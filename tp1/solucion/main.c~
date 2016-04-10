#include "tdt.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

char *archivoMain  =  "salida.main.txt";

bloque b1 = {{0x05,0x05,0x05},{0x12,0x34,0x56,0x78,0x9A,0xBC,0xDE,0xF1,0x23,0x45,0x67,0x89,0xAB,0xCD,0xEF}};
bloque b2 = {{0xFF,0xFF,0xFF},{0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE,0xFF}};
bloque b3 = {{0x53,0xFF,0xAA},{0x11,0x12,0x22,0x33,0x34,0x44,0x55,0x56,0x66,0x77,0x78,0x88,0x99,0x9A,0xAA}};
bloque b4 = {{0x10,0xEE,0x05},{0x11,0x11,0x22,0x22,0x33,0x33,0x44,0x44,0x55,0x55,0x66,0x66,0x77,0x77,0x88}};

bloque* b[5] = {&b1,&b2,&b3,&b4,0};

uint8_t claveMin[3] = {0,0,0};
uint8_t claveMax[3] = {0xFF,0xFF,0xFF};
uint8_t valorMax[15] = {0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};
uint8_t valorMin[15] = {  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0};

void printmaxmin(FILE *pFile, tdt* tabla);

int main (void){
    FILE *pFile;

    tdt *tabla = tdt_crear("pepe");    
    tdt_agregar(tabla,claveMin,valorMax);
    tdt_agregar(tabla,claveMax,valorMin);
    
    tdt_agregarBloques(tabla, (bloque**)&b);
    
    tdt_borrarBloque(tabla,&b3);
    
    tdt_borrarBloque(tabla,&b2);
    
    pFile = fopen(archivoMain, "w");
    
    fprintf(pFile, "Imprimiento máximos y minimos:\n");
    printmaxmin(pFile, tabla);
    
    fprintf(pFile, "Imprimiento traducciones:\n");
    tdt_imprimirTraducciones(tabla, pFile);
    
    fprintf(pFile, "Cantidad de traducciones: %d\n", tdt_cantidad(tabla));
    
    fclose(pFile);
    
    tdt_destruir(&tabla);
    
    return 0;
}

void printmaxmin(FILE *pFile, tdt* tabla) {
    int i;
    maxmin *mm = tdt_obtenerMaxMin(tabla);
    fprintf(pFile,"max_clave = %i",mm->max_clave[0]);
    for(i=1;i<3;i++) fprintf(pFile,"-%i",mm->max_clave[i]);
    fprintf(pFile,"\n");
    fprintf(pFile,"min_clave = %i",mm->min_clave[0]);
    for(i=1;i<3;i++) fprintf(pFile,"-%i",mm->min_clave[i]);
    fprintf(pFile,"\n");
    fprintf(pFile,"max_valor = %i",mm->max_valor[0]);
    for(i=1;i<15;i++) fprintf(pFile,"-%i",mm->max_valor[i]);
    fprintf(pFile,"\n");
    fprintf(pFile,"min_valor = %i",mm->min_valor[0]);
    for(i=1;i<15;i++) fprintf(pFile,"-%i",mm->min_valor[i]);
    fprintf(pFile,"\n");
    free(mm);
}


