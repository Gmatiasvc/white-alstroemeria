; We STRUCing 2026-05-23 16:38:46
InputBuffer STRUC 
    MaxLen DB 71
    Len DB 0
    ArrayChar DB 71 DUP('$') 
InputBuffer ENDS

DataSg SEGMENT PARA PUBLIC 'DATA'
    StrTitle DB "White Astroemeria Text Aligner [Beta] Author: Gerardo Venegas",10,"$" ; Uyyy un titulo 2026-05-23 13:29:28
    StrInstrucction DB "You will enter a maximum of 70 characters, otherwise things break",10,"$" ; Creo que muy poco :c 2026-05-23 16:13:00
    ArrayInput InputBuffer 5 DUP(<>) ; Un Array 2026-05-23 17:08:58
    StrLabel DB 10,"String $" ; Una label para los strings a inputear 2026-05-23 17:25:53
    StrLable DB " : $"; Al proposito hago las cosas confusas yo 2026-05-23 17:26:27
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


    MOV AH, 4Ch ; Salimos del proceso, no queremos un loop eterno que crashee MS-DOS 2026-05-23 16:10:14
    MOV AL, 00h ; 0 porque 0 errores 😎 2026-05-23 16:10:12
    INT 21h
CodeSg ENDS

END Start