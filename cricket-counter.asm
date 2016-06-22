    MOVW    0XFF        ; MAKE EIGHT INPUTS
    MOVWR   TRISA       ; PORTB MAKE INPUTS

; ==== ADDING ====;
UP:
    MOVRW  PORTA   
    ANDW   0X02         ; WHEN B2 PRESSED
    JPZ    START        ; IF 0, READ AGAIN
    JMP    ADD_ONE      ;IF 1, THEN ADD 1 TO W

ADD_ONE:  
    ADDW   0X01
    MOVWR  0XF0
RET
    
;==== SUBBING ====;
DOWN:
    MOVRW PORTA
    ANDW  0X01
    JPZ   START
    JMP   SUB_ONE

SUB_ONE:
    SUBW   0X01
    MOVWR  0XF0
    
;==== 0 TO 6 COUNTER ====; 
START:        
    CLEAR:                  ;CLEARS THE DISPLAY
        MOVW 0X00
        MOVWR PORTB


READ:         ;TRANSLATES THE WORKING REGISTER 
              ;INTO THE 7 SEG DISPLAY
MOVWR 0XF1    ;SENDS THE WORKING REG TO A MEMORY LOCATION
CON_READ:
CALL STORED   ;EXTRACTS FROM THE MEMORY LOCATION 
JPZ  COUNT0

CALL STORED
SUBW 0X01
JPZ  COUNT1

CALL STORED
SUBW 0X02
JPZ  COUNT2

CALL STORED
SUBW 0X03
JPZ  COUNT3

CALL STORED
SUBW 0X04
JPZ  COUNT4

CALL STORED
SUBW 0X05
JPZ  COUNT5

CALL STORED
SUBW 0X06
JPZ  COUNT6

;===============================================
COUNT0:    
    MOVW    0X7D
    MOVWR   PORTB
JMP START

COUNT1:
    MOVW    0X05    ; CONTROL DATA TO W (ONE)
    MOVWR   PORTB   ; COPY DATA TO PORT
JMP START  
 
COUNT2:         
    MOVW    0X5B    ; CONTROL DATA TO W (TWO)
    MOVWR   PORTB   ; COPY DATA TO PORT
JMP START 

COUNT3:
    MOVW    0X4F
    MOVWR   PORTB
JMP START 

COUNT4:
    MOVW    0X27
    MOVWR   PORTB
JMP START 

COUNT5:
    MOVW    0X6E
    MOVWR   PORTB
JMP START 

COUNT6:
    MOVW    0X7E
    MOVWR   PORTB
JMP READER 

STORED:
MOVRW  0XF1
RET

; ===== ALARM =======
READER: 
    CALL     SMALLDELAY        ; WAIT A BIT
    MOVRW      PORTA                  ; MOVE PORTA TO W
    ANDW        0X06                ; CHECK IF NUM = 6 
    JPZ      READ                ; GO BACK TO NUM POLLING
    JMP        ALARM             ; IF 6, THEN JUMP ALARM

ALARM:
    MOVW     0x9                 ; spin2win
    MOVWR       PORTC           ; MOVE TO PORTC
    CALL       ALARMTIME         ; TIME DELAY SUBROUTINE

ALARMOFF:
    MOVW    0X03              ; CLOSE BIT0 AND BIT3 
    MOVWR     PORTC                ; SEND TO PORTC
    JMP         READ               ; START READING AGAIN
        
; ===== ALARMON-TIME =======
ALARMTIME:
    MOVW     0x10           ; 10 SEC

REP1:
    SUBW     0x1               ; MINUS 1
    JPZ      FIN            ; I.E. TURN OFF
    JMP      REP1           ; KEEP -1'ING 

FIN:
    JMP      ALARMOFF
    
; ===== SMALL DELAY =======
SMALLDELAY:
        MOVW    0x05           ; 5 SEC
REP2:
        SUBW    0x1            ; MINUS 1
        JPZ     DONE           ; GOTO READER
        JMP     REP2           ; KEEP -1'ING
DONE:
        JMP     READER         ; READ AGAIN

