#include "f.h"
#include <stdio.h>
#include <stdlib.h>
#define WORD __int32_t



void change_first_bit(char * filename)
{
	WORD *i = (WORD *)malloc(sizeof(WORD));
	FILE * plik = fopen(filename, "r+");

	if(plik == NULL)
	{
		printf("Cannot open file %s\n", filename);
		return;
	}
	fseek(plik, 0L, SEEK_END);
	
	int fileSize = ftell(plik);
	rewind(plik);
	char * fileBytes = (char *)malloc(sizeof(char) * fileSize + 1);
	int count = fread(fileBytes, sizeof(char), fileSize, plik);
	printf("change_first_pixel: read %d bytes\n", count);
	f(fileBytes);
	fclose(plik);
	int wsk = 0;
	while (wsk < fileSize)
	{
		printf("0x");
		for (int j = 0; j < 4; j++)
		{
			printf("%02hhx", *(fileBytes + wsk));
			wsk++;
		}
		printf(" ");
	}
	
}

void imageInfo(char * filename)
{
	FILE *plik = fopen(filename, "r");
	if(plik == NULL)
	{
		printf("imageInfo: cannot open file %s\n", filename);
		return;
	}

	printf ("Pozycja = %0#10x\n", ftell(plik));
	WORD *i = (WORD *)malloc(sizeof(WORD));
	WORD *pixel = (WORD *)malloc(sizeof(WORD));
	fseek(plik, 10, 0);
	fread(i, sizeof(WORD), 1, plik );
	printf("Offset pixeli %d\n", *i);
	
	int pixelOffset = *i;

	fseek(plik, 18, 0);
	fread(i, sizeof(WORD), 1, plik );
	printf("Szerokosc obrazu %d\n", *i);

	//int imageWidth = *i;

	fread(i, sizeof(WORD), 1, plik );
	printf("Wysokosc obrazu %d\n", *i);

	//int imageHeight = *i;

	fseek(plik, 0L, SEEK_END);
	int fSize = ftell(plik);
	printf("Romiar pliku: %d\n", fSize);

	char * buffer = (char *)malloc(fSize+1);
	rewind(plik);
	fread(buffer, sizeof(char), fSize, plik);
	

	fseek(plik, pixelOffset, 0);
	fread(pixel, sizeof(WORD), 1, plik);
	printf("1. pixel %0#10x\n", *pixel);

	int pixelBytes = fSize - pixelOffset;
	int pixelCount = pixelBytes/4;
	printf("Liczba pixeli: %d\n", pixelCount);

	fclose(plik);

}


void displayImageBytes(char * filename)
{
	FILE * plik = fopen(filename, "r");
	if(plik == NULL)
	{
		printf("displayImageBytes: Cannot open file %s\n", filename);
		return;
	}

	rewind(plik);
	char c = 0;
	int tmp = 1;
	
	while (tmp == 1 )
	{
		printf("0x ");
		for(int i = 0; i < 4; i++)
		{
			tmp = fread(&c, sizeof(char), 1, plik);
			if(tmp != 1)
				break;
			printf("%02hhx ", c);
			
		}
		printf(" ");
		c = 0;
	}
	puts("\n");

	fclose(plik);
}

// schemat koloru 0x XX RR GG BB

int main (int argc, char *argv[])
{
	if (argc < 2){
		printf("Arg missing.\n");
		return 0;
	}
	
	
	/*imageInfo(argv[1]);
	displayImageBytes(argv[1]);*/
	change_first_bit(argv[1]);
	

	

	
	

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
