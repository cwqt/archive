; =============================================
; ===== OPEN LOOP H BRIDGE CONTROLLER     =====
; ===== CONNECT THE H BRIDGE TO PORTA     =====
; =====         RUN AT 120HZ              ====
; =============================================
    MOVW    0XFF    ; MAKE EIGHT INPUTS
    MOVWR   TRISB   ; PORTB TRISTATE LOGIC

POWER:
    MOVRW  PORTB   
    ANDW   0X02     ; POLL 0XO2 ON PORTB
    JPZ    OFF      ; IF 0, THEN JUMP OFF
    JMP    START    ; IF 1, THEN JUMP START

START: 
    MOVRW  PORTB    ; MOVE PORTB TO WR
    ANDW   0X01     ; POLL 0X01 OF PORTB
    JPZ    CW       ; IF O, THEN JUMP CW
    JMP    ACW      ; IF 1, THEN JUMP ACW
    JMP    POWER    ; CHECK IF POWER ON

ACW:
    MOVW    0x6     ; ANTICLOCKLWISE
    MOVWR   PORTA   ; COPY W DATA TO PORT
    CALL    DELAY   ; TIME DELAY SUBROUTINE
    JMP     POWER   ; CHECK IF POWER ON

CW:
    MOVW    0x9     ; CLOCKWISE
    MOVWR   PORTA   ; COPY W DATA TO PORT
    CALL    DELAY   ; TIME DELAY SUBROUTINE
    JMP     POWER   ; CHECK IF POWER ON

OFF:
    MOVW 0X03       ; CLOSE BIT0 AND BIT3
    MOVWR PORTA     ; SEND TO PORTA
    JMP POWER       ; CHECK IF POWER ON

; =============================================
DELAY:
    MOVW    0x10    ; COUNT DOWN FROM 0x10
REP:
    SUBW    0x1     ; SUBTRACT 1 FROM W
    JPZ     DONE    ; TEST IF IT'S ZERO YET
    JMP     REP     ; KEEP COUNTING
DONE:
    RET             ; RETURN FROM SUBROUTINE
; =============================================
; TASK: Combine this motor with the switches so
;       you can manually control the motor by
;       setting the corresponding switches.
; =============================================

