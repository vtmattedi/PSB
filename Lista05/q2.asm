; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q2.asm && gcc -o q2 q2.o -no-pie -z execstack -lm && ./q2
; remember to be in the same directory as the file
section .data
    output db "Minutes: %d", 10, 0
    fmt db "%d"
    prompt db "Inital value of RBX (Int32): ",0
    input dd 0
section .bss
    valMin resw 1

section .text
    global main
extern printf
extern scanf
main:
    ; https://www.rapidtables.com/convert/number/binary-to-decimal.html
    ; For easy bin-dec
    ; Btw Crappy timestamp strategy, 5 bits for seconds just does not work
    ; and it only represents a time from 0 seconds to <32 hours
    ; but skips the 32 to 59 seconds range ???????????
    ; no reason to have seconds if its not going to range from 0 to 59
    ; a better strategy would be to count the number of minutes since a fixed point,
    ; akin to the unix timestamp, this would result in 2.730 days of range ~ 7 years
    ; that is limeted but well, everything is limited with a single 16 bit variable constraint
    mov rbp, rsp
    push rbp
    lea rdi, [prompt]
    mov rsi, [valMin]
    call printf
    lea rdi, [fmt]
    lea rsi, [input]
    call scanf
    movsxd rbx, [input] ; zero extend input to 64 bits  
    ; Assume BX contains the timestamp
    ; Example: BX = 0bHHHHHMMMMMMSSSSS

    ; Mask to extract the minutes (bits 5 to 10)
    mov cx, 0b0000011111100000
    and bx, cx

    ; Shift right to align the minutes to the least significant bits
    shr bx, 5

    ; Store the result in ValMinutos
    mov [valMin], bx

    lea rdi, [output]
    mov rsi, [valMin]
    call printf
    ; Exit 
    pop rbp
    mov eax, 60         
    xor edi, edi        
    syscall