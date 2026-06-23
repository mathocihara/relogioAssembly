extern LimparTela
extern TelaRelogio
extern IncrementarSegundo
extern EsperarUmSegundo


section .text
global _start

_start:

MainLoop:

    ; Limpa a tela
    call LimparTela

    ; Exibe a tela do relógio
    call TelaRelogio

    ; Aguarda 1 segundo
    call EsperarUmSegundo

    ; Atualiza os segundos
    call IncrementarSegundo

    ; Repete indefinidamente
    jmp MainLoop
	
