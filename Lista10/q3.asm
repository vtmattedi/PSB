; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q3.asm && gcc -o q3 q3.o -no-pie -z execstack -lm && ./q3
; remember to be in the same directory as the file
section .data
    prompt db "Type in a string: ", 0
    input_fmt db "%s", 0
    output_fmt db 9, " Input: %s", 10, 0
    output_fmt_2 db  9, "Output: %s", 10, 0
section .bss
    vector_in resb 256  ; Holds input
    vector_out resb 256  ; Holds output
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
    

    lea rsi, [vector_in]
    lea rdi, [vector_out]
    call _revese_str
    
_exit:
    ;#print res
    lea rdi, [output_fmt]
    mov rsi, vector_in
    call printf
    lea rdi, [output_fmt_2]
    lea rsi, [vector_out]
    call printf
  
    pop rbp
    mov rax, 60         
    xor rdi, rdi        
    syscall

_revese_str:
    ; stack align
    ; rdi = reverse_str(rsi), length = rcx
    push rbp
    mov rbp, rsp
    mov rcx, 0
    call _str_len
_reveserse_loop:
    cmp rcx, 0
    je _reverse_str_done
    mov rax, 0
    mov al, [rsi]
    mov [rdi + rcx - 1], al
    dec rcx
    inc rsi
    jmp _reveserse_loop
_reverse_str_done:
    pop rbp
    ret

_str_len:
    ; stack align
    ; rcx = str_len(rsi)
    push rbp
    mov rbp, rsp
    mov rcx, 0
_str_loop:
    mov rax, 0
    mov al, [rsi + rcx]
    cmp al, 0
    je _str_len_done
    inc rcx
    jmp _str_loop

_str_len_done:
    pop rbp
    ret