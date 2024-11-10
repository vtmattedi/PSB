; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1
; remember to be in the same directory as the file
section .data
    prompt db "Type two numbers [uint16] [0,65535] (quotient, dividend) separeted by space: ",10, 0
    ; Not following the input will result in UB
    ; The most likely scenario is that the lower 16 bits will be the input (even 64 bit input)
    ; however I have not tested it thoroughly. max n tested = 4779665335670358016 (0x4254C84C8DE14000)
    ; and it works as 0x4000 which is described above
    fmt_input db "%d %d", 0
    fmt_output db "DX: 0x%X, AX: 0x%X", 10, 0
    fm_32 db "Result (32bit): %d [0x%X]", 10, 0
    num1 dw 0 ; 16 bits
    num2 dw 0 ; 16 bits
    carry db "carry %x", 10, 0
    noCarry db "no carry %x", 10, 0

section .text
    extern printf, scanf
    global main

main:
    mov rbp, rsp
    push rbp
    ; Read two numbers
    lea rdi, [prompt]
    call printf
    lea rdi, [fmt_input]
    lea rsi, [num1]
    lea rdx, [num2]
    call scanf

     movsxd rax, [num1]
     movsxd rbx, [num2]

    ; Perform multiplication
    mul  bx  ; DX:AX = AX * BX -> that is not working; it is saving at the 32bit register
    ; Comment this to see the raw RAX    
    and rax, 0xFFFF ; Rax will be  signbit->0xn (n= num of bits of the num in DX)-> AX (lower 16 bits of the result)

    ; Print DX, AX,
    lea  rdi, [fmt_output]
    mov  rsi, rdx
    mov  rdx, rax
    call printf

    ; Print DX, AX,
    ; lea rdi, [fmt_output]
    ; movsx rsi, dx
    ; movsx rdx, ax
    ; call printf

    
    ;  Load numbers again into AX and DX cuz we called printf
     movsx rax, word [num1]
     movsx rbx, word [num2]

    ; Perform multiplication
    mul  bx  ; DX:AX = AX * BX -> that is not working; it is saving at the 32bit register
    
    mov ebx, 0 ;  zero out EbX
    mov rcx, 16; 16 bits
_loopDx:
    ;mov rdx, r15
     push rcx ; save rcx
    shl ebx, 1 ; shifts EbX to the left -> 0 on LSB
    shl dx, 1 ; shifts Dx to the left
    jnc _noCarryDx; if there was no carry, continue
    ; if there was a carry, set the LSB of EbX to 1
    inc ebx ; sets the LSB of EbX to 1
    ;mov r15, rdx
    jmp _jumpDx
_noCarryDx:
_jumpDx:
    ;pop rcx ; restore rcx
    loop _loopDx

    mov rcx, 16; 16 bits
_loopAx:
    ;push rcx ; save rcx
    shl ebx, 1 ; shifts EbX to the left -> 0 on LSB
    shl ax, 1 ; shifts Ax to the left
    jnc _noCarryAx; if there was no carry, continue
    ; if there was a carry, set the LSB of EbX to 1
    inc ebx ; sets the LSB of EbX to 1
    jmp _jumpAx
_noCarryAx:
_jumpAx:
    ;pop rcx ; restore rcx
    loop _loopAx

    ; at this point ebx should contain dx:ax

    movsxd r15, ebx  ; zero extend input to 64 bits and sotres it  in r15 for now (prevent interactions from scanf)


    lea rdi, [fm_32]
    movsxd rsi, ebx
    movsxd rdx, ebx
    call printf

    ; Exit program
    pop rbp
    mov rax, 1
    xor rbx, rbx
    int 0x80