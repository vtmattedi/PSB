; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1
; remember to be in the same directory as the file
section .data
    prompt db "Type in an unsigned int : ",10, 0
    input_fmt db "%u", 0
    output_fmt db 9, " %u! =  %lu", 10, 0
section .bss
    num resd 1  ; Holds input
section .text
    extern printf, scanf;
    ;Limited to c's scanf.
    ;Therefore there is no null terminator in the input string
    ;And spaces, tabs, and newlines are considered as delimiters.
    global main

main:
    ; # stack align
    push rbp
    mov rbp, rsp

    ;#get input
    lea rdi, [prompt]
    call printf
    lea rdi, [input_fmt]
    lea rsi, [num]
    call scanf
    lea rbx, [num]
_loop:
    inc rcx
    push rcx
    cmp rcx, rbx
    jl _loop
    mov rax, 1 
_loop2: 
    pop rcx
    mul rcx
    cmp rcx, 0
    jg _loop2
_exit:
    ;#print res
    lea rdi, [output_fmt]
    mov rsi, [num]
    mov rdx, rax
    call printf
    pop rbp
    mov rax, 60         
    xor rdi, rdi        
    syscall
