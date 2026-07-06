#!/bin/bash

set -e

rm -rf build
mkdir build

echo "== Sistema =="
nasm -f elf64 sistema/entrada_saida.asm -o build/entrada_saida.o
nasm -f elf64 sistema/teclado.asm -o build/teclado.o

echo "== Menus =="
nasm -f elf64 menus/menu_principal.asm -o build/menu_principal.o
nasm -f elf64 menus/menu_relogio.asm -o build/menu_relogio.o

echo "== Modulos =="
nasm -f elf64 modulos/relogio.asm -o build/relogio.o

echo "== Principal =="
nasm -f elf64 principal.asm -o build/principal.o

echo "== Linkando =="
ld \
build/entrada_saida.o \
build/teclado.o \
build/menu_principal.o \
build/menu_relogio.o \
build/relogio.o \
build/principal.o \
-o build/app

echo "OK!"
