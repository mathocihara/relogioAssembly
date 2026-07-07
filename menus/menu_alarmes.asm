extern ImprimirString

section .data

menuAlarmes db "=========================",10
             db "      ALARMES",10
             db "=========================",10,10
             db "Alarmes:",10
             db "-------------------------",10,10
             db "1 - Ver Alarmes",10
             db "2 - Criar Alarme",10
             db "3 - Editar Alarme",10
             db "4 - Excluir Alarme",10
             db "0 - Voltar",10

tamMenuAlarmes equ $ - menuAlarmes

section .text

global MostrarMenuAlarmes

; Exibe o menu de alarmes
MostrarMenuAlarmes:

    mov rsi, menuAlarmes
    mov rdx, tamMenuAlarmes
    call ImprimirString

    ret