//==============================================================
// menus/menu_alarmes.c
//
// Interface dos Alarmes
//==============================================================

#include <stdio.h>

#define MAX_ALARMES 10

// vindo do ASM
extern int QuantidadeAlarmes;

// estrutura simples exposta pelo ASM
typedef struct {
    int hora;
    int minuto;
    int ativo; // 0 = desligado, 1 = ativo
} Alarme;

extern Alarme ListaAlarmes[MAX_ALARMES];

void MostrarMenuAlarmes(void)
{
    printf("\n");
    printf("====================================\n");
    printf("              ALARMES              \n");
    printf("====================================\n");
    printf("\n");

    if (QuantidadeAlarmes == 0)
    {
        printf("Nenhum alarme configurado.\n");
    }
    else
    {
        printf("Lista de alarmes:\n");
        printf("------------------------------------\n");

        for (int i = 0; i < QuantidadeAlarmes; i++)
        {
            printf("[%d] %02d:%02d  - %s\n",
                i,
                ListaAlarmes[i].hora,
                ListaAlarmes[i].minuto,
                ListaAlarmes[i].ativo ? "ATIVO" : "DESATIVADO"
            );
        }
    }

    printf("\n");
    printf("------------------------------------\n");
    printf("1 - Ver Alarmes\n");
    printf("2 - Criar Alarme\n");
    printf("3 - Editar Alarme\n");
    printf("4 - Excluir Alarme\n");
    printf("0 - Voltar\n");
    printf("====================================\n");
}