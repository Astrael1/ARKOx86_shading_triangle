#include "f.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define WORD __int32_t



void process(char * filename, 
WORD pozX, WORD pozY, WORD color, 
WORD pozX2, WORD pozY2, WORD color2 )
{
	WORD *i = (WORD *)malloc(sizeof(WORD) * 10);
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
	
	i[0] = pozX;
	i[1] = pozY;
	i[2] = color;
	i[3] = pozX2;
	i[4] = pozY2;
	i[5] = color2;

	f(fileBytes, i);
	printf("Wartosc pod i: %d\n", *i);
	
	int wsk = 0;
	while (wsk < 150)
	{
		for (int x = 0 ; x < 5 ; x ++)
		{
			printf("0x");
			for (int j = 0; j < 4; j++)
			{
				printf("%02hhx", *(fileBytes + wsk));
				wsk++;
			}
			printf(" ");
		}
		printf("\n");
	}
	rewind(plik);
	fwrite(fileBytes, sizeof(char), fileSize, plik);
	fclose(plik);
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
	int n = 36;
	
	while (tmp == 1 && n--)
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
	if (argc < 3){
		printf("Arg missing.\n");
		return 0;
	}
	
	if(strcmp(argv[1], "-i") == 0)
	{
		imageInfo(argv[2]);
	}
	else if (strcmp(argv[1], "-d") == 0)
	{
		printf("Byte display requested\n");
	}
	else if (strcmp(argv[1], "-p") == 0)
	{
		printf("Process requested\n");
		process(argv[2], 10, 10, 0x0000ff00, 20, 9, 0x000000ff);
	}
	/*imageInfo(argv[1]);
	displayImageBytes(argv[1]);
	change_first_bit(argv[1]);*/

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
