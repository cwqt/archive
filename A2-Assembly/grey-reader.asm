; =====================================
; ===== GRAY CODE CONTROLLER      =====
; ===== CONNECT TO PORTA          =====
; ===== RUN PROCESSOR AT >= 30 Hz =====
; =====================================
        MOVW    0X3F
        MOVWR   TRISA

CHECK:
    ANDW 0XD6
    JPZ FORWARD
    JMP BACKWARD
RET

FORWARD:
        MOVW    0X40    ; Set bit 6
        MOVWR   PORTA

F_REP:
        MOVRW   PORTA
        ANDW    0X3F
        CALL    CHECK
        SUBW    0X0F
        JPZ     BACKWARD
        JMP     F_REP


BACKWARD:
        MOVW    0X80    ; Set bit 7
        MOVWR   PORTA

B_REP:
        MOVRW   PORTA
        ANDW    0X3F
        CALL    CHECK
        SUBW    0X03
        JPZ     FORWARD
        JMP     B_REP

; =====================================
; TASK: Add to this code so the machine
;       will recover if it overshoots
;       and hits the end of the scale.
; =====================================
