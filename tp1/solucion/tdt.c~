#include "tdt.h"

/*tdt* tdt_crear(char* identificacion) {
    tdt *tabla = (tdt *)malloc(sizeof(tdt));

    char* myId = (char*)malloc(sizeof(char*));
    strcpy(myId, identificacion);

    tabla->identificacion = myId;
    tabla->primera = NULL;
    tabla->cantidad = 0;
    
    return tabla;
}*/

void tdt_recrear(tdt** tabla, char* identificacion) {
    tdt *pTabla = *tabla;
    if(identificacion != NULL)
        *(pTabla->identificacion) = *identificacion;
        
    pTabla->cantidad = 0;
    
    uint16_t i, j;
    i = 0; 
    j = 0;

    if(pTabla->primera == NULL)
        goto salir;

    vaciarSt1:; 
    tdtN2 *st2 = pTabla->primera->entradas[(uint8_t)i];
    if(st2 == NULL)
        goto continuarSt1;
            
    vaciarSt2:; 
    tdtN3 *st3 = st2->entradas[(uint8_t)j]; 
        if(st3 == NULL)
            goto continuarSt2;
        free(st3);
        st2->entradas[(uint8_t)j] = NULL;
        goto continuarSt2;
        
    continuarSt1: 
        i += 1;
        if(i < 256)
            goto vaciarSt1;
        free(pTabla->primera);
        pTabla->primera = NULL;
        goto salir;
        
    continuarSt2: 
        j += 1;
        if(j < 256)
            goto vaciarSt2;
        j = 0;
        free(st2);
        pTabla->primera->entradas[(uint8_t)i] = NULL;
        goto continuarSt1;    
               
    salir: 
    return;        
}

uint32_t tdt_cantidad(tdt* tabla) {
    return tabla->cantidad;
}

void tdt_agregarBloque(tdt* tabla, bloque* b) {
    tdt_agregar(tabla, b->clave, b->valor);
    return;
}

void tdt_borrarBloque(tdt* tabla, bloque* b) {
    tdt_borrar(tabla, b->clave);
    return;
}

void tdt_traducirBloque(tdt* tabla, bloque* b) {
    tdt_traducir(tabla, b->clave, b->valor);
    return;
}

void tdt_agregarBloques(tdt* tabla, bloque** b) {
    uint32_t i = 0;
    
    ciclo: 
        if(b[i] == 0)
            goto salir;
        tdt_agregarBloque(tabla, b[i]);
        i += 1;
        goto ciclo;
    
    salir: 
    return;
}

void tdt_borrarBloques(tdt* tabla, bloque** b) {
    uint32_t i = 0;
    
    ciclo: 
        if(b[i] == 0)
            goto salir;
        tdt_borrarBloque(tabla, b[i]);
        i += 1;
        goto ciclo;
    
    salir: 
    return;
}

void tdt_traducirBloques(tdt* tabla, bloque** b) {
    uint32_t i = 0;
    
    ciclo: 
        if(b[i] == 0)
            goto salir;
        tdt_traducirBloque(tabla, b[i]);
        i += 1;
        goto ciclo;
    
    salir: 
    return;
}

void tdt_traducir(tdt* tabla, uint8_t* clave, uint8_t* valor) {
    if(tabla->primera == NULL)
        goto salir;
    
    tdtN2* st2 = tabla->primera->entradas[(int)clave[0]];
    
    if(st2 == NULL)
        goto salir;

    tdtN3* st3 = st2->entradas[(int)clave[1]];

    if(st3 == NULL)
        goto salir;
       
    if(st3->entradas[(int)clave[2]].valido == 0)
        goto salir;
   
    uint8_t i = 0;
   
    ciclo:
        valor[i] = st3->entradas[(int)clave[2]].valor.val[i];
        i += 1;
        if(i < 15)
            goto ciclo;
        
    salir: 
    return;
}

void tdt_destruir(tdt** tabla) {
    tdt* pTabla = *tabla;
    
    char* myId = pTabla->identificacion;
    if(myId != NULL)
        free(myId);    
       
    tdt_recrear(tabla, NULL);
    
    free(pTabla);
               
    return;  
}

void tdt_agregar(tdt* tabla, uint8_t* clave, uint8_t* valor) {
    if(tabla->primera == NULL)
        goto tdtN1Empty;
    
    continuarN1:;
    
    tdtN2* st2 = tabla->primera->entradas[(uint8_t)clave[0]];
    
    if(st2 == NULL)
        goto tdtN2Empty;

    continuarN2:;
   
    tdtN3* st3 = st2->entradas[(uint8_t)clave[1]];

    if(st3 == NULL)
        goto tdtN3Empty;
      
    continuarN3:;  
        
    uint8_t i = 0;
  
    if(st3->entradas[(uint8_t)clave[2]].valido == 0) {
        st3->entradas[(uint8_t)clave[2]].valido = 1;
        tabla->cantidad += 1;
    }
   
    ciclo: 
        if(i == 15) {
            goto salir;
        }    
        st3->entradas[(int)clave[2]].valor.val[i] = valor[i];
        i += 1;
        goto ciclo;
               
    tdtN1Empty: 
        tabla->primera = (tdtN1 *)malloc(sizeof(tdtN1));
        uint16_t n1 = 0;
        vaciarN1:
            tabla->primera->entradas[n1] = NULL;
            n1 += 1;
            if(n1 < 256)
                goto vaciarN1;
        goto continuarN1;
        
    tdtN2Empty: 
        st2 = (tdtN2 *)malloc(sizeof(tdtN2));
        uint16_t n2 = 0;
        vaciarN2:
            st2->entradas[n2] = NULL;
            n2 += 1;
            if(n2 < 256)
                goto vaciarN2;
        tabla->primera->entradas[(uint8_t)clave[0]] = st2;
        goto continuarN2;
        
    tdtN3Empty: 
        st3 = (tdtN3 *)malloc(sizeof(tdtN3));     
        st2->entradas[(uint8_t)clave[1]] = st3;
        goto continuarN3;
            
    salir:
    return;
}

void tdt_borrar(tdt* tabla, uint8_t* clave) {
    if(tabla->primera == NULL)
        goto salir;
        
    tdtN2 *st2 = tabla->primera->entradas[(uint8_t)clave[0]];
    
    if(st2 == NULL)
        goto salir;
    
    tdtN3 *st3 = st2->entradas[(uint8_t)clave[1]];
    
    if(st3 == NULL)
        goto salir;
    
    uint16_t i = 0;

    if(st3->entradas[(uint8_t)clave[2]].valido == 0)
        goto salir;
    
    tabla->cantidad -= 1;
    vaciar: 
    st3->entradas[(uint8_t)clave[2]].valor.val[(uint8_t)i] = 0;
    i += 1;
    if(i < 15)
        goto vaciar;
    st3->entradas[(uint8_t)clave[2]].valido = 0;
    
    i = 0;    
    checkTdtN3: 
        if(st3->entradas[(uint8_t)i].valido == 1)
            goto salir;
        
        i += 1;
        if(i < 256)
            goto checkTdtN3;
         
        free(st3);
        st2->entradas[(uint8_t)clave[1]] = NULL;
        
    i = 0;
    checkTdtN2: 
        if(st2->entradas[(uint8_t)i] != NULL)
           goto salir;
      
        i += 1;
        if(i < 256)
            goto checkTdtN2;
        
        free(st2);
        tabla->primera->entradas[(uint8_t)clave[0]] = NULL;
        
    i = 0;
    checkTdtN1: 
        if(tabla->primera->entradas[(uint8_t)i] != NULL)
            goto salir;
        
        i += 1;
        if(i < 256)
            goto checkTdtN1;
        
        free(tabla->primera);
        tabla->primera = NULL;
                
    salir: 
        return;
}

void tdt_imprimirTraducciones(tdt* tabla, FILE *pFile) {   
    fprintf(pFile, "- %s -\n", (char *)tabla->identificacion);
    
    uint16_t i, j, n;
    i = 0; 
    j = 0;
    n = 0;
    
    if(tabla->primera == NULL)
            goto salir;
    
    printSt1Values:; 
        tdtN2 *st2 = tabla->primera->entradas[(uint8_t)i];
        if(st2 == NULL)
            goto continuarSt1;
            
    printSt2Values:; 
        tdtN3 *st3 = st2->entradas[(uint8_t)j]; 
        if(st3 == NULL)
            goto continuarSt2;
            
    printSt3Values: 
        if(st3->entradas[(uint8_t)n].valido == 0)
            goto continuarSt3;
        clave c;
        c.cla[0] = i;
        c.cla[1] = j;
        c.cla[2] = n;
        uint8_t *pVal = st3->entradas[(uint8_t)n].valor.val;
        fprintf(pFile, "%02X%02X%02X => %02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X\n", c.cla[0], c.cla[1], c.cla[2], pVal[0], pVal[1], pVal[2], pVal[3], pVal[4], pVal[5], pVal[6], pVal[7], pVal[8], pVal[9], pVal[10], pVal[11], pVal[12], pVal[13], pVal[14]); //0 padding - 15 bytes - unsigned int - upper case
        goto continuarSt3;
         
    continuarSt1: 
        i += 1;
        if(i < 256)
            goto printSt1Values;
        goto salir;
        
    continuarSt2: 
        j += 1;
        if(j < 256)
            goto printSt2Values;
        j = 0;
        goto continuarSt1;
        
    continuarSt3: 
        n += 1;
        if(n < 256)
            goto printSt3Values;        
        n = 0;
        goto continuarSt2;   
        
    salir: //fclose(pFile);    
    return;       
}

maxmin* tdt_obtenerMaxMin(tdt* tabla) {
  maxmin *mm = (maxmin *)malloc(sizeof(maxmin));
  
  uint8_t value = 0;
  
  mm->max_clave[0] = value;
  mm->max_clave[1] = value;
  mm->max_clave[2] = value;
  
  value = 255;
  
  mm->min_clave[0] = value;
  mm->min_clave[1] = value;
  mm->min_clave[2] = value;
  
  uint8_t m = 0;
  
  ciclo: 
      mm->max_valor[m] = 0;
      mm->min_valor[m] = 255;
      m += 1;
      if(m < 15)
        goto ciclo;
      
    uint16_t i, j, n;
    i = 0; 
    j = 0;
    n = 0;
    
    if(tabla->primera == NULL)
            goto salir;
    
    st1Values:; 
        tdtN2 *st2 = tabla->primera->entradas[(uint8_t)i];
        if(st2 == NULL)
            goto continuarSt1;
            
    st2Values:; 
        tdtN3 *st3 = st2->entradas[(uint8_t)j]; 
        if(st3 == NULL)
            goto continuarSt2;
            
    st3Values: 
        if(st3->entradas[(uint8_t)n].valor.val[15] == 0)
            goto continuarSt3;
            
        clave c;
        c.cla[0] = (uint8_t)i;
        c.cla[1] = (uint8_t)j;
        c.cla[2] = (uint8_t)n;    
            
        if((c.cla[0] > mm->max_clave[0]) || 
           (c.cla[0] == mm->max_clave[0] && c.cla[1] > mm->max_clave[1]) ||
           (c.cla[0] == mm->max_clave[0] && c.cla[1] == mm->max_clave[1] && c.cla[2] > mm->max_clave[2])) {
            mm->max_clave[0] = (uint8_t)i;
            mm->max_clave[1] = (uint8_t)j;
            mm->max_clave[2] = (uint8_t)n;
        }
        
        if((c.cla[0] < mm->min_clave[0]) || 
           (c.cla[0] == mm->min_clave[0] && c.cla[1] < mm->min_clave[1]) ||
           (c.cla[0] == mm->min_clave[0] && c.cla[1] == mm->min_clave[1] && c.cla[2] < mm->min_clave[2])) {
            mm->min_clave[0] = (uint8_t)i;
            mm->min_clave[1] = (uint8_t)j;
            mm->min_clave[2] = (uint8_t)n;    
        }
        
        uint8_t z = 0;
               
        verMayor:
            if(st3->entradas[(uint8_t)n].valor.val[z] < mm->max_valor[z]) {
                z = 0;
                goto verMenor;
            }               
            if(st3->entradas[(uint8_t)n].valor.val[z] > mm->max_valor[z]) {
                goto esMayor;
            }               
            z += 1;
            if(z < 15)
                goto verMayor;
        
        esMayor:
        
        z = 0;    
                   
        loadMaxValue: 
        mm->max_valor[z] = st3->entradas[(uint8_t)n].valor.val[z];
        z += 1;
        if(z < 15)
            goto loadMaxValue;
            
        z = 0;       
               
        verMenor:
            if(st3->entradas[(uint8_t)n].valor.val[z] > mm->min_valor[z]) {
                goto continuarSt3;
            }
            if(st3->entradas[(uint8_t)n].valor.val[z] < mm->min_valor[z]) {
                goto esMenor;
            }               
            z += 1;
            if(z < 15)
                goto verMenor;       
        
        esMenor:
                
        z = 0;
       
        loadMinValue: 
        mm->min_valor[z] = st3->entradas[(uint8_t)n].valor.val[z];
        z += 1;
        if(z < 15)
            goto loadMinValue;
            
        goto continuarSt3;        
         
    continuarSt1: 
        i += 1;
        if(i < 256)
            goto st1Values;
        goto salir;
        
    continuarSt2: 
        j += 1;
        if(j < 256)
            goto st2Values;
        j = 0;
        goto continuarSt1;
        
    continuarSt3: 
        n += 1;
        if(n < 256)
            goto st3Values;        
        n = 0;
        goto continuarSt2;    
  
  salir: 
    return mm;
}
