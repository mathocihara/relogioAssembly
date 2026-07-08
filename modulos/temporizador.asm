;==============================================================
; modulos/temporizador.asm
; Temporizador com definicao de tempo em HH:MM:SS
;==============================================================

default rel

%include "constantes.inc"
%include "estruturas.inc"

global ModuloTemporizador

extern LimparTela
extern CursorHome
extern LerTecla
extern ImprimirString

extern Temporizador
extern EstadoTemporizador
extern TextoTemporizador

extern DecrementarTempo
extern CopiarTempo
extern TempoParaTexto
extern Esperar1Segundo

section .data

titulo1 db "====================================",10,0
titulo2 db "           TEMPORIZADOR            ",10,0
titulo3 db "====================================",10,10,0

txtTempo db "Tempo restante: ",0
txtEstado db 10,"Estado: ",0

estadoParado db "PARADO",10,0
estadoRodando db "RODANDO",10,0
estadoPausado db "PAUSADO",10,0
estadoFinalizado db "FINALIZADO",10,0

menu1 db 10,"1 - Definir tempo",10,0
menu2 db "2 - Iniciar",10,0
menu3 db "3 - Pausar",10,0
menu4 db "4 - Reiniciar",10,0
menu0 db "0 - Voltar",10,0

msgHora db "Digite HORA (2 digitos): ",0
msgMin  db "Digite MINUTO (2 digitos): ",0
msgSeg  db "Digite SEGUNDO (2 digitos): ",0

; tempo configurado pelo usuario
TempoConfigurado:
    db 0
    db 1
    db 0
    db 0

section .bss
dig1 resb 1
dig2 resb 1

section .text

;==============================================================
; InicializarTemporizador
; copia TempoConfigurado para Temporizador
;==============================================================
InicializarTemporizador:
    mov rdi, Temporizador
    mov rsi, TempoConfigurado
    call CopiarTempo
    ret

;==============================================================
; TemporizadorZerado
; eax = 1 se zerado
; eax = 0 caso contrario
;==============================================================
TemporizadorZerado:
    cmp byte [Temporizador + TEMPO.hora], 0
    jne .nao
    cmp byte [Temporizador + TEMPO.minuto], 0
    jne .nao
    cmp byte [Temporizador + TEMPO.segundo], 0
    jne .nao

    mov eax, 1
    ret

.nao:
    xor eax, eax
    ret

;==============================================================
; LerDigito
; espera uma tecla entre '0' e '9'
; retorna valor numerico em AL
;==============================================================
LerDigito:
.loop:
    call LerTecla
    cmp al, '0'
    jb .loop
    cmp al, '9'
    ja .loop

    sub al, '0'
    ret

;==============================================================
; LerDoisDigitos
; retorna valor em AL (0..99)
;==============================================================
LerDoisDigitos:
    call LerDigito
    mov [dig1], al

    call LerDigito
    mov [dig2], al

    movzx eax, byte [dig1]
    mov bl, 10
    mul bl                 ; AX = dig1 * 10

    movzx ebx, byte [dig2]
    add al, bl
    ret

;==============================================================
; DefinirTempoTemporizador
; usuario define HH:MM:SS
;==============================================================
DefinirTempoTemporizador:

    ;--------------------------
    ; hora
    ;--------------------------
    call LimparTela
    call CursorHome
    mov rdi, msgHora
    call ImprimirString
    call LerDoisDigitos
    mov [TempoConfigurado + TEMPO.hora], al

    ;--------------------------
    ; minuto
    ;--------------------------
    call LimparTela
    call CursorHome
    mov rdi, msgMin
    call ImprimirString
    call LerDoisDigitos

    cmp al, 59
    jbe .min_ok
    xor al, al
.min_ok:
    mov [TempoConfigurado + TEMPO.minuto], al

    ;--------------------------
    ; segundo
    ;--------------------------
    call LimparTela
    call CursorHome
    mov rdi, msgSeg
    call ImprimirString
    call LerDoisDigitos

    cmp al, 59
    jbe .seg_ok
    xor al, al
.seg_ok:
    mov [TempoConfigurado + TEMPO.segundo], al

    mov byte [TempoConfigurado + TEMPO.estado], 0

    call InicializarTemporizador
    mov dword [EstadoTemporizador], PARADO
    ret

;==============================================================
; ModuloTemporizador
;==============================================================
ModuloTemporizador:

    call InicializarTemporizador
    mov dword [EstadoTemporizador], PARADO

.loop_temporizador:

    ;------------------------------------------
    ; se estiver rodando, decrementa
    ;------------------------------------------
    cmp dword [EstadoTemporizador], EXECUTANDO
    jne .nao_decrementa

    mov rdi, Temporizador
    call DecrementarTempo

    call TemporizadorZerado
    cmp eax, 1
    jne .nao_decrementa

    mov dword [EstadoTemporizador], 3

.nao_decrementa:

    ;------------------------------------------
    ; atualiza texto
    ;------------------------------------------
    mov rdi, Temporizador
    mov rsi, TextoTemporizador
    call TempoParaTexto

    ;------------------------------------------
    ; desenha tela
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
    mov rdi, TextoTemporizador
    call ImprimirString

    mov rdi, txtEstado
    call ImprimirString

    cmp dword [EstadoTemporizador], PARADO
    je .mostrar_parado

    cmp dword [EstadoTemporizador], EXECUTANDO
    je .mostrar_rodando

    cmp dword [EstadoTemporizador], PAUSADO
    je .mostrar_pausado

    cmp dword [EstadoTemporizador], 3
    je .mostrar_finalizado

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
    jmp .mostrar_menu

.mostrar_finalizado:
    mov rdi, estadoFinalizado
    call ImprimirString

.mostrar_menu:
    mov rdi, menu1
    call ImprimirString
    mov rdi, menu2
    call ImprimirString
    mov rdi, menu3
    call ImprimirString
    mov rdi, menu4
    call ImprimirString
    mov rdi, menu0
    call ImprimirString

    call Esperar1Segundo
    call LerTecla

    cmp al, '0'
    je .sair

    cmp al, '1'
    je .definir

    cmp al, '2'
    je .iniciar

    cmp al, '3'
    je .pausar

    cmp al, '4'
    je .reiniciar

    jmp .loop_temporizador

.definir:
    call DefinirTempoTemporizador
    jmp .loop_temporizador

.iniciar:
    cmp dword [EstadoTemporizador], 3
    jne .iniciar_normal
    call InicializarTemporizador

.iniciar_normal:
    mov dword [EstadoTemporizador], EXECUTANDO
    jmp .loop_temporizador

.pausar:
    mov dword [EstadoTemporizador], PAUSADO
    jmp .loop_temporizador

.reiniciar:
    call InicializarTemporizador
    mov dword [EstadoTemporizador], PARADO
    jmp .loop_temporizador

.sair:
    ret