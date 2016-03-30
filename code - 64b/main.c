#include <stdio.h>

extern double sumad(double, double);
extern void imprime(int a, double f, char *s);
int main(int argc, char *argv[]) {
    /* sumad:
    double res = 0;
    res = sumad(44.4, 3.4);
    printf("res fun %f \n", res);*/
    char *s = "hola";
    //printf("the value is %s \n", s);
    imprime(2, 4.4, s);
    return 0;
}
