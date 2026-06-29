extern ImprimirString
extern LerTeclaNaoBloqueante
extern MainLoop

section .data
tituloConfig db "===== CONFIGURACOES =====",10,10
tamTituloConfig equ $ - tituloConfig

opcao1 db "1 - Ajustar Hora",10
tamOpcao1 equ $ - opcao1

opcao2 db "2 - Ajustar Data",10
tamOpcao2 equ $ - opcao2

opcao3 db "3 - Formato 12h/24h",10
tamOpcao3 equ $ - opcao3

opcao0 db "0 - Voltar",10
tamOpcao0 equ $ - opcao0

section .text
global Configuracao

Configuracao:
    ; imprime UMA vez
    mov rsi, tituloConfig
    mov rdx, tamTituloConfig
    call ImprimirString

    mov rsi, opcao1
    mov rdx, tamOpcao1
    call ImprimirString

    mov rsi, opcao2
    mov rdx, tamOpcao2
    call ImprimirString

    mov rsi, opcao3
    mov rdx, tamOpcao3
    call ImprimirString

    mov rsi, opcao0
    mov rdx, tamOpcao0
    call ImprimirString

.espera:
    call LerTeclaNaoBloqueante

    cmp al, 0
    je .espera

    cmp al, '0'
    je Voltar

    jmp .espera

Voltar:
    jmp MainLoop
