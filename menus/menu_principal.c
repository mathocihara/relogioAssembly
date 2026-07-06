#include <stdio.h>

void MostrarMenuPrincipal(void)
{
    printf("\033[H\033[J"); // limpa tela

    printf("====================================\n");
    printf("           MENU PRINCIPAL           \n");
    printf("====================================\n\n");

    printf("1 - Relogio\n");
    printf("2 - Cronometro\n");
    printf("3 - Temporizador\n");
    printf("4 - Alarmes\n");
    printf("0 - Sair\n\n");

    printf("====================================\n");
}