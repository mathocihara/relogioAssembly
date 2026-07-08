;==============================================================
; modulos/relogio.asm
; Módulo Relógio - versão com hora/data reais + alarme
;==============================================================

default rel

global ModuloRelogio
global AtualizarHorarioDataSistema

extern LimparTela
extern CursorHome
extern LerTecla
extern ImprimirString
extern Esperar1Segundo

extern TextoHorarioSistema
extern TextoDataSistema
extern TempoEpoch
extern PonteiroTM
extern HorarioSistema

extern VerificarAlarmes

extern time
extern localtime
extern strftime

section .data
titulo1 db "====================================",10,0
titulo2 db "              RELOGIO               ",10,0
titulo3 db "====================================",10,10,0

txtHora   db "Hora: ",0
txtQuebra db 10,0
txtData   db "Data: ",0
txtVoltar db 10,10,"0 - Voltar",10,0

FormatoHora db "%H:%M:%S",0
FormatoData db "%d/%m/%Y",0

section .text

;==============================================================
; AtualizarHorarioDataSistema
; Atualiza:
; - TextoHorarioSistema
; - TextoDataSistema
; - HorarioSistema (hora/minuto/segundo em bytes)
;==============================================================
AtualizarHorarioDataSistema:
    push rbp
    mov rbp, rsp

    ; time(&TempoEpoch)
    lea rdi, [TempoEpoch]
    call time

    ; tm = localtime(&TempoEpoch)
    lea rdi, [TempoEpoch]
    call localtime
    mov [PonteiroTM], rax

    ; strftime(TextoHorarioSistema, 16, "%H:%M:%S", tm)
    lea rdi, [TextoHorarioSistema]
    mov rsi, 16
    lea rdx, [FormatoHora]
    mov rcx, [PonteiroTM]
    call strftime

    ; strftime(TextoDataSistema, 16, "%d/%m/%Y", tm)
    lea rdi, [TextoDataSistema]
    mov rsi, 16
    lea rdx, [FormatoData]
    mov rcx, [PonteiroTM]
    call strftime

    ;----------------------------------------------------------
    ; Atualiza HorarioSistema em formato numérico:
    ; byte 0 = hora
    ; byte 1 = minuto
    ; byte 2 = segundo
    ;----------------------------------------------------------
    mov rax, [PonteiroTM]

    mov edx, [rax + 8]                  ; hora
    mov byte [HorarioSistema + 0], dl

    mov edx, [rax + 4]                  ; minuto
    mov byte [HorarioSistema + 1], dl

    mov edx, [rax + 0]                  ; segundo
    mov byte [HorarioSistema + 2], dl

    mov byte [HorarioSistema + 3], 0

    pop rbp
    ret


;==============================================================
; ModuloRelogio
;==============================================================
ModuloRelogio:

.loop:
    ; atualiza relógio real
    call AtualizarHorarioDataSistema

    ; verifica se algum alarme disparou
    call VerificarAlarmes

    ; desenha tela
    call LimparTela
    call CursorHome

    mov rdi, titulo1
    call ImprimirString

    mov rdi, titulo2
    call ImprimirString

    mov rdi, titulo3
    call ImprimirString

    mov rdi, txtHora
    call ImprimirString

    mov rdi, TextoHorarioSistema
    call ImprimirString

    mov rdi, txtQuebra
    call ImprimirString

    mov rdi, txtData
    call ImprimirString

    mov rdi, TextoDataSistema
    call ImprimirString

    mov rdi, txtVoltar
    call ImprimirString

    call Esperar1Segundo

    call LerTecla
    cmp al, '0'
    je .sair

    jmp .loop

.sair:
    ret