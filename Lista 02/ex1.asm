;#Im using # because replit only makes a comment after a # (visually)
;# This was made for x86-64bits
;# compile and run: nasm -f elf64 ex1.asm && gcc -o ex1 ex1.o -no-pie -z execstack -lm && ./ex1

section .data
    b4_first_prompt db "limitations: A,B >= 0; A,B < 1e9, A<B will lead to overflow on the subtraction. only b10", 10,0
    b4_first_prompt_len equ $-b4_first_prompt
    first_prompt db "Type number A: ", 0
    first_prompt_len equ $-first_prompt
    second_prompt db "Type number B: ", 0
    second_prompt_len equ $-second_prompt 
    output db "A+B = ", 0
    output_len equ $-output
    input_len equ 10
    output2 db "A-B = ", 0
    newline db 10
    newline_len equ $-newline


section .bss
    A_str resb input_len    ;#10bytes
    B_str resb input_len    ;#10bytes
    result resb 16  ;# result str
    reverse_result resb 16 ;#
    ;# shame_wall -> AB_val resb 4 ;#A+B int32
    AB_val resb 1;#A+B 32bit

section .text
    global main

main:
    ; #limitations prompt
    ; #not following lead to UB
    mov rax, 1
    mov rdi, 1
    mov rsi, b4_first_prompt
    mov rdx, b4_first_prompt_len
    syscall
    ; #req A
    mov rax, 1
    mov rdi, 1
    mov rsi, first_prompt
    mov rdx, first_prompt_len
    syscall

    ;#read A
    mov rax, 0
    mov rdi, 0
    mov rsi, A_str
    mov rdx, input_len
    syscall

    ; #req A
    mov rax, 1
    mov rdi, 1
    mov rsi, second_prompt
    mov rdx, second_prompt_len
    syscall

    ;#read A
    mov rax, 0
    mov rdi, 0
    mov rsi, B_str
    mov rdx, input_len
    syscall



    ;# convert A->int
    mov rsi, A_str ;#source
    ;#mov rdi, result ;#sanityChecker
    call str_to_int
    mov rdi, AB_val ;#target
    xor eax,eax ; #clear A 
    mov eax, [AB_val] ; #set A to val 
    add eax, r15d, 
    mov [rdi], eax


    ;# convert B->int
    mov rsi, B_str ;#source
    call str_to_int
    mov rdi, AB_val ;#target
    xor eax,eax
    mov eax, [AB_val]
    add eax, r15d
    mov [rdi], eax


    ;#AB_val to str
    mov rax, [AB_val] ;#input val
    mov rdi, result ;#target
    call int_to_str

    ; #print output prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    mov rdx, output_len
    syscall

    ;#print result
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 16
    syscall
    call _ln
    ;# A-B
    ;#Zero AB_val and does the conversion again
    mov rdi, AB_val 
    mov byte [rdi], 0
    ;# convert A->int
    mov rsi, A_str ;#source
    ;#mov rdi, result ;#sanityChecker
    call str_to_int
    mov rdi, AB_val ;#target
    xor eax,eax ; #clear A 
    mov eax, [AB_val] ; #set A to val 
    add eax, r15d, 
    mov [rdi], eax

    ;# convert B->int
    mov rsi, B_str ;#source
    call str_to_int
    mov rdi, AB_val ;#target
    xor eax,eax
    mov eax, [AB_val]
    sub eax, r15d
    mov [rdi], eax


    ;#AB_val to str
    mov rax, [AB_val] ;#input val
    mov rdi, result ;#target
    call int_to_str

    ; #print output prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, output2
    mov rdx, output_len
    syscall

    ;#print result
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 16
    syscall
    call _ln

    call _exit


_ln:
;#print newline
mov rax, 1
mov rdi, 1
mov rsi, newline
mov rdx, newline_len
syscall
ret


 _exit:
    mov rax, 60
    xor rdi, rdi
    syscall

; # int(char* A)
str_to_int:
; # rsi -> char pointer
; # rdi ->  sanity checker pointer
; # result will be in r15
    xor rcx, rcx ;#index
    xor rax, rax ;#Current
    xor r15, r15 ;#total
next_digit:
    xor rax, rax ;#Current
    movzx rax, byte [rsi + rcx]  ; #rax = A[rcx] padded by 0
    cmp rax, 0  ; # if it is null terminator done
    ;# not memmory safe, what happens if we go over the char* buff?
    jle done_conversion
    cmp al, 0x39
    jg _ignore
    cmp al, 0x30
    jl _ignore
    imul r15, 10 ;#rdx *= 10
    sub rax, 0x30  ; # rax = ascii -> int 
    add r15, rax  ; #rdx += 0

    ;#debug
    ;#sanity test check
    ;#wierd input -> adding ; at the end
    ;#add rax, 0x61 
    ;#mov byte [rdi + rcx], al
_ignore:
    inc rcx  ; #index++
    jmp next_digit
done_conversion:
    ;#inc rcx  ; #index++ sanity test check
    ;#mov byte [rdi + rcx], 10 sanity test check
    ret

; #itoa(*value, char* target, target_len) -> 
; #rax = value, rdi = *target, rdx = target_len
int_to_str:
    mov rbx, 10  ; #Divisor (base 10)
    mov rcx, 0   ; #current index
;    xor r14,r14   ;
;    mov r14, rdx ;
;#     dec rdx      ; #target_len = target_len-1
;# _clear_str: ;#clear a char * from the back to the front
;#     test rdx, rdx
;#     jz _start_convert
;#     mov byte [rdi + rdx], 0 ; #clear char* rdi[ rdx]
;#     dec rdx
;#     jmp _clear_str

_convert:
    mov rdx, 0    ; # rdx = 0, clear the remainder
    div ebx       ; # eax =  edx/ebx edx, edx = edx%ebx
    add dl, 0x30 ; # convert dl into char
    push rdx      ; # lifo will revert string for me
    ;mov byte [rdi + rcx], dl
    inc rcx       ; #puhscount
    ;# if index >= r14 -> go to maxsize
    ;#cmp rcx, r14
    ;#jge _max_size

    cmp eax, 0 ; #if eax/ebx > 0, continue
    jg _convert
    ;#ret
    ;#done
__done:
    mov rax, 0
    mov rbx, 0
    mov rdx, 0
    mov byte [rdi + rcx], 0 ; #null terminate string
    dec rcx
_save:
    pop  rdx
    mov byte [rdi + rbx], dl
    xor rdx, rdx
    inc rbx
    cmp rbx, rcx
    jle _save
    ret
