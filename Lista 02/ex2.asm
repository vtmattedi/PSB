;#Im using # because replit only makes a comment after a # (visually)
;# This was made for x86-64bits and need to compile using gcc for scanf. printf
;# compile and run: nasm -f elf64 ex2.asm && gcc -o ex2 ex2.o -no-pie -z execstack -lm && ./ex2
section .data
    prompt db "input 3 integers separeted by spaces (any signed 32-bit int i.e. -10, 10000, 4000): ",0;#prompt
    fmt_input db "%d %d %d", 0  ;# Format for scanf
    fmt_output db "%c) Storing in R14: %d", 10, 0  ;# Format for printf
    X dd 0 ;#32 bit int
    Y dd 0
    Z dd 0

section .text
    global main

extern scanf ;# RSI, rdx, rcx
extern printf ;# RSI, rdx, rcx

main:

;# realign stack
;# https://stackoverflow.com/questions/38335212/calling-printf-in-x86-64-using-gnu-assembler
;#not using these lines will result ina  segfault
push rbp
mov rbp, rsp

    ;#print prompt
    lea rdi, [prompt]
    call printf
    ;# Get  X, Y, Z
    lea rdi, [fmt_input]   ;# input fmt
    lea rsi, [X]           ;# First arg
    lea rdx, [Y]           ;# Second arg
    lea rcx, [Z]           ;# Third arg
    call scanf             

    mov r15d, 0x61;# a

    ;# a) R = X - (-Y + Z)
    mov rax, [X]           ;# AX = X
    mov rbx, [Y]           ;# BX = Y
    mov rcx, [Z]           ;# CX = Z
    neg rbx                ;# -y
    add rbx, rcx            ;# (-y+z)
    sub rax, rbx            ;#x - (-y + z)
    mov r14, rax         ;#R14 = result
    ;# Print result 
    lea rdi, [fmt_output]  ;# Load format string for printf
    mov rsi, r15           ;# question letter, first arg
    mov rdx, r14          ;# second arg, result
    call printf            

    ;# b  R = X - (-(Y + X)) -> 2x + y
    mov rax, [X]           ;# AX = X
    mov rbx, [Y]           ;# BX = Y
    add rbx, rax             ;# x + y
    ;#neg bx                 ; # -(x+y)
    ;#sub ax, bx             ; # x - -(x+y)
    add rax, rbx             ;# more efficient
    mov r14, rax         ;#R14 = result

    lea rdi, [fmt_output]  ;# Load format string for printf
    inc  r15 ;# next letter
    mov rsi, r15 ;# question letter, first arg
    mov rdx, r14            ;# second arg, result
    call printf            ; Call printf

    ;# c) R = X + Y + (Y - Z)
    mov rax, [X]           ;# AX = X
    mov rbx, [Y]           ;# BX = Y
    mov rcx, [Z]           ;# CX = Z
    add rax, rbx           ; #x + y
    sub rbx, rcx            ;# rbx = Y - Z
    add rax, rbx            ; # x + y + (y-z)
    mov r14, rax         ;#R14 = result
    ;# Print result for c
    lea rdi, [fmt_output]  ;# Load format string for printf

    inc  r15 ;# next letter
    mov rsi, r15 ;# question letter, first arg
    mov rdx, r14            ;# second arg, result
    call printf           

_exit: 
    pop rbp      ;#resolve segfault problems
    mov eax, 60  ;# x64 syscall to exit
    xor edi, edi ;# exit code = 0
    syscall
