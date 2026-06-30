 section .data
global estado
global hora 
global minuto 
global segundo 

global dia
global mes
global ano

hora       db 23
minuto     db 59
segundo    db 58


dia        db 22
mes        db 6
ano        dw 2026
; estado do programa: 0 = menu, 1 = relogio, 2 = configuracao
estado     db 0
