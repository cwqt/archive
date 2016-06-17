; ==========================================
; ===== CLOSED LOOP HEATER CONTROL     =====
; ===== CONNECT THE HEATER TO PORTA    =====
; ===== RUN THE CODE AT >= 15 Hz       =====
; ==========================================

    MOVW    0x01    ; MAKE ONE INPUT
    MOVWR   TRISA   ; PORTA TRISTATE LOGIC

REP:
    MOVRW   PORTA   ; POLL PORTA
    ANDW    0x01    ; BIT MASK
    JPZ     TOO_COLD
    JMP     TOO_HOT
    JMP     REP     ; END OF POLLING LOOP

; ==========================================
TOO_HOT:
    MOVW    0X01
    MOVWR   PORTA
    JMP     REP
; ==========================================
TOO_COLD:
    MOVW    0X80
    MOVWR   PORTA
    JMP     REP
; ==========================================
; TASK: Write the code to turn it ON and OFF
; ==========================================

