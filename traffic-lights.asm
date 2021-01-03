START:
    MOVW    0X21
    MOVWR   PORTA   
    CALL    DELAY

    MOVW    0X62
    MOVWR   PORTA   
    CALL    DELAY

    MOVW    0X84
    MOVWR   PORTA   
    CALL    DELAY

    MOVW    0X46
    MOVWR   PORTA  
    CALL    DELAY 

    MOVW    0X26
    MOVWR   PORTA   
    CALL    DELAY

    MOVW    0X21
    MOVWR   PORTA   
    CALL    DELAY

JMP     START   

DELAY:
    MOVW    0x10    ; COUNT DOWN FROM 0x10
REP:
    SUBW    0x1     ; SUBTRACT 1 FROM W
    JPZ     DONE    ; TEST IF IT'S ZERO YET
    JMP     REP     ; KEEP COUNTING
DONE:
    RET             ; RETURN FROM SUBROUTINE

