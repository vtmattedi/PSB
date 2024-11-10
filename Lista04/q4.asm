;#Im using # because replit only makes a comment after a # (visually)
;# This was made for x86-64bits and need to compile using gcc for scanf. printf
;# compile and run: nasm -f elf64 q4.asm && gcc -o q4 q4.o -no-pie -z execstack -lm && ./q4

section .data
    prompt db "Type a string: ", 0
    fmt db "%s", 0
    result db "Inverted: %s", 10, 0
section    .bss
    buffer resb 100  ;# Buffer para armazenar a string

section .text
    global main
    extern printf, scanf

main:
    ; # stack align
    push rbp
    mov rbp, rsp

    ;#get input
    lea rdi, [prompt]
    call printf
    lea rdi, [fmt]
    lea rsi, [buffer]
    call scanf

    ;# str_len
    mov rdi, buffer
    call string_length
    mov rcx, rax         ;# RCX = str_len(input)

    ; Inverte a string
    lea rsi, [buffer]     ; # Input Pointer
    lea rdi, [buffer + rcx - 1] ; # last index of Input
_reverse: ;# o(n/2)
    cmp rsi, rdi          ; #if they cross we are done
    jge _exit          
    mov al, [rsi]         ; #swap char
    xchg al, [rdi]
    mov [rsi], al
    inc rsi               ; #increase begin pointer
    dec rdi               ; #decrease end pointer
    jmp _reverse          ; #keeps loop

_exit:
    ;#print res
    lea rdi, [result]
    lea rsi, [buffer]
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
