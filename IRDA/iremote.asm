;=========================================================================
;	Sony SIRCS Protocol IR Remote Decoder 
;	(C) 2000 by Michael Owings. All Rights Reserved
;	You are free to use and post this code, provided such usage
;	is non-commercial and you give me credit. 
;	Commercial users should contact me for licensing terms. 
;	
;	Pin 2 -- used by the host computer to request the latest data
;	from the 12c508. The host should first pull this pin low, pause briefly
;	then bring it high. The PIC will then transmit a single 8 bit byte
;	back to the host on this same pin containing the SIRCS code for the last
;	key pressed, or 255 if no key has been pressed since the last read.
;
;	Pin 3 -- Optional pin used to signal the host that a new SIRCS code has
;	been received. Goes high when there is new unread data, else low. This can
;	be used to interrupt the host when new data is available
;
;	Data is currently transmitted on pin 2 at 2400 baud, 8-n-1. The baud
;	rate can be changed by fooling with subroutine baud_delay.
;
;	Any Sony remote or cheap universal remote can be used to transmit the 
;	codes. For a universal remote, just program it as a sony remote and
;	you will be good to go. The full receiver circuit requires only
;	three additional components -- an IR decoder module (such as the Sharp or 
;	Lite-On modules) a 47uF cap and a 47 ohm resistor.
;
;	SIRCS Notes:
;	A SIRCS message actually consists of a 5 or 8 bit device code along
;	with a 7 bit command code. We always toss the 5 bit code and only
;	return the command code. Also, we always assume a 5-bit device
;	code, so an incoming SIRCS message with an 8 bit device code will
;	possibly cause us problems, but this would not normally be a 
;	concern as most messages will only use the 5-bit device code.
;	Moreover, the command byte comes first so it is unlikely the the
;	extra device bits would cause any problems.
;
;	Messages begin with a 2.4 ms start bit. Then the message itself. First
;	the 7 bit control code is transmitted (in reverse bit order, i.e. msb-lsb
; 	then the 5 or 8 bit (usually 5) device code is transmitted, also in msb-lsb
;	order. 
;
;	The IRM module pulls IRM low when a pulse is received. A one is represented by 
;	a 1.2 ms pulse, followed by 0.4ms of no pulse. A 0 is represented by 0.8ms pulse
;	followed by 0.4ms of no pulse. Total message time is always streched to 45 ms by
;	the remote (filled out by no pulse)
;
;	CREDIT WHERE CREDIT IS DUE:
;	Idea for this project based on Dennis Clark's 12c508 Dinsmore Compass processor
;	Serial output routines also derived (to put it nicely) from this code. See:
;	http:/www.verinet.com/~dlc/botlinks.htm	 
;
;	Address any questions/comments to mikey@swampgas.com	
;=========================================================================
	INCLUDE	"P12C508A.INC"

	TITLE '12C508 SIRCS Protocol Decoder Module
	LIST P = 12C508A, F = INHX8M

;==========================================================================
;       Program Variables
;==========================================================================
#define BDELAY		D'51'		; 2400 BAUD delay amount (417us)
#define LED 		GPIO,0		; Pin 7 = GP0 Used for debugging only
#define	OUT			GPIO,5		; Pin 2 = GP5 = OUT
#define ATN			GPIO,4		; Pin3 = GP4 = ATN Line
#define IRM			GPIO,1		; Pin 6 = GP1 = IR Module connection
		LIST
WAIT		EQU	9 		; Location for counter for 200 us time delay loop
WAIT2		EQU D'14' 	; Location for outer loop
DTEMP		EQU D'13'   ; Temp location of data being sent
DOUT		EQU	D'11'	; Location of data to be sent
BCOUNT		EQU	D'12'	; bit count register
PTIMER		EQU D'15'	; Pulse timer register
TIMER100	EQU	D'16'	; 100 us timer loop counter used in pulse counter
FIFTY		EQU	D'17'	; Holds the number 50

;================================
;       Main Code               =
;================================
	org		0x1FF		; Set your EPROM oscillator trim. This line can 
	movlw	0x70		; be removed for OTPs
start
	org		0x000
	movwf 	OSCCAL		; Store the factory osc. calibration value
	movlw	B'11100010'	; Set all as outputs except 6 and 2
	tris	GPIO		; Config I/O
	movlw	B'01000000'	; Set OPTION bits (weak pullups enabled)
	option				
	bcf		ATN			; Attention line low
	movlw	D'255'
	movwf	DOUT		; Init DOUT to 255 (no reading)
	movlw	D'50'
	movwf	FIFTY

atn_wait
	call	check_irm
	btfsc	OUT			; Wait for low on OUT...
	goto	atn_wait
atn_wait2
	call	check_irm
	btfss	OUT	   		; Followed by high
	goto	atn_wait2

	movlw	D'20'		; Give the remote 4 ms to be ready for transmit
	movwf	WAIT2
wait_loop
	call	delay200us 		
	decfsz	WAIT2,F
	goto	wait_loop		

	call	sendbyte 	; send DOUT
	bcf		ATN			; Indicate no data
	movlw	D'255'
	movwf	DOUT		; Put 255 into DOUT (no reading)
	goto	atn_wait	; Do it again

; Time pulses and construct DOUT
check_irm
	btfsc	IRM		 		; Falling edge of a pulse?
	goto	end_check_irm	; If not, exit

	call	time_pulse		; Time startbit
	movlw	D'21'			; Check for lte 21 (2.1 ms)
	movwf	DTEMP
	movf	PTIMER,W		; Move PTIMER to W
	subwf	DTEMP,W			; Subtract
	btfsc	STATUS,C		; Carry flag clear?
	goto	end_check_irm	; If not we're lte 21, so bail -- start bit too short DOUT = 255
	movlw	D'26'			; Check for lte 26 (2.6ms)
	movwf	DTEMP
	movf	PTIMER,W		; Move PTIMER to W
	subwf	DTEMP,W			; Subtract
	btfss	STATUS,C		; Carry flag set?
	goto	end_check_irm	; If not, we're gt 26 so bail -- start bit too long DOUT = 255

	clrf	DOUT			; Clear DOUT
	movlw	D'8'			; 1200 us is a high, 600 us is low
	movwf	DTEMP			; so we split the dif and say < 900 is low, > 900 is high
	
	movlw	D'7'			; Get all 7 data bits
	movwf	BCOUNT			; move bits to get into BCOUNT
get_bit
	call	time_pulse		; get pulse width
	movf	PTIMER,W		; Put pulse time into w
	subwf	DTEMP,W			; Subtract w from 8 (800 us)
	btfss	STATUS,C		; W less thsn or eq to 8?
	goto	set_bit			; if not, set the bit
	bcf		STATUS,C		; clear carry bit
	goto	rotate_byte		; go rotate it
set_bit
	bsf		STATUS,C		; set carry bit
rotate_byte
	rrf		DOUT,F			; rotate carry bit into DOUT
	decfsz	BCOUNT,F		; dec bit count
	goto	get_bit 		; if > 0, get next bit
	bcf		STATUS,C		; Clear carry flag
	rrf		DOUT,F			; rotate 0 into high bit and we're done

	movlw	D'5'			; Get 5 category bits and discard
	movwf	BCOUNT
get_catbit
	call	time_pulse		; Get category bit pulse time
	decfsz	BCOUNT,F		; Toss bit, just decrement
	goto	get_catbit		; if not 0, go get next cat bit

	movlw	D'210'			; 210 x 200 us = 42 ms
	movwf	WAIT2			; Wait 42 ms to debounce 
debounce_loop
	call	delay200us		; Delay 200us
	decfsz	WAIT2,F			; dec wait counter
	goto	debounce_loop	; loop if not 0

	bsf		ATN				; We have data
end_check_irm
	return					; All done

; 200 us Delay routine
; 2us to call + 2us to load regs +188us in loop + 2us to return = 100us 
delay200us
	MOVLW	D'62' ; Load outer loop counter
	MOVWF	WAIT
dloop
	DECFSZ	WAIT,F
	GOTO	dloop
	RETURN

; Pulse timer routine
; Waits for IRM to go low (if it already isn't) and then times 
; how long till it goes high again. Time in 100us units is returned in PTIMER
time_pulse
	movlw	D'50' 		; wait up to 5ms for IRM to go low
	movwf	PTIMER
wait_low
	movlw	D'19'		; Init 100us timer loop
	movwf	TIMER100
ck_irm_low
	btfss	IRM			; Is IRM set?
	goto	wait_high	; If not, we're done -- wait for pulse to go high
	decfsz	TIMER100,F	; Dec 100us timer
	goto	ck_irm_low	; Keep going if not 0
	decfsz	PTIMER,F	; Dec main timer
	goto	wait_low	; If !0, then reset 100us timer
	retlw	D'255'		; If here, then we timed out, so bail
wait_high
	movlw	D'50'
	movwf	PTIMER		; Wait up to 5ms for pulse to go high
wt_high
	movlw	D'19'		; Init 100 us timer
	movwf	TIMER100
ck_irm_high
	btfsc	IRM			; IRM clear?
	goto	tp_finish	; If not, we're done
	decfsz	TIMER100,F	; dec timer
	goto	ck_irm_high	; goto IRM high
	decfsz	PTIMER,F	; Dec pulse timer
	goto	wt_high		; If not done, reset 100us timer
	retlw	D'255'		; If here, we timed out so bail
tp_finish
	movf	PTIMER,W	; Subtract PTIMER from 50
	subwf	FIFTY,W		; Put result in W
	movwf	PTIMER		; Back into PTIMER
	return				; PTIMER has pulse width in 100 us intervals

; Baud delay routine
; Short 2400 BAUD (417us) delay
; Other baud rates are possible by fiddling with BDELAY and the nops
; The delay needed for a given baude rate in uS can be figured by simply
; dividing 1,000,000 by the desired baud rate. For example:
; 9600 baud would need a delay of 1000000/9600 = 104 uS (rounded)  
baud_delay
	movlw	BDELAY		; 416us delay
	movwf	WAIT		
bdloop					
	nop
	nop
	nop
	nop
	nop
	decfsz	WAIT,F		; dec wait loop
	goto	bdloop		; repeat if != 0
	nop
	nop
	nop
	return				

; Send DOUT serially to OUT. The delay configured in baud_delay determines the
; baud rate. DOUT is not destroyed. 
sendbyte
	movlw	B'11000010'		; Set 2 as an output temporarily 
	tris	GPIO			; Change IO bit for 2
	bsf		OUT				; serial line high
	call	baud_delay		; 

	movf	DOUT,W			; Put DOUT into DTEMP (which gets destroyed)
	movwf	DTEMP

	movlw	8				; Assume 8 bits (actually we could get away with 7)
	movwf	BCOUNT			; 
	bcf		OUT				; Start bit is always low
send_bit
	call	baud_delay		; Wait for the specified baud delay
	rrf		DTEMP,F			; Rotate next bit into carry flag
	btfsc	STATUS,C		; Is it clear?
	bsf		OUT				; Nope -- it's a one
	btfss	STATUS,C		; retest it 
	bcf		OUT				; It's a 0
	decfsz	BCOUNT,F		; When 0, all bits have been sent
	goto 	send_bit		; goto get next bit

	call	baud_delay		; Last delay
	bsf		OUT				; Stop bit
	call	baud_delay		; For at LEAST baud_delay us

	movlw	B'11100010'		; Set 2 back to input 
	tris	GPIO			; Reset IO
	return

	end