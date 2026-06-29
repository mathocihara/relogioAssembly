section .data
F_GETFL equ 3
F_SETFL equ 4
O_NONBLOCK equ 0x800

section .text
global InicializarEntrada

InicializarEntrada:
    mov rax, 72
    mov rdi, 0
    mov rsi, F_GETFL
    syscall

    or rax, O_NONBLOCK
    mov rdx, rax

    mov rax, 72
    mov rdi, 0
    mov rsi, F_SETFL
    syscall
    ret
