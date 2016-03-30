#include <stdio.h>
#include <stdlib.h>

const int MAX = 3;
 
int main () {
    
   int dos = 2;
   int *numero = &dos;
   printf("Value of numero %d\n", numero[0]);
   printf("Value of numero in position 1..\n 0 ever is the las like \0 in char?: %d\n", numero[1]);
 
   int var[] = {10, 100, 200};
   int *pVar = var;
   int i; 
   int *ptr[MAX];
   int **ptr2 = (int**)malloc(sizeof(int*)*3);
 
   for ( i = 0; i < MAX; i++) {
      ptr[i] = &var[i]; /* assign the address of integer. */
      ptr2[i] = &var[i]; 
      //var[i] = 0;
      //*(var+i)=0;
      //pVar[i] = 0;
      //*(pVar+i)=0;
   }
   
   for ( i = 0; i < MAX; i++) {
      printf("Value of ptr[%d] = %d\n", i, *ptr[i] );
      printf("Value of ptr2[%d] = %d\n", i, *ptr2[i] );
   }
   //without const get: warning: deprecated conversion from string constant to 'char*'
   //this is like char* name = "rodrigo". Is declared in rod.data
   //the const is only for user acknowledge
   const char *names[] = {
      "Zara Ali",
      "Hina Ali",
      "Nuha Ali",
      "Sara Ali",
   };
   
   i = 0;

   for ( i = 0; i < MAX; i++) {
      printf("Value of names[%d] = %s\n", i, names[i] );
      printf("Value of names[%d] is really a pointer\n but printf with percent s makes the work for you: %p\n", i, (void*)names[i] );;
   }

   const char *nombre = "ro";
   printf("0: %c\n", nombre[0]);
   printf("1: %c\n", nombre[1]);
   printf("printing last with char format: %c\n", nombre[2]);
   printf("printing last with dec format: %d\n", nombre[2]);
   printf("why?\n");
   printf("because nombre is an array of pointer to chares! and last is null\n");
   printf("0: %p\n", (void*)nombre[0]);
   printf("1: %p\n", (void*)nombre[1]);
   printf("printing last with ptr format: %p\n", (void*)nombre[2]);
   
   return 0;
}