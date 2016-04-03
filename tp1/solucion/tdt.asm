; FUNCIONES de C
  extern malloc
  extern free
  extern strcpy
  extern tdt_agregar
  extern tdt_borrar
  
; FUNCIONES
   global tdt_crear
   global tdt_recrear
   global tdt_cantidad
   global tdt_agregarBloque
   global tdt_agregarBloques
   global tdt_borrarBloque
   global tdt_borrarBloques
   global tdt_traducir
   global tdt_traducirBloque
   global tdt_traducirBloques
   global tdt_destruir

; /** defines offsets y size: struct TDT**/
  %define TDT_OFFSET_IDENTIFICACION   0
  %define TDT_OFFSET_PRIMERA          8
  %define TDT_OFFSET_CANTIDAD        16
  %define TDT_SIZE                   20
; /** defines offsets y size: constants**/
  %define NULL 0
  %define ZERO 0
  %define ADDRESS_SIZE 8
; /** defines offsets y size: bloque**/
  %define BLOQUE_OFFSET_CLAVE 0
  %define BLOQUE_OFFSET_VALOR 3
; /** defines offsets y size: tdtN3**/
  %define TDTN3_OFFSET_VALOR 0
  %define TDTN3_OFFSET_VALIDO 15
  
; MODO DE USO DE REGISTROS!
; R8  R9  R10  R11 LOS USO COMO QUIERO PERO OJO CON R8 Y R9
; RBX R12 R13 R14 R15 PUSHEARLOS!!
; ORDEN DE LOS PARAMETROS: RDI RSI RDX RCX R8 R9 (integers) OJO cuando hay varios parametros | XMMn (. flotante) n <= 15
; RETORNO: RAX o XMM0
; SUB RSP, <bytes> PARA RESERVAR VARIABLES LOCALES Y PARA ALINEARSE. LUEGO: ADD RSP, <bytes> PARA REESTABLECER
; stn = sub-table n = number
section .text

; =====================================
; tdt* tdt_crear(char* identificacion)
tdt_crear:
	PUSH RBP
	MOV RBP, RSP
    PUSH RBX
    PUSH R12 ; alineado
    
    XOR RBX, RBX
    XOR R12, R12
    MOV RBX, RDI ; almaceno identificacion
    CMP RBX, NULL
    JE .crearTdt
    
    XOR RCX, RCX ; contador de bytes para longitud de la nueva identificacion 
    XOR R10, R10 ; almaceno los char de identificacion
    
.contar:
    MOV R10B, [RBX + RCX] ; recorro los bytes de identificacion hasta encontrar un NULL   
    CMP R10B, ZERO ; si es el final. PRE: un string siempre termina en 0x0
    JE .seguir    
    ADD RCX, 1
    JMP .contar
    
.seguir:
    ADD RCX, 1
    MOV RDI, RCX; tamaño de *(identificacion)
    CALL malloc ; char* myId    
    MOV R12, RAX ; almaceno el puntero a myId
    MOV RDI, RAX ; almaceno myId en el primer parametro de strcpy
    MOV RSI, RBX ; source
    CALL strcpy ; copia desde identificacion a myId
    
.crearTdt:
    MOV RDI, TDT_SIZE ; piso identificacion 
	CALL malloc
	MOV QWORD [RAX + TDT_OFFSET_IDENTIFICACION], R12 ; tabla->identificacion = identificacion	
	MOV QWORD [RAX + TDT_OFFSET_PRIMERA], NULL ; tabla->primera = NULL
	MOV DWORD [RAX + TDT_OFFSET_CANTIDAD], ZERO ; tabla->cantidad = 0
	
    POP R12
    POP RBX  
    POP RBP
	RET

; =====================================
; void tdt_recrear(tdt** tabla, char* identificacion)
tdt_recrear:
    PUSH RBP
	MOV RBP, RSP
    PUSH RBX
    PUSH R12
    PUSH R13
    PUSH R14
    PUSH R15
    SUB RSP, 8 ; alineado
    
    XOR RBX, RBX
    XOR R12, R12
    XOR R13, R13
    XOR R14, R14
    XOR R15, R15
    
	MOV R13, [RDI] ; *(tabla)
    MOV R14, RSI ; almaceno identificacion	
    CMP R14, NULL ; identificacion == NULL?
	JE .identificacionNull
	
    XOR RCX, RCX ; contador de bytes para longitud de la nueva identificacion
    XOR R10, R10 ; almaceno los char de identificacion
    
.contar:
    MOV R10B, [R14 + RCX]
    CMP R10B, ZERO
    JE .seguir
    ADD RCX, 1
    JMP .contar
    
.seguir:
    ADD RCX, 1
    MOV RDI, RCX
    call malloc ; nuevo char* myId 
    MOV RBX, RAX ; almaceno myId    
    MOV RDI, RAX ;  almaceno myId en el primer parametro de strcpy - RSI ya contiene identificacion
    MOV RSI, R14 ; vuelvo a almacenar el puntero de identificacion porque puede no preservarse
    call strcpy ; copia desde identificacion a myId
    
    MOV RDI, [R13 + TDT_OFFSET_IDENTIFICACION] ; pTabla->identificacion
    CMP RDI, NULL
    JE .pisar
    call free
    
.pisar:
    MOV QWORD [R13 + TDT_OFFSET_IDENTIFICACION], RBX ; pTabla->identificacion = myId

.identificacionNull:
    MOV DWORD [R13 + TDT_OFFSET_CANTIDAD], ZERO
    
    XOR R14, R14 ; i uso R14W? puedo sumarlo a R13?
    XOR R15, R15 ; j uso R15W? puedo sumarlo a R13?
 
.vaciarSt1:    
    MOV RCX, [R13 + TDT_OFFSET_PRIMERA] ; pTabla->primera
    CMP RCX, NULL ; primera == NULL?
    JE .salir
    MOV RBX, [RCX + R14*ADDRESS_SIZE] ; tdtN2 *st2 = primera->entradas[i]
    CMP RBX, NULL ; st2 == NULL?
    JE .continuarSt1
    
.vaciarSt2:
    MOV R12, [RBX + R15*ADDRESS_SIZE] ; tdtN3 *st3 = st2->entradas[j]
    CMP R12, NULL ; st3 == NULL?
    JE .continuarSt2
    
    MOV RDI, R12 ; piso tabla con st3    
    CALL free ; free sabe
    MOV QWORD [RBX + R15*ADDRESS_SIZE], NULL ; st2->entrads[j] = NULL
    JMP .continuarSt2
    
.continuarSt1:
    ADD R14, 1
    CMP R14, 256
    JL .vaciarSt1
    
    MOV RDI, [R13 + TDT_OFFSET_PRIMERA] ; piso lo que haya en RDI con primera
    CALL free
    
    MOV QWORD [R13 + TDT_OFFSET_PRIMERA], NULL ; pTabla->primera = NULL
    JMP .salir
       
.continuarSt2:
    ADD R15, 1
    CMP R15, 256
    JL .vaciarSt2
    MOV R15, ZERO
    MOV RDI, RBX ; piso lo que haya en RDI con st2
    call free
    MOV RCX, [R13 + TDT_OFFSET_PRIMERA] ; pTabla->primera - vuelvo a almacenar porque puede no preservarse
    MOV QWORD [RCX + R14*ADDRESS_SIZE], NULL ; primera->entradas[i] = NULL
    JMP .continuarSt1

.salir:
    ADD RSP, 8
    POP R15
    POP R14
    POP R13
    POP R12
    POP RBX
    POP RBP
    RET     

; =====================================
; uint32_t tdt_cantidad(tdt* tabla)
tdt_cantidad:
    PUSH RBP
	MOV RBP, RSP
	
    XOR RAX, RAX
    MOV EAX, [RDI + TDT_OFFSET_CANTIDAD]
    
    POP RBP
    RET
    
; =====================================
; void tdt_agregarBloque(tdt* tabla, bloque* b)
tdt_agregarBloque:
    PUSH RBP
	MOV RBP, RSP
    MOV R9, RSI
    
    LEA RSI, [R9 + BLOQUE_OFFSET_CLAVE]
    LEA RDX, [R9 + BLOQUE_OFFSET_VALOR]
    CALL tdt_agregar
    
    POP RBP
    RET

; =====================================
; void tdt_agregarBloques(tdt* tabla, bloque** b)
tdt_agregarBloques:
    PUSH RBP
	MOV RBP, RSP
    PUSH RBX
    PUSH R12
    PUSH R13
    PUSH R14 ; alineado
    
    MOV RBX, RDI
    MOV R12, RSI
    XOR R13, R13
    
.ciclo:
    MOV R14, [R12 + R13*ADDRESS_SIZE]
    CMP R14, ZERO
    JE .salir
    
    MOV RDI, RBX
    MOV RSI, R14
    CALL tdt_agregarBloque
    ADD R13, 1
    JMP .ciclo
    
.salir:
    POP R14
    POP R13
    POP R12
    POP RBX
    POP RBP
    RET
        
; =====================================
; void tdt_borrarBloque(tdt* tabla, bloque* b)
tdt_borrarBloque:
    PUSH RBP
	MOV RBP, RSP
	
    LEA RSI, [RSI + BLOQUE_OFFSET_CLAVE]
    CALL tdt_borrar
    
    POP RBP
    RET
        
; =====================================
; void tdt_borrarBloques(tdt* tabla, bloque** b)
tdt_borrarBloques:
    PUSH RBP
	MOV RBP, RSP
    PUSH RBX
    PUSH R12
    PUSH R13
    PUSH R14 ; alineado
    
    MOV RBX, RDI
    MOV R12, RSI
    XOR R13, R13
.ciclo:
    MOV R14, [R12 + R13*ADDRESS_SIZE]
    CMP R14, ZERO
    JE .salir
    
    MOV RDI, RBX
    MOV RSI, R14
    CALL tdt_borrarBloque
    ADD R13, 1
    JMP .ciclo
    
.salir:
    POP R14
    POP R13
    POP R12
    POP RBX
    POP RBP
    RET
        
; =====================================
; void tdt_traducir(tdt* tabla, uint8_t* clave, uint8_t* valor)
tdt_traducir:
    PUSH RBP
	MOV RBP, RSP
    PUSH RBX
    PUSH R12
    PUSH R13
    SUB RSP, 8 ; alineado
    
    MOV RBX, RDI ; tabla
    MOV R12, RSI ; clave
    MOV R13, RDX ; valor
    
    MOV RCX, [RBX + TDT_OFFSET_PRIMERA] ; tabla->primera
    CMP RCX, NULL
    JE .salir
    
    XOR R8, R8
    MOV R8B, [R12] ; clave[0]
    MOV R9, [RCX + R8*ADDRESS_SIZE] ; tdtN2 *st2 = primera->entradas[clave[0]]
    CMP R9, NULL
    JE .salir
    
    MOV R8B, [R12 + 1] ; clave[1]
    MOV R10, [R9 + R8*ADDRESS_SIZE] ; tdtN3 *st3 = st2->entradas[clave[1]]
    CMP R10, NULL
    JE .salir
    
    MOV R8B, [R12 + 2] ; clave[2]
    XOR R9, R9
    LEA R11, [R10 + R8*ADDRESS_SIZE]
    LEA R11, [R11 + R8*ADDRESS_SIZE] ; son 16 bytes por valor valido
    MOV R9B, [R11 + TDTN3_OFFSET_VALIDO] ; st3->entradas[clave[2]].valido
    CMP R9B, ZERO
    JE .salir
    
    XOR RCX, RCX ; int i = 0;
    
.ciclo:
    LEA R11, [R10 + R8*ADDRESS_SIZE]
    LEA R11, [R11 + R8*ADDRESS_SIZE] ; son 16 bytes por valor valido
    LEA R11, [R11 + TDTN3_OFFSET_VALOR] 
    MOV R9B, [R11 + RCX] ; st3->entradas[clave[2]].valor.val[i];
    MOV BYTE [R13 + RCX], R9B ; valor[i] = st3->entradas[clave[2]].valor.val[i];
    ADD RCX, 1
    CMP RCX, 15
    JL .ciclo
    
.salir:
    ADD RSP, 8 ; alineado
    POP R13
    POP R12
    POP RBX
    POP RBP
    RET         
; =====================================
; void tdt_traducirBloque(tdt* tabla, bloque* b)
tdt_traducirBloque:
    PUSH RBP
	MOV RBP, RSP
	
    MOV R9, RSI
    LEA RSI, [R9 + BLOQUE_OFFSET_CLAVE]
    LEA RDX, [R9 + BLOQUE_OFFSET_VALOR]
    CALL tdt_traducir
    
    POP RBP
    RET

; =====================================
; void tdt_traducirBloques(tdt* tabla, bloque** b)
tdt_traducirBloques:
    PUSH RBP
	MOV RBP, RSP
    PUSH RBX
    PUSH R12
    PUSH R13
    PUSH R14 ; alineado
    
    MOV RBX, RDI
    MOV R12, RSI
    XOR R13, R13
    
.ciclo:
    MOV R14, [R12 + R13*ADDRESS_SIZE]
    CMP R14, ZERO
    JE .salir
    
    MOV RDI, RBX
    MOV RSI, R14
    CALL tdt_traducirBloque
    ADD R13, 1
    JMP .ciclo
    
.salir:
    POP R14
    POP R13
    POP R12
    POP RBX
    POP RBP
    RET
        
; =====================================
; void tdt_destruir(tdt** tabla)
tdt_destruir:
    PUSH RBP
	MOV RBP, RSP
    PUSH RBX
    SUB RSP, 8 ; alineado
    
    MOV RBX, [RDI] ; tdt* pTabla = *tabla
    MOV RSI, RDI
    MOV RDI, [RBX + TDT_OFFSET_IDENTIFICACION] ; char *myId = pTabla->identificacion
    
    CMP RDI, NULL
    JE .continuar
    CALL free
    
.continuar:
    MOV RDI, RSI
    MOV RSI, NULL
    CALL tdt_recrear
    
    MOV RDI, RBX
    CALL free
    
    ADD RSP, 8
    POP RBX
    POP RBP
    RET 

