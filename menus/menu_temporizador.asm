global MostrarMenuTemporizador
extern ImprimirString

section .data

menuTemporizador db "=========================",10
                  db "   TEMPORIZADOR",10
                  db "=========================",10,10
                  db "1 - Inserir Tempo",10
                  db "0 - Voltar",10


tamMenuTemporizador equ $ - menuTemporizador

section .text

MostrarMenuTemporizador:
    mov rsi, menuTemporizador
    mov rdx, tamMenuTemporizador
    call ImprimirString
    ret