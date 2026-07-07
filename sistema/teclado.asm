;==============================================================
; sistema/teclado.asm
;
; Teclado simples e não-bloqueante (Linux/WSL)
; usando syscall read + terminal já configurado pelo C
;==============================================================

default rel

section .text

global LerTecla

;==============================================================
; LerTecla
;
; retorno:
; AL = tecla pressionada
; AL = 0 se nada
;==============================================================

LerTecla:

    sub rsp, 8

    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, rsp       ; buffer
    mov rdx, 1         ; 1 byte

    syscall

    cmp rax, 1
    jne .sem_tecla

    mov al, [rsp]
    add rsp, 8
    ret

.sem_tecla:
    xor al, al
    add rsp, 8
    ret

global InicializarTeclado
global RestaurarTeclado

section .text

InicializarTeclado:
    ret

RestaurarTeclado:
    ret