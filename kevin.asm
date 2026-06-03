DATOS SEGMENT
    MSG_TITULO DB "Nasheeeeee Text Aligner By: Kevin Alva", 13, 10
               DB "You will enter some characters then the program will align them", 13, 10, 10, "$"
    
    MSG_STR    DB "String $"
    MSG_PUNTO  DB " : $"
    STR_NUM    DB '1'

    TXT_TIT_I DB "Left alignment$"
    TXT_TIT_C DB "Center alignment$"
    TXT_TIT_D DB "Right alignment$"
    
    TXT_F7    DB " F7: Align left $"
    TXT_F8    DB " F8: Align center $"
    TXT_F9    DB " F9: Align right $"
    TXT_F10   DB " F10: Exit $"

    CADENAS   DB 5 DUP(37 DUP('$')) ; Matriz 5x37 (36 chars + $)
    LONG      DB 5 DUP(0)           ; Longitudes exactas
    ESTADO    DB 0FFh               ; FF=Esperando, 0=Izq, 1=Cen, 2=Der
DATOS ENDS

PILA SEGMENT PARA STACK 'STACK'
    DB 64 DUP(?)
PILA ENDS

CODIGO SEGMENT
    ASSUME CS:CODIGO, DS:DATOS, SS:PILA

INICIO:
    MOV AX, DATOS
    MOV DS, AX

    MOV AX, 0003h       ; Limpiar pantalla
    INT 10h

    LEA DX, MSG_TITULO
    MOV AH, 09h
    INT 21h

    MOV CX, 5           ; Bucle Mayor
    MOV BX, 0           ; Offset Matriz Cadenas
    MOV SI, 0           ; Offset Arreglo Longitudes

B_MAYOR:
    MOV AH, 09h
    LEA DX, MSG_STR
    INT 21h
    
    MOV AH, 02h
    MOV DL, STR_NUM
    INT 21h
    
    MOV AH, 09h
    LEA DX, MSG_PUNTO
    INT 21h

    MOV DI, 0           ; Bucle Menor

B_MENOR:
    MOV AH, 01h         
    INT 21h
    
    CMP AL, 13          ; ¿Enter?
    JE FIN_LIN
    CMP AL, 8           ; ¿Borrar?
    JE BORRAR
    
    CMP DI, 36          ; ¿Límite?
    JGE DEL_EXCESO      ; Si se pasa, borra visualmente el exceso

    MOV CADENAS[BX+DI], AL
    INC DI
    JMP B_MENOR

DEL_EXCESO:
    MOV AH, 02h
    MOV DL, 8
    INT 21h
    MOV DL, 32
    INT 21h
    MOV DL, 8
    INT 21h
    JMP B_MENOR

BORRAR:
    CMP DI, 0           
    JE B_MENOR
    DEC DI
    MOV CADENAS[BX+DI], '$' 
    
    MOV AH, 02h         
    MOV DL, 32
    INT 21h
    MOV DL, 8
    INT 21h
    JMP B_MENOR

FIN_LIN:
    MOV AX, DI
    MOV LONG[SI], AL    
    ADD BX, 37          
    INC SI
    INC STR_NUM
    
    MOV AH, 02h
    MOV DL, 10
    INT 21h
    LOOP B_MAYOR

    MOV AH, 01h         ; Función BIOS: Set Cursor Shape
    MOV CH, 20h         ; Scanline 20h vuelve invisible al cursor
    MOV CL, 00h
    INT 10h

    MOV DH, 12          ; Línea superior
    CALL DIBUJAR_LINEA_H
    
    MOV DH, 20          ; Línea separadora de menú
    CALL DIBUJAR_LINEA_H

    MOV DH, 22          ; Línea final de tabla
    CALL DIBUJAR_LINEA_H

    LEA SI, TXT_F7
    MOV DH, 21          
    MOV DL, 2           
    MOV BL, 09h         ; Azul
    CALL PRINT_COLOR

    MOV DL, 19
    MOV BL, 0Fh         ; Separador Blanco
    CALL PINTAR_SEP

    LEA SI, TXT_F8
    MOV DL, 21          
    MOV BL, 0Ah         ; Verde
    CALL PRINT_COLOR

    MOV DL, 40
    MOV BL, 0Fh
    CALL PINTAR_SEP

    LEA SI, TXT_F9
    MOV DL, 42          
    MOV BL, 0Eh         ; Amarillo
    CALL PRINT_COLOR

    MOV DL, 60
    MOV BL, 0Fh
    CALL PINTAR_SEP

    LEA SI, TXT_F10
    MOV DL, 62          
    MOV BL, 0Ch         ; Rojo
    CALL PRINT_COLOR

ESPERA:
    MOV AH, 00h         
    INT 16h
    CMP AL, 00h         
    JNE ESPERA

    CMP AH, 41h         ; F7
    JE SET_IZQ
    CMP AH, 42h         ; F8
    JE SET_CEN
    CMP AH, 43h         ; F9
    JE SET_DER
    CMP AH, 44h         ; F10
    JE SALIR
    JMP ESPERA          

SET_IZQ: 
    MOV ESTADO, 0 
    CALL IMPRIMIR
    JMP ESPERA
SET_CEN: 
    MOV ESTADO, 1 
    CALL IMPRIMIR
    JMP ESPERA
SET_DER: 
    MOV ESTADO, 2 
    CALL IMPRIMIR
    JMP ESPERA

SALIR: 
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 23
    MOV DL, 0
    INT 10h

    MOV AH, 01h
    MOV CH, 06h
    MOV CL, 07h
    INT 10h

    MOV AX, 4C00h 
    INT 21h

IMPRIMIR PROC
    CALL LIMPIAR_INTERIOR 

    CMP ESTADO, 0
    JE LBL_IZQ
    CMP ESTADO, 1
    JE LBL_CEN
    
LBL_DER:
    LEA SI, TXT_TIT_D
    MOV DL, 64          
    MOV BL, 0Eh         
    JMP PINTAR_TIT_LBL

LBL_IZQ:
    LEA SI, TXT_TIT_I
    MOV DL, 1           
    MOV BL, 09h         
    JMP PINTAR_TIT_LBL

LBL_CEN:
    LEA SI, TXT_TIT_C
    MOV DL, 32          
    MOV BL, 0Ah         

PINTAR_TIT_LBL:
    MOV DH, 13          
    CALL PRINT_COLOR

    MOV CX, 5
    MOV BX, 0
    MOV SI, 0
    MOV DH, 15          

C_IMP:
    MOV AL, 80          
    SUB AL, LONG[SI]    
    
    CMP ESTADO, 0       
    JE C_IZQ
    CMP ESTADO, 2       
    JE F_CUR
    
    SHR AL, 1           
    JMP F_CUR

C_IZQ:
    MOV AL, 0           

F_CUR:
    MOV DL, AL
    CALL MOVER_CUR      

    PUSH DX             
    LEA DX, CADENAS
    ADD DX, BX          
    MOV AH, 09h
    INT 21h
    POP DX              

    INC DH              
    INC SI
    ADD BX, 37          
    LOOP C_IMP
    RET
IMPRIMIR ENDP

DIBUJAR_LINEA_H PROC
    PUSH CX
    PUSH DX
    MOV DL, 0
    MOV CX, 80
DL_LOOP:
    CALL MOVER_CUR
    PUSH DX
    MOV AH, 02h
    MOV DL, '-'
    INT 21h
    POP DX
    INC DL
    LOOP DL_LOOP
    POP DX
    POP CX
    RET
DIBUJAR_LINEA_H ENDP

PINTAR_SEP PROC
    CALL MOVER_CUR
    PUSH DX
    MOV AH, 09h
    MOV AL, '|'
    MOV BH, 0
    MOV CX, 1
    INT 10h
    POP DX
    RET
PINTAR_SEP ENDP

MOVER_CUR PROC
    PUSH AX
    PUSH BX
    MOV AH, 02h
    MOV BH, 0
    INT 10h
    POP BX
    POP AX
    RET
MOVER_CUR ENDP

LIMPIAR_INTERIOR PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AX, 0600h       
    MOV BH, 07h         
    MOV CH, 13          
    MOV CL, 0           
    MOV DH, 19          
    MOV DL, 79          
    INT 10h
    POP DX
    POP CX
    POP BX
    POP AX
    RET
LIMPIAR_INTERIOR ENDP

PRINT_COLOR PROC
PC_LOOP:
    MOV AL, [SI]
    CMP AL, '$'
    JE PC_FIN           
    
    CALL MOVER_CUR      
    
    PUSH AX
    PUSH BX
    PUSH CX
    MOV AH, 09h         
    MOV BH, 0
    MOV CX, 1           
    INT 10h
    POP CX
    POP BX
    POP AX
    
    INC DL              
    INC SI              
    JMP PC_LOOP
PC_FIN:
    RET
PRINT_COLOR ENDP

CODIGO ENDS
END INICIO