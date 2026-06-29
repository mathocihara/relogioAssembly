section .data
F_GETFL equ 3
F_SETFL equ 4
O_NONBLOCK equ 0x800

section .bss
tecla resb 1

section .text
global LerTeclaNaoBloqueante

LerTeclaNaoBloqueante:

    ; pega flags atuais do stdin
    mov rax, 72          ; sys_fcntl
    mov rdi, 0           ; stdin
    mov rsi, F_GETFL
    syscall

    ; adiciona O_NONBLOCK
    or rax, O_NONBLOCK

    ; aplica flags
    mov rdi, 0
    mov rsi, F_SETFL
    mov rdx, rax
    mov rax, 72
    syscall

    ; tenta ler
    mov rax, 0
    mov rdi, 0
    mov rsi, tecla
    mov rdx, 1
    syscall

    cmp rax, 1
    jne .sem

    mov al, [tecla]
    ret

.sem:
    mov al, 0
    ret
