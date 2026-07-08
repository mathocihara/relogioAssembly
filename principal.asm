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

    jmp .loop_principal

.abrir_relogio:
    call ModuloRelogio
    jmp .loop_principal

.sair:
    call RestaurarTeclado
    xor eax, eax

    add rsp, 8
    pop rbp
    ret