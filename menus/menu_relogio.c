#include <stdio.h>

extern char TextoHorarioSistema[16];
extern char TextoDataSistema[16];

void MostrarMenuRelogio(void)
{
    printf("====================================\n");
    printf("              RELOGIO               \n");
    printf("====================================\n\n");

    printf("Hora: %s\n", TextoHorarioSistema);
    printf("Data: %s\n\n", TextoDataSistema);

    printf("0 - Voltar\n\n");
}