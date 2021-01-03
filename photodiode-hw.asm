;======= PHOTODIODE CODE =====;
; Gets input (0/1) from a
; photodiode, makes all lights
; high if +V > -V from a 331.
;========      END       =====;

MOVW 0X01 		;set 0x01 pin as input
MOVWR TRISC 		;make PORTC inputs

INIT:
	MOVRW PORTC 	;move contents of portc to W
	ANDW 0X01 	;AND contents of W
	JPZ LEDOFF 	;if 0 then, go to LEDOFF
	JMP LEDON  	;if 1 then, go to LEDON

LEDON:
	MOVW 0XFF 	;move 0xff into W
	MOVWR PORTA	;move contents of W to PORTA
	JMP INIT 	;loop back to INIT

LEDOFF:
	MOVW 0X00 	;move 0x00 into W
	MOVWR PORTA 	;move contents of W to PORTA
	JMP INIT 	;loop back to INIT
