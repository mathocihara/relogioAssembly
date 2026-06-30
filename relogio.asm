global TelaRelogio
extern ImprimirString
extern hora
extern minuto
extern segundo
extern dia
extern mes
extern ano
extern BinarioParaASCII

section .data



titulo db "===== RELOGIO DIGITAL =====",10
tamTitulo equ $ - titulo

textoHora db "Hora: "
tamTextoHora equ $ - textoHora

bufferHora db "00:00:00",10
tamBufferHora equ $ - bufferHora

textoData db "Data: "
tamTextoData equ $ - textoData

bufferData db "00/00/0000",10
tamBufferData equ $ - bufferData

section .text

TelaRelogio:

    mov rsi, titulo
    mov rdx, tamTitulo
    call ImprimirString

    mov rsi, textoHora
    mov rdx, tamTextoHora
    call ImprimirString

    call ConverterHora

    mov rsi, bufferHora
    mov rdx, tamBufferHora
    call ImprimirString

    mov rsi, textoData
    mov rdx, tamTextoData
    call ImprimirString

    call ConverterData

    mov rsi, bufferData
    mov rdx, tamBufferData
    call ImprimirString

ret

ConverterHora:
    mov al, [hora]
    lea rsi, [bufferHora]
    call BinarioParaASCII

    mov al, [minuto]
    lea rsi, [bufferHora + 3]
    call BinarioParaASCII

    mov al, [segundo]
    lea rsi, [bufferHora + 6]
    call BinarioParaASCII
    ret
ConverterData:
    mov al, [dia]
    lea rsi, [bufferData]
    call BinarioParaASCII

    mov al, [mes]
    lea rsi, [bufferData + 3]
    call BinarioParaASCII

    mov byte [bufferData + 6], '2'
    mov byte [bufferData + 7], '0'

    mov ax, [ano]
    sub ax, 2000
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov [bufferData + 8], al
    mov [bufferData + 9], ah
    ret
