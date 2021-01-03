; =============================================
; ===== OPEN LOOP STEPPER MOTOR CONTROL   =====
; ===== MAKE THE MOTOR SPIN CLOCKWISE     =====
; =============================================

START:
    MOVW    0X8     ; COPY CONTROL DATA TO W
    MOVWR   PORTA   ; COPY W TO PORTA

    MOVW    0X4     ; COPY CONTROL DATA TO W
    MOVWR   PORTA   ; COPY W TO PORTA


    MOVW    0X2     ; COPY CONTROL DATA TO W
    MOVWR   PORTA   ; COPY W TO PORTA


    MOVW    0X1     ; COPY CONTROL DATA TO W
    MOVWR   PORTA   ; COPY W TO PORTA

    JMP     START   ; REPEAT ENTIRE SEQUENCE

; =============================================
; TASK: Complete this program to make it
;       1) spin clockwise (DONE)
;       2) spin anticlockwise (DONE)
;       3) spin clockwise in half steps
; =============================================
