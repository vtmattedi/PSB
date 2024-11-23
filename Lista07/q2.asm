; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1
; remember to be in the same directory as the file
section .data
    prompt db "Type in an int64 for cell [Matrix %c] [%d], [%d] @0x%08x: ", 0 ;debug address
    ;prompt db "Type in an int64 for cell  [Matrix %c] [%d], [%d]: ", 0
    input_fmt db "%d", 0
    debug db "rsp: %08d, rbp: %08d", 10, 0
    matrix_name db "[Matrix %c]", 10, 0
    matrix_fmt db 9, "%8d %8d %8d", 10, 9, "%8d %8d %8d", 10, 9, "%8d %8d %8d", 10, 0
    ;
    output_fmt db 9, "Diagonal Sum: %d ", 10, 0
    ;output_fmt db 9, "Diagonal Sum: %d  [%d][%d]", 10, 0 ;Debug
section .bss
    matrixA resq 9 ; 3x3 matrix
    matrixB resq 9 ; 3x3 matrix
    matrixC resq 9 ; 3x3 matrix
    diag resq 1 ; diagonal sum
section .text
    extern printf, scanf
    global main

main:
    ; # stack align
    push rbp
    mov rbp, rsp

    ;#get input
    mov r15, 0
    mov r14, 65 ; A

_inputloopA:
    mov rax, r15 ; calc current row/col
    cqo          ; sign extend rax to rdx:rax
    mov rbx , 3  ; 3 columns
    div rbx      ; rdx = rax % rbx
    lea rdi, [prompt]
    mov rsi, r14
    mov rdx, r15
    mov rcx, rdx
    lea r8, [matrixA + r15 * 8] ; Address of current cell for debug
    call printf
    lea rdi, [input_fmt]
    lea rsi, [matrixA + r15 * 8]
    xor rax, rax
    xor rdx, rdx
    call scanf
    inc r15
    cmp r15, 9
    jne _inputloopA


    mov r15, 0
    mov r14, 66 ; B

_inputloopB:
    mov rax, r15 ; calc current row/col
    cqo          ; sign extend rax to rdx:rax
    mov rbx , 3  ; 3 columns
    div rbx      ; rdx = rax % rbx
    lea rdi, [prompt]
    mov rsi, r14
    mov rdx, rax
    mov rcx, rdx
    lea r8, [matrixB + r15 * 8] ; Address of current cell for debug
    call printf
    lea rdi, [input_fmt]
    lea rsi, [matrixB + r15 * 8]
    xor rax, rax
    xor rdx, rdx
    call scanf
    inc r15
    cmp r15, 9
    jne _inputloopB

    mov r15, 0
_calcMatrixC: ; Add matrixA and matrixB point by point
    mov rax, [matrixA + 8 * r15] ; rax = matrixA[r15]
    mov rbx, [matrixB + 8 * r15] ; rbx = matrixB[r15]
    add rax, rbx
    mov [matrixC + 8 * r15], rax
    inc r15
    cmp r15, 9
    jne _calcMatrixC

    lea r13, [matrixA]
    mov r14, 65
    call _printmatrix
    
    lea r13, [matrixB]
    mov r14, 66
    call _printmatrix
 
     lea r13, [matrixC]
    mov r14, 67
    call _printmatrix
 
 _exit:
    pop rbp
    mov rax, 60         
    xor rdi, rdi        
    syscall



;Print Matrix function expects the matrix[3x3]Address in r13, and the matrix name in r14

   
_printmatrix:
    push rbp
    mov rbp, rsp
 
    lea rdi, [matrix_name]
    ; mov r14, 65
    mov rsi, r14                                ; 1
    call printf
; order of placeholders:                                #n
    mov rsi, [r13]                                   ; 1
    mov rdx, [r13 + 8]                               ; 2
    mov rcx, [r13 + 8*2]                             ; 3
    mov r8, [r13 + 8*3]                              ; 4
    mov r9, [r13 + 8*4]                              ; 5
    ; Then I need to push in the inverted order
    push qword [r13 + 8*8]                           ; 9
    push qword [r13 + 8*7]                           ; 8 
    push qword [r13 + 8*6]                           ; 7
    push qword [r13 + 8*5]                           ; 6


    ; Load format string
    lea rdi, [matrix_fmt]                ; Address of format string in rdi

    call printf                          ; Call printf
   	mov rsp, rbp
    pop rbp
    ret
