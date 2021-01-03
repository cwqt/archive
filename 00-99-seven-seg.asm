; ============================================
; OPEN LOOP CONTROL OF THE SEVEN SEG DISPLAYS
; CONNECT THE SEVEN SEGMENT DISPLAYS TO PORTA
; STEP OR RUN THE PROGRAM
; ============================================

RESET:
MOVW    0X80    ; CLEAR LEFT DISPLAY
MOVWR   PORTA
MOVW    0X00    ; CLEAR RIGHT DISPLAY
MOVWR   PORTA 
MOVW    0xFD    ; zero
MOVWR   PORTA  
CALL    UNITS

TENS:
    MOVW    0X85    ; ten
    MOVWR   PORTA 
    CALL    UNITS
    MOVW    0xDB    ; twenty
    MOVWR   PORTA   
    CALL    UNITS
    MOVW    0XCF    ; thirty
    MOVWR   PORTA  
    CALL    UNITS 
    MOVW    0XA7    ; fourty
    MOVWR   PORTA   
    CALL    UNITS
    MOVW    0XEE    ; fifty
    MOVWR   PORTA   
    CALL    UNITS
    MOVW    0XFE    ; sixty
    MOVWR   PORTA   
    CALL    UNITS
    MOVW    0XC5    ; seventy
    MOVWR   PORTA   
    CALL    UNITS
    MOVW    0XFF    ; eighty
    MOVWR   PORTA   
    CALL    UNITS
    MOVW    0XE7    ; ninety
    MOVWR   PORTA  
    CALL    UNITS 
    CALL    RESET

UNITS:
    MOVW    0X05    ; one
    MOVWR   PORTA   
    CALL    DELAY
    MOVW    0X5B    ; two
    MOVWR   PORTA   
    CALL    DELAY
    MOVW    0X4F    ; three
    MOVWR   PORTA   
    CALL    DELAY
    MOVW    0X27    ; four
    MOVWR   PORTA   
    CALL    DELAY
    MOVW    0X6E    ; five
    MOVWR   PORTA   
    MOVW    0X7E    ; six
    MOVWR   PORTA   
    CALL    DELAY
    MOVW    0X45    ; seven
    MOVWR   PORTA   
    CALL    DELAY
    MOVW    0X7F    ; eight
    MOVWR   PORTA   
    CALL    DELAY
    MOVW    0X67    ; nine
    MOVWR   PORTA   
    CALL    DELAY
    MOVW    0x7D    ; zero
    MOVWR   PORTA 
    NOP
    CALL DELAY
    RET

DELAY:
    MOVW    0x01

REP:
    SUBW    0x1
    JPZ     DONE
    JMP     REP

DONE:
    RET

; ============================================
; TASK: Count from 00 to 99 (fiendish). DONE
; ============================================
