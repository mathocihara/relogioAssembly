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

extern MostrarMenuRelogio
extern LerTecla

extern ImprimirString

global RodarRelogio
global AtualizarHorarioSistema
global AtualizarDataSistema
global AtualizarHorarioDataSistema
global IncrementarRelogio
global IncrementarData
global DiasNoMes


section .data
msg_teste_relogio db "TESTE DO RODARRELOGIO",10,0
FormatoHora db "%H:%M:%S",0
FormatoData db "%d/%m/%Y",0

DelaySpec:
    dq 0          ; tv_sec
    dq 0          ; tv_nsec

section .text
;==============================================================
; AtualizarHorarioSistema
; Pega o horário atual do Linux e salva em HorarioSistema
;==============================================================
AtualizarHorarioSistema:
    push rbx

    ; time(&TempoEpoch)
    lea rdi, [TempoEpoch]
    call time

    ; tm = localtime(&TempoEpoch)
    lea rdi, [TempoEpoch]
    call localtime
    mov [PonteiroTM], rax

    ; HorarioSistema.hora = tm_hour
    mov rbx, [PonteiroTM]
    mov eax, dword [rbx + 8]
    mov byte [HorarioSistema + TEMPO.hora], al

    ; HorarioSistema.minuto = tm_min
    mov eax, dword [rbx + 4]
    mov byte [HorarioSistema + TEMPO.minuto], al

    ; HorarioSistema.segundo = tm_sec
    mov eax, dword [rbx + 0]
    mov byte [HorarioSistema + TEMPO.segundo], al

    pop rbx
    ret

;==============================================================
; AtualizarDataSistema
; Usa o tm atual e salva em DataSistema
;==============================================================
AtualizarDataSistema:
    push rbx

    mov rbx, [PonteiroTM]

    ; DataSistema.dia = tm_mday
    mov eax, dword [rbx + 12]
    mov byte [DataSistema + DATA.dia], al

    ; DataSistema.mes = tm_mon + 1
    mov eax, dword [rbx + 16]
    inc eax
    mov byte [DataSistema + DATA.mes], al

    ; DataSistema.ano = tm_year + 1900
    mov eax, dword [rbx + 20]
    add eax, 1900
    mov word [DataSistema + DATA.ano], ax

    pop rbx
    ret


;==============================================================
; AtualizarHorarioDataSistema
; Sincroniza structs com o Linux e gera as strings
;==============================================================
AtualizarHorarioDataSistema:

    call AtualizarHorarioSistema
    call AtualizarDataSistema

    ; HorarioSistema -> TextoHorarioSistema
    mov rdi, HorarioSistema
    mov rsi, TextoHorarioSistema
    call TempoParaTexto

    ; DataSistema -> TextoDataSistema
    mov rdi, DataSistema
    mov rsi, TextoDataSistema
    call DataParaTexto

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
    push rbx

    ; HH
    mov al, [rdi + TEMPO.hora]
    call .to2digits
    mov [rsi], al
    mov [rsi+1], ah

    mov byte [rsi+2], ':'

    ; MM
    mov al, [rdi + TEMPO.minuto]
    call .to2digits
    mov [rsi+3], al
    mov [rsi+4], ah

    mov byte [rsi+5], ':'

    ; SS
    mov al, [rdi + TEMPO.segundo]
    call .to2digits
    mov [rsi+6], al
    mov [rsi+7], ah

    mov byte [rsi+8], 0

    pop rbx
    ret

.to2digits:
    xor ah, ah
    mov bl, 10
    div bl
    add al, '0'
    add ah, '0'
    ret
;==============================================================
; DataParaTexto(DATA *d, char *out)
; RDI = DATA*
; RSI = buffer "DD/MM/AAAA"
;==============================================================
DataParaTexto:
    push rbx

    ; DD
    mov al, [rdi + DATA.dia]
    call .to2digits_data
    mov [rsi], al
    mov [rsi+1], ah

    mov byte [rsi+2], '/'

    ; MM
    mov al, [rdi + DATA.mes]
    call .to2digits_data
    mov [rsi+3], al
    mov [rsi+4], ah

    mov byte [rsi+5], '/'

    ; AAAA
    mov ax, [rdi + DATA.ano]

    ; milhar
    xor dx, dx
    mov bx, 1000
    div bx
    add al, '0'
    mov [rsi+6], al

    ; centena
    mov ax, dx
    xor dx, dx
    mov bx, 100
    div bx
    add al, '0'
    mov [rsi+7], al

    ; dezena
    mov ax, dx
    xor dx, dx
    mov bx, 10
    div bx
    add al, '0'
    mov [rsi+8], al

    ; unidade
    add dl, '0'
    mov [rsi+9], dl

    mov byte [rsi+10], 0

    pop rbx
    ret

.to2digits_data:
    xor ah, ah
    mov bl, 10
    div bl
    add al, '0'
    add ah, '0'
    ret

;==============================================================
; Delays (usando libc -> usleep)
;==============================================================

section .text

;==============================================================
; Delays (usando syscall nanosleep)
;==============================================================

section .text

global Esperar100ms
global Esperar250ms
global Esperar500ms
global Esperar1Segundo

;--------------------------------------------------------------
; _Dormir
; Entrada:
;   RDI = segundos
;   RSI = nanossegundos
;--------------------------------------------------------------
_Dormir:
    mov [DelaySpec], rdi
    mov [DelaySpec + 8], rsi

    mov rax, 35                 ; syscall nanosleep
    lea rdi, [DelaySpec]        ; req
    xor rsi, rsi                ; rem = NULL
    syscall
    ret

;==============================================================
; Esperar100ms
;==============================================================
Esperar100ms:
    xor rdi, rdi
    mov rsi, 100000000          ; 100 ms
    call _Dormir
    ret

;==============================================================
; Esperar250ms
;==============================================================
Esperar250ms:
    xor rdi, rdi
    mov rsi, 250000000          ; 250 ms
    call _Dormir
    ret

;==============================================================
; Esperar500ms
;==============================================================
Esperar500ms:
    xor rdi, rdi
    mov rsi, 500000000          ; 500 ms
    call _Dormir
    ret

;==============================================================
; Esperar1Segundo
;==============================================================
Esperar1Segundo:
    mov rdi, 1                  ; 1 segundo
    xor rsi, rsi
    call _Dormir
    ret

;==============================================================
; DiasNoMes
; Retorna em AL a quantidade de dias do mês atual de DataSistema
;==============================================================
DiasNoMes:
    push rbx

    mov al, [DataSistema + DATA.mes]

    cmp al, 1
    je .d31
    cmp al, 2
    je .fev
    cmp al, 3
    je .d31
    cmp al, 4
    je .d30
    cmp al, 5
    je .d31
    cmp al, 6
    je .d30
    cmp al, 7
    je .d31
    cmp al, 8
    je .d31
    cmp al, 9
    je .d30
    cmp al, 10
    je .d31
    cmp al, 11
    je .d30
    cmp al, 12
    je .d31

    mov al, 31
    jmp .fim

.d30:
    mov al, 30
    jmp .fim

.d31:
    mov al, 31
    jmp .fim

.fev:
    mov al, 28

.fim:
    pop rbx
    ret

;==============================================================
; IncrementarData
; Soma 1 dia em DataSistema
;==============================================================
IncrementarData:
    push rbx

    ; al = quantidade de dias do mês atual
    call DiasNoMes
    mov bl, al

    ; dia++
    inc byte [DataSistema + DATA.dia]

    ; se dia <= dias do mês, termina
    mov al, [DataSistema + DATA.dia]
    cmp al, bl
    jbe .fim

    ; passou do fim do mês -> dia = 1
    mov byte [DataSistema + DATA.dia], 1

    ; mes++
    inc byte [DataSistema + DATA.mes]

    ; se mes <= 12, termina
    cmp byte [DataSistema + DATA.mes], 13
    jne .fim

    ; passou de dezembro -> janeiro do próximo ano
    mov byte [DataSistema + DATA.mes], 1
    inc word [DataSistema + DATA.ano]

.fim:
    pop rbx
    ret

;==============================================================
; IncrementarRelogio
; Soma 1 segundo em HorarioSistema
; Se passar de 23:59:59, vira 00:00:00 e incrementa a data
;==============================================================
IncrementarRelogio:

    ; segundo++
    inc byte [HorarioSistema + TEMPO.segundo]

    ; se segundo < 60, termina
    cmp byte [HorarioSistema + TEMPO.segundo], 60
    jb .fim

    ; segundo = 0
    mov byte [HorarioSistema + TEMPO.segundo], 0

    ; minuto++
    inc byte [HorarioSistema + TEMPO.minuto]

    ; se minuto < 60, termina
    cmp byte [HorarioSistema + TEMPO.minuto], 60
    jb .fim

    ; minuto = 0
    mov byte [HorarioSistema + TEMPO.minuto], 0

    ; hora++
    inc byte [HorarioSistema + TEMPO.hora]

    ; se hora < 24, termina
    cmp byte [HorarioSistema + TEMPO.hora], 24
    jb .fim

    ; virou meia-noite
    mov byte [HorarioSistema + TEMPO.hora], 0
    call IncrementarData

.fim:
    ret

;==============================================================
; RodarRelogio
;
; Responsável por:
; - sincronizar com o Linux ao entrar
; - mostrar a tela do relógio
; - esperar 1 segundo
; - incrementar o relógio interno
; - atualizar as strings
; - sair quando o usuário apertar '0'
;==============================================================
;==============================================================
; RodarRelogio - TESTE MINIMO
;
; Objetivo:
; testar somente a chamada da tela do relógio,
; sem Linux, sem incremento, sem strings.
;==============================================================
RodarRelogio:
    push rbp
    mov rbp, rsp
    sub rsp, 8

    call MostrarMenuRelogio

    add rsp, 8
    pop rbp
    ret

.sair:
    ret