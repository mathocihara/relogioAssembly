extern LimparTela
extern ImprimirString

section .data

menuEditar db "==============================",10
           db "     EDITAR ALARME",10
           db "==============================",10,10
           db "Numero do alarme: ",10
           db "Nova hora: ",10
           db "Novo minuto: ",10

tamMenuEditar equ $-menuEditar

section .text

global MostrarMenuEditarAlarme

MostrarMenuEditarAlarme:

    call LimparTela

    mov rsi,menuEditar
    mov rdx,tamMenuEditar
    call ImprimirString

    ret