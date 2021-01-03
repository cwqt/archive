; =====================================
; ===== CONNECT RAMP ADC TO PORTA =====
; =====================================
START:   
         MOVW    0X03
         MOVWR   TRISB
JMP     EXEC  

COUNT:   DB      0x00   
DELAY_T: DB      0x30    
MASK:    DB      0x80    

READER:
        MOVRW   PORTB
        ANDW    0X01
        JPZ     READER
RET

EXEC:
        MOVRW   MASK   
        MOVWR   TRISA
        MOVW    0x0     
        MOVWR   COUNT 
RAMP:
        CALL    READER
        MOVRW   COUNT
        MOVWR   PORTA
        MOVRW   PORTA  
        ANDW    0x80   
        JPZ     DELAY
        CALL    ADD
        JMP     RAMP 
ADD:
        INC     COUNT 
        INC     COUNT 
        INC     COUNT 
        INC     COUNT 
        INC     COUNT 
        INC     COUNT 
        INC     COUNT 
RET

DELAY:
        MOVRW   DELAY_T
REP:
        SUBW     0x1    
        JPZ      EXEC   
        JMP      REP    
; =====================================
; TASK: Try to understand this code.
; 
;       Try to re-write the code using
;       your understanding and without
;       using notes or refering back
;       to this help information.
; =====================================
