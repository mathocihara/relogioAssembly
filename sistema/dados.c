// sistema/dados.c
// NÃO define variáveis, só referencia ASM

#include <stdio.h>

// strings (ASM é dono)
extern char TextoHorarioSistema[];
extern char TextoCronometro[];
extern char TextoTemporizador[];
extern char TextoDataSistema[];

// buffers (ASM é dono)
extern char BufferEntrada[];
extern char BufferSaida[];

// alarmes (ASM é dono)
extern int QuantidadeAlarmes;