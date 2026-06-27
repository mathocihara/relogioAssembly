extern ImprimirString


extern hora
extern minuto
extern segundo
extern dia
extern mes
extern ano

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
global TelaRelogio

TelaRelogio:

    mov rsi, titulo
    mov rdx, tamTitulo
    call ImprimirString

    ; Imprime "Hora: "
    mov rsi, textoHora
    mov rdx, tamTextoHora
    call ImprimirString


    ; Converte hora
    mov al, [hora]
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov [bufferHora], al
    mov [bufferHora + 1], ah

    ; Converte minuto
    mov al, [minuto]
    xor ah, ah
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov [bufferHora + 3], al
    mov [bufferHora + 4], ah

    ; Converte segundo
    mov al, [segundo]
    xor ah, ah
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov [bufferHora + 6], al
    mov [bufferHora + 7], ah


    mov al, [dia]
    xor ah, ah
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov [bufferData], al
    mov [bufferData + 1], ah
    mov al, [mes]
    xor ah, ah
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov [bufferData + 3], al
    mov [bufferData + 4], ah

   mov word [bufferData + 6], '20'

    mov ax, [ano]
    sub ax, 2000

    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov [bufferData + 8], al
    mov [bufferData + 9], ah
    ; Imprime HH:MM:SS
    mov rsi, bufferHora
    mov rdx, tamBufferHora
    call ImprimirString

    mov al, [dia]
    xor ah, ah
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov [bufferData], al
    mov [bufferData + 1], ah

    mov al, [mes]
    xor ah, ah
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov [bufferData + 3], al
    mov [bufferData + 4], ah

    mov word [bufferData + 6], '20'

    mov ax, [ano]
    sub ax, 2000

    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    mov [bufferData + 8], al
    mov [bufferData + 9], ah

    ; Imprime "Data: "
    mov rsi, textoData
    mov rdx, tamTextoData
    call ImprimirString

    ; Imprime DD/MM/AAAA
    mov rsi, bufferData
    mov rdx, tamBufferData
    call ImprimirString
ret
