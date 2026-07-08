default rel

global Esperar1Segundo

extern sleep

section .text
Esperar1Segundo:
    mov rdi, 1
    call sleep
    ret
