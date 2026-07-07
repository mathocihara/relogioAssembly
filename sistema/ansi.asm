;==============================================================
; sistema/ansi.asm
;
; Controle de terminal ANSI
;==============================================================

default rel

section .data

; ESC = 27
ESC db 27

cls db "[2J",0
home db "[H",0

hide_cursor db "[?25l",0
show_cursor db "[?25h",0

section .text

global LimparTela
global CursorHome
global EsconderCursor
global MostrarCursor

extern ImprimirString


;==============================================================
; LimparTela
;==============================================================
LimparTela:

    ; ESC + [2J
    mov rdi, ESC
    call ImprimirString

    mov rdi, cls
    call ImprimirString

    ret


;==============================================================
; CursorHome
;==============================================================
CursorHome:

    ; ESC + [H
    mov rdi, ESC
    call ImprimirString

    mov rdi, home
    call ImprimirString

    ret


;==============================================================
; EsconderCursor
;==============================================================
EsconderCursor:

    mov rdi, ESC
    call ImprimirString

    mov rdi, hide_cursor
    call ImprimirString

    ret


;==============================================================
; MostrarCursor
;==============================================================
MostrarCursor:

    mov rdi, ESC
    call ImprimirString

    mov rdi, show_cursor
    call ImprimirString

    ret