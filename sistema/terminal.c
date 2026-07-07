#include <stdlib.h>

// ativa modo real-time do terminal
void InicializarTerminal()
{
    system("stty -echo -icanon time 0 min 0");
}

// restaura terminal normal
void RestaurarTerminal()
{
    system("stty sane");
}