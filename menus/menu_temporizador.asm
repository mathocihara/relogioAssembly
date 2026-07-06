extern ImprimirString

section .data

menuTemporizador db "=========================",10
                  db "   TEMPORIZADOR",10
                  db "=========================",10,10
                  db "00:00:00",10,10
                  db "1 - Inserir Tempo",10
                  db "2 - Iniciar",10
                  db "3 - Pausar",10
                  db "4 - Reiniciar",10
                  db "0 - Voltar",10

tamMenuTemporizador equ $ - menuTemporizador

section .text

global MostrarMenuTemporizador

; Exibe o menu do temporizador
MostrarMenuTemporizador:

    mov rsi, menuTemporizador
    mov rdx, tamMenuTemporizador
    call ImprimirString

    ret