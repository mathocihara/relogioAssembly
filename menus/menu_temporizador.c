//==============================================================
// menus/menu_temporizador.c
//
// Interface do Temporizador (Countdown)
//==============================================================

#include <stdio.h>

// buffer vindo do ASM (tempo formatado "HH:MM:SS")
extern char TextoTemporizador[16];

// estado do temporizador
extern int EstadoTemporizador;
// 0 = parado
// 1 = rodando
// 2 = pausado
// 3 = finalizado

void MostrarMenuTemporizador(void)
{
    printf("\n");
    printf("====================================\n");
    printf("           TEMPORIZADOR            \n");
    printf("====================================\n");
    printf("\n");

    printf("Tempo restante: %s\n", TextoTemporizador);

    printf("\n");

    if (EstadoTemporizador == 0)
        printf("Estado: PARADO\n");
    else if (EstadoTemporizador == 1)
        printf("Estado: RODANDO\n");
    else if (EstadoTemporizador == 2)
        printf("Estado: PAUSADO\n");
    else if (EstadoTemporizador == 3)
        printf("Estado: FINALIZADO\n");

    printf("\n");
    printf("------------------------------------\n");
    printf("1 - Iniciar\n");
    printf("2 - Pausar\n");
    printf("3 - Reiniciar\n");
    printf("0 - Voltar\n");
    printf("====================================\n");
}