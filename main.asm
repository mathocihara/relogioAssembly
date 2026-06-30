global MainLoop


extern LimparTela
extern MenuPrincipal
extern LerTeclaNaoBloqueante


extern Configuracao
extern TelaRelogio
extern EsperarUmSegundo
extern InicializarEntrada
extern IncrementarSegundo
extern estado
section .text
global _start


_start:
    call InicializarEntrada
   jmp MainLoop

MainLoop:
    call LimparTela

    mov al, [estado]

    cmp al, 0
    je EstadoMenu

    cmp al, 1
    je EstadoRelogio

    cmp al, 2
    je EstadoConfiguracao

    jmp MainLoop

EstadoMenu:
    call MenuPrincipal
    call LerTeclaNaoBloqueante

    cmp al, '1'
    je IrRelogio

    cmp al, '2'
    je IrConfiguracao

    cmp al, '0'
    je Sair
    call EsperarUmSegundo
    jmp MainLoop
EstadoRelogio:
    call LimparTela
    call TelaRelogio
    call EsperarUmSegundo
    call IncrementarSegundo
    call LerTeclaNaoBloqueante
    cmp al, '0'
    je VoltarMenu

    jmp EstadoRelogio

EstadoConfiguracao:
    call Configuracao
    jmp MainLoop

IrRelogio:
    mov byte [estado], 1
    jmp MainLoop

IrConfiguracao:
    mov byte [estado], 2
    jmp MainLoop

VoltarMenu:
    mov byte [estado], 0
    jmp MainLoop

Sair:
    mov rax, 60
    xor rdi, rdi
    syscall
