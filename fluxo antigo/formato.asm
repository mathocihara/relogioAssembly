extern formatoHora

section .text
global AlternarFormatoHora

AlternarFormatoHora:

    cmp byte [formatoHora], 24
    je MudarPara12

    mov byte [formatoHora], 24
    ret

MudarPara12:

    mov byte [formatoHora], 12
    ret
