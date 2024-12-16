; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q2.asm && gcc -o q2 q2.o -no-pie -z execstack -lm && ./q2
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
    
    mov rax, [num]  

    cmp rax, 0
    jne _cont
    mov rax, 1
    jmp _exit
_cont:
    ; Push all numbers from 1 to n onto the stack
    mov rcx, 1        ; start from 1
_push_loop:
    cmp rcx, rax      
    jg _push_done     
    push rcx          
    inc rcx           
    jmp _push_loop    

_push_done:
    ; Now pop all numbers from the stack and multiply them
    mov rax, 1        
_pop_loop:
    cmp rsp, rbp      ; check if we've popped all numbers (rsp == rbp)
    je _exit
    pop rcx           ; pop the top of the stack into rcx
    mul rcx           ; rax = rax * rcx (multiply the current result with rcx)
    jmp _pop_loop    


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
