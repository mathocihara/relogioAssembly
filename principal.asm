;==============================================================
; principal.asm
;==============================================================

default rel

global main

extern InicializarTeclado
extern RestaurarTeclado
extern LerTecla

extern LimparTela
extern CursorHome
extern ImprimirString

extern MostrarMenuPrincipal
extern MostrarMenuRelogio

extern AtualizarHorarioDataSistema
extern Esperar1Segundo

section .data

titulo db "==== SISTEMA DE RELOGIO ====",10,0
prompt db "Pressione uma opcao: ",0

msgCronometro db "CRONOMETRO - EM CONSTRUCAO",10
              db "0 - Voltar",10,0

msgTemporizador db "TEMPORIZADOR - EM CONSTRUCAO",10
                db "0 - Voltar",10,0

msgAlarmes db "ALARMES - EM CONSTRUCAO",10
           db "0 - Voltar",10,0

section .text

main:
    call InicializarTeclado

.loop_principal:
    call LimparTela
    call CursorHome

    mov rdi, titulo
    call ImprimirString

    call MostrarMenuPrincipal

    mov rdi, prompt
    call ImprimirString

.espera_menu:
    call LerTecla
    cmp al, 0
    je .espera_menu

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

    jmp .espera_menu

;==============================================================
; RELÓGIO
;==============================================================
.relogio:
.relogio_loop:
    call LimparTela
    call CursorHome

    call AtualizarHorarioDataSistema
    call MostrarMenuRelogio

    call Esperar1Segundo

    call LerTecla
    cmp al, '0'
    je .loop_principal

    jmp .relogio_loop

;==============================================================
; CRONÔMETRO
;==============================================================
.cronometro:
    call LimparTela
    call CursorHome

    mov rdi, msgCronometro
    call ImprimirString

.crono_espera:
    call LerTecla
    cmp al, 0
    je .crono_espera
    cmp al, '0'
    je .loop_principal
    jmp .crono_espera

;==============================================================
; TEMPORIZADOR
;==============================================================
.temporizador:
    call LimparTela
    call CursorHome

    mov rdi, msgTemporizador
    call ImprimirString

.timer_espera:
    call LerTecla
    cmp al, 0
    je .timer_espera
    cmp al, '0'
    je .loop_principal
    jmp .timer_espera

;==============================================================
; ALARMES
;==============================================================
.alarmes:
    call LimparTela
    call CursorHome

    mov rdi, msgAlarmes
    call ImprimirString

.alarmes_espera:
    call LerTecla
    cmp al, 0
    je .alarmes_espera
    cmp al, '0'
    je .loop_principal
    jmp .alarmes_espera

.sair:
    call RestaurarTeclado
    xor eax, eax
    ret