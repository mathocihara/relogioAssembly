extern LimparTela
extern MostrarMenuPrincipal
extern MostrarMenuRelogio
extern MostrarMenuTemporizador

extern AjustarHora
extern AjustarData

extern AjustarTemporizador
extern MostrarTelaTemporizadorEdicao
extern IniciarTemporizador
extern PausarTemporizador
extern ReiniciarTemporizador

extern LerOpcaoMenu

global _start

section .text

_start:

menu:
    call LimparTela
    call MostrarMenuPrincipal

.espera:
    call LerOpcaoMenu

    cmp al, '1'
    je MenuRelogio

    cmp al, '3'
    je MenuTemporizador

    cmp al, '0'
    je Sair

    jmp .espera


;=========================================
; MENU RELÓGIO
;=========================================
MenuRelogio:
    call LimparTela
    call MostrarMenuRelogio

.EsperaRelogio:
    call LerOpcaoMenu

    cmp al, '3'
    je AjustarHorario

    cmp al, '4'
    je AjustarDataMenu

    cmp al, '0'
    je menu

    jmp .EsperaRelogio



;=========================================
; AJUSTAR HORÁRIO
;=========================================
AjustarHorario:
    call AjustarHora
    jmp MenuRelogio


;=========================================
; AJUSTAR DATA (placeholder)
;=========================================
AjustarDataMenu:
    call AjustarData
    jmp MenuRelogio

;=========================================
; MENU TEMPORIZADOR
;=========================================
MenuTemporizador:
    call LimparTela
    call MostrarMenuTemporizador

.EsperaTemporizador:
    call LerOpcaoMenu

    cmp al, '1'
    je InserirTempoTemporizador

    cmp al, '0'
    je menu

    jmp .EsperaTemporizador


InserirTempoTemporizador:
    call AjustarTemporizador
    jmp TelaTemporizadorEdicao

;===========================================	
;==========================================
TelaTemporizadorEdicao:
    call MostrarTelaTemporizadorEdicao

.EsperaTelaTemporizadorEdicao:
    call LerOpcaoMenu

    cmp al, '1'
    je AcaoIniciarTemporizador

    cmp al, '2'
    je AcaoPausarTemporizador

    cmp al, '3'
    je AcaoReiniciarTemporizador

    cmp al, '0'
    je MenuTemporizador

    jmp .EsperaTelaTemporizadorEdicao


AcaoIniciarTemporizador:
    call IniciarTemporizador
    jmp TelaTemporizadorEdicao

AcaoPausarTemporizador:
    call PausarTemporizador
    jmp TelaTemporizadorEdicao

AcaoReiniciarTemporizador:
    call ReiniciarTemporizador
    jmp TelaTemporizadorEdicao


;=========================================
; SAÍDA
;=========================================
Sair:
    mov rax, 60
    xor rdi, rdi
    syscall