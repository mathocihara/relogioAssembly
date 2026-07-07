;==============================================================
; sistema/teclado.asm
;==============================================================

default rel

global InicializarTeclado
global RestaurarTeclado
global LerTecla

extern InicializarTerminal
extern RestaurarTerminal

section .text

;==============================================================
; InicializarTeclado
;==============================================================
InicializarTeclado:
    call InicializarTerminal
    ret

;==============================================================
; RestaurarTeclado
;==============================================================
RestaurarTeclado:
    call RestaurarTerminal
    ret

;==============================================================
; LerTecla
;
; retorno:
;   AL = tecla pressionada
;   AL = 0 se nada foi pressionado
;==============================================================
LerTecla:
    sub rsp, 8

    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, rsp        ; buffer
    mov rdx, 1          ; lê 1 byte
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