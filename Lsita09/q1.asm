; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1
; remember to be in the same directory as the file
section .data
    prompt db "Type in a string aka a byte vector of size 5: ",10, 0
    input_fmt db "%05s", 0
    output_fmt db 9, " Input: %s", 10, 0
    output_fmt_2 db  9, "Output: %s", 10, 0
    debug_fmt db "%u", 10, 0
section .bss
    vector_in resb 256  ; Holds input
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
    lea rsi, [vector_in]
    call scanf
    lea rdi, [output_fmt]
    mov rsi, vector_in
    call printf
    lea rsi, [vector_in]
    lea rdi, [vector_in + 4]
_loop:
    mov rax, 0
    mov byte al, [rsi]
    push rax
    mov rbx, 0
    mov byte bl, [rdi]
    push rbx
    pop rax
    cmp rax, 0
    je _iszero
    mov byte [rsi], al
    jmp _cont
    _iszero:
    mov byte [rsi], " "
    _cont:
    pop rbx 
    mov byte [rdi], bl
    inc rsi
    dec rdi
    cmp rsi, rdi
    jl _loop
    
_exit:
    ;#print res
    lea rdi, [output_fmt_2]
    lea rsi, [vector_in]
    mov rdx, rax
    call printf
  
    pop rbp
    mov rax, 60         
    xor rdi, rdi        
    syscall
