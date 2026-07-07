#include <stdlib.h>

void InicializarTerminal(void)
{
    system("stty -echo -icanon time 0 min 0");
}

void RestaurarTerminal(void)
{
    system("stty sane");
}