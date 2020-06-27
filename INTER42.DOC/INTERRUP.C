Interrupt List, part 3 of 12
This compilation is Copyright (c) 1989,1990,1991,1992,1993,1994 Ralf Brown
--------B-1580-------------------------------
INT 15 C - OS HOOK - DEVICE OPEN (AT,XT286,PS)
	AH = 80h
	BX = device ID
	CX = process ID
	CF clear
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = status (see #0333)
Note:	this function should be hooked by a multitasker which wishes to keep
	  track of device ownership; the default BIOS handler merely returns
	  successfully
SeeAlso: AH=81h,AH=82h

(Table 0333)
Values for status:
 80h	invalid command (PC,PCjr)
 86h	function not supported (XT)
--------b-1580------------------------------------
INT 15 - HUNTER 16 - GET/SET BATTERY CAPACITY (APM)
	AH = 80h
	AL = function
	    00h get
		Return: AL = capacity (500mA + AL * 50mA, max 40 = 2500mA)
	    else set
		BL = battery capacity (same as AL above)
SeeAlso: AH=61h"HUNTER",AH=81h"HUNTER"
--------B-1581-------------------------------
INT 15 C - OS HOOK - DEVICE CLOSE
	AH = 81h
	BX = device ID
	CX = process ID
	CF clear
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = status (see #0333)
Note:	this function should be hooked by a multitasker which wishes to keep
	  track of device ownership; the default BIOS handler merely returns
	  successfully
SeeAlso: AH=80h,AH=82h
--------b-1581------------------------------------
INT 15 - HUNTER 16 - CONTROL POWER OUTPUT
	AH = 81h
	AL = new state of power output (00h off, nonzero on)
Desc:	turn the +5V low power output on or off
SeeAlso: AH=80h"HUNTER"
--------B-1582-------------------------------
INT 15 C - OS HOOK - PROGRAM TERMINATION
	AH = 82h
	BX = process ID
	CF clear
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = status (see #0333)
Notes:	closes all devices opened by the given process ID with function 80h
	this function should be hooked by a multitasker which wishes to keep
	  track of device ownership; the default BIOS handler merely returns
	  successfully
SeeAlso: AH=80h,AH=81h
--------b-1582------------------------------------
INT 15 - HUNTER 16 - SOUND OUTPUT
	AH = 82h
	DX = length (duration in seconds = DX * 666670 / frequency)
	BX = pitch (see #0334)
Desc:	Sound the tone specified in BX for the duration in DX
SeeAlso: AX=1019h

(Table 0334)
Values for HUNTER 16 sound pitch:
BX(dec)	 Note	Frequency	BX(dec)	 Note	Frequency
  425	G	1568.000	 1515	A	 440.000
  451	F#	1479.503	 1605	G#	 415.307
  477	F	1396.900	 1701	G	 392.000
  506	E	1318.500	 1802	F#	 369.998
  536	D#	1244.523	 1909	F	 349.230
  568	D	1174.700	 2022	E	 329.630
  601	C#	1108.749	 2143	D#	 311.127
  637	C	1046.500	 2270	D	 293.660
  675	B	 958.770	 2405	C#	 277.183
  715	A#	 932.329	 2548	MID C	 261.630
  758	A	 880.000	 2700	B	 246.940
  803	G#	 830.609	 2860	A#	 233.081
  850	G	 783.990	 3030	A	 220.000
  901	F#	 739.990	 3210	G#	 207.654
  954	F	 698.460	 3401	G	 196.000
 1011	E	 659.260	 3604	F#	 184.996
 1071	D#	 622.257	 3818	F	 174.610
 1135	D	 587.330	 4045	E	 164.810
 1203	C#	 554.365	 4286	D#	 155.560
 1274	C	 523.250	 4540	D	 146.830
 1350	B	 493.880	 4668	C#	 142.827
 1430	A#	 466.162	 4803	C	 138.810
--------B-1583-------------------------------
INT 15 - BIOS - SET EVENT WAIT INTERVAL (AT,PS50+)
	AH = 83h
	AL = subfunction
	    00h set interval
		CX:DX = microseconds to delay
		ES:BX -> byte whose high bit is to be set at end of interval
	    01h cancel wait interval
Return: CF set on error or function already busy
	    AH = status
		80h invalid command (PC,PCjr)
		86h function not supported (XT and later)
	CF clear if successful
Notes:	the resolution of the wait period is 977 microseconds on most systems
	  because most BIOSes use the 1/1024 second fast interrupt from the AT
	  real-time clock chip which is available on INT 70
	IBM AT 1/10/84 BIOS ignores AL and always performs subfunction 00h
SeeAlso: AH=41h,AH=86h,INT 70
--------b-1583------------------------------------
INT 15 - HUNTER 16 - CONTROL SCREEN SYNCHRONISATION
	AH = 83h
	AL = state of LCD window (00h disabled, nonzero enabled)
Desc:	Enable/disable the facility where the displayed window tracks the
	  cursor output to keep the focus visible
--------B-1584-------------------------------
INT 15 - BIOS - JOYSTICK SUPPORT (XT after 11/8/82,AT,XT286,PS)
	AH = 84h
	DX = subfunction
	    0000h read joystick switches
		Return: AL bits 7-4 = switch settings
	    0001h read positions of joysticks
		Return: AX = X position of joystick A
			BX = Y position of joystick A
			CX = X position of joystick B
			DX = Y position of joystick B
Return: CF set on error
	    AH = status (see #0333)
	CF clear if successful
Notes:	if no game port is installed, subfunction 0000h returns AL=00h (all
	  switches open) and subfunction 0001h returns AX=BX=CX=DX=0000h
	a 250kOhm joystick typically returns 0000h-01A0h
--------b-158400----------------------------------
INT 15 - HUNTER 16 - GET DISKETTE PORT
	AX = 8400h
	BH = Drive (0: A:, 1: B:)
Return: AL = Port (0: COM1, >0: COM2)
Desc:	return the COM port used for the floppy drive
SeeAlso: AX=8401h
--------b-158401----------------------------------
INT 15 - HUNTER 16 - SET DISKETTE PORT
	AX = 8401h
	BH = Drive (0: A:, 1: B:)
	BL = Port (0: COM1, >0: COM2)
Desc:	set the COM port used for the floppy drive
SeeAlso: AX=8400h
--------B-1585-------------------------------
INT 15 C - OS HOOK - SysReq KEY ACTIVITY (AT,PS)
	AH = 85h
	AL = SysReq key action (00h pressed, 01h released)
	CF clear
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = status (see #0333)
Notes:	called by keyboard decode routine
	the default handler simply returns successfully; programs which wish
	  to monitor the SysReq key must hook this call
	the SysReq key is often labeled SysRq
SeeAlso: INT 09
--------b-158500----------------------------------
INT 15 - HUNTER 16 - RESTORE POWER MENU (APM)
	AX = 8500h
Desc:	restore the standard power menu
SeeAlso: AX=8501h"HUNTER"
--------b-158501----------------------------------
INT 15 - HUNTER 16 - SET POWER MENU (APM)
	AX = 8501h
	BL = user software interrupt number
Desc:	install an alternate power menu routine
SeeAlso: AX=8500h"HUNTER"
--------B-1586-------------------------------
INT 15 - BIOS - WAIT (AT,PS)
	AH = 86h
	CX:DX = interval in microseconds
Return: CF clear if successful (wait interval elapsed)
	CF set on error or AH=83h wait already in progress
	    AH = status (see #0333)
Note:	the resolution of the wait period is 977 microseconds on most systems
	  because most BIOSes use the 1/1024 second fast interrupt from the AT
	  real-time clock chip which is available on INT 70
SeeAlso: AH=41h,AH=83h,INT 1A/AX=FF01h,INT 70
--------b-1586------------------------------------
INT 15 - HUNTER 16 - GET/SET SCREEN ATTRIBUTE TABLE
	AH = 86h
	AL = function (00h get, nonzero set)
	BX = 1234h
	DS:SI -> 256-byte Attribute buffer
Note:	In text modes each character has its attribute byte XOR'd with the
	  corresponding byte in the attribute table.  If the attribute is 15,
	  15 is XOR'd with Table[15]
--------B-1587-------------------------------
INT 15 - SYSTEM - COPY EXTENDED MEMORY
	AH = 87h
	CX = number of words to copy (max 8000h)
	ES:SI -> global descriptor table (see #0336)
Return: CF set on error
	CF clear if successful
	AH = status (see #0335)
Notes:	copy is done in protected mode with interrupts disabled by the default
	  BIOS handler; many 386 memory managers perform the copy with
	  interrupts enabled
	this function is incompatible with the OS/2 compatibility box
SeeAlso: AH=88h,AH=89h,INT 1F/AH=90h

(Table 0335)
Values for extended-memory copy status:
 00h	source copied into destination
 01h	parity error
 02h	interrupt error
 03h	address line 20 gating failed
 80h	invalid command (PC,PCjr)
 86h	unsupported function (XT,PS30)

Format of global descriptor table:
Offset	Size	Description	(Table 0336)
 00h 16 BYTEs	zeros (used by BIOS)
 10h	WORD	source segment length in bytes (2*CX-1 or greater)
 12h  3 BYTEs	24-bit linear source address, low byte first
 15h	BYTE	source segment access rights (93h)
 16h	WORD	zero
 18h	WORD	destination segment length in bytes (2*CX-1 or greater)
 1Ah  3 BYTEs	24-bit linear destination address, low byte first
 1Dh	BYTE	destination segment access rights (93h)
 1Eh 18 BYTEs	zeros (used by BIOS)
--------b-1587------------------------------------
INT 15 - HUNTER 16 - SET INT 72h VECTOR
	AH = 87h
	DS:DX = new service routine
Desc:	set the INT 72h vector which is called in 2 cases:
	  - when the machine is about to turn off or reboot, INT 72h is called
	    with AH=0
	  - when the machine is powering up INT 72h is called with AH=01h
Note:	the actual INT 72h vector must also be changed with INT 21/AH=25h
--------B-1588-------------------------------
INT 15 - SYSTEM - GET EXTENDED MEMORY SIZE (286+)
	AH = 88h
Return: CF clear if successful
	    AX = number of contiguous KB starting at absolute address 100000h
	CF set on error
	    AH = status
		80h invalid command (PC,PCjr)
		86h unsupported function (XT,PS30)
Notes:	TSRs which wish to allocate extended memory to themselves often hook
	  this call, and return a reduced memory size.	They are then free to
	  use the memory between the new and old sizes at will.
	the standard BIOS only returns memory between 1MB and 16MB; use AH=C7h
	  for memory beyond 16MB
	not all BIOSes correctly return the carry flag, making this call
	  unreliable unless one first checks whether it is supported through
	  a mechanism other than calling the function and testing CF
SeeAlso: AH=87h,AH=C7h
--------b-1588------------------------------------
INT 15 - HUNTER 16 - GET POWER UP KEYS
	AH = 88h
Return: AH = 00h
	BX = column
	CL = row
SeeAlso: AH=71h
--------B-1589-------------------------------
INT 15 - SYSTEM - SWITCH TO PROTECTED MODE
	AH = 89h
	BL = interrupt number of IRQ0 (IRQ1-7 use next 7 interrupts)
	BH = interrupt number of IRQ8 (IRQ9-F use next 7 interrupts)
	ES:SI -> GDT for protected mode
	       offset 0h  null descriptor (initialize to zeros)
		      8h  GDT descriptor
		     10h  IDT descriptor
		     18h  DS
		     20h  ES
		     28h  SS
		     30h  CS
		     38h  uninitialized, used to build descriptor for BIOS CS
Return: CF set on error
	   AH = FFh  error enabling address line 20
	CF clear if successful
	   AH = 00h
	   in protected mode at specified address
Notes:	BL and BH must be multiples of 8
	the protected-mode CS must reference the same memory as the CS this
	  function is called from because execution continues with the address
	  following the interrupt call
SeeAlso: AH=87h,AH=88h,INT 67/AX=DE0Ch
--------b-158900----------------------------------
INT 15 - HUNTER 16 - GET POWER MODE
	AX = 8900h
Return: AH = 00h
	BL = current power mode
	    00h Standard Power Mode (SPM)
	    01h Advanced Power Mode (APM)
SeeAlso: AX=8901h
--------b-158901----------------------------------
INT 15 - HUNTER 16 - SET POWER MODE
	AX = 8901h
	BL = new mode
	    00h Standard Power Mode (SPM)
	    01h Advanced Power Mode (APM)
Return: AH = 00h
SeeAlso: AX=8900h
--------b-158A------------------------------------
INT 15 - HUNTER 16 - CONTROL POWER INPUT (SPM)
	AH = 8Ah
	AL = new state of Power Input (00h disabled, nonzero enabled)
	SI = 1234h
	DI = 5678h
Return: AH = status
	    00h success
	    FFh failure
Desc:	Enable or disable Power Input. When Power Input is disabled the AC
	  adaptor will neither charge the batteries nor supply power to the
	  Hunter 16. Disable Power Input if using Alkaline batteries.
--------b-158B------------------------------------
INT 15 - HUNTER 16 - GET/SET CHARGER TEMPERATURE OVERRIDE
	AH = 8Bh
	AL = function
	    00h get
		Return:	BH = Maximum charging temperature
				Temp = -20 + (n * 0.63) degrees Centigrade
			BL = Minimum charging temperature
	    else set
		BH = maximum charging temperature (as above)
		BL = minimum charging temperature (as above)
Return: AH = status
	    00h success
	    FFh failure 
Desc:	get/set the temperature interval within which the charger should 
	  operate
--------b-158C------------------------------------
INT 15 - HUNTER 16 - GET/SET POWER SAVE ENTRY FLAG
	AH = 8Ch
	AL = function
	    00h get
		Return: BX = which operations disable power save (see #0337)
	    else set
		BX = which operations should disable power save (see #0337)
SeeAlso: AH=8Dh

Bitfields for HUNTER 16 operations disabling power save:
Bit(s)	Description	(Table 0337)
 0	INT 10h prevents power save
 1	INT 13h prevents power save
 2	INT 14h prevents power save
 3	INT 15h prevents power save
 4	INT 1Ah prevents power save
 5	INT 21h prevents power save
 6	direct write to video RAM prevents power save
 7	access to 8250 UART prevents power save
 8	access to 8253 (Sound) prevents power save
--------b-158D------------------------------------
INT 15 - HUNTER 16 - GET/SET BOOST CHARGE (SPM)
	AH = 8Dh
	AL = function
	    00h get
		Return: AL = Fast Charge state (00h prevented, else allowed)
	    nonzero set
		BH = Fast Charge state (00h prevent, nonzero allow)
Return: AH = status
	    00h success
	    FFh failure
Desc:	control whether Fast Charging (200ma rather than 70ma) is allowed
SeeAlso: AH=8Ch
--------B-1590-------------------------------
INT 15 - OS HOOK - DEVICE BUSY (AT,PS)
	AH = 90h
	AL = device type (see #0338)
	ES:BX -> request block for type codes 80h through BFh
	CF clear
Return: CF set if wait time satisfied
	CF clear if driver must perform wait
	    AH = 00h
Notes:	type codes are allocated as follows:
	  00-7F non-reentrant devices; OS must arbitrate access
	  80-BF reentrant devices; ES:BX points to a unique control block
	  C0-FF wait-only calls, no complementary INT 15/AH=91h call
	floppy and hard disk BIOS code uses this call to implement a timeout;
	  for device types 00h and 01h, a return of CF set means that the
	  timeout expired before the disk responded.
	this function should be hooked by a multitasker to allow other tasks
	  to execute while the BIOS is waiting for I/O completion; the default
	  handler merely returns with AH=00h and CF clear
SeeAlso: AH=91h,INT 13/AH=00h,INT 17/AH=00h,INT 1A/AH=83h

(Table 0338)
Values for device type:
 00h	disk
 01h	diskette
 02h	keyboard
 03h	PS/2 pointing device
 21h	waiting for keyboard input (Phoenix BIOS)
 80h	network
 FBh	digital sound (Tandy)
 FCh	disk reset (PS)
 FDh	diskette motor start
 FEh	printer
--------B-1591-------------------------------
INT 15 - OS HOOK - DEVICE POST (AT,PS)
	AH = 91h
	AL = device type (see #0338)
	ES:BX -> request block for type codes 80h through BFh
	CF clear
Return: AH = 00h
Note:	this function should be hooked by a multitasker to allow other tasks
	  to execute while the BIOS is waiting for I/O completion; the default
	  handler merely returns with AH=00h and CF clear
SeeAlso: AH=90h
----------15A1-------------------------------
INT 15 U - AMI PCI BIOS - SET ??? FLAG
	AX = A100h
Return: AX = 0000h
	CF clear
Desc:	sets bit 7 of CMOS RAM location 37h and updates the CMOS checksum in
	  locations 3Eh and 3Fh
Note:	in the examined version of the BIOS, nonzero values in AL cause it to
	  drop through to checking the next possible value of AH, i.e. only
	  subfunction 00h is supported
--------b-15BC-------------------------------
INT 15 - Phoenix 386 BIOS - DETERMINE CPU SPEED FOR DELAY LOOPS
	AH = BCh
Return: CF clear
	(Phoenix 1.10 10a) BYTE 0040h:00B0h set to delay loop count
	(Dell 4xxDE BIOS A11) WORD 0040h:00ECh set to delay loop count
Note:	this function reads system timer channel 0 twice, then does
	  calculations on the returned values to determine the delay loop
	  counter needed by the BIOS for beeps and floppy timeouts
SeeAlso: AX=2305h
--------E-15BF00-----------------------------
INT 15 - Rational Systems DOS/16M - ???
	AX = BF00h
	???
Return: ???
Note:	under DESQview/X 1.02 DVDOS4GX.DVR, this call is identical to AX=BF02h
SeeAlso: AX=BF02h
--------E-15BF01-----------------------------
INT 15 - Rational Systems DOS/16M - ???
	AX = BF01h
	???
Return: ???
Notes:	under DESQview/X 1.02 DVDOS4GX.DVR, this call is identical to AX=BF02h
	called by DOS/4GW
SeeAlso: AX=BF00h,AX=BF02h
--------E-15BF02DX0000-----------------------
INT 15 - Rational Systems DOS/16M - INSTALLATION CHECK
	AX = BF02h
	DX = 0000h
Return: DX = nonzero if installed
	    DX:SI -> XBRK structure (see #0339)
Note:	this function is also supported by DOS/4G
SeeAlso: AX=BF01h,AX=BFDCh,AX=BFDEh/BX=0000h
SeeAlso: INT 21/AH=FFh/DH=0Eh,INT 2F/AH=A1h,INT 2F/AX=F100h,INT 2F/AX=FBA1h

Format of DOS/16M XBRK structure:
Offset	Size	Description	(Table 0339)
 00h	DWORD	linear address of first available byte
 04h	DWORD	linear address of last available byte + 1 ???
 08h	DWORD	real-mode address of XBRK structure???
 0Ch	DWORD	???
 10h  2 BYTEs	???
 12h	WORD	segment of ???
 14h  8 BYTEs	???
 1Ch 512 BYTEs	protected-mode IDT
21Ch  N BYTEs	protected-mode GDT
--------E-15BF03-----------------------------
INT 15 - Rational Systems DOS/4GW - UNINSTALL???
	AX = BF03h
	BX = PSP segment of extender
	???
Return: ???
Note:	if BX is not the PSP segment of the extender, it passes the call down
	  the INT 15 chain; this allows nested instances of the extender
SeeAlso: AX=BF06h
--------E-15BF04-----------------------------
INT 15 - Rational Systems DOS/4GW - ???
	AX = BF04h
	BX = PSP segment of extender
Return: nothing???
Notes:	if BX is not the PSP segment of the extender, it passes the call down
	  the INT 15 chain; this allows nested instances of the extender
	grabs INT 2Fh and installs handlers for INT 2F/AX=1605h-1607h
SeeAlso: INT 2F/AX=1607h/BX=22C0h
--------E-15BF05-----------------------------
INT 15 - Rational Systems DOS/4GW - INITIALIZE PROTECTED-MODE INTERFACE
	AX = BF05h
	BX = PSP segment of extender
Return: nothing???
Notes:	if BX is not the PSP segment of the extender, it passes the call down
	  the INT 15 chain; this allows nested instances of the extender
	calls INT 67/AX=DE01h if ???
--------E-15BF06-----------------------------
INT 15 - Rational Systems DOS/4GW - ???
	AX = BF06h
	BX = PSP segment of extender
	???
Return: ???
Note:	if BX is not the PSP segment of the extender, it passes the call down
	  the INT 15 chain; this allows nested instances of the extender
SeeAlso: AX=BF03h
--------E-15BFDCDX0000-----------------------
INT 15 - Rational Systems DOS/4GW - INSTALLATION CHECK
	AX = BFDCh
	DX = 0000h
	SI = 0000h
Return: DX = nonzero if installed
	    DX:SI -> XBRK structure (see #0339)
SeeAlso: AX=BF02h
--------E-15BFDEBX0000-----------------------
INT 15 - DESQview/X - DVDOS4GX.DVR - INSTALLATION CHECK
	AX = BFDEh
	BX = 0000h
Return: AX = ??? (0003h)
	BX = FFFFh
SeeAlso: AX=BF02h
--------E-15BFDEBX0001-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - GET PROCESS MANAGER NAME
	AX = BFDEh
	BX = 0001h
Return: BX = 0000h (success)
	CX:DX -> name of process manager executable
SeeAlso: AX=BFDEh/BX=0000h
--------E-15BFDEBX0002-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - SET ???
	AX = BFDEh
	BX = 0002h
	CX:DX -> ???
Return: BX = 0000h (success)
SeeAlso: AX=BFDEh/BX=0000h,AX=BFDEh/BX=0003h
--------E-15BFDEBX0003-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - GET ???
	AX = BFDEh
	BX = 0003h
Return: BX = 0000h (success)
	CX:DX -> ???
SeeAlso: AX=BFDEh/BX=0000h,AX=BFDEh/BX=0002h
--------E-15BFDEBX0004-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - ???
	AX = BFDEh
	BX = 0004h
	CL = ???
Return: BX = 0000h (success)
	CX:DX -> XBRK structure (see #0339)
SeeAlso: AX=BFDEh/BX=0000h
--------E-15BFDEBX0005-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - ???
	AX = BFDEh
	BX = 0005h
	CX = new value for ???
Return: BX = 0000h (success)
	AX = old value of ???
	DS:SI -> ??? (if AX nonzero on return)
	ES:DI -> ??? (if AX zero on return)
Note:	called by DOS4GW.EXE
SeeAlso: AX=BFDEh/BX=0000h
--------E-15BFDEBX0006-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - GET ???
	AX = BFDEh
	BX = 0006h
Return: BX = 0000h (success)
	AH = interrupt number??? (BEh)
	CX:DX = ???
SeeAlso: AX=BFDEh/BX=0000h,AX=BFDEh/BX=0007h,INT BE"DESQview"
--------E-15BFDEBX0007-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - SET ???
	AX = BFDEh
	BX = 0007h
	CX:DX = ???
Return: BX = 0000h (success)
SeeAlso: AX=BFDEh/BX=0000h,AX=BFDEh/BX=0006h
--------E-15BFDEBX0008-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - ???
	AX = BFDEh
	BX = 0008h
	CX = segment of ???
	DS = ???
Return: BX = status
	    0000h successful
		AL = ??? (80h or C0h)
		DX = ??? (0603h) if AL=C0h
	    0001h failed
		AX = 0000h
Note:	called by DOS4GW.EXE
SeeAlso: AX=BFDEh/BX=0000h
--------E-15BFDEBX0009-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - GET PROTECTED MODE PROGRAM LOADER
	AX = BFDEh
	BX = 0009h
Return: BX = 0000h (success)
	CX:DX -> full pathname to LOAD32.EXP
SeeAlso: AX=BFDEh/BX=0000h
--------E-15BFDEBX000A-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - DECREMENT ???
	AX = BFDEh
	BX = 000Ah
Return: BX = 0000h (success)
	AX = new value of ??? counter
Notes:	also resets a variety of values if the counter goes negative
	called by DOS4GW.EXE
SeeAlso: AX=BFDEh/BX=0000h,AX=BFDEh/BX=000Bh
--------E-15BFDEBX000B-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - INCREMENT ???
	AX = BFDEh
	BX = 000Bh
Return: AX = new value of ??? counter
Note:	called by DOS4GW.EXE
SeeAlso: AX=BFDEh/BX=0000h,AX=BFDEh/BX=000Ah
--------E-15BFDEBX000C-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - ???
	AX = BFDEh
	BX = 000Ch
	CL = ???
	    00h
	    nonzero
Return: ???
SeeAlso: AX=BFDEh/BX=0000h
--------E-15BFDEBX000D-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - ???
	AX = BFDEh
	BX = 000Dh
	???
Return: ???
SeeAlso: AX=BFDEh/BX=0000h
--------E-15BFDEBX000E-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - ???
	AX = BFDEh
	BX = 000Eh
	DX:CX -> ???
Return: AX = segment of handle for calling task
	BX = ??? (probably destroyed)
	DX:CX -> ???
SeeAlso: AX=BFDEh/BX=0000h,AX=BFDEh/BX=000Fh,AX=BFDEh/BX=0013h
--------E-15BFDEBX000F-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - ???
	AX = BFDEh
	BX = 000Fh
Return: AX = segment of handle for calling task
	BX = ??? (probably destroyed)
	DX:CX -> ???
Note:	identical to AX=BFDEh/BX=000Eh with CX:DX = 0000h:0000h
SeeAlso: AX=BFDEh/BX=000Eh,AX=BFDEh/BX=0010h
--------E-15BFDEBX0010-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - GET TASK HANDLE
	AX = BFDEh
	BX = 0010h
Return: AX = segment of caller's task handle
	BX destroyed
SeeAlso: AX=BFDEh/BX=000Fh
--------E-15BFDEBX0011-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - GET ???
	AX = BFDEh
	BX = 0011h
Return: CX = code segment of DVDOS4GX.DVR
	BX = ??? (0004h)
SeeAlso: AX=BFDEh/BX=0000h
--------E-15BFDEBX0012-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - GET ???
	AX = BFDEh
	BX = 0012h
Return: DX = code segment of DVDOS4GX.DVR
	BX = ??? (012Ch)
	CX = ??? (0006h)
SeeAlso: AX=BFDEh/BX=0000h
--------E-15BFDEBX0013-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - GET ???
	AX = BFDEh
	BX = 0013h
Return: DX:CX -> ???
SeeAlso: AX=BFDEh/BX=000Eh
--------E-15BFDEBX0014-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - LOCK ??? MAILBOX
	AX = BFDEh
	BX = 0014h
	CX = index of ??? mailbox
		(0000h-0004h valid, but no range checking done)
Return: AX,BX destroyed
SeeAlso: AX=BFDEh/BX=0015h,AX=BFDEh/BX=0017h
--------E-15BFDEBX0015-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - UNLOCK ??? MAILBOX
	AX = BFDEh
	BX = 0015h
	CX = index of ??? mailbox
		(0000h-0004h valid, but no range checking done)
Return: AX,BX destroyed
SeeAlso: AX=BFDEh/BX=0014h,AX=BFDEh/BX=0016h
--------E-15BFDEBX0016-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - CHECK IF ??? MAILBOX OWNED
	AX = BFDEh
	BX = 0016h
	CX = index of ??? mailbox
		(0000h-0004h valid, but no range checking done)
Return: AX = status
	    0000h no one owns mailbox
	    0001h mailbox has an owner
	BX destroyed
SeeAlso: AX=BFDEh/BX=0015h,AX=BFDEh/BX=0017h
--------E-15BFDEBX0017-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - GET ??? MAILBOX OWNER
	AX = BFDEh
	BX = 0017h
	CX = index of ??? mailbox
		(0000h-0004h valid, but no range checking done)
Return: AX = segment of mailbox owner's handle
	BX = segment of caller's task handle
SeeAlso: AX=BFDEh/BX=0015h,AX=BFDEh/BX=0016h
--------E-15BFDEBXFFFD-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - GET ???
	AX = BFDEh
	BX = FFFDh
Return: CX:DX = ???
SeeAlso: AX=BFDEh/BX=FFFEh
--------E-15BFDEBXFFFE-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - SET ???
	AX = BFDEh
	BX = FFFEh
	CX:DX = ???
SeeAlso: AX=BFDEh/BX=FFFDh
--------E-15BFDEBXFFFF-----------------------
INT 15 - DESQview/X 1.02+ - DVDOS4GX.DVR - NOP
	AX = BFDEh
	BX = FFFFh
SeeAlso: AX=BFDEh/BX=0000h
--------B-15C0-------------------------------
INT 15 - SYSTEM - GET CONFIGURATION (XT after 1/10/86,AT mdl 3x9,CONV,XT286,PS)
	AH = C0h
Return: CF set if BIOS doesn't support call
	CF clear on success
	    ES:BX -> ROM table (see #0340)
	AH = status
	    00h successful
	    86h unsupported function
Notes:	the 1/10/86 XT BIOS returns an incorrect value for the feature byte
	the configuration table is at F000h:E6F5h in 100% compatible BIOSes
	Dell machines contain the signature "DELL" or "Dell" at absolute FE076h
	  and a model byte at absolute address FE845h (see #0346)
	Hewlett-Packard machines contain the signature "HP" at F000h:00F8h and
	  a product identifier at F000h:00FAh (see #0348)
	Compaq machines can be identified by the signature string "COMPAQ" at
	  F000h:FFEAh, and is preceded by additional information (see #0347)
	Tandy 1000 machines contain 21h in the byte at F000h:C000h and FFh in
	  the byte at FFFFh:000Eh; Tandy 1000SL/TL machines only provide the
	  first three data bytes (model/submodel/revision) in the returned
	  table
	Toshiba laptops contain the signature "TOSHIBA" at FE010h as part of
	  a laptop information record at F000h:E000h (see #0349)
	some AST machines contain the string "COPYRIGHT AST RESEARCH" one byte
	  past the end of the configuration table
	the Phoenix 386 BIOS contains a second version and date string
	  (presumably the last modification for that OEM version) beginning at
	  F000h:FFD8h, with each byte doubled (so that both ROM chips contain
	  the complete information)
SeeAlso: AH=C7h,AH=C9h,AH=D1h

Format of ROM configuration table:
Offset	Size	Description	(Table 0340)
 00h	WORD	number of bytes following
 02h	BYTE	model (see #0345)
 03h	BYTE	submodel (see #0345)
 04h	BYTE	BIOS revision: 0 for first release, 1 for 2nd, etc.
 05h	BYTE	feature byte 1 (see #0341)
 06h	BYTE	feature byte 2 (see #0342)
 07h	BYTE	feature byte 3 (see #0343)
 08h	BYTE	feature byte 4 (see #0344)
 09h	BYTE	feature byte 5:
		reserved (0) (IBM)
		??? (08h) (Phoenix 386 v1.10)
---AWARD BIOS---
 0Ah  N BYTEs	AWARD copyright notice
---Phoenix BIOS---
 0Ah	BYTE	??? (00h)
 0Bh	BYTE	major version
 0Ch	BYTE	minor version (BCD)
 0Dh  4 BYTEs	ASCIZ string "PTL" (Phoenix Technologies Ltd)
---Quadram Quad386---
 0Ah 17 BYTEs	ASCII signature string "Quadram Quad386XT"

Bitfields for feature byte 1:
Bit(s)	Description	(Table 0341)
 7	DMA channel 3 used by hard disk BIOS
 6	2nd 8259 installed
 5	Real-Time Clock installed
 4	INT 15/AH=4Fh called upon INT 09h
 3	wait for external event (INT 15/AH=41h) supported
 2	extended BIOS area allocated (usually at top of RAM)
 1	bus is Micro Channel instead of ISA
 0	system has dual bus (Micro Channel + ISA)

Bitfields for feature byte 2:
Bit(s)	Description	(Table 0342)
 7	reserved
 6	INT 16/AH=09h (keyboard functionality) supported
 5	INT 15/AH=C6h (get POS data) supported
 4	INT 15/AH=C7h (return memory map info) supported
 3	INT 15/AH=C8h (en/disable CPU functions) supported
 2	non-8042 keyboard controller
 1	data streaming supported
 0	reserved

Bitfields for feature byte 3:
Bit(s)	Description	(Table 0343)
 7-5	reserved
 4	??? (set on 1992 PS/1's, N51SX, CL57SX, 35SX?, 40SX?)
 3	SCSI subsystem supported on system board
 2	information panel installed
 1	IML (Initial Machine Load) system
 0	SCSI supported in IML

Bitfields for feature byte 4:
Bit(s)	Description	(Table 0344)
 7	??? (set on N51SX, CL57SX)
 6-4	reserved
 3	??? (set on some 1992 PS/1's, 35SX, 40SX)
 2-1	reserved
 0	??? (set on N51SX, CL57SX, 57SX)

(Table 0345)
Values for model/submodel/revision:
Model  Submdl  Rev	BIOS date	System
 FFh	*	*	04/24/81	PC (original)
 FFh	*	*	10/19/81	PC (some bugfixes)
 FFh	*	*	10/27/82	PC (HD, 640K, EGA support)
 FFh	00h	rev	  ???		Tandy 1000SL
 FFh	01h	rev	  ???		Tandy 1000TL
 FFh	46h	***	  ???		Olivetti M15
 FEh	*	*	08/16/82	PC XT
 FEh	*	*	11/08/82	PC XT and Portable
 FEh	*	*	../..x..	Toshiba laptops up to ~1987
					("x"=product ID) (see #0350)
 FEh	43h	***	  ???		Olivetti M240
 FEh	A6h	???	  ???		Quadram Quad386
 FDh	*	*	06/01/83	PCjr
 FCh	*	*	01/10/84	AT models 068,099 6 MHz 20MB
 FCh	00h	00h	  ???		PC3270/AT
 FCh	00h	01h	06/10/85	AT model  239	  6 MHz 30MB
 FCh	00h	> 01h	  ???		7531/2 Industrial AT
 FCh	01h	00h	11/15/85	AT models 319,339 8 MHz, Enh Keyb, 3.5"
 FCh	01h	00h	09/17/87	Tandy 3000
 FCh	01h	00h	../..x..	Toshiba laptops since ~1988
					("x"=product ID) (see #0350)
 FCh	01h	00h	03/08/93	Compaq DESKPRO/i
 FCh	01h	00h	 various	Compaq DESKPRO, SystemPro, ProSignia
 FCh	01h	00h	07/20/93	Zenith Z-Lite 425L
 FCh	01h	20h	06/10/92	AST
 FCh	01h	30h	  ???		Tandy 3000NL
 FCh	01h	???	  ???		Compaq 286/386
 FCh	02h	00h	04/21/86	PC XT-286
 FCh	02h	00h	 various	Compaq LTE Lite
 FCh	02h	00h	08/05/93	Compaq Contura 486/486c/486cx
 FCh	04h	00h	02/13/87     ** PS/2 Model 50 (10 MHz/1 ws 286)
 FCh	04h	02h	  ???		PS/2 Model 50
 FCh	04h	03h	04/18/88	PS/2 Model 50Z (10 MHz/0 ws 286)
 FCh	04h	04h	  ???		PS/2 Model 50Z
 FCh	05h	00h	02/13/87     ** PS/2 Model 60 (10 MHz 286)
 FCh	06h	00h	  ???		IBM 7552-140 "Gearbox"
 FCh	06h	01h	  ???		IBM 7552-540 "Gearbox"
 FCh	08h	***	  ???		Epson, unknown model
 FCh	08h	00h	  ???		PS/2 Model 25/286
 FCh	09h	00h	  ???		PS/2 Model 25 (10 MHz 286)
 FCh	09h	02h	06/28/89	PS/2 Model 30-286
 FCh	0Bh	00h	02/16/90	PS/1 Model 2011 (10 MHz 286)
 FCh	20h	00h	02/18/93	Compaq ProLinea
 FCh	30h	***	  ???		Epson, unknown model
 FCh	31h	***	  ???		Epson, unknown model
 FCh	33h	***	  ???		Epson, unknown model
 FCh	3Fh	???	09/16991	Toshiba T2200SX/60 (see also #0350)
 FCh	42h	***	  ???		Olivetti M280
 FCh	45h	***	  ???		Olivetti M380 (XP 1, XP3, XP 5)
 FCh	48h	***	  ???		Olivetti M290
 FCh	4Fh	***	  ???		Olivetti M250
 FCh	50h	***	  ???		Olivetti M380 (XP 7)
 FCh	51h	***	  ???		Olivetti PCS286
 FCh	52h	***	  ???		Olivetti M300
 FCh	81h	00h	01/15/88	Phoenix 386 BIOS v1.10 10a
 FCh	81h	01h	  ???		"OEM machine"
 FCh	82h	01h	  ???		"OEM machine"
 FCh	94h	00h	  ???		Zenith 386
 FCh	FFh	???	01/28<91	Toshiba T2000SX/40 (see also #0350)
 FBh	00h	01h	01/10/86	PC XT-089, Enh Keyb, 3.5" support
 FBh	00h	02h	05/09/86	PC XT
 FBh	4Ch	***	  ???		Olivetti M200
 FAh	00h	00h	09/02/86	PS/2 Model 30 (8 MHz 8086)
 FAh	00h	01h	12/12/86	PS/2 Model 30
 FAh	01h	00h	  ???		PS/2 Model 25/25L (8 MHz 8086)
 FAh	30h	00h	  ???		IBM Restaurant Terminal
 FAh	4Eh	***	  ???		Olivetti M111
 FAh	FEh	00h	  ???		IBM PCradio 9075
 F9h	00h	00h	09/13/85	PC Convertible
 F9h	FFh	00h	  ???		PC Convertible
 F8h	00h	00h	03/30/87     ** PS/2 Model 80 (16MHz 386)
 F8h	01h	00h	10/07/87	PS/2 Model 80 (20MHz 386)
 F8h	02h	00h	  ???		PS/2 Model 55-5571
 F8h	04h	00h	  ???		PS/2 Model 70
 F8h	04h	02h	04/11/88	PS/2 Model 70 20MHz, type 2 system brd
 F8h	04h	03h	03/17/89	PS/2 Model 70 20MHz, type 2 system brd
 F8h	05h	00h	  ???		IBM PC 7568
 F8h	06h	00h	  ???		PS/2 Model 55-5571
 F8h	07h	00h	  ???		IBM PC 7561/2
 F8h	07h	01h	  ???		PS/2 Model 55-5551
 F8h	07h	02h	  ???		IBM PC 7561/2
 F8h	07h	03h	  ???		PS/2 Model 55-5551
 F8h	09h	00h	  ???		PS/2 Model 70 16MHz, type 1 system brd
 F8h	09h	02h	04/11/88	PS/2 Model 70 some models
 F8h	09h	03h	03/17/89	PS/2 Model 70 some models
 F8h	0Bh	00h	01/18/89	PS/2 Model P70 (8573-121) typ 2 sys brd
 F8h	0Bh	02h	12/16/89	PS/2 Model P70 ??
 F8h	0Ch	00h	11/02/88	PS/2 Model 55SX (16 MHz 386SX)
 F8h	0Dh	00h	  ???		PS/2 Model 70 25MHz, type 3 system brd
 F8h	0Eh	00h	  ???		PS/1 486SX
 F8h	0Fh	00h	  ???		PS/1 486DX
 F8h	10h	00h	  ???		PS/2 Model 55-5551
 F8h	11h	00h	10/01/90	PS/2 Model 90 XP (25 MHz 486)
 F8h	12h	00h	  ???		PS/2 Model 95 XP
 F8h	13h	00h	10/01/90	PS/2 Model 90 XP (33 MHz 486)
 F8h	14h	00h	10/01/90	PS/2 Model 90-AK9 (25 MHz 486), 95 XP
 F8h	15h	00h	  ???		PS/2 Model 90 XP
 F8h	16h	00h	10/01/90	PS/2 Model 90-AKD (33 MHz 486)
 F8h	17h	00h	  ???		PS/2 Model 90 XP
 F8h	19h	05h	  ???		PS/2 Model 35/35LS or 40 (20 MHz 386SX)
 F8h	1Ah	00h	  ???		PS/2 Model 95 XP
 F8h	1Bh	00h	10/02/89	PS/2 Model 70-486 (25 MHz 486)
 F8h	1Ch	00h	02/08/90	PS/2 Model 65-121 (16 MHz 386SX)
 F8h	1Eh	00h	02/08/90	PS/2 Model 55LS (16 MHz 386SX)
 F8h	23h	00h	  ???		PS/2 Model L40 SX
 F8h	23h	01h	  ???		PS/2 Model L40 SX (20 MHz 386SX)
 F8h	25h	00h	  ???		PS/2 Model 57 SLC
 F8h	25h	06h	  ???		PS/2 Model M57 (20 MHz 386SLC)
 F8h	26h	00h	  ???		PS/2 Model 57 SX
 F8h	26h	01h	  ???		PS/2 Model 57 (20 MHz 386SX)
 F8h	28h	00h	  ???		PS/2 Model 95 XP
 F8h	29h	00h	  ???		PS/2 Model 90 XP
 F8h	2Ah	00h	  ???		PS/2 Model 95 XP (50 MHz 486)
 F8h	2Bh	00h	  ???		PS/2 Model 90 (50 MHz 486)
 F8h	2Ch	00h	  ???		PS/2 Model 95 XP
 F8h	2Ch	01h	  ???		PS/2 Model 95 (20 MHz 486SX)
 F8h	2Dh	00h	  ???		PS/2 Model 90 XP (20 MHz 486SX)
 F8h	2Eh	00h	  ???		PS/2 Model 95 XP
 F8h	2Eh	01h	  ???		PS/2 Model 95 (20 MHz 486SX + 487SX)
 F8h	2Fh	00h	  ???		PS/2 Model 90 XP (20 MHz 486SX + 487SX)
 F8h	30h	00h	  ???		PS/1 Model 2121 (16 MHz 386SX)
 F8h	33h	00h	  ???		PS/2 Model 30-386
 F8h	34h	00h	  ???		PS/2 Model 25-386
 F8h	36h	00h	  ???		PS/2 Model 95 XP
 F8h	37h	00h	  ???		PS/2 Model 90 XP
 F8h	38h	00h	  ???		PS/2 Model 57
 F8h	39h	00h	  ???		PS/2 Model 95 XP
 F8h	3Fh	00h	  ???		PS/2 Model 90 XP
 F8h	40h	00h	  ???		PS/2 Model 95 XP
 F8h	41h	00h	  ???		PS/2 Model 77
 F8h	45h	00h	  ???		PS/2 Model 90 XP (Pentium)
 F8h	46h	00h	  ???		PS/2 Model 95 XP (Pentium)
 F8h	47h	00h	  ???		PS/2 Model 90/95 E (Pentium)
 F8h	48h	00h	  ???		PS/2 Model 85
 F8h	49h	00h	  ???		PS/ValuePoint 325T
 F8h	4Ah	00h	  ???		PS/ValuePoint 425SX
 F8h	4Bh	00h	  ???		PS/ValuePoint 433DX
 F8h	4Eh	00h	  ???		PS/2 Model 295
 F8h	50h	00h	  ???		PS/2 Model P70 (8573) (16 MHz 386)
 F8h	50h	01h	12/16/89	PS/2 Model P70 (8570-031)
 F8h	52h	00h	  ???		PS/2 Model P75 (33 MHz 486)
 F8h	56h	00h	  ???		PS/2 Model CL57 SX
 F8h	57h	00h	  ???		PS/2 Model 90 XP
 F8h	58h	00h	  ???		PS/2 Model 95 XP
 F8h	59h	00h	  ???		PS/2 Model 90 XP
 F8h	5Ah	00h	  ???		PS/2 Model 95 XP
 F8h	5Bh	00h	  ???		PS/2 Model 90 XP
 F8h	5Ch	00h	  ???		PS/2 Model 95 XP
 F8h	5Dh	00h	  ???		PS/2 Model N51 SLC
 F8h	5Eh	00h	  ???		IBM ThinkPad 700
 F8h	61h	***	  ???		Olivetti P500
 F8h	62h	***	  ???		Olivetti P800
 F8h	80h	00h	  ???		PS/2 Model 80 (25 MHz 386)
 F8h	80h	01h	11/21/89	PS/2 Model 80-A21
 F8h	81h	00h	  ???		PS/2 Model 55-5502
 F8h	87h	00h	  ???		PS/2 Model N33SX
 F8h	88h	00h	  ???		PS/2 Model 55-5530T
 F8h	97h	00h	  ???		PS/2 Model 55 Note N23SX
 F8h	99h	00h	  ???		PS/2 Model N51 SX
 F8h	F2h	30h	  ???		Reply Model 32
 F8h	F6h	30h	  ???		Memorex Telex
 F8h	FDh	00h	  ???		IBM Processor Complex (with VPD)
 F8h	???	???	  ???		PS/2 Model 90 (25 MHz 486SX)
 F8h	???	???	  ???		PS/2 Model 95 (25 MHz 486SX)
 F8h	???	???	  ???		PS/2 Model 90 (25 MHz 486SX + 487SX)
 F8h	???	???	  ???		PS/2 Model 95 (25 MHz 486SX + 487SX)
 E1h	???	???	  ???		??? (checked for by DOS4GW.EXE)
 E1h	00h	00h	  ???		PS/2 Model 55-5530 Laptop
 9Ah	*	*	  ???		Compaq XT/Compaq Plus
 30h	???	???	  ???		Sperry PC
 2Dh	*	*	  ???		Compaq PC/Compaq Deskpro
 ???	56h	???	  ???		Olivetti, unknown model
 ???	74h	???	  ???		Olivetti, unknown model
    * This BIOS call is not implemented in these early versions.
      Read Model byte at F000h:FFFEh and BIOS date at F000h:FFF5h.
   ** These BIOS versions require the DASDDRVR.SYS patches.
  *** These Olivetti and Epson machines store the submodel in the byte at
	F000h:FFFDh.

(Table 0346)
Values for Dell model byte:
 02h	Dell 200
 03h	Dell 300
 05h	Dell 220
 06h	Dell 310
 07h	Dell 325
 09h	Dell 310A
 0Ah	Dell 316
 0Bh	Dell 220E
 0Ch	Dell 210
 0Dh	Dell 316SX
 0Eh	Dell 316LT
 0Fh	Dell 320LX
 11h	Dell 425E

Format of Compaq product information:
Address		Size	Description	(Table 0347)
 F000h:FFE4h	BYTE	product family code (first byte)
 F000h:FFE4h	BYTE	Point release number
 F000h:FFE4h	BYTE	ROM version code
 F000h:FFE4h	BYTE	product family code (second byte)
 F000h:FFE8h	WORD	BIOS type code

Bitfields for Hewlett-Packard product identifier:
Bit(s)	Description	(Table 0348)
 4-0	machine code
	0 original Vectra
	1 ES/12
	2 RS/20
	3 Portable/CS
	4 ES
	5 CS
	6 RS/16
	other reserved
 7-5	CPU type
	0 = 80286
	1 = 8088
	2 = 8086
	3 = 80386
	other reserved

Format of Toshiba laptop information:
Offset	Size	Description	(Table 0349)
 00h  8 BYTEs	ASCII product number (e.g. "T2200SX ")
 08h  8 BYTEs	ASCII version number (e.g. "V1.20   ")
 10h  8 BYTEs	ASCII signature string "TOSHIBA "
 18h  8 BYTEs	???
 20h	DWORD	-> built-in BIOS setup program entry point or 0000h:0000h
Note:	this record is located at F000h:E000h

(Table 0350)
Values for Toshiba product ID:
model prodID   version	  date	   product number    /hdd
 FEh	29h		../..)..   Toshiba T1000LE
 FEh	2Ah		../..*..   Toshiba T1000XE
 FEh	2Bh		../..+..   Toshiba T1000SE
 FEh	2Ch		../..,..   Toshiba T1000      -
 FEh	2Dh		../..-..   Toshiba T1200F     -
 FEh	2Dh	V4.00	12/26-87   Toshiba T1200H    /20
 FEh	2Eh		../.....   Toshiba T1100+
 FCh	22h		../.."..   Toshiba T8500
 FCh	26h		01/15&88   Toshiba T5200     /100
 FCh	27h		../..'..   Toshiba T5100
 FCh	28h		../..(..   Toshiba T2000
 FCh	2Ah		12/26*89   Toshiba T1200XE
 FCh	2Bh		../..+..   Toshiba T1600
 FCh	2Ch		../..,..   Toshiba T3100e
 FCh	2Dh		../..-..   Toshiba T3200
 FCh	2Fh		../../..   Toshiba T3100
 FCh	34h		../..4..   Toshiba T100X
 FCh	???		../.. ..   Toshiba T200
 FCh	???		../.. ..   Toshiba T200CS
 FCh	38h		../..8..   Toshiba T2000SXe
 FCh	39h	V1.20	09/16991   Toshiba T2200SX   /60
 FCh	39h	V1.40	10/01992   Toshiba T2200SX   /120 (upgraded)
 FCh	3Ch	V1.50	01/28<91   Toshiba T2000SX   /40
 FCh	3Dh		../..=..   Toshiba T3200SXC
 FCh	3Eh		../..>..   Toshiba T3100SX
 FCh	3Fh		../..?..   Toshiba T3200SX
 FCh	40h		../..@..   Toshiba T4500C
 FCh	41h		04/05A92   Toshiba T4500     ("T4500SXC" ?)
 FCh	45h	V3.20	04/14E92   Toshiba T4400SX   ("C" or "SXC" on cover)
 FCh	45h		01/13E93   Toshiba T4400SXC
 FCh	46h *		../..F..   Toshiba T6400
 FCh	46h *		../..F..   Toshiba T6400C
 FCh	5Fh		../.._..   Toshiba T3300SL
 FCh	69h		../..i..   Toshiba T1900C
 FCh	6Ah		../..j..   Toshiba T1900
 FCh	6Dh		../..m..   Toshiba T1850C
 FCh	6Eh		12/25n92   Toshiba T1850
 FCh	6Fh		07/17o92   Toshiba T1800
 FCh	7Eh	V1.30	06/17~93   Toshiba T4600C
 FCh	7Fh		../..x..   Toshiba T4600
 FCh	97h		../..x..   Toshiba T4800CT
 FCh	98h *	V1.10	12/22x93   Toshiba T1910     /120 /320
 FCh	98h *		../..x..   Toshiba T1910CS
 FCh	99h		../..x..   Toshiba T4700CS
 FCh	9Bh	V2.30	01/31x94   Toshiba T4700CT
 FCh	9Bh	V2.50	03/22x94   Toshiba T4700CT   /320
 FCh	9Ch	V1.30	01/11x94   Toshiba T1950CT   /320
 FCh	9Dh *		../..x..   Toshiba T1950
 FCh	9Dh *		../..x..   Toshiba T1950CS
 FCh	9Eh *	V1.20	12/25x93   Toshiba T3400     /120
 FCh	9Eh *			   Toshiba T3400CT
Note:	BIOS version numbers and dates may vary, esp. due to harddisk upgrades
	[*] These models have monochrome and color versions which can only be
	  distinguished with INT 42/AX=7503h
--------B-15C1-------------------------------
INT 15 - SYSTEM - RETURN EXTENDED-BIOS DATA-AREA SEGMENT ADDRESS (PS)
	AH = C1h
Return: CF set on error
	CF clear if successful
	    ES = segment of data area
SeeAlso: AH=04h"ABIOS"
--------M-15C200-----------------------------
INT 15 - SYSTEM - POINTING DEVICE BIOS INTERFACE (PS) - ENABLE/DISABLE
	AX = C200h
	BH = new state
	    00h disabled
	    01h enabled
Return: CF set on error
	AH = status (see #0351)

(Table 0351)
Values for pointing device function status:
 00h	successful
 01h	invalid function
 02h	invalid input
 03h	interface error
 04h	need to resend
 05h	no device handler installed
--------M-15C201-----------------------------
INT 15 - SYSTEM - POINTING DEVICE BIOS INTERFACE (PS) - RESET
	AX = C201h
Return: CF set on error
	    AH = status (see #0351)
	CF clear if successful
	    BH = device ID
	    BL = value returned by attached device after reset
		AAh if device is a mouse
Note:	after successful completion of this call, the pointing device is set
	  as follows: disabled, sample rate 100 Hz, resolution 4 counts/mm,
	  scaling 1:1, unchanged data package size
SeeAlso: INT 33/AX=0000h
--------M-15C202-----------------------------
INT 15 - SYSTEM - POINTING DEVICE BIOS INTERFACE (PS) - SET SAMPLING RATE
	AX = C202h
	BH = sampling rate
	    00h 10/second
	    01h 20/second
	    02h 40/second
	    03h 60/second
	    04h 80/second
	    05h 100/second
	    06h 200/second
Return: CF set on error
	    AH = status (see #0351)
SeeAlso: INT 33/AX=001Ch
--------M-15C203-----------------------------
INT 15 - SYSTEM - POINTING DEVICE BIOS INTERFACE (PS) - SET RESOLUTION
	AX = C203h
	BH = resolution (see #0352)
Return: CF set on error
	    AH = status (see #0351)

(Table 0352)
Values for pointing device resolution:
 00h	one count per mm
 01h	two counts per mm
 02h	four counts per mm
 03h	eight counts per mm
--------M-15C204-----------------------------
INT 15 - SYSTEM - POINTING DEVICE BIOS INTERFACE (PS) - GET TYPE
	AX = C204h
Return: CF set on error
	    AH = status (see #0351)
	CF clear if successful
	    BH = device ID
--------M-15C205-----------------------------
INT 15 - SYSTEM - POINTING DEVICE BIOS INTERFACE (PS) - INITIALIZE
	AX = C205h
	BH = data package size (1 - 8 bytes)
Return: CF set on error
	    AH = status (see #0351)
Note:	the pointing device is set as follows: disabled, 100 Hz sample rate,
	  resolution 4 counts/mm, scaling 1:1
SeeAlso: AX=C201h
--------M-15C206-----------------------------
INT 15 - SYSTEM - POINTING DEVICE BIOS INTERFACE (PS) - EXTENDED COMMANDS
	AX = C206h
	BH = subfunction
	    00h return device status
		Return: BL = pointing device status (see #0353)
			CL = resolution (see #0352)
			DL = sample rate, reports per second
	    01h set scaling at 1:1
	    02h set scaling at 2:1
Return: CF set on error
	    AH = status (see #0351)

Bitfields for pointing device status:
Bit(s)	Description	(Table 0353)
 0	right button pressed
 1	reserved
 2	left button pressed
 3	reserved
 4	0 if 1:1 scaling, 1 if 2:1 scaling
 5	device enabled
 6	0 if stream mode, 1 if remote mode
 7	reserved
--------M-15C207-----------------------------
INT 15 - SYSTEM - POINTING DEVICE BIOS INTERFACE (PS) - SET DEVICE HANDLER ADDR
	AX = C207h
	ES:BX -> FAR user device handler
Return: CF set on error
	    AH = status (see #0351)
Note:	when the subroutine is called, it is passed the following values on
	  the stack; the handler should return with a FAR return without
	  popping the stack:
		WORD 1: status (see #0354)
		WORD 2: X data (high byte = 00h)
		WORD 3: Y data (high byte = 00h)
		WORD 4: 0000h
SeeAlso: INT 33/AX=000Ch

Bitfields for pointing device status:
Bit(s)	Description	(Table 0354)
 15-8	reserved (0)
 7	Y data overflowed
 6	X data overflowed
 5	Y data is negative
 4	X data is negative
 3	reserved (1)
 2	reserved (0)
 1	right button pressed
 0	left button pressed
--------B-15C3------------------------------
INT 15 - SYSTEM - ENABLE/DISABLE WATCHDOG TIMEOUT (PS50+)
	AH = C3h
	AL = function
	    00h disable PS/2 watchdog timer
	    01h enable PS/2 watchdog timer
		BX = timer counter (0001h-00FFh)
	    02h disable Gearbox system
	    03h enable Gearbox system
Return: CF set on error
	CF clear if successful
Note:	the watchdog timer generates an NMI
SeeAlso: INT 21/AH=2Bh/CX=6269h/DX=742Dh
--------B-15C4-------------------------------
INT 15 - SYSTEM - PROGRAMMABLE OPTION SELECT (PS50+)
	AH = C4h
	AL = subfunction
	    00h return base POS register address
	    01h enable selected slot for setup
		BL = slot number (1 to 8)
	    02h disable setup for all slots (enable adapter)
Return: CF set on error
	DX = base POS register address (if subfunction 00h)
SeeAlso: AH=C6h
--------B-15C5-------------------------------
INT 15 UC - OS HOOK - ROM BIOS TRACING CALLOUT (PS30/286,PS50Z,PS95)
	AH = C5h
	AL = interrupt being invoked
	    01h INT 19
	    02h INT 14
	    03h INT 16
	    04h INT 40 (floppy INT 13)
	    05h INT 17
	    06h INT 10
	    07h INT 12
	    08h INT 11
	    09h INT 1A
Return: all registers except AX must be preserved
Notes:	called as the very first action of the indicated ROM BIOS interrupt
	  handlers on the PS/2 Models 30/286, 50Z, and 95
	default handler does nothing and returns CF clear for the above
	  subfunctions, CF set and AH=86h for all other subfunctions
	value of AX passed to the original interrupt handler is pushed on
	  stack immediately prior to call
--------B-15C6-------------------------------
INT 15 U - later PS/2 models - GET POS DATA
	AH = C6h
	???
Return: ???
Notes:	this function is referenced by name and number in some IBM BIOS manuals
	IBM reports that "there are a number of problems with this call" and
	  does not recommend its use.
SeeAlso: AH=C4h
--------B-15C7-------------------------------
INT 15 - SYSTEM - later PS/2s - RETURN MEMORY-MAP INFORMATION
	AH = C7h
	DS:SI -> user supplied memory map table (see #0355)
Note:	call AH=C0h and examine bit 4 of feature byte 2 to check if this
	  function is supported
Return: CF set on error, clear if successful
SeeAlso: AH=C0h,AH=C9h,AH=D1h

Format of memory-map table structure:
Offset	Size	Description	(Table 0355)
 00h	WORD	length of table (excluding this word)
 02h	DWORD	local memory between 1M and 16M, in 1K blocks
 06h	DWORD	local memory between 16M and 4G, in 1K blocks
 0Ah	DWORD	system memory between 1M and 16M, in 1K blocks
 0Eh	DWORD	system memory between 16M and 4G, in 1K blocks
 12h	DWORD	cacheable memory between 1M and 16M, in 1K blocks
 16h	DWORD	cacheable memory between 16M and 4G, in 1K blocks
 1Ah	DWORD	1K blocks before start of non-system memory between 1M and 16M
 1Eh	DWORD	1K blocks before start of non-system memory between 16M and 4G
 22h  2 DWORDs	reserved
--------B-15C8-------------------------------
INT 15 - SYSTEM - ENABLE/DISABLE PROCESSOR FUNCTIONS
	AH = C8h
	AL = function
	    00h disable cache or (90 and 95) disable cache L1
	    01h enable cache or (90 and 95) enable cache L1
	    ---models 90 and 95 only---
	    02h disable cache L2
	    03h enable cache L2
	    04h disable both caches
	    05h enable both caches
	    06h return status of both caches
	    07h-FFh Reserved
Return: CF set on error
	CF clear if successful
	    AH = status (see #0356)
	For subfunction 06h only:
	    BH = status of cache L2
		00h enabled
		01h disabled or not installed
	    BL = status of cache L1 (same codes as BH)
Notes:	 supported by at least PS/2 70, 70/486, 80-A21, 90, 95
	call AH=C0h and examine bit 3 of feature byte 2 to check if this
	  function is supported.
	on a 486 system, any external caches must be disabled when the
	  on-chip cache (L1) is disabled.
SeeAlso: AH=C0h

(Table 0356)
Values for status:
 00h	operation successful
 01h	function choice (in AL) is invalid
 02h	NVRAM data is invalid
 03h	cache test error
 04h	(90 and 95 only) cannot perform operation requested due to state of
	  other cache (see note above)
 05h	no L2 cache is present
 09h	CPU in protected mode
--------B-15C9-------------------------------
INT 15 - newer PS/2; various BIOSes - GET CPU TYPE AND MASK REVISION
	AH = C9h
	AL = 10h (may be required on some non-PS BIOSes)
Return: CF clear if successful
	    AH = 00h
	    CH = CPU type (see #0357)
	    CL = mask revision (stepping level) (see #0358)
	CF set on error
	    AH = status (80h,86h = function not supported)
Notes:	the BIOS must save DX at startup in order to be able to support this
	  call; PS/2 Models 56, 57, 90, and 95 are known to support it
	the PS/2 BIOS merely reads CMOS locations 190h (type) and 191h (rev)

(Table 0357)
Values for CPU type:
 03h	80386DX or clone
 04h	80486
 23h	80386SX or clone
 43h	80386SL or clone
 A3h	IBM 386SLC
 A4h	IBM 486SLC

(Table 0358)
Values for stepping level:
---80386---
 03h	B1
 05h	D0
 08h	D1/D2/E1
---80386SX---
 04h	A0
 05h	B
 08h	C/D1
---80486---
 00h	A0/A1
 01h	B2
 03h	B3
 04h	B4
 05h	B5
 06h	B6
 07h	C1
 10h	cAx
 11h	cBx
 33h	DX2/66
---486SX---
 20h	A0
Note:	the steppings for 486 are alternately reported to be 01h=Bx, 02h=C0,
	  04h=D0
--------B-15CA-------------------------------
INT 15 U - PS/2 Model 95 - READ/WRITE CMOS MEMORY
	AH = CAh
	AL = function
	    00h read CMOS
		Return: CL = value of CMOS location
	    01h write CMOS
		CL = new value for CMOS location
	BL = CMOS location (0Eh-3Fh)
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = error code (see #0359)
Note:	writes do not update the CMOS checksum

(Table 0359)
Values for CMOS read/write error code:
 01h	CMOS lost power or has invalid checksum
 03h	specified location out of range (too high)
 04h	specified location out of range (too low)
 80h	unsupported function (PC)
 86h	unsupported function (XT)
--------B-15CB-------------------------------
INT 15 U - PS/2 Model 95 - RESERVED
	AH = CBh
	???
Return: ???
--------B-15CC-------------------------------
INT 15 U - PS/2 Model 95 - RESERVED
	AH = CCh
	???
Return: ???
--------V-15CCCC-----------------------------
INT 15 U - Toshiba laptops - VCHAD.EXE - INSTALLATION CHECK
	AX = CCCCh
Return: AX = ABCDh if installed
Note:	supported by Toshiba VGA change display utility VCHAD.EXE ver 2.90+
	  older versions have the string "VCHAD" 2 bytes after the address of
	  the INT 15 handler which is hooked by all versions for the SysReq key
SeeAlso: AH=85h
--------B-15CD-------------------------------
INT 15 U - PS/2 Model 95 - RESERVED
	AH = CDh
	???
Return: ???
--------B-15CE--BL00-------------------------
INT 15 - later PS/2s - ALLOCATE DMA ARBITRATION LEVEL
	AH = CEh
	BL = 00h-0Eh arbitration level to be allocated
	     0Fh-FFh reserved
	AL = option byte
	    bit 7-1: reserved (0)
	    bit 0: 0 = need DMA channel for arbitration level requested
		   1 = no channel required for arbitration level
Return: CF set on error
	    AH = status (80h,86h = function not supported)
	CF clear on success
	    AL = channel number
		00h-07h channel number allocated for the arbiration level
		08h-FEh reserved
		FFh	no channel requested for arbitration level
	    AH = status (see #0360)
Notes:	 arbitration level 00h has the highest priority, 0Eh the lowest
	 to perform a DMA transfer operation, be sure to call this function
	   first, and call AH=CFh afterward.  Failure to use this function
	   can cause unpredictable results.
SeeAlso: AH=CFh

(Table 0360)
Values for DMA arbitration status:
 00h	success
 01h	arbitration level not available
 02h	channel not available
 03h	invalid arbitration level passed
--------B-15CF-------------------------------
INT 15 - later PS/2s - DEALLOCATE DMA ARBITRATION LEVEL
	AH = CFh
	BL = arbitration level to be deallocated (see AH=CEh)
Return: CF set on error
	    AH = status (80h,86h = function not supported)
	CF clear on success
	    AH = status
		00h success
		04h arbitration level not allocated
SeeAlso: AH=CEh
--------B-15D0-------------------------------
INT 15 - later PS/2s - RESERVED
	AH = D0h
	???
Return: ???
--------B-15D100DX0000-----------------------
INT 15 - later PS/2s - GET NUMBER OF DEVICE DESCRIPTOR TABLE (DDT) ENTRIES
	AX = D100h
	DX = 0000h (reserved, must set to 0)
Return: BL = size of one DDT entry, in bytes
	CX = number of DDT entries
	AH = return code (see #0361)
	CF set on error
	CF clear on success
SeeAlso: AH=C0h,AH=C7h,AH=C9h,AX=D101h,AX=D102h,AX=D103h,AX=D104h

(Table 0361)
Values for return code:
 00h	success
 01h	requested DDT entry not found
 02h	DDT data not valid
 86h	function not supported
--------B-15D101-----------------------------
INT 15 - later PS/2s - RETURN DEVICE DESCRIPTOR TABLE (DDT) ENTRY BY NUMBER
	AX = D101h
	BX = number of requested entry (starting with 1)
	DX = 0000h (reserved, must be set to 0)
	ES:DI -> buffer to contain DDT entry (see #0362)
Return:	AH = return code (see #0361)
	CF set on error
	CF clear on success
	    ES:DI buffer filled with DDT entry
SeeAlso: AH=C0h,AH=C7h,AH=C9h,AX=D100h,AX=D102h,AX=D104h

Format of Device Descriptor Table (DDT):
Offset	Size	Description	(Table 0362)
 00h	BYTE	bits 7-4: reserved (set to 0)
		bits 3-0: slot of device (0 = system board)
 01h	BYTE	bits 7-4: second interrupt for this device (0 = none)
		bits 3-0: first interrupt for this device (0 = none)
 02h	BYTE	bits 7-4: second arbitration level for this device
		bits 3-0: first arbitration level for this device
 03h	WORD	DDT indicators (see #0363)
 05h	BYTE	reserved (0)
 06h	WORD	device ID (0 = none)
 08h	WORD	starting address of first  I/O block (0 = none)
 0Ah	WORD	starting address of second I/O block (0 = none)
 OCh	WORD	starting address of third  I/O block (0 = none)
 OEh	DWORD	start of first non-system memory block (0 = none)
 12h	WORD	size of first non-system memory block (in kilobytes)
 14h	DWORD	start of second non-system memory block (0 = none)
 18h	WORD	size of second non-system memory block (in kilobytes)
 1Ah	BYTE	implementation identifier of the device
 1Bh	BYTE	implementation revision level of the device
Note:	I/O block addresses and non-system memory addresses are listed in
	  ascending order in each DDT entry.

Bitfields for DDT indicators:
Bit(s)	Description	(Table 0363)
 15	reserved (0)
 14	second arbitration level exists
 13	first arbitration level exists
 12	serial interface is RS-422
 11	not address limited
 10	DMA channel used
 9	second arbitration level can be shared
 8	first arbitration level can be shared
 7-0	reserved (0)
--------B-15D102-----------------------------
INT 15 - later PS/2s - RETURN DEVICE DESCRIPTOR TABLE (DDT) ENTRY BY I/O ADDRSS
	AX = D102h
	BX = entry number at which to start searching
	CX = requested I/O port address
	DX = 0000h (reserved, must be set to 0)
	ES:DI -> buffer to contain DDT entry (see #0362)
Return:	AH = return code (see #0361)
	BX = DDT entry number where I/O port was found, or total entries
	     plus 1 if port was not found.
	CF set on error
	CF clear on success
	    ES:DI buffer filled with DDT entry
Desc:	the DDT is searched from the specified entry for the I/O port in CX,
	  and the first entry in which it is found is returned
SeeAlso: AH=C0h,AH=C7h,AH=C9h,AX=D100h,AX=D101h,AX=D103h,AX=D104h
--------B-15D103DX0000-----------------------
INT 15 - later PS/2s - RETURN ENTIRE DDT
	AX = D103h
	DX = 0000h (reserved, must be set to 0)
	ES:DI -> buffer to contain DDT entry (see #0362)
Return:	AH = return code (see #0361)
	CF set on error
	CF clear on success
	    ES:DI buffer filled with DDT entry
SeeAlso: AH=C0h,AH=C7h,AH=C9h,AX=D100h,AX=D104h
--------B-15D104-----------------------------
INT 15 - later PS/2s - RETURN DEVICE DESCRIPTOR TABLE (DDT) ENTRY BY DEVICE ID
	AX = D104h
	BX = entry number at which to start searching
	CX = requested device ID
	DX = 0000h (reserved, must be set to 0)
	ES:DI -> buffer to contain DDT entry (see #0362)
Return:	AH = return code (see #0361)
	BX = DDT entry number where device ID was found, or total entries
	      plus 1 if port was not found.
	CF set on error
	CF clear on success
	    ES:DI buffer filled with DDT entry
Desc:	the DDT is searched from the specified entry for the device ID in CX,
	  and the first entry in which it is found is returned.
SeeAlso: AH=C0h,AH=C7h,AH=C9h,AX=D100h,AX=D101h,AX=D103h
--------B-15D2-------------------------------
INT 15 - later PS/2s - RESERVED
	AH = D2h
	???
Return: ???
--------B-15D3-------------------------------
INT 15 - later PS/2s - RESERVED
	AH = D3h
	???
Return: ???
--------B-15D4-------------------------------
INT 15 - later PS/2s - GET PHYSICAL FIXED DISK DRIVE NUMBER (SELECTABLE BOOT)
	AH = D4h
	DL = logical fixed disk drive number
Return:	AH = return code (see #0364)
	CF set on error
	CF clear on success
	    AL = physical fixed disk drive number

(Table 0364)
Values for return code:
 00h	success
 01h	specified logical drive number is invalid
 80h	function not supported (on PCjr and PC)
 86h	function not supported
--------B-15D5-------------------------------
INT 15 - later PS/2s - RESERVED
	AH = D5h
	???
Return: ???
--------B-15D600BL00-------------------------
INT 15 - later PS/2s - READ BOOT DEVICE ID
	AX = D600h
	BL = 00h
	DX = device ID
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = status (86h for function not supported)
SeeAlso: AX=D600h/BL=01h,AX=D601h/BL=00h,AX=D602h
--------B-15D600BL01-------------------------
INT 15 - later PS/2s - WRITE BOOT DEVICE ID
	AX = D600h
	BL = 01h
	DX = device ID
Return: CF clear on success
	    AH = 00h
	CF set on error
	    AH = status (86h for function not supported)
SeeAlso: AX=D600h/BL=00h,AX=D601h/BL=01h
--------B-15D601BL00-------------------------
INT 15 - later PS/2s - READ BOOT DEVICE KEY
	AX = D601h
	BL = 00h
	DX = device ID
Return: CF clear on success
	    AH = 00h
	CF set on error
	    AH = status (86h for function not supported)
SeeAlso: AX=D600h/BL=00h,AX=D601h/BL=01h,AX=D602h
--------B-15D601BL01-------------------------
INT 15 - later PS/2s - WRITE BOOT DEVICE KEY
	AX = D601h
	BL = 01h
	DX = device ID
Return: CF clear on success
	    AH = 00h
	CF set on error
	    AH = status (86h for function not supported)
SeeAlso: AX=D600h/BL=01h,AX=D601h/BL=00h
--------B-15D602-----------------------------
INT 15 - later PS/2s - QUERY BOOT REFERENCE PARTITION
	AX = D602h
Return: CF clear on success
	    AH = 00h
	    AL = status of reference-partition boot request
		00h boot not requested
		01h boot requested
	CF set on error
	    AH = status (86h for function not supported)
SeeAlso: AX=D601h/BL=00h
--------X-15D800-----------------------------
INT 15 - EISA SYSTEM ROM - READ SLOT CONFIGURATION INFORMATION
	AX = D800h
	CL = slot number (including embedded and virtual)
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = error code (80h,82h,83h,86h,87h)(see #0366)
	AL = bit flags (see #0365)
	BH = major revision level of configuration utility
	BL = minor revision level of configuration utility
	CX = checksum of configuration file
	DH = number of device functions
	DL = combined function information byte
	SI:DI = 4-byte compressed ID (DI = bytes 0&1, SI = bytes 2&3)
Note:	call with AL=80h if using 32-bit CS addressing mode instead of 16-bit
SeeAlso: AX=D801h,AX=D804h

Bitfields for EISA AL bit flags:
Bit(s)	Description	(Table 0365)
 7	set if duplicate IDs
 6	set if product ID readable
 4,5	slot type (00=expansion, 01=embedded, 10=virtual device)
 0-3	duplicate ID number if bit 7 set

(Table 0366)
Values for EISA error code:
 80h	invalid slot number
 81h	invalid function number
 82h	EISA CMOS corrupt
 83h	empty slot
 84h	error clearing CMOS
 85h	EISA CMOS is full
 86h	invalid BIOS-FW function call
 87h	invalid system configuration
 88h	config utility version not supported
--------X-15D801-----------------------------
INT 15 - EISA SYSTEM ROM - READ FUNCTION CONFIGURATION INFORMATION
	AX = D801h
	CH = function number to read
	CL = slot number (including embedded and virtual)
	DS:SI -> 320-byte buffer for standard configuration data block
Return: CF clear if successful
	    AH = 00h
	    DS:SI buffer filled
	CF set on error
	    AH = error code (80h-83h,86h,87h) (see #0366)
	BX destroyed
Note:	call with AL=81h if using 32-bit CS addressing mode instead of 16-bit
--------X-15D802-----------------------------
INT 15 - EISA SYSTEM ROM - CLEAR NONVOLATILE MEMORY (EISA CMOS)
	AX = D802h
	BH = EISA config utility major revision level
	BL = EISA config utility minor revision level
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = error code (84h,86h,88h) (see #0366)
Note:	call with AL=82h if using 32-bit CS addressing mode instead of 16-bit
SeeAlso: AX=D803h
--------X-15D803-----------------------------
INT 15 - EISA SYSTEM ROM - WRITE NONVOLATILE MEMORY
	AX = D803h
	CX = length of data structure (0000h = empty slot)
		includes two bytes for config file checksum
	DS:SI -> configuration data
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = error code (84h-86h) (see #0366)
Note:	call with AL=83h if using 32-bit CS addressing mode instead of 16-bit
SeeAlso: AX=D802h
--------X-15D804-----------------------------
INT 15 - EISA SYSTEM ROM - READ PHYSICAL SLOT
	AX = D804h
	CL = slot number (including embedded and virtual)
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = error code (80h,83h,86h) (see #0366)
	SI:DI = 4-byte compressed ID (DI = bytes 0&1, SI = bytes 2&3)
Note:	call with AL=84h if using 32-bit CS addressing mode instead of 16-bit
SeeAlso: AX=D800h
--------b-15D820-----------------------------
INT 15 - Compaq LTE Lite - GET ???
	AX = D820h
	DS:SI -> 17-byte buffer for ???
Return: DS:SI buffer filled (first byte is length of remaining data, unless
	  it is greater than 10h, in which case the second byte is 00h and no
	  other data is returned)
Note:	this function is also supported by Compaq's EISA System ROM, Contura
	  486/486c/486cx and recent DESKPRO/i ROMs
SeeAlso: AX=D821h
--------b-15D821-----------------------------
INT 15 - Compaq LTE Lite - SET ???
	AX = D821h
	DS:SI -> counted string (should not be more than 16 bytes)
Return: AH = 00h
Note:	this function is also supported by Compaq's EISA System ROM, Contura
	  486/486c/486cx and recent DESKPRO/i ROMs
SeeAlso: AX=D820h
--------b-15D822BL00-------------------------
INT 15 - Compaq EISA System ROM 04/08/93 - GET ???
	AX = D822h
	BL = 00h
	CX = size of buffer or 0000h to retrieve required buffer size
	DS:SI -> buffer for ??? (if CX nonzero)
Return: CF clear if successful
	    AH = 00h
	    DH = 08h
	    CX = required buffer size to retrieve all data (if CX=0 on entry)
	    DS:SI buffer filled (if CX nonzero on entry)
	CF set on error (BL nonzero)
	    AH = 86h
--------b-15D823-----------------------------
INT 15 - Compaq EISA System ROM 04/08/93 - ???
	AX = D823h
	BL = subfunction??? (00h or 80h)
	BH = ???
	DS:SI -> buffer for ??? (see #0367)
Return: CF clear if successful
	    AH = 00h
	    DH = 08h
	    DL = ???
	CF set on error
	    AH = error code
		86h BL neither 00h nor 80h
		87h ???

Format of Compaq EISA buffer:
Offset	Size	Description	(Table 0367)
 00h	BYTE	???
 01h	WORD	???
 03h	BYTE	???
 04h	WORD	???
 06h	WORD	???
	???
----------15D824-----------------------------
INT 15 - Compaq EISA System ROM 04/08/93 - ???
	AX = D824h
	CX = ???
	DS:SI -> ASCIZ string containing ???
Return: CF clear if successful
	    AH = 00h
	    CX = ???
	CF set on error
	    AH = error code
		87h ??? failed
		88h ???
Note:	these functions are only available if ??? from keyboard controller
	  command C0h
----------15D825-----------------------------
INT 15 - Compaq EISA System ROM 04/08/93 - ???
	AX = D825h
	CX = ???
	SI = ???
	DI = ???
	???
Return: CF clear if successful
	    AH = 00h
	    CX = ???
	CF set on error
	    AH = error code
		87h ??? failed
		88h ???
		    CX = ???
Note:	these functions are only available if ??? from keyboard controller
	  command C0h
----------15D826-----------------------------
INT 15 - Compaq EISA System ROM 04/08/93 - ???
	AX = D826h
	BX = ???
	CX = size of buffer in bytes
	DS:SI -> buffer for ???
	???
Return: CF clear if successful
	    AH = 00h
	    CX = ???
	CF set on error
	    AH = error code
		87h ??? failed
		88h ???
Note:	these functions are only available if ??? from keyboard controller
	  command C0h
--------X-15D8-------------------------------
INT 15 - EISA SYSTEM ROM - 32-bit CS ADDRESSING MODE CALLS
	AH = D8h
	AL = 80h to 84h
	other registers as appropriate for AL=00h to 04h
Return: as appropriate for AL=00h to 04h
Note:	these functions are identical to AX=D800h to D804h, except that they
	  should be called when using 32-bit CS addressing mode (pointers use
	  ESI rather than SI as offset) instead of 16-bit addressing mode
SeeAlso: AX=D800h,AX=D801h,AX=D802h,AX=D803h,AX=D804h
--------b-15D8-------------------------------
INT 15 - Compaq EISA System ROM 04/08/93 - 32-bit CS ADDRESSING MODE CALLS
	AH = D8h
	AL = A0h to A6h
	other registers as appropriate for AL=20h to 26h
Return: as appropriate for AL=20h to 26h
Note:	these functions are identical to AX=D820h to D826h, except that they
	  should be called when using 32-bit CS addressing mode
----------15DA-------------------------------
INT 15 U - AMI PCI BIOS v1.00.05.AX1 - ???
	AH = DAh
	AL = function (00h-08h,12h,14h,15h,19h,88h-8Eh,92h,99h)
	???
Return: ???
SeeAlso: AH=DBh
----------15DA-------------------------------
INT 15 U - AMI PCI BIOS v1.00.05.AX1 - ???
	AH = DBh
	AL = function (00h-04h)
	???
Return: ???
SeeAlso: AH=DAh
--------Q-15DE00-----------------------------
INT 15 - DESQview - GET PROGRAM NAME
	AX = DE00h
Return: AX = offset into DESQVIEW.DVO of program most recently selected from
		the "Switch Windows" menu (see #0368)
Note:	always returns AX=0000h under DESQview/X
SeeAlso: AX=DE07h

Format of program entry in DESQVIEW.DVO:
Offset	Size	Description	(Table 0368)
 00h	BYTE	length of name (FFh if end of file)
 01h  N BYTEs	name
      2 BYTEs	keys to invoke program (second = 00h if only one key used)
	BYTE	program type
		00h normal program
		04h divider
		80h Delete a Program
		81h Change a Program
	WORD	??? apparently always 0000h
--------Q-15DE01-----------------------------
INT 15 - DESQview - UPDATE "OPEN WINDOW" MENU
	AX = DE01h
Return: nothing
Notes:	reads DESQVIEW.DVO, disables Open menu if file not in current directory
	NOP for DESQview/X
--------Q-15DE02-----------------------------
INT 15 - DESQview 1.x only - SET ??? FLAG FOR CURRENT WINDOW
	AX = DE02h
Return: nothing
Note:	this call is a NOP in DV 2.x
SeeAlso: AX=DE03h
--------Q-15DE03-----------------------------
INT 15 - DESQview 1.x only - GET ??? FOR CURRENT WINDOW
	AX = DE03h
Return: AX = ??? for current window
	BX = ??? for current window
Note:	this call is a NOP in DV 2.x
SeeAlso: AX=DE02h
--------Q-15DE04-----------------------------
INT 15 - DESQview - GET AVAILABLE COMMON MEMORY
	AX = DE04h
Return: BX = bytes of common memory available
	CX = largest block available
	DX = total common memory in bytes
SeeAlso: AX=DE05h,AX=DE06h
--------Q-15DE05-----------------------------
INT 15 - DESQview - GET AVAILABLE CONVENTIONAL MEMORY
	AX = DE05h
Return: BX = KB of memory available
	CX = largest block available
	DX = total conventional memory in KB
SeeAlso: AX=DE04h,AX=DE06h
--------Q-15DE06-----------------------------
INT 15 - DESQview - GET AVAILABLE EXPANDED MEMORY
	AX = DE06h
Return: BX = KB of expanded memory available
	CX = largest block available
	DX = total expanded memory in KB
SeeAlso: AX=DE04h,AX=DE05h
--------Q-15DE07-----------------------------
INT 15 - DESQview - "APPNUM" - GET CURRENT PROGRAM'S NUMBER
	AX = DE07h
Return: AX = number of program as it appears on the "Switch Windows" menu
Note:	this API call may be made from a hardware interrupt handler
SeeAlso: AX=DE00h
--------Q-15DE08-----------------------------
INT 15 - DESQview - GET ???
	AX = DE08h
Return: AX = 0000h if ??? is not set to the current task
	     0001h if ??? is set to the current task
--------Q-15DE09-----------------------------
INT 15 - DESQview - UNIMPLEMENTED
	AX = DE09h
Return: nothing (NOP in DV 1.x and 2.x)
--------Q-15DE0A-----------------------------
INT 15 - DESQview v2.00+ - "DBGPOKE" - DISPLAY CHARACTER ON STATUS LINE
	AX = DE0Ah
	BL = character
Return: character displayed, next call will display in next position (which
	wraps back to the start of the line if off the right edge of screen)
Notes:	displays character on bottom line of *physical* screen, regardless
	  of current size of window (even entirely hidden)
	does not know about graphics display modes, just pokes the characters
	  into display memory
	this API call may be made from a hardware interrupt handler
SeeAlso: AX=1003h
--------Q-15DE0B-----------------------------
INT 15 - DESQview v2.00+ - "APILEVEL" - DEFINE MINIMUM API LEVEL REQUIRED
	AX = DE0Bh
	BL = API level minor version number
	BH = API level major version number
Return: AX = maximum API level (AH = major, AL = minor)
Notes:	if the requested API level is greater than the version of DESQview, a
	  "You need a newer version" error window is popped up
	the API level defaults to 1.00, and is inherited by child tasks
--------Q-15DE0C-----------------------------
INT 15 - DESQview v2.00+ - "GETMEM" - ALLOCATE "SYSTEM" MEMORY
	AX = DE0Ch
	BX = number of bytes
Return: ES:DI -> allocated block or 0000h:0000h (DV 2.26+)
Note:	use SETERROR (AX=DE15h) to avoid a user prompt if there is insufficient
	  system memory
SeeAlso: AX=1001h,AX=102Eh,AX=DE0Dh,AX=DE15h,AX=DE19h
--------Q-15DE0D-----------------------------
INT 15 - DESQview v2.00+ - "PUTMEM" - DEALLOCATE "SYSTEM" MEMORY
	AX = DE0Dh
	ES:DI -> previously allocated block
Return: nothing
SeeAlso: AX=1002h,AX=DE0Ch
--------Q-15DE0E-----------------------------
INT 15 - DESQview v2.00+ - "FINDMAIL" - FIND MAILBOX BY NAME
	AX = DE0Eh
	ES:DI -> name to find (see #0369)
	CX = length of name
Return: BX = 0000h not found
	     0001h found
		DS:SI = object handle
SeeAlso: AH=12h/BH=11h,AH=12h/BX=1200h"GETNAME"

(Table 0369)
Values for special DESQview mailbox names:
 "COM1" ... "COM4"	RBcomm using COM1 ... COM4
 "DESQview/X Help Engine"
 "DESQview/X Network Server"  Network Manager
 "DESQview X Server0"	X-Windows server
 "DESQview X Server7"	X-Windows printing service
 "INBOX"		DESQview/X LPD requests
 "OUTBOX"		DESQview/X LPD responses
 "WAITBOX"		semaphore to synchronize DESQview/X LPD communications
 "_DVNM_"		DV/X v1.10 network manager
--------Q-15DE0F-----------------------------
INT 15 - DESQview v2.00+ - ENABLE DESQview EXTENSIONS
	AX = DE0Fh
Return: AX and BX destroyed (seems to be bug, weren't saved&restored)
Notes:	sends a manager stream with opcodes AEh, BDh, and BFh to task's window
	enables an additional mouse mode
--------Q-15DE10-----------------------------
INT 15 - DESQview v2.00+ - "PUSHKEY" - PUT KEY INTO KEYBOARD INPUT STREAM
	AX = DE10h
	BH = scan code
	BL = character
Return: nothing
Notes:	a later read will get the keystroke as if it had been typed by the user
	multiple pushes are read last-in first-out
	if a script exists for the pushed key in the current application, the
	  script will be executed
	early copies of DV 2.00 destroy AX, BX, ES, and DI
SeeAlso: INT 16/AH=05h
--------Q-15DE11BL00-------------------------
INT 15 - DESQview v2.00+ - "JUSTIFY" - EN/DISABLE AUTOM. WINDOW JUSTIFICATION
	AX = DE11h
	BL = 00h      viewport will not move automatically
	     nonzero  viewport will move to keep cursor visible (default)
Return: nothing
--------Q-15DE12BX0000-----------------------
INT 15 - DESQview v2.01+ - "CSTYLE" - SET "C"-COMPATIBLE CONTROL CHAR INTERPRET
	AX = DE12h
	BX = 0000h    select normal style (linefeed only moves down)
	     nonzero  select C style (linefeed moves to start of next line)
Return: nothing
Note:	set on a per-task basis, and inherited from the parent task
--------Q-15DE13-----------------------------
INT 15 - DESQview v2.20+ - "GETCRIT" - GET CRITICAL NESTING COUNT
	AX = DE13h
Return: BX = number of calls to BEGINC or ENTERC
	      (see INT 15/AX=101Bh,INT 15/AX=DE1Ch) without matching ENDC
	      (see INT 15/AX=101Ch)
Note:	this API call may be made from within a hardware interrupt handler
SeeAlso: AX=101Bh,AX=101Ch,AX=DE1Bh,AX=DE1Ch
--------Q-15DE14-----------------------------
INT 15 - DESQview v2.20+ - GET OBJECT TYPE
	AX = DE14h
	ES:DI -> object
Return: BL = 00h not an object
	     08h window or task
	     09h mailbox
	     0Ah keyboard
	     0Bh timer
	     0Ch objectq
	     0Fh pointer
	     10h panel
SeeAlso: AX=1016h
--------Q-15DE15-----------------------------
INT 15 - DESQview v2.20+ - SET ERROR HANDLING
	AX = DE15h
	BL = error handling mode
	    00h post system error on all error conditions
	    01h return carry flag set on calls to ADDTO, SUBFROM, and WRITE
		messages sent to mailboxes which fail due to lack of system
		or common memory
	    02h (v2.26+) same as 01h, but also return null pointer for GETMEM
		calls which fail due to lack of system memory
Return: nothing
SeeAlso: AX=DE0Ch,AX=DE16h
--------Q-15DE16-----------------------------
INT 15 - DESQview v2.20+ - GET ERROR HANDLING
	AX = DE16h
Return: BL = current mode
	    00h always post system error
	    01h return carry flag set on failed mailbox writes
	    02h return CF set on failed mailbox writes and NULL on failed
		GETMEM calls
SeeAlso: AX=DE15h
--------Q-15DE17-----------------------------
INT 15 - DESQview v2.20-2.25 - reserved
	AX = DE17h
Return: pops up "Programming error" window
Note:	AX = 1117h is NOT identical to this call under DESQview 2.20 thru 2.25
SeeAlso: AX=1117h
--------Q-15DE17-----------------------------
INT 15 - DESQview v2.26+ - "ASSERTMAP" - GET/SET MAPPING CONTEXT
	AX = DE17h
	BX = function
	    0000h   get current mapping context without setting
	    nonzero set new mapping context to BX
Return: BX = mapping context in effect before call
Notes:	mapping contexts determine conventional-memory addressability; setting
	  a mapping context ensures that the associated program and data areas
	  are in memory for access.  Usable by drivers, TSRs and shared
	  programs.
	caller need not be running under DESQview
	this API call may be made from a hardware interrupt handler
SeeAlso: AX=1016h,AX=1117h,AX=DE21h,INT 2F/AX=1685h
--------Q-15DE18-----------------------------
INT 15 - DESQview v2.20+ - internal - ???
	AX = DE18h
	BP = function number
	    high byte must be 10h
	    low byte is function
		00h set ???
		    BL = ???  (00h-10h, video mode???)
		    BH = value to store
		03h set ???
		    BL = ??? (stored in driver)
		0Ah get ???
		    ES:DI -> 18-byte buffer to hold ???
Note:	calls video driver (NOP for Hercules driver,probably CGA and MCGA also)
--------Q-15DE19-----------------------------
INT 15 - DESQview v2.23+ - "GETCOMMON" - ALLOCATE "COMMON" MEMORY
	AX = DE19h
	BX = number of bytes to allocate
Return: AX = 0000h successful
		ES:DI -> allocated block
	     nonzero insufficient memory
Note:	this API call may be made from within a hardware interrupt handler
SeeAlso: AX=DE0Ch,AX=DE15h,AX=DE1Ah
--------Q-15DE1A-----------------------------
INT 15 - DESQview v2.23+ - "PUTCOMMON" - DEALLOCATE "COMMON" MEMORY
	AX = DE1Ah
	ES:DI -> previously allocated block
Return:	AX = 0000h (successful)
Note:	this function may be called from within a hardware interrupt handler
SeeAlso: AX=DE0Dh,AX=DE19h
--------Q-15DE1B-----------------------------
INT 15 - DESQview v2.23+ internal - DECREMENT CRITICAL NESTING COUNT
	AX = DE1Bh
Return: nothing
SeeAlso: AX=101Ch,AX=DE13h,AX=DE1Ch
--------Q-15DE1C-----------------------------
INT 15 - DESQview v2.23+ - "ENTERC" - INCREMENT CRITICAL NESTING COUNT
	AX = DE1Ch
Return: nothing
Notes:	similar to AX=101Bh, but begins the critical region without ensuring
	  that DOS is free
	the official documentation states that this call should be paired with
	  "ENDC" (AX=101Ch); no mention is made of AX=DE1Bh
	this API call may be made from within a hardware interrupt handler
SeeAlso: AX=101Bh,AX=101Ch,AX=DE13h,AX=DE1Bh
--------Q-15DE1D-----------------------------
INT 15 - DESQview v2.23+ - "PUTKEY" - FAKE USER KEYSTROKES
	AX = DE1Dh
	DX = segment of handle for task to receive keystroke
	BL = character
	BH = scan code
Return: AX = 0000h if successful
	   nonzero if receiver's keyboard buffer was full
Notes:	the key is treated as though the user had pressed it, ignoring any
	  script which may be bound to the key, and using the current field
	  table if the keyboard object is in field processing mode
	multiple PUTKEYs are seen in the order in which they are executed
SeeAlso: AX=DE10h
--------Q-15DE1E-----------------------------
INT 15 - DESQview v2.23+ - "SCRNINFO" - GET TRUE VIDEO PARAMETERS
	AX = DE1Eh
Return: CL = actual number of rows on screen
	CH = actual number of columns on screen
	BL = actual video mode (may differ from INT 10/AH=0Fh return) (v2.26+)
Note:	this API call may be made from a hardware interrupt handler
SeeAlso: INT 10/AH=0Fh
--------Q-15DE1F-----------------------------
INT 15 - DESQview v2.23+ - "DOSUSER" - GET HANDLE OF TASK CURRENTLY USING DOS
	AX = DE1Fh
Return: BX = segment of task handle or 0000h if no tasks are using DOS
Note:	this API call may be made from within a hardware interrupt handler
SeeAlso: AX=DE13h,INT 21/AH=34h
--------Q-15DE20-----------------------------
INT 15 - DESQview v2.26+ - "DISPATCHINT" - INTERRUPT ANOTHER TASK
	AX = DE20h
	BX = segment of handle of task to interupt
	DX:CX -> FAR interrupt routine
	BP,SI,DI,DS,ES as required by interrupt routine
Return: nothing
Notes:	unlike "PGMINT" (AX=1021h), DISPATCHINT may be applied to the task
	  making the DISPATCHINT call
	multiple "DISPATCHINT" calls are processed in the order in which they
	  were executed
	the FAR routine is entered with the current ES, DS, SI, DI, and BP
	  values, using the task's internal stack (see AX=101Ah); only SS:SP
	  needs to be preserved
	this API call may be made from within a hardware interrupt handler
SeeAlso: AX=1021h,AX=DE2Ah
--------Q-15DE21-----------------------------
INT 15 - DESQview v2.26+ - "ASSERTVIR" - CONTROL 386 SCREEN VIRTUALIZATION
	AX = DE21h
	BX = new state
	    0000h turn off
	    nonzero turn on
Return: BX = old state of virtualization
Notes:	this API call may be made from within a hardware interrupt handler
	under DV 2.40 and 2.42, this call appears to have no effect and always
	  returns a nonzero value in BX which appears to be the offset within
	  the DV common memory segment of the caller's task object; it may
	  only have an effect within a hardware interrupt handler
SeeAlso: AX=1117h,AX=DE17h
--------Q-15DE22-----------------------------
INT 15 - DESQview v2.26+ - "PROCESSMEM" - GET TASK MEMORY STATUS
	AX = DE22h
	DX = segment of task handle
Return: DX = total amount of memory in paragraphs
	BX = amount of system memory in paragraphs
	CX = largest block of system memory available in paragraphs
	AX = memory flags (see #0370)
Notes:	if the task handle is a child task, the returned values will be for the
	  process containing the task, rather than the task itself
	if the process's system memory is swapped out, BX,CX,DX remain
	  unchanged, because the memory usage cannot be determined
SeeAlso: AX=DE04h,AX=DE05h,AX=DE06h

Bitfields for DESQview process memory flags:
Bit(s)	Description	(Table 0370)
 0	system memory resides in shared memory
 1	process's memory is swapped out
 2	process's system memory is swapped out
--------Q-15DE23-----------------------------
INT 15 U - DESQview v2.31+ - ???
	AX = DE23h
	BX = ??? IRQ number on first PIC?
	CX = ??? IRQ number on second PIC?
Return: ???
Note:	called by QEMM 6.00+
--------Q-15DE24-----------------------------
INT 15 - DESQview v2.40+ - "XNEWPROC" - START NEW APPLICATION
	AX = DE24h
	BX = length of .DVP data
	CX = length of ??? string
	DS:SI -> ??? string
	ES:DI -> .DVP data (see #0285 at AX=102Ch)
Return: BX = segment of task handle??? or 0000h on error
Note:	this call is similar to AX=102Ch except that it can interpret the
	  extended DVP data
SeeAlso: AX=102Ch
--------Q-15DE25-----------------------------
INT 15 - DESQview v2.40+ - "GETDVPATH" - GET DESQview DIRECTORY
	AX = DE25h
	ES:DI -> 67-byte buffer for ASCIZ directory name
Return: ES:DI buffer filled with directory from which DESQview was started
BUG:	DV 2.42 does not place a terminating NUL at the end of the directory
	  name, so if the buffer is not cleared to zeros before the call,
	  there is no way to tell where the directory name ends.  This bug
	  has been fixed in DV 2.52 (DV/X 1.02)
SeeAlso: AX=DE2Eh,INT 21/AH=47h
--------Q-15DE26-----------------------------
INT 15 - DESQview v2.40+ - "GETFOREGROUND" - GET KEYBOARD FOCUS
	AX = DE26h
Return: BX = segment of handle for task with keyboard focus
Note:	under DESQview/X, the X server always has the keyboard focus unless a
	  "direct" window is active
SeeAlso: AX=DE2Fh,INT 2F/AX=DE0Ah
--------Q-15DE27-----------------------------
INT 15 - DESQview v2.50+ - "ADDINSTANCEDATA" - ADD PER-TASK SAVE/RESTORE AREA
	AX = DE27h
	BX = type
	    0000h process
	    0001h task
	ES:DI -> list of Instance Item Structures (see #0371)
Return: CF clear if successful
	    AX = ???
	    BX = ???
	CF set on error
	    AX = error code???
		0004h invalid BX value
Note:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
SeeAlso: INT 2F/AX=DE08h,INT 2F/AX=DE09h

Format of DESQview Instance Item Structure [one element of list]:
Offset	Size	Description	(Table 0371)
 00h	WORD	length of data area DESQview should save and restore on context
		  switches (0000h = end of list)
 02h	DWORD	pointer to area to be saved/restored
--------Q-15DE28-----------------------------
INT 15 U - DESQview v2.50+ - ???
	AX = DE28h
	BX = segment of ??? or 0000h for default
	???
Return: ???
Note:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
SeeAlso: AX=DE2Ah
--------Q-15DE29BX0000-----------------------
INT 15 U - DESQview/X - ???
	AX = DE29h
	BX = 0000h
	???
Return: CF clear if successful
	    ???
	CF set on error
Notes:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
	under DESQview 2.60, this function and all other subfunctions of
	  AX=DE29h always return CF set, as they are unique to DESQview/X
--------Q-15DE29BX0001-----------------------
INT 15 U - DESQview/X - ???
	AX = DE29h
	BX = 0001h
	DX = segment of window handle
Return: CF clear if successful
	    AX = ???
	    DX = ???
	CF set on error
Note:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
--------Q-15DE29BX0002-----------------------
INT 15 U - DESQview/X - ???
	AX = DE29h
	BX = 0002h
	DX = segment of window handle
Return: CF clear if successful
	    AX = ???
	    DX = ???
	CF set on error
Note:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
--------Q-15DE29BX0003-----------------------
INT 15 U - DESQview/X - ???
	AX = DE29h
	BX = 0003h
	DX = segment of window handle
Return: CF clear if successful
	    ???
	CF set on error
Note:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
--------Q-15DE29BX0004-----------------------
INT 15 U - DESQview/X - GET DISPLAY NAME
	AX = DE29h
	BX = 0004h
	CX = size of buffer in bytes
	DX = segment of window handle
	ES:DI -> buffer for display name
Return: CF clear if successful
	    buffer filled with ASCIZ display name (truncated if necessary) or
	      null string if no display
	CF set on error
Notes:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
	the name ":0" refers to the local display
--------Q-15DE29BX0005-----------------------
INT 15 U - DESQview/X - ???
	AX = DE29h
	BX = 0005h
	???
Return: CF clear if successful
	    ???
	CF set on error
Note:	under DESQview 2.60, this function and all other subfunctions of
	  AX=DE29h always return CF set, as they are unique to DESQview/X
--------Q-15DE2A-----------------------------
INT 15 - DESQview v2.50+ - "DISPATCHINTAFTERDOS" - INTERRUPT ANOTHER TASK
	AX = DE2Ah
	BX = segment of handle for task to interrupt or 0000h for caller
	DX:CX -> interrupt routine
	BP,SI,DI,DS,ES as required by interrupt routine
Return: nothing
Notes:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
	this call is the same as AX=DE20h except that it will delay
	  interrupting the specified task until after it has exited DOS
SeeAlso: AX=1021h,AX=DE20h
--------Q-15DE2B-----------------------------
INT 15 - DESQview v2.50+ - "OBJNEXT" - TRAVERSE OBJECT LIST
	AX = DE2Bh
	ES:DI -> starting object
		0000h:0000h for first object in list???
Return: AX = status
	    0000h successful
		ES:DI -> next object of same type (window/non-window)
	    0001h failed (ES:DI was not a valid handle)
Notes:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
	there are two separate lists, one for window/task objects and one
	  for all other objects
SeeAlso: AX=1016h,AX=DE2Ah,AX=DE2Ch
--------Q-15DE2C-----------------------------
INT 15 - DESQview v2.50+ - "WININFO" - GET WINDOW INFORMATION
	AX = DE2Ch
	DX = window information format version (0100h for DESQview 2.5x)
	BX = segment of window handle or 0000h for default
	ES:DI -> buffer for window information (see #0372)
Return: AX = status
	    0000h successful
Note:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
SeeAlso: AX=1000h,AX=1016h,AX=DE01h,AX=DE2Bh

Format of DESQview window information:
Offset	Size	Description	(Table 0372)
 00h	BYTE	task flag: 00h window, 01h task
 01h	BYTE	process number if owner task
		00h if non-owner task
 02h	WORD	segment of owner's handle, 0000h if orphaned
 04h	WORD	mapping context (see #0274 at AX=1016h)
 06h	BYTE	task status (see #0373)
 07h	BYTE	unused
 08h	WORD	status bits (see #0374)
 0Ah	BYTE	01h if foreground-only window

(Table 0373)
Values for DESQview task status:
 00h	"Waiting" waiting for input
 01h	"Idle" keyboard poll limit reached
 03h	same as 01h
 04h	"Pausing" INT 15/AX=1000h pause called
 04h	DV/X direct: user did something to allow task switch
 05h	"ModeChg" video mode about to be changed
 06h	"ModeNtf" notify that video mode changed
 07h	"MoniCh" requested change to other monitor
 08h	"StartPgm" control relinquished to start new process
 09h	"MgrCan" made window manager CANCEL command
 0Ah	"Slicing" time slice expired
 0Bh	"Exit DOS" notify on DOS calls
 0Ch	"Enter DOS" process is re-entering DOS
 0Dh	"Terminate" INT 21/AH=4Ch or task freed
 0Eh	"BrkNxt" Control-Break pressed
 0Fh	"MgrCol" keyboard focus taken away
 10h	"PgmInt" interrupted by API call from another task
 11h	"BldOpen" call to INT 15/AX=DE01h

Bitfields for DESQview task status bits:
Bit(s)	Description	(Table 0374)
 6	task is freeing another task
 5	process is being created
 4	user suspended process
 3	process suspended itself
 2	process is resized direct window (suspended)
 1	process swapped out
 0	DESQview process
--------Q-15DE2D-----------------------------
INT 15 U - DESQview v2.50+ - GET/SET SOCKET HANDLER
	AX = DE2Dh
	CX = direction
	    FFFFh set socket handler
		DX:BX -> FAR function for socket interface
			must be of the format described under INT 63"DESQview"
	    other get socket handler
		Return: DX:BX -> socket handler
Notes:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
	the "set" subfunction is normally called only by SOCKET.DVR
SeeAlso: AX=DE2Eh,INT 63"DESQview"
--------Q-15DE2E-----------------------------
INT 15 U - DESQview v2.50+ - SOCKET API
	AX = DE2Eh
	DX:BX -> socket record (see #0376)
		0000h:0000h to create a new socket record
Return: CX = size of socket record in bytes
	DX:BX -> socket record which was used
Notes:	DESQview 2.50-2.52 are distributed as part of DESQview/X v1.0x.
	socket records are allocated from common memory
	for Unix compatibility, each socket and connection on a socket is
	  allocated a DOS file handle (referencing an SFT for NUL) which is
	  used on various calls to specify which of possibly multiple
	  connections is to be operated upon
SeeAlso: AX=DE2Dh,INT 61/AX=0001h/SF=0001h"VINES",INT 63"DESQview"

(Table 0375)
Values for DESQview/X socket API function number:
 0000h	initialize socket???
 0001h	"gethostname"
 0002h	"ioctl" check for input
 0003h	"sleep" delay for specified period
 0004h	"htons" convert word to network (big-endian) byte order
 0005h	"select"
 0006h	"bsd_close"/"so_close" close socket
 0007h	NOP
 0008h	"connect" initiate connection on socket
 0009h	"recv"/"recvfrom" read from socket
 000Ah	"socket"
 000Bh	???
 000Ch	"gethostbyname"
 000Dh	"send"/"sendto" write to socket
 000Eh	??? (does something to all connections for process)
 000Fh	"getpid" get process identifier
 0010h	"gettimeofday"
 0011h	"bind" assign name to socket
 0012h	"listen" listen for connections on socket
 0013h	"accept" accept connection on socket
 0014h	connect to X server
 0015h	"gethostbyaddr" get host information for an address
 0016h	"getprotobyname"
 0017h	"getprotobynumber"
 0018h	"getservbyname"
 0019h	"getservbyport"
 001Ah	"getsockname" determine name bound to socket
 001Bh	"getpeername" get name of connected peer
 001Ch	"getsockopt"/"setsockopt"
 001Dh	"so_exit"	 close all sockets for calling process
 001Eh	"issock" determine whether file handle references socket
 001Fh	"so_attach" reattach previously detached socket
 0020h	"so_detach" temporarily detach socket
 0021h	get DESQview directory
 0022h	"NewProc" start new application (see AX=102Ch)
 0023h	"so_linkup"
 0024h	canonicalize filename
 0025h	indirect INT 15h call
 0026h	Network Manager interface
 0027h	"so_unlink"    close connection from "so_linkup"
 0028h	"raisepriority"
 0029h	"lowerpriority"
 002Ah	???
 FFFFh	"NetExit" (appears to be a NOP)

Format of DESQview/X socket record:
Offset	Size	Description	(Table 0376)
 00h	WORD	signature F0ADh
 02h	WORD	function number (see #0375)
 04h	WORD	returned error code (see #0393)
 06h	WORD	maximum message size??? (usually 0400h)
 08h	WORD	PSP segment to use or 0000h if socket not valid
 0Ah	WORD	scratch space (JFT size)
 0Ch	DWORD	scratch space (JFT address)
 10h	DWORD	mailbox handle (initialized by function 0000h)
 14h	DWORD	timer object handle (initialized by function 0000h)
---function 0000h---
 18h	WORD	(return) ???
---function 0001h---
 18h	WORD	(return) status???
 1Ah 128 BYTEs	(return) ASCIZ hostname (empty string if not on network)
 9Ah	WORD	maximum length of hostname to return
---function 0002h---
 18h	WORD	(return) status
 1Ah	WORD	socket's file handle
 1Ch	WORD	IOCTL function
		05h "FIONREAD" determine available input
		06h "FIONBIO" set blocking state of socket
 1Eh	WORD	(return, subfn 05h) number of bytes available for reading
		(call, subfn 06h) 0000h blocking, nonzero nonblocking
---function 0003h---
 18h  2 BYTEs	unused
 1Ah	WORD	delay time in seconds
---function 0004h---
 18h	WORD	(return) result in network (big-endian) byte order
 1Ah	WORD	value to convert to network byte order
---function 0005h---
 18h	WORD	(return) number of handles meeting the specified conditions???
 1Ah	WORD	number of file handles in each bitset???
 1Ch	DWORD	bitset of socket handles to check for readability???
 20h	DWORD	bitset of socket handles to check for writability???
 24h	DWORD	bitset of socket handles to check for errors???
 28h	WORD	timeout in ??? or 0000h to block until some socket ready
 2Ah	DWORD	???
 2Eh	DWORD	???
---function 0006h---
 18h	WORD	(return) status: 0000h if successful, FFFFh on error
 1Ah	WORD	socket's file handle
---function 0008h---
 18h	WORD	(return) status: 0000h if successful, FFFFh on error
 1Ah	WORD	socket's file handle
 1Ch	WORD	0001h if socket name specified, 0000h if not
 1Eh	WORD	length of socket name
 20h  N BYTEs	name of socket to which to connect
---function 0009h---
 18h	WORD	(return) number of bytes actually read, 0000h if connection
			closed, or FFFFh on error
 1Ah	WORD	socket's file handle
 1Ch	WORD	number of bytes to read
 1Eh	WORD	flags
 20h	WORD	0000h if no source address desired
		0001h if source address is to be stored (datagram sockets)
 22h	WORD	length of source address
 24h 110 BYTEs	source address
 92h 1K BYTEs	buffer for data to be read
---function 000Ah---
 18h	WORD	(return) socket's file handle or FFFFh on error
 1Ah	WORD	address family (0001h,0002h)
 1Ch	WORD	socket type
 1Eh	WORD	protocol
---function 000Bh---
 18h	WORD	(return) 0001h if ??? or FFFFh on error
 1Ah	WORD	socket's file handle
 1Eh	WORD	(call) ???
---function 000Ch---
 18h 128 BYTEs	buffer containing ASCIZ hostname
		special case if empty string or "unix"
 98h	???	'struct hostent' ???
 A2h	???	(return) ???
---function 000Dh---
 18h	WORD	(return) number of bytes actually written or FFFFh on error
 1Ah	WORD	socket's file handle
 1Ch	WORD	number of bytes to write
 1Eh	WORD	number of bytes to follow in subsequent writes???
 20h	WORD	flags
 22h	WORD	0000h if no destination specified, 0001h if destination present
 24h	WORD	???
 26h	WORD	length of destination address
 28h 110 BYTEs	destination address
 96h 1K BYTEs	buffer containing data to be written
---function 000Eh---
 no additional fields
---function 000Fh---
 18h	DWORD	(return) DESQview task handle of calling process
---function 0010h---
 18h	DWORD	(return) current time
 1Ch	DWORD	(return) ???
---function 0011h---
 18h	WORD	(return) status: 0000h if successful, FFFFh on error
 1Ah	WORD	socket's file handle
 1Ch	WORD	length of name
 1Eh  N BYTEs	buffer for socket name
---function 0012h---
 18h	WORD	(return) status: 0000h if successful, FFFFh on error
 1Ah	WORD	socket's file handle
 1Ch	WORD	maximum backlog of pending connections allowed on socket
---function 0013h---
 18h	WORD	(return) file handle for new connection or FFFFh on error
 1Ah	WORD	listen()ing socket's file handle
 1Ch	WORD	(call) length of buffer for connecting entity's address
		(return) actual length of address
 1Eh  N BYTEs	buffer for connecting entity's address
---function 0014h---
 18h	WORD	(return) socket's file handle or FFFFh on error
 1Ah  4 BYTEs	(return) ???
 1Eh	WORD	(return) ???
 20h	WORD	(return) ???
 22h 256 BYTEs	ASCIZ X display name
122h	???
---function 0015h---
 18h	WORD	(call) type of address??? (test for 0001h seen)
 1Ah	WORD	(call) length of buffer for host address
 1Ch 110 BYTEs	buffer containing host address
 8Ah	WORD	(return) offset of official host name???
 8Ch	WORD	(return) offset of alias list???
 8Eh	WORD	(return) address type???
 90h	WORD	(return) length of an address in bytes???
 92h	WORD	(return) offset of address???
 9Ah  N BYTEs	(return) ??? buffer for hostname, alias list, and host address
---function 0016h---
 18h	???	buffer for protocol name???
 98h	???
---function 0017h---
 18h	WORD	(call) protocol number???
 1Ah	WORD	(return) ??? or 0001h
---function 0018h---
 18h 128 BYTEs	buffer containing ???
 98h 128 BYTEs	buffer containing ???
118h	WORD	(return) ???
---function 0019h---
 18h	WORD	length of name???
 1Ah 128 BYTEs	buffer for name???
 9Ah	WORD	(return) ???
---function 001Ah---
 18h	WORD	(return) 0000h if successful, FFFFh on error
 1Ah	WORD	socket's file handle
 1Ch	WORD	(call) length of buffer for socket name
		(return) actual length of socket name
 1Eh  N BYTEs	buffer for socket name
---function 001Bh---
 18h	WORD	(return) status: 0000h if successful, FFFFh on error
 1Ah	WORD	socket's file handle
 1Ch	WORD	(call) size of buffer for name
		(return) actual size of name
 1Eh  N BYTEs	buffer for peer's name
---function 001Ch---
 18h	WORD	(return) status: 0000h if successful, FFFFh on error
 1Ah	WORD	direction: 0000h to get, 0001h to set
 1Ch	WORD	socket's file handle
 1Eh	WORD	option level
 20h	WORD	option name
 22h	WORD	(call) length of buffer for option value
		(return) actual length of option value
 24h  N BYTEs	buffer for option value
---function 001Dh---
 no additional fields
---function 001Eh---
 18h	WORD	(return) status: 0000h ??? or 0001h ???
 1Ah	WORD	file handle which may or may not be a socket
---function 001Fh---
 18h	WORD	(return) file handle or FFFFh on error
 1Ah	DWORD	(call) pointer to Socket Context Record (see #0394) of a
			previously detached socket
---function 0020h---
 18h	WORD	(return) status: 0000h if successful or FFFFh on error
 1Ah	WORD	socket's file handle
 1Ch	DWORD	(return) pointer to Socket Context Record (see #0394) for
			the file handle
---function 0021h---
 18h 64 BYTEs	buffer for DESQview startup directory (see AX=DE25h)
---function 0022h---
 18h	DWORD	(return) task handle of new application
 1Ch	WORD	size of .DVP data
 1Eh 129 BYTEs	ASCIZ ???
 9Fh  N BYTEs	.DVP data (see #0285 at AX=102Ch)
---function 0023h---
 18h	WORD	(return) ??? or FFFFh on error
 1Ah	WORD	socket's file handle???
---function 0024h---
 18h	WORD	(return) DOS error code (see #0789 at INT 21/AH=59h)
			0000h if successful
 1Ah 129 BYTEs	ASCIZ filename/pathname
11Bh 129 BYTEs	ASCIZ canonicalized filename/pathname (see INT 21/AH=60h)
---function 0025h---
 18h	WORD	value of AX
 1Ah	WORD	value of BX
 1Ch	WORD	(call) value of CX for call if AH value other than 12h
		(call) number of stack parameters if AH value is 12h
		(return) returned CX for calls other than INT 15/AH=12h
 1Eh	WORD	value of DX
 20h	WORD	value of DI
 22h	WORD	value of SI
 24h	WORD	value of DS
 26h	WORD	value of ES
 28h	WORD	(return) value of FLAGS after call
 2Ah  N DWORDs	(call) stack parameters for INT 15/AH=12h call
		(return) stack results from INT 15/AH=12h call
---function 0026h---
 18h	WORD	(call) Network Manager subfunction (see #0377)
		(return) status???
 1Ah	WORD	(call) size of parameter data
		(return) size of returned data
 1Ch  N BYTEs	(call) parameter data required by call (see #0378,#0379,#0380)
		(return) result data (see #0388,#0389,#0392)
---function 0027h---
 18h	WORD	(return) status: 0000h if successful, FFFFh on error
 1Ah	WORD	socket's file handle
---functions 0028h,0029h---
 18h	WORD	(call) file handle for which to set priority low/high
			FFFFh to change calling task's priority
---function 002Ah---
 no additional fields

(Table 0377)
Values for DESQview/X Network Manager subfunction:
 0004h	"so_exit"???
 0005h	"gethostbyname"
 0006h	"gethostname"
 0009h	"socket"
 000Dh	"gethostbyaddr"
 000Fh	"getprotobyname"
 0010h	get protocol name for protocol number
 0011h	"getservbyname"
 0012h	"getservbyport" (see #0381)
 0013h	"getsockname"??? (see #0382)
 0016h	??? (see #0383)
 0017h	kill Network Manager
 0018h	"getpeername"??? (see #0384)
 0019h	??? (called by socket function 0000h) (see #0385)
 001Ah	??? (see #0386)
 001Bh	"so_linkup" (see #0387)
 001Dh	get network services (see #0388)
 001Fh	"getpwuid"
 0020h	"getpwnam"
 0021h	"getpwvar"
 0022h	"crypt"
 0023h	"so_unlink"
 0024h	"getlogin" (see #0389)
 0028h	"sethostent"
 0029h	"gethostent"
 002Ah	"soaddhost"
 002Bh	"soupdatehost"
 002Ch	"sodeletehost"
 002Dh	"setservent"
 002Eh	"getservent"
 002Fh	"setpwent"
 0030h	"getpwent" (see #0390)
 0031h	???
 0032h	???
 0033h	???
 0034h	get IP network number (see #0391)
 0035h	??? (pops up Network Manager window)
 0037h	???
 0038h	get machine name and IP address (see #0392)
 0039h	???

Format of Function 0026h/Subfunction 000Fh data:
Offset	Size	Description	(Table 0378)
 00h  8 BYTEs	(return) ???

Format of Function 0026h/Subfunction 0010h data:
Offset	Size	Description	(Table 0379)
 00h  2 BYTEs	(return) ???
 02h	WORD	(return) protocol number
 04h	WORD	(call) protocol number for which to get name
 06h	WORD	(return) ???
 08h	var	(return) ASCIZ protocol name
 N	var	(return) ASCIZ protocol name

Format of Function 0026h/Subfunction 0011h data:
Offset	Size	Description	(Table 0380)
 00h  8 BYTEs	???
 08h	var	(return) ASCIZ protocol name
	var	(return) ASCIZ ??? name
	var	(return) ASCIZ ??? name

Format of Function 0026h/Subfunction 0012h data:
Offset	Size	Description	(Table 0381)
 00h  8 BYTEs	(return) ???

Format of Function 0026h/Subfunction 0013h data:
Offset	Size	Description	(Table 0382)
 00h 116 BYTEs	(return) ???

Format of Function 0026h/Subfunction 0016h data:
Offset	Size	Description	(Table 0383)
 00h  4 BYTEs	(return) ???

Format of Function 0026h/Subfunction 0018h data:
Offset	Size	Description	(Table 0384)
 00h 116 BYTEs	(return) ???

Format of Function 0026h/Subfunction 0019h data:
Offset	Size	Description	(Table 0385)
 00h  4 BYTEs	(return) ???
 04h	DWORD	(return) task handle of ???

Format of Function 0026h/Subfunction 001Ah data:
Offset	Size	Description	(Table 0386)
 00h 38 BYTEs	(return) ???

Format of Function 0026h/Subfunction 001Bh data:
Offset	Size	Description	(Table 0387)
 00h 10 BYTEs	(return) ???

Format of Function 0026h/Subfunction 001Dh return data [array]:
Offset	Size	Description	(Table 0388)
 00h	WORD	??? or FFFFh if end of array
 02h  7 BYTEs	???
 09h 27 BYTEs	ASCIZ name of service

Format of Function 0026h/Subfunction 0024h return data:
Offset	Size	Description	(Table 0389)
 00h	var	ASCIZ username

Format of Function 0026h/Subfunction 0030h data:
Offset	Size	Description	(Table 0390)
 00h	WORD	(call) UID or 0000h for current user
		(return) ???
 02h	WORD	(return) UID
 04h  6 BYTEs	(return) ???
 0Ah	var	(return) ASCIZ username
	var	(return) ASCIZ encrypted password
	var	(return) ASCIZ initial ("home") directory

Format of Function 0026h/Subfunction 0034h data:
Offset	Size	Description	(Table 0391)
 00h  1-3 BYTEs IP network number of caller's machine (low byte first)

Format of Function 0026h/Subfunction 0038h return data:
Offset	Size	Description	(Table 0392)
 00h	BYTE	???
 01h  4 BYTEs	IP address
 05h	var	ASCIZ machine name
	???

(Table 0393)
Values for DESQview/X socket error code:
 0000h	successful
 0009h	"BADF" bad file handle
 000Ch	"ENOMEM" out of memory
 000Eh	"EFAULT" bad address
 0016h	"EINVAL" invalid argument
 0018h	"EMFILE" too many open files
 0020h	"EPIPE" ??? broken pipe
 0023h	"EWOULDBLOCK" operation cannot be completed at this time
 0024h	"EINPROGRESS" operation now in progress
 0026h	"ENOTSOCK" socket invalid
 0028h	"EMSGSIZE" message too long to send atomically
 002Ch	"ESOCKTNOSUPPORT" socket type not supported
 002Fh	"EAFNOSUPPORT" address family not supp. by protocol fam.
 0031h	"EDOM" argument too large
 0038h	"EISCONN" socket is already connected
 0039h	"ENOTCONN" socket is not connected

Format of DESQview/X Socket Context Record:
Offset	Size	Description	(Table 0394)
 00h	DWORD	pointer to next Socket Context Record, 0000h:0000h if last
 04h	WORD	SFT index for socket, 00FFh if not connected, FFFFh if detached
 06h	WORD	PSP segment of owner or 0000h
 08h	WORD	mapping context of owning window (see #0274 at AX=1016h)
 0Ah  2 BYTEs	???
 0Ch	WORD	address family
 0Eh	WORD	socket type
 10h	WORD	protocol
 12h	WORD	socket state
		0001h created
		0002h bound
		0003h listening???
		0005h connected
 14h	DWORD	timer object handle
 18h	DWORD	object handle (mailbox???)
 1Ch	DWORD	object handle of parent of above object or 0000h:0000h
 20h	DWORD	pointer to ??? or 0000h
 24h  6 BYTEs	???
 2Ah	WORD	file handle for socket or FFFFh
 2Ch  2 BYTEs	???
 2Eh	WORD	nonzero if socket nonblocking
---network connections only---
 30h  2 BYTEs	???
 32h	WORD	???
 34h  4 BYTEs	(big-endian) IP address of remote
 38h  6 BYTEs	???
--------Q-15DE2F-----------------------------
INT 15 - DESQview v2.50+ - "VIDEONOTIFY" - HAS DIRECT WINDOW BEEN ACTIVE?
	AX = DE2Fh
Return: BX = status
	    0001h keyboard focus has been given to a direct window since the
		last call
	    0000h if not
Notes:	DESQview 2.50-2.53 are distributed as part of DESQview/X v1.00-1.10.
	Quarterdeck stated that this call would not be available under future
	  versions of DESQview Classic, but it is still present in v2.60
--------Q-15DE30-----------------------------
INT 15 - DESQview v2.50+ - "GETDVXVERSION" - GET DESQview/X VERSION
	AX = DE30h
Return: BX = version (BH=major, BL=minor) or 0000h if not DESQview/X
Notes:	DESQview 2.50-2.53 are distributed as part of DESQview/X v1.00-1.10.
	you must first check the DESQview version to verify that it is 2.50 or
	  greater
SeeAlso: INT 21/AH=2Bh/CX=4445h
--------Q-15DE31-----------------------------
INT 15 - DESQview/X v1.10 - ???
	AX = DE31h
	CX = ???
	    0000h ???
	    nonzero ???
	???
Return: ???
--------b-15DF-------------------------------
INT 15 - Juko UNIQUE UX BIOS - TURBO MODE CONTROL
	AH = DFh
	AL = function
	    00h turn on Turbo mode
	    01h turn off Turbo mode
	    02h set Turbo mode according to hardware switch
SeeAlso: INT 13/AX=FFFFh
--------b-15E00F-----------------------------
INT 15 - Compaq Systempro - MULTIPROCESSOR DISPATCH
	AX = E00Fh
	ES:BX -> start of 2nd processor's execution
Return: AL = status
	    0Fh successful
	    00h failure
SeeAlso: AX=E10Eh,AX=E200h
--------b-15E10E-----------------------------
INT 15 - Compaq Systempro - MULTIPROCESSOR END-OF-DISPATCH
	AX = E10Eh
	ES:BX -> start of 2nd processor's execution
Return: AL = status
	    0Fh successful (halted)
	    00h failure (not halted)
SeeAlso: AX=E00Fh,AX=E200h
--------b-15E200-----------------------------
INT 15 - Compaq Systempro - MULTIPROCESSOR AVAILABLE
	AX = E200h
Return: AX bit 15 set if 2nd processor available
SeeAlso: AX=E00Fh,AX=E10Eh
--------b-15E4-------------------------------
INT 15 - Tandy??? - ???
	AH = E4h
	AL = subfunction
	    21h, 89h, 8Ah, 8Bh called by 386MAX v6.01
	DL = ???
Return: DL = 00h if successful???
Note:	the section of code in 386MAX which calls these functions also checks
	  whether the ROM BIOS has both Tandy and Phoenix Technologies
	  signatures if these calls fail; the Tandy 1000SL/TL BIOS does not
	  support this function, however, returning the usual CF set/AH=86h for
	  "unsupported function".
--------b-15E4-------------------------------
INT 15 - Compaq ROM BIOS 03/08/93 and newer - ???
	AH = E4h
	AL = subfunction
	    00h get ???
		Return: CF clear
			AH = 00h
			CX = 0000h
			BX = ??? (read from [XBDA:0094h])
	    01h,02h unsupported by this ROM version
		Return: CF set, AH = 86h
	    80h,90h,A0h,B0h,C0h,D0h,E0h,F0h set ???
		Return: CF clear
			AH = 00h
			CX = 0000h
			BX = ???
	    81h,91h,A1h,B1h,C1h,D1h,E1h,F1h unsupported by 3/8/93&4/8/93 ROMs
		Return: CF set, AH = 86h
Notes:	functions 80h/90h/etc. are not supported by the 4/8/93 EISA System ROM
	these functions are not supported by the 7/26/93 LTE Lite 386 ROM
--------b-15E800-----------------------------
INT 15 - Compaq Contura - GET ???
	AX = E800h
Return: AX = 0000h
	BH = 00h
	BL = ??? (read from port 0C7Ch)
	CH = ???
	CL = ???
	DX = 0000h
Note:	also supported by 3/8/93 DESKPRO/i and 7/26/93 LTE Lite 386 ROM BIOS
--------b-15E801-----------------------------
INT 15 - Compaq Contura - GET ???
	AX = E801h
Return: CF clear
	AX = extended memory in K (read from CMOS locations 30h and 31h)
	BH = ???
	BL = ???
	CX = extended memory in K (read from CMOS locations 17h and 18h)
	DX = ???
Note:	also supported by 3/8/93 DESKPRO/i and 7/26/93 LTE Lite 386 ROM BIOS
--------b-15E802-----------------------------
INT 15 - Compaq Contura - GET ???
	AX = E802h
Return: CF clear
	AX = 0000h
	BX = ???
	CX = 0000h
Note:	this function is also supported by the LTE Lite 25c, 25E, and 486; not
	  supported by LTE Lite 20 and 25.
--------m-15F200CX454D-----------------------
INT 15 - Tandon memory mapper - Tandon MAPPER HARDWARE INITIALISATION CHECK ???
	AX = F200h
	CX = 454Dh
Return: CF clear if hardware already initialised
	    BX = upper RAM areas in use
		bit 0: C000-C3FF
		bit 1: C400-C7FF
		...
		bit 11: EC00-EFFF
	CF set if hardware not initialised yet
--------B-1600-------------------------------
INT 16 - KEYBOARD - GET KEYSTROKE
	AH = 00h
Return: AH = BIOS scan code
	AL = ASCII character
Notes:	on extended keyboards, this function discards any extended keystrokes,
	  returning only when a non-extended keystroke is available
	the BIOS scan code is usually, but not always, the same as the hardware
	  scan code processed by INT 09.  It is the same for ASCII keystrokes
	  and most unshifted special keys (F-keys, arrow keys, etc.), but
	  differs for shifted special keys.
SeeAlso: AH=01h,AH=05h,AH=10h,AH=20h,INT 18/AH=00h
--------B-1601-------------------------------
INT 16 - KEYBOARD - CHECK FOR KEYSTROKE
	AH = 01h
Return: ZF set if no keystroke available
	ZF clear if keystroke available
	    AH = BIOS scan code
	    AL = ASCII character
Note:	if a keystroke is present, it is not removed from the keyboard buffer;
	  however, any extended keystrokes which are not compatible with 83/84-
	  key keyboards are removed in the process of checking whether a
	  non-extended keystroke is available
SeeAlso: AH=00h,AH=11h,AH=21h,INT 18/AH=01h
--------B-1602-------------------------------
INT 16 - KEYBOARD - GET SHIFT FLAGS
	AH = 02h
Return: AL = shift flags (see #0395)
SeeAlso: AH=12h,AH=22h,INT 17/AH=0Dh,INT 18/AH=02h

Bitfields for keyboard shift flags:
Bit(s)	Description	(Table 0395)
 7	Insert active
 6	CapsLock active
 5	NumLock active
 4	ScrollLock active
 3	Alt key pressed (either Alt on 101/102-key keyboards)
 2	Ctrl key pressed (either Ctrl on 101/102-key keyboards)
 1	left shift key pressed
 0	right shift key pressed
--------B-1603-------------------------------
INT 16 - KEYBOARD - SET TYPEMATIC RATE AND DELAY
	AH = 03h
	AL = subfunction
	    00h set default delay and rate (PCjr and some PS/2)
	    01h increase delay before repeat (PCjr)
	    02h decrease repeat rate by factor of 2 (PCjr)
	    03h increase delay and decrease repeat rate (PCjr)
	    04h turn off typematic repeat (PCjr and some PS/2)
	    05h set repeat rate and delay (AT,PS)
		BH = delay value (00h = 250ms to 03h = 1000ms)
		BL = repeat rate (00h=30/sec to 0Ch=10/sec [def] to 1Fh=2/sec)
	    06h get current typematic rate and delay (newer PS/2s)
		Return: BL = repeat rate (see above)
			BH = delay (see above)
Note:	use INT 16/AH=09h to determine whether some of the subfunctions are
	  supported
SeeAlso: INT 16/AH=09h,AH=29h"HUNTER",AH=2Ah"HUNTER"
--------B-1604-------------------------------
INT 16 - KEYBOARD - SET KEYCLICK (PCjr only)
	AH = 04h
	AL = keyclick state
	    00h off
	    01h on
SeeAlso: AH=03h
--------B-1605-------------------------------
INT 16 - KEYBOARD - STORE KEYSTROKE IN KEYBOARD BUFFER (AT/PS w enh keybd only)
	AH = 05h
	CH = scan code
	CL = ASCII character
Return: AL = 00h if successful
	     01h if keyboard buffer full
Note:	under DESQview, a number of "keystrokes" invoke specific
	  DESQview-related actions when they are read from the keyboard
	  buffer (see #2208)
SeeAlso: AH=00h,AH=25h"K3",AH=71h,AH=FFh,INT 15/AX=DE10h

(Table 2208)
Values for pseudo-keystrokes for DESQview:
 38FBh or FB00h	switch to next window (only if main menu already popped up)
 38FCh or FC00h	pop up DESQview main menu
 38FEh or FE00h	close the current window
 38FFh or FF00h	pop up DESQview learn menu
--------B-1605-------------------------------
INT 16 - KEYBOARD - SELECT KEYBOARD LAYOUT (PCjr only)
	AH = 05h
	AL = function
	    01h set keyboard layout to French
	    02h set keyboard layout to German
	    03h set keyboard layout to Italian
	    04h set keyboard layout to Spanish
	    05h set keyboard layout to UK
	    80h check if function supported
		Return: AL <> 80h if supported
Return: ???
Note:	this function is called by the DOS 3.2 KEYBxx.COM
SeeAlso: AH=92h,AH=A2h
--------B-1609-------------------------------
INT 16 - KEYBOARD - GET KEYBOARD FUNCTIONALITY
	AH = 09h
Return: AL = supported keyboard functions (see #0396)
Note:	this function is only available if bit 6 of the second feature byte
	  returned by INT 15/AH=C0h is set
SeeAlso: AH=03h,AH=0Ah,AH=10h,AH=11h,AH=12h,AH=20h,AH=21h,AH=22h,INT 15/AH=C0h

Bitfields for supported keyboard functions:
Bit(s)	Description	(Table 0396)
 7	reserved
 6	INT 16/AH=20h-22h supported (122-key keyboard support)
 5	INT 16/AH=10h-12h supported (enhanced keyboard support)
 4	INT 16/AH=0Ah supported
 3	INT 16/AX=0306h supported
 2	INT 16/AX=0305h supported
 1	INT 16/AX=0304h supported
 0	INT 16/AX=0300h supported
--------B-160A-------------------------------
INT 16 - KEYBOARD - GET KEYBOARD ID
	AH = 0Ah
Return: BX = keyboard ID (see #0397)
Note:	check return value from AH=09h to determine whether this function is
	  supported
SeeAlso: AH=09h

(Table 0397)
Values for keyboard ID:
 0000h	no keyboard attached
 41ABh	Japanese "G" keyboard (translate mode)
 54ABh	Japanese "P" keyboard (translate mode)
 83ABh	Japanese "G" keyboard (pass-through mode)
 84ABh	Japanese "P" keyboard (pass-through mode)
 90ABh	old Japanese "G" keyboard
 91ABh	old Japanese "P" keyboard
 92ABh	old Japanese "A" keyboard
--------B-1610-------------------------------
INT 16 - KEYBOARD - GET ENHANCED KEYSTROKE (enhanced kbd support only)
	AH = 10h
Return: AH = BIOS scan code
	AL = ASCII character
Notes:	if no keystroke is available, this function waits until one is placed
	  in the keyboard buffer
	the BIOS scan code is usually, but not always, the same as the hardware
	  scan code processed by INT 09.  It is the same for ASCII keystrokes
	  and most unshifted special keys (F-keys, arrow keys, etc.), but
	  differs for shifted special keys.
	unlike AH=00h, this function does not discard extended keystrokes
	INT 16/AH=09h can be used to determine whether this function is
	  supported, but only on later model PS/2s
SeeAlso: AH=00h,AH=09h,AH=11h,AH=20h
--------B-1611-------------------------------
INT 16 - KEYBOARD - CHECK FOR ENHANCED KEYSTROKE (enh kbd support only)
	AH = 11h
Return: ZF set if no keystroke available
	ZF clear if keystroke available
	    AH = BIOS scan code
	    AL = ASCII character
Notes:	if a keystroke is available, it is not removed from the keyboard buffer
	unlike AH=01h, this function does not discard extended keystrokes
	some versions of the IBM BIOS Technical Reference erroneously report
	  that CF is returned instead of ZF
	INT 16/AH=09h can be used to determine whether this function is
	  supported, but only on later model PS/2s
SeeAlso: AH=01h,AH=09h,AH=10h,AH=21h
--------B-1612-------------------------------
INT 16 - KEYBOARD - GET EXTENDED SHIFT STATES (enh kbd support only)
	AH = 12h
Return: AL = shift flags 1 (same as returned by AH=02h) (see #0398)
	AH = shift flags 2 (see #0399)
Notes:	AL bit 3 set only for left Alt key on many machines
	AH bits 7 through 4 always clear on a Compaq SLT/286
	INT 16/AH=09h can be used to determine whether this function is
	  supported, but only on later model PS/2s
SeeAlso: AH=02h,AH=09h,AH=22h,AH=51h,INT 17/AH=0Dh

Bitfields for keyboard shift flags 1:
Bit(s)	Description	(Table 0398)
 7	Insert active
 6	CapsLock active
 5	NumLock active
 4	ScrollLock active
 3	Alt key pressed (either Alt on 101/102-key keyboards)
 2	Ctrl key pressed (either Ctrl on 101/102-key keyboards)
 1	left shift key pressed
 0	right shift key pressed

Bitfields for keyboard shift flags 2:
Bit(s)	Description	(Table 0399)
 7	SysReq key pressed (SysReq is often labeled SysRq)
 6	CapsLock pressed
 5	NumLock pressed
 4	ScrollLock pressed
 3	right Alt key pressed
 2	right Ctrl key pressed
 1	left Alt key pressed
 0	left Ctrl key pressed
--------J-1613-------------------------------
INT 16 - DOS/V - DOUBLE-BYTE CHARACTER SET SHIFT CONTROL
	AH = 13h
	AL = function
	    00h set shift status
		DX = shift status (see #0400), must preserve internal status
			  bits
	    01h get shift status
		Return: DX = current shift status (see #0400)
Note:	these functions are supplied by the Japanese Front-End Processor
SeeAlso: AH=14h,INT 21/AX=6301h

Bitfields for DOS/V shift status:
Bit(s)	Description	(Table 0400)
 0	full-size rather than half-size
 2-1	character input mode
	00 alphanumeric, 01 Katakana, 10 Hiragana, 11 unused
 5-3	internal status
 6	Romaji enabled
 7	Katakana to Kanji conversion enabled
 15-8	internal status
--------J-1614-------------------------------
INT 16 - DOS/V - SHIFT STATUS DISPLAY CONTROL
	AH = 14h
	AL = function
	    00h enable display
	    01h disable display
	    02h get display state
		Return: AL = current state (00h enabled, 01h disabled)
Desc:	control the screen-bottom shift status row(s) for the Japanese
	  Front-End Processor
SeeAlso: AH=13h,INT 10/AH=19h,INT 10/AH=1Dh
--------B-1620-------------------------------
INT 16 - KEYBOARD - GET 122-KEY KEYSTROKE (122-key kbd support only)
	AH = 20h
Return: AH = BIOS scan code (see AH=10h for details)
	AL = ASCII character
Note:	use AH=09h to determine whether this function is supported
SeeAlso: AH=00h,AH=09h,AH=10h,AH=21h,AH=22h
--------b-1620------------------------------------
INT 16 - HUNTER 16 - SET TEMPORARY SHIFT
	AH = 20h
	AL = shift status (see #0401)
Notes:	the Husky Hunter 16 is an 8088-based ruggedized laptop.	 Other family
	  members are the Husky Hunter, Husky Hunter 16/80, and Husky Hawk.
	the user can override the specified settings by pressing the keys

Bitfields for HUNTER 16 shift status:
Bit(s)	Description	(Table 0401)
 4	Scroll Lock on
 5	Num Lock on
 6	Caps Lock on
--------K-1620-------------------------------
INT 16 - K3 v1.5+, K3PLUS v5.0+ - GET EXTENDED BUFFER STATE
	AH = 20h
Return: AX = K3 version
	ES:BX -> extended keyboard buffer start
	ES:DX -> extended keyboard buffer end
	ES:SI -> next keystroke
	ES:DI -> last keystroke in buffer
	CX = number of keystrokes in buffer
Program: K3PLUS is an enhancement by Matthias Paul and Axel C. Frinke of the
	  K3 extended German keyboard driver by Martin Gerdes published in c't
	  magazine in 1988
SeeAlso: AH=25h"K3",AX=AF20h
--------B-1621-------------------------------
INT 16 - KEYBOARD - CHECK FOR 122-KEY KEYSTROKE (122-key kbd support only)
	AH = 21h
Return: ZF set if no keystroke available
	ZF clear if keystroke available
	    AH = BIOS scan code
	    AL = ASCII character
Notes:	use AH=09h to determine whether this function is supported
	some versions of the IBM BIOS Technical Reference erroneously report
	  that CF is returned instead of ZF
SeeAlso: AH=01h,AH=09h,AH=11h,AH=20h,AH=21h
--------b-1621------------------------------------
INT 16 - HUNTER 16 - CONTROL SHIFT KEYS
	AH = 21h
	AL = shift keys to control (see #0395)
	BL = shift state for disabled keys
Note:	If a bit in AL is set the key is disabled and set to the state of the
	  corresponding bit in BL
SeeAlso: AH=20h"HUNTER",AH=22h"HUNTER"
--------B-1622-------------------------------
INT 16 - KEYBOARD - GET 122-KEY SHIFT STATUS (122-key kbd support only)
	AH = 22h
Return: AL = shift flags 1 (see #0398)
	AH = shift flags 2 (see #0399)
Note:	use AH=09h to determine whether this function is supported
SeeAlso: AH=02h,AH=09h,AH=12h,AH=20h,AH=21h
--------b-1622------------------------------------
INT 16 - HUNTER 16 - CONTROL CTRL-ALT-DEL
	AH = 22h
	AL = new Ctrl-Alt-Del state (00h enabled, nonzero disabled)
	BX = 0708h
	CX = 0910h
	DX = 1112h
Return: AL = 00h if successful
SeeAlso: AH=21h"HUNTER",AH=23h"HUNTER",AH=2Ah
--------b-1623------------------------------------
INT 16 - HUNTER 16 - CONTROL EMERGENCY BREAKOUT
	AH = 23h
	AL = new state of breakout (00h enabled, nonzero disabled)
	BX = 0708h   
	CX = 0910h
	DX = 1112h
Return: AL = 00h if successful
Desc:	Enables or disables the emergency breakout feature, where the
	  Hunter 16 at power on checks whether the X and P keys are pressed.
	  If so the machine will boot rather than continue the running program
SeeAlso: AH=22h"HUNTER"
--------b-1624------------------------------------
INT 16 - HUNTER 16 - REDEFINE KEY CODES
	AH = 24h
	AL = Matrix Code (see #0402)
	BL = new Key code
Return: AL = status (00h successful, nonzero failed)
SeeAlso: AH=2Bh,AH=2Ch

(Table 0402)
Values for HUNTER 16 Matrix Code:
 Code  Key		Code	Key		Code	Key
 00h   Esc key		1Eh	Space		3Bh	L
 01h   1		21h	0		3Ch	,
 02h   Q		22h	-		3Eh	Right shift
 03h   Tab		23h	'		42h	8
 04h   Num Lock		24h	Keypad 4	43h	7
 05h   \		25h	Enter		44h	U
 08h   LShift		26h	Keypad 7	45h	I
 09h   Ctrl		27h	.		46h	J
 0Ah   "Paw" key	28h	Keypad 1	47h	K
 0Bh   2		29h	Keypad 0	48h	M
 0Ch   W		2Ch	=		49h	N 
 0Dh   A		2Dh	Backspace	4Ah	/
 0Eh   S		2Eh	Keypad 8	4Dh	6
 0Fh   Z		2Fh	Keypad 9	4Eh	5
 11h   Alt		30h	Keypad 5	4Fh	T
 16h   4		31h	Keypad 6	50h	Y
 17h   3		32h	Keypad 2	51h	G
 18h   E		33h	Keypad 3	52h	H
 19h   R		34h	Keypad .	53h	B
 1Ah   D		37h	9		54h	V
 1Bh   F		38h	O		55h	#
 1Ch   X		39h	P		58h	Pwr
 1Dh   C		3Ah	;		59h	Shift Pwr
--------b-1625------------------------------------
INT 16 - HUNTER 16 - RESET KEYBOARD
	AH = 25h
Return: AL = 00h
Desc:	restores the standard keyboard layout after any remapping
SeeAlso: AH=24h,AH=2Bh,AH=2Ch
--------K-1625-------------------------------
INT 16 - K3 v1.5+, K3PLUS v5.0+ - COPY INTO EXTENDED BUFFER
	AH = 25h
	CX = number of keystrokes to copy
	ES:SI -> buffer containing keystrokes
Return: CF clear if successful
	CF set on error (i.e. buffer full)
	    CX = number of keystrokes NOT transferred
	    ES:SI -> first keystroke not transferred
SeeAlso: AH=05h,AH=20h"K3",AX=AF25h
--------b-1626------------------------------------
INT 16 - HUNTER 16 - CONTROL KEYCLICK
	AH = 26h
	AL = new state of keyclicks (00h disabled, 01h enabled)
Return: AL = 00h
SeeAlso: AH=2Ah
--------b-1627------------------------------------
INT 16 - HUNTER 16 - CONTROL SCREEN DUMP AREA
	AH = 27h
	AL = what to dump
	    00h whole (virtual) window
	    01h LCD window only
Return: AL = 00h
Desc:	control whether printscren dumps the whole 80x25 screen or only the
	  part displayed in the LCD window
Note:	the Hunter 16 has a 240x64 LCD display which serves as a window into
	  a 640x200 virtual screen
--------b-1629------------------------------------
INT 16 - HUNTER 16 - GET KEY REPEAT
	AH = 29h
Return: BL = Typematic rate (characters per second) (see #0403)
	BH = delay (00h = 250ms, 01h = 500ms, 02h = 750ms, 03h = 1s)
SeeAlso: AH=03h,AH=2Ah

(Table 0403)
Values for HUNTER 16 Typematic rate:
 00h	30.0	 08h	15.0	 10h	7.5	 18h	3.7
 01h	26.7	 09h	13.3	 11h	6.7	 19h	3.3
 02h	24.0	 0Ah	12.0	 12h	6.0	 1Ah	3.0
 03h	21.8	 0Bh	10.9	 13h	5.5	 1Bh	2.7
 04h	20.0	 0Ch	10.0	 14h	5.0	 1Ch	2.5
 05h	18.5	 0Dh	 9.2	 15h	4.6	 1Dh	2.3
 06h	17.1	 0Eh	 8.6	 16h	4.3	 1Eh	2.1
 07h	16.0	 0Fh	 8.0	 17h	4.0	 1Fh	2.0
SeeAlso: AH=2Ah
--------b-162A------------------------------------
INT 16 - HUNTER 16 - CONTROL KEY REPEAT
	AH = 2Ah
	AL = new state of keyboard autorepeat (00h disabled, 01h enabled)
SeeAlso: AH=03h,AH=26h,AH=29h,AH=2Bh
--------b-162B------------------------------------
INT 16 - HUNTER 16 - REDEFINE KEY SCAN CODES
	AH = 2Bh
	AL = which key table to redefine
	    00h unshifted
	    01h shifted
	    02h Numlock
	BH = standard scan code of key (00h-80h)
	BL = new scan code
Desc:	redefine the generated scan code from BH to BL
SeeAlso: AH=24h,AH=2Ah,AH=2Ch
--------b-162C------------------------------------
INT 16 - HUNTER 16 - REDEFINE RAW KEY CODES
	AH = 2Ch
	AL = Matrix code of key (see AH=29h)
	BL = new key code
Return: AL = status (00h success, nonzero failed)
Desc:	redefine the key code generated by holding the PAW key down and
	  pressing the key in AL
SeeAlso: AH=24h,AH=2Bh
--------b-162D------------------------------------
INT 16 - HUNTER 16 - CONTROL BREAK KEYS
	AH = 2Dh
	AL = enabled break keys
	    bit 0 Ctrl-C
	    bit 1 Ctrl-Break
	BX = 0708h
	CX = 0910h
	DX = 1112h
Return: AL = status (00h success, FFh failed)
SeeAlso: AH=21h"HUNTER"
--------U-163577-----------------------------
INT 16 U - TextWare TWTSR - API
	AX = 3577h
	CX = function
	    00CBh ???
		Return: AX = 0000h
			BX = 0000h
			DX:CX -> ???
	    00CCh uninstall
		Return: AX = status
			    0000h successful
			    FFFDh unable to unload because vectors taken
	    00CDh ???
		Return: AX = 0000h
			BX = 0000h
			DX:CX -> ???
	    other
		Return: AX = 5345h ('SE')
Program: TWTSR is a TSR which allows the TextWare hypertext browser to be
	  popped up via hotkey
SeeAlso: AX=D724h
--------U-164252-----------------------------
INT 16 - TEXTCAP 2.0 - INSTALLATION CHECK
	AX = 4252h
Return: AX = 5242h if installed
Program: TEXTCAP 2.0 is a heavily modified (by Gisbert W. Selke) version of the
	  PC Magazine utility CAPTURE written by Tom Kihlken
SeeAlso: AX=4253h,AX=4254h
--------U-164253-----------------------------
INT 16 - TEXTCAP 2.0 - UNINSTALL
	AX = 4253h
Return: AX = segment of resident code
Notes:	the uninstall code does not check whether interrupt vectors have been
	  chained by other programs
	the caller must free the main memory block (using the returned segment)
SeeAlso: AX=4252h,AX=4254h
--------U-164254-----------------------------
INT 16 - TEXTCAP 2.0 - DUMP TEXT SCREEN TO FILE
	AX = 4254h
Return: AX = status
	    4254h if screen dump will be written as soon as disk becomes idle
	    5442h if screen dump written
SeeAlso: AX=4252h,AX=4253h
--------e-164500-----------------------------
INT 16 - Shamrock Software EMAIL - GET STATUS
	AX = 4500h
	DL = port number (01h = COM1)
	ES:BX -> 13-byte buffer for ASCIZ name
Return: AX = 4D00h if EMAIL installed on specified port
	    ES:BX -> "" if no connection
		  -> "*" if connection but caller has not identified name
		  -> name otherwise
	    CX = version (CH = major, CL = minor)
	    DL = privilege level of user (00h = guest)
	    DH = chosen language (00h German, 01h English)
SeeAlso: AX=4501h,AX=4502h
--------e-164501-----------------------------
INT 16 - Shamrock Software EMAIL - GET ELAPSED ONLINE TIME AND MAXIMUM TIME
	AX = 4501h
	DL = port number (01h = COM1)
Return: AX = 4D00h if EMAIL installed on specified port
	    BX = maximum connect time in clock ticks
	    CX = maximum connect time for guests (without name) in clock ticks
	    DX = elapsed connect time of current user in clock ticks
SeeAlso: AX=4500h
--------e-164502-----------------------------
INT 16 - Shamrock Software EMAIL - GET CURRENT COMMUNICATIONS PARAMETERS
	AX = 4502h
	DL = port number (01h = COM1)
Return: AX = 4D00h if EMAIL installed on specified port
	    BL = current value of serial port's Line Control Register
	    BH = flags (see #0404)
	    CX = selected country code (33 = France, 49 = Germany, etc)
	    DX = baudrate divisor (115200/DX = baudrate)
SeeAlso: AX=4500h

Bitfields for Shamrock Software EMAIL flags:
Bit(s)	Description	(Table 0404)
 0	ISO code
 1	pause
 2	linefeed
 3	ANSI sequences
--------e-164503-----------------------------
INT 16 - Shamrock Software EMAIL - SPECIFY COMMAND-WORD FOR USER FUNCTION
	AX = 4503h
	DL = port number (01h = COM1)
	DH = maximum execution time in clock ticks (00h = 5 seconds)
	ES:BX -> ASCIZ string with new user command-word
Return: AX = 4D00h if EMAIL installed on specified port
Notes:	a single user command (consisting of only uppercase letters and digits)
	  may be defined, and remains valid until it is overwritten or the
	  EMAIL program terminates; the user command must be activated by
	  calling AX=4504h at least once.
	an existing command word may be redefined with this function
SeeAlso: AX=4504h,AX=4505h
--------e-164504-----------------------------
INT 16 - Shamrock Software EMAIL - CHECK FOR USER FUNCTION COMMAND-WORD
	AX = 4504h
	DL = port number (01h = COM1)
	ES:BX -> 80-byte buffer for ASCIZ user input line
Return: AX = 4D00h if EMAIL installed on specified port
	    DL = flags
		bit 0: user function supported (always set)
		bit 1: user entered user-function command word
	    if DL bit 1 set,
		ES:BX buffer contains line entered by user which begins with
			the defined command word and has been converted to all
			caps
Note:	caller must process the returned commandline and invoke AX=4505h
	  within five seconds with the result of that processing
SeeAlso: AX=4503h,AX=4505h
--------e-164505-----------------------------
INT 16 - Shamrock Software EMAIL - SEND RESULT OF USER FUNCTION
	AX = 4505h
	DL = port number (01h = COM1)
	DH = error flag
	    bit 3: set on error
	ES:BX -> ASCIZ text to return to user, max 1024 bytes
Return: AH = 4Dh if EMAIL installed on specified port
	AL = status
	    00h successful
	    02h unable to perform function (timeout, prev call not complete)
	    other error
Notes:	if the error flag in DH is set, the string is not sent and an error
	  message is generated instead; if this function is not called within
	  five seconds of AX=4504h, EMAIL automatically generates an error
	  message
	the string is copied into an internal buffer, allowing this function's
	  caller to continue immediately
SeeAlso: AX=4503h,AX=4504h,INT 17/AX=2400h
--------e-164506-----------------------------
INT 16 - Shamrock Software EMAIL - MONITOR XMODEM DOWNLOAD
	AX = 4506h
	DL = port number (01h = COM1)
	ES:BX -> 13-byte buffer for ASCIZ filename
Return: AX = 4D00h if EMAIL installed on specified port
	    DH = Xmodem status
		00h no XGET command given
		01h XGET in progress
		02h XGET completed successfully
	    ES:BX buffer filled with last filename given to XGET command
		(without path)
Note:	DH=02h will only be returned once per XGET; subsequent calls will
	  return DH=00h
SeeAlso: AX=4500h,INT 17/AX=2408h
--------K-164D4F-----------------------------
INT 16 - M16_KBD.COM v5.6 - INSTALLATION CHECK
	AX = 4D4Fh
Return: AX = 6F6Dh if installed
	    ES = segment of resident code
Program: M16_KBD is a shareware Cyrillic keyboard driver by I.V. Morozov
SeeAlso: INT 10/AX=1130h/BX=4D4Fh
--------J-165000-----------------------------
INT 16 - KEYBOARD - AX PC - SET KEYBOARD COUNTRY CODE
	AX = 5000h
	BX = country code
	    0001h USA (English), 0051h Japan
Return: AL = status
	    00h successful
	    01h bad country code
	    02h other error
SeeAlso: AX=5001h,INT 10/AX=5000h,INT 17/AX=5000h
--------J-165001-----------------------------
INT 16 - KEYBOARD - AX PC - GET KEYBOARD COUNTRY CODE
	AX = 5001h
Return: AL = status
	    00h successful
		BX = country code
	    02h error
SeeAlso: AX=5000h,INT 10/AX=5001h,INT 17/AX=5001h
--------J-1651-------------------------------
INT 16 - KEYBOARD - AX PC - READ SHIFT KEY STATUS
	AH = 51h
Return: AL = standard shift key states (see #0395,#0398)
	AH = Kana lock (00h off, 01h on)
SeeAlso: AH=02h,AH=12h,AH=22h
--------t-165453BX5242-----------------------
INT 16 - TSRBONES - INSTALLATION CHECK
	AX = 5453h ('TS')
	BX = 5242h ('RB')
	CX = 4F4Eh ('ON')
	DX = 4553h ('ES')
Return: AX = 4553h if installed
	BX = 4F4Eh if installed
	CX = 5242h if installed
	DX = 5453h if installed
Program: TSRBONES is a skeletal TSR framework by Robert Curtis Davis
Note:	these values are the default as the TSRBONES package is distributed,
	  but will normally be changed when implementing an actual TSR with
	  the TSRBONES skeleton
SeeAlso: INT 2D"AMIS"
--------A-165500-----------------------------
INT 16 C - Microsoft Word internal - MICROSOFT WORD COOPERATION WITH TSR
	AX = 5500h
Return: AX = 4D53h ('MS') if keyboard TSR present
Notes:	during startup, Microsoft Word tries to communicate with any TSRs
	  that are present through this call.
	if the return is not 4D53h, Word installs its own INT 09 and INT 16
	  handlers; otherwise it assumes that the TSR will handle the keyboard
SeeAlso: INT 1A/AX=3601h
--------A-1655FEDX0000-----------------------
INT 16 CU - Microsoft QBASIC internal - MICROSOFT COOPERATION WITH TSR???
	AX = 55FEh
	DX = 0000h
	ES:BX -> ??? function
	ES:CX -> ??? structure
Return: AX = result
	    4D4Bh only the INT 1B handler will be installed.
	    <> 4D4Bh handlers for INT 08, INT 09, INT 16, INT 1B, and
		  INT 1C are installed
Notes:	The pointer in ES:CX seems to point at a structure defining a callback
	  function when new keyboard keys are pressed. If a TSR returns
	  AX=4D4Bh, QBASIC will stop (with IRQ's and interrupts enabled).
SeeAlso: INT 16/AX=5500h,INT 1A/AX=3601h
--------U-1655FF-----------------------------
INT 16 - Swap Utilities - ???
	AX = 55FFh
	BX >= 0004h
	CX = function
	    0000h set ??? flag
	    other clear ??? flag
Note:	present in SWAPSH and SWAPDT v1.77j, distributed with PC Tools v7, as
	  well as the Trusted Access SCRNBLNK.COM; this may be part of the
	  standard TesSeRact library
SeeAlso: INT 2F/AX=5453h
--------c-165758BX4858-----------------------
INT 16 U - Netroom CACHECLK - INSTALLATION CHECK
	AX = 5758h
	BX = 4858h ('HX')
	DX = 4443h ('DC')
	CX <> 5758h
Return: BX = 6878h if installed
	CX = 6463h if installed
	    AX = code segment of TSR
	    CX = internal version??? (v3.00 returns 0100h)
Program: CACHECLK is a "cloaked" disk cache included with Netroom
Notes:	if CX=5758h on entry, CACHECLK returns with all registers unchanged
	the cache statistics are located early in the segment pointed at by
	  AX on return
SeeAlso: INT 2F/AX=5758h
----------165758BX5754-----------------------
INT 16 U - Netroom ??? - ???
	AX = 5758h
	BX = 5754h
	???
Return: ???
----------165758BX5755-----------------------
INT 16 U - Netroom ??? - ???
	AX = 5758h
	BX = 5755h
	DS:SI -> ???
Return: ???
----------165758BX5756-----------------------
INT 16 U - Netroom ??? - INSTALLATION CHECK
	AX = 5758h
	BX = 5756h
Return: BX <> 5756h if installed
--------m-165758BX5858-----------------------
INT 16 U - Netroom PRENET - GET OLD INTERRUPT VECTORS
	AX = 5758h
	BX = 5858h
Return: CF clear
	DX:BX -> saved copy of interrupt vector table
Note:	the installation check consists of calling this function and comparing
	  BX against 5858h on return; if it has changed, PRENET is installed
SeeAlso: AX=5758h/BX=5859h
Index:	installation check;Netroom PRENET
--------m-165758BX5859-----------------------
INT 16 U - Netroom POSTNET - GET OLD INTERRUPT VECTORS
	AX = 5758h
	BX = 5859h
Return: CF clear
	DX:BX -> saved copy of interrupt vector table
Note:	the installation check consists of calling this function and comparing
	  BX against 5859h on return; if it has changed, POSTNET is installed
SeeAlso: AX=5758h/BX=5858h
Index:	installation check;Netroom POSTNET
--------U-166969BX6968-----------------------
INT 16 - PC Tools v5.1+ BACKTALK - UNHOOK
	AX = 6969h
	BX = 6968h
Return: resident code unhooked, but not removed from memory
Index:	uninstall;BACKTALK
--------U-166969BX6969-----------------------
INT 16 - PC Tools v5.1+ BACKTALK - INSTALLATION CHECK
	AX = 6969h
	BX = 6969h
	DX = 0000h
Return: DX nonzero if installed
	    BX = CS of resident code
	    DX = PSP segment of resident code
	    DS:SI -> ASCIZ identification string "CPoint Talk"
--------i-166A6B-----------------------------
INT 16 U - FastJuice - DISABLE/UNLOAD???
	AX = 6A6Bh
Return: ???
Program: FastJuice is a resident battery-power monitor by SeaSide Software
SeeAlso: AX=7463h
Index:	uninstall;FastJuice
--------G-166C63-----------------------------
INT 16 U - TMED v1.6a - INSTALLATION CHECK
	AX = 6C63h ('lc')
Return: AX = 4C43h ('LC') if installed
Program: TMED is a freeware resident memory editor by Liang Chen
--------b-166F00BX0000-----------------------
INT 16 - HP HIL Vectras - HP HIL Extended BIOS INSTALLATION CHECK
	AX = 6F00h
	BX = 0000h
Return: BX = 4850h if present
Notes:	called by recent MS Mouse drivers looking for an HP-HIL mouse
	supported by ES, QS, and RS series HP Vectras
SeeAlso: AX=6F0Dh
--------b-166F0D-----------------------------
INT 16 - HP HIL Vectras - GET HIL Extended BIOS INTERRUPT NUMBER
	AX = 6F0Dh
Return: AH = interrupt number (default 6Fh, 02h means 6Fh as well)
Note:	called by MS Windows HPSYSTEM.DRV and HPEBIOS.386 to support the HP-HIL
	  input system
SeeAlso: AX=6F0Eh,INT 6F"HP"
--------b-166F0E-----------------------------
INT 16 - HP HIL Vectras - SET HIL Extended BIOS INTERRUPT NUMBER
	AX = 6F0Eh
	BL = new interrupt number (60h-6Fh,78h-7Fh)
Return: AH = status (00h = successful)
Desc:	allows the HIL Extended BIOS software to use a non-default interrupt
	  number in case of an interrupt conflict with another application
Note:	called by MS Windows HPSYSTEM.DRV and HPEBIOS.386 to support the HP-HIL
	  input system
SeeAlso: AX=6F0Dh,INT 6F"HP"
--------K-1670-------------------------------
INT 16 - FAKEY.COM - INSTALLATION CHECK
	AH = 70h
Return: AX = 1954h if installed
Program: FAKEY is a keystroke faking utility by System Enhancement Associates
--------K-1671-------------------------------
INT 16 - FAKEY.COM - PUSH KEYSTROKES
	AH = 71h
	CX = number of keystrokes
	DS:SI -> array of words containing keystrokes to be returned by AH=00h
Program: FAKEY is a keystroke faking utility by System Enhancement Associates
SeeAlso: AH=05h,AH=72h
--------K-1672-------------------------------
INT 16 - FAKEY.COM - CLEAR FAKED KEYSTROKES
	AH = 72h
Program: FAKEY is a keystroke faking utility by System Enhancement Associates
SeeAlso: AH=71h
--------K-1673-------------------------------
INT 16 - FAKEY.COM - PLAY TONES
	AH = 73h
	CX = number of tones to play
	DS:SI -> array of tones (see #0405)
Program: FAKEY is a keystroke faking utility by System Enhancement Associates
SeeAlso: INT 15/AX=1019h

Format of FAKEY.COM tone array entries:
Offset	Size	Description	(Table 0405)
 00h	WORD	divisor for timer channel 2
 02h	WORD	duration in clock ticks
--------i-167463-----------------------------
INT 16 U - FastJuice - INSTALLATION CHECK
	AX = 7463h ("tc")
Return: AX = 5443h ("TC") if installed
Program: FastJuice is a resident battery-power monitor by SeaSide Software
SeeAlso: AX=6A6Bh
--------R-1675-------------------------------
INT 16 - pcANYWHERE III - SET TICK COUNT FOR SCANNING
	AH = 75h
	AL = number of ticks between checks for new screen changes
--------R-1676-------------------------------
INT 16 - pcANYWHERE III - SET ERROR CHECKING TYPE
	AH = 76h
	AL = error checking type
	    00h none
	    01h fast
	    02h slow
--------R-1677-------------------------------
INT 16 - pcANYWHERE III - LOG OFF
	AH = 77h
	AL = mode
	    00h wait for another call
	    01h leave in Memory Resident Mode
	    02h leave in Automatic Mode
	    FFh leave in current operating mode
--------U-167761-----------------------------
INT 16 - WATCH.COM v2.x-v3.0 - INSTALLATION CHECK
	AX = 7761h ('wa')
Return: AX = 5741h ('WA') if installed
Note:	WATCH.COM is part of the "TSR" package by Kim Kokkonen
SeeAlso: INT 21/AX=7761h
--------U-167788BX7789-----------------------
INT 16 - PC Magazine PUSHDIR.COM - INSTALLATION CHECK
	AX = 7788h
	BX = 7789h
	DS:SI -> signature "PUSHDIR VERSION 1.0"
Return: AX = 7789h if installed and signature correct
	BX = 7788h
	SI destroyed
--------R-1679-------------------------------
INT 16 - pcANYWHERE III - CHECK STATUS
	AH = 79h
Return: AX = status
	    FFFFh if resident and active
	    FFFEh if resident but not active
	    FFFDh if in Memory Resident mode
	    FFFCh if in Automatic mode
	    other value if not resident
SeeAlso: AX=7B00h,INT 21/AX=2B44h
--------R-167A-------------------------------
INT 16 - pcANYWHERE III - CANCEL SESSION
	AH = 7Ah
--------R-167B00-----------------------------
INT 16 - pcANYWHERE III - SUSPEND
	AX = 7B00h
SeeAlso: AH=79h,AX=7B01h
--------R-167B01-----------------------------
INT 16 - pcANYWHERE III - RESUME
	AX = 7B01h
SeeAlso: AH=79h,AX=7B00h
--------R-167C-------------------------------
INT 16 - pcANYWHERE III - GET PORT CONFIGURATION
	AH = 7Ch
Return: AH = port number
	AL = baud rate
	    00h = 50 baud
	    01h = 75 baud
	    02h = 110 baud
	    03h = 134.5 baud
	    04h = 150 baud
	    05h = 300 baud
	    06h = 600 baud
	    07h = 1200 baud
	    08h = 1800 baud
	    09h = 2000 baud
	    0Ah = 2400 baud
	    0Bh = 4800 baud
	    0Ch = 7200 baud
	    0Dh = 9600 baud
	    0Eh = 19200 baud
--------R-167D-------------------------------
INT 16 - pcANYWHERE III - GET/SET TERMINAL PARAMETERS
	AH = 7Dh
	AL = subfunction
	    00h set terminal parameters
	    01h get terminal parameters
	    02h get configuration header and terminal parameters
	DS:CX -> terminal parameter block
--------R-167E-------------------------------
INT 16 - pcANYWHERE III - COMMUNICATIONS I/O THROUGH PORT
	AH = 7Eh
	AL = subfunction
	    01h port input status
		Return AX = 0 if no characer ready,
		       AX = 1 if character ready
	    02h port input character
		Return AL = received character
	    03h port output character in CX
	    11h hang up phone
--------R-167F-------------------------------
INT 16 - pcANYWHERE III - SET KEYBOARD/SCREEN MODE
	AH = 7Fh
	AL = subfunction
	    00h enable remote keyboard only
	    01h enable host keyboard only
	    02h enable both keyboards
	    08h display top 24 lines
	    09h display bottom 24 lines
	    10h Hayes modem
	    11h other modem
	    12h direct connect
--------U-1680-------------------------------
INT 16 - MAKEY.COM - INSTALLATION CHECK
	AH = 80h
Return: AX = 1954h if installed
Program: MAKEY is a utility by System Enhancement Associates
--------U-168765BX4321-----------------------
INT 16 - AT.COM version 8/26/87 - API
	AX = 8765h
	BX = 4321h
	CX = ??? or FFFFh
	if CX = FFFFh
		DX = number of event to remove or FFFFh
Return: ES:BX -> event record array (see #0406)
Program: AT.COM is a resident scheduler by Bill Frolik

Format of AT.COM event record:
Offset	Size	Description	(Table 0406)
 00h	BYTE	in-use flag (00h free, 01h in use, FFh end of array)
 01h	BYTE	day of date on which to trigger
 02h	BYTE	month of date on which to trigger
 03h	BYTE	trigger time, minute
 04h	BYTE	trigger time, hour
 05h	WORD	offset of command to be executed
----------1692-------------------------------
INT 16 - ???
	AH = 92h
Return: AH <= 80h if ???
Note:	this function is called by the DOS 3.2 KEYBxx.COM and DOS 5+ KEYB.COM
SeeAlso: AH=05h"PCjr",AH=A2h
--------U-1699-------------------------------
INT 16 - SCOUT v5.4 - GET ???
	AH = 99h
Return: AX = ABCDh
	BX:CX -> ??? (appears to be start of PSP for resident portion)
Program: Scout is a memory-resident file manager by New-Ware
SeeAlso: AH=9Eh
--------U-169E-------------------------------
INT 16 - SCOUT v5.4 - INSTALLATION CHECK
	AH = 9Eh
Return: AX = ABCDh if installed
Program: Scout is a memory-resident file manager by New-Ware
SeeAlso: AH=99h
----------16A2-------------------------------
INT 16 - ???
	AH = A2h
Return: AH <= 80h if ???
Note:	this function is this function is called by the DOS 5+ KEYB.COM
SeeAlso: AH=92h
--------V-16AA-------------------------------
INT 16 - PTxxx.COM - (xxx=CGA,EGA,VGA,HER...) CALL GATE FOR GRAPHICS
	AH = AAh
	Various registers set up by high level language.
Return: Graphics performed
Note:	PT stands for Paint Tools which is a graphics library for Turbo Pascal,
	  Modula 2 and others from DataBiten in Sweden. The library is
	  installed as a memory resident driver.
--------U-16AABBBXEEFF-----------------------
INT 16 U - JORJ v4.3 - INSTALLATION CHECK
	AX = AABBh
	BX = EEFFh
Return: AX = EEFFh if installed
	BX = AABBh if installed
	    CL = hotkey name (default 6Ah 'j' for Alt-J)
Program: JORJ is a shareware dictionary with phonetic lookup by Jorj Software
	  Co.
Index:	hotkeys;JORJ
--------K-16AF20-----------------------------
INT 16 - K3PLUS v2.00+ - GET EXTENDED BUFFER STATE
	AX = AF20h
Return: AX = K3 version (same as returned in BX by AX=AF4Dh)
	ES:BX -> extended keyboard buffer start
	ES:DX -> extended keyboard buffer end
	ES:SI -> next keystroke
	ES:DI -> last keystroke in buffer
	CX = number of keystrokes in buffer
Program: K3PLUS is an enhancement by Matthias Paul and Axel C. Frinke of the
	  K3 extended German keyboard driver by Martin Gerdes published in c't
	  magazine in 1988
Note:	this function is identical to AH=20h"K3"
SeeAlso: AH=20h"K3",AX=AF25h,AX=AF4Dh,AX=AF50h
--------K-16AF25-----------------------------
INT 16 - K3PLUS v2.00+ - COPY INTO EXTENDED BUFFER
	AX = AF25h
	CX = number of keystrokes to copy
	ES:SI -> buffer containing keystrokes
Return: CF clear if successful
	CF set on error (i.e. buffer full)
	    CX = number of keystrokes NOT transferred
	    ES:SI -> first keystroke not transferred
Note:	this function is identical to AH=25h"K3"
SeeAlso: AH=25h"K3",AX=AF20h,AX=AF4Dh,AX=AF50h
--------K-16AF4D-----------------------------
INT 16 - K3PLUS v2.00+ - GET VERSION INFORMATION
	AX = AF4Dh
Return: AL = 50h if installed
	    BX = K3 version
	    DX = API version
	    ES:CX -> K3 structure (version-dependent) (see #2209)
Program: K3PLUS is an enhancement by Matthias Paul and Axel C. Frinke of the
	  K3 extended German keyboard driver by Martin Gerdes published in c't
	  magazine in 1988
SeeAlso: AX=AF20h,AX=AF50h
Index:	installation check;K3PLUS

Format of internal K3 structure:
Offset	Size	Description	(Table 2209)
 00h  3 BYTEs	signature "K3$"
 03h	BYTE	length of structure, including this byte and signature
 04h	WORD	compiler switch option flags A (see #2211)
 06h	WORD	compiler switch option flags B (see #2212)
 08h	BYTE	internal flags A (see #2213)
 09h	BYTE	internal flags B (see #2214)
 0Ah	WORD	DOS version recorded at startup
 0Ch	WORD	"ActTypeSpeed"
 0Eh	WORD	last Keyboard-ID sent (41ABh translated, 83ABh native)
 10h	WORD	offset of K3TAB Special
 12h	WORD	offset of K3TAB German
 14h	WORD	offset of K3TAB Alt
 16h	WORD	offset of K3TAB AltGr
 18h	WORD	offset of K3TAB Ctrl
 1Ah	WORD	offset of K3TAB NPad
 1Ch	WORD	offset of K3TAB CtrlNPad
 1Eh	WORD	offset of K3TAB AltNPad
 20h	WORD	offset of ApoTbl or 0000h
 22h	WORD	offset of UmlautTbl or 0000h
 24h	WORD	offset of UmlautTblExp or 0000h
 26h	WORD	length of video mode table
 28h	WORD	offset of VidMdTbl or 0000h
 2Ah	BYTE	'$' end marker

Bitfields for K3 compiler switch option flags A:
Bit(s)	Description	(Table 2211)
 15	GuINT16Fct2
 14	Int15df
 13	GuAltNP
 12	SupAT
 11	GuINT16Fct3
 10	GuINT16Ret
 9-8	Layout (0-2, 3 reserved)
 7	ForceMF (force MF decode without read-ID)
 6	KXlate (translate keys)
 5	UmlautX (include umlaut translation capability)
 4	ApoX (translate apostrophe)
 3	DoINT16
 2	UseCC
 1-0	UseEB (0-2, 3 reserved)

Bitfields for K3 compiler switch option flags B:
Bit(s)	Description	(Table 2212)
 15-5	reserved (0)
 4	SendOut
 3	SupInt16fct5500
 2	GuINT15Fct4F
 1-0	UseBufferStart (0-2, 3 reserved) 

Bitfields for K3 internal flags A:
Bit(s)	Description	(Table 2213)
 7	DoingUmlautExp
 6	CallINT15fct4F
 5	Beep1 (requires SendOut set in option flags B)
 4	ATflag (set for AT, 386, PS/2 Models 50-80)
 3	XTflag (set for PC, PC/XT, Micromint PC, Pencock PC, PS/2 Model 30)
 2	KeyClick
 1	UmlautExp
 0	UmlautTrans

Bitfields for K3 internal flags B:
Bit(s)	Description	(Table 2214)
 7-1	reserved
 0	ApoPendingBeep
--------K-16AF50-----------------------------
INT 16 - K3PLUS v2.00+ - CHECK IF FUNCTION SUPPORTED
	AX = AF50h
	CH = function
	    00h get function flags
		CL = 00h
		Return: CX = supported function flags (see #2210)
	    nonzero reserved for extensions
SeeAlso: AX=AF20h,AX=AF4Dh,AX=AF51h,AX=AF80h

Bitfields for K3PLUS supported function list:
Bit(s)	Description	(Table 2210)
 0	function 4Dh supported
 1	function 50h supported
 2-3	reserved (0)
 4	function 20h supported
 5	function 25h supported
 6	function 51h supported
 7	reserved (0)
 8	function 80h supported
 9	function 81h supported
 10	function 82h supported
 11-15	reserved (0)
--------K-16AF51-----------------------------
INT 16 - K3PLUS v2.00+ - SET OPTIONS
	AX = AF51h
	CX = switches
Return: AL = status
	    00h done
		CX = previous switch settings
	    01h switch not supported
	    FFh other error
SeeAlso: AX=AF4Dh,AX=AF50h,AX=AF80h
--------K-16AF80-----------------------------
INT 16 - K3PLUS v2.00+ - GET ORIGINAL INT 09h VECTOR
	AX = AF80h
Return: AL = status
	    00h not supported
	    81h if successful
		ES:CX -> original INT 09 handler
SeeAlso: AX=AF4Dh,AX=AF50h,AX=AF81h,AX=AF82h
--------K-16AF81-----------------------------
INT 16 - K3PLUS v2.00+ - GET ORIGINAL INT 16h HANDLER
	AX = AF81h
Return: AL = status
	    00h not supported
	    82h if successful
		ES:CX -> original INT 16 handler
SeeAlso: AX=AF4Dh,AX=AF50h,AX=AF80h,AX=AF82h
--------K-16AF82-----------------------------
INT 16 - K3PLUS v2.00+ - GET ORIGINAL INT 10h HANDLER
	AX = AF82h
Return: AL = status
	    00h not supported
	    83h if successful
		ES:CX -> original INT 10 handler
Program: K3PLUS is an enhancement by Matthias Paul and Axel C. Frinke of the
	  K3 extended German keyboard driver by Martin Gerdes published in c't
	  magazine in 1988
SeeAlso: AX=AF4Dh,AX=AF50h,AX=AF80h,AX=AF81h
--------m-16B0B1-----------------------------
INT 16 - VGARAM v1.00 - INSTALLATION CHECK
	AX = B0B1h
	ES:DI -> 6 byte signature "VGARAM"
Return: AX = B1B0h if installed,
	DS:BX -> VGARAM Status byte: 0 = OFF, 1 = ON
Program: VGARAM is a utility by Brett Warthen which makes VGA memory which is
	  not used in text modes available for DOS
--------K-16CA--BX736B-----------------------
INT 16 - CtrlAlt Associates STACKEY.COM v3.00 - API
	AH = CAh
	BX = 736Bh ("sk")
	CX = 736Bh
	AL = function
	    00h installation check
		Return: DX = words available in keyboard buffer
	    01h place keystroke in buffer
		DX = keystroke (DH = scan code, DL = ASCII character)
		Return: DX = words available in keyboard buffer
			    FFFFh on error
	    02h flush STACKEY and BIOS keyboard buffers
Return: AX = CAFFh if installed
	    BX = segment of resident code
	    CX = STACKEY version (CH = major, CL = minor)
Program: STACKEY is a shareware keyboard-input faking TSR
Index:	installation check;STACKEY
--------V-16CA00BX6570-----------------------
INT 16 - CtrlAlt Associates EGAPAL.COM v1.00 - INSTALLATION CHECK
	AX = CA00h
	BX = 6570h ("ep")
	CX = 6570h
Return: AX = CAFFh if installed
	    BX = segment of resident code
	    CX = ??? (0090h)
Program: EGAPAL is a TSR supplied with STACKEY which makes EGA palette settings
	  permanent across mode switches
SeeAlso: AX=CA00h/BX=7670h
--------V-16CA00BX7670-----------------------
INT 16 - CtrlAlt Associates VGAPAL.COM v1.00 - INSTALLATION CHECK
	AX = CA00h
	BX = 7670h ("vp")
	CX = 7670h
Return: AX = CAFFh if installed
	    BX = segment of resident code
	    CX = ??? (0090h)
Program: VGAPAL is a TSR supplied with STACKEY which makes VGA palette settings
	  permanent across mode switches
SeeAlso: AX=CA00h/BX=6570h
--------U-16D724CX00CB-----------------------
INT 16 U - APCAL v3.20 - GET ???
	AX = D724h
	CX = 00CBh
Return: AX = 0000h
	BX = 0000h
	DX:CX -> ??? or 0000h:0000h
Program: APCAL is an optionally-resident shareware appointment calendar by
	  Gamma Software
SeeAlso: AX=3577h,AX=D724h/CX=00CCh,AX=D724h/CX=00CDh
--------U-16D724CX00CC-----------------------
INT 16 U - APCAL v3.20 - GET ???
	AX = D724h
	CX = 00CCh
Return: AX = 0000h
	BX = 0000h
	DX:CX -> ??? (apparently an internal data area)
SeeAlso: AX=D724h/CX=00CBh,AX=D724h/CX=00CDh
--------U-16D724CX00CD-----------------------
INT 16 U - APCAL v3.20 - GET ???
	AX = D724h
	CX = 00CDh
Return: AX = ??? (5345h seen)
SeeAlso: AX=D724h/CX=00CBh,AX=D724h/CX=00CCh
----------16DFDF-----------------------------
INT 16 U - Corel PowerSCSI - FDAUDIO.COM - INSTALLATION CHECK
	AX = DFDFh
Return: ES:DI -> ASCII signature "FDAUDIO/CD" followed by ASCII date, i.e.
	  "06/18/93" if installed
--------t-16E0E0-----------------------------
INT 16 - TurboPower TSRs - ALTERNATE INSTALLATION CHECK
	AX = E0E0h
Return: AX = 1F1Fh if installed
	    DWORD 0040h:00F0h -> last data block in TSR list (see #0408)
Note:	the returned TSR list provides support for communication among TSRs
	  built with TurboPower's Turbo Professional and Object Professional
	  libraries for Turbo Pascal
SeeAlso: AX=F0F0h
--------U-16ED--BHED-------------------------
INT 16 - BORLAND TURBO LIGHTNING - API
	AH = EDh
	BH = EDh
	BL = function
	    00h installation check
		Return: AX = 5205h
			CH = major version
			CL = minor version
	    01h identical to function 00h???
	    02h get resident data segment
		Return: AX = data segment of resident portion
	    03h get resident ???
		Return: AX = offset of some buffer in resident code seg
	    04h redefine auxiliary dictionary
		DS:SI -> counted filename string
		Return: AL = result code
	    05h select active environment
		AL = environment (00h to 0Ch)
		Return: AX = status
			    0000h if OK
			    0001h if out of range
	    06h toggle AutoProof???
		AL = state (00h off, 01h on)
	    07h ???
	    08h ???
		AL = char???
		CX = ???
		DX = ???
		Return: AX = 0, 1 or 2
	    09h ???
	    0Ah ???
		CX = ???
		DX = ???
		Return: AX = ???
	    0Bh check dictionary integrity???
		DS:SI -> counted dictionary filename string
		Return: AX = 0, 40h, 80h
	    0Ch spellcheck string (disk dictionary, possibly RAM dict as well)
		DS:SI -> counted string to check
		Return: AH = 0
			AL = result code
			   00h string found in dictionary
			   20h string begins more than one word
			   40h string not found
	    0Dh set ???
		(sets an internal flag)
	    0Eh spellcheck string (RAM dictionary only)
		DS:SI -> counted string to check
		Return: AH = 00h
			AL = result code
			    00h string found in dictionary
			    01h string not found
			    02h ???
	    0Fh ???
	    10h ???
Notes:	AX in general returns an error code from most functions.
Index:	installation check;Turbo Lightning
--------U-16EF-------------------------------
INT 16 - CALCULATOR - INSTALLATION CHECK
	AH = EFh
Return: AX = 0088h if installed
Program: CALCULATOR is a shareware popup calculator by Andrzej Brzezinski and
	  Marek Kosznik
--------b-16F0-------------------------------
INT 16 - Compaq 386 and newer - SET CPU SPEED
	AH = F0h
	AL = speed code (see #0407)
	if AL=09h,
	    CX = speed value, 1 (slowest) to 50 (full), 3 ~= 8088
SeeAlso: AH=F1h,AH=F3h

(Table 0407)
Values for speed code:
 00h	equivalent to 6 MHz 80286 (COMMON)
 01h	equivalent to 8 MHz 80286 (FAST)
 02h	full 16 MHz (HIGH)
 03h	toggles between 8 MHz-equivalent and speed set by system board switch
	  (AUTO or HIGH)
 08h	full 16 MHz except 8 MHz-equivalent during floppy disk access
 09h	specify speed directly
--------t-16F0F0-----------------------------
INT 16 - TurboPower TSRs - INSTALLATION CHECK
	AX = F0F0h
Return: AX = 0F0Fh if installed
	    ES:DI -> last data block in TSR list
Note:	the returned TSR list provides support for communication among TSRs
	  built with TurboPower's Turbo Professional and Object Professional
	  libraries for Turbo Pascal
SeeAlso: AX=E0E0h

Format of TurboPower TSR data block:
Offset	Size	Description	(Table 0408)
 00h	DWORD	pointer to program tag (counted ASCII string)
 04h	WORD	interface version number (0400h)
 06h	DWORD	pointer to command entry point
 0Ah	DWORD	pointer to previous data block (0000h:0000h if none)
 0Eh	DWORD	pointer to next data block (0000h:0000h if none)
---swappable TSRs only---
 12h	DWORD	pointer to swapping data
 16h	DWORD	pointer to user data
	more???
--------b-16F1-------------------------------
INT 16 - Compaq 386 and newer - READ CURRENT CPU SPEED
	AH = F1h
Return: AL = speed code (see #0407)
	if AL = 09h, CX = speed code
SeeAlso: AH=F0h,AH=F3h
--------b-16F2-------------------------------
INT 16 - Compaq 386 and newer - DETERMINE ATTACHED KEYBOARD TYPE
	AH = F2h
Return: AL = type
	    00h if 11-bit AT keyboard is in use
	    01h if 9-bit PC keyboard is in use
	AH = 00h (04/08/93 system ROM)
--------b-16F3-------------------------------
INT 16 - Compaq 80286s - SET CPU SPEED LIMIT (OVERRIDE JUMPER)
	AH = F3h
	AL = new limit
	    00h limit is 6 Mhz
	    01h limit is 8 Mhz/6 Mhz
SeeAlso: AH=F0h,AH=F1h
--------U-16F398-----------------------------
INT 16 U - NORTON GUIDES - INSTALLATION CHECK
	AX = F398h
Return: AX = 6A73h ("js")
	BH = scan code of current hot key
	BL = ASCII code of current hot key
Note:	NG.EXE was written by John Socha
--------b-16F400-----------------------------
INT 16 - Compaq Systempro and higher - CACHE CONTROLLER STATUS
	AX = F400h
Return: AH = E2h
	AL = status
	    00h not present
	    01h enabled
	    02h disabled
SeeAlso: AX=F401h,AX=F402h
--------b-16F401-----------------------------
INT 16 - Compaq Systempro and higher - ENABLE CACHE CONTROLLER
	AX = F401h
Return: AX = E201h
SeeAlso: AX=F400h,AX=F402h
--------b-16F402-----------------------------
INT 16 - Compaq Systempro and higher - DISABLE CACHE CONTROLLER
	AX = F402h
Return: AX = E202h
SeeAlso: AX=F400h,AX=F401h
--------v-16FA00DX5945-----------------------
INT 16 U - PC Tools v8+ VSAFE, VWATCH - INSTALLATION CHECK
	AX = FA00h
	DX = 5945h
Return: CF clear
	DI = 4559h
	BX = BIOS hotkey scancode (default 2F00h) (VSAFE only)
		FFFFh if disabled
Note:	MS-DOS 6.0 bundles VSAFE and VWATCH as part of its virus protection
SeeAlso: AX=FA05h,INT 13/AH=FAh,INT 21/AH=FAh"VDEFEND",INT 2F/AX=6282h
--------v-16FA01DX5945-----------------------
INT 16 U - PC Tools v8+ VSAFE, VWATCH - UNINSTALL
	AX = FA01h
	DX = 5945h
Return: CF clear if successful
	DI = 4559h
SeeAlso: AX=FA00h
--------v-16FA02DX5945-----------------------
INT 16 U - PC Tools v8+ VSAFE, VWATCH - GET/SET OPTIONS
	AX = FA02h
	DX = 5945h
	BL = new parameter flags (see #0409)
Return: CF clear
	DI = 4559h
	CL = old value of parameter flags

Bitfields for VSAFE/VWATCH parameter flags:
Bit(s)	Description	(Table 0409)
 7	Protect executable files
 6	Protect FD boot sector
 5	Protect HD boot sector
 4	Boot sector viruses
 3	Check executable files
 2	General write protect
 1	Resident
 0	HD Low level format
--------v-16FA03DX5945-----------------------
INT 16 U - PC Tools v8+ VSAFE, VWATCH - GET ???
	AX = FA03h
	DX = 5945h
Return: CF clear
	DI = 4559h
	AX = 0002h
--------v-16FA04DX5945-----------------------
INT 16 U - PC Tools v8+ VSAFE - GET HOTKEY DISABLE FLAG
	AX = FA04h
	DX = 5945h
Return: CF clear
	DI = 4559h
	BL = hotkey disable flag (nonzero if hotkey disabled)
Note:	this function is a NOP under VWATCH, merely returning CF clear/DI=4559h
SeeAlso: AX=FA00h,AX=FA05h
--------v-16FA05DX5945-----------------------
INT 16 U - PC Tools v8+ VSAFE - SET HOTKEY DISABLE FLAG
	AX = FA05h
	DX = 5945h
	BL = new value of hotkey disable flag (nonzero to disable hotkey)
Return: CF clear
	DI = 4559h
Note:	this function is a NOP under VWATCH, merely returning CF clear/DI=4559h
SeeAlso: AX=FA00h,AX=FA04h
--------v-16FA06DX5945-----------------------
INT 16 U - PC Tools v8+ VSAFE, VWATCH - GET NETWORK DRIVES TEST FLAG
	AX = FA06h
	DX = 5945h
Return: CF clear
	DI = 4559h
	BL = test status
	    00h don't monitor network drives (default for VWATCH v2.1)
	    FFh monitor network drives (default for VSAFE v2.0)
	CL = ??? (only VSAFE 2.0)
SeeAlso: AX=FA07h
--------v-16FA07DX5945-----------------------
INT 16 U - PC Tools v8+ VSAFE, VWATCH - SET NETWORK DRIVES TEST FLAG
	AX = FA07h
	DX = 5945h
	BL = new state
	    00h don't monitor
	    01h monitor network drives
Return: CF clear
	DI = 4559h
Note:	VWATCH v2.1 (from PC Tools 9.0) returns CF set instead
SeeAlso: AX=FA00h,AX=FA06h
--------v-16FA08DX5945-----------------------
INT 16 U - PC Tools v9+ VWATCH v2.1 - ???
	AX = FA08h
	DX = 5945h
Return: CF clear
	DI = 4559h
	AX = ??? (0002h)
	BX = version (BH=major, BL=two-digit minor)
Note:	this function is not supported by the PC Tools 9.0 VSAFE v2.0
SeeAlso: AX=FA00h,AX=FA06h
--------U-16FE55-----------------------------
INT 16 U - PC Tools v8+ programs - GET ???
	AX = FE55h
	CX = segment of resident program or 0000h for last loaded
	DX = 0000h
Return: DX = resident code segment (unchanged if CX=0000h on entry)
	AX = ??? or 0000h
Note:	this call is supported by CPSCHED, CPTASK, DATAMON, DPROTECT, DRIVEMAP,
	  and DSKLIGHT beginning in PC Tools v8.0; programs other than CPTASK
	  seem to hook it merely to return the same AX as the CPTASK loaded
	  prior to them returned
--------U-16FEA4-----------------------------
INT 16 U - PC Tools v7+ CPSCHED/DESKTOP - RESET ???
	AX = FEA4h
Return: nothing
Note:	this function is identical to AX=FFA4h, and is implemented by the same
	  code in DESKTOP
SeeAlso: AX=FFA4h
--------U-16FEC6-----------------------------
INT 16 U - PC Tools v7+ CPSCHED - ENABLE/DISABLE CPSCHED API
	AX = FEC6h
	BL = new state (00h enabled, nonzero disabled)
Return: nothing
Desc:	specify whether CPSCHED API calls other than this one and AX=FE55h will
	  be honored
--------U-16FED3-----------------------------
INT 16 U - PC Tools v7+ CPSCHED/DESKTOP - ???
	AX = FED3h
	DS:SI -> 92-byte data record for ???
Return: ???
Note:	this function is identical to AX=FFD3h, and is implemented by the same
	  code in DESKTOP
SeeAlso: AX=FFD3h
--------U-16FEDC-----------------------------
INT 16 U - PC Tools v7+ CPSCHED - UNHOOK INTERRUPTS
	AX = FEDCh
Return: AX,DX destroyed
Index:	uninstall;CPSCHED
--------U-16FEEFCX0000-----------------------
INT 16 U - PC Tools v7+ CPSCHED/DESKTOP - INSTALLATION CHECK
	AX = FEEFh
	CX = 0000h
Return: CX = ABCDh if PC Tools scheduler (CPSCHED or DESKTOP) installed
	    BX = segment of resident portion
	    DX = (CPSCHED v8.0) resident CS
Note:	this function is identical to AX=FFD3h, and is implemented by the same
	  code in DESKTOP
SeeAlso: AX=FFEFh
--------U-16FEF1-----------------------------
INT 16 U - PC Tools v7 only CPSCHED/DESKTOP - ALTERNATE INSTALLATION CHECK
	AX = FEF1h
	BX = ???
Return: CX = 5555h if PC Tools scheduler (CPSCHED or DESKTOP) installed
	DX = 5555h
Note:	this function is identical to AX=FFD3h, and is implemented by the same
	  code in DESKTOP
SeeAlso: AX=FFF1h
--------K-16FF-------------------------------
INT 16 - KEYBOARD - KBUF extensions - ADD KEY TO TAIL OF KEYBOARD BUFFER
	AH = FFh
	DX = scan code
Return: AL = status
	    00h success
	    01h failure
Program: KBUF is a keyboard buffer expander by Mark Adler
SeeAlso: AH=05h
--------V-16FF-------------------------------
INT 16 - OPTIMA 1024 VGA-Sync,ET-3000 chipset - QUERY ZOOM INTERRUPT
	AH = FFh
Return: AL = interrupt number to which BIOS keyboard handler has been relocated
	AL+1 = Zoom interrupt number
	BX = hotkey
Notes:	the default interrupts are 60h for keyboard and 61h for Zoom interrupt;
	  the default hot key is F10
	not all vendors include the Tseng TSR which supports these functions
SeeAlso: INT 60"OPTIMA"
Index:	hotkeys;OPTIMA 1024 VGA
--------d-16FF70BX0000-----------------------
INT 16 U - PC Tools v8+ DRIVEMAP - INSTALLATION CHECK
	AX = FF70h
	BX = 0000h
	CX = 4C69h ('Li')
	DX = 6E6Bh ('nk')
Return: AX = 0000h
	CX = 4350h ('CP')
	DH = major version
	DL = minor version
Program: DRIVEMAP is a redirector which allows drives on computers connected
	  over the parallel or serial ports to appear as local drives
SeeAlso: AX=FF70h/BX=0001h,AX=FF70h/BX=0002h
--------d-16FF70BX0001-----------------------
INT 16 U - PC Tools v8+ DRIVEMAP - ???
	AX = FF70h
	BX = 0001h
	DL = ???
Return: AX = ???
	DH = ???
SeeAlso: AX=FF70h/BX=0000h,AX=FF70h/BX=0002h
--------d-16FF70BX0002-----------------------
INT 16 U - PC Tools v8+ DRIVEMAP - ???
	AX = FF70h
	BX = 0002h
	CX = ???
	DX = ???
Return: AX = ??? or FFFEh/FFFFh on error
	DL = ???
BUG:	DRIVEMAP will branch to random locations for BX values other than
	  those listed above for v8.0-9.0 because a) the incorrect register is
	  range-tested, resulting in BX=0003h-5CD6h being accepted as valid
	  function numbers, and b) the conditional which branches on invalid
	  function numbers jumps to the following instruction, becoming a NOP
SeeAlso: INT 2F/AX=9203h"DRIVEMAP"
Index:	installation check;DRIVEMAP
--------T-16FF80BX0000-----------------------
INT 16 U - PC Tools v8+ CPTASK - INSTALLATION CHECK
	AX = FF80h
	BX = 0000h
	CX = 0000h
	DX = 0000h
Return: CX = 5555h if installed
Program: CPTASK is a task switcher by Central Point Software
--------T-16FF80BX0001-----------------------
INT 16 U - PC Tools v8+ CPTASK - GET ???
	AX = FF80h
	BX = 0001h
	???
Return: DX:SI -> task list??? (ten entries of 70h bytes in v9.0)
	BX = ??? (PSP segment of resident code???)
--------T-16FF80BX0002-----------------------
INT 16 U - PC Tools v8+ CPTASK - GET ???
	AX = FF80h
	BX = 0002h
Return: DX:SI -> ???
--------T-16FF80BX0003-----------------------
INT 16 U - PC Tools v8+ CPTASK - GET ??? FLAGS
	AX = FF80h
	BX = 0003h
Return: AX = flags (see #0410)
SeeAlso: AX=FF80h/BX=0004h,AX=FF80h/BX=0006h

Bitfields for CPTASK flags:
Bit(s)	Description	(Table 0410)
 10	???
 13	???
 14	???
 15	???
--------T-16FF80BX0004-----------------------
INT 16 U - PC Tools v8+ CPTASK - SET ???
	AX = FF80h
	BX = 0004h
	CX = new value of ???
Return: ???
Note:	this function also sets bit 14 of the flags word returned by
	  AX=FF80h/BX=0003h
--------T-16FF80BX0005-----------------------
INT 16 U - PC Tools v8+ CPTASK - GET NUMBER OF ACTIVE TASKS???
	AX = FF80h
	BX = 0005h
Return: AX = number of active tasks???
--------T-16FF80BX0006-----------------------
INT 16 U - PC Tools v8+ CPTASK - GET AND CLEAR ??? FLAG
	AX = FF80h
	BX = 0006h
Return: AX = old state (0000h clear, 0001h set)
Note:	the tested flag is bit 13 of the flags returned by AX=FF80h/BX=0003h
--------T-16FF80BX0007-----------------------
INT 16 U - PC Tools v8+ CPTASK - ???
	AX = FF80h
	BX = 0007h
	ES:DI -> ???
	???
Return: ???
--------T-16FF80BX0008-----------------------
INT 16 U - PC Tools v8+ CPTASK - ???
	AX = FF80h
	BX = 0008h
	???
Return: ???
--------T-16FF80BX0009-----------------------
INT 16 U - PC Tools v8+ CPTASK - GET ???
	AX = FF80h
	BX = 0009h
Return: CL = ???
	CH = ??? (01h or 02h)
--------T-16FF80BX000A-----------------------
INT 16 U - PC Tools v9+ CPTASK - SET ???
	AX = FF80h
	BX = 000Ah
	DS:SI -> 128-byte buffer containing ???
--------T-16FF80BX000B-----------------------
INT 16 U - PC Tools v9+ CPTASK - SET ???
	AX = FF80h
	BX = 000Bh
	DX = index of ??? task (1-10)
--------T-16FF80BX000C-----------------------
INT 16 U - PC Tools v9+ CPTASK - SET IDLE??? DELAY
	AX = FF80h
	BX = 000Ch
	CX = new delay time in minutes
--------T-16FF80BX4350-----------------------
INT 16 U - PC Tools v8+ CPTASK - UNINSTALL
	AX = FF80h
	BX = 4350h ('CP')
	CX = 5354h ('ST')
Return: never returns; terminates all tasks and exits to program originally
	  calling CPTASK
--------U-16FF90-----------------------------
INT 16 U - PC Tools v8+ DESKTOP - ???
	AX = FF90h
	???
Return: ???
Note:	available only when popped up
--------U-16FF91-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - ???
	AX = FF91h
	???
Return: AX = 0000h
Note:	calls AX=FFFDh after ???
SeeAlso: AX=FF92h,AX=FFFDh
--------U-16FF92-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - ???
	AX = FF92h
	???
Return: AX = 0000h
Note:	like AX=FF91h, but temporarily sets ??? to 3
SeeAlso: AX=FF91h,AX=FFFDh
--------U-16FF93-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - SET ??? FLAG
	AX = FF93h
--------U-16FF94-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - SET ???
	AX = FF94h
	CX = ??? (default 0017h)
--------U-16FF95-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - SET ???
	AX = FF95h
	BX = ???
--------U-16FF96-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - ???
	AX = FF96h
	CL = ???
Return: AX = ???
--------U-16FF97-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - ???
	AX = FF97h
	DS:DX -> buffer for ??? (see #0411)
Return: ???

Format of PC Tools DESKTOP buffer:
Offset	Size	Description	(Table 0411)
 00h 48 BYTEs	???
 30h 128 BYTEs	???
--------U-16FF98-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - OPEN \DESK.OVL FILE AND SEEK TO OVERLAY
	AX = FF98h
	DX = byte offset in file of overlay header (see #0412)
Return: BX = file handle for DESK.OVL file
Desc:	open the DESK.OVL file, seek to the specified offset, read in the
	  overlay header, and seek to the offset specified by the header

Format of PC Tools DESKTOP overlay header:
Offset	Size	Description	(Table 0412)
 00h 12 BYTEs	NUL-padded ASCII overlay filename
 0Ch	DWORD	offset within DESK.OVL file of actual overlay
--------U-16FF99-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - ???
	AX = FF99h
	???
Return: ???
--------U-16FF9A-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - GET NAME OF COLOR SCHEME
	AX = FF9Ah
Return: ES:BX -> name of current color scheme
Note:	available even if not popped up
--------U-16FF9B-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - UNUSED
	AX = FF9Bh
Return: ???
Note:	sounds triple-length beep
--------T-16FF9C-----------------------------
INT 16 U - PC Tools v8+ CPTASK - SET/CLEAR ??? POINTER
	AX = FF9Ch
	BL = function
	    00h set ??? pointer
		DS:SI -> ???
	    01h clear pointer to 0000h:0000h
----------16FF9D-----------------------------
INT 16 U - PC Tools v8+ CPTASK, VSAFE - ???
	AX = FF9Dh
	ES:BX -> ??? word
Return: ???
Note:	if ES is non-zero, the word pointed at by ES:BX determines whether the
	  ??? flag is cleared (word = 0000h) or set (word is nonzero).	The
	  flag is always cleared if ES=0000h.
--------U-16FF9E-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - ???
	AX = FF9Eh
	DL = ???
	    bit 7: ???
	    bits 6-0: function number??? (00h,01h,other)
	???
Return: ???
--------U-16FFA1-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - ???
	AX = FFA1h
	???
Return: ???
Note:	same as AX=FFA2h, except ??? set to FFh
SeeAlso: AX=FFA2h
--------U-16FFA2-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - ???
	AX = FFA2h
	???
Return: ???
Note:	calls AX=FFC7h (remove window) and AX=FFFDh
SeeAlso: AX=FFA1h,AX=FFC7h,AX=FFFDh
--------y-16FFA3BX0000-----------------------
INT 16 U - PC Tools v7-8 DATAMON, v9+ DPROTECT - INSTALLATION CHECK
	AX = FFA3h
	BX = 0000h
	CX = 0000h
Return: AX = segment of resident code
	BX = 5555h
	CX = 5555h
Note:	also supported by DOS 6 UNDELETE which is licensed from PC Tools
SeeAlso: INT 21/AH=3Fh"NB.SYS",INT 21/AX=4101h,INT 2F/AX=6284h
--------y-16FFA3BX0001-----------------------
INT 16 U - PC Tools v7-8 DATAMON, v9+ DPROTECT - GET ???
	AX = FFA3h
	BX = 0001h
	CX = 0001h
Return: AX:BX -> ???
	CX = BX
--------y-16FFA3BX0002-----------------------
INT 16 U - PC Tools v7-8 DATAMON, v9+ DPROTECT - GET ???
	AX = FFA3h
	BX = 0002h
	CX = 0002h
Return: AX = ??? (0 or 1)
	CX = BX = AX
--------y-16FFA3BX0003-----------------------
INT 16 U - PC Tools v7-8 DATAMON, v9+ DPROTECT - GET ???
	AX = FFA3h
	BX = 0003h
	CX = 0003h
Return: AX = ??? (0 or 1)
	CX = BX = AX
--------y-16FFA3BX0004-----------------------
INT 16 U - PC Tools v7+ DATAMON - SET ??? FLAG
	AX = FFA3h
	BX = 0004h
	CX = 0004h
SeeAlso: AX=FFA3h/BX=0005h
--------y-16FFA3BX0005-----------------------
INT 16 U - PC Tools v7+ DATAMON - CLEAR ??? FLAG
	AX = FFA3h
	BX = 0005h
	CX = 0005h
SeeAlso: AX=FFA3h/BX=0004h
--------y-16FFA3BX0006-----------------------
INT 16 U - PC Tools v7+ DATAMON - SET PSP SEGMENT ???
	AX = FFA3h
	BX = 0006h
	CX = 0006h
	DX = current PSP segment as known to DOS??? or 0000h
----------16FFA3BXFFA3-----------------------
INT 16 U - PC Tools v9 DSKLIGHT - INSTALLATION CHECK
	AX = FFA3h
	BX = FFA3h
	CX = FFA3h
Return: BX = CX = 5555h if installed
	    AX = resident code segment
Program: DSKLIGHT is a TSR included with PC Tools v9+ which displays a disk-
	  access indicator on the screen; in v7 and v8, this function was
	  provided by DATAMON
Note:	DSKLIGHT chains to the previous handler if BX or CX is not FFA3h
--------U-16FFA4-----------------------------
INT 16 U - PC Tools v7-8 DESKTOP - ???
	AX = FFA4h
Return: ???
Notes:	available even when not popped up
	sets unknown flag if ??? conditions met
SeeAlso: AX=FEA4h
--------c-16FFA5CX1111-----------------------
INT 16 - PC-Cache v6+ - INSTALLATION CHECK
	AX = FFA5h
	CX = 1111h
Return: CH = 00h if installed
	    ES:DI -> internal data (see #0413)
	    CL = cache state
		01h enabled
		02h disabled
SeeAlso: INT 13/AH=27h,INT 13/AH=A0h,INT 21/AH=2Bh/CX=4358h

Format of PC-Cache internal data:
Offset	Size	Description	(Table 0413)
-1Ch 20 BYTEs	cached drive list, one byte per drive A: to T:
		each byte is either blank (20h) or drive letter (41h-54h)
 -8	BYTE	???
 -7	WORD	number of physical transfers (scaled down to 0000h-7FFFh)
 -5	WORD	number of saved transfers (scaled down to 0000h-7FFFh)
 -3   3 BYTEs	???
--------c-16FFA5CXAAAA-----------------------
INT 16 - PC-Cache v6+ - ENABLE DELAYED WRITES
	AX = FFA5h
	CX = AAAAh
Return: AX = ??? (apparently either 0000h or sectors_in_cache - 5)
SeeAlso: AX=FFA5h/CX=CCCCh
--------c-16FFA5CXCCCC-----------------------
INT 16 - PC-Cache v6+ - FLUSH CACHE AND DISABLE DELAYED WRITES
	AX = FFA5h
	CX = CCCCh
Return: AX = ??? (apparently either 0000h or sectors_in_cache - 5)
Note:	delayed writes are automatically disabled on EXECing
	  (see INT 21/AH=4Bh) a program named either WIN.CO? or DV.E??;
	  however, delayed writes are not automatically reenabled upon the
	  program's termination in v6.
SeeAlso: AX=FFA5h/CX=AAAAh,AX=FFA5h/CX=FFFFh
--------c-16FFA5CXDDDD-----------------------
INT 16 - PC-Cache v6+ - FLUSH AND DISABLE CACHE
	AX = FFA5h
	CX = DDDDh
SeeAlso: AX=FFA5h/CX=EEEEh,AX=FFA5h/CX=FFFFh
--------c-16FFA5CXEEEE-----------------------
INT 16 - PC-Cache v6+ - ENABLE CACHE
	AX = FFA5h
	CX = EEEEh
SeeAlso: AX=FFA5h/CX=DDDDh
--------c-16FFA5CXFFFF-----------------------
INT 16 - PC-Cache v6+ - FLUSH CACHE
	AX = FFA5h
	CX = FFFFh
SeeAlso: AX=FFA5h/CX=CCCCh,AX=FFA5h/CX=DDDDh,INT 13/AH=A1h
--------U-16FFA6-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - GET ???
	AX = FFA6h
Return: DS:SI -> ???
Note:	available only when popped up
--------U-16FFA7-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - GET ??? PATH
	AX = FFA7h
Return: DS:SI -> ASCIZ path (directory from which PCTools was run???)
--------U-16FFA8-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - ???
	AX = FFA8h
	DS:SI -> three consecutive ASCIZ strings for ??? (max 256 bytes total)
	???
Return: ???
Notes:	available only when popped up
	strings copied into internal buffer, among other actions
--------U-16FFA9-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - GET VERSION STRING
	AX = FFA9h
Return: DS:SI -> version string
--------U-16FFAA-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - ???
	AX = FFAAh
	???
Return: ???
Note:	available only when popped up
--------U-16FFAB-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - GET EDITOR SETTINGS???
	AX = FFABh
Return: DS:SI -> editor setting strings???
--------U-16FFAC-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - SET ???
	AX = FFACh
	DL = ???
Note:	available only when popped up
--------U-16FFAD-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - SET ???
	AX = FFADh
	DL = ???
--------U-16FFAE-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - GET ???
	AX = FFAEh
Return: AL = ???
--------U-16FFAF-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - SET ???
	AX = FFAFh
	DL = ???
--------U-16FFB0-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - SET ???
	AX = FFB0h
	BL = ???
--------U-16FFB1-----------------------------
INT 16 U - PC Tools v6.0-8.0 DESKTOP - ???
	AX = FFB1h
	???
Return: ???
--------U-16FFB2-----------------------------
INT 16 U - PC Tools v5.5-8.0 DESKTOP - GET ???
	AX = FFB2h
Return: DS:SI -> ???
--------U-16FFB3-----------------------------
INT 16 U - PC Tools v5.5-8.0 DESKTOP - ???
	AX = FFB3h
	???
Return: ???
Note:	available only when popped up
--------U-16FFB4-----------------------------
INT 16 U - PC Tools v5.5-8.0 DESKTOP - SET ??? FLAG
	AX = FFB4h
Note:	available only when popped up
SeeAlso: AX=FFBBh
--------U-16FFB5-----------------------------
INT 16 U - PC Tools v5.5-8.0 DESKTOP - GET/SET WINDOW PARAMETERS
	AX = FFB5h
	BX = window specifier (000Fh to 0019h) (see #0414)
	DX = 0000h get, nonzero = set
	ES:DI -> window parameter buffer (see #0415)
SeeAlso: AX=FFCBh

(Table 0414)
Values for PC Tools DESKTOP window specifier:
 000Fh	comm/FAX
 0014h	hotkey selection
 0015h	ASCII table
 0016h	system colors menu

Format of PC Tools DESKTOP window parameters:
Offset	Size	Description	(Table 0415)
 00h	BYTE	rows in window, not counting frame
 01h	BYTE	columns in window, not counting frame
 02h	BYTE	row number of top of window
 03h	BYTE	2*column number of left of window
 04h	BYTE	character attribute for ???
 05h	BYTE	character attribute for background/border
 06h	BYTE	character attribute for ???
 07h	DWORD	pointer to ??? on screen
 0Bh  4 BYTEs	???
 0Fh	BYTE	nonzero if window may be resized
Note:	if running in monochrome mode, character attributes at offsets 04h to
	  06h are stored unchanged, but attributes other than 07h, 0Fh, or 70h
	  are changed to 07h on reading
--------U-16FFB6-----------------------------
INT 16 U - PC Tools v5.5-8.0 DESKTOP - GET ???
	AX = FFB6h
Return: AH = ???
	AL = ???
--------U-16FFB7-----------------------------
INT 16 U - PC Tools v5.5-8.0 DESKTOP - GET/SET ???
	AX = FFB7h
	BX = direction
	    0000h copy to buffer
	    else  copy from buffer
	DS:SI -> 70-byte buffer with ???
Return: data copied
Note:	available only when popped up under v6.0+
--------U-16FFB8-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - GET/SET???
	AX = FFB8h
	BH = subfunction
	    00h get
		Return: BL = old value of ???
			CL = old value of ??? (v6.0+)
			CH = old value of ??? (v6.0+)
	    nonzero set
		BL = new value for ???
		CL = new value for ??? (v6.0+)
		CH = new value for ??? (v6.0+)
		DH = ???
		Return: AL = old value replaced by CL (v6.0+)
			AH = old value replaced by CH (v6.0+)
--------U-16FFB9-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFB9h
	???
Return: AX = ???
	CX = ???
	DS:SI -> ???
	ES:DI -> ???
--------U-16FFBA-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFBAh
	???
Return: AX = ???
Note:	available only when popped up
--------U-16FFBB-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - CLEAR ??? FLAG
	AX = FFBBh
Note:	available only when popped up
SeeAlso: AX=FFB4h
--------U-16FFBC-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - RESTORE ORIGINAL SCREEN???
	AX = FFBCh
--------U-16FFBD-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ??? DATABASE INDEXING MESSAGES
	AX = FFBDh
	???
Return: ???
--------U-16FFBE-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFBEh
	???
Return: ???
Note:	available only when popped up
--------U-16FFBF-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFBFh
	BX = DOS file handle to write on
	???
Return: ???
Note:	available only when popped up
--------U-16FFC0-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFC0h
	???
Return: AX = 0000h if successful
	AX = FFFFh on error
Note:	available only when popped up
--------U-16FFC1-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFC1h
	BL = ???
	ES:DI -> data structure (see #0416)
	???
Return: AX = ???
Note:	available only when popped up
SeeAlso: AX=FFC2h,AX=FFC3h

Format of PC Tools DESKTOP data structure:
Offset	Size	Description	(Table 0416)
 00h	WORD	???
 02h	WORD	???
 04h	WORD	???
 06h	WORD	???
 08h	WORD	???
 0Ah	BYTE	???
 0Bh	BYTE	??? (zero/nonzero)
---v7.1---
 0Ch	WORD	???
 0Eh	BYTE	???
 0Fh	WORD	???
 11h	WORD	???
	???
--------U-16FFC2-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFC2h
	BL = ???
	ES:DI -> data structure (see #0416)
	???
Return: AH = ???
	CX = ???
	DH = ???
	DL = ???
Note:	available only when popped up
SeeAlso: AX=FFC1h,AX=FFC3h
--------U-16FFC3-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFC3h
	BL = ???
	ES:DI -> data structure (see #0416)
	???
Return: AH = ???
	CX = ???
	DH = ???
	DL = ???
Note:	available only when popped up
SeeAlso: AX=FFC1h,AX=FFC2h
--------U-16FFC4-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - GET ???
	AX = FFC4h
Return: AL = ???
	BX = segment of scratch space???
	CX = segment of stored screen data (section covered by window???)
	DX = segment of window parameters for ???
	ES:BP -> ???
Note:	available only when popped up in versions prior to 6.0
--------U-16FFC5-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - CHECK WHETHER DESKTOP LOADED RESIDENT
	AX = FFC5h
Return: BL = Desktop state
	    00h if nonresident
	    nonzero if loaded resident
Note:	available only when popped up; should call AX=FFEFh first to ensure
	  that DESKTOP is active
SeeAlso: AX=FFEFh,AX=FFF3h
--------U-16FFC6-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - SET ???
	AX = FFC6h
	BL = new value for ???
--------U-16FFC7-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - REMOVE WINDOW
	AX = FFC7h
	???
Return: ???
--------U-16FFC8-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - GET ???
	AX = FFC8h
Return: DS:SI -> ???
Note:	valid only while popped up
--------U-16FFC9-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - COPY DATA TO CLIPBOARD
	AX = FFC9h
	DS:SI -> characters to store in clipboard
	CX = size in bytes
Return: CF set on error
Notes:	available only when popped up
	while copying, bytes of 00h and 0Ah are skipped
--------U-16FFCA-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - SET ???
	AX = FFCAh
	DX = ???
Return: AX destroyed
Note:	available only when popped up
--------U-16FFCB-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - SELECT WINDOW PARAMETERS???
	AX = FFCBh
	DX = window specifier???
Return: AX destroyed
Note:	available only when popped up
SeeAlso: AX=FFB5h
--------U-16FFCC-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - DISPLAY ASCIZ STRING CENTERED IN WINDOW
	AX = FFCCh
	DS:SI -> ASCIZ string
Return: AX = ???
	CX = ???
	ES:DI -> address past last character displayed (v5.1/5.5)
	      -> ??? on menu bar (v6.0)
--------U-16FFCD-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFCDh
	DS:DX -> ???
Return: ???
Note:	available only when popped up
--------U-16FFCE-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - SET ??? DELAYS
	AX = FFCEh
	CX = ???
Return: nothing???
--------U-16FFCF-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - CLOSE PRINTER/PRINT FILE
	AX = FFCFh
Note:	available only when popped up
--------U-16FFD0-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - PREPARE TO PRINT???
	AX = FFD0h
	???
Return: ???
Note:	available only when popped up
--------U-16FFD1-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - DISPLAY PRINT OPTIONS MENU
	AX = FFD1h
Return: BX = number of copies
	DX = destination
	    00h cancel
	    01h LPT1
	    02h LPT2
	    03h LPT3
	    04h COM1
	    05h COM2
	    06h disk file
Note:	available only when popped up
--------U-16FFD2-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFD2h
	BX = ???
Return: BL = ???
Note:	available only when popped up
--------U-16FFD3-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFD3h
	DS:SI -> 92-byte data record for ???
Return: ???
SeeAlso: AX=FED3h
--------U-16FFD4BH3C-------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - CREATE/OPEN/DELETE FILE
	AX = FFD4h
	BH = 3Ch create file (with no attributes)
	     3Dh open file
	     41h delete file
	BL = access mode
	     00h read only
	     01h write only
	     02h read/write
	DS:SI -> ASCIZ filename
Return: BX = file handle
	    0000h on error
Note:	operation is attempted in (in order) the directory from which the
	  desktop was started/run???, the directory specified with the
	  filename, X:\PCTOOLS\, and X:\
--------U-16FFD5-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFD5h
	???
Return: ???
Note:	available only when popped up
--------U-16FFD6-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFD6h
	BX = ???
	CX = ???
	DX = offset in ???
	???
Return: ???
Note:	available only when popped up
--------U-16FFD7-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFD7h
	???
Return: BL = ???
Note:	available only when popped up
--------U-16FFD8-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - SAFE CREATE FILE
	AX = FFD8h
	DS:BX -> ASCIZ filename
Return: BX = file handle
	    0000h on error
Note:	pops up confirmation menu if file already exists
	only available when popped up???
--------U-16FFD9-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - GET ???
	AX = FFD9h
Return: AX = ???
Note:	available only when popped up
--------U-16FFDA-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - GET NAME OF LAST FILE OPENED
	AX = FFDAh
	DS:SI -> ??? (v5.1/5.5 only)
Return: DS:SI -> filename
--------U-16FFDB-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - SET ???
	AX = FFDBh
	BL = ???
Note:	available only when popped up
--------U-16FFDC-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - UNHOOK
	AX = FFDCh
Return: interrupt vectors 09h, 10h (v6.0+), 16h, 1Ch, and 21h restored to
	  original values
Index:	uninstall;PC Tools DESKTOP
--------U-16FFDDBX0000-----------------------
INT 16 U - PC Tools v5.1+ PCShell API - INSTALLATION CHECK
	AX = FFDDh
	BX = 0000h
Return: CX = 5555h
	DX = 5555h if PCShell installed in resident mode
--------U-16FFDDBX0001-----------------------
INT 16 U - PC Tools v5.1+ PCShell API - REQUEST POP-UP
	AX = FFDDh
	BX = 0001h
Return: CF clear if request successful (PCShell will pop up)
	CF set on error
SeeAlso: AX=FFDDh/BX=0003h
--------U-16FFDDBX0002-----------------------
INT 16 U - PC Tools v5.1-5.5 PCShell API - GET ???
	AX = FFDDh
	BX = 0002h
Return: AL =
	    00h ???
	    01h ???
Note:	PCShell v6.0+ displays the error message "Incorrect PCRUN version",
	  awaits a keystroke, and aborts the current process
--------U-16FFDDBX0003-----------------------
INT 16 U - PC Tools v5.1+ PCShell API - REQUEST POP-UP
	AX = FFDDh
	BX = 0003h
SeeAlso: AX=FFDDh/BX=0001h
--------U-16FFDDBX0004-----------------------
INT 16 U - PC Tools v5.1+ PCShell API - GET ???
	AX = FFDDh
	BX = 0004h
Return: CF clear if successful
	    DS:SI -> ???
--------U-16FFDDBX0005-----------------------
INT 16 U - PC Tools v5.1+ PCShell API - ???
	AX = FFDDh
	BX = 0005h
	???
Return: ???
Note:	resets various variables if certain conditions are met
--------U-16FFDDBX0006-----------------------
INT 16 U - PC Tools v5.1+ PCShell API - ???
	AX = FFDDh
	BX = 0006h
	???
Return: ???
Note:	resets various variables if certain conditions are met
--------U-16FFDDBX0007-----------------------
INT 16 U - PC Tools v5.1+ PCShell API - SET ??? FLAG
	AX = FFDDh
	BX = 0007h
Return: CF clear if successful
SeeAlso: AX=FFDDh/BX=0008h
--------U-16FFDDBX0008-----------------------
INT 16 U - PC Tools v5.1+ PCShell API - CLEAR ??? FLAG
	AX = FFDDh
	BX = 0008h
Return: CF undefined
SeeAlso: AX=FFDDh/BX=0007h
--------U-16FFDDBX0009-----------------------
INT 16 U - PC Tools v6.0+ PCShell API - GET PCRUN PARAMETERS
	AX = FFDDh
	BX = 0009h
Return: CF clear if successful
	    DS:SI -> list of pointers (see #0417)

Format of PC Tools PCShell returned pointer list:
Offset	Size	Description	(Table 0417)
 00h	WORD	offset of WORD containing ???
 02h	WORD	offset of name of program to execute
 04h	WORD	offset of 80-byte buffer for ???
 06h	WORD	offset of buffer for ??? (length in WORD preceding buffer)
 08h	WORD	offset of buffer for ??? (length in WORD preceding buffer)
--------U-16FFDDBX000A-----------------------
INT 16 U - PC Tools v6.0+ PCRUN API - INSTALLATION CHECK
	AX = FFDDh
	BX = 000Ah
Return: CX = 5555h if running
	DX = 5555h
Note:	also sets a flag
--------U-16FFDDBX000B-----------------------
INT 16 U - PC Tools v6.0+ PCRUN API - ???
	AX = FFDDh
	BX = 000Bh
	???
Return: CX = 5555h if PCRUN active
	DX = 5555h
Note:	also clears flag set by AX=FFDDh/BX=000Ah
--------U-16FFDE-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - DISPLAY POPUP MENU
	AX = FFDEh
	DS:DX -> menu description (must be on a paragraph boundary)
Return: AX = ???
	    AL seems to be the number of the selected button
Note:	available only when popped up
SeeAlso: AX=FFEEh
--------U-16FFDF-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFDFh
	???
Return: ???
--------U-16FFE0-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFE0h
	CX = ???
	DX = ???
Note:	available only when popped up
--------U-16FFE1-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - BEEP
	AX = FFE1h
--------U-16FFE2-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFE2h
	DX = ???
Return: ???
Note:	available only when popped up
--------U-16FFE3-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - PRINT CHARACTER
	AX = FFE3h
	BL = character to print to currently open printer or print file
Return: CF set on error
Note:	available only when popped up
SeeAlso: INT 17/AH=00h
--------U-16FFE4-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFE4h
	DX = segment of ???
Return: ???
Note:	available only when popped up
--------U-16FFE5-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - POP UP FILE SELECTION MENU
	AX = FFE5h
	DS:SI -> ASCIZ wildcard filespec followed by ASCIZ menu title
	DX = segment of window parameters???
Return: AX = DOS file handle for file
		DS:DX -> filename???
	    FFFFh if function cancelled by user
Note:	available only when popped up
SeeAlso: AX=FFDAh
--------U-16FFE6-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - CHECK FOR AND GET KEYSTROKE
	AX = FFE6h
Return: AX = 0000h if no key available
	     else  BIOS keycode
Notes:	available only when popped up
	invokes INT 28 idle interrupt before checking for key
--------U-16FFE7-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFE7h
	BX = segment of ???
Return: ???
Note:	available only when popped up
--------U-16FFE8-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - DISPLAY NUMBER
	AX = FFE8h
	CX = number
	DH = attribute
	DS:SI -> destination for ASCII number
Return: DS:SI buffer filled in with alternating characters and attributes
--------U-16FFE9-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - GET FILE LIST???
	AX = FFE9h
Return: BX = segment of file/directory list (14 bytes per file, NUL-padded)
Note:	available only when popped up
--------U-16FFEA-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - DISPLAY COUNTED STRING
	AX = FFEAh
	DS:SI -> counted string (count byte followed by string)
Return: ???
Note:	available only when popped up
--------U-16FFEB-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFEBh
	???
Return: ???
--------U-16FFEC-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - GET KEY
	AX = FFECh
	DS:SI -> FAR routine to ???
	BX = ???
	???
Return: AX = keystroke
	    FFFFh if F10 pressed to go to menu
Notes:	available only when popped up
	invokes INT 28 while waiting for keystroke
	F10 is hotkey to Desktop menu
Index:	hotkeys;PC Tools DESKTOP
--------U-16FFED-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - GET ???
	AX = FFEDh
Return: AX = ???
Note:	available only when popped up
--------U-16FFEE-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - DEFINE PULLDOWN MENUS
	AX = FFEEh
	DS:SI -> pulldown menu system description (see #0418)
Return: AX destroyed
Notes:	available only when popped up
	if the accessory does not need any menu items of its own, it should
	  call AX=FFFAh instead
SeeAlso: AX=FFF7h,AX=FFFAh

Format of PC Tools DESKTOP pulldown menu system description:
Offset	Size	Description	(Table 0418)
 00h	WORD	offset of menu bar contents (counted string)
 02h	WORD	number of items on menu bar
 04h 10 BYTEs	scan codes for hotkeying to each of up to ten menu items
 0Eh 10 BYTEs	which character to highlight in each menu item (01h=first)
 18h	WORD	offset of first menu definition (see #0419)
 1Ah	WORD	offset of second menu definition
	...

Format of PC Tools DESKTOP menu definition:
Offset	Size	Description	(Table 0419)
 00h	WORD	offset of menu contents (see #0420)
 02h	WORD	number of entries in menu
 04h	for each entry:
		Offset	Size	Description
		 00h	BYTE	scancode of Alt-key to invoke entry
		 01h	BYTE	character to highlight (01h=first, etc)
		 02h	WORD	offset of FAR routine to handle selection

Format of PC Tools DESKTOP menu contents:
Offset	Size	Description	(Table 0420)
 00h	BYTE	number of lines in menu
 01h	BYTE	width of menu
 02h  N BYTEs	counted strings, one for each line in menu
--------U-16FFEFCX0000-----------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - INSTALLATION CHECK
	AX = FFEFh
	CX = 0000h
Return: CX = ABCDh if PC Tools DESKTOP.EXE installed
	    BX = segment of resident portion
	    AX = ??? (v5.1/5.5 only)
SeeAlso: AX=FEEFh,AX=FFC5h,AX=FFF3h
--------U-16FFF0-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - SET ???
	AX = FFF0h
	DX = ???
Return: AX destroyed
Note:	available only when popped up
--------U-16FFF1BX0000-----------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ALTERNATE INSTALLATION CHECK
	AX = FFF1h
	BX = 0000h  leave ??? flag as is
	    nonzero set ??? flag
Return: CX = 5555h if installed
	DX = 5555h
--------U-16FFF2-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - DISPLAY HELP LINE
	AX = FFF2h
	DS:SI -> ASCIZ function key label string (each label preceded by '[')
		or help text
Return: AX destroyed
Notes:	available only when popped up
	if the specified string does not start with '[', it is displayed
	  centered on the bottom line, else the function key labels are shown
--------U-16FFF3-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - PREPARE TO UNLOAD RESIDENT DESKTOP
	AX = FFF3h
Note:	releases any EMS being used; restores video mode, page, and cursor
	  shape; and restores interrupt vectors
SeeAlso: AX=FFC5h,AX=FFEFh
Index:	uninstall;PC Tools DESKTOP
--------U-16FFF4-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - ???
	AX = FFF4h
	???
Return: ???
Note:	available only when popped up
SeeAlso: AX=FFF6h
--------U-16FFF5-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - GET SCREEN ATTRIBUTE ARRAY
	AX = FFF5h
Return: ES:BX -> screen attributes data structure (see #0421)
	AL = ??? (v6.0+)

Format of PC Tools DESKTOP attribute data structure:
Offset	Size	Description	(Table 0421)
 -1	BYTE	attribute for desktop background
 00h	BYTE	attribute for normal characters on desktop menu
 01h	BYTE	attribute for highlighted characters on desktop menu
 02h  5 BYTEs	???
 07h	BYTE	attribute for dialog boxes
 08h 15 BYTEs	???
 17h	BYTE	attribute for message boxes
--------U-16FFF6-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - INVOKE NOTEPAD EDITOR
	AX = FFF6h
	DS = segment of editor buffer structure (see #0422)
	BX = ???
	DX = segment of window parameters structure (see #0415)
Return: ???
Note:	available only when popped up
SeeAlso: AX=FFF4h

Format of PC Tools DESKTOP editor buffer structure:
Offset	Size	Description	(Table 0422)
 00h	WORD	offset of current cursor position in buffer segment
 02h  2 BYTEs	???
 04h	WORD	offset of beginning of file data in buffer segment
 06h 10 BYTEs	???
 10h  N BYTEs	ASCIZ name of file being edited
--------U-16FFF7-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - PROCESS MENU BAR ENTRY???
	AX = FFF7h
	DS:SI -> ???
	???
Return: ???
Notes:	available only when popped up
	performs input processing on the menu bar set up with AX=FFEEh
SeeAlso: AX=FFEEh,AX=FFFBh
--------U-16FFF8-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - DRAW EMPTY WINDOW
	AX = FFF8h
	DS:0000h -> window parameters structure (see #0415)
	DS:BX -> DWORD to store address of ??? on screen
Return: ???
--------U-16FFF9-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - DEFINE SCREEN REFRESH ROUTINE
	AX = FFF9h
	ES:BX -> FAR routine to redisplay the utility's window
Note:	available only when popped up
--------U-16FFFA-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - DEFINE STANDARD PULLDOWN MENUS
	AX = FFFAh
Notes:	available only when popped up
	adds the "Window" option to the "Desktop" option which is the only one
	  available when no accessories are active.  Unlike AX=FFEEh, no
	  additional menu items are added between "Desktop" and "Window"
SeeAlso: AX=FFEEh,AX=FFFBh
--------U-16FFFB-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - PROCESS STANDARD MENU BAR
	AX = FFFBh
Return: ???
Notes:	available only when popped up
	performs input processing on the standard menu bar set up with AX=FFFAh
SeeAlso: AX=FFF7h
--------U-16FFFC-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - GET HOTKEYS AND KEYBOARD VECTOR
	AX = FFFCh
Return: ES:BX -> hotkey table (see #0423)
	DS:DX = original INT 09 vector

Format of PC Tools DESKTOP hotkey table:
Offset	Size	Description	(Table 0423)
 00h  2 BYTEs	scancode/shift state for desktop hotkey
 02h  2 BYTEs	scancode/shift state for clipboard paste key
 04h  2 BYTEs	scancode/shift state for clipboard copy key
 06h  2 BYTEs	scancode/shift state for screen autodial key
--------U-16FFFD-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - COPY ???
	AX = FFFDh
Return: AX destroyed
Note:	copies 4000 bytes from ??? to ??? under certain circumstances
SeeAlso: AX=FF91h,AX=FF92h
--------M-16FFFE-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - SHOW MOUSE CURSOR
	AX = FFFEh
SeeAlso: AX=FFFFh,INT 33/AX=0001h
--------M-16FFFF-----------------------------
INT 16 U - PC Tools v5.1-8.0 DESKTOP - HIDE MOUSE CURSOR
	AX = FFFFh
SeeAlso: AX=FFFEh,INT 33/AX=0002h
--------P-17----DX0ABC-----------------------
INT 17 - PRINTER - LPTx v5.x INSTALLATION CHECK
	DX = 0ABCh
Return: AX = AAAAh
	DX = BAAAh
	ES = code segment of resident portion
--------P-17----DX0B90-----------------------
INT 17 - PRINTER - LPTx v6.x INSTALLATION CHECK
	DX = 0B90h
Return: DX = ABBBh
	ES = code segment of resident portion
--------P-17----DX0B91-----------------------
INT 17 - PRINTER - LPTx v7.x INSTALLATION CHECK
	DX = 0B91h
Return: DX = ABCBh
	ES = code segment of resident portion
--------P-17----DX0F5F-----------------------
INT 17 - PRINTER - LPTx v4.x INSTALLATION CHECK
	DX = 0F5Fh
Return: AX = AAAAh
	DX = F555h
	ES = code segment of resident portion
--------B-1700-------------------------------
INT 17 - PRINTER - WRITE CHARACTER
	AH = 00h
	AL = character to write
	DX = printer number (00h-02h)
Return: AH = printer status (see #0424)
SeeAlso: AH=02h,AH=84h"AX",AH=F1h,INT 16/AX=FFE3h,INT 1A/AH=11h"NEC"

Bitfields for printer status:
Bit(s)	Description	(Table 0424)
 7	not busy
 6	acknowledge
 5	out of paper
 4	selected
 3	I/O error
 2-1	unused
 0	timeout
--------B-1701-------------------------------
INT 17 - PRINTER - INITIALIZE PORT
	AH = 01h
	DX = printer number (00h-02h)
Return: AH = printer status (see #0424)
Note:	some printers report that they are ready immediately after
	  initialization when they actually are not; a more reliable result may
	  be obtained by calling AH=02h after a brief delay
SeeAlso: AH=02h,AH=FFh"PC-MOS",INT 1A/AH=10h"NEC"
--------B-1702-------------------------------
INT 17 - PRINTER - GET STATUS
	AH = 02h
	DX = printer number (00h-02h)
Return: AH = printer status (see #0424)
Note:	PRINTFIX from MS-DOS 5.0 hooks this function and always returns AH=90h
SeeAlso: AH=01h,AH=F2h,INT 1A/AH=12h"NEC"
--------P-1702--DX0000-----------------------
INT 17 - INSET - INSTALLATION CHECK
	AH = 02h
	DX = 0000h
	CX = 07C3h (1987d)
Return: CX = 07C2h (1986d) if installed
Program: INSET is a text/graphics integration program
--------b-170200BX5050-----------------------
INT 17 - Advanced Parallel Port BIOS - INSTALLATION CHECK
	AX = 0200h
	BX = 5050h ('PP')
	CH = 45h   ('E')
	DX = printer port number (00h-02h)
Return: AH = 00h      \
	AL = 45h       If Advanced BIOS Installed
	CX = 5050h    /
	DX:BX -> far entry point to Advanced BIOS
Program: The Advanced Parallel Port BIOS provides support for parallel
	  port peripherals using the enhanced modes of the IEEE 1284.
--------P-1703-------------------------------
INT 17 U - Emulaser ELTSR - INSTALL INTERRUPT HANDLERS
	AH = 03h
Return: BX = ???
	CX = ???
Program: ELTSR is the resident portion of the Emulaser PostScript emulator by
	  Vertisoft Systems, Inc.
SeeAlso: AH=04h"Emulaser",AH=0Eh,INT 1A/AH=E5h
--------c-1703-------------------------------
INT 17 - PC-MOS/386 v5.01 - PRINT SPOOLER - PRINT STRING
	AH = 03h
	DX = printer port number
	CX = number of characters to print
	DS:SI -> string
Return: AH = printer status (see #0424)
	CX = number of characters actually printed
Desc:	send an entire string of chars to the print spooler with a single call
Program: PC-MOS/386 v5.01 is a multitasking, multiuser MS-DOS 5.0-compatible
	  operating system by The Software Link, Inc.
SeeAlso: AH=00h,AH=01h,AH=02h,AH=FFh"PC-MOS"
--------P-1704-------------------------------
INT 17 U - Emulaser ELTSR - BEGIN CAPTURING OUTPUT
	AH = 04h
Note:	has no effect unless ELTSR is deactivated (see AX=0503h)
SeeAlso: AH=03h"Emulaser",AX=0503h,INT 1A/AH=E5h
--------P-170500-----------------------------
INT 17 U - Emulaser ELTSR - ???
	AX = 0500h
	???
Return: AX = unload status (0001h safe to unload, 0002h not safe)
	BX = ???
	CX = PSP segment of ELTSR
	DX = activity flag (0000h disabled, 0001h capturing, 0002h ???printing)
	SI = ???
	DI = ???
SeeAlso: AH=04h,INT 1A/AH=E5h
--------P-170501-----------------------------
INT 17 U - Emulaser ELTSR - UNHOOK INTERRUPTS
	AX = 0501h
Return: (see AX=0500h)
Note:	restores interrupt vectors without checking whether they have been
	  hooked by later programs; should only be called if ELTSR reports
	  that it is safe to unload
SeeAlso: AH=04h,AX=0500h,AX=0503h,INT 1A/AH=E5h
Index:	uninstall;Emulaser ELTSR
--------P-170502-----------------------------
INT 17 U - Emulaser ELTSR - SET ???
	AX = 0502h
	BL = Emulaser port (31h = LPT1, 32h = LPT2, 33h = LPT3)
	CL = ???
	DL = ???
Return: (see AX=0500h)
SeeAlso: AH=04h,AX=0500h,INT 1A/AH=E5h
--------P-170503-----------------------------
INT 17 U - Emulaser ELTSR - DEACTIVATE???
	AX = 0503h
Return: (see AX=0500h)
SeeAlso: AH=04h,AX=0500h,AX=0501h,INT 1A/AH=E5h
--------P-1706-------------------------------
INT 17 U - Emulaser ELTSR - ???
	AH = 06h
	???
Return: ???
SeeAlso: AH=05h,INT 1A/AH=E5h
--------P-1707-------------------------------
INT 17 U - Emulaser ELTSR - OPEN CAPTURE FILE
	AH = 07h
	ES:DX -> ASCIZ filename to be opened
Return: ???
Note:	new output will be appended to the specified file
SeeAlso: AH=08h,INT 1A/AH=E5h
--------P-1708-------------------------------
INT 17 U - Emulaser ELTSR - CLOSE CAPTURE FILE
	AH = 08h
	???
Return: ???
Desc:	close the file previously opened by function 07h
SeeAlso: AH=07h,INT 1A/AH=E5h
--------P-1709-------------------------------
INT 17 U - Emulaser ELTSR - PRINT CAPTURE FILE???
	AH = 09h
	BX = ???
	CX = ???
	DX = printer port (01h COM1, 02h COM2, 05h LPT1, 06h LPT2)
Return: AX = status
	    00h successful
	    FFh failed
Program: ELTSR is the resident portion of the Emulaser PostScript emulator by
	  Vertisoft Systems, Inc.
Note:	this function calls through to INT 1A/AX=E401h, and thus requires
	  that either ELSPL or Disk Spool II be installed
SeeAlso: AH=0Ah,INT 1A/AX=E401h,INT 1A/AH=E5h
--------P-170A-------------------------------
INT 17 U - Emulaser ELTSR - SET ??? FILENAME
	AH = 0Ah
	ES:BX -> ??? buffer
	CX = length of ??? buffer
Return: ???
Note:	copies the specified name into the buffer passed to ELSPL as the
	  filename by AH=09h
SeeAlso: AH=09h,INT 1A/AH=E5h
--------P-170B-------------------------------
INT 17 U - Emulaser ELTSR - GET ???
	AH = 0Bh
Return: AX:BX -> ???
SeeAlso: AH=0Ah,INT 1A/AH=E5h
--------P-170C-------------------------------
INT 17 U - Emulaser ELTSR - SET ??? FLAG
	AH = 0Ch
	???
Return: ???
SeeAlso: AH=0Bh,INT 1A/AH=E5h
--------P-170D-------------------------------
INT 17 U - Emulaser ELTSR - GET TRUE ScrlLk STATE
	AH = 0Dh
Return: AX = state (0000h off, 0010h on)
Desc:	determine the actual state of ScrlLk even when Emulaser is controlling
	  the ScrlLk light as its activity indicator
SeeAlso: AH=0Ch,INT 16/AH=02h,INT 1A/AH=E5h
--------P-170E-------------------------------
INT 17 U - Emulaser ELTSR - BACKGROUND PROCESSING
	AH = 0Eh
Program: ELTSR is the resident portion of the Emulaser PostScript emulator by
	  Vertisoft Systems, Inc.
Note:	this function is called by ELTSR on every INT 08 to allow data to be
	  processed in the background, but may also be called by applications
	  to give Emulaser additional CPU time
SeeAlso: AH=0Dh,INT 1A/AH=E5h
--------P-172000-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - INSTALLATION CHECK
	AX = 2000h
	BL = printer number???
Return:	AX = status (see #0425)
	BX = driver version number (BH=major,BL=minor)
	CH = ??? (00h)
	CL = ???
	DX = ??? (0100h)
Note:	also enables the remaining printer driver functions (2001h-2007h)
SeeAlso: AX=2001h,AX=2002h,AX=2003h,AX=2004h,AX=2005h,AX=2006h,AX=2007h

(Table 0425)
Values for PC Paint function status:
 0000h	successful
 0001h	invalid printer???
 0002h	???
 0003h	invalid subfunction
 0005h	driver disabled, must call function 00h first
 0009h	unknown printer error
 000Bh	printer not selected
 000Ch	printer out of paper
 000Eh	error while writing to serial printer
 000Fh	???
 0010h	invalid function number
 0011h	value out of range
--------P-172001-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - SET ??? FLAG
	AX = 2001h
	BL = printer number???
Return: AX = status (see #0425)
--------P-172002-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - GET INFORMATION
	AX = 2002h
	BL = printer number???
	CL = desired information
	    00h printer type
		Return: ES:DI -> ASCIZ printer name
	    01h paper size
		DX = size index
		Return: ES:DI -> ASCIZ paper size description
	    02h ???
		Return: BX = ???
	    03h printer information???
		DX = ???
		ES:BX -> buffer for ??? (min 134 bytes)
Return: AX = status (see #0425)
SeeAlso: AX=2000h,AX=2004h
--------P-172003-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - ???
	AX = 2003h
	ES:BX -> ???
Return: AX = status (see #0425)
SeeAlso: AX=2000h,AX=2004h
--------P-172004-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - GET ???
	AX = 2004h
	BL = printer number???
Return: AX = status (see #0425)
	ES:DI -> ???
SeeAlso: AX=2000h,AX=2003h
--------P-172005-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - ADVANCE PRINTER TO NEXT PAGE
	AX = 2005h
	BL = printer number???
Return: AX = status (see #0425)
Note:	this function also clears the flag set by AX=2001h
SeeAlso: AX=2000h,AX=2001h,AX=2006h
--------P-172006-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - ADVANCE TO NEXT PAGE & SHUT DOWN
	AX = 2006h
	BL = printer number???
Return: AX = status (see #0425)
Note:	this function also clears the flag set by AX=2001h and disables
	  functions other than AX=2000h
SeeAlso: AX=2000h,AX=2001h,AX=2005h
--------P-172007-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - UNIMPLEMENTED
	AX = 2007h
Return: AX unchanged
SeeAlso: AX=2000h
--------N-172400-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - ENABLE/DISABLE API FUNCTIONS
	AX = 2400h
	DL = new state
	    00h disabled
	    01h enabled
Return: DL = 24h if installed
	DH = minor version number
	CX = network address of this machine
	AL = status (see #0426)
SeeAlso: AX=2403h,INT 16/AX=4500h

(Table 0426)
Values for NET.24 function status:
 00h	successful
 01h	timeout
 02h	header error
 03h	data error
 04h	busy
 05h	invalid parameters
--------N-172401-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - RECEIVE BLOCK, NO HANDSHAKE
	AX = 2401h
	BL = timeout in clock ticks
Return: AL = status (see #0426)
	DX:BX -> receive buffer
SeeAlso: AX=2402h,AX=2404h,AX=2408h
--------N-172402-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - TRANSMIT BLOCK, NO HANDSHAKE
	AX = 2402h
	transmit buffer filled (see AX=2403h)
Return: AL = status (see #0426)
SeeAlso: AX=2401h,AX=2403h,AX=2404h,AX=2409h
--------N-172403-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - GET STATUS AND TRANSMISSION BUFFER
	AX = 2403h
Return: AL = status (see #0426)
	CX = number of characters in receive ring buffer
	DX:BX -> transmit buffer
SeeAlso: AX=2400h,AX=2402h
--------N-172404-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - SEND ACK BLOCK
	AX = 2404h
	BX = target address
Return: AL = status (see #0426)
SeeAlso: AX=2402h,AX=2405h
--------N-172405-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - SEND NAK BLOCK
	AX = 2405h
	BX = target address
Return: AL = status (see #0426)
SeeAlso: AX=2402h,AX=2404h
--------N-172406-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - PREPARE CHARACTER-ORIENTED RECEIVE
	AX = 2406h
Return: AL = status (see #0426)
SeeAlso: AX=2407h,AX=240Ah
--------N-172407-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - RECEIVE CHARACTER FROM REMOTE
	AX = 2407h
Return: AL = status (see also #0426)
	    06h end of data
	DL = received character
SeeAlso: AX=2406h
--------N-172408-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - RECEIVE BLOCK, WITH HANDSHAKE
	AX = 2408h
Return: AL = status (see also #0426)
	    06h end of data
	CX = number of bytes in receive buffer
	DX:SI -> receive buffer
SeeAlso: AX=2401h,AX=2405h,AX=2409h
--------N-172409-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - TRANSMIT COMMAND, WITH HANDSHAKE
	AX = 2409h
	BX = target address
	CX = number of data bytes
	DL = command code to send
	DS:SI -> data bytes for command
Return: AL = status (see also #0426)
	    03h no response
	    06h remote currently unable to perform command
SeeAlso: AX=2405h,AX=2408h
--------N-17240A-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - PREPARE CHARACTER-ORIENTED TRANSMIT
	AX = 240Ah
Return: AL = status (see #0426)
SeeAlso: AX=2406h,AX=240Bh,AX=240Ch
--------N-17240B-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - TRANSMIT SINGLE CHARACTER TO REMOTE
	AX = 240Bh
	DL = character to send
Return: AL = status (see also AX=2400h)
	    03h transmission error
	    06h write error
SeeAlso: AX=2407h,AX=240Ah,AX=240Ch
--------N-17240C-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - END CHARACTER-ORIENTED TRANSMIT
	AX = 240Ch
Return: AL = status (see also AX=2400h)
	    03h transmission error
	    06h remote breaks connection
SeeAlso: AX=240Ah,AX=240Bh
--------J-175000-----------------------------
INT 17 - AX (Japanese AT) PRINTER - SET PRINTER COUNTRY CODE
	AX = 5000h
	BX = country code
	    0001h USA (English), 0051h Japan
Return: AL = status
	    00h successful
	    01h bad country code
	    02h other error
SeeAlso: AX=5001h,AH=51h,INT 10/AX=5000h,INT 16/AX=5000h
--------J-175001-----------------------------
INT 17 - AX (Japanese AT) PRINTER - GET PRINTER COUNTRY CODE
	AX = 5001h
Return: AL = status
	    00h successful
		BX = country code
	    02h error
SeeAlso: AX=5000h,AH=51h,INT 10/AX=5001h,INT 16/AX=5001h
--------J-1751-------------------------------
INT 17 - AX (Japanese AT) PRINTER - JIS to Shift-JIS CONVERSION
	AH = 51h
	DX = 2-byte JIS code
Return: DX = shift-JIS value or 0000h on error
Note:	one of AH=51h and AH=52h converts from JIS (Japanese Industry Standard)
	  characters to Shift-JIS characters, and the other performs the
	  opposite conversion
SeeAlso: AX=5000h,AH=52h
--------J-1752-------------------------------
INT 17 - AX (Japanese AT) PRINTER - Shift-JIS to JIS CONVERSION
	AH = 52h
	DX = 2-byte shift-JIS code
Return: DX = JIS code or 0000h on error
Note:	one of AH=51h and AH=52h converts from JIS (Japanese Industry Standard)
	  characters to Shift-JIS characters, and the other performs the
	  opposite conversion
SeeAlso: AH=51h
--------V-1760-------------------------------
INT 17 - FLASHUP.COM - INSTALLATION CHECK
	AH = 60h
Return: AL = 60h
	DX = CS of resident code
Notes:	FLASHUP.COM is part of Flash-Up Windows by The Software Bottling Co.
	FLASHUP also hooks INT 10 and receives commands via INT 10/AH=09h,0Ah
	  consisting of an 80h followed by the actual command
SeeAlso: INT 10/AH=09h,INT 10/AH=0Ah
--------V-1761-------------------------------
INT 17 - SPEEDSCR.COM - INSTALLATION CHECK
	AH = 61h
Return: AL = 61h
	DX = CS of resident code
Note:	SPEEDSCR.COM is by The Software Bottling Co.
--------P-1762-------------------------------
INT 17 U - T2PS v1.0 - UNINSTALL
	AH = 62h
Return: nothing
SeeAlso: AH=63h,AH=64h,INT 05/AX=554Eh
--------P-1763-------------------------------
INT 17 U - T2PS v1.0 - SET PARAMETERS
	AH = 63h
	ES:SI -> settings (see #0427)
Program: T2PS is a shareware ASCII-to-PostScript converter by A.N.D.
	  Technologies
SeeAlso: AH=62h,AH=64h,INT 05/AX=4E57h

Format of T2PS settings:
Offset	Size	Description	(Table 0427)
 00h	WORD	LPT port number (0=LPT1, etc.)
 02h	WORD	page heigh in points
 04h	WORD	page width in points
 06h	WORD	top margin in points
 08h	WORD	bottom margin in points
 0Ah	WORD	left margin in points
 0Ch	WORD	right margin in points
 0Eh	WORD	font size in points
 10h	WORD	tab size
 12h	WORD	timeout in clock ticks
--------P-1764-------------------------------
INT 17 U - T2PS v1.0 - GET PARAMETERS
	AH = 64h
	ES:SI -> buffer for settings (see #0427)
Return: ES:SI buffer filled
SeeAlso: AH=62h,AH=63h,INT 05/AX=5053h
--------N-1781-------------------------------
INT 17 - Alloy NTNX, MW386 - CANCEL JOBS FOR CURRENT USER
	AH = 81h
	AL = 00h (NTNX compatibility mode)
	CL = number of jobs to cancel
Return: AL = status (see #0428)
Note:	this function cancels the last CL printouts for the current task
SeeAlso: AH=82h

(Table 0428)
Values for Alloy status:
 00h	success
 01h-7Fh warning
 80h	general failure
 81h	host overloaded (NTNX only)
 82h	module busy (NTNX only)
 83h	host busy (NTNX only)
 84h	re-entry flag set
 85h	invalid request
 86h	invalid printer
 87h	invalid process ID
 89h	access denied
 8Ah	option not available for given port type
 8Bh	option not available for given task type
 91h	printer busy
 C2h	file not found
 C3h	path not found
 C4h	file access failure
--------N-1782-------------------------------
INT 17 - Alloy NTNX, MW386 - CANCEL ALL JOBS FOR CURRENT USER
	AH = 82h
	AL = 00h (NTNX compatibility mode)
Return: AL = status (see #0428)
SeeAlso: AH=81h
--------N-1783-------------------------------
INT 17 - Alloy NTNX, MW386 - SET NUMBER OF COPIES
	AH = 83h
	AL = mode
	    00h NTNX compatibility
		CL = number of copies (max 99, default 1)
	    02h MW386 v2+
		BX = logical device number
		    00h-03h = LPT1-LPT4
		    04h-07h = COM1-COM4
		CX = number of copies
Return: AL = status (see #0428)
Note:	in NTNX compatibility mode, this function only affects LPT1
--------N-1784-------------------------------
INT 17 - Alloy NTNX, MW386 - GENERATE PRINT BREAK
	AH = 84h
	AL = mode
	    00h NTNX compatibility
	    02h MW386 v2+
		BX = logical device number
		    00h-03h = LPT1-LPT4
		    04h-07h = COM1-COM4
Note:	closes spool file and tells spooler to queue the print job (LPT1 only
	  under MW386 in NTNX compatibility mode)
--------J-1784-------------------------------
INT 17 - AX (Japanese AT) PRINTER - OUTPUT CHARACTER WITHOUT CONVERSION
	AH = 84h
	AL = character
	DX = printer number
Return: AH = printer status (see #0424)
SeeAlso: AH=00h,AH=85h
--------J-1785-------------------------------
INT 17 - AX (Japanese AT) PRINTER - ENABLE/DISABLE CHARACTER CONVERSION
	AH = 85h
	AL = new state (00h enabled, 01h disabled)
SeeAlso: AH=84h"AX"
--------N-1787-------------------------------
INT 17 - Alloy NTNX - SET INDOS POINTER
	AH = 87h
	AL = 00h
	CX:BX -> buffer for user-written printer drivers
Return: BX,CX destroyed
Note:	must be executed before the printer is enabled
SeeAlso: AH=8Ah
--------N-1788-------------------------------
INT 17 - Alloy NTNX, MW386 - REMOVE PRINTER FROM SPOOLER
	AH = 88h
	AL = mode
	    00h NTNX compatibility
		DX = NTNX printer number (see #0429)
	    01h MW386
		DX = MW386 printer number
Return: AH = status (see #0428)
Note:	removes specified printer from the spooler's list of printers
SeeAlso: AH=89h,AH=8Bh

(Table 0429)
Values for Alloy NTNX printer number:
 00h	host LPT1
 01h	host LPT2
 02h	host LPT3
 03h	host LPT4
 04h	host COM1
 05h	host COM2
 06h	user's logical COM2
 07h	user's terminal AUX port
 08h	user's logical COM1 (MW386 only)
--------N-1789-------------------------------
INT 17 - Alloy NTNX, MW386 - ADD PRINTER TO SPOOLER
	AH = 89h
	AL = mode
	    00h NTNX compatibility
		DX = NTNX printer number (see #0429)
	    01h MW386
		DX = MW386 printer number
Return: AL = status (see #0428)
Note:	the specified printer is added to the spooler's list of available
	  printers
SeeAlso: AH=88h,AH=8Bh
--------N-178A-------------------------------
INT 17 - Alloy NTNX - ACTIVATE USER-WRITTEN PRINTER DRIVER
	AH = 8Ah
	???
SeeAlso: AH=92h
--------N-178B-------------------------------
INT 17 - Alloy MW386 - GET PHYSICAL DEVICE NUMBER FROM NAME
	AH = 8Bh
	DS:DX -> ASCIZ printer name
Return: AL = status (see also AH=81h)
	    00h successful
		DX = physical device number
SeeAlso: AH=89h,AH=8Ch,INT 14/AH=20h"Alloy"
--------N-178C-------------------------------
INT 17 - Alloy MW386 - GET DEVICE NAME FROM PHYSICAL DEVICE NUMBER
	AH = 8Ch
	DX = physical device number
	ES:DI -> 17-byte buffer for ASCIZ device name
Return: AL = status (see also AH=81h)
	    00h successful
		ES:DI buffer filled
SeeAlso: AH=88h,AH=8Bh
--------N-178D-------------------------------
INT 17 - Alloy NTNX,MW386 - RESET SPOOLER
	AH = 8Dh
	AL = 00h
Return: AL = status (see #0428)
Notes:	clears all buffers and resets spooler to boot-up values
	MW386 supports this function for compatibility only; it is a NOP
--------N-178E-------------------------------
INT 17 - Alloy NTNX - GET INT 28 ENTRY POINT
	AH = 8Eh
	AL = 00h
Return: CX:BX -> INT 28 entry point
SeeAlso: AH=8Fh
--------N-178F-------------------------------
INT 17 - Alloy NTNX - GET DOS INTERCEPT ENTRY POINT
	AH = 8Fh
	AL = 00h
Return: CX:BX -> DOS intercept routine
SeeAlso: AH=8Eh
--------N-1790-------------------------------
INT 17 - Alloy NTNX, MW386 - SPOOL FILE BY NAME
	AH = 90h
	AL = mode
	    00h NTNX compatibility
		DL = printer code (FFh=current) (NTNX, MW386 v1.x only)
		DH = number of copies (FFh=current) (NTNX, MW386 v1.x only)
	    02h MW386 v2+
		BX = logical device number
		    00h-03h = LPT1-LPT4
		    04h-07h = COM1-COM4
	CX:SI -> ASCIZ pathname
Return: AL = status (see #0428)
Note:	in mode 00h, the file is always sent to logical LPT1
SeeAlso: AH=A0h
--------N-1791-------------------------------
INT 17 - Alloy NTNX, MW386 - GET USER NUMBER AND CURRENT PRINTER
	AH = 91h
	AL = mode
	    00h NTNX compatibility
		Return: CX = user number (00h = host)
			DX = currently selected printer number (00h-08h)
	    01h MW386
		Return: CX = user number
			DX = physical dev number of currently selected printer
	    02h MW386 v2+
		BX = logical device number
		    00h-03h = LPT1-LPT4
		    04h-07h = COM1-COM4
		Return: CX = user number
			DX = physical device number
Return: AL = status (see #0428)
SeeAlso: AH=8Ch
--------N-1792-------------------------------
INT 17 - Alloy NTNX - CHECK PRINTER DRIVER
	AH = 92h
	AL = 00h
	CL = 00h
Return: CL = driver state
	    01h initialized
	    80h not initialized
	AX = status (see #0428)
SeeAlso: AH=8Ah
--------N-1794-------------------------------
INT 17 - Alloy NTNX, MW386 - SELECT PRINTER
	AH = 94h
	AL = mode
	    00h NTNX compatibility
		DX = NTNX printer number (see #0429)
	    01h MW386
		DX = MW386 printer number
	    02h MW386 v2+
		BX = logical printer number
		DX = MW386 printer number
Return: AL = status (see #0428)
Note:	modes 00h and 01h affect only logical LPT1
SeeAlso: AH=8Bh,AH=95h
--------N-1795-------------------------------
INT 17 - Alloy NTNX, MW386 - GET CURRENT PRINTER
	AH = 95h
	AL = mode
	    00h NTNX compatibility
		Return: DX = NTNX printer number (see #0429)
			    (FFFFh if current printer not compatible with NTNX)
	    01h MW386
		Return: DX = MW386 printer number
	    02h MW386 v2+
		BX = logical device number
		    00h-03h = LPT1-LPT4
		    04h-07h = COM1-COM4
		Return: DX = MW386 printer number (FFFFh = none)
Return: AL = status (see #0428)
Note:	modes 00h and 01h return the printer number of logical LPT1 only
SeeAlso: AH=94h
--------N-1796-------------------------------
INT 17 - Alloy NTNX - SET SERIAL PORT PARAMETERS
	AH = 96h
	AL = 00h
Note:	documentation states that this is a NOP, doing only XOR AX,AX before
	  returning
SeeAlso: INT 14/AH=24h
--------N-1797-------------------------------
INT 17 - Alloy NTNX, MW386 - SET DATA DRIVEN PRINT BREAK
	AH = 97h
	AL = mode
	    00h NTNX compatibility
	    02h MW386 v2+
		BX = logical device number
		    00h-03h = LPT1-LPT4
		    04h-07h = COM1-COM4
	CH,CL,DH = three character break sequence
	DL = subfunction
	    00h set break string
	    else reset break
Return: AL = status (see #0428)
Notes:	mode 00h affects only logical LPT1
	when the break string is encountered, the spool file will be closed and
	  queued for printing automatically
	the break string is not permanently saved, and will be reset each time
	  MW386 or the user is rebooted
SeeAlso: AH=9Bh
--------N-1798-------------------------------
INT 17 - Alloy NTNX,MW386 - RESTART PRINTER
	AH = 98h
	AL = 00h
	DL = printer number (FFh=current)
Return: AL = status
	    00h successful
	    01h incorrect printer
	    02h task not found
Note:	MW386 supports this function for compatibility only; it is a NOP
--------N-1799-------------------------------
INT 17 - Alloy NTNX, MW386 - GET/SET PRINTER MODE
	AH = 99h
	AL = mode
	    00h NTNX compatibility
		DL = NTNX printer number (see #0429)
			(FFh = task's current logical LPT1)
		DH = mode (see #0430)
	    01h MW386
		DX = MW386 printer number
		CL = mode (as for DH above)
Return: AL = status (see #0428)
	DH = mode (bits 1 and 2 set as above)
	DL = printer owner's user number if not spooled

Bitfields for Alloy printer mode:
 0	get mode if 1, set mode if 0	(Table 0430)
 1	private ("attached")
 2	direct instead of spooled
 3-7	reserved (0)
--------N-179A-------------------------------
INT 17 - Alloy NTNX,MW386 - SET TAB EXPANSION
	AH = 9Ah
	AL = mode
	    00h NTNX compatibility
		DX = NTNX printer number (see #0429)
			(FFFFh = current logical LPT1)
	    01h MW386
		DX = MW386 printer number
	CL = tab length (00h = no expansion, 01h-63h = spaces per tab)
Return: AL = status (see #0428)
Note:	beginning with MW386 v2.0, tab expansion is set on a per-printer basis
	  rather than a per-user basis; NTNX and MW386 v1.x ignore DX
SeeAlso: AH=A4h
--------N-179B-------------------------------
INT 17 - Alloy NTNX,MW386 - SET PRINT BREAK TIMEOUT
	AH = 9Bh
	AL = mode
	    00h NTNX compatibility
		CX = timeout value in clock ticks (1/18 sec) (00h = never)
	    01h MW386
		CX = timeout value in seconds (00h = never)
	    02h MW386 v2+
		BX = logical device number
		    00h-03h = LPT1-LPT4
		    04h-07h = COM1-COM4
		CX = timeout value in seconds (00h = never)
Return: AL = status (see #0428)
Notes:	modes 00h and 01h affect only the current logical LPT1
	if no data is sent to a printer for the specified amount of time, the
	  spool file will be closed and queued for printing automatically
SeeAlso: AH=97h
--------N-17A0-------------------------------
INT 17 - Alloy MW386 - SPOOL COPY OF FILE
	AH = A0h
	AL = mode
	    00h NTNX compatibility
		DX = ??? (NTNX, MW386 v1.x only)
	    02h MW386 v2+
		BX = logical device number
		    00h-03h = LPT1-LPT4
		    04h-07h = COM1-COM4
	CX:SI -> ASCIZ pathname
Return: AL = status (see #0428)
Notes:	makes a copy of the specified file in the spooler's directory, allowing
	  the original file to be modified or deleted while the copy is printed
	in mode 00h, the file is printed on logical LPT1
SeeAlso: AH=90h
--------N-17A4-------------------------------
INT 17 - Alloy MW386 - ENABLE/DISABLE FORM FEED
	AH = A4h
	AL = new state
	    00h form feed after end of print job disabled
	    01h form feed enabled
Return: AL = status (see #0428)
Note:	only affects the current logical LPT1
SeeAlso: AH=9Ah,AH=A6h,INT 7F/AH=05h"NTNX (Host)"
--------N-17A6-------------------------------
INT 17 - Alloy MW386 - ENABLE/DISABLE BANNER PAGE
	AH = A6h
	AL = new state
	    00h banner page before print job disabled
	    01h banner page enabled
Return: AL = status (see #0428)
Note:	only affects the current logical LPT1
SeeAlso: AH=A4h
--------N-17A7-------------------------------
INT 17 - Alloy MW386 v2+ - GET/SET SPOOL FLAGS
	AH = A7h
	AL = spool flags (see #0431)
	BX = logical device number
	    00h-03h = LPT1-LPT4
	    04h-07h = COM1-COM4
Return: AL = status (see #0428)
Note:	the documentation does not state which register contains the result of
	  a GET
SeeAlso: AH=A4h,AH=A6h

Bitfields for Alloy spool flags:
Bit(s)	Description	(Table 0431)
 0	banner page enabled (see AH=A6h)
 1	form feed enabled (see AH=A4h)
 2-6	reserved (0)
 7	set flags if 1, get flags if 0
--------N-17A8-------------------------------
INT 17 - Alloy MW386 - DEFINE TEMPORARY FILENAME
	AH = A8h
	CX:SI -> ASCIZ filename without extension (max 8 chars)
Return: AL = status (see #0428)
Note:	allows application to specify banner page filename for spool files
	  collected from the application's printer output
SeeAlso: AH=A9h
--------N-17A9-------------------------------
INT 17 - Alloy MW386 - CHANGE TEMPORARY SPOOL DRIVE
	AH = A9h
	AL = new spool drive (2=C:,3=D:,etc)
Return: AL = status (see #0428)
Note:	does not remove previous spooling directory since jobs may be pending
SeeAlso: AH=A8h
--------N-17AA-------------------------------
INT 17 - Alloy MW386 v2+ - GET REAL-TIME PRINTER STATUS
	AH = AAh
	AL = mode
	    00h NTNX
		DX = NTNX printer number (see #0429)
	    01h MW386
		DX = MW386 printer number
Return: AH = instantaneous printer status
	    00h printer ready
	    01h not ready
	    12h off line
	    13h out of paper
	    14h general device failure
	    15h device timeout
	    16h bad device number
--------N-17AF-------------------------------
INT 17 - Alloy MW386 - CHECK SPOOLER
	AH = AFh
Return: AX = 55AAh if spooler available
--------c-17C0-------------------------------
INT 17 - PC Magazine PCSpool - GET CONTROL BLOCK ADDRESS
	AH = C0h
	DX = printer port (0-3)
Return: ES:BX -> control block (see #0432)
SeeAlso: AH=C1h

Format of PCSpool control block:
Offset	Size	Description	(Table 0432)
 00h	WORD	printer number
 02h	WORD	address of printer status port
 04h	WORD	number of first record in queue
 06h	WORD	number of last record in queue
 08h	DWORD	characters already printed
 0Ch	DWORD	number of characters remaining
 10h	DWORD	pointer to dequeue buffer
 14h	DWORD	previous count of characters printed
 18h	DWORD	number of clock ticks taken to print them
 1Ch	WORD	offset of next character to output
 1Eh	WORD	offset of next character to print
 20h	WORD	pointer to spooling queue record
 22h	BYTE	current spooling status
 23h	BYTE	current printer status:
		00h OK
		01h not ready
		02h paused with message
		03h paused
		04h initializing
		FEh non-existent port
		FFh not spooled
 24h	BYTE	current control record type
 25h	WORD	observed printer speed
 27h	WORD	characters to print per service
 29h	BYTE	01h if disk write needed
 2Ah	BYTE	01h if queued data should be flushed
 2Bh	BYTE	01h to update cps status
--------c-17C1--------------------------------
INT 17 - PC Magazine PCSpool - BUILD PAUSE CONTROL RECORD
	AH = C1h
	DX = printer port (0-3)
	DS:SI -> ASCIZ string to save for display
Note:	flushes pending writes
SeeAlso: AH=C0h,AH=C2h
--------c-17C2-------------------------------
INT 17 - PC Magazine PCSpool - FLUSH PENDING WRITES
	AH = C2h
	DX = printer port (0-3)
SeeAlso: AH=C3h
--------c-17C3-------------------------------
INT 17 - PC Magazine PCSpool - CANCEL PRINTER QUEUE (FLUSH ALL QUEUED OUTPUT)
	AH = C3h
	DX = printer port (0-3)
SeeAlso: AH=C2h,AH=C7h
--------c-17C4-------------------------------
INT 17 - PC Magazine PCSpool - QUERY SPOOLER ACTIVE
	AH = C4h
Return: DI = B0BFh
	SI = segment
--------c-17C5-------------------------------
INT 17 - PC Magazine PCSpool - JOB SKIP PRINTER QUEUE
	AH = C5h
	DX = printer port (0-3)
Note:	cancels up to the pause record
--------c-17C6-------------------------------
INT 17 - PC Magazine PCSpool - CHECK PRINTER QUEUE STATUS
	AH = C6h
	DX = printer port (0-3)
Return: AX = queue status
	   0000h printer not active or at pause
	   0001h printer busy
--------c-17C7-------------------------------
INT 17 - PC Magazine PCSpool - CLOSE QUEUE
	AH = C7h
	DX = printer port (0-3)
SeeAlso: AH=C3h
--------P-17CD00-----------------------------
INT 17 - INSET - EXECUTE COMMAND STRING
	AX = CD00h
	DS:DX -> ASCIZ command string (max 80 bytes)
Return: CX = 07C2h (1986d)
Note:	user interface menus pop up after last command, unless that command
	exits INSET
--------P-17CD01-----------------------------
INT 17 - INSET - GET IMAGE SIZE
	AX = CD01h
	DS:DX -> ASCIZ name of image file
Return: AX = height in 1/720th inch
	BX = width in 1/720th inch
	CX = 07C2h (1986d)
--------P-17CD02-----------------------------
INT 17 - INSET - INITIALIZE
	AX = CD02h
Return: CX = 07C2h (1986d)
Note:	all open files are closed and the printer is reset
SeeAlso: AX=CD04h
--------P-17CD03-----------------------------
INT 17 - INSET - EXECUTE INSET MENU WITHIN OVERRIDE MODE
	AX = CD03h
Return: CX = 07C2h (1986d)
--------P-17CD04-----------------------------
INT 17 - INSET - INITIALIZE LINKED MODE
	AX = CD04h
	ES:SI -> FAR routine for linked mode (see #0433)
Return: CX = 07C2h
SeeAlso: AX=CD02h,AX=CD08h

(Table 0433)
Values INSET linked-mode routine is called with:
	AL = function
	    00h send character to printer
		BL = character to send
	    01h send string to printer
		CX = number of bytes to send
		DS:DX -> buffer containing data
	    02h move print head to horizontal starting position of image
Return:	AX = status
	    0000h success
	    0001h failure
--------P-17CD05-----------------------------
INT 17 - INSET - START MERGING IMAGE INTO TEXT
	AX = CD05h
	DS:DX -> ASCIZ name of PIX file
	CX = left margin of text in 1/720th inch
Return: AH = printer type
	    00h page-oriented (multiple images may be placed side-by-side)
	    01h line-oriented (use AX=CD06h for vertical paper movement)
	CX = 07C2h (1986d)
SeeAlso: AX=CD07h
--------P-17CD06-----------------------------
INT 17 - INSET - GRAPHICS LINE FEED
	AX = CD06h
Return: AH = completion status
	    00h image complete
	    01h image incomplete
	CX = 07C2h (1986d)
SeeAlso: AX=CD09h
--------P-17CD07-----------------------------
INT 17 - INSET - FLUSH GRAPHICS FROM MERGE BUFFER
	AX = CD07h
Return: CX = 07C2h
SeeAlso: AX=CD05h
--------P-17CD08-----------------------------
INT 17 - INSET - CANCEL LINK MODE
	AX = CD08h
Return: CX = 07C2h
SeeAlso: AX=CD04h
--------P-17CD09-----------------------------
INT 17 - INSET - ALTER TEXT LINE SPACING
	AX = CD09h
	CX = line spacing in 1/720th inch
Return: CX = 07C2h
Note:	not yet implemented, line spacing is currently fixed at 1/6 inch
SeeAlso: AX=CD06h
--------P-17CD0A-----------------------------
INT 17 - INSET - GET SETUP
	AX = CD0Ah
	DS:DX -> buffer for IN.SET data
Return: CX = 07C2h
--------P-17CD0B-----------------------------
INT 17 - INSET - START GETTING SCALED IMAGE
	AX = CD0Bh
	DS:SI -> ASCIZ pathname of .PIX file
	BX = number of bitplanes
	CX = number of rows in output bitmap
	DX = number of columns in output bitmap
Return: AX = status
	    0000h OK
	    FFFFh error
Note:	image is returned in strips by repeated calls to AX=CD0Ch
--------P-17CD0C-----------------------------
INT 17 - INSET - GET NEXT IMAGE STRIP
	AX = CD0Ch
Return: AX = status
	    0000h OK but not complete
	    0001h OK and image complete
	    FFFFh error
	DS:SI -> buffer (max 4K) for bit map strip
	CX = start row
	DX = number of rows
	BX = offset in bytes between bit planes
Note:	buffer may be overwritten by subsequent calls
SeeAlso: AX=CD0Bh
--------P-17F0-------------------------------
INT 17 - NorthNet Jetstream API - INSTALLATION CHECK
	AH = F0h
	DX = printer port (0-3)
Return: AX = 0001h Jetstream present
	     else  non-Jetstream port
Note:	NorthNet Jetstream is a high-performance DMA-driven parallel card able
	  to drive printers at up to 80000 characters per second
--------P-17F1-------------------------------
INT 17 - NorthNet Jetstream API - PRINT DATA BUFFER
	AH = F1h
	CX = data buffer length
	DX = printer port (0-3)
	DS:SI -> data buffer
Return: AX = status
	    0000h printer not ready (see also AH=02h)
	    other printing started
SeeAlso: AH=00h,AH=F2h,AH=F3h,AH=F5h
--------P-17F2-------------------------------
INT 17 - NorthNet Jetstream API - GET PRINT PROGRESS STATUS
	AH = F2h
	DX = printer port (0-3)
Return: AX = status
	    0000h prior print request finished
	    other number of characters left to print
SeeAlso: AH=02h,AH=F1h,AH=F3h
--------P-17F3-------------------------------
INT 17 - NorthNet Jetstream API - ABORT PRINT OPERATION
	AH = F3h
	DX = printer port (0-3)
Return: AX = number of unprinted characters due to abort
SeeAlso: AH=F1h,AH=F4h
--------P-17F4-------------------------------
INT 17 - NorthNet Jetstream API - SET COMPLETION (POST) ADDRESS
	AH = F4h
	DX = printer port (0-3)
	DS:DS -> FAR post address (called with interrupts on)
SeeAlso: AH=F1h,AH=F3h
--------P-17F5-------------------------------
INT 17 - NorthNet Jetstream API - PRINT DATA BUFFER FROM EXTENDED MEMORY
	AH = F5h
	CX = data buffer length
	DX = printer port (0-3)
	DS:SI -> data buffer (32-bit physical address)
Return: AX = status
	    0000h printer not ready (see also AH=02h)
	    other printing started
SeeAlso: AH=F1h
--------c-17FF--BX0000-----------------------
INT 17 U - PC-MOS/386 v5.01 - PRINT SPOOLER - CLOSE SPOOL FILE
	AH = FFh
	BX = 0000h
	CX = 0000h
	DX = printer port number
Return: AH = printer status (see #0424 at AH=00h)
Program: PC-MOS/386 v5.01 is a multitasking, multiuser MS-DOS 5.0-compatible
	  operating system by The Software Link, Inc.
Desc:	close the spool file immediately instead of waiting for the close time
	  to elapse
SeeAlso: AH=01h,AH=03h"PC-MOS"
--------B-18---------------------------------
INT 18 - DISKLESS BOOT HOOK (START CASSETTE BASIC)
Desc:	called when there is no bootable disk available to the system
Notes:	only PCs produced by IBM contain BASIC in ROM, so the action is
	  unpredictable on compatibles; this interrupt often reboots the
	  system, and often has no effect at all
	network cards with their own BIOS can hook this interrupt to allow
	  a diskless boot off the network (even when a hard disk is present
	  if none of the partitions is marked as the boot partition)
SeeAlso: INT 2F/AX=4A06h,INT 86"NetBIOS"
--------J-1800-------------------------------
INT 18 - NEC PC-9800 series - KEYBOARD - GET KEYSTROKE
	AH = 00h
Return: AX = keystroke
SeeAlso: AH=01h,AH=02h,INT 16/AH=00h
--------J-1801-------------------------------
INT 18 - NEC PC-9800 series - KEYBOARD - CHECK FOR KEYSTROKE
	AH = 01h
Return: ZF set if no keystroke available
	ZF clear if keystroke available
	    AX = keystroke
SeeAlso: AH=00h,AH=02h,INT 16/AH=01h
--------J-1802-------------------------------
INT 18 - NEC PC-9800 series - KEYBOARD - GET SHIFT STATUS
	AH = 02h
Return: AL = shift flags
SeeAlso: AH=00h,AH=02h,AH=03h,AH=04h,INT 16/AH=02h
--------J-1803-------------------------------
INT 18 - NEC PC-9800 series - KEYBOARD - INITIALIZE
	AH = 03h
	???
Return: ???
SeeAlso: AH=00h,AH=04h
--------J-1804-------------------------------
INT 18 - NEC PC-9800 series - KEYBOARD - KEY PRESSED
	AH = 04h
	???
Return: ???
Note:	details are not available at this time
SeeAlso: AH=00h,AH=02h,INT 16/AH=00h,INT 16/AH=01h,INT 16/AH=02h
--------J-18---------------------------------
INT 18 - NEC PC-9800 series - VIDEO
	AH = function
	    0Ah set video mode
	    0Bh get video mode
	    0Ch start text screen display
	    0Dh end text screen display
	    0Eh set single display area
	    0Fh set multiple display area
	    10h set cursor shape
	    11h display cursor
	    12h terminate cursor
	    13h set cursor position
	    14h read font patter
	    16h initialize text video RAM
	    1Ah define user character
	???
Return: ???
Notes:	details are not available at this time
	text video RAM is located at segments A000h (characters) and A200h
	  (attributes)
----------185350BX4849-----------------------
INT 18 - SPHINX C-- - WB.COM - API
	AX = 5350h ('SP')
	BX = 4849h ('HI')
	CX = 4E58h ('NX')
	DH = function
	    01h set ???
		DL = ???
	    02h get ???
		Return: DL = ???
	    03h get ???
		Return: ES:DI -> ??? data buffer
	    06h ???
Return: AX = 7370h ('sp') if installed
	BX = 6869h ('hi') if installed
	CX = 6E78h ('nx') if installed
Program: SPHINX C-- is a shareware compiler by Peter Cellik for a language
	  which is a cross between C and assembler; WB.COM is the driver which
	  launches the WorkBench
--------s-186900-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - GET STATUS
	AX = 6900h
Return: AX = amount of DRAM on card or 0000h if GUS not available
Program: YEA_GUS is a driver for the Graphics Ultra Sound which hooks INT 18h
	  and then shells out the the program requiring its services
SeeAlso: AX=6901h,AX=690Ah,AX=690Bh
--------s-186901-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - RESET
	AX = 6901h
	BX = number of active voices (14-32)
Return: nothing
SeeAlso: AX=6900h
--------s-186902-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - SET VOLUME FOR SPECIFIC VOICE
	AX = 6902h
	BX = voice number (00h-1Fh)
	CX = linear volume (0000h-01FFh)
Return: nothing
SeeAlso: AX=6900h,AX=6903h,AX=6904h,AX=6909h,AX=690Ah
--------s-186903-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - SET FREQUENCY FOR VOICE
	AX = 6903h
	BX = voice number (00h-1Fh)
	CX = frequency in Hz (0-44100)
Return: nothing
SeeAlso: AX=6902h,AX=6904h
--------s-186904-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - SET LEFT/RIGHT BALANCE
	AX = 6904h
	BX = voice number (00h-1Fh)
	CX = balance (0 = left, 7 = even, 15 = right)
Return: nothing
SeeAlso: AX=6902h,AX=6903h
--------s-186905-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - PLAY MUSIC
	AX = 6905h
	BL = voice number
	BH = sample type (0 = 8-bit, 1 = 16-bit)
	CL = looping type (0 = none, 1 = forward, 2 = back and forth)
	CH:DI = 20-bit starting address for voice data
	DL:SI = 20-bit address for loop start
	DH:BP = 20-bit address for loop end
SeeAlso: AX=6903h,AX=6906h,AX=690Bh
--------s-186906-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - LOAD SOUND DATA
	AX = 6906h
	BL = data format (1 = twos-complement, 0 = not)
	BH = sample type (0 = 8-bit, 1 = 16-bit)
	CX = number of bytes to send
	ES:SI -> buffer containing data
	DL:DI = 20-bit address of GUS DRAM at which to load sound data
SeeAlso: AX=6900h,AX=6905h,AX=690Ch
--------s-186907-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - STOP VOICE
	AX = 6907h
	BX = voice number (00h-1Fh)
Return: nothing
SeeAlso: AX=6908h,AX=690Dh
--------s-186908-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - SET VOICE END
	AX = 6908h
	BX = voice number (00h-1Fh)
	CL:DX = 20-bit ending address
Return: nothing
SeeAlso: AX=690Bh
--------s-186909-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - RAMP VOLUME
	AX = 6909h
	BL = voice number (00h-1Fh)
	BH = looping type (0 = none, 1 = forward, 2 = back and forth)
	CX = starting volume
	DX = ending volume
	DI:SI = time
Return: nothing
SeeAlso: AX=6902h,AX=690Ah
--------s-18690A-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - GET VOLUME
	AX = 690Ah
	BX = voice number (00h-1Fh)
Return: AX = current non-linear volume for voice
SeeAlso: AX=6902h,AX=6909h
--------s-18690B-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - GET POSITION
	AX = 690Bh
	BX = voice number
Return: BX:AX = 20-bit address at which voice is playing
SeeAlso: AX=6900h,AX=6905h,AX=6908h
--------s-18690C-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - SAVE SOUND DATA
	AX = 690Ch
	BL = data format (1 = twos-complement, 0 = not)
	BH = sample type (0 = 8-bit, 1 = 16-bit)
	CX = number of bytes to get
	ES:SI -> buffer for retrieved data
	DL:DI = 20-bit address in GUS DRAM from which to read voice data
Return: nothing
SeeAlso: AX=6906h
--------s-18690D-----------------------------
INT 18 - Gravis Ultra Sound YEA_GUS.EXE - RESTART VOICE
	AX = 690Dh
	BX = voice
	CX = sample type (0 = 8-bit, 1 = 16-bit)
	DX = looping type (0 = none, 1 = forward, 2 = back and forth)
Return: CX = balance value
SeeAlso: AX=6907h,AX=6908h
--------s-188000-----------------------------
INT 18 - Gravis Ultra Sound EURO_MOD.EXE - INITIALIZE
	AX = 8000h
Program: EURO_MOD is a .MOD file player for the Gravis Ultra Sound which hooks
	  INT 18h and then shells out to the program requiring its services
SeeAlso: AX=8001h,AX=8004h
--------s-188001-----------------------------
INT 18 - Gravis Ultra Sound EURO_MOD.EXE - LOAD .MOD FILE
	AX = 8001h
	BX:CX -> ASCIZ filename
SeeAlso: AX=8000h,AX=8002h
--------s-188002-----------------------------
INT 18 - Gravis Ultra Sound EURO_MOD.EXE - PLAY .MOD FILE
	AX = 8002h
SeeAlso: AX=8002h,AX=8003h
--------s-188003-----------------------------
INT 18 - Gravis Ultra Sound EURO_MOD.EXE - STOP PLAYING
	AX = 8003h
--------s-188004-----------------------------
INT 18 - Gravis Ultra Sound EURO_MOD.EXE - SHUTDOWN
	AX = 8004h
SeeAlso: AX=8000h,AX=8003h
--------B-19---------------------------------
INT 19 - SYSTEM - BOOTSTRAP LOADER
Desc:	This interrupt reboots the system without clearing memory or restoring
	  interrupt vectors.  Because interrupt vectors are preserved, this
	  interrupt usually causes a system hang if any TSRs have hooked
	  vectors from 00h through 1Ch, particularly INT 08.
Notes:	Usually, the BIOS will try to read sector 1, head 0, track 0 from drive
	  A: to 0000h:7C00h.  If this fails, and a hard disk is installed, the
	  BIOS will read sector 1, head 0, track 0 of the first hard disk.
	  This sector should contain a master bootstrap loader and a partition
	  table (see #0435).  After loading the master boot sector at
	  0000h:7C00h, the master bootstrap loader is given control.  It will
	  scan the partition table for an active partition, and will then load
	  the operating system's bootstrap loader (contained in the first
	  sector of the active partition) and give it control.
	true IBM PCs and most clones issue an INT 18 if neither floppy nor hard
	  disk have a valid boot sector
	to accomplish a warm boot equivalent to Ctrl-Alt-Del, store 1234h in
	  0040h:0072h and jump to FFFFh:0000h.	For a cold boot equivalent to
	  a reset, store 0000h at 0040h:0072h before jumping.
	VDISK.SYS hooks this interrupt to allow applications to find out how
	  much extended memory has been used by VDISKs (see #0434).  DOS 3.3+
	  PRINT hooks INT 19 but does not set up a correct VDISK header block
	  at the beginning of its INT 19 handler segment, thus causing some
	  programs to overwrite extended memory which is already in use.
	the default handler is at F000h:E6F2h for 100% compatible BIOSes
	MS-DOS 3.2+ hangs on booting (even from floppy) if the hard disk
	  contains extended partitions which point at each other in a loop,
	  since it will never find the end of the linked list of extended
	  partitions
SeeAlso: INT 14/AH=17h,INT 18,INT 5B"PC Cluster"

Format of VDISK header block (at beginning of INT 19 handler's segment):
Offset	Size	Description	(Table 0434)
 00h 18 BYTEs	n/a (for VDISK.SYS, the device driver header)
 12h 11 BYTEs	signature string "VDISK	 Vn.m" for VDISK.SYS version n.m
 1Dh 15 BYTEs	n/a
 2Ch  3 BYTEs	linear address of first byte of available extended memory

Format of hard disk master boot sector:
Offset	Size	Description	(Table 0435)
 00h 446 BYTEs	Master bootstrap loader code
1BEh 16 BYTEs	partition record for partition 1 (see #0436)
1CEh 16 BYTEs	partition record for partition 2
1DEh 16 BYTEs	partition record for partition 3
1EEh 16 BYTEs	partition record for partition 4
1FEh	WORD	signature, AA55h indicates valid boot block

Format of partition record:
Offset	Size	Description	(Table 0436)
 00h	BYTE	boot indicator (80h = active partition)
 01h	BYTE	partition start head
 02h	BYTE	partition start sector (bits 0-5)
 03h	BYTE	partition start track (bits 8,9 in bits 6,7 of sector)
 04h	BYTE	operating system indicator (see #0437)
 05h	BYTE	partition end head
 06h	BYTE	partition end sector (bits 0-5)
 07h	BYTE	partition end track (bits 8,9 in bits 6,7 of sector)
 08h	DWORD	sectors preceding partition
 0Ch	DWORD	length of partition in sectors

(Table 0437)
Values for operating system indicator:
 00h	empty
 01h	DOS 12-bit FAT
 02h	XENIX root file system
 03h	XENIX /usr file system (obsolete)
 04h	DOS 16-bit FAT
 05h	DOS 3.3+ extended partition
 06h	DOS 3.31+ Large File System
 07h	QNX
 07h	OS/2 HPFS
 07h	Advanced Unix
 08h	AIX bootable partition, SplitDrive
 09h	AIX data partition
 09h	Coherent filesystem
 0Ah	OS/2 Boot Manager
 0Ah	OPUS
 0Ah	Coherent swap partition
 10h	OPUS
 18h	AST special Windows swap file
 24h	NEC MS-DOS 3.x
 40h	VENIX 80286
 50h	Disk Manager, read-only partition
 51h	Disk Manager, read/write partition
 51h	Novell???
 52h	CP/M
 52h	Microport System V/386
 56h	GoldenBow VFeature
 61h	SpeedStor
 63h	Unix SysV/386, 386/ix
 63h	Mach, MtXinu BSD 4.3 on Mach
 63h	GNU HURD
 64h	Novell NetWare
 65h	Novell NetWare (3.11)
 70h	DiskSecure Multi-Boot
 75h	PC/IX
 80h	Minix v1.1 - 1.4a
 81h	Minix v1.4b+
 81h	Linux
 81h	Mitac Advanced Disk Manager
 82h	Linux Swap partition
 83h	Linux native file system (ext2fs/xiafs)
 84h	OS/2-renumbered type 04h partition (related to hiding DOS C: drive)
 93h	Amoeba file system
 94h	Amoeba bad block table
 B7h	BSDI file system (secondarily swap)
 B8h	BSDI swap partition (secondarily file system)
 C1h	DR-DOS 6.0 LOGIN.EXE-secured 12-bit FAT partition
 C4h	DR-DOS 6.0 LOGIN.EXE-secured 16-bit FAT partition
 C6h	DR-DOS 6.0 LOGIN.EXE-secured Huge partition
 DBh	CP/M, Concurrent CP/M, Concurrent DOS
 DBh	CTOS (Convergent Technologies OS)
 E1h	SpeedStor 12-bit FAT extended partition
 E4h	SpeedStor 16-bit FAT extended partition
 F2h	DOS 3.3+ secondary
 FEh	LANstep
 FFh	Xenix bad block table
--------B-1A00-------------------------------
INT 1A - TIME - GET SYSTEM TIME
	AH = 00h
Return: CX:DX = number of clock ticks since midnight
	AL = midnight flag, nonzero if midnight passed since time last read
Notes:	there are approximately 18.2 clock ticks per second, 1800B0h per 24 hrs
	IBM and many clone BIOSes set the flag for AL rather than incrementing
	  it, leading to loss of a day if two consecutive midnights pass
	  without a request for the time (e.g. if the system is on but idle)
SeeAlso: AH=01h,AH=02h,INT 21/AH=2Ch,INT 62/AX=0099h
--------B-1A01-------------------------------
INT 1A - TIME - SET SYSTEM TIME
	AH = 01h
	CX:DX = number of clock ticks since midnight
SeeAlso: AH=00h,AH=03h,INT 21/AH=2Dh
--------B-1A02-------------------------------
INT 1A - TIME - GET REAL-TIME CLOCK TIME (AT,XT286,PS)
	AH = 02h
Return: CF clear if successful
	    CH = hour (BCD)
	    CL = minutes (BCD)
	    DH = seconds (BCD)
	    DL = daylight savings flag (00h standard time, 01h daylight time)
	CF set on error (i.e. clock not running or in middle of update)
SeeAlso: AH=00h
--------B-1A03-------------------------------
INT 1A - TIME - SET REAL-TIME CLOCK TIME (AT,XT286,PS)
	AH = 03h
	CH = hour (BCD)
	CL = minutes (BCD)
	DH = seconds (BCD)
	DL = daylight savings flag (00h standard time, 01h daylight time)
SeeAlso: AH=01h
--------B-1A04-------------------------------
INT 1A - TIME - GET REAL-TIME CLOCK DATE (AT,XT286,PS)
	AH = 04h
Return: CF clear if successful
	    CH = century (BCD)
	    CL = year (BCD)
	    DH = month (BCD)
	    DL = day (BCD)
	CF set on error
SeeAlso: AH=02h,AH=05h,INT 21/AH=2Ah
--------B-1A05-------------------------------
INT 1A - TIME - SET REAL-TIME CLOCK DATE (AT,XT286,PS)
	AH = 05h
	CH = century (BCD)
	CL = year (BCD)
	DH = month (BCD)
	DL = day (BCD)
SeeAlso: AH=04h,INT 21/AH=2Bh
--------B-1A06-------------------------------
INT 1A - TIME - SET ALARM (AT,XT286,PS)
	AH = 06h
	CH = hour (BCD)
	CL = minutes (BCD)
	DH = seconds (BCD)
Return: CF set on error (alarm already set or clock stopped for update)
	CF clear if successful
Note:	the alarm occurs every 24 hours until turned off, invoking INT 4A each
	  time
SeeAlso: AH=07h,INT 4A
--------B-1A07-------------------------------
INT 1A - TIME - CANCEL ALARM (AT,XT286,PS)
	AH = 07h
Return: alarm disabled
Note:	does not disable the real-time clock's IRQ
SeeAlso: AH=06h,INT 70
--------B-1A08-------------------------------
INT 1A - TIME - SET RTC ACTIVATED POWER ON MODE (CONVERTIBLE)
	AH = 08h
	CH = hours in BCD
	CL = minutes in BCD
	DH = seconds in BCD
SeeAlso: AH=09h
--------B-1A09-------------------------------
INT 1A - TIME - READ RTC ALARM TIME AND STATUS (CONV,PS30)
	AH = 09h
Return: CH = hours in BCD
	CL = minutes in BCD
	DH = seconds in BCD
	DL = alarm status
	    00h alarm not enabled
	    01h alarm enabled but will not power up system
	    02h alarm will power up system
SeeAlso: AH=08h
--------B-1A0A-------------------------------
INT 1A - TIME - READ SYSTEM-TIMER DAY COUNTER (XT2,PS)
	AH = 0Ah
Return: CF set on error
	CF clear if successful
	    CX = count of days since Jan 1,1980
SeeAlso: AH=04h,AH=0Bh
--------B-1A0B-------------------------------
INT 1A - TIME - SET SYSTEM-TIMER DAY COUNTER (XT2,PS)
	AH = 0Bh
	CX = count of days since Jan 1,1980
Return: CF set on error
	CF clear if successful
SeeAlso: AH=05h,AH=0Ah
--------J-1A10-------------------------------
INT 1A - NEC PC-9800 series - PRINTER - INITIALIZE
	AH = 10h
	???
Return: ???
SeeAlso: AH=11h,AH=12h,INT 17/AH=01h
--------J-1A11-------------------------------
INT 1A - NEC PC-9800 series - PRINTER - OUTPUT CHARACTER
	AH = 11h
	???
Return: ???
SeeAlso: AH=10h,AH=12h,INT 17/AH=00h
--------J-1A12-------------------------------
INT 1A - NEC PC-9800 series - PRINTER - SENSE STATUS
	AH = 12h
	???
Return: ???
SeeAlso: AH=10h,AH=11h,INT 17/AH=02h
--------A-1A3601-----------------------------
INT 1A - WORD PERFECT v5.0 Third Party Interface - INSTALLATION CHECK
	AX = 3601h
Return: DS:SI = routine to monitor keyboard input, immediately preceded by the
		ASCIZ string "WPCORP\0"
Notes:	WordPerfect 5.0 will call this interrupt at start up to determine if a
	  third party product wants to interface with it.  The third party
	  product must intercept this interrupt and return the address of a
	  keyboard monitor routine.
	Before checking for keyboard input, and after every key entered by the
	  user, Word Perfect will call the routine whose address was provided
	  in DS:SI with the following parameters:
		Entry:	AX = key code or 0
			BX = WordPerfect state flag
		Exit:	AX = 0 or key code
			BX = 0 or segment address of buffer with key codes
	See the "WordPerfect 5.0 Developer's Toolkit" for further information.
SeeAlso: INT 16/AX=5500h
--------N-1A6108-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_SENDWITHREPLY" - SEND MSG AND GET REPLY
	AX = 6108h
	STACK:	WORD	conversation ID (0000h-0009h)
		DWORD	pointer to message buffer
		WORD	length of message
		DWORD	pointer to reply buffer
		WORD	length of reply buffer
		WORD	0000h (use default "Cparams" structure)
Return: AX = status (see #0438)
	STACK unchanged
Program: SNAP.EXE is a TSR written by IBM and Carnegie Mellon University
	  which implements the Simple Network Application Protocol
SeeAlso: AX=6205h

(Table 0438)
Values for SNAP.EXE status:
 0000h	successful
 F830h	"SNAP_ABORTED"
 FC04h	"SNAP_SERVERDIED"
 FC05h	"SNAP_RESEND"
 FC06h	"SNAP_SELECTFAILED"
 FC07h	"SNAP_WRONGVERSION"
 FC08h	"SNAP_INVALIDACK"
 FC09h	"SNAP_TIMEOUT"
 FC0Ah	"SNAP_SERVERREJECT"
 FC0Bh	"SNAP_NOREPLYDUE"
 FC0Ch	"SNAP_NOAUTHENTICATE"/"SNAP_GUARDIAN_ERROR"
 FC0Dh	"SNAP_NOINIT"
 FC0Eh	"SNAP_SOCKETERROR"
 FC0Fh	"SNAP_BUFFERLIMIT"
 FC10h	"SNAP_INVALIDCID"
 FC11h	"SNAP_INVALIDOP"
 FC12h	"SNAP_XMITFAIL"
 FC13h	"SNAP_NOMORERETRIES"
 FC14h	"SNAP_BADPARMS"
 FC15h	"SNAP_NOMEMORY"
 FC16h	"SNAP_NOMORECONVS"
 FFFFh	failed (invalid function/parameter)
--------N-1A6205-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_SENDNOREPLY" - SEND MSG, DON'T AWAIT REPLY
	AX = 6205h
	STACK:	WORD	conversation ID (0000h-0009h)
		DWORD	pointer to message
		WORD	length of message
		WORD	0000h (use default "Cparms" structure)
Return: AX = status (see #0438)
	STACK unchanged
SeeAlso: AX=6108h
--------N-1A6308-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_BEGINCONV" - BEGIN CONVERSATION
	AX = 6308h
	STACK:	WORD	offset of ASCIZ "guardian"
		WORD	offset of ASCIZ hostname
		WORD	offset of ASCIZ server name
		WORD	offset of ASCIZ userid
		WORD	offset of ASCIZ password
		WORD	offset of password length
		WORD	offset of password type
		WORD	offset of "Cparms" structure (see #0439)
Return: ???
	STACK unchanged
Note:	all stacked offsets are within the SNAP data segment (use AX=6A01h
	  to allocate a buffer)
SeeAlso: AX=6405h,AX=7202h

Format of SNAP.EXE Cparms structure:
Offset	Size	Description	(Table 0439)
 00h	WORD	retry delay in seconds
 02h	WORD	timeout delay in seconds
 04h	WORD	maximum buffer size
 06h	WORD	encryption level
--------N-1A6405-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_ENDCONV" - END CONVERSATION
	AX = 6405h
	STACK:	WORD	conversation ID (0000h-0009h)
		DWORD	pointer to message buffer
		WORD	length of message
		WORD	0000h (use default "Cparms" structure)
Return: AX = status (see #0438)
	STACK unchanged
Program: SNAP.EXE is a TSR written by IBM and Carnegie Mellon University
	  which implements the Simple Network Application Protocol
SeeAlso: AX=6308h
--------N-1A6900-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_DATASEG" - GET RESIDENT DATA SEGMENT
	AX = 6900h
Return: AX = value used for DS by resident code
SeeAlso: AX=6A01h,AX=6F01h
--------N-1A6A01-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_ALLOC" - ALLOCATE BUFFER IN SNAP DATA SEGMENT
	AX = 6A01h
	STACK:	WORD	number of bytes to allocate
Return: AX = offset of allocated buffer or 0000h if out of memory
	STACK unchanged
Program: SNAP.EXE is a TSR written by IBM and Carnegie Mellon University
	  which implements the Simple Network Application Protocol
SeeAlso: AX=6B01h
--------N-1A6B01-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_FREE" - DEALLOCATE BUFFER IN SNAP DATA SEGMENT
	AX = 6B01h
	STACK:	WORD	offset within SNAP data segment of previously allocated
			buffer
Return: STACK unchanged
Note:	this call is a NOP if the specified offset is 0000h
SeeAlso: AX=6A01h
--------N-1A6C04-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_COPYTO" - COPY DATA TO RESIDENT SNAP PACKAGE
	AX = 6C04h
	STACK:	WORD	offset within SNAP data segment of dest (nonzero)
		WORD	segment of source buffer
		WORD	offset of source buffer
		WORD	number of bytes to copy
Return: AX = offset of byte after last one copied to destination
	STACK unchanged
Program: SNAP.EXE is a TSR written by IBM and Carnegie Mellon University
	  which implements the Simple Network Application Protocol
SeeAlso: AX=6D04h
--------N-1A6D04-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_COPYFROM" - COPY DATA FROM RESIDENT SNAP PACKAGE
	AX = 6D04h
	STACK:	WORD	offset within SNAP data segment of source buffer
		WORD	segment of destination buffer
		WORD	offset of destination buffer
		WORD	number of bytes to copy
Return: AX = offset of byte after last one copied from source
	buffer filled
	STACK unchanged
SeeAlso: AX=6C04h
--------N-1A6E01-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_SETDEBUG" - SET ???
	AX = 6E01h
	STACK:	WORD	new value for ???
Return: AX = old value of ???
	STACK unchanged
Program: SNAP.EXE is a TSR written by IBM and Carnegie Mellon University
	  which implements the Simple Network Application Protocol
--------N-1A6F01-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_CHKINSTALL" - INSTALLATION CHECK
	AX = 6F01h
	STACK: WORD 0000h
Return: AX = status
	    0000h SNAP is resident
	    other SNAP not present
	STACK unchanged
Program: SNAP.EXE is a TSR written by IBM and Carnegie Mellon University
	  which implements the Simple Network Application Protocol, and is
	  required by PCVENUS (a network shell).  The combination of SNAP and
	  PCVENUS allows the use of the Andrew File System as one or more
	  networked drives.
SeeAlso: AX=6900h,AX=7400h
--------N-1A7002-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_SETANCHOR"
	AX = 7002h
	STACK:	WORD	anchor number (0000h-0009h)
		WORD	new value for the anchor
Return: AX = status
	    0000h successful
	    FFFFh failed (top word on stack not in range 00h-09h)
	STACK unchanged
SeeAlso: AX=7101h
--------N-1A7101-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_GETANCHOR"
	AX = 7101h
	STACK:	WORD	anchor number (0000h-0009h)
Return: AX = anchor's value
	STACK unchanged
Program: SNAP.EXE is a TSR written by IBM and Carnegie Mellon University
	  which implements the Simple Network Application Protocol
SeeAlso: AX=7002h
--------N-1A7202-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_SETCONVPARMS" - SET CONVERSATION PARAMETERS
	AX = 7202h
	STACK:	WORD	conversation ID (0000h-0009h)
		WORD	offset within resident data segment of "Cparms"
			  structure (see #0439)
Return: AX = status???
	STACK unchanged
SeeAlso: AX=6308h
--------N-1A7302-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_CLIENTVERSION" - ???
	AX = 7302h
	STACK:	WORD	conversation ID (0000h-0009h)
		WORD	offset within resident data segment of ???
Return: AX = ???
	???
	STACK unchanged
SeeAlso: AX=7400h
--------N-1A7400-----------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_VERSION" - GET VERSION
	AX = 7400h
Return: AX = version (AH=major, AL=minor)
Note:	this call is only valid if SNAP is installed
SeeAlso: AX=7302h,INT 1A/AX=6F01h
--------N-1A75-------------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_NOP" - ???
	AH = 75h
	AL = ???
Return: AX = ??? (0000h)
Program: SNAP.EXE is a TSR written by IBM and Carnegie Mellon University
	  which implements the Simple Network Application Protocol
--------N-1A76-------------------------------
INT 1A - SNAP.EXE 3.2+ - "SNAP_802_5" - ???
	AH = 76h
	AL = ???
Return: AX = ???
--------N-1A77-------------------------------
INT 1A - SNAP.EXE 3.4 - ???
	AH = 77h
	AL = ??? (at least 01h)
	STACK:	WORD	???
		???
Return: ???
	STACK unchanged
--------N-1A7802-----------------------------
INT 1A - SNAP.EXE 3.4 - ???
	AX = 7802h
	STACK:	WORD	???
		WORD	???
Return: ???
	STACK unchanged
Program: SNAP.EXE is a TSR written by IBM and Carnegie Mellon University
	  which implements the Simple Network Application Protocol
--------s-1A7F-------------------------------
INT 1A - Tandy 2500, Tandy 1000L series - DIGITAL SOUND???
	AH = 7Fh
	???
Return: ???
Note:	this function is not supported by the Tandy 1000SL/TL BIOS
SeeAlso: AH=80h,AH=83h,AH=85h
--------s-1A80-------------------------------
INT 1A - PCjr, Tandy 2500???, Tandy 1000SL/TL - SET UP SOUND MULTIPLEXOR
	AH = 80h
	AL = 00h source is 8253 channel 2
	     01h source is cassette input
	     02h source is I/O channel "Audio IN"
	     03h source is sound generator chip
Note:	although documented in the 1000TL Technical Reference, the 1000TL
	  BIOS has just an IRET for this call
SeeAlso: AH=7Fh,AH=83h
--------X-1A80-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - GET NUMBER OF ADAPTERS
	AH = 80h
Return: CF clear if successful
	    CX = 5353h ('SS') if Socket Services installed
		AL = number of adapters present (0-16)
	    AH destroyed
	CF set on error
	    AH = error code (see #0440)
SeeAlso: AH=83h"PCMCIA"

(Table 0440)
Values for PCMCIA error codes:
 01h	"BAD_ADAPTER" nonexistent adapter
 02h	"BAD_ATTRIBUTE" invalid attribute specified
 03h	"BAD_BASE" invalid system memory base address
 04h	"BAD_EDC" invalid EDC generator specified
 05h	"BAD_INDICATOR" invalid indicator specified
 06h	"BAD_IRQ" invalid IRQ channel specified
 07h	"BAD_OFFSET" invalid PCMCIA card offset specified
 08h	"BAD_PAGE" invalid page specified
 09h	"BAD_READ" unable to complete request
 0Ah	"BAD_SIZE" invalid window size specified
 0Bh	"BAD_SOCKET" nonexistent socket specified
 0Ch	"BAD_TECHNOLOGY" unsupported Card Technology for writes
 0Dh	"BAD_TYPE" unavailable window type specified
 0Eh	"BAD_VCC" invalid Vcc power level index specified
 0Fh	"BAD_VPP" invalid Vpp1 or Vpp2 power level index specified
 10h	"BAD_WAIT" invalid number of wait states specified
 11h	"BAD_WINDOW" nonexistent window specified
 12h	"BAD_WRITE" unable to complete request
 13h	"NO_ADAPTERS" no adapters installed, but Socket Services is present
 14h	"NO_CARD" no card in socket
--------X-1A81-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - REGISTER STATUS CHANGE CALLBACK
	AH = 81h
	DS:DX -> callback routine (see #0441) or 0000h:0000h to disable
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (see #0440)
Note:	the callback will be invoked on any socket changes whose notification
	  has not been disabled with the status change enable mask; it may be
	  invoked either while processing a hardware interrupt from the adapter
	  or while processing the following Socket Services request
SeeAlso: AH=80h"PCMCIA",AH=82h"PCMCIA"

(Table 0441)
Values PCMCIA callback routine is invoked with:
	AL = adapter number
	BH = status change interrupt enable mask (see #0442)
	BL = socket number
	DH = current socket status (see #0443)
	DL = current card status (see #0444)
Return: all registers preserved
Notes:	the callback may be invoked during a hardware interrupt, and may not
	  call on Socket Services
	the callback will be invoked once for each socket with a status change

Bitfields for PCMCIA status change interrupt enable mask:
Bit(s)	Description	(Table 0442)
 7	card detect change
 6	ready change
 5	battery warning change
 4	battery dead change
 3	insertion request
 2	ejection request
 1-0	reserved (0)

Bitfields for PCMCIA current socket status:
Bit(s)	Description	(Table 0443)
 7	card changed
 6	reserved (0)
 5	card insertion complete
 4	card ejection complete
 3	card insertion request pending
 2	card ejection request pending
 1	card locked
 0	reserved (0)

Bitfields for PCMCIA current card status:
Bit(s)	Description	(Table 0444)
 7	card detect
 6	ready
 5	battery voltage detect 2 (battery warning)
 4	battery voltage detect 1 (battery dead)
 3-1	reserved (0)
 0	write protected
--------s-1A8100-----------------------------
INT 1A - Tandy 2500, Tandy 1000L series - DIGITAL SOUND - INSTALLATION CHECK
	AX = 8100h
Return: AL > 80h if supported
	AX = 00C4h if supported (1000SL/TL)
	    CF set if sound chip is busy
	    CF clear  if sound chip is free
Note:	the value of CF is not definitive; call this function until CF is
	  clear on return, then call AH=84h"Tandy"
--------s-1A82-------------------------------
INT 1A - Tandy 2500???, Tandy 1000SL/TL - DIGITAL SOUND - RECORD SOUND
	AH = 82h
	ES:BX -> buffer for sound samples
	CX = length of buffer
	DX = transfer rate (1-4095, 1 is fastest)
Return: AH = 00h
	CF set if sound busy
	CF clear if sound chip free
Note:	the value in DX should be 1/10 the corresponding value for
	  INT 1A/AH=83h on the 1000TL, 1/11.5 on the 1000SL.  Call
	  INT 1A/AX=8100h and INT 1A/AH=84h before invoking this function.
	The BIOS issues an INT 15/AX=91FBh when the input is complete
	DMA across a 64K boundary is masked by the BIOS
--------X-1A82-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - REGISTER CARD TECHNOLOGY CALLBACK
	AH = 82h
	DS:DX -> callback routine (see #0445) or 0000h:0000h
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (see #0440)
Note:	the callback is invoked on a Write Multiple request with an unsupported
	  card technology type
SeeAlso: AH=81h"PCMCIA",AH=94h

(Table 0445)
Values PCMCIA callback routine is invoked with:
	ES:AX -> Low-Level Socket Services Routines (see #0447)
	BH = socket attributes (see #0446)
	CX = number of bytes or words to write
	DS:SI -> data buffer to be written
	DX:DI -> 26-bit linear card address
	BP = card technology type
Return: CF clear if successful
	CF set on error
	    AH = error code (07h,0Ch,12h,14h) (see #0440)

Bitfields for PCMCIA socket attributes:
Bit(s)	Description	(Table 0446)
 7-4	reserved (0)
 3	packed buffer
 2	even bytes only (only valid if 1 set)
 1	data width (clear = byte, set = word)
 0	memory type (clear = common, set = attribute)

Format of PCMCIA Low-Level Socket Services Routines:
Offset	Size	Description	(Table 0447)
 00h	WORD	offset of Write Many routine (see #0448)
 02h	WORD	offset of Write One routine (see #0449)
 04h	WORD	offset of Read One routine (see #0450)
 06h	WORD	offset of Increment Offset routine (see #0451)
 08h	WORD	offset of Set Offset routine (see #0452)
 0Ah	WORD	offset of Get Status routine (see #0453)

(Table 0448)
Call Write Many routine with:
	BH = socket attributes (see #0446)
	CX = number of bytes or words to write
	DS:SI -> data to be written
Return: CF clear if successful
	CF set on error

(Table 0449)
Call Write One routine with:
	AL/AX = data to be written
	BH = socket attributes (see #0446)
Return: CF clear if successful
	CF set on error

(Table 0450)
Call Read One routine with:
	BH = socket attributes (see #0446)
Return: CF clear if successful
	    AL/AX = data read
	CF set on error

(Table 0451)
Call Increment Offset routine with:
	BH = socket attributes (see #0446)
Return: CF clear if successful
	CF set on error

(Table 0452)
Call Set Offset routine with:
	DX:DI = new offset address
Return: CF clear if successful
	CF set on error

(Table 0453)
Call Get Status routine with:
	nothing
Return: AL = current card status (see #0444)
--------s-1A83-------------------------------
INT 1A - Tandy 2500, Tandy 1000L series - START PLAYING DIGITAL SOUND
	AH = 83h
	AL = volume (0=silence, 7=highest)
	CX = number of bytes to play
	DX = time between sound samples (multiples of 273 nanoseconds)
	    only bits 11-0 used
	ES:BX -> sound data (array of 8-bit unsigned PCM samples)
Return: AH = 00h
	CF set if sound is busy
	CF clear if sound chip is free
Notes:	this call returns immediately while the sound plays in the
	  background; the sound chip is clocked at 3.57 MHz, with the low 12
	  bits of DX specifying the clock divisor
	The BIOS appears to call INT 15/AX=91FBh when the sound device
	  underflows to allow another INT 1A/AH=83h for seamless playing of
	  long sounds.
SeeAlso: AH=84h"Tandy",INT 15/AH=91h
--------X-1A83-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - GET SOCKET SERVICES VERSION NUMBER
	AH = 83h
	AL = adapter number
Return: CF clear if successful
	    AX = Socket Services version (BCD)
	    BX = implementation version (BCD)
	    CX = 5353h ("SS")
	    DS:SI -> ASCIZ implementor description
	CF set on error
	    AH = error code (01h) (see #0440)
Note:	the current version (from the Revision A.00 documentation) of Socket
	  Services is 1.00 (AX=0100h)
SeeAlso: AH=80h"PCMCIA"
--------s-1A84-------------------------------
INT 1A - Tandy 2500, Tandy 1000L series - STOP PLAYING DIGITAL SOUND
	AH = 84h
Return: ???
Note:	the BIOS will call INT 15/AX=91FBh when the sound has stopped playing
SeeAlso: AH=83h"Tandy",AH=85h"Tandy"
--------X-1A84-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - INQUIRE ADAPTER
	AH = 84h
	AL = adapter number
Return: CF clear if successful
	    AH destroyed
	    BH = number of windows
	    BL = number of sockets (1-16)
	    CX = number of EDCs
	    DH = capabilities (see #0454)
	    DL = status change interrupt used (only if DH bit 3 set)(see #0455)
	CF set on error
	    AH = error code (01h) (see #0440)
SeeAlso: AH=80h"PCMCIA",AH=85h"PCMCIA",AH=87h

Bitfields for PCMCIA capabilities:
Bit(s)	Description	(Table 0454)
 7-6	reserved (0)
 5	status change interrupt is hardware shareable
 4	status change interrupt is software shareable
 3	status change interrupt
 2	data bus width is per-socket rather than per-window
 1	power management is per-adapter rather than per-socket
 0	indicators are per-adapter rather than per-socket

(Table 0455)
Values for PCMCIA status change interrupt usage:
 00h-0Fh IRQ level
 10h	NMI
 11h	I/O check
 12h	bus error
 13h	vendor specific
 14h-FFh reserved
--------s-1A85-------------------------------
INT 1A - Tandy 2500, Tandy 1000L series - DIGITAL SOUND???
	AH = 85h
	???
Return: ???
Note:	this function is not supported by the Tandy 1000SL/TL BIOS
SeeAlso: AH=7Fh,AH=83h"Tandy"
--------X-1A85-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - GET ADAPTER
	AH = 85h
	AL = adapter number
Return: CF clear if successful
	    AH destroyed
	    DH = adapter attributes (see #0456)
	CF set on error
	    AH = error code (01h) (see #0440)
SeeAlso: AH=84h"PCMCIA",AH=86h

Bitfields for PCMCIA adapter attributes:
Bit(s)	Description	(Table 0456)
 7-5	reserved (0)
 4	hardware share status change
 3	software share status change
 2	enable status change interrupts
 1	adapter preserves state information during reduced power consumption
 0	attempting to reduce power consumption
--------X-1A86-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - SET ADAPTER
	AH = 86h
	AL = adapter number
	DH = new adapter attributes (see #0456)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h) (see #0440)
SeeAlso: AH=84h"PCMCIA",AH=85h"PCMCIA"
--------X-1A87-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - INQUIRE WINDOW
	AH = 87h
	AL = adapter number
	BH = window number
Return: CF clear if successful
	    AH destroyed
	    BL = capabilities (see #0457)
	    CX = bitmap of assignable sockets
	    DH = EISA A15-A12 address lines (in bits 7-4, bits 3-0 = 0)
	    DL = supported access speeds (see #0458)
	    DS:SI -> Memory Window Characteristics table (see #0459)
	    DS:DI -> I/O Window Characteristics table (see #0460)
	CF set on error
	    AH = error code (01h,11h) (see #0440)
SeeAlso: AH=84h"PCMCIA",AH=88h,AH=89h,AH=8Ch

Bitfields for PCMCIA window capabilities:
Bit(s)	Description	(Table 0457)
 7-5	reserved (0)
 4	separate enable for EISA comon space
 3	EISA I/O mappable
 2	I/O space
 1	attribute memory
 0	common memory

Bitfields for PCMCIA supported access speeds:
Bit(s)	Description	(Table 0458)
 7	reserved (0)
 6	600 ns
 5	300 ns
 4	250 ns
 3	200 ns
 2	150 ns
 1	100 ns
 0	WAIT line monitoring

Format of PCMCIA Memory Window Characteristics table:
Offset	Size	Description	(Table 0459)
 00h	WORD	window capabilities (see #0461)
 02h	WORD	minimum base address in 4K pages
 04h	WORD	maximum base address in 4K pages
 06h	WORD	minimum window size in 4K pages
 08h	WORD	maximum window size in 4K pages
 0Ah	WORD	window size granularity (4K units)
 0Ch	WORD	required base address alignment (4K units)
 0Eh	WORD	required card offset alignment (4K units)

Format of PCMCIA I/O Window Characteristics table:
Offset	Size	Description	(Table 0460)
 00h	WORD	window capabilities (see #0461)
 02h	WORD	minimum base address in bytes
 04h	WORD	maximum base address in bytes
 06h	WORD	minimum window size in bytes
 08h	WORD	maximum window size in bytes
 0Ah	WORD	window size granularity (bytes)

Bitfields for PCMCIA window capabilities:
Bit(s)	Description	(Table 0461)
 0	programmable base address
 1	programmable window size
 2	window disable/enable supported
 3	8-data bus
 4	16-data bus
 5	base address alignment on size boundary required
 6	power-of-two size granularity
---memory windows---
 7	card offset must be aligned on size boundary
 8	paging hardware available
 9	paging hardware shared
 10	page disable/enable supported
 11-15	reserved (0)
---I/O windows---
 7-15	reserved (0)
--------X-1A88-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - GET WINDOW
	AH = 88h
	AL = adapter number
	BH = window number
Return: CF clear if successful
	    AH destroyed
	    BL = socket number (0-16) (0 = not assigned)
	    CX = window size (bytes for I/O window, 4K units for memory window)
	    DH = window attributes (see #0462)
	    DL = access speed (only one bit set) (see #0458)
	    SI = window base address (bytes if I/O, 4K units if memory)
	    DI = card offset address (memory only, 4K units)
	CF set on error
	    AH = error code (01h,11h) (see #0440)
SeeAlso: AH=87h,AH=89h,AH=8Ah

Bitfields for PCMCIA window attributes:
Bit(s)	Description	(Table 0462)
 0	memory-mapped rather than I/O-mapped
 1	attribute memory rather than common (memory-mapped)
	EISA mapped (I/O)
 2	enabled
 3	16-data path
 4	subdivided into pages (memory-mapped only)
 5	non-specific access slot enable (EISA-mapped only)
 6-7	reserved (0)
--------X-1A89-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - SET WINDOW
	AH = 89h
	AL = adapter number
	BH = window number
	BL = socket number
	CX = window size (bytes if I/O window, 4K units if memory window)
	DH = window attributes (see #0462)
	DL = access speed (only one bit set) (see #0458)
	SI = window base address (bytes if I/O, 4K units if memory window)
	DI = card offset addrress (memory only, 4K units)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,03h,07h,08h,0Ah,0Bh,0Dh,10h,11h) (see #0440)
SeeAlso: AH=87h,AH=88h,AH=8Bh
--------X-1A8A-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - GET PAGE
	AH = 8Ah
	AL = adapter number
	BH = window number
	BL = page number
Return: CF clear if successful
	    AH destroyed
	    DX = page attributes (see #0463)
	    DI = memory card offset (4K units)
	CF set on error
	    AH = error code (01h,08h,11h) (see #0440)
Notes:	this function is only valid for memory-mapped windows
	the socket being operated on is implied by the previous AH=89h call
SeeAlso: AH=88h,AH=8Bh

Bitfields for PCMCIA page attributes:
Bit(s)	Description	(Table 0463)
 0	page enabled
 15-1	reserved (0)
--------X-1A8B-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - SET PAGE
	AH = 8Bh
	AL = adapter number
	BH = window number
	BL = page number
	DX = page attributes (see #0463)
	DI = memory card offset (4K units)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,02h,07h,08h,11h) (see #0440)
Notes:	this function is only valid for memory-mapped windows
	the socket being operated on is implied by the previous AH=89h call
SeeAlso: AH=89h,AH=8Ah
--------X-1A8C-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - INQUIRE SOCKET
	AH = 8Ch
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
Return: CF clear if successful
	    AH destroyed
	    DH = capabilities (see #0464)
	    DL = hardware indicators (see #0465)
	    DS:SI -> Socket Characteristics table (see #0466)
	    DS:DI -> Power Management table (see #0468)
	CF set on error
	    AH = error code (01h,0Bh) (see #0440)
SeeAlso: AH=87h,AH=8Dh,AH=8Eh

Bitfields for PCMCIA socket capabilities:
Bit(s)	Description	(Table 0464)
 0	card change
 1	card lock
 2	insert card (motor control)
 3	eject card (motor control)
 4-7	reserved (0)

Bitfields for PCMCIA socket hardware indicators:
Bit(s)	Description	(Table 0465)
 0	busy status
 1	write-protected
 2	battery status
 3	card lock status
 4	XIP status (eXecute-In-Place)
 5-7	reserved (0)

Format of PCMCIA Socket Characteristics table:
Offset	Size	Description	(Table 0466)
 00h	WORD	supported card types (see #0467)
 02h	WORD	steerable IRQ levels (bit 0 = IRQ0 to bit 15 = IRQ15)
 04h	WORD	additional steerable IRQ levels
		bit 0: NMI
		bit 1: I/O check
		bit 2: bus error
		bit 3: vendor-unique
		bits 4-7 reserved (0)

Bitfields for supported card types:
Bit(s)	Description	(Table 0467)
 0	memory card
 1	I/O card
 2-7	reserved (0)

Format of PCMCIA Power Management table:
Offset	Size	Description	(Table 0468)
 00h	WORD	number of entries in table (0 if power management not avail)
 02h 2N BYTEs	power levels
		byte 0: voltage in 0.1V units
		byte 1: power supply
			bit 7: Vcc
			bit 6: Vpp1
			bit 5: Vpp2
--------X-1A8D-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - GET SOCKET
	AH = 8Dh
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
Return: CF clear if successful
	    AH destroyed
	    BH = status change interrupt enable mask (see #0442)
	    CH = Vcc level (lower nybble) (see #0468)
	    CL = Vpp1 level (upper nybble) and Vpp2 level (lower nybble)
	    DH = current socket status (see #0443)
	    DL = indicators (see #0465)
	    SI = card type (see #0469)
	    DI = IRQ level steering (I/O only) (see #0470)
	CF set on error
	    AH = error code (01h,0Bh) (see #0440)
SeeAlso: AH=8Ch,AH=8Eh

Bitfields for PCMCIA card type:
Bit(s)	Description	(Table 0469)
 0	memory
 1	I/O
 2-15	reserved (0)

Bitfields for PCMCIA I/O level steering:
Bit(s)	Description	(Table 0470)
 15	interrupt steering enabled
 14-5	reserved (0)
 4-0	IRQ level (0-15=IRQ,16=NMI,17=I/O check,18=bus error,19=vendor)
--------X-1A8E-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - SET SOCKET
	AH = 8Eh
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
	BH = status change interrupt enable mask (see #0442)
	CL = Vpp1 level (upper nybble) and Vpp2 level (lower nybble)
	DH = current socket status (see #0443)
	DL = indicators (see #0465)
	SI = card type (see #0469)
	DI = IRQ level steering (I/O only) (see #0470)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,02h,05h,06h,0Bh,0Eh,0Fh) (see #0440)
SeeAlso: AH=8Ch,AH=8Dh
--------X-1A8F-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - GET CARD
	AH = 8Fh
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
Return: CF clear if successful
	    AH destroyed
	    DL = current card status (see #0444)
	CF set on error
	    AH = error code (01h,0Bh) (see #0440)
SeeAlso: AH=8Dh,AH=90h
--------X-1A90-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - RESET CARD
	AH = 90h
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,0Bh,14h) (see #0440)
Note:	toggles RESET pin of the specified card, but does not wait after
	  toggling the pin; it is the caller's responsibility to avoid
	  accessing the card before it is ready again
--------X-1A91-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - READ ONE
	AH = 91h
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
	BH = attributes (see #0471)
	DX:SI = card address
Return: CF clear if successful
	    AH destroyed
	    CL/CX = value read
	CF set on error
	    AH = error code (01h,07h,09h,0Bh,14h) (see #0440)
	    CX may be destroyed
Note:	this function is only valid for I/O-mapped sockets
SeeAlso: AH=92h,AH=93h,INT 21/AX=440Dh"IOCTL"

Bitfields for PCMCIA attributes:
Bit(s)	Description	(Table 0471)
 2	even bytes only
 1	word rather than byte
 0	attribute memory instead of common memory
--------X-1A92-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - WRITE ONE
	AH = 92h
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
	BH = attributes (see #0471)
	CL/CX = value to write
	DX:SI = card address
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,07h,0Bh,12h,14h) (see #0440)
Note:	this function is only valid for I/O-mapped sockets; it also does not
	  implement Card Technology handling--use AH=94h when writing to
	  non-RAM technologies
SeeAlso: AH=91h,AH=94h,INT 21/AX=440Dh"IOCTL"
--------X-1A93-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - READ MULTIPLE
	AH = 93h
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
	BH = attributes (see #0471)
	CX = number of bytes or words to read
	DX:SI = card address
	DS:DI -> data buffer to be filled
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,07h,09h,0Bh,14h) (see #0440)
Note:	this function is only available on I/O-mapped sockets
SeeAlso: AH=91h,AH=94h,INT 21/AX=440Dh"IOCTL"
--------X-1A94-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - WRITE MULTIPLE
	AH = 94h
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
	BH = attributes (see #0471)
	CX = number of bytes or words to read
	DX:DI = card address
	DS:SI -> buffer containing data
	BP = Card Technology type (0000h = RAM)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,07h,0Bh,0Ch,12h,14h) (see #0440)
Notes:	this function is only available on I/O-mapped sockets
	Socket Services calls the Card Technology callback (see #0445) for
	  any card technology it does not directly support
SeeAlso: AH=82h"PCMCIA",AH=92h,AH=93h,INT 21/AX=440Dh"IOCTL"
--------X-1A95-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - INQUIRE ERROR DETECTION CODE
	AH = 95h
	AL = adapter number
	BH = EDC generator number
Return: CF clear if successful
	    AH destroyed
	    CX = bitmap of assignable sockets
	    DH = EDC capabilities (see #0472)
	    DL = supported EDC types (see #0473)
	CF set on error
	    AH = error code (01h,04h) (see #0440)
SeeAlso: AH=96h,AH=9Ch

Bitfields for EDC capabilities:
Bit(s)	Description	(Table 0472)
 0	unidirectional only generation
 1	bidirectional only generation
 2	register-based (I/O-mapped) support
 3	memory-mapped support
 4	pausable
 5-7	reserved (0)

Bitfields for supported EDC types:
Bit(s)	Description	(Table 0473)
 0	8-checksum
 1	16-CRC-SDLC
 2-7	reserved (0)
--------X-1A96-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - GET ERROR DETECTION CODE
	AH = 96h
	AL = adapter number
	BH = EDC generator number
Return: CF clear if successful
	    AH destroyed
	    BL = socket number
	    DH = EDC attributes (see #0474)
	    DL = EDC type (see #0473) (only one bit set)
	CF set on error
	    AH = error code (01h,04h) (see #0440)
SeeAlso: AH=95h,AH=97h,AH=9Ch

Bitfields for EDC attributes:
Bit(s)	Description	(Table 0474)
 0	unidirectional only
 1	(if 0 set) clear=read, set=write
 2-7	reserved (0)
--------X-1A97-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - SET ERROR DETECTION CODE
	AH = 97h
	AL = adapter number
	BH = EDC generator
	BL = socket number
	DH = EDC attributes (see #0474)
	DL = EDC type (see #0473) (only one bit may be set)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,02h,04h,0Bh) (see #0440)
SeeAlso: AH=96h,AH=9Ch
--------X-1A98-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - START ERROR DETECTION CODE
	AH = 98h
	AL = adapter number
	BH = EDC generator
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,04h) (see #0440)
SeeAlso: AH=96h,AH=99h,AH=9Bh,AH=9Ch
--------X-1A99-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - PAUSE ERROR DETECTION CODE
	AH = 99h
	AL = adapter number
	BH = EDC generator
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,04h) (see #0440)
SeeAlso: AH=9Ah
--------X-1A9A-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - RESUME ERROR DETECTION CODE
	AH = 9Ah
	AL = adapter number
	BH = EDC generator
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,04h) (see #0440)
SeeAlso: AH=99h,AH=98h
--------X-1A9B-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - STOP ERROR DETECTION CODE
	AH = 9Bh
	AL = adapter number
	BH = EDC generator
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (see #0440)
SeeAlso: AH=98h,AH=99h,AH=9Ch
--------X-1A9C-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - READ ERROR DETECTION CODE
	AH = 9Ch
	AL = adapter number
	BH = EDC generator
Return: CF clear if successful
	    AH destroyed
	    DL/DX = computed checksum or CRC
	CF set on error
	    AH = error code (01h,04h) (see #0440)
SeeAlso: AH=95h,AH=96h,AH=98h,AH=99h,AH=9Bh
--------c-1AA0-------------------------------
INT 1A U - Disk Spool II v2.07+ - INSTALLATION CHECK
	AH = A0h
Return: AH = B0h if installed
	    AL = pending INT 1A/AH=D0h subfunction if nonzero???
	    ES = code segment
	    ES:BX -> name of current spool file
	    ES:SI -> current despool file
	    CL = despooler state (00h disabled, 41h enabled)
	    CH = spooler state (00h disabled, 41h enabled)
	    DL = despooler activity
		00h currently active printing a file
		41h standing by
	    DH = 00h ???
	       = 41h ???
	    DI = 0000h ???
		 0001h ???
Program: Disk Spool II is a shareware disk-based print spooler by Budget
	  Software Company
Note:	this function is also supported by Vertisoft's Emulaser utility ELSPL,
	  as that is a licensed version of Disk Spool II
SeeAlso: AH=ABh,AH=C0h,AH=D0h,AH=E1h
--------c-1AAB-------------------------------
INT 1A U - Disk Spool II v1.83 - INSTALLATION CHECK
	AH = ABh
Return: AH = BAh if installed
	    AL = pending INT 1A/AH=ADh subfunction if nonzero???
	    ES = code segment
	    ES:BX -> name of current spool file
	    ES:SI -> current despool file
	    CL = despooler state (00h disabled, 41h enabled)
	    CH = spooler state (00h disabled, 41h enabled)
	    DL = despooler activity
		00h currently active printing a file
		41h standing by
	    DH = 00h ???
	       = 41h ???
	    DI = 0000h ???
		 0001h ???
Program: Disk Spool II is a shareware disk-based print spooler by Budget
	  Software Company
SeeAlso: AH=A0h,AH=ACh,AH=ADh,AH=E1h
--------c-1AAC-------------------------------
INT 1A U - Disk Spool II v1.83 - INSTALLATION CHECK
	AH = ACh
Return: (see AH=ABh)
Note:	this function is identical to AH=ABh
SeeAlso: AH=A0h,AH=ABh,AH=ADh
--------c-1AAD-------------------------------
INT 1A U - Disk Spool II v1.83 - FUNCTION CALLS
	AH = ADh
	AL = function code (see #0475)
Return: AH = 00h if successful
SeeAlso: AH=ABh

(Table 0475)
Values for Disk Spool function code:
 02h	enable spooler only
 03h	enable the despooler
 04h	disable the despooler
 08h	inhibit popup menu
 09h	enable popup menu
 0Ah	???
 0Bh	disable the spooler
 0Ch	start despooler after last successfully printed document???
 0Dh	start despooler at the exact point where it last left off???
 0Eh	pop up the menu
 0Fh	???
 11h	???
 14h	???
 15h	???
 16h	???
 17h	???
 18h	???
 19h	???
 20h	clear file pointed to by the despooler???
 21h	???
 22h	???
 23h	???
 30h	???
--------d-1AB001CX4D52-----------------------
INT 1A - Microsoft Real-Time Compression Interface (MRCI) - ROM-BASED SERVER
	AX = B001h
	CX = 4D52h ("MR")
	DX = 4349h ("CI")
Return: CX = 4943h ("IC") if installed
	DX = 524Dh ("RM") if installed
	    ES:DI -> MRCINFO structure (see #0476)
Note:	this call is functionally identical to INT 2F/AX=4A12h, which should
	  be called first, as this call is used for the first, ROM-based
	  MRCI server, while the other call is used for RAM-based servers
	  which may be partially or entirely replacing a prior server
SeeAlso: INT 2F/AX=4A12h

Format of MRCINFO structure:
Offset	Size	Description	(Table 0476)
 00h  4 BYTEs	vendor signature
		"MSFT" Microsoft
 04h	WORD	server version (high=major)
 06h	WORD	MRCI specification version
 08h	DWORD	address of server entry point (see #0478)
 0Ch	WORD	bit flags: server capabilities (see #0477)
 0Eh	WORD	bit flags: hardware assisted capabilities (see #0477)
 10h	WORD	maximum block size supported by server (at least 8192 bytes)

Bitfields for MRCI capabilities:
Bit(s)	Description	(Table 0477)
 0	standard compress
 1	standard decompress
 2	update compress
 3	MaxCompress (not present in initial public release)
 4	reserved
 5	incremental decompress
 6-14	reserved
 15	this structure is in ROM and can't be modified
	(server capabilities only)

(Table 0478)
Call MRCI entry point with:
	DS:SI -> MRCREQUEST structure (see #0479)
	CX = type of client (0000h application, 0001h file system)
	AX = operation
	    0001h perform standard compression
	    0002h perform standard decompression
	    0004h perform update compression
	    0008h perform MaxCompress
	    0020h perform incremental decompression
	AX = FFFFh clear flags
	    BX = bitmask of flags to clear (set bits in BX are flags to clear)
Return: AX = status
	    0000h successful
	    0001h invalid function
	    0002h server busy, try again
	    0003h destination buffer too small
	    0004h incompressible data
	    0005h bad compressed data format
	BP destroyed (MS-DOS 6.2)
Note:	MRCI driver may chain to a previous driver

Format of MRCREQUEST structure:
Offset	Size	Description	(Table 0479)
 00h	DWORD	pointer to source buffer
 04h	WORD	size of source buffer (0000h = 64K)
 06h	WORD	(UpdateCompress only)
		(call) offset in source buffer of beginning of changed data
		(return) offset in destination buffer of beginning of changed
			  compressed data
 08h	DWORD	pointer to destination buffer
		must contain original compressed data for UpdateCompress
 0Ch	WORD	size of destination buffer (0000h = 64K)
		any compression: size of buffer for compressed data
		standard decompression: number of bytes to be decompressed
		incremental decompression: number of byte to decompress now
		(return) actual size of resulting data
 0Eh	WORD	client compressed data storage allocation size
 10h	DWORD	incremental decompression state data
		set to 00000000h before first incremental decompression call
Notes:	the source and destination buffers may not overlap
	the source and destination buffer sizes should normally be the same
	application should not update the contents of the MRCREQUEST structure
	  between incremental decompression calls
--------X-1AB101-----------------------------
INT 1A - Intel PCI BIOS v2.0c - INSTALLATION CHECK
	AX = B101h
Return: AH = 00h if installed
	    CF clear
	    EDX = 20494350h (' ICP')
	    EDI = physical address of protected-mode entry point (see #0481)
	    AL = PCI hardware characteristics (see #0480)
	    BH = PCI interface level major version (BCD)
	    BL = PCI interface level minor version (BCD)
	    CL = number of last PCI bus in system
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Note:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
SeeAlso: AX=B181h

Bitfields for PCI hardware characteristics:
Bit(s)	Description	(Table 0480)
 0	configuration space access mechanism 1 supported
 1	configuration space access mechanism 2 supported
 2-3	reserved
 4	Special Cycle generation mechanism 1 supported
 5	Special Cycle generation mechanism 2 supported
 6-7	reserved

(Table 0481)
Call protected-mode entry point with:
	registers as for real/V86-mode INT call
	CS = ring 0 descriptor with access to full address space
Return: as for real/V86-mode call
--------X-1AB102-----------------------------
INT 1A - Intel PCI BIOS v2.0c - FIND PCI DEVICE
	AX = B102h
	CX = device ID
	DX = vendor ID
	SI = device index (0-n)
Return: CF clear if successful
	CF set on error
	AH = status
	    00h successful
		BL = bus number
		BH = device/function number (bits 7-3 device, bits 2-0 func)
	    83h bad vendor ID
	    86h device not found
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	device ID FFFFh may be reserved as a wildcard in future implementations
	the meanings of BL and BH on return may be exchanged in future
	  implementations
	all devices sharing a single vendor ID and device ID may be enumerated
	  by incrementing SI from 0 until error 86h is returned
SeeAlso: AX=B182h
--------X-1AB103-----------------------------
INT 1A - Intel PCI BIOS v2.0c - FIND PCI CLASS CODE
	AX = B103h
	ECX = class code (bits 23-0)
	SI = device index (0-n)
Return: CF clear if successful
	CF set on error
	AH = status
	    00h successful
		BL = bus number
		BH = device/function number (bits 7-3 device, bits 2-0 func)
	    86h device not found
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on return may be exchanged in future
	  implementations
	all devices sharing the same Class Code may be enumerated by
	  incrementing SI from 0 until error 86h is returned
SeeAlso: AX=B183h
--------X-1AB106-----------------------------
INT 1A - Intel PCI BIOS v2.0c - PCI BUS-SPECIFIC OPERATIONS
	AX = B106h
	BL = bus number
	EDX = Special Cycle data
Return: CF clear if successful
	CF set on error
	AH = status
	    00h successful
	    81h unsupported function
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Note:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
SeeAlso: AX=B186h
--------X-1AB108-----------------------------
INT 1A - Intel PCI BIOS v2.0c - READ CONFIGURATION BYTE
	AX = B108h
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
Return: CF clear if successful
	    CL = byte read
	CF set on error
	AH = status
	    00h successful
	    87h bad register number
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry may be exchanged in future
	  implementations
SeeAlso: AX=B188h
--------X-1AB109-----------------------------
INT 1A - Intel PCI BIOS v2.0c - READ CONFIGURATION WORD
	AX = B109h
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
Return: CF clear if successful
	    CX = word read
	CF set on error
	AH = status
	    00h successful
	    87h bad register number
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry may be exchanged in future
	  implementations
SeeAlso: AX=B189h
--------X-1AB10A-----------------------------
INT 1A - Intel PCI BIOS v2.0c - READ CONFIGURATION DWORD
	AX = B10Ah
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
Return: CF clear if successful
	    ECX = dword read
	CF set on error
	AH = status
	    00h successful
	    87h bad register number
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry may be exchanged in future
	  implementations
SeeAlso: AX=B18Ah
--------X-1AB10B-----------------------------
INT 1A - Intel PCI BIOS v2.0c - WRITE CONFIGURATION BYTE
	AX = B10Bh
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
	CL = byte to write
Return: CF clear if successful
	CF set on error
	AH = status
	    00h successful
	    87h bad register number
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry may be exchanged in future
	  implementations
SeeAlso: AX=B18Bh
--------X-1AB10C-----------------------------
INT 1A - Intel PCI BIOS v2.0c - WRITE CONFIGURATION WORD
	AX = B10Ch
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (multiple of 2 less than 0100h)
	CX = word to write
Return: CF clear if successful
	CF set on error
	AH = status
	    00h successful
	    87h bad register number
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry may be exchanged in future
	  implementations
SeeAlso: AX=B18Ch
--------X-1AB10D-----------------------------
INT 1A - Intel PCI BIOS v2.0c - WRITE CONFIGURATION DWORD
	AX = B10Dh
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (multiple of 4 less than 0100h)
	ECX = dword to write
Return: CF clear if successful
	CF set on error
	AH = status
	    00h successful
	    87h bad register number
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry may be exchanged in future
	  implementations
SeeAlso: AX=B18Dh
--------X-1AB181-----------------------------
INT 1A - Intel PCI BIOS v2.0c - INSTALLATION CHECK (32-bit)
	AX = B181h
Return: as for AX=B101h
SeeAlso: AX=B101h
--------X-1AB182-----------------------------
INT 1A - Intel PCI BIOS v2.0c - FIND PCI DEVICE (32-bit)
	AX = B182h
	CX = device ID
	DX = vendor ID
	SI = device index (0-n)
Return: as for AX=B102h
SeeAlso: AX=B102h
--------X-1AB183-----------------------------
INT 1A - Intel PCI BIOS v2.0c - FIND PCI CLASS CODE (32-bit)
	AX = B183h
	ECX = class code (bits 23-0)
	SI = device index (0-n)
Return: as for AX=B103h
SeeAlso: AX=B103h
--------X-1AB186-----------------------------
INT 1A - Intel PCI BIOS v2.0c - PCI BUS-SPECIFIC OPERATIONS (32-bit)
	AX = B186h
	BL = bus number
	EDX = Special Cycle data
Return: as for AX=B106h
SeeAlso: AX=B106h
--------X-1AB188-----------------------------
INT 1A - Intel PCI BIOS v2.0c - READ CONFIGURATION BYTE (32-bit)
	AX = B188h
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
Return: as for AX=B108h
SeeAlso: AX=B108h
--------X-1AB189-----------------------------
INT 1A - Intel PCI BIOS v2.0c - READ CONFIGURATION WORD (32-bit)
	AX = B189h
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
Return: as for AX=B109h
SeeAlso: AX=B109h
--------X-1AB18A-----------------------------
INT 1A - Intel PCI BIOS v2.0c - READ CONFIGURATION DWORD (32-bit)
	AX = B18Ah
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
Return: as for AX=B10Ah
SeeAlso: AX=B10Ah
--------X-1AB18B-----------------------------
INT 1A - Intel PCI BIOS v2.0c - WRITE CONFIGURATION BYTE (32-bit)
	AX = B18Bh
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
	CL = byte to write
Return: as for AX=B10Bh
SeeAlso: AX=B10Bh
--------X-1AB18C-----------------------------
INT 1A - Intel PCI BIOS v2.0c - WRITE CONFIGURATION WORD (32-bit)
	AX = B18Ch
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (multiple of 2 less than 0100h)
	CX = word to write
Return: as for AX=B10Ch
SeeAlso: AX=B10Ch
--------X-1AB18D-----------------------------
INT 1A - Intel PCI BIOS v2.0c - WRITE CONFIGURATION DWORD (32-bit)
	AX = B18Dh
	BL = bus number
	BH = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (multiple of 4 less than 0100h)
	ECX = dword to write
Return: as for AX=B10Dh
SeeAlso: AX=B10Dh
--------X-1AB4-------------------------------
INT 1A - Intel Plug-and-Play BIOS Extensions - API
	AH = B4h
	AL = function (00h-07h)
	further details not yet available
--------c-1AC0-------------------------------
INT 1A U - Disk Spool II v2.07+ - ALTERNATE INSTALLATION CHECK
	AH = C0h
Return: (see AH=A0h)
Notes:	this call is identical to AH=A0h
	this function is also supported by Vertisoft's Emulaser utility ELSPL,
	  as that is a licensed version of Disk Spool II
SeeAlso: AH=A0h,AH=ABh,AH=D0h
--------U-1ACCCCBXCCCC-----------------------
INT 1A U - DATEFIX - INSTALLATION CHECK
	AX = CCCCh
	BX = CCCCh
	CX = 0000h
Return: CX = CCCCh if installed
	    ES:BX -> original interrupt handler
Program: DATEFIX is a public-domain TSR to correct the date on AT&T 6300
	  machines, where the realtime clock's calendar wraps after 1991
SeeAlso: AH=FEh,AH=FFh"AT&T"
--------c-1AD0-------------------------------
INT 1A U - Disk Spool II v2.07+ - FUNCTION CALLS
	AH = D0h
	AL = function code
	    01h enable spooler and despooler
	    02h enable spooler only
	    03h enable despooler at beginning of file
	    04h disable the despooler
	    05h disable the despooler and spooler
	    06h clear the spool file
	    08h inhibit the popup menu
	    09h enable the popup menu
	    0Ah ??? (called by Disk Spool's INT 21 handler)
	    0Bh disable the spooler
	    0Ch start despooler after last successfully printed document
	    0Dh start despooler at the exact point where it last left off
	    0Eh pop up the menu
	    0Fh ???
	    11h start new spool file??? (called by Disk Spool's INT 21 handler
			when a program terminates)
	    14h ???
	    15h delete despool file and reset ???
	    16h ??? (writes something to unknown file)
	    17h ??? (writes something to despool file, then reads something
			else and ???)
	    18h ??? (reads something from despool file, and then ???)
	    19h ??? (creates/truncates spool file)
	    20h clear file pointed to by the despooler
	    21h ??? (writes something to unknown file)
	    22h ??? (writes something to spool file if spooler/despooler using
			same file)
	    23h ??? (opens/creates unknown file, then ???)
	    30h ???
	    31h ???
	    32h beep
	    33h append CRLF to spool file???
	    34h ???
	    35h ???
	    36h ???
	    37h append CRLF to spool file and start a new spool file???
	    38h ???
	    40h ??? (v4.05)
	    41h ??? (v4.05)
	    51h ??? (called by Disk Spool's INT 21 handler)
	    52h ??? (called by Disk Spool's INT 21 handler)
	    57h ???
	    5Ah ??? (v4.05)
	    5Bh ??? (v4.05)
	    5Ch ??? (v4.05)
Note:	this function is also supported by Vertisoft's Emulaser utility ELSPL,
	  as that is a licensed version of Disk Spool II
SeeAlso: AH=A0h,AH=ADh
--------c-1AE0-------------------------------
INT 1A - Disk Spool II v4.0x - ENABLE/DISABLE
	AH = E0h
	AL = subfunction
	    01h enable spooler
	    02h disable spooler
	    03h enable despooler
	    04h disable despooler
	CL = printer port (01h COM1, 02h COM2, 05h LPT1, 06h LPT2)
Return: AH = status
	    00h successful
	    F0h printer port not managed by Disk Spool II
	    FFH failed
Note:	this function is also supported by Vertisoft's Emulaser utility ELSPL,
	  as that is a licensed version of Disk Spool II
SeeAlso: AH=A0h,AH=E1h,AX=E301h,AX=E401h
--------c-1AE1-------------------------------
INT 1A - Disk Spool II v4.0x - GET STATUS
	AH = E1h
	CL = printer port (01h COM1, 02h COM2, 05h LPT1, 06h LPT2)
Return: AH = status
	    00h successful
		CL = despooler state (00h disabled, 41h enabled)
		CH = spooler state (00h disabled, 41h enabled)
		DL = despooler activity (00h standing by, 41h printing)
		ES:BX -> ASCIZ name of current spool file (or next if AutoSpool
			or AutoDespool enabled)
		ES:SI -> ASCIZ name of current despool file
		ES:DI -> 3-byte file extension used by Disk Spool II
	    F0h printer port not managed by Disk Spool II
Note:	this function is also supported by Vertisoft's Emulaser utility ELSPL,
	  as that is a licensed version of Disk Spool II
SeeAlso: AH=A0h,AH=E0h,AH=E2h
--------c-1AE2-------------------------------
INT 1A - Disk Spool II v4.0x - GET SPOOL FILES
	AH = E2h
	AL = which
	    01h first
	    02h next (can only call after "first")
	CL = printer port (01h COM1, 02h COM2, 05h LPT1, 06h LPT2)
Return: AH = status
	    00h successful
		ES:BX -> ASCIZ filename
	    F0h no (more) spool files
	    FFh failed
Note:	this function is also supported by Vertisoft's Emulaser utility ELSPL,
	  as that is a licensed version of Disk Spool II
SeeAlso: AH=E0h,AH=E1h
--------c-1AE301-----------------------------
INT 1A - Disk Spool II v4.0x - GET SPOOL FILE STATUS
	AX = E301h
	ES:BX -> ASCIZ filename (max 32 chars)
Return: AH = status
	    00h successful
		ES:SI -> spool file status record (see #0482)
	    F0h not a spool file
	    FFh failed
Note:	this function is also supported by Vertisoft's Emulaser utility ELSPL,
	  as that is a licensed version of Disk Spool II
SeeAlso: AH=E0h,AX=E302h,AX=E401h

Format of Disk Spool II spool file status record:
Offset	Size	Description	(Table 0482)
 00h	BYTE	hour of creation or last update
 01h	BYTE	minute of creation or last update
 02h	BYTE	year-1980 of creation or last update
 03h	BYTE	month of creation or last update
 04h	BYTE	day of creation or last update
 05h	BYTE	total number of copies to print
 06h	BYTE	number of copies already printed
 07h	BYTE	printer port (01h COM1, 02h COM2, 05h LPT1, 06h LPT2)
 08h	BYTE	save status (00h delete after printing, 01h save)
 09h	BYTE	file status
		01h done printing, but being saved
		02h on hold
		03h queued for printing
		04h being spooled
		05h being despooled (i.e. printed)
 0Ah 16 BYTEs	ASCIZ description
 1Ah  2 WORDs	file size in bytes (high,low)
 1Eh  2 WORDs	bytes left to print (high,low)
--------c-1AE302-----------------------------
INT 1A - Disk Spool II v4.0x - UPDATE SPOOL FILE
	AX = E302h
	ES:BX -> ASCIZ filename (max 32 chars)
	ES:SI -> spool file status record (see #0482)
Return: AH = status
	    00h successful
	    F0h not a spool file
	    FFh failed
Note:	this function is also supported by Vertisoft's Emulaser utility ELSPL,
	  as that is a licensed version of Disk Spool II
SeeAlso: AH=E0h,AX=E301h,AX=E401h
--------c-1AE401-----------------------------
INT 1A - Disk Spool II v4.0x - SPOOL EXISTING FILE
	AX = E401h
	ES:BX -> ASCIZ filename (max 32 chars)
	CL = printer port (01h COM1, 02h COM2, 05h LPT1, 06h LPT2)
Return: AH = status
	    00h successful
	    FFh failed
Note:	this function is also supported by Vertisoft's Emulaser utility ELSPL,
	  as that is a licensed version of Disk Spool II
SeeAlso: AH=E1h,AX=E302h,AX=E402h
--------c-1AE402-----------------------------
INT 1A U - Disk Spool II v4.0x - SPOOL EXISTING FILE???
	AX = E402h
	ES:BX -> ASCIZ filename (max 32 chars)
	CL = printer port (01h COM1, 02h COM2, 05h LPT1, 06h LPT2)
Return: AH = status
	    00h successful
	    FFh failed
Note:	this function is also supported by Vertisoft's Emulaser utility ELSPL,
	  as that is a licensed version of Disk Spool II
SeeAlso: AH=E1h,AX=E302h,AX=E401h
--------c-1AE5-------------------------------
INT 1A U - Emulaser ELSPL.COM - ???
	AH = E5h
	???
Return: ???
Program: ELSPL.COM is a licensed version of Disk Spool II which is distributed
	  as part of Vertisoft's Emulaser PostScript emulator
SeeAlso: AH=A0h,INT 17/AH=03h
--------c-1AEE-------------------------------
INT 1A U - Disk Spool II v4.05 - ???
	AH = EEh
	AL = printer port???
	???
Return: ???
Note:	this function is also supported by Vertisoft's Emulaser utility ELSPL,
	  as that is a licensed version of Disk Spool II
SeeAlso: AH=E1h
--------U-1AF7-------------------------------
INT 1A - RighTime v1.1 - TEMPORARILY DISABLE
	AH = F7h
Program: RighTime is a TSR by G.T. Becker which continuously adjusts the system
	  time to correct for clock drift
Note:	any AH value from F0h-F7h or F9h-FEh will perform this function in
	  version 1.1, but F7h is the function called by transient portion
SeeAlso: AH=F8h,AH=FFh"RighTime"
--------U-1AF8-------------------------------
INT 1A - RighTime v1.1 - ENABLE
	AH = F8h
Program: RighTime is a TSR by G.T. Becker which continuously adjusts the system
	  time to correct for clock drift
Note:	RighTime is TeSseRact-compatible (see INT 2F/AX=5453h) and modifies its
	  TeSseRact program identifier based on its current state: "RighTime"
	  when enabled, "RighTim"F7h when disabled.
SeeAlso: AH=F7h,AH=FFh"RighTime"
--------b-1AFE-------------------------------
INT 1A - AT&T 6300 - READ TIME AND DATE
	AH = FEh
Return: BX = day count (0 = Jan 1, 1984)
	CH = hour
	CL = minute
	DH = second
	DL = hundredths
SeeAlso: AX=CCCCh/BX=CCCCh,AH=FFh"AT&T",INT 21/AH=2Ah,INT 21/AH=2Ch
--------b-1AFF-------------------------------
INT 1A - AT&T 6300 - SET TIME AND DATE
	AH = FFh
	BX = day count (0 = Jan 1, 1984)
	CH = hour
	CL = minute
	DH = second
	DL = hundredths
Return: ???
SeeAlso: AX=CCCCh/BX=CCCCh,AH=FEh,INT 21/AH=2Bh,INT 21/AH=2Dh
--------U-1AFF-------------------------------
INT 1A - RighTime v1.1 - PERMANENTLY DISABLE
	AH = FFh
Program: RighTime is a TSR by G.T. Becker which continuously adjusts the system
	  time to correct for clock drift
Note:	upon being permanently disabled, RighTime closes the file handle
	  referencing its executable (which is updated with time correction
	  information every two minutes while RighTime is enabled).
--------s-1AFF00-----------------------------
INT 1A - SND - INSTALLATION CHECK???
	AX = FF00h
Return: AL = version??? (02h)
	AH = busy flag (00h if not in a SND call, 01h if SND currently active)
Note:	the SND API is also supported by IC (Internal Commands) v2.0, a
	  shareware TSR by Geoff Friesen which extends COMMAND.COM's internal
	  command set
SeeAlso: AX=FF01h,AX=FF02h,AX=FF04h,AX=FF05h
--------s-1AFF01-----------------------------
INT 1A - SND - PAUSE
	AX = FF01h
	DX = number of clock ticks to delay
Return: AH = status
	    00h successful
	    01h SND busy
Notes:	if successful, execution returns to the caller after the delay expires;
	  if SND is busy, execution returns immediately
	the IC v2.0 implementation of this API makes no special allowance for
	  time rollover at midnight, which can cause the delay to be over one
	  hour if this function is called just before the BIOS time count
	  rolls over and the delay extends into the next day
SeeAlso: AX=FF00h,INT 15/AH=86h,INT 62/AX=0096h,INT 7F/AH=E8h,INT 80/BX=0009h
SeeAlso: INT E0/CL=BDh
--------s-1AFF02-----------------------------
INT 1A - SND - START SOUND
	AX = FF02h
	DX = frequency in Hertz (14h-FFFFh)
Return: AH = status
	    00h successful
	    01h SND busy
SeeAlso: AX=FF00h,AX=FF01h,AX=FF03h
--------s-1AFF03-----------------------------
INT 1A - SND - STOP SOUND
	AX = FF03h
Return: AH = status
	    00h successful
	    01h busy
Note:	turns off any sound currently being emitted by the PC's speaker unless
	  SND is currently busy processing an API call (this includes
	  background music).  Use AX=FF05h to stop the sound even if an API
	  call is in progress.
SeeAlso: AX=FF00h,AX=FF02h,AX=FF05h
--------s-1AFF04-----------------------------
INT 1A - SND - PLAY MUSIC STRING IN BACKGROUND
	AX = FF04h
	DS:DX -> ASCIZ music string
Return: AH = status
	    00h successful (music begins playing in background)
	    01h busy
Note:	the music string accepted by SND is not the same as that accepted by
	  BASIC and other programs which process music strings
SeeAlso: AX=FF00h,AX=FF05h,INT 80/BX=0006h
--------s-1AFF05-----------------------------
INT 1A - SND - UNCONDITIONALLY STOP SOUND
	AX = FF05h
Return: AH = 00h (successful)
Note:	this function is the same as AX=FF03h, but will stop the sound even if
	  SND is currently busy, such as playing background music
SeeAlso: AX=FF00h,AX=FF03h,INT 80/BX=0007h
--------B-1B---------------------------------
INT 1B C - KEYBOARD - CONTROL-BREAK HANDLER
Desc:	this interrupt is automatically called when INT 09 determines that
	  Control-Break has been pressed
Note:	normally points to a short routine in DOS which sets the Ctrl-C flag,
	  thus invoking INT 23h the next time DOS checks for Ctrl-C.
SeeAlso: INT 23
--------B-1C---------------------------------
INT 1C - TIME - SYSTEM TIMER TICK
Desc:	this interrupt is automatically called on each clock tick by the INT 08
	  handler
Notes:	this is the preferred interrupt to chain when a program needs to be
	  invoked regularly
	not available on NEC 9800-series PCs
SeeAlso: INT 08,INT E2"PC Cluster"
--------B-1D---------------------------------
INT 1D - SYSTEM DATA - VIDEO PARAMETER TABLES
Note:	the default parameter table (see #0483) is located at F000h:F0A4h for
	  100% compatible BIOSes
SeeAlso: INT 10/AH=00h

Format of video parameters:
Offset	Size	Description	(Table 0483)
 00h 16 BYTEs	6845 register values for modes 00h and 01h
 10h 16 BYTEs	6845 register values for modes 02h and 03h
 20h 16 BYTEs	6845 register values for modes 04h and 05h
 30h 16 BYTEs	6845 register values for modes 06h and 07h
 40h	WORD	bytes in video buffer for modes 00h and 01h
 42h	WORD	bytes in video buffer for modes 02h and 03h
 44h	WORD	bytes in video buffer for modes 04h and 05h
 46h	WORD	bytes in video buffer for modes 06h and 07h
 48h  8 BYTEs	columns on screen for each of modes 00h through 07h
 50h  8 BYTEs	CRT controller mode bytes for each of modes 00h through 07h
--------B-1E---------------------------------
INT 1E - SYSTEM DATA - DISKETTE PARAMETERS
Note:	the default parameter table (see #0484) is located at F000h:EFC7h for
	  100% compatible BIOSes
SeeAlso: INT 13/AH=0Fh,INT 41

Format of diskette parameter table:
Offset	Size	Description	(Table 0484)
 00h	BYTE	first specify byte
		bits 7-4: step rate
		bits 3-0: head unload time (0Fh = 240 ms)
 01h	BYTE	second specify byte
		bits 7-1: head load time (01h = 4 ms)
		bit    0: non-DMA mode (always 0)
 02h	BYTE	delay until motor turned off (in clock ticks)
 03h	BYTE	bytes per sector (00h = 128, 01h = 256, 02h = 512, 03h = 1024)
 04h	BYTE	sectors per track
 05h	BYTE	length of gap between sectors (2Ah for 5.25", 1Bh for 3.5")
 06h	BYTE	data length (ignored if bytes-per-sector field nonzero)
 07h	BYTE	gap length when formatting (50h for 5.25", 6Ch for 3.5")
 08h	BYTE	format filler byte (default F6h)
 09h	BYTE	head settle time in milliseconds
 0Ah	BYTE	motor start time in 1/8 seconds
--------B-1F---------------------------------
INT 1F - SYSTEM DATA - 8x8 GRAPHICS FONT
Desc:	this vector points at 1024 bytes of graphics data, 8 bytes for each
	  character 80h-FFh
Note:	graphics data for characters 00h-7Fh stored at F000h:FA6Eh in 100%
	  compatible BIOSes
SeeAlso: INT 10/AX=5000h,INT 43
--------J-1F90-------------------------------
INT 1F - NEC PC-9801 - COPY EXTENDED MEMORY
	AH = 90h
	ES:BX -> global descriptor table (see #0336 at INT 15/AH=87h)
	CX = number of bytes to copy
	SI = 0000h
	DI = 0000h
Return: CF clear if successful
	CF set on error
	???
SeeAlso: INT 15/AH=87h
--------!---Section--------------------------
