default rel

global _start

extern InicializarTeclado
extern RestaurarTeclado
extern ModuloRelogio

section .text

_start:
    and rsp, -16
    sub rsp, 8

    call InicializarTeclado
    call ModuloRelogio
    call RestaurarTeclado

    add rsp, 8

    mov rax, 60
    xor rdi, rdi
    syscall