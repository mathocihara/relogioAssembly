default rel

section .bss
tecla resb 1

section .text

global LerTecla
global LimparLinhaEntrada
global LerOpcaoMenu


LerTecla:
    mov rax, 0
    mov rdi, 0
    mov rsi, tecla
    mov rdx, 1
    syscall

    mov al, [tecla]
    ret


LerOpcaoMenu:
.ler:
    call LerTecla

    cmp al, 10
    je .ler

    cmp al, 13
    je .ler

    ret

; Consome tudo até encontrar ENTER
LimparLinhaEntrada:
.ler:
    call LerTecla

    cmp al, 10          ; '\n'
    je .fim

    cmp al, 13          ; '\r'
    je .fim

    jmp .ler

.fim:
    ret