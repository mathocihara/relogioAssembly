section .data
    msg db "Assembly funcionando!", 10
    tam equ $ - msg

section .text
    global _start

_start:
    mov rax, 1      ; syscall write
    mov rdi, 1      ; stdout
    mov rsi, msg
    mov rdx, tam
    syscall

    mov rax, 60     ; syscall exit
    xor rdi, rdi
    syscall
