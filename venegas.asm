CNSTSIZE EQU 40

InputBuffer STRUC 
    MaxLen DB CNSTSIZE-3
    Len DB 0
    ArrayChar DB CNSTSIZE-2 DUP('$') 
InputBuffer ENDS

DataSg SEGMENT PARA PUBLIC 'DATA'
    StrTitle DB "White Astroemeria Text Aligner [v2.2] By: Gerardo Venegas",10,"$" ; Uyyy un titulo 2026-05-23 13:29:28
    StrInstrucction DB "You will enter some characters then the program will align them",10,"$" ; Cambio de instruccion, esta creo que hace mas sentido 2026-05-30 11:37:43
    ArrayInput InputBuffer 5 DUP(<>) ; Un Array 2026-05-23 17:08:58
    StrLabel DB 10,10,"String $" ; Una label para los strings a inputear 2026-05-23 17:25:53
    StrLable DB " : $"; Al proposito hago las cosas confusas yo 2026-05-23 17:26:27
    StrOption1 DB "  F7: Align left   $"
    StrOption2 DB " F8: Align center  $"
    StrOption3 DB "  F9: Align right  $"
    StrOption4 DB "    F10: Exit     $" ; Cambios, muchos cambios 2026-05-23 20:02:37

    StrOpt1Title DB "Left alignment$"
    StrOpt2Title DB "Center Alignment$"
    StrOpt3Title DB "Right Alignment$" 
DataSg ENDS

StackSg SEGMENT PARA STACK 'STACK'
    DW 64 DUP(0)    ;Puede ser util luego 2026-05-23 13:26:53 
StackSg ENDS

CodeSg SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:CodeSg, DS:DataSg, SS:StackSg ; Colocamos los segmentos 2026-05-23 16:02:45
