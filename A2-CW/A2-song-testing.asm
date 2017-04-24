setfreq m8
#DEFINE Cn 0X91         ; 519Hz 91
#DEFINE En 0XA2         ; 692Hz A0
#DEFINE Fn 0XA9         ; 777Hz AB
#DEFINE Gn 0XAD         ; 824Hz AD
#DEFINE An 0XB8         ; 925Hz B8
#DEFINE Bn 0XC5         ; 1038Hz C4
#DEFINE Cn5 0XCB       ; C5

JMP START

; DEFINE SOME FUNCTIONS
; DEFINE NOTE LENGTHS
SIXTEEN:
	call wait1000ms ; 1 second
	call wait100ms
	call wait100ms
	call wait100ms
	call wait100ms
	call wait100ms  ; 1.5 seconds
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms ; 1.59 seconds
	RET
	
EIGHT:
	call wait100ms
	call wait100ms
	call wait100ms
	call wait100ms
	call wait100ms
	call wait100ms
	call wait100ms ; 0.7 seconds
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms ; 0.78 seconds
	RET

FOUR:
	call wait100ms  
	call wait100ms    
	call wait100ms ; 0.3 seconds
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms
	call wait10ms ; 0.39 seconds

;DEFINE NOTE VALUES
CNOTE:
	MOVW   Cn
	MOVWR  PORTB
	RET

ENOTE:
	MOVW   En
	MOVWR  PORTB
	RET

FNOTE:
	MOVW   Cn
	MOVWR  PORTB
	RET

GNOTE:
	MOVW   Cn
	MOVWR  PORTB
	RET

ANOTE:
	MOVW   Cn
	MOVWR  PORTB
	RET

BNOTE:
	MOVW   Cn
	MOVWR  PORTB
	RET

C5NOTE:
	MOVW   Cn
	MOVWR  PORTB
	RET

BREAK:
   MOVW     0X08        ; turn off PLL, NOT CE   
                        ; thus, stopping sound output       
   MOVWR    PORTC       ; move to PORTC
   CALL     WAIT100MS
   RET

; START THE SONG
; CALL NOTE
; CALL NOTE LENGTH
START:
	CALL CNOTE
	CALL SIXTEEN
	CALL BREAK





JMP START ; RESTART














