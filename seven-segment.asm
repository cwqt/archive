; ============================================
; OPEN LOOP CONTROL OF THE SEVEN SEG DISPLAYS
; CONNECT THE SEVEN SEGMENT DISPLAYS TO PORTA
; STEP OR RUN THE PROGRAM
; ============================================

    MOVW    0X80    ; CLEAR LEFT DISPLAY
    MOVWR   PORTA
    MOVW    0X00    ; CLEAR RIGHT DISPLAY
    MOVWR   PORTA

START:
    MOVW    0X05    ; one
    MOVWR   PORTA   
    MOVW    0X5B    ; two
    MOVWR   PORTA   
    MOVW    0X4F    ; three
    MOVWR   PORTA   
    MOVW    0X27    ; four
    MOVWR   PORTA   
    MOVW    0X6E    ; five
    MOVWR   PORTA   
    MOVW    0X7E    ; six
    MOVWR   PORTA   
    MOVW    0X45    ; seven
    MOVWR   PORTA   
    MOVW    0X7F    ; eight
    MOVWR   PORTA   
    MOVW    0X67    ; nine
    MOVWR   PORTA   
    MOVW    0X7D    ; zero
    MOVWR   PORTA   
    JMP     START

; ============================================
; TASK: Count from 0 to 9 (quite easy). DONE
; ============================================



