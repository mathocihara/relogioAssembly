#!/bin/bash
set -e

echo "Compilando sistema..."

rm -rf build
mkdir -p build

INCLUDE="-Iinclude/ -Isistema/"

# ======================
# ASM - sistema
# ======================
nasm -f elf64 $INCLUDE sistema/dados.asm -o build/dados.o
nasm -f elf64 $INCLUDE sistema/entrada_saida.asm -o build/entrada_saida.o
nasm -f elf64 $INCLUDE sistema/teclado.asm -o build/teclado.o
nasm -f elf64 $INCLUDE sistema/tempo.asm -o build/tempo.o
nasm -f elf64 $INCLUDE sistema/ansi.asm -o build/ansi.o

# ======================
# ASM - módulos
# ======================
nasm -f elf64 $INCLUDE modulos/relogio.asm -o build/relogio.o
nasm -f elf64 $INCLUDE modulos/cronometro.asm -o build/cronometro.o
nasm -f elf64 $INCLUDE modulos/temporizador.asm -o build/temporizador.o

# ======================
# ASM - menus
# ======================
nasm -f elf64 $INCLUDE menus/menu_principal.asm -o build/menu_principal.o
nasm -f elf64 $INCLUDE menus/menu_relogio.asm -o build/menu_relogio.o
nasm -f elf64 $INCLUDE menus/menu_cronometro.asm -o build/menu_cronometro.o
nasm -f elf64 $INCLUDE menus/menu_temporizador.asm -o build/menu_temporizador.o
nasm -f elf64 $INCLUDE menus/menu_alarme.asm -o build/menu_alarme.o

# ======================
# ASM - principal
# ======================
nasm -f elf64 $INCLUDE principal.asm -o build/principal.o

# ======================
# C - terminal
# ======================
gcc -c sistema/terminal.c -o build/terminal.o

echo "Linkando..."

gcc \
  build/principal.o \
  build/dados.o \
  build/entrada_saida.o \
  build/teclado.o \
  build/tempo.o \
  build/ansi.o \
  build/relogio.o \
  build/cronometro.o \
  build/temporizador.o \
  build/menu_principal.o \
  build/menu_relogio.o \
  build/menu_cronometro.o \
  build/menu_temporizador.o \
  build/menu_alarme.o \
  build/terminal.o \
  -o app \
  -no-pie

echo "Build concluído!"