;==============================================================
; principal.asm
;==============================================================

default rel

global _start

;==============================================================
; SISTEMA
;==============================================================

extern InicializarTeclado
extern RestaurarTeclado
extern LerTecla

extern LimparTela
extern CursorHome

extern ImprimirString

extern MostrarMenuPrincipal

; tempo
extern AtualizarHorarioDataSistema
extern TextoHorarioSistema
extern TextoDataSistema

; delay
extern Esperar1Segundo

; cronômetro / timer
extern Cronometro
extern Temporizador
extern IncrementarTempo
extern DecrementarTempo
extern TempoParaTexto

section .data

titulo db "==== SISTEMA DE RELOGIO ====",10,0
prompt db "Pressione uma opcao: ",0

buffer_tempo db "00:00:00",10,0

;==============================================================
; ENTRY
;==============================================================
section .text

_start:

    call InicializarTeclado

.loop_principal:

    call LimparTela
    call CursorHome

    mov rdi, titulo
    call ImprimirString

    call MostrarMenuPrincipal

    mov rdi, prompt
    call ImprimirString

    call LerTecla
    cmp al, 0
    je .loop_principal

    cmp al, '0'
    je .sair

    cmp al, '1'
    je .relogio

    cmp al, '2'
    je .cronometro

    cmp al, '3'
    je .temporizador

    cmp al, '4'
    je .alarmes

    jmp .loop_principal

;==============================================================
; RELÓGIO
;==============================================================
.relogio:

.relogio_loop:

    call LimparTela
    call CursorHome

    call AtualizarHorarioDataSistema

    mov rdi, TextoHorarioSistema
    call ImprimirString

    mov rdi, TextoDataSistema
    call ImprimirString

    call LerTecla
    cmp al, '0'
    je .loop_principal

    call Esperar1Segundo
    jmp .relogio_loop

;==============================================================
; CRONÔMETRO
;==============================================================
.cronometro:

.crono_loop:

    mov rdi, Cronometro
    call IncrementarTempo

    mov rdi, Cronometro
    mov rsi, buffer_tempo
    call TempoParaTexto

    mov rdi, buffer_tempo
    call ImprimirString

    call LerTecla
    cmp al, '0'
    je .loop_principal

    call Esperar1Segundo
    jmp .crono_loop

;==============================================================
; TEMPORIZADOR
;==============================================================
.temporizador:

.timer_loop:

    mov rdi, Temporizador
    call DecrementarTempo

    mov rdi, Temporizador
    mov rsi, buffer_tempo
    call TempoParaTexto

    mov rdi, buffer_tempo
    call ImprimirString

    call LerTecla
    cmp al, '0'
    je .loop_principal

    call Esperar1Segundo
    jmp .timer_loop

;==============================================================
; ALARMES
;==============================================================
.alarmes:

.alarmes_loop:

    call LerTecla
    cmp al, '0'
    je .loop_principal

    jmp .alarmes_loop

;==============================================================
; SAIR
;==============================================================
.sair:

    call RestaurarTeclado

    mov rax, 60
    xor rdi, rdi
    syscall