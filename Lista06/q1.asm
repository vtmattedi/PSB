; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1
; remember to be in the same directory as the file
section .data
    prompt db "Type in a vector of bytes a.k.a a string [max-size: 255]: ",10, 0
    input_fmt db "%s", 0
    output_fmt db 9, "Input: %s", 10, 9, "Output: %s", 10, 0
section .bss
    vector_in resb 256  ; Holds input
    vector_out resb 256 ; Holds output
section .text
    extern printf, scanf
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

    ;# str_len
    mov rdi, vector_in
    call string_length
    mov rcx, rax         ;# RCX = str_len(input)

    ; Inverte a string
    lea rdi, [vector_out] ; # last index of Input
_reverse: ;# o(n/2)
    lea rsi, [vector_in + rcx - 1]     ; # Input Pointer
    mov byte al, [rsi]
    mov byte [rdi], al
    inc rdi
    dec rcx
    cmp rcx, 0
    jnz _reverse
    mov byte [rdi], 0 ; Terminate the string at the output

_exit:
    ;#print res
    lea rdi, [output_fmt]
    lea rsi, [vector_in]
    lea rdx, [vector_out]
    call printf

    pop rbp
    mov rax, 60         
    xor rdi, rdi        
    syscall

;#str_len, expects char* start on RDI, returns on rax 
string_length:
    mov rax, 0
_str_len_loop:
    cmp byte [rdi + rax], 0
    je _str_len_end
    inc rax
    jmp _str_len_loop
_str_len_end:
    ret

