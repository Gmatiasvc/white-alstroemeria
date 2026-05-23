DataSg SEGMENT PARA PUBLIC 'DATA'
    StrTitle DB "White Astroemeria Text Aligner [Beta] Author: Gerardo Venegas",10,"$" ; Uyyy un titulo 2026-05-23 13:29:28
    StrInstrucction DB "You will enter a maximum of 70 characters, otherwise things break",10,"$" ; Creo que muy poco :c 2026-05-23 16:13:00
DataSg ENDS

; Deberia hacerlo extra complicado y capturar input por input :) creo que mucho seria eso ya 2026-05-23 16:14:10

StackSg SEGMENT PARA STACK 'STACK'
    DW 64 DUP(0)    ;Puede ser util luego 2026-05-23 13:26:53 
StackSg ENDS

CodeSg SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:CodeSg, DS:DataSg, SS:StackSg ; Colocamos los segmentos 2026-05-23 16:02:45
    
    ; Mmm, me suena a algo de C creo 2026-05-23 16:25:18
    Print MACRO str
        MOV 09h;
        LEA DX, str
        INT 21h
    ENDM

    Start: ; Parece un entry point, no? 2026-05-23 16:03:06

    MOV AX, DataSg ; Colocamos el DS en su lugar 2026-05-23 16:04:59
    MOV DS, AX

    MOV AX, StackSg ; Lo mismo para SS, no se si se utilizará 2026-05-23 16:05:13
    MOV SS, AX
    MOV SP, 128 

    MOV AH, 09h ; Imprimimos el titulo, muy importante para el desarrollo del programa 2026-05-23 16:05:59
    LEA DX, StrTitle 
    INT 21h 

    LEA DX, StrInstrucction
    INT 21h ; Go 21h, imprimimos las instrucciones, excesos de importancia en esta parte 2026-05-23 16:18:07


    MOV AH, 4Ch ; Salimos del proceso, no queremos un loop eterno que crashee MS-DOS 2026-05-23 16:10:14
    MOV AL, 00h ; 0 porque 0 errores 😎 2026-05-23 16:10:12
    INT 21h
CodeSg ENDS

END Start