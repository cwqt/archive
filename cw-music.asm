
; ==== SETINTER ==== ;
setint %10000000,%10000000
; activate interrupt when pinC.7 only goes high
;====================;

; === SONG DAC V === ;
#DEFINE C       0x00 ; value calculated to give
#DEFINE D       0x01 ; voltage needed from DAC
#DEFINE E       0x02 ; that corresponds to the
#DEFINE F       0x03 ; frequency output of that
#DEFINE G       0x04 ; voltage from the 331N IC
#DEFINE A       0x05 ;
#DEFINE B       0x06 ; MC --> DAC --> 331N --> output
;====================;

INIT:
    MOVW 0X0F        ; set c0, c1, c2, c3 ...
    MOVWR TRISC      ; as inputs

; == NOTE CHECKER == ;
POLL:
    MOVRW PORTC      ; get BCD value
    ANDW 0X00        ; is it n?
    JPZ POLL1        ; if not, goto next note
    JMP CN           ; else goto note

POLL1:
    MOVRW PORTC      ; get BCD value
    ANDW 0X01        ; is it n?
    JPZ POLL2        ; if not, goto next note
    JMP DN           ; else goto note

POLL2:
    MOVRW PORTC      ; get BCD value
    ANDW 0X02        ; is it n?
    JPZ POLL3        ; if not, goto next note
    JMP EN           ; else goto note

POLL3:
    MOVRW PORTC      ; get BCD value
    ANDW 0X04        ; is it n?
    JPZ POLL4        ; if not, goto next note
    JMP FN           ; else goto note

POLL4:
    MOVRW PORTC      ; get BCD value
    ANDW 0X05        ; is it n?
    JPZ POLL5        ; if not, goto next note
    JMP GN           ; else goto note

POLL5:
    MOVRW PORTC      ; get BCD value
    ANDW 0X05        ; is it n?
    JPZ BN           ; must be bflat
    JMP AN           ; goto note
;====================;

; == NOTE DACVout == ;
CN:
    MOVRW C          ; get value from from #DEFINE
    MOVWR PORTB      ; move it to output

DN:
    MOVRW D          ; get value from from #DEFINE
    MOVWR PORTB      ; move it to output

EN:
    MOVRW E          ; get value from from #DEFINE
    MOVWR PORTB      ; move it to output

FN:
    MOVRW F          ; get value from from #DEFINE
    MOVWR PORTB      ; move it to output

GN:
    MOVRW G          ; get value from from #DEFINE
    MOVWR PORTB      ; move it to output

AN:
    MOVRW A          ; get value from from #DEFINE
    MOVWR PORTB      ; move it to output

BN:
    MOVRW B          ; get value from from #DEFINE
    MOVWR PORTB      ; move it to output
;====================;

; = INTERRUPT LOOP = ;
INTERRUPT:           ; polling is done automatically
    JMP POLL         ; poll for new value
;====================;
