;
; Someday this will be a Simple clock written in assembler
;
; syscall listing can be found here http://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
;

section .data

section .bss
    c: resb 1               ; buffer for our character to print

section .text
    global _start

; output eax to stdout
outchar:
    mov [c], eax            ; set the value into our buffer
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rdx, 1              ; one character
    mov rsi, c              ; our buffer
    syscall                 ; call it
    ret

; quit with zero return code
quit_zero:
    mov    rax, 60          ; sys_exit
    mov    rdi, 0           ; code
    syscall

; main
_start:
    mov eax, 42             ; * character
    call outchar

    mov eax, 10             ; newline
    call outchar

    mov eax, 42             ; * character
    call outchar

    mov eax, 10             ; newline
    call outchar

    jmp quit_zero
