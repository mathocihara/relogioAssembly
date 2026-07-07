#include <stdio.h>

void MostrarMenuRelogio(void)
{
    printf("\033[2J\033[H");
    printf("=== TESTE MENU RELOGIO ===\n");
    printf("Se voce esta vendo isso, MostrarMenuRelogio foi chamado.\n");
    fflush(stdout);
}