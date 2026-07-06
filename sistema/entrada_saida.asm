;==============================================================
; sistema/entrada_saida.asm
;
; Funções básicas de I/O no terminal
;==============================================================

default rel

section .text

global ImprimirString
global ImprimirChar
global ImprimirNumero

extern write

;==============================================================
; ImprimirString(char *str)
; RDI = ponteiro string (null-terminated)
;==============================================================
ImprimirString:

    push rbx

    mov rbx, rdi        ; salva início da string

    xor rcx, rcx

.conta:
    cmp byte [rdi + rcx], 0
    je .print
    inc rcx
    jmp .conta

.print:
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, rbx        ; string
    mov rdx, rcx        ; tamanho
    syscall

    pop rbx
    ret


;==============================================================
; ImprimirChar(char c)
; RDI = char (em al)
;==============================================================
ImprimirChar:

    sub rsp, 1
    mov [rsp], dil

    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall

    add rsp, 1
    ret


;==============================================================
; ImprimirNumero(int n)  (simples, decimal)
; RDI = número
;==============================================================
ImprimirNumero:

    push rbx
    push r12

    mov rax, rdi
    mov rbx, 10
    mov r12, rsp

    sub rsp, 32
    mov rsi, rsp
    add rsi, 31
    mov byte [rsi], 0

.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    test rax, rax
    jnz .loop

    mov rdi, rsi
    call ImprimirString

    add rsp, 32

    pop r12
    pop rbx
    ret