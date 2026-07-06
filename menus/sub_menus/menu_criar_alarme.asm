extern LimparTela
extern ImprimirString

section .data

menuCriar db "==============================",10
          db "      NOVO ALARME",10
          db "==============================",10,10
          db "Hora (HH): ",10
          db "Minuto (MM): ",10

tamMenuCriar equ $-menuCriar

section .text

global MostrarMenuCriarAlarme

MostrarMenuCriarAlarme:

    call LimparTela

    mov rsi,menuCriar
    mov rdx,tamMenuCriar
    call ImprimirString

    ret