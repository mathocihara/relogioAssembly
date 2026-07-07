;==============================================================
; sistema/dados.asm (VERSÃO CORRIGIDA FINAL)
;==============================================================

default rel

%include "constantes.inc"

;==============================================================
; EXPORTAÇÕES (ASM → C)
;==============================================================

global HorarioSistema
global DataSistema
global Cronometro
global Temporizador
global Alarmes
global QuantidadeAlarmes

global TextoHorarioSistema
global TextoCronometro
global TextoTemporizador
global TextoDataSistema

global BufferEntrada
global BufferSaida
global TempoEpoch
global PonteiroTM

; 🔥 NOVOS (ERRO QUE VOCÊ TINHA)
global EstadoCronometro
global EstadoTemporizador
global ListaAlarmes

;==============================================================
; DADOS
;==============================================================

section .data

;========================
; HORÁRIO
;========================
HorarioSistema:
db 0,0,0,0

;========================
; DATA
;========================
DataSistema:
db 1,1
dw 2000

;========================
; CRONÔMETRO
;========================
Cronometro:
db 0,0,0,0

;========================
; TEMPORIZADOR
;========================
Temporizador:
db 0,0,0,0

;========================
; ESTADOS (NOVO)
;========================
EstadoCronometro db 0
EstadoTemporizador db 0

;========================
; ALARMES
;========================
Alarmes:
times MAX_ALARMES * 3 db 0

QuantidadeAlarmes db 0

; Lista visível para C (NOVO)
ListaAlarmes:
times MAX_ALARMES * 3 db 0

;========================
; TEXTOS
;========================
TextoHorarioSistema db "00:00:00",0
TextoCronometro     db "00:00:00",0
TextoTemporizador   db "00:00:00",0
TextoDataSistema    db "00/00/0000",0

;========================
; BUFFERS
;========================
BufferEntrada times MAX_STRING db 0
BufferSaida   times MAX_STRING db 0

;========================
; BSS
;========================
section .bss

TempoEpoch  resq 1
PonteiroTM  resq 1