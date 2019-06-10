CC = gcc
CFLAGS = -Wall -m64 -g
SFMLPTH = /usr/include/SFML
all:	f.o main.o 
	$(CC) $(CFLAGS) f.o main.o -o fun -lstdc++;
	export LD_LIBRARY_PATH=/home/asdf/Desktop/ARKO/ARKOx86/ARKO_Cieniowanie_Trojkata/SFML-2.4.0/lib/;
main.o:	main.cpp
	$(CC) $(CFLAGS) -c main.cpp -o main.o
f.o:	f.s
	nasm -f elf64 -o f.o f.s
clean:
	rm -f *.o
