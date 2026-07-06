global MostrarMenuRelogio
extern ImprimirString


section .data

menuRelogio db "3 - Ajustar Hora",10
             db "4 - Ajustar Data",10
             db "0 - Voltar",10

tamMenuRelogio equ $ - menuRelogio

section .text

global MostrarMenuRelogio

MostrarMenuRelogio:
    mov rsi, menuRelogio
    mov rdx, tamMenuRelogio
    call ImprimirString
    ret