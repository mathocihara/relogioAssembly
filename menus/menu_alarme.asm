default rel

global MostrarMenuAlarmes

extern LimparTela
extern CursorHome
extern ImprimirString

section .data
menu_alarme_str db \
"====================================",10,\
"              ALARMES               ",10,\
"====================================",10,10,\
"Modulo ainda nao implementado nesta etapa.",10,\
"0 - Voltar",10,\
"====================================",10,0

section .text

MostrarMenuAlarmes:
    call LimparTela
    call CursorHome
    mov rdi, menu_alarme_str
    call ImprimirString
    ret
