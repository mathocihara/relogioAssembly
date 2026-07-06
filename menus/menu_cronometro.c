//==============================================================
// menus/menu_cronometro.c
//
// Interface do Cronômetro
//==============================================================

#include <stdio.h>

// buffer vindo do ASM (tempo formatado "HH:MM:SS")
extern char TextoCronometro[16];

// variável de estado controlada no ASM
extern int EstadoCronometro;
// 0 = parado
// 1 = rodando
// 2 = pausado

void MostrarMenuCronometro(void)
{
    printf("\n");
    printf("====================================\n");
    printf("            CRONOMETRO             \n");
    printf("====================================\n");
    printf("\n");

    printf("Tempo: %s\n", TextoCronometro);

    printf("\n");

    if (EstadoCronometro == 0)
        printf("Estado: PARADO\n");
    else if (EstadoCronometro == 1)
        printf("Estado: RODANDO\n");
    else if (EstadoCronometro == 2)
        printf("Estado: PAUSADO\n");

    printf("\n");
    printf("------------------------------------\n");
    printf("1 - Iniciar\n");
    printf("2 - Pausar\n");
    printf("3 - Reiniciar\n");
    printf("0 - Voltar\n");
    printf("====================================\n");
}