default rel

global ModuloRelogio

extern LimparTela
extern ImprimirString
extern LerTecla

section .data

msg db "RELÓGIO (tempo do sistema)", 10
len equ $ - msg

newline db 10

section .bss
ts resq 2

section .text

ModuloRelogio:

.loop:

    ; =========================
    ; limpa tela
    ; =========================
    call LimparTela

    ; =========================
    ; pega tempo do sistema
    ; =========================
    mov rax, 228          ; clock_gettime
    mov rdi, 0            ; CLOCK_REALTIME
    mov rsi, ts
    syscall

    ; =========================
    ; imprime título
    ; =========================
    mov rsi, msg
    mov rdx, len
    call ImprimirString

    ; =========================
    ; imprime timestamp bruto (debug inicial)
    ; =========================
    mov rax, [ts]
    call print_num

    mov rsi, newline
    mov rdx, 1
    call ImprimirString

    ; =========================
    ; delay ~1s (simples)
    ; =========================
    mov rcx, 200000000
.delay:
    dec rcx
    jnz .delay

    ; =========================
    ; saída
    ; =========================
    call LerTecla
    cmp al, '0'
    je .sair

    jmp .loop

.sair:
    ret


; =========================
; print simples número
; =========================
print_num:
    sub rsp, 32

    mov rbx, 10
    xor rcx, rcx

.convert:
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsp+rcx], dl
    inc rcx
    test rax, rax
    jnz .convert

.print:
    dec rcx
    mov al, [rsp+rcx]

    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall

    test rcx, rcx
    jnz .print

    add rsp, 32
    ret