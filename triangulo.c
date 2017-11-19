#include <stdio.h>
#include <stdlib.h>

float area(int x1, int y1, int x2, int y2, int x3, int y3){
   return abs((x1*(y2-y3) + x2*(y3-y1)+ x3*(y1-y2))/2.0);
}
 
int verifica(int x1, int y1, int x2, int y2, int x3, int y3, int x, int y){   

   int A = area(x1, y1, x2, y2, x3, y3);
   int A1 = area(x, y, x2, y2, x3, y3);
   int A2 = area(x1, y1, x, y, x3, y3);
   int A3 = area(x1, y1, x2, y2, x, y);

   return (A == A1 + A2 + A3);
}

void desenha(int x1, int y1, int x2, int y2, int x3, int y3, int x, int y){
	for(int i=0 ; i<35; i++){
		for(int j=0 ; j<55; j++){
			if(i==x1 && j==y1)
				printf("A");
			else if(i==x2 && j==y2)
				printf("B");
			else if(i==x3 && j==y3)
				printf("C");
			else if(i==x && j==y)
				printf("P");
			else if(verifica(x1, y1, x2, y2, x3, y3, i, j))
				printf("+");
			else
				printf(".");
			
		}
		printf("\n");
	}

}
 
int main(){
	int x1 = 0, y1 = 0, x2 = 20, y2 = 0, x3 = 20, y3 = 30, x, y;

	printf("Insira as coordenadas: ");
	scanf("%d" "%d", &x, &y);

	if (verifica(x1, y1, x2, y2, x3, y3, x, y))
		printf ("O ponto está dentro\n");
	else
		printf ("O ponto está fora\n");

	desenha(x1, y1, x2, y2, x3, y3, x, y);
 
   return 0;
}
