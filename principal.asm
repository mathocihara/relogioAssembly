extern LimparTela
extern MostrarMenuPrincipal
extern MostrarMenuRelogio
extern AjustarHora
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
    je AjustarData

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
AjustarData:
    jmp MenuRelogio


;=========================================
; SAÍDA
;=========================================
Sair:
    mov rax, 60
    xor rdi, rdi
    syscall