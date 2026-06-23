extern ImprimirString

extern hora
extern minuto
extern segundo


section .data

titulo db "===== RELOGIO DIGITAL =====",10
tamTitulo equ $ - titulo

textoHora db "Hora: "
tamTextoHora equ $ - textoHora

bufferHora db "00:00:00",10
tamBufferHora equ $ - bufferHora


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


    ; Imprime HH:MM:SS
    mov rsi, bufferHora
    mov rdx, tamBufferHora
    call ImprimirString

ret
