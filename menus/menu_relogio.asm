default rel

global MostrarMenuRelogio

extern LimparTela
extern CursorHome
extern ImprimirString

section .data
menu_relogio_str db \
"====================================",10,\
"               RELOGIO              ",10,\
"====================================",10,10,\
"0 - Voltar",10,\
"====================================",10,0

section .text

MostrarMenuRelogio:
    call LimparTela
    call CursorHome
    mov rdi, menu_relogio_str
    call ImprimirString
    ret