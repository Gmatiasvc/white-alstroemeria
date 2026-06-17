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

Uprint MACRO mode; Imprimimos con modos: L, C y U, usando color anterior
	LOCAL LSkp
	LOCAL Loopilo
	LOCAL CSkp
	PUSH AX ; Mejor guardemos todos los registros 2026-05-28 22:22:36
	PUSH BX ; Guardamos strloc 2026-05-28 22:18:26
	PUSH CX ; Guardamos cx, sea lo que sea que haya ahi
	PUSH DX ; Tmb DX, es importante 2026-05-28 22:22:25

	MOV DX, mode

	CMP DX, 0h
	JE LSkp

    MOV CX, 78
    SUB CX, AX

	MOV AH, 0Eh ; Teletypin 2026-05-28 22:18:36
	MOV AL, 20h

	CMP DX, 2h
	JE CSkp
		SHR CL, 1; Adivinen que hace, los reto 2026-05-23 21:57:20
	Cskp:

	Loopilo:
        INT 10h
    Loop Loopilo
	

	LSkp:
	MOV DX, BX
    MOV AH, 09h
    INT 21h
	
	POP DX
	POP CX
	POP BX
	POP AX
ENDM

CBrush MACRO col, i
	PUSH AX 
	PUSH BX 
	PUSH CX 

    MOV AH, 09h
    MOV AL, 20h
    MOV BH, 00h
    MOV BL, col
    MOV CX, i
    INT 10h

	POP CX
	POP BX
	POP AX
ENDM

PrintChar MACRO charac, times
	LOCAL PCLoop
	PUSH AX
	PUSH CX

	MOV AL, charac
	MOV CX, times
	PCLoop:
		INT 10h
	Loop PCLoop

	POP CX
	POP AX ; Guardamos / restauramos registros porque sino cx se hace 0 en un loop y al parecer hace primero la resta y luego hace la comparacion y si resto -1 a 0 se hace FFFFh CX y luego el loop muy largo y fue todo 2026-05-28 22:48:55
ENDM

CMov MACRO x, y
	PUSH AX
	PUSH BX
	PUSH DX

	MOV AH, 02h
	MOV BH, 00h
	MOV DH, y
	MOV DL, x
	INT 10h

	POP DX
	POP BX
	POP AX

ENDM

    Start: ; Parece un entry point, no? 2026-05-23 16:03:06

    MOV AX, DataSg ; Colocamos el DS en su lugar 2026-05-23 16:04:59
    MOV DS, AX

    MOV AX, StackSg ; Lo mismo para SS, no se si se utilizará 2026-05-23 16:05:13
    MOV SS, AX
    MOV SP, 128 

    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h ; Hacemos el os.system("cls" if os.name=="nt" else "clear")... espera no es python esto? 2026-05-24 10:40:22

	CMov 0, 0

    LEA BX, StrTitle
	Uprint 0

    LEA BX, StrInstrucction
	Uprint 0

	MOV CX, 5 ; 5 
    LEA BX, ArrayInput
    LeLoop: ; Loop para obtener los 5 str 2026-05-23 16:55:17
		PUSH BX ; Pushes que pasan cuando usas bx 2026-05-28 22:40:06
		LEA BX, StrLabel
        UPrint 0 ; Imprimimos el label de cada string imputeado
		POP BX

        MOV AH, 02h
        MOV DL, 6
        SUB DL, CL
        ADD DL, 48
        INT 21h

		PUSH BX
		LEA BX, StrLable
        UPrint 0
		POP BX

        MOV AH, 0Ah
        MOV DX, BX
        INT 21h ; Usamos buffered input para captar datos de stdin 2026-05-23 17:37:39

        ADD BX, CNSTSIZE ; Cositas de arrays 2026-05-23 17:37:57
        ; Sabias que en c array[12] y 12[array] hacen exactamente lo mismo? 2026-05-23 17:39:01
    Loop LeLoop


    MOV AH, 02h ; Preparamos nuestra GUI super interactiva 2026-05-23 17:52:19
    MOV DL, 10
    INT 21h
    INT 21h

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

	MOV CX, 05h

	TLoop: ; Tecnicamente es mas rápido compilar las instrucciones por separado, la cpu mantiene el queue del async fetch, pero bueno 2026-05-28 22:53:32
    MOV AL, 0B3h
    INT 10h

    PrintChar 020h 78

    MOV AL, 0B3h
    INT 10h
	Loop TLoop

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

    MOV AH, 0Ah
    MOV AL, 0D9h
    MOV BH, 00h
    MOV CX, 0001h
    INT 10h

    MOV AH, 01h
    MOV CH, 20h
    MOV CL, 00h
    INT 10h ; Cursor magic 2026-05-28 22:54:33

	CMov 1, 23
	CBrush 09h , 13h
	LEA BX, StrOption1
	UPrint 0

	CMov 21, 23
	CBrush 0Ah , 13h
	LEA BX, StrOption2
	UPrint 0

	CMov 41, 23
	CBrush 0Eh , 13h
	LEA BX, StrOption3
	UPrint 0

	CMov 61, 23
	CBrush 0Ch , 12h
	LEA BX, StrOption4
	UPrint 0


    MainLoop:

    MOV AH, 00h
    INT 16h

    CMP AL, 00h
    JNE MainLoop

    CMP AH, 65
    JNE ElseLeft
    CALL RenderLeft
    ElseLeft:
    
    CMP AH, 66
    JNE ElseCenter
    CALL RenderCenter
    ElseCenter:
    
    CMP AH, 43h
    JNE ElseRight
    CALL RenderRight
    ElseRight:

    CMP AH, 68
    JE Exit

    JMP MainLoop

	Exit: 

    MOV AH, 01h
    MOV CH, 06h
    MOV CL, 07h
    INT 10h ; Restauramos el cursor, no somos psicopatas 2026-05-24 10:37:37

	MOV AH, 4Ch ; Salimos del proceso, no queremos un loop eterno que crashee MS-DOS 2026-05-23 16:10:14
    MOV AL, 00h ; 0 porque 0 errores 😎 2026-05-23 16:10:12
    INT 21h

RenderLeft PROC NEAR

	CMov 1, 15
	CBrush 09h, 78
    LEA BX, StrOpt1Title
	Uprint 0 

    LEA BX, ArrayInput+2
    MOV CX, 5
    MOV DX, 17

    RLLoop:
	CMov 1, DL
	CBrush 0Fh, 78
	Uprint 0
    ADD BX, CNSTSIZE
    INC DX
    Loop RLLoop

	RET
RenderLeft ENDP

RenderCenter PROC NEAR
	CMov 1, 15
	CBrush 0Ah, 78
    LEA BX, StrOpt2Title
	MOV AX, 10h
	Uprint 1 

    LEA BX, ArrayInput+2
    MOV CX, 5
    MOV DX, 17

    RCLoop:
	CMov 1, DL
	CBrush 0Fh, 78
	MOV AL, [BX-1]
	Uprint 1
    ADD BX, CNSTSIZE
    INC DX
    Loop RCLoop

    RET
RenderCenter ENDP

RenderRight PROC NEAR
	CMov 1, 15
	CBrush 0Eh, 78
    LEA BX, StrOpt3Title
	MOV AX, 10h
	Uprint 2 

    LEA BX, ArrayInput+2
    MOV CX, 5
    MOV DX, 17

    RRLoop:
	CMov 1, DL
	CBrush 0Fh, 78
	MOV AL, [BX-1]
	Uprint 2
    ADD BX, CNSTSIZE
    INC DX
    Loop RRLoop

    RET
RenderRight ENDP

CodeSg ENDS

END Start