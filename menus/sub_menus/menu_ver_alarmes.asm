extern LimparTela
extern ImprimirString

section .data

menuVerAlarmes db "==============================",10
               db "       VER ALARMES",10
               db "==============================",10,10
               db "Alarmes cadastrados:",10,10
               db "0 - Voltar",10

tamMenuVerAlarmes equ $-menuVerAlarmes

section .text

global MostrarMenuVerAlarmes

MostrarMenuVerAlarmes:

    call LimparTela

    mov rsi,menuVerAlarmes
    mov rdx,tamMenuVerAlarmes
    call ImprimirString

    ret