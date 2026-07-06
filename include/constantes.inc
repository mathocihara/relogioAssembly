;==============================================================
;
; constantes.inc
;
; Constantes globais do projeto
;
;==============================================================

%ifndef CONSTANTES_INC
%define CONSTANTES_INC

;==============================================================
; ASCII
;==============================================================

%define ASCII_NULL            0
%define ASCII_ENTER          10
%define ASCII_ESC            27
%define ASCII_BACKSPACE       8
%define ASCII_DELETE        127
%define ASCII_ESPACO         32

%define ASCII_0              '0'
%define ASCII_1              '1'
%define ASCII_2              '2'
%define ASCII_3              '3'
%define ASCII_4              '4'
%define ASCII_5              '5'
%define ASCII_6              '6'
%define ASCII_7              '7'
%define ASCII_8              '8'
%define ASCII_9              '9'

;==============================================================
; Tamanhos
;==============================================================

%define MAX_STRING          256

%define MAX_ALARMES          20

;==============================================================
; Estados
;==============================================================

%define DESLIGADO             0
%define LIGADO                1

%define PARADO                0
%define EXECUTANDO            1
%define PAUSADO               2

;==============================================================
; Limites do relógio
;==============================================================

%define SEGUNDO_MIN           0
%define SEGUNDO_MAX          59

%define MINUTO_MIN            0
%define MINUTO_MAX           59

%define HORA_MIN              0
%define HORA_MAX             23

;==============================================================
; ANSI
;==============================================================

%define ANSI_ESC             27

;==============================================================
; Cores do texto
;==============================================================

%define COR_PRETO            30
%define COR_VERMELHO         31
%define COR_VERDE            32
%define COR_AMARELO          33
%define COR_AZUL             34
%define COR_MAGENTA          35
%define COR_CIANO            36
%define COR_BRANCO           37

;==============================================================
; Cores do fundo
;==============================================================

%define FUNDO_PRETO          40
%define FUNDO_VERMELHO       41
%define FUNDO_VERDE          42
%define FUNDO_AMARELO        43
%define FUNDO_AZUL           44
%define FUNDO_MAGENTA        45
%define FUNDO_CIANO          46
%define FUNDO_BRANCO         47

%endif