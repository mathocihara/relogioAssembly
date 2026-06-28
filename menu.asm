extern ImprimirString

section .data

tituloMenu db "===== MENU PRINCIPAL =====",10,10
tamTituloMenu equ $ - tituloMenu

opcao1 db "1 - Relogio",10
tamOpcao1 equ $ - opcao1

opcao2 db "2 - Configuracoes",10
tamOpcao2 equ $ - opcao2

opcao0 db "0 - Sair",10
tamOpcao0 equ $ - opcao0

section .text
global MenuPrincipal

MenuPrincipal:

    ; Imprime o título
    mov rsi, tituloMenu
    mov rdx, tamTituloMenu
    call ImprimirString

    ; Imprime opção 1
    mov rsi, opcao1
    mov rdx, tamOpcao1
    call ImprimirString

    ; Imprime opção 2
    mov rsi, opcao2
    mov rdx, tamOpcao2
    call ImprimirString

    ; Imprime opção 0
    mov rsi, opcao0
    mov rdx, tamOpcao0
    call ImprimirString

    ret
