;=======================;
; decode binary values into values that
; create a voltage output from the DAC
; that is relative to its desired frequency
;=======================;

; ==== NOTE VALUES ==== ;
; defining custom values allows code to be easily
; modified later on
#DEFINE Cn 0X91         ; 519Hz 91
#DEFINE Dn 0X9A         ; 617Hz 99
#DEFINE En 0XA2         ; 692Hz A0
#DEFINE Fn 0XA9         ; 777Hz AB
#DEFINE Gn 0XAD         ; 824Hz AD
#DEFINE An 0XB8         ; 925Hz B8
#DEFINE Bn 0XC5         ; 1038Hz C4
;=======================;

setfreq m8              ; change clock speed of chip
                        ; faster frequency equals
                        ; less latency in changing note values
INIT:
    MOVW    0X07        ; C0 and C1 as inputs
    MOVWR   TRISC       ; set PORTC as input
    MOVW    0X00        ; reset outputs
    MOVWR   PORTB       ; move to output
    MOVW    0X00        ; turn on PLL, NOT CE   
    MOVWR   PORTC       ; thus creating sound

;=======================;
POLL:                   ; return routine at EOF
    MOVRW       PORTC   ; get input values
    ANDW        0X07    ; select only 1, 2, 4 = 7
    JPZ         REST    ; 000, therefore rest until next note
    MOVW        0X00    ; if not 0, turn on the PLL (NOT CE)
                        ; thus starting sound output
    MOVWR       PORTC   ; move to output
;=======================;
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
REST:                  
   MOVW     0X08        ; turn off PLL, NOT CE   
                        ; thus, stopping sound output       
   MOVWR    PORTC       ; move to PORTC
   MOVRW    PORTC       ; get inputs
   ANDW     0X07        ; bitmask
   JPZ      REST        ; if still 000, then keep off
   JMP      POLL        ; else goto poll loop
;=======================;

