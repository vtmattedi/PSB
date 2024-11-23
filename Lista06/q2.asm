; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q2.asm && gcc -o q2 q2.o -no-pie -z execstack -lm && ./q2
; remember to be in the same directory as the file
section .data
   vector dq 5,4,3,2,1 ; int64 [5,4,3,2,1]
   size dq 5 ;size of vect
    output_fmt db "(this idiotic machine does not print using printf without a newline (10) at the end of the string so this will not look nice)",10,"final vector: ",10,0
    fmt db  "%d ", 10,0

section .text
    extern printf, scanf
    global main

main:
    ; # stack align
    push rbp
    mov rbp, rsp

    mov rcx, [size] ; rcx = size
    dec rcx         ; rcx = size - 1
    mov rdi, rcx    ; rdi = size - 1

_outer_loop:
    mov rsi, 0      ; rsi = 0

_inner_loop:
    mov rax, [vector + rsi * 8]
    mov rbx, [vector + rsi * 8 + 8]
    cmp rax, rbx
    jle _no_swap

    ; Swap elements
    mov [vector + rsi * 8], rbx
    mov [vector + rsi * 8 + 8], rax

_no_swap:
    inc rsi
    cmp rsi, rdi
    jl _inner_loop

    dec rdi
    jnz _outer_loop

    lea rdi, [output_fmt]
    call printf
    mov r15, 0
_loop1:
    lea rdi, [fmt]
    mov rsi, [vector + r15 * 8 ]
    call printf
    inc r15
    cmp r15, 5
    jne _loop1

_exit:

    pop rbp
    mov rax, 60         
    xor rdi, rdi        
    syscall

