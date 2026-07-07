extern ImprimirString

section .data

menuCronometro db "=========================",10
                db "    CRONOMETRO",10
                db "=========================",10,10
                db "00:00:00",10,10
                db "1 - Iniciar",10
                db "2 - Pausar",10
                db "3 - Reiniciar",10
                db "0 - Voltar",10

tamMenuCronometro equ $ - menuCronometro

section .text

global MostrarMenuCronometro

; Exibe o menu do cronômetro
MostrarMenuCronometro:

    mov rsi, menuCronometro
    mov rdx, tamMenuCronometro
    call ImprimirString

    ret