extern LimparTela
extern MenuPrincipal
extern IncrementarSegundo
extern EsperarUmSegundo
extern LerTecla
extern MenuPrincipal

section .text
global _start

_start:

MainLoop:

    ; Limpa a tela
    call LimparTela

    ; Exibe a tela do relógio
    call MenuPrincipal

    call LerTecla 
    cmp al, '0'
    je Sair
    
    jmp MainLoop

Sair:
    mov rax, 60
    xor rdi, rdi
    syscall
