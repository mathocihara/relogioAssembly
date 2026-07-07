;==============================================================
; sistema/ansi.asm
;
; Controle de terminal ANSI
;==============================================================

default rel

section .data

; Strings ANSI completas
ansi_cls         db 27, "[2J", 0
ansi_home        db 27, "[H", 0
ansi_hide_cursor db 27, "[?25l", 0
ansi_show_cursor db 27, "[?25h", 0

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
    mov rdi, ansi_cls
    call ImprimirString
    ret

;==============================================================
; CursorHome
;==============================================================
CursorHome:
    mov rdi, ansi_home
    call ImprimirString
    ret

;==============================================================
; EsconderCursor
;==============================================================
EsconderCursor:
    mov rdi, ansi_hide_cursor
    call ImprimirString
    ret

;==============================================================
; MostrarCursor
;==============================================================
MostrarCursor:
    mov rdi, ansi_show_cursor
    call ImprimirString
    ret