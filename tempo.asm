extern segundo
extern minuto
extern hora

section .data

tempoEspera:
    dq 1      ; segundos
    dq 0      ; nanossegundos


section .text

global IncrementarSegundo
global EsperarUmSegundo
global IncrementarMinuto
global IncrementarHora

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
    jl .fimSegundo

    mov byte [segundo], 0

    call IncrementarMinuto

.fimSegundo:
   ret

IncrementarMinuto:
    inc byte [minuto]

    cmp byte [minuto], 60
    jl .fimMinuto

    mov byte [minuto], 0

    call IncrementarHora
.fimMinuto:
    ret

IncrementarHora:
   inc byte [hora]

    cmp byte [hora], 24
    jl .fimHora

    mov byte [hora], 0

.fimHora:
    ret
