global BinarioParaASCII

section .text

BinarioParaASCII:

    push rbx

    xor ah, ah          ; garante estado limpo
    mov bl, 10
    div bl              ; AL = dezenas, AH = unidades

    add al, '0'
    add ah, '0'

    mov [rsi], al
    mov [rsi + 1], ah

    pop rbx
    ret
