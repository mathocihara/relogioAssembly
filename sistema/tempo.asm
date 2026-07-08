;==============================================================
; sistema/tempo.asm
; Funções genéricas de tempo
;==============================================================

default rel

%include "constantes.inc"
%include "estruturas.inc"

extern usleep

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

section .text

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

DecrementarTempo:
    cmp byte [rdi + TEMPO.hora], 0
    jne .continua
    cmp byte [rdi + TEMPO.minuto], 0
    jne .continua
    cmp byte [rdi + TEMPO.segundo], 0
    je .fim

.continua:
    cmp byte [rdi + TEMPO.segundo], 0
    jne .dec_seg

    mov byte [rdi + TEMPO.segundo], 59

    cmp byte [rdi + TEMPO.minuto], 0
    jne .dec_min

    mov byte [rdi + TEMPO.minuto], 59
    dec byte [rdi + TEMPO.hora]
    jmp .fim

.dec_min:
    dec byte [rdi + TEMPO.minuto]
    jmp .fim

.dec_seg:
    dec byte [rdi + TEMPO.segundo]
.fim:
    ret

ZerarTempo:
    mov byte [rdi + TEMPO.hora], 0
    mov byte [rdi + TEMPO.minuto], 0
    mov byte [rdi + TEMPO.segundo], 0
    mov byte [rdi + TEMPO.estado], 0
    ret

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

    xor eax, eax
    ret

.maior:
    mov eax, 1
    ret

.menor:
    mov eax, -1
    ret

TempoParaTexto:
    push rbx

    ; HH
    movzx eax, byte [rdi + TEMPO.hora]
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [rsi], al
    mov [rsi+1], dl
    mov byte [rsi+2], ':'

    ; MM
    movzx eax, byte [rdi + TEMPO.minuto]
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [rsi+3], al
    mov [rsi+4], dl
    mov byte [rsi+5], ':'

    ; SS
    movzx eax, byte [rdi + TEMPO.segundo]
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [rsi+6], al
    mov [rsi+7], dl

    mov byte [rsi+8], 0

    pop rbx
    ret

DataParaTexto:
    push rbx

    ; DD
    movzx eax, byte [rdi + DATA.dia]
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [rsi], al
    mov [rsi+1], dl
    mov byte [rsi+2], '/'

    ; MM
    movzx eax, byte [rdi + DATA.mes]
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [rsi+3], al
    mov [rsi+4], dl
    mov byte [rsi+5], '/'

    mov byte [rsi+6], '2'
    mov byte [rsi+7], '0'
    mov byte [rsi+8], '0'
    mov byte [rsi+9], '0'
    mov byte [rsi+10], 0

    pop rbx
    ret

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