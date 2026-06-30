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

opcao0 db "0 - Voltar",10
tamOpcao0 equ $ - opcao0

section .text
global Configuracao

Configuracao:
    mov rsi, tituloConfig
    mov rdx, tamTituloConfig
    call ImprimirString

    mov rsi, opcao1
    mov rdx, tamOpcao1
    call ImprimirString

    mov rsi, opcao0
    mov rdx, tamOpcao0
    call ImprimirString

    mov rsi, opcao2
    mov rdx, tamOpcao2
    call ImprimirString

.espera:
    call LerTeclaNaoBloqueante

    cmp al, 0
    je .espera

    cmp al, '1'
    je AjustarHora

    cmp al, '2'
    je AjustarData

    cmp al, '0'
    je Voltar

    jmp .espera
AjustarHora:
    ; implementar depois
    jmp Configuracao

AjustarData:
    ; implementar depois
    jmp Configuracao

Voltar:
    jmp MainLoop
