section .data
F_GETFL equ 3
F_SETFL equ 4
O_NONBLOCK equ 0x800

section .bss
tecla resb 1

section .text
global LerTeclaNaoBloqueante

LerTeclaNaoBloqueante:
    ; read(stdin, tecla, 1)
    mov rax, 0
    mov rdi, 0
    mov rsi, tecla
    mov rdx, 1
    syscall

    cmp rax, 1
    jne .sem_tecla

    xor rax, rax
    mov al, [tecla]
    
    ret

.sem_tecla:
    xor rax, rax
    ret
