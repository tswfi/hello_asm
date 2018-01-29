;
; Someday this will be a Simple clock written in assembler
;
; syscall listing can be found here http://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
;

%define SYS_WRITE 1

section .data
    ; escape sequence for saving cursor position
    savecursor db 1Bh, '[s'
    .len equ $ - savecursor
    ; escape sequence for returning cursor to the position saved
    setcursor db 1Bh, '[10;20H'
    .len equ $ - setcursor

section .bss
    c: resb 1               ; buffer for our character to print

section .text
    global _start

; output eax to stdout
outchar:
    mov [c], eax            ; set the value into our buffer
    mov rax, SYS_WRITE      ; sys_write
    mov rdi, 1              ; stdout
    mov rdx, 1               ; one character
    mov rsi, c              ; our buffer
    syscall                 ; call it
    ret

; output the full line (bit 8)
outline:
    ; hours
    mov eax, 32             ; space character
    call outchar

    mov eax, 42             ; * character
    call outchar

    mov eax, 32             ; space character
    call outchar

    mov eax, 42             ; * character
    call outchar

    ; minutes
    mov eax, 32             ; space character
    call outchar
    mov eax, 32             ; space character
    call outchar

    mov eax, 42             ; * character
    call outchar

    mov eax, 32             ; space character
    call outchar

    mov eax, 42             ; * character
    call outchar

    ; seconds
    mov eax, 32             ; space character
    call outchar
    mov eax, 32             ; space character
    call outchar

    mov eax, 42             ; * character
    call outchar

    mov eax, 32             ; space character
    call outchar

    mov eax, 42             ; * character
    call outchar

    ; and a newline
    mov eax, 10             ; newline
    call outchar

    ret


outtime:
    ; bit 8
    call outline

    ; bit 4
    call outline

    ; bit 2
    call outline

    ; bit 1
    call outline

    ret

; quit with zero return code
quit_zero:
    mov    rax, 60          ; sys_exit
    mov    rdi, 0           ; code
    syscall

savecursorposition:
    ; save our cursor position
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, savecursor
    mov     rdx, savecursor.len
    syscall                 ; call it

    ret

returncursorposition:
    ; return the cursor back to the saved position
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, setcursor
    mov     rdx, setcursor.len
    syscall                 ; call it

    ret

; main
_start:
    nop                     ; break here :)

    inc rcx

    call savecursorposition

    call outtime

    call returncursorposition

    call outtime

    jmp quit_zero
