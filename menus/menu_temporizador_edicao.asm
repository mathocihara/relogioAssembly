global MostrarMenuTemporizadorEdicao

extern ImprimirString

section .data

menuTemporizadorEdicao db "=========================",10
                       db "   TEMPORIZADOR",10
                       db "=========================",10,10
                       db "1 - Iniciar",10
                       db "2 - Pausar",10
                       db "3 - Reiniciar",10
                       db "0 - Voltar",10

tamMenuTemporizadorEdicao equ $ - menuTemporizadorEdicao

section .text

MostrarMenuTemporizadorEdicao:
    mov rsi, menuTemporizadorEdicao
    mov rdx, tamMenuTemporizadorEdicao
    call ImprimirString
    ret

