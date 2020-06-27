Interrupt List, part 12 of 12
This compilation is Copyright (c) 1989,1990,1991,1992,1993,1994 Ralf Brown
----------80---------------------------------
INT 80 - Q-PRO4 - ???
--------r-80---------------------------------
INT 80 - reserved for BASIC
Note:	this vector and INT 81 through INT ED are modified but not restored by
	  Direct Access v4.0, and may be left dangling by other programs
	  written with the same version of compiled BASIC
SeeAlso: INT 81"BASIC",INT 86"BASIC",INT EF"BASIC"
--------s-80----BL00-------------------------
INT 80 - SBSIM - "STARTSND" - START SOUND ON SPECIFIED DRIVER
	BL = 00h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: AX = initialization result (see #2150)
Program: SBSIM is Creative Labs' SoundBlaster Simplified Interface Module,
	  which provides access to multiple drivers for the SoundBlaster
	  board through a single interface
Range:	INT 80h to INT BFh, selected automatically
Note:	the SBSIM installation check consists of testing for the signature
	  "SBSIM" at offset 103h in the interrupt handler's segment.
SeeAlso: INT 80/BL=01h"SBSIM",INT 80/BL=02h"SBSIM",INT 80/BL=03h"SBSIM"
SeeAlso: INT 80/BX=0000h"SBSIM"

(Table 2150)
Values for SBSIM error code:
 01h	busy--currently in use
 02h	bad driver specified
 03h	invalid function
 04h	voice process already active
 05h	couldn't start CT-VOICE
 06h	couldn't start CTVDSK
 07h	invalid SBSIM handle
 08h	buffer not initialized yet
 09h	bad filename
 0Ah	bad file handle
 0Bh	driver not started yet
 0Ch	XMS driver not installed
 0Dh	no free SBSIM handles
 0Eh	bad file type
 0Fh	couldn't free XMS block
 10h	invalid source selected
 11h	get pan position failed
 12h	set pan position failed
 13h	set volume failed
 14h	couldn't start fade/pan
 15h	couldn't stop fade/pan
 16h	couldn't pause fade/pan
 17h	not a fade/pan operation
 18h	bad mode for fade/pan
 19h	couldn't start fade/pan
 1Ah	source not fading/panning
 1Bh	FM or MIDI already playing
 1Ch	bad MIDI mapper format
--------s-80----BL01-------------------------
INT 80 - SBSIM - "PLAYSND" - PLAY MUSIC/VOICE ON SELECTED DRIVER
	BL = 01h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: AX = result (see #2150)
SeeAlso: INT 80/BL=00h"SBSIM",INT 80/BL=02h"SBSIM",INT 80/BL=04h"SBSIM"
--------s-80----BL02-------------------------
INT 80 - SBSIM - "STOPSND" - STOP MUSIC/VOICE ON SELECTED DRIVER
	BL = 02h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: nothing
SeeAlso: INT 80/BL=00h"SBSIM",INT 80/BL=01h"SBSIM",INT 80/BL=03h"SBSIM"
--------s-80----BL03-------------------------
INT 80 - SBSIM - "PAUSESND" - TEMPORARILY PAUSE PLAYBACK ON SELECTED DRIVER
	BL = 03h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: nothing
SeeAlso: INT 80/BL=00h"SBSIM",INT 80/BL=02h"SBSIM",INT 80/BL=04h"SBSIM"
SeeAlso: INT 80/BL=05h
--------s-80----BL04-------------------------
INT 80 - SBSIM - "RESUMESND" - RESTART PLAYBACK ON SELECTED DRIVER
	BL = 04h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: nothing
SeeAlso: INT 80/BL=00h"SBSIM",INT 80/BL=03h"SBSIM",INT 80/BL=05h"SBSIM"
--------s-80----BL05-------------------------
INT 80 - SBSIM - "GETSNDSTAT" - GET DRIVER'S STATUS
	BL = 05h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: AX = status
SeeAlso: INT 80/BL=00h"SBSIM",INT 80/BL=01h"SBSIM",INT 80/BL=03h"SBSIM"
--------s-80----BX0000-----------------------
INT 80 - SoundBlaster SBFM driver - GET VERSION
	BX = 0000h
Return: ???
Note:	SBFM installs at a free interrupt in the range 80h through BFh
SeeAlso: BX=0008h"SBFM",INT 2F/AX=FBFBh
--------s-80----BX0000-----------------------
INT 80 - SBSIM - "QUERYVERSION" - GET VERSION
	BX = 0000h
Return: AX = version (AH = major, AL = minor)
Program: SBSIM is Creative Labs' SoundBlaster Simplified Interface Module,
	  which provides access to multiple drivers for the SoundBlaster
	  board through a single interface
Range:	INT 80h to INT BFh, selected automatically
Note:	the SBSIM installation check consists of testing for the signature
	  "SBSIM" at offset 103h in the interrupt handler's segment.
SeeAlso: BX=0001h"SBSIM",BX=0005h"SBSIM",INT 80/BL=00h"SBSIM"
Index:	installation check;SBSIM|installation check;SoundBlaster
--------s-80----BX0001-----------------------
INT 80 - SoundBlaster SBFM driver - SET MUSIC STATUS BYTE ADDRESS
	BX = 0001h
	DX:AX -> music status byte
SeeAlso: BX=0000h"SBFM",BX=0002h"SBFM",BX=0003h"SBFM"
--------s-80----BX0001-----------------------
INT 80 - SBSIM - "QUERYDRIVERS" - CHECK DRIVERS INSTALLED
	BX = 0001h
Return: AX = bit flags for loaded drivers (see #2151)
SeeAlso: BX=0000h"SBSIM",BX=0002h"SBSIM",BX=0005h"SBSIM",INT 80/BL=00h"SBSIM"

Bitfields for SBSIM loaded drivers:
Bit(s)	Description	(Table 2151)
 0	FM
 1	double disk-buffered voice driver (DDBV)
 2	memory voice driver
 3	auxiliary driver (mixer)
 4	MIDI
--------s-80----BX0002-----------------------
INT 80 - SoundBlaster SBFM driver - SET INSTRUMENT TABLE
	BX = 0002h
	CX = number of instruments
	DX:AX -> instrument table
SeeAlso: BX=0000h"SBFM",BX=0001h"SBFM",BX=0005h"SBFM"
--------s-80----BX0002-----------------------
INT 80 - SBSIM - GETADDRESS" - GET SELECTED DRIVER'S ENTRY POINT
	BX = 0002h
	AX = driver (00h = FM,01h = DDBV,02h = memvoice,03h = mixer,04h = MIDI)
Return: CF clear if successful
	    DX:AX -> entry point
	CF set on error
SeeAlso: BX=0000h"SBSIM",BX=0001h"SBSIM",BX=0005h"SBSIM",INT 80/BL=00h"SBSIM"
--------s-80----BX0003-----------------------
INT 80 - SoundBlaster SBFM driver - SET SYSTEM CLOCK RATE
	BX = 0003h
	AX = clock rate divisor (1193180 / desired frequency in Hertz)
	    FFFFh to restore to 18.2 Hz
SeeAlso: BX=0000h"SBFM",BX=0001h"SBFM",BX=0004h"SBFM"
--------s-80----BX0004-----------------------
INT 80 - SoundBlaster SBFM driver - SET DRIVER CLOCK RATE
	BX = 0004h
	AX = driver clock rate divisor (1193180 / frequency in Hertz)
Note:	default frequency is 96 Hz
SeeAlso: BX=0000h"SBFM",BX=0003h"SBFM"
--------s-80----BX0005-----------------------
INT 80 - SoundBlaster SBFM driver - TRANSPOSE MUSIC
	BX = 0005h
	AX = semi-tone offset
SeeAlso: BX=0000h"SBFM",BX=0002h"SBFM",BX=0006h"SBFM"
--------s-80----BX0005-----------------------
INT 80 - SBSIM - "GETBUFFERINFO" - GET DRIVER'S BUFFER ADDRESS
	BX = 0005h
	AX = driver (00h = FM, 01h = DDB Voice, 04h = MIDI)
Return: CF clear if successful
	    DX:AX -> buffer
	    CX = buffer size in K
	CF set on error
Program: SBSIM is Creative Labs' SoundBlaster Simplified Interface Module,
	  which provides access to multiple drivers for the SoundBlaster
	  board through a single interface
Range:	INT 80h to INT BFh, selected automatically
Note:	the SBSIM installation check consists of testing for the signature
	  "SBSIM" at offset 103h in the interrupt handler's segment.
SeeAlso: BX=0000h"SBSIM",BX=0001h"SBSIM",BX=0002h"SBSIM",INT 80/BL=00h"SBSIM"
--------s-80----BX0006-----------------------
INT 80 - SoundBlaster SBFM driver - PLAY MUSIC
	BX = 0006h
	DX:AX -> music block
Return: AX = status
	    0000h successful
	    0001h music already active
SeeAlso: BX=0000h"SBFM",BX=0007h"SBFM",BX=000Ah"SBFM",INT 1A/AX=FF04h
--------s-80----BX0007-----------------------
INT 80 - SoundBlaster SBFM driver - STOP MUSIC
	BX = 0007h
Return: AX = status
	    0000h successful
	    0001h music not active
SeeAlso: BX=0000h"SBFM",BX=0006h"SBFM",BX=0009h"SBFM",INT 1A/AX=FF05h
--------s-80----BX0008-----------------------
INT 80 - SoundBlaster SBFM driver - RESET DRIVER
	BX = 0008h
Return: AX = status
	    0000h successful
	    0001h music is active
SeeAlso: BX=0000h"SBFM"
--------s-80----BX0009-----------------------
INT 80 - SoundBlaster SBFM driver - PAUSE MUSIC
	BX = 0009h
Return: AX = status
	    0000h successful
	    0001h no music active
SeeAlso: BX=0000h"SBFM",BX=0007h"SBFM",BX=000Ah"SBFM",INT 1A/AX=FF01h
--------s-80----BX000A-----------------------
INT 80 - SoundBlaster SBFM driver - RESUME MUSIC
	BX = 000Ah
Return: AX = status
	    0000h successful
	    0001h no music paused
SeeAlso: BX=0000h"SBFM",BX=0006h"SBFM",BX=0009h"SBFM"
--------s-80----BX000B-----------------------
INT 80 - SoundBlaster SBFM driver - SET USER-DEF TRAP FOR SYSTEM-EXCLUSIVE CMDS
	BX = 000Bh
	DX:AX -> trap routine
SeeAlso: BX=0000h"SBFM"
--------s-80----BX0400-----------------------
INT 80 - SBSIM - "GETVOLUME" - GET SOURCE'S VOLUME
	BX = 0400h
	AX = sound source (see #2152)
Return: CF clear if successful
	    AX = volume
	CF set on error
	    AX = error code (see INT 80/BL=00h)
SeeAlso: BX=0401h"SBSIM"

(Table 2152)
Values for SBSIM sound source:
 00h	master volume
 01h	voice
 02h	FM
 03h	CD
 04h	line in
 05h	microphone
--------s-80----BX0401-----------------------
INT 80 - SBSIM - "SETVOLUME" - SET SOURCE'S VOLUME
	BX = 0401h
	AX = sound source (see INT 80/BX=0400h)
	DX = new volume
Return: AX = result (0000h = success) (see also INT 80/BL=00h)
SeeAlso: BX=0400h"SBSIM"
--------N-8001-------------------------------
INT 80 - QPC Software PKTINT.COM - INITIALIZE
	AH = 01h
Return: AX = 0000h
	CX = FFFFh
	DX = FFFFh
Notes:	this interrupt is the WinQVTNet protected mode interface to Windows 3.0
	all buffer pointers are reset back to 0
--------N-8002-------------------------------
INT 80 - QPC Software PKTINT.COM - GET BUFFER ADDRESSES
	AH = 02h
	BX = extra bytes to allocate per packet
Return: AX = segment address of 10K buffer (for receives???)
	BX = segment address of 2K buffer (for sends???)
SeeAlso: AH=05h
--------N-8003-------------------------------
INT 80 - QPC Software PKTINT.COM - GET ENTRY POINT
	AH = 03h
Return: CX:DX -> receive call address
Note:	the returned address can be used in the packet driver calls since it
	  will be a valid address in all DOS boxes
SeeAlso: AH=06h
--------N-8004-------------------------------
INT 80 - QPC Software PKTINT.COM - ENABLE???
	AH = 04h
	BX = ???
Return: ???
SeeAlso: AH=01h
--------N-8005-------------------------------
INT 80 - QPC Software PKTINT.COM - GET RECEIVE STATISTICS
	AH = 05h
Return: AX = amount of buffer currently in use
	BX = current offset in buffer
	CX = number of times receive has been called
SeeAlso: AH=02h
--------N-8006-------------------------------
INT 80 - QPC Software PKTINT.COM - REMOVE RECEIVED PACKET
	AH = 06h
Return: BX = next packet offset
	CX = number of bytes still buffered
	DX = size of packet released back into buffer pool
SeeAlso: AH=03h
--------r-81---------------------------------
INT 81 - reserved for BASIC
Note:	this vector is modified but not restored by Direct Access v4.0, and
	  may be left dangling by other programs written with the same version
	  of compiled BASIC
SeeAlso: INT 80"BASIC",INT 82"BASIC"
--------N-81---------------------------------
INT 81 - IBM TOKEN RING ADAPTER - ???
SeeAlso: INT 82"TOKEN RING",INT 91"TOKEN RING"
--------r-82---------------------------------
INT 82 - reserved for BASIC
SeeAlso: INT 81"BASIC",INT 83"BASIC"
--------N-82---------------------------------
INT 82 - IBM TOKEN RING ADAPTER - ???
	AH = function
	    00h display message???
		DS:BX -> string
	???
Return: ???
SeeAlso: INT 81"TOKEN RING",INT 91"TOKEN RING"
--------r-83---------------------------------
INT 83 - reserved for BASIC
SeeAlso: INT 82"BASIC",INT 84"BASIC"
--------r-84---------------------------------
INT 84 - reserved for BASIC
SeeAlso: INT 83"BASIC",INT 85"BASIC"
--------r-85---------------------------------
INT 85 - reserved for BASIC
Note:	INT 80 through INT ED are modified but not restored by Direct Access
	  v4.0, and may be left dangling by other programs written with the
	  same version of compiled BASIC
SeeAlso: INT 84"BASIC",INT 86"BASIC"
--------N-86---------------------------------
INT 86 - NetBIOS - ORIGINAL INT 18
Note:	some implementations of NetBIOS reportedly relocate INT 18 here
SeeAlso: INT 18
--------r-86---------------------------------
INT 86 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 85"BASIC",INT 87"BASIC"
--------r-86---------------------------------
INT 86 - APL*PLUS/PC - Terminate APL session and return to DOS
SeeAlso: INT 21/AH=4Ch,INT 87"APL"
--------r-87---------------------------------
INT 87 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 86"BASIC",INT 88"BASIC"
--------r-87---------------------------------
INT 87 - APL*PLUS/PC - ???
SeeAlso: INT 86"APL",INT 88/AL=00h
--------v-87---------------------------------
INT 87 - VIRUS - "ZeroHunt" - VIRAL CODE (NOT A VECTOR!)
Note:	the ZeroHunt virus copies its resident code down to 0000h:021Ch and
	  following
SeeAlso: INT 8B"VIRUS"
--------r-88---------------------------------
INT 88 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 87"BASIC",INT 89"BASIC"
--------r-88--00-----------------------------
INT 88 - APL*PLUS/PC - CREATE OBJECT OF ARBITRARY RANK OR SHAPE
	AL = 00h
	BX = STPTR of the variable to be assigned
	ES:SI -> model of type, rank, and shape (see #2153)
Return: ES:DI -> first data byte of object
	DX:CX = number of elements in the object
SeeAlso: INT C8"APL"

Format of APL*PLUS/PC shape model:
Offset	Size	Description	(Table 2153)
 00h	BYTE	type
		01h character (2-byte dimension sizes)
		02h integer (2-byte dimension sizes)
		08h floating point (2-byte dimension sizes)
		11h character (4-byte dimension sizes)
		12h integer (4-byte dimension sizes)
		18h floating point (4-byte dimension sizes)
 01h	BYTE	rank
 02h	(D)WORD first dimension of shape
 N	(D)WORD second dimension of shape
	...
--------r-88--01-----------------------------
INT 88 - APL*PLUS/PC - CREATE CHARACTER SCALAR/VECTOR/MATRIX <64K IN SIZE
	AL = 01h
	AH = rank
	BX = STPTR of the variable to be assigned
	CX = first dimension (if any)
	DX = second dimension (if any)
Return: ES:DI -> object
	CX = number of elements in the object
Note:	each dimension must be 32767 or smaller
SeeAlso: AL=02h,AL=08h,INT C8"APL"
--------r-88--02-----------------------------
INT 88 - APL*PLUS/PC - CREATE INTEGER SCALAR/VECTOR/MATRIX <64K IN SIZE
	AL = 02h
	AH = rank
	BX = STPTR of the variable to be assigned
	CX = first dimension (if any)
	DX = second dimension (if any)
Return: ES:DI -> object
	CX = number of elements in the object
Note:	each dimension must be 32767 or smaller
SeeAlso: AL=01h,AL=08h,INT C8"APL"
--------r-88--08-----------------------------
INT 88 - APL*PLUS/PC - CREATE FLOATING POINT SCALAR/VECTOR/MATRIX <64K IN SIZE
	AL = 08h
	AH = rank
	BX = STPTR of the variable to be assigned
	CX = first dimension (if any)
	DX = second dimension (if any)
Return: ES:DI -> object
	CX = number of elements in the object
Note:	each dimension must be 32767 or smaller
SeeAlso: AL=01h,AL=02h,INT C8"APL"
--------r-88--F5-----------------------------
INT 88 - APL*PLUS/PC - FORCE OBJECT INTO REAL WORKSPACE FROM VIRTUAL
	AL = F5h
	BX = STPTR of object
SeeAlso: INT C8"APL"
--------r-88--F6-----------------------------
INT 88 - APL*PLUS/PC - MAKE NAME IMMUNE FROM OUTSWAPPING
	AL = F6h
	BX = STPTR of object
SeeAlso: AL=F7h,AL=F8h,INT C8"APL"
--------r-88--F7-----------------------------
INT 88 - APL*PLUS/PC - MAKE NAME ELIGIBLE FOR OUTSWAPPING
	AL = F7h
	BX = STPTR of object
SeeAlso: AL=F6h,AL=F8h,INT C8"APL"
--------r-88--F8-----------------------------
INT 88 - APL*PLUS/PC - REPORT WHETHER NAME IS ELIGIBLE FOR OUTSWAPPING
	AL = F8h
	BX = STPTR of object
Return: BX = name's outswapping status
	    0000h eligible
	    0001h not eligible
SeeAlso: AL=F6h,AL=F7h,INT C8"APL"
--------r-88--F9-----------------------------
INT 88 - APL*PLUS/PC - DETERMINE NAME STATUS
	AL = F9h
	ES:SI -> name
	CX = length of name
Return: CF set if name ill-formed or already in use
	    BX = STPTR if already in symbol table
	CF clear if name is available for use
	    BX = 0000h
Note:	does not force the name into the workspace
SeeAlso: AL=FEh,AL=FFh,INT C8"APL"
--------r-88--FC-----------------------------
INT 88 - APL*PLUS/PC - DETERMINE IF MEMORY AVAIL WITHOUT GARBAGE COLLECTION
	AL = FCh
	BX = amount of memory needed (paragraphs)
Return: CF clear if memory available
	CF set if a workspace compaction is required
SeeAlso: AL=FDh,INT C8"APL"
--------r-88--FD-----------------------------
INT 88 - APL*PLUS/PC - PERFORM GARBAGE COLLECTION AND RETURN AVAILABLE MEMORY
	AL = FDh
Return: BX = number of paragraphs available in workspace
SeeAlso: AL=FCh,INT C8"APL"
--------r-88--FE-----------------------------
INT 88 - APL*PLUS/PC - CREATE NAME
	AL = FEh
	ES:SI -> name
	CX = length of name
Return: BX = STPTR of name
	DX = interpreter's data segment
SeeAlso: AL=F9h,AL=FFh,INT C8"APL"
--------r-88--FF-----------------------------
INT 88 - APL*PLUS/PC - DETERMINE NAME STATUS
	AL = FFh
	ES:SI -> name
	CX = length of name
Return: CF set if name ill-formed or already in use
	    BX = STPTR if already in symbol table
	CF clear if name is available for use
	    BX = 0000h
Note:	forces the name into the workspace and makes it immune from outswapping
SeeAlso: AL=F9h,AL=FEh,INT C8"APL"
--------r-89---------------------------------
INT 89 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 88"BASIC",INT 8A"BASIC"
--------r-8A---------------------------------
INT 8A - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 89"BASIC",INT 8B"BASIC"
--------r-8A---------------------------------
INT 8A - APL*PLUS/PC - PRINT SCREEN
Note:	same as INT 05
SeeAlso: INT 05,INT 8C"APL",INT CA"APL"
--------r-8B---------------------------------
INT 8B - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 8A"BASIC",INT 8C"BASIC"
--------r-8B---------------------------------
INT 8B - APL*PLUS/PC - BEEP
Note:	same as printing a ^G via INT 21/AH=02h
SeeAlso: INT 21/AH=02h,INT CB"APL"
--------v-8B---------------------------------
INT 8B - VIRUS - "ZeroHunt" - INSTALLATION CHECK (NOT A VECTOR!)
Note:	if the ZeroHunt virus is resident, this vector will contain either
	  EE83h:019Bh (ZH-411) or EE83h:019Fh (ZH-415)
SeeAlso: INT 70"VIRUS",INT 87"VIRUS",INT 9C"VIRUS"
--------r-8C---------------------------------
INT 8C - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-8C---------------------------------
INT 8C - APL*PLUS/PC - CLEAR SCREEN MEMORY
	AX = flag
	    0000h do not save display attributes
	    0001h save attributes
SeeAlso: INT CC"APL"
--------r-8D---------------------------------
INT 8D - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-8E---------------------------------
INT 8E - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-8F---------------------------------
INT 8F - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-90---------------------------------
INT 90 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-90---------------------------------
INT 90 - APL*PLUS/PC - USED BY PORT 10 PRINTER DRIVER
--------r-91---------------------------------
INT 91 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-91---------------------------------
INT 91 - IBM TOKEN RING ADAPTER - ???
SeeAlso: INT 81"TOKEN RING",INT 82"TOKEN RING",INT 93"TOKEN RING"
--------r-92---------------------------------
INT 92 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-92---------------------------------
INT 92 - Sangoma X.25 INTERFACE PROGRAM
	BX:DX -> control block
SeeAlso: INT 68"Sangoma"
--------e-92E1-------------------------------
INT 92 - Da Vinci eMail Dispatcher INTERFACE
	AH = E1h
	AL = function
	BX = stack count (number of words to push)
	CX:DX -> stack data (in word-reversed order ready to push)
Return: AX = status (see #2154)
Note:	preserves BP, DS, SI, DI; other registers may be destroyed

(Table 2154)
Values for Da Vinci eMail function status:
 0001h	success
 FF97h	"ERS_NOT_AVAILABLE"
 FF99h	"ERS_TOO_MANY_NAMES"
 FF9Ah	"ERS_BAD_NAME_PASSWORD"
 FFE3h	"ERS_NAME_NOT_FOUND"
 FFF8h	"ERS_USE_STRING" (call NetGetError to get error string)
 FFFFh	"ERS_NO_SUCH_FILE"
--------e-92E100-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetInitStart"
	AX = E100h
	BX = size of parameter block in words (000Ah)
	CX:DX -> parameter block (see #2155)
Return: AX = 0001h success
Desc:	this function is used to initialize the dispatcher
SeeAlso: AX=E101h,AX=E103h

Format of Da Vinci eMail "NetInitStart" parameter block:
Offset	Size	Description	(Table 2155)
 00h	WORD	segment of ???
 02h	WORD	offset of ???
 04h	WORD	high part of long ???
 06h	WORD	low part of long ???
 08h	WORD	high part of long ???
 0Ah	WORD	low part of long ???
 0Ch	WORD	high part of long ???
 0Eh	WORD	low part of long ???
 10h	WORD	high part of long ???
 12h	WORD	low part of long ???
--------e-92E101BX0000-----------------------
INT 92 - Da Vinci eMail Dispatcher - "NetInitCheck"
	AX = E101h
	BX = 0000h
	CX:DX ignored
Return: AX = 0001h success
SeeAlso: AX=E100h,AX=E180h
--------e-92E102BX0000-----------------------
INT 92 - Da Vinci eMail Dispatcher - "NetCheckDriver"
	AX = E102h
	BX = 0000h
	CX:DX ignored
Return: AX = 0001h success
Desc:	this function is used to determine if the dispatcher is loaded
SeeAlso: AX=E10Bh,AX=E180h
--------e-92E103BX0000-----------------------
INT 92 - Da Vinci eMail Dispatcher - "NetTerminate"
	AX = E103h
	BX = 0000h
	CX:DX ignored
Return: AX = status (see #2154)
SeeAlso: AX=E100h
--------e-92E104-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetWhereIs"
	AX = E104h
	BX = size of parameter block in words (0006h)
	CX:DX -> parameter block (see #2156)
Return: AX = status (see #2154)
Desc:	this function is used to verify node address for usernames
SeeAlso: AX=E180h

Format of Da Vinci eMail "NetWhereIs" parameter block:
Offset	Size	Description	(Table 2156)
 00h	WORD	segment of node address buffer
 02h	WORD	offset of node address buffer
 04h	WORD	segment of uppercase username
 06h	WORD	offset of uppercase username
 08h	WORD	segment of "DVSEMAIL"
 0Ah	WORD	offset of "DVSEMAIL"
--------e-92E105-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetOpen"
	AX = E105h
	BX = size of parameter block in words (0007h)
	CX:DX -> parameter block (see #2157)
Return: AX = 0000h Error
	AX = handle
Desc:	this function is used to open a submission channel
SeeAlso: AX=E10Ah,AX=E106h,AX=E108h

Format of Da Vinci eMail "NetOpen" parameter block:
Offset	Size	Description	(Table 2157)
 00h	WORD	operation (1 = read, 2 = write)
 02h	WORD	segment of uppercase To: username
 04h	WORD	offset of uppercase To: username
 06h	WORD	segment of "DVSEMAIL"
 08h	WORD	offset of "DVSEMAIL"
 0Ah	WORD	segment of node address
 0Ch	WORD	offset of node address
--------e-92E106BX0004-----------------------
INT 92 - Da Vinci eMail Dispatcher - "NetRead"
	AX = E106h
	BX = 0004h
	CX:DX -> parameter block
Return: AX = 0001h
SeeAlso: AX=E108h
--------e-92E107BX0002-----------------------
INT 92 - Da Vinci eMail Dispatcher - "NetGetError"
	AX = E107h
	BX = 0002h
	CX:DX -> parameter block
Return: AX = 0001h
SeeAlso: AX=E109h,AX=E180h
--------e-92E108-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetWrite"
	AX = E108h
	BX = size of parameter block in words (0004h)
	CX:DX -> parameter block (see #2158)
Return: AX = amount written
Desc:	This function is used to write transactions to the dispatcher.
	  The command block is written first and then another call is used
	  to write the associated data.
SeeAlso: AX=E106h

Format of Da Vinci eMail "NetWrite" parameter block:
Offset	Size	Description	(Table 2158)
 00h	WORD	buffer count (see #2160)
 02h	WORD	segment of command buffer (see #2159)
 04h	WORD	offset of command buffer
 06h	WORD	handle from NetOpen

Format of Da Vinci eMail command buffer:
Offset	Size	Description	(Table 2159)
 00h	BYTE	command
		21h '!' Protocol commands for remote control
		41h 'A' Authorization protocol element
		42h 'B' Return(back) routing information
		    Associated data is the From: username
		43h 'C' Carbon Copy list
		    Associated data is a comma delimitted list of usernames
		44h 'D' Distribution list
		    Associated data is a comma delimitted list of usernames
		45h 'E' Mail end marker
		    No associated data
		48h 'H' Mail message header
		    Associated data is a message header buffer
		4Dh 'M' Mail message
		    Associated data is the body of the message
		4Fh 'O' Object
		50h 'P' Paperclip attachment
		52h 'R' Routing information
		    Associated data is the To: username
		53h 'S' Subject
		    Associated data is the subject of the message
		54h 'T' Trail of Reply/Forwards
 01h	BYTE	subcommand
 02h	DWORD	length of associated data

Format of Da Vinci eMail message header buffer:
Offset	Size	Description	(Table 2160)
 00h 30 BYTEs	subject line
 1Eh 24 BYTEs	To
 36h 24 BYTEs	From
 4Eh	DWORD	Time
		BYTE	00h
		BYTE	hour
		BYTE	minute
		BYTE	second
 52h	DWORD	Date
		BYTE	00h
		BYTE	year
		BYTE	month
		BYTE	day
 56h	DWORD	serial number (00000000h)
 5Ah	WORD	mail types (see #2161)
 5Ch	WORD	special types (0)

Bitfields for Da Vinci eMail mail types:
Bit(s)	Description	(Table 2161)
 7	blind carbon copy
 6	carbon copy
 5	priority
 4	confidential
 3	certified
 2	bulk
 1-0	class (first, second, third, bulk)
--------e-92E109-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetErrorFix" (UNUSED)
	AX = E109h
	BX = size of parameter block in words (0001h)
	CX:DX -> parameter block (see #2162)
Return: AX = FF97h (ERS_NOT_AVAILABLE)
SeeAlso: AX=E107h,AX=E180h

Format of Da Vinci eMail "NetErrorFix" parameter block:
Offset	Size	Description	(Table 2162)
 00h	WORD	???
--------e-92E10A-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetClose"
	AX = E10Ah
	BX = size of parameter block in words (0001h)
	CX:DX -> parameter block (see #2163)
Return: AX = 0001h
Desc:	this function is used to close a dispatcher handle
SeeAlso: AX=E105h

Format of Da Vinci eMail "NetClose" parameter block:
Offset	Size	Description	(Table 2163)
 00h	WORD	handle from NetOpen
--------e-92E10B-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetCheckQueue"
	AX = E10Bh
	BX = size of parameter block in words (0004h)
	CX:DX -> parameter block (see #2164)
Return: AX = 0001h
SeeAlso: AX=E102h,AX=E10Ch

Format of Da Vinci eMail "NetCheckQueue" parameter block:
Offset	Size	Description	(Table 2164)
 00h	WORD	segment of 24-byte username buffer
 02h	WORD	offset of 24-byte username buffer
 04h	WORD	segment of 24-byte protocol buffer
 06h	WORD	offset of 24-byte protocol buffer
--------e-92E10C-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetReadQueue"
	AX = E10Ch
	BX = size of parameter block in words (0002h)
	CX:DX -> parameter block (see #2165)
Return: AX = 0001h
SeeAlso: AX=E10Bh

Format of Da Vinci eMail "NetReadQueue" parameter block:
Offset	Size	Description	(Table 2165)
 00h	WORD	Segment of 128 byte node address buffer
 02h	WORD	Offset of 128 byte node address buffer
--------e-92E10D-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetSubmitName"
	AX = E10Dh
	BX = size of parameter block in words (0006h)
	CX:DX -> parameter block (see #2166)
Return: AX = status (see #2154)
Desc:	this function is used to verify username/password
SeeAlso: AX=E10Eh

Format of Da Vinci eMail "NetSubmitName" parameter block:
Offset	Size	Description	(Table 2166)
 00h	WORD	segment of uppercase password string
 02h	WORD	offset of uppercase password string
 04h	WORD	segment of uppercase username string
 06h	WORD	offset of uppercase username string
 08h	WORD	segment of "DVSEMAIL"
 0Ah	WORD	offset of "DVSEMAIL"
--------e-92E10E-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetRemoveName"
	AX = E10Eh
	BX = size of parameter block in words (0004h)
	CX:DX -> parameter block (see #2167)
Return: AX = 0001h
Desc:	this function is used to remove a username
SeeAlso: AX=E10Dh

Format of Da Vinci eMail "NetRemoveName" parameter block:
Offset	Type	Description	(Table 2167)
 00h	WORD	segment of uppercase username
 02h	WORD	offset of uppercase username
 04h	WORD	segment of "DVSEMAIL"
 06h	WORD	offset of "DVSEMAIL"
--------e-92E10FBX0000-----------------------
INT 92 - Da Vinci eMail Dispatcher - IS ANYONE THERE? QUERY
	AX = E10Fh
	BX = 0000h
	CX:DX ignored
Return: AX = 0001h
SeeAlso: AX=E180h
--------e-92E110-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetGetAltRoute"
	AX = E110h
	BX = size of parameter block in words (0006h)
	CX:DX -> parameter block (see #2168)
Return: AX = 0001h
SeeAlso: AX=E111h,AX=E113h

Format of Da Vinci eMail "NetGetAltRoute" parameter block:
Offset	Size	Description	(Table 2168)
 00h  6 WORDs	???
--------e-92E111-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetDeleteAltRoutes"
	AX = E111h
	BX = size of parameter block in words (0004h)
	CX:DX -> parameter block (see #2169)
Return: AX = 0001h
SeeAlso: AX=E110h,AX=E113h

Format of Da Vinci eMail "NetDeleteAltRoutes" parameter block:
Offset	Size	Description	(Table 2169)
 00h  4 WORDs	???
--------e-92E112-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetChangePassword"
	AX = E112h
	BX = size of parameter block in words (0008h)
	CX:DX -> parameter block (see #2170)
Return: AX = 0001h
SeeAlso: AX=E180h

Format of Da Vinci eMail "NetChangePassword" parameter block:
Offset	Size	Description	(Table 2170)
 00h  8 WORDs	???
--------e-92E113-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetSetAltRoute"
	AX = E113h
	BX = size of parameter block in words (0008h)
	CX:DX -> parameter block (see #2171)
Return: AX = 0001h
SeeAlso: AX=E110h,AX=E111h

Format of Da Vinci eMail "NetSetAltRoute" parameter block:
Offset	Size	Description	(Table 2171)
 00h  8 WORDs	???
--------e-92E175-----------------------------
INT 92 - Da Vinci eMail Dispatcher - BECOME MICRO TSR
	AX = E175h
Return: AX = 0012h
	BX = PSP
SeeAlso: AX=E180h
--------e-92E180-----------------------------
INT 92 - Da Vinci eMail Dispatcher - INSTALLATION CHECK
	AX = E180h
Return: AX = 0012h if installed
	ES:DX -> '$'-terminated driver information string
SeeAlso: AX=E102h,AX=E105h,AX=E10Fh,AX=E175h
--------r-93---------------------------------
INT 93 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-93---------------------------------
INT 93 - IBM TOKEN RING ADAPTER - ???
SeeAlso: INT 81"TOKEN RING",INT 91"TOKEN RING"
--------r-94---------------------------------
INT 94 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------s-94----SI0000-----------------------
INT 94 u - PCM driver - INITIALIZE SOUND
	SI = 0000h
	ES:BX -> parameters
Return: ???
Program: PCM.COM is a sound driver for Media Vision's Pro Audio Spectrum
	  sound boards
Note:	the installation check consists of testing for the signature string
	  "PCMDRIVER" immediately preceding the interrupt handler; the word
	  preceding the signature gives the PCM driver's version
SeeAlso: SI=0001h,SI=0002h,SI=0003h,SI=0004h,SI=0005h,SI=000Ah
Index:	installation check;PCM driver|PCM.COM;installation check
Index:	PCM driver;installation check
--------s-94----SI0001-----------------------
INT 94 u - PCM driver - INITIALIZE PCM
	SI = 0001h
	ES:BX -> parameters
Return: ???
SeeAlso: SI=0000h,SI=0002h,SI=0003h,SI=000Ah
--------s-94----SI0002-----------------------
INT 94 u - PCM driver - INITIALIZE PCM INFO
	SI = 0002h
	ES:BX -> parameters (see #2172)
Return: ???
SeeAlso: SI=0000h,SI=0001h,SI=0003h,SI=000Ah

Format of PCM driver parameters:
Offset	Size	Description	(Table 2172)
 00h	DWORD	rate
 04h	WORD	channel number
 06h	WORD	"comp"
 08h	WORD	"dsize"
--------s-94----SI0003-----------------------
INT 94 u - PCM driver - INITIALIZE DMA BUFFER
	SI = 0003h
	ES:BX -> parameters (see #2173)
Return: ???
SeeAlso: SI=0000h,SI=000Ah,SI=000Bh

Format of PCM driver parameters:
Offset	Size	Description	(Table 2173)
 00h	DWORD	-> DMA buffer
 04h	WORD	size of DMA buffer
 06h	WORD	number of divisions
--------s-94----SI0004-----------------------
INT 94 u - PCM driver - INITIALIZE USER FUNCTION
	SI = 0004h
	ES:BX -> parameters (see #2174)
Return: ???
SeeAlso: SI=0000h,SI=0001h

Format of PCM driver parameters:
Offset	Size	Description	(Table 2174)
 00h	DWORD	-> user function
--------s-94----SI0005-----------------------
INT 94 u - PCM driver - BEGIN AUDIO PLAY
	SI = 0005h
Return: ???
SeeAlso: SI=0000h,SI=0006h,SI=0007h,SI=0009h
--------s-94----SI0006-----------------------
INT 94 u - PCM driver - BEGIN AUDIO RECORD
	SI = 0006h
Return: ???
SeeAlso: SI=0005h,SI=0007h,SI=0009h
--------s-94----SI0007-----------------------
INT 94 u - PCM driver - PAUSE AUDIO PLAY/RECORD
	SI = 0007h
Return: ???
SeeAlso: SI=0005h,SI=0006h,SI=0008h
--------s-94----SI0008-----------------------
INT 94 u - PCM driver - RESUME AUDIO PLAY/RECORD
	SI = 0008h
Return: ???
SeeAlso: SI=0007h
--------s-94----SI0009-----------------------
INT 94 u - PCM driver - STOP AUDIO PLAY/RECORD
	SI = 0009h
Return: ???
SeeAlso: SI=0005h,SI=0006h,SI=0007h
--------s-94----SI000A-----------------------
INT 94 u - PCM driver - UNHOOK INTERRUPTS AND TURN OFF DMA
	SI = 000Ah
Return: ???
SeeAlso: SI=0000h,SI=0001h,SI=0003h
Index:	uninstall;PCM driver
--------s-94----SI000B-----------------------
INT 94 u - PCM driver - FIND VALID DMA BUFFER IN HUGE MEMORY BLOCK
	SI = 000Bh
	ES:BX -> parameters (see #2175)
Return: ???
SeeAlso: SI=0003h

Format of PCM driver parameters:
Offset	Size	Description	(Table 2175)
 00h	DWORD	-> memory block to contain DMA buffer
 04h	WORD	desired size of DMA buffer
--------s-94----SI000D-----------------------
INT 94 u - Media Vision PCM.COM - GET STATUS
	SI = 000Dh
Return: AX = status (0000h = waiting) (see #2176)

Bitfields for PCM.COM status:
Bit(s)	Description	(Table 2176)
 0	playing
 1	recording
 2	SBplaying
 3	SBrecording
 14	SBpaused
 15	paused
--------s-94----SI8000-----------------------
INT 94 u - Media Vision PCM.COM - GET INTERNAL DMA BUFFER ADDRESS
	SI = 8000h
Return: DX:AX -> DMA buffer
Program: PCM.COM is a superset of the standard PCM driver which provides
	  additional functions for fine control of the driver
Note:	the installation check for the Media Vision PCM.COM "shark" functions
	  consists of testing for the signature "PCM-SHARK" at offset 107h in
	  the INT 94 handler's segment
SeeAlso: SI=8001h,SI=8004h
Index:	installation check;Media Vision PCM.COM|PCM.COM;installation check
Index:	Media Vision PCM.COM;"shark" functions
--------s-94----SI8001-----------------------
INT 94 u - Media Vision PCM.COM - GET INTERNAL DMA BUFFER SIZE AND DIVISIONS
	SI = 8001h
Return: AX = DMA buffer size
	DX = divisions
SeeAlso: SI=8000h
--------s-94----SI8002-----------------------
INT 94 u - Media Vision PCM.COM - CHECK BOARD ADDRESS
	SI = 8002h
Return: AX = status
	    0000h if board not at specified I/O address
	    other if board found
Note:	the I/O address is specified by ORing the base I/O port shifted left
	  four bits into SI before calling INT 94
SeeAlso: SI=8000h
--------s-94----SI8004-----------------------
INT 94 u - Media Vision PCM.COM - GET INTERNAL NOTE BUFFER
	SI = 8004h
Return: AX = offset of note buffer (segment = segment of internal DMA buffer)
	DX = size of buffer in note structures
SeeAlso: SI=8000h
--------s-94----SI8005-----------------------
INT 94 u - Media Vision PCM.COM - SINGLE-STEP QUEUE
	SI = 8005h
Return: ???
--------s-94----SI8011-----------------------
INT 94 u - Media Vision PCM.COM - INITIALIZE
	SI = 8011h
	ES:BX -> "iobf91" structure
Return: ???
--------s-94----SI8012-----------------------
INT 94 u - Media Vision PCM.COM - LOAD SOUND FOR LATER PLAY THROUGH KEYBOARD
	SI = 8012h
	ES:BX -> "i94f92buf" structure
Return: ???
SeeAlso: SI=8013h,SI=8014h
--------s-94----SI8013-----------------------
INT 94 u - Media Vision PCM.COM - GET INTERNAL SOUND USAGE
	SI = 8013h
Return: AX = number of sounds used
	DX = maximum handles
--------s-94----SI8014-----------------------
INT 94 u - Media Vision PCM.COM - GET DATA FOR SPECIFIED SOUND
	SI = 8014h
	ES:BX -> "i94f92buf" structure to be filled in
		sound number field set to desired sound
Return: AX = status
	    0000h successful
	    FFFFh sound number out of range
SeeAlso: SI=8012h,SI=8013h
--------s-94----SI8015-----------------------
INT 94 u - Media Vision PCM.COM - GET/SET INTERNAL DMA BUFFER
	SI = 8015h
	ES:BX -> DMA info structure (see #2177)
Return: ???

Format of PCM.COM DMA info structure:
Offset	Size	Description	(Table 2177)
 00h	DWORD	-> DMA buffer (offset FFFFh = return current buffer info)
 04h	WORD	DMA buffer size
 06h	WORD	divisions
--------s-94----SI8016-----------------------
INT 94 u - Media Vision PCM.COM - SIMULATE DOUBLE-SHIFT HOTKEY
	SI = 8016h
	AX = hotkey number (01h-08h)
Return: ???
SeeAlso: AL=02h/SI=8017h
--------s-94--01SI8017-----------------------
INT 94 u - Media Vision PCM.COM - CTRL-G INTERCEPT
	AL = 01h
	SI = 8017h
	AH = new state (00h off, 01h on)
Return: ???
SeeAlso: AL=02h/SI=8017h
--------s-94--02SI8017-----------------------
INT 94 u - Media Vision PCM.COM - DOUBLE-SHIFT-HOTKEY SOUND FEATURE
	AL = 02h
	SI = 8017h
	AH = new state (00h off, 01h on)
Return: ???
--------s-94--04SI8017-----------------------
INT 94 u - Media Vision PCM.COM - RANDOM SOUND FEATURE
	AL = 04h
	SI = 8017h
	AH = new state
	    00h off
	    01h on
		CX = minimum delay
		DX = maximum delay
Return: ???
--------s-94--08SI8017-----------------------
INT 94 u - Media Vision PCM.COM - NO ACTIVITY FEATURE
	AL = 08h
	SI = 8017h
	AH = new state
	    00h off
	    01h on
		DX:CX = delay
Return: ???
SeeAlso: AL=10h/SI=8017h
--------s-94--10SI8017-----------------------
INT 94 u - Media Vision PCM.COM - TIMER CONTROL
	AL = 10h
	SI = 8017h
	AH bit 7: set timer
	AH bit 6: timer active (timer turned off if clear)
	AH bits 5-0: timer number
	DX:CX = delay if AH bit 7 set (one-shot if DX bit 15 set)
Return: ???
SeeAlso: AL=08h/SI=8017h
--------s-94----SI8018-----------------------
INT 94 u - Media Vision PCM.COM - GET INFO
	SI = 8018h
	AL = what to get
	    00h "F92state"
	    01h "F92bkgd"
	    02h "I10timer"
	    03h "I08state"
Return: DX:AX -> desired information
--------r-95---------------------------------
INT 95 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-95---------------------------------
INT 95 - APL*PLUS/PC - DETERMINE R= SPACE
Note:	use only when the R= option is invoked on entering APL
--------r-96---------------------------------
INT 96 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-97---------------------------------
INT 97 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-98---------------------------------
INT 98 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-99---------------------------------
INT 99 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-9A---------------------------------
INT 9A - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 99,INT 9B
--------r-9B---------------------------------
INT 9B - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9A,INT 9C"BASIC"
--------r-9C---------------------------------
INT 9C - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9B,INT 9D"BASIC"
--------v-9C---------------------------------
INT 9C - VIRUS - "INT13" - ORIGINAL INT 13h VECTOR
SeeAlso: INT 8B"VIRUS",INT 9D"VIRUS",INT 9E"VIRUS",INT 9F"VIRUS"
--------r-9D---------------------------------
INT 9D - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9C"BASIC",INT 9E"BASIC"
--------v-9D---------------------------------
INT 9D - VIRUS - "INT13" - ROM INT 13h ENTRY POINT
Note:	this vector is used by the virus to store the result of a call to
	  INT 2F/AH=13h
SeeAlso: INT 2F/AH=13h,INT 9C"VIRUS",INT 9E"VIRUS",INT 9F"VIRUS"
--------r-9E---------------------------------
INT 9E - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9D"BASIC",INT 9F"BASIC"
--------v-9E---------------------------------
INT 9E - VIRUS - "INT13" - ORIGINAL INT 21h VECTOR
SeeAlso: INT 70"VIRUS",INT 9C"VIRUS",INT 9D"VIRUS",INT E0"VIRUS"
--------r-9F---------------------------------
INT 9F - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9D"BASIC",INT A0"BASIC"
--------v-9F---------------------------------
INT 9F - VIRUS - "INT13" - STORAGE FOR USER INT 13h VECTOR
Note:	while it is infecting a file, the INT13 virus grabs INT 13 and uses
	  this interrupt to store the existing INT 13 vector for later
	  restoration
SeeAlso: INT 9C"VIRUS",INT 9D"VIRUS"
--------r-A0---------------------------------
INT A0 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9F"BASIC",INT A1"BASIC"
--------r-A0---------------------------------
INT A0 - APL*PLUS/PC - USED BY APL/GSS*CGI GRAPHICS INTERFACE
SeeAlso: INT 59
--------r-A1---------------------------------
INT A1 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A0"BASIC",INT A2"BASIC"
--------r-A2---------------------------------
INT A2 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A1"BASIC",INT A3"BASIC"
--------r-A3---------------------------------
INT A3 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A2"BASIC",INT A4"BASIC"
--------r-A4---------------------------------
INT A4 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A3"BASIC",INT A5"BASIC"
--------U-A4---------------------------------
INT A4 U - Right Hand Man - API
	AH = function number (v3.3 supports functions 00h-52h)
Return: CF set on error
	CF clear if successful
Program: Right Hand Man is a TSR desk-top utility originally by Red E Products
	  which has evolved into Futurus Team
Note:	this interrupt is only hooked while popped up
SeeAlso: INT 2F/AX=A4E0h
--------r-A5---------------------------------
INT A5 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A4"BASIC",INT A6"BASIC"
--------r-A6---------------------------------
INT A6 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A5"BASIC",INT A7"BASIC"
--------r-A7---------------------------------
INT A7 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-A8---------------------------------
INT A8 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-A9---------------------------------
INT A9 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AA---------------------------------
INT AA - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AB---------------------------------
INT AB - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AC---------------------------------
INT AC - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AD---------------------------------
INT AD - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AE---------------------------------
INT AE - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AF---------------------------------
INT AF - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-B0---------------------------------
INT B0 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-B1---------------------------------
INT B1 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-B2---------------------------------
INT B2 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-B3---------------------------------
INT B3 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------U-B370-------------------------------
INT B3 - ZIPKEY - GET VERSION
	AH = 70h
Return: AH = major version
	AL = minor version
	CL = number of states and territories in current database
	DH = year of current database - 1900
	DL = month of current database's file date
Program: ZIPKEY is a resident ZIPCODE database by Eric Isaacson
Note:	if installed, the string "ZIPKEY" is present at offset 75h in the
	  interrupt handler's segment, and the byte at 7Bh contains the API
	  version number (00h for v1.x, 01h for v2.0)
--------U-B371-------------------------------
INT B3 - ZIPKEY - CONVERT TWO-LETTER ABBREVIATION TO STATE CODE
	AH = 71h
	BX = abbreviation, in either case (first letter in BL)
Return: CF set on error
	    AL = FFh
	CF clear if successful
	    AL = ZIPKEY state code
SeeAlso: AH=72h
--------U-B372-------------------------------
INT B3 - ZIPKEY - CONVERT STATE CODE TO TWO-LETTER ABBREVIATION
	AH = 72h
	BL = ZIPKEY state code
Return: CF set on error
	    AX destroyed
	CF clear if successful
	    AX = abbreviation, in upper case
SeeAlso: AH=71h,AH=73h
--------U-B373-------------------------------
INT B3 - ZIPKEY - CONVERT STATE CODE TO STATE NAME
	AH = 73h
	BL = ZIPKEY state code
	ES:DI -> buffer for name
Return: CF set on error
	    AX destroyed
	CF clear if successful
	    ES:DI points one byte beyond end of name
SeeAlso: AH=72h
--------U-B374-------------------------------
INT B3 - ZIPKEY - CONVERT ZIPCODE TO ASCII DIGITS
	AH = 74h
	DX = zipcode region (0-999)
	CH = last two digits of zipcode (0-99)
	ES:DI -> buffer
Return: CF set on error
	    AX destroyed
	CF clear if successful
	    ES:DI points one byte beyond end of digit string
--------U-B375-------------------------------
INT B3 - ZIPKEY - LOOK UP STATE CODE FOR ZIPCODE
	AH = 75h
	DX = zipcode region (0-999)
	CH = last two digits of zipcode (0-99)
Return: CF set on error (zipcode not found)
	    AL = suggested state code, FFh if none
	CF clear if successful
	    AL = ZIPKEY state code
	    BX = area code (v2.0+)
SeeAlso: AH=76h,AH=79h
--------U-B376-------------------------------
INT B3 - ZIPKEY - LOOK UP CITY AND STATE FOR ZIPCODE
	AH = 76h
	DX = zipcode region (0-999)
	CH = last two digits of zipcode (0-99)
	ES:DI -> buffer for name
Return: CF set on error
	    AL = suggested state code, FFh if none
	    ES:DI buffer filled with suggested city name
	CF clear if successful
	    AL = ZIPKEY state code
	    BX = area code (v2.0+)
	    ES:DI points one byte beyond end of name
SeeAlso: AH=75h,AH=78h,AH=7Eh
--------U-B377-------------------------------
INT B3 - ZIPKEY - PLAY BACK EXIT KEY FOR ENTRY WITH GIVEN ZIPCODE
	AH = 77h
	DX = zipcode region (0-999)
	CH = last two digits of zipcode (0-99)
	BX = 16-bit BIOS keycode for a defined ZIPKEY alternate exit key
Return: CF set on error
	    AX destroyed
	CF clear if successful
	    zipcode specification as defined by the BX keystroke is placed in
	      keyboard buffer, as if the user had popped up ZIPKEY and exited
	      by pressing the key specified by BX
--------U-B378-------------------------------
INT B3 - ZIPKEY - LOOK UP ZIPCODES FOR A GIVEN STATE AND CITY
	AH = 78h
	BL = ZIPKEY state code
	DS:SI -> city name, terminated with 0Dh if complete name, 00h if prefix
Return: BH = number of matching entries (set to 51 if more than 50)
	DX = zipcode region of first match (0-999)
	CL = last two digits of first zipcode in the range (0-99)
	CH = last two digits of last zipcode in the range (0-99)
	AX destroyed
SeeAlso: AH=79h,AH=7Ah
--------U-B379-------------------------------
INT B3 - ZIPKEY - LOOK UP ZIPCODES FOR A GIVEN CITY
	AH = 79h
	BL = ZIPKEY state code of first state to search
	DS:SI -> city name, terminated with 0Dh if complete name, 00h if prefix
Return: AL = ZIPKEY state code of first matching state
	BH = number of matching entries (set to 51 if more than 50)
	DX = zipcode region of first match (0-999)
	CL = last two digits of first zipcode in first range (0-99)
	CH = last two digits of last zipcode in first range (0-99)
Note:	to find all matching cities, repeat search with BL set to one more than
	  the returned AL
SeeAlso: AH=78h,AH=7Ah
--------U-B37A-------------------------------
INT B3 - ZIPKEY - FETCH AN ENTRY FROM A PREVIOUS LOOKUP
	AH = 7Ah
	BL = case number (0 to one less than value returned in BH by lookup)
Return: AL = ZIPKEY state code
	DX = zipcode region (0-999)
	CL = last two digits of first zipcode in the range (0-99)
	CH = last two digits of last zipcode in the range (0-99)
SeeAlso: AH=78h,AH=79h
--------U-B37B-------------------------------
INT B3 - ZIPKEY - GET VALUES NEEDED TO SAVE ZIPKEY CONTEXT
	AH = 7Bh
Return: BL = maximum number of characters for a city name
	BH = ZIPKEY state code for last city-name search, or FFh if none
	CX:DX = internal code identifying last city search
	AX destroyed
SeeAlso: AH=7Ch
--------U-B37C-------------------------------
INT B3 - ZIPKEY - RESTORE ZIPKEY CONTEXT
	AH = 7Ch
	BL = maximum number of characters for a city name
	BH = ZIPKEY state code for last city-name search, or FFh if none
	CX:DX = internal code returned by AH=7Bh
Return: CF set on error
	CF clear if successful
	AX destroyed
SeeAlso: AH=7Bh
--------U-B37D-------------------------------
INT B3 - ZIPKEY - REQUEST POP UP
	AH = 7Dh
	BL = index number to simulate pressing a hotkey
	    FFh for immediate popup with no playback on return
Return: CF set on error
	    AL = error code
		FDh already busy with another request
		FEh illegal function
	CF clear if successful
	    AX destroyed
	    window popped up and was closed by the user
SeeAlso: AH=70h
--------U-B37E-------------------------------
INT B3 - ZIPKEY - GET NAME OF PRIMARY CITY FOR A ZIPCODE REGION
	AH = 7Eh
	DX = zipcode region (0-999)
	ES:DI -> buffer for name
Return: CF set on error
	    AL = FFh region does not exist
	CF clear if successful
	    AL = ZIPKEY state code
	    ES:DI points one byte beyond end of name
SeeAlso: AH=76h
--------U-B37F-------------------------------
INT B3 - ZIPKEY - ENABLE/DISABLE HOTKEYS
	AH = 7Fh
	BL = function
	    00h turn off hotkeys
	    01h turn on hotkeys
	    02h return hotkey status
	    03h toggle hotkey status
Return: AL = hotkey status
	    00h off
	    01h on
--------U-B380-------------------------------
INT B3 - ZIPKEY v2.0+ - DETERMINE STATE FOR AREA CODE
	AH = 80h
	BX = telephone area code (decimal)
Return: CF clear if successful
	    AL = ZIPKEY state code
	    DX = first ZIP region for state (03E8h if Canada)
	    CX = number of ZIP regions in state
	CF set on error
	    AL = FFh
	    DX = 03E9h
--------r-B4---------------------------------
INT B4 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-B4---------------------------------
INT B4 - StackMan - REQUEST NEW STACK
Return: SS:SP -> new stack
Program: StackMan is a freeware stack manager by Franz Veldman of ESaSS B.V.
	  which functions as a replacement for the DOS STACK= command as well
	  as permitting multiple TSRs to share a pool of stack space
Note:	the installation check consists of testing for the string "STACKXXX" at
	  offset 0Ah from the interrupt handler
SeeAlso: INT 2F/AX=C9FFh,INT B5"STACKMAN"
Index:	installation check;STACKMAN
--------r-B5---------------------------------
INT B5 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT B4"BASIC",INT B6"BASIC"
--------r-B5---------------------------------
INT B5 - StackMan - RESTORE ORIGINAL STACK
	SS:SP -> stack returned by INT B4
Return: SS:SP restored to value before INT B4
SeeAlso: INT 2F/AX=C9FFh,INT B4"StackMan"
--------m-B5---------------------------------
INT B5 U - Netroom NETSWAP4 - ???
	???
Return: ???
SeeAlso: INT 31/AH=57h
--------r-B6---------------------------------
INT B6 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT B5"BASIC",INT B7"BASIC"
--------y-B6---------------------------------
INT B6 - (NOT A VECTOR!) - USED BY TBFENCE
Program: TBFence is a security program by ESaSS B.V. which transparently
	  encrypts floppies and optionally allows only encrypted diskettes to
	  be accessed
Note:	the low word of this vector (0000h:02D8h) contains the segment of the
	  TBFence INT 13h code, which starts with the signature word E487h;
	  this forms the installation check
	the highest byte of this vector contains the start of a FAR JMP
	  instruction to ???
SeeAlso: INT B7"TBFENCE"
Index:	installation check;TBFence
--------r-B7---------------------------------
INT B7 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT B6"BASIC",INT B8"BASIC"
--------y-B7---------------------------------
INT B7 - TBFENCE - ???
SeeAlso: INT B6"TBFENCE"
--------r-B8---------------------------------
INT B8 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT B7"BASIC",INT B9"BASIC"
--------r-B9---------------------------------
INT B9 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-BA---------------------------------
INT BA - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-BB---------------------------------
INT BB - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-BC---------------------------------
INT BC - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-BD---------------------------------
INT BD - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-BE---------------------------------
INT BE - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT BD"BASIC",INT BF"BASIC"
--------Q-BE---------------------------------
INT BE - DESQview/X - ???
Note:	points at an IRET
SeeAlso: INT 15/AX=BFDEh/BX=0006h,INT 63"DESQview"
--------r-BF---------------------------------
INT BF - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT BE"BASIC",INT C0"BASIC"
--------r-C0---------------------------------
INT C0 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT BF"BASIC",INT C1"BASIC"
--------d-C0---------------------------------
INT C0 - AMI BIOS - DRIVE 0 DATA
Note:	this vector is used by some AMI BIOSes to store the first four bytes
	  of the hard disk parameter table
SeeAlso: INT 41,INT 60"Adaptec",INT C1"AMI",INT C2"AMI",INT C3"AMI",INT C4"AMI"
--------r-C1---------------------------------
INT C1 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C0"BASIC",INT C2"BASIC"
--------d-C1---------------------------------
INT C1 - AMI BIOS - DRIVE 0 DATA
Note:	this vector is used by some AMI BIOSes to store the second four bytes
	  of the hard disk parameter table
SeeAlso: INT 41,INT 60"Adaptec",INT C0"AMI",INT C2"AMI",INT C3"AMI"
--------r-C2---------------------------------
INT C2 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C1"BASIC",INT C3"BASIC"
--------d-C2---------------------------------
INT C2 - AMI BIOS - DRIVE 0 DATA
Note:	this vector is used by some AMI BIOSes to store the third four bytes
	  of the hard disk parameter table
SeeAlso: INT 41,INT 60"Adaptec",INT C0"AMI",INT C1"AMI",INT C3"AMI"
--------r-C3---------------------------------
INT C3 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C2"BASIC",INT C4"BASIC"
--------d-C3---------------------------------
INT C3 - AMI BIOS - DRIVE 0 DATA
Note:	this vector is used by some AMI BIOSes to store the final four bytes
	  of the hard disk parameter table
SeeAlso: INT 41,INT 60"Adaptec",INT C0"AMI",INT C1"AMI",INT C2"AMI"
--------r-C4---------------------------------
INT C4 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C3"BASIC",INT C5"BASIC"
--------d-C4---------------------------------
INT C4 - AMI BIOS - DRIVE 1 DATA
Note:	this vector is used by some AMI BIOSes to store the first four bytes
	  of the second hard disk's parameter table
SeeAlso: INT 46,INT 64"Adaptec",INT C0"AMI",INT C5"AMI",INT C6"AMI",INT C7"AMI"
--------r-C5---------------------------------
INT C5 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C4"BASIC",INT C6"BASIC"
--------d-C5---------------------------------
INT C5 - AMI BIOS - DRIVE 1 DATA
Note:	this vector is used by some AMI BIOSes to store the second four bytes
	  of the second hard disk's parameter table
SeeAlso: INT 46,INT 64"Adaptec",INT C0"AMI",INT C4"AMI",INT C6"AMI",INT C7"AMI"
--------r-C6---------------------------------
INT C6 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C5"BASIC",INT C7"BASIC"
--------r-C6---------------------------------
INT C6 - APL*PLUS/PC - IDENTICAL TO INT 86
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 86"APL"
--------d-C6---------------------------------
INT C6 - AMI BIOS - DRIVE 1 DATA
Note:	this vector is used by some AMI BIOSes to store the third four bytes
	  of the second hard disk's parameter table
SeeAlso: INT 46,INT 64"Adaptec",INT C0"AMI",INT C4"AMI",INT C5"AMI",INT C7"AMI"
--------r-C7---------------------------------
INT C7 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C6"BASIC",INT C8"BASIC"
--------r-C7---------------------------------
INT C7 - APL*PLUS/PC - ???
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 87"APL"
--------d-C7---------------------------------
INT C7 - AMI BIOS - DRIVE 1 DATA
Note:	this vector is used by some AMI BIOSes to store the final four bytes
	  of the second hard disk's parameter table
SeeAlso: INT 46,INT 64"Adaptec",INT C0"AMI",INT C4"AMI",INT C5"AMI",INT C6"AMI"
--------r-C8---------------------------------
INT C8 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C7"BASIC",INT C9"BASIC"
--------r-C8---------------------------------
INT C8 - APL*PLUS/PC - IDENTICAL TO INT 88
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 88"APL"
--------r-C9---------------------------------
INT C9 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C8"BASIC",INT CA"BASIC"
--------r-C9---------------------------------
INT C9 - APL*PLUS/PC - ???
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 89"APL"
--------r-CA---------------------------------
INT CA - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C9"BASIC",INT CB"BASIC"
--------r-CA---------------------------------
INT CA - APL*PLUS/PC - PRINT SCREEN
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 8A"APL"
--------r-CB---------------------------------
INT CB - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CA"BASIC",INT CC"BASIC"
--------r-CB---------------------------------
INT CB - APL*PLUS/PC - BEEP
Notes:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
	same as printing a ^G via INT 21/AH=02h
SeeAlso: INT 8B"APL"
--------r-CC---------------------------------
INT CC - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CB"BASIC",INT CD"BASIC"
--------r-CC---------------------------------
INT CC - APL*PLUS/PC - CLEAR SCREEN MEMORY
	AX = flag
	    0000h do not save display attributes
	    0001h save attributes
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 8C"APL"
--------r-CD---------------------------------
INT CD - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CC"BASIC",INT CE"BASIC"
--------r-CD---------------------------------
INT CD - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-CE---------------------------------
INT CE - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CD"BASIC",INT CF"BASIC"
--------r-CE---------------------------------
INT CE - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-CF---------------------------------
INT CF - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CE"BASIC",INT D0"BASIC"
--------r-CF---------------------------------
INT CF - APL*PLUS/PC - DEFAULT LOW-RESOLUTION TIMER FOR QUAD MF FUNCTION
SeeAlso: INT E0"APL"
--------r-D0---------------------------------
INT D0 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CF"BASIC",INT D1"BASIC"
--------r-D0---------------------------------
INT D0 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------U-D0---------------------------------
INT D0 - [not a vector!] - NJFRERAM SIGNATURE VECTOR
Program: NJFRERAM is a resident free-memory display utility by Mike "Nifty
	  James" Blaszczak
Note:	if NJFRERAM is installed, this vector points at the signature "NJ"
Index:	installation check;NJFRERAM
--------r-D1---------------------------------
INT D1 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D0"BASIC",INT D2"BASIC"
--------r-D1---------------------------------
INT D1 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-D2---------------------------------
INT D2 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D1"BASIC",INT D3"BASIC"
--------r-D2---------------------------------
INT D2 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-D3---------------------------------
INT D3 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D2"BASIC",INT D4"BASIC"
--------r-D3---------------------------------
INT D3 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-D4---------------------------------
INT D4 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D3"BASIC",INT D5"BASIC"
--------r-D4---------------------------------
INT D4 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------O-D400-------------------------------
INT D4 O - PC-MOS/386 v5.01 - OBSOLETE FUNCTIONS
	AH = 00h and 01h
Return: nothing
Desc:	PC-MOS/386 v5.01 reports that these functions are no longer supported
	  and enters an endless loop
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
--------O-D402-------------------------------
INT D4 - PC-MOS/386 v3.0+ - GET SYSTEM CONTROL BLOCK POINTER
	AH = 02h
Return: AX = 0000h
	ES:BX -> System Control Block in V86 mode (see #2178)
	ES:EBX -> System Control Block in native mode (see #2178)
Note:	superseded by AH=26h
SeeAlso: AH=04h,AH=10h,AH=26h,AH=28h,AH=29h,AH=2Ah,INT 21/AX=3000h,INT 38

Format of PC-MOS/386 System Control Block:
Offset	Size	Description	(Table 2178)
 00h	WORD	pointer to first TCB in chain
 02h 17 BYTEs	reserved
 13h	WORD	pointer to current task's TCB
 15h	WORD	pointer to TCB of visible (console) task
--------O-D403-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET/SET EXTENDED DIRECTORY INFORMATION
	AH = 03h
	AL = subfunction (00h get, 01h set)
	DS:(E)DX -> pathname
	ES:(E)BX -> 10-byte buffer for directory information (see #2179)
Return: CF clear if successful
	    AL = permitted access level for file (00h-03h)
	    ES:(E)BX -> modified buffer (AL=01h on entry)
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
Notes:	BX/DX are used in V86 mode, EBX/EDX in native mode
	the file class cannot be changed for files because it affects the
	  encryption method, but directories can have their classes changed

Format of PC-MOS/386 directory information:
Offset	Size	Description	(Table 2179)
 00h	BYTE	reserved (0)
 01h	BYTE	file class ('A'-'Z' or 00h)
 02h	DWORD	user ID of file creator
 06h	WORD	file creation time (see #0780 at INT 21/AX=5700h)
 08h	WORD	file creation date (see #0781 at INT 21/AX=5700h)
--------O-D404-------------------------------
INT D4 - PC-MOS/386 v3.0+ - GET TASK CONTROL BLOCK
	AH = 04h
	BX = task ID or FFFFh for calling task
Return: CF clear if successful
	    ES = segment of Task Control Block (TCB) (see #2180)
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
Note:	superseded by AH=27h
SeeAlso: AH=02h,AH=27h,AH=28h,AH=29h,AH=2Ah,INT 38

Format of PC-MOS/386 Task Control Block:
Offset	Size	Description	(Table 2180)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "T" = TCB
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---TCB---
 10h	WORD	TCB task ID
 12h	WORD	native context save area
 14h	WORD	start address of task
 16h	WORD	end address of task
 18h	BYTE	task priority
 19h	BYTE	task time slice
 1Ah	BYTE	"TCBWAIT" run status of task
 1Bh	BYTE	"TCBSTAT" what the task is waiting for
 1Ch	DWORD	address of polling routine
 20h	BYTE	error code from last function call
 21h 11 BYTEs	name of currently executing task
 2Ch  4 BYTEs	???
 30h	BYTE	keyboard disabled if bit 1 set
 31h	BYTE	current shift state and toggles
 32h  2 BYTEs	???
 34h	BYTE	current video mode
 35h	BYTE	current video page
 36h	BYTE	number of text columns per screen
 37h	BYTE	number of text rows per screen
 38h	WORD	length of video buffer
 3Ah	WORD	video page length
 3Ch	WORD	apge start address in video RAM
 3Eh  4 WORDs	current cursor positions for four screen pages
 46h  8 BYTEs	???
 4Eh	WORD	current cursor type
 50h	BYTE	current palette setting
 51h	BYTE	original video mode
 52h	BYTE	start CRT row (00h or 01h)
 53h	BYTE	video RAM in task active
 54h	WORD	handle of video save area
 56h	WORD	page count of video save area
 58h	WORD	segment address of video save area
 5Ah	WORD	poitner to first Task File Block (see #2183)
 5Ch	WORD	pointer to first Current Directory Block (see #2186)
 5Eh	WORD	pointer to active Current Directory Block (see #2186)
 60h	BYTE	number of drives
 61h	BYTE	current drive (0=A:, etc.)
 62h	DWORD	disk transfer address
 66h  4 BYTEs	???
 6Ah	BYTE	verify flag (nonzero = on)
 6Bh	BYTE	break flag (nonzero = on)
 6Ch	WORD	share/lock retry count
 6Eh	WORD	ticks between share/lock retries
 70h	BYTE	remote printer flags (see #2181)
 71h	BYTE	ETX/ACK delay count
 72h	WORD	spooler segment address
 74h  2 BYTEs	???
 76h  3 BYTEs	remote printer redirection for LPT1 through LPT3 (see #2182)
 79h  2 BYTEs	???
 7Bh	DWORD	offset of username in TCB
 7Fh	BYTE	current output class
 80h  7 BYTEs	protection access rights, 2 bits per class (writeable!)
 87h 122 BYTEs	???
101h	BYTE	TCB sleep downcounter value
102h 20 BYTEs	???
116h	BYTE	last scan code
	...
5D0h	DWORD	far pointer to Device Driver Terminal's entry point
5D4h	WORD	offset of logical screen
5D6h	WORD	segment of logical screen
5D8h	WORD	cursor offset within page
5DAh	BYTE	screen columns
5DBh	WORD	async port number (0000h = none)
5DDh	DWORD	physical baudrate
5E1h 19 BYTEs	reserved for Device Driver Terminal (DDT)
	...
7A6h	DWORD	far pointer to unregister calling chain

Bitfields for PC-MOS/386 remote printer flags:
Bit(s)	Description	(Table 2181)
 0	LPT1 to terminal
 1	LPT2 to terminal
 2	LPT3 to terminal
 3	escape to printer pending
 4	use XON/XOFF
 5	use ETX/ACK
 6	waiting for ACK or XON
 7	transparent printing on

(Table 2182)
Values for PC-MOS/386 remote printer redirection:
 00h	not redirected
 01h	redirected to COM1
 ...
 18h	redirected to COM24
 51h	redirected to LPT1
 52h	redirected to LPT2
 53h	redirected to LPT3

Format of PC-MOS/386 Task File Block:
Offset	Size	Description	(Table 2183)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "F" = task file block
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---TFB---
 10h	WORD	segment address of next TFB
 12h	WORD	segment address of previous TFB
 14h	WORD	segment address of TFB's Global File Block (see #2185)
 16h	WORD	segment address of owner's PSP
 18h	WORD	file handle
 1Ah  3 BYTEs	???
 1Dh	DWORD	file position
 21h  4 BYTEs	???
 25h	BYTE	IOCTL flags (see #2184)
 26h  2 BYTEs	???

Bitfields for PC-MOS/386 IOCTL flags:
Bit(s)	Description	(Table 2184)
 0	stdin
 1	stdout
 2	null device
 3	clock device
 4	reserved
 5	ASCII mode instead of binary
 6	EOF encountered on input
 7	device rather than file

Format of PC-MOS/386 Global File Block:
Offset	Size	Description	(Table 2185)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "G" = global file block
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---GFB---
 10h 10 BYTEs	???
 1Ah	WORD	file attribute
 1Ch	BYTE	???
 1Dh	DWORD	address of device driver
 21h	WORD	first cluster
 23h	WORD	time of last modification
 25h	WORD	date of last modification
 27h	DWORD	size of file in bytes
 2Bh 11 BYTEs	???
 36h 11 BYTEs	device name or FCB-format filename
 41h	WORD	segment address of TFB list
 43h	WORD	segment address of first RLB (see #2188) (0000h = none)
 45h	BYTE	flag: nonzero if GFB refers to character device
 46h	WORD	address of Block Device Block (see #2187)
 48h	WORD	sector of file's directory entry
 4Ah	WORD	high word of file's directory entry
 4Ch	WORD	ofsset of directory entry within sector

Format of PC-MOS/386 Current Directory Block:
Offset	Size	Description	(Table 2186)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "C" = current directory block
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---CDB---
 10h	BYTE	drive number
 11h	BYTE	???
 12h 64 BYTEs	directory name
 52h	WORD	first directory cluster (0000h = root)

Format of PC-MOS/386 Block Device Block:
Offset	Size	Description	(Table 2187)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "B" = block device block
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---BDB---
 10h	BYTE	logical drive
 11h	BYTE	unit passed to driver
 12h	WORD	sector size
 14h	BYTE	cluster mask
 15h	BYTE	cluster shift count
 16h	WORD	starting sector of first FAT
 18h	BYTE	number of FATs
 19h	WORD	number of root directories
 1Bh	WORD	sector number of first data sector (cluster 0002h)
 1Dh	WORD	number of clusters + 1 (number of highest data cluster)
 1Fh	BYTE	number of sectors in FAT
 20h	WORD	beginning root directory sector number
 22h	DWORD	device driver address
 26h	BYTE	media descriptor byte
 27h  5 BYTEs	???
 2Ch	BYTE	flag: volume > 32MB
 2Dh	BYTE	???
 2Eh	BYTE	number of sectors per cluster
 2Fh	WORD	number of clusters on device
 31h	WORD	number of free clusters (FFFFh = unknown)
 33h	WORD	root directory cluster number
 35h	WORD	pointer to alias/subst string
 37h	WORD	TCB segment address of owner (0000h = none)

Format of PC-MOS/386 Record Lock Block:
Offset	Size	Description	(Table 2188)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "R" = record lock block
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---RLB---
 10h	WORD	segment address of owner's PSP
 12h	WORD	segment address of Global File Block (see #2185)
 14h	WORD	segment address of owner's Task File Block (see #2183)
 16h	DWORD	file offset of locked region start
 1Ah	DWORD	length of locked region
 1Eh	WORD	owner's handle for file
--------O-D407-------------------------------
INT D4 - PC-MOS/386 v3.0+ - WAIT FOR EVENT
	AH = 07h
	AL = events to monitor (see #2189)
	BX = number of timer ticks until timeout if AL bit 1 set
	CX = bitmap of IRQs to monitor if AL bit 2 set
		(bit 0 = IRQ0 .. bit 15 = IRQ15)
	DX = port to monitor if AL bit 3 set
Return: CF clear if successful
	    AL = type of event which woke up task (see above)
	    CX = IRQ (if any) which awakened task
	    DX = port (if any) which awakened task
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
Note:	a device driver may make this call with AL=00h, which indicates that
	  the driver is responsible for setting and clearing the TCBWAIT field
	  in the TCB.  To put task to sleep, set TCBWAIT bits 2-0 to 001; to
	  reawaken it, set bit 1 (leaving other bits unchanged)
SeeAlso: AH=04h,INT 16/AH=00h,INT 38

Bitfields for PC-MOS/386 events to monitor:
Bit(s)	Description	(Table 2189)
 0	keystroke
 1	timeout
 2	IRQ
 3	port access
 7	return status of user poll routine (other ignored if set)
--------O-D410-------------------------------
INT D4 - PC-MOS/386 v3.0+ - ENTER/LEAVE NATIVE 386 EXECUTION MODE
	AH = 10h
	AL = direction (00h return to V86 mode, 01h enter native mode)
	CX = length in bytes of Native Context Area ( >=1024 )
	DX = segment of Native Context Area
Return: CF clear if successful
	    running in desired mode at instruction following INT D4 call
	    all segment registers converted to appropriate selectors/segments
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
Note:	MS-DOS calls are available in protected mode
SeeAlso: AH=11h,AH=12h,AH=13h,INT 2F/AX=1687h,INT 67/AX=DE0Ch,INT 38
--------O-D411-------------------------------
INT D4 - PC-MOS/386 v3.0+ - ALLOCATE NATIVE MODE MEMORY BLOCK
	AH = 11h
	EBX = block length in bytes
Return: CF clear if successful
	    EBX = number of bytes actually allocated
	    ES = selector for allocated block
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
Note:	the memory must be released before the program terminates
SeeAlso: AH=10h,AH=12h,INT 38
--------O-D412-------------------------------
INT D4 - PC-MOS/386 v3.0+ - FREE NATIVE MODE MEMORY BLOCK
	AH = 12h
	ES = selector for block to free
Return: CF clear if successful
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
SeeAlso: AH=10h,AH=11h,AH=13h,INT 38
--------O-D413-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET ALIAS FOR SELECTOR (NATIVE MODE ONLY)
	AH = 13h
	AL = type of alias selector (00h data, 01h stack, 02h code)
	BX = selector
Return: CF clear if successful
	    AX = new selector or 0000h if BX selector not found
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
SeeAlso: AH=11h,AH=12h
--------O-D416-------------------------------
INT D4 - PC-MOS/386 v5.01 - SET/CLEAR IRQ RESERVATION
	AH = 16h
	AL = function (00h clear, 01h set reservation)
	CX = IRQ number
Return: AX = status
	    (0000h successful, 0001h currently reserved by another task)
SeeAlso: AH=07h,INT 14/AH=11h"PC-MOS"
--------O-D419-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET TASK ID
	AH = 19h
Return: BX = caller's task ID
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=1Dh,AH=1Eh
--------O-D41A-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET/SET TASK PRIORITY
	AH = 1Ah
	AL = subfunction (00h read, 01h set, 02h get and set)
	BX = task ID (FFFFh for current task)
	CL = new priority value
Return: CF clear if successful
	    CL = current priority value
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
SeeAlso: AH=1Bh,AH=1Ch
--------O-D41B-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET/SET TIME SLICE
	AH = 1Bh
	AL = subfunction (00h read, 01h set, 02h get and set)
	BX = task ID (FFFFh for current task) (see AH=19h)
	CL = new time slice value
Return: CF clear if successful
	    CL = current time slice value
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
SeeAlso: AH=1Ah,AH=1Ch
--------O-D41C-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET/SET KEYBOARD MODE
	AH = 1Ch
	AL = subfunction (00h enable, 01h disable, 02h get mode)
	BX = task ID (FFFFh for current task)
Return: CF clear if successful
	    CL = current keyboard state
	CF set on error
	    AX = error code (INT 21/AH=59h)
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=1Ah,AH=1Bh
--------O-D41D-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET CURRENT PROGRAM NAME
	AH = 1Dh
	BX = task ID (FFFFh for current task) (see AH=19h)
	ES:DI -> buffer for program name (see #2190)
Return: CF clear if successful
	    ES:DI buffer filled
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
SeeAlso: AH=19h,AH=1Eh

Format of PC-MOS/386 program name buffer:
Offset	Size	Description	(Table 2190)
 00h  8 BYTEs	filename
 08h  3 BYTEs	extension
--------O-D41E-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET CURRENT USERNAME AND SECURITY CLASS
	AH = 1Eh
	BX = task ID (FFFFh for current task)
	ES:DI -> 4-byte buffer for username
Return: CF clear if successful
	    CL = security class
		20h (' ') none
		41h-5Ah ('A'-'Z') security level
	    ES:DI buffer filled
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
SeeAlso: AH=19h,AH=1Dh
--------O-D41F-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET TASK PARTITION INFORMATION
	AH = 1Fh
	BX = task ID (FFFFh for current task) (see AH=19h)
Return: CF clear if successful
	    CX = start segment of task
	    DX = ending segment of task
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=2Dh
--------O-D420-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET PORT AND BAUDRATE INFORMATION
	AH = 20h
	BX = task ID (FFFFh for current task) (see AH=19h)
Return: CF clear if successful
	    CX = port number (0000h if none)
	    DI:SI = baudrate (if CX nonzero)
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
SeeAlso: INT 14/AH=0Ch"FOSSIL"
--------O-D421-------------------------------
INT D4 - PC-MOS/386 v5.01 - REMOVE A TASK
	AH = 21h
	BX = task ID (FFFFh for current task) (see AH=19h)
Return: CF clear if successful
	    AX = ASCII percentage of System Memory Pool used
		(AH = tens digit, AL = ones digit)
	    DS,SI destroyed
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=22h
--------O-D422-------------------------------
INT D4 - PC-MOS/386 v5.01 - ADD A TASK TO THE SYSTEM
	AH = 22h
	DS:SI -> addtask data structure (see #2192)
Return: CF clear if successful
	    ES = segment address of the new task's TCB data structure
	CF set on error
	    AX = error code (see #2191)
SeeAlso: AH=21h

(Table 2191)
Values for PC-MOS/386 error code:
 08h	insufficient memory
 0Bh	invalid addtask structure format
 12h	insufficient available space in system memory pool
 1Fh	general failure
 55h	already allocated
 57h	if task already in use or invalid parameter

Format of PC-MOS/386 addtask data structure:
Offset	Size	Description	(Table 2192)
 00h	WORD	task size in KB (min 16KB)
 02h	WORD	task ID (0000h for automatic selection)
 04h	BYTE	task class (' ' or 'A'-'Z')
 05h	DWORD	-> ASCIZ name of task startup batchfile
 09h	DWORD	-> task's terminal driver (0000000h = background task)
 0Dh	WORD	task port
 0Fh	DWORD	task baud rate
 13h	DWORD	(return) total extended memory
 17h	DWORD	(return) number of 4K extended memory pages allocated
 1Bh	WORD	(return) paragraphs of system memory pool allocated
 1Dh	WORD	(return) system memory pool size in paragraphs
 1Fh	WORD	(return) ASCII task percentage of system memory pool
 21h  3 BYTEs	reserved
--------O-D423-------------------------------
INT D4 - PC-MOS/386 v5.01 - CHANGE TERMINAL DRIVER
	AH = 23h
	BX = task ID (FFFFh for current task)
	DS:SI -> entry point of the new Device Driver Terminal
Return: CF clear if successful
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
--------O-D424-------------------------------
INT D4 U - PC-MOS/386 v5.01 - GET OPERATING SYSTEM SERIAL NUMBER
	AH = 24h
Return: DS:DX -> '$'-terminated string containing the serial number
--------O-D425-------------------------------
INT D4 - PC-MOS/386 v5.01 - IDENTIFY LOAD ADDRESS OF DEVICE DRIVER LOCATION
	AH = 25h
	DX = driver's CS value
Return: AX = segment address of driver in system memory pool
	    (0000h if the driver is not within the system memory pool)
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
--------O-D426-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET SYSTEM CONTROL BLOCK SEGMENT/SELECTOR
	AH = 26h
Return: DX = segment/selector of the System Control Block (see #2178)
Note:	this function supersedes AH=02h
SeeAlso: AH=02h,AH=27h,AH=28h,AH=29h,AH=2Ah
--------O-D427-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET TASK CONTROL BLOCK SEGMENT/SELECTOR
	AH = 27h
	BX = task ID (FFFFh if current task) (see AH=19h)
Return: CF clear if successful
	    DX = segment/selector for the Task Control Block (see #2180)
	CF set on error
	    AX = error code (INT 21/AH=59h)
Note:	this function supersedes AH=04h
SeeAlso: AH=26h,AH=28h,AH=29h,AH=2Ah
--------O-D428-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET CONTROL BLOCK DATA FROM SCB OR TCB
	AH = 28h
	BX = offset into control block at which to start reading
	CX = number of bytes to read
	DX = segment/selector of control block obtained via AH=26h or AH=27h
	ES:DI -> buffer for data
Return: CF clear if successful
	CF set on error
	    AX = error code (see also INT 21/AH=59h)
		05h access denied due to an invalid segment/selector
SeeAlso: AH=26h,AH=27h,AH=29h,AH=2Ah
--------O-D429-------------------------------
INT D4 - PC-MOS/386 v5.01 - WRITE CONTROL BLOCK DATA INTO SCB OR TCB
	AH = 29h
	BX = offset into control block at which to start writing
	CX = number of bytes to write
	DX = segment/selector of control block obtained via AH=26h or AH=27h
	DS:SI -> buffer containing data to be written
Return: CF clear if successful
	CF set on errro
	    AX = error code (see also INT 21/AH=59h)
		05h access denied due to an invalid segment/selector
Note:	 this function performs no bounds checking
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=26h,AH=27h,AH=28h,AH=2Ah
--------O-D42A-------------------------------
INT D4 - PC-MOS/386 v5.01 - SWAP CONTROL BLOCK DATA OF SCB OR TCB
	AH = 2Ah
	BX = offset into control block at which to start swap
	CX = number of bytes to swap
	DX = segment/selector of control block obtained via AH=26h or AH=27h
	DS:SI -> buffer containing new data and to receive current data
Return: CF clear if successful
	CF set on error
	    AX = error code (see also INT 21/AH=59h)
		05h access denied due to an invalid segment/selector
Note:	the interrupts are disabled during the swap to prevent corruption
SeeAlso: AH=26h,AH=27h,AH=28h,AH=29h
--------O-D42C-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET/SET SPOOLER PARAMETERS
	AH = 2Ch
	AL = function
	    00h set spooler timeout
		CX = timout value in seconds
	    01h get spooler timeout
		Return: CX = current timeout in seconds
	    02h get spooler parameters
		Return: CH = priority (00h-09h)
			CL = disposition (d, h, i, n, s)
			SI = class (a - z)
	    03h set spooler parameters
		CH = priority (00h-09h)
		CL = disposition (d, h, i, n, s)
		SI = class (a - z)
		BX = task ID (FFFFh for current task)
		DX = LPT number
Return: CF clear if successful
	CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
SeeAlso: AH=00h,AH=02h,AH=03h
--------O-D42D-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET MAXIMUM TASK SIZE
	AH = 2Dh
Return: DX = maximum task size in paragraphs
	BX = start address of task space
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=1Fh,AH=22h
--------r-D5---------------------------------
INT D5 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D4"BASIC",INT D6"BASIC"
--------r-D5---------------------------------
INT D5 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-D6---------------------------------
INT D6 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D5"BASIC",INT D7"BASIC"
--------r-D6---------------------------------
INT D6 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-D7---------------------------------
INT D7 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D6"BASIC",INT D8"BASIC"
--------r-D7---------------------------------
INT D7 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-D8---------------------------------
INT D8 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D7"BASIC",INT D9"BASIC"
--------r-D8---------------------------------
INT D8 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------H-D8---------------------------------
INT D8 - Screen Thief v1.00 - RELOCATED IRQ0
Range:	INT 78h to INT E0h, selected by commandline switch
Note:	Screen Thief relocates IRQs 0 through 7 to INT D8 to INT DF by default,
	  but may be directed via a commandline switch to use any range
	  starting at a multiple of 8 between 78h and E0h
SeeAlso: INT 08"IRQ0",INT 2D/AL=10h"Screen Thief",INT 50"DESQview"
SeeAlso: INT D9"Screen Thief"
--------r-D9---------------------------------
INT D9 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D8"BASIC",INT DA"BASIC"
--------r-D9---------------------------------
INT D9 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------H-D9---------------------------------
INT D9 - Screen Thief v1.00 - RELOCATED IRQ1
Range:	INT 79h to INT E1h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 09"IRQ1",INT D8"Screen Thief",INT DA"Screen Thief"
--------r-DA---------------------------------
INT DA - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D9"BASIC",INT DB"BASIC"
--------r-DA---------------------------------
INT DA - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------H-DA---------------------------------
INT DA - Screen Thief v1.00 - RELOCATED IRQ2
Range:	INT 7Ah to INT E2h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0A"IRQ2",INT D9"Screen Thief",INT DB"Screen Thief"
--------r-DB---------------------------------
INT DB - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DA"BASIC",INT DC"BASIC"
--------r-DB---------------------------------
INT DB - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------H-DB---------------------------------
INT DB - Screen Thief v1.00 - RELOCATED IRQ3
Range:	INT 7Bh to INT E3h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0B"IRQ3",INT DA"Screen Thief",INT DC"Screen Thief"
--------u-DC---------------------------------
INT DC - PC/370 v4.1- - API
SeeAlso: INT 60"PC/370"
--------r-DC---------------------------------
INT DC - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DB"BASIC",INT DD"BASIC"
--------r-DC---------------------------------
INT DC - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------H-DC---------------------------------
INT DC - Screen Thief v1.00 - RELOCATED IRQ4
Range:	INT 7Ch to INT E4h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0C"IRQ4",INT DB"Screen Thief",INT DD"Screen Thief"
--------r-DD---------------------------------
INT DD - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DC"BASIC",INT DE"BASIC"
--------r-DD---------------------------------
INT DD - STSC APL*PLUS/PC v9.0 - PLACE KEYSTROKE EVENTS IN INPUT BUFFER
	BX = where to place keystrokes
	    FFFFh insert before current buffer contents
	    0000h replace current contents
	    0001h insert after current contents
	CX = number of keystroke events to insert
	ES:SI -> data to be placed into buffer (list of WORD key codes)
	    4000h + N = normal ASCII keystroke N (N = 00h to FFh)
	    4100h + N = extended ASCII keystroke N (N = 03h to 84h)
SeeAlso: INT 16/AH=05h
--------H-DD---------------------------------
INT DD - Screen Thief v1.00 - RELOCATED IRQ5
Range:	INT 7Dh to INT E5h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0D"IRQ5",INT DC"Screen Thief",INT DE"Screen Thief"
--------r-DE---------------------------------
INT DE - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DD"BASIC",INT DF"BASIC"
--------r-DE---------------------------------
INT DE - APL*PLUS/PC - ???
Note:	appears to be the same as INT 16
--------H-DE---------------------------------
INT DE - Screen Thief v1.00 - RELOCATED IRQ6
Range:	INT 7Eh to INT E6h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0E"IRQ6",INT DD"Screen Thief",INT DF"Screen Thief"
--------b-DF---------------------------------
INT DF - Victor 9000 - SuperBIOS
--------r-DF---------------------------------
INT DF - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DE"BASIC",INT E0"BASIC"
--------r-DF---------------------------------
INT DF - APL*PLUS/PC - SAME AS INT 10
SeeAlso: INT 10
--------H-DF---------------------------------
INT DF - Screen Thief v1.00 - RELOCATED IRQ7
Range:	INT 7Fh to INT E7h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0F"IRQ7",INT DE"Screen Thief"
--------r-E0---------------------------------
INT E0 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DF"BASIC",INT E1"BASIC"
--------r-E0---------------------------------
INT E0 - APL*PLUS/PC - RESTIME HIGH-RESOLUTION TIMER FOR QUAD MF FUNCTION
SeeAlso: INT CF"APL"
--------v-E0---------------------------------
INT E0 - VIRUS - "Micro-128" - ???
Note:	Micro-128 also overwrites the upper half of the interrupt table
SeeAlso: INT 9E"VIRUS",INT F1"VIRUS"
--------O-E0---------------------------------
INT E0 - CP/M-86, Concurrent CP/M, DR Multiuser DOS - FUNCTION CALLS
	CL = function number
	DS,DX = parameters
Return: as appropriate for function
Notes:	several functions are covered in more detail in following entries
	most of these calls are also supported by Digital Research's DOS Plus
	  v2.1; the unsupported functions are 26h,29h-2Bh,3Ah,3Dh-62h,71h-8Ch,
	  90h-92h,94h-97h,9Bh-ABh, and AEh-FFh
SeeAlso: INT 21/AX=4459h,INT 21/AH=E0h"DOS Plus"

(Table 2193)
Values for CP/M-86,DR Multiuser DOS function number:
 00h	terminate calling process (see also INT 21/AH=00h)
 01h	read a character
 02h	write character to default console (see also INT 21/AH=02h)
 03h	read character from default AUX (see also INT 21/AH=03h)
 04h	write character to default AUX (see also INT 21/AH=04h)
 05h	write character to default list device (see also INT 21/AH=05h)
 06h	perform raw I/O on default console (see also INT 21/AH=06h)
 07h	return default AUX input status
 08h	return default AUX output status
 09h	write string to default console (see also INT 21/AH=09h)
 0Ah	read string from default console (see also INT 21/AH=0Ah)
 0Bh	return default console input status (see also INT 21/AH=0Bh)
 0Ch	get BDOS release ID
 0Dh	reset all disk drives (see also INT 21/AH=0Dh)
 0Eh	set default drive (see also INT 21/AH=0Eh)
 0Fh	open file via FCB (see also INT 21/AH=0Fh,#0486)
 10h	close file via FCB (see also INT 21/AH=10h)
 11h	search for first matching file with FCB (see also INT 21/AH=11h)
 12h	search for next matching file with FCB (see also INT 21/AH=12h)
 13h	delete file via FCB (see also INT 21/AH=13h)
 14h	sequential read via FCB (see also INT 21/AH=14h)
 15h	sequential write via FCB (see also INT 21/AH=15h)
 16h	create file via FCB (see also INT 21/AH=16h)
 17h	rename file via FCB (see also INT 21/AH=17h)
 18h	get bit map of logged drives
 19h	get default drive (see also INT 21/AH=19h)
 1Ah	set DMA address offset
 1Bh	get default disk allocation vector (see also INT 21/AH=1Bh)
 1Ch	set default drive to read-only
 1Dh	get bit map of read-only drives
 1Eh	set file attributes via FCB (see also INT 21/AX=4301h)
 1Fh	get address of disk parameter block (see also INT 21/AH=1Fh)
 20h	get/set default user number
 21h	read random record via FCB (see also INT 21/AH=21h)
 22h	write random record via FCB (see also INT 21/AH=22h)
 23h	compute file size with FCB (see also INT 21/AH=23h)
 24h	get FCB random record number (see also INT 21/AH=24h)
 25h	reset specified drives
 26h	access specified drives (not in DR DOS Plus v2.1)
 27h	free specified drives
 28h	write random with FCB, zero fill (see also also INT 21/AH=28h)
 2Ah	lock records in FCB file (see also INT 21/AH=5Ch)
 2Bh	unlock records in FCB file (see also INT 21/AH=5Ch)
 2Ch	set BDOS multisector count
 2Dh	set BDOS error mode
 2Eh	get free space on disk
 2Fh	load, initialize, and jump to process (see also INT 21/AH=4Bh)
 30h	flush write-deferred buffers
 31h	get/set system variable (DOS Plus v2.1)
 32h	call BIOS (XIOS) character routine (see #2194)
 33h	set DMA address segment
 34h	get DMA buffer address
 35h	CP/M-86 allocate maximum memory
 36h	allocate maximum memory at specified segment
 37h	CP/M-86 allocate memory segment (see also INT 21/AH=48h)
 38h	allocate memory at specified segment
 39h	CP/M-86 free specified memory segment (see also INT 21/AH=49h)
 3Ah	CP/M-86 free all memory (not in DOS Plus v2.1)
 3Bh	load .CMD file into memory
 3Ch	(DOS Plus v2.1) call RSX program
 40h	(DR-NET) log on a server
 41h	(DR-NET) log off a server
 42h	(DR-NET) send a message
 43h	(DR-NET) receive a message
 44h	(DR-NET) get network status
 45h	(DR-NET) get requestor configuration table
 46h	(DR-NET) set compatibility attributes
 47h	(DR-NET) get server configuration table
 48h	(DR-NET) set network error mode
 49h	(DR-NET) attach network
 4Ah	(DR-NET) detach network
 4Bh	(DR-NET) set default password
 4Ch	(DR-NET) get-set long timeout
 4Dh	(DR-NET) get parameter table
 50h	(DR-NET) get network information
 53h	get current time (see also INT 21/AH=2Ch)
 54h	set current time (see also INT 21/AH=2Dh)
 55h	get binary system date (see also INT 21/AH=2Ah)
 56h	set system date (see also INT 21/AH=2Bh)
 57h	allocate system flag
 58h	deallocate system flag
 59h	reserve memory in global area
 5Ah	lock physical drive
 5Bh	unlock physical drive
 5Ch	search path for executable file
 5Dh	load and execute command (see also INT 21/AH=4Bh)
 5Eh	get/set process exit code
 5Fh	set country information
 60h	get country information
 63h	truncate FCB file (see also INT 21/AH=28h)
 64h	create/update directory label
 65h	get directory label
 66h	get FCB date stamp and password mode
 67h	write extended FCB
 68h	set system date and time
 69h	get system date and time in binary
 6Ah	establish password for file access
 6Bh	get OS serial number
 6Ch	(DOS Plus v2.1) get/set program return code
 6Dh	get/set console mode
 6Eh	get/set string delimiter
 6Fh	write block to default console
 70h	write block to default list device
 71h	execute DOS-compatible function
 74h	set FCB time and date stamps
 80h	allocate memory
 82h	deallocate memory
 83h	poll I/O device
 84h	wait on system flag
 85h	set system flag
 86h	create message queue
 87h	open message queue
 88h	delete message queue
 89h	read from message queue
 8Ah	conditionally read from message queue
 8Bh	write to message queue
 8Ch	conditionally write to message queue
 8Dh	delay calling process
 8Eh	call process dispatcher (yield CPU)
 8Fh	terminate calling process (same as function 00h)
 90h	create a process
 91h	set calling process' priority
 92h	attach to default console
 93h	detach from default console
 95h	assign default console to process
 96h	interpret and execute commandline
 97h	resident procedure library
 98h	parse ASCII string into FCB (see also INT 21/AH=29h)
 99h	return default console
 9Ah	get address of system data (SYSDAT)
 9Bh	get system time and date
 9Ch	return calling process' descriptor
 9Dh	terminate process by name or PD address
 9Eh	attach to default list device
 9Fh	detach from default list device
 A0h	select default list device
 A1h	conditionally attach to default list device
 A2h	conditionally attach to default console
 A3h	get OS version number
 A4h	get default list device
 A5h	attach to default AUX
 A6h	detach from default AUX
 A7h	conditionally attach to default AUX
 A8h	set default AUX
 A9h	return default AUX
 ACh	read block from default AUX
 ADh	(DOS Plus v2.1) write block to default AUX
 B0h	configure default AUX
 B1h	get/set device control parameters
 B2h	send Break through default AUX
 B3h	allocate physical memory
 B4h	free physical memory
 B5h	map physical memory
 B6h	nondestructive message queue read
 B7h	timed wait on system flag
 B8h	get/set I/O port mapping
 B9h	set list device timeout
 BAh	set AUX timeout value
 BBh	execute XIOS service
 BDh	(DR Multiuser DOS) delay
 FFh	return 80386 to native mode

(Table 2194)
Values for DOS Plus v2.1 XIOS functions:
 00h	terminate program
 01h	???
 02h	check for console input status
 03h	read character from console
 04h	write character to console
 05h	write character to list device
 06h	write character to auxiliary device
 07h	read cahracter from auxiliary device
 0Fh	get list device status
 10h-14h reserved
 15h	device initialization
 16h	check console output status
 17h-7Fh reserved
---BBC Acorn---
 80h	get XIOS version
 81h	get Tube semaphore
 82h	release Tube semaphore
 83h	select text/graphics
 84h	update B&W graphics rectangle
 85h	update color graphics rectangle
 86h	get/release/update mouse
 87h	get system error info
 88h	entry in CLOCK called by WatchDog RSP
 89h	BBC OSBYTE function
 8Ah	BBC OSWORD function

(Table 2195)
Values for DR Multiuser DOS Error Return Code:
 00h	no error
 01h	system call not implemented
 02h	illegal system call number
 03h	cannot find memory
 04h	illegal flag number
 05h	flag overrun
 06h	flag underrun
 07h	no unused Queue Descriptors
 08h	no free queue buffer
 09h	cannot find queue
 0Ah	queue in use
 0Ch	no free Process Descriptors
 0Dh	no queue access
 0Eh	empty queue
 0Fh	full queue
 10h	CLI queue missing
 11h	no 8087 in system
 12h	no unused Memory Descriptors
 13h	illegal console number
 14h	no Process Descriptor match
 15h	no console match
 16h	no CLI process
 17h	illegal disk number
 18h	illegal filename
 19h	illegal filetype
 1Ah	character not ready
 1Bh	illegal Memory Descriptor
 1Ch	bad return from BDOS load
 1Dh	bad return from BDOS read
 1Eh	bad return from BDOS open
 1Fh	null command
 20h	not owner of resource
 21h	no CSEG in load file
 22h	process Descriptor exists on Thread Root
 23h	could not terminate process
 24h	cannot attach to process
 25h	illegal list device number
 26h	illegal password
 28h	external termination occurred
 29h	fixup error upon load
 2Ah	flag set ignored
 2Bh	illegal auxilliary device number
--------O-E0----CL03-------------------------
INT E0 - DR Multiuser DOS - "A_READ" - READ CHARACTER FROM AUX DEVICE
	CL = 03h
Return: AL = ASCII character
Notes:	A_READ reads the next 8-bit character from the logical auxilliary
	  input device (AUXn:); control is not returned to the calling
	  process until a character has been read.
	if another process owns AUX, this call blocks until the device becomes
	  available
SeeAlso: INT 21/AH=03h,INT E0/CL=04h,INT E0/CL=07h,INT E0/CL=A5h,INT E0/CL=ACh
--------O-E0----CL04-------------------------
INT E0 - DR Multiuser DOS - "A_WRITE" - WRITE CHARACTER TO AUX DEVICE
	CL = 04h
	DL = ASCII character
Return: nothing
Note:	if another process owns AUX, this call blocks until the device becomes
	  available
SeeAlso: INT 21/AH=04h,INT E0/CL=03h,INT E0/CL=08h,INT E0/CL=A5h,INT E0/CL=ADh
--------O-E0----CL07-------------------------
INT E0 - DR Multiuser DOS - "A_STATIN" - GET INPUT STATUS OF AUX DEVICE
	CL = 07h
Return: AL = status
	    00h not ready
	    FFh character available
Desc:	determine whether the current AUX device has input available
SeeAlso: INT E0/CL=03h,INT E0/CL=08h
--------O-E0----CL08-------------------------
INT E0 - DR Multiuser DOS - "A_STATOUT" - GET OUTPUT STATUS OF AUX DEVICE
	CL = 08h
Return: AL = status
	    00h not ready
	    FFh ready for output
Desc:	determine whether the current AUX device is able to accept more output
SeeAlso: INT E0/CL=04h,INT E0/CL=07h
--------O-E0----CL59-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "S_MEMORY" - RESERVE MEMORY IN GLOBAL AREA
	CL = 59h
	DX = size in bytes
Return: AX = status
	    FFFFh failed
	    other successful
		ES:BX -> reserved memory
--------O-E0----CL86-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_MAKE" - CREATE MESSAGE QUEUE
	CL = 86h
	DS:DX -> queue descriptor (see #2196)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #2195)
SeeAlso: INT E0/CL=87h

Format of DR Multiuser DOS queue descriptor:
Offset	Size	Description	(Table 2196)
 00h  2 WORDs	internal use, initialize to zeros
 04h	WORD	flags
 06h  8 BYTEs	queue name
 0Eh	WORD	length of message
 10h	WORD	number of messages
 12h  4 WORDs	internal use, initialize to zeros
 1Ah	WORD	offset in system area of buffer for messages
--------O-E0----CL87-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_OPEN" - OPEN MESSAGE QUEUE
	CL = 87h
	DS:DX -> queue parameter block (see #2197)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #2195)
SeeAlso: INT E0/CL=86h,INT E0/CL=89h

Format of DR Multiuser DOS queue parameter block:
Offset	Size	Description	(Table 2197)
 00h	WORD	internal use, initialize to zero
 02h	WORD	queue ID (set by INT E0/CL=87h)
 04h	WORD	internal use, initialize to zero
 06h	WORD	offset of queue message buffer
 08h  8 BYTEs	queue name
--------O-E0----CL89-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_READ" - READ MESSAGE QUEUE
	CL = 89h
	DS:DX -> queue parameter block (see #2197)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #2195)
SeeAlso: INT E0/CL=87h,INT E0/CL=8Ah,INT E0/CL=8Bh
--------O-E0----CL8A-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_CREAD" - CONDITIONALLY READ MSG QUEUE
	CL = 8Ah
	DS:DX -> queue parameter block (see #2197)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #2195)
SeeAlso: INT E0/CL=87h,INT E0/CL=89h,INT E0/CL=8Ch
--------O-E0----CL8B-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_WRITE" - WRITE MESSAGE QUEUE
	CL = 8Bh
	DS:DX -> queue parameter block (see #2197)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #2195)
SeeAlso: INT E0/CL=89h,INT E0/CL=8Ch
--------O-E0----CL8C-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_CWRITE" - CONDITIONALLY WRITE MSG QUEUE
	CL = 8Ch
	DS:DX -> queue parameter block (see #2197)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #2195)
SeeAlso: INT E0/CL=8Ah,INT E0/CL=8Bh
--------O-E0----CL8E-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "P_DISPATCH" - CALL DISPATCHER
	CL = 8Eh
	DX = FFFFh (optional) to force dispatch
Return: nothing
Desc:	allow other processes of the same or higher priority to run if they
	  are ready
Note:	if DX=FFFFh, a dispatch is forced even if no other process is ready
SeeAlso: INT E0/CL=91h
--------O-E0----CL91-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "P_PRIORITY" - SET PROCESS PRIORITY
	CL = 91h
	DL = new priority (00h highest to FFh lowest)
Note:	sets priority of calling process; transient processes are initialized
	  to priority C8h
SeeAlso: INT E0/CL=8Eh
--------O-E0----CL93-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "C_DETACH" - DETACH FROM DEFAULT CONSOLE
	CL = 93h
Return: AX = status
	    0000h successfully detached
	    FFFFh detach failed
SeeAlso: INT E0/CL=A6h
--------O-E0----CLA5-------------------------
INT E0 - DR Multiuser DOS - "A_ATTACH" - ATTACH AUX DEVICE
	CL = A5h
Desc:	attaches the default auxiliary device to the calling process unless
	  it is already attached to another process, in which case the call
	  blocks until the device becomes available
Note:	this call should be used before attempting to read or write from
	  the AUX device; however, the I/O calls internally call this function
	  to ensure device ownership
SeeAlso: INT E0/CL=03h,INT E0/CL=04h,INT E0/CL=A6h,INT E0/CL=A7h,INT E0/CL=A8h
SeeAlso: INT E0/CL=ACh,INT E0/CL=ADh,INT E0/CL=B0h
--------O-E0----CLA6-------------------------
INT E0 - DR Multiuser DOS - "A_DETACH" - DETACH FROM AUX DEVICE
	CL = A6h
Return: AX = status
	    0000h successfully detached
	    FFFFh detach failed
	CX = error code
SeeAlso: INT E0/CL=93h,INT E0/CL=A5h,INT E0/CL=A7h
--------O-E0----CLA7-------------------------
INT E0 - DR Multiuser DOS - "A_CATTACH" - CONDITIONALLY ATTACH TO AUX DEVICE
	CL = A7h
Return: AX = status
	    0000h attached
	    FFFFh unable to attach
Desc:	attaches the default auxiliary device to the calling process if it is
	  available
Note:	does not block if the device is already in use
SeeAlso: INT E0/CL=A5h,INT E0/CL=A6h,INT E0/CL=A8h,INT E0/CL=B0h
--------O-E0----CLA8-------------------------
INT E0 - DR Multiuser DOS - "A_SET" - SET DEFAULT AUX DEVICE NUMBER
	CL = A8h
	DL = auxiliary device number
Return: AX = status
	    0000h successful
	    FFFFh failed
	CX = error code
Desc:	specify which physical device will become AUX
SeeAlso: INT E0/CL=A5h,INT E0/CL=A9h
--------O-E0----CLA9-------------------------
INT E0 - DR Multiuser DOS - "A_GET" - GET DEFAULT AUX DEVICE NUMBER
	CL = A9h
Return: AL = current default auxiliary device number
Desc:	determine which physical device is currently AUX
SeeAlso: INT E0/CL=A8h
--------O-E0----CLAC-------------------------
INT E0 - DR Multiuser DOS - "A_READBLK" - READ STRING FROM AUX DEVICE
	CL = ACh
	DS:DX -> character control block (CHCB) (see #2198)
Return: AX = number of characters read
Desc:	read characters from the default auxiliary (AUXn:) device into a buffer
	  until the buffer is full or the device is no longer ready
Notes:	if the device is initially not ready, blocks until at least one
	  character has been read
	if another process owns AUX, this call blocks until the device becomes
	  available
SeeAlso: INT E0/CL=03h,INT E0/CL=A5h,INT E0/CL=ADh

Format of DR Multiuser DOS character control block (CHCB):
Offset	Size	Description	(Table 2198)
 00h	DWORD	pointer to character buffer
 04h	WORD	length of character buffer
--------O-E0----CLAD-------------------------
INT E0 - DR Multiuser DOS - "A_WRITEBLK" - WRITE STRING TO AUX DEVICE
	CL = ADh
	DS:DX -> character control block (see INT E0/CL=ACh)
Return: AX = number of characters written
Note:	does not return until at least one character has been written
SeeAlso: INT E0/CL=04h,INT E0/CL=A5h,INT E0/CL=ACh
--------O-E0----CLB0-------------------------
INT E0 - DR Multiuser DOS - "A_CONFIG" - GET/SET AUX DEVICE PARAMETERS
	CL = B0h
	DX:DX -> AUX device parameter block (see #2199)
Return: AX = status
	    0000h successful
		parameter block updated
	    FFFFh failed
		CX = error code
SeeAlso: INT E0/CL=A5h,INT E0/CL=B1h

Format of DR Multiuser DOS AUX device parameter block:
Offset	Size	Description	(Table 2199)
 00h	BYTE	function (00h get, 01h set)
 01h	BYTE	baud rate (see #2201) FFh = don't change/unknown
 02h	BYTE	parity (see #2200)
 03h	BYTE	stop bits (00h one, 01h 1.5, 02h two, FFh unknown/don't change)
 04h	BYTE	data bits (05h-08h or FFh unknown/don't change)
 05h	BYTE	handshake (00h none, 01h DTS/DSR, 02h RTS/CTS, 04h XON/XOFF,
		FFh unknown/don't change)
 06h	BYTE	XON character, FFh unknown/don't change
 07h	BYTE	XOFF character, FFh unknown/don't change

(Table 2200)
Values for parity:
 00h	none
 01h	odd
 02h	none
 03h	even
 04h	stick parity bit
 FFh	don't change/unknown

(Table 2201)
Values for baud rate:
 00h	50 baud
 01h	62.5 baud
 02h	75 baud
 03h	110 baud
 04h	134.5 baud
 05h	150 baud
 06h	200 baud
 07h	300 baud
 08h	600 baud
 09h	1200 baud
 0Ah	1800 baud
 0Bh	2000 baud
 0Ch	2400 baud
 0Dh	3600 baud
 0Eh	4800 baud
 0Fh	7200 baud
 10h	9600 baud
 11h	19200 baud
 12h	38400 baud
 13h	56000 baud
 14h	76800 baud
 15h	115200 baud
--------O-E0----CLB1-------------------------
INT E0 - DR Multiuser DOS - "A_CONTROL" - GET/SET AUX CONTROL PARAMETERS
	CL = B1h
	DS:DX -> AUX device control block (see #2202)
Return: AX = status
	    0000h successful
		control block updated
	    FFFFh failed
		CX = error code
SeeAlso: INT E0/CL=B0h,INT E0/CL=B2h

Format of DR Multiuser DOS AUX device control block:
Offset	Size	Description	(Table 2202)
 00h	BYTE	function (00h get, 01h set)
 01h	BYTE	DTR state (00h low, 01h high, FFh unknown/don't change)
 02h	BYTE	RTS state (00h low, 01h high, FFh unknown/don't change)
 03h	BYTE	DSR state (00h low, 01h high, FFh unknown/don't change)
 04h	BYTE	CTS state (00h low, 01h high, FFh unknown/don't change)
 05h	BYTE	DCD state (00h low, 01h high, FFh unknown/don't change)
 06h	BYTE	RI state (00h inactive, 01h active, FFh unknown/don't change)
--------O-E0----CLB2-------------------------
INT E0 - DR Multiuser DOS - "A_BREAK" - SEND BREAK TO AUX DEVICE
	CL = B2h
	DX = duration of break in system ticks (0001h-FFFFh)
Return: AX = status
	    0000h successful
		break signal completed
	    FFFFh failed
		CX = error code
Note:	if the AUX device is currently owned by another process, this call will
	  block until the device becomes available
SeeAlso: INT E0/CL=A5h,INT E0/CL=B1h
--------O-E0----CLBD-------------------------
INT E0 - DR Multiuser DOS - "P_DELAY" - DELAY EXECUTION
	CL = BDh
	DX = delay in system ticks
Return: after the delay elapses
Notes:	the length of a system tick is installation-dependent (typically
	  1/50 or 1/60 second); the length may be determined by reading the
	  TICKSPERSEC value from the system data segment
	the actual delay before the process is rescheduled to run may be up to
	  one tick longer than requested; the delay between rescheduling and
	  actual execution cannot be predicted if higher-priority processes
	  are awaiting a turn at the CPU
SeeAlso: INT 15/AH=86h,INT 1A/AX=FF01h,INT 2F/AX=1224h,INT 62/AX=0096h
--------g-E00000-----------------------------
INT E0 - PCROBOTS v1.41 - "SWAPTASK" - END CURRENT ROBOT'S TURN
	AX = 0000h
Program: PCROBOTS is P.D. Smith's adaptation of Tom Poindexter's CROBOTS, in
	  which specially-written .COM or .EXE programs form robots battling
	  each other in a user-defined arena
--------g-E00001-----------------------------
INT E0 - PCROBOTS v1.41 - "MOVEMENT" - START MOVING
	AX = 0001h
	BX = speed (0-maximum for robot)
	CX = direction (0-359 degrees)
Notes:	the speed will change to the specified value at the maximum
	  acceleration the robot is capable of; if the robot is already moving
	  faster than its maximum maneuverability speed, it will not be able
	  to change direction
	this call also terminates the current robot's turn
SeeAlso: AX=0000h,AX=0002h,AX=0003h
--------g-E00002-----------------------------
INT E0 - PCROBOTS v1.41 - "SCAN" - SCAN FOR OTHER ROBOTS IN THE GIVEN DIRECTION
	AX = 0002h
	BX = direction (0-359 degrees)
	CX = resolution (0-45 degrees)
Return: AX = status
	    FFFFh if nothing detected
	    else robot ID (0-19)
		BX = range to detected robot
Notes:	the scan searches within CX degrees to either side of the specified
	  direction
	the scanner will see right through walls, but shells will not pass
	  through walls
	this call also terminates the current robot's turn
SeeAlso: AX=0000h,AX=0001h,AX=0003h
--------g-E00003-----------------------------
INT E0 - PCROBOTS v1.41 - "SHOOT" - FIRE A SHELL AT ANOTHER ROBOT
	AX = 0003h
	BX = direction (0-359 degrees)
	CX = range (0-700)
Return: AX = status (0000h not fired, else ID of shell fired)
Notes:	up to seven shells may be in flight for a robot at one time; the cannon
	  takes 50 ticks to reload
	this call also terminates the current robot's turn
SeeAlso: AX=0000h,AX=0001h,AX=0002h,AX=002Ch
--------g-E00010-----------------------------
INT E0 - PCROBOTS v1.41 - "GETXY" - GET ROBOT'S CURRENT POSITION
	AX = 0010h
Return: BX = current X coordinate (0-999)
	CX = current Y coordinate (0-999)
--------g-E00011-----------------------------
INT E0 - PCROBOTS v1.41 - "TRANSMIT" - SEND DATA TO ANOTHER ROBOT
	AX = 0011h
	BX = target robot ID
	CX = data to be sent
Return: AX = status (0000h data could not be sent, 0001h data sent)
Note:	this call costs one unit of battery power
--------g-E00012-----------------------------
INT E0 - PCROBOTS v1.41 - "RECEIVE" - GET DATA FROM OTHER ROBOTS
	AX = 0012h
Return: AX = status
	    0000h no data available
	    0001h data retrieved
		BX = sender's ID
		CX = data
Note:	each robot has a 20-word receive FIFO; if the FIFO is full, other
	  robots will be unable to send more data until some is read
--------g-E00013-----------------------------
INT E0 - PCROBOTS v1.41 - "DAMAGE" - DETERMINE HOW MUCH DAMAGE SUSTAINED
	AX = 0013h
Return: BX = damage status
Note:	the initial value depends on configuration, but is typically 100; as
	  the robot is damaged, it decreases
--------g-E00014-----------------------------
INT E0 - PCROBOTS v1.41 - "SPEED" - DETERMINE HOW FAST ROBOT IS MOVING
	AX = 0014h
Return: BX = current speed
--------g-E00015-----------------------------
INT E0 - PCROBOTS v1.41 - "BATTERY" - DETERMINE HOW MUCH BATTERY POWER LEFT
	AX = 0015h
Return: BX = current battery charge
Note:	the battery starts off with 1000 units of charge, and is constantly
	  being charged by solar panels and constantly discharged by motion;
	  the battery is charged at 4 units per turn and discharged at
	  0.1*speed units per turn.
--------g-E00016-----------------------------
INT E0 - PCROBOTS v1.41 - "TICKS" - DETERMINE HOW LONG SINCE GAME STARTED
	AX = 0016h
Return: BX:CX = number of game ticks elapsed (not related to real time)
--------g-E00017-----------------------------
INT E0 - PCROBOTS v1.41 - "L_SIN" - GET SCALED SINE OF AN ANGLE
	AX = 0017h
	BX = angle (0-359 degrees)
Return: BX:CX = 100000*sine of angle
SeeAlso: AX=0018h,AX=0019h,AX=001Ah,AX=001Bh
--------g-E00018-----------------------------
INT E0 - PCROBOTS v1.41 - "L_COS" - GET SCALED COSINE OF AN ANGLE
	AX = 0018h
	BX = angle (0-359 degrees)
Return: BX:CX = 100000*cosine of angle
SeeAlso: AX=0017h,AX=0019h,AX=001Ah
--------g-E00019-----------------------------
INT E0 - PCROBOTS v1.41 - "L_TAN" - GET SCALED TANGENT OF AN ANGLE
	AX = 0019h
	BX = angle (0-359 degrees)
Return: BX:CX = 100000*tangent of angle
SeeAlso: AX=0017h,AX=0018h,AX=001Ah
--------g-E0001A-----------------------------
INT E0 - PCROBOTS v1.41 - "L_ATAN" - GET ANGLE GIVEN SCALED TANGENT
	AX = 001Ah
	BX:CX = 100000*tangent of an angle
Return: AX = angle (-90 to +90 degrees)
SeeAlso: AX=0017h,AX=0018h,AX=0019h
--------g-E0001B-----------------------------
INT E0 - PCROBOTS v1.41 - "SQRT" - DETERMINE SQUARE ROOT OF A NUMBER 
	AX = 001Bh
	BX:CX = value
Return: BX:CX = square root
SeeAlso: AX=0017h
--------g-E0001C-----------------------------
INT E0 - PCROBOTS v1.41 - "SET_PATTERN" - SPECIFY ROBOT'S DISPLAY IMAGE
	AX = 001Ch
	BX:CX -> pattern array
Note:	the pattern array consists of five bytes, the low five bits of each
	  specifying the bit pattern for one line of the robot's screen display
--------g-E0001D-----------------------------
INT E0 - PCROBOTS v1.41 - "DEBUG_FLAG" - SET/CLEAR MARKERS NEXT TO ROBOT'S NAME
	AX = 001Dh
	BX = flag number (0 or 1)
	CX = new value (0 reset, 1 set)
Program: PCROBOTS is P.D. Smith's adaptation of Tom Poindexter's CROBOTS, in
	  which specially-written .COM or .EXE programs form robots battling
	  each other in a user-defined arena
Note:	the two flag markers may be used for any purpose, typically for
	  debugging to provide a visual display of progress
--------g-E0001E-----------------------------
INT E0 - PCROBOTS v1.41 - "BUY_ARMOUR" - BUY OR SELL ARMOR FOR ROBOT
	AX = 001Eh
	BX = number of armor units to buy (negative to sell)
Note:	each armor unit is worth 50 battery units; the robot's armor rating
	  will not go above its initial rating, so attempts to purchase more
	  will waste battery units
SeeAlso: AX=001Fh
--------g-E0001F-----------------------------
INT E0 - PCROBOTS v1.41 - "BUY_SHELLS" - BUY ADDITIONAL CANNON SHELLS
	AX = 001Fh
	BX = number of shells to buy
Note:	each shell costs ten battery units
SeeAlso: AX=001Eh,AX=0020h
--------g-E00020-----------------------------
INT E0 - PCROBOTS v1.41 - "SHELLS LEFT" - DETERMINE HOW MANY SHELLS ROBOT HAS
	AX = 0020h
Return: BX = number of shells remaining
SeeAlso: AX=001Fh
--------g-E00021-----------------------------
INT E0 - PCROBOTS v1.41 - "GET LOCAL MAP"
	AX = 0021h
	BX:CX -> 81-byte buffer for map
Return: buffer filled with 9x9 area of map centered on robot's position

(Table 2203)
Values for PCROBOTS map squares:
 2Eh '.' empty square
 44h 'D' damaging trap
 52h 'R' refueling point
 58h 'X' wall
--------g-E00022-----------------------------
INT E0 - PCROBOTS v1.41 - "INVISIBILITY" - CONTROL ROBOT'S INVISIBILITY DEVICE
	AX = 0022h
	BX = new state (0000h become visible, 0001h become invisible)
Notes:	this function has no effect if the robot is not capable of invisibility
	the robot can only stay invisible for 100 turns, after which it will
	  automatically become visible; it must also be remain visible for
	  as many turns as it was invisible before it can turn invisible
	  again
SeeAlso: AX=0024h,AX=0080h
--------g-E00023-----------------------------
INT E0 - PCROBOTS v1.41 - "GET_SHELL_STATUS" - FIND OUT WHAT HAPPENED TO SHELL
	AX = 0023h
Return: BX = status of last shell to land
	    0000h missed completely
	    0001h hit a wall
	    0002h hit a robot within 50-square radius
	    0003h hit a robot within 25-square radius
	    0004h hit a robot within 5-square radius
--------g-E00024-----------------------------
INT E0 - PCROBOTS v1.41 - "IS_INVISIBLE" - DETERMINE WHETHER ROBOT IS INVISIBLE
	AX = 0024h
Return: BX = visibility (0000h visible, 0001h invisible)
SeeAlso: AX=0022h,AX=0080h
--------g-E00025-----------------------------
INT E0 - PCROBOTS v1.41 - "L_ATAN2" - GET ARCTANGENT
	AX = 0025h
	BX = Y
	CX = X
Return: AX = angle (arctangent of Y/X)
--------g-E00026-----------------------------
INT E0 - PCROBOTS v1.41 - "GET_ROBOT_ID" - DETERMINE CURRENT ROBOT'S IDENTIFIER
	AX = 0026h
Return: AX = robot ID
--------g-E00027-----------------------------
INT E0 - PCROBOTS v1.41 - "REGISTER_IFF" - REGISTER FRIEND/FOE IDENT STRING
	AX = 0027h
	BX:CX = ASCIZ IFF string
Note:	the IFF string may only be set once
SeeAlso: AX=0028h,AX=0029h
--------g-E00028-----------------------------
INT E0 - PCROBOTS v1.41 - "CHECK_IFF" - QUERY FRIEND/FOE IDENTIFICATION STRING
	AX = 0028h
	BX = robot ID to test
Return: AX = status
	    0000h IFF strings match
	    0001h IFF strings differ or invalid robot ID
SeeAlso: AX=0027h
--------g-E00029-----------------------------
INT E0 - PCROBOTS v1.41 - "REGISTER_NAME" - SPECIFY ROBOT'S NAME
	AX = 0029h
	BX:CX -> ASCIZ name string
Note:	the name may only be set once
SeeAlso: AX=0027h,AX=002Ah
--------g-E0002A-----------------------------
INT E0 - PCROBOTS v1.41 - "FIND_NAME" - SEARCH FOR ROBOT WITH GIVEN NAME
	AX = 002Ah
	BX:CX -> ASCIZ name string
	DX = first ID to check
Return: AX = robot ID or FFFFh if no robot with specified name
SeeAlso: AX=0028h,AX=0029h,AX=002Bh
--------g-E0002B-----------------------------
INT E0 - PCROBOTS v1.41 - "GET_TEAM_ID" - DETERMINE TEAM MEMBERSHIP OF ROBOT
	AX = 002Bh
Return: AX = team ID (0-2) or FFFFh if 'loner'
SeeAlso: AX=0029h
--------g-E0002C-----------------------------
INT E0 - PCROBOTS v1.41 - "GET_ASHELL_STATUS" - FIND OUT WHAT HAPPENED TO SHELL
	AX = 002Ch
	BX = shell ID
Return: AX = status
	    0000h missed completely
	    0001h hit a wall
	    0002h hit a robot within a 50-square radius
	    0003h hit a robot within a 25-square radius
	    0004h hit a robot within a 5-square radius
	    0005h shell not known (too old or not yet fired)
	    0006h shell still in flight
SeeAlso: AX=0003h
--------g-E0002D-----------------------------
INT E0 - PCROBOTS v1.41 - "REGISTER_X" - SELECT AUTOMATIC X POSITION UPDATES
	AX = 002Dh
	BX:CX -> X word variable
Return: AX = status (0001h OK, 0000h problem with address)
Note:	after this call, PCROBOTS will automatically update the specified
	  word whenever the robot moves
SeeAlso: AX=002Eh
--------g-E0002E-----------------------------
INT E0 - PCROBOTS v1.41 - "REGISTER_Y" - SELECT AUTOMATIC Y POSITION UPDATES
	AX = 002Eh
	BX:CX -> Y word variable
Return: AX = status (0001h OK, 0000h problem with address)
Note:	after this call, PCROBOTS will automatically update the specified
	  word whenever the robot moves
SeeAlso: AX=002Dh
--------g-E00080-----------------------------
INT E0 - PCROBOTS v1.41 - "CONFIGURE" - CUSTOMIZE ROBOT
	AX = 0080h
	BX = basic configuration (see #2204)
	CX = advanced configuration (see #2205)
Return: AX = status (0001h OK, 0000h not first call in program)
Program: PCROBOTS is P.D. Smith's adaptation of Tom Poindexter's CROBOTS, in
	  which specially-written .COM or .EXE programs form robots battling
	  each other in a user-defined arena
Notes:	a maximum of ten points may be allocated to the robot; if you attempt
	  to allocate more, some items will be given a value of zero.  If this
	  function is not called, each attribute is set to the default value
	  of 2.
	if the invisibility option is chosen, the robot will start with only
	  900 cannon shells instead of the default 1000

Bitfields for PCROBOTS basic configuration:
Bit(s)	Description	(Table 2204)
 0-3	maximum speed (0-4 = 50,75,100,150,200)
 4-7	maneuverability (0-4 = 20%,35%,50%,75%,100%)
 8-11	cannon range (0-4 = 300,500,700,1000,1500)
 12-15	robot armor (0-4 = 50,75,100,150,200)

Bitfields for PCROBOTS advanced configuration:
Bit(s)	Description	(Table 2205)
 0-2	robot acceleration (0-4 = 5,7,10,15,20)
 3	capable of invisibility
--------r-E1---------------------------------
INT E1 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-E1---------------------------------
INT E1 - PC Cluster Disk Server Information (NOT A VECTOR!)
Desc:	points at a data table
SeeAlso: INT E2
--------r-E2---------------------------------
INT E2 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-E2---------------------------------
INT E2 - PC Cluster Program - RELOCATED INT 1C
SeeAlso: INT 1C
--------r-E3---------------------------------
INT E3 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-E40005-----------------------------
INT E4 - Logitech Modula v2.0 - MonitorEntry
	AX = 0005h
	BX = priority
SeeAlso: AX=0006h
--------r-E40006-----------------------------
INT E4 - Logitech Modula v2.0 - MonitorExit
	AX = 0006h
SeeAlso: AX=0005h
--------r-E4---------------------------------
INT E4 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-E5---------------------------------
INT E5 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-E6---------------------------------
INT E6 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-E7---------------------------------
INT E7 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-E8---------------------------------
INT E8 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-E9---------------------------------
INT E9 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-EA---------------------------------
INT EA - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-EB---------------------------------
INT EB - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-EC---------------------------------
INT EC - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-EC---------------------------------
INT EC - used by Alloy NTNX
--------r-EC---------------------------------
INT EC - Exact - RUNTIME INTERFACE MULTIPLEXOR
	AX = function number (0000h to 0140h)
	STACK:	DWORD address to return to
		any arguments required by function
Return: STACK:	return address popped, but otherwise unchanged
Desc:	this is the interface from applications to the runtime system by Exact
	  Automatisering B.V. of the Netherlands.  By using this interrupt,
	  it can provide DLL-style capabilities under MS-DOS.
Note:	the interrupt handler removes the return address and flags placed on
	  the stack by the INT EC, then jumps to the appropriate function
--------r-ED---------------------------------
INT ED - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
	INT 80 through INT ED are modified but not restored by Direct Access
	  v4.0, and may be left dangling by other programs written with the
	  same version of compiled BASIC
SeeAlso: INT EC"BASIC",INT EE"BASIC"
--------r-EE---------------------------------
INT EE - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT ED"BASIC",INT EE"BASIC"
--------r-EF---------------------------------
INT EF - BASIC - ORIGINAL INT 09 VECTOR
Note:	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT EE"BASIC",INT F0"BASIC"
--------O-EF----CX0473-----------------------
INT EF - GEM - INTERFACE
	CX = 0473h
	DS:DX -> GEM parameter block
--------r-F0---------------------------------
INT F0 - BASICA.COM, GWBASIC, compiled BASIC - ORIGINAL INT 08 VECTOR
Note:	BASICA.COM does not restore vector on termination
SeeAlso: INT EF"BASIC"
--------*-F1---------------------------------
INT F1 - reserved for user interrupt
--------s-F1---------------------------------
INT F1 - SPEECH.COM - CONVERT TEXT STRING TO SPEECH
	DS:BX -> '$'-terminated text string
Program: SPEECH.COM is a resident text-to-speech converter by Douglas Sisco
--------s-F1---------------------------------
INT F1 - Andy C. McGuire SPEECH.COM/SAY.COM
SeeAlso: INT F2"SPEECH"
--------U-F1---------------------------------
INT F1 - AQUEDUCT, PIPELINE - GET DATA AREA ADDRESS
Return: AX:BX -> data area
Program: AQUEDUCT and PIPELINE are TSRs by James W. Birdsall to connect COM1
	  and COM2 in software
Note:	The installation check consists of testing for the following signature
	  immediately preceding the interrupt handler: "JWBtvv" where 't' is
	  either "A" for AQUEDUCT or "P" for PIPELINE and "vv" is a two-digit
	  version number
Index:	installation check;AQUEDUCT|installation check;PIPELINE
--------N-F1---------------------------------
INT F1 - NetWare Remote Boot - INSTALLATION CHECK (NOT A VECTOR!)
Note:	if this vector contains the value 5774654Eh ("NetW"), the remote boot
	  BIOS extension is active, and access to the floppy disk is redirected
	  to an image file in the server's SYS:LOGIN directory
--------v-F1---------------------------------
INT F1 - VIRUS - "Violetta" - ???
Note:	used but not chained by virus
SeeAlso: INT E0"VIRUS",INT FF"VIRUS"
--------*-F2---------------------------------
INT F2 - reserved for user interrupt
--------s-F2---------------------------------
INT F2 - Andy C. McGuire SPEECH.COM/SAY.COM
SeeAlso: INT F1"SPEECH"
----------F2---------------------------------
INT F2 - ICCTSR 1.0 - ImageCapture COLOR Developer's Kit - API
	AH = function number (see #2206)
	???
Return: ???
Program: ImageCapture is a product of International Computers
SeeAlso: INT F3"ICCTSR"

(Table 2206)
Values for ImageCapture function:
 01h	power up
 02h	power down
 03h	set controls
 04h	capture image
 05h	display image
 06h	read file
 07h	write file
 08h	write array
 09h	read pixel
 0Ah	write pixel
 0Bh	check if VGA present
 0Ch	set video mode
 0Dh	check for keystroke
 0Eh	delay
--------*-F3---------------------------------
INT F3 - reserved for user interrupt
--------s-F3---------------------------------
INT F3 - SoundBlaster - POINTER TO ECHO VALUE
Note:	this is not a vector, but a pointer to a DWORD containing the echo
	  value selected with SET-ECHO.EXE
SeeAlso: INT 2F/AX=FBFBh
----------F3---------------------------------
INT F3 - ICCTSR 1.0 - HANDSHAKE ID VECTOR
Program: ImageCapture is a product of International Computers
SeeAlso: INT F2"ICCTSR"
--------*-F4---------------------------------
INT F4 - reserved for user interrupt
--------T-F4---------------------------------
INT F4 - DoubleDOS - GIVE UP REST OF CURRENT CLOCK TICK AND ALL OF NEXT TICK
SeeAlso: INT 21/AH=EEh"DoubleDOS",INT FE"DoubleDOS"
--------*-F5---------------------------------
INT F5 - reserved for user interrupt
--------T-F5---------------------------------
INT F5 - DoubleDOS - ???
--------*-F6---------------------------------
INT F6 - reserved for user interrupt
--------T-F6---------------------------------
INT F6 - DoubleDOS - ???
--------*-F7---------------------------------
INT F7 - reserved for user interrupt
--------T-F7---------------------------------
INT F7 - DoubleDOS - ???
----------F700-------------------------------
INT F7 - FSBBS 2.0 - CONFIGURATION RECORD
	AH = 00h
	AL = function
	    00h get configuration record
		Return: DS:DX -> configuration record
	    01h set configuration record
	    02h get path for option
		DS:DX -> option name
		Return: DS:DX -> path
	    03h determine whether configuration record set
		Return: AX = status
			    0000h set
			    0001h not yet set
	    04h get link state
		Return: AX = state
			    0000h unlinked
			    0001h linked
Notes:	this information is preliminary and still subject to change
	all of the INT F7 calls for FSBBS are used for interprogram
	  communication between the BBS kernel and the programs it spawns
SeeAlso: AH=01h
----------F701-------------------------------
INT F7 - FSBBS 2.0 - USER RECORD
	AH = 01h
	AL = function
	    00h get user record for user currently online
		Return: DS:DX -> user record
	    01h set user record
		DS:DX -> user record
SeeAlso: AH=00h,AH=02h
----------F702-------------------------------
INT F7 - FSBBS 2.0 - GET ACCOUNT NAME
	AH = 02h
Return: DS:DX -> 8-character blank-padded account name
SeeAlso: AH=01h
----------F703-------------------------------
INT F7 - FSBBS 2.0 - TERMINAL NUMBER
	AH = 03h
	AL = function
	    00h get terminal index number
		Return: DX = index number
	    01h set terminal index number
		DX = terminal index
----------F704-------------------------------
INT F7 - FSBBS 2.0 - PASSDATA BUFFER
	AH = 04h
	AL = function
	    00h get PassData buffer contents
		DS:DX -> buffer for PassData contents
	    01h set PassData contents
		DS:DX -> buffer containing new PassData
		CH = length of data in buffer
----------F705-------------------------------
INT F7 - FSBBS 2.0 - TIMER FUNCTIONS
	AH = 05h
	AL = function
	    00h get time remaining
		Return: DX = number of minutes remaining
	    01h get current time
		Return: DS:DX -> 8-character time string
	    02h increment time
		DX = number of additional minutes
	    03h decrement time
		DX = number of minutes
SeeAlso: AH=06h
----------F706-------------------------------
INT F7 - FSBBS 2.0 - FUNCTION AVAILABILITY
	AH = 06h
	AL = function
	    00h determine whether function is available
		DX = index of function
	    01h set function availability
		DX = index of function
		???
SeeAlso: AH=05h,AH=07h
----------F707-------------------------------
INT F7 - FSBBS 2.0 - DUMP FUNCTIONS
	AH = 07h
	AL = function
	    00h get current dump mode
		Return: DL = mode
	    01h set dump mode
		DL = mode
SeeAlso: AH=06h
--------*-F8---------------------------------
INT F8 - reserved for user interrupt
--------h-F8---------------------------------
INT F8 - TANDY??? - 100 HZ INTERRUPT
Note:	this vector is not used on the Tandy 1000TL
SeeAlso: INT FA"USART"
--------T-F8---------------------------------
INT F8 - DoubleDOS - ???
--------*-F9---------------------------------
INT F9 - reserved for user interrupt
--------T-F9---------------------------------
INT F9 - DoubleDOS - ???
--------*-FA---------------------------------
INT FA - reserved for user interrupt
--------h-FA---------------------------------
INT FA - TANDY??? - SERIAL PORT USART INTERRUPT
Note:	this vector is not used on the Tandy 1000TL
SeeAlso: INT F8"100 HZ",INT FB"USART"
--------T-FA---------------------------------
INT FA - DoubleDOS - TURN OFF TIMESHARING
SeeAlso: INT 21/AH=EAh"DoubleDOS",INT FB"DoubleDOS"
--------*-FB---------------------------------
INT FB - reserved for user interrupt
--------h-FB---------------------------------
INT FB - TANDY??? - KEYBOARD USART RECEIVE INTERRUPT
SeeAlso: INT FA"USART"
--------T-FB---------------------------------
INT FB - DoubleDOS - TURN ON TIMESHARING
SeeAlso: INT 21/AH=EBh"DoubleDOS",INT FA"DoubleDOS"
--------*-FC---------------------------------
INT FC - reserved for user interrupt
--------T-FC---------------------------------
INT FC - DoubleDOS - GET CURRENT SCREEN BUFFER ADDRESS
Return: ES = segment of display buffer
Desc:	determine the address of the virtual screen to which the program
	  should write instead of the actual video memory, so that the
	  multitasked programs do not interfere with each other's output
Note:	the display buffer may be moved if multitasking is enabled
SeeAlso: INT 21/AH=ECh"DoubleDOS",INT FB"DoubleDOS"
--------*-FD---------------------------------
INT FD - reserved for user interrupt
--------T-FD---------------------------------
INT FD - DoubleDOS - ???
--------S-FD---------------------------------
INT FD - TFPCX - INSTALLATION CHECK
	AH = function (see separate entries below)
Program: TFPCX is an interface between modem and terminal program for packet-
	  radio communications
Notes:	the installation check consists of testing for the string "N5NX" three
	  bytes beyond the interrupt handler; INT FD is the default, but may
	  be changed, so the full installation check consists of scanning
	  for the signature
	TFPCX returns AX=FFFFh on any unsupported function call
SeeAlso: AH=01h,AH=03h,AH=FEh
--------S-FD01-------------------------------
INT FD - TFPCX - TEST FOR CHARACTER WAITING
	AH = 01h
Return: AX = status
	    0000h no characters waiting
	    0001h character available for input
Program: TFPCX is an interface between modem and terminal program for packet-
	  radio communications
SeeAlso: AH=02h
--------S-FD02-------------------------------
INT FD - TFPCX - GET CHARACTER
	AH = 02h
Return: AL = character
Notes:	this call is only allowed if AH=01h indicated that a character is
	  available
	all available characters should be read before sending any additional
	  characters
SeeAlso: AH=01h,AH=03h
--------S-FD03-------------------------------
INT FD - TFPCX - OUTPUT CHARACTER
	AH = 03h
	AL = character to send
SeeAlso: AH=02h
--------S-FDFE-------------------------------
INT FD - TFPCX - GET VERSION
	AH = FEh
Return: AH = major version
	AL = minor version
Program: TFPCX is an interface between modem and terminal program for packet-
	  radio communications
SeeAlso: AH=01h,AH=03h
--------B-FE---------------------------------
INT FE - AT/XT286/PS50+ - destroyed by return from protected mode
Note:	the ROM BIOS uses 0030h:0100h as the initial stack on startup, which
	  is the last fourth of the interrupt vector table.  If the processor
	  is returned to real mode via a hardware reset (the only possibility
	  on an 80286, though there are a number of ways of generating one),
	  then the BIOS startup code stacks three words on its scratch stack
	  before determining that a return to real mode has been requested.
	  As a result, INT FE and INT FF are corrupted.
SeeAlso: INT FF"XT286"
--------T-FE---------------------------------
INT FE - DoubleDOS - GIVE UP TIME
	AL = number of 55ms time slices to give away
Return: after other program (if active) has run
SeeAlso: INT 21/AH=EEh"DoubleDOS",INT F4"DoubleDOS"
--------G-FE---------------------------------
INT FE - Turbo Debugger 8086 v2.5+ - OVERLAY MANAGER
SeeAlso: INT 3F
--------B-FF---------------------------------
INT FF - AT/XT286/PS50+ - destroyed by return from protected mode
Note:	(see INT FE"XT286")
SeeAlso: INT FE"XT286"
--------b-FF---------------------------------
INT FF - Z100 - WARM BOOT
SeeAlso: INT 40"Z100"
--------Q-FF---------------------------------
INT FF U - QEMM-386.SYS v6.0+ - internal
Notes:	requires that a byte in the conventional-memory stub be set to the
	  desired function number (00h through 0Ch)

(Table 2207)
Values for QEMM internal functions:
 00h	reflect back to Virtual86-mode interrupt handler (default)
 01h	???
 02h	access DR7???
 03h	QPI upcall (see INT 67/AH=3Fh)
 04h	???
 05h	???
 06h	INT 15/AH=87h
 07h	EMS services (see INT 67/AH=40h-5Dh)
 08h	???
 09h	QEMM exception handler
 0Ah	XMS services (see INT 2F/AX=4310h)
 0Bh	Virtual DMA Services (see INT 4B/AX=8102h)
 0Ch	???
--------v-FF---------------------------------
INT FF - VIRUS - "Violetta" - ???
Note:	used but not chained by virus
SeeAlso: INT E0"VIRUS",INT F1"VIRUS"
--------!---Admin----------------------------
Highest Table Number = 2214
--------!---FILELIST-------------------------
Please redistribute all of the files comprising the interrupt list (listed at
the beginning of the list and in INTERRUP.1ST) unmodified as a group, in a
trio of archives named INTER42A through INTER42C (preferably the original
authenticated PKZIP archives), and the utility programs in a fourth archive
called INTER42D.ZIP

This compilation is Copyright (c) 1989,1990,1991,1992,1993,1994 Ralf Brown
--------!---CONTACT_INFO---------------------
Internet: ralf@telerama.lm.com
UUCP: {uunet,harvard}!telerama.lm.com!ralf
FIDO: Ralf Brown 1:129/26.1
	or post a message to me in the DR_DEBUG echo (I probably won't see it
	unless you address it to me)
CIS:  >INTERNET:ralf@telerama.lm.com
