all:
	nasm -ggdb -f elf64 imprime.asm -o imprime.o
	gcc -o ejec -g main.c imprime.o
#	nasm -ggdb -f elf64 holamundo.asm
#	ld holamundo.o -o holamundo
#	nasm -ggdb -f elf64 mequieroir.asm
#	ld mequieroir.o -o mequieroir

clean: 
	rm -f *.o imprime ejec
#	rm -f *.o mequieroir holamundo
