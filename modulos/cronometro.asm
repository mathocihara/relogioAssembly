;==============================================================
; modulos/cronometro.asm
; Cronômetro funcional
;==============================================================

default rel

%include "constantes.inc"
%include "estruturas.inc"

global ModuloCronometro

extern LimparTela
extern CursorHome
extern LerTecla
extern ImprimirString

extern Cronometro
extern EstadoCronometro
extern TextoCronometro

extern IncrementarTempo
extern ZerarTempo
extern TempoParaTexto
extern Esperar1Segundo

section .data

titulo1 db "====================================",10,0
titulo2 db "            CRONOMETRO             ",10,0
titulo3 db "====================================",10,10,0

txtTempo db "Tempo: ",0
txtEstado db 10,"Estado: ",0

estadoParado db "PARADO",10,0
estadoRodando db "RODANDO",10,0
estadoPausado db "PAUSADO",10,0

menu1 db 10,"1 - Iniciar",10,0
menu2 db "2 - Pausar",10,0
menu3 db "3 - Reiniciar",10,0
menu0 db "0 - Voltar",10,0

section .text

;==============================================================
; ModuloCronometro
;==============================================================
ModuloCronometro:

.loop_cronometro:

    ;------------------------------------------
    ; Atualiza texto HH:MM:SS
    ;------------------------------------------
    mov rdi, Cronometro
    mov rsi, TextoCronometro
    call TempoParaTexto

    ;------------------------------------------
    ; Desenha tela
    ;------------------------------------------
    call LimparTela
    call CursorHome

    mov rdi, titulo1
    call ImprimirString

    mov rdi, titulo2
    call ImprimirString

    mov rdi, titulo3
    call ImprimirString

    mov rdi, txtTempo
    call ImprimirString

    mov rdi, TextoCronometro
    call ImprimirString

    mov rdi, txtEstado
    call ImprimirString

    cmp dword [EstadoCronometro], PARADO
    je .mostrar_parado

    cmp dword [EstadoCronometro], EXECUTANDO
    je .mostrar_rodando

    cmp dword [EstadoCronometro], PAUSADO
    je .mostrar_pausado

    jmp .mostrar_parado

.mostrar_parado:
    mov rdi, estadoParado
    call ImprimirString
    jmp .mostrar_menu

.mostrar_rodando:
    mov rdi, estadoRodando
    call ImprimirString
    jmp .mostrar_menu

.mostrar_pausado:
    mov rdi, estadoPausado
    call ImprimirString

.mostrar_menu:
    mov rdi, menu1
    call ImprimirString

    mov rdi, menu2
    call ImprimirString

    mov rdi, menu3
    call ImprimirString

    mov rdi, menu0
    call ImprimirString

    ;------------------------------------------
    ; Lê tecla primeiro
    ;------------------------------------------
    call LerTecla

    ; nenhuma tecla pressionada
    cmp al, 0
    je .sem_tecla

    cmp al, '0'
    je .sair

    cmp al, '1'
    je .iniciar

    cmp al, '2'
    je .pausar

    cmp al, '3'
    je .reiniciar

    jmp .sem_tecla

.iniciar:
    mov dword [EstadoCronometro], EXECUTANDO
    jmp .esperar

.pausar:
    mov dword [EstadoCronometro], PAUSADO
    jmp .esperar

.reiniciar:
    mov rdi, Cronometro
    call ZerarTempo
    mov dword [EstadoCronometro], PARADO
    jmp .loop_cronometro

.sem_tecla:
    ;------------------------------------------
    ; Se estiver rodando, incrementa 1 segundo
    ;------------------------------------------
    cmp dword [EstadoCronometro], EXECUTANDO
    jne .esperar

    mov rdi, Cronometro
    call IncrementarTempo

.esperar:
    ;------------------------------------------
    ; Espera 1 segundo
    ;------------------------------------------
    call Esperar1Segundo
    jmp .loop_cronometro

.sair:
    ret