; This was made for x86-64bits and need to compile using gcc for scanf. printf
; compile and run: nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1
; remember to be in the same directory as the file
section .data
    ;prompt db "Type in an int64 for cell [%d], [%d] @0x%08x: ", 0 ;debug address
    prompt db "Type in an int64 for cell [%d], [%d]: ", 0
    input_fmt db "%d", 0
    matrix_fmt db "Matrix:",9," %8d %8d %8d", 10, 9, " %8d %8d %8d", 10, 9, " %8d %8d %8d", 10, 0
    ;
    output_fmt db 9, "Diagonal Sum: %d ", 10, 0
    ;output_fmt db 9, "Diagonal Sum: %d  [%d][%d]", 10, 0 ;Debug index, cell
section .bss
    matrix resq 9 ; 3x3 matrix
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
_inputloop:
    mov rax, r15 ; calc current row/col
    cqo          ; sign extend rax to rdx:rax
    mov rbx , 3  ; 3 columns
    div rbx      ; rdx = rax % rbx
    lea rdi, [prompt]
    mov rsi, rax
    mov rdx, rdx
    lea rcx, [matrix + r15 * 8] ; Address of current cell for debug
    call printf
    lea rdi, [input_fmt]
    lea rsi, [matrix + r15 * 8]
    xor rax, rax
    xor rdx, rdx
    call scanf
    inc r15
    cmp r15, 9
    jne _inputloop

_calcdiagonal:
    mov r15, 0 ; row/column of diagonal element
    mov r14, 0 ; sum
_calcdiagonal_loop:
    mov rax, r15
    imul rax, 3 ; rax = r15 * 3 -> set current row to r15
    add rax, r15 ; rax = r15 * 3 + r15 -> set current column to r15
    mov rdx, [matrix + rax * 8] ; rdx = matrix[r15][r15]
    add r14, rdx
; _printdiagonalDebug:
;     lea rdi, [output_fmt]
;     mov rsi, r14 ; partial sum
;     mov rdx, r15 ; row
;     mov rcx, rax ; index cell
;     call printf
    inc r15 ; inc row -> 0, 0 -> 1,1 -> 2,2
    cmp r15, 3 ; check if column is > 2
    jne _calcdiagonal_loop
    mov [diag], r14 ; Save the result

_exit:

;Print Matrix
_printmatrix:
; order of placeholders:                                #n
    mov rsi, [matrix]                                   ; 1
    mov rdx, [matrix + 8]                               ; 2
    mov rcx, [matrix + 8*2]                             ; 3
    mov r8, [matrix + 8*3]                              ; 4
    mov r9, [matrix + 8*4]                              ; 5
    ; Then I need to push in the inverted order
    push qword [matrix + 8*8]                           ; 9
    push qword [matrix + 8*7]                           ; 8 
    push qword [matrix + 8*6]                           ; 7
    push qword [matrix + 8*5]                           ; 6

    ; Load format string
    lea rdi, [matrix_fmt]                ; Address of format string in rdi

    call printf                          ; Call printf
; Print Diagonal Sum
_printdiagonal:
    lea rdi, [output_fmt]
    mov rsi, [diag]
    call printf


    pop rbp
    mov rax, 60         
    xor rdi, rdi        
    syscall



