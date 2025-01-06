; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1
; remember to be in the same directory as the file
section .data
    prompt db "Type in an int32 : ", 0
    input_fmt db "%d", 0
    output_fmt db 9, " Input: %d %d, result = %d", 10, 0
section .bss
    num_a resd 1  ; Holds input a
    num_b resd 1  ; Holds input b
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
    and rsp, -16

    ;#get input
    lea rdi, [prompt]
    call printf
    lea rdi, [input_fmt]
    lea rsi, [num_a]
    call scanf
    lea rdi, [prompt]
    call printf
    lea rdi, [input_fmt]
    lea rsi, [num_b]
    call scanf

    mov rax, [num_a]
    mov rbx, [num_b]
    call _sum
    ;call _exit    
_exit:
    ;#print res
    lea rdi, [output_fmt]
    mov rsi, [num_a]
    mov rdx, [num_b]
    mov rcx, rax
    call printf
  
    pop rbp
    mov rax, 60         
    xor rdi, rdi        
    syscall

_sum:
; will try not to mess with the stack unless I have to.
    ; rax = rax + rbx
    
    push rbp
    mov rbp, rsp
    ; Well I had to
    ;not rly problem was elsewhere
    add rax, rbx

    pop rbp
    ret