;=======================+
; inputs: c0, c1        |
; corres: 1/8, 1/16 MSB |
; output: b0 b1 b2 b3   |
; twentytwoo - 2017 JLC |
;=======================+
setfreq m8
; ===== VARIABLES ===== ;
#DEFINE FOURd      0X10 ; 1.527s / 0.01 = 157.9 = 158 0x30
#DEFINE EIGHTd     0X05 ; 0.789s / 0.01 = 78.9 = 79
#DEFINE SIXTEENd   0X01 ; 0.395s / 0.01 = 39.5 = 40
#DEFINE ROTAMOUNT  0X02 ; (rotate n times) 0x02 = 2 * 1.8 deg
; == MEM.  LOCATIONS == ;
SYMBOL N_LENGTH    = B0 ; note rpm value
SYMBOL R_COUNT     = B1 ; rotation call count
SYMBOL SWP         = B2;
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
    JMP     ROTLOOP     ; move value into W, to then be stored in N_LENGTH

EIGHT: ; 0.789 sec.
    MOVW    EIGHTd      ; put eight delay length into W for TMR
    JMP     ROTLOOP     ; move value into W, to then be stored in N_LENGTH

SIXTEEN: ; 0.395 sec.
    MOVW    SIXTEENd    ; put sixteen delay length into W for TMR
    JMP     ROTLOOP     ; move value into W, to then be stored in N_LENGTH
;=======================;
; === SPEED CONTROL === ;
RPMDEL:
   MOVRW N_LENGTH       ; move delay value into W
   MOVWR SWP            ; and save it in the SWP memory location

DELAY:
   CALL     wait100ms   ; wait 0.1s
   JPZ      ENDOFDELAY  ; if N_LENGTH == 0, end of loop
   ; put this here to prevent arithmetic underflow looping back
   ; and putting 255 into N_LENGTH
   DEC      N_LENGTH    ; decrement counter
   JMP      DELAY       ; loop

ENDOFDELAY:
   MOVRW   SWP          ; at end of loop, restore value back into
   ; N_LENGTH so that the next call has the same delay
   MOVWR   N_LENGTH     ; save W into N_LENGTH
   RET                  ; return back to stepper rotating
;=======================;
; == STEPPER CONTROL == ;
ROTLOOP:
   MOVWR    N_LENGTH    ; store n loop amount in a mem. location,
                        ; i.e. iterate FOUR/EIGHT/SIX.d times
                        ; therefore delay = Fd/Ed/Sd * 10ms
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
    CALL    RPMDEL      ; delay 
    MOVW    0X02        ; 2a
    MOVWR   PORTB       ; move to output
    CALL    RPMDEL      ; delay
    MOVW    0X04        ; 1b
    MOVWR   PORTB       ; move to output
    CALL    RPMDEL      ; delay
    MOVW    0X08        ; 2b
    MOVWR   PORTB       ; move to output
    CALL    RPMDEL      ; delay
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
