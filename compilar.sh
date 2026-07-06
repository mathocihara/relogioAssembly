#!/bin/bash

echo "Compilando sistema..."

rm -rf build
mkdir -p build

INCLUDE="-Isistema/ -Iinclude/"

# ======================
# ASM
# ======================
nasm -f elf64 $INCLUDE principal.asm -o build/principal.o
nasm -f elf64 $INCLUDE sistema/dados.asm -o build/dados.o
nasm -f elf64 $INCLUDE sistema/entrada_saida.asm -o build/entrada_saida.o
nasm -f elf64 $INCLUDE sistema/teclado.asm -o build/teclado.o
nasm -f elf64 $INCLUDE sistema/tempo.asm -o build/tempo.o
nasm -f elf64 $INCLUDE sistema/ansi.asm -o build/ansi.o

# ======================
# C (SEM dados.c !!!)
# ======================
gcc -c menus/menu_principal.c -o build/menu_principal.o
gcc -c menus/menu_relogio.c -o build/menu_relogio.o
gcc -c menus/menu_cronometro.c -o build/menu_cronometro.o
gcc -c menus/menu_temporizador.c -o build/menu_temporizador.o
gcc -c menus/menu_alarmes.c -o build/menu_alarmes.o

# ======================
# LINK FINAL
# ======================
echo "Linkando..."

gcc \
  -no-pie \
  -nostartfiles \
  -Wl,-e,_start \
  build/principal.o \
  build/dados.o \
  build/entrada_saida.o \
  build/teclado.o \
  build/tempo.o \
  build/ansi.o \
  build/menu_principal.o \
  build/menu_relogio.o \
  build/menu_cronometro.o \
  build/menu_temporizador.o \
  build/menu_alarmes.o \
  -o app \
  -lc