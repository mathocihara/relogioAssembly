extern ImprimirString

section .data

menuPrincipal db "=========================",10
              db " CENTRAL DE TEMPO",10
              db "=========================",10,10
              db "1 - Relogio",10
              db "2 - Cronometro",10
              db "3 - Temporizador",10
              db "4 - Alarmes",10
              db "0 - Sair",10

tamMenuPrincipal equ $ - menuPrincipal

section .text

global MostrarMenuPrincipal

MostrarMenuPrincipal:
    mov rsi, menuPrincipal
    mov rdx, tamMenuPrincipal
    call ImprimirString
    ret