global MainLoop

extern RelogioLoop
extern LimparTela
extern MenuPrincipal
extern LerTeclaNaoBloqueante
extern LerTecla
extern AlternarFormatoHora
extern Configuracao
extern TelaRelogio

section .text
global _start


_start:
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
    je MostrarConfiguracao

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


MostrarConfiguracao:
.loop:
    call LimparTela
    call Configuracao

    call LerTeclaNaoBloqueante

    cmp al, '0'
    je MainLoop

    cmp al, '3'
    je AlterarFormato

    jmp .loop

EsperaRelogio:

    call LerTeclaNaoBloqueante

    cmp al, '0'
    je MainLoop


   jmp MainLoop



AlterarFormato: 
    
    call AlternarFormatoHora

    jmp MainLoop

Sair:
    mov rax, 60
    xor rdi, rdi
    syscall
