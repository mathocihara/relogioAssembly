default rel

global MostrarTelaTemporizadorEdicao
global IniciarTemporizador
global PausarTemporizador
global ReiniciarTemporizador

extern LimparTela
extern ImprimirString
extern LerTecla
extern MostrarMenuTemporizadorEdicao

extern MontarTemporizadorBuffer
extern bufferTemporizador

section .data

quebraLinhaDupla db 10,10
tamQuebraLinhaDupla equ $ - quebraLinhaDupla

msgEmConstrucao db "Funcao ainda nao implementada.",10
tamMsgEmConstrucao equ $ - msgEmConstrucao

msgPressione db 10,"Pressione qualquer tecla para voltar...",10
tamMsgPressione equ $ - msgPressione

section .text

;=========================================================
; Mostra a tela de edição do temporizador
; Exibe o tempo configurado e o menu de ações
;=========================================================
MostrarTelaTemporizadorEdicao:

    ; Atualiza o buffer HH:MM:SS com os valores atuais
    call MontarTemporizadorBuffer

    ; Limpa a tela
    call LimparTela

    ; Mostra o valor atual do temporizador
    mov rsi, bufferTemporizador
    mov rdx, 8
    call ImprimirString

    ; Pula duas linhas
    mov rsi, quebraLinhaDupla
    mov rdx, tamQuebraLinhaDupla
    call ImprimirString

    ; Mostra o menu de edição
    call MostrarMenuTemporizadorEdicao

    ret


;=========================================================
; Iniciar Temporizador
;=========================================================
IniciarTemporizador:
    call LimparTela

    mov rsi, msgEmConstrucao
    mov rdx, tamMsgEmConstrucao
    call ImprimirString

    mov rsi, msgPressione
    mov rdx, tamMsgPressione
    call ImprimirString

    call LerTecla
    ret


;=========================================================
; Pausar Temporizador
;=========================================================
PausarTemporizador:
    call LimparTela

    mov rsi, msgEmConstrucao
    mov rdx, tamMsgEmConstrucao
    call ImprimirString

    mov rsi, msgPressione
    mov rdx, tamMsgPressione
    call ImprimirString

    call LerTecla
    ret


;=========================================================
; Reiniciar Temporizador
;=========================================================
ReiniciarTemporizador:
    call LimparTela

    mov rsi, msgEmConstrucao
    mov rdx, tamMsgEmConstrucao
    call ImprimirString

    mov rsi, msgPressione
    mov rdx, tamMsgPressione
    call ImprimirString

    call LerTecla
    ret