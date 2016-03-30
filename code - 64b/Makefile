all:
	nasm -f macho64 -g funcion.asm -o funcion.o
	gcc -ggdb -o programa programa.c funcion.o
#	nasm -ggdb -f macho64 imprime.asm -o imprime.o
#	gcc -o ejec -g main.c imprime.o
#	nasm -ggdb -f macho64 holamundo.asm
#	ld holamundo.o -o holamundo
#	nasm -ggdb -f macho64 mequieroir.asm
#	ld mequieroir.o -o mequieroir

clean: 
	rm programa funcion.o
#	rm -f *.o imprime ejec
#	rm -f *.o mequieroir holamundo
