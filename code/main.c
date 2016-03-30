#include <stdio.h>
#include <inttypes.h>

extern double sumad(double, double);
extern void imprime(int a, double f, char *s);
int main(int argc, char *argv[]) {
    /* sumad:
    double res = 0;
    res = sumad(44.4, 3.4);
    printf("res fun %f \n", res);*/
    //char *s = "hola";
    //printf("the value is %s \n", s);
    //imprime(2, 4.4, s);
   
  printf( "    short int: %zd\n" , sizeof(short int) ) ;
  printf( "          int: %zd\n" , sizeof(int) ) ;
  printf( "     long int: %zd\n", sizeof(long int) ) ;
  printf( "long long int: %zd\n", sizeof(long long int) ) ;
  printf( "       size_t: %zd\n", sizeof(size_t) ) ;
  printf( "        void*: %zd\n\n", sizeof(void *) ) ;
  printf( "        uint32_t: %zd\n\n", sizeof(uint32_t) ) ;

  printf( "PRIu32 usage (see source): %"PRIu32"\n" , (uint32_t) 42 ) ;
      
  return 0;
}
