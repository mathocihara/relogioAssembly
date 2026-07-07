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
nasm -f elf64 menus/menu_temporizador.asm -o build/menu_temporizador.o
nasm -f elf64 menus/menu_temporizador_edicao.asm -o build/menu_temporizador_edicao.o

echo "== Modulos =="
nasm -f elf64 modulos/relogio.asm -o build/relogio.o
nasm -f elf64 modulos/temporizador.asm -o build/temporizador.o
nasm -f elf64 modulos/temporizador_edicao.asm -o build/temporizador_edicao.o

echo "== Principal =="
nasm -f elf64 principal.asm -o build/principal.o

echo "== Linkando =="
ld \
build/entrada_saida.o \
build/teclado.o \
build/menu_principal.o \
build/menu_relogio.o \
build/menu_temporizador.o \
build/menu_temporizador_edicao.o \
build/relogio.o \
build/temporizador.o \
build/temporizador_edicao.o \
build/principal.o \
-o build/app

echo "OK!"