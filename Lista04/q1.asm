;#Im using # because replit only makes a comment after a # (visually)
;# This was made for x86-64bits and need to compile using gcc for scanf. printf
;# compile and run: nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1
section .data
   prompt db "Type two numbers (Rax, Rbx) separeted by space: ",10, 0
   fmt db "%d %d"
   result db "Final RAX = %d.", 10 ,0
   debug db "%d %d",10,0
   a dd 1 
   b dd 1
section .text
    global main

extern scanf ;# RSI, rdx, rcx
extern printf ;# RSI, rdx, rcx

main:
;realign stack
;not using these lines will result in a  segfault
push rbp
mov rbp, rsp

;#gets input
    lea rdi, [prompt]
    call printf
    lea rdi, [fmt]
    lea rsi, [a]
    lea rdx, [b]
    call scanf

 
    ;#if(eax >= ebx):
;#eax = 1
;#else if(eax == 0):
;#eax = -1
    movsxd rax, [a]
    movsxd rbx, [b]

    cmp rax, rbx ; 
    jge _ge ;# if (eax >= ebx)
    test rax, rax ; 
    jz _eax_0     ;#else if(eax == 0)
    jmp _exit     ;# else

_ge: 
    mov rax, 1
    jmp _exit
_eax_0:
    mov rax, -1
    jmp _exit

_exit: 

    lea rdi, [result]
    mov rsi, rax
    call printf
    pop rbp      ;#resolve segfault problems
    mov eax, 60  ;# x64 syscall to exit
    xor edi, edi ;# exit code = 0
    syscall
