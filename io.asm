section .data

; Limpa a tela e posiciona o cursor no início
clearScreen db 27,"[2J",27,"[H"
tamClearScreen equ $ - clearScreen

section .text

global LimparTela
global ImprimirString


; ============================================
; LimparTela()
; Limpa a tela do terminal
; ============================================
LimparTela:

    mov rax, 1              ; syscall write
    mov rdi, 1              ; stdout
    mov rsi, clearScreen
    mov rdx, tamClearScreen
    syscall

    ret


; ============================================
; ImprimirString()
;
; Entrada:
; RSI -> endereço da string
; RDX -> tamanho da string
; ============================================
ImprimirString:

    mov rax, 1              ; write
    mov rdi, 1              ; stdout
    syscall

    ret
