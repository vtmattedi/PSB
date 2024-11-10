;#Im using # because replit only makes a comment after a # (visually)
;# This was made for x86-64bits and need to compile using gcc for scanf. printf
;# compile and run: nasm -f elf64 ex3.asm && gcc -o ex3 ex3.o -no-pie -z execstack -lm && ./ex3
section .data
    ;#Change %d to %l and dd to dq, and vector step to 8 bytes to use 64bit
    prompt db "[%d] type a number (signed 32bit int): ", 0
    preprompt db "Input 10 integers to be stored on a Vector.", 10,0
    fmt_input db "%d", 0
    vector dd 10 dup(0)  ;# int[10] = {0}
    input_buff dd 0      ;# input buffer
    result db 10, "Vector at %08x: ", 10, 0    
    fmt_vect db "pos: %2d val: %11d addr: 0x%08X", 10, 0 ;#11 is the max size of a str representation of a int, 8 * 8 = 64 bit

section .text
    global main
    extern printf
    extern scanf

main:
    push rbp
    mov rbp, rsp
    lea rdi, [preprompt]    ;#
    call printf
    mov rbx, vector ;#start pointer
    mov r15, 10

read_loop:
    lea rdi, [prompt]    ; load address of prompt string
    mov rsi, 10
    sub rsi, r15
    call printf          
    lea rdi, [fmt_input] ; load address of input format string
    lea rsi, [input_buff] ; load address of input buffer
    call scanf          

    mov rax, [input_buff] ;# move input buffer value to rax
    mov [rbx], rax        ;# store the value in the vector
    add rbx, 4            ;# 4 bytes = 1 dd

    dec r15               ;# decrease loop counter
    cmp r15, 0            ;# compare loop counter with 0
    jne read_loop         ; #if not zero, jump to end of read loop

    mov rsi, vector       ;# rsi points to the start of the vector
    lea rdi, [result]     ;# load address of result string
    call printf           ;# print the result prompt

    mov r15, 0           ; #loop counter for printing
    mov rbx, vector
print_loop:
    mov rsi, rbx
    ; Prepare arguments for printf
    lea rdi, [fmt_vect]          ;# Load address of vector format string
    mov rcx, rsi                 ;# Move address of current position to rdx (rsi already points here)
    mov rdx, [rsi]                 ;# Move the current position (r15) to rax
    mov rsi, r15              ; #Move current vector value to rsi

    ;# Print the vector position, value, and address
    call printf

    add rbx, 4                   ;# Move to the next position in the vector (8 bytes for dq)

    inc r15                       ; #Increment loop counter
    cmp r15, 10                   ; #Compare loop counter with 10
    jne print_loop                ; #If not equal to 10, jump to print_loop

_exit: 
    pop rbp      ;#resolve segfault problems
    mov eax, 60  ;# x64 syscall to exit
    xor edi, edi ;# exit code = 0
    syscall
