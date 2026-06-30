extern dia
extern mes
extern ano
extern segundo
extern minuto
extern hora

section .data

tempoEspera:
    dq 1      ; segundos
    dq 0      ; nanossegundos


section .text

global IncrementarSegundo
global IncrementarMinuto
global IncrementarHora
global IncrementarData
global EsperarUmSegundo



EsperarUmSegundo:

    mov rax, 35             ; syscall nanosleep
    mov rdi, tempoEspera    ; struct timespec
    mov rsi, 0              ; restante (não utilizado)
    syscall

    ret

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
    
    call IncrementarData

.fimHora:
    ret


IncrementarData:

    inc byte [dia]

    cmp byte [dia], 32
    jl .fimData

    ; Reinicia o dia
    mov byte [dia], 1

    ; Incrementa o mês
    inc byte [mes]

    cmp byte [mes], 13
    jl .fimData

    ; Reinicia o mês
    mov byte [mes], 1

    ; Incrementa o ano
    inc word [ano]

.fimData:
    ret
