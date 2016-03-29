; FUNCIONES de C
  extern malloc
  extern free
  extern strcpy
  extern tdt_agregar
  extern tdt_borrar
  
; FUNCIONES
  global tdt_crear
;  global tdt_recrear
;  global tdt_cantidad
;  global tdt_agregarBloque
;  global tdt_agregarBloques
;  global tdt_borrarBloque
;  global tdt_borrarBloques
;  global tdt_traducir
;  global tdt_traducirBloque
;  global tdt_traducirBloques
;  global tdt_destruir

; /** defines offsets y size: struct TDT**/
  %define TDT_OFFSET_IDENTIFICACION   0
  %define TDT_OFFSET_PRIMERA          8
  %define TDT_OFFSET_CANTIDAD        16
  %define TDT_SIZE                   20
; /** defines offsets y size: constants**/
  %define NULL 0
  %define ZERO 0

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
	MOV R9, RDI ; guardo identificacion
	MOV RDI, TDT_SIZE ; piso identificacion 
	CALL malloc
	MOV QWORD [RAX + TDT_OFFSET_IDENTIFICACION], R9 ; tabla->identificacion = identificacion	
	MOV QWORD [RAX + TDT_OFFSET_PRIMERA], NULL ; tabla->primera = NULL
	MOV DWORD [RAX + TDT_OFFSET_CANTIDAD], ZERO ; tabla->cantidad = 0
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
	MOV RDX, [RDI] ; *(tabla)
	CMP RSI, NULL ; identificacion == NULL?
	JE .identificacionNull
	MOV QWORD [RDX + TDT_OFFSET_IDENTIFICACION], RSI ; pTabla->identificacion = identificacion

.identificacionNull:
    MOV DWORD [RDX + TDT_OFFSET_CANTIDAD], ZERO
    
    XOR R8, R8 ; i uso R8W? puedo sumarlo a RDX?
    XOR R9, R9 ; j uso R9W? puedo sumarlo a RDX?
    
    MOV RCX, [RDX + TDT_OFFSET_PRIMERA] ; pTabla->primera
    CMP RCX, NULL ; primera == NULL?
    JE .salir

.vaciarSt1:
    MOV RBX, [RCX] ; primera->entradas
    MOV RBX, [RBX + R8] ; tdtN2 *st2 = entradas[i]
    CMP RBX, NULL ; st2 == NULL?
    JE .continuarSt1
.vaciarSt2:
    MOV R12, [RBX] ; st2->entradas
    MOV R12, [R12 + R9] ; tdtN3 *st3 = entradas[j]
    CMP R12, NULL ; st3 == NULL?
    JE .continuarSt2
    MOV RDI, R12 ; piso tabla con st3    
    CALL free ; free sabe
    MOV R12, [RBX] ; st2->entradas
    MOV QWORD [R12 + R9], NULL ; entrads[j] = NULL
    JMP .continaurSt2
    
.continuarSt1:
    ADD R8, 1
    CMP R8, 256
    JL .vaciarSt1
    MOV RDI, RCX ; piso lo que haya en RDI con primera
    CALL free
    MOV QWORD [RDX + TDT_OFFSET_PRIMERA], NULL ; pTabla->primera = NULL
    JMP .salir
       
.continuarSt2:
    ADD R9, 1
    CMP R9, 256
    JL .vaciarSt2
    MOV R9, 0
    MOV RDI, RBX ; piso lo que haya en RDI con st2
    call free
    MOV RBX, [RCX] ; piso st2 con primera->entradas
    MOV QWORD [RBX + R8], NULL

.salir:
    SUB RSP, 8
    PUSH R15
    PUSH R14
    PUSH R13
    PUSH R12
    PUSH RBX
    POP RBP
    RET     

; =====================================
; uint32_t tdt_cantidad(tdt* tabla)
tdt_cantidad:

; =====================================
; void tdt_agregarBloque(tdt* tabla, bloque* b)
tdt_agregarBloque:

; =====================================
; void tdt_agregarBloques(tdt* tabla, bloque** b)
tdt_agregarBloques:
        
; =====================================
; void tdt_borrarBloque(tdt* tabla, bloque* b)
tdt_borrarBloque:
        
; =====================================
; void tdt_borrarBloques(tdt* tabla, bloque** b)
tdt_borrarBloques:
        
; =====================================
; void tdt_traducir(tdt* tabla, uint8_t* clave, uint8_t* valor)
tdt_traducir:
        
; =====================================
; void tdt_traducirBloque(tdt* tabla, bloque* b)
tdt_traducirBloque:

; =====================================
; void tdt_traducirBloques(tdt* tabla, bloque** b)
tdt_traducirBloques:
        
; =====================================
; void tdt_destruir(tdt** tabla)
tdt_destruir:


