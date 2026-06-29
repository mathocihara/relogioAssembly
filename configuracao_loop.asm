global ConfiguracaoLoop

extern LimparTela
extern Configuracao
extern LerTeclaConfiguracao
extern AlternarFormatoHora
extern MainLoop

ConfiguracaoLoop:
.loop:
    call LimparTela
    call Configuracao
    call LerTeclaConfiguracao

    cmp al, 10
    je .loop

    cmp al, '0'
    je VoltarMenu



    jmp .loop

VoltarMenu:
    jmp MainLoop
