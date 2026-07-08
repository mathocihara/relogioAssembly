default rel

global MostrarMenuCronometro

extern LimparTela
extern CursorHome
extern ImprimirString

section .data
menu_cronometro_str db \
"====================================",10,\
"            CRONOMETRO              ",10,\
"====================================",10,10,\
"Modulo ainda nao implementado nesta etapa.",10,\
"0 - Voltar",10,\
"====================================",10,0

section .text

MostrarMenuCronometro:
    call LimparTela
    call CursorHome
    mov rdi, menu_cronometro_str
    call ImprimirString
    ret
