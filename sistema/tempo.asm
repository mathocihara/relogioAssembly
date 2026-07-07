;==============================================================
; sistema/tempo.asm
;==============================================================

default rel

%include "constantes.inc"
%include "estruturas.inc"

extern TextoHorarioSistema
extern TextoDataSistema

extern time
extern localtime
extern strftime
extern usleep

global AtualizarHorarioSistema
global AtualizarDataSistema
global AtualizarHorarioDataSistema

global IncrementarTempo
global DecrementarTempo
global ZerarTempo
global CopiarTempo
global CompararTempo
global TempoParaTexto
global DataParaTexto

global Esperar100ms
global Esperar250ms
global Esperar500ms
global Esperar1Segundo

section .data
FormatoHora db "%H:%M:%S",0
FormatoData db "%d/%m/%Y",0

section .bss
tempo_epoch  resq 1
ponteiro_tm  resq 1

section .text

;==============================================================
; AtualizarHorarioSistema
;==============================================================
AtualizarHorarioSistema:
    sub rsp, 8

    ; time(&tempo_epoch)
    lea rdi, [tempo_epoch]
    call time

    ; tm = localtime(&tempo_epoch)
    lea rdi, [tempo_epoch]
    call localtime
    mov [ponteiro_tm], rax

    ; strftime(TextoHorarioSistema, 16, "%H:%M:%S", tm)
    lea rdi, [TextoHorarioSistema]
    mov rsi, 16
    lea rdx, [FormatoHora]
    mov rcx, [ponteiro_tm]
    call strftime

    add rsp, 8
    ret

;==============================================================
; AtualizarDataSistema
;==============================================================
AtualizarDataSistema:
    sub rsp, 8

    ; strftime(TextoDataSistema, 16, "%d/%m/%Y", tm)
    lea rdi, [TextoDataSistema]
    mov rsi, 16
    lea rdx, [FormatoData]
    mov rcx, [ponteiro_tm]
    call strftime

    add rsp, 8
    ret

;==============================================================
; AtualizarHorarioDataSistema
;==============================================================
AtualizarHorarioDataSistema:
    call AtualizarHorarioSistema
    call AtualizarDataSistema
    ret

;==============================================================
; IncrementarTempo(TEMPO *t)
; RDI = ponteiro para TEMPO
;==============================================================
IncrementarTempo:
    inc byte [rdi + TEMPO.segundo]

    cmp byte [rdi + TEMPO.segundo], 60
    jl .fim

    mov byte [rdi + TEMPO.segundo], 0
    inc byte [rdi + TEMPO.minuto]

    cmp byte [rdi + TEMPO.minuto], 60
    jl .fim

    mov byte [rdi + TEMPO.minuto], 0
    inc byte [rdi + TEMPO.hora]

    cmp byte [rdi + TEMPO.hora], 24
    jl .fim

    mov byte [rdi + TEMPO.hora], 0

.fim:
    ret

;==============================================================
; DecrementarTempo(TEMPO *t)
;==============================================================
DecrementarTempo:
    cmp byte [rdi + TEMPO.hora], 0
    jne .continua
    cmp byte [rdi + TEMPO.minuto], 0
    jne .continua
    cmp byte [rdi + TEMPO.segundo], 0
    jne .continua
    ret

.continua:
    cmp byte [rdi + TEMPO.segundo], 0
    jne .dec_segundo

    mov byte [rdi + TEMPO.segundo], 59

    cmp byte [rdi + TEMPO.minuto], 0
    jne .dec_minuto

    mov byte [rdi + TEMPO.minuto], 59
    dec byte [rdi + TEMPO.hora]
    ret

.dec_minuto:
    dec byte [rdi + TEMPO.minuto]
    ret

.dec_segundo:
    dec byte [rdi + TEMPO.segundo]
    ret

;==============================================================
; ZerarTempo(TEMPO *t)
;==============================================================
ZerarTempo:
    mov byte [rdi + TEMPO.hora], 0
    mov byte [rdi + TEMPO.minuto], 0
    mov byte [rdi + TEMPO.segundo], 0
    mov byte [rdi + TEMPO.estado], 0
    ret

;==============================================================
; CopiarTempo(dest, src)
; RDI = destino
; RSI = origem
;==============================================================
CopiarTempo:
    mov al, [rsi + TEMPO.hora]
    mov [rdi + TEMPO.hora], al

    mov al, [rsi + TEMPO.minuto]
    mov [rdi + TEMPO.minuto], al

    mov al, [rsi + TEMPO.segundo]
    mov [rdi + TEMPO.segundo], al

    mov al, [rsi + TEMPO.estado]
    mov [rdi + TEMPO.estado], al
    ret

;==============================================================
; CompararTempo(a, b)
; RDI = a
; RSI = b
; retorna:
;   0  -> iguais
;   1  -> a > b
;  -1  -> a < b
;==============================================================
CompararTempo:
    mov al, [rdi + TEMPO.hora]
    cmp al, [rsi + TEMPO.hora]
    ja .maior
    jb .menor

    mov al, [rdi + TEMPO.minuto]
    cmp al, [rsi + TEMPO.minuto]
    ja .maior
    jb .menor

    mov al, [rdi + TEMPO.segundo]
    cmp al, [rsi + TEMPO.segundo]
    ja .maior
    jb .menor

    xor rax, rax
    ret

.maior:
    mov rax, 1
    ret

.menor:
    mov rax, -1
    ret

;==============================================================
; TempoParaTexto(TEMPO *t, char *out)
; RDI = TEMPO*
; RSI = buffer "HH:MM:SS"
;==============================================================
TempoParaTexto:
    ; hora
    movzx eax, byte [rdi + TEMPO.hora]
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [rsi], al
    mov [rsi+1], dl

    mov byte [rsi+2], ':'

    ; minuto
    movzx eax, byte [rdi + TEMPO.minuto]
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [rsi+3], al
    mov [rsi+4], dl

    mov byte [rsi+5], ':'

    ; segundo
    movzx eax, byte [rdi + TEMPO.segundo]
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [rsi+6], al
    mov [rsi+7], dl

    mov byte [rsi+8], 0
    ret

;==============================================================
; DataParaTexto(DATA *d, char *out)
; RDI = DATA*
; RSI = buffer "DD/MM/AAAA"
;==============================================================
DataParaTexto:
    ; dia
    movzx eax, byte [rdi + DATA.dia]
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [rsi], al
    mov [rsi+1], dl

    mov byte [rsi+2], '/'

    ; mes
    movzx eax, byte [rdi + DATA.mes]
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [rsi+3], al
    mov [rsi+4], dl

    mov byte [rsi+5], '/'

    ; ano
    mov ax, [rdi + DATA.ano]
    mov bx, 1000
    xor dx, dx
    div bx
    add al, '0'
    mov [rsi+6], al

    mov ax, dx
    mov bx, 100
    xor dx, dx
    div bx
    add al, '0'
    mov [rsi+7], al

    mov ax, dx
    mov bx, 10
    xor dx, dx
    div bx
    add al, '0'
    add dl, '0'
    mov [rsi+8], al
    mov [rsi+9], dl

    mov byte [rsi+10], 0
    ret

;==============================================================
; Delays
;==============================================================
Esperar100ms:
    sub rsp, 8
    mov rdi, 100000
    call usleep
    add rsp, 8
    ret

Esperar250ms:
    sub rsp, 8
    mov rdi, 250000
    call usleep
    add rsp, 8
    ret

Esperar500ms:
    sub rsp, 8
    mov rdi, 500000
    call usleep
    add rsp, 8
    ret

Esperar1Segundo:
    sub rsp, 8
    mov rdi, 1000000
    call usleep
    add rsp, 8
    ret