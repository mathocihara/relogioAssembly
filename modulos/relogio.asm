default rel

global AjustarHora

extern ImprimirString
extern LerTecla
extern LimparTela

section .data

hora        db 0
minuto      db 0
segundo     db 0

horaTemp    db 0
minutoTemp  db 0
segundoTemp db 0

;--------------- Mensagens -------------------------------

msgHora db "Digite a hora (00-23): ",10
tamMsgHora equ $-msgHora

msgMinuto db "Digite o minuto (00-59): ",10
tamMsgMinuto equ $-msgMinuto

msgSegundo db "Digite o segundo (00-59): ",10
tamMsgSegundo equ $-msgSegundo

msgErro db "Valor invalido!",10
tamMsgErro equ $-msgErro

msgConfirmado db "Horario configurado:",10
tamMsgConfirmado equ $-msgConfirmado

msgPressione db 10,"Pressione qualquer tecla para voltar...",10
tamMsgPressione equ $-msgPressione

section .bss
bufferEntrada resb 3
bufferHorario resb 8

section .text

;=========================================================
; Lê um número de até 2 dígitos e retorna em AL
; Ignora ENTER inicial herdado do menu
;=========================================================
LerNumero:
    xor r8, r8                  ; índice do buffer = 0

.ler:
    call LerTecla

    cmp al, 10                  ; ENTER
    je .converter

    cmp al, '0'
    jb .ler                     ; ignora abaixo de '0'

    cmp al, '9'
    ja .ler                     ; ignora acima de '9'

    cmp r8, 2
    je .ler                     ; no máximo 2 dígitos

    mov [bufferEntrada + r8], al
    inc r8
    jmp .ler

.converter:
    ; Se ENTER chegou antes de qualquer dígito,
    ; ignora e continua esperando número.
    cmp r8, 0
    je .ler

    cmp r8, 1
    je .umDigito

    ; Dois dígitos: (d1 * 10) + d2
    movzx eax, byte [bufferEntrada]
    sub eax, '0'
    imul eax, eax, 10

    movzx edx, byte [bufferEntrada + 1]
    sub edx, '0'

    add eax, edx
    ret

.umDigito:
    movzx eax, byte [bufferEntrada]
    sub eax, '0'
    ret


;=========================================================
; Converte AL (0..99) em 2 dígitos ASCII no endereço RSI
; Ex.: AL=14 -> [RSI]='1' [RSI+1]='4'
;=========================================================
ConverterByteParaAscii2:
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
; Monta bufferHorario = HH:MM:SS usando hora/minuto/segundo
;=========================================================
MontarHorarioBuffer:

    ; hora -> bufferHorario[0..1]
    mov al, [hora]
    mov rsi, bufferHorario
    call ConverterByteParaAscii2

    mov byte [bufferHorario+2], ':'

    ; minuto -> bufferHorario[3..4]
    mov al, [minuto]
    mov rsi, bufferHorario+3
    call ConverterByteParaAscii2

    mov byte [bufferHorario+5], ':'

    ; segundo -> bufferHorario[6..7]
    mov al, [segundo]
    mov rsi, bufferHorario+6
    call ConverterByteParaAscii2

    ret


;=========================================================
; Ajustar Hora
;=========================================================
AjustarHora:

    ;=========================
    ; LER HORA
    ;=========================
    call LimparTela
    mov rsi, msgHora
    mov rdx, tamMsgHora
    call ImprimirString

    call LerNumero
    mov [horaTemp], al

    ;=========================
    ; LER MINUTO
    ;=========================
    call LimparTela
    mov rsi, msgMinuto
    mov rdx, tamMsgMinuto
    call ImprimirString

    call LerNumero
    mov [minutoTemp], al

    ;=========================
    ; LER SEGUNDO
    ;=========================
    call LimparTela
    mov rsi, msgSegundo
    mov rdx, tamMsgSegundo
    call ImprimirString

    call LerNumero
    mov [segundoTemp], al

    ;=========================
    ; VALIDAR HORA
    ;=========================
    mov al, [horaTemp]
    cmp al, 23
    ja .erro

    mov al, [minutoTemp]
    cmp al, 59
    ja .erro

    mov al, [segundoTemp]
    cmp al, 59
    ja .erro

    ;=========================
    ; COPIAR PARA O HORÁRIO OFICIAL
    ;=========================
    mov al, [horaTemp]
    mov [hora], al

    mov al, [minutoTemp]
    mov [minuto], al

    mov al, [segundoTemp]
    mov [segundo], al

    ;=========================
    ; MONTAR E MOSTRAR HORÁRIO
    ;=========================
    call MontarHorarioBuffer

    call LimparTela

    mov rsi, msgConfirmado
    mov rdx, tamMsgConfirmado
    call ImprimirString

    mov rsi, bufferHorario
    mov rdx, 8
    call ImprimirString

    mov rsi, msgPressione
    mov rdx, tamMsgPressione
    call ImprimirString

    call LerTecla
    ret

.erro:
    call LimparTela
    mov rsi, msgErro
    mov rdx, tamMsgErro
    call ImprimirString

    mov rsi, msgPressione
    mov rdx, tamMsgPressione
    call ImprimirString

    call LerTecla
    ret