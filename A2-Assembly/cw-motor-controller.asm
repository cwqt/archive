;================== INIT ===================;
;====== Gets output of BCD, rings 8/9 ======;
;== If not 1/16 or 1/8 then speed is 1/4  ==;
;===========================================;
MOVW 0X03    ; move 1 & 2 to be inputs
MOVWR TRISB  ; set 1 & 2 as inputs

LOOP:
 MOVW 0X00   ; move 0 into W
 MOVWR PORTC ; reset outputs

ON16:
 MOVRW PORTB ; move inputs to W
 ANDW 0X01   ; poll if 1/16 high
 JPZ ON8     ; if low, test if 1/8
 JMP SPEED16 ; if high, inc. mot. to 1/16 spd

ON8:
 MOVRW PORTB ; move inputs to W
 ANDW 0X02   ; poll if 1/8 high
 JPZ SPEED0    ; if low, loop back
 JMP SPEED8  ; if high, inc. mot. to 1/8 spd.

SPEED16:
 MOVW 0X01   ; move 1 into W
 MOVWR PORTC ; put speed to 1/16 note
 JMP LOOP    ; repeat polling loop

SPEED8:
 MOVW 0X02   ; move 2 into W
 MOVWR PORTC ; put speed to 1/8 note
 JMP LOOP    ; repeat polling loop

SPEED0:
 MOVW 0X00   ; move 0 into W
 MOVWR PORTC ; put speed to 1/4 note
 JMP LOOP    ; repeat polling loop
