;# Im using # because replit only makes a comment after a # (visually)
;# This was made for x86-64bits and need to compile using gcc for scanf. printf
;# compile and run: nasm -f elf64 ex4.asm && gcc -o ex4 ex4.o -no-pie -z execstack -lm && ./ex4

section .data
        stepfmt db "RAX: %2d, RBX: %2d, RCX: %2d",10,0
        current_step db "[Step:%d] ", 0
section .text
    global main
    extern printf

main:
push rbp
mov rbp, rsp
    ;#load start values
    mov rax, 10
    mov rbx, 20
    mov rcx, 30
    mov r15, 0
    call _printStep
    
    ;#AX + BX should be 30
    add rax, rbx
    call _printStep
    ;# AX + CX should be 60
    add rax, rcx
    call _printStep
    call _exit

_printStep:
    ;# same as in the begining of main, needed to align stack.
    push rbp  
    mov rbp, rsp

    ;# print first part
    ;#store current data
    mov r12, rax
    mov r13, rbx
    mov r14, rcx
    
    lea rdi, [current_step]
    mov rsi, r15
    call printf
    inc r15 ;# step++
    ;#print second part
    lea rdi, [stepfmt]
    mov rsi, r12
    mov rdx, r13
    mov rcx, r14
    ;#mov rcx, rcx ;->obviously not needed
    call printf

    ;#restore data
    mov rax, r12
    mov rbx, r13
    mov rcx, r14
    
    pop rbp
    ret

_exit: 
    pop rbp      ;#resolve segfault problems
    mov eax, 60  ;# x64 syscall to exit
    xor edi, edi ;# exit code = 0
    syscall
