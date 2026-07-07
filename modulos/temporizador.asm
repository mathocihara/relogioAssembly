default rel

global AjustarTemporizador
global MontarTemporizadorBuffer
global bufferTemporizador

extern ImprimirString
extern LerTecla
extern LimparTela

section .data

tempHora        db 0
tempMinuto      db 0
tempSegundo     db 0

tempHoraTemp    db 0
tempMinutoTemp  db 0
tempSegundoTemp db 0

;--------------- Mensagens -------------------------------

msgHoraTemp db "Digite a hora do temporizador (00-99): ",10
tamMsgHoraTemp equ $-msgHoraTemp

msgMinutoTemp db "Digite o minuto do temporizador (00-59): ",10
tamMsgMinutoTemp equ $-msgMinutoTemp

msgSegundoTemp db "Digite o segundo do temporizador (00-59): ",10
tamMsgSegundoTemp equ $-msgSegundoTemp

msgErroTemp db "Valor invalido!",10
tamMsgErroTemp equ $-msgErroTemp

msgConfirmadoTemp db "Temporizador configurado:",10
tamMsgConfirmadoTemp equ $-msgConfirmadoTemp

msgPressioneTemp db 10,"Pressione qualquer tecla para voltar...",10
tamMsgPressioneTemp equ $-msgPressioneTemp

section .bss
bufferEntradaTemp resb 3
bufferTemporizador resb 8

section .text

;=========================================================
; Lê um número de até 2 dígitos e retorna em AL
; Ignora ENTER inicial herdado do menu
;=========================================================
LerNumeroTemporizador:
    xor r8, r8

.ler:
    call LerTecla

    cmp al, 10
    je .converter

    cmp al, '0'
    jb .ler

    cmp al, '9'
    ja .ler

    cmp r8, 2
    je .ler

    mov [bufferEntradaTemp + r8], al
    inc r8
    jmp .ler

.converter:
    cmp r8, 0
    je .ler

    cmp r8, 1
    je .umDigito

    ; Dois dígitos: (d1 * 10) + d2
    movzx eax, byte [bufferEntradaTemp]
    sub eax, '0'
    imul eax, eax, 10

    movzx edx, byte [bufferEntradaTemp + 1]
    sub edx, '0'

    add eax, edx
    ret

.umDigito:
    movzx eax, byte [bufferEntradaTemp]
    sub eax, '0'
    ret


;=========================================================
; Converte AL (0..99) em 2 dígitos ASCII no endereço RSI
;=========================================================
ConverterByteParaAscii2Temp:
    xor ah, ah
    mov bl, 10
    div bl                      ; AL = dezena, AH = unidade

    add al, '0'
    mov [rsi], al

    mov al, ah
    add al, '0'
    mov [rsi+1], al
    ret


;=========================================================
; Monta bufferTemporizador = HH:MM:SS
;=========================================================
MontarTemporizadorBuffer:

    ; hora -> bufferTemporizador[0..1]
    mov al, [tempHora]
    mov rsi, bufferTemporizador
    call ConverterByteParaAscii2Temp

    mov byte [bufferTemporizador+2], ':'

    ; minuto -> bufferTemporizador[3..4]
    mov al, [tempMinuto]
    mov rsi, bufferTemporizador+3
    call ConverterByteParaAscii2Temp

    mov byte [bufferTemporizador+5], ':'

    ; segundo -> bufferTemporizador[6..7]
    mov al, [tempSegundo]
    mov rsi, bufferTemporizador+6
    call ConverterByteParaAscii2Temp

    ret


;=========================================================
; Ajustar Temporizador
;=========================================================
AjustarTemporizador:

    ;=========================
    ; LER HORA
    ;=========================
    call LimparTela
    mov rsi, msgHoraTemp
    mov rdx, tamMsgHoraTemp
    call ImprimirString

    call LerNumeroTemporizador
    mov [tempHoraTemp], al

    ;=========================
    ; LER MINUTO
    ;=========================
    call LimparTela
    mov rsi, msgMinutoTemp
    mov rdx, tamMsgMinutoTemp
    call ImprimirString

    call LerNumeroTemporizador
    mov [tempMinutoTemp], al

    ;=========================
    ; LER SEGUNDO
    ;=========================
    call LimparTela
    mov rsi, msgSegundoTemp
    mov rdx, tamMsgSegundoTemp
    call ImprimirString

    call LerNumeroTemporizador
    mov [tempSegundoTemp], al

    ;=========================
    ; VALIDAR
    ;=========================
    ; Hora do temporizador: 0..99
    mov al, [tempHoraTemp]
    cmp al, 99
    ja .erro

    ; Minuto: 0..59
    mov al, [tempMinutoTemp]
    cmp al, 59
    ja .erro

    ; Segundo: 0..59
    mov al, [tempSegundoTemp]
    cmp al, 59
    ja .erro

    ;=========================
    ; COPIAR PARA O TEMPORIZADOR OFICIAL
    ;=========================
    mov al, [tempHoraTemp]
    mov [tempHora], al

    mov al, [tempMinutoTemp]
    mov [tempMinuto], al

    mov al, [tempSegundoTemp]
    mov [tempSegundo], al

    ;=========================
    ; MONTAR E MOSTRAR TEMPORIZADOR
    ;=========================
    call MontarTemporizadorBuffer

    call LimparTela

    mov rsi, msgConfirmadoTemp
    mov rdx, tamMsgConfirmadoTemp
    call ImprimirString

    mov rsi, bufferTemporizador
    mov rdx, 8
    call ImprimirString

    mov rsi, msgPressioneTemp
    mov rdx, tamMsgPressioneTemp
    call ImprimirString

    call LerTecla
    ret

.erro:
    call LimparTela

    mov rsi, msgErroTemp
    mov rdx, tamMsgErroTemp
    call ImprimirString

    mov rsi, msgPressioneTemp
    mov rdx, tamMsgPressioneTemp
    call ImprimirString

    call LerTecla
    ret