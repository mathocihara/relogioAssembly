section .text

global LimparTela
global ImprimirString

LimparTela:
    mov rax, 1
    mov rdi, 1
    mov rsi, clear
    mov rdx, clear_len
    syscall
    ret

ImprimirString:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

section .data

clear db 27,"[2J",27,"[H"
clear_len equ $ - clear