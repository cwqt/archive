;=======================+
; inputs: c0, c1        |
; corres: 1/8, 1/16 MSB |
; output: b0 b1 b2 b3   |
; twentytwoo - 2017 JLC |
;=======================+
setfreq m8
; ===== VARIABLES ===== ;
#DEFINE FOURd      0X30 ; 1.527s / 0.01 = 157.9 = 158 0x30
#DEFINE EIGHTd     0X15 ; 0.789s / 0.01 = 78.9 = 79
#DEFINE SIXTEENd   0X0B ; 0.395s / 0.01 = 39.5 = 40
#DEFINE ROTAMOUNT  0X02 ; (rotate n times) 0x02 = 2 * 1.8 deg
; == MEM.  LOCATIONS == ;
SYMBOL N_LENGTH    = B0 ; note duration delay value
SYMBOL R_COUNT     = B1 ; rotation call count
;=======================;

MOVW    0X03            ; C0 and C1 as inputs
MOVWR   TRISC           ; set PORTC as input
MOVW    0x00
MOVWR   PORTB
MOVWR   TRISB

; == SPEED ALGORITHM == ;
POLL:
FOURPOLL:
    MOVRW   PORTC
    ANDW    0X03
    XORW    0X01
    JPZ     FOUR
    JMP     EIGHTPOLL ; not actually needed

EIGHTPOLL:
    MOVRW   PORTC
    ANDW    0X03
    XORW    0X02
    JPZ     EIGHT
    JMP     SIXTEENPOLL

SIXTEENPOLL:
    MOVRW   PORTC
    ANDW    0X03
    XORW    0X03
    JPZ     SIXTEEN
    JMP     EOFPOLL

EOFPOLL:
    MOVRW   PORTC
    ANDW    0X03
    XORW    0X00
    JPZ     EOF
    JMP     POLL
;=======================;

; ==== NOTE LENGTH ==== ;
FOUR: ; 1.579 sec.
    MOVW    FOURd       ; put four delay length into W for TMR
    JMP     INITDELAY   ; move value into W, to then be stored in N_LENGTH

EIGHT: ; 0.789 sec.
    MOVW    EIGHTd      ; put eight delay length into W for TMR
    JMP     INITDELAY   ; move value into W, to then be stored in N_LENGTH

SIXTEEN: ; 0.395 sec.
    MOVW    SIXTEENd    ; put sixteen delay length into W for TMR
    JMP     INITDELAY   ; move value into W, to then be stored in N_LENGTH
;=======================;

; == TIMING FUNCTION == ;
INITDELAY:
   MOVWR    N_LENGTH    ; store n loop amount in a mem. location,
                        ; i.e. iterate FOUR/EIGHT/SIX.d times
                        ; therefore delay = Fd/Ed/Sd * 10ms

DELAY:
   MOVW     0x64        ; move 100 into pre, 4MHz/100 = 40KHz new CK speed
                        ; 100 * 100us = 10ms delay
   MOVWR    PRE         ; turn on the prescaler
   MOVW     0X64        ; move 100 into W to ...
   MOVWR    TMR         ; set delay time for TMR
   ; (loading TMR automatically clears the timer overflow bit in status SR)
   ; since prescaler is running at 100us / clock
   ; 100 x ck speed will give a total of 10ms delay.
   ; n * 10ms = delay (s)

SRPOLL:
   MOVRW    SR
   ; run the loop until timer == 0
   ; then decrement the note register so that the actual delay
   ; is equal to TMR * note length
   ; e.g., FOURd = 158 (9E) * 10ms = 1.58 seconds
   ANDW     0X02        ; check TMR flag in status register
   ;DEBUG               ; comment on production
   JPZ      SRPOLL      ; if TMR still low, keep polling for TMR high
                        ; when TMR goes high, don't loop but ...
   DEC      N_LENGTH    ; decrement the note length register
   JPZ      ROTLOOP     ; if looped SRPOLL time/s (Z=1), goto stepper routine
   JMP      DELAY       ; Z=0, therefore timer loop not over, go back to delay
;=======================;

; == STEPPER CONTROL == ;
ROTLOOP:
    MOVW    0X00        ; turn off ...
    MOVWR   PRE         ; ... the prescaler (PRE=0, TMR DISABLED)
    MOVW    ROTAMOUNT   ; rotate 14 times, T = 360/no. sectors(27) = 13.3^.
    MOVWR   R_COUNT     ; move rotamount into memory location
REP:
    DEC     R_COUNT     ; decrement the current rotation count
    JPZ     DONE        ; if delay == 0 then poll
    CALL    ROTATE      ; rotate once
    JMP     REP         ; repeat loop until 0xE0 == 0
DONE:
    JMP     POLL        ; check new BCD value

ROTATE:
    MOVW    0X01        ; 1a
    MOVWR   PORTB       ; move to output
    CALL    WAIT50      ; delay 
    MOVW    0X02        ; 2a
    MOVWR   PORTB       ; move to output
    CALL    WAIT50      ; delay
    MOVW    0X04        ; 1b
    MOVWR   PORTB       ; move to output
    CALL    WAIT50      ; delay
    MOVW    0X08        ; 2b
    MOVWR   PORTB       ; move to output
    CALL    WAIT50      ; delay
RET

WAIT50:
    CALL    wait100ms
    CALL    wait10ms
    CALL    wait10ms
    CALL    wait10ms
    CALL    wait10ms
    CALL    wait10ms
RET
;=======================;

; ==== END OF FILE ==== ;
EOF:
   MOVW 0X01      	; move 1 into w
   MOVWR PORTB          ; turn on led
   CALL wait100ms       ; keep it on for 0.1s
   MOVW 0X00            ; move 0 into w
   MOVWR PORTB          ; turn off led
   CALL wait100ms       ; wait 0.1s
   MOVRW PORTB
   JMP POLL             ; else, poll again.
;=======================;
