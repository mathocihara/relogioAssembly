section .bss
tecla resb 1

section .text
global LerTecla

LerTecla:

    ; syscall read
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, tecla
    mov rdx, 1          ; lê 1 byte
    syscall

    ; retorna a tecla em AL
    mov al, [tecla]

    ret

