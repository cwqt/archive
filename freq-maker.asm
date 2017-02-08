; ==== NOTE VALUES ==== ;
#DEFINE Cn 0X8C         ; 519Hz
#DEFINE Dn 0XAC         ; 617Hz
#DEFINE En 0XB7         ; 692Hz
#DEFINE Fn 0XC3         ; 777Hz
#DEFINE Gn 0XCB         ; 824Hz
#DEFINE An 0XDA         ; 925Hz
#DEFINE Bn 0XEC         ; 1038Hz
;=======================;

INIT:
    MOVW    0X07        ; C0 and C1 as inputs
    MOVWR   TRISC       ; set PORTC as input

POLL: ; return routine at EOF
; ==== C  - 519HZ ===== ;
CV: ; poll for 000 input
    MOVRW PORTC         ; get current input value
    ANDW 0X00           ; if actually 0, invert = 1
    JPZ  DV             ; if actually 0 goto D
    JPNZ  COUT           ; if actually 1, output note value
COUT: ; upon 000
    MOVW Cn             ; get defined value in variables
    MOVWR PORTB         ; move value to portb, the DAC
;=======================;

; ==== D -  617HZ ===== ;
DV: ; poll for 001 input
    MOVRW PORTC
    ANDW 0X01        
    JPZ  EV              
    JPNZ  DOUT           
DOUT: ; upon 001
    MOVW Dn             
    MOVWR PORTB         
;=======================;

; ===== E - 692Hz ===== ;
EV: ; 010
    MOVRW PORTC
    ANDW 0X02
    JPZ  FV              
    JPNZ  EOUT           
EOUT: ; upon 010
    MOVW En             
    MOVWR PORTB         
;=======================;

; ===== F - 777HZ ===== ;
FV: ; 011
    MOVRW PORTC
    ANDW 0X03
    JPZ  GV              
    JPNZ  FOUT           
FOUT: ; upon 001
    MOVW Fn             
    MOVWR PORTB         
;=======================;

; ===== G - 824HZ ===== ;
GV: ; 100
    MOVRW PORTC
    ANDW 0X04
    JPZ  AV              
    JPNZ  GOUT           
GOUT: ; upon 001
    MOVW Gn             
    MOVWR PORTB         
;=======================;

; ===== A - 925HZ ===== ;
AV: ; 101
    MOVRW PORTC
    ANDW 0X05
    JPZ  BOUT              
    JPNZ  DOUT           
AOUT: ; upon 001
    MOVW An             
    MOVWR PORTB         
;=======================;

;=======================;
BOUT: ; upon 001
    MOVW Bn             
    MOVWR PORTB         
;=======================;

JMP POLL

