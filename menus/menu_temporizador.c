#include <stdio.h>

extern char TextoTemporizador[16];
extern int EstadoTemporizador;

void MostrarMenuTemporizador(void)
{
    printf("====================================\n");
    printf("           TEMPORIZADOR             \n");
    printf("====================================\n\n");

    printf("Tempo restante: %s\n", TextoTemporizador);

    if (EstadoTemporizador == 0)
        printf("Estado: PARADO\n");
    else if (EstadoTemporizador == 1)
        printf("Estado: EXECUTANDO\n");
    else if (EstadoTemporizador == 2)
        printf("Estado: PAUSADO\n");
    else if (EstadoTemporizador == 3)
        printf("Estado: FINALIZADO\n");
    else
        printf("Estado: DESCONHECIDO\n");

    printf("\n");
    printf("1 - Iniciar\n");
    printf("2 - Pausar\n");
    printf("3 - Reiniciar\n");
    printf("0 - Voltar\n\n");
}