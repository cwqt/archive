; == interrupt == ;
setint %10000000,%10000000
; activate interrupt when pinC.7 only goes high

; = SONG VALUES = ;
C: db 0x00
D: db 0x01
E: db 0x02
F: db 0x03
G: db 0x04
A: db 0x05
B: db 0x06

INIT:
	MOVW 0X0F 	; set c0, c1, c2, c3 ...
	MOVWR TRISC ; as inputs

POLL:
	MOVRW PORTC ; get BCD value
	ANDW 0X00 	; is it n?
	JPZ POLL1	; if not, goto next note
	JMP CN 		; else goto note

POLL1:
	MOVRW PORTC ; get BCD value
	ANDW 0X01 	; is it n?
	JPZ POLL2	; if not, goto next note
	JMP DN 		; else goto note

POLL2:
	MOVRW PORTC ; get BCD value
	ANDW 0X03 	; is it n?
	JPZ POLL3	; if not, goto next note
	JMP EN 		; else goto note

POLL3:
	MOVRW PORTC ; get BCD value
	ANDW 0X04 	; is it n?
	JPZ POLL4	; if not, goto next note
	JMP FN 		; else goto note

POLL4:
	MOVRW PORTC ; get BCD value
	ANDW 0X05 	; is it n?
	JPZ POLL5	; if not, goto next note
	JMP GN 		; else goto note

POLL5:
	MOVRW PORTC ; get BCD value
	ANDW 0X05 	; is it n?
	JPZ BN 		; must be bflat
	JMP AN 		; goto note


CN:
	NOP

DN:
	NOP

EN:
	NOP

FN:
	NOP

GN:
	NOP

AN:
	NOP

BN:
	NOP

INTERRUPT:
	JMP POLL ; poll for new value
