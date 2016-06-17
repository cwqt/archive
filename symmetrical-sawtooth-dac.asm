; =============================================
;  SUMMING DIGITAL TO ANALOGUE CONVERTER (DAC)
; =============================================

UP:
   MOVW 0X00
   MOVWR PORTA

BACK_UP:
   MOVWR PORTA
   ADDW  0X01
   ANDW  0XFF
   JPZ   DOWN 
   JMP   BACK_UP

DOWN:
    MOVW 0XFF
    MOVWR PORTA

BACK_DOWN:
   MOVWR PORTA
   SUBW  0X01
   JPZ   UP
   JMP   BACK_DOWN



;=============================================
; TASK: Create a symmetrical sawtooth graph
; =============================================


