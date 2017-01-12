;=======================+
; inputs: c0, c1        |
; corres: 1/8, 1/16 MSB |
; output: b0 b1 b2 b3   |
; twentytwoo - 2017 JLC |
;=======================+

; ===== VARIABLES ===== ;
#DEFINE FOURd      0X9E ; 1.527s / 0.01 = 157.9 = 158
#DEFINE EIGHTd     0X4F ; 0.789s / 0.01 = 78.9 = 79
#DEFINE SIXTEENd   0X28 ; 0.395s / 0.01 = 39.5 = 40
#DEFINE ROTAMOUNT  0X0F ; (rotate n times) 0x0e = 15-1=14
; == MEM.  LOCATIONS == ;
SYMBOL N_LENGTH    = B0 ; note duration delay value
SYMBOL R_COUNT     = B1 ; rotation call count
;=======================;

INIT:
    MOVW    0X03        ; C0 and C1 as inputs
    MOVWR   TRISC       ; set PORTC as input

; == SPEED ALGORITHM == ;
POLL:
    MOVRW   PORTC       ; get current BCD value
    JPZ     FOREOF      ; if 00 then maybe 1/4 or EOF
    XORW    0X03        ; input sanitizing
    ANDW    0X03        ; is it 1/4 or EOF?
    JPZ     FOREOF      ; if not, then 1/4 or EOF
    JMP     SORE        ; else 1/16 OR 1/8 delay

FOREOF:
    MOVRW   PORTC       ; get current BCD value
    ANDW    0X03        ; is it EOF?
    JPZ     FOUR        ; if not, then 1/4 delay
    JMP     EOF         ; else goto EOF loop

SORE:
    MOVRW   PORTC       ; get current BCD value
    ANDW    0X02        ; is it a 1/6 note?
    JPZ     EIGHT       ; if not, then 1/8 delay
    JMP     SIXTEEN     ; else 1/16 delay
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
    CALL    wait10ms    ; delay
    MOVW    0X02        ; 2a
    MOVWR   PORTB       ; move to output
    CALL    wait10ms    ; delay
    MOVW    0X04        ; 1b
    MOVWR   PORTB       ; move to output
    CALL    wait10ms    ; delay
    MOVW    0X08        ; 2b
    MOVWR   PORTB       ; move to output
    CALL    wait10ms    ; delay
RET
;=======================;

; ==== END OF FILE ==== ;
EOF:
   MOVW 0X01      	    ; move 1 into w
   MOVWR PORTB          ; turn on led
   CALL wait100ms       ; keep it on for 0.1s
   MOVW 0X00            ; move 0 into w
   MOVWR PORTB          ; turn off led
   CALL wait100ms       ; wait 0.1s
   MOVRW PORTC          ; get portc input
   ANDW 0X03            ; can start again?
   JPZ EOF              ; if not, loop
   JMP POLL             ; else, start song again.
;=======================;
