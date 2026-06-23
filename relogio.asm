extern ImprimirString

extern hora
extern minuto
extern segundo


section .data

titulo db "===== RELOGIO DIGITAL =====",10
tamTitulo equ $ - titulo

section .text
global TelaRelogio

TelaRelogio:

    mov rsi, titulo
    mov rdx, tamTitulo
    call ImprimirString


    ret
