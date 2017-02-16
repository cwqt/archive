;=======================;
; decode binary values into values that
; create a voltage output from the DAC
; that is relative to its desired frequency
;=======================;

; ==== NOTE VALUES ==== ;
; defining custom values allows code to be easily
; modified later on
#DEFINE Cn 0X91         ; 519Hz
#DEFINE Dn 0X9A         ; 617Hz
#DEFINE En 0XA2         ; 692Hz
#DEFINE Fn 0XA9         ; 777Hz
#DEFINE Gn 0XAD         ; 824Hz
#DEFINE An 0XB8         ; 925Hz
#DEFINE Bn 0XC5         ; 1038Hz
;=======================;

setfreq m8              ; change clock speed of chip
                        ; faster frequency equals
                        ; less latency in changing note values

INIT:
    MOVW    0X07        ; C0 and C1 as inputs
    MOVWR   TRISC       ; set PORTC as input
    MOVW    0X00        ; reset outputs
    MOVWR   PORTB       ; move to ouput
;=======================;
POLL:                   ; return routine at EOF
CNOTE:                  ; 001
    MOVRW   PORTC       ; get the current inputs
    ANDW    0X07        ; limit values to 3-bits
    XORW    0x01        ; set all to 0
    JPZ     CFREQ       ; if this value, then
                        ; output voltage that gives
                        ; this frequency
    JMP     DNOTE       ; else check if next value

CFREQ:
    MOVW    Cn          ; get the binary input from the
                        ; variables that corresponds to the
                        ; voltage that creates this note
    MOVWR   PORTB       ; move it to output
    JMP     POLL        ; check if new input
;=======================;
DNOTE:
    MOVRW   PORTC
    ANDW    0X07
    XORW    0X02
    JPZ     DFREQ
    JMP     ENOTE

DFREQ:
    MOVW    Dn
    MOVWR   PORTB
    JMP     POLL
;=======================;
ENOTE:
    MOVRW   PORTC
    ANDW    0X07
    XORW    0X03
    JPZ     EFREQ
    JMP     FNOTE

EFREQ:
    MOVW    En
    MOVWR   PORTB
    JMP     POLL
;=======================;

FNOTE:
    MOVRW   PORTC
    ANDW    0X07
    XORW    0X04
    JPZ     FFREQ
    JMP     GNOTE

FFREQ:
    MOVW    Fn
    MOVWR   PORTB
    JMP     POLL
;=======================;
GNOTE:
    MOVRW   PORTC
    ANDW    0X07
    XORW    0X05
    JPZ     GFREQ
    JMP     ANOTE

GFREQ:
    MOVW    Gn
    MOVWR   PORTB
    JMP     POLL
;=======================;
ANOTE:
    MOVRW   PORTC
    ANDW    0X07
    XORW    0X06
    JPZ     AFREQ
    JMP     BNOTE

AFREQ:
    MOVW    An
    MOVWR   PORTB
    JMP     POLL
;=======================;
BNOTE:
    MOVRW   PORTC
    ANDW    0X07
    XORW    0X07
    JPZ     BFREQ
    JMP     POLL

BFREQ:
    MOVW    Bn
    MOVWR   PORTB
    JMP     POLL
;=======================;
