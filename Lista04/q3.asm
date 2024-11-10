;#Im using # because replit only makes a comment after a # (visually)
;# This was made for x86-64bits and need to compile using gcc for scanf. printf
;# compile and run: nasm -f elf64 q3.asm && gcc -o q3 q3.o -no-pie -z execstack -lm && ./q3

section .data
    prompt db "Type a positive Integer: ", 0
    fmt db "%d",0
    prime db "%d is prime! [Next candidate square would be: %d]", 10, 0
    not_prime db "%d is not Prime! first divisor = %d.", 10, 0
    debug db "%d - > %d:%d",10,0
    n dq 0 
    m dq 0 

section .text
    global main
    extern printf, scanf

main:
    ;#align stack
    push rbp
    mov rbp, rsp

    ;#gets input
    lea rdi, [prompt]
    call printf
    lea rdi, [fmt]
    lea rsi, [n]
    lea rdx, [m]
    call scanf
    lea rdi, [prompt]
    lea rsi, [n]
    lea rdx, [m]
    
    call printf


    movsxd rax, [n]
    cmp rax, 2
    mov rcx, 1
    ;#Check for < 2 (0,1 negatives)
    jl _not_prime
    ;# Check for 2
    mov rcx, 2
    je _prime
    
;#check even number
    movsxd rax, [n] ;#32bit val into 64bit reg
    mov rdx, 0
    mov rcx, 2
    div rcx 
    cmp rdx, 0   
    je _not_prime

    ;# check for all odd number between 3...sqr(n)
    ;# final length = 2 + sqr(n)/2 => O(sqr(n)/2)
    mov rcx, 3
_check:
    mov rax, [n]          ;#load n
    ;mov rdx, 0            ; # zero old result, and 64bit of the 
    mov rdx, 0            ; # zero old result, and 64bit of the 
    div rcx               ;# rax = rax / rcx,  rdx = rax%rcx
    cmp rdx, 0            ;# rax%rcx == 0 => n is not prime (divisor found)
    mov rdx, rcx
    je _not_prime        

    add rcx, 2               ; #rcx += 2, skip even numbers
    mov rbx, rcx             ;# compare next number with n
    imul rbx, rbx                 ;# square(next number)
    movsxd rax, [n]          ;#load n
 
    cmp rbx, rax
    jg _prime            ;# if square(rcx) > rax, rax is prime (nodivisior)
    jmp  _check

_prime:
    mov rax, [n]
    mov rsi, rax
    lea rdi, [prime]
    mov rdx, rbx
    call printf
    jmp _exit

_not_prime:
    mov rax, [n]
    mov rsi, rax
    lea rdi, [not_prime]
    mov rdx, rcx
    call printf
     jmp _exit

_exit:
    pop rbp
    mov rax, 60         
    xor rdi, rdi        
    syscall
