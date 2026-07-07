;==============================================================
; sistema/dados.asm
;==============================================================

default rel

%include "constantes.inc"

;==============================================================
; EXPORTAÇÕES
;==============================================================

global HorarioSistema
global DataSistema
global Cronometro
global Temporizador

global EstadoCronometro
global EstadoTemporizador

global ListaAlarmes
global QuantidadeAlarmes

global TextoHorarioSistema
global TextoCronometro
global TextoTemporizador
global TextoDataSistema

global BufferEntrada
global BufferSaida

global TempoEpoch
global PonteiroTM

section .data

;==============================================================
; HORÁRIO DO SISTEMA
; formato compatível com TEMPO:
; hora, minuto, segundo, estado
;==============================================================
HorarioSistema:
    db 0, 0, 0, 0

;==============================================================
; DATA DO SISTEMA
; formato:
; dia, mes, ano(word)
;==============================================================
DataSistema:
    db 1, 1
    dw 2000

;==============================================================
; CRONÔMETRO
; formato TEMPO:
; hora, minuto, segundo, estado
;==============================================================
Cronometro:
    db 0, 0, 0, 0

;==============================================================
; TEMPORIZADOR
; formato TEMPO:
; hora, minuto, segundo, estado
;==============================================================
Temporizador:
    db 0, 0, 0, 0

;==============================================================
; ESTADOS EXPOSTOS PARA O C
;==============================================================
EstadoCronometro:
    dd 0

EstadoTemporizador:
    dd 0

;==============================================================
; LISTA DE ALARMES
;
; C espera:
; typedef struct {
;     int hora;
;     int minuto;
;     int ativo;
; } Alarme;
;
; então cada alarme precisa ter 12 bytes:
; 4 bytes hora + 4 bytes minuto + 4 bytes ativo
;==============================================================
ListaAlarmes:
    times MAX_ALARMES * 12 db 0

QuantidadeAlarmes:
    dd 0

;==============================================================
; TEXTOS
;==============================================================
TextoHorarioSistema:
    db "00:00:00",0

TextoCronometro:
    db "00:00:00",0

TextoTemporizador:
    db "00:00:00",0

TextoDataSistema:
    db "00/00/0000",0

;==============================================================
; BUFFERS
;==============================================================
BufferEntrada:
    times MAX_STRING db 0

BufferSaida:
    times MAX_STRING db 0

section .bss

TempoEpoch:
    resq 1

PonteiroTM:
    resq 1