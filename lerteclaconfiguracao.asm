section .bss
tecla resb 1

section .text
global LerTeclaConfiguracao

LerTeclaConfiguracao:
.loop:
    mov rax, 0      ; syscall read
    mov rdi, 0      ; stdin
    mov rsi, tecla
    mov rdx, 1
    syscall

    cmp rax, 1
    jne .loop

    mov al, [tecla]

    ; aceita só 0,1,2,3
    cmp al, '0'
    je .fim

    cmp al, '1'
    je .fim

    cmp al, '2'
    je .fim

    cmp al, '3'
    je .fim

    jmp .loop

.fim:
    ret
