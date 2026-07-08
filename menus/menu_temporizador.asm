default rel

global MostrarMenuTemporizador

extern LimparTela
extern CursorHome
extern ImprimirString

section .data
menu_temporizador_str db \
"====================================",10,\
"           TEMPORIZADOR             ",10,\
"====================================",10,10,\
"Modulo ainda nao implementado nesta etapa.",10,\
"0 - Voltar",10,\
"====================================",10,0

section .text

MostrarMenuTemporizador:
    call LimparTela
    call CursorHome
    mov rdi, menu_temporizador_str
    call ImprimirString
    ret
