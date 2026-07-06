#!/bin/bash

for arquivo in *.asm
do
    nasm -f elf64 "$arquivo" -o "${arquivo%.asm}.o"
done

ld *.o -o relogio

echo "Compilação concluída!"
