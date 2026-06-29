global RelogioLoop

extern MainLoop
extern IncrementarSegundo
extern TelaRelogio
extern LimparTela
extern EsperarUmSegundo
extern LerTeclaNaoBloqueante
extern MainLoop

RelogioLoop:
.loop:
    call IncrementarSegundo
    call LimparTela
    call TelaRelogio
    call EsperarUmSegundo

    call LerTeclaNaoBloqueante
    cmp al, '0'
    je VoltarMenu

    jmp .loop

VoltarMenu:
    jmp MainLoop
