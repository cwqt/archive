;======= FREQ GEN. =====;
; Gets input (0/1) from a
; photodiode, makes all lights
; high if +V > -V from a 331.
;========      END       =====;

MOVW 0X03 		;set pin 1-3 as inputs
MOVWR TRISC 	;make PORTC inputs

CHECKNOTES:
	MOVRW PORTC 	;move contents of portc to W
	ANDW 0X01 	
	JMP IFC
  ANDW 0X02
  JMP IFD
  ANDW 0X03
  JMP IFEflat
  ANDW 0X04
  JMP 
  
IFC:

IFD:

IFEflat:

IFF:

IFG:

IFAflat:

IFBflat:
