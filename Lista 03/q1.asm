;#Im using # because replit only makes a comment after a # (visually)
;# This was made for x86-64bits and need to compile using gcc for scanf. printf
;# compile and run: nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1
section .data
    prompt db "input 3 integers separeted by spaces (any signed 32-bit int i.e. -10, 10000, 4000): ",0;#prompt
    fmt_input db "%d %d %d", 0  ;# Format for scanf
    fmt_output1 db 9, "%c) Storing ",0
    fmt_output2 db " in R14(Quo): %d;  R15(Rem): %d.", 10, 0  ;# Format for printf
    yoda db "Wrong you are, divide by 0 you may not.",10,0
    X dd 0 ;#32 bit int
    Y dd 0
    Z dd 0
    fmt_eq1 db "([%d] * 5) / ([%d] - 3)", 0
    fmt_eq2 db "([%d] * -5) / (-[%d] % [%d])", 0
section .text
    global main

extern scanf ;# RSI, rdx, rcx
extern printf ;# RSI, rdx, rcx

main:
;# realign stack
;#not using these lines will result in a  segfault
push rbp
mov rbp, rsp

    ;#print prompt
    lea rdi, [prompt]
    call printf
    ;# Get  X1, Y (X2), Z (X3)
    lea rdi, [fmt_input]   ;# input fmt
    lea rsi, [X]           ;# First arg
    lea rdx, [Y]           ;# Second arg
    lea rcx, [Z]           ;# Third arg
    call scanf

    ;# no div by 0
    movsxd  rax, DWORD [Y]  ;# AX = X
    sub rax, 3
    test rax, rax
    jz _bad

    mov r13d, 0x61;# a

    ;# a)  R = (X1 * 5) / (X2 - 3)
    ;# NEED to be movsxd since we are loading a int into a 64bit reg
    movsxd  rax, DWORD [X]  ;# AX = X
    imul rax, 5             ;# X * 5
    movsxd  rbx, DWORD [Y]  ;# BX = Y
    sub rbx, 3              ;# Y - 3
    cqo                      ;# extends rax We are using 64bit register and 32 bit int so it NEEDS to be CQO isntead of the CDQ, using CDQ will lead to float point exceptions
    idiv rbx                ;# rax/rbx
    mov r14, rax            ;#R14 = quotient
    call _abs_rdx        ;# rem = abs(rem)
    mov r15, rdx            ;#R15 = reminder
    call _printRes          ;#Print result
    
    ;# b)  R = (X1 * -5) / (-X2 % X3)
    inc r13              ;# question letter
    
    movsxd rax, DWORD [Y]         ;# BX = Y
    neg rax                       ;# -Y
    movsxd rbx, DWORD [Z]         ;# CX = Z
    test rbx, rbx           ;# Z cant be 0
    jz _bad               
    cqo                  ;#cqo not cdq
    idiv rbx             ;# -Y / Z
    mov rbx, rdx         ;# RDX = -y%z
    test rbx, rbx           ;# -y%z cant be 0
    jz _bad             

    movsxd rax, DWORD [X];# RAX = X
    imul rax, -5         ;# RAX = X * -5
    cqo                  ;#cqo not cdq
    idiv rbx             ;# (X * -5) / (-Y % Z)
  
    mov r14, rax         ;#R14 = quotient
    call _abs_rdx        ;# rem = abs(rem)
    mov r15, rdx         ;#R15 = reminder
    call _printRes
    call _exit

_printRes:
    ;# Print result 
    push rbp
    mov rbp, rsp
    lea rdi, [fmt_output1]   ;# Load format string for printf
    mov rsi, r13            ;# question letter, First arg
    call printf
    cmp r13, 0x61 ;# quest a
    jne _quest_b
    ;#question A
    lea rdi, [fmt_eq1]       ;# Load format string for printf
    mov rsi, [X]            ;# question letter, First arg
    mov rdx, [Y]            ;# Second arg, Quotient
    mov rcx, [Z]            ;# Third arg, Dividend
    call printf  
    jmp _print_end    
_quest_b:
   ;#question B
    lea rdi, [fmt_eq2]   ;# Load format string for printf
    mov rsi, [X]            ;# question letter, First arg
    mov rdx, [Y]            ;# Second arg, Quotient
    mov rcx, [Z]            ;# Third arg, Dividend
    call printf  
_print_end:    
    lea rdi, [fmt_output2]   ;# Load format string for printf
    mov rsi, r14            ;# Second arg, Quotient
    mov rdx, r15            ;# Third arg, Dividend
    call printf            
    pop rbp
    ret

_abs_rdx:
    push rbp
    mov rbp, rsp
    cmp rdx, 0
    jge _end_abs
    imul rdx, -1
    _end_abs:      
    pop rbp
    ret

_bad:
    lea rdi, [yoda]
    call printf

_exit: 
    pop rbp      ;#resolve segfault problems
    mov eax, 60  ;# x64 syscall to exit
    xor edi, edi ;# exit code = 0
    syscall
