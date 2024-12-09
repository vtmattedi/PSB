; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1
; remember to be in the same directory as the file
section .data
    prompt db "Type in a string [max-size: 255]: ",10, 0
    input_fmt db "%255s", 0
    output_fmt db 9, " Input: %s", 10, 9, "Output: %s", 10, 0
    debug_fmt db "%u", 10, 0
section .bss
    vector_in resb 256  ; Holds input
    vector_out resb 256 ; Holds output
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
    lea rdi, [debug_fmt];
    mov rsi, [vector_in];
    call printf
    ;load string input;
    lea rsi, [vector_in]
    lea rdi, [vector_out]
    
_loop:
    lodsb ; Load byte at RSI into AL and increment RSI
    ; check for lower case 
    cmp al, 0x61; 'a'
    jl _continue
    cmp al, 0x7A; 'z'
    jg _continue
    sub al, 0x20; lower - 0x20 = upper
    jmp _end_loop;
_continue:
;handle accent (extended ASCII)
;https://www.ascii-code.com/
; well should work but it is not on the debug
; á is printing as 41411 which makes no sense
; do not know if it is a WSL thing
; as the professor said we do not need to implement
; I will not

;check for non ordinary cases:
    cmp al, 0x9E; ž
    jne _continue2
    sub al, 0x10; ž - 0x10 = Ž
    jmp _end_loop

_continue2:
    cmp al, 0xFF; y umlaut
    jne _continue3
    mov al, 0x9F; Y
    jmp _end_loop
_continue3:
    cmp al, 0xF7; ÷
    je _end_loop
;general case:
    cmp al, 0xE0; à 
    jl _end_loop
    cmp al, 0xFD; æ
    jg _end_loop
    sub al, 0x20;

_end_loop:
    stosb ; Store AL at RDI and increment RDI
    cmp al, 0 ; Check if AL is `\0`
    jnz _loop ; Repeat until zero byte is found i.e. null terminator.

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
