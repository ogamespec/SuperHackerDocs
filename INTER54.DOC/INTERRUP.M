Interrupt List, part 13 of 16
Copyright (c) 1989,1990,1991,1992,1993,1994,1995,1996,1997 Ralf Brown
--------M-330000-----------------------------
INT 33 - MS MOUSE - RESET DRIVER AND READ STATUS
	AX = 0000h
Return: AX = status
	    0000h hardware/driver not installed
	    FFFFh hardware/driver installed
	BX = number of buttons
	    0000h other than two
	    0002h two buttons (many drivers)
	    0003h Mouse Systems/Logitech three-button mouse
	    FFFFh two buttons
Notes:	to use mouse on a Hercules-compatible monographics card in graphics
	  mode, you must first set 0040h:0049h to 6 for page 0 or 5 for page 1,
	  and then call this function.	Logitech drivers v5.01 and v6.00
	  reportedly do not correctly use Hercules graphics in dual-monitor
	  systems, while version 4.10 does.
	the Logitech mouse driver contains the signature string "LOGITECH"
	  three bytes past the interrupt handler; many of the Logitech mouse
	  utilities check for this signature.
	Logitech MouseWare v6.30 reportedly does not support CGA video modes
	  if no CGA is present when it is started and the video board is
	  later switched into CGA emulation
SeeAlso: AX=0011h,AX=0021h,AX=002Fh,INT 62/AX=007Ah,INT 74
--------M-330001-----------------------------
INT 33 - MS MOUSE v1.0+ - SHOW MOUSE CURSOR
	AX = 0001h
SeeAlso: AX=0002h,INT 16/AX=FFFEh,INT 62/AX=007Bh,INT 6F/AH=06h"F_TRACK_ON"
--------M-330002-----------------------------
INT 33 - MS MOUSE v1.0+ - HIDE MOUSE CURSOR
	AX = 0002h
Note:	multiple calls to hide the cursor will require multiple calls to
	  function 01h to unhide it.
SeeAlso: AX=0001h,AX=0010h,INT 16/AX=FFFFh,INT 62/AX=007Bh
SeeAlso: INT 6F/AH=08h"F_TRACK_OFF"
--------M-330003-----------------------------
INT 33 - MS MOUSE v1.0+ - RETURN POSITION AND BUTTON STATUS
	AX = 0003h
Return: BX = button status (see #2800)
	CX = column
	DX = row
Note:	in text modes, all coordinates are specified as multiples of the cell
	  size, typically 8x8 pixels
SeeAlso: AX=0004h,AX=000Bh,INT 2F/AX=D000h"ZWmous"

Bitfields for mouse button status:
Bit(s)	Description	(Table 2800)
 0	left button pressed if 1
 1	right button pressed if 1
 2	middle button pressed if 1 (Mouse Systems/Logitech/Genius)
--------M-330004-----------------------------
INT 33 - MS MOUSE v1.0+ - POSITION MOUSE CURSOR
	AX = 0004h
	CX = column
	DX = row
Note:	the row and column are truncated to the next lower multiple of the cell
	  size (typically 8x8 in text modes); however, some versions of the
	  Microsoft documentation incorrectly state that the coordinates are
	  rounded
SeeAlso: AX=0003h,INT 62/AX=0081h,INT 6F/AH=10h"F_PUT_SPRITE"
--------M-330005-----------------------------
INT 33 - MS MOUSE v1.0+ - RETURN BUTTON PRESS DATA
	AX = 0005h
	BX = button number (see #2801)
Return: AX = button states (see #2800)
	BX = number of times specified button has been pressed since last call
	CX = column at time specified button was last pressed
	DX = row at time specified button was last pressed
Note:	at least for the Genius mouse driver, the number of button presses
	  returned is limited to 7FFFh
SeeAlso: AX=0006h,INT 62/AX=007Ch

(Table 2801)
Values for mouse button number:
 0000h	left
 0001h	right
 0002h	middle (Mouse Systems/Logitech/Genius mouse)
--------M-330006-----------------------------
INT 33 - MS MOUSE v1.0+ - RETURN BUTTON RELEASE DATA
	AX = 0006h
	BX = button number (see #2801)
Return: AX = button states (see #2800)
	BX = number of times specified button has been released since last call
	CX = column at time specified button was last released
	DX = row at time specified button was last released
Note:	at least for the Genius mouse driver, the number of button releases
	  returned is limited to 7FFFh
SeeAlso: AX=0005h,INT 62/AX=007Ch
--------M-330007-----------------------------
INT 33 - MS MOUSE v1.0+ - DEFINE HORIZONTAL CURSOR RANGE
	AX = 0007h
	CX = minimum column
	DX = maximum column
Note:	in text modes, the minimum and maximum columns are truncated to the
	  next lower multiple of the cell size, typically 8x8 pixels
SeeAlso: AX=0008h,AX=0010h,AX=0031h,INT 62/AX=0080h
SeeAlso: INT 6F/AH=0Ch"F_SET_LIMITS_X"
--------M-330008-----------------------------
INT 33 - MS MOUSE v1.0+ - DEFINE VERTICAL CURSOR RANGE
	AX = 0008h
	CX = minimum row
	DX = maximum row
Note:	in text modes, the minimum and maximum rows are truncated to the
	  next lower multiple of the cell size, typically 8x8 pixels
SeeAlso: AX=0007h,AX=0010h,AX=0031h,INT 62/AX=0080h
SeeAlso: INT 6F/AH=0Eh"F_SET_LIMITS_Y"
--------M-330009-----------------------------
INT 33 - MS MOUSE v3.0+ - DEFINE GRAPHICS CURSOR
	AX = 0009h
	BX = column of cursor hot spot in bitmap (-16 to 16)
	CX = row of cursor hot spot (-16 to 16)
	ES:DX -> mask bitmap (see #2802)
Notes:	in graphics modes, the screen contents around the current mouse cursor
	  position are ANDed with the screen mask and then XORed with the
	  cursor mask
	the Microsoft mouse driver v7.04 and v8.20 uses only BL and CL, so the
	  hot spot row/column should be limited to -128..127
	Microsoft KnowledgeBase article Q19850 states that the high bit is
	  right-most, but that statement is contradicted by all other available
	  documentation
SeeAlso: AX=000Ah,AX=0012h,AX=002Ah,INT 62/AX=007Fh,INT 6F/AH=0Ah"F_DEF_MASKS"

Format of mouse mask bitmap:
Offset	Size	Description	(Table 2802)
 00h 16 WORDs	screen mask
 10h 16 WORDs	cursor mask
Note:	each word defines the sixteen pixels of a row, low bit rightmost
--------M-33000A-----------------------------
INT 33 - MS MOUSE v3.0+ - DEFINE TEXT CURSOR
	AX = 000Ah
	BX = hardware/software text cursor
	    0000h software
		CX = screen mask
		DX = cursor mask
	    0001h hardware
		CX = start scan line
		DX = end scan line
Note:	when the software cursor is selected, the character/attribute data at
	  the current screen position is ANDed with the screen mask and then
	  XORed with the cursor mask
SeeAlso: AX=0009h,INT 62/AX=007Eh
--------M-33000B-----------------------------
INT 33 - MS MOUSE v1.0+ - READ MOTION COUNTERS
	AX = 000Bh
Return: CX = number of mickeys mouse moved horizontally since last call
	DX = number of mickeys mouse moved vertically
Notes:	a mickey is the smallest increment the mouse can sense
	positive values indicate down/right
SeeAlso: AX=0003h,AX=001Bh,AX=0027h
--------M-33000C-----------------------------
INT 33 - MS MOUSE v1.0+ - DEFINE INTERRUPT SUBROUTINE PARAMETERS
	AX = 000Ch
	CX = call mask (see #2803)
	ES:DX -> FAR routine (see #2804)
SeeAlso: AX=0018h

Bitfields for mouse call mask:
Bit(s)	Description	(Table 2803)
 0	call if mouse moves
 1	call if left button pressed
 2	call if left button released
 3	call if right button pressed
 4	call if right button released
 5	call if middle button pressed (Mouse Systems/Logitech/Genius mouse)
 6	call if middle button released (Mouse Systems/Logitech/Genius mouse)
 7-15	unused
Note:	some versions of the Microsoft documentation incorrectly state that CX
	  bit 0 means call if mouse cursor moves

(Table 2804)
Values interrupt routine is called with:
	AX = condition mask (same bit assignments as call mask)
	BX = button state
	CX = cursor column
	DX = cursor row
	SI = horizontal mickey count
	DI = vertical mickey count
Notes:	some versions of the Microsoft documentation erroneously swap the
	  meanings of SI and DI
	in text modes, the row and column will be reported as a multiple of
	  the character cell size, typically 8x8 pixels
--------M-33000D-----------------------------
INT 33 - MS MOUSE v1.0+ - LIGHT PEN EMULATION ON
	AX = 000Dh
SeeAlso: AX=000Eh,INT 10/AH=04h
--------M-33000E-----------------------------
INT 33 - MS MOUSE v1.0+ - LIGHT PEN EMULATION OFF
	AX = 000Eh
SeeAlso: AX=000Dh
--------M-33000F-----------------------------
INT 33 - MS MOUSE v1.0+ - DEFINE MICKEY/PIXEL RATIO
	AX = 000Fh
	CX = number of mickeys per 8 pixels horizontally (default 8)
	DX = number of mickeys per 8 pixels vertically (default 16)
SeeAlso: AX=0013h,AX=001Ah,INT 62/AX=0082h
--------M-330010-----------------------------
INT 33 - MS MOUSE v1.0+ - DEFINE SCREEN REGION FOR UPDATING
	AX = 0010h
	CX,DX = X,Y coordinates of upper left corner
	SI,DI = X,Y coordinates of lower right corner
Note:	mouse cursor is hidden in the specified region, and needs to be
	  explicitly turned on again
SeeAlso: AX=0001h,AX=0002h,AX=0007h,AX=0010h"Genius MOUSE",AX=0031h
--------M-330010-----------------------------
INT 33 - Genius MOUSE - DEFINE SCREEN REGION FOR UPDATING
	AX = 0010h
	ES:DX -> update region list (see #2805)
Notes:	mouse cursor is hidden in the specified region, and needs to be
	  explicitly turned on again
	this version of the call is described in an August 1988 version of the
	  Genius Mouse programmer's reference; it has been changed to conform
	  to the Microsoft version shown above by version 9.06 (and possibly
	  earlier versions)
SeeAlso: AX=0001h,AX=0002h,AX=0007h,AX=0010h"MS MOUSE"

Format of Genius Mouse update region list:
Offset	Size	Description	(Table 2805)
 00h	WORD	left-most column
 02h	WORD	top-most row
 04h	WORD	right-most column
 06h	WORD	bottom-most row
--------M-330011-----------------------------
INT 33 - Genius Mouse 9.06 - GET NUMBER OF BUTTONS
	AX = 0011h
Return: AX = FFFFh
	BX = number of buttons
SeeAlso: AX=0000h
--------M-330012-----------------------------
INT 33 - MS MOUSE - SET LARGE GRAPHICS CURSOR BLOCK
	AX = 0012h
	BH = cursor width in words
	CH = rows in cursor
	BL = horizontal hot spot (-16 to 16)
	CL = vertical hot spot (-16 to 16)
	ES:DX -> bit map of screen and cursor maps
Return: AX = FFFFh if successful
SeeAlso: AX=0009h,AX=002Ah,AX=0035h
--------M-330013-----------------------------
INT 33 - MS MOUSE v5.0+ - DEFINE DOUBLE-SPEED THRESHOLD
	AX = 0013h
	DX = threshold speed in mickeys/second, 0000h = default of 64/second
Note:	if speed exceeds threshold, the cursor's on-screen motion is doubled
SeeAlso: AX=000Fh,AX=001Bh,AX=002Ch
--------M-330014-----------------------------
INT 33 - MS MOUSE v3.0+ - EXCHANGE INTERRUPT SUBROUTINES
	AX = 0014h
	CX = call mask (see #2803)
	ES:DX -> FAR routine
Return: CX = call mask of previous interrupt routine
	ES:DX = FAR address of previous interrupt routine
SeeAlso: AX=000Ch,AX=0018h
--------M-330015-----------------------------
INT 33 - MS MOUSE v6.0+ - RETURN DRIVER STORAGE REQUIREMENTS
	AX = 0015h
Return: BX = size of buffer needed to store driver state
SeeAlso: AX=0016h,AX=0017h,AX=0042h
--------M-330016-----------------------------
INT 33 - MS MOUSE v6.0+ - SAVE DRIVER STATE
	AX = 0016h
	BX = size of buffer (see AX=0015h)
	ES:DX -> buffer for driver state
Note:	although not documented (since the Microsoft driver does not use it),
	  many drivers appear to require BX on input
SeeAlso: AX=0015h,AX=0017h
--------M-330017-----------------------------
INT 33 - MS MOUSE v6.0+ - RESTORE DRIVER STATE
	AX = 0017h
	BX = size of buffer (see AX=0015h)
	ES:DX -> buffer containing saved state
Notes:	although not documented (since the Microsoft driver does not use it),
	  many drivers appear to require BX on input
	some mouse drivers range-check the values in the saved state based on
	  the current video mode; thus, the video mode should be restored
	  before the mouse driver's state is restored
SeeAlso: AX=0015h,AX=0016h
--------M-330018-----------------------------
INT 33 - MS MOUSE v6.0+ - SET ALTERNATE MOUSE USER HANDLER
	AX = 0018h
	CX = call mask (see #2806)
	ES:DX -> FAR routine to be invoked on mouse events (see #2807)
Return: AX = status
	    0018h if successful
	    FFFFh on error
Notes:	up to three handlers can be defined by separate calls to this function,
	  each with a different combination of shift states in the call mask;
	  calling this function again with a call mask of 0000h undefines the
	  specified handler (official documentation); specifying the same
	  call mask and an address of 0000h:0000h undefines the handler (real
	  life)
	some versions of the documentation erroneously reverse the order of
	  the bits in the call mask
SeeAlso: AX=000Ch,AX=0014h,AX=0019h

Bitfields for mouse call mask:
Bit(s)	Description	(Table 2806)
 0	call if mouse moves
 1	call if left button pressed
 2	call if left button released
 3	call if right button pressed
 4	call if right button released
 5	call if shift button pressed during event
 6	call if ctrl key pressed during event
 7	call if alt key pressed during event
Note:	at least one of 5-7 must be set

(Table 2807)
Values user handler is called with:
	AX = condition mask (same bit assignments as call mask)
	BX = button state
	CX = cursor column
	DX = cursor row
	SI = horizontal mickey count
	DI = vertical mickey count
Return: registers preserved
Note:	in text modes, the row and column will be reported as a multiple of
	  the cell size, typically 8x8 pixels
--------M-330019-----------------------------
INT 33 - MS MOUSE v6.0+ - RETURN USER ALTERNATE INTERRUPT VECTOR
	AX = 0019h
	CX = call mask (see #2806)
Return: BX:DX = user interrupt vector
	CX = call mask (0000h if not found)
Note:	attempts to find a user event handler (defined by function 18h)
	  whose call mask matches CX
SeeAlso: AX=0018h
--------M-33001A-----------------------------
INT 33 - MS MOUSE v6.0+ - SET MOUSE SENSITIVITY
	AX = 001Ah
	BX = horizontal speed \
	CX = vertical speed   / (see AX=000Fh)
	DX = double speed threshold (see AX=0013h)
SeeAlso: AX=0013h,AX=001Bh,INT 62/AX=0082h
--------M-33001B-----------------------------
INT 33 - MS MOUSE v6.0+ - RETURN MOUSE SENSITIVITY
	AX = 001Bh
Return: BX = horizontal speed
	CX = vertical speed
	DX = double speed threshold
SeeAlso: AX=000Bh,AX=001Ah
--------M-33001C-----------------------------
INT 33 - MS MOUSE v6.0+ - SET INTERRUPT RATE
	AX = 001Ch
	BX = rate (see #2808)
Notes:	only available on InPort mouse
	values greater than 4 may cause unpredictable driver behavior

(Table 2808)
Values for mouse interrupt rate:
 00h	no interrupts allowed
 01h	30 per second
 02h	50 per second
 03h	100 per second
 04h	200 per second
--------M-33001D-----------------------------
INT 33 - MS MOUSE v6.0+ - DEFINE DISPLAY PAGE NUMBER
	AX = 001Dh
	BX = display page number
Note:	the cursor will be displayed on the specified page
SeeAlso: AX=001Eh
--------M-33001E-----------------------------
INT 33 - MS MOUSE v6.0+ - RETURN DISPLAY PAGE NUMBER
	AX = 001Eh
Return: BX = display page number
SeeAlso: AX=001Dh
--------M-33001F-----------------------------
INT 33 - MS MOUSE v6.0+ - DISABLE MOUSE DRIVER
	AX = 001Fh
Return: AX = status
	    001Fh successful
		ES:BX = INT 33 vector before mouse driver was first installed
	    FFFFh unsuccessful
Notes:	restores vectors for INT 10 and INT 71 (8086) or INT 74 (286/386)
	if you restore INT 33 to ES:BX, driver will be completely disabled
	many drivers return AX=001Fh even though the driver has been disabled
SeeAlso: AX=0020h
--------M-330020-----------------------------
INT 33 - MS MOUSE v6.0+ - ENABLE MOUSE DRIVER
	AX = 0020h
Return: AX = status
	    0020h successful
	    FFFFh unsuccessful
Notes:	restores vectors for INT 10h and INT 71h (8086) or INT 74h (286/386)
	  which were removed by function 1Fh
	Microsoft's documentation states that no value is returned
SeeAlso: AX=001Fh
--------M-330021-----------------------------
INT 33 - MS MOUSE v6.0+ - SOFTWARE RESET
	AX = 0021h
Return: AX = status
	    FFFFh if mouse driver installed
		BX = number of buttons (FFFFh = two buttons)
	    0021h if mouse driver not installed
Note:	this call is identical to funtion 00h, but does not reset the mouse
SeeAlso: AX=0000h
--------M-330022-----------------------------
INT 33 - MS MOUSE v6.0+ - SET LANGUAGE FOR MESSAGES
	AX = 0022h
	BX = language (see #2809)
Note:	only available on international versions of the driver; US versions
	  ignore this call
SeeAlso: AX=0023h

(Table 2809)
Values for mouse driver language:
 00h	English
 01h	French
 02h	Dutch
 03h	German
 04h	Swedish
 05h	Finnish
 06h	Spanish
 07h	Portugese
 08h	Italian
--------M-330023-----------------------------
INT 33 - MS MOUSE v6.0+ - GET LANGUAGE FOR MESSAGES
	AX = 0023h
Return: BX = language (see #2809)
Note:	the US version of the driver always returns zero
SeeAlso: AX=0022h
--------M-330024-----------------------------
INT 33 - MS MOUSE v6.26+ - GET SOFTWARE VERSION, MOUSE TYPE, AND IRQ NUMBER
	AX = 0024h
Return: AX = FFFFh on error
	otherwise,
	    BH = major version
	    BL = minor version
	    CH = type (1=bus, 2=serial, 3=InPort, 4=PS/2, 5=HP)
	    CL = interrupt (0=PS/2, 2=IRQ2, 3=IRQ3,...,7=IRQ7,...,0Fh=IRQ15)
SeeAlso: AX=004Dh,AX=006Dh
--------M-330025-----------------------------
INT 33 - MS MOUSE v6.26+ - GET GENERAL DRIVER INFORMATION
	AX = 0025h
Return: AX = general information (see #2810)
	BX = cursor lock flag for OS/2 to prevent reentrancy problems
	CX = mouse code active flag (for OS/2)
	DX = mouse driver busy flag (for OS/2)

Bitfields for general mouse driver information:
Bit(s)	Description	(Table 2810)
 15	driver loaded as device driver rather than TSR
 14	driver is newer integrated type
 13,12	current cursor type
	00 software text cursor
	01 hardware text cursor (CRT Controller's cursor)
	1X graphics cursor
 11-8	interrupt rate (see #2808)
 7-0	count of currently-active Mouse Display Drivers (MDD), the newer
	  integrated driver type
--------M-330026-----------------------------
INT 33 - MS MOUSE v6.26+ - GET MAXIMUM VIRTUAL COORDINATES
	AX = 0026h
Return: BX = mouse-disabled flag (0000h mouse enabled, nonzero disabled)
	CX = maximum virtual X (for current video mode)
	DX = maximum virtual Y
Note:	for driver versions before 7.05, this call returns the currently-set
	  maximum coordinates; v7.05+ returns the absolute maximum coordinates
SeeAlso: AX=0031h
--------M-330026-----------------------------
INT 33 - Genius Mouse 9.06 - ???
	AX = 0026h
Return: CX = 0204h if CX was 0105h on entry, else unchanged
--------M-330027-----------------------------
INT 33 - MS MOUSE v7.01+ - GET SCREEN/CURSOR MASKS AND MICKEY COUNTS
	AX = 0027h
Return: AX = screen-mask value (or hardware cursor scan-line start for v7.02+)
	BX = cursor-mask value (or hardware cursor scan-line stop for v7.02+)
	CX = horizontal mickeys moved since last call
	DX = vertical mickeys moved since last call
SeeAlso: AX=000Bh
--------M-330028-----------------------------
INT 33 - MS MOUSE v7.0+ - SET VIDEO MODE
	AX = 0028h
	CX = new video mode (call is NOP if 0000h)
	DH = Y font size (00h = default)
	DL = X font size (00h = default)
Return: CL = status (00h = successful)
Notes:	DX is ignored unless the selected video mode supports font size control
	when CX=0000h, an internal flag that had been set by a previous call
	  is cleared; this is required before a mouse reset
SeeAlso: AX=0029h,INT 10/AH=00h
--------M-330029-----------------------------
INT 33 - MS MOUSE v7.0+ - ENUMERATE VIDEO MODES
	AX = 0029h
	CX = previous video mode
	    0000h get first supported video mode
	    other get next supported mode after mode CX
Return: CX = first/next video mode (0000h = no more video modes)
	DS:DX -> description of video mode or 0000h:0000h if none
Notes:	the enumerated video modes may be in any order and may repeat
	the description string (if available) is terminated by '$' followed by
	  a NUL byte
SeeAlso: AX=0028h
--------M-33002A-----------------------------
INT 33 - MS MOUSE v7.02+ - GET CURSOR HOT SPOT
	AX = 002Ah
Return: AX = internal counter controlling cursor visibility
	BX = cursor hot spot column
	CX = cursor hot spot row
	DX = mouse type (see #2811)
Note:	the hot spot location is relative to the upper left corner of the
	  cursor block and may range from -128 to +127 both horizontally and
	  vertically
SeeAlso: AX=0009h,AX=0012h,AX=0035h

(Table 2811)
Values for mouse type:
 00h	none
 01h	bus
 02h	serial
 03h	InPort
 04h	IBM
 05h	Hewlett-Packard
--------M-33002B-----------------------------
INT 33 - MS MOUSE v7.0+ - LOAD ACCELERATION PROFILES
	AX = 002Bh
	BX = active acceleration profile
	    0001h-0004h or FFFFh to restore default curves
	ES:SI -> buffer containing acceleration profile data (see #2812)
Return: AX = success flag
SeeAlso: AX=002Ch,AX=002Dh,AX=0033h

Format of acceleration profile data:
Offset	Size	Description	(Table 2812)
 00h	BYTE	length of acceleration profile 1
 01h	BYTE	length of acceleration profile 2
 02h	BYTE	length of acceleration profile 3
 03h	BYTE	length of acceleration profile 4
 04h 32 BYTEs	threshold speeds for acceleration profile 1
 24h 32 BYTEs	threshold speeds for acceleration profile 2
 44h 32 BYTEs	threshold speeds for acceleration profile 3
 64h 32 BYTEs	threshold speeds for acceleration profile 4
 84h 32 BYTEs	speedup factor for acceleration profile 1
		(10h = 1.0, 14h = 1.25, 20h = 2.0, etc)
 A4h 32 BYTEs	speedup factor for acceleration profile 2
		(10h = 1.0, 14h = 1.25, 20h = 2.0, etc)
 C4h 32 BYTEs	speedup factor for acceleration profile 3
		(10h = 1.0, 14h = 1.25, 20h = 2.0, etc)
 E4h 32 BYTEs	speedup factor for acceleration profile 4
		(10h = 1.0, 14h = 1.25, 20h = 2.0, etc)
104h 16 BYTEs	name of acceleration profile 1 (blank-padded)
114h 16 BYTEs	name of acceleration profile 2 (blank-padded)
124h 16 BYTEs	name of acceleration profile 3 (blank-padded)
134h 16 BYTEs	name of acceleration profile 4 (blank-padded)
Note:	unused bytes in the threshold speed fields are filled with 7Fh and
	  unused bytes in the speedup factor fields are filled with 10h
--------M-33002C-----------------------------
INT 33 - MS MOUSE v7.0+ - GET ACCELERATION PROFILES
	AX = 002Ch
Return: AX = status (0000h success)
	BX = currently-active acceleration profile
	ES:SI -> acceleration profile data (see #2812)
SeeAlso: AX=002Bh,AX=002Dh,AX=0033h
--------M-33002D-----------------------------
INT 33 - MS MOUSE v7.0+ - SELECT ACCELERATION PROFILE
	AX = 002Dh
	BX = acceleration level
	    0001h-0004h to set profile, or FFFFh to get current profile
Return: AX = status
	    0000h successful
		ES:SI -> 16-byte blank-padded name of acceleration profile
	    FFFEh invalid acceleration curve number
		ES:SI destroyed
	BX = active acceleration curve number
SeeAlso: AX=0013h,AX=002Bh,AX=002Ch,AX=002Eh
--------M-33002E-----------------------------
INT 33 - MS MOUSE v8.10+ - SET ACCELERATION PROFILE NAMES
	AX = 002Eh
	BL = flag (if nonzero, fill ES:SI buffer with default names on return)
	ES:SI -> 64-byte buffer containing profile names (16 bytes per name)
Return: AX = status (0000h success)
	    FFFEh error for ATI Mouse driver
	ES:SI buffer filled with default names if BL nonzero on entry
Notes:	not supported by Logitech driver v6.10
	supported by ATI Mouse driver v7.04
SeeAlso: AX=002Ch,AX=002Dh,AX=012Eh,AX=022Eh
--------M-33002F-----------------------------
INT 33 - MS MOUSE v7.02+ - MOUSE HARDWARE RESET
	AX = 002Fh
Return: AX = status
Note:	invoked by mouse driver v8.20 on being called with INT 2F/AX=530Bh
SeeAlso: INT 2F/AH=53h
--------M-330030-----------------------------
INT 33 - MS MOUSE v7.04+ - GET/SET BallPoint INFORMATION
	AX = 0030h
	CX = command
	    0000h get status of BallPoint device
	    other set rotation angle and masks
		BX = rotation angle (-32768 to 32767 degrees)
		CH = primary button mask
		CL = secondary button mask
Return: AX = button status (FFFFh if no BallPoint) (see #2813)
	BX = rotation angle (0-360 degrees)
	CH = primary button mask
	CL = secondary button mask
Note:	not supported by the ATI Mouse driver which calls itself v7.04

Bitfields for BallPoint mouse button status:
Bit(s)	Description	(Table 2813)
 5	button 1
 4	button 2
 3	button 3
 2	button 4
 other	zero
--------M-330031-----------------------------
INT 33 - MS MOUSE v7.05+ - GET CURRENT MINIMUM/MAXIMUM VIRTUAL COORDINATES
	AX = 0031h
Return: AX = virtual X minimum
	BX = virtual Y minimum
	CX = virtual X maximum
	DX = virtual Y maximum
Note:	the minimum and maximum values are those set by AX=0007h and AX=0008h;
	  the default is minimum = 0 and maximum = absolute maximum
	  (see AX=0026h)
SeeAlso: AX=0007h,AX=0008h,AX=0010h,AX=0026h
--------M-330032-----------------------------
INT 33 - MS MOUSE v7.05+ - GET ACTIVE ADVANCED FUNCTIONS
	AX = 0032h
Return: AX = active function flags (FFFFh for v8.10)
	    bit 15: function 0025h supported
	    bit 14: function 0026h supported
	    ...
	    bit 0:  function 0034h supported
	BX = ??? (0000h) officially unused
	CX = ??? (E000h) officially unused
	DX = ??? (0000h) officially unused
Note:	the Italian version of MS MOUSE v8.20 reportedly indicates that
	  functions 0033h and 0034h are not supported even though they are
--------M-330033-----------------------------
INT 33 - MS MOUSE v7.05+ - GET SWITCH SETTINGS AND ACCELERATION PROFILE DATA
	AX = 0033h
	CX = size of buffer
	    0000h get required buffer size
		Return: AX = 0000h
			CX = required size (0154h for Logitech v6.10, 0159h
				for MS v8.10-8.20)
	    other
		ES:DX -> buffer of CX bytes for mouse settings
		Return: AX = 0000h
			CX = number of bytes returned
			ES:DX buffer filled (see #2814)
SeeAlso: AX=002Bh

Format of mouse settings data buffer:
Offset	Size	Description	(Table 2814)
 00h	BYTE	mouse type
 01h	BYTE	current language
 02h	BYTE	horizontal sensitivity (00h-64h)
 03h	BYTE	vertical sensitivity (00h-64h)
 04h	BYTE	double-speed threshold (00h-64h)
 05h	BYTE	ballistic curve (01h-04h)
 06h	BYTE	interrupt rate (01h-04h)
 07h	BYTE	cursor override mask
 08h	BYTE	laptop adjustment
 09h	BYTE	memory type (00h-02h)
 0Ah	BYTE	SuperVGA support (00h,01h)
 0Bh	BYTE	rotation angle
 0Ch	BYTE	???
 0Dh	BYTE	primary button (01h-04h)
 0Eh	BYTE	secondary button (01h-04h)
 0Fh	BYTE	click lock enabled (00h,01h)
 10h 324 BYTEs	acceleration profile data (see #2812)
154h  5 BYTEs	??? (Microsoft driver, but not Logitech)
--------M-330034-----------------------------
INT 33 - MS MOUSE v8.0+ - GET INITIALIZATION FILE
	AX = 0034h
Return: AX = status (0000h successful)
	ES:DX -> ASCIZ initialization (.INI) file name
--------M-330035-----------------------------
INT 33 - MS MOUSE v8.10+ - LCD SCREEN LARGE POINTER SUPPORT
	AX = 0035h
	BX = function
	    FFFFh get current settings
		Return: AX = 0000h
			BH = style (see #2815)
			BL = size (see #2816)
			CH = threshold (00h-64h)
			CL = active flag (00h disabled, 01h enabled)
			DX = delay
	    other
		BH = pointer style (see #2815)
		BL = size (see #2816)
		CH = threshold (00h-64h)
		CL = active flag (00h disable size change, 01h enable)
		DX = delay (0000h-0064h)
		Return: AX = 0000h
Note:	not supported by Logitech driver v6.10
SeeAlso: AX=0012h,AX=002Ah

(Table 2815)
Values for pointer style:
 00h	normal
 01h	reverse
 02h	transparent
SeeAlso: #2816

(Table 2816)
Values for pointer size:
 00h	small ("1")
 01h	medium ("1.5")
 02h	large ("2")
SeeAlso: #2815
--------M-330042-----------------------------
INT 33 - PCMOUSE - GET MSMOUSE STORAGE REQUIREMENTS
	AX = 0042h
Return: AX = status
	    0000h MSMOUSE not installed
	    0042h functions 42h, 50h, and 52h not supported
	    FFFFh successful
		BX = buffer size in bytes for functions 50h and 52h
Note:	this function is also supported by the Genius Mouse 9.06 driver
SeeAlso: AX=0015h,AX=0050h,AX=0052h
--------M-330043-----------------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - CONFIGURE MOUSE???
	AX = 0043h
	CX:BX -> configuration buffer (see #2817)
	DL = ???
Return: ???
Notes:	also calls routines for INT 33/AX=0053h and INT 33/AX=004Fh
	this function is also supported by the Genius Mouse 9.06 driver

Format of Mouse Systems configuration buffer:
Offset	Size	Description	(Table 2817)
 00h	WORD	I/O port address
 02h	BYTE	???
 03h	BYTE	interrupt number
 04h	BYTE	interrupt mask for interrupt controller
 05h  5 BYTEs	???
--------M-330044CXCDEF-----------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - TOGGLE IGNORE ACCELERATION CMDS
	AX = 0044h
	CX = CDEFh
Return: AX = new state of "Ignore Application Acceleration Commands" flag
Note:	this function is also supported by the Genius Mouse 9.06 driver
SeeAlso: AX=0045h
--------M-330045CXCDEF-----------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - TOGGLE RESOLUTION DOUBLING
	AX = 0045h
	CX = CDEFh
Return: AX = new state of resolution doubling flag
Note:	this function is also supported by the Genius Mouse 9.06 driver
SeeAlso: AX=0044h
--------M-330047-----------------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - SET BUTTON ASSIGNMENTS
	AX = 0047h
	ES:BX -> button assignments (3 bytes, combinations of "L", "M", "R")
Return: ???
Note:	also supported by Genius Mouse 9.06 driver
SeeAlso: AX=0067h
--------M-330048BXCDEF-----------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - GET ???
	AX = 0048h
	BX = CDEFh
Return: CX = ???
	BH = ???
	BL = ??? (if 50h, driver is using PS/2 pointing device BIOS interface)
Note:	also supported by Genius Mouse 9.06 driver
--------M-33004B-----------------------------
INT 33 - LCS/Telegraphics MOUSE DRIVERS - INSTALLATION CHECK / GET VERSION
	AX = 004Bh
Return: ES:DI -> ASCIZ signature/description string if installed (see #2818)

(Table 2818)
Values for LCS/Telegraphics mouse driver OEM signature/description string:
 "Primax Generic;Universal Mouse Driver;IMOUSE;v8.20i"
 "Synaptics;TouchPad Driver;SYNTOUCH;v2.26"
 "Z-NIX;BUS,AUX,Serial 3-byte and 5-byte Mouse Driver;ZMOUSE;v7.04d"
Note:	the string consists of OEM, driver description, driver name, and
	  version number
--------M-33004CBXCDEF-----------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - SET ??? FLAG
	AX = 004Ch
	BX = CDEFh
Note:	also supported by Genius Mouse 9.06
SeeAlso: AX=006Ch
--------M-33004D-----------------------------
INT 33 - MS MOUSE - RETURN POINTER TO COPYRIGHT STRING
	AX = 004Dh
Return: ES:DI -> copyright message "*** This is Copyright 1983 Microsoft" or
		"Copyright 19XX...."
Notes:	also supported by Logitech, Kraft, Genius Mouse, and Mouse Systems
	  mouse drivers
	in the Genius Mouse 9.06 driver, the ASCIZ signature "KYE" immediately
	  follows the above copyright message (KYE Corp. manufactures the
	  driver)
SeeAlso: AX=0024h,AX=006Dh,AX=0666h
--------M-33004F-----------------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - ENABLE MOUSE
	AX = 004Fh
Return: nothing
Note:	also supported by Genius Mouse 9.06
SeeAlso: AX=0043h,AX=0053h
--------M-330050-----------------------------
INT 33 - PCMOUSE - SAVE MSMOUSE STATE
	AX = 0050h
	BX = buffer size (ignored by some driver versions)
	ES:DX -> buffer
Return: AX = FFFFh if successful
Notes:	the buffer must be large enough to hold the entire state, or following
	  data will be overwritten by state data in versions which ignore BX;
	  use INT 33/AX=0042h to get the required size
	this function is also supported by the Genius Mouse 9.06 driver
SeeAlso: AX=0042h,AX=0052h
--------M-330052-----------------------------
INT 33 - PCMOUSE - RESTORE MSMOUSE STATE
	AX = 0052h
	BX = buffer size (ignored by some driver versions)
	ES:DX -> buffer
Return: AX = FFFFh if successful
Note:	also supported by Genius Mouse 9.06 driver
SeeAlso: AX=0050h
--------M-330053-----------------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - DISABLE MOUSE
	AX = 0053h
Return: nothing
Note:	also supported by Genius Mouse 9.06
SeeAlso: AX=0043h,AX=004Fh
--------M-330054CXCDEF-----------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - SELECT ULTRARES ACCELERATION LEVEL
	AX = 0054h
	CX = CDEFh
	BX = new acceleration level (0-9)
Return: ???
Note:	this function is also supported by the Genius Mouse 9.06 driver
SeeAlso: AX=005Ah
--------M-330055-----------------------------
INT 33 - Kraft Mouse - GET ???
	AX = 0055h
Return: CX = ???
	DX = ???
	ES = ???
--------M-330058-----------------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - ???
	AX = 0058h
Return: AX = CS of driver
	CX:BX = original INT 33 vector
	DX = ???
Note:	this function is also supported by the Genius Mouse 9.06 driver
--------M-33005A-----------------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - SET ULTRARES ACCELERATIONS
	AX = 005Ah
	CX = number of WORDs to copy (max 0014h, but not range-checked)
	DX:SI -> buffer containing thresholds??? (CX words)
	DX:BX -> buffer containing acceleration values???
		(9*14h words, only first CX of each 14h used)
	???
Return: CF clear
	???
Note:	this function is also supported by Genius Mouse 9.06
SeeAlso: AX=0054h
--------M-330061BXCDEF-----------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - ???
	AX = 0061h
	BX = CDEFh
Return: CX = ???
Note:	also supported by Genius Mouse 9.06
--------M-330067-----------------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - GET MOUSE BUTTONS???
	AX = 0067h
Return: BL = number of buttons???
Note:	also supported by Genius Mouse 9.06
SeeAlso: AX=0047h
--------M-33006A-----------------------------
INT 33 U - ATI Mouse - INSTALLATION CHECK
	AX = 006Ah
Return: AL = AAh
	AH = ???
	BH = ???
	BL = ???
	CL = ???
	CH = ???
Program: ATI's MOUSE.COM and MOUSE.SYS are drivers for the mouse port found on
	  some of ATI's video adapters
SeeAlso: AX=006Dh
--------M-33006C-----------------------------
INT 33 U - TRUEDOX Mouse driver v4.01 - GET/SET HARDWARE PARAMETERS
	AX = 006Ch
	BX = new IRQ (0003h or 0004h), or 0000h to get current values only
	CL = new IRQmask (sent to 8259)
	DX = new base I/O port
Return: BX = current IRQ
	DX = light pen state???
Note:	this is the mouse driver for the Dell Dimension series of computers, by
	  TRUEDOX Technology Corporation
SeeAlso: AX=00A1h,AX=0666h
--------M-33006CBXCDEF-----------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - CLEAR ??? FLAG
	AX = 006Ch
	BX = CDEFh
Note:	also supported by Genius Mouse 9.06
SeeAlso: AX=004Ch
--------M-33006D-----------------------------
INT 33 - MS MOUSE - GET VERSION STRING
	AX = 006Dh
Return: ES:DI -> Microsoft version number of resident driver (see #2819)
Notes:	also supported by Logitech, Mouse Systems, Kraft, and Genius mouse
	  drivers
	the Mouse Systems 7.01 and Genius Mouse 9.06 drivers report their
	  Microsoft version as 7.00 even though they do not support any of the
	  functions from 0025h through 002Dh supported by the MS 7.00 driver
	  (the Genius Mouse driver supports function 0026h, but it differs
	  from the Microsoft function)
	the TRUEDOX 4.01 driver reports its version as 6.26 through this call,
	  but as 6.24 through AX=0024h
SeeAlso: AX=0024h,AX=004Dh,AX=006Ah,AX=266Ch

Format of Microsoft version number:
Offset	Size	Description	(Table 2819)
 00h	BYTE	major version
 01h	BYTE	minor version (BCD)
--------M-330070BXABCD-----------------------
INT 33 - Mouse Systems MOUSE DRIVER - POPUP.COM - INSTALLATION CHECK
	AX = 0070h
	BX = ABCDh
Return: AX = ABCDh if installed
	    BX:CX -> data structure (see #2820)
Notes:	this function is also supported by the Genius Mouse 9.06 driver
	the v7.01 POPUP.COM and menu drivers also check for the signature
	  CDh ABh BAh DCh at offset -2Ch from the interrupt handler
	if POPUP is not loaded, the returned data structure contains the proper
	  signature at offset 00h, but not at offset 08h

Format of Mouse Systems POPUP.COM data structure:
Offset	Size	Description	(Table 2820)
 00h	WORD	signature ABCDh
 02h	DWORD	pointer to info structure??? (see #2821)
 06h  2 BYTEs	???
 08h	WORD	signature ABCDh

Format of Mouse Systems POPUP.COM info structure:
Offset	Size	Description	(Table 2821)
 00h	WORD	driver version
 02h  8 BYTEs	???
 0Ah	WORD	segment of ???
	???
--------M-330072BXABCD-----------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - ???
	AX = 0072h
	BX = ABCDh
Return: ???
Note:	this function is also supported by the Genius Mouse 9.06 driver
--------M-330073BXCDEF-----------------------
INT 33 - Mouse Systems MOUSE DRIVER v7.01+ - GET BUTTON ASSIGNMENTS
	AX = 0073h
	BX = CDEFh
	ES:DX -> 3-byte buffer for button assignments
Return: CX = number of buttons???
	ES:DX buffer filled (default is "LMR")
Note:	also supported by Genius Mouse 9.06
SeeAlso: AX=0067h
--------M-3300A0-----------------------------
INT 33 U - TRUEDOX Mouse driver - SET HARDWARE PC MODE (3 button)
	AX = 00A0h
Return: nothing
Note:	this function is only available if the mouse mode is switchable
	  through the power pins
SeeAlso: AX=006Ch"TRUEDOX",AX=00A1h"TRUEDOX"
--------M-3300A1-----------------------------
INT 33 U - TRUEDOX Mouse driver - SET HARDWARE MS MODE (2 button)
	AX = 00A1h
Return: nothing
Notes:	this function is only available if the mouse mode is switchable
	  through the power pins
	this is the mouse driver for the Dell Dimension series of computers, by
	  TRUEDOX Technology Corporation
SeeAlso: AX=006Ch"TRUEDOX",AX=00A0h"TRUEDOX",AX=00A6h,AX=0666h
--------M-3300A6-----------------------------
INT 33 U - TRUEDOX Mouse driver - SET RESOLUTION
	AX = 00A6h
	BX = new software resolution
	    0001h 50-200 dpi
	    0002h 200-400 dpi
	    0003h 400-800 dpi
Note:	this is the mouse driver for the Dell Dimension series of computers, by
	  TRUEDOX Technology Corporation
SeeAlso: AX=00A0h,AX=00A1h,AX=0666h
--------M-3300B0-----------------------------
INT 33 U - LCS/Telegraphics MOUSE DRIVERS - ???
	AX = 00B0h
	???
Return: ???
--------M-3300F0-----------------------------
INT 33 U - LCS/Telegraphics MOUSE DRIVERS - ???
	AX = 00F0h
	???
Return: ???
--------M-3300F1-----------------------------
INT 33 U - LCS/Telegraphics MOUSE DRIVERS - ???
	AX = 00F1h
	???
Return: ???
--------M-3300F2-----------------------------
INT 33 U - LCS/Telegraphics MOUSE DRIVERS - ???
	AX = 00F2h
	???
Return: ???
--------M-3300F3-----------------------------
INT 33 U - LCS/Telegraphics MOUSE DRIVERS - ???
	AX = 00F3h
	???
Return: ???
--------M-330100CX4752-----------------------
INT 33 - GRTMOUSE v1.00+ - INSTALLATION CHECK
	AX = 0100h
	CX = 4752h ('GR')
	DX = 544Dh ('TM')
Return: AX = 474Dh ('GM') if installed
	    CX = version number (CH = major, CL = minor)
Program: GRTMOUSE is a graphical-cursor driver for textmode by Tommer Leyvand
SeeAlso: AX=0101h,AX=0102h,AX=0103h,AX=0104h
--------M-330101-----------------------------
INT 33 - GRTMOUSE v1.00+ - SET MOUSE CURSOR SHAPE
	AX = 0101h
	DS:SI -> 16-byte cursor pattern
Return: CF clear if successful
SeeAlso: AX=0100h,AX=0102h
--------M-330102-----------------------------
INT 33 - GRTMOUSE v1.00+ - GET MOUSE CURSOR SHAPE
	AX = 0102h
	ES:DI -> 16-byte buffer for cursor pattern
SeeAlso: AX=0100h,AX=0101h
--------M-330103-----------------------------
INT 33 - GRTMOUSE v1.00+ - SET ACTIVE CHARACTERS
	AX = 0103h
	CH,CL,DH,DL = ASCII codes to be remapped to display mouse pointer
Note:	the default active characters are D0h,D1h,D6h,D8h; the active
	 characters should be in the range C0h to DFh
SeeAlso: AX=0100h,AX=0104h
--------M-330104-----------------------------
INT 33 - GRTMOUSE v1.00+ - GET ACTIVE CHARACTERS
	AX = 0104h
Return: CH,CL,DH,DL = ASCII codes for the active characters
SeeAlso: AX=0100h,AX=0103h
--------M-33012E-----------------------------
INT 33 - MS MOUSE v8.10+ - ???
	AX = 012Eh
	BL = ???
Return: AX = 0000h (MS)
	AX = FFFFh (ATI Mouse v7.04)
Note:	not supported by Logitech driver v6.10
SeeAlso: AX=002Eh,AX=022Eh
--------M-33022E-----------------------------
INT 33 - MS MOUSE v8.10+ - ???
	AX = 022Eh
	BL = ???
Return: AX = 0000h (MS)
	AX = FFFFh (ATI Mouse v7.04)
Note:	not supported by Logitech driver v6.10
SeeAlso: AX=002Eh,AX=012Eh
--------M-330666-----------------------------
INT 33 U - TRUEDOX Mouse driver v4.01 - GET COPYRIGHT STRING
	AX = 0666h
Return: DX:AX -> ASCII "Copyright 1987-1992 TRUEDOX Technology Corporation"
Note:	this is the mouse driver for the Dell Dimension series of computers,
	  by TRUEDOX Technology Corporation
SeeAlso: AX=004Dh,AX=00A6h,AX=0666h
--------M-33136C-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - ???
	AX = 136Ch
	BX = ???
Return: AX = ???
	BX = ???
--------M-33146C-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - GET/SET ???
	AX = 146Ch
	BL = function
	    00h set ???
		BH = new value (zero/nonzero to clear/set)
	    else get ???
		Return: ???
--------M-33156C-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - GET SIGNATURE AND VERSION STRINGS
	AX = 156Ch
Return: ES:DI -> signature "LOGITECH MOUSE DRIVER"
	ES:SI -> version string, terminated with CRLF
--------M-33166C-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - ???
	AX = 166Ch
	BL = ???
	    00h ???
	    01h ???
	    other ???
		BH = new value of ???
		Return: AX = FFFFh
--------M-33176C-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - ???
	AX = 176Ch
	???
Return: ???
--------M-33186C-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - ???
	AX = 186Ch
	???
Return: ???
--------M-33196C-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - ???
	AX = 196Ch
	???
Return: ???
--------M-331A6C-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - GET ???
	AX = 1A6Ch
Return: AX = FFFFh
	BX = ???
	CX = ???
SeeAlso: AX=1B6Ch
--------M-331B6C-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - SET ???
	AX = 1B6Ch
	BX = new value for ??? (0000h-0003h)
Return: AX = FFFFh
SeeAlso: AX=1A6Ch
--------M-331C6C-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - ???
	AX = 1C6Ch
	BX = ???
	    <42h ???
	    =42h ???
	    >42h ???
		ES:DI -> ???
		Return: AX = ???
--------M-331D6C-----------------------------
INT 33 - LOGITECH MOUSE - GET COMPASS PARAMETER
	AX = 1D6Ch
Return: BX = direction (0=north, 1=south, 2=east, 3=west)
SeeAlso: AX=1E6Ch
--------M-331E6C-----------------------------
INT 33 - LOGITECH MOUSE - SET COMPASS PARAMETER
	AX = 1E6Ch
	BX = direction (0=north, 1=south, 2=east, 3=west)
SeeAlso: AX=1D6Ch
--------M-331F6C-----------------------------
INT 33 - LOGITECH MOUSE - GET BALLISTICS INFORMATION
	AX = 1F6Ch
Return: BX = 0=off, 1=on
	CX = 1=low, 2=high
SeeAlso: AX=002Ch,AX=236Ch
--------M-33206C-----------------------------
INT 33 - LOGITECH MOUSE - SET LEFT OR RIGHT PARAMETER
	AX = 206Ch
	BX = parameter (00h = right, FFh = left)
SeeAlso: AX=216Ch
--------M-33216C-----------------------------
INT 33 - LOGITECH MOUSE - GET LEFT OR RIGHT PARAMETER
	AX = 216Ch
Return: BX = parameter (00h = right, FFh = left)
SeeAlso: AX=206Ch
--------M-33226C-----------------------------
INT 33 - LOGITECH MOUSE - REMOVE DRIVER FROM MEMORY
	AX = 226Ch
Note:	this only frees memory; does not restore hooked interrupts
--------M-33236C-----------------------------
INT 33 - LOGITECH MOUSE - SET BALLISTICS INFORMATION
	AX = 236Ch
	BX = 0=off, 1=on
	CX = 1=low, 2=high
SeeAlso: AX=002Ch,AX=1F6Ch
--------M-33246C-----------------------------
INT 33 - LOGITECH MOUSE - GET PARAMETERS AND RESET SERIAL MOUSE
	AX = 246Ch
	ES:DX -> parameter table buffer (see #2822)
Return: AX = FFFFh if driver installed for serial mouse
SeeAlso: AX=0000h,AX=256Ch/BX=0000h,AX=256Ch/BX=0001h,AX=256Ch/BX=0003h

Format of Logitech Mouse parameter table:
Offset	Size	Description	(Table 2822)
 00h	WORD	baud rate divided by 100  (serial mouse only)
 02h	WORD	emulation		  (serial mouse only)
 04h	WORD	report rate		  (serial mouse only)
 06h	WORD	firmware revision	  (serial mouse only)
 08h	WORD	00h			  (serial mouse only)
 0Ah	WORD	port			  (serial mouse only)
 0Ch	WORD	physical buttons
 0Eh	WORD	logical buttons
--------M-33256CBX0000-----------------------
INT 33 - LOGITECH MOUSE - SET PARAMETERS - SET BAUD RATE (SERIAL MOUSE ONLY)
	AX = 256Ch
	BX = 0000h
	CX = rate (0=1200, 1=2400, 2=4800, 3=9600)
Return: AX = FFFFh if driver installed for serial mouse
SeeAlso: AX=246Ch,AX=256Ch/BX=0001h,AX=256Ch/BX=0002h,AX=276Ch
--------M-33256CBX0001-----------------------
INT 33 - LOGITECH MOUSE - SET PARAMETERS - SET EMULATION (SERIAL MOUSE ONLY)
	AX = 256Ch
	BX = 0001h
	CX = emulation type (see #2823)
Return: AX = FFFFh if driver installed for serial mouse
SeeAlso: AX=246Ch,AX=256Ch/BX=0000h,AX=256Ch/BX=0003h,AX=276Ch

(Table 2823)
Values for Logitech mouse emulation type:
 00h	5 byte packed binary
 01h	3 byte packed binary
 02h	hexadecimal
 03h	relative bit pad
 04h	not supported
 05h	MM Series
 06h	not supported
 07h	Microsoft
--------M-33256CBX0002-----------------------
INT 33 - LOGITECH MOUSE - SET PARAMETERS - SET REPORT RATE (SERIAL MOUSE ONLY)
	AX = 256Ch
	BX = 0002h
	CX = rate (0=10, 1=20, 2=35, 3=50, 4=70, 5=100, 6=150)
Return: AX = FFFFh if driver installed for serial mouse
SeeAlso: AX=246Ch,AX=256Ch/BX=0001h,AX=256Ch/BX=0003h,AX=276Ch
--------M-33256CBX0003-----------------------
INT 33 - LOGITECH MOUSE - SET PARAMETERS - SET MOUSE PORT (SERIAL MOUSE ONLY)
	AX = 256Ch
	BX = 0003h
	CX = port (1, 2)
Return: AX = FFFFh if driver installed for serial mouse
SeeAlso: AX=246Ch,AX=256Ch/BX=0000h,AX=256Ch/BX=0004h,AX=276Ch
--------M-33256CBX0004-----------------------
INT 33 - LOGITECH MOUSE - SET PARAMETERS - SET MOUSE LOGICAL BUTTONS
	AX = 256Ch
	BX = 0004h
	CX = buttons (2, 3)
Return: AX = FFFFh if driver installed for serial mouse
SeeAlso: AX=246Ch,AX=276Ch
--------M-33266C-----------------------------
INT 33 - LOGITECH MOUSE - GET VERSION???
	AX = 266Ch
Return: BX = 'SS'
	CH = '4'  major version number
	CL = '1'  minor version number
SeeAlso: AX=006Dh
--------M-33276C-----------------------------
INT 33 - LOGITECH MOUSE - ??? Tries MMSeries, Baud 2400
	AX = 276Ch
SeeAlso: AX=256Ch
--------M-333000-----------------------------
INT 33 - Smooth Mouse Driver, PrecisePoint - INSTALLATION CHECK
	AX = 3000h
Return: AX = FFFFh if installed
	    BX = version number (BH = major, BL = minor)
Program: SMD is a programmer's library by Andy Hakim which provides a
	  graphics-style mouse cursor in text mode.  PrecisePoint is an
	  SMD-based TSR which replaces the block mouse cursor in text
	  applications.
SeeAlso: AX=0000h,AX=3001h,AX=3003h
--------M-333001-----------------------------
INT 33 - Smooth Mouse Driver, PrecisePoint - ENABLE SMOOTH MOUSE
	AX = 3001h
Return: AX = status (0000h = disabled, 0001h = enabled)
Note:	SMD remains disabled if running under Desqview or in graphics mode
SeeAlso: AX=0001h,AX=0002h,AX=3002h
--------M-333002-----------------------------
INT 33 - Smooth Mouse Driver, PrecisePoint - DISABLE SMOOTH MOUSE
	AX = 3002h
Return: AX = status (0000h = disabled, 0001h = enabled)
SeeAlso: AX=0001h,AX=0002h,AX=3000h,AX=3001h
--------M-333003-----------------------------
INT 33 - Smooth Mouse Driver, PrecisePoint - GET INFORMATION
	AX = 3003h
	BL = data structure selector
	    00h Primary Bitmap (used for 25 line mode) (see #2824)
	    01h Secondary Bitmap (used for 43/50 line modes) (see #2824)
	    02h Sacrifice Character Map (see #2825)
	    03h Program Information (see #2826)
Return: ES:DX -> selected data structure
SeeAlso: AX=3000h

Format of Primary/Secondary Bitmap [SMD_BITMAP_STRUCT]:
Offset	Size	Description	(Table 2824)
 00h	BYTE	vertical size of bitmap (00h - 10h)
 01h	BYTE	horizontal size of bitmap (00h - 10h)
 02h	BYTE	vertical hotspot position (00h - 10h)
 03h	BYTE	horizontal hotspot position (00h - 10h)
 04h 16 WORDs	cursor bitmap data
 14h 16 WORDs	screen bitmap data

Format of Sacrifice Character Map [SMD_SMAP_STRUCT]:
Offset	Size	Description	(Table 2825)
 00h	BYTE	bytes are character values (00h-FFh) used in place of the
 01h	BYTE	actual character for the corresponding position on the screen
 02h	BYTE	     +--------------+	  occupied by part or all of the mouse
 03h	BYTE	     | 0h | 1h | 2h |	  cursor
 04h	BYTE	     |----+----+----|
 05h	BYTE	     | 3h | 4h | 5h |
 06h	BYTE	     |----+----+----|
 07h	BYTE	     | 6h | 7h | 8h |
 08h	BYTE	     +--------------+

Format of Program Information [SMD_INFO_STRUCT]:
Offset	Size	Description	(Table 2826)
 00h	WORD	segment of old interrupt 33h handler
 02h	WORD	offset of old interrupt 33h handler
 04h	WORD	PSP of SMD
 06h	BYTE	ENABLE/DISABLE manual setting status
 07h	BYTE	ENABLE/DISABLE internal usage status
--------M-333004-----------------------------
INT 33 - Smooth Mouse Driver, PrecisePoint - RESERVED FUTURE EXPANSION
	AX = 3004h
SeeAlso: AX=3000h
--------M-333005-----------------------------
INT 33 - Smooth Mouse Driver, PrecisePoint - RESERVED FUTURE EXPANSION
	AX = 3005h
SeeAlso: AX=3000h
--------M-334F00-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - GET ???
	AX = 4F00h
Return: AX = 004Fh if supported
	BX = ???
	ES:DI -> ???
SeeAlso: AX=4F01h
--------M-334F01-----------------------------
INT 33 - LOGITECH MOUSE v6.10+ - ???
	AX = 4F01h
	ES = ???
Return: AX = 004Fh if supported
	ES:DI -> ???
SeeAlso: AX=4F00h
--------M-336F00-----------------------------
INT 33 - Hewlett Packard - HP MOUSE DRIVER INSTALLATION CHECK
	AX = 6F00h
	BX <> 4850h
Return: BX = 4850h ('HP') if mouse driver written by Hewlett Packard
SeeAlso: INT 10/AX=6F00h,INT 14/AX=6F00h,INT 16/AX=6F00h,INT 17/AX=6F00h
--------M-338800-----------------------------
INT 33 U - InfoTrack IMOUSE.COM - UNHOOK MOUSE IRQ
	AX = 8800h
	BX <> FFFFh
Note:	the code is written to expect a subfunction number in AL, but only
	  function 00h has been implemented
SeeAlso: AX=8800h/BX=FFFFh
--------M-338800BXFFFF-----------------------
INT 33 U - InfoTrack IMOUSE.COM - GET ACTIVE IRQ
	AX = 8800h
	BX = FFFFh
Return: BL = number of IRQ being used by the mouse
SeeAlso: AX=8800h
--------T-33FFE6-----------------------------
INT 33 - Switch-It v3.23 - GET ??? PROGRAM
	AX = FFE6h
	CX = length of buffer
	ES:DI -> buffer for program name
Return: ES:DI buffer filled
Program: Switch-It is a task switcher supporting up to 100 programs
	  simultaneously by Better Software Technology, Inc.
--------T-33FFE7-----------------------------
INT 33 - Switch-It v3.23 - GET ???
	AX = FFE7h
Return: AX = ???
--------T-33FFE8-----------------------------
INT 33 - Switch-It v3.23 - ???
	AX = FFE8h
	CX = length of name including terminating NUL
	DS:SI -> ASCIZ program pathname
--------T-33FFE9-----------------------------
INT 33 - Switch-It v3.23 - SET ???
	AX = FFE9h
	BX = ???
--------T-33FFEA-----------------------------
INT 33 - Switch-It v3.23 - SET ???
	AX = FFEAh
	BL = ???
--------T-33FFEB-----------------------------
INT 33 - Switch-It v3.23 - SET ??? FLAG
	AX = FFEBh
--------T-33FFEC-----------------------------
INT 33 - Switch-It v3.23 - SET ???
	AX = FFECh
	BL = ???
--------T-33FFED-----------------------------
INT 33 - Switch-It v3.23 - GET ???
	AX = FFEDh
Return: AX = ??? (0001h)
	BX = ???
Program: Switch-It is a task switcher supporting up to 100 programs
	  simultaneously by Better Software Technology, Inc.
--------T-33FFEE-----------------------------
INT 33 - Switch-It v3.23 - GET ???
	AX = FFEEh
Return: AX = ???
--------T-33FFEF-----------------------------
INT 33 - Switch-It v3.23 - GET ???
	AX = FFEFh
Return: BX:AX -> ???
--------T-33FFF0-----------------------------
INT 33 - Switch-It v3.23 - SET ???
	AX = FFF0h
	BL = ???
--------T-33FFF1-----------------------------
INT 33 - Switch-It v3.23 - GET CONFIGURATION FILE
	AX = FFF1h
Return: BX:AX -> ASCIZ pathname of configuration file
Program: Switch-It is a task switcher supporting up to 100 programs
	  simultaneously by Better Software Technology, Inc.
--------T-33FFF2-----------------------------
INT 33 - Switch-It v3.23 - SET ??? FLAG
	AX = FFF2h
Return: AL = 01h
--------T-33FFF3-----------------------------
INT 33 - Switch-It v3.23 - GET ???
	AX = FFF3h
Return: AX = ???
--------T-33FFF4-----------------------------
INT 33 - Switch-It v3.23 - SET ???
	AX = FFF4h
	BX = ???
	CX = ???
--------T-33FFF5-----------------------------
INT 33 - Switch-It v3.23 - GET ???
	AX = FFF5h
Return: AX = ???
--------T-33FFF6-----------------------------
INT 33 - Switch-It v3.23 - GET ???
	AX = FFF6h
Return: AX = ???
--------T-33FFF7-----------------------------
INT 33 - Switch-It v3.23 - GET ???
	AX = FFF7h
	BX = index of ???
Return: AX = ???
--------T-33FFF8-----------------------------
INT 33 - Switch-It v3.23 - ???
	AX = FFF8h
	BX = ???
	CX = length of program name, including terminating NUL
	DS:SI -> ASCIZ program pathname
Return: ???
Program: Switch-It is a task switcher supporting up to 100 programs
	  simultaneously by Better Software Technology, Inc.
--------T-33FFF9-----------------------------
INT 33 - Switch-It v3.23 - NOP
	AX = FFF9h
--------T-33FFFA-----------------------------
INT 33 - Switch-It v3.23 - SET ???
	AX = FFFAh
	BX = index of program
SeeAlso: AX=FFFBh,AX=FFFCh
--------T-33FFFB-----------------------------
INT 33 - Switch-It v3.23 - GET ???
	AX = FFFBh
	BX = index of program
Return: AX = ??? (0000h or 0001h)
SeeAlso: AX=FFFAh,AX=FFFCh
--------T-33FFFC-----------------------------
INT 33 - Switch-It v3.23 - CLEAR ???
	AX = FFFCh
	BX = index of program
SeeAlso: AX=FFFAh,AX=FFFCh
--------T-33FFFD-----------------------------
INT 33 - Switch-It v3.23 - GET MEMORY ADDRESSES???
	AX = FFFDh
Return: AX = first available segment???
	BX = paragraph of top of conventional memory
	DX = PSP segment of SI.EXE
--------T-33FFFE-----------------------------
INT 33 - Switch-It v3.23 - INSTALLATION CHECK
	AX = FFFEh
Return: BX = ???
	DX = 5349h ("SI")
--------T-33FFFF-----------------------------
INT 33 - Switch-It v3.23 - ???
	AX = FFFFh
	BX = ???
Program: Switch-It is a task switcher supporting up to 100 programs
	  simultaneously by Better Software Technology, Inc.
--------r-34---------------------------------
INT 34 - FLOATING POINT EMULATION - OPCODE D8h
Desc:	this interrupt is used to emulate floating-point instructions with
	  an opcode of D8h
Note:	the floating-point emulators in Borland and Microsoft languages and
	  Lahey FORTRAN use this interrupt
SeeAlso: INT 35,INT 3E
--------r-35---------------------------------
INT 35 - FLOATING POINT EMULATION - OPCODE D9h
Desc:	this interrupt is used to emulate floating-point instructions with
	  an opcode of D9h
Note:	the floating-point emulators in Borland and Microsoft languages and
	  Lahey FORTRAN use this interrupt
SeeAlso: INT 34,INT 36
--------r-36---------------------------------
INT 36 - FLOATING POINT EMULATION - OPCODE DAh
Desc:	this interrupt is used to emulate floating-point instructions with
	  an opcode of DAh
Note:	the floating-point emulators in Borland and Microsoft languages and
	  Lahey FORTRAN use this interrupt
SeeAlso: INT 35,INT 37
--------r-37---------------------------------
INT 37 - FLOATING POINT EMULATION - OPCODE DBh
Desc:	this interrupt is used to emulate floating-point instructions with
	  an opcode of DBh
Note:	the floating-point emulators in Borland and Microsoft languages and
	  Lahey FORTRAN use this interrupt
SeeAlso: INT 36,INT 38
--------r-38---------------------------------
INT 38 - FLOATING POINT EMULATION - OPCODE DCh
Desc:	this interrupt is used to emulate floating-point instructions with
	  an opcode of DCh
Note:	the floating-point emulators in Borland and Microsoft languages and
	  Lahey FORTRAN use this interrupt
SeeAlso: INT 37,INT 39
--------O-38---------------------------------
INT 38 - PC-MOS/386 v3.0 - API
Note:	this API was been moved to INT D4h sometime between versions 3.0 and
	  5.01; v3.0 supported at least functions 02h,04h,0703h,10h,11h, and
	  12h
SeeAlso: INT D4/AH=02h,INT D4/AH=04h,INT D4/AH=07h,INT D4/AH=10h,INT D4/AH=11h
--------r-39---------------------------------
INT 39 - FLOATING POINT EMULATION - OPCODE DDh
Desc:	this interrupt is used to emulate floating-point instructions with
	  an opcode of DDh
Note:	the floating-point emulators in Borland and Microsoft languages and
	  Lahey FORTRAN use this interrupt
SeeAlso: INT 38,INT 3A
--------r-3A---------------------------------
INT 3A - FLOATING POINT EMULATION - OPCODE DEh
Desc:	this interrupt is used to emulate floating-point instructions with
	  an opcode of DEh
Note:	the floating-point emulators in Borland and Microsoft languages and
	  Lahey FORTRAN use this interrupt
SeeAlso: INT 39,INT 3B
--------r-3B---------------------------------
INT 3B - FLOATING POINT EMULATION - OPCODE DFh
Desc:	this interrupt is used to emulate floating-point instructions with
	  an opcode of DFh
Note:	the floating-point emulators in Borland and Microsoft languages and
	  Lahey FORTRAN use this interrupt
SeeAlso: INT 3A,INT 3C
--------r-3C---------------------------------
INT 3C - FLOATING POINT EMULATION - INSTRUCTIONS WITH SEGMENT OVERRIDE
Notes:	the floating-point emulators in Borland and Microsoft languages and
	  Lahey FORTRAN use this interrupt
	the generated code is  CD 3C xy mm ....
	  where xy is a modified ESC instruction and mm is the modR/M byte.
	  The xy byte appears to be encoded as
		s s 0 1 1 x x x	  or	s s 0 0 0 x x x
	  where "ss" specifies the segment override:
		00 -> DS:
		01 -> SS:
		10 -> CS:
		11 -> ES:
SeeAlso: INT 3B,INT 3D
--------r-3D---------------------------------
INT 3D - FLOATING POINT EMULATION - STANDALONE FWAIT
Notes:	the floating-point emulators in Borland and Microsoft languages and
	  Lahey FORTRAN use this interrupt
	this vector is modified but not restored by Direct Access v4.0, and
	  may be left dangling by other programs written with the same version
	  of compiled BASIC
SeeAlso: INT 3C,INT 3E
--------r-3E---------------------------------
INT 3E - FLOATING POINT EMULATION - Borland LANGUAGES "SHORTCUT" CALL
Notes:	the two bytes following the INT 3E instruction are the subcode
	  (see #2827) and a NOP (90h), except for subcodes DCh and DEh, where
	  the second byte is a register count (01h-08h)
	this vector is modified but not restored by Direct Access v4.0, and
	  may be left dangling by other programs written with the same version
	  of compiled BASIC
SeeAlso: INT 3D

(Table 2827)
Values for Borland floating-point shortcut subcode:
Subcode		Function
 DCh	load 8086 stack with 8087 registers; overwrites the 10*N bytes at the
	  top of the stack prior to the INT 3E with the 8087 register contents
 DEh	load 8087 registers from top of 8086 stack; ST0 is furthest from top
	  of 8086 stack
 E0h	round TOS and R1 to single precision, compare, pop twice
	  returns AX=8087 status word, FLAGS=8087 condition bits
 E2h	round TOS and R1 to double precision, compare, pop twice
	  returns AX=8087 status word, FLAGS=8087 condition bits
	Note: buggy in TPas5.5, because it sets the 8087 precision control
	  field to the undocumented value 01h; this results in actually
	  rounding to single precision
 E4h	compare TOS/R1 with two POP's
	  returns FLAGS=8087 condition bits
 E6h	compare TOS/R1 with POP
	  returns FLAGS=8087 condition bits
 E8h	FTST (check TOS value)
	  returns FLAGS=8087 condition bits
 EAh	FXAM (check TOS value)
	  returns AX=8087 status word
 ECh	sine(ST0)
 EEh	cosine(ST0)
 F0h	tangent(ST0)
 F2h	arctangent(ST0)
 F4h	ST0 = ln(ST0)
 F6h	ST0 = log2(ST0)
 F8h	ST0 = log10(ST0)
 FAh	ST0 = e**ST0
 FCh	ST0 = 2**ST0
 FEh	ST0 = 10**ST0
--------r-3F---------------------------------
INT 3F - Overlay manager interrupt (Microsoft LINK.EXE, Borland TLINK VROOMM)
Notes:	INT 3F is the default, and may be overridden while linking
	this vector is modified but not restored by Direct Access v4.0, and
	  may be left dangling by other programs written with the same version
	  of compiled BASIC
SeeAlso: INT FE"OVERLAY"
--------r-3F---------------------------------
INT 3F - Microsoft Dynamic Link Library manager
SeeAlso: INT 21/AH=4Bh
--------B-40---------------------------------
INT 40 - DISKETTE - ROM BIOS DISKETTE HANDLER RELOCATED BY HARD DISK BIOS
SeeAlso: INT 13/AH=00h,INT 13/AH=02h,INT 47"SuperBIOS",INT 63"Adaptec"
--------h-40---------------------------------
INT 40 - Z100 - Master 8259 - Parity error or S100 error
SeeAlso: INT 41"Z100",INT FF"Z100"
--------O-40---------------------------------
INT 40 - Acorn BBC Master 512 - "OSFIND" - OPEN FILE
	AL = operation
	    00h close file
	    40h open file for reading
	    80h open file for writing
	    C0h open file for random access
	DS:BX -> CR-terminated filename
Return: AL = file handle (00h if file closed or could not be opened)
Note:	the Acorn BBC Master 512 is an 80186-based add-on board for the
	  6502-based Master 128 which uses the original CPU as an I/O processor
SeeAlso: INT 41"Acorn",INT 42"Acorn",INT 43"Acorn",INT 44"Acorn",INT 4C"Acorn"
--------h-40---------------------------------
INT 40 - TI Professional PC - IRQ0
Note:	on the TI Pro, IRQ0 is connected to the same pin on the expansion bus
	  that IBM connects to IRQ2
SeeAlso: INT 0A"IRQ2",INT 41"TI Professional"
--------B-41---------------------------------
INT 41 - SYSTEM DATA - HARD DISK 0 PARAMETER TABLE
Notes:	the default parameter table array is located at F000h:E401h in 100%
	  compatible BIOSes; the pointer may be overridden by the hard disk
	  controller's BIOS to support drive formats unknown to the ROM BIOS
	not used by some PS/2 models
	BIOSes which support four hard drives may store the parameter tables
	  for drives 81h-83h immediately following the parameter table pointed
	  at by INT 41, with a separate copy of the drive 81h table for INT 46.
	  The check for such an arrangement is to test whether INT 46 points
	  somewhere other than exactly 16 bytes past INT 41, and the sixteen
	  bytes starting at offset 10h from INT 41 are identical to the sixteen
	  bytes pointed at by INT 46
SeeAlso: #2828,INT 13/AH=09h,INT 1E,INT 46"HARD DISK 1",INT 60"Adaptec"
SeeAlso: INT C0"AMI"

Format of fixed disk parameters:
Offset	Size	Description	(Table 2828)
 00h	WORD	number of cylinders
 02h	BYTE	number of heads
 03h	WORD	starting reduced write current cylinder (XT only, 0 for others)
 05h	WORD	starting write precompensation cylinder number
 07h	BYTE	maximum ECC burst length (XT only)
 08h	BYTE	control byte (see #2829,#2830)
 09h	BYTE	standard timeout (XT only, 0 for others)
 0Ah	BYTE	formatting timeout (XT and WD1002 only, 0 for others)
 0Bh	BYTE	timeout for checking drive (XT and WD1002 only, 0 for others)
 0Ch	WORD	cylinder number of landing zone (AT and later only)
 0Eh	BYTE	number of sectors per track (AT and later only)
 0Fh	BYTE	reserved
SeeAlso: #0198,#0200

Bitfields for XT fixed disk control byte:
Bit(s)	Description	(Table 2829)
 2-0	drive step speed
	000  3ms
	100  200ms
	101  70ms (default)
	110  3ms
	111  3ms
 5-3	unused
 6	disable ECC retries
 7	disable access retries

Bitfields for AT fixed disk control byte:
Bit(s)	Description	(Table 2830)
 0	unused
 1	reserved (0)  (disable IRQ)
 2	reserved (0)  (no reset)
 3	set if more than 8 heads
 4	always 0
 5	set if manufacturer's defect map on max cylinder+1  (AT and later only)
 6	disable ECC retries
 7	disable access retries
--------h-41---------------------------------
INT 41 - Z100 - Master 8259 - Processor Swap
SeeAlso: INT 40"Z100",INT 42"Z100"
--------h-41---------------------------------
INT 41 - TI Professional PC - IRQ1
Note:	on the TI Pro, IRQ1 is connected to the same pin on the expansion bus
	  that IBM connects to IRQ3
SeeAlso: INT 0B"IRQ3",INT 40"TI Professional",INT 42"TI Professional"
--------O-41---------------------------------
INT 41 - Acorn BBC Master 512 - "OSGBPB" - MULTI-BYTE GET/PUT
	AL = function
	    01h put bytes sequentially
	    02h put bytes, ignoring sequential pointer
	    03h get bytes sequentially
	    04h get bytes, ignoring sequential pointer
	    05h get media title and boot option
	    06h get current device and directory
	    07h get current library and device
	    08h search directory
	DS:BX -> control block (see #2831)
Return: CF clear if successful
	CF set on error
	AL = 00h if operation attempted
	AL unchanged if unsupported function
SeeAlso: INT 40"Acorn",INT 42"Acorn",INT 43"Acorn"

Format of BBC Master control block:
Offset	Size	Description	(Table 2831)
 00h	BYTE	file handle
 01h	DWORD	pointer to data in either I/O processor or Tube processor
 05h	DWORD	number of bytes to be transferred
 09h	DWORD	transfer address
--------G-410000-----------------------------
INT 41 CPU - MS Windows debugging kernel - OUTPUT CHARACTER FOR USER
	AX = 0000h
	DS:DX -> character
Note:	the kernel calls this function when it wants the user program to
	  output a character
SeeAlso: AX=0001h
--------G-410001-----------------------------
INT 41 CPU - MS Windows debugging kernel - INPUT CHARACTER
	AX = 0001h
Return: AL = character
Note:	the kernel calls this function when it needs to input a character
SeeAlso: AX=0000h
--------G-41000D-----------------------------
INT 41 CPU - MS Windows debugging kernel - TASK GOING OUT
	AX = 000Dh
SeeAlso: AX=000Eh
--------G-41000E-----------------------------
INT 41 CPU - MS Windows debugging kernel - TASK COMING IN
	AX = 000Eh
SeeAlso: AX=000Dh
--------G-410012-----------------------------
INT 41 CPU - MS Windows debugging kernel - "OutputDebugString"
	AX = 0012h
	DS:SI -> string (Windows 3.0)
	ES:SI -> string (Windows 3.1)
Return: nothing???
Note:	this function is called by the kernel when it wants to output a
	  string through the debugger
SeeAlso: AX=0050h,INT 68/AH=47h
--------G-41004F-----------------------------
INT 41 CPU - MS Windows debugging kernel - DEBUGGER INSTALLATION CHECK
	AX = 004Fh
Return: AX = F386h if debugger is present
SeeAlso: INT 68/AX=4400h
--------G-410050-----------------------------
INT 41 P - MS Windows debugging kernel - "DefineDebugSegment"
	AX = 0050h
	BX = segment number in executable (0-based)
	CX = selector
	DX = instance handle
	SI = segment flags (0=code, 1=data)
	ES:DI -> module name of owner
Return: ???
SeeAlso: AX=0012h,AX=004Fh
--------G-410051-----------------------------
INT 41 CPU - MS Windows debugging kernel - MOVE SEGMENT
	AX = 0051h
	???
Return: ???
SeeAlso: AX=0050h,AX=0052h
--------G-410052-----------------------------
INT 41 CPU - MS Windows debugging kernel - FREE SEGMENT
	AX = 0052h
	BX = freed selector
SeeAlso: AX=0050h,AX=0051h,AX=005Ch
--------G-410059-----------------------------
INT 41 CPU - MS Windows debugging kernel - LOAD TASK
	AX = 0059h
	???:BX = CS:IP of new task's starting point
--------G-41005C-----------------------------
INT 41 CPU - MS Windows debugging kernel - FREE INITIAL SEGMENT
	AX = 005Ch
	BX = freed selector
Note:	called only when KERNEL starts, once for CS and once for the DS alias
	  to CS
SeeAlso: AX=0052h
--------G-410060-----------------------------
INT 41 CPU - MS Windows debugging kernel -  END OF SEGMENT LOAD
	AX = 0060h
	???
Return: ???
SeeAlso: AX=0061h
--------G-410061-----------------------------
INT 41 CPU - MS Windows debugging kernel - END OF SEGMENT DISCARD
	AX = 0061h
	???
Return: ???
SeeAlso: AX=0060h
--------G-410062-----------------------------
INT 41 CPU - MS Windows debugging kernel - APPLICATION TERMINATING
	AX = 0062h
STACK:	BYTE	exit code
Return: ???
	STACK unchanged???
SeeAlso: AX=0064h
--------G-410063-----------------------------
INT 41 CPU - MS Windows debugging kernel - ASYNCHRONOUS STOP (Ctrl-Alt-SysReq)
	AX = 0063h
--------G-410064-----------------------------
INT 41 CPU - MS Windows debugging kernel - DLL LOADED
	AX = 0064h
	CX:BX = DLL entry point CS:IP
	SI = module handle
SeeAlso: AX=0062h,AX=0065h
--------G-410065-----------------------------
INT 41 CPU - MS Windows debugging kernel - MODULE REMOVED
	AX = 0065h
	ES = module handle
SeeAlso: AX=0064h
--------V-42---------------------------------
INT 42 - VIDEO - RELOCATED DEFAULT INT 10 VIDEO SERVICES (EGA,VGA)
Desc:	contains the address of the original INT 10 handler which an EGA+
	  video adapter replaces with its own on-board BIOS code
SeeAlso: INT 10/AH=00h,INT 10/AH=0Eh,INT 6D"VGA"
Note:	not used by PS/2 built-in VGA or XGA
--------h-42---------------------------------
INT 42 - Z100 - Master 8259 - Timer
SeeAlso: INT 41"Z100",INT 43"Z100"
--------h-42---------------------------------
INT 42 - TI Professional PC - IRQ2
Note:	on the TI Pro, IRQ0 is connected to the same pin on the expansion bus
	  that IBM connects to IRQ4
SeeAlso: INT 0C"IRQ4",INT 41"TI Professional",INT 43"TI Professional"
--------b-42---------------------------------
INT 42 - Western Digital WD1002 SuperBIOS - INT 40 CASCADE
Note:	if the second WD1002 controller in the system finds INT 40 already in
	  use, it uses this vector to cascade to the first controller's BIOS
SeeAlso: INT 40"DISKETTE",INT 47"SuperBIOS"
--------O-42---------------------------------
INT 42 - Acorn BBC Master 512 - "OSBPUT" - WRITE SINGLE BYTE TO FILE
	AL = byte to be written
	BH = file handle
Return: flags destroyed
SeeAlso: INT 40"Acorn",INT 41"Acorn",INT 43"Acorn",INT 47"Acorn",INT 49"Acorn"
--------V-427500-----------------------------
INT 42 U - Toshiba laptops - ???
	AX = 7500h
	BL = ??? (00h or 01h)
Return: ???
Note:	used by Toshiba utility VCHAD.EXE
SeeAlso: AX=7501h,AX=7503h
--------V-427501-----------------------------
INT 42 U - Toshiba laptop - GET ??? DATA
	AX = 7501h
	DS:DI -> data area to be filled ???
Return: area filled with data ???
Note:	used by Toshiba utility VCHAD.EXE
SeeAlso: AX=7500h,AX=7502h,AX=7503h
--------V-427502-----------------------------
INT 42 U - Toshiba laptops - SET ??? DATA
	AX = 7502h
	DS:DI -> data area ???
Return: ???
Note:	used by Toshiba utility VCHAD.EXE
SeeAlso: AX=7501h,AX=7503h
--------V-427503-----------------------------
INT 42 - Toshiba laptops - GET DISPLAY STATUS
	AX = 7503h
Return: AX = 7575h if supported
	CX = 0001h if supported
	BH = display type (00h color, 03h monochrome)
	BL = display state
	    01h internal LCD display is active
	    02h external VGA display is active
	    03h both displays active / DeskStation display mode enabled
		(not possible on all machines)
Note:	used by VCHAD.EXE and supported by all Toshiba VGA laptops until about
	  1994 (string "TOSHIBA " at F000:E010h should be checked before call)
	no longer supported by T21xx series, use INT 10/AX=5F50h instead
	INT 42 normally points to F000:F065h but may be redirected by QEMM386
SeeAlso: AX=7500h,AX=7504h,INT 10/AX=5F50h,INT 15/AH=C0h
--------V-427504-----------------------------
INT 42 U - Toshiba laptops - ???
	AX = 7504h
	BL = ???
Return: BH = ???
Note:	used by Toshiba utility VCHAD.EXE
SeeAlso: AX=7500h,AX=7503h
--------V-43---------------------------------
INT 43 - VIDEO DATA - CHARACTER TABLE (EGA,MCGA,VGA)
Desc:	points at graphics data for characters 00h-7Fh of the current font
	  in 8x8 dot modes, graphics data for all characters in 8x14 and 8x16
	  modes
Note:	this is not a callable vector!
SeeAlso: INT 06"no-name",INT 1F"SYSTEM DATA",INT 44"VIDEO"
--------h-43---------------------------------
INT 43 - Z100 - Master 8259 - Slave 8259 input
Note:	slave runs in special fully nested mode
SeeAlso: INT 42"Z100",INT 44"Z100"
--------h-43---------------------------------
INT 43 - TI Professional PC - IRQ3 - TIMER1 25ms INTERVAL INTERRUPT
SeeAlso: INT 0B"IRQ3",INT 42"TI Professional",INT 44"TI Professional"
SeeAlso: INT 58"TI Professional"
--------O-43---------------------------------
INT 43 - Acorn BBC Master 512 - "OSBGET" - READ SINGLE BYTE FROM FILE
	BH = file handle
Return: CF clear if successful
	    AL = byte read from file
	CF set on error
SeeAlso: INT 40"Acorn",INT 41"Acorn",INT 42"Acorn",INT 46"Acorn"
--------V-44---------------------------------
INT 44 - VIDEO DATA - ROM BIOS CHARACTER FONT, CHARACTERS 00h-7Fh (PCjr)
Desc:	this vector points at graphics data for current character font
SeeAlso: INT 1F"SYSTEM DATA",INT 43"VIDEO"
--------N-44---------------------------------
INT 44 - Novell NetWare - HIGH-LEVEL LANGUAGE API
--------I-44---------------------------------
INT 44 - IBM 3270-PC High Level Language API
	DS:SI -> parameter control block
--------h-44---------------------------------
INT 44 - Z100 - Master 8259 - Serial A
SeeAlso: INT 43"Z100",INT 45"Z100"
--------h-44---------------------------------
INT 44 - TI Professional PC - IRQ4
Note:	on the TI Pro, IRQ4 is connected to the same pin on the expansion bus
	  that IBM connects to IRQ5
SeeAlso: INT 0D"IRQ5",INT 43"TI Professional",INT 45"TI Professional"
--------v-44---------------------------------
INT 44 - VIRUS - "Lehigh" - ORIGINAL INT 21h VECTOR
SeeAlso: INT 32"VIRUS",INT 60"VIRUS",INT 70"VIRUS",INT 9E"VIRUS"
--------O-4400-------------------------------
INT 44 - Acorn BBC Master 512 - "OSARGS" - GET/SET FILE PARAMS FOR OPEN FILE
	AH = 00h
	AL = function
	    00h get current filing system
		Return: AL = filing system (see #2832)
	    01h get address of commandline tail
		Return: BX buffer filled with address of command tail in I/O
			      processor address space (use INT 4A/AL=05h to
			      retrieve)
	    FFh flush all files onto secondary storage
	BX -> 4-byte data buffer
Note:	the commandline tail is terminated with a carriage return (0Dh)
SeeAlso: INT 40"Acorn",INT 45"Acorn"

(Table 2832)
Values for BBC Master filing system:
 00h	none
 01h	1200 bps cassette
 02h	300 bps cassette
 03h	ROM FS
 04h	DFS
 05h	ANFS/NFS
 06h	TFS
 08h	ADFS
--------O-44---------------------------------
INT 44 - Acorn BBC Master 512 - "OSARGS" - GET/SET FILE PARAMS FOR OPEN FILE
	AH = nonzero file handle
	AL = function
	    00h get sequential pointer for file
	    01h set sequential pointer for file
	    02h get length of file
	BX -> 4-byte data buffer
Return: BX buffer updated if appropriate
SeeAlso: INT 40"Acorn",INT 41"Acorn",INT 44/AH=00h,INT 45"Acorn",INT 4A"Acorn"
--------h-45---------------------------------
INT 45 - Z100 - Master 8259 - Serial B
SeeAlso: INT 44"Z100",INT 46"Z100"
--------h-45---------------------------------
INT 45 - TI Professional PC - IRQ5
Note:	on the TI Pro, IRQ5 is connected to the same pin on the expansion bus
	  that IBM connects to IRQ6
SeeAlso: INT 0E"IRQ6",INT 44"TI Professional",INT 46"TI Professional"
--------O-45---------------------------------
INT 45 - Acorn BBC Master 512 - "OSFILE" - READ/WRITE FILE OR DIRECTORY INFO
	AL = function
	    00h save block of memory as file
	    01h update directory entry for existing file
	    02h set load address for existing file
	    03h set execution address for existing file
	    04h set attributes for existing file
	    05h read directory
	    06h delete file
	    FFh load file
	DS:BX -> control block (see #2833)
Return: FLAGS destroyed
	AL = file type
	    00h not found
	    01h file found
	    02h directory found
	    FFh protected file
SeeAlso: INT 40"Acorn",INT 41"Acorn",INT 44"Acorn",INT 46"Acorn"

Format of BBC Master control block:
Offset	Size	Description	(Table 2833)
 00h	WORD	address of CR-terminated filename
 02h	DWORD	load address of file
 06h	DWORD	execution address of file
 0Ah	DWORD	start address of data to save
 0Eh	DWORD	end address of data to save, or file attributes
		file attributes in low byte (see #2834)
		other three bytes are filing-system specific file attributes

Bitfields for BBC Master file attributes:
Bit(s)	Description	(Table 2834)
 0	no owner read access
 1	no owner write access
 2	not executable by owner
 3	not deletable by owner
 4	no public read access
 5	no public write access
 6	not executable with public access
 7	not deletable with public access
--------B-46---------------------------------
INT 46 - SYSTEM DATA - HARD DISK 1 DRIVE PARAMETER TABLE
Note:	not used by some PS/2 models
SeeAlso: INT 13/AH=09h,INT 41"HARD DISK 0",INT 60"Adaptec",INT C0"AMI"
--------h-46---------------------------------
INT 46 - Z100 - Master 8259 - Keyboard, Retrace, and Light Pen
SeeAlso: INT 45"Z100",INT 47"Z100"
--------h-46---------------------------------
INT 46 - TI Professional PC - IRQ6 - FLOPPY DISK CONTROLLER
Note:	on the TI Pro, IRQ6 is connected to the same pin on the expansion bus
	  that IBM connects to IRQ7
SeeAlso: INT 0F"IRQ7",INT 45"TI Professional",INT 47"TI Professional"
--------O-46---------------------------------
INT 46 - Acorn BBC Master 512 - "OSRDCH" - GET CHARACTER FROM CUR INPUT STREAM
Return: CF clear if successful
	    AL = character read
	CF set on error
	    AL = error code
SeeAlso: INT 40"Acorn",INT 43"Acorn",INT 47"Acorn",INT 49"Acorn"
--------h-47---------------------------------
INT 47 - Z100 - Master 8259 - Printer
SeeAlso: INT 46"Z100",INT 48"Z100"
--------h-47---------------------------------
INT 47 - TI Professional PC - IRQ7 - KEYBOARD USART
SeeAlso: INT 09"IRQ1",INT 46"TI Professional"
--------O-47---------------------------------
INT 47 - Acorn BBC Master 512 - "OSWRCH" - WRITE CHARACTER TO CUR OUTPUT STREAM
	AL = character to be written
Return: FLAGS destroyed
SeeAlso: INT 40"Acorn",INT 46"Acorn",INT 49"Acorn"
--------b-47---------------------------------
INT 47 - Western Digital WD1002-27X SuperBIOS - INT 40 CASCADE
Desc:	used by the second WD1002-27X controller to cascade to the first
	  controller's INT 40
SeeAlso: INT 40"DISKETTE",INT 42"SuperBIOS",INT 48"SuperBIOS"
----------478000-----------------------------
INT 47 - SQL Base - DATABASE ENGINE API
	AX = 8000h
	DS:BX -> parameter block, first word is function number (see #2835)
Program: SQL Base is a network-oriented database engine by Gupta Technologies
SeeAlso: AX=8001h

(Table 2835)
Values for SQL Base function number:
 01h	"SQLFINI" initalialize application's use of the database
 02h	"SQLFDON" application is done using the database
 03h	"SQLFCON" connect to a cursor/database
 04h	"SQLFDIS" disconnect from a cursor/database
 05h	"SQLFCOM" compile a SQL command
 06h	"SQLFEXE" execute a SQL command
 07h	"SQLFCEX" compile and execute a SQL command
 08h	"SQLFCMT" commit a transaction to the database
 09h	"SQLFDES" describe the items of a SELECT statement
 0Ah	"SQLFGFI" get fetch information
 0Bh	"SQLFFBK" fetch previous result row from SELECT statement
 0Ch	"SQLFFET" fetch next result row from SELECT statement
 0Dh	"SQLFEFB" enable fetch backwards
 0Eh	"SQLFPRS" position in result set
 0Fh	"SQLFURS" undo result set
 10h	"SQLFNBV" get number of bind variables
 11h	"SQLFBND" bind data variables
 12h	"SQLFBNN" bind numerics
 13h	"SQLFBLN" bind long number
 14h	"SQLFBLD" bind long data variables
 15h	"SQLFSRS" start restriction set processing
 16h	"SQLFRRS" restart restriction set processing
 17h	"SQLFCRS" close restriction set
 18h	"SQLFDRS" drop restriction set
 19h	"SQLFARF" apply Roll Forward journal
 1Ah	"SQLFERF" end Roll Forward journal
 1Bh	"SQLFSRF" start Roll Forward journal
 1Ch	"SQLFSTO" store a compiled SQL command
 1Dh	"SQLFRET" retrieve a compiled SQL command
 1Eh	"SQLFDST" drop a stored command
 1Fh	"SQLFCTY" get command type
 20h	"SQLFEPO" get error position
 21h	"SQLFGNR" get number of rows
 22h	"SQLFNSI" get number of select items
 23h	"SQLFRBF" get Roll Back flag
 24h	"SQLFRCD" get return code
 25h	"SQLFROW" get number of ROWs
 26h	"SQLFSCN" set cursor name
 27h	"SQLFSIL" set isolation level
 28h	"SQLFSLP" set log parameters
 29h	"SQLFSSB" set select buffer
 2Ah	"SQLFSSS" set sort space
 2Bh	"SQLFRLO" read long
 2Ch	"SQLFWLO" write long
 2Dh	"SQLFLSK" long seek
 2Eh	"SQLFGLS" get long size
 2Fh	"SQLFELO" end long operation
 30h	"SQLFRBK" roll back a transaction from the database
 31h	"SQLFERR" error message
 32h	"SQLFCPY" copy
 33h	"SQLFR01" reserved
 34h	"SQLFSYS" system
 35h	"SQLFSTA" statistics
 36h	"SQLFR02" reserved
 37h	"SQLFXAD" extra add
 38h	"SQLFXCN" extra character to number
 39h	"SQLFXDA" extra date add
 3Ah	"SQLFXDP" extra date picture
 3Bh	"SQLFXDV" extra divide
 3Ch	"SQLFXML" extra multiply
 3Dh	"SQLFXNP" extra number picture
 3Eh	"SQLFXPD" extra picture date
 3Fh	"SQLFXSB" extra subtract
 40h	"SQLFINS" install database
 41h	"SQLFDIN" deinstall database
 42h	"SQLFDIR" directory of databases
 43h	"SQLFTIO" timeout
 44h	"SQLFFQN" get fully qualified column name
 45h	"SQLFEXP" explain execution plan
 46h	"SQLFFER" get full error
 47h	"SQLFBKP" begin online backup
 48h	"SQLFRDC" read backup data chunk
 49h	"SQLFEBK" end backup
 4Ah	"SQLFRES" begin restore from backup
 4Bh	"SQLFWDC" write backup data chunk for restore
 4Ch	"SQLFRRD" recover restored database to consistent state
 4Dh	"SQLFERS" end restore
 4Eh	"SQLFNRR" return number of result set rows
 4Fh	"SQLFSTR" start restriction mode
 50h	"SQLFSPR" stop restriction mode
 51h	"SQLFCNC" connect 2
 52h	"SQLFCNR" connect with no recovery
 53h	"SQLFOMS" set output message size
 54h	"SQLFIMS" set input message size
 55h	"SQLFSCP" set cache pages
 56h	"SQLFDSC" describe items of a SELECT statement (external)
 57h	"SQLFLAB" get label info for items in SELECT statement
 58h	"SQLFCBV" clear bind variables
 59h	"SQLFGET" get database information
 5Ah	"SQLFSET" set database information
 5Bh	"SQLFTEC" translate error code
----------478001-----------------------------
INT 47 - SQL Base - GET VERSION NUMBER
	AX = 8001h
Return: ???
Program: SQL Base is a network-oriented database engine by Gupta Technologies
SeeAlso: AX=8000h
--------B-48---------------------------------
INT 48 - KEYBOARD - CORDLESS KEYBOARD TRANSLATION (PCjr)
SeeAlso: INT 49"PCjr"
--------h-48---------------------------------
INT 48 - Z100 - Slave 8259 - S100 vectored line 0
SeeAlso: INT 47"Z100",INT 49"Z100"
--------N-48---------------------------------
INT 48 - Watstar PC Network data pointer 1
SeeAlso: INT 49"Watstar"
--------O-48---------------------------------
INT 48 - Acorn BBC Master 512 - "OSNEWL" - SEND NEWLINE TO OUTPUT STREAM
Return: FLAGS destroyed
Note:	writes a carriage return (0Dh) followed by a linefeed (0Ah)
SeeAlso: INT 40"Acorn",INT 47"Acorn",INT 49"Acorn"
--------b-48---------------------------------
INT 48 - Western Digital WD1002-27X SuperBIOS - DRIVE DATA (NOT A VECTOR!)
Note:	the second WD1002-27X controller in a system uses the low byte to
	  store the number of drives controlled by the second controller,
	  and the high word for temporary storage during track recalculation;
	  the first controller uses offsets 74h-77h in the BIOS data area
	  (refer to MEMORY.LST) to store data
SeeAlso: INT 47"SuperBIOS"
--------V-48---------------------------------
INT 48 U - Compaq UILIB.EXE - API
	AX = function (see #2836)
	BX = call type (0002h) (see #2839)
	???
Return: ???
Note:	returns AX=FFFFh if 1000h<=AX<=2000h and AX is not one of the functions
	  listed below
SeeAlso: AX=1A70h

(Table 2836)
Values for valid UILIB function number:
 1000h	1160h	12D0h	1430h	1570h	1680h	17F0h	1920h	1A90h
 1010h	1170h	12E0h	1440h	1578h	1690h	1800h	1930h	1AA0h
 1020h	1180h	12F0h	1450h	1580h	16A0h	1810h	1940h
 1030h	1190h	1300h	1460h	1590h	16B0h	1820h	1950h
 1040h	11A0h	1310h	1470h	1594h	16C0h	1830h	1960h
 1050h	11B0h	1320h	1480h	1598h	16D0h	1840h	1970h
 1060h	11C0h	1330h	1490h	15A0h	16E0h	1848h	1980h
 1070h	11D0h	1340h	14A0h	15B0h	16F0h	1850h	1990h
 1080h	11E0h	1350h	14B0h	15C0h	1700h	1860h	19A0h
 1090h	11F0h	1360h	14B8h	15D0h	1710h	1870h	19B0h
 1095h	1200h	1370h	14BBh	15D4h	1720h	1878h	19C0h
 1098h	1210h	1380h	14C0h	15D8h	1730h	1880h	19D0h
 10A0h	1220h	1390h	14D0h	15E0h	1735h	1890h	19E0h
 10C0h	1230h	13A0h	14E0h	15F0h	1740h	1898h	19F0h
 10D0h	1240h	13B0h	14F0h	1600h	1750h	18A0h	1A00h
 10E0h	1250h	13B8h	1500h	1610h	1770h	18B0h	1A10h
 10F0h	1260h	13C0h	1508h	1620h	1780h	18C0h	1A20h
 1100h	1270h	13D0h	1510h	1630h	1790h	18D0h	1A30h
 1110h	1280h	13E0h	1520h	1640h	17A0h	18E0h	1A40h
 1120h	1290h	13F0h	1530h	1650h	17B0h	18F0h	1A50h
 1130h	12A0h	1400h	1540h	1660h	17C0h	1900h	1A60h
 1140h	12B0h	1410h	1550h	1664h	17D0h	1909h	1A70h
 1150h	12C0h	1420h	1560h	1670h	17E0h	1910h	1A80h
--------b-4800-------------------------------
INT 48 - TI Professional PC - SPEAKER DEVICE - SOUND SPEAKER
	AH = 00h
	AL = number of 25ms ticks sound should last
Return: nothing
Desc:	sound the speaker at the current frequency setting (see AH=02h) for
	  the indicated duration
Notes:	this function returns immediately; the sound is terminated by the
	  timer interrupt handler
	if a new sound is requested while one is already in progress, the
	  previous sound is terminated immediately and the new sound takes
	  its place
SeeAlso: AH=01h,AH=02h,AH=03h,AH=04h,AH=06h,AH=08h,AH=0Ah,AH=0Bh
SeeAlso: INT 40"TI Professional",INT 49/AH=01h"TI"
SeeAlso: INT 4A/AH=00h"TI",INT 4C"TI Professional",INT 4D/AH=00h
--------b-4801-------------------------------
INT 48 - TI Professional PC - SPEAKER DEVICE - CHECK SPEAKER STATUS
	AH = 01h
Return: ZF clear if speaker is currently on
	ZF set if speaker is currently off
SeeAlso: AH=00h,AH=02h,AH=03h,AH=04h,AH=06h,AH=08h,AH=0Ah,AH=0Bh
--------b-4802-------------------------------
INT 48 - TI Professional PC - SPEAKER DEVICE - SET SPEAKER FREQUENCY
	AH = 02h
	CX = frequency divisor (freq = 1250000 / CX)
Return: nothing
SeeAlso: AH=00h,AH=01h,AH=03h,AH=04h,AH=06h,AH=08h,AH=0Ah,AH=0Bh
--------b-4803-------------------------------
INT 48 - TI Professional PC - SPEAKER DEVICE - TURN ON SPEAKER
	AH = 03h
Return: nothing
Desc:	turn on the speaker at the current frequency, leaving it on until
	  explicitly turned off with AH=04h or the end of a subsequent
	  AH=00h
SeeAlso: AH=00h,AH=01h,AH=02h,AH=04h,AH=06h,AH=08h,AH=0Ah,AH=0Bh
--------b-4804-------------------------------
INT 48 - TI Professional PC - SPEAKER DEVICE - TURN OFF SPEAKER
	AH = 04h
Return: nothing
SeeAlso: AH=00h,AH=01h,AH=02h,AH=03h,AH=04h,AH=06h,AH=08h,AH=0Ah,AH=0Bh
--------b-4805-------------------------------
INT 48 - TI Professional PC - SPEAKER DEVICE - DELAY
	AH = 05h
	CX = desired delay in milliseconds
Return: after delay expires
Note:	the delay is only approximate, and may be longer than requested
SeeAlso: AH=00h,AH=01h,AH=02h,AH=03h,AH=04h,AH=06h,AH=08h,AH=0Ah,AH=0Bh
--------b-4806-------------------------------
INT 48 - TI Professional PC - CALCULATE CRC
	AH = 06h
	ES:BX -> memory block for which to calculate CRC
	BP = size of block in bytes
Return: DX = CRC for block
	ZF set if DX = 0000h
Note:	if the CRC of a memory block is appended to the block, then the CRC
	  of the block plus CRC should equal 0000h
SeeAlso: AH=00h,AH=01h,AH=02h,AH=03h,AH=04h,AH=06h,AH=08h,AH=0Ah,AH=0Bh
--------b-4807-------------------------------
INT 48 - TI Professional PC - PRINT ROM MESSAGE
	AH = 07h
	SI = offset of ASCIZ message string within segment F400h
Return: nothing
SeeAlso: AH=00h,AH=01h,AH=02h,AH=03h,AH=04h,AH=06h,AH=08h,AH=0Ah,AH=0Bh
--------b-4808-------------------------------
INT 48 - TI Professional PC - DISPLAY SYSTEM ERROR MESSAGE
	AH = 08h
	BX = error number
Return: nothing
Desc:	displays the error message " ** System Error ** - xxxx" where xxxx is
	  the hexadecimal value in BX
SeeAlso: AH=00h,AH=01h,AH=02h,AH=03h,AH=04h,AH=06h,AH=08h,AH=0Ah,AH=0Bh
--------b-4809-------------------------------
INT 48 - TI Professional PC - GET SYSTEM CONFIGURATION DATA
	AH = 09h
Return: ES:BX -> system configuration word (see #2859)
SeeAlso: AH=00h,AH=01h,AH=02h,AH=03h,AH=04h,AH=06h,AH=08h,AH=0Ah,AH=0Bh
--------b-480A-------------------------------
INT 48 - TI Professional PC - GET EXTRA SYSTEM CONFIGURATION INFO ADDRESS
	AH = 0Ah
Return: ES:BX -> configuration information (see #2837)
SeeAlso: AH=00h,AH=01h,AH=02h,AH=03h,AH=04h,AH=06h,AH=08h,AH=0Bh

Format of TI Professional PC extra system configuration information:
Offset	Size	Description	(Table 2837)
 -3	WORD	memory size in paragraphs
 00h	BYTE	drive type byte (see #2838)
 01h	WORD	extra system configuration word 1
		bit 0: 8087 is present
		bits 15-1: reserved (0)
 03h	WORD	extra system configuration word 2
		bits 15-0: reserved (0)

Bitfields for TI Professional PC drive type byte:
Bit(s)	Description	(Table 2838)
 0	drive A is double-sided
 1	drive A has 80 tracks instead of 40
 2	drive B is double-sided
 3	drive B has 80 tracks instead of 40
 4	drive C is double-sided
 5	drive C has 80 tracks instead of 40
 6	drive D is double-sided
 7	drive D has 80 tracks instead of 40
Note:	the type for drive A is determined by motherboard switches; the
	  remaining drives' types are set from a table in IO.SYS
SeeAlso: #2837
--------b-480B-------------------------------
INT 48 - TI Professional PC - GET EXTRA SYSTEM CONFIGURATION INFORMATION
	AH = 0Bh
Return: AL = drive type byte (see #2838)
	BX = extra system configuration word 1 (see #2837)
	CX = extra system configuration word 2 (see #2837)
	AH destroyed
SeeAlso: AH=00h,AH=01h,AH=02h,AH=03h,AH=04h,AH=06h,AH=08h,AH=0Ah
--------V-481A70-----------------------------
INT 48 U - Compaq UILIB.EXE - INSTALLATION CHECK
	AX = 1A70h
	BX = call type (see #2839)
Return: CX = 5649h ('VI') if installed
	DX = 4557h ('EW') if installed
	    AX = version??? (0106h)

(Table 2839)
Values for UILIB call type:
 0000h	near
 0001h	far
 0002h	INT (only valid call type when using INT 48)
 0003h	near
--------B-49---------------------------------
INT 49 - SYSTEM DATA - NON-KEYBOARD SCAN-CODE TRANSLATION TABLE (PCjr)
SeeAlso: #2840,INT 48"PCjr"

Format of PCjr scan-code translation table:
Offset	Size	Description	(Table 2840)
 00h	BYTE	number of non-keyboard scancodes in the table
 01h  N WORDs	high byte 00h (NUL) byte scancode with low order byte
		  representing the scancode mapped values relative to their
		  input values within the range of 56h through 7Eh
--------h-49---------------------------------
INT 49 - Z100 - Slave 8259 - S100 vectored line 1
SeeAlso: INT 48"Z100",INT 4A"Z100"
--------N-49---------------------------------
INT 49 - Watstar PC Network data pointer 2
SeeAlso: INT 48"Watstar"
--------O-49---------------------------------
INT 49 - Acorn BBC Master 512 - "OSASCI" - WRITE CHARACTER TO CUR OUTPUT STREAM
	AL = character to be written
Return: FLAGS destroyed
Note:	converts carriage return (0Dh) into CRLF sequence (0Dh 0Ah)
SeeAlso: INT 40"Acorn",INT 46"Acorn",INT 47"Acorn",INT 48"Acorn"
--------b-49---------------------------------
INT 49 - Tandy 2000 - BOOTSTRAP LOADER
Note:	this interrupt is identical to INT 19
SeeAlso: INT 19,INT 4A"Tandy 2000",INT 4C"Tandy 2000",INT 51"Tandy 2000"
--------a-490001-----------------------------
INT 49 - MAGic v1.16+ - TURN ON MAGNIFICATION
	AX = 0001h
Return: AX = status (see #2841)
	BX,CX,DX destroyed
Program: MAGic (MAGnification In Color) is a TSR by Microsystems Software, Inc.
	  providing 2x2 text and graphics magnification on VGA, XGA, and SVGA
Note:	INT 49 is the default, but may be overridden on the commandline.  The
	  actual interrupt in use may be found by searching for the signature
	  "MAGic" or "xMAGic" (for the deluxe version) immediately preceding
	  the interrupt handler (this is also the installation check).	MAGic
	  uses CodeRunneR, which places the signature "RT" at offset 0000h in
	  the interrupt handler's segment, followed by MAGic's TSR ID of
	  "VMAG".
SeeAlso: AX=0002h,AX=0003h,AX=0004h,AX=0008h
Index:	installation check;MAGic

(Table 2841)
Values for MAGic status:
 0000h	cannot magnify current video mode
 0002h	magnified (text mode)
 0003h	magnified (graphics mode)
 FFFDh	function works only in magnified mode
 FFFFh	MAGic busy, retry later
--------a-490002-----------------------------
INT 49 - MAGic v1.16+ - TURN OFF MAGNIFICATION
	AX = 0002h
Return: AX = status (see #2841)
	BX,CX,DX destroyed
SeeAlso: AX=0001h
--------a-490003-----------------------------
INT 49 - MAGic v1.16+ - SHIFT MAGNIFIED WINDOW TO INCLUDE SPECIFIED LOCATION
	AX = 0003h
	BX = vertical position (character row [text] or pixel row [graphics])
	DX = horizontal position (char column [text] or 8-pixel units [gr])
Return: AX = status
	    0000h successful
	    FFFFh MAGic busy, retry later
	BX,CX,DX destroyed
Note:	window is not moved if the position is inside the current window
SeeAlso: AX=0001h,AX=0004h,AX=0005h
--------a-490004-----------------------------
INT 49 - MAGic v1.16+ - REPOSITION MAGNIFIED WINDOW
	AX = 0004h
	BX = vertical position of upper left corner
	DX = horizontal position
Return: AX = status (see AX=0003h)
	BX,CX,DX destroyed
SeeAlso: AX=0001h,AX=0003h,AX=0005h
--------a-490005-----------------------------
INT 49 - MAGic v1.16+ - GET POSITION OF MAGNIFIED WINDOW
	AX = 0005h
Return: AX = status
	    0000h successful
		BX = vertical position (char row or pixel row)
		DX = horizontal position (char column or 8-pixel units)
	    FFFFh MAGic busy, retry later
		BX,DX destroyed
	CX destroyed
SeeAlso: AX=0001h,AX=0003h,AX=0004h,AX=0006h,AX=0007h
--------a-490006-----------------------------
INT 49 - MAGic v1.16+ - GET SIZE OF FULL SCREEN
	AX = 0006h
Return: AX = status
	    0000h successful
		BX = vertical size (char rows or pixel rows)
		DX = horizontal size (char cols or 8-pixel units)
	    FFFFh MAGic busy, retry later
		BX,DX destroyed
	CX destroyed
SeeAlso: AX=0001h,AX=0005h,AX=0007h
--------a-490007-----------------------------
INT 49 - MAGic v1.16+ - GET SIZE OF MAGNIFICATION WINDOW
	AX = 0007h
Return: AX = status
	    0000h successful
		BX = vertical size (char rows or pixel rows)
		DX = horizontal size (char cols or 8-pixel units)
	    FFFEh invalid function
	    FFFFh MAGic busy, retry later
		BX,DX destroyed
	CX destroyed
BUG:	in v1.16 and v1.17, this function is not recognized as valid, but
	  AX=0000h is accepted and will branch into hyperspace
SeeAlso: AX=0001h,AX=0006h
--------a-490008-----------------------------
INT 49 - MAGic v1.23+ - SET TEXT MODE MAGNIFICATION SIZE
	AX = 0008h
	BX = scaling factor (01h=1.4 times, 02h, 04h, 06h, 08h, 09h=12 times)
Return: AX = status
	    0000h successful
	    FFFBh scaling factor only available in MAGic Deluxe
	    FFFCh already in magnified state, can't set size
Notes:	this call specifies the amount a subsequent call to AX=0001h should
	  magnify the display
	scaling factors greater than 2 are only available in MAGic Deluxe
SeeAlso: AX=0001h
--------V-4901-------------------------------
INT 49 - TI Professional PC - CRT - SET CURSOR SIZE AND TYPE
	AH = 01h
	CH = cursor start line (bits 3-0) and status (bits 6-5)
	    status bits:
		00 non-blinking cursor
		01 no cursor
		10 fast-blinking cursor
		11 slow-blinking cursor
	CL = cursor end line
Return: nothing
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=02h,AH=03h,INT 40"TI Professional",INT 48/AH=00h"TI Professional"
SeeAlso: INT 4A/AH=00h"TI",INT 4B"TI Professional",INT 4D/AH=00h
SeeAlso: INT 57"TI Professional"
--------V-4902-------------------------------
INT 49 - TI Professional PC - CRT - SET CURSOR POSITION
	AH = 02h
	DH = column
	DL = row
Return: DX destroyed
Notes:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
	the TI swaps the row and column compared to the equivalent IBM call
SeeAlso: AH=01h,AH=03h
--------V-4903-------------------------------
INT 49 - TI Professional PC - CRT - GET CURSOR POSTION AND TYPE
	AH = 03h
Return: CH = cursor start and status (see AH=01h)
	CL = cursor end line
	DH = cursor column
	DL = cursor row
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=01h,AH=02h
--------V-4906-------------------------------
INT 49 - TI Professional PC - CRT - SCROLL UP/COPY WINDOW
	AH = 06h
	AL = source blanking
	    00h blank source region (move/scroll)
	    nonzero do not blank source region (copy)
	DH,DL = source start column,row
	BH,BL = destination start column,row
	CH = width of region to move/copy
	CL = height of region to move/copy
Return: nothing
Notes:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
	the specified region may be wider than the screen, but reliable
	  operation then requires that the height be exactly one row
SeeAlso: AH=01h,AH=02h,AH=07h,AH=13h,AH=14h
--------V-4907-------------------------------
INT 49 - TI Professional PC - CRT - SCROLL DOWN/COPY WINDOW
	AH = 07h
	AL = source blanking
	    00h blank source region (move/scroll)
	    nonzero do not blank source region (copy)
	DH,DL = source start column,row
	BH,BL = destination start column,row
	CH = width of region to move/copy
	CL = height of region to move/copy
Return: nothing
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=01h,AH=02h,AH=06h,AH=13h,AH=14h
--------V-4908-------------------------------
INT 49 - TI Professional PC - CRT - GET CHARACTER AND ATTRIBUTE AT POSITION
	AH = 08h
Return: AL = character at current cursor position
	AH = attribute
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=01h,AH=09h,AH=0Ah,AH=0Eh,INT 10/AH=08h
--------V-4909-------------------------------
INT 49 - TI Professional PC - CRT - WRITE CHARACTER(S) WITH ATTRIBUTE
	AH = 09h
	AL = character to write
	BL = attribute to use (becomes new current attribute)
	CX = number of times to write character
Return: nothing
Desc:	write CX copies of the character in AL beginning at the current cursor
	  position
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=01h,AH=08h,AH=0Ah,AH=0Eh,INT 10/AH=09h
--------V-490A-------------------------------
INT 49 - TI Professional PC - CRT - WRITE CHARACTER(S) WITH CURRENT ATTRIBUTE
	AH = 0Ah
	AL = character to write
	CX = number of times to write character
Return: nothing
Desc:	write CX copies of the character in AL beginning at the current cursor
	  position
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=01h,AH=02h,AH=08h,AH=09h,AH=0Eh,INT 10/AH=0Ah
--------V-490E-------------------------------
INT 49 - TI Professional PC - CRT - TTY OUTPUT
	AH = 0Eh
	AL = character to write
Return: nothing
Desc:	write the character in AL at the current cursor position, advancing
	  the cursor, and interpreting CR, LF, TAB, and BEL characters
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=01h,AH=02h,AH=08h,AH=09h,AH=0Ah,INT 10/AH=0Eh
--------V-4910-------------------------------
INT 49 - TI Professional PC - CRT - WRITE BLOCK OF CHARACTERS WITH ATTRIBUTE
	AH = 10h
	AL = attribute (becomes new current attribute)
	DX:BX -> string of characters to write
	CX = length of string
Return: nothing
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
BUG:	CX must not be 0000h on entry, or the system will crash
SeeAlso: AH=01h,AH=02h,AH=09h,AH=0Eh,AH=11h
--------V-4911-------------------------------
INT 49 - TI Professional PC - CRT - WRITE BLOCK OF CHARACTERS WITH CURR ATTRIB
	AH = 11h
	DX:BX -> string of characters to write
	CX = length of string
Return: nothing
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
BUG:	CX must not be 0000h on entry, or the system will crash
SeeAlso: AH=01h,AH=02h,AH=09h,AH=0Eh,AH=10h
--------V-4912-------------------------------
INT 49 - TI Professional PC - CRT - FILL ENTIRE SCREEN WITH ATTRIBUTE
	AH = 12h
	AL = attribute (see #2842)
Return: nothing
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=01h,AH=02h

Bitfields for TI Professional PC screen attribute:
Bit(s)	Description	(Table 2842)
 7	alternate character set (requires user-supplied ROM)
 6	blink
 5	underline
 4	reverse video
 3	character enable
 2	green (color) or 58% intensity (gray-scale)
 1	red (color)  or 27.5% intensity
 0	blue (color) or 14.5% intensity
--------V-4913-------------------------------
INT 49 - TI Professional PC - CRT - CLEAR ENTIRE TEXT SCREEN AND HOME CURSOR
	AH = 13h
Return: nothing
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=01h,AH=02h,AH=06h,AH=14h
--------V-4914-------------------------------
INT 49 - TI Professional PC - CRT - CLEAR ENTIRE GRAPHICS SCREEN
	AH = 14h
Return: nothing
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=01h,AH=02h,AH=06h,AH=13h
--------V-4915-------------------------------
INT 49 - TI Professional PC - CRT - SET PROTECTED STATUS AREA
	AH = 15h
	CL = row at which to start status area, or 00h to cancel
	CH = 00h
Return: nothing
Desc:	set a protected area of the screen which will not be affected by TTY
	  writes or the scrolls they may generate
Notes:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
	the current cursor position must be above the status area in order to
	  set the protected area
SeeAlso: AH=01h,AH=02h
--------V-4916-------------------------------
INT 49 - TI Professional PC - CRT - SET ATTRIBUTE LATCH
	AH = 16h
	BL = new attribute (see #2842)
Return: nothing
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=01h,AH=02h
--------V-4917-------------------------------
INT 49 - TI Professional PC - CRT - GET START-OF-DISPLAY POINTER
	AH = 17h
Return: DX = current offset at which display starts
Note:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
SeeAlso: AH=01h,AH=02h,INT 10/AH=FEh
--------V-4918-------------------------------
INT 49 - TI Professional PC - CRT - PRINT TTY STRING
	AH = 18h
	CS:BX -> counted string (count byte with length followed by string)
Return: nothing
Notes:	AH=00h,04h,05h,0Bh,0Ch,0Dh,0Fh are documented as NOPs
	the string must be located in the caller's code segment; any TSRs
	  which want to hook INT 49 must check for this function and emulate
	  it, because the BIOS retrieves the caller's CS from the stack
SeeAlso: AH=01h,AH=02h,AH=0Eh
--------B-4A---------------------------------
INT 4A C - SYSTEM - USER ALARM HANDLER
Desc:	This interrupt is invoked by the BIOS when a real-time clock alarm
	  occurs; an application may use it to perform an action at a
	  predetermined time.
Note:	this interrupt is called from within a hardware interrupt handler,
	  so all usual precautions against reentering DOS must be taken
SeeAlso: INT 1A/AH=06h
--------h-4A---------------------------------
INT 4A - Z100 - Slave 8259 - S100 vectored line 2
SeeAlso: INT 49"Z100",INT 4B"Z100"
--------b-4A---------------------------------
INT 4A - Tandy 2000 - PRINT SCREEN
Note:	this interrupt is identical to INT 05
SeeAlso: INT 05"PRINT SCREEN"
--------O-4A---------------------------------
INT 4A - Acorn BBC Master 512 - "OSWORD" - MISC FUNCTIONS USING CONTROL BLOCK
	AL = function code
	    FAh transfer data between 80186 and 65C12 I/O processor
	DS:BX -> control block (see #2843)
Return: FLAGS destroyed
	control block updated
Note:	there are more functions than are listed here, but details are not
	  available
SeeAlso: INT 40"Acorn",INT 4B"Acorn",INT 4C"Acorn"

Format of BBC Master control block for function FAh:
Offset	Size	Description	(Table 2843)
 00h	BYTE	number of parameters sent to I/O processor (0Dh,0Eh)
 01h	BYTE	number of parameters read from I/O processor (01h)
 02h	DWORD	I/O processor address
 06h	DWORD	80186 segment:offset address
 0Ah	WORD	number of bytes to transfer
 0Ch	BYTE	operation type
		00h write to 65C12 at 24 us/byte
		01h read from 65C12 at 24 us/byte
		02h write to 65C12 at 26 us/word
		03h read from 65C12 at 26 us/word
		04h write to 65C12 at 10 us/byte using 256-byte blocks
		05h read from 65C12 at 10 us/byte using 256-byte blocks
 0Dh	BYTE	65C12 memory access control (only used if offset 00h = 0Eh)
		(see #2844)

Bitfields for 65C12 memory access control:
Bit(s)	Description	(Table 2844)
 7	unused
 6	always use main screen memory if I/O addr 3000h-7FFFh (overrides bit 5)
 5	use shadow screen memory if screen address specified
 4	use current ROM rather than ROM selected by bits 3-0 (only if I/O
	  address between 8000h and BFFFh)
 3-0	paged ROM number
--------b-4A00-------------------------------
INT 4A - TI Professional PC - KEYBOARD - GET KEYPRESS
	AH = 00h
Return: AX = keystroke (AH=00h for ASCII keys -- no scan code)
SeeAlso: AH=01h,AH=02h,AH=03h,AH=04h,AH=05h,INT 16/AH=00h
SeeAlso: INT 47"TI Professional",INT 48/AH=00h"TI Professional"
SeeAlso: INT 49/AH=01h"TI",INT 4C"TI Professional",INT 4D/AH=00h
SeeAlso: INT 5B"TI Professional"
--------b-4A01-------------------------------
INT 4A - TI Professional PC - KEYBOARD - GET KEYBOARD STATUS
	AH = 01h
Return: ZF set if no keystroke available
	ZF clear if keystrokes in buffer
	    AX = next keystroke (AH=00h for ASCII keys -- no scan code)
SeeAlso: AH=00h,AH=02h,AH=03h,AH=04h,AH=05h,INT 16/AH=01h
--------b-4A02-------------------------------
INT 4A - TI Professional PC - KEYBOARD - GET KEYBOARD MODE
	AH = 02h
Return: AL = shift states (see #2845)
SeeAlso: AH=00h,AH=02h,AH=03h,AH=04h,AH=05h,INT 16/AH=02h

Bitfields for TI Professional PC keyboard shift states:
Bit(s)	Description	(Table 2845)
 0	Ctrl key pressed
 1	Alt key pressed
 2	either Shift key pressed
 3-6	0
 7	CapsLock is ON
--------b-4A03-------------------------------
INT 4A - TI Professional PC - KEYBOARD - FLUSH KEYBOARD BUFFER
	AH = 03h
Return: nothing
SeeAlso: AH=00h,AH=02h,AH=03h,AH=04h,AH=05h
--------b-4A04-------------------------------
INT 4A - TI Professional PC - KEYBOARD - SEND COMMAND TO KEYBOARD
	AH = 04h
	AL = command
	    00h reset to default states
	    01h enable auto-repeat (default)
	    02h disable auto-repeat
	    03h lock keyboard
	    04h unlock keyboard (default)
	    05h enable keyclick (requires hardware modification to work)
	    06h disable keyclick (default)
Return: nothing
SeeAlso: AH=00h,AH=02h,AH=03h,AH=04h,AH=05h
--------b-4A05-------------------------------
INT 4A - TI Professional PC - KEYBOARD - INSERT CHARACTER INTO KEYBOARD BUFFER
	AH = 05h
	BX = character code (BH=00h if ASCII character, BL=00h/BH nonzero for
	      extended codes) (see #2846)
Return: ZF set if keyboard buffer was already full
	ZF clear if keystroke inserted into buffer
SeeAlso: AH=00h,AH=02h,AH=03h,AH=04h,AH=05h,INT 5B"TI"

(Table 2846)
Values for TI Professional PC scan/character codes:
 Scan	Key	Normal	Shift	Ctrl	Alt	Notes
 00h	  -- unused
 01h	F5	3F00h	5800h	6200h	6C00h
 02h	F6	4000h	5900h	6300h	6D00h
 03h	F7	4100h	5A00h	6400h	6E00h
 04h	F8	4200h	5B00h	6500h	6F00h
 05h	F9	4300h	5C00h	6600h	7000h
 06h	F10	4400h	5D00h	6700h	7100h
 07h	F11	4500h	0800h	0A00h	0C00h
 08h	F12	4600h	0900h	0B00h	0D00h
 09h	1 !	0031h	0021h	----	7800h
 0Ah	2 @	0032h	0040h	0300h	7900h
 0Bh	3 #	0033h	0023h	----	7A00h
 0Ch	4 $	0034h	0024h	----	7B00h
 0Dh	5 %	0035h	0025h	----	7C00h
 0Eh	6 ^	0036h	005Eh	001Eh	7D00h
 0Fh	7 &	0037h	0026h	----	7E00h
 10h	8 *	0038h	002Ah	----	7F00h
 11h	9 (	0039h	0028h	----	8000h
 12h	0 )	0030h	0029h	----	8100h
 13h	- _	002Dh	005Fh	001Fh	8200h
 14h	= +	003Dh	002Bh	----	8300h
 15h BACK SPACE 0008h	0008h	007Fh	----
 16h	` ~	0060h	007Eh	----	----
 17h	NUM =	003Dh	003Dh	003Dh	8C00h
 18h	NUM +	002Bh	002Bh	002Bh	8D00h
 19h   NUM SPAC	0020h	0020h	0020h	8E00h
 1Ah   NUM TAB	0009h	0F00h	0009h	8F00h
 1Bh	NUM 1	0031h	0031h	0031h	(alt-###)	[Note 5]
 1Ch	(unused)
 1Dh	NUM 0	0030h	0030h	0030h	(alt-###)	[Note 5]
 1Eh  NUM ENTER	000Dh	000Dh	000Dh	----
 1Fh	NUM 4	0034h	0034h	0034h	(alt-###)	[Note 5]
 20h	NUM 5	0035h	0035h	0035h	(alt-###)	[Note 5]
 21h	NUM 9	0039h	0039h	0039h	(alt-###)	[Note 5]
 22h	NUM -	002Dh	002Dh	002Dh	----
 23h	NUM 2	0032h	0032h	0032h	(alt-###)	[Note 5]
 24h-26h  -- unused
 27h	NUM 7	0037h	0037h	0037h	(alt-###)	[Note 5]
 28h	NUM 8	0038h	0038h	0038h	(alt-###)	[Note 5]
 29h	NUM 6	0036h	0036h	0036h	(alt-###)	[Note 5]
 2Ah	NUM ,	002Ch	002Ch	002Ch	----
 2Bh	NUM 3	0033h	0033h	0033h	(alt-###)	[Note 5]
 2Ch	NUM .	002Eh	002Eh	002Eh	----
 2Dh	PRINT	7200h	[Note2]	----	----	[Notes 1,2]
 2Eh   RtArrow	4D00h	8A00h	7400h	4E00h
 2Fh	INS	5200h	2800h	2900h	2A00h	[Note 1]
 30h	DEL	5300h	3800h	3900h	3A00h	[Note 1]
 31h	TAB	0009h	0F00h	0009h	----
 32h	Q	0071h	0051h	0011h	1000h
 33h	W	0077h	0057h	0017h	1100h
 34h	E	0065h	0045h	0005h	1200h
 35h	R	0072h	0052h	0012h	1300h
 36h	T	0074h	0054h	0014h	1400h
 37h	Y	0079h	0059h	0019h	1500h
 38h	U	0075h	0055h	0015h	1600h
 39h	I	0069h	0049h	0009h	1700h
 3Ah	O	006Fh	004Fh	000Fh	1800h
 3Bh	P	0070h	0050h	0010h	1900h
 3Ch	[ {	005Bh	007Bh	001Bh	----
 3Dh	] }	005Dh	007Dh	001Dh	----
 3Eh  LINE FEED	000Ah	000Ah	7500h	4F00h
 3Fh  BRK/PAUS	[Note3]	[Note4]	----	----	[Notes 1,3,4]
 40h  UpArrow	4800h	8800h	8400h	4900h
 41h	ESC	001Bh	001Bh	001Bh	----
 42h	A	0061h	0041h	0001h	1E00h
 43h	S	0073h	0053h	0013h	1F00h
 44h	D	0064h	0044h	0004h	2000h
 45h	F	0066h	0046h	0006h	2100h
 46h	G	0067h	0047h	0007h	2200h
 47h	H	0068h	0048h	0008h	2300h
 48h	J	006Ah	004Ah	000Ah	2400h
 49h	K	006Bh	004Bh	000Bh	2500h
 4Ah	L	006Ch	004Ch	000Ch	2600h
 4Bh	; :	003Bh	003Ah	----	----
 4Ch	' "	0027h	0022h	----	----
 4Dh	RETURN	000Dh	000Dh	000Dh	----
 4Eh	\ |	005Ch	007Ch	001Ch	----
 4Fh  LeftArrow	4B00h	8B00h	7300h	4C00h
 50h	HOME	4700h	8600h	7700h	8500h
 51h  Space Bar	0020h	0020h	0020h	0020h
 52h	Z	007Ah	005Ah	001Ah	2C00h
 53h	X	0078h	0058h	0018h	2D00h
 54h	C	0063h	0043h	0003h	2E00h
 55h	V	0076h	0056h	0016h	2F00h
 56h	B	0062h	0042h	0002h	3000h
 57h	N	006Eh	004Eh	000Eh	3100h
 58h	M	006Dh	004Dh	000Dh	3200h
 59h	, <	002Ch	003Ch	----	----
 5Ah  PRINT	7200h	[Note2]	----	----	[Notes 1,2]
 5Bh	. >	002Eh	003Eh	----	----
 5Ch	/ ?	002Fh	003Fh	----	----
 5Dh	(unused)
 5Eh	DEL	5300h	3800h	3900h	3A00h	[Note 1]
 5Fh	INS	5200h	2800h	2900h	2A00h	[Note 1]
 60h  DownArrow	5000h	8900h	7600h	5100h
 61h-63h  -- unused
 64h  BRK/PAUS	[Note3]	[Note4]	----	----	[Notes 1,3,4]
 65h	F1	3B00h	5400h	5E00h	6800h
 66h	F2	3C00h	5500h	5F00h	6900h
 67h	F3	3D00h	5600h	6000h	6A00h
 68h	F4	3E00h	5700h	6100h	6B00h
 69h-6Fh  -- unused
Notes:	[1] four of the keys can have differing scan codes, depending on the
	  actual keyboard; the BIOS accepts either scan code ("normal": 2Fh,
	  30h, 5Ah, 64h; "alternate": 2Dh,3Fh,5Eh,5Fh) for any of these keys
	[2] Shift-Print invokes INT 5E for a screen dump; the PRTSCRN.DEV
	  device driver also supports Alt-Print, Ctrl-Print, Shift-Alt-Print,
	  and Shift-Ctrl-Print for dumping graphics in various permutations
	[3] BRK/PAUS invokes INT 5C for a pause, then stuffs 0100h into the
	  keyboard buffer
	[4] Shift-BRK/PAUS invokes INT 5D for the Break, then stuffs 0000h
	  into the keyboard buffer; MS-DOS hooks INT 5D to keep the 0000h from
	  appearing in the keyboard buffer
	[5] on the TI Pro, one enters an arbitrary character slightly
	  differently than on a standard PC: exactly three numberpad digits
	  must be pressed (using leading zeros for codes less than 100), and
	  the key for the requested code is inserted into the keyboard buffer
	  immediately on pressing the third key.  The Alt key may be released
	  and re-pressed arbitrarily often between digits without affecting
	  the Alt-digit-digit-digit sequence.
	scan codes with bit 7 set are not key releases, but rather
	  auto-repeated keystrokes, which the BIOS only places into the
	  keyboard buffer if the buffer is empty at the time (thus avoiding
	  typeahead of repeated keystrokes faster than they can be processed)
SeeAlso: #0005 at INT 09
--------h-4B---------------------------------
INT 4B - Z100 - Slave 8259 - S100 vectored line 3
SeeAlso: INT 4A"Z100",INT 4C"Z100"
--------d-4B---------------------------------
INT 4B - Common Access Method SCSI interface (draft revision 1.9)
	ES:DI -> CAM Control Block (see #2861 at INT 4F/AX=8100h)
Notes:	the CAM committee moved the interface to INT 4F after revision 1.9
	  to avoid conflicting with the IBM SCSI interface and the Virtual
	  DMA specification
	the installation check for the driver is the string "SCSI_CAM" eight
	  bytes past the INT 4Bh handler
	the only driver to date reported to use the CAM interface on INT 4B
	  instead of INT 4F is from Future Domain (which has drivers for CAM
	  on either interrupt)
SeeAlso: INT 4F/AX=8100h
Index:	installation check;Common Access Method SCSI interface
--------b-4B---------------------------------
INT 4B - Tandy 2000 - EQUIPMENT DETERMINATION
Return: AX = BIOS equipment list word (see #2847)
Note:	this interrupt is identical to INT 11 on the Tandy 2000
SeeAlso: INT 11"EQUIPMENT",INT 4A"Tandy 2000",INT 4C"Tandy 2000"

Bitfields for Tandy 2000 BIOS equipment list:
Bit(s)	Description	(Table 2847)
 0	reserved
 1	monochrome graphics installed
 2	graphics with color option installed
 3	floppy disk drive 1 installed
 4	floppy disk drive 2 installed
 5	hard disk drive 1 installed
 6	hard disk drive 2 installed
 7	unused
 8	black and white monitor
 9	color monitor
 12-10	reserved
 13	printer installed
 14	reserved
 15	unused
SeeAlso: #0151 at INT 11
--------O-4B---------------------------------
INT 4B - Acorn BBC Master 512 - "OSBYTE" - MISC FUNCTIONS USING REGISTER PARAMS
	AL = function code
	BL = first parameter
	BH = second parameter (if needed)
Return: BL = first return parameter
	BH = second return parameter
	CF depends on function
SeeAlso: INT 40"Acorn",INT 4A"Acorn",INT 4C"Acorn"
--------b-4B00-------------------------------
INT 4B - TI Professional PC - PARALLEL PORT - OUTPUT CHARACTER
	AH = 00h
	DL = printer number (00h)
	AL = character to print
Return: AH = printer status (see #2848)
Note:	on the TI Pro, the BIOS only supports DL=00h; MS-DOS versions for the
	  TI hook INT 4B and handle requests for DL<>00h
SeeAlso: AH=01h,AH=02h,INT 17/AH=00h
SeeAlso: INT 40"TI Professional",INT 48/AH=00h"TI Professional"
SeeAlso: INT 49/AH=01h"TI",INT 4C"TI Professional",INT 4D/AH=00h

Bitfields for TI Professional PC printer status:
Bit(s)	Description	(Table 2848)
 0	timeout (function 00h only)
 3-1	unused
 4	busy
 5	paper out
 6	on-line (selected)
 7	fault
--------b-4B01-------------------------------
INT 4B - TI Professional PC - PARALLEL PORT - INITIALIZE PRINTER
	AH = 01h
	DL = printer number (00h)
Return: AH = printer status (see #2848)
Note:	on the TI Pro, the BIOS only supports DL=00h; MS-DOS versions for the
	  TI hook INT 4B and handle requests for DL<>00h
SeeAlso: AH=00h,AH=02h,INT 17/AH=01h
--------b-4B02-------------------------------
INT 4B - TI Professional PC - PARALLEL PORT - GET PRINTER STATUS
	AH = 02h
	DL = printer number (00h)
Return: AH = printer status (see #2848)
Note:	on the TI Pro, the BIOS only supports DL=00h; MS-DOS versions for the
	  TI hook INT 4B and handle requests for DL<>00h
SeeAlso: AH=00h,AH=01h,INT 17/AH=02h
--------d-4B80-------------------------------
INT 4B - IBM SCSI interface
	AH = 80h
	AL = 00h-10h (Corel PowerSCSI INT4BCAM.SYS)
	further details not yet available
--------d-4B8102DX0000-----------------------
INT 4B - Virtual DMA Specification (VDS) - GET VERSION
	AX = 8102h
	DX = 0000h
Return: CF clear if successful
	    AH = major version number
	    AL = minor version number
	    BX = product number (see #2849)
	    CX = product revision number
		always 0000h for QMAPS and HPMM.SYS
		always 0001h for Microsoft's EMM386.EXE v4.20-4.41
	    DX = flags (see #2851)
	    SI:DI = maximum DMA buffer size
	CF set on error
	    AL = error code (see #2850)
Note:	bit 5 of 0040h:007Bh is supposed to be set if VDS is supported; this is
	  apparently not always the case
SeeAlso: INT 2C/AX=002Bh,INT 31/AX=0400h
Index:	installation check;Virtual DMA Spec

(Table 2849)
Values for VDS product number:
 0000h	for Quadtel's QMAPS and Hewlett-Packard's HPMM.SYS
 0001h	for Microsoft's EMM386.EXE
 0003h	for Windows 3.x WIN386.EXE
 0300h	OS/2 (all versions to date)
 0EDCh	for DR DOS 6.0 EMM386.SYS
 4560h	("E`") for Qualitas' 386MAX
 4D43h	("MC") for V Communications' Memory Commander
 5145h	("QE") for Quarterdeck's QEMM-386
 524Dh	("RM") for Helix's Netroom RM386

(Table 2850)
Values for VDS error code:
 01h	region not in contiguous memory
 02h	region crossed a physical alignment boundary
 03h	unable to lock pages
 04h	no buffer available
 05h	region too large for buffer
 06h	buffer currently in use
 07h	invalid memory region
 08h	region was not locked
 09h	number of physical pages greater than table length
 0Ah	invalid buffer ID
 0Bh	copy out of buffer range
 0Ch	invalid DMA channel number
 0Dh	disable count overflow
 0Eh	disable count underflow
 0Fh	function not supported
 10h	reserved flag bits set in DX

Bitfields for VDS flags:
Bit(s)	Description	(Table 2851)
 0	PC/XT bus (DMA in first megabyte only)
 1	physical buffer/remap region in first megabyte
 2	automatic remap enabled
 3	all memory is physically contiguous
 4-15	reserved (zero)
--------d-4B8103-----------------------------
INT 4B - Virtual DMA Specification - LOCK DMA REGION
	AX = 8103h
	DX = flags (see #2852)
	ES:DI -> DMA descriptor structure (see #2853,#2854,#2855)
Return: CF clear if successful
	    DDS physical address field filled in
	    DDS buffer ID field filled (0000h if no buffer allocated)
	CF set on error
	    AL = error code (see #2850)
	    DDS region size field filled wth maximum contiguous length in bytes
BUGS:	Windows 3.0 does not correctly support automatic remapping or copying
	  in enhanced mode
	Windows 3.0 in enhanced mode does not return a correct code on error
SeeAlso: AX=8104h,AX=8105h

Bitfields for VDS flags:
Bit(s)	Description	(Table 2852)
 0	reserved (zero)
 1	data should be copied into buffer (ignored if 2 set)
 2	buffer should not be allocated if region noncontiguous or crosses
	  physical alignment boundary specified by 4-5
 3	don't attempt automatic remap
 4	region must not cross 64K physical alignment boundary
 5	region must not cross 128K physical alignment boundary
 6-15	reserved (zero)

Format of DMA descriptor structure (DDS):
Offset	Size	Description	(Table 2853)
 00h	DWORD	region size
 04h	DWORD	offset
 08h	WORD	segment/selector
 0Ah	WORD	buffer ID
 0Ch	DWORD	physical address

Format of Extended DMA descriptor structure (EDDS):
Offset	Size	Description	(Table 2854)
 00h	DWORD	region size
 04h	DWORD	offset
 08h	WORD	segment/selector
 0Ah	WORD	reserved
 0Ch	WORD	number available
 0Eh	WORD	number used
 10h	DWORD	region 0 physical address
 14h	DWORD	region 0 size in bytes
 18h	DWORD	region 1 physical address
 1Ch	DWORD	region 1 size in bytes
	...

Format of Extended DMA descriptor structure (EDDS) with page table entries:
Offset	Size	Description	(Table 2855)
 00h	DWORD	region size
 04h	DWORD	offset
 08h	WORD	segment/selector
 0Ah	WORD	reserved
 0Ch	WORD	number available
 0Eh	WORD	number used
 10h	DWORD	page table entry 0 (same as 80386 page table entry)
 14h	DWORD	page table entry 1
	...
Note:	bits 1-11 of the page table entries should be zero; bit 0 set if page
	  is present and locked
--------d-4B8104-----------------------------
INT 4B - Virtual DMA Specification - UNLOCK DMA REGION
	AX = 8104h
	DX = flags
	    bit 0: reserved (zero)
	    bit 1: data should be copied out of buffer
	    bits 2-15 reserved (zero)
	ES:DI -> DMA descriptor structure (see #2853,#2854) with region size,
		  physical address, and buffer ID fields set
Return: CF clear if successful
	    DDS physical address field set
	    DDS buffer ID field set (0000h if no buffer allocated)
	CF set on error
	    AL = error code (see #2850)
	    DDS region size field filled wth maximum contiguous length in bytes
Note:	Windows 3.0 does not check whether the region extends beyond the end of
	  a segment
BUG:	Windows 3.0 in enhanced mode does not return a correct code on error
SeeAlso: AX=8103h,AX=8106h
--------d-4B8105-----------------------------
INT 4B - Virtual DMA Specification - SCATTER/GATHER LOCK REGION
	AX = 8105h
	DX = flags (see #2856)
	ES:DI -> Extended DMA descriptor structure (see #2854,#2855)
		  region size, linear segment, linear offset, and number avail
		  fields set
Return: CF clear if successful
	    EDDS number used field set
	    if DX bit 6 set, lower 12 bits of BX = offset in first page
	CF set on error
	    AL = error code (see #2850)
	    EDDS region size field filled with max length in bytes that can be
		  locked and described in the EDDS table
BUG:	Windows 3.0 in enhanced mode may return zero instead of the physical
	  page address for pages which were originally not present
SeeAlso: AX=8103h,AX=8106h

Bitfields for VDS flags:
Bit(s)	Description	(Table 2856)
 0-5	reserved (zero)
 6	EDDS should be returned with page table entries
 7	only present pages should be locked (not-present pages receive entry
	  of 0000h)
 8-15	reserved (zero)
--------d-4B8106-----------------------------
INT 4B - Virtual DMA Specification - SCATTER/GATHER UNLOCK REGION
	AX = 8106h
	DX = flags (see #2857)
	ES:DI -> Extended DMA descriptor structure (see #2854,#2855) returned
		  by AX=8105h
Return: CF clear if successful
	CF set on error
	    AL = error code (see #2850)
Note:	according to the Microsoft version of the VDS specification, the
	  actual scatter/gather list is ignored, while according to the IBM
	  version of the specification, "the result of a LOCK operation"
	  must be provided to this function
SeeAlso: AX=8104h,AX=8105h

Bitfields for VDS flags:
Bit(s)	Description	(Table 2857)
 0-5	reserved (zero)
 6	EDDS contains page table entries
 7	EDDS may contain not-present pages (entry = 0000h)
 8-15	reserved (zero)
--------d-4B8107-----------------------------
INT 4B - Virtual DMA Specification - REQUEST DMA BUFFER
	AX = 8107h
	DX = flags
	    bit 0: reserved (zero)
	    bit 1: data should be copied into buffer
	    bits  2-15 reserved (zero)
	ES:DI -> DMA descriptor structure (see #2853) with region size set
		  (also region offset and region segment if DX bit 1 set)
Return: CF clear if successful
	    DDS physical address and buffer ID set
	    DDS region size filled with length of buffer
	CF set on error
	    AL = error code (see #2850)
SeeAlso: AX=8108h
--------d-4B8108-----------------------------
INT 4B - Virtual DMA Specification - RELEASE DMA BUFFFER
	AX = 8108h
	DX = flags
	    bit 0: reserved (zero)
	    bit 1: data should be copied out of buffer
	    bits 2-15 reserved (zero)
	ES:DI -> DMA descriptor structure (see #2853,#2854) with buffer ID set
		  (also region size/region offset/segment if DX bit 1 set)
Return: CF clear if successful
	CF set on error
	    AL = error code (see #2850)
BUG:	under Windows 3.0 Enhanced mode, you must specify that data be copied
	  for this function to work correctly
SeeAlso: AX=8107h
--------d-4B8109DX0000-----------------------
INT 4B - Virtual DMA Specification - COPY INTO DMA BUFFER
	AX = 8109h
	DX = 0000h
	ES:DI -> DMA descriptor structure (see #2853,#2854) with buffer ID,
		  region segment/offset, and region size fields set
	BX:CX = starting offset into DMA buffer
Return: CF clear if successful
	CF set on error
	    AL = error code (see #2850)
BUG:	Windows 3.0 Enhanced mode does not correctly interpret the copy count
SeeAlso: AX=810Ah
--------d-4B810ADX0000-----------------------
INT 4B - Virtual DMA Specification - COPY OUT OF DMA BUFFER
	AX = 810Ah
	DX = 0000h
	ES:DI -> DMA descriptor structure (see #2853,#2855) with buffer ID,
		  region segment/offset, and region size fields set
	BX:CX = starting offset into DMA buffer
Return: CF clear if successful
	CF set on error
	    AL = error code (see #2850)
BUG:	Windows 3.0 Enhanced mode does not correctly interpret the copy count
SeeAlso: AX=8109h
--------d-4B810B-----------------------------
INT 4B - Virtual DMA Specification - DISABLE DMA TRANSLATION
	AX = 810Bh
	BX = DMA channel number
	DX = 0000h
Return: CF clear if successful
	CF set on error
	    AL = error code (see #2850)
SeeAlso: AX=810Ch
--------d-4B810C-----------------------------
INT 4B - Virtual DMA Specification - ENABLE DMA TRANSLATION
	AX = 810Ch
	BX = DMA channel number
	DX = 0000h
Return: CF clear if successful
	    ZF set if disable count decremented to zero
	CF set on error
	    AL = error code (see #2850)
SeeAlso: AX=810Bh
--------Q-4B810D-----------------------------
INT 4B - QEMM-386 - BUG
	AX = 810Dh
Note:	the code in QEMM v5.11 and 6.00 jumps to an invalid location on this
	  call
--------h-4C---------------------------------
INT 4C - Z100 - Slave 8259 - S100 vectored line 4
SeeAlso: INT 4B"Z100",INT 4D"Z100"
--------b-4C---------------------------------
INT 4C - TI Professional PC - CLOCK/ANALOG INTERFACE
	no details available
SeeAlso: INT 40"TI Professional",INT 49/AH=01h"TI"
SeeAlso: INT 4A/AH=00h"TI",INT 4B"TI Professional",INT 4D/AH=00h
SeeAlso: INT 58"TI Professional"
--------b-4C---------------------------------
INT 4C - Tandy 2000 - GET MEMORY SIZE
Return: AX = kilobytes of contiguous memory starting at 0
Note:	this interrupt is identical to INT 12 on the Tandy 2000
SeeAlso: INT 12"BIOS",INT 4A"Tandy 2000",INT 4B"Tandy 2000",INT 51"Tandy 2000"
--------O-4C---------------------------------
INT 4C - Acorn BBC Master 512 - "OSCLI" - INTERPRET COMMAND LINE
	DS:BX -> CR-terminated command string
Return: FLAGS destroyed
SeeAlso: INT 40"Acorn",INT 4A"Acorn",INT 4B"Acorn"
--------h-4D---------------------------------
INT 4D - Z100 - Slave 8259 - S100 vectored line 5
SeeAlso: INT 4C"Z100",INT 4E"Z100"
--------s-4D---------------------------------
INT 4D - IBM - M-Audio Adapter SUPPORT
	no details available; supposedly documented in IBM form G571-0203-01
--------B-4D00-------------------------------
INT 4D - TI Professional PC - DISK - RESET DISK SYSTEM
	AH = 00h
	DL = drive (if bit 7 is set both hard disks and floppy disks reset)
Return: AH = status (see #0159 at INT 13/AH=01h)
	CF clear if successful (returned AH=00h)
	CF set on error
Note:	this function is the same as INT 13/AH=00h on a standard PC BIOS
SeeAlso: AH=01h,AH=02h,AH=08h,AH=0Bh,INT 13/AH=00h,INT 46"TI Professional"
SeeAlso: INT 48/AH=00h"TI Professional",INT 4A/AH=00h"TI"
--------B-4D01-------------------------------
INT 4D - TI Professional PC - DISK - GET STATUS OF LAST OPERATION
	AH = 01h
	DL = drive (bit 7 set for hard disk)
Return: CF clear if status unchanged
	CF set if status changed since last call
	AH = 00h
	AL = status of previous operation (see #0159 at INT 13/AH=01h)
Notes:	this function is nearly the same as INT 13/AH=01h on a standard PC BIOS
	the TI's BIOS tranparently performs a number of retries, and an error
	  status is only reported if all of the retries fail.  To get the error
	  status if the operation succeeded on a retry, use AH=07h instead
SeeAlso: AH=00h,AH=07h,INT 13/AH=01h
--------B-4D02-------------------------------
INT 4D - TI Professional PC - DISK - READ SECTOR(S) INTO MEMORY
	AH = 02h
	AL = number of sectors to read (must be nonzero)
	CH = low eight bits of cylinder number
	CL = sector number 1-63 (bits 0-5)
	     high two bits of cylinder (bits 6-7, hard disk only)
	DH = head number
	DL = drive number (bit 7 set for hard disk)
	ES:BX -> data buffer
Return: CF set on error
	    if AH = 11h (corrected ECC error), AL = burst length
	CF clear if successful
	AH = status (see #0159 at INT 13/AH=01h)
	AL = number of sectors transferred
	ES:BX -> buffer for last sector processed (including one with errors)
SeeAlso: AH=00h,AH=01h,AH=03h,AH=04h,INT 13/AH=02h
--------B-4D03-------------------------------
INT 4D - TI Professional PC - DISK - WRITE SECTOR(S) FROM MEMORY
	AH = 03h
	AL = number of sectors to write (must be nonzero)
	CH = low eight bits of cylinder number
	CL = sector number 1-63 (bits 0-5)
	     high two bits of cylinder (bits 6-7, hard disk only)
	DH = head number
	DL = drive number (bit 7 set for hard disk)
	ES:BX -> buffer containing data
Return: CF set on error
	    if AH = 11h (corrected ECC error), AL = burst length
	CF clear if successful
	AH = status (see #0159 at INT 13/AH=01h)
	AL = number of sectors transferred
	ES:BX -> buffer for last sector processed (including one with errors)
SeeAlso: AH=00h,AH=01h,AH=02h,AH=04h,INT 13/AH=03h
--------B-4D04-------------------------------
INT 4D - TI Professional PC - DISK - VERIFY DISK SECTOR CRC(S)
	AH = 04h
	AL = number of sectors to verify (must be nonzero)
	CH = low eight bits of cylinder number
	CL = sector number 1-63 (bits 0-5)
	     high two bits of cylinder (bits 6-7, hard disk only)
	DH = head number
	DL = drive number (bit 7 set for hard disk)
	ES:BX -> data buffer
Return: CF set on error
	    if AH = 11h (corrected ECC error), AL = burst length
	CF clear if successful
	AH = status (see #0159 at INT 13/AH=01h)
	AL = number of sectors transferred
	ES:BX -> buffer for last sector processed (including one with errors)
Note:	even though no data is transferred, ES:BX must still be valid
SeeAlso: AH=00h,AH=01h,AH=02h,AH=06h,INT 13/AH=04h
--------B-4D05-------------------------------
INT 4D - TI Professional PC - DISK - NOP
	AH = 05h
Note:	on the TI Pro, FORMAT.COM contains direct port I/O commands to perform
	  disk formatting, rather than using the BIOS
--------B-4D06-------------------------------
INT 4D - TI Professional PC - DISK - VERIFY DISK SECTOR(S)
	AH = 06h
	AL = number of sectors to verify (must be nonzero)
	CH = low eight bits of cylinder number
	CL = sector number 1-63 (bits 0-5)
	     high two bits of cylinder (bits 6-7, hard disk only)
	DH = head number
	DL = drive number (bit 7 set for hard disk)
	ES:BX -> data buffer
Return: CF set on error
	    if AH = 11h (corrected ECC error), AL = burst length
	CF clear if successful
	AH = status (see #0159 at INT 13/AH=01h)
	AL = number of sectors transferred
	ES:BX -> buffer for last sector processed (including one with errors)
Note:	even though no data is transferred, ES:BX must still be valid because
	  an actual comparison with disk data is performed, not just the CRC
	  check of the standard PC BIOS or INT 4D/AH=04h
SeeAlso: AH=00h,AH=01h,AH=02h,AH=04h,INT 13/AH=04h
--------B-4D07-------------------------------
INT 4D - TI Professional PC - DISK - GET RETRY STATUS OF LAST OPERATION
	AH = 07h
	DL = drive (bit 7 set for hard disk)
Return: CF clear if status unchanged
	CF set if status changed since last call
	AH = 00h
	AL = status of previous operation (see #0159 at INT 13/AH=01h)
Notes:	this function is nearly the same as INT 13/AH=01h on a standard PC BIOS
	the TI's BIOS tranparently performs a number of retries; this function
	  returns the error status of a failed operation even if the operation
	  succeeded on a retry
SeeAlso: AH=00h,AH=01h,INT 13/AH=01h
--------B-4D08-------------------------------
INT 4D - TI Professional PC - DISK - SET STANDARD DEVICE INTERFACE TABLE
	AH = 08h
	DL = drive number (00h-03h)
	AL = drive type
	    00h single-sided 48 tpi (40-track, 8 sectors, 512 bytes/sector)
	    01h double-sided 48 tpi (40-track, 8 sectors, 512 bytes/sector)
	    02h single-sided 96 tpi (80-track, 8 sectors, 512 bytes/sector)
	    03h double-sided 96 tpi (80-track, 8 sectors, 512 bytes/sector)
Return: nothing???
SeeAlso: AH=00h,AH=09h
--------B-4D09-------------------------------
INT 4D - TI Professional PC - DISK - SET DEVICE INTERFACE TABLE ADDRESS
	AH = 09h
	DL = drive number (00h-07h)
	ES:BX -> Device Interface Table (see #2858)
Return: nothing???
SeeAlso: AH=00h,AH=08h,AH=0Ah,INT 1E

Format of TI Professional PC Device Interface Table:
Offset	Size	Description	(Table 2858)
 00h	DWORD	-> entry point for disk routine
 04h	WORD	bytes per sector
 06h	BYTE	sectors per track
 07h	BYTE	number of heads
 08h	BYTE	number of cylinders
 09h	BYTE	retry count
 0Ah	BYTE	precompensation start
SeeAlso: #0929 at INT 1E
--------B-4D0A-------------------------------
INT 4D - TI Professional PC - DISK - GET DEVICE INTERFACE TABLE ADDRESS
	AH = 0Ah
	DL = drive number (00h-07h)
Return: AH = status
	ES:BX -> Device Interface Table (see #2858)
SeeAlso: AH=00h,AH=08h,AH=09h,INT 1E
--------B-4D0B-------------------------------
INT 4D - TI Professional PC - DISK - TURN OFF ALL DRIVES
	AH = 0Bh
Return: AH = 00h
Note:	used for diagnostics or to conserve power
SeeAlso: AH=00h
--------h-4E---------------------------------
INT 4E - Z100 - Slave 8259 - S100 vectored line 6
SeeAlso: INT 4D"Z100",INT 4F"Z100"
--------b-4E00-------------------------------
INT 4E - TI Professional PC - TIME-OF-DAY CLOCK - SET BIOS DATE
	AH = 00h
	BX = number of days since January 1, 1980
Return: nothing
SeeAlso: AH=01h,AH=02h
SeeAlso: INT 40"TI Professional",INT 48/AH=00h"TI Professional"
SeeAlso: INT 4A/AH=00h"TI",INT 4F"TI Professional"
--------b-4E01-------------------------------
INT 4E - TI Professional PC - TIME-OF-DAY CLOCK - SET BIOS TIME
	AH = 01h
	CH = hours
	CL = minutes
	DH = seconds
	DL = hundredths
Return: nothing
Note:	the BIOS does not validate the data passed to this function
SeeAlso: AH=00h,AH=02h
--------b-4E02-------------------------------
INT 4E - TI Professional PC - TIME-OF-DAY CLOCK - GET BIOS DATA AND TIME
	AH = 02h
Return: AX = number of days since January 1, 1980
	CH = hours
	CL = minutes
	DH = seconds
	DL = hundredths
SeeAlso: AH=00h,AH=01h
--------h-4F---------------------------------
INT 4F - Z100 - Slave 8259 - S100 vectored line 7
SeeAlso: INT 4E"Z100"
--------b-4F---------------------------------
INT 4F - TI Professional PC - SYSTEM CONFIGURATION CALL
Return: AX = system configuration word (see #2859)
	BX = size of contiguous DOS memory in paragraphs
SeeAlso: INT 11"BIOS",INT 12"BIOS",INT 40"TI Professional",INT 48/AH=09h
SeeAlso: INT 49/AH=01h"TI",INT 4B"TI Professional",INT 4D/AH=00h
SeeAlso: INT 4E"TI Professional"

Bitfields for TI Professional PC system configuration:
Bit(s)	Description	(Table 2859)
 0	floppy drive 0 (A:, internal) installed
 1	floppy drive 1 (B:, internal) installed
 2	floppy drive 2 (C:, external) installed
 3	floppy drive 3 (D:, external) installed
 4	drive A: is 96tpi (80 tracks)
 5	drive A: is double-sided
 6	60 Hz power instead of 50 Hz
 7	hard disk (E: or E:/F:) installed
 8	serial port 1 installed
 9	serial port 2 installed
 10	serial port 3 installed
 11	serial port 4 installed
 14-12	installed graphics RAM
	000 none (text-only system)
	001 bank A only (graphics limited to 2 of 8 colors)
	111 banks A/B/C (graphics supports 8 of 8 colors)
 15	clock/analog board installed
--------d-4F8100-----------------------------
INT 4F - Common Access Method SCSI interface rev 2.3 - SEND CCB TO XPT/SIM
	AX = 8100h
	ES:BX -> CAM Control Block (CCB) (see #2861)
Return: AH = status
	    00h successful
	    01h invalid CCB address (0000h:0000h)
Note:	the SCSI Interface Module (SIM) may complete the requested function
	  and invoke the completion callback function before this call returns
SeeAlso: AX=8200h,INT 2F/AX=7F01h,INT 4B"Common Access Method"

(Table 2860)
Values for CAM function code:
 00h	NOP
 01h	execute SCSI I/O
 02h	get device type
 03h	path inquiry
 04h	release SIM queue
 05h	set async callback
 06h	set device type
 07h-0Fh reserved
 10h	abort SCSI command
 11h	reset SCSI bus
 12h	reset SCSI device
 13h	terminate I/O process
 14h-1Fh reserved
 20h	engine inquiry
 21h	execute engine request
 22h-2Fh reserved
 30h	enable logical unit number
 31h	execute target I/O
 32h-7Fh reserved
 80h-FFh vendor-specific functions

Format of CAM Control Block:
Offset	Size	Description	(Table 2861)
 00h	DWORD	physical address of this CCB
 04h	WORD	CAM control block length
 06h	BYTE	function code (see #2860)
 07h	BYTE	CAM status (see #2864)
 08h	BYTE	SCSI status
 09h	BYTE	path ID (FFh = XPT)
 0Ah	BYTE	target ID
 0Bh	BYTE	logical unit number
 0Ch	WORD	CAM flags (see #2862)
 0Eh	BYTE	CAM address flags (see #2863)
 0Fh	BYTE	target-mode flags (see #2865)
---function 02h---
 10h	DWORD	pointer to 36-byte buffer for inquiry data or 0000h:0000h
 14h	BYTE	peripheral device type of target logical unit number
---function 03h---
 10h	BYTE	version number (00h-07h prior to rev 1.7, 08h = rev 1.7,
		09h-FFh = rev no, i.e. 23h = rev 2.3)
 11h	BYTE	SCSI capabilities (see #2866)
 12h	BYTE	target mode support
		bit 7: processor mode
		bit 6: phase-cognizant mode
		bit 5-0: reserved
 13h	BYTE	miscellaneous flags
		bit 7: scanned high to low instead of low to high
		bit 6: removables not included in scan
		bit 5: inquiry data not kept by XPT
		bits 4-0: reserved
 14h	WORD	engine count
 16h 14 BYTEs	vendor-specific data
 24h	DWORD	size of private data area
 28h	DWORD	asynchronous event capabilities (see #2867)
 2Ch	BYTE	highest path ID assigned
 2Dh	BYTE	SCSI device ID of initiator
 2Eh  2 BYTEs	reserved
 30h 16 BYTEs	SIM vendor ID
 40h 16 BYTEs	HBA (host bus adaptor) vendor ID
 50h  4 BYTEs	operating-system dependant usage
---functions 00h,04h,11h,12h---
 no additional fields
---function 05h---
 10h	DWORD	asynchronous event enables (refer to function 03h above)
 14h	DWORD	pointer to asynchronous callback routine (see #2873)
 18h	DWORD	pointer to peripheral driver buffer
 1Ch	BYTE	size of peripheral buffer
---function 06h---
 10h	BYTE	peripheral device type of target
---functions 10h,13h---
 10h	DWORD	pointer to CCB to be aborted
---function 20h---
 10h	WORD	engine number
 12h	BYTE	engine type
		00h buffer memory
		01h lossless compression
		02h lossy compression
		03h encryption
 13h	BYTE	engine algorithm ID
		00h vendor-unique
		01h LZ1 variation 1 (STAC)
		02h LZ2 variation 1 (HP DCZL)
		03h LZ2 variation 2 (Infochip)
 14h	DWORD	engine memory size
---function 21h---
 10h	DWORD	pointer to peripheral driver
 14h  4 BYTEs	reserved
 18h	DWORD	OS-dependent request-mapping info
 1Ch	DWORD	address of completion callback routine
 20h	DWORD	pointer to scatter/gather list or data buffer
 24h	DWORD	length of data transfer
 28h	DWORD	pointer to engine buffer data
 2Ch  2 BYTEs	reserved
 2Eh	WORD	number of scatter/gather entries
 30h	DWORD	maximum destination data length
 34h	DWORD	length of destination data
 38h	DWORD	source residual length
 3Ch 12 BYTEs	reserved
 48h	DWORD	OS-dependent timeout value
 4Ch  4 BYTEs	reserved
 50h	WORD	engine number
 52h	WORD	vendor-unique flags
 54h  4 BYTEs	reserved
 58h  N BYTEs	private data area for SIM
---function 30h---
 10h	WORD	group 6 vendor-unique CDB length
 12h	WORD	group 7 vendor-unique CDB length
 14h	DWORD	pointer to target CCB list
 18h	WORD	number of target CCBs
---other functions---
 10h	DWORD	pointer to peripheral driver
 14h	DWORD	pointer to next CCB
 18h	DWORD	OS-dependent request mapping information
 1Ch	DWORD	address of completion callback routine (see #2872)
 20h	DWORD	pointer to scatter/gather list or data buffer
 24h	DWORD	length of data transfer
 28h	DWORD	pointer to sense info buffer
 2Ch	BYTE	length of sense info buffer
 2Dh	BYTE	CDB length
 2Eh	WORD	number of scatter/gather entries
		scatter/gather list is array of 2N DWORDs, each pair specifying
		  the address and length of a data block
 30h  4 BYTEs	vendor-specific data
 34h	BYTE	(ret) SCSI status
 35h	BYTE	(ret) auto-sense residual length
 36h  2 BYTEs	reserved
 38h	DWORD	(ret) residual length
 40h 12 BYTEs	Command Descriptor Block (CDB) (see #2868,#2869,#2870)
 44h	DWORD	OS-dependent timeout value
 48h	DWORD	pointer to message buffer
 4Ch	WORD	length of message buffer
 4Eh	WORD	vendor-unique flags
 50h	BYTE	tag queue action
 51h  3 BYTEs	reserved
 54h  N BYTEs	private data area for SIM

Bitfields for CAM flags:
Bit(s)	Description	(Table 2862)
 0	CDB is a pointer
 1	tagged queue action enable
 2	linked CDB
 3	disable callback on completion
 4	scatter/gather
 5	disable autosense
 7-6	direction (00 reserved, 01 in, 10 out, 11 no data transfer)
 9-8	reserved
 10	engine synchronize
 11	SIM queue freeze
 12	SIM queue priority
	1 head insertion
	0 tail insertion (normal)
 13	disable synchronous transfers	\ mutually
 14	initiate synchronous transfers	/ exclusive
 15	disable disconnect

Bitfields for CAM address flags:
Bit(s)	Description	(Table 2863)
 7	SG list/data (0 = host, 1 = engine)
 6	CDB pointer    (6-1: 0=virtual addr, 1=phys addr)
 5	SG list/data
 4	sense buffer
 3	message buffer
 2	next CCB
 1	callback on completion
 0	reserved

(Table 2864)
Values for CAM status:
 00h	request in progress
 01h	request successful
 02h	host aborted request
 03h	unable to abort request
 04h	request completed with error
 05h	CAM is busy
 06h	invalid request
 07h	invalid path ID
 08h	no such SCSI device
 09h	unable to terminate I/O process
 0Ah	timeout on target selection
 0Bh	timeout on command
 0Dh	receive message rejection
 0Eh	sent/received SCSI bus reset
 0Fh	detected uncorrectable parity error
 10h	Autosense request failed
 11h	no HBA detected
 12h	data over/underrun
 13h	bus freed unexpectedly
 14h	target bus phase sequence failure
 15h	CCB too small
 16h	requested capability not available
 17h	sent bus device reset
 18h	terminate I/O process
 38h	invalid LUN
 39h	invalid target ID
 3Ah	unimplemented function
 3Bh	nexus not established
 3Ch	invalid initiator ID
 3Dh	received SCSI Command Descriptor Block
 3Eh	LUN already enabled
 3Fh	SCSI bus busy
Note:	bit 6 set to indicate frozen SIM queue
	bit 7 set to indicate valid autosense

Bitfields for CAM target-mode flags:
Bit(s)	Description	(Table 2865)
 7	data buffer valid
 6	status valid
 5	message buffer valid
 4	reserved
 3	phase-cognizant mode
 2	target CCB available
 1	disable autodisconnect
 0	disable autosave/restore

Bitfields for SCSI capabilities:
Bit(s)	Description	(Table 2866)
 7	modify data pointers
 6	wide bus (32 bits)
 5	wide bus (16 bits)
 4	synchronous transfers
 3	linked commands
 2	reserved
 1	tagged queueing
 0	soft reset

Bitfields for CAM asynchronous event capabilities:
Bit(s)	Description	(Table 2867)
 31-24	vendor-specific
 23-8	reserved
 7	new devices found during rescan
 6	SIM module deregistered
 5	SIM module registered
 4	sent bus device reset to target
 3	SCSI AEN
 2	reserved
 1	unsolicited reselection
 0	unsolicited SCSI bus reset

Format of Six-Byte SCSI Command Descriptor Block (CDB):
Offset	Size	Description	(Table 2868)
 00h	BYTE	operation code (see #2871)
 01h	BYTE	logical unit number (bits 7-5), SCSI-1/SCSI-2
		MSB of logical block address (bits 4-0)
 02h	WORD	logical block address (low word)
 04h	BYTE	transfer length
 05h	BYTE	control byte
SeeAlso: #2869,#2870

Format of Ten-Byte SCSI Command Descriptor Block (CDB):
Offset	Size	Description	(Table 2869)
 00h	BYTE	operation code (see #2871)
 01h	BYTE	logical unit number (bits 7-5), SCSI-1/SCSI-2
		reserved in SCSI-3
 02h	DWORD	logical block address (low word)
 06h	BYTE	reserved
 07h	WORD	transfer length
 09h	BYTE	control byte
SeeAlso: #2868,#2870

Format of Twelve-Byte SCSI Command Descriptor Block (CDB):
Offset	Size	Description	(Table 2870)
 00h	BYTE	operation code (see #2871)
 01h	BYTE	logical unit number (bits 7-5), SCSI-1/SCSI-2
		reserved in SCSI-3
 02h	DWORD	logical block address (low word)
 06h	DWORD	transfer length
 0Ah	BYTE	reserved
 0Bh	BYTE	control byte
SeeAlso: #2868,#2869

(Table 2871)
Values for SCSI CDB operation code for direct-access devices:
 00h	Test Unit Ready
 01h	Rezero Unit
 03h	Request Sense
 04h	Format Unit
 07h	Reassign Blocks
 08h	Read (6-byte CDB)
 0Ah	Write (6-byte CDB)
 0Bh	Seek (6-byte CDB)
 12h	Inquiry
 15h	Mode Select (6-byte CDB)
 16h	Reserve
 17h	Release
 18h	Copy
 1Ah	Mode Sense (6-byte CDB)
 1Bh	Start/Stop Unit
 1Ch	Receive Diagnostic Results
 1Dh	Send Diagnostic
 1Eh	Prevent/Allow Medium Removal
 25h	Read Capacity
 28h	Read (10-byte CDB)
 2Ah	Write (10-byte CDB)
 2Bh	Seek (10-byte CDB)
 2Eh	Write and Verify
 2Fh	Verify
 30h	Search Data High
 31h	Search Data Equal
 32h	Search Data Low
 33h	Set Limits
 34h	Prefetch
 35h	Synchronize Cache
 36h	Lock/Unlock Cache
 37h	Read Defect Data
 39h	Compare
 3Ah	Copy and Verify
 3Bh	Write Buffer
 3Ch	Read Buffer
 3Eh	Read Long
 3Fh	Write Long
 40h	Change Definition
 41h	Write Same
 4Ch	Log Select
 4Dh	Log Sense
 55h	Mode Select (10-byte CDB)
 5Ah	Mode Sense (10-byte CDB)
SeeAlso: #2868,#2869,#2870

(Table 2872)
Values completion callback function is called with:
	interrupts disabled
	ES:BX -> completed CCB

(Table 2873)
Values asynchronous callback function is called with:
	AH = opcode
	AL = path ID generating callback
	DH = target ID causing event
	DL = LUN causing event
	CX = data byte count (if applicable)
	ES:BX -> data buffer (if applicable)
Return: all registers preserved
--------d-4F8200CX8765-----------------------
INT 4F - Common Access Method SCSI interface rev 2.3 - INSTALLATION CHECK
	AX = 8200h
	CX = 8765h
	DX = CBA9h
Return: AH = 00h if installed
	    CX = 9ABCh
	    DX = 5678h
	    ES:DI -> "SCSI_CAM"
SeeAlso: AX=8100h,INT 4B"Common Access Method"
--------N-50---------------------------------
INT 50 - TIL Xpert AIM (X.25)
	AH = function
--------H-50---------------------------------
INT 50 - IRQ0 relocated by DESQview
Range:	INT 50 to INT F8, selected automatically
Notes:	this is the default location for older versions; DESQview v2.26+
	  searches for unused ranges of interrupts and uses the lowest
	  available range in its list for relocating these IRQs and the next
	  lowest for relocating IRQ8-IRQ15
	a range of eight interrupts starting at a multiple of 8 is considered
	  available if all vectors are identical and it has not been excluded
	  with an /XB:nn commandline switch
	the list of ranges for v2.26 is 50h,58h,68h,78h,F8h (if < two of these
	  are available, F8h and then 50h are used anyway)
	the list of ranges for v2.31+ is 68h,78h,88h-B8h,F8h (if < two of these
	  are available, F8h and then F0h are used anyway)
SeeAlso: INT 08"IRQ0",INT 51"DESQview",INT 54"DESQview",INT 58"DESQview"
SeeAlso: INT D8"Screen Thief"
--------H-50---------------------------------
INT 50 - IRQ0 relocated by IBM 3278 emulation control program
SeeAlso: INT 51"IBM 3278"
--------H-50---------------------------------
INT 50 - IRQ0 relocated by OS/2 v1.x
SeeAlso: INT 51"OS/2"
----------50---------------------------------
INT 50 - TI Professional PC - FATAL SOFTWARE ERROR TRAP
Desc:	the default handler generates a System Error message and halts the
	  computer such that only Ctrl-Alt-Del can restart operation
Note:	documented as "for system use only"; intended for multi-tasking
	  software
SeeAlso: INT 40"TI Professional",INT 4F"TI Professional"
SeeAlso: INT 51"TI Professional",INT 53"TI Professional"
--------V-500000-----------------------------
INT 50 - Vanderaart TEXT WINDOWS, PC Thuis Shell - OPEN TEXT WINDOW
	AX = 0000h
	ES:BX -> name string or ES:0000h if none
	CH,CL = row,column of upper left corner
	DH,DL = row,column of lower right corner
Return: AX = window handle or
	    0000h if not installed
	    FFFFh on error
SeeAlso: AX=0001h,AX=0002h"TEXT WINDOWS"
--------V-500001-----------------------------
INT 50 - Vanderaart TEXT WINDOWS, PC Thuis Shell - CLOSE TEXT WINDOW
	AX = 0001h
	DI = window handle
SeeAlso: AX=0000h
--------V-500002-----------------------------
INT 50 - Vanderaart TEXT WINDOWS - PUT CHARACTER IN WINDOW
	AX = 0002h
	BL = character
	BH = attribute
	DL = column
	DH = row
	DI = window handle
Return: AX = status
	    0000h if successful
	    FFFFh if outside window
SeeAlso: AX=0000h
--------l-500002-----------------------------
INT 50 - PC Thuis Organizer Shell - PLOT TEXT
	AX = 0002h
	ES:BX -> text string
	DH,DL = row,column of upper left corner
	DI = window handle
Return: AX = status
	    0000h successful (text fits in window)
	    FFFFh error
Program: The PC Thuis Organizer Shell was written by John Vanderaart and
	  published in the June/July 1990 issue of PC Thuis Power magazine
--------V-500003-----------------------------
INT 50 - Vanderaart TEXT WINDOWS - OUTPUT LINE TO WINDOW
	AX = 0003h
	ES:BX -> text string
	CX = string length (0000h if ASCIZ string)
	DL = position (FFh centered, else flush left)
	DH = starting row
	DI = window handle
Return: AX = status
	    0000h successful
	    FFFFh did not fit in window
--------l-500003-----------------------------
INT 50 - PC Thuis Organizer Shell - WRITE FILE
	AX = 0003h
	ES:BX -> data to be written
	CX = number of bytes to write
	DS:SI -> filename
Return: AX = status
	    0000h successful
	    FFFFh error
SeeAlso: AX=0004h"Shell"
--------V-500004-----------------------------
INT 50 - Vanderaart TEXT WINDOWS - GET KEY
	AX = 0004h
	CH = type
	    00h any key
	    01h 'J' or 'N' (Dutch for yes/no)
Return: AX = key
SeeAlso: INT 16/AH=00h
--------l-500004-----------------------------
INT 50 - PC Thuis Organizer Shell - READ FILE
	AX = 0004h
	ES:BX -> buffer for data
	CX = number of bytes to read or 0000h for entire file
	DL = file type
	    01h setting shell
	    02h setting sterm
	    03h INT21 file
	DS:SI -> filename
Return: AX = status
	    0000h successful
	    FFFFh error
Note:	file type numbers are maintained by John Vanderaart; if a new file type
	  is needed, a type number should be requested from him through the
	  magazine:
		PC Thuis BV
		Spaarne 55
		2011 CE HAARLEM
		The Netherlands
SeeAlso: AX=0003h"Shell"
--------V-500005-----------------------------
INT 50 - Vanderaart TEXT WINDOWS - CHANGE ATTRIBUTE
	AX = 0005h
	BL = new attribute
	CH,CL = row,column of upper left corner
	DH,DL = row,column of lower right corner
	DI = window handle
--------l-500005-----------------------------
INT 50 - PC Thuis Organizer Shell - PROMPT YES/NO
	AX = 0005h
	ES:BX -> prompt string (ES:0000h if no prompt)
Return: AX = key pressed
	    0000h "J" (Dutch "Ja" = "Yes")
	    FFFFh "N" (Dutch "Nee" = "No")
Program: The PC Thuis Organizer Shell was written by John Vanderaart and
	  published in the June/July 1990 issue of PC Thuis Power magazine
SeeAlso: AX=0008h"PC Thuis"
--------V-500006-----------------------------
INT 50 - Vanderaart TEXT WINDOWS - EDIT LINE IN WINDOW
	AX = 0006h
	ES:BX -> text string
	CH = type of input (see #2874)
	DH,DL = row,column of upper left corner
	DI = window handle
Return: AX = key which terminated entry
	    0000h Enter
	    0001h Esc
	    0002h Down arrow
	    0003h Up arrow
	    0004h F10

(Table 2874)
Values for type of input to Vanderaart Text Windows:
 00h	everything
 01h	uppercase only
 02h	positive numbers
 03h	Dutch postal code ("9999 AA")
 04h	'J' or 'N' (Dutch yes/no)
 05h	telephone or FAX number
 06h	positive or negative number
 07h	date (dd/mm/yy)
 08h	money
 09h	'1' through '8'
 0Ah	'1' through '4'
 0Bh	uppercase filenames
--------l-500006-----------------------------
INT 50 - PC Thuis Organizer Shell - ALERT USER
	AX = 0006h
	ES:BX -> string
--------l-500007-----------------------------
INT 50 - PC Thuis Organizer Shell - DO LINE
	AX = 0007h
	ES:BX -> text string
	CX = string length in bytes (0000h if NUL-terminated)
	DL = FFh to center string, else flush left
	DH = upper left row
	DI = window handle
Return: AX = status
	    0000h successful
	    FFFFh error
Program: The PC Thuis Organizer Shell was written by John Vanderaart and
	  published in the June/July 1990 issue of PC Thuis Power magazine
SeeAlso: AX=0008h
--------l-500008-----------------------------
INT 50 - PC Thuis Organizer Shell - DO MENU
	AX = 0008h
	ES:BX -> menu structure
Return: AL = index 1 or FFh if not selected
	AH = index 2 or FFh if not selected
	BL = index 3 or FFh if not selected
	BH = index 4 or FFh if not selected
SeeAlso: AX=0005h"PC Thuis",AX=0007h,AX=000Ch
--------l-500009-----------------------------
INT 50 - PC Thuis Organizer Shell - MESSAGE ON
	AX = 0009h
	ES:BX -> message string
SeeAlso: AX=000Ah
--------l-50000A-----------------------------
INT 50 - PC Thuis Organizer Shell - MESSAGE OFF
	AX = 000Ah
SeeAlso: AX=0009h
--------l-50000B-----------------------------
INT 50 - PC Thuis Organizer Shell - CHANGE ATTRIBUTE
	AX = 000Bh
	BL = new attribute
	CH,CL = row,column of upper left corner
	DH,DL = row,column of lower right corner
	DI = window handle
--------l-50000C-----------------------------
INT 50 - PC Thuis Organizer Shell - DO REQUEST
	AX = 000Ch
	ES:BX -> request structure
Return: AX = status
	    0000h confirmed
	    FFFFh denied
SeeAlso: AX=0008h
--------l-50000D-----------------------------
INT 50 - PC Thuis Organizer Shell - EDIT LINE
	AX = 000Dh
	ES:BX -> text string
	CL = length
	CH = input type (see #2875)
	DH,DL = row,column of upper left corner
	DI = window handle
Return: AX = result code
Program: The PC Thuis Organizer Shell was written by John Vanderaart and
	  published in the June/July 1990 issue of PC Thuis Power magazine

Bitfields for input type:
Bit(s)	Description	(Table 2875)
 0	force uppercase
 1	integer
 2	no spaces allowed
 3	no cursor keys
--------l-50000E-----------------------------
INT 50 - PC Thuis Organizer Shell - PLOT CHARACTER
	AX = 000Eh
	BL = character
	BH = attribute
	DH,DL = row,column at which to plot
	DI = window handle
Return: AX = status
	    0000h successful
	    FFFFh errror
--------l-50000F-----------------------------
INT 50 - PC Thuis Organizer Shell - EMPTY WINDOW
	AX = 000Fh
	BL = character
	BH = attribute
	DI = window handle
--------l-500010-----------------------------
INT 50 - PC Thuis Organizer Shell - TRACE MENU
	AX = 0010h
	ES:BX -> first menu structure
	CL = hotkey to look up
Return: AL = index 1 or FFh if not selected
	AH = index 2 or FFh if not selected
	BL = index 3 or FFh if not selected
	BH = index 4 or FFh if not selected
Index:	hotkeys;PC Thuis Organizer Shell
--------l-500011-----------------------------
INT 50 - PC Thuis Organizer Shell - MOVE MEMORY
	AX = 0011h
	DS:SI -> source
	ES:DI -> destination
	CX = number of bytes to move (0000h = until NUL string terminator???)
SeeAlso: AX=0012h
--------l-500012-----------------------------
INT 50 - PC Thuis Organizer Shell - COMPARE MEMORY
	AX = 0012h
	DS:SI -> source
	ES:DI -> destination
	CX = number of bytes to compare (0000h=until NUL string terminator???)
Return: AX = status
	    0000h same
	    FFFFh different
SeeAlso: AX=0011h
--------l-500013-----------------------------
INT 50 - PC Thuis Organizer Shell - GET KEY
	AX = 0013h
	CH = type flags
	    bit 0: force uppercase
	    bit 1: integer
	    bit 2: no spaces
Return: AX = keystroke
--------l-500014-----------------------------
INT 50 - PC Thuis Organizer Shell - SCROLL WINDOW
	AX = 0014h
	BL = direction
	    06h up
	    07h down
	BH = attribute
	DI = window handle
SeeAlso: INT 10/AH=06h,INT 10/AH=07h
--------l-500015-----------------------------
INT 50 - PC Thuis Organizer Shell - GET MEMORY HANDLE
	AX = 0015h
	BL = handle size
	    00h 65536 bytes (64K)
	    01h 65535 bytes (64K-1)
	    02h 32768 bytes (32K)
	    03h 32767 bytes (32K-1)
Return: AX = segment
Program: The PC Thuis Organizer Shell was written by John Vanderaart and
	  published in the June/July 1990 issue of PC Thuis Power magazine
SeeAlso: INT 21/AH=48h
--------H-51---------------------------------
INT 51 - IRQ1 relocated by DESQview
Range:	INT 51 to INT F9, selected automatically
Note:	this is the default location for older versions; see INT 50"DESQview"
	  for details of interrupt relocation
SeeAlso: INT 50"DESQview",INT 54"DESQview",INT 58"DESQview"
--------H-51---------------------------------
INT 51 - IRQ1 relocated by IBM 3278 emulation control program
SeeAlso: INT 50"IBM 3278",INT 54"IBM 3278"
--------H-51---------------------------------
INT 51 - IRQ1 relocated by OS/2 v1.x
SeeAlso: INT 50"OS/2",INT 54"OS/2"
----------51---------------------------------
INT 51 - TI Professional PC - RESTART TIMING EVENT
	AX = timer count in 25ms intervals
	DS:DI -> timing-event table (see #2876)
Note:	documented as "for system use only"; intended for multi-tasking
	  software
SeeAlso: INT 50"TI Professional",INT 52"TI Professional"

Format of TI Professional PC timing event table:
Offset	Size	Description	(Table 2876)
 00h	WORD	offset of next event table entry
 02h	BYTE	normally unused (FFh)
 03h	BYTE	flags:
		bit 7 set if timing event active
		bits 6-0 not used by BIOS (0), but could be used by option ROMs
 04h	WORD	timeout count (decremented every 25ms when active)
 06h	WORD	offset of event handler (in segment F400h) to call on event
		  timeout; the F400h segment allows addressing both system ROMs
		  and the first 16K of memory (due to the 1M memory wraparound)
--------b-51---------------------------------
INT 51 - Tandy 2000 - KEYBOARD SERVICES
Note:	this interrupt is identical to INT 16 on Tandy 2000
SeeAlso: INT 16/AH=00h,INT 16/AH=01h,INT 16/AH=02h,INT 16/AH=04h"Tandy"
SeeAlso: INT 16/AH=04h,INT 4A"Tandy 2000",INT 4C"Tandy 2000",INT 52"Tandy 2000"
--------H-52---------------------------------
INT 52 - IRQ2 relocated by DESQview
Range:	INT 52 to INT FA, selected automatically
Note:	this is the default location for older versions; see INT 50"DESQview"
	  for details of interrupt relocation
SeeAlso: INT 50"DESQview",INT 54"DESQview",INT 58"DESQview"
--------H-52---------------------------------
INT 52 - IRQ2 relocated by IBM 3278 emulation control program, OS/2 v1.x
SeeAlso: INT 50"IBM 3278",INT 51"OS/2"
----------52---------------------------------
INT 52 - TI Professional PC - CANCEL TIMING EVENT
	DS:DI -> timing-event table (see #2876)
Note:	documented as "for system use only"; intended for multi-tasking
	  software
SeeAlso: INT 51"TI Professional",INT 53"TI Professional"
--------b-52---------------------------------
INT 52 - Tandy 2000 - VIDEO SERVICES
Note:	this interrupt is identical to INT 10
SeeAlso: INT 10/AH=00h,INT 10/AH=01h,INT 10/AH=08h,INT 10/AH=0Eh
SeeAlso: INT 4A"Tandy 2000",INT 51"Tandy 2000",INT 53"Tandy 2000"
--------H-53---------------------------------
INT 53 - IRQ3 relocated by DESQview
Range:	INT 53 to INT FB, selected automatically
Note:	this is the default location for older versions; see INT 50"DESQview"
	  for details of interrupt relocation
SeeAlso: INT 50"DESQview",INT 54"DESQview",INT 58"DESQview"
--------H-53---------------------------------
INT 53 - IRQ3 relocated by IBM 3278 emulation control program, OS/2 v1.x
SeeAlso: INT 50"IBM 3278",INT 51"OS/2"
----------53---------------------------------
INT 53 - TI Professional PC - SVC INTERFACE
Notes:	documented as "for system use only"; intended for multi-tasking
	  software
	this interrupt is not used by the BIOS; the default handler generates
	  a system error trap (see INT 51"TI Professional")
SeeAlso: INT 50"TI Professional",INT 54"TI Professional"
--------b-53---------------------------------
INT 53 - Tandy 2000 - SERIAL COMMUNICATIONS
Note:	this interrupt is identical to INT 14 on Tandy 2000
SeeAlso: INT 14/AH=00h"SERIAL",INT 14/AH=01h,INT 14/AH=02h,INT 14/AH=03h
SeeAlso: INT 14/AH=04h"Tandy 2000",INT 52"Tandy 2000",INT 54"Tandy 2000"
--------N-53---------------------------------
INT 53 - WEB??? - API
	BX = function
	    0000h ???
		AX = ???
		Return: AX = ???
	    0004h ???
	    0009h ???
	    0015h
		AX = ???
		DX = ???
	    0017h
Return: ???
Notes:	the installation check consists of looking for the signature "WEBCO"
	  immediately prior to the interrupt handler
	the above calls are made by Show Partner F/X v3.6 (see INT 10/AH=53h)
Index:	installation check;unknown|installation check;WEBCO
--------H-54---------------------------------
INT 54 - IRQ4 relocated by DESQview
Range:	INT 54 to INT FC, selected automatically
Note:	this is the default location for older versions; see INT 50"DESQview"
	  for details of interrupt relocation
SeeAlso: INT 50"DESQview",INT 58"DESQview"
--------H-54---------------------------------
INT 54 - IRQ4 relocated by IBM 3278 emulation control program, OS/2 v1.x
SeeAlso: INT 51"IBM 3278",INT 51"OS/2"
----------54---------------------------------
INT 54 - TI Professional PC - ACTIVATE TASK SUBROUTINE
Notes:	documented as "for system use only"; intended for multi-tasking
	  software
	this interrupt is not used by the BIOS; the default handler generates
	  a system error trap (see INT 51"TI Professional")
SeeAlso: INT 50"TI Professional",INT 53"TI Professional"
--------b-54---------------------------------
INT 54 - Tandy 2000 - LINE PRINTER
Note:	this interrupt is identical to INT 17 on Tandy 2000
SeeAlso: INT 17/AH=00h,INT 17/AH=01h,INT 17/AH=02h,INT 4A"Tandy 2000"
SeeAlso: INT 53"Tandy 2000",INT 55"Tandy 2000"
--------X-545400-----------------------------
INT 54 U - Toshiba PCMCIA2 - INSTALLATION CHECK
	AX = 5400h
Return: AX = 0054h if installed
	    CX:DX -> INT function handler
--------H-55---------------------------------
INT 55 - IRQ5 relocated by DESQview
Range:	INT 55 to INT FD, selected automatically
Note:	this is the default location for older versions; see INT 50"DESQview"
	  for details of interrupt relocation
SeeAlso: INT 50"DESQview",INT 58"DESQview"
--------H-55---------------------------------
INT 55 - IRQ5 relocated by IBM 3278 emulation control program, OS/2 v1.x
SeeAlso: INT 51"IBM 3278",INT 51"OS/2"
--------b-55---------------------------------
INT 55 - TI Professional PC - RESERVED FOR FUTURE USE
Notes:	documented as "for system use only"; intended for multi-tasking
	  software
	this interrupt is not used by the BIOS; the default handler generates
	  a system error trap (see INT 51"TI Professional")
SeeAlso: INT 50"TI Professional",INT 56"TI Professional"
--------b-55---------------------------------
INT 55 - Tandy 2000 - SYSTEM CLOCK
Note:	this interrupt is identical to INT 1A on Tandy 2000
SeeAlso: INT 1A/AH=00h,INT 1A/AH=01h,INT 1A/AH=02h"Tandy 2000"
SeeAlso: INT 1A/AH=03h"Tandy 2000",INT 54"Tandy 2000",INT 56"Tandy 2000"
--------H-56---------------------------------
INT 56 - IRQ6 relocated by DESQview
Range:	INT 56 to INT FE, selected automatically
Note:	this is the default location for older versions; see INT 50"DESQview"
	  for details of interrupt relocation
SeeAlso: INT 50"DESQview",INT 58"DESQview"
--------H-56---------------------------------
INT 56 - IRQ6 relocated by IBM 3278 emulation control program, OS/2 v1.x
SeeAlso: INT 51"IBM 3278",INT 51"OS/2"
--------b-56---------------------------------
INT 56 - TI Professional PC - RESERVED FOR FUTURE USE
Notes:	documented as "for system use only"; intended for multi-tasking
	  software
	this interrupt is not used by the BIOS; the default handler generates
	  a system error trap (see INT 51"TI Professional")
SeeAlso: INT 50"TI Professional",INT 55"TI Professional"
--------b-56---------------------------------
INT 56 - Tandy 2000 - FLOPPY DISK SERVICES
Note:	this interrupt is identical to INT 13 on Tandy 2000
SeeAlso: INT 13/AH=00h,INT 13/AH=01h,INT 13/AH=02h,INT 13/AH=03h
SeeAlso: INT 4A"Tandy 2000",INT 51"Tandy 2000",INT 55"Tandy 2000"
--------H-57---------------------------------
INT 57 - IRQ7 relocated by DESQview
Range:	INT 57 to INT FF, selected automatically
Note:	this is the default location for older versions; see INT 50"DESQview"
	  for details of interrupt relocation
SeeAlso: INT 50"DESQview",INT 58"DESQview"
--------H-57---------------------------------
INT 57 - IRQ7 relocated by IBM 3278 emulation control program, OS/2 v1.x
SeeAlso: INT 51"IBM 3278",INT 51"OS/2"
--------b-57---------------------------------
INT 57 C - TI Professional PC - CRT MAPPING HOOK
	AX/BX/CX/DX/BP/SI/DI same as on entry to CRT subroutine (e.g. INT 49)
	DS = BIOS system segment
	ES = DE00h
Return: DF/IF flags must be preserved
	ES,DS,BP preserved
	AX,BX,CX,DX,SI,DI may be changed as necessary to modify the original
	  call
Desc:	hooking this vector permits programs to intercept or modify all
	  screen output, including both application calls to INT 49 and
	  calls generated internally by the BIOS which bypass INT 49
Note:	by default, this vector points at an IRET instruction
SeeAlso: INT 49/AH=01h"TI",INT 50"TI Professional"
--------H-58---------------------------------
INT 58 - IRQ8 relocated by DESQview 2.26+
Range:	INT 58 to INT F8, selected automatically
Note:	this is the default, but other INTs may be used (see INT 50"DESQview")
SeeAlso: INT 50"DESQview",INT 59"DESQview",INT 70
--------H-58---------------------------------
INT 58 - IRQ0 relocated by DoubleDOS
SeeAlso: INT 08
--------b-58---------------------------------
INT 58 C - TI Professional PC - SYSTEM TIMER 25ms HOOK
Desc:	called from the hardware timer tick interrupt, after executing the
	  first four BIOS timing events, updating the system clock, invoking
	  INT 5A if required, saving registers, and switching to a temporary
	  stack (the one reserved for IRQ3)
Notes:	the handler for this interrupt may destroy AX,BX,DI,ES but must
	  preserve all other registers; 8 WORDs of stack space are available,
	  of which at most 4 may be used if the handler enables interrupts
	if the handler switches stacks (because more than 4/8 WORDs are
	  required), the original stack must be restored before chaining to
	  the previous handler
SeeAlso: INT 43"TI Professional",INT 4C"TI Professional"
SeeAlso: INT 5A"TI Professional"
--------H-59---------------------------------
INT 59 - IRQ9 relocated by DESQview 2.26+
Range:	INT 59 to INT F9, selected automatically
Note:	this is the default, but other INTs may be used (see INT 50"DESQview")
SeeAlso: INT 50"DESQview",INT 58"DESQview",INT 5A"DESQview",INT 71
--------H-59---------------------------------
INT 59 - IRQ1 relocated by DoubleDOS
SeeAlso: INT 09
--------b-59---------------------------------
INT 59 - TI Professional PC - COMMON ROM HARDWARE INTERRUPT EXIT VECTOR
Desc:	all hardware interrupts on the TI Pro jump indirectly to the handler
	  pointed at by this interrupt vector to finish their handling of
	  the hardware interrupt
Notes:	the default handler decrements the interrupt count, restores registers
	  (including the stack pointer), sends an EOI to the interrupt
	  controller, and finally does an IRET
	can be used by multitaskers which need to get control after every
	  hardware interrupt
SeeAlso: INT 40"TI Professional",INT 47"TI Professional"
SeeAlso: INT 53"TI Professional"
--------V-59---------------------------------
INT 59 - GSS Computer Graphics Interface (GSS*CGI)
	DS:DX -> block of 5 array pointers
Return: CF set on error
	    AX = error code
	CF clear if successful
	    AX = return code
Note:	INT 59 is the means by which GSS*CGI language bindings communicate with
	  GSS*CGI device drivers and the GSS*CGI device driver controller.
	also used by the IBM Graphic Development Toolkit
--------H-5A---------------------------------
INT 5A - IRQ10 relocated by DESQview 2.26+
Range:	INT 5A to INT FA, selected automatically
Note:	this is the default, but other INTs may be used (see INT 50"DESQview")
SeeAlso: INT 50"DESQview",INT 59"DESQview",INT 5B"DESQview",INT 72
--------H-5A---------------------------------
INT 5A - IRQ2 relocated by DoubleDOS
SeeAlso: INT 0A"IRQ2"
--------N-5A---------------------------------
INT 5A - PC Cluster adapter BIOS entry address
	???
Return: ???
SeeAlso: INT 5B"PC Cluster"
--------b-5A---------------------------------
INT 5A - TI Professional PC - SYSTEM TIMER 100ms HOOK
Desc:	called from the hardware timer tick interrupt, after executing the
	  first four BIOS timing events, updating the system clock, saving
	  registers, and switching to a temporary stack (the one reserved
	  for IRQ3), but before calling INT 58
	no details available
Notes:	this interrupt is invoked on every fourth timer interrupt
	the handler for this interrupt may destroy AX,BX,DI,ES but must
	  preserve all other registers; 8 WORDs of stack space are available,
	  of which at most 4 may be used if the handler enables interrupts
	if the handler switches stacks (because more than 4/8 WORDs are
	  required), the original stack must be restored before chaining to
	  the previous handler
SeeAlso: INT 43"TI Professional",INT 4C"TI Professional"
SeeAlso: INT 58"TI Professional"
--------H-5B---------------------------------
INT 5B - IRQ11 relocated by DESQview 2.26+
Range:	INT 5B to INT FB, selected automatically
Note:	this is the default, but other INTs may be used (see INT 50"DESQview")
SeeAlso: INT 50"DESQview",INT 5A"DESQview",INT 5C"DESQview",INT 73
--------H-5B---------------------------------
INT 5B - IRQ3 relocated by DoubleDOS
SeeAlso: INT 0B
--------N-5B---------------------------------
INT 5B - PC cluster adapter - RELOCATED INT 19
SeeAlso: INT 19,INT 5A"PC Cluster"
--------N-5B---------------------------------
INT 5B - AT&T Starlan Extended NetBIOS (variable length names)
	ES:BX -> Network Control Block (see #2877)
Return: AL = status (see #2880)
SeeAlso: INT 5C"NetBIOS"

Format of Starlan Network Control Block:
Offset	Size	Description	(Table 2877)
 00h	BYTE	ncb_command (see also #2882)
		70h send net Break
 01h	BYTE	ncb_retcode
 02h	BYTE	ncb_lsn
 03h	BYTE	ncb_num
 04h	DWORD	-> ncb_buffer
 08h	WORD	ncb_length
 0Ah 16 BYTEs	ncb_callname
 1Ah 16 BYTEs	ncb_name
 2Ah	BYTE	ncb_rto
 2Bh	BYTE	ncb_sto
 2Ch	DWORD	-> ncb_post	/* int (far *ncb_post)(); */
 30h	BYTE	ncb_lana_num
 31h	BYTE	ncb_cmd_cplt
 32h	DWORD	-> ncb_vname
 36h	BYTE	ncb_vnamelen
 37h  9 BYTEs	ncb_reserve
Note:	fields 00h-31h are the same as for a standard NetBIOS NCB (see #2881)
--------N-5B---------------------------------
INT 5B - Microsoft Network Transport Layer Interface
Note:	used by MS-NET for executing network commands
SeeAlso: INT 5C"NetBIOS"
--------N-5B---------------------------------
INT 5B - used by Alloy NTNX
--------N-5B---------------------------------
INT 5B - ISOLAN Multi Protocol Software
	ES:BX -> Transfer Control Block (see #2878)
Return: AL = status
Note:	this software interface allows multiple protocols/software packages
	  to access a BICC 411x network card

Format of ISOLAN Transfer Control Block:
Offset	Type	Description	(Table 2878)
 00h	BYTE	command code
		B3h Status
		F2h Activate
		F3h Deactivate
		F4h Send Data
 01h	BYTE	command identity
 02h	BYTE	virtual circuit ID
 03h	WORD	buffer length
 05h	DWORD	buffer pointer
 09h	BYTE	expedited data flag
 0Ah	BYTE	cancelable flag
 0Bh 16 BYTEs	local network address
 1Bh 16 BYTEs	remote network address
 2Bh	DWORD	asynchronous notification routine
 30h	DWORD	local network number
 34h	DWORD	remote network number
 38h	BYTE	call timeout
 39h	BYTE	not used
 3Ah  8 BYTEs	reserved
 42h	BYTE	command code extension
 43h	WORD	Blue Book MAC type
--------b-5B---------------------------------
INT 5B C - TI Professional PC - KEYBOARD MAPPING HOOK
	CF set
	AH = shift state (see #2879)
	AL = scan code (see #2846)
Return:	BX, CX, DI, ES may be destroyed
	various return methods are supported:
	    IRET, AX unchanged: process keystroke normally
	    IRET, AL = FFh: discard keystroke
	    IRET, AX changed: process modified keystroke
	    chain to old INT 5B: allow other handlers to look at (possibly
		  modified) keystroke in AX
	    RETF 2, CF clear: place returned AX into keyboard buffer without
		  any further processing
Notes:	invoked by the keyboard ISR, and used to remap the keyboard
	if CF is clear on entry, some other handler has processed the
	  keystroke and the current handler should not modify it, instead
	  performing a RETF 2 or IRET (after clearing CF on the stack)
	when requesting that a value be placed directly into the keyboard
	  buffer, AL and AH may not *both* be nonzero (the TI does not
	  return scan codes as part of the key code for non-extended keys)
SeeAlso: INT 15/AH=4Fh,INT 4A/AH=00h"TI",INT 59"TI Professional"
SeeAlso: INT 5C"TI Professional",INT 5D"TI Professional"
SeeAlso: INT 5E"TI Professional",INT 5F"TI Professional"

Bitfields for TI Professional PC keyboard mapping hook shift states:
Bit(s)	Description	(Table 2879)
 7	CAPS LOCK is on
 6-4	reserved (0)
 3	repeated key
 2	Shift is pressed
 1	Alt is pressed
 0	Ctrl is pressed
--------U-5B5254DL04-------------------------
INT 5B U - SitBack v3.02R - GET ???
	AX = 5254h
	DL = 04h
Return: ES:BX -> ??? in resident portion
Program: SitBack is a background file backup utility by SitBack Technologies,
	  Inc. which initiates backups whenever the system is idle
SeeAlso: AX=8485h/DL=71h,AX=8485h/DL=72h
--------U-5B8485DL70-------------------------
INT 5B U - SitBack v3.02R - INSTALLATION CHECK
	AX = 8485h
	DL = 70h
Return: CX = 8485h if installed
	    DX:AX -> ??? (configuration data?)
Program: SitBack is a background file backup utility by SitBack Technologies,
	  Inc. which initiates backups whenever the system is idle
SeeAlso: AX=5254h/DL=04h,AX=8485h/DL=78h
--------U-5B8485DL71-------------------------
INT 5B U - SitBack v3.02R - SET ??? FLAG AND GET ??? ADDRESS
	AX = 8485h
	DL = 71h
Return: ES:BX -> FAR entry point to ???
Note:	the flag which is modified is located at the address returned by
	   AX=5254h/DL=04h
SeeAlso: AX=8485h/DL=72h
--------U-5B8485DL72-------------------------
INT 5B U - SitBack v3.02R - CLEAR ??? FLAG
	AX = 8485h
	DL = 72h
Note:	the flag which is modified is located at the address returned by
	   AX=5254h/DL=04h
SeeAlso: AX=8485h/DL=71h
--------U-5B8485DL73-------------------------
INT 5B U - SitBack v3.02R - ???
	AX = 8485h
	DL = 73h
	???
Return: ???
--------U-5B8485DL74-------------------------
INT 5B U - SitBack v3.02R - ???
	AX = 8485h
	DL = 74h
	???
Return: ???
--------U-5B8485DL75-------------------------
INT 5B U - SitBack v3.02R - ???
	AX = 8485h
	DL = 75h
	CX = ???
Return: ???
SeeAlso: AX=8485h/DL=76h
--------U-5B8485DL76-------------------------
INT 5B U - SitBack v3.02R - ???
	AX = 8485h
	DL = 76h
	CX = ???
Return: ???
Note:	conditionally calls the code for AX=8485h/DL=75h
SeeAlso: AX=8485h/DL=75h
--------U-5B8485DL77-------------------------
INT 5B U - SitBack v3.02R - SET ??? FLAG
	AX = 8485h
	DL = 77h
--------U-5B8485DL78-------------------------
INT 5B U - SitBack v3.02R - GET RESIDENT DATA SEGMENT
	AX = 8485h
	DL = 78h
Return: CX = 5342h if supported
	    ES = AX = segment of TSR data
SeeAlso: AX=8485h/DL=70h,AX=8485h/DL=79h
--------U-5B8485DL79-------------------------
INT 5B U - SitBack v3.02R - GET DTA
	AX = 8485h
	DL = 79h
Return: CX = 5342h if supported
	    ES:BX -> DTA set by last INT 21/AH=1Ah
Note:	this function is provided by SBOS.EXE rather than SB.EXE
SeeAlso: INT 21/AH=1Ah
--------U-5B8485DL7A-------------------------
INT 5B U - SitBack v3.02R - TOGGLE ???
	AX = 8485h
	DL = 7Ah
Return: CX = 5342h if supported
	    AL = new value of ??? (00h or 01h)
--------N-5C---------------------------------
INT 5C - NetBIOS INTERFACE
	ES:BX -> network control block (NCB) (see #2881)
Return: AL = status (see #2880)
Program: NetBIOS was developed by Sytek, Inc. in 1984 as a high-level
	  programming interface to the IBM PC Network; the first implementation
	  was a ROM BIOS extension on Sytek's PCnet LAN adapter card, but many
	  current networks support NetBIOS as the session layer.
Note:	The Sytek PCnet card uses DMA 3.
SeeAlso: INT 2A/AH=01h,INT 2A/AH=04h,INT 5B"Extended NetBIOS"

(Table 2880)
Values for NetBIOS status:
 00h	successful
 01h	bad buffer size
 03h	invalid NETBIOS command
 05h	timeout
 06h	receive buffer too small
 07h	No-ACK command failed
 08h	bad session number
 09h	LAN card out of memory
 0Ah	session closed
 0Bh	command has been cancelled
 0Dh	name already exists
 0Eh	local name table full
 0Fh	name still in use, can't delete
 11h	local session table full
 12h	remote PC not listening
 13h	bad NCB_NUM field
 14h	no answer to CALL or no such remote
 15h	name not in local name table
 16h	duplicate name
 17h	bad delete
 18h	abnormal end
 19h	name error, multiple identical names in use
 1Ah	bad packet
 21h	network card busy
 22h	too many commands queued
 23h	bad LAN card number
 24h	command finished while cancelling
 26h	command can't be cancelled
 30h	name defined by another process (OS/2)
 34h	NetBIOS environment not defined, must issue reset (OS/2)
 35h	required operating system resources exhausted (OS/2)
 36h	maximum applications exceeded (OS/2)
 37h	no SAPs available for NetBIOS (OS/2)
 38h	requested resources not available (OS/2)
 40h	Lana System Error
 41h	Lana Remote Hot Carrier
 42h	Lana Local Hot Carrier
 43h	Lana No Carrier Detected
 44h	unusual network condition
 45h-4Dh hardware error
 4Eh	token ring is broken
 4Fh	token ring error
 50h	adapter malfunction
 F7h	error in explicit INITIALIZE
 F8h	error in implicit OPEN
 F9h	TOKREUI internal error
 FAh	hardware adapter testing
 FBh	NetBIOS emulator not found
 FCh	OPEN or OPEN_SAP failure
 FDh	unexpected adapter closure
 FFh	NetBIOS busy (command pending)

Format of NetBIOS Network Control Block:
Offset	Size	Description	(Table 2881)
 00h	BYTE	command code (see #2882)
 01h	BYTE	return code (see #2880)
 02h	BYTE	local session number (LSN)
 03h	BYTE	"ncb_num" datagram table entry from ADD NAME
 04h	DWORD	-> I/O buffer
 08h	WORD	length of data in buffer
 0Ah 16 BYTEs	remote system to call
 1Ah 16 BYTEs	network name of local machine
 2Ah	BYTE	receive timeout in 1/2 seconds
 2Bh	BYTE	send timeout in 1/2 seconds
 2Ch	DWORD	-> FAR post handler	/* int (far *ncb_post)(); */
 30h	BYTE	network adapter number on which to execute command
		00h-03h IBM NetBIOS specs
		F0h-FFh Eicon NABios interface (see also INT 7B"Eicon")
 31h	BYTE	command completion code (see #2880)
 32h 14 BYTEs	reserved for network card

(Table 2882)
Values for NetBIOS command code field in NCB:
 10h	start session with NCB_NAME name (call)
 11h	listen for call
 12h	end session with NCB_NAME name (hangup)
 14h	send data via NCB_LSN
 15h	receive data from a session
 16h	receive data from any session
 17h	send multiple data buffers
 20h	send unACKed message (datagram)
 21h	receive datagram
 22h	send broadcast datagram
 23h	receive broadcast datagram
 30h	add name to name table
 31h	delete name from name table
 32h	reset adapter card and tables
 33h	get adapter status (see #2883)
 34h	status of all sessions for name (see #2885)
 35h	cancel
 36h	add group name to name table
 48h	send data and receive data (LAN Manager NETBEUI.DOS)
 70h	unlink from IBM remote program (no F0h function)
 71h	send data without ACK
 72h	send multiple buffers without ACK
 72h	UngermannBass Register (conflicts with above function)
 73h	UngermannBass SendNmc
 74h	UngermannBass Callniu
 75h	UngermannBass Calladdr
 76h	UngermannBass Listenaddr
 77h	UngermannBass SendPkt
 78h	find name
 78h	UngermannBass RcvPkt (conflicts with above function)
 79h	token-ring protocol trace
 79h	UngermannBass SendAttn (conflicts with above function)
 7Ah	UngermannBass RcvAttn
 7Bh	UngermannBass Listenniu
 7Ch	UngermannBass RcvRaw
 7Dh	UngermannBass SendNmc2
 7Fh	Beame&Whiteside BWNB installation check (returns with return code and
	  completion code both set to 03h, while invalid functions return only
	  return code field set to 03h)
Note:	OR any of the above except 70h with 80h for non-waiting call

Format of NetBIOS structure "astatus":
Offset	Size	Description	(Table 2883)
 00h  6 BYTEs as_id
 06h	BYTE  as_jumpers
 07h	BYTE  as_post
 08h	BYTE  as_major
 09h	BYTE  as_minor
 0Ah	WORD  as_interval
 0Ch	WORD  as_crcerr
 0Eh	WORD  as_algerr
 10h	WORD  as_colerr
 12h	WORD  as_abterr
 14h	DWORD as_tcount
 18h	DWORD as_rcount
 1Ch	WORD  as_retran
 1Eh	WORD  as_xresrc
 20h  8 BYTEs as_res0
 28h	WORD  as_ncbfree
 2Ah	WORD  as_ncbmax
 2Ch	WORD  as_ncbx
 2Eh  4 BYTEs as_res1
 32h	WORD  as_sespend
 34h	WORD  as_msp
 36h	WORD  as_sesmax
 38h	WORD  as_bufsize
 3Ah	WORD  as_names
 3Ch 16 name structures	 as_name (see #2884)

Format of NetBIOS structure "name":
Offset	Size	Description	(Table 2884)
 00h 16 BYTEs "nm_name" symbolic name
 10h	BYTE  "nm_num" number associated with name
 11h	BYTE  nm_status

Format of NetBIOS structure "sstatus":
Offset	Size	Description	(Table 2885)
 00h	BYTE	number of sessions being reported
 01h	BYTE	number of sessions with this name
 02h	BYTE	number of outstanding receive datagrams
 03h	BYTE	number of outstanding ReceiveAnys
 04h	var	session structures (see #2886)

Format of NetBIOS structure "session":
Offset	Size	Description	(Table 2886)
 00h	BYTE	local session number
 01h	BYTE	state
		01h listen pending
		02h call pending
		03h session established
		04h hangup pending
		05h hangup done
		06h session aborted
 02h 16 BYTEs	local name
 12h 16 BYTEs	remote name
 22h	BYTE	number of outstanding receives
 23h	BYTE	number of outstanding sends/chainsends
--------H-5C---------------------------------
INT 5C - IRQ12 relocated by DESQview 2.26+
Range:	INT 5C to INT FC, selected automatically
Note:	this is the default, but other INTs may be used (see INT 50"DESQview")
SeeAlso: INT 50"DESQview",INT 5B"DESQview",INT 5D"DESQview",INT 74
--------H-5C---------------------------------
INT 5C - IRQ4 relocated by DoubleDOS
SeeAlso: INT 0C
--------N-5C---------------------------------
INT 5C - TOPS INTERFACE
	ES:BX -> Network Control Block
Note:	TOPS card uses DMA 1, 3 or none.
--------N-5C---------------------------------
INT 5C - ATALK.SYS - AppleTalk INTERFACE
	DX:BX -> control block (see #2888)
Return: none
Range:	INT 5Ch to INT 70h
Notes:	the signature 'AppleTalk' appears 16 bytes prior to the interrupt
	  handler; this serves as the installation check
Index:	installation check;ATALK.SYS|installation check;AppleTalk interface

(Table 2887)
Values for ATALK.SYS command code:
 01h	"AT_INIT"	    initialize the driver
 02h	"AT_KILL"
 03h	"AT_GETNETINFO" get current network info incl init status
 04h	"AT_GETCLOCKTICKS"
 05h	"AT_STARTTIMER"
 06h	"AT_RESETTIMER"
 07h	"AT_CANCELTIMER"
 10h	"LAP_INSTALL"
 11h	"LAP_REMOVE"
 12h	"LAP_WRITE"
 13h	"LAP_READ"
 14h	"LAP_CANCEL"
 20h	"DDP_OPENSOCKET"
 21h	"DDP_CLOSESOCKET"
 22h	"DDP_WRITE"
 23h	"DDP_READ"
 24h	"DDP_CANCEL"
 30h	"NBP_REGISTER"
 31h	"NBP_REMOVE"
 32h	"NBP_LOOKUP"
 33h	"NBP_CONFIRM"
 34h	"NBP_CANCEL"
 35h	"ZIP_GETZONELIST"
 36h	"ZIP_GETMYZONE"
 37h	"ZIP_TAKEDOWN"
 38h	"ZIP_BRINGUP"
 40h	"ATP_OPENSOCKET"
 41h	"ATP_CLOSESOCKET"
 42h	"ATP_SENDREQUEST"
 43h	"ATP_GETREQUEST"
 44h	"ATP_SENDRESPONSE"
 45h	"ATP_ADDRESPONSE"
 46h	"ATP_CANCELTRANS"
 47h	"ATP_CANCELRESPONSE"
 48h	"ATP_CANCELREQUEST"
 50h	"ASP_GETPARMS"
 51h	"ASP_CLOSESESSION"
 52h	"ASP_CANCEL"
 53h	"ASP_INIT"
 54h	"ASP_KILL"
 55h	"ASP_GETSESSION"
 56h	"ASP_GETREQUEST"
 57h	"ASP_CMDREPLY"
 58h	"ASP_WRTCONTINUE"
 59h	"ASP_WRTREPLY"
 5Ah	"ASP_CLOSEREPLY"
 5Bh	"ASP_NEWSTATUS"
 5Ch	"ASP_ATTENTION"
 5Dh	"ASP_GETSTATUS"
 5Eh	"ASP_OPENSESSION"
 5Fh	"ASP_COMMAND"
 60h	"ASP_WRITE"
 61h	"ASP_GETATTENTION"
 70h	"PAP_OPEN"
 71h	"PAP_CLOSE"
 72h	"PAP_READ"
 73h	"PAP_WRITE"
 74h	"PAP_STATUS"
 75h	"PAP_REGNAME"
 76h	"PAP_REMNAME"
 77h	"PAP_INIT"
 78h	"PAP_NEWSTATUS"
 79h	"PAP_GETNEXTJOB"
 7Ah	"PAP_KILL"
 7Bh	"PAP_CANCEL"

Format of AppleTalk control block:
Offset	Size	Description	(Table 2888)
 00h	WORD	command code (see #2887)
		OR with the following flags
		8000h start command then return
		4000h wait for interrupt service to complete
 02h	WORD	returned status
		0000h success (already initialized if func 01h)
 04h	DWORD	pointer to completion function
 08h	WORD	network number
 0Ah	BYTE	node ID
---if general func (01h,03h), control block continues:
 0Bh	BYTE	"inf_abridge"
 0Ch	WORD	"inf_config"
 0Eh	DWORD	pointer to buffer
 12h	WORD	buffer size
---if DDP function (20h-24h), control block continues:
 0Bh	BYTE	"ddp_addr_socket"
 0Ch	BYTE	"ddp_socket"
 0Dh	BYTE	"ddp_type"
 0Eh	DWORD	pointer to buffer
 12h	WORD	buffer size
 14h	BYTE	"ddp_chksum"
---if Name Binding Protocol (30h-34h), control block continues:
 0Bh	BYTE	"nbp_addr_socket"
 0Ch	WORD	"nbp_toget"
 0Eh	DWORD	pointer to buffer (see #2889)
 12h	WORD	buffer size
 14h	BYTE	"nbp_interval"
 15h	BYTE	"nbp_retry"
 16h	DWORD	"nbp_entptr"
---if AppleTalk Transaction Protocol (42h), control block continues:
 0Bh	BYTE	"atp_addr_socket"
 0Ch	WORD	"atp_socket"
 0Eh	DWORD	pointer to buffer
 12h	WORD	buffer size
 14h	BYTE	"atp_interval"
 15h	BYTE	"atp_retry"
 16h	BYTE	ATP flags
		bit 5: exactly one transaction
 17h	BYTE	"atp_seqbit"
 18h	BYTE	transaction ID
 19h  4 BYTEs	ATP user bytes
 1Dh	BYTE	number of BDS buffers
 1Eh	BYTE	number of BDS responses
 1Fh	DWORD	pointer to BDS buffers (see #2890)

Format of Name Binding Protocol Name-to-Address binding entries for NBP_LOOKUP:
Offset	Size	Description	(Table 2889)
 00h	WORD	"tup_address_network"
 02h	BYTE	"tup_address_notid"
 03h	BYTE	"tup_address_socket"
 04h	BYTE	"tup_enum"
 05h 99 BYTEs	name

Format of BDS entries:
Offset	Size	Description	(Table 2890)
 00h	DWORD	pointer to buffer
 04h	WORD	size of buffer
 06h	WORD	BDS data size
 08h  4 BYTEs	"bds_userbytes"
--------N-5C---------------------------------
INT 5C - IBM 802.2 INTERFACE (LLC)
	ES:BX -> CCB (see #2891)
Return: none

Format of IBM 802.2 CCB:
Offset	Size	Description	(Table 2891)
 00h	BYTE	adapter
 01h	BYTE	command code
 02h	BYTE	return code
 03h	BYTE	work
 04h	DWORD	pointer to ???
 08h	DWORD	pointer to completion function???
 0Ch	DWORD	pointer to parameters???
--------N-5C---------------------------------
INT 5C - $25 LAN - INSTALLATION CHECK
Notes:	current versions only check whether the vector is 0000h:0000h or not
	future versions are supposed to have the signature "NET" in the three
	  bytes preceding the INT 5C handler
--------b-5C0100-----------------------------
INT 5C C - TI Professional PC - KEYBOARD PAUSE KEY VECTOR
	AX = 0100h
	CF clear
Return: CF clear
	    AX = keystroke to be placed into keyboard buffer
	CF set
	    AX ignored
Desc:	toggle a pause flag which is checked by the CRT Device Service Routine
	  (see INT 49/AH=01h"TI") and causes it to temporarily halt the
	  machine on the next video-related function (until a key is pressed)
SeeAlso: INT 09"IRQ1",INT 4A/AH=00h"TI",INT 59"TI Professional"
SeeAlso: INT 5B"TI Professional",INT 5D"TI Professional"
SeeAlso: INT 5E"TI Professional",INT 5F"TI Professional"
--------N-5C04-------------------------------
INT 5C - $25 LAN - CHECK IF CONNECTION ALIVE
	AH = 04h
	AL = COM port (0 = default)
	CX = wait count in character times (should be at least 100)
Return: ZF set if link alive
--------H-5D---------------------------------
INT 5D - IRQ13 relocated by DESQview 2.26+
Range:	INT 5D to INT FD, selected automatically
Note:	this is the default, but other INTs may be used (see INT 50"DESQview")
SeeAlso: INT 50"DESQview",INT 5C"DESQview",INT 5E"DESQview",INT 75
--------H-5D---------------------------------
INT 5D - IRQ5 relocated by DoubleDOS
SeeAlso: INT 0D"IRQ5",INT 5C"DoubleDOS"
--------b-5D---------------------------------
INT 5D C - TI Professional PC - KEYBOARD BREAK KEY VECTOR
	CF clear
	AX = 0000h
Return: CF clear
	    AX = keystroke to place into keyboard buffer
	CF set
	    AX ignored
Desc:	invoked by the keyboard ISR when Shift-BrkPause is pressed
Note:	the default handler is a simple IRET instruction
SeeAlso: INT 09"IRQ1",INT 4A/AH=00h"TI",INT 59"TI Professional"
SeeAlso: INT 5B"TI Professional",INT 5C"TI Professional"
SeeAlso: INT 5E"TI Professional",INT 5F"TI Professional"
--------H-5E---------------------------------
INT 5E - IRQ14 relocated by DESQview 2.26+
Range:	INT 5E to INT FE, selected automatically
Note:	this is the default, but other INTs may be used (see INT 50"DESQview")
SeeAlso: INT 50"DESQview",INT 5D"DESQview",INT 5F"DESQview",INT 76
--------H-5E---------------------------------
INT 5E - IRQ6 relocated by DoubleDOS
SeeAlso: INT 0E,INT 5D"DoubleDOS"
--------b-5E---------------------------------
INT 5E C - TI Professional PC - KEYBOARD PRINT-SCREEN VECTOR
	CF set
Return: CF clear
	    AX = keystroke to be placed into keyboard buffer
	CF set
	    AX ignored
Desc:	hook to dump the screen to the printer
Notes:	hooked by TI MS-DOS, which provides a PRTSCRN character device which
	  can invoke screen prints when a decimal digit (indicating the type
	  of screen dump) is written to it
	the TI MS-DOS print-screen routine allows selective dumps of text
	  only, graphics only, or text and graphics superimposed, in either
	  normal or reverse, by pressing the appropriate keystroke combination:
	  Shift-Print, Ctrl-Print, Alt-Print, Shift-Alt-Print, Ctrl-Alt-Print,
	  or Shift-Ctrl-Print.
	the BIOS default routine for this vector is an IRET
SeeAlso: INT 05"PRINT SCREEN",INT 4A/AH=00h"TI",INT 59"TI Professional"
SeeAlso: INT 5B"TI Professional",INT 5C"TI Professional"
SeeAlso: INT 5D"TI Professional",INT 5F"TI Professional"
--------H-5F---------------------------------
INT 5F - IRQ15 relocated by DESQview 2.26+
Range:	INT 5F to INT FF, selected automatically
Note:	this is the default, but other INTs may be used (see INT 50"DESQview")
SeeAlso: INT 50"DESQview",INT 5E"DESQview",INT 77
--------H-5F---------------------------------
INT 5F - IRQ7 relocated by DoubleDOS
SeeAlso: INT 0F,INT 5E"DoubleDOS"
--------b-5F---------------------------------
INT 5F C - TI Professional PC - KEYBOARD QUEUEING VECTOR
Return: all registers preserved
Desc:	hook for multitaskers to be informed when a keypress is placed in the
	  keyboard buffer
Note:	the default handler is a simple IRET instruction
SeeAlso: INT 09,INT 4A/AH=00h"TI",INT 59"TI Professional"
SeeAlso: INT 5B"TI Professional",INT 5C"TI Professional"
SeeAlso: INT 5D"TI Professional",INT 5E"TI Professional"
--------b-5F00-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - SET VIDEO MODE
	AH = 00h
	AL = video mode
	    03h text,CGA color (100LX/200LX)
	    06h 640x200 CGA graphics (100LX/200LX)
	    07h text, system manager compliant
	    20h 240x128 mono graphics, system manager compliant
	    87h text, not system manager compliant
	    A0h 240x128 mono graphics, not system manager compliant
Notes:	the defaults after setting the mode to graphics are (0,0) logical
	  origin, full-screen clip region, (0,0) pen location, pen color 1,
	  pixel replacement FORCE, line type and fill mask all bits set
	modes 03h and 06h can also be set with the standard INT 10/AH=00h
SeeAlso: INT 0F"HP 95LX",INT 10/AH=00h,INT 15/AX=4DD4h
--------b-5F01-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - SET FILL MASK
	AH = 01h
	ES:DI -> 8-byte fill mask
Note:	the fill mask represents an 8x8 pixel box and is repeated as necessary
	  when drawing filled rectangles; it is always aligned with the byte
	  boundaries of video memory, regardless of the actual boundaries of
	  the rectangle
SeeAlso: AH=02h
--------b-5F02-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - GET CURRENT GRAPHICS INFO
	AH = 02h
	ES:DI -> graphics info record (see #2892)
Return: DX:AX -> filled graphics info record (for return to high-level langs)

Format of HP 95LX graphics info record:
Offset	Size	Description	(Table 2892)
 00h	BYTE	current video mode
 01h	BYTE	default video mode
 02h	WORD	display width in pixels
 04h	WORD	display height in pixels
 06h	WORD	current pen column
 08h	WORD	current pen row
 0Ah	WORD	current line type
 0Ch	WORD	current replacement rule
 0Eh	WORD	current pen color
 10h	WORD	current leftmost column of clip region
 12h	WORD	current rightmost column of clip region
 14h	WORD	current topmost row of clip region
 16h	WORD	current bottommost row of clip region
 18h	WORD	current column of logical origin
 1Ah	WORD	current row of logical origin
 1Ch  8 BYTEs	current fill mask
--------b-5F03-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - SET LOGICAL ORIGIN
	AH = 03h
	CX = column
	DX = row
SeeAlso: AH=04h
--------b-5F04-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - SET CLIP REGION
	AH = 04h
	CX = left-most column
	DX = top-most row
	SI = right-most column
	DI = bottom-most row
SeeAlso: AH=03h
--------b-5F05-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - DRAW RECTANGLE
	AH = 05h
	AL = fill type
	    00h outline, using current line type and color
	    01h solid, using current color
	    02h pattern, using current fill mask and color
	DX,CX = row,column of other corner of rectangle
Note:	the rectangle is drawn starting at the current pen position
SeeAlso: AH=01h,AH=06h,AH=07h
--------b-5F06-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - DRAW LINE
	AH = 06h
	DX,CX = row,column of end point
Note:	the line is drawn starting at the current pen position
SeeAlso: AH=05h,AH=07h
--------b-5F07-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - PLOT POINT
	AH = 07h
	DX,CX = row,column of point
Note:	also sets pen position to the specified point
SeeAlso: AH=06h,AH=08h,AH=0Ch
--------b-5F08-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - MOVE PEN
	AH = 08h
	DX,CX = row,column of new pen position
SeeAlso: AH=07h,AH=09h
--------b-5F09-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - SET PEN COLOR
	AH = 09h
	AL = new color (00h = white, 01h = black)
SeeAlso: AH=08h,AH=0Ah,AH=0Bh
--------b-5F0A-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - SET REPLACEMENT RULE
	AH = 0Ah
	AL = new replacement rule
	    00h force
	    01h AND
	    02h OR
	    03h XOR
	    ---100LX/200LX---
	    04h InvForce
	    05h InvAND
	    06h	InvOR
	    07h InvXOR
	    08h Txt
SeeAlso: AH=01h,AH=09h,AH=0Bh
--------b-5F0B-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - SET LINE TYPE
	AH = 0Bh
	CX = new line type
Note:	the line type specifies 16 bits which are repeated over and over while
	  drawing the pixels of a line
SeeAlso: AH=09h,AH=0Ah
--------b-5F0C-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - GET PIXEL
	AH = 0Ch
	DX,CX = row,column of pixel to read
Return: AX = pixel color
SeeAlso: AH=07h
--------b-5F0D-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - GET IMAGE
	AH = 0Dh
	DX,CX = row,column of first corner
	BP,SI = row,column of second corner
	ES:DI -> image buffer (see #2893)
Note:	the specified corners are included in the saved image
SeeAlso: AH=0Eh

Format of HP 95LX image buffer:
Offset	Size	Description	(Table 2893)
 00h	WORD	number of planes (always 01h on HP 95LX)
 02h	WORD	number of bits/pixel (always 01h on HP 95LX)
 04h	WORD	image width in pixels
 06h	WORD	image height in pixels
 08h  N BYTEs	image data
		requires (WIDTH+7)/8 * HEIGHT bytes
--------b-5F0E-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - PUT IMAGE
	AH = 0Eh
	AL = replacement rule (see #2894)
	DX,CX = row,column of top left corner
	ES:DI -> image buffer (see #2893)
Note:	if the specified image does not fit completely on the screen, this call
	  does nothing
SeeAlso: AH=0Dh

Bitfields for replacement rule:
Bit(s)	Description	(Table 2894)
 2	invert image before applying rule
 1-0	function (00 force, 01 AND, 10 OR, 11 XOR)
--------b-5F0F-------------------------------
INT 5F - HP 95LX/100LX/200LX GRAPHICS PRIMITIVES - WRITE TEXT
	AH = 0Fh
	AL = rotate flag (if nonzero, rotate 90 degrees counter-clockwise)
	DX,CX = row,column of first character's top left corner
	ES:DI -> ASCIZ text
--------b-5F10-------------------------------
INT 5F - HP 100LX/200LX GRAPHICS PRIMITIVES - GET FONT POINTER
	AH = 10h
	CX = font size of desired font
	    0808h  8x8	small  (80x25 text)
	    0A0Bh 11x10 medium (64x18 text)
	    100Ch 12x16 large  (40x16 text)
Return: DX:AX -> ptr to font or 0000h:fontID# if built-in font
SeeAlso: AH=11h
--------b-5F11-------------------------------
INT 5F - HP 100LX/200LX GRAPHICS PRIMITIVES - SET CURRENT FONT
	AH = 11h
	ES:DI -> ptr to font or 0000h:fontID# for built-in font
Note:	this function should be called immediately after AH=10h with the
	  pointer supplied by that call
SeeAlso: AH=10h
--------*-60---------------------------------
INT 60 - reserved for user interrupt
--------v-60---------------------------------
INT 60 - VIRUS - "Zero Bug" - INSTALLATION CHECK
Desc:	The "Zero Bug" virus hooks this vector.	 It considers itself installed
	  if offset 103h of the handler's segment contains the bytes "ZE"
SeeAlso: INT 32"VIRUS",INT 44"VIRUS",INT 61"SEMTEX"
--------d-60---------------------------------
INT 60 - Adaptec and OMTI controllers - DRIVE 0 DATA
SeeAlso: INT 41"HARD DISK 0",INT 61"Adaptec",INT 62"Adaptec",INT 63"Adaptec"
SeeAlso: INT 64"Adaptec",INT C0"AMI",#0649 at INT 1A/AX=B102h
Notes:	this vector stores the first four bytes of the parameter table for
	  hard disk 0
	these vectors are used by the following Adaptec controllers:
	    ACB 2370 A/B/C, ACB 2372 A/B/C, ACB 2333 A/B, 2322B-8, 2322B-16
	these vectors are NOT used by the following Adaptec controllers:
	    ACB 2310, ACB 2312, ACB 2320D, ACB 2322D
--------b-60---------------------------------
INT 60 - TI Professional PC - SYSTEM ROM DATA AREA POINTER (NOT A VECTOR!)
Desc:	the low word of this vector contains the segment of the RAM data area
	  to be used by the system ROM at F400h:A000h, and the high word
	  contains the length of the data area (see #2895)
SeeAlso: INT 61"TI Professional PC",INT 66"TI Professional PC"

Format of TI Professional System ROM data area:
Offset	Size	Description	(Table 2895)
 00h	BYTE	port 00h shadow
 01h	BYTE	port 03h shadow
 02h	BYTE	port 04h shadow
 03h	WORD	system configuration word (see #2898)
 05h	BYTE	25ms count
 06h	WORD	offset of timing event 1 (0008h)
 08h	WORD	(event 1) offset of timing event 2 (0010h)
 0Ah	BYTE	(event 1) unused (FFh)
 0Bh	BYTE	(event 1) active flag (bit 7 set if on)
 0Ch	WORD	(event 1) count-down until end of event
 0Eh	WORD	(event 1) event routine (in segment F400h) to call at timeout
 10h	WORD	(event 2) offset of timing event 3 (0018h)
 12h	BYTE	(event 2) unused (FFh)
 13h	BYTE	(event 2) active flag (bit 7 set if on)
 14h	WORD	(event 2) count-down until end of event
 16h	WORD	(event 2) event routine (in segment F400h) to call at timeout
 18h	WORD	(event 3) offset of timing event 3 (0020h)
 1Ah	BYTE	(event 3) unused (FFh)
 1Bh	BYTE	(event 3) active flag (bit 7 set if on)
 1Ch	WORD	(event 3) count-down until end of event
 1Eh	WORD	(event 3) event routine (in segment F400h) to call at timeout
 20h	WORD	(event 4) 0000h - last event
 22h	BYTE	(event 4) unused (FFh)
 23h	BYTE	(event 4) active flag (bit 7 set if on)
 24h	WORD	(event 4) count-down until end of event
 26h	WORD	(event 4) event routine (in segment F400h) to call at timeout
 28h	WORD	offset of start of text display within segment DE00h
 2Ah	WORD	end of display
 2Ch	WORD	current absolute cursor position
 2Eh	WORD	start of current character row
 30h	WORD	current cursor column
 32h	WORD	cursor type and size (see #2896)
 34h	WORD	start of protected status region on screen (0000h = none)
 36h	BYTE	pop flag used by some ROM routines
		00h pop registers before return
		nonzero: do not pop
 37h	BYTE	unused (FFh)
 38h	BYTE	PAUSE flag
		00h off
		FFh on
 39h	BYTE	temp: current attribute while moving characters on screen
 3Ah	WORD	start of keyboard queue (next key at start+2 or 0042h if 0060h)
 3Ch	WORD	end of keyboard queue (next key inserted at end+2 or 0042h)
 3Eh	BYTE	number of characters in buffer
 3Fh	BYTE	keyboard mode flags (see #2897)
 40h	BYTE	Alt-digit-digit-digit accumulator
 41h	BYTE	Alt-digit-digit-digit count of digits (mod 3)
 42h 16 WORDs	keyboard buffer (circular queue)
 62h  8 DWORDs	Drive Interface Table pointers for floppies A:-D: + four others
		(0000h:0000h if pointer not in use)
 82h	BYTE	disk-error retry count (incremented on each disk error)
 83h  2	BYTEs	BIOS scratch space
 85h  8 BYTEs	current cylinder number for drives 0-7
		FFh = unknown
 8Dh	BYTE	BIOS scratch space
 8Eh	BYTE	hard error code for last disk access
		00h operation successful
 8Fh  8 BYTEs	save area for disk DSR parameters
 97h  6 BYTEs	current drive status
 9Dh	BYTE	retry error status
 9Eh	BYTE	BIOS scratch space
 9Fh  7 BYTEs	???
 A6h  2	WORDs	INT 47 save area for SS,SP
 AAh  2	WORDs	INT 46 save area for SS,SP
 AEh  2	WORDs	INT 43 save area for SS,SP
 B2h  2	WORDs	save area for SS,SP to be restored by common intr. exit routine
 B6h 24 WORDs	stack for INT 47
 E6h 24 WORDs	stack for INT 46
116h 17 WORDs	stack for INT 43
13Ah  6 BYTEs	system date and time (hundredths, seconds, minutes, hours, and
		  WORD days since 1/1/1980)
Note:	timing event 1 is the disk I/O timeout, event 2 is the floppy disk
	  motor timeout, event 3 is the floppy disk motor spin-up time, and
	  event 4 is used to turn off the speaker after a delay

Bitfields for TI Professional PC cursor size and type:
Bit(s)	Description	(Table 2896)
 15	reserved (0)
 14-13	cursor type
	00 nonblinking
	01 off
	10 slow blink
	11 fast blink
 12-8	starting scan line (0-11)
 7-5	reserved (0)
 4-0	ending scan line (0-11)
SeeAlso: #2895

Bitfields for TI Professional PC keyboard mode flags:
Bit(s)	Description	(Table 2897)
 7	CapsLock was ON at last keypress
 6-4	reserved (0)
 3	repeat key
 2	Shift was down at last keypress
 1	Alt was down at last keypress
 0	Ctrl was down at last keypress
SeeAlso: #2895

Bitfields for TI Professional System Configuration Word:
Bit(s)	Description	(Table 2898)
 0	drive A: installed
 1	drive B: installed
 2	drive C: installed
 3	drive D: installed
 4	drive A: is 80-track
 5	drive A: is double-sided
 6	60-Hz (USA,etc.) system instead of 50-Hz (Europe)
 7	hard disk installed
 8	serial port 1 installed
 9	serial port 2 installed
 10	serial port 3 installed
 11	serial port 4 installed
 14-12	installed graphics planes
	000 none
	001 plane A
	111 planes A, B, and C
 15	clock installed
SeeAlso: #2895
--------b-60---------------------------------
INT 60 - Atari Portfolio - USER INTERFACE FUNCTIONS
Desc:	supplies a number of subfunctions which perform such functions as
	  drawing boxes and menus, and provide input line editing
SeeAlso: INT 61/AH=00h"Atari",INT 61"EXTENDED BIOS"
--------V-60---------------------------------
INT 60 - Nabbit v2.0 - (NOT A VECTOR!) - INSTALLATION CHECK
Program: Nabbit is a shareware resident screen data grabber by RSE Inc.
Range:	INT 60 to INT 66, selected by searching for first free vector
Note:	the Nabbit installation check consists of testing whether the
	  interrupt vector points at the ASCIZ signature string "iG"
	  (69h 47h 00h)
--------V-60---------------------------------
INT 60 - ATI M64VBE.COM - INSTALLATION SIGNATURE
Program: M64VBE is a VESA VBE 2.0 driver TSR for ATI's Mach64 video chip
Range:	INT 60 to INT 66, selected by searching for first free vector
Note:	the installation check is to scan for an interrupt with the ASCIZ
	  signature "M64VBE" three bytes past the interrupt handler
SeeAlso: INT 10/AX=4FDDh"M64VBE",INT 10/AX=4FFFh/BX=364Dh"M64VBE"
--------V-60---------------------------------
INT 60 U - Buffit v3.0 - (NOT A VECTOR!) - INSTALLATION CHECK
Program: Buffit is a shareware scrollback utility by D.T. Hamilton
Range:	INT 60 to INT 6F, selected by searching for first free vector
Notes:	the Buffit installation check consists of testing whether the
	  interrupt vector points at the ASCII signature "Buffit  "
	there is a private entry point (see #2899) immediately following the
	  signature string, i.e. eight bytes beyond the address pointed at
	  by the interrupt vector

(Table 2899)
Call Buffit private entry point with:
	AH = function
	    00h get information and hotkey state
	    01h get information and toggle hotkey state
Return: AH = new hotkey state (00h enabled, 01h disabled)
	AL = hotkey scan code (see #0005)
	BH = hotkey shift states
	BL = ??? (01h)
	CX = segment of resident code
	DH = interrupt number used for signature pointer
	DL = ??? (00h)
	SI = INT 09 handler offset
	DI = INT 21 handler offset
Index:	hotkeys;Buffit
--------r-60---------------------------------
INT 60 - PC-IPC API
	STACK:	DWORD	pointer to parameter block (see #2900)
Return: STACK:	unchanged
Program: PC-IPC is a shareware TSR by Donnelly Software Engineering which
	  allows communication between independent programs
Range:	INT 00 to INT FF, selected by commandline switch

Format of PC-IPC parameter block:
Offset	Size	Description	(Table 2900)
 00h	WORD	caller's ID
 02h	WORD	to ID
 04h	WORD	command code (see #2901)
 06h	WORD	returned status (see #2902)
 08h	WORD	returned error code (see #2903)
 0Ah	WORD	size of data
 0Ch	DWORD	pointer to data buffer

(Table 2901)
Values for PC-IPC command code:
 01h "IPC_CMND_INQUIRE"	 inquire current status
	set status field, writes WORD to data buffer containing free
	  message space in bytes, and sets the "size" field to the
	  number of messages waiting
 02h "IPC_CMND_ENABLE"	reenable PC-IPC
	ignored unless called with the same ID that disabled PC-IPC
 03h "IPC_CMND_DISABLE" disable PC-IPC
 04h "IPC_CMND_INSTALL" reset PC-IPC
 06h "IPC_CMND_RDATA"	read data
	returns first message in data buffer, sets "size" to message length
	  and "to ID" field to sender's ID
	if no messages available, bit 4 of status is cleared and "size" is
	  set to zero
 07h "IPC_CMND_SDATA"	send data
 08h "IPC_CMND_REQID"	require user ID
	create a new recognized ID and return in "caller's ID" field
 09h "IPC_CMND_DELID"	cancel user ID
	delete caller's ID from pool of recognized IDs
 0Ah "IPC_CMND_RDATAW"	read data, wait if no messages available
 0Bh "IPC_CMND_VERS"	get PC-IPC version
	string representing version returned in data buffer, "size" field
	  set to length of string

Bitfields for returned status:
Bit(s)	Description	(Table 2902)
 0	unused
 1	IPC enabled
 2	IPC installed
 3	error
 4	message(s) available

(Table 2903)
Values for PC-IPC error code:
 00h	no error
 01h	invalid command or parameter
 02h	only process 0 can install/reset IPC
 03h	process can not install/reset IPC
 04h	IPC is not enabled
 05h	process can not disable IPC
 06h	invalid destination process ID
 07h	invalid sending process ID
 08h	invalid data destination
 09h	no more process IDs available
 0Ah	can not relinquish that process ID
 0Bh	message space is full
 0Ch	IPC is not installed
--------R-60---------------------------------
INT 60 - Tangram Arbiter - API
Desc:	Arbiter makes a PC disk look like a slow disk over an SNA link to an
	  IBM mainframe
Range:	INT 60h to INT 66h, selected by configuration parameter
Notes:	identified by string "@ARB_API" immediately following a short jump at
	  the interrupt handler address
--------N-60---------------------------------
INT 60 - Excelan LAN Workplace for DOS 3.5 - API
	ES:BX -> request packet (see #2904)
Return: request packet updated
Notes:	this interrupt is also supported by Beame&Whiteside's BWLWP35 shim,
	  which was used in creating this description
	the installation check consists of testing for the WORD 4142h ('AB')
	  immediately preceding the interrupt handler
BUG:	because BWLWP35 range-checks only the low byte of the function number,
	  and has a fencepost error even in that test, functions 000Bh and
	  XX01h-XX0Bh (XX nonzero) branch to random locations
SeeAlso: INT 2F/AX=7A40h

Format of Excelan request packet:
Offset	Size	Description	(Table 2904)
 00h 12 BYTEs	???
 0Ch	WORD	(ret) error code (see #2905)
 0Eh	DWORD	-> FAR function for ???
 12h	WORD	function number
		0001h ???
		0002h NOP
		0003h NOP
		0004h NOP
		0005h ???
		0006h get ??? record
		0007h NOP
		0008h reset ???
		0009h NOP
		000Ah set ???
	???
---function 01h---
 20h	BYTE	(call) subfunction (32h-3Bh)
		3Bh non-blocking I/O request (will be tested every clock tick)
 21h	BYTE	(ret) error code
		00h successful
		09h invalid connection number
		2Ah bad connection type
		45h ???
---function 01h, subfunction 32h---
 3Ah	WORD	(call) connection type (01h stream, 02h datagram)
---function 01h, subfunction 34h---
 26h	WORD	(call) ???
 28h	WORD	(call) ???
 2Ah	WORD	(call) ???
---function 01h, subfunction 35h---
 1Ah	WORD	(call) connection number???
 26h	WORD	(ret) ???
---function 01h, subfunction 36h---
 1Ah	WORD	(call) connection number???
 38h	WORD	???
---function 01h, subfunction 37h---
 24h	WORD	(ret) ???
 26h	WORD	(ret) ???
---function 01h, subfunction 38h---
 1Ah	WORD	(call) connection number???
---function 01h, subfunction 3Ah---
 22h	WORD	(call) ???
		667Eh ???
		667Fh ???
 24h	BYTE	(call 667Eh) ???
 24h	WORD	(return 667Fh) ???
---function 01h, subfunction 3Bh---
 0Eh	DWORD	(call) -> function to invoke for I/O or 0000h:0000h
		function called with AX = 0000h
				     STACK: DWORD -> request packet
					    WORD 0000h
			should return STACK unchanged
 1Ah	WORD	(call) connection number???
 21h	BYTE	(ret) set to 01h when I/O becomes possible
 22h	BYTE	(call) direction (00h write, 01h read)
 34h	DWORD	(ret) -> next pending request packet
---function 05h---
 1Eh	WORD	(call) ???
 20h	WORD	(call) ???
 34h	DWORD	(call) -> ???
---function 06h---
 16h	DWORD	(call) -> buffer for ??? record (see #2906)
 1Ah	WORD	(call) number of bytes to copy
 22h	WORD	(ret) number of bytes transferred
---function 08h---
 14h	WORD	(ret) ??? (0001h)
---function 0Ah---
 16h	DWORD	(call) -> WORD ???
 1Ch	WORD	(call) must be 000Ah for BWLWP35

(Table 2905)
Values for Excelan error code:
 0000h	successful
 002Dh	invalid function
 0050h	???

Format of ??? record:
Offset	Size	Description	(Table 2906)
 00h	WORD	offset of ???
 02h  4 BYTEs	???
 06h	DWORD	IP address (big-endian)
 0Ah  6 BYTEs	physical address (big-endian)
	???
--------N-60---------------------------------
INT 60 - TCPDRV 2.01 - TCP/IP Application Binary Interface (ABI)
Note:	The handler for the interrupt will start with a 2-byte NEAR jump
	  instruction, followed by the ASCIZ signature string "TCP DRVR".
	To find the interrupt being used by the driver, an application
	  should scan through interrupt vectors 60h to 7Fh until it finds
	  one with the "TCP DRVR" string.
	This specification is being proposed by Peter R. Tattam from the
	  University of Tasmania.
Index:	installation check;TCPDRV
--------G-60---------------------------------
INT 60 U - INTRSPY/CMDSPY v1.0 only - API
Program: INTRSPY is a script-driven debugger included with the book
	  _Undocumented_DOS_.
Notes:	INTRSPY will hook the first available interrupt in the range 60h-67h.
	The installation check is to
	  a) determine that the handler is an IRET instruction
	  b) the signature 0Dh "INTRSPY vN.NN" immediately precedes the handler
	If INTRSPY is installed, the DWORD immediately after the IRET stores
	  its entry point (see #2907)
	INTRSPY v2.0 (included with the second edition of the book) no longer
	  supports this API
Index:	installation check;INTRSPY

(Table 2907)
Call INTRSPY v1.0 entry point with:
	AH = function
	    00h ???
	    01h set current directory (for use in reporting)
		ES:DI -> counted string containing directory name (max 79 char)
	    02h set name of script file
		ES:DI -> counted string containing file name (max 79 chars)
	    03h set script arguments
		ES:DI -> counted string containing arguments (max 79 chars)
	    04h get directory set with function 01h
		ES:DI -> 80-byte buffer for directory name
	    05h get name of script file
		ES:DI -> 80-byte buffer for script filename
	    06h get script arguments
		ES:DI -> 80-byte buffer for script arguments
	    07h get ???
		CL = 00h-15h specifies what to get
		ES:DI -> WORD to be set with desired value on return
	    08h get ???
		ES:DI -> WORD to be set with returned value
	    09h get ???
		ES:DI -> WORD to be set with returned value
	    0Bh store code for interrupt handler???
		ES:DI -> data
		CX = number of bytes
	    0Ch ???
		ES:DI -> ???
	    0Dh get ???
		ES:DI -> BYTE to be set with returned value
	    0Eh set ??? flag
	    0Fh clear ??? flag
	    10h ???
		Return: AL = 04h or 05h if failed
	    11h ???
		Return: AL = 05h if failed
	    12h get ???
		ES:DI -> buffer
		Return: CX = number of bytes returned in buffer
	    13h ???
Return: AH = 00h
	AL = status
	    00h successful
	    01h invalid function
	    02h ???
	    03h ???
	    04h ???
	    05h ???
--------u-60---------------------------------
INT 60 U - PC/370 v4.2 - ???
	???
Return: ???
Program: PC/370 is an IBM 370 emulator by Donald S. Higgins
Range:	INT 00 to INT FF, selected by patching the executable
Note:	the documentation includes instructions for patching the system for
	  another interrupt
SeeAlso: INT 2F/AX=7F24h,INT DC"PC/370"
--------r-60---------------------------------
INT 60 - JPI TopSPEED Modula-2 v1 - PROCEDURE ENTRY TRAP
SeeAlso: INT 61"JPI"
--------N-60---------------------------------
INT 60 - FTP Packet Driver - PC/TCP Packet Driver Specification
Range:	INT 20 to INT FF
Notes:	The handler for the interrupt will start with a 3-byte jump
	  instruction, followed by the ASCIZ string "PKT DRVR" (the
	  terminating NUL is significant).
	To find the interrupt being used by the driver, an application should
	  scan through interrupt vectors 20h to FFh (60h through 80h for
	  v1.09- of the specification) until it finds one with the "PKT DRVR"
	  string.
	AH values of 80h to FFh have been reserved for user-defined additions.
--------I-60---------------------------------
INT 60 u - 3270-PC CONTROL PROGRAM - ???
--------b-60----DI0100-----------------------
INT 60 u - HP 95LX System Manager - WAIT FOR EVENT
	DI = 0100h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to event record (see #2909)
Return: event record filled
	STACK unchanged
Note:	this call will timeout after about 500ms
SeeAlso: INT 15/AX=4DD4h,INT 60/DI=0101h,INT 61"HP 95LX",INT 62"HP 95LX"

(Table 2908)
Values for HP 95LX event type:
 00h	no events
 01h	keystroke available
 02h	Ctrl-Break
 03h	reactivation (always follows deactivation event)
 04h	about to deactivate (sleep)
	next get-event call will not return until reactivated
 05h	forced application termination
 06h	1-2-3 bridge service request (only given to 1-2-3)
 07h	request to grow
 08h	request to shrink
 09h	application's alarm expired
 0Ah	daily chance to set an alarm
 0Bh	system date or time has been changed

Format of HP 95LX event record:
Offset	Size	Description	(Table 2909)
 00h	WORD	event type (see #2908)
 02h	WORD	ASCII code page 850 translation of keystroke
		or grow/shrink amount in paragraphs or 0000h if error
		or alarm expiration data
 04h	BYTE	scan code from BIOS
 05h	BYTE	shift key states at time keystroke is retrieved
 06h	WORD	LICS translation of keystroke
 08h	BYTE	function key number (1-2-3 only)
 09h	DWORD	pointer to 1-2-3 bridge record (see #2911)
		or pointer to time change structure (see #2910)
Note:	if the System Manager is awaiting the conclusion of a bridge service
	  or grow/shrink call and the event type field is set to FFFFh on
	  entry, the SysMgr will resume

Format of HP 95LX time change structure:
Offset	Size	Description	(Table 2910)
 00h	WORD	old year
 02h	BYTE	old month
 03h	BYTE	old date
 04h	BYTE	old day
 05h	BYTE	old hour
 06h	BYTE	old minute
 07h	BYTE	old second
 08h	BYTE	old hundredth of a second
 09h  9 BYTEs	new time in same format as old time
--------b-60----DI0101-----------------------
INT 60 u - HP 95LX System Manager - CHECK FOR EVENT
	DI = 0101h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD pointer to event record (INT 60/DI=0100h)
Return: event record filled
	STACK unchanged
Note:	this call returns immediately if no event is available
SeeAlso: INT 60/DI=0100h
--------b-60----DI0102-----------------------
INT 60 u - HP 95LX System Manager - "SH_STATUS"
	DI = 0102h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
--------b-60----DI0104-----------------------
INT 60 u - HP 95LX System Manager - LOTUS 1-2-3 BRIDGE SERVICES
	DI = 0104h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD pointer to bridge record (see #2911)
Return: ???
	STACK unchanged

Format of HP 95LX bridge record:
Offset	Size	Description	(Table 2911)
 00h	WORD	function code (see #2912)
 02h	WORD	return code from 1-2-3
 04h 16 BYTEs	ASCII range name
 14h	WORD	start column of range
 16h	WORD	start row of range
 18h	WORD	end column of range
 1Ah	WORD	end row of range
 1Ch	WORD	order in which data is placed in buffer
 1Eh	WORD	buffer size
 20h	WORD	offset within bridge record's segment of buffer for cell data

(Table 2912)
Values for HP 95LX function code:
 00h	test
 01h	get range
 02h	"GETRANGE_ADDR"
 03h	"SETRANGE_ADDR"
 04h	"GETRANGE_DATA"
 05h	"SETRANGE_DATA"
 06h	recalculate
 07h	get cursor
 08h	set cursor
 09h	redisplay
 0Ah	cell type
 0Bh	"CALCTYPE"
--------b-60----DI0105-----------------------
INT 60 u - HP 95LX System Manager - FLUSH KEYBOARD BUFFER
	DI = 0105h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
--------b-60----DI0106-----------------------
INT 60 u - HP 95LX System Manager - YIELD CPU
	DI = 0106h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=1000h,INT 2F/AX=1680h
--------b-60----DI0107-----------------------
INT 60 u - HP 95LX System Manager - "NO_FINI" - REFUSE TERMINATION REQUEST
	DI = 0107h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI0200-----------------------
INT 60 u - HP 95LX System Manager - SETUP MENU
	DI = 0200h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to menu data (see #2913)
		DWORD	pointer to ???
		WORD	number of items on menu???
		WORD	???
		DWORD	pointer to ???
		WORD	???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 60/DI=0201h,INT 60/DI=0203h,INT 60/DI=0205h

Format of HP 95LX menu data:
Offset	Size	Description	(Table 2913)
 00h 80 BYTEs	first line of menu text
 50h 80 BYTEs	second line of menu text
 A0h 80 BYTEs	third line of menu text
 F0h	WORD	number of keywords
 F2h	WORD	index of currently highlighted keyword or FFFFh
 F4h	WORD	single prompt on top line if nonzero
 F6h 20 BYTEs	which line each of 20 keywords is located on
10Ah 20 BYTEs	offset of each of 20 keywords within its line
11Eh 20 BYTEs	length of each of 20 keywords
132h 20 BYTEs	first letter of each of 20 keywords
146h 20 WORDs	offsets of long prompts for each of 20 keywords
--------b-60----DI0201-----------------------
INT 60 u - HP 95LX System Manager - DISPLAY OR REDISPLAY MENU
	DI = 0201h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to menu data (see #2913)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0200h,INT 60/DI=0202h,INT 60/DI=0206h
--------b-60----DI0202-----------------------
INT 60 u - HP 95LX System Manager - "MENU_ON" - ENABLE PROCESSING OF MENU
	DI = 0202h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to menu data (see #2913)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0200h,INT 60/DI=0201h,INT 60/DI=0203h
--------b-60----DI0203-----------------------
INT 60 u - HP 95LX System Manager - REMOVE MENU
	DI = 0203h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to menu data (see #2913)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0201h,INT 60/DI=0202h,INT 60/DI=0204h,INT 60/DI=0208h
--------b-60----DI0204-----------------------
INT 60 u - HP 95LX System Manager - LET SYSTEM MANAGER HANDLE MENU KEYSTROKE
	DI = 0204h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to menu data (see #2913)
		WORD	keystroke
		DWORD	pointer to WORD to receive selection number
Return: buffer for selection number filled with index of selected menu item or
	  FFFFh if no final selection yet
	STACK unchanged
SeeAlso: INT 60/DI=0200h,INT 60/DI=0202h,INT 60/DI=0207h
--------b-60----DI0205-----------------------
INT 60 u - HP 95LX System Manager - INITIALIZE FILE SELECTION MENU
	DI = 0205h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file menu structure (see #2914)
		DWORD	pointer to edit record (see #2917 at INT 60/DI=0400h)
		DWORD	pointer to wildcard filespec for initial file list
		WORD	row???
		WORD	column???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0200h,INT 60/DI=0206h,INT 60/DI=0208h

Format of HP 95LX file menu structure:
Offset	Size	Description	(Table 2914)
 00h	DWORD	pointer to ASCIZ base directory name
 04h	DWORD	pointer to ASCIZ file pattern (wildcard filespec)
 08h	DWORD	pointer to file list workspace, at least 1024 bytes (see #2915)
 0Ch	WORD	size of file list workspace in bytes
 0Eh	WORD	starting row (-3 is topmost, 0 is first non-"reserved" line)
 10h	WORD	starting column
 12h	WORD	number of lines
 14h	WORD	number of columns
 16h	WORD	number of files displayed on each line
---the remaining fields are initialized by the System Manager---
 18h	WORD	0000h if first edit character, else multiline
 1Ah	WORD	number of files in file list
 1Ch	WORD	max files workspace has room for
 1Eh	WORD	file at top of list
 20h	WORD	index of file to highlight
 22h	WORD	index of file to unhighlight
 24h	WORD	current focus (01h FMENU, 02h EDIT)

Format of HP 95LX file list workspace entry:
Offset	Size	Description	(Table 2915)
 00h	BYTE	file attributes
 01h	WORD	file time (see #1317 at INT 21/AX=5700h)
 03h	WORD	file date (see #1318 at INT 21/AX=5700h)
 05h	DWORD	file size
 09h 13 BYTEs	ASCIZ filename
--------b-60----DI0206-----------------------
INT 60 u - HP 95LX System Manager - DISPLAY/REDISPLAY FILE SELECTION MENU
	DI = 0206h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file menu structure (see #2914)
		DWORD	pointer to edit record (see #2917 at INT 60/DI=0400h)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0205h
--------b-60----DI0207-----------------------
INT 60 u - HP 95LX System Manager - LET SYSMGR PROCESS FILE SEL MENU KEYSTROKE
	DI = 0207h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file menu structure (see #2914)
		DWORD	pointer to edit record (see #2917 at INT 60/DI=0400h)
		WORD	keystroke
Return: AX = status (see #2916)
	STACK unchanged
SeeAlso: INT 60/DI=0205h,INT 60/DI=0208h

(Table 2916)
Values for HP 95LX System Manager status:
 0000h	keystroke processed, call INT 60/DI=0206h to refresh menu
 0001h	redisplay application area before refreshing menu
 0002h	user confirmed selection, filename is in edit record's buffer
 0003h	user aborted menu
 FFFBh	bad filename
 FFFCh	bad directory
 FFFDh	bad drive
 FFFEh	unknown keystroke
 FFFFh	keystroke known but invalid in current context
--------b-60----DI0208-----------------------
INT 60 u - HP 95LX System Manager - REMOVE FILE SELECTION MENU
	DI = 0208h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file menu structure (see #2914)
		DWORD	pointer to edit record (see #2917 at INT 60/DI=0400h)
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 60/DI=0205h,INT 60/DI=0206h
--------b-60----DI0300-----------------------
INT 60 u - HP 95LX System Manager - DISPLAY STRING
	DI = 0300h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	starting row (-3 is topmost, 0 is first user line)
		WORD	starting column
		DWORD	pointer to string
		WORD	length of string
		WORD	display style: 0000h normal, 0001h reverse video
		WORD	"OSTYLE"
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0F03h,INT 60/DI=1005h
--------b-60----DI0301-----------------------
INT 60 u - HP 95LX System Manager - CLEAR PORTION OF SCREEN
	DI = 0301h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	starting row (-3 is topmost, 0 is first user line)
		WORD	starting column
		WORD	number of rows
		WORD	number of columns
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0302h,INT 60/DI=1005h
--------b-60----DI0302-----------------------
INT 60 u - HP 95LX System Manager - SCROLL PORTION OF SCREEN
	DI = 0302h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	starting row???
		WORD	starting column???
		WORD	height of scroll region???
		WORD	width of scroll region???
		WORD	number of lines to scroll region???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0301h
--------b-60----DI0303-----------------------
INT 60 u - HP 95LX System Manager - SCREEN SERVICE "M_XCHG"
	DI = 0303h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		WORD	???
		WORD	???
		WORD	???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0304-----------------------
INT 60 u - HP 95LX System Manager - SCREEN SERVICE "M_CHRATTR"
	DI = 0304h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0305-----------------------
INT 60 u - HP 95LX System Manager - SCREEN SERVICE "M_CHRRVRT"
	DI = 0305h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		WORD	???
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0307-----------------------
INT 60 u - HP 95LX System Manager - SCREEN SERVICE "M_CHRINV"
	DI = 0307h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0308-----------------------
INT 60 u - HP 95LX System Manager - SCREEN SERVICE "M_ROWS_COLS"
	DI = 0308h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
--------b-60----DI0309-----------------------
INT 60 u - HP 95LX System Manager - SET SCREEN (VIDEO???) MODE
	DI = 0309h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	new mode
Return: ???
	STACK unchanged
--------b-60----DI030A-----------------------
INT 60 u - HP 95LX System Manager - GET SCREEN (VIDEO???) MODE
	DI = 030Ah
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
--------b-60----DI030B-----------------------
INT 60 u - HP 95LX System Manager - SET CURSOR POSITION
	DI = 030Bh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	row (-3 is topmost, 0 is first non-reserved line)
		WORD	column
Return: ???
	STACK unchanged
Note:	cursor is hidden if the specified position is not on the physical
	  display
SeeAlso: INT 10/AH=02h,INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI0400-----------------------
INT 60 u - HP 95LX System Manager - "EDIT_INIT"
	DI = 0400h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to edit record (see #2917)
		DWORD	pointer to string to be edited
		WORD	initial length of string being edited
		WORD	maximum length of edited string
		WORD	row of edit field
		WORD	leftmost column of edit field
Return: ???
	STACK unchanged

Format of HP 95LX edit record:
Offset	Size	Description	(Table 2917)
 00h	WORD	current length of edit buffer
 02h	BYTE	flag for special processing on first character
 03h	BYTE	flags
		bit 0: tab handling
 04h	WORD	editing in prompt window?
 06h	DWORD	pointer to top line of prompt window message
 0Ah	WORD	length of top line of prompt
 0Ch	DWORD	pointer to second line of prompt window message
 10h	WORD	length of second line of prompt
 12h 80 BYTEs	workspace for editing
 62h  2 WORDs	line array needed for multi-line editing
 66h 36 BYTEs	multi-line edit record (see #2918)
 8Ah	WORD	displayable columns

Format of HP 95LX multi-line edit record:
Offset	Size	Description	(Table 2918)
 00h	DWORD	pointer to user-supplied edit buffer
 04h	WORD	length of edit buffer
 06h	WORD	current cursor position
 08h	WORD	starting row of edit area (-3 is topmost, 0 is first user line)
 0Ah	WORD	starting column of edit area
 0Ch	WORD	height of edit area
 0Eh	WORD	width of edit area
 10h	WORD	current top row (-3 is topmost, 0 is first user line)
 12h	WORD	number of rows displayable
 14h	BYTE	cursor column
 15h	BYTE	01h if buffer has been modified
 16h	BYTE	first displayable column (ticker fields only)
 17h	BYTE	01h if wordwrap enabled, FFh if ticker field
 18h	DWORD	pointer to array of line starts (at least one bigger than edit
		  area is high)
 1Ch	BYTE	currently marking?
 1Dh	BYTE	flag
 1Eh	WORD	offset of mark start
 20h	WORD	offset of mark end (inclusive)
 22h	WORD	displayable columns
--------b-60----DI0401-----------------------
INT 60 u - HP 95LX System Manager - EDIT ON TOP LINE
	DI = 0401h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to edit record (see #2917)
		DWORD	pointer to string to edit
		WORD	initial length of string being edited
		WORD	maximum length of edited string
		DWORD	pointer to first line of prompt
		WORD	length of first line
		DWORD	pointer to second line of prompt
		WORD	length of second line
Return: ???
	STACK unchanged
--------b-60----DI0402-----------------------
INT 60 u - HP 95LX System Manager - DISPLAY OR REDISPLAY EDIT FIELD
	DI = 0402h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to edit record (see #2917)
Return: ???
	STACK unchanged
--------b-60----DI0403-----------------------
INT 60 u - HP 95LX System Manager - LET SYSTEM MANAGER PROCESS EDITING KEYSTROK
	DI = 0403h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to edit record (see #2917)
		WORD	keystroke
		DWORD	pointer to WORD buffer for result code
Return: result code buffer filled with 0001h if editing complete
	STACK unchanged
--------b-60----DI0404-----------------------
INT 60 u - HP 95LX System Manager - "MDIT_INI"
	DI = 0404h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		WORD	???
		WORD	???
		WORD	???
		DWORD	pointer to ???
		WORD	???
		WORD	???
		WORD	???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0405-----------------------
INT 60 u - HP 95LX System Manager - "MDIT_DIS"
	DI = 0405h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0406-----------------------
INT 60 u - HP 95LX System Manager - "MDIT_KEY"
	DI = 0406h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0407-----------------------
INT 60 u - HP 95LX System Manager - "MDIT_FIL"
	DI = 0407h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0408-----------------------
INT 60 u - HP 95LX System Manager - "MDIT_MARK"
	DI = 0408h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0409-----------------------
INT 60 u - HP 95LX System Manager - "MDIT_UNMARK"
	DI = 0409h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI040A-----------------------
INT 60 u - HP 95LX System Manager - "MDIT_CUTMARK"
	DI = 040Ah
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI040B-----------------------
INT 60 u - HP 95LX System Manager - "MDIT_INS_STR"
	DI = 040Bh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI0500-----------------------
INT 60 u - HP 95LX System Manager - OPEN FILE
	DI = 0500h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file state record (see #2919)
		DWORD	pointer to filename
		WORD	length of filename
		WORD	???
		WORD	suppress buffering if nonzero
Return: AX = status
	STACK unchanged
SeeAlso: INT 60/DI=0501h,INT 60/DI=0502h,INT 60/DI=0508h

Format of HP 95LX file state record:
Offset	Size	Description	(Table 2919)
 00h	WORD	DOS file handle
 02h	WORD	state flags (see #2920)
 04h	DWORD	current DOS physical file offset (FFFFFFFFh if unknown)
 08h	DWORD	DOS file offset of start of buffer
 0Ch	DWORD	effective file offset as seen by caller
 10h	WORD	number of bytes in file buffer
---buffered I/O only---
 12h 512 BYTEs	file buffer

Bitfields for HP 95LX file state flags:
Bit(s)	Description	(Table 2920)
 0	buffer contents valid
 1	buffer is dirty and must be written
 2	unbuffered I/O
 3	file is a character device
SeeAlso: #2919
--------b-60----DI0501-----------------------
INT 60 u - HP 95LX System Manager - OPEN FILE IN READ-ONLY MODE
	DI = 0501h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file state record (see #2919)
		DWORD	pointer to filename
		WORD	length of filename
		WORD	???
		WORD	suppress buffering if nonzero
Return: AX = status
	STACK unchanged
SeeAlso: INT 60/DI=0500h
--------b-60----DI0502-----------------------
INT 60 u - HP 95LX System Manager - CREATE NEW FILE
	DI = 0502h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file state record (see #2919)
		DWORD	pointer to filename
		WORD	length of filename
		WORD	???
		WORD	suppress buffering if nonzero
Return: AX = status
	STACK unchanged
SeeAlso: INT 60/DI=0500h,INT 60/DI=0503h
--------b-60----DI0503-----------------------
INT 60 u - HP 95LX System Manager - CREATE OR TRUNCATE FILE
	DI = 0503h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file state record (see #2919)
		DWORD	pointer to filename
		WORD	length of filename
		WORD	???
		WORD	suppress buffering if nonzero
Return: AX = status
	STACK unchanged
SeeAlso: INT 60/DI=0502h
--------b-60----DI0504-----------------------
INT 60 u - HP 95LX System Manager - READ FROM FILE
	DI = 0504h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file state record (see #2919)
		DWORD	pointer to data buffer
		WORD	number of bytes to read
		DWORD	pointer to WORD in which to return actual bytes read
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0505h
--------b-60----DI0505-----------------------
INT 60 - HP 95LX System Manager - WRITE TO FILE
	DI = 0505h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file state record (see #2919)
		DWORD	pointer to data
		WORD	length of data
Return: AX = status
	STACK unchanged
SeeAlso: INT 60/DI=0504h
--------b-60----DI0506-----------------------
INT 60 u - HP 95LX System Manager - SET FILE POSITION
	DI = 0506h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file state record (see #2919)
		2 WORDs	???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0507h
--------b-60----DI0507-----------------------
INT 60 u - HP 95LX System Manager - GET FILE POSITION
	DI = 0507h "M_TELL"
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file state record (see #2919)
		DWORD	pointer to DWORD buffer for file position???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0506h
--------b-60----DI0508-----------------------
INT 60 u - HP 95LX System Manager - CLOSE FILE
	DI = 0508h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to file state record (see #2919)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0500h
--------b-60----DI0509-----------------------
INT 60 u - HP 95LX System Manager - FILE SERVICE "M_SETPAT"
	DI = 0509h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI050A-----------------------
INT 60 u - HP 95LX System Manager - FILE SERVICE "M_MATCH"
	DI = 050Ah
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ??? (see #2921)
		DWORD	pointer to ???
Return: ???
	STACK unchanged

Format of HP 95LX pattern match control block:
Offset	Size	Description	(Table 2921)
 00h 43 BYTEs	FindFirst data block (see #1278 at INT 21/AH=4Eh)
 2Bh 80 BYTEs	full path name
 7Bh	BYTE	offset of last component of filename
 7Ch	BYTE	DOS function number (4Eh or 4Fh)
--------b-60----DI050B-----------------------
INT 60 u - HP 95LX System Manager - IDENTIFY FILENAME REFERENT
	DI = 050Bh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		WORD	???
		DWORD	pointer to ???
Return: ??? = result (see #2922)
	???
	STACK unchanged

(Table 2922)
Values returned by HP 95LX System Manager:
 0000h	nonexistent
 0001h	file
 0002h	directory
 0003h	character device
--------b-60----DI050C-----------------------
INT 60 u - HP 95LX System Manager - DELETE FILE
	DI = 050Ch "M_DELETE"
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI050D-----------------------
INT 60 u - HP 95LX System Manager - RENAME FILE
	DI = 050Dh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		WORD	???
		DWORD	pointer to ???
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI050E-----------------------
INT 60 u - HP 95LX System Manager - FILE SERVICE "M_GETDIR"
	DI = 050Eh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI050F-----------------------
INT 60 u - HP 95LX System Manager - FILE SERVICE "M_SETDIR"
	DI = 050Fh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0510-----------------------
INT 60 u - HP 95LX System Manager - FILE SERVICE "M_VOLUME"
	DI = 0510h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0511-----------------------
INT 60 u - HP 95LX System Manager - MAKE A SUBDIRECTORY
	DI = 0511h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
SeeAlso: INT 21/AH=39h,INT 60/DI=0512h
--------b-60----DI0512-----------------------
INT 60 u - HP 95LX System Manager - REMOVE A SUBDIRECTORY
	DI = 0512h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
SeeAlso: INT 21/AH=3Ah,INT 60/DI=0511h
--------b-60----DI0513-----------------------
INT 60 u - HP 95LX System Manager - GET DEFAULT DRIVE
	DI = 0513h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ??? buffer for current drive
Return: ???
	STACK unchanged
SeeAlso: INT 21/AH=19h,INT 60/DI=0514h
--------b-60----DI0514-----------------------
INT 60 u - HP 95LX System Manager - SET DEFAULT DRIVE
	DI = 0514h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	new drive
Return: ???
	STACK unchanged
SeeAlso: INT 21/AH=0Eh"DOS 1+",INT 60/DI=0513h
--------b-60----DI0515-----------------------
INT 60 u - HP 95LX System Manager - FILE SERVICE "M_FDATE"
	DI = 0515h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0516-----------------------
INT 60 u - HP 95LX System Manager - FILE SERVICE "M_GET_SYSDIR"
	DI = 0516h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0517-----------------------
INT 60 u - HP 95LX System Manager - GET FILE ATTRIBUTES
	DI = 0517h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		WORD	???
		DWORD	pointer to ??? buffer for file's attributes???
Return: ???
	STACK unchanged
SeeAlso: INT 21/AX=4300h,INT 60/DI=0518h
--------b-60----DI0518-----------------------
INT 60 u - HP 95LX System Manager - SET FILE ATTRIBUTES
	DI = 0518h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		WORD	???
		WORD	new attributes???
Return: ???
	STACK unchanged
SeeAlso: INT 21/AX=4301h,INT 60/DI=0517h
--------b-60----DI0519-----------------------
INT 60 u - HP 95LX System Manager - FILE SERVICE "M_COMMON_OPEN"
	DI = 0519h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
		WORD	???
		WORD	???
		WORD	???
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI051A-----------------------
INT 60 u - HP 95LX System Manager - FILE SERVICE "M_COPYDT"
	DI = 051Ah
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI051B-----------------------
INT 60 u - HP 95LX System Manager - FILE SERVICE "M_GETFDT"
	DI = 051Bh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI051C-----------------------
INT 60 u - HP 95LX System Manager - FILE SERVICE "M_PUTFDT"
	DI = 051Ch
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0600-----------------------
INT 60 u - HP 95LX System Manager - PROCESS INITIALIZING
	DI = 0600h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 60/DI=0601h,INT 61"HP 95LX"
--------b-60----DI0601-----------------------
INT 60 u - HP 95LX System Manager - PROCESS TERMINATION
	DI = 0601h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: never
	STACK unchanged
SeeAlso: INT 21/AH=4Ch,INT 2F/AX=1122h,INT 60/DI=0600h
--------b-60----DI0602-----------------------
INT 60 u - HP 95LX System Manager - "M_LOCK" - PREVENT TASK SWITCHES
	DI = 0602h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=101Bh,INT 2F/AX=1681h,INT 60/DI=0603h
--------b-60----DI0603-----------------------
INT 60 u - HP 95LX System Manager - "M_UNLOCK" - ALLOW TASK SWITCHES
	DI = 0603h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=101Ch,INT 2F/AX=1682h,INT 60/DI=0602h
--------b-60----DI0604-----------------------
INT 60 u - HP 95LX System Manager - "M_SPAWN"
	DI = 0604h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		WORD	???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 21/AH=4Bh
--------b-60----DI0605-----------------------
INT 60 u - HP 95LX System Manager - "M_APPCOUNT"
	DI = 0605h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
--------b-60----DI0606-----------------------
INT 60 u - HP 95LX System Manager - "M_REBOOT"
	DI = 0606h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 14/AH=17h"FOSSIL",INT 19
--------b-60----DI0607-----------------------
INT 60 u - HP 95LX System Manager - "M_SPAWNARG"
	DI = 0607h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0608-----------------------
INT 60 u - HP 95LX System Manager - "M_REG_APP_NAME"
	DI = 0608h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0609-----------------------
INT 60 u - HP 95LX System Manager - "M_APP_NAME"
	DI = 0609h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: DX:AX -> ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI0700-----------------------
INT 60 u - HP 95LX System Manager - OPEN CLIPBOARD
	DI = 0700h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ??? = error code (see #2923)
	???
	STACK unchanged
SeeAlso: INT 60/DI=0701h,INT 60/DI=0702h

(Table 2923)
Values for HP 95LX error code:
 0000h	successful
 FFF8h	transfer request out of bounds
 FFF9h	no such representation
 FFFAh	no representation open
 FFFBh	a representation is already open
 FFFCh	representation already exists
 FFFDh	heap allocation failure
 FFFEh	clipboard not open
 FFFFh	clipboard access denied
--------b-60----DI0701-----------------------
INT 60 u - HP 95LX System Manager - CLOSE CLIPBOARD
	DI = 0701h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0700h,INT 60/DI=0702h
--------b-60----DI0702-----------------------
INT 60 u - HP 95LX System Manager - RESET CLIPBOARD
	DI = 0702h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0700h
--------b-60----DI0704-----------------------
INT 60 u - HP 95LX System Manager - "M_NEW_REP" - START A NEW REPRESENTATION???
	DI = 0704h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0705h,INT 60/DI=0706h,INT 60/DI=0707h
--------b-60----DI0705-----------------------
INT 60 u - HP 95LX System Manager - CLIPBOARD SERVICE "M_FINI_REP"
	DI = 0705h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0704h
--------b-60----DI0706-----------------------
INT 60 u - HP 95LX System Manager - CLIPBOARD SERVICE "M_REP_NAME"
	DI = 0706h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0704h,INT 60/DI=0707h
--------b-60----DI0707-----------------------
INT 60 u - HP 95LX System Manager - CLIPBOARD SERVICE "M_REP_INDEX"
	DI = 0707h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0704h,INT 60/DI=0706h
--------b-60----DI0708-----------------------
INT 60 u - HP 95LX System Manager - WRITE TO CLIPBOARD
	DI = 0708h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to data to be written???
		WORD	length of data???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0709h
--------b-60----DI0709-----------------------
INT 60 u - HP 95LX System Manager - READ FROM CLIPBOARD
	DI = 0709h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		WORD	???
		DWORD	pointer to buffer for data???
		WORD	length of buffer???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0708h
--------b-60----DI0800-----------------------
INT 60 u - HP 95LX System Manager - BEEP
	DI = 0800h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0801h,INT 60/DI=0802h,INT 60/DI=0803h
--------b-60----DI0801-----------------------
INT 60 u - HP 95LX System Manager - SOUND SERVICE "M_THUD"
	DI = 0801h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0800h,INT 60/DI=0802h,INT 60/DI=0803h
--------b-60----DI0802-----------------------
INT 60 u - HP 95LX System Manager - MAKE A SOUND PATTERN
	DI = 0802h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	pattern number (00h-06h)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0800h,INT 60/DI=0801h,INT 60/DI=0803h
--------b-60----DI0803-----------------------
INT 60 u - HP 95LX System Manager - TURN OFF SOUND
	DI = 0803h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0800h,INT 60/DI=0801h,INT 60/DI=0802h
--------b-60----DI0900-----------------------
INT 60 - HP 95LX System Manager - ALLOCATE REGULAR MEMORY BLOCK
	DI = 0900h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	size of block in bytes
Return: AX -> memory block
	STACK unchanged
Note:	System Manager-compliant applications are always small-model (64K code,
	  64K data)
SeeAlso: INT 15/AX=4DD4h,INT 60/DI=0902h,INT 60/DI=0903h
--------b-60----DI0902-----------------------
INT 60 u - HP 95LX System Manager - FREE REGULAR MEMORY BLOCK
	DI = 0902h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	offset of memory block???
Return: ???
	STACK unchanged
Note:	System Manager-compliant applications are always small-model (64K code,
	  64K data)
SeeAlso: INT 60/DI=0900h,INT 60/DI=0904h
--------b-60----DI0903-----------------------
INT 60 u - HP 95LX System Manager - ALLOCATE LARGE MEMORY BLOCK
	DI = 0903h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	size of block in bytes???
Return: AX -> memory block???
	STACK unchanged
SeeAlso: INT 60/DI=0900h,INT 60/DI=0904h
--------b-60----DI0904-----------------------
INT 60 u - HP 95LX System Manager - FREE LARGE MEMORY BLOCK
	DI = 0904h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	segment of memory block???
Return: AX -> ???
	STACK unchanged
SeeAlso: INT 60/DI=0902h,INT 60/DI=0903h
--------b-60----DI0B00-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_DTINFO"
	DI = 0B00h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0B01-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_GETDTM"
	DI = 0B01h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0B02-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_SETDTM"
	DI = 0B02h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0B03-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_XALARM"
	DI = 0B03h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0B04-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_ALARM"
	DI = 0B04h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to alarm record??? (see #2924)
		WORD	???
Return: ???
	STACK unchanged

Format of HP 95LX alarm record:
Offset	Size	Description	(Table 2924)
 00h	BYTE	hour
 01h	BYTE	minute
 02h	BYTE	second
 03h	BYTE	unused padding
 04h	WORD	rescheduling interval, in seconds
 06h	BYTE	are seconds significant?
 07h	BYTE	alarm sound
 08h 40 BYTEs	message displayed when alarm activates
 30h	BYTE	task ID of owner
 31h	BYTE	application's own use for sub-class
 32h  4 BYTEs	application's own use for private data
--------b-60----DI0B05-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_START_SW"
	DI = 0B05h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0B06-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_GET_SW"
	DI = 0B06h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0B07-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_STOP_SW"
	DI = 0B07h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0B08-----------------------
INT 60 u - HP 95LX System Manager - "M_TELLTIME" - DISPLAY TIMESTAMP
	DI = 0B08h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	timestamp format (see #2925)
		WORD	row (-3 is topmost, 0 is first non-reserved line)
		WORD	column
Return: ???
	STACK unchanged

Bitfields for HP 95LX timestamp format:
Bit(s)	Description	(Table 2925)
 1-0	timestamp components
	00 date only
	01 time only
	10 date and time
	11 day and date
 4	supply am/pm
 5	supply seconds
 6	show year
 7	four-digit year
--------b-60----DI0B09-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_GET_SETTINGS"
	DI = 0B09h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ??? (see #2926)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0B0Ah,INT 60/DI=0B0Fh

Format of HP 95LX system settings:
Offset	Size	Description	(Table 2926)
 00h	WORD	country code
 02h	WORD	speaker volume (00h-03h or FFh for off)
 04h	WORD	contrast level (00h-0Fh)
 06h	WORD	week start (00h Sunday, 01h Monday)
 08h	WORD	punctuation format (see #2927)
 0Ah	WORD	two-character language code (only 5355h = "US" byte-swapped)
 0Ch	WORD	current date format (see #2928)
 0Eh	WORD	current time format (see #2929)
 10h	WORD	collating sequence
		00h numbers first, 01h letters first, 02h ASCII
 12h 80 BYTEs	name of picture file
 62h 30 BYTEs	name
 80h 30 BYTEs	title
 9Eh 28 BYTEs	company name
 BAh	WORD	number of languages
 BCh  6 BYTEs	available languages
 C2h 66 BYTEs	language menu
104h  2 BYTEs	ASCIZ date separator
106h  2 BYTEs	ASCIZ time separator
108h	BYTE	date order
109h	BYTE	use 24 hour time?
10Ah 16 BYTEs	currency string
11Ah	WORD	currency string position (00h prefix, 01h suffix)
11Ch	WORD	keyboard (see #2930)
11Eh	WORD	printer baud rate
		00h 300, 01h 1200, 02h 2400, 03h 4800, 04h 9600, 05h 19200
120h	WORD	printer driver code
		00h Epson FX80, 01h HP Laserjet, 02h IBM ProPrinter
122h	WORD	printer interface (00h COM1, 01h COM2, 02h IR, 03h LPT1)
124h	WORD	system manager interrupt (60h by default)
126h	WORD	code page (01h CP850, 02h CP437)
128h	WORD	active exit key
12Ah	WORD	active menu key
12Ch	WORD	active CHAR key toggle
12Eh  6 BYTEs	alarm

(Table 2927)
Values for HP 95LX punctuation format:
 code	decimal arg	thousands
 00h	.	,	,
 01h	,	.	.
 02h	.	;	;
 03h	,	;	.
 04h	.	,	" "
 05h	,	.	" "
 06h	.	;	" "
 07h	,	;	" "

(Table 2928)
Values for HP 95LX current date format:
 00h	dd-mmm-yy
 01h	dd-mmm
 02h	mmm-yy
 03h	mm/dd/yy
 04h	dd/mm/yy
 05h	dd.mm.yy
 06h	yy-mm-dd
 07h	mm/dd
 08h	dd/mm
 09h	dd.mm
 0Ah	mm-dd

(Table 2929)
Values for HP 95LX current time format:
 00h	HH:MM:SS am/pm
 01h	HH:MM am/pm
 02h	HH:MM:SS
 03h	HH.MM.SS
 04h	HH,MM,SS
 05h	HHhMMmSSs
 06h	HH:MM
 07h	HH.MM
 08h	HH,MM
 09h	HHhMMm

(Table 2930)
Values for HP 95LX keyboard layout:
 0001h	Belgium
 0002h	French Canadian
 0004h	Denmark
 0008h	Finland
 0010h	French
 0020h	Finland
 0040h	Italy
 0080h	Netherlands
 0100h	Norway
 0200h	Portugal
 0400h	Spain
 0800h	Sweden
 1000h	Swiss French
 2000h	Swiss German
 4000h	United Kingdom
 8000h	USA
--------b-60----DI0B0A-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_SET_SETTINGS"
	DI = 0B0Ah
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0B09h
--------b-60----DI0B0B-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_START_TIMER"
	DI = 0B0Bh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0B0Ch,INT 60/DI=0B0Dh
--------b-60----DI0B0C-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_STOP_TIMER"
	DI = 0B0Ch
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0B0Bh,INT 60/DI=0B0Dh
--------b-60----DI0B0D-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_GET_TIMER"
	DI = 0B0Dh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0B0Bh,INT 60/DI=0B0Ch
--------b-60----DI0B0E-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_TELL_ANYTIME"
	DI = 0B0Eh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		WORD	???
		WORD	???
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: DX:AX -> ???
	STACK unchanged
--------b-60----DI0B0F-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVCE "M_GET_SETTINGS_ADDR"
	DI = 0B0Fh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: DX:AX -> system settings record (see #2926)
	STACK unchanged
SeeAlso: INT 60/DI=0B09h
--------b-60----DI0B10-----------------------
INT 60 u - HP 95LX System Manager - PARSE DATE SPECIFICATION
	DI = 0B10h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0B11-----------------------
INT 60 u - HP 95LX System Manager - PARSE TIME SPECIFICATION
	DI = 0B11h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to ???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0B12-----------------------
INT 60 u - HP 95LX System Manager - SET DATE PARSING RULE
	DI = 0B12h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	new parsing rule (see #2931)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0B13h

(Table 2931)
Values for HP 95LX date parsing rule:
 01h	day-month-year
 02h	month-day-year
 03h	year-month-day
 04h	"DMYO"
 05h	"MDYO"
 OR with 08h to get any year
--------b-60----DI0B13-----------------------
INT 60 u - HP 95LX System Manager - SET TIME PARSING RULE
	DI = 0B13h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	new parsing rule (see #2932)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0B12h

(Table 2932)
Values for HP 95LX time parsing rule:
 01h	HH:MM:SS (am/pm)
 02h	HH:MM:SS (24hr)
 03h	HHMM:SS (24hr)
 04h	HH:MM:SS.hh (24hr)
 05h	HH:MM (am/pm)
 06h	HH:MM (24hr)
 07h	HHMM (24hr)
--------b-60----DI0B14-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_POST_TIME"
	DI = 0B14h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
--------b-60----DI0B15-----------------------
INT 60 u - HP 95LX System Manager - CLOCK/CALENDAR SERVICE "M_DAY_TRIGGER"
	DI = 0B15h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI0C00-----------------------
INT 60 u - HP 95LX System Manager - OPEN PRINTER
	DI = 0C00h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0C01h,INT 60/DI=0C02h,INT 60/DI=0C03h
--------b-60----DI0C01-----------------------
INT 60 u - HP 95LX System Manager - CLOSE PRINTER
	DI = 0C01h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
Note:	relinquishes control of printer
SeeAlso: INT 60/DI=0C00h
--------b-60----DI0C02-----------------------
INT 60 u - HP 95LX System Manager - WRITE TO PRINTER
	DI = 0C02h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to data to be written
		WORD	length of data
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0C00h
--------b-60----DI0C03-----------------------
INT 60 u - HP 95LX System Manager - INITIALIZE PRINTER
	DI = 0C03h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0C00h
--------b-60----DI0C04-----------------------
INT 60 u - HP 95LX System Manager - "M_TRANS_PRINTER"
	DI = 0C04h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0C05-----------------------
INT 60 u - HP 95LX System Manager - "M_FALL_PRINTER"
	DI = 0C05h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI0E00-----------------------
INT 60 u - HP 95LX System Manager - COMMUNICATIONS SERVICE "M_COMM_INIT"
	DI = 0E00h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: #2933,INT 60/DI=0E01h,INT 60/DI=0E02h

(Table 2933)
Values for HP 95LX error code:
 0000h	successful
 FFF1h	"E_BUSY"
 FFF2h	timeout
 FFF3h	framing error
 FFF4h	parity error
 FFF5h	overrun error
 FFF6h	"E_EMPTY"
 FFF7h	"E_CONECT"
 FFF8h	not open
 FFF9h	out of memory
 FFFAh	buffer overflow
 FFFBh	"E_NOFIT"
 FFFCh	unsupported
 FFFDh	"E_IVOPR"
 FFFEh	"E_IVCHN"
 FFFFh	"E_REOPEN"
--------b-60----DI0E01-----------------------
INT 60 u - HP 95LX System Manager - OPEN COMMUNICATIONS CHANNEL
	DI = 0E01h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to WORD buffer for comm channel handle
		WORD	communications line number (01h-04h)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0E00h,INT 60/DI=0E02h
--------b-60----DI0E02-----------------------
INT 60 u - HP 95LX System Manager - CLOSE COMMUNICATIONS CHANNEL
	DI = 0E02h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	comm channel handle
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0E00h,INT 60/DI=0E01h
--------b-60----DI0E03-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_GETMDM"
	DI = 0E03h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E04-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_ANSWER"
	DI = 0E04h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E05-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_DIAL"
	DI = 0E05h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0E06-----------------------
INT 60 u - HP 95LX System Manager - RESET COMMUNICATIONS CHANNEL
	DI = 0E06h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	comm channel handle
		WORD	reset options (see #2934)
Return: ???
	STACK unchanged

Bitfields for HP 95LX reset options:
Bit(s)	Description	(Table 2934)
 0	reset line
 1	flush transmit buffer
 2	flush receive buffer
 3	reset modem
 4	reset receiver's ^S state
 5	reset transmitter's ^S state
--------b-60----DI0E07-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_HANGUP"
	DI = 0E07h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E08-----------------------
INT 60 u - HP 95LX System Manager - SEND DATA OVER COMM CHANNEL
	DI = 0E08h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	comm channel handle
		DWORD	pointer to data to be sent
		WORD	option flags
			bit 0: send partial buffer
			bit 1: turn on receiver after sending
		DWORD	pointer to WORD containing length of data to be sent
Return: length WORD updated to contain number of bytes actually sent???
	STACK unchanged
SeeAlso: INT 60/DI=0E09h,INT 60/DI=0E0Bh
--------b-60----DI0E09-----------------------
INT 60 u - HP 95LX System Manager - QUERY COMM CHANNEL TRANSMIT QUEUE
	DI = 0E09h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to ??? WORD
		DWORD	pointer to ??? WORD
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0E0Ah
--------b-60----DI0E0A-----------------------
INT 60 u - HP 95LX System Manager - QUERY COMM CHANNEL RECEIVE QUEUE
	DI = 0E0Ah
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	comm channel handle
		DWORD	pointer to WORD to get receive buffer size
		DWORD	pointer to WORD to get free bytes in receive buffer
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0E09h,INT 60/DI=0E0Bh
--------b-60----DI0E0B-----------------------
INT 60 u - HP 95LX System Manager - RECEIVE DATA FROM COMM CHANNEL
	DI = 0E0Bh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	comm channel handle
		DWORD	pointer to data buffer
		DWORD	pointer to WORD (call) length of data buffer
					(ret) number of bytes received
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0E08h,INT 60/DI=0E0Ah
--------b-60----DI0E0C-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_HAZCMD"
	DI = 0E0Ch
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E0D-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_COMAND"
	DI = 0E0Dh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E0E-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_BREAK"
	DI = 0E0Eh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E0F-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_FRCXON"
	DI = 0E0Fh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E10-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_FRCXOF"
	DI = 0E10h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E11-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_SETDTR"
	DI = 0E11h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E12-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_XMITNG"
	DI = 0E12h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E13-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_STATUS"
	DI = 0E13h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E14-----------------------
INT 60 u - HP 95LX System Manager - SET COMMUNICATIONS SETTINGS
	DI = 0E14h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	comm channel handle
		DWORD	pointer to communications settings (see #2935)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0E15h

Format of HP 95LX communications settings:
Offset	Size	Description	(Table 2935)
 00h	BYTE	dial type ('T' tone, 'P' pulse)
 01h	WORD	baud rate divisor (115200/baud_rate)
 03h	BYTE	parity (00h none, 08h odd, 18h even, 28h mark, 38h space)
 04h	BYTE	stop bits (00h one, 04h two)
 05h	BYTE	data bits - 5
 06h	BYTE	software handshake
		01h none, 02h XOFF/XON, 04h XOFF/any, 08h ENQ/ACK
 07h	BYTE	infrared (01h off, 02h on)
 08h	BYTE	duplex (01h half, 02h full)
 09h	BYTE	echo (01h echo, 02h no echo)
--------b-60----DI0E15-----------------------
INT 60 u - HP 95LX System Manager - GET COMMUNICATIONS SETTINGS
	DI = 0E15h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to buffer for settings (see #2935)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0E14h
--------b-60----DI0E16-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_CNFGUR"
	DI = 0E16h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		WORD	???
		WORD	???
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI0E17-----------------------
INT 60 u - HP 95LX System Manager - "M_COMM_QRYERR"
	DI = 0E17h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI0F00-----------------------
INT 60 u - HP 95LX System Manager - "M_ERRMSG"
	DI = 0F00h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
		DWORD	pointer to ???
		WORD	???
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0F01-----------------------
INT 60 u - HP 95LX System Manager - DRAW STANDARD TITLE BOX
	DI = 0F01h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ASCIZ title string
Return: ???
	STACK unchanged
--------b-60----DI0F02-----------------------
INT 60 u - HP 95LX System Manager - "SHOWNAME"
	DI = 0F02h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI0F03-----------------------
INT 60 u - HP 95LX System Manager - DISPLAY TWO-LINE MESSAGE BOX
	DI = 0F03h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to first line of message
		WORD	length of first line
		DWORD	pointer to second line of message
		WORD	length of second line
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0300h,INT 60/DI=0F04h,INT 60/DI=0F09h
--------b-60----DI0F04-----------------------
INT 60 u - HP 95LX System Manager - REMOVE MESSAGE BOX
	DI = 0F04h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0F03h,INT 60/DI=0F09h
--------b-60----DI0F05-----------------------
INT 60 u - HP 95LX System Manager - "M_COM_TIMER_ADDR"
	DI = 0F05h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: DX:AX -> ???
	STACK unchanged
--------b-60----DI0F06-----------------------
INT 60 u - HP 95LX System Manager - "M_COM_TIMER_COUNT_ADDR"
	DI = 0F06h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: DX:AX -> ???
	STACK unchanged
--------b-60----DI0F07-----------------------
INT 60 u - HP 95LX System Manager - "M_SYS_RSRC_ADDR"
	DI = 0F07h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: DX:AX -> ???
	STACK unchanged
--------b-60----DI0F08-----------------------
INT 60 u - HP 95LX System Manager - "M_BIOS_OUTSTR"
	DI = 0F08h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI0F09-----------------------
INT 60 u - HP 95LX System Manager - DISPLAY THREE-LINE MESSAGE BOX
	DI = 0F09h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to first line of message
		WORD	length of first line
		DWORD	pointer to second line of message
		WORD	length of second line
		DWORD	pointer to third line of message
		WORD	length of third line
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0F03h,INT 60/DI=0F04h
--------b-60----DI0F0A-----------------------
INT 60 u - HP 95LX System Manager - DISABLE MACROS
	DI = 0F0Ah
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0F0Bh
--------b-60----DI0F0B-----------------------
INT 60 u - HP 95LX System Manager - ENABLE MACROS
	DI = 0F0Bh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 60/DI=0F0Ah
--------b-60----DI0F0C-----------------------
INT 60 u - HP 95LX System Manager - "M_DATE_TIME_SEPS"
	DI = 0F0Ch
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI0F0D-----------------------
INT 60 u - HP 95LX System Manager - "M_FORM_FT"
	DI = 0F0Dh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: DX:AX -> ???
	STACK unchanged
--------b-60----DI0F0E-----------------------
INT 60 u - HP 95LX System Manager - "M_RAM_IV_INFO"
	DI = 0F0Eh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: DX:AX -> ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI1005-----------------------
INT 60 u - HP 95LX System Manager - "M_DIRTY_SYNC" - FORCE SCREEN UPDATE
	DI = 1005h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
SeeAlso: INT 10/AH=FFh,INT 60/DI=0300h,INT 60/DI=0301h
--------b-60----DI1200-----------------------
INT 60 u - HP 95LX System Manager - RESOURCE SERVICE "MAP_RESOURCE_FILE"
	DI = 1200h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI1201-----------------------
INT 60 u - HP 95LX System Manager - "GET_RESOURCE_PTR"
	DI = 1201h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		WORD	???
Return: DX:AX -> ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI1202-----------------------
INT 60 u - HP 95LX System Manager - "GET_RSRC_TAB_PTR"
	DI = 1202h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: DX:AX -> ???
	STACK unchanged
--------b-60----DI1203-----------------------
INT 60 u - HP 95LX System Manager - "INIT_SYSMGR_RSRCS"
	DI = 1203h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: ???
	STACK unchanged
--------b-60----DI1300-----------------------
INT 60 u - HP 95LX System Manager - INITIALIZE HELP SYSTEM
	DI = 1300h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI1301-----------------------
INT 60 u - HP 95LX System Manager - DISPLAY HELP
	DI = 1301h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
--------b-60----DI1302-----------------------
INT 60 u - HP 95LX System Manager - "M_HELP_KEY"
	DI = 1302h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI1303-----------------------
INT 60 u - HP 95LX System Manager - "M_HELP_TERM"
	DI = 1303h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI1400-----------------------
INT 60 u - HP 95LX System Manager - "M_ColInit"
	DI = 1400h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
Return: AX = ???
	STACK unchanged
--------b-60----DI1401-----------------------
INT 60 u - HP 95LX System Manager - "M_ColCpStr"
	DI = 1401h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI1402-----------------------
INT 60 u - HP 95LX System Manager - "M_ColLicsStr"
	DI = 1402h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI1403-----------------------
INT 60 u - HP 95LX System Manager - "M_ColLicsChar"
	DI = 1403h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI1404-----------------------
INT 60 u - HP 95LX System Manager - "M_ColToLower"
	DI = 1404h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI1405-----------------------
INT 60 u - HP 95LX System Manager - "M_ColCpSearch"
	DI = 1405h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
		DWORD	pointer to ???
		WORD	???
		WORD	???
Return: ???
	STACK unchanged
--------b-60----DI1406-----------------------
INT 60 u - HP 95LX System Manager - "M_ColToUpper"
	DI = 1406h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		DWORD	pointer to ???
		WORD	???
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI1500-----------------------
INT 60 u - HP 95LX System Manager - "GrDispInit"
	DI = 1500h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI1501-----------------------
INT 60 u - HP 95LX System Manager - "GrDispClear"
	DI = 1501h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI1502-----------------------
INT 60 u - HP 95LX System Manager - "GrDispDot"
	DI = 1502h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI1503-----------------------
INT 60 u - HP 95LX System Manager - "GrDispDraw"
	DI = 1503h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI1504-----------------------
INT 60 u - HP 95LX System Manager - "GrDispFill"
	DI = 1504h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI1505-----------------------
INT 60 u - HP 95LX System Manager - "GrDispRead"
	DI = 1505h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI1506-----------------------
INT 60 u - HP 95LX System Manager - "GrDispString"
	DI = 1506h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI1507-----------------------
INT 60 u - HP 95LX System Manager - "GrDispPan"
	DI = 1507h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI1508-----------------------
INT 60 u - HP 95LX System Manager - "GrDispZoom"
	DI = 1508h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI1509-----------------------
INT 60 u - HP 95LX System Manager - "GrDispSave"
	DI = 1509h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI150A-----------------------
INT 60 u - HP 95LX System Manager - "GrDispRestore"
	DI = 150Ah
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
--------b-60----DI150B-----------------------
INT 60 u - HP 95LX System Manager - "GrDispCorner"
	DI = 150Bh
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------b-60----DI1604-----------------------
INT 60 u - HP 95LX System Manager - "CP_TO_LICS"
	DI = 1604h
	STACK:	2 WORDs unused dummies (for calls from high level languages)
		???
Return: ???
	STACK unchanged
SeeAlso: INT 15/AX=4DD4h,INT 61"HP 95LX",INT 62"HP 95LX"
--------G-6000-------------------------------
INT 60 - SYS_PROF.EXE - PROFILER STATUS
	AH = 00h
Return: AX = 0000h    profiling is off
	    otherwise profiling is on
Note:	SYS_PROF.EXE is the TSR portion of a profiler from Micro Cornucopia
	  Issue 47
SeeAlso: AH=01h"SYS_PROF",AH=02h"SYS_PROF"
--------G-6000-------------------------------
INT 60 - MDEBUG - GET STATUS
	AH = 00h
	DS:SI -> password or a null byte
Return: AX = return code
	    FFFEh password is invalid
	    FFFDh display mode is invalid
	    else successful
		ES = value of the monitor register SE
		DI = value of the monitor register OF
		CH = monitor color
		CL = interpreter color
		BH = monitor start line
		BL = interpreter start line
		AH = makecode of the hotkey
		AL = ASCII code of the hotkey
		DL = status of special keys (only SHIFT, ALT, CTRL) for the
		      hotkey (coded as for the keyboard flag at 0040h:0017h)
		DH = basic process number for the communication with drivers
		      process number for the display driver, DH+1 = process
		      number for the command driver(s)
	DS:SI -> MDEBUG identification table (see #2936)
Program: MDEBUG is a shareware memory-resident debugging tool by Bernd
	  Schemmer, including a memory monitor, an interpreter, and a
	  disassembler
Notes:	MDEBUG uses INT 60 by default, but may be directed to any of INT 60
	  through INT 67; the interrupt handler is preceded by the signature
	  "USERINT" and is not chained
	if DS:SI points at a null byte, MDEBUG will prompt for a password if
	  passwords are active; enough stack space must be provided for an
	  INT 10h call (which MDEBUG uses while prompting for the password)
SeeAlso: AH=02h"MDEBUG"
Index:	hotkeys;MDEBUG

Format of MDEBUG identification table:
Offset	Size	Description	(Table 2936)
 -2	WORD	entry offset
 00h	WORD	CS of MDEBUG
 02h	DWORD	old INT 08h vector
 06h	DWORD	old INT 09h vector
 0Ah	DWORD	address INT 16h routine used by MDEBUG
 0Eh	BYTE	length of version string
 0Fh  N BYTEs	version string
--------N-600000-----------------------------
INT 60 - RIFS - CLIENT - INSTALLATION CHECK
	AX = 0000h
Return: AX = 1234h if installed
	CF clear
Program: RIFS is the Remote Installable File System by "kyle"
Range:	INT 60 to INT 66 and INT 18,selected by scanning for 0000h:0000h vector
Note:	the installation check consists of testing for the signature "RIFS"
	  immediately preceding the interrupt handler
SeeAlso: AX=0001h,AX=0005h,AX=0007h,AX=0008h,INT 2F/AX=5600h
--------N-600001-----------------------------
INT 60 - RIFS - CLIENT - UNINSTALL
	AX = 0001h
Return: CF clear if successful
SeeAlso: AX=0000h,AX=0009h
--------N-600002-----------------------------
INT 60 - RIFS - CLIENT - REMAP DRIVE
	AX = 0002h
	BH = local drive number
	BL = remote drive number
Return: CF clear if successful
	CF set on error
SeeAlso: AX=0000h,AX=0003h,AX=0004h,INT 21/AX=5F03h,INT 21/AX=5F05h"STARLITE"
--------N-600003-----------------------------
INT 60 - RIFS - CLIENT - UNMAP DRIVE
	AX = 0003h
	BL = drive to unmap
Return: CF clear if successful
	CF set on error
SeeAlso: AX=0000h,AX=0002h,AX=0004h,INT 21/AX=5F04h,INT 21/AX=5F06h"STARLITE"
--------N-600004-----------------------------
INT 60 - RIFS - CLIENT - UNMAP ALL DRIVES
	AX = 0004h
Return: CF clear if successful
	CF set on error
SeeAlso: AX=0000h,AX=0002h,AX=0003h
--------N-600005-----------------------------
INT 60 - RIFS - CLIENT - GET TRANSLATION TABLE
	AX = 0005h
Return: CF clear if successful
	    ES:BX -> translation table
	CF set on error
SeeAlso: AX=0000h,AX=0006h,AX=0007h
--------N-600006-----------------------------
INT 60 - RIFS - CLIENT - GET STATISTICS TABLE
	AX = 0006h
Return: CF clear if successful
	    ES:BX -> statistics table
	CF set on error
SeeAlso: AX=0000h,AX=0005h,AX=0007h,AX=000Ah
--------N-600007-----------------------------
INT 60 - RIFS - CLIENT - GET PORT TRANSLATION TABLE
	AX = 0007h
Return: CF clear if successful
	    CX = number of entries
	    ES:BX -> port mapping table
	CF set on error
SeeAlso: AX=0000h,AX=0005h
--------N-600008-----------------------------
INT 60 - RIFS - SERVER - INSTALLATION CHECK
	AX = 0008h
Return: CF clear if successful
	CF set on error
Range:	INT 60 to INT 66 and INT 18,selected by scanning for 0000h:0000h vector
Note:	the installation check consists of testing for the signature "RIFS"
	  immediately preceding the interrupt handler
SeeAlso: AX=0000h,AX=0009h,AX=000Ah,AX=000Bh
--------N-600009-----------------------------
INT 60 - RIFS - SERVER - UNINSTALL
	AX = 0009h
Return: CF clear if successful
	CF set on error
SeeAlso: AX=0001h,AX=0008h
--------N-60000A-----------------------------
INT 60 - RIFS - SERVER - GET STATISTICS TABLE
	AX = 000Ah
Return: CF clear if successful
	    ES:BX -> statistics table
	CF set on error
SeeAlso: AX=0006h,AX=0008h,AX=0009h,AX=000Bh
--------N-60000B-----------------------------
INT 60 - RIFS - SERVER - RESET
	AX = 000Bh
Return: CF clear if successful
	CF set on error
Note:	closes all open files
SeeAlso: AX=0008h,AX=0009h
--------G-6001-------------------------------
INT 60 - MDEBUG - GET ADDRESS OF THE HELP REGISTERS
	AH = 01h
	DS:SI -> password or a null byte
Return: AX = return code
	    FFFEh password is invalid
	    FFFDh display mode is invalid
	    else successful
		ES:DI point to the help registers of MDEBUG
	       ES:DI-02h  -> R0 (WORD)
	       ES:DI	  -> R1 (WORD)
	       ES:DI+02h  -> R2 (WORD)
	       ES:DI+04h  -> R3 (WORD)
	       ...
	       ES:DI+0Eh  -> R8 (WORD)
--------G-6001-------------------------------
INT 60 - SYS_PROF.EXE - TURN PROFILING OFF
	AH = 01h
Note:	SYS_PROF.EXE is the TSR portion of a profiler from Micro Cornucopia
	  Issue 47
SeeAlso: AH=00h"SYS_PROF",AH=02h"SYS_PROF"
--------N-6001FF-----------------------------
INT 60 - FTP Packet Driver - BASIC FUNC - GET DRIVER INFO
	AX = 01FFh
	BX = handle returned by function 02h
Return: CF set on error
	    DH = error code (see #2937)
	CF clear if successful
	    BX = version
	    CH = network interface class (see #2938)
	    DX = interface type (see #2938)
	    CL = number
	    DS:SI -> name
	    AL = driver functions supported
		01h basic
		02h basic and extended
		05h basic and high-performance
		06h basic, high-performance, and extended
		FFh not installed
Note:	the handle in BX is optional for drivers written to v1.07 or later of
	  the packet driver specification

(Table 2937)
Values for Packet Driver error code:
 01h "BAD_HANDLE"	invalid handle number
 02h "NO_CLASS"		no interfaces of the specified class found
 03h "NO_TYPE"		no interfaces of the specified type found
 04h "NO_NUMBER"	no interfaces of the specified number found
 05h "BAD_TYPE"		bad packet type
 06h "NO_MULTICAST"	interface does not support multicast messages
 07h "CANT_TERMINATE"	this packet driver cannot terminate
 08h "BAD_MODE"		invalid receiver mode
 09h "NO_SPACE"		insufficient space
 0Ah "TYPE_INUSE"	type accessed but never released
 0Bh "BAD_COMMAND"	bad command
 0Ch "CANT_SEND"	packet could not be sent
 0Dh "CANT_SET"		hardware address could not be changed
 0Eh "BAD_ADDRESS"	hardware address has a bad length or format
 0Fh "CANT_RESET"	could not reset interface

(Table 2938)
Values for Packet Driver network interface classes/types:
    Class 01h  Ethernet/IEEE 802.3
	01h 3COM 3C500/3C501
	02h 3COM 3C505
	03h MICOM-Interlan NI5010
	04h BICC Data Networks 4110
	05h BICC Data Networks 4117
	06h MICOM-Interlan NP600
	08h Ungermann-Bass PC-NIC
	09h Univation NC-516
	0Ah TRW PC-2000
	0Bh MICOM-Interlan NI5210
	0Ch 3COM 3C503
	0Dh 3COM 3C523
	0Eh Western Digital WD8003
	0Fh Spider Systems S4
	10h Torus Frame Level
	11h 10Net Communications
	12h Gateway PC-bus
	13h Gateway AT-bus
	14h Gateway MCA-bus
	15h IMC PCnic
	16h IMC PCnic II
	17h IMC PCnic 8-bit
	18h Tigan Communications
	19h Micromatic Research
	1Ah Clarkson "Multiplexor"
	1Bh D-Link 8-bit
	1Ch D-Link 16-bit
	1Dh D-Link PS/2
	1Eh Research Machines 8
	1Fh Research Machines 16
	20h Research Machines MCA
	21h Radix Microsystems EXM1 16-bit
	22h Interlan Ni9210
	23h Interlan Ni6510
	24h Vestra LANMASTER 16-bit
	25h Vestra LANMASTER 8-bit
	26h Allied Telesis PC/XT/AT
	27h Allied Telesis NEC PC-98
	28h Allied Telesis Fujitsu FMR
	29h Ungermann-Bass NIC/PS2
	2Ah Tiara LANCard/E AT
	2Bh Tiara LANCard/E MC
	2Ch Tiara LANCard/E TP
	2Dh Spider Communications SpiderComm 8
	2Eh Spider Communications SpiderComm 16
	2Fh AT&T Starlan NAU
	30h AT&T Starlan-10 NAU
	31h AT&T Ethernet NAU
	32h Intel smart card
	33h Xircom Packet Adapter
	34h Aquila Ethernet
	35h Novell NE1000
	36h Novell NE2000
	37h SMC PC-510
	38h AT&T Fiber NAU
	39h NDIS to Packet Driver adapter
	3Ah Racal-InterLan ES3210
	3Bh General Systems ISDN simulated Ethernet
	3Ch Hewlett-Packard
	3Dh IMC EtherNic-8
	3Eh IMC EtherNic-16
	3Fh IMC EtherNic-MCA
	40h NetWorth EtherNext
	41h Dataco Scanet
	42h DEC DEPCA
	43h C-Net
	44h Gandalf LANLine
	45h Apricot built-in
	46h David Systems Ether-T
	47h ODI to Packet Driver adapter (see also INT 2F/AX=5100h)
	48h AMD Am21110-16
	49h Intel ICD Network controller family
	4Ah Intel ICD PCL2
	4Bh Intel ICD PCL2A
	4Ch AT&T LANPacer
	4Dh AT&T LANPacer+
	4Eh AT&T EVB
	4Fh AT&T StarStation
	50h SLIP simulated ethernet
	51h Racal-Interlan NIA310
	52h Racal-Interlan NISE
	53h Racal-Interlan NISE30
	54h Racal-Interlan NI6610
	55h Ethernet over IP/UDP
	56h ICL EtherTeam 16
	57h David Systems
	58h NCR WaveLAN
	59h Thomas Contrad TC5045
	5Ah Russ Nelson's Parallel Port driver
	5Bh Intell EtherExpress 16
	5Ch IBMTOKEN
	5Dh Zenith Z-Note
	5Eh 3Com 3C509
	5Fh Mylex LNE390
	60h Madge Smart Ringnode
	61h Novell NE2100
	62h Allied Telesis 1500
	63h Allied Telesis 1700
	64h Fujitsu EtherCoupler
    Class 02h  ProNET-10
	01h Proteon p1300
	02h Proteon p1800
    Class 03h  IEEE 802.5/ProNet-4 (without expanded RIFs)
	01h IBM Token-Ring Adapter
	02h Proteon p1340
	03h Proteon p1344
	04h Gateway PC-bus
	05h Gateway AT-bus
	06h Gateway MCA-bus
	07h Madge board
	39h NDIS to Packet Driver adapter
	47h ODI to Packet Driver adapter
    Class 04h  Omninet
    Class 05h  Appletalk
	01h ATALK.SYS adapter
    Class 06h  Serial Line
	01h Clarkson 8250-SLIP
	02h Clarkson "Multiplexor"
	03h Eicon Technologies
    Class 07h  StarLAN (subsumed by Ethernet class)
    Class 08h  ARCnet
	01h Datapoint RIM
    Class 09h  AX.25
	01h Ottawa PI card
	02h Eicon Technologies
    Class 0Ah  KISS
    Class 0Bh  IEEE 802.3 with 802.2 headers
	types same as for class 01h
    Class 0Ch  FDDI with 802.2 headers
	01h Western Digital
	02h Frontier Technology
    Class 0Dh  Internet X.25
	01h Western Digital
	02h Frontier Technology
	03h Emerging Technologies
	04h The Software Forge
	05h Link Data Intelligent X.25
	06h Eicon Technologies
    Class 0Eh  N.T. LANSTAR (encapsulating DIX Ethernet)
	01h NT LANSTAR/8
	02h NT LANSTAR/MC
    Class 0Fh  SLFP (MIT serial specification)
	01h MERIT
    Class 10h  PPP (Point-to-Point Protocol)
	01h 8250/16550 UART
	02h Niwot Networks synch
	03h Eicon Technologies
    Class 11h  802.5 with expanded RIFs
	types same as for class 3
    Class 12h  reserved for LCP/NCPs
Note: class and type numbers are cleared through FTP Software
--------G-6002-------------------------------
INT 60 - MDEBUG - SET STATUS
	AH = 02h
	DS:SI -> password or a null byte
	ES = new value for the register SE
	DI = new value for the register OF
	CH = new monitor color if nonzero
	CL = new interpreter color if nonzero
	BH = new monitor start line if nonzero
	BL = new interpreter start line if nonzero
	AL = new ASCII code for the hotkey ('A'..'Z', 'a'..'z') if nonzero
	DL = new status of the special keys (SHIFT, ALT, CTRL) for the hotkey
	      if nonzero
	DH = if nonzero, new basic process number for communication with the
	      drivers (DH = multiplex number for the display driver,
	      DH+1 = multiplex number for the command driver or drivers)
Return: AX = return code
	    FFFFh call not allowed
	    FFFEh password is invalid
	    FFFDh display mode is invalid
	    0000h successful, status changed
	    else AL = error reasons (see #2939)
Note:	the values of the registers SE and OF are always changed, the other
	  values are only changed if they are valid
SeeAlso: AH=00h"MDEBUG"
Index:	hotkeys;MDEBUG

Bitfields for MDEBUG error reasons:
Bit(s)	Description	(Table 2939)
 0	invalid monitor start line
 1	invalid interpreter start line
 2	invalid hotkey
 3	invalid process number
 4-7	reserved
--------N-6002-------------------------------
INT 60 - FTP Packet Driver - BASIC FUNC - ACCESS TYPE
	AH = 02h
	AL = interface class
	BX = interface type
	DL = interface number
	DS:SI -> type
	CX = length of type (0000h for all packets)
	ES:DI -> receiver function (see #2940)
Return: CF set on error
	    DH = error code (see #2937)
	CF clear if successful
	    AX = handle
SeeAlso: AH=03h"FTP"

(Table 2940)
Values packet driver receiver is called with when a packet is received:
	AX = subfunction
	    00h get packet buffer
		CX = buffer length
		DX = lookahead length (v1.10+)
		DS:SI -> lookahead buffer if DX nonzero (v1.10+)
		DI = error flags (class dependent) (v1.10+)
		Return: ES:DI -> packet buffer
				0000h:0000h means throw away packet
			CX = size of buffer (v1.10+), may be smaller than
			      incoming data
	    01h copy completed
		DS:SI -> buffer
		CX = bytes actually copied (v1.10+)
	BX = handle
--------G-6002-------------------------------
INT 60 - SYS_PROF.EXE - TURN PROFILING ON
	AH = 02h
Note:	SYS_PROF.EXE is the TSR portion of a profiler from Micro Cornucopia
	  Issue 47
SeeAlso: AH=00h"SYS_PROF",AH=01h"SYS_PROF"
--------G-6003-------------------------------
INT 60 - MDEBUG - POP UP
	AH = 03h
	DS:SI -> password or a null byte
	ES -> new value for the register SE
	DI -> new value for the register OF
Return: AX = return code (see #2941)
SeeAlso: AH=04h"MDEBUG"

(Table 2941)
Values for MDEBUG return code:
 FFFFh	call not allowed
 FFFEh	password is invalid
 FFFDh	display mode is invalid
 else	successful
--------N-6003-------------------------------
INT 60 - FTP Packet Driver - BASIC FUNC - RELEASE TYPE
	AH = 03h
	BX = handle
Return: CF set on error
	   DH = error code (see #2937)
	CF clear if successful
SeeAlso: AH=02h"FTP"
--------G-6003-------------------------------
INT 60 - SYS_PROF.EXE - GET ADDRESS OF PROFILING TABLE
	AH = 03h
Return: ES:BX -> profiling table
Note:	SYS_PROF.EXE is the TSR portion of a profiler from Micro Cornucopia
	  Issue 47
SeeAlso: AH=04h"SYS_PROF"
--------N-6004-------------------------------
INT 60 - FTP Packet Driver - BASIC FUNC - SEND PACKET
	AH = 04h
	DS:SI -> buffer
	CX = length
Return: CF set on error
	    DH = error code (see #2937)
	CF clear if successful
Note:	the buffer may be modified immediately upon return from this call
SeeAlso: AH=0Bh
--------G-6004-------------------------------
INT 60 - MDEBUG - POP UP
	AH = 04h
	DS:SI -> password or a null byte
Return: AX = return code (see #2941)
SeeAlso: AH=03h"MDEBUG",AH=07h"MDEBUG"
--------G-6004-------------------------------
INT 60 - SYS_PROF.EXE - CLEAR PROFILING TABLE
	AH = 04h
Note:	SYS_PROF.EXE is the TSR portion of a profiler from Micro Cornucopia
	  Issue 47
SeeAlso: AH=03h"SYS_PROF"
--------N-6005-------------------------------
INT 60 - FTP Packet Driver - BASIC FUNC - TERMINATE DRIVER FOR HANDLE
	AH = 05h
	BX = handle (optional for v1.10+)
Return: CF set on error
	   DH = error code (see #2937)
	CF clear if successful
--------G-6005-------------------------------
INT 60 - MDEBUG - GET AND SET MDEBUG FLAGS
	AH = 05h
	DS:SI -> password or a null byte
	BL = new value for the semaphor of MDEBUG
	     00h  enable popup of MDEBUG
	     else disable popup of MDEBUG
Return: AX = return code
	    FFFEh password is invalid
	    FFFDh display mode is invalid
	    else successful
		BL = old value of the semaphor of MDEBUG
		BH = old value of the INT 08h semaphor
		    (this semaphor is always reset after this function)
--------N-6006-------------------------------
INT 60 - FTP Packet Driver - BASIC FUNC - GET ADDRESS
	AH = 06h
	BX = handle (optional for v1.10+)
	ES:DI -> buffer
	CX = length
Return: CF set on error
	    DH = error code (see #2937)
	CF clear if successful
	    CX = length
Note:	copies the local net address associated with the handle into the buffer
--------G-6006-------------------------------
INT 60 - MDEBUG - GET PASSWORD STATUS
	AH = 06h
Return: AL = status
	    00h password inactive
	    01h password active
--------N-6007-------------------------------
INT 60 - FTP Packet Driver - BASIC FUNC - RESET INTERFACE
	AH = 07h
	BX = handle (optional for v1.10+)
Return: CF set on error
	    DH = error code (see #2937)
	CF clear if successful
--------G-6007-------------------------------
INT 60 - MDEBUG v1.70+ - GET ACTIVE PART OF MDEBUG
	AH = 07h
Return: AL = active part for the next popup session of MDEBUG:
	    bit 0: the next popup session will start in the interpreter rather
		  than in the monitor
	    bit 1: the next popup session will sart in the online-help
SeeAlso: AH=03h"MDEBUG",AH=04h"MDEBUG"
--------G-6008-------------------------------
INT 60 - MDEBUG - UNUSED
	AH = 08h-FFh
Return: AX = FFFCh
--------N-600A-------------------------------
INT 60 - FTP Packet Driver 1.09+ - HIGH-PERF FUNC - GET PARAMETERS
	AH = 0Ah
Return: CF set on error
	    DH = error code (0Bh) (see #2937)
	CF clear if successful
	    ES:DI -> parameter table (see #2942)

Format of packet driver parameter table:
Offset	Size	Description	(Table 2942)
 00h	BYTE	major revision of packet driver spec driver conforms to
 01h	BYTE	minor revision of packet driver spec
 02h	BYTE	length of this structure in bytes
 03h	BYTE	length of a MAC-layer address
 04h	WORD	maximum transfer unit, including MAC headers
 06h	WORD	buffer size for multicast addr
 08h	WORD	number of receive buffers (one less than back-to-back MTU rcvs)
 0Ah	WORD	number of transmit buffers
 0Ch	WORD	interrupt number to hook for post-EOI processing, 00h=none
--------N-600B-------------------------------
INT 60 - FTP Packet Driver 1.09 - HIGH-PERF FUNC - ASYNCHRONOUS SEND PACKET
	AH = 0Bh
	DS:SI -> buffer
	CX = length of buffer
	ES:DI -> FAR function to call when buffer becomes available (see #2943)
Return: CF set on error
	    DH = error code (0Bh,0Ch) (see #2937)
	CF clear if successful
Notes:	unlike function 04h, the buffer is not available for modification as
	  soon as the call returns; the buffer may be queued by the driver and
	  not processed until later
	this function has been dropped from v1.10+ of the specification and
	  replaced by function 0Ch
SeeAlso: AH=04h"Packet Driver",AH=0Ch"Packet Driver"

(Table 2943)
Values packet driver completion function is called with:
	AX = result
	    00h copy OK
	    nonzero error
	ES:DI -> buffer passed to INT 60/AH=0Bh call
--------N-600C-------------------------------
INT 60 - FTP Packet Driver 1.10+ - HIGH-PERF FUNC - ASYNCHRONOUS SEND PACKET
	AH = 0Ch
	ES:DI -> pointer to IOCB (see #2944)
Return: CF set on error
	    DH = error code (see #2937)
	CF clear if successful
SeeAlso: AH=04h"Packet Driver",AH=0Bh"Packet Driver"

Format of packet driver IOCB:
Offset	Size	Description	(Table 2944)
 00h	DWORD	pointer to buffer
 04h	WORD	length of buffer
 06h	BYTE	flags
		bit 0: packet driver is finished with IOCB
		bit 1: application requests upcall when driver completes
 07h	DWORD	function address for upcall (see #2945)
 0Bh  4 BYTEs	future gather write
 0Fh	BYTE	???
 10h  8 BYTEs	private driver workspace

(Table 2945)
Values completion function is called with:
	ES:DI -> IOCB passed to INT 60/AH=0Ch
--------N-600C-------------------------------
INT 60 - Banyan VINES, 3com - GET STATION ADDRESS
	AH = 0Ch
Return: AL = status
	    00h successful
		ES:SI -> 6-byte station address
	    02h semaphore service is unavailable
--------N-600D-------------------------------
INT 60 - FTP Packet Driver 1.10+ - HIGH-PERF FUNC - DROP PACKET FROM QUEUE
	AH = 0Dh
	ES:DI -> IOCB
Return: CF set on error
	    DH = error code (see #2937)
	CF clear if successful
SeeAlso: AH=0Ch"Packet Driver"
--------N-6011-------------------------------
INT 60 - 3com, 10NET, Banyan VINES - LOCK AND WAIT
	AH = 11h
	AL = drive number or 0
	DX = number of seconds to wait
	ES:SI = Ethernet address or 0
	DS:BX -> 31-byte ASCIZ semaphore name
Return: AL = status (see #2946)
SeeAlso: AH=12h,AH=13h

(Table 2946)
Values for 3com semaphore status:
 00h	successful
 01h	timeout
 02h	server not responding
 03h	invalid semaphore name
 04h	semaphore list is full
 05h	invalid drive ID
 06h	invalid Ethernet address
 07h	not logged in
 08h	write to network failed
 09h	semaphore already logged for this CPU
--------N-6012-------------------------------
INT 60 - 3com, 10NET, Banyan VINES - LOCK
	AH = 12h
	AL = drive number or 00h
	ES:SI = Ethernet address or 0000h:0000h
	DS:BX -> 31-byte ASCIZ semaphore name
Return: AL = status (see also #2946)
	    01h semaphore currently locked by another PC
Note:	unlike function 11h, this function returns immediately
SeeAlso: AH=11h,AH=13h
--------N-6013-------------------------------
INT 60 - 3com, 10NET, Banyan VINES - UNLOCK
	AH = 13h
	AL = drive number or 00h
	ES:SI = Ethernet address or 0000h:0000h
	DS:BX -> 31-byte ASCIZ semaphore name
Return: AL = status (see also #2946)
	    01h semaphore not locked
SeeAlso: AH=11h,AH=12h
--------N-6014-------------------------------
INT 60 - FTP Packet Driver - EXTENDED FUNC - SET RECEIVE MODE
	AH = 14h
	BX = handle (optional for v1.10+)
	CX = mode (see #2947)
Return: CF set on error
	   DH = error code (01h,08h) (see #2937)
	CF clear if successful
SeeAlso: AH=15h

(Table 2947)
Values for packet driver receive mode:
 01h	turn off receiver
 02h	receive only packets sent to this interface
 03h	mode 2 plus broadcast packets
 04h	mode 3 plus limited multicast packets
 05h	mode 3 plus all multicast packets
 06h	all packets
 07h	raw mode for serial line only (v1.10+)
--------N-6015-------------------------------
INT 60 - FTP Packet Driver - EXTENDED FUNC - GET RECEIVE MODE
	AH = 15h
	BX = handle (optional for v1.10+)
Return: CF set on error
	    DH = error code (01h) (see #2937)
	CF clear if successful
	    AX = receive mode (see #2947)
SeeAlso: AH=14h
--------N-6016-------------------------------
INT 60 - FTP Packet Driver - EXTENDED FUNC - SET MULTICAST LIST
	AH = 16h
	ES:DI -> multicast list
	CX = length of list in bytes
Return: CF set on error
	    DH = error code (06h,09h,0Eh) (see #2937)
	CF clear if successful
SeeAlso: AH=17h
--------N-6017-------------------------------
INT 60 - FTP Packet Driver - EXTENDED FUNC - GET MULTICAST LIST
	AH = 17h
Return: CF set on error
	    DH = error code (06h,09h) (see #2937 at AX=01FFh)
	CF clear if successful
	    ES:DI -> multicast addresses (do not modify)
	    CX = bytes of multicast addresses currently in use
SeeAlso: AH=16h
--------N-6018-------------------------------
INT 60 - FTP Packet Driver - EXTENDED FUNC - GET STATISTICS
	AH = 18h
	BX = handle (optional for v1.10+)
Return: CF set on error
	    DH = error code (01h) (see #2937)
	CF clear if successful
	    DS:SI -> statistics (see #2948)

Format of packet driver statistics:
Offset	Size	Description	(Table 2948)
 00h	DWORD	packets in
 04h	DWORD	packets out
 08h	DWORD	bytes in
 0Ch	DWORD	bytes out
 10h	DWORD	errors in
 14h	DWORD	errors out
 18h	DWORD	packets dropped
--------N-6019-------------------------------
INT 60 - FTP Packet Driver - EXTENDED FUNC - SET NETWORK ADDRESS
	AH = 19h
	ES:DI -> address
	CX = length of address
Return: CF set on error
	    DH = error code (0Dh,0Eh) (see #2937)
	CF clear if successful
	    CX = length
--------N-601A-------------------------------
INT 60 - FTP Packet Driver v1.10+ - EXTENDED FUNC - SEND RAW BYTES
	AH = 1Ah
	DS:SI -> buffer
	CX = length of buffer
Return: CF set on error
	    DH = error code (see #2937 at AX=01FFh)
	CF clear if successful
SeeAlso: AH=1Ch
--------N-601B-------------------------------
INT 60 - FTP Packet Driver v1.10+ - EXTENDED FUNC - FLUSH RAW BYTES RECEIVED
	AH = 1Bh
Return: CF set on error
	    DH = error code (see #2937)
	CF clear if successful
SeeAlso: AH=1Ch
--------N-601C-------------------------------
INT 60 - FTP Packet Driver v1.10+ - EXTENDED FUNC - FETCH RAW BYTES RECEIVED
	AH = 1Ch
	DS:SI -> buffer
	CX = length of buffer
	DX = timeout in clock ticks
Return: CF set on error
	    DH = error code (see #2937 at AX=01FFh)
	CF clear if successful
	    CX = number of bytes transferred to buffer
SeeAlso: AH=1Ah,AH=1Bh
--------a-60AD-------------------------------
INT 60 - AccessDOS - API
	AH = ADh
	AL = function
	    E1h ???
		Return: AX = ???
	    E2h get configuration
		Return: BX:AX -> configuration data
Program: AccessDOS is a public domain TSR developed at The Trace Research and
	  Development Center which provides extensions for keyboard, mouse,
	  and sound access by the visually, hearing, or motor-control
	  impaired.
Range:	INT 60 to INT 66, selected by scanning for 0000h:0000h vector
Note:	the installation check is to test for the signature "ACCESSv1.00"
	  beginning three bytes past the start of the interrupt handler
--------N-60E9-------------------------------
INT 60 - FTP Packet Driver - Crynwr Software - AUTOSELECT TRANSCEIVER
	AH = E9h
	???
Return: ???
--------!---Section--------------------------
