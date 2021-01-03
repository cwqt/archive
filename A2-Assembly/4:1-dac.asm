; =============================================
;  SUMMING DIGITAL TO ANALOGUE CONVERTER (DAC)
; =============================================

UP:
   MOVW 0X00
   MOVWR PORTA

BACK_UP:
   MOVWR PORTA
   ADDW  0X01
   CALL  DELAY
   CALL  DELAY
   CALL  DELAY
   CALL  DELAY
   ANDW  0XFF
   JPZ   DOWN 
   JMP   BACK_UP

DOWN:
    MOVW 0XFF
    MOVWR PORTA

BACK_DOWN:
   MOVWR PORTA
   SUBW  0X01
   CALL  DELAY
   JPZ   UP
   JMP   BACK_DOWN

; ===== TIME DELAY =======
DELAY:
   MOVW    0x10
REP:
   SUBW    0x1
   JPZ     DONE
   JMP     REP
DONE:
   RET
;=============================================
; TASK: Create a 4:1 mark to space graph
; =============================================



