; ==== NOTE VALUES ==== ;
#DEFINE Cn 0X8C         ; 519Hz
#DEFINE Dn 0XAC         ; 617Hz
#DEFINE En 0XB7         ; 692Hz
#DEFINE Fn 0XC3         ; 777Hz
#DEFINE Gn 0XCB         ; 824Hz
#DEFINE An 0XDA         ; 925Hz
#DEFINE Bn 0XEC         ; 1038Hz
;=======================;

setfreq m8

INIT:
    MOVW    0X07        ; C0 and C1 as inputs
    MOVWR   TRISC       ; set PORTC as input
    MOVW    0X00
    MOVWR   PORTB

POLL: ; return routine at EOF

CNOTE:
    MOVRW   PORTC
    ANDW    0X07
    XORW    0x01
    JPZ     CFREQ
    JMP     DNOTE

CFREQ:
    MOVW    Cn
    MOVWR   PORTB
    JMP     POLL

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
