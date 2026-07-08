default rel

global MostrarMenuPrincipal

extern ImprimirString

section .data
menu_principal_str db \
"====================================",10,\
"           MENU PRINCIPAL           ",10,\
"====================================",10,10,\
"1 - Relogio",10,\
"0 - Sair",10,10,\
"====================================",10,0

section .text

MostrarMenuPrincipal:
    mov rdi, menu_principal_str
    call ImprimirString
    ret