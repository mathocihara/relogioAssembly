extern segundo

section .data

tempoEspera:
    dq 1      ; segundos
    dq 0      ; nanossegundos


section .text

global IncrementarSegundo
global EsperarUmSegundo


;=================================
; EsperarUmSegundo()
; Aguarda 1 segundo
;=================================

EsperarUmSegundo:

    mov rax, 35             ; syscall nanosleep
    mov rdi, tempoEspera    ; struct timespec
    mov rsi, 0              ; restante (não utilizado)
    syscall

    ret

;=================================
; IncrementarSegundo()
;=================================

IncrementarSegundo:

    inc byte [segundo]

    cmp byte [segundo], 60
    jl .fim

    mov byte [segundo], 0

.fim:
    ret
