//==============================================================
// menus/menu_relogio.c
//
// Interface do Relógio
//==============================================================

#include <stdio.h>

// buffers que serão preenchidos pelo ASM
extern char TextoHorarioSistema[16];
extern char TextoDataSistema[16];

void MostrarMenuRelogio(void)
{
    printf("\n");
    printf("====================================\n");
    printf("              RELOGIO               \n");
    printf("====================================\n");
    printf("\n");

    printf("Hora: %s\n", TextoHorarioSistema);
    printf("Data: %s\n", TextoDataSistema);

    printf("\n");
    printf("------------------------------------\n");
    printf("0 - Voltar\n");
    printf("====================================\n");
}