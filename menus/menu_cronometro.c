#include <stdio.h>

extern char TextoCronometro[16];
extern int EstadoCronometro;

void MostrarMenuCronometro(void)
{
    printf("====================================\n");
    printf("            CRONOMETRO              \n");
    printf("====================================\n\n");

    printf("Tempo: %s\n", TextoCronometro);

    if (EstadoCronometro == 0)
        printf("Estado: PARADO\n");
    else if (EstadoCronometro == 1)
        printf("Estado: EXECUTANDO\n");
    else if (EstadoCronometro == 2)
        printf("Estado: PAUSADO\n");
    else
        printf("Estado: DESCONHECIDO\n");

    printf("\n");
    printf("1 - Iniciar\n");
    printf("2 - Pausar\n");
    printf("3 - Reiniciar\n");
    printf("0 - Voltar\n\n");
}