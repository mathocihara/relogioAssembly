global MainLoop

extern RelogioLoop
extern LimparTela
extern MenuPrincipal
extern LerTeclaNaoBloqueante
extern LerTeclaConfiguracao
extern LerTecla
extern AlternarFormatoHora
extern Configuracao
extern TelaRelogio
extern EsperarUmSegundo
extern InicializarEntrada
extern ConfiguracaoLoop

section .text
global _start


_start:
    call InicializarEntrada
   jmp MainLoop

MainLoop:

    call LimparTela
    call MenuPrincipal
   .wait:
    call LerTeclaNaoBloqueante

    cmp al, 0
    je .wait 

    cmp al, '1'
    je RelogioLoop

    cmp al, '2'
    je ConfiguracaoLoop

    cmp al, '0'
    je Sair

    jmp MainLoop

MostrarRelogio:
.loop:

    call LimparTela
    call TelaRelogio

    call LerTeclaNaoBloqueante

    cmp al, '0'
    je MainLoop

    jmp .loop



AlterarFormato: 
    
    call AlternarFormatoHora

    jmp MainLoop

Sair:
    mov rax, 60
    xor rdi, rdi
    syscall
