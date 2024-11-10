

;#Im using # because replit only makes a comment after a # (visually)
;# This was made for x86-64bits and need to compile using gcc for scanf. printf
;# compile and run: nasm -f elf64 q2.asm && gcc -o q2 q2.o -no-pie -z execstack -lm && ./q2

; To simplify, this code was not made  to ge inputs nor prints outputs
section .data


section .text
    global main

extern scanf ;# RSI, rdx, rcx
extern printf ;# RSI, rdx, rcx

main:
;# realign stack
;#not using these lines will result in a  segfault
push rbp
mov rbp, rsp

;#do:
;#eax = eax + 1
;#if (eax == ecx):
;#edx = 10
;#else:
;#edx = 20
;#while (eax < ebx)
_loop:
    cmp rax, rbx    ;# while( eax < ebx)
    jg _exit
    inc rax         ;#eax++
    cmp rax, rcx    ; 
    je _equal       ;# if(eax == 0)
                    ;#else
    mov edx, 20     ; # edx = 20
    jmp _loop       ;# continue
_equal: 
    mov edx, 10     ;#edx = 10
    jmp _loop       ;#continue
_exit: 
    pop rbp      ;#resolve segfault problems
    mov eax, 60  ;# x64 syscall to exit
    xor edi, edi ;# exit code = 0
    syscall

