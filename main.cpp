#include "f.h"
#include <stdio.h>
#include <stdlib.h>
#define WORD __int32_t

// schemat koloru 0x XX RR GG BB

int main (int argc, char *argv[])
{
	if (argc < 3){
		printf("Arg missing.\n");
		return 0;
	}
	FILE *plik = fopen(argv[1], "r+");

	

	if(plik == NULL)
	{
		printf("Nie mozna otworzyc pliku");
	}

	
	printf ("Pozycja = %0#10x\n", ftell(plik));
	WORD *i = (WORD *)malloc(sizeof(WORD));
	WORD *pixel = (WORD *)malloc(sizeof(WORD));
	fseek(plik, 10, 0);
	fread(i, sizeof(WORD), 1, plik );
	printf("Offset pixeli %d\n", *i);

	int pixelOffset = *i;
	
	fseek(plik, *i, 0);
	fread(pixel, sizeof(WORD), 1, plik);
	printf("1. pixel %0#10x\n", *pixel);

	fseek(plik, 0L, SEEK_END);
	int fSize = ftell(plik);
	printf("Romiar pliku: %d\n", fSize);
	
	fseek(plik, *i, 0);
	*pixel = 0x00000000;
	int diagnoza = fwrite(pixel, sizeof(WORD), 1, plik);
	printf("Zapisano %d bajtów\n", diagnoza);

	fseek(plik, *i, 0);
	fread(pixel, sizeof(WORD), 1, plik);
	printf("1. pixel %0#10x\n", *pixel);

	int pixelBytes = fSize - pixelOffset;
	int pixelCount = pixelBytes/4;
	printf("Liczba pixeli: %d\n", pixelCount);

	
	rewind(plik);
	fseek(plik, *i, 0);
	char c = 0;
	int tmp = 1;
	while (tmp == 1)
	{
		printf("0x ");
		for(int i = 0; i < 4; i++)
		{
			tmp = fread(&c, sizeof(char), 1, plik);
			if(tmp != 1)
				break;
			printf("%02hhx ", c);
			
		}
		printf("\n");
		c = 0;
	}

	fclose(plik);

	f(argv[2]);
	printf(argv[2]);
	printf("\n");

	
	

	// visual part
	/*sf::RenderWindow window(sf::VideoMode(1200,400), "SFML Works");
	sf::CircleShape shape(100.f);
	shape.setFillColor(sf::Color::Green);

	sf::Texture leTexture;
	
	sf::Uint8 pixele[] = {0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 
	0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 
	0x00ffffff, 0x00ffffff, 0x00ffffff};
	sf::Image obrazek;
	//obrazek.create(10,10, pixele);
	obrazek.create(100, 100, sf::Color::Blue);

	if(!leTexture.loadFromImage(obrazek)){printf("Error\n");}
	sf::RectangleShape rektShape;
	shape.setTexture(&leTexture);

	while (window.isOpen())
	{
		sf::Event event;
		while (window.pollEvent(event))
		{
			if(event.type == sf::Event::Closed)
				window.close();
		}
		window.clear();
		window.draw(shape);
		window.display();
	}*/
	

	return 0;
}
