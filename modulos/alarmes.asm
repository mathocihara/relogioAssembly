;==============================================================
; modulos/alarmes.asm
; Alarmes - criar / listar / remover / disparar
;==============================================================

default rel

%include "constantes.inc"

global ModuloAlarmes
global VerificarAlarmes

extern LimparTela
extern CursorHome
extern LerTecla
extern ImprimirString

extern ListaAlarmes
extern QuantidadeAlarmes
extern HorarioSistema

section .data

titulo1 db "====================================",10,0
titulo2 db "              ALARMES              ",10,0
titulo3 db "====================================",10,10,0

menu1 db "1 - Listar alarmes",10,0
menu2 db "2 - Criar alarme",10,0
menu3 db "3 - Remover alarme",10,0
menu0 db "0 - Voltar",10,0

msgNenhum db "Nenhum alarme cadastrado.",10,0

msgCriarHora db "Hora (2 digitos): ",0
msgCriarMin  db "Minuto (2 digitos): ",0

msgRemover db "Indice do alarme para remover (2 digitos): ",0

txtAbre       db "[",0
txtFecha      db "] ",0
txtDoisPontos db ":",0
txtAtivo      db " ATIVO",10,0

; tela do disparo
alarmTop1 db "====================================",10,0
alarmTop2 db "            ALARME !!!             ",10,0
alarmTop3 db "====================================",10,10,0
alarmMsg1 db "Horario do alarme: ",0
alarmOpt1 db 10,"1 - Desligar",10,0
alarmOpt2 db "2 - Adiar 5 minutos",10,0
beepMsg db 7,0

section .bss
dig1     resb 1
dig2     resb 1
horaTemp resb 1
minTemp  resb 1

section .text

;==============================================================
; LerDigito
; retorna AL = 0..9
;==============================================================
LerDigito:
.loop:
    call LerTecla
    cmp al, '0'
    jb .loop
    cmp al, '9'
    ja .loop
    sub al, '0'
    ret

;==============================================================
; LerDoisDigitos
; retorna AL = 0..99
;==============================================================
LerDoisDigitos:
    push rbx

    call LerDigito
    mov [dig1], al

    call LerDigito
    mov [dig2], al

    movzx eax, byte [dig1]
    imul eax, eax, 10
    movzx ebx, byte [dig2]
    add eax, ebx

    pop rbx
    ret

;==============================================================
; ImprimirCharInterno
; DIL = caractere ASCII
;==============================================================
ImprimirCharInterno:
    sub rsp, 8
    mov [rsp], dil

    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall

    add rsp, 8
    ret

;==============================================================
; Imprimir2Digitos
; AL = valor 0..99
;==============================================================
Imprimir2Digitos:
    push rax
    push rbx
    push rdx

    xor ah, ah
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'

    sub rsp, 2
    mov [rsp], al
    mov [rsp+1], ah

    movzx rdi, byte [rsp]
    call ImprimirCharInterno

    movzx rdi, byte [rsp+1]
    call ImprimirCharInterno

    add rsp, 2

    pop rdx
    pop rbx
    pop rax
    ret

;==============================================================
; CriarAlarme
;==============================================================
CriarAlarme:
    mov eax, [QuantidadeAlarmes]
    cmp eax, MAX_ALARMES
    jae .fim

    ; hora
    call LimparTela
    call CursorHome
    mov rdi, msgCriarHora
    call ImprimirString
    call LerDoisDigitos

    cmp al, 23
    jbe .hora_ok
    xor al, al
.hora_ok:
    mov [horaTemp], al

    ; minuto
    call LimparTela
    call CursorHome
    mov rdi, msgCriarMin
    call ImprimirString
    call LerDoisDigitos

    cmp al, 59
    jbe .min_ok
    xor al, al
.min_ok:
    mov [minTemp], al

    ; endereço = ListaAlarmes + QuantidadeAlarmes*12
    mov eax, [QuantidadeAlarmes]
    imul eax, 12
    lea rdx, [ListaAlarmes + rax]

    ; +0 hora(int)
    ; +4 minuto(int)
    ; +8 ativo(int)
    movzx eax, byte [horaTemp]
    mov dword [rdx + 0], eax

    movzx eax, byte [minTemp]
    mov dword [rdx + 4], eax

    mov dword [rdx + 8], 1

    inc dword [QuantidadeAlarmes]

.fim:
    ret

;==============================================================
; ListarAlarmes
;==============================================================
ListarAlarmes:
    push r12
    push r13

    call LimparTela
    call CursorHome

    mov rdi, titulo1
    call ImprimirString
    mov rdi, titulo2
    call ImprimirString
    mov rdi, titulo3
    call ImprimirString

    mov eax, [QuantidadeAlarmes]
    cmp eax, 0
    jne .tem_alarmes

    mov rdi, msgNenhum
    call ImprimirString
    jmp .espera_zero

.tem_alarmes:
    xor r12d, r12d

.loop:
    mov eax, [QuantidadeAlarmes]
    cmp r12d, eax
    jge .espera_zero

    mov rdi, txtAbre
    call ImprimirString

    mov al, r12b
    call Imprimir2Digitos

    mov rdi, txtFecha
    call ImprimirString

    mov eax, r12d
    imul eax, 12
    lea r13, [ListaAlarmes + rax]

    mov al, byte [r13 + 0]
    call Imprimir2Digitos

    mov rdi, txtDoisPontos
    call ImprimirString

    mov al, byte [r13 + 4]
    call Imprimir2Digitos

    mov rdi, txtAtivo
    call ImprimirString

    inc r12d
    jmp .loop

.espera_zero:
.wait:
    call LerTecla
    cmp al, '0'
    jne .wait

    pop r13
    pop r12
    ret

;==============================================================
; RemoverAlarme
;==============================================================
RemoverAlarme:
    push r12
    push r13
    push r14

    mov eax, [QuantidadeAlarmes]
    cmp eax, 0
    je .fim

    call LimparTela
    call CursorHome
    mov rdi, msgRemover
    call ImprimirString

    call LerDoisDigitos
    movzx r12d, al

    mov eax, [QuantidadeAlarmes]
    cmp r12d, eax
    jae .fim

.shift_loop:
    mov eax, [QuantidadeAlarmes]
    dec eax
    cmp r12d, eax
    jge .reduz

    ; src = índice+1
    mov eax, r12d
    inc eax
    imul eax, 12
    lea r13, [ListaAlarmes + rax]

    ; dst = índice
    mov eax, r12d
    imul eax, 12
    lea r14, [ListaAlarmes + rax]

    mov eax, [r13 + 0]
    mov [r14 + 0], eax

    mov eax, [r13 + 4]
    mov [r14 + 4], eax

    mov eax, [r13 + 8]
    mov [r14 + 8], eax

    inc r12d
    jmp .shift_loop

.reduz:
    dec dword [QuantidadeAlarmes]

.fim:
    pop r14
    pop r13
    pop r12
    ret

;==============================================================
; AdiarAlarme5Min
; RDI = ponteiro do alarme atual
;==============================================================
AdiarAlarme5Min:
    push rbx

    mov eax, [rdi + 4]      ; minuto
    add eax, 5

    cmp eax, 60
    jl .salvar_min

    sub eax, 60
    mov [rdi + 4], eax

    mov eax, [rdi + 0]      ; hora
    inc eax
    cmp eax, 24
    jl .salvar_hora

    xor eax, eax

.salvar_hora:
    mov [rdi + 0], eax
    pop rbx
    ret

.salvar_min:
    mov [rdi + 4], eax
    pop rbx
    ret

;==============================================================
; TelaAlarmeDisparado
; RDI = ponteiro do alarme que disparou
;==============================================================
TelaAlarmeDisparado:
    push r12
    mov r12, rdi

.tela_loop:
    call LimparTela
    call CursorHome

    ; beep
    mov rdi, beepMsg
    call ImprimirString

    mov rdi, alarmTop1
    call ImprimirString
    mov rdi, alarmTop2
    call ImprimirString
    mov rdi, alarmTop3
    call ImprimirString

    mov rdi, alarmMsg1
    call ImprimirString

    mov al, byte [r12 + 0]
    call Imprimir2Digitos

    mov rdi, txtDoisPontos
    call ImprimirString

    mov al, byte [r12 + 4]
    call Imprimir2Digitos

    mov rdi, alarmOpt1
    call ImprimirString
    mov rdi, alarmOpt2
    call ImprimirString

.espera:
    call LerTecla

    cmp al, '1'
    je .desligar

    cmp al, '2'
    je .adiar

    jmp .espera

.desligar:
    mov dword [r12 + 8], 0
    pop r12
    ret

.adiar:
    mov rdi, r12
    call AdiarAlarme5Min
    pop r12
    ret

;==============================================================
; VerificarAlarmes
; verifica se algum alarme ativo bate com HorarioSistema
;==============================================================
VerificarAlarmes:
    push rbx
    push r12
    push r13

    mov eax, [QuantidadeAlarmes]
    cmp eax, 0
    je .fim

    xor r12d, r12d

.loop:
    mov eax, [QuantidadeAlarmes]
    cmp r12d, eax
    jge .fim

    ; ponteiro do alarme atual
    mov eax, r12d
    imul eax, 12
    lea r13, [ListaAlarmes + rax]

    ; ativo?
    mov eax, [r13 + 8]
    cmp eax, 1
    jne .prox

    ; compara hora
    mov al, byte [HorarioSistema + 0]
    mov bl, byte [r13 + 0]
    cmp al, bl
    jne .prox

    ; compara minuto
    mov al, byte [HorarioSistema + 1]
    mov bl, byte [r13 + 4]
    cmp al, bl
    jne .prox

    ; só dispara no segundo 0
    mov al, byte [HorarioSistema + 2]
    cmp al, 0
    jne .prox

    ; disparou
    mov rdi, r13
    call TelaAlarmeDisparado
    jmp .fim

.prox:
    inc r12d
    jmp .loop

.fim:
    pop r13
    pop r12
    pop rbx
    ret

;==============================================================
; ModuloAlarmes
;==============================================================
ModuloAlarmes:

.loop_menu:
    call LimparTela
    call CursorHome

    mov rdi, titulo1
    call ImprimirString
    mov rdi, titulo2
    call ImprimirString
    mov rdi, titulo3
    call ImprimirString

    mov eax, [QuantidadeAlarmes]
    cmp eax, 0
    jne .mostrar_menu

    mov rdi, msgNenhum
    call ImprimirString

.mostrar_menu:
    mov rdi, menu1
    call ImprimirString
    mov rdi, menu2
    call ImprimirString
    mov rdi, menu3
    call ImprimirString
    mov rdi, menu0
    call ImprimirString

.espera:
    call LerTecla

    cmp al, '0'
    je .sair

    cmp al, '1'
    je .listar

    cmp al, '2'
    je .criar

    cmp al, '3'
    je .remover

    jmp .espera

.listar:
    call ListarAlarmes
    jmp .loop_menu

.criar:
    call CriarAlarme
    jmp .loop_menu

.remover:
    call RemoverAlarme
    jmp .loop_menu

.sair:
    ret