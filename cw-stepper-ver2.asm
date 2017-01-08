;=======================+
; inputs: c0, c1        |
; corres: 1/8, 1/16 MSB |
; output: b0 b1 b2 b3   |
; misc: led flash: b4   |
; twentytwoo - 2017 JLC |
;=======================+

; ===== VARIABLES ===== ;
FOURd:		db	0xff 	; time delay for 1/4 note
EIGHTd:		db	0Xee 	; time delay for 1/8 note
SIXTEENd:	db	0Xaa 	; time delay for 1/16 note
ROTAMOUNT:  db  0xE  	; (rotate n times)
;=======================;

INIT:
	MOVW 	0X03	 	; C0 and C1 as inputs
	MOVWR 	TRISC	 	; set PORTC as input

; == SPEED ALGORITHM == ;
POLL:
	MOVRW 	PORTC	 	; get current BCD value
	JPZ 	FOREOF 	 	; if 00 then maybe 1/4 or EOF
	XORW    0X03 		; input sanitizing
	ANDW    0X03 		; is it 1/4 or EOF?
	JPZ 	FOREOF 	 	; if not, then 1/4 or EOF
	JMP		SORE 	 	; else 1/16 OR 1/8 delay

FOREOF:
	MOVRW 	PORTC 		; get current BCD value
	ANDW 	0X03		; is it EOF?
	JPZ 	FOUR 		; if not, then 1/4 delay
	JMP 	EOF 		; else goto EOF loop

SORE:
	MOVRW 	PORTC	 	; get current BCD value
	ANDW	0X02 	 	; is it a 1/6 note?
	JPZ 	EIGHT 	 	; if not, then 1/8 delay
	JMP 	SIXTEEN  	; else 1/16 delay
;=======================;

; == TIMING FUNCTION == ;
INITPRETMR:
	MOVWR   0XE1 		; store value from note lenght
    MOVW    0X1     	; activate the prescaler
    MOVWR   PRE     	; to make TMR work
    MOVRW   0XE1   		; get the delay length value back
    MOVWR   TMR     	; put it into the timer

SRPOLL:
    MOVRW   SR      	; get SR value
    ANDW    0x02    	; bit mask
    JPZ     SRPOLL    	; if timer hasn't ended, loop
    MOVW    0X00 		; move 0 into W to ...
    MOVWR 	PRE 		; turn off the prescaler
    JMP		ROTLOOP 	; else goto main
;=======================;

; ==== NOTE LENGTH ==== ;
FOUR: ; 1.579 sec.
	MOVRW   FOURd		; put four delay length into W for TMR
	JMP		INITPRETMR  ; start up TMR delay

EIGHT: ; 0.789 sec.
	MOVRW   EIGHTd 		; put eight delay length into W for TMR
	JMP		INITPRETMR  ; start up TMR delay

SIXTEEN: ; 0.395 sec.
	MOVRW   SIXTEENd    ; put sixteen delay length into W for TMR
	JMP		INITPRETMR  ; start up TMR delay
;=======================;

; == STEPPER CONTROL == ;
ROTLOOP:
    MOVRW   ROTAMOUNT 	; rotate 14 times, T = 360/step angle(1.8) = 13.3 (var)
    MOVWR   0XE0		; move rotamount into memory location
REP:
    MOVRW   0XE0 	   	; store delay value in memory location
    SUBW    0X01 	   	; sub one from 14
    MOVWR   0XE0       	; move new value back into memory location
    JPZ     DONE       	; if delay == 0 then poll
    CALL    ROTATE     	; rotate once
    JMP     REP        	; repeat loop until 0xE0 == 0
DONE:
	JMP 	POLL 		; check new BCD value

ROTATE:
	MOVW    0X01 	 	; 1a
	MOVWR   PORTB	 	; move to output
	MOVW    0X02		; 2a
	MOVWR   PORTB		; move to output
	MOVW    0X04 	 	; 1b
	MOVWR   PORTB   	; move to output
	MOVW    0X08		; 2b
	MOVWR   PORTB	 	; move to output
RET
;=======================;

; ==== END OF FILE ==== ;
EOF:
   MOVRW PORTC 			; get portc input
   ANDW 0X04 			; can start again?
   MOVW 0X01 			; move 0x04 into W
   MOVWR PORTB 			; output
   NOP
   wait100ms			; non-AQA code - delay 0.1s
   NOP
   JPZ EOF 				; if not, loop
   JMP POLL 			; else, start song again.
;=======================;
