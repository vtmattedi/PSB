;# Im using # because replit only makes a comment after a # (visually)
;# This was made for x86-64bits and need to compile using gcc for scanf. printf
;# compile and run: nasm -f elf64 ex5.asm && gcc -o ex5 ex5.o -no-pie -z execstack -lm && ./ex5

section .data
        stepfmt db "RAX: %2d ",10,0
        current_step db "[Step:%d] ", 0
        addMemFmt db "Adding %d from 0x%08X",10,0
        mem db 20
section .text
    global main
    extern printf

main:
push rbp
mov rbp, rsp
    ;#load start values
    mov rax, 50
    mov r15, 0
    call _printStep

    ;#AX += [mem] should be 70
    call _printAddMem
    add rax, [mem]
    call _printStep
    ;#AX -= 5 shoulbe be 65
    sub rax, 5
    call _printStep
    call _exit

_printStep:
     ;# same as in the begining of main, needed to align stack.
    push rbp  
    mov rbp, rsp

    ;#store current data
    mov r12, rax

    lea rdi, [current_step]
    mov rsi, r15
    call printf
    inc r15 ;# step++
    ;#print second part
    lea rdi, [stepfmt]
    mov rsi, r12
    ;#mov rcx, rcx ;->obviously not needed
    call printf

    ;#restore RAX
    mov rax, r12

    pop rbp
    ret

_printAddMem:
    ;# print first part
    push rbp
    mov rbp, rsp

    ;#store current data
    mov r12, rax

    lea rdi, [addMemFmt]
    mov rsi, [mem]
    mov rdx, mem
    call printf

    ;#restore RAX
    mov rax, r12

    pop rbp
    ret


_exit: 
    pop rbp      ;#resolve segfault problems
    mov eax, 60  ;# x64 syscall to exit
    xor edi, edi ;# exit code = 0
    syscall
