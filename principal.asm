default rel

global main

extern InicializarTeclado
extern RestaurarTeclado
extern LerTecla

extern LimparTela
extern CursorHome
extern ImprimirString

extern MostrarMenuPrincipal
extern ModuloRelogio
extern ModuloCronometro
extern ModuloTemporizador

section .data
titulo db "==== SISTEMA DE RELOGIO ====",10,0
prompt db "Pressione uma opcao: ",0

section .text

main:
    push rbp
    mov rbp, rsp
    sub rsp, 8                ; alinhamento para chamadas C/libc

    call InicializarTeclado

.loop_principal:
    call LimparTela
    call CursorHome

    mov rdi, titulo
    call ImprimirString

    call MostrarMenuPrincipal

    mov rdi, prompt
    call ImprimirString

.espera_opcao:
    call LerTecla
    cmp al, 0
    je .espera_opcao

    cmp al, '0'
    je .sair

    cmp al, '1'
    je .abrir_relogio

    cmp al, '2'
    je .abrir_cronometro

    cmp al, '3'
    je .abrir_temporizador

    jmp .loop_principal

.abrir_relogio:
    call ModuloRelogio
    jmp .loop_principal

.abrir_cronometro:
    call ModuloCronometro
    jmp .loop_principal

.abrir_temporizador:
    call ModuloTemporizador
    jmp .loop_principal

.sair:
    call RestaurarTeclado
    xor eax, eax

    add rsp, 8
    pop rbp
    ret