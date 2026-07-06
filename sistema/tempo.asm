;==============================================================
; sistema/tempo.asm
;==============================================================

default rel

%include "constantes.inc"
%include "estruturas.inc"

extern HorarioSistema
extern DataSistema

extern TextoHorarioSistema
extern TextoDataSistema

extern TempoEpoch
extern PonteiroTM

extern time
extern localtime
extern strftime

global AtualizarHorarioSistema
global AtualizarDataSistema
global AtualizarHorarioDataSistema

section .data

FormatoHora db "%H:%M:%S",0
FormatoData db "%d/%m/%Y",0

section .text

;==============================================================
; AtualizarHorarioSistema
;==============================================================
AtualizarHorarioSistema:

    push rbp
    mov rbp, rsp

    ; time(&TempoEpoch)
    lea rdi, [TempoEpoch]
    call time

    ; tm = localtime(&TempoEpoch)
    lea rdi, [TempoEpoch]
    call localtime
    mov [PonteiroTM], rax

    ; strftime(TextoHorarioSistema)
    lea rdi, [TextoHorarioSistema]
    mov rsi, 9
    lea rdx, [FormatoHora]
    mov rcx, [PonteiroTM]
    call strftime

    pop rbp
    ret


;==============================================================
; AtualizarDataSistema
;==============================================================
AtualizarDataSistema:

    push rbp
    mov rbp, rsp

    ; reutiliza o mesmo time já calculado
    ; (assume que AtualizarHorarioSistema já foi chamado)

    mov rax, [PonteiroTM]

    ; strftime(TextoDataSistema)
    lea rdi, [TextoDataSistema]
    mov rsi, 11
    lea rdx, [FormatoData]
    mov rcx, rax
    call strftime

    pop rbp
    ret


;==============================================================
; AtualizarHorarioDataSistema
;==============================================================
AtualizarHorarioDataSistema:

    call AtualizarHorarioSistema
    call AtualizarDataSistema
    ret

;==============================================================
; Funções de manipulação de TEMPO
;==============================================================

section .text

global IncrementarTempo
global DecrementarTempo
global ZerarTempo
global CopiarTempo
global CompararTempo

;==============================================================
; IncrementarTempo(TEMPO *t)
; RDI = ponteiro TEMPO
;==============================================================
IncrementarTempo:

    inc byte [rdi + TEMPO.segundo]

    cmp byte [rdi + TEMPO.segundo], 60
    jl .end

    mov byte [rdi + TEMPO.segundo], 0
    inc byte [rdi + TEMPO.minuto]

    cmp byte [rdi + TEMPO.minuto], 60
    jl .end

    mov byte [rdi + TEMPO.minuto], 0
    inc byte [rdi + TEMPO.hora]

    cmp byte [rdi + TEMPO.hora], 24
    jl .end

    mov byte [rdi + TEMPO.hora], 0

.end:
    ret


;==============================================================
; DecrementarTempo(TEMPO *t)
;==============================================================
DecrementarTempo:

    cmp byte [rdi + TEMPO.segundo], 0
    jne .dec_sec

    cmp byte [rdi + TEMPO.minuto], 0
    jne .dec_min

    cmp byte [rdi + TEMPO.hora], 0
    je .end

    dec byte [rdi + TEMPO.hora]
    mov byte [rdi + TEMPO.minuto], 59
    mov byte [rdi + TEMPO.segundo], 59
    ret

.dec_min:
    dec byte [rdi + TEMPO.minuto]
    mov byte [rdi + TEMPO.segundo], 59
    ret

.dec_sec:
    dec byte [rdi + TEMPO.segundo]

.end:
    ret


;==============================================================
; ZerarTempo(TEMPO *t)
;==============================================================
ZerarTempo:

    mov byte [rdi + TEMPO.hora], 0
    mov byte [rdi + TEMPO.minuto], 0
    mov byte [rdi + TEMPO.segundo], 0
    ret


;==============================================================
; CopiarTempo(dest, src)
; RDI = dest
; RSI = src
;==============================================================
CopiarTempo:

    mov al, [rsi + TEMPO.hora]
    mov [rdi + TEMPO.hora], al

    mov al, [rsi + TEMPO.minuto]
    mov [rdi + TEMPO.minuto], al

    mov al, [rsi + TEMPO.segundo]
    mov [rdi + TEMPO.segundo], al

    ret


;==============================================================
; CompararTempo(a, b)
; RDI = a
; RSI = b
;
; retorna:
;  0 = iguais
;  1 = a > b
; -1 = a < b
;==============================================================
CompararTempo:

    mov al, [rdi + TEMPO.hora]
    cmp al, [rsi + TEMPO.hora]
    ja .greater
    jb .less

    mov al, [rdi + TEMPO.minuto]
    cmp al, [rsi + TEMPO.minuto]
    ja .greater
    jb .less

    mov al, [rdi + TEMPO.segundo]
    cmp al, [rsi + TEMPO.segundo]
    ja .greater
    jb .less

    mov rax, 0
    ret

.greater:
    mov rax, 1
    ret

.less:
    mov rax, -1
    ret

;==============================================================
; Conversões para texto
;==============================================================

section .data

NumStr db "00",0

section .text

global TempoParaTexto
global DataParaTexto

;==============================================================
; TempoParaTexto(TEMPO *t, char *out)
; RDI = TEMPO*
; RSI = buffer "HH:MM:SS"
;==============================================================
TempoParaTexto:

    ; HH
    mov al, [rdi + TEMPO.hora]
    call .to2digits
    mov [rsi], ax

    mov byte [rsi+2], ':'

    ; MM
    mov al, [rdi + TEMPO.minuto]
    call .to2digits
    mov [rsi+3], ax

    mov byte [rsi+5], ':'

    ; SS
    mov al, [rdi + TEMPO.segundo]
    call .to2digits
    mov [rsi+6], ax

    mov byte [rsi+8], 0
    ret


;--------------------------------------------------------------
; converte AL (0-99) em ASCII no AX
;--------------------------------------------------------------
.to2digits:

    xor ah, ah
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov ah, al
    mov al, ah
    ret


;==============================================================
; DataParaTexto(DATA *d, char *out)
; RDI = DATA*
; RSI = buffer "DD/MM/AAAA"
;==============================================================
DataParaTexto:

    ; DD
    mov al, [rdi + DATA.dia]
    call .to2digits_data
    mov [rsi], ax

    mov byte [rsi+2], '/'

    ; MM
    mov al, [rdi + DATA.mes]
    call .to2digits_data
    mov [rsi+3], ax

    mov byte [rsi+5], '/'

    ; AAAA (16 bits já vem pronto)
    mov ax, [rdi + DATA.ano]

    mov bx, 100
    xor dx, dx
    div bx

    add ax, '00'
    add dx, '00'

    mov [rsi+6], ax
    mov [rsi+8], dx

    mov byte [rsi+10], 0
    ret


;--------------------------------------------------------------
; helper 2 dígitos
;--------------------------------------------------------------
.to2digits_data:

    xor ah, ah
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov ah, al
    mov al, ah
    ret

;==============================================================
; Delays (usando libc -> usleep)
;==============================================================

section .text

extern usleep

global Esperar100ms
global Esperar250ms
global Esperar500ms
global Esperar1Segundo

;==============================================================
; Esperar100ms
;==============================================================
Esperar100ms:

    mov rdi, 100000     ; 100 ms = 100.000 us
    call usleep
    ret


;==============================================================
; Esperar250ms
;==============================================================
Esperar250ms:

    mov rdi, 250000
    call usleep
    ret


;==============================================================
; Esperar500ms
;==============================================================
Esperar500ms:

    mov rdi, 500000
    call usleep
    ret


;==============================================================
; Esperar1Segundo
;==============================================================
Esperar1Segundo:

    mov rdi, 1000000
    call usleep
    ret