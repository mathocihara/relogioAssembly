extern LimparTela
extern ImprimirString

section .data

menuExcluir db "==============================",10
            db "    EXCLUIR ALARME",10
            db "==============================",10,10
            db "Numero do alarme: "

tamMenuExcluir equ $-menuExcluir

section .text

global MostrarMenuExcluirAlarme

MostrarMenuExcluirAlarme:

    call LimparTela

    mov rsi,menuExcluir
    mov rdx,tamMenuExcluir
    call ImprimirString

    ret