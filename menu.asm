extern ImprimirString

section .data

menu db "===== MENU PRINCIPAL =====",10
     db "1 - Relogio",10
     db "2 - Configuracoes",10
     db "0 - Sair",10

tamMenu equ $ - menu

section .text
global MenuPrincipal
extern ImprimirString


MenuPrincipal:

    mov rsi, menu
    mov rdx, tamMenu
    call ImprimirString

    ret
