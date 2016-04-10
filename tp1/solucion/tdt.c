#include "tdt.h"

void tdt_agregar(tdt* tabla, uint8_t* clave, uint8_t* valor) {
    if(tabla->primera == NULL) {
        tabla->primera = (tdtN1 *)malloc(sizeof(tdtN1));
        uint16_t n1 = 0;
        while(n1 < 256) {
            tabla->primera->entradas[n1] = NULL;
            n1 += 1;
        }
    }

    tdtN2* st2 = tabla->primera->entradas[clave[0]];
    
    if(st2 == NULL) {
        st2 = (tdtN2 *)malloc(sizeof(tdtN2));
        uint16_t n2 = 0;
        while(n2 < 256) {
            st2->entradas[n2] = NULL;
            n2 += 1;
        }
                
        tabla->primera->entradas[clave[0]] = st2;
    }
   
    tdtN3* st3 = st2->entradas[clave[1]];

    if(st3 == NULL) {
        st3 = (tdtN3 *)malloc(sizeof(tdtN3));
        uint16_t n3 = 0;
        while(n3 < 256) {
            st3->entradas[n3].valido = 0;
            n3 += 1;
        }
                  
        st2->entradas[clave[1]] = st3;
    }
        
    uint8_t i = 0;
  
    uint8_t *v = &st3->entradas[clave[2]].valido;
    if(*v == 0) {
        *v = 1;
        tabla->cantidad += 1;
    }
   
    while(i < 15) {     
        st3->entradas[clave[2]].valor.val[i] = valor[i];
        i += 1;
    }

    return;
}

void tdt_borrar(tdt* tabla, uint8_t* clave) {
    if(tabla->primera == NULL)
        return;
        
    tdtN2 *st2 = tabla->primera->entradas[clave[0]];
    
    if(st2 == NULL)
        return;
    
    tdtN3 *st3 = st2->entradas[clave[1]];
    
    if(st3 == NULL)
        return;
    
    uint16_t i = 0;

    uint8_t *v = &st3->entradas[clave[2]].valido;
    if(*v == 0)
        return;
    
    tabla->cantidad -= 1;
    while(i < 15) { 
        st3->entradas[clave[2]].valor.val[i] = 0;
        i += 1;
    }
    st3->entradas[clave[2]].valido = 0;
    
    i = 0;    
    while(i < 256) { 
        if(st3->entradas[i].valido == 1)
            return;
        
        i += 1;
    }
         
    free(st3);
    st2->entradas[clave[1]] = NULL;
        
    i = 0;
    while(i < 256) { 
        if(st2->entradas[i] != NULL)
           return;
      
        i += 1;
    }
        
    free(st2);
    tabla->primera->entradas[clave[0]] = NULL;
        
    i = 0;
    while(i < 256) { 
        if(tabla->primera->entradas[i] != NULL)
            return;
        
        i += 1;
    }
        
    free(tabla->primera);
    tabla->primera = NULL;
            
    return;
}

void tdt_imprimirTraducciones(tdt* tabla, FILE *pFile) {   
    fprintf(pFile, "- %s -\n", (char *)tabla->identificacion);
    
    uint16_t i, j, n;
    i = 0; 
    j = 0;
    n = 0;
    
    if(tabla->primera == NULL)
        return;
    
    while(i < 256) { 
        tdtN2 *st2 = tabla->primera->entradas[i];
        if(st2 != NULL) {
            j = 0;  
            while(j < 256) {
                n = 0;
                tdtN3 *st3 = st2->entradas[j]; 
                if(st3 != NULL) {                        
                    while(n < 256) { 
                        if(st3->entradas[n].valido != 0) {
                            clave c;
                            c.cla[0] = i;
                            c.cla[1] = j;
                            c.cla[2] = n;
                            uint8_t *pVal = st3->entradas[n].valor.val;
                            fprintf(pFile, "%02X%02X%02X => %02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X\n", c.cla[0], c.cla[1], c.cla[2], pVal[0], pVal[1], pVal[2], pVal[3], pVal[4], pVal[5], pVal[6], pVal[7], pVal[8], pVal[9], pVal[10], pVal[11], pVal[12], pVal[13], pVal[14]); //0 padding - 15 bytes - unsigned int - upper case
                        }
                        n += 1;
                    }
                }
                j += 1;
            }    
        }     
        i += 1;
    }
                
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

    while(m < 15) { 
        mm->max_valor[m] = 0;
        mm->min_valor[m] = 255;
        m += 1;
    }
      
    uint16_t i, j, n;
    i = 0; 
    j = 0;
    n = 0;
    
    if(tabla->primera == NULL)
        return mm;
    
    while(i < 256) {
        tdtN2 *st2 = tabla->primera->entradas[i];
        if(st2 != NULL) {
            j = 0;
            
            while(j < 256) {
                tdtN3 *st3 = st2->entradas[j]; 
                if(st3 != NULL) {
                    n = 0;
                    
                    while(n < 256) { 
                        if(st3->entradas[n].valor.val[15] != 0) {
                         
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
                                   
                            while(z < 15) {
                                if(st3->entradas[n].valor.val[z] < mm->max_valor[z]) {
                                    z = 0;
                                    break;
                                }               
                                if(st3->entradas[n].valor.val[z] > mm->max_valor[z]) {
                                    z = 0;       
                                    while(z < 15) { 
                                        mm->max_valor[z] = st3->entradas[n].valor.val[z];
                                        z += 1;
                                    }
                                }               
                                z += 1;
                            }
                                
                            z = 0;       
                                   
                            while(z < 15) {
                                if(st3->entradas[n].valor.val[z] > mm->min_valor[z]) {
                                    break;
                                }
                                if(st3->entradas[n].valor.val[z] < mm->min_valor[z]) {
                                    z = 0;
                                    while(z < 15) {
                                        mm->min_valor[z] = st3->entradas[n].valor.val[z];
                                        z += 1;
                                    }
                                }               
                                z += 1;
                            }             
                        }
                        n += 1;
                    }
                }
                j += 1; 
            }
        }
        i += 1;
    }    

    return mm;
}

/*tdt* tdt_crear(char* identificacion) {
    tdt *tabla = (tdt *)malloc(sizeof(tdt));

    char* myId = NULL;

    if(identificacion != NULL) {
        char letra;
        int contadorBytes = 0;
        contar:
            letra = identificacion[contadorBytes];
            contadorBytes += 1;
            if((int)letra != 0)
                goto contar;

            contadorBytes += 1;

        myId = (char *)malloc(contadorBytes);

        strcpy(myId, identificacion);
    }

    tabla->identificacion = myId;
    tabla->primera = NULL;
    tabla->cantidad = 0;
    
    return tabla;
}

void tdt_recrear(tdt** tabla, char* identificacion) {
    tdt *pTabla = *tabla;

    if(identificacion != NULL) {
        char letra;
        int contadorBytes = 0;
        contar:
            letra = identificacion[contadorBytes];
            contadorBytes += 1;
            if((int)letra != 0)
                goto contar;

            contadorBytes += 1;

        char* myId = (char *)malloc(contadorBytes);

        strcpy(myId, identificacion);

        if(pTabla->identificacion != NULL)
            free(pTabla->identificacion);

        pTabla->identificacion = myId;        
    }
    
    pTabla->cantidad = 0;
    
    uint16_t i, j;
    i = 0; 
    j = 0;

    if(pTabla->primera == NULL)
        goto salir;

    vaciarSt1:; 
    tdtN2 *st2 = pTabla->primera->entradas[i];
    if(st2 == NULL)
        goto continuarSt1;
            
    vaciarSt2:; 
    tdtN3 *st3 = st2->entradas[j]; 
        if(st3 == NULL)
            goto continuarSt2;
        free(st3);
        st2->entradas[j] = NULL;
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
        pTabla->primera->entradas[i] = NULL;
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
    
    tdtN2* st2 = tabla->primera->entradas[clave[0]];
    
    if(st2 == NULL)
        goto salir;

    tdtN3* st3 = st2->entradas[clave[1]];

    if(st3 == NULL)
        goto salir;
       
    if(st3->entradas[clave[2]].valido == 0)
        goto salir;
   
    uint8_t i = 0;
   
    ciclo:
        valor[i] = st3->entradas[clave[2]].valor.val[i];
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
}*/
