; We STRUCing 2026-05-23 16:38:46
InputBuffer STRUC 
    MaxLen DB 69
    Len DB 0
    ArrayChar DB 69 DUP('$') 
InputBuffer ENDS

DataSg SEGMENT PARA PUBLIC 'DATA'
    StrTitle DB "White Astroemeria Text Aligner [Beta] Author: Gerardo Venegas",10,"$" ; Uyyy un titulo 2026-05-23 13:29:28
    StrInstrucction DB "You will enter a maximum of 68 characters, otherwise things break",10,"$" ; Creo que muy poco :c 2026-05-23 16:13:00
    ArrayInput InputBuffer 5 DUP(<>) ; Un Array 2026-05-23 17:08:58
    StrLabel DB 10,10,"String $" ; Una label para los strings a inputear 2026-05-23 17:25:53
    StrLable DB " : $"; Al proposito hago las cosas confusas yo 2026-05-23 17:26:27
    StrOption1 DB "  F7: Align left   $"
    StrOption2 DB " F8: Align center  $"
    StrOption3 DB "  F9: Align right  $"
    StrOption4 DB "    F10: Exit     $" ; Cambios, muchos cambios 2026-05-23 20:02:37
DataSg ENDS

; Deberia hacerlo extra complicado y capturar input por input :) creo que mucho seria eso ya 2026-05-23 16:14:10

StackSg SEGMENT PARA STACK 'STACK'
    DW 64 DUP(0)    ;Puede ser util luego 2026-05-23 13:26:53 
StackSg ENDS

CodeSg SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:CodeSg, DS:DataSg, SS:StackSg ; Colocamos los segmentos 2026-05-23 16:02:45
    
    ; Mmm, me suena a algo de C creo 2026-05-23 16:25:18
    Print MACRO str
        MOV AH, 09h;
        LEA DX, str
        INT 21h
    ENDM

    PrintChar MACRO charac, times
    LOCAL PCLoop
    MOV AL, charac
    MOV CX, times
    PCLoop:
        INT 10h
    Loop PCLoop
    ENDM

    ; Me seria util un print, pero formatted 2026-05-23 20:03:08
    Printf MACRO str, col, x, y
        PUSH AX ; Guardamos todos los registros, esta va a ser una operación bastante larga 2026-05-23 20:10:41
        PUSH BX
        PUSH CX
        PUSH DX 
        PUSHF ; Si sirvió el stack :o 2026-05-23 20:08:37

        MOV AH, 03h 
        MOV BH, 00h
        INT 10h ; Recogemos la ubicacion del cursor 2026-05-23 20:10:15
        PUSH DX ; Guardamos la ubicacion del cursor 2026-05-23 20:10:16

        MOV AH, 02h
        MOV BH, 00h
        MOV DH, y
        MOV DL, x
        INT 10h ; Movemos el cursor 2026-05-23 20:16:34

        MOV AH, 09h
        MOV AL, 20h
        MOV BH, 00h
        MOV BL, col
        MOV CX, 1
        INT 10h ; Aplicamos el atributo de color a utilizar 2026-05-23 20:18:23

        MOV AH, 09h
        LEA DX, str
        INT 21h ; Imprimimos el str dado 2026-05-23 20:18:28

        MOV AH, 08h
        MOV BH, 00h
        INT 10h

        MOV AH, 09h
        MOV BH, 00h
        MOV BL, 07h
        MOV CX, 1
        INT 10h ; Reiniciamos color 2026-05-23 21:10:24

        POP DX 
        MOV AH, 02h
        MOV BH, 00h
        INT 10h ; Restauramos cursor 2026-05-23 21:10:50

        POPF
        POP DX
        POP CX
        POP BX
        POP AX
    ENDM ; Un printf, interesante. Aunque no funciona nada como el printf de C 2026-05-23 21:11:56

    Start: ; Parece un entry point, no? 2026-05-23 16:03:06

    MOV AX, DataSg ; Colocamos el DS en su lugar 2026-05-23 16:04:59
    MOV DS, AX

    MOV AX, StackSg ; Lo mismo para SS, no se si se utilizará 2026-05-23 16:05:13
    MOV SS, AX
    MOV SP, 128 

    ; Imprimimos el titulo, muy importante para el desarrollo del programa 2026-05-23 16:05:59
    Print StrTitle 

    ; Go 21h, imprimimos las instrucciones, excesos de importancia en esta parte 2026-05-23 16:18:07
    ; Para algo estoy haciendo macros, utilizamos macros  2026-05-23 16:28:18
    Print StrInstrucction

    MOV CX, 5 ; 5 
    LEA BX, ArrayInput
    LeLoop: ; Loop para obtener los 5 str 2026-05-23 16:55:17
        Print StrLabel ; Imprimimos el label de cada string imputeado
        MOV AH, 02h
        MOV DL, 6
        SUB DL, CL
        ADD DL, 48
        INT 21h
        Print StrLable

        MOV AH, 0Ah
        MOV DX, BX
        INT 21h ; Usamos buffered input para captar datos de stdin 2026-05-23 17:37:39

        ADD BX, 73 ; Cositas de arrays 2026-05-23 17:37:57
        ; Sabias que en c array[12] y 12[array] hacen exactamente lo mismo? 2026-05-23 17:39:01
    Loop LeLoop

    MOV AH, 02h ; Preparamos nuestra GUI super interactiva 2026-05-23 17:52:19
    MOV DL, 10
    INT 21h
    INT 21h

    ; We teletypin 2026-05-23 17:54:51
    ; Lo mejor de usar linux es bootear directamente a TTY1, nadie que me agarre la laptop sabrá que hacer 2026-05-23 17:55:34

    MOV AH, 0Eh ; Que linda interrupt 2026-05-23 17:56:22
    MOV AL, 0DAh
    INT 10h

    PrintChar 0C4h 78

    MOV AL, 0BFh
    INT 10h

    MOV AL, 0B3h
    INT 10h

    PrintChar 020h 78

    MOV AL, 0B3h
    INT 10h

    MOV AL, 0C3h
    INT 10h

    PrintChar 0C4h 78

    MOV AL, 0B4h
    INT 10h

    MOV AL, 0B3h
    INT 10h

    PrintChar 020h 78

    MOV AL, 0B3h
    INT 10h

    MOV AL, 0B3h
    INT 10h

    PrintChar 020h 78

    MOV AL, 0B3h
    INT 10h

    MOV AL, 0B3h
    INT 10h

    PrintChar 020h 78

    MOV AL, 0B3h
    INT 10h

    MOV AL, 0B3h
    INT 10h

    PrintChar 020h 78

    MOV AL, 0B3h
    INT 10h

    MOV AL, 0B3h
    INT 10h

    PrintChar 020h 78

    MOV AL, 0B3h
    INT 10h

    MOV AL, 0C3h
    INT 10h

    PrintChar 0C4h 19

    MOV AL, 0C2h
    INT 10h

    PrintChar 0C4h 19

    MOV AL, 0C2h
    INT 10h

    PrintChar 0C4h 19
    
    MOV AL, 0C2h
    INT 10h

    PrintChar 0C4h 18

    MOV AL, 0B4h
    INT 10h

    MOV AL, 0B3h
    INT 10h

    PrintChar 020h 19

    MOV AL, 0B3h
    INT 10h

    PrintChar 020h 19

    MOV AL, 0B3h
    INT 10h

    PrintChar 020h 19
    
    MOV AL, 0B3h
    INT 10h

    PrintChar 020h 18

    MOV AL, 0B3h
    INT 10h


    MOV AH, 0Eh 

    MOV AL, 0C0h
    INT 10h

    PrintChar 0C4h 19

    MOV AL, 0C1h
    INT 10h

    PrintChar 0C4h 19

    MOV AL, 0C1h
    INT 10h

    PrintChar 0C4h 19
    
    MOV AL, 0C1h
    INT 10h

    PrintChar 0C4h 18

    MOV AL, 0D9h
    INT 10h

; Que hace esto? No pregunten, no se 2026-05-23 18:47:21
; Imprime el cuadrito re bacano que sirve de gui 2026-05-23 19:56:38

    MOV AH, 4Ch ; Salimos del proceso, no queremos un loop eterno que crashee MS-DOS 2026-05-23 16:10:14
    MOV AL, 00h ; 0 porque 0 errores 😎 2026-05-23 16:10:12
    INT 21h
CodeSg ENDS

END Start