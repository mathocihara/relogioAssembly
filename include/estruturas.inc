;==============================================================
;
; include/estruturas.inc
;
; Estruturas do projeto
;
;==============================================================

%ifndef ESTRUTURAS_INC
%define ESTRUTURAS_INC

;==============================================================
; TEMPO
;
; Utilizado por:
; - Relógio
; - Cronômetro
; - Temporizador
;==============================================================

struc TEMPO

.hora       resb 1
.minuto     resb 1
.segundo    resb 1
.estado     resb 1

endstruc

;==============================================================
; DATA
;==============================================================

struc DATA

.dia         resb 1
.mes         resb 1
.ano         resw 1

endstruc

;==============================================================
; ALARME
;==============================================================

struc ALARME

.hora        resb 1
.minuto      resb 1
.ativo       resb 1

endstruc

%endif