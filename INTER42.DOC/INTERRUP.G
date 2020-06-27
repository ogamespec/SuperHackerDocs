Interrupt List, part 7 of 12
This compilation is Copyright (c) 1989,1990,1991,1992,1993,1994 Ralf Brown
--------D-2D---------------------------------
INT 2D - DOS 2+ - RESERVED
Note:	this vector is not used in DOS versions <= 6.00, and points at an IRET
--------t-2D---------------------------------
INT 2D - ALTERNATE MULTIPLEX INTERRUPT SPECIFICATION (AMIS) [v3.5.1]
	AH = multiplex number
	AL = function
	    00h installation check
		Return: AL = 00h if free
			AL = FFh if multiplex number in use
			    CX = binary version number (CH = major, CL = minor)
			    DX:DI -> signature string (see #1240) identifying
				    the program using the multiplex number
	    01h get entry point
		Return: AL = 00h if all API calls via INT 2D
			AL = FFh if entry point supported
			    DX:BX -> entry point for bypassing interrupt chain
	    02h uninstall
		DX:BX = return address for successful uninstall (may be
			ignored by TSR)
		Return: AL = status
			    00h not implemented
			    01h unsuccessful
			    02h can not uninstall yet, will do so when able
			    03h safe to remove, but no resident uninstaller
				(TSR still enabled)
				BX = segment of memory block with resident code
			    04h safe to remove, but no resident uninstaller
				(TSR now disabled)
				BX = segment of memory block with resident code
			    05h not safe to remove now, try again later
			    FFh successful
			return at DX:BX with AX destroyed if successful and
			  TSR honors specific return address
	    03h request pop-up
		Return: AL = status
			    00h not implemented or TSR is not a pop-up
			    01h can not pop up at this time, try again later
			    02h can not pop up yet, will do so when able
			    03h already popped up
			    04h unable to pop up, user intervention required
				BX = standard reason code
				    0000h unknown failure
				    0001h interrupt chain passes through memory
					  which must be swapped out to pop up
				    0002h swap-in failed
				CX = application's reason code if nonzero
			    FFh TSR popped up and was exited by user
				BX = return value
				    0000h no return value
				    0001h TSR unloaded
				    0002h-00FFh reserved
				    0100h-FFFFh application-dependent
	    04h determine chained interrupts
		BL = interrupt number (except 2Dh)
		Return: AL = status
			    00h not implemented
			    01h (obsolete) unable to determine
			    02h (obsolete) interrupt hooked
			    03h (obsolete) interrupt hooked, address returned
				DX:BX -> TSR's interrupt BL handler
			    04h list of hooked interrupts returned
				DX:BX -> interrupt hook list (see #1241)
			    FFh interrupt not hooked
		Notes:	since INT 2D is known to be hooked, the resident code
			  need not test for BL=2Dh (to minimize its size), and
			  the return value is therefore undefined in that case.
			BL is ignored if the TSR returns AL=04h; in that case,
			  the caller needs to scan the return list rather than
			  making additional calls to this function.  If the
			  return is not 00h or 04h, then the caller must cycle
			  through the remaining interrupt numbers it wishes to
			  check.
			return values 01h thru 03h are disparaged and will be
			  removed from the next version of this specification;
			  they are included for compatibility with version 3.3,
			  though they were probably never used in any
			  implementation
	    05h get hotkeys
		Return: AL = status
			    00h not implemented
			    FFh supported
				DX:BX -> hotkey list (see #1242)
	    06h-0Fh reserved for future enhancements
		Return: AL = 00h (not implemented)
	    other  application-dependent
Notes:	programs should not use fixed multiplex numbers; rather, a program
	  should scan all multiplex numbers from 00h to FFh, remembering the
	  first unused multiplex in case the program is not yet installed.
	  For multiplex numbers which are in use, the program should compare
	  the first 16 bytes of the signature string to determine whether it
	  is already installed on that multiplex number.  If not previously
	  installed, it should use the first free multiplex number.
	functions other than 00h are not valid unless a program is installed
	  on the selected multiplex number
	to be considered fully compliant with version 3.5 of the specification,
	  programs must implement at least functions 00h, 02h (no resident
	  uninstall code required), and 04h (return value 04h).	 TSRs that
	  provide hotkeys with which the user can activate them must also
	  implement function 05h.  The absolute minimum fully-compliant
	  implementation has an overhead of 64 bytes (80 bytes with function
	  05h) plus 22 bytes per hooked interrupt (for the interrupt sharing
	  protocol header and hook list entry).
	the signature string and description may be used by memory mappers
	  to display the installed programs
	users of this proposal should adhere to the IBM interrupt sharing
	  protocol (see #1246), which will permit removal of TSRs in
	  arbitrary order and interrupt handler reordering.  All TSRs
	  following this proposal should be removable, though they need not
	  keep the code for removing themselves resident; it is acceptable
	  for a separate program to perform the removal.
	A sample implementation including example TSRs and utility programs
	  may be found in a separate package distributed as AMISLnnn.ZIP
	  (AMISL091.ZIP as of this writing).
	Please let me know if you choose to follow this proposal.  The
	  signature and a list of the private API calls you use would be
	  appreciated, as well.
SeeAlso: INT 2F
Index:	installation check;Alternate Multiplex Interrupt Specification
Index:	installation check;AMIS|installation check;FASTMOUS
Index:	installation check;SPELLER|installation check;Monitor
Index:	installation check;NOLPT|installation check;NOTE
Index:	installation check;RBkeyswp|installation check;SWITCHAR
Index:	installation check;VGABLANK|installation check;EATMEM
Index:	installation check;RECALL|installation check;XPTR2
Index:	uninstall;Alternate Multiplex Interrupt Specification|uninstall;AMIS
Index:	entry point;Alternate Multiplex Interrupt|entry point;AMIS

Format of AMIS signature string:
Offset	Size	Description	(Table 1240)
 00h  8 BYTEs	blank-padded manufacturer's name (possibly abbreviated)
 08h  8 BYTEs	blank-padded product name
 10h 64 BYTEs	ASCIZ product description (optional, may be a single 00h)
Note:	it is not necessary to reserve a full 64 bytes for the description,
	  just enough to store the actual ASCIZ string

Format of AMIS interrupt hook list [array]:
Offset	Size	Description	(Table 1241)
 00h	BYTE	interrupt number (last entry in array is 2Dh)
 01h	WORD	offset within hook list's segment of the interrupt handler
		this will point at the initial short jump of the interrupt
		  sharing protocol header (see #1246)

Format of AMIS hotkey list:
Offset	Size	Description	(Table 1242)
 00h	BYTE	type of hotkey checking (see #1243)
 01h	BYTE	number of hotkeys (may be zero if TSR can disable hotkeys)
 02h 6N BYTEs	array of hotkey definitions
		(one per hotkey, first should be primary hotkey)
		Offset	Size	Description
		 00h	BYTE	hotkey scan code (00h/80h if shift states only)
				hotkey triggers on release if bit 7 set
		 01h	WORD	required shift states (see #1244)
		 03h	WORD	disallowed shift states (see #1244)
		 05h	BYTE	hotkey flags (see #1245)
Notes:	except for bit 7, the shift states correspond exactly to the return
	  values from INT 16/AH=12h.  A set bit in the required states word
	  indicates that the corresponding shift state must be active when the
	  hotkey's scan code is received for the hotkey to be recognized; a
	  clear bit means that the corresponding state may be ignored.	A set
	  bit in the disallowed shift states word indicates that the
	  corresponding shift state must be inactive.
	for the disallowed-states word, if one of the "either" bits is set,
	  then both the corresponding left bit and right bit must be set
	examples:
		Ctrl-Alt-Del monitoring: 53h 000Ch 0003h 06h
		Alt-key tap (DESQview):	 B8h 0000h 0007h 08h
		Shf-Shf-N (NOTE.COM):	 31h 0003h 000Ch 00h
Index:	hotkeys;AMIS

Bitfields for type of AMIS hotkey checking:
Bit(s)	Description	(Table 1243)
 0	checks before chaining INT 09
 1	checks after chaining INT 09
 2	checks before chaining INT 15/AH=4Fh
 3	checks after chaining INT 15/AH=4Fh
 4	checks on INT 16/AH=00h,01h,02h
 5	checks on INT 16/AH=10h,11h,12h
 6	checks on INT 16/AH=20h,21h,22h
 7	reserved (0)

Bitfields for AMIS shift states:
Bit(s)	Description	(Table 1244)
 0	right shift pressed
 1	left shift pressed
 2	either control key pressed
 3	either Alt key pressed
 4	ScrollLock active
 5	NumLock active
 6	CapsLock active
 7	either shift key pressed
 8	left control key pressed
 9	left Alt key pressed
 10	right control key pressed
 11	right Alt key pressed
 12	ScrollLock pressed
 13	NumLock pressed
 14	CapsLock pressed
 15	SysReq key pressed
Notes:	if bit 2 is set, either control key may be pressed for the hotkey; if
	  bits 8 and 10 are both set, then both control keys must be pressed.
	  Similarly for bits 3 and 9/11, as well as 7 and 0/1.
	the SysReq key is often labeled SysRq

Bitfields for AMIS hotkey flags:
Bit(s)	Description	(Table 1245)
 0	hotkey chained before processing
 1	hotkey chained after processing
 2	others should pass through this hotkey so that it can be monitored
 3	hotkey will not activate if other keys pressed/released before hotkey
	  press is completed
 4	this key is remapped into some other key
 5-7	reserved (0)

Format of interrupt sharing protocol interrupt handler entry point:
Offset	Size	Description	(Table 1246)
 00h  2 BYTEs	short jump to actual start of interrupt handler, immediately
		  following this data block (EBh 10h)
 02h	DWORD	address of next handler in chain
 06h	WORD	signature 424Bh
 08h	BYTE	EOI flag
		00h software interrupt or secondary hardware interrupt handler
		80h primary hardware interrupt handler (will issue EOI)
 09h  2 BYTEs	short jump to hardware reset routine
		must point at a valid FAR procedure (may be just RETF)
 0Bh  7 BYTEs	reserved (0)

(Table 1247)
Values of AMIS signatures known to be in use:
 'Byrial J' 'EKLAVO  '	permits keyboard entry of Esperanto accented letters
 'CoveSoft' 'Burnout+'	shareware screen saver Burnout Plus
 'Crynwr  ' 'SPELLER '	TSR spelling-checker
 'CSJewell' 'Modula3L'	Curtis Jewell's Modula-3 compiler (non-TSR)
 'DAISYCHA' 'INDRIVER'	Advanced Parallel Port daisy chain driver (vendor name
			  in product description field, if desired)
			(see also INT 2D/AL=DCh)
 'ECLIPSE ' 'PLUMP   '	Eclipse Software's printer and plotter spooler
 'GraySoft' 'GIPC    '	GraySoft's Inter-Process Communications driver
 'heathh  ' 'Monitor '
 'Helge O '		TSRs by Helge Olav Helgesen
 'J. Berry' 'RATSR   '	RemoteAccess Network Manager workstation module
 'JWB	  ' 'RAMLIGHT'	James Birdsall's on-screen RAMdisk activity indicator
 'Nildram ' 'ST	     '	Screen Thief graphics screen grabber
 'R-Ware  ' 'dLite   '	run-time data decompression TSR
 'Ralf B  ' 'FASTMOUS'	example TSR included with sample AMIS library code
 'Ralf B  ' 'NOLPT n '	example TSR -- turn LPTn into bit-bucket
 'Ralf B  ' 'NOTE    '	example TSR -- popup note-taker
 'Ralf B  ' 'RBkeyswp'	RBkeyswap v3.0+ -- swap Esc/~ and LCtrl/CapsLock keys
 'Ralf B  ' 'SWITCHAR'	example TSR -- add switchar() support removed from DOS5
 'Ralf B  ' 'VGABLANK'	example TSR -- VGA-only screen blanker
 'Sally IS' 'Mdisk   '	removeable, resizeable RAMdisk
 'Sally IS' 'Scr2Tex '	screen dumper with output in (La)Tex format
 'Thaco	  ' 'NEST    '	Eirik Pedersen's programmer's delimiter matcher
 'TifaWARE' 'EATMEM  '	George A. Theall's public domain memory restrictor for
			testing programs (v1.1+)
 'TifaWARE' 'RECALL  '	public domain commandline editor and history (v1.2+)
 'Todd	  ' 'XPTR2   '	PC-to-Transputer interface by Todd Radel
--------N-2D--10-----------------------------
INT 2D - RATSR 2.0+ - GET STATUS
	AL = 10h
	AH = AMIS multiplex number for RATSR
Return: AL = status
	    01h listening (no connection)
	    02h receiving	      \
	    03h sending		       > station being monitored
	    04h initializing receive  /
	AH = keyboard lock status (00h unlocked, 01h locked)
Program: RATSR is a utility by James Berry provided with
	  RemoteAccess/Professional, a commercial bulletin board system, that
	  allows remote control of a station over a network
SeeAlso: INT 2D"AMIS"
--------d-2D--10-----------------------------
INT 2D - dLite 1.0+ - GET PARAMETER BLOCK ADDRESS
	AL = 10h
	AH = AMIS multiplex number for dLite
Return: CF clear if successful
	    ES:BX -> parameter block (see #1248)
	CF set on error
Program: dLite is a shareware TSR by Rainer Schuetze which transparently
	  expands compressed files when they are read
SeeAlso: AL=11h"dLite",AL=12h"dLite",INT 21/AX=FEDCh"PCMANAGE"

Format of dLite parameter block:
Offset	Size	Description	(Table 1248)
 00h	BYTE	TSR flags (see #1249)
 01h	WORD	maximum number of programs needing original filesize
 03h	WORD	current number of programs needing original filesize
 05h	WORD	maximum number of files that can be handled by dLite (should
		  be the same as FILES= in CONFIG.SYS)
 07h	WORD	offset (in the same segment as the parameter block) of the
		  table of programs needing the original filesize (8 bytes
		  each,	without path or extension, uppercase, and zero \
		  terminated if	shorter than 8 bytes)

Bitfields for dLite TSR flags:
Bit(s)	Description	(Table 1249)
 0	deny FCB access
 1	dLite sleeping rather than activated
 2	always indicate original filesize when reading directory entries,
	  rather than only for specified programs
 3-7	reserved
--------V-2D--10-----------------------------
INT 2D - Burnout Plus v3.00 - GET STATE/CONTROL INFORMATION
	AL = 10h
	AH = AMIS multiplex number for Burnout Plus
Return: AL = 01h
	BX = Burnout Plus status (see #1250)
	CX = record of features loaded (see #1251)
	ES:DI -> Burnout Plus control structure (see #1252)
Program: Burnout Plus is a DOS screen saver from Cove Software
SeeAlso: INT 14/AX=AA01h,INT 2D"AMIS"
Index:	screen saver;Burnout Plus

Bitfields for Burnout Plus status:
Bit(s)	Description	(Table 1250)
 0	screen is blanked
 1	MS Windows is active (Burnout Plus deactivated)
 2-15	reserved

Bitfields for Burnout Plus features loaded/features enabled:
Bit(s)	Description	(Table 1251)
 0	mouse activity monitor
 1	passkey support
 2	password support
 3	continuous clear
 4	software blanking
 5	video activity monitor
 6	disk activity monitor
 7	activating keystroke suppression

Format of Burnout Plus control structure:
Offset	Size	Description	(Table 1252)
 00h	BYTE	size of structure in bytes
 01h	WORD	Burnout Plus version
 03h	WORD	screen blanking reset count in clock ticks
 05h	WORD	current countdown value in clock ticks
 07h	BYTE	type of timeout specification
 08h	BYTE	instant-blank hotkey
 09h	WORD	extended status information (see #1253)
		the bits for password, passkey, and software blanking are
		  ignored and cannot be enabled or disabled externally
 0Bh	WORD	features enabled (see #1251)
Note:	all fields except the first two may be modified by external programs
	  to affect the operation of Burnout Plus
Index:	hotkeys;Burnout Plus

Bitfields for extended Burnout Plus status information:
Bit(s)	Description	(Table 1253)
 0	Burnout Plus disabled
 1	force screen to blank on next clock tick
 2	restore screen if currently blanked
 3-15	reserved
Note:	1 and 2 are automatically cleared by Burnout Plus after blanking
	  or restoring the screen
--------V-2D--10-----------------------------
INT 2D U - Screen Thief v1.00 - FREE HIGH MEMORY BUFFERS
	AL = 10h
	AH = AMIS multiplex number for Screen Thief
Return: nothing
Program: Screen Thief is a graphics screen grabber
Note:	releases any code and data stored in EMS, DOS UMBs, or XMS UMBs, but
	  does not release the low-memory stub; this may be used to effect a
	  partial uninstall if INT 2D/AL=02h fails
SeeAlso: INT D8"Screen Thief"
--------i-2D--10-----------------------------
INT 2D U - RAMLIGHT v1.0 - GET MONITORING INFORMATION
	AL = 10h
	AH = AMIS multiplex number for RAMLIGHT
Return: ES:BX -> array of fake device driver headers used in monitoring
	CX = number of drives being monitored???
--------d-2D--11-----------------------------
INT 2D - dLite 1.0+ - CHECK FOR dPressed FILE AND GET ORIGINAL SIZE
	AL = 11h
	AH = AMIS multiplex number for dLite
	BX = file handle
Return: CF clear if successful
	    DX:AX = size of uncompressed file
	CF set on error (not dPressed file)
SeeAlso: AL=10h"dLite",AL=12h"dLite"
--------d-2D--12-----------------------------
INT 2D - dLite 1.0+ - CHECK FOR dPressed FILE AND GET COMPRESSED SIZE
	AL = 12h
	AH = AMIS multiplex number for dLite
	BX = file handle
Return: CF clear if successful
	    DX:AX = size of compressed file
	CF set on error (not dPressed file)
SeeAlso: AL=10h"dLite",AL=11h"dLite"
--------b-2D--DC-----------------------------
INT 2D C - DAISY.SYS - BROADCAST: CHAIN RESCANNED
	AL = DCh
	AH = AMIS multiplex number for signature 'DAISYCHA' 'INDRIVER'
	DL = LPT Port Rescanned
Program: DAISY.SYS is a daisy chain manager for parallel port peripherals
	  conforming to the Advanced Parallel Port Committee's daisy chain
	  specification.
Desc:	This Broadcast is sent whenever daisy chain IDs are reassigned to
	  warn parallel port device drivers that their daisy chain ID may
	  have been changed.
Note:	This function is a callout from DAISY.SYS, NOT a call into DAISY.SYS
SeeAlso: INT 17/AX=0200h"Advanced Parallel Port"
--------l-2E---------------------------------
INT 2E U - DOS 2+ - PASS COMMAND TO COMMAND INTERPRETER FOR EXECUTION
	DS:SI -> commandline to execute (see #1254)
Return: all registers except CS:IP destroyed
	AX = status (4DOS v4.0)
	   0000h successful
	   FFFFh error before processing command (not enough memory, etc)
	   other error number returned by command
Notes:	this call allows execution of arbitrary commands (including COMMAND.COM
	  internal commands) without loading another copy of COMMAND.COM
	if COMMAND.COM is the user's command interpreter, the primary copy
	  executes the command; this allows the master environment to be
	  modified by issuing a "SET" command, but changes in the master
	  environment will not become effective until all programs descended
	  from the primary COMMAND.COM terminate
	since COMMAND.COM processes the string as if typed from the keyboard,
	  the transient portion needs to be present, and the calling program
	  must ensure that sufficient memory to load the transient portion can
	  be allocated by DOS if necessary
	results are unpredictable if invoked by a program run from a batch file
	  because this call is not reentrant and COMMAND.COM uses the same
	  internal variables when processing a batch file
	hooked but ignored by 4DOS v3.0 COMMAND.COM replacement unless SHELL2E
	  has been loaded
	the MS-DOS 5 Programmer's Reference calls this "Reload Transient"

Format of DOS commandline:
Offset	Size	Description	(Table 1254)
 00h	BYTE	length of command string, not counting trailing CR
 01h	var	command string
  N	BYTE	0Dh (CR)
--------O-2E---------------------------------
INT 2E UP - Windows NT - NATIVE API
	EAX = function number
	EDX = address of parameter block
Return: ???
--------l-2E----BXE22E-----------------------
INT 2E - 4DOS v2.x-3.03 SHELL2E.COM - UNINSTALL
	BX = E22Eh
	DS:SI -> zero byte
Return: if successful, SHELL2E terminates itself with INT 21/AH=4Ch
----------2F---------------------------------
INT 2F - Multiplex - NOTES
	AH = identifier of program which is to handle the interrupt
	   00h-7Fh reserved for DOS
	   B8h-BFh reserved for networks
	   C0h-FFh reserved for applications
	AL is the function code
   This is a general mechanism for verifying the presence of a TSR and
   communicating with it.  When searching for a free identifier code for AH
   using the installation check (AL=00h), the calling program should set
   BX/CX/DX to 0000h and must not depend on any registers other than CS:IP
   and SS:SP to be valid on return, since numerous programs now use additional
   registers on input and/or output for the installation check.
Notes:	Since the multiplex chain is growing so long, and beginning to
	  experience multiplex number collisions, I am proposing an alternate
	  multiplex interrupt on INT 2D.  If you decide to use the alternate
	  multiplex, please let me know.
	DOS and some other programs return values in the flags register, so
	  any TSR which chains by calling the previous handler rather than
	  jumping to it should ensure that the returned flags are preserved
	  and passed back to the original caller
SeeAlso: INT 2D
--------t-2F---------------------------------
INT 2F - BMB Compuscience Canada Utilities Interface - INSTALLATION CHECK
	AH = xx (dynamically assigned based upon a search for a multiplex
		 number which doesn't answer installed)
	AL = 00h installation check
	ES:DI = EBEBh:BEBEh
Return: AL = 00h not installed
	     01h not installed, not OK to install
	     FFh installed; if ES:DI was EBEBh:BEBEh on entry, ES:DI will point
		 to a string of the form 'MMMMPPPPPPPPvNNNN' where MMMM is a
		 short form of the manufacturer's name, PPPPPPPP is a product
		 name and NNNN is the product's version number
--------t-2F---------------------------------
INT 2F - Ross Wentworth's Turbo Pascal POPUP LIBRARY
	AH = programmer-selected multiplex number
	AL = function
	    00h installation check
		Return: AL = FFh if installed
	    01h get TSR interrupt vectors
		Return: DX:AX -> vector table (see #1255)
	    02h get TSR code segment
		Return: AX = code segment for all interrupt handlers
	    03h call user exit routine and release TSR's memory
	    04h get signature string
		Return: DX:AX -> counted string containing signature
	    05h get TSR's INT 2F handler
		Return: DX:AX -> INT 2F handler
	    06h enable/disable TSR
		BL = new state (00h disabled, 01h enabled)
	    07h activate TSR (popup if not disabled)
	    08h get hotkeys
		BL = which hotkey (00h = hotkey 1, 01h = hotkey 2)
		Return: AX = hotkey (AH = keyflags, AL = scancode)
	    09h set hotkey
		BL = which hotkey (00h = hotkey 1, 01h = hotkey 2)
		CX = new hotkey (CH = keyflags, CL = scancode)
	    0Ah-1Fh reserved
Index:	installation check;Ross Wentworth POPUP library
Index:	hotkeys;Ross Wentworth POPUP library

Format of POPUP vector table entry:
Offset	Size	Description	(Table 1255)
 00h	BYTE	vector number (00h = end of table)
 01h	DWORD	original vector
 05h	WORD	offset of interrupt handler in TSR's code segment
--------t-2F---------------------------------
INT 2F - CiriSOFT Spanish University of Valladolid TSR's Interface
	AH = xx (dynamically assigned based upon a search for a multiplex
		 number from C0h to FFh which doesn't answer installed)
	AL = 00h installation check
	ES:DI = 1492h:1992h
Return: AL = 00h not installed
	     01h not installed, not OK to install
	     FFh installed; and if ES:DI was 1492h:1992h on entry, ES:DI will
		 point to author_name_ver table (see #1256)
	AH = FFh
Note:	this interface permits advanced communication with TSRs: it is possible
	  to make a generic uninstall utility, advanced TSR relocator programs
	  in order to fit fragmented memory areas, etc.
See also: INT 2D"AMIS",INT 2F"Compuscience"
Index:	installation check;CiriSOFT TSR interface
Index:	uninstall;CiriSOFT TSR interface

Format of CiriSOFT author_name_ver table:
Offset	Size	Description	(Table 1256)
 -16	WORD	segment of the start of the resident TSR code (CS in programs
		  with PSP, XMS upper memory segment if installed as UMB...)
 -14	WORD	offset of the start of the resident TSR code (frequently 100h
		  in *.COM programs and 0 in upper memory TSR's).
 -12	WORD	memory used by TSR (in paragraphs). Knowing the memory area
		  used by TSR is possible to determine if hooked vectors are
		  still pointing it (and if it is safe to uninstall).
 -10	BYTE	characteristics byte (see #1257)
 -9	BYTE	number of multiplex entry used (redefinition available). Note
		  that the TSR must use THIS variable in it's INT 2Fh handler.
 -8	WORD	offset to vector_area table (see #1258)
 -6	WORD	offset to extra_area table (see bit 7 in offset -10 and below)
 -4   4 BYTEs	signature string "*##*"
 00h	var	"AUTHOR:PROGRAM_NAME:VERSION",0	 (variable length, this area
		  is used in order to determine if the TSR is already resident
		  and it's version code; the ':' char is used as delimiter)

Bitfields for CiriSOFT characteristics byte:
Bit(s)	Description	(Table 1257)
 0-2	type
	000 normal program (with PSP)
	001 upper XMS memory block (needed HIMEM.SYS function to free memory
	      when uninstalling)
	010 device driver (*.SYS)
	011 device driver in EXE format
	1xx others (reserved)
 3-6	reserved
 7	set if extra_table defined and supported

Format of CiriSOFT vector_area table:
Offset	Size	Description	(Table 1258)
 -1	BYTE	number of vectors intercepted by TSR
 00h	BYTE	first vector number
 01h	DWORD	first vector pointer before installing the TSR
 05h	BYTE	second vector number
 06h	DWORD	second vector pointer before installing the TSR
 0Ah	...	(and so on)
Note:	the TSR must use these variables to invoke the previous interrupt
	  handler routines

Format of extra_area table (needed only to improve relocation feature):
Offset	Size	Description	(Table 1259)
 00h	WORD	offset to external_ctrl table (0 if not supported)
 02h	WORD	reserved for future use (0)

Format of CiriSOFT external_ctrl table:
Offset	Size	Description	(Table 1260)
 00h	BYTE	bit 0: TSR is relocatable (no absolute segment references)
 01h	WORD	offset to a variable which can activate/inhibit the TSR
 ---And if bit 0 in offset 00h is off:
 03h	DWORD	pointer to ASCIZ pathname for executable file which supports
		  /SR parameter (silent installation & inhibit)
 07h	DWORD	pointer to first variable to initialize on the copy reloaded
		  from the previous TSR still resident
 0Bh	DWORD	pointer to last variable (all variables packed in one block)
--------c-2F00-------------------------------
INT 2F U - DOS 2.x only PRINT.COM - ???
	AH = 00h
	???
Return: ???
Notes:	DOS 2.x PRINT.COM does not chain to previous INT 2F handler
	values in AH other than 00h or 01h cause PRINT to return the number of
	  files in the queue in AH
SeeAlso: AH=01h
--------P-2F00-------------------------------
INT 2F U - PSPRINT - PRINT JOB CONTROL
	AH = 00h
	???
Return: ???
--------c-2F0080-----------------------------
INT 2F - DOS 3.1+ PRINT - GIVE PRINT A TIME SLICE
	AX = 0080h
Return: after PRINT executes
Notes:	PRINT returns AL=01h if AH=00h but AL is not 80h on entry
	this function is not supported by the Novell DOS 7 PRINT.COM
--------N-2F00D8-----------------------------
INT 2F - Personal NetWare - VLM - ???
	AX = 00D8h
	???
Return: ???
Note:	hooked by one of the .VLMs loaded by VLM.EXE v1.10, but apparently a
	  NOP
--------c-2F01-------------------------------
INT 2F U - DOS 2.x only PRINT.COM - ???
	AH = 01h
	???
Return: ???
Notes:	DOS 2.x PRINT.COM does not chain to previous INT 2F handler
	values in AH other than 00h or 01h cause PRINT to return the number of
	  files in the queue in AH
SeeAlso: AH=00h
--------c-2F0100-----------------------------
INT 2F - DOS 3+ PRINT - INSTALLATION CHECK
	AX = 0100h
Return: AL = status
	    00h not installed
	    01h not installed, but not OK to install
	    FFh installed
		AH = 00h (Novell DOS 7)
SeeAlso: AX=0101h
--------c-2F0100SI20D6-----------------------
INT 2F U - PrintCache 3.1 PRINT.COM - INSTALLATION CHECK
	AX = 0100h
	SI = 20D6h
	DI = 8761h
Return: AX = 00FFh if installed
	DI = 0001h if PrintCache's PRINT.COM installed and magic values match
	    SI = resident code segment
Program: PrintCache PRINT.COM is a DOS PRINT replacement included in
	  LaserTools' PrintCache memory/disk-based print spooler package
Note:	if either of SI or DI differ from the indicated magic values, only AX
	  will be modified on return, for compatibility with DOS PRINT
SeeAlso: AX=0101h/SI=20D6h,AX=C000h"PCACHE"
--------c-2F0101-----------------------------
INT 2F - DOS 3+ PRINT - SUBMIT FILE FOR PRINTING
	AX = 0101h
	DS:DX -> submit packet (see #1261)
Return: CF clear if successful
	    AL = status
		01h added to queue
		9Eh now printing
	CF set on error
	    AX = error code (see #1262,#0789 at INT 21/AH=59h)
SeeAlso: AX=0102h

Format of PRINT submit packet:
Offset	Size	Description	(Table 1261)
 00h	BYTE	level (must be 00h)
 01h	DWORD	pointer to ASCIZ filename (no wildcards)

(Table 1262)
Values for PRINT error code:
 0001h	invalid function
 0002h	file not found
 0003h	path not found
 0004h	out of file handles
 0005h	access denied
 0008h	print queue full
 0009h	spooler busy
 000Ch	name too long
 000Fh	invalid drive
--------c-2F0101SI20D6-----------------------
INT 2F U - PrintCache v3.1 PRINT.COM - SUBMIT FILE FOR PRINTING
	AX = 0101h
	SI = 20D6h
	DI = 8761h
	DS:DX -> submit packet (see #1261)
	CL = print options
	    bit 4: use default options
Return: CF clear if successful
	    AL = status
		01h added to queue
		9Eh now printing
	CF set on error
	    AX = error code (see #1262)
Program: PrintCache PRINT.COM is a DOS PRINT replacement included in
	  LaserTools' PrintCache memory/disk-based print spooler package
Note:	if either SI or DI differs from the indicated magic values on entry,
	  PrintCache will use the default print options for the file for
	  compatibility with DOS PRINT
SeeAlso: AX=0100h/SI=20D6h,AX=0101h,AX=0107h"PrintCache"
--------c-2F0102-----------------------------
INT 2F - DOS 3+ PRINT - REMOVE FILE FROM PRINT QUEUE
	AX = 0102h
	DS:DX -> ASCIZ filename (wildcards allowed)
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1262)
SeeAlso: AX=0101h,AX=0103h
--------c-2F0103-----------------------------
INT 2F - DOS 3+ PRINT - CANCEL ALL FILES IN PRINT QUEUE
	AX = 0103h
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1262)
SeeAlso: AX=0102h
--------c-2F0104-----------------------------
INT 2F - DOS 3+ PRINT - FREEZE PRINT QUEUE TO READ JOB STATUS
	AX = 0104h
Return: CF clear if successful
	    DX = error count since status last read
	    DS:SI -> print queue
	CF set on error
	    AX = error code (see #1262)
Desc:	get the list of print jobs, temporarily suspending PRINT's activities
	  to avoid changing the list while it is being examined
Notes:	the print queue is an array of 64-byte ASCIZ filenames terminated by
	  an empty filename; the first name is the file currently being printed
	printing is stopped until AX=0105h is called to prevent the queue
	  from changing while the filenames are being read
SeeAlso: AX=0101h,AX=0105h
--------c-2F0105-----------------------------
INT 2F - DOS 3+ PRINT - RESTART PRINT QUEUE AFTER STATUS READ
	AX = 0105h
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1262)
Desc:	restart PRINT's activities once an application finishes examining the
	  print queue
SeeAlso: AX=0104h
--------c-2F0106-----------------------------
INT 2F - DOS 3.3+ PRINT - GET PRINTER DEVICE
	AX = 0106h
Return: CF set if files in print queue
	    AX = error code 0008h (queue full)
	    DS:SI -> device driver header
	CF clear if print queue empty
	    AX = 0000h
Desc:	determine which device, if any, PRINT is currently using for output
Notes:	undocumented prior to the release of MS-DOS 5.0
	this function can be used to allow a program to avoid printing to the
	  printer on which PRINT is currently performing output
SeeAlso: AX=0104h
--------c-2F0107-----------------------------
INT 2F U - PrintCache v3.1 PRINT.COM - SET TRAILING FORM FEEDS
	AX = 0107h
	CL bit 0: output form feed between print jobs
Return: AL destroyed
SeeAlso: AX=0100h/SI=20D6h,AX=0101h/SI=20D6h
--------N-2F0200-----------------------------
INT 2F U - PC LAN PROGRAM REDIR/REDIRIFS internal - INSTALLATION CHECK
	AX = 0200h
Return: AL = FFh if installed
Desc:	determine whether the PC LAN Program redirector is installed
SeeAlso: AX=0201h,AX=0203h
--------N-2F0201-----------------------------
INT 2F U - PC LAN PROGRAM REDIR/REDIRIFS internal - ???
	AX = 0201h
Return: nothing???
Notes:	this function is called by the DOS 3.3+ PRINT.COM
	AX=0202h appears to be the opposite function
	these functions are supposedly used to signal opening and closing of
	  printers
SeeAlso: AX=0202h
--------N-2F0202-----------------------------
INT 2F U - PC LAN PROGRAM REDIR/REDIRIFS internal - ???
	AX = 0202h
	???
Return: nothing???
Notes:	this function is called by the DOS 3.3+ PRINT.COM
	these functions are supposedly used to signal opening and closing of
	  printers
SeeAlso: AX=0201h
--------N-2F0203-----------------------------
INT 2F U - PC LAN PROGRAM REDIR/REDIRIFS internal - ???
	AX = 0203h
Return: nothing???
Notes:	this function is called by the DOS 3.3+ PRINT.COM
	AX=0204h appears to be the opposite function
	these functions are supposedly used to signal opening and closing of
	  printers
SeeAlso: AX=0200h,AX=0204h
--------N-2F0204-----------------------------
INT 2F U - PC LAN PROGRAM REDIR/REDIRIFS internal - ???
	AX = 0204h
	???
Return: nothing???
Notes:	this function is called by the DOS 3.3+ PRINT.COM
	AX=0203h appears to be the opposite function
	these functions are supposedly used to signal opening and closing of
	  printers
SeeAlso: AX=0200h,AX=0203h
--------N-2F---------------------------------
INT 2F U - PC LAN PROGRAM REDIR/REDIRIFS internal - ???
	AX = 02xxh
	???
Return: ???
--------l-2F0500-----------------------------
INT 2F U - DOS 3+ CRITICAL ERROR HANDLER - INSTALLATION CHECK
	AX = 0500h
Return: AL = 00h not installed, OK to install
	     01h not installed, can't install
	     FFh installed
Desc:	determine whether a critical error message override is installed
Note:	this set of functions allows a user program to partially or completely
	  override the default critical error handler's message in COMMAND.COM
SeeAlso: AH=05h,INT 24
--------l-2F05-------------------------------
INT 2F CU - DOS 3+ CRITICAL ERROR HANDLER - EXPAND ERROR INTO STRING
	AH = 05h
---DOS 3.x---
	AL = extended error code (not zero)
---DOS 4+ ---
	AL = error type
	    01h DOS extended error code
	    02h parameter error
	BX = error code
Return: CF clear if successful
	    ES:DI -> ASCIZ error message (read-only)
	    AL = completion state
		00h message requires completion with device name, drive, etc.
		01h message is complete as returned
	CF set if error code can't be converted to string
	    AX,DI,ES destroyed
	other flags corrupted
Notes:	called at start of COMMAND.COM's default critical error handler if
	  installed by a user program, allowing partial or complete overriding
	  of the default error messages
	subfunction 02h is called by many DOS 4 external programs
	DR-DOS's COMMAND.COM appends additional info ("0 files copied") to the
	  returned string
SeeAlso: AX=0500h,AX=122Eh,INT 24
--------U-2F0600-----------------------------
INT 2F - DOS 3+ ASSIGN - INSTALLATION CHECK
	AX = 0600h
Return: AL = status
	    00h not installed
	    01h not installed, but not OK to install
	    FFh installed
Notes:	ASSIGN is not a TSR in DR-DOS 5.0; it is internally replaced by SUBST
	  (see INT 21/AH=52h)
	undocumented prior to the release of DOS 5.0
SeeAlso: AX=0601h,INT 21/AH=52h
--------U-2F0601-----------------------------
INT 2F U - DOS 3+ ASSIGN - GET DRIVE ASSIGNMENT TABLE
	AX = 0601h
Return: ES = segment of ASSIGN work area and assignment table
Note:	under DOS 3+, the 26 bytes starting at ES:0103h specify which drive
	  each of A: to Z: is mapped to.  Initially set to 01h 02h 03h....
SeeAlso: AX=0600h
--------D-2F0800-----------------------------
INT 2F U - DRIVER.SYS support - INSTALLATION CHECK
	AX = 0800h
Return: AL = status
	    00h not installed, OK to install
	    01h not installed, not OK to install
	    FFh installed
Desc:	determine whether the internal support code used by DRIVER.SYS is
	  present; it is always present in DOS 3.2+
Note:	supported by DR-DOS 5.0
--------D-2F0801-----------------------------
INT 2F U - DRIVER.SYS support - ADD NEW BLOCK DEVICE
	AX = 0801h
	DS:DI -> drive data table (see #1269,#1270,#1271)
Return: AX,BX,SI,ES destroyed
Notes:	moves down internal list of drive data tables, copying and modifying
	  the drive description flags word for tables referencing same physical
	  drive
	the data table is appended to the chain of tables
	supported by DR-DOS 5.0
SeeAlso: AX=0803h
--------D-2F0802-----------------------------
INT 2F U - DRIVER.SYS support - EXECUTE DEVICE DRIVER REQUEST
	AX = 0802h
	ES:BX -> device driver request header (see #1265)
Return: request header updated as per requested operation
Notes:	supported by DR-DOS 5.0
	DOS 3.2 executes this function on any AL value from 02h through F7h;
	  DOS 4+ executes this function on AL=02h and AL=04h-F7h
	the command codes and structures described below apply to all drivers
	  which support the appropriate commands; this call is just one of a
	  number of ways in which a device driver request may be invoked
SeeAlso: AX=0800h,AX=0801h,AX=0803h,INT 21/AH=52h,INT 21/AH=99h,INT 21/AH=9Ah

(Table 1263)
Values for device driver command code:
 00h	INIT
 01h	MEDIA CHECK (block devices)
 02h	BUILD BPB (block devices)
 03h	IOCTL INPUT
 04h	INPUT
 05h	NONDESTRUCTIVE INPUT, NO WAIT (character devices)
 06h	INPUT STATUS (character devices)
 07h	INPUT FLUSH (character devices)
 08h	OUTPUT
 09h	OUTPUT WITH VERIFY
 0Ah	OUTPUT STATUS (character devices)
 0Bh	OUTPUT FLUSH (character devices)
 0Ch	IOCTL OUTPUT
 0Dh	(DOS 3+) DEVICE OPEN
 0Eh	(DOS 3+) DEVICE CLOSE
 0Fh	(DOS 3+) REMOVABLE MEDIA (block devices)
 10h	(DOS 3+) OUTPUT UNTIL BUSY (character devices)
 11h	(European MS-DOS 4.0) STOP OUTPUT (console screen drivers only)
 12h	(European MS-DOS 4.0) RESTART OUTPUT (console screen drivers only)
 13h	(DOS 3.2+) GENERIC IOCTL
 14h	unused
 15h	(European MS-DOS 4.0) RESET UNCERTAIN MEDIA FLAG
 16h	unused
 17h	(DOS 3.2+) GET LOGICAL DEVICE
 18h	(DOS 3.2+) SET LOGICAL DEVICE
 19h	(DOS 5+) CHECK GENERIC IOCTL SUPPORT
 80h	(CD-ROM) READ LONG
 81h	(CD-ROM) reserved
 82h	(CD-ROM) READ LONG PREFETCH
 83h	(CD-ROM) SEEK
 84h	(CD-ROM) PLAY AUDIO
 85h	(CD-ROM) STOP AUDIO
 86h	(CD-ROM) WRITE LONG
 87h	(CD-ROM) WRITE LONG VERIFY
 88h	(CD-ROM) RESUME AUDIO

Bitfields for device request status:
Bit(s)	Description	(Table 1264)
 15	error
 14-11	reserved
 10	??? set by DOS kernel on entry to some driver calls
 9	busy
 8	done (may be clear on return under European MS-DOS 4.0)
 7-0	error code if bit 15 set (see #1266)

Format of device driver request header:
Offset	Size	Description	(Table 1265)
 00h	BYTE	length of request header
 01h	BYTE	subunit within device driver
 02h	BYTE	command code (see #1263)
 03h	WORD	status (filled in by device driver) (see #1264)
---DOS---
 05h  4 BYTEs	reserved (unused in DOS 2.x and 3.x)
 09h	DWORD	(European MS-DOS 4.0 only) pointer to next request header in
			  device's request queue
		(other versions) reserved (unused in DOS 2.x and 3.x)
---STARLITE architecture---
 05h	DWORD	pointer to next request header
 09h  4 BYTEs	reserved
---command code 00h---
 0Dh	BYTE	(return) number of units
 0Eh	DWORD	(call) pointer to DOS device helper function (see #1267)
			  (European MS-DOS 4.0 only)
		(call) pointer past end of memory available to driver (DOS 5+)
		(return) address of first free byte following driver
 12h	DWORD	(call) pointer to commandline arguments
		(return) pointer to BPB array (block drivers) or
			  0000h:0000h (character drivers)
 16h	BYTE	(DOS 3+) drive number for first unit of block driver (0=A)
   ---European MS-DOS 4.0---
 17h	DWORD	pointer to function to save registers on stack
   ---DOS 5+ ---
 17h	WORD	(return) error-message flag
		0001h MS-DOS should display error msg on init failure
---command code 01h---
 0Dh	BYTE	media descriptor
 0Eh	BYTE	(return) media status
		00h don't know
		01h media has not changed
		FFh media has been changed
 0Fh	DWORD	(return, DOS 3+) pointer to previous volume ID if OPEN/CLOSE/RM
		  bit in device header is set and disk changed
---command code 02h---
 0Dh	BYTE	media descriptor
 0Eh	DWORD	transfer address
		-> scratch sector if NON-IBM FORMAT bit in device header set
		-> first FAT sector otherwise
 12h	DWORD	pointer to BPB (set by driver) (see INT 21/AH=53h)
---command codes 03h,0Ch--- (see also INT 21/AX=4402h,INT 21/AX=4403h)
 0Dh	BYTE	media descriptor (block devices only)
 0Eh	DWORD	transfer address
 12h	WORD	(call) number of bytes to read/write
		(return) actual number of bytes read or written
---command codes 04h,08h,09h---
 0Dh	BYTE	media descriptor (block devices only)
 0Eh	DWORD	transfer address
 12h	WORD	byte count (character devices) or sector count (block devices)
 14h	WORD	starting sector number (block devices only)
 16h	DWORD	(DOS 3+) pointer to volume ID if error 0Fh returned
 1Ah	DWORD	(DOS 4+) 32-bit starting sector number (block devices with
		  device attribute word bit 1 set only) if starting sector
		  number above is FFFFh (see INT 21/AH=52h)
---command code 05h---
 0Dh	BYTE	byte read from device if BUSY bit clear on return
---command codes 06h,07h,0Ah,0Bh,0Dh,0Eh,0Fh---
 no further fields
---command code 10h---
 0Dh	BYTE	unused
 0Eh	DWORD	transfer address
 12h	WORD	(call) number of bytes to write
		(return) actual number of bytes written
---command codes 11h,12h---
 0Dh	BYTE	reserved
---command code 15h---
 no further fields
---command codes 13h,19h---
 0Dh	BYTE	category code
		00h unknown
		01h COMn:
		03h CON
		05h LPTn:
		07h mouse (European MS-DOS 4.0)
		08h disk
		9Eh (STARLITE) Media Access Control driver
 0Eh	BYTE	function code
		00h (STARLITE) MAC Bind request
 0Fh	WORD	copy of DS at time of IOCTL call (apparently unused in DOS 3.3)
		SI contents (European MS-DOS 4.0)
 11h	WORD	offset of device driver header
		DI contents (European MS-DOS 4.0)
 13h	DWORD	pointer to parameter block from INT 21/AX=440Ch or AX=440Dh
---command codes 80h,82h---
 0Dh	BYTE	addressing mode
		00h HSG (default)
		01h Phillips/Sony Red Book
 0Eh	DWORD	transfer address (ignored for command 82h)
 12h	WORD	number of sectors to read
		(if 0 for command 82h, request is an advisory seek)
 14h	DWORD	starting sector number
		logical sector number in HSG mode
		frame/second/minute/unused in Red Book mode
		(HSG sector = minute * 4500 + second * 75 + frame - 150)
 18h	BYTE	data read mode
		00h cooked (2048 bytes per frame)
		01h raw (2352 bytes per frame, including EDC/ECC)
 19h	BYTE	interleave size (number of sectors stored consecutively)
 1Ah	BYTE	interleave skip factor
		(number of sectors between consecutive portions)
---command code 83h---
 0Dh	BYTE	addressing mode (see above)
 0Eh	DWORD	transfer address (ignored)
 12h	WORD	number of sectors to read (ignored)
 14h	DWORD	starting sector number (see also above)
---command code 84h---
 0Dh	BYTE	addressing mode (see above)
 0Eh	DWORD	starting sector number (see also above)
 12h	DWORD	number of sectors to play
---command codes 85h,88h---
 no further fields
---command codes 86h,87h---
 0Dh	BYTE	addressing mode (see above)
 0Eh	DWORD	transfer address (ignored in write mode 0)
 12h	WORD	number of sectors to write
 14h	DWORD	starting sector number (see also above)
 18h	BYTE	write mode
		00h mode 0 (write all zeros)
		01h mode 1 (default) (2048 bytes per sector)
		02h mode 2 form 1 (2048 bytes per sector)
		03h mode 2 form 2 (2336 bytes per sector)
 19h	BYTE	interleave size (number of sectors stored consecutively)
 1Ah	BYTE	interleave skip factor
		(number of sectors between consecutive portions)

(Table 1266)
Values for device driver error code:
 00h	write-protect violation
 01h	unknown unit
 02h	drive not ready
 03h	unknown command
 04h	CRC error
 05h	bad drive request structure length
 06h	seek error
 07h	unknown media
 08h	sector not found
 09h	printer out of paper
 0Ah	write fault
 0Bh	read fault
 0Ch	general failure
 0Dh	reserved
 0Eh	(CD-ROM) media unavailable
 0Fh	invalid disk change

(Table 1267)
Call European MS-DOS 4.0 device helper function with:
	DL = function
	    00h "SchedClock" called on each timer tick
		AL = tick interval in milliseconds
	    01h "DevDone" device I/O complete
		ES:BX -> request header
		Note:	must update status word first; may be called from
			  an interrupt handler
	    02h "PullRequest" pull next request from queue
		DS:SI -> DWORD pointer to start of device's request queue
		Return: ZF clear if pending request
			    ES:BX -> request header
			ZF set if no more requests
	    03h "PullParticular" remove specific request from queue
		DS:SI -> DWORD pointer to start of device's request queue
		ES:BX -> request header
		Return: ZF set if request header not found
	    04h "PushRequest" push the request onto the queue
		DS:SI -> DWORD pointer to start of device's request queue
		ES:BX -> request header
		interrupts disabled
	    05h "ConsInputFilter" keyboard input check
		AX = character (high byte 00h if PC ASCII character)
		Return: ZF set if character should be discarded
			ZF clear if character should be handled normally
		Note:	called by keyboard interrupt handler so DOS can scan
			  for special input characters
	    06h "SortRequest" push request in sorted order by starting sector
		DS:SI -> DWORD pointer to start of device's request queue
		ES:BX -> request header
		interrupts disabled
	    07h "SigEvent" send signal on keyboard event
		AH = event identifier
		Return: AL,FLAGS destroyed
	    09h "ProcBlock" block on event
		AX:BX = event identifier (typically a pointer)
		CX = timeout in ms or 0000h for never
		DH = interruptable flag (nonzero if pause may be interrupted)
		interrupts disabled
		Return: after corresponding ProcRun call
			CF clear if event wakeup, set if unusual wakeup
			ZF set if timeout wakeup, clear if interrupted
			AL = wakeup code, nonzero if unusual wakeup
			interrupts enabled
			BX,CX,DX destroyed
		Note:	block process and schedules another to run
	    0Ah "ProcRun" unblock process
		AX:BX = event identifier (typically a pointer)
		Return: AX = number of processes awakened
			ZF set if no processes awakened
			BX,CX,DX destroyed
	    0Bh "QueueInit" initialize/clear character queue
		DS:BX -> character queue structure (see #1268)
		Note:	the queue size field must be set before calling
	    0Dh "QueueWrite" put a character in the queue
		DS:BX -> character queue (see #1268)
		AL = character to append to end of queue
		Return: ZF set if queue is full
			ZF clear if character stored
	    0Eh "QueueRead" get a character from the queue
		DS:BX -> character queue (see #1268)
		Return: ZF set if queue is empty
			ZF clear if characters in queue
			    AL = first character in queue
	    10h "GetDOSVar" return pointer to DOS variable
		AL = index of variable
		    03h current process ID
		BX = index into variable if AL specifies an array
		CX = expected length of variable
		Return: CF clear if successful
			    DX:AX -> variable
			CF set on error
			    AX,DX destroyed
			BX,CX destroyed
		Note:	the variables may not be modified
	    14h "Yield" yield CPU if higher-priority task ready to run
		Return: FLAGS destroyed
	    1Bh "CritEnter" begin system critical section
		DS:BX -> semaphore (6 BYTEs, initialized to zero)
		Return: AX,BX,CX,DX destroyed
	    1Ch "CritLeave" end system critical section
		DS:BX -> semaphore (6 BYTEs, initialized to zero)
		Return: AX,BX,CX,DX destroyed
		Note:	must be called in the context of the process which
			  called CritEnter on the semaphore
Note:	the DWORD pointing at the request queue must be allocated by the driver
	  and initialized to 0000h:0000h.  It always points at the next request
	  to be executed

Format of European MS-DOS 4.0 character queue:
Offset	Size	Description	(Table 1268)
 00h	WORD	size of queue in bytes
 02h	WORD	index of next character out
 04h	WORD	count of characters in the queue
 06h  N BYTEs	queue buffer
--------D-2F0803-----------------------------
INT 2F U - DOS 4+ DRIVER.SYS support - GET DRIVE DATA TABLE LIST
	AX = 0803h
Return: DS:DI -> first drive data table in list
Note:	not available under DR-DOS 5.0
SeeAlso: AX=0801h

Format of DOS 3.30 drive data table:
Offset	Size	Description	(Table 1269)
 00h	DWORD	pointer to next table (offset FFFFh if last table)
 04h	BYTE	physical unit number (for INT 13)
 05h	BYTE	logical drive number (0=A:)
 06h 19 BYTEs	BIOS Parameter Block (see also INT 21/AH=53h)
		Offset	Size	Description
		 00h	WORD	bytes per sector
		 02h	BYTE	sectors per cluster, FFh if unknown
		 03h	WORD	number of reserved sectors
		 05h	BYTE	number of FATs
		 06h	WORD	number of root dir entries
		 08h	WORD	total sectors
		 0Ah	BYTE	media descriptor, 00h if unknown
		 0Bh	WORD	sectors per FAT
		 0Dh	WORD	sectors per track
		 0Fh	WORD	number of heads
		 11h	WORD	number of hidden sectors
 19h	BYTE	flags
		bit 6: 16-bit FAT instead of 12-bit FAT
 1Ah	WORD	number of DEVICE OPEN calls without corresponding DEVICE CLOSE
 1Ch 11 BYTEs	volume label or "NO NAME    " if none (always "NO NAME" for
		  fixed media)
 27h	BYTE	terminating null for volume label???
 28h	BYTE	device type (see INT 21/AX=440Dh)
 29h	WORD	bit flags describing drive (see #1272)
 2Bh	WORD	number of cylinders
 2Dh 19 BYTEs	BIOS Parameter Block for highest capacity supported
 40h  3 BYTEs	???
 43h  9 BYTEs	filesystem type???, default = "NO NAME	"
		(apparently only MS-DOS 3.30 fixed media, nulls for removable
		  media and PC-DOS 3.30)
 4Ch	BYTE	least-significant byte of last-accessed cylinder number
---removable media---
 4Dh	DWORD	time of last access in clock ticks (FFFFFFFFh if never)
---fixed media---
 4Dh	WORD	partition (FFFFh = primary, 0001h = extended)
 4Fh	WORD	absolute cylinder number of partition's start on physical
		  drive (always FFFFh if primary partition)

Format of COMPAQ DOS 3.31 drive data table:
Offset	Size	Description	(Table 1270)
 00h	DWORD	pointer to next table (offset FFFFh if last table)
 04h	BYTE	physical unit number (for INT 13)
 05h	BYTE	logical drive number (0=A:)
 06h 25 BYTEs	BIOS Parameter Block (see DOS 4.0-6.0 drive data table below)
 1Fh  6 BYTEs	reserved fields from BPB above???
 25h	BYTE	flags
		bit 6: 16-bit FAT instead of 12-bit FAT
		bit 5: large volume???
 26h	WORD	device-open count???
 28h 11 BYTEs	volume label or "NO NAME    " if none (always "NO NAME" for
		  fixed media)
 33h	BYTE	terminating null for volume label
 34h	BYTE	device type (see INT 21/AX=440Dh)
 35h	WORD	bit flags describing drive (see #1272)
 37h	WORD	number of cylinders
 39h 25 BYTEs	BIOS parameter block for highest capacity drive supports
 52h  6 BYTEs	??? apparently always zeros
 58h	BYTE	least-significant byte of last-accessed cylinder number
---removable media---
 59h	DWORD	time of last access in clock ticks (FFFFFFFFh if never)
---fixed media---
 59h	WORD	partition (FFFFh = primary, 0001h = extended)
 5Bh	WORD	absolute cylinder number of partition's start on physical
		  drive (always FFFFh if primary partition)

Format of DOS 4.0-6.0 drive data table:
Offset	Size	Description	(Table 1271)
 00h	DWORD	pointer to next table (offset FFFFh if last table)
 04h	BYTE	physical unit number (for INT 13)
 05h	BYTE	logical drive number (0=A:)
 06h 25 BYTEs	BIOS Parameter Block (see also INT 21/AH=53h)
		Offset	Size	Description
		 00h	WORD	bytes per sector
		 02h	BYTE	sectors per cluster, FFh if unknown
		 03h	WORD	number of reserved sectors
		 05h	BYTE	number of FATs
		 06h	WORD	number of root dir entries
		 08h	WORD	total sectors (see offset 15h if zero)
		 0Ah	BYTE	media descriptor, 00h if unknown
		 0Bh	WORD	sectors per FAT
		 0Dh	WORD	sectors per track
		 0Fh	WORD	number of heads
		 11h	DWORD	number of hidden sectors
		 15h	DWORD	total sectors if WORD at 08h is zero
 1Fh	BYTE	flags
		bit 6: 16-bit FAT instead of 12-bit
		bit 7: unsupportable disk (all accesses will return Not Ready)
 20h	WORD	device-open count
 22h	BYTE	device type (see INT 21/AX=440Dh)
 23h	WORD	bit flags describing drive (see #1272)
 25h	WORD	number of cylinders (for partition only, if hard disk)
 27h 25 BYTEs	BIOS Parameter Block for default (highest) capacity supported
 40h  6 BYTEs	reserved (part of BPB above)
 46h	BYTE	last track accessed
---removable media---
 47h	DWORD	time of last access in clock ticks (FFFFFFFFh if never)
---fixed media---
 47h	WORD	partition (FFFFh = primary, 0001h = extended)
		always 0001h for DOS 5+
 49h	WORD	absolute cylinder number of partition's start on physical drive
		(FFFFh if primary partition in DOS 4.x)
------
 4Bh 11 BYTEs	volume label or "NO NAME    " if none (apparently taken from
		  extended boot record rather than root directory)
 56h	BYTE	terminating null for volume label
 57h	DWORD	serial number
 5Bh  8 BYTEs	filesystem type ("FAT12	  " or "FAT16	")
 63h	BYTE	terminating null for filesystem type

Bitfields for flags describing drive:
Bit(s)	Description	(Table 1272)
 0	fixed media
 1	door lock ("changeline") supported
 2	current BPB locked
 3	all sectors in a track are the same size
 4	physical drive has multiple logical units
 5	current logical drive for shared physical drive
 6	disk change detected
 7	set DASD before formatting
 8	disk reformatted
 9	unformatted (fixed media only, disables reads and writes)
--------f-2F1000-----------------------------
INT 2F - SHARE - INSTALLATION CHECK
	AX = 1000h
Return: AL = status
	    00h not installed, OK to install
	    01h not installed, not OK to install
	    FFh installed
BUGS:	values of AL other than 00h put DOS 3.x SHARE into an infinite loop
	  (08E9: OR  AL,AL
	   08EB: JNZ 08EB) <- the buggy instruction (DOS 3.3)
	values of AL other than described here put PC-DOS 4.00 into the same
	  loop (the buggy instructions are the same)
Notes:	supported by OS/2 v1.3+ compatibility box, which always returns AL=FFh
	if DOS 4.01 SHARE was automatically loaded, file sharing is in an
	  inactive state (due to the undocumented /NC flag used by the autoload
	  code) until this call is made
	DOS 5+ chains to the previous handler if AL <> 00h on entry
	Windows Enhanced mode hooks this call and reports that SHARE is
	  installed even when it is not
SeeAlso: AX=1080h,INT 21/AH=52h
--------d-2F1001-----------------------------
INT 2F U - DR-DOS 6.0 SHARE internal - SET ???
	AX = 1001h
	DX:BX -> ???function
Notes:	this function is also supported by SuperStor, a disk-compression
	  program by Addstor which is bundled with DR-DOS 6.0, and the
	  Novell DOS 7 DELWATCH.EXE
	the default handler for the pointer set by this call under DELWATCH
	  simply returns with CF set
SeeAlso: AX=1000h,X=F800h
--------f-2F1040-----------------------------
INT 2F U - DOS 4 only SHARE internal - ???
	AX = 1040h
	???
Return: AL = FFh???
SeeAlso: AX=1000h
--------f-2F1080-----------------------------
INT 2F U - DOS 4 only SHARE internal - TURN ON FILE SHARING CHECKS
	AX = 1080h
Return: AL = status
	    F0h successful
	    FFh checking was already on
Note:	DOS 4.x SHARE has dual functions: FCB support for large (>32M) media
	  and file sharing checks.  The undocumented commandline flag /NC can
	  be used to disable the sharing code.
SeeAlso: AX=1000h,AX=1081h
--------f-2F1081-----------------------------
INT 2F U - DOS 4 only SHARE internal - TURN OFF FILE SHARING CHECKS
	AX = 1081h
Return: AL = status
	    F0h successful
	    FFh checking was already off
Note:	(see AX=1080h)
SeeAlso: AX=1000h,AX=1080h
----------2F10FE-----------------------------
INT 2F U - Novell DOS 7 DELWATCH.EXE - INSTALLATION CHECK
	AX = 10FEh
Return: AX = 20FFh if installed and active
	    DX:BX -> private entry point

(Table 1273)
Call DELWATCH private entry point with:
	AH = function
	    00h NOP???
		Return: AX = 0000h
			CX = 0004h (unsupported function)
	    01h disable DELWATCH on drive
		AL = drive number (00h = A:)
		Return: AX = status (0000h if failed, FFFFh if successful)
	    02h ???
		AL = drive number (00h = A:)
		???
		Return: ???
	    03h	???
		AL = drive number (00h = A:)
		CX = ??? (0000h/0001h)
		???
		Return: ???
	    04h ???
		AL = drive number (00h = A:)
		???
		Return: ???
	    05h ???
		AL = drive number (00h = A:)
		???
		Return: ???
	    06h enable DELWATCH on drive
		AL = drive number with bit 7 set (80h = A:, etc.)
		BX = maximum files of same name in one directory to save
		CX = maximum files to save on this disk
		???
		Return: AX = status
			    0000h failed
			    FFFFh successful
			CX = error code on failure
			    (0004h if AL < 80h on entry)
	    07h ???
	    08h set file extensions list
		AL = sense (00h exclude named extensions, 01h only named ext.)
		DS:BX -> 31-byte ASCIZ extension list (three blank-padded bytes
			  per extension)
		Return: AX = FFFFh (successful)
	    09h	???
		AL = drive number (00h = A:)
		???
		Return: ???
	    0Ah ???
		AL = drive number (00h = A:)
		???
		Return: ???
	    0Bh reset ???
		Return: AX = FFFFh (successful)
		see also function 0Dh
	    0Ch check if drive enabled
		AL = drive number with bit 7 set (80h = A:, etc.)
		Return: AX = state
			    0000h disabled or error (check CX)
			    0001h drive enabled
			CX = error code (0004h invalid drive number)
	    0Dh set ???
		BX = ???
		Return: AX = FFFFh (successful)
		see also function 0Bh
	    0Eh ???
		AL = drive number (00h = A:)
		???
		Return: ???
Return: AX = 0000h, CX = 0001h if DELWATCH busy
	registers unchanged if AH >= 0Fh on entry
--------O-2F10FF-----------------------------
INT 2F U - Multiplex - DR-DOS 5.0 - ???
	AX = 10FFh
	ES:BX -> ???
Note:	sets pointer in kernel
--------N-2F1100-----------------------------
INT 2F C - NETWORK REDIRECTOR - INSTALLATION CHECK
	AX = 1100h
Return: AL = status
	    00h not installed, OK to install
	    01h not installed, not OK to install
	    FFh installed
		AH = product identifier (ad hoc by various manufacturers)
		    00h if PC Tools v8 DRIVEMAP
		    42h ('B') for Beame&Whiteside BWNFS v3.0a
		    6Eh ('n') for NetWare Lite v1.1 CLIENT
Notes:	this function is called by the DOS 3.1+ kernel
	in DOS 4.x only, the 11xx calls are all in IFSFUNC.EXE, not in the
	  PC LAN Program redirector; DOS 5+ moves the calls back into the
	  redirector
	the PC Network 1.00 redirector (renamed to PC LAN Program in 1.1-1.3)
	  only supports AL=00h-27h
--------d-2F1100SFDADA-----------------------
INT 2F - MSCDEX (MS CD-ROM Extensions) - INSTALLATION CHECK
	AX = 1100h subfn DADAh
	STACK: WORD DADAh
Return: AL = status
	    00h not installed, OK to install
		STACK unchanged
	    01h not installed, not OK to install
		STACK unchanged
	    FFh installed
		STACK: WORD	ADADh if MSCDEX installed
				DADBh if Lotus CD/Networker installed
Note:	although MSCDEX sets the stack word to ADADh on return, any value other
	  than DADAh is considered to mean that MSCDEX is already installed;
	  Lotus CD/Networker v4+ uses this feature to fool MSCDEX into
	  thinking it is already installed when it is in fact CD/Networker
	  that is installed
Index:	installation check;Lotus CD/Networker
Index:	Lotus CD/Networker;installation check
--------N-2F1101-----------------------------
INT 2F CU - NETWORK REDIRECTOR - REMOVE REMOTE DIRECTORY
	AX = 1101h
	SS = DOS DS
	SDA first filename pointer -> fully-qualified directory name
	SDA CDS pointer -> current directory structure for drive with dir
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1103h,AX=1105h,INT 21/AH=3Ah,INT 21/AH=60h
--------N-2F1102-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - REMOVE REMOTE DIRECTORY
	AX = 1102h
	SS = DOS DS
	SDA first filename pointer -> fully-qualified directory name
	SDA CDS pointer -> current directory structure for drive with dir
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
Note:	appears to be identical to AX=1101h; MS internal documentation calls
	  this function "SEQ_RMDIR"
SeeAlso: AX=1101h
--------N-2F1103-----------------------------
INT 2F CU - NETWORK REDIRECTOR - MAKE REMOTE DIRECTORY
	AX = 1103h
	SS = DOS DS
	SDA first filename pointer -> fully-qualified directory name
	SDA CDS pointer -> current directory structure for drive with dir
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1101h,AX=1105h,INT 21/AH=39h,INT 21/AH=60h
--------N-2F1104-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - MAKE REMOTE DIRECTORY
	AX = 1104h
	SS = DOS DS
	SDA first filename pointer -> fully-qualified directory name
	SDA CDS pointer -> current directory structure for drive with dir
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
Note:	appears to be identical to AX=1103h
SeeAlso: AX=1103h
--------N-2F1105-----------------------------
INT 2F CU - NETWORK REDIRECTOR - CHDIR
	AX = 1105h
	SS = DOS DS
	SDA first filename pointer -> fully-qualified directory name
	SDA CDS pointer -> current directory structure for drive with dir
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    CDS updated with new path
Notes:	this function is called by the DOS 3.1+ kernel
	directory string in CDS should not have a terminating backslash unless
	  the current directory is the root
SeeAlso: AX=1101h,AX=1103h,INT 21/AH=3Bh,INT 21/AH=60h
--------N-2F1106-----------------------------
INT 2F CU - NETWORK REDIRECTOR - CLOSE REMOTE FILE
	AX = 1106h
	BX = device info word from SFT
	ES:DI -> SFT
	    SFT DPB field -> DPB of drive containing file
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    SFT updated (redirector must decrement open count, which may be
		  done with INT 2F/AX=1208h)
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1116h,AX=1201h,AX=1208h,AX=1227h,INT 21/AH=3Eh
--------N-2F1107-----------------------------
INT 2F CU - NETWORK REDIRECTOR - COMMIT REMOTE FILE
	AX = 1107h
	ES:DI -> SFT
	    SFT DPB field -> DPB of drive containing file
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    all buffers for file flushed
	    directory entry updated
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: INT 21/AH=68h,INT 21/AX=5D01h
--------N-2F1108-----------------------------
INT 2F CU - NETWORK REDIRECTOR - READ FROM REMOTE FILE
	AX = 1108h
	ES:DI -> SFT
	    SFT DPB field -> DPB of drive containing file
	CX = number of bytes
	SS = DOS DS
	SDA DTA field -> user buffer
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    CX = number of bytes read (0000h = end of file)
	    SFT updated
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1109h,AX=1229h,INT 21/AH=3Fh,INT 21/AX=5D06h
--------N-2F1109-----------------------------
INT 2F CU - NETWORK REDIRECTOR - WRITE TO REMOTE FILE
	AX = 1109h
	ES:DI -> SFT
	    SFT DPB field -> DPB of drive containing file
	CX = number of bytes
	SS = DOS DS
	SDA DTA field -> user buffer
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    CX = number of bytes written
	    SFT updated
Notes:	this function is called by the DOS 3.1+ kernel
	PrintCache v3.1 PCACHE.EXE intercepts this function for SFTs where
	  the Device Driver Header field points at PCACHE, but does not
	  intercept any other network redirector functions
SeeAlso: AX=1107h,AX=1108h,INT 21/AH=40h,INT 21/AX=5D06h
--------N-2F110A-----------------------------
INT 2F CU - NETWORK REDIRECTOR (DOS 3.x only) - LOCK REGION OF FILE
	AX = 110Ah
	BX = file handle
	CX:DX = starting offset
	SI = high word of size
	STACK: WORD low word of size
	ES:DI -> SFT
	    SFT DPB field -> DPB of drive containing file
	SS = DOS DS
Return: CF set on error
	   AL = DOS error code (see #0789 at INT 21/AH=59h)
	STACK unchanged
Notes:	this function is called by the DOS 3.10-3.31 kernel
	the redirector is expected to resolve lock conflicts
SeeAlso: AX=110Bh,INT 21/AH=5Ch
--------N-2F110A-----------------------------
INT 2F CU - NETWORK REDIRECTOR (DOS 4+) - LOCK/UNLOCK REGION OF FILE
	AX = 110Ah
	BL = function
	    00h lock
	    01h unlock
	CX = number of lock/unlock parameters (0001h for DOS 4.0-6.1)
	DS:DX -> parameter block (see #1274)
	ES:DI -> SFT
	    SFT DPB field -> DPB of drive containing file
	SS = DOS DS
Return: CF set on error
	   AL = DOS error code (see #0789 at INT 21/AH=59h)
Notes:	this function is called by the DOS 4.0+ kernel
	the redirector is expected to resolve lock conflicts
SeeAlso: AX=110Bh,INT 21/AH=5Ch

Format of parameter block entry [array, but currently limited to single entry]:
Offset	Size	Description	(Table 1274)
 00h	DWORD	start offset
 04h	DWORD	size of region
--------N-2F110B-----------------------------
INT 2F CU - NETWORK REDIRECTOR (DOS 3.x only) - UNLOCK REGION OF FILE
	AX = 110Bh
	BX = file handle
	CX:DX = starting offset
	SI = high word of size
	STACK: WORD low word of size
	ES:DI -> SFT for file
	    SFT DPB field -> DPB of drive containing file
Return: CF set on error
	   AL = DOS error code (see #0789 at INT 21/AH=59h)
	STACK unchanged
Note:	this function is called by the DOS 3.1-3.31 kernel; DOS 4.0+ calls AX=110Ah instead
SeeAlso: AX=110Ah,INT 21/AH=5Ch
--------N-2F110C-----------------------------
INT 2F CU - NETWORK REDIRECTOR - GET DISK INFORMATION
	AX = 110Ch
	ES:DI -> current directory structure for desired drive
Return: CF clear if data valid
	    AL = sectors per cluster
	    AH = media ID byte
	    BX = total clusters
	    CX = bytes per sector
	    DX = number of available clusters
	CF set if data invalid
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: INT 21/AH=36h
--------N-2F110D-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - SET REMOTE FILE'S ATTRIBUTES
	AX = 110Dh
	SDA first filename pointer -> name of file
	???
Return: ???
Note:	similar to AX=110Eh
SeeAlso: AX=110Eh
--------N-2F110E-----------------------------
INT 2F CU - NETWORK REDIRECTOR - SET REMOTE FILE'S ATTRIBUTES
	AX = 110Eh
	SS = DOS DS
	SDA first filename pointer -> fully-qualified name of file
	SDA CDS pointer -> current directory structure for drive with file
	STACK: WORD new file attributes
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	STACK unchanged
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=110Dh,AX=110Fh,INT 21/AX=4301h,INT 21/AH=60h
--------N-2F110F-----------------------------
INT 2F CU - NETWORK REDIRECTOR - GET REMOTE FILE'S ATTRIBUTES AND SIZE
	AX = 110Fh
	SS = DOS DS
	SDA first filename pointer -> fully-qualified name of file
	SDA CDS pointer -> current directory structure for drive with file
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    AX = file attributes
	    BX:DI = file size
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=110Eh,INT 21/AX=4300h,INT 21/AH=60h
--------N-2F1110-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - GET REMOTE FILE'S ATTRIBUTES AND SIZE
	AX = 1110h
	SDA first filename pointer -> name of file
	???
Return: ???
Note:	appears to be similar to AX=110Fh
SeeAlso: AX=110Eh
--------N-2F1111-----------------------------
INT 2F CU - NETWORK REDIRECTOR - RENAME REMOTE FILE
	AX = 1111h
	SS = DS = DOS DS
	SDA first filename pointer = offset of fully-qualified old name
	SDA second filename pointer = offset of fully-qualified new name
	SDA CDS pointer -> current directory structure for drive with file
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1112h,INT 21/AH=56h,INT 21/AH=60h
--------N-2F1112-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - RENAME REMOTE FILE
	AX = 1112h
	SS = DS = DOS DS
	SDA first filename pointer -> name of file
	???
Return: ???
Note:	similar to AX=1111h
SeeAlso: AX=1111h
--------N-2F1113-----------------------------
INT 2F CU - NETWORK REDIRECTOR - DELETE REMOTE FILE
	AX = 1113h
	SS = DS = DOS DS
	SDA first filename pointer -> fully-qualified filename in DOS DS
	SDA CDS pointer -> current directory structure for drive with file
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
Notes:	this function is called by the DOS 3.1+ kernel
	the filespec may contain wildcards
SeeAlso: AX=1114h,INT 21/AH=41h,INT 21/AH=60h
--------N-2F1114-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - DELETE REMOTE FILE
	AX = 1114h
	SDA first filename pointer -> name of file
	???
Return: ???
Note:	similar to AX=1113h
SeeAlso: AX=1113h
--------N-2F1115-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - OPEN REMOTE FILE
	AX = 1115h
	SS = DOS DS
	ES:DI -> SFT ???
	???
Return: ???
Note:	similar to AX=1116h
SeeAlso: AX=1116h,AX=112Eh
--------N-2F1116-----------------------------
INT 2F CU - NETWORK REDIRECTOR - OPEN EXISTING REMOTE FILE
	AX = 1116h
	ES:DI -> uninitialized SFT
	SS = DOS DS
	SDA first filename pointer -> fully-qualified name of file to open
	STACK: WORD file access and sharing modes (see INT 21/AH=3Dh)
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    SFT filled (except handle count, which DOS manages itself)
	STACK unchanged
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1106h,AX=1115h,AX=1117h,AX=1118h,AX=112Eh,INT 21/AH=3Dh
SeeAlso: INT 21/AH=60h
--------N-2F1117-----------------------------
INT 2F CU - NETWORK REDIRECTOR - CREATE/TRUNCATE REMOTE FILE
	AX = 1117h
	ES:DI -> uninitialized SFT
	SS = DOS DS
	SDA first filename pointer -> fully-qualified name of file to open
	SDA CDS pointer -> current directory structure for drive with file
	STACK: WORD file creation mode
			low byte = file attributes (see INT 21/AH=3Ch)
			high byte = 00h normal create, 01h create new file
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    SFT filled (except handle count, which DOS manages itself)
	STACK unchanged
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1106h,AX=1116h,AX=1118h,AX=112Eh,INT 21/AH=3Ch,INT 21/AH=60h
--------N-2F1118-----------------------------
INT 2F CU - NETWORK REDIRECTOR - CREATE/TRUNCATE FILE WITHOUT CDS
	AX = 1118h
	ES:DI -> uninitialized SFT
	SS = DOS DS
	SDA first filename pointer -> fully-qualified name of file
	STACK: WORD file creation mode
			low byte = file attributes
			high byte = 00h normal create, 01h create new file
Return: ???
	STACK unchanged
Note:	this function is called by the DOS 3.1+ kernel when creating a file
	  on a drive for which the SDA CDS pointer has offset FFFFh
SeeAlso: AX=1106h,AX=1116h,AX=1117h,AX=112Eh,INT 21/AH=60h
--------N-2F1119-----------------------------
INT 2F CU - NETWORK REDIRECTOR - FIND FIRST FILE WITHOUT CDS
	AX = 1119h
	SS = DS = DOS DS
	[DTA] = uninitialized 21-byte findfirst search data (see INT 21/AH=4Eh)
	SDA first filename pointer -> fully-qualified search template
	SDA search attribute = attribute mask for search
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    [DTA] = updated findfirst search data
		    (bit 7 of first byte must be set)
	    [DTA+15h] = standard directory entry for file
Notes:	this function is called by the DOS 3.1+ kernel
	DOS 4.x IFSFUNC returns CF set, AX=0003h
SeeAlso: AX=111Ah,AX=111Bh
--------N-2F111A-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - FIND NEXT FILE WITHOUT CDS
	AX = 111Ah
	???
Return: CF set
	    AX = error code (03h for DOS 4.01 IFSFUNC)
Note:	use AX=111Ch for DOS 5+
SeeAlso: AX=1119h,AX=111Ch
--------N-2F111B-----------------------------
INT 2F CU - NETWORK REDIRECTOR - FINDFIRST
	AX = 111Bh
	SS = DS = DOS DS
	[DTA] = uninitialized 21-byte findfirst search data (see INT 21/AH=4Eh)
	SDA first filename pointer -> fully-qualified search template
	SDA CDS pointer -> current directory structure for drive with file
	SDA search attribute = attribute mask for search
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    [DTA] = updated findfirst search data
		    (bit 7 of first byte must be set)
	    [DTA+15h] = standard directory entry for file
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1119h,AX=111Ch,INT 21/AH=4Eh,INT 21/AH=60h
--------N-2F111C-----------------------------
INT 2F CU - NETWORK REDIRECTOR - FINDNEXT
	AX = 111Ch
	SS = DS = DOS DS
	ES:DI -> CDS
	[DTA] = 21-byte findfirst search data (see INT 21/AH=4Eh)
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    [DTA] = updated findfirst search data
		    (bit 7 of first byte must be set)
	    [DTA+15h] = standard directory entry for file
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1119h,AX=111Bh,INT 21/AH=4Fh
--------N-2F111D-----------------------------
INT 2F CU - NETWORK REDIRECTOR - CLOSE ALL REMOTE FILES FOR PROCESS (ABORT)
	AX = 111Dh
	SS = DOS DS
	SDA PSP segment field = PSP of terminating process
Return: nothing
Notes:	used when a process is aborted; the process being terminated is
	  indicated by the "sharing PSP" field in the SDA (offset 1Ah/1Ch)
	this function is called by the DOS 3.1+ kernel
	closes all FCBs opened by process
SeeAlso: INT 21/AX=5D04h
--------N-2F111E-----------------------------
INT 2F CU - NETWORK REDIRECTOR - DO REDIRECTION
	AX = 111Eh
	SS = DOS DS
	STACK: WORD function to execute
		5F00h  get redirection mode
			BL = type (03h printer, 04h disk)
			Return: BH = state (00h off, 01h on)
		5F01h  set redirection mode
			BL = type (03h printer, 04h disk)
			BH = state (00h off, 01h on)
		5F02h  get redirection list entry
			BX = redirection list index
			DS:SI -> 16-byte local device name buffer
			ES:DI -> 128-byte network name buffer
			Return: must set user's BX to device type and CX to
				stored parameter value, using AX=1218h to get
				stack frame address
		5F03h  redirect device
			BL = device type (see INT 21/AX=5F03h)
			CX = stored parameter value
			DS:SI -> ASCIZ source device name
			ES:DI -> destination ASCIZ network path + ASCIZ passwd
		5F04h  cancel redirection
			DS:SI -> ASCIZ device name or network path
		5F05h  get redirection list extended entry
			BX = redirection list index
			DS:SI -> buffer for ASCIZ source device name
			ES:DI -> buffer for destination ASCIZ network path
			Return: BH = status flag
				BL = type (03h printer, 04h disk)
				CX = stored parameter value
				BP = NETBIOS local session number
		5F06h  similar to 5F05h???
Return: CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
	STACK unchanged
Notes:	this function is called by the DOS 3.1+ kernel on INT 21/AH=5Fh
	  (including LAN Manager calls)
	the PC Network 1.00 redirector does not support function 5F06h
SeeAlso: INT 21/AX=5F00h,INT 21/AX=5F01h,INT 21/AX=5F02h,INT 21/AX=5F03h
SeeAlso: INT 21/AX=5F04h,INT 21/AX=5F05h,INT 21/AX=5F06h
--------N-2F111F-----------------------------
INT 2F CU - NETWORK REDIRECTOR - PRINTER SETUP
	AX = 111Fh
	STACK: WORD function
		5E02h  set printer setup
		5E03h  get printer setup
		5E04h  set printer mode
		5E05h  get printer mode
Return: CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
	STACK unchanged
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: INT 21/AX=5E02h,INT 21/AX=5E03h,INT 21/AX=5E04h,INT 21/AX=5E05h
--------N-2F1120-----------------------------
INT 2F CU - NETWORK REDIRECTOR - FLUSH ALL DISK BUFFERS
	AX = 1120h
	DS = DOS DS
	???
Return: CF clear (successful)
Notes:	this function is called by the DOS 3.1+ kernel
	uses CDS array pointer and LASTDRIVE= entries in DOS list of lists
SeeAlso: INT 21/AH=0Dh,INT 21/AX=5D01h
--------N-2F1121-----------------------------
INT 2F CU - NETWORK REDIRECTOR - SEEK FROM END OF REMOTE FILE
	AX = 1121h
	CX:DX = offset (in bytes) from end
	ES:DI -> SFT
	    SFT DPB field -> DPB of drive with file
	SS = DOS DS
Return: CF set on error
	    AL = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    DX:AX = new file position
Note:	this function is called by the DOS 3.1+ kernel, but only when seeking
	  from the end of a file opened with sharing modes set in such a
	  manner that another process is able to change the size of the file
	  while it is already open
SeeAlso: AX=1228h,INT 21/AH=42h
--------N-2F1122-----------------------------
INT 2F CU - NETWORK REDIRECTOR - PROCESS TERMINATION HOOK
	AX = 1122h
	SS = DOS DS
	DS = PSP of process about to terminate
Return: ???
Notes:	this function is called by the DOS 3.1+ kernel
	after calling this function, the kernel calls INT 2F/AX=111Dh
SeeAlso: AX=111Dh,INT 21/AH=4Ch,INT 60/DI=0601h
--------N-2F1123-----------------------------
INT 2F CU - NETWORK REDIRECTOR - QUALIFY REMOTE FILENAME
	AX = 1123h
	DS:SI -> ASCIZ filename to canonicalize
	ES:DI -> 128-byte buffer for qualified name
Return: CF set if not resolved
Notes:	called by MS-DOS 3.1+ kernel, but not called by DR-DOS 5.0 unless the
	  filename matches the name of a character device
	called first when DOS attempts to resolve a filename (unless inside an
	  AX=5D00h server call); if this fails, DOS resolves the name locally
SeeAlso: AX=1221h,INT 21/AH=60h
--------N-2F1124-----------------------------
INT 2F CU - NETWORK REDIRECTOR - TURN OFF REMOTE PRINTER
	AX = 1124h
	ES:DI -> SFT
	SS = DOS DS
	???
Return: CX = ???
Note:	this function is called by the DOS 3.1+ kernel if AX=1126h returns CF set
SeeAlso: AX=1126h
--------N-2F1125-----------------------------
INT 2F CU - NETWORK REDIRECTOR - REDIRECTED PRINTER MODE
	AX = 1125h
	STACK: WORD subfunction
		5D07h get print stream state
			Return: DL = current state
		5D08h set print stream state
			DL = new state
		5D09h finish print job
Return: CF set on error
	    AX = error code (see #0789 at INT 21/AH=59h)
	STACK unchanged
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: INT 21/AX=5D07h,INT 21/AX=5D08h,INT 21/AX=5D09h
--------N-2F1126-----------------------------
INT 2F CU - NETWORK REDIRECTOR - REMOTE PRINTER ECHO ON/OFF
	AX = 1126h
	ES:DI -> SFT for file handle 4???
	SS = DOS DS???
	???
Return: CF set on error
Notes:	this function is called by the DOS 3.1+ kernel
	called when print echoing (^P, ^PrtSc) changes state and STDPRN has
	  bit 11 of the device information word in the SFT set
SeeAlso: AX=1124h
--------N-2F1127-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - UNUSED
	AX = 1127h
Return: CF set
	    AX = 0001h (invalid function) (see #0789 at INT 21/AH=59h)
--------N-2F1128-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - UNUSED
	AX = 1128h
Return: CF set
	    AX = 0001h (invalid function) (see #0789 at INT 21/AH=59h)
--------N-2F1129-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - UNUSED
	AX = 1129h
Return: CF set
	    AX = 0001h (invalid function) (see #0789 at INT 21/AH=59h)
--------N-2F112A-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - CLOSE ALL FILES FOR PROCESS
	AX = 112Ah
	DS = DOS DS
	???
Return: ???
Note:	does something to each IFS driver
--------N-2F112B-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - GENERIC IOCTL
	AX = 112Bh
	SS = DOS DS
	CX = function/category
	DS:DX -> parameter block
	STACK: WORD value of AX on entry to INT 21 (440Ch or 440Dh)
	???
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
Note:	this function is called by the DOS 4.0 kernel
--------N-2F112C-----------------------------
INT 2F CU - NETWORK REDIRECTOR (DOS 4+) - "UPDATE_CB" - ???
	AX = 112Ch
	SS = DOS DS
	SDA current SFT pointer -> SFT for file
	???
Return: CF set on error
Note:	called by SHARE in DOS 5.0-6.0
--------N-2F112D-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - EXTENDED ATTRIBUTES
	AX = 112Dh
	BL = subfunction (value of AL on INT 21)
	    02h get extended attributes
	    03h get extended attribute properties
	    04h set extended attributes
		Return: CF clear
	    else ???
		Return: CX = ??? (00h or 02h for DOS 4.01)
	ES:DI -> SFT for file
	SS = DOS DS
Return: DS = DOS DS
Note:	this function is called by the DOS 4.0 kernel on INT 21/AX=5702h,
	  INT 21/AX=5703h, and INT 21/AX=5704h
SeeAlso: INT 21/AX=5702h,INT 21/AX=5703h,INT 21/AX=5704h,INT 21/AH=6Eh
--------N-2F112E-----------------------------
INT 2F CU - NETWORK REDIRECTOR (DOS 4+) - EXTENDED OPEN/CREATE FILE
	AX = 112Eh
	SS = DS = DOS DS
	ES:DI -> uninitialized SFT for file
	STACK: WORD file attribute for created/truncated file
			low byte = file attributes
			high byte = 00h normal create/open, 01h create new file
	SDA first filename pointer -> fully-qualified filename
	SDA extended file open action = action code (see INT 21/AX=6C00h)
	SDA extended file open mode = open mode for file (see INT 21/AX=6C00h)
Return: CF set on error
	    AX = error code
	CF clear if successful
	    CX = result code
		01h file opened
		02h file created
		03h file replaced (truncated)
	    SFT initialized (except handle count, which DOS manages itself)
Note:	this function is called by the DOS 4+ kernel
BUG:	this function is not called correctly under some DOS versions
	  (at least 5.0 and 6.2):
	    the file attribute on the stack is not correct if the action 
	      code is 11h,
	    the result code in CX is not passed back to the application.
SeeAlso: AX=1115h,AX=1116h,AX=1117h,INT 21/AX=6C00h
--------N-2F112F-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - IFS IOCTL
	AX = 112Fh
	SS = DOS DS
	STACK: WORD function in low byte
		00h ???
		    DS:SI -> Current Directory Structure???
		    CL = drive (1=A:)
		01h ???
		    DS:SI -> ???
		    CL = file handle???
		02h ???
		    DS:SI -> Current Directory Structure???
		    DI = ???
		    CX = drive (1=A:)
	???
Return: CF set on error
	    AX = DOS error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
Note:	this function is called by the DOS 4.0 kernel
SeeAlso: INT 21/AH=6Bh
--------N-2F1130-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - GET IFSFUNC SEGMENT
	AX = 1130h
Return: ES = CS of resident IFSFUNC
--------N-2F1180-----------------------------
INT 2F - LAN Manager Enhanced DOS Services - ???
	AX = 1180h
	???
Return: ???
--------N-2F1182-----------------------------
INT 2F - LAN Manager Enhanced DOS Services - INSTALL SERVICE
	AX = 1182h
	???
Return: ???
--------N-2F1184-----------------------------
INT 2F - LAN Manager Enhanced DOS - ???
	AX = 1184h
	???
Return: ???
--------N-2F1186-----------------------------
INT 2F - LAN Manager Enhanced DOS - DosReadAsynchNmPipe
	AX = 1186h
	DS:SI -> stack frame (see #1275)
Return: CF clear if successful
	CF set if error
	    AX = error code
Note:	LAN Manager enhance mode adds features beyond the standard redirector
	  file/printer services
SeeAlso: AX=118Fh,AX=1190h,AX=1191h,INT 21/AX=5F39h

Format of LAN Manager DosReadAsynchNmPipe stack frame:
Offset	Size	Description	(Table 1275)
 00h	DWORD	-> number of bytes read
 04h	WORD	size of buffer
 06h	DWORD	-> buffer
 0Ah	DWORD	-> return code
 0Eh	DWORD	function to call on completion as function( char far *buffer )
 12h	WORD	handle
--------N-2F118A-----------------------------
INT 2F - LAN Manager 2.0+ DOS Enhanced ENCRYPT.EXE - STREAM ENCRYPTION SERVICE
	AX = 118Ah
	BX = function (0000h or 0001h)
Return: CF clear if successful
	    AX = 1100h success
	CF set if error
	    AX = 0001h, etc.
SeeAlso: AX=1186h,AH=41h,AH=42h,AH=4Bh
--------N-2F118B-----------------------------
INT 2F - LAN Manager Enhanced DOS - ???
	AX = 118Bh
	???
Return: ???
--------N-2F118C-----------------------------
INT 2F - LAN Manager Enhanced DOS - ???
	AX = 118Ch
	???
Return: ???
--------N-2F118E-----------------------------
INT 2F - LAN Manager Enhanced DOS - ???
	AX = 118Eh
	???
Return: ???
--------N-2F118F-----------------------------
INT 2F - LAN Manager Enhanced DOS - DosWriteAsynchNmPipe
	AX = 118Fh
	DS:SI -> stack frame (see #1276)
Return: CF clear if successful
	CF set if error
	    AX = error code
SeeAlso: AX=1186h,AX=1191h,INT 21/AX=5F3Ah

Format of LAN Manager DosReadAsynchNmPipe stack frame:
Offset	Size	Description	(Table 1276)
 00h	DWORD	-> number of bytes read
 04h	WORD	Size of buffer
 06h	DWORD	-> buffer
 0Ah	DWORD	-> return code
 0Eh	DWORD	function to call on completion as function( char far *buffer )
 12h	WORD	handle
--------N-2F1190-----------------------------
INT 2F - LAN Manager Enhanced DOS - DosReadAsynchNmPipe2
	AX = 1190h
	DS:SI -> stack frame (see #1277)
Return: CF clear if successful
	CF set if error
	    AX = error code
SeeAlso: AX=1186h,AX=1191h

Format of LAN Manager DosReadAsynchNmPipe2 stack frame:
Offset	Size	Description	(Table 1277)
 00h	DWORD	-> number of bytes read
 04h	WORD	size of buffer
 06h	DWORD	-> buffer
 0Ah	DWORD	-> return code
 0Eh	DWORD	function to call on completion as function( char far *buffer )
 12h	WORD	handle
 14h	DWORD	???
--------N-2F1191-----------------------------
INT 2F - LAN Manager Enhanced DOS - DosWriteAsynchNmPipe2
	AX = 1191h
	DS:SI -> stack frame (see #1278)
Return: CF clear if successful
	CF set if error
	    AX = error code
SeeAlso: AX=118Fh,AX=1190h,INT 21/AX=5F3Ah

Format of LAN Manager DosReadAsynchNmPipe2 stack frame:
Offset	Size	Description	(Table 1278)
 00h	DWORD	-> number of bytes read
 04h	WORD	size of buffer
 06h	DWORD	-> buffer
 0Ah	DWORD	-> return code
 0Eh	DWORD	function to call on completion as function( char far *buffer )
 12h	WORD	handle
 14h	DWORD	???
--------D-2F1200-----------------------------
INT 2F U - DOS 3+ internal - INSTALLATION CHECK
	AX = 1200h
Return: AL = FFh (for compatibility with other INT 2F functions)
--------D-2F1201-----------------------------
INT 2F U - DOS 3+ internal - CLOSE CURRENT FILE
	AX = 1201h
	SS = DOS DS (must be using a DOS internal stack)
	SDA current SFT pointer -> SFT of file to close
Return: CF set on error
	BX???
	CX new reference count of SFT
	ES:DI -> SFT for file
SeeAlso: AX=1106h,AX=1227h,INT 21/AH=3Eh
--------D-2F1202-----------------------------
INT 2F U - DOS 3+ internal - GET INTERRUPT ADDRESS
	AX = 1202h
	STACK: WORD vector number
Return: ES:BX -> interrupt vector
	STACK unchanged
--------D-2F1203-----------------------------
INT 2F U - DOS 3+ internal - GET DOS DATA SEGMENT
	AX = 1203h
Return: DS = data segment of IBMDOS.COM/MSDOS.SYS
Note:	for DOS prior to version 5.0, the data segment is the same as the code
	  segment
--------D-2F1204-----------------------------
INT 2F U - DOS 3+ internal - NORMALIZE PATH SEPARATOR
	AX = 1204h
	STACK: WORD character to normalize
Return: AL = normalized character (forward slash turned to backslash, all
		  others unchanged)
	ZF set if path separator
	STACK unchanged
--------D-2F1205-----------------------------
INT 2F U - DOS 3+ internal - OUTPUT CHARACTER TO STANDARD OUTPUT
	AX = 1205h
	STACK: WORD character to output
Return: STACK unchanged
Note:	can be called only from within DOS
--------D-2F1206-----------------------------
INT 2F U - DOS 3+ internal - INVOKE CRITICAL ERROR
	AX = 1206h
	DI = error code
	BP:SI -> device driver header
	SS = DOS DS (must be using a DOS internal stack)
	STACK: WORD value to be passed to INT 24 in AX
Return: AL = 0-3 for Abort, Retry, Ignore, Fail
	STACK unchanged
SeeAlso: INT 24
--------D-2F1207-----------------------------
INT 2F U - DOS 3+ internal - MAKE DISK BUFFER MOST-RECENTLY USED
	AX = 1207h
	DS:DI -> disk buffer
Return: nothing
Desc:	move the indicated buffer to the end of the disk buffer chain (least-
	  recently used is first); under DOS 3.3, the buffer is then moved to
	  the start of the disk buffer chain if it was marked unused
Notes:	can be called only from within DOS
	this function is nearly the same as AX=120Fh
SeeAlso: AX=120Fh
--------D-2F1208-----------------------------
INT 2F U - DOS 3+ internal - DECREMENT SFT REFERENCE COUNT
	AX = 1208h
	ES:DI -> SFT
Return: AX = original value of reference count
Notes:	if the reference count was 1, it is set to FFFFh (since 0 indicates
	  that the SFT is not in use).	It is the caller's responsibility to
	  set the reference count to zero after cleaning up.
	used by network redirectors such as MSCDEX
SeeAlso: AX=1106h
--------D-2F1209-----------------------------
INT 2F U - DOS 3+ internal - FLUSH AND FREE DISK BUFFER
	AX = 1209h
	DS:DI -> disk buffer
Return: disk buffer marked unused, contents written to disk if buffer dirty
Note:	can be called only from within DOS
SeeAlso: AX=120Eh,AX=1215h
--------D-2F120A-----------------------------
INT 2F U - DOS 3+ internal - PERFORM CRITICAL ERROR INTERRUPT
	AX = 120Ah
	DS = SS = DOS DS (must be using a DOS internal stack)
	STACK: WORD extended error code
Return: AL = user response (0=ignore, 1=retry, 2=abort, 3=fail)
	CF clear if retry, set otherwise
	STACK unchanged
Notes:	can only be called during a DOS function call, as it uses various
	  fields in the SDA to set up the registers for the INT 24
	reportedly sets current DPB's first root directory sector to 1
SeeAlso: INT 24
--------D-2F120B-----------------------------
INT 2F U - DOS 3+ internal - SIGNAL SHARING VIOLATION TO USER
	AX = 120Bh
	ES:DI -> system file table entry for previous open of file
	STACK: WORD extended error code (should be 20h--sharing violation)
Return: CF clear if operation should be retried
	CF set if operation should not be retried
	    AX = error code (20h) (see #0789 at INT 21/AH=59h)
	STACK unchanged
Notes:	can only be called during a DOS function call
	should only be called if an attempt was made to open an already-open
	  file contrary to the sharing rules
	invokes INT 24 if SFT file opened via FCB or in compatibility mode with
	  inheritance allowed
--------D-2F120C-----------------------------
INT 2F U - DOS 3+ internal - OPEN DEVICE AND SET SFT OWNER/MODE
	AX = 120Ch
	SDA current SFT pointer -> SFT for file
	DS = DOS DS
	SS = DOS DS (must be using a DOS internal stack)
Return: ES, DI, AX destroyed
Notes:	invokes "device open" call on device driver for SFT
	changes owner of last-accessed SFT to calling process if it was opened
	  via FCB
	called by network redirectors such as MSCDEX
--------D-2F120D-----------------------------
INT 2F U - DOS 3+ internal - GET DATE AND TIME
	AX = 120Dh
	SS = DOS DS (must be using a DOS internal stack)
Return: AX = current date in packed format (see #0781 at INT 21/AX=5700h)
	DX = current time in packed format (see #0780 at INT 21/AX=5700h)
SeeAlso: INT 21/AH=2Ah,INT 21/AH=2Ch
--------D-2F120E-----------------------------
INT 2F U - DOS 3+ internal - MARK ALL DISK BUFFERS UNREFERENCED
	AX = 120Eh
	SS = DOS DS (must be using a DOS internal stack)
Return: DS:DI -> first disk buffer
Notes:	clears "referenced" flag on all disk buffers
	in DOS 5+, this has become essentially a NOP, invoking the same code
	  used by AX=1224h (SHARING DELAY)
SeeAlso: AX=1209h,AX=1210h,INT 21/AH=0Dh
--------D-2F120F-----------------------------
INT 2F U - DOS 3+ internal - MAKE BUFFER MOST RECENTLY USED
	AX = 120Fh
	DS:DI -> disk buffer
	SS = DOS DS (must be using a DOS internal stack)
Return: DS:DI -> next buffer in buffer list
Desc:	move the indicated buffer to the end of the disk buffer chain (least-
	  recently used is first); under DOS 3.3, the buffer is then moved to
	  the start of the disk buffer chain if it was marked unused
Note:	this function is the same as AX=1207h except that it returns a
	  pointer to the buffer following the specified buffer in the buffer
	  chain
SeeAlso: AX=1207h
--------D-2F1210-----------------------------
INT 2F U - DOS 3+ internal - FIND UNREFERENCED DISK BUFFER
	AX = 1210h
	DS:DI -> first disk buffer to check
Return: ZF clear if found
	    DS:DI -> first unreferenced disk buffer
	ZF set if not found
Note:	in DOS 5+, this has become essentially a NOP, invoking the same code
	  used by AX=1224h (SHARING DELAY)
SeeAlso: AX=120Eh
--------D-2F1211-----------------------------
INT 2F U - DOS 3+ internal - NORMALIZE ASCIZ FILENAME
	AX = 1211h
	DS:SI -> ASCIZ filename to normalize
	ES:DI -> buffer for normalized filename
Return: destination buffer filled with uppercase filename, with slashes turned
	to backslashes
SeeAlso: AX=121Eh,AX=1221h
--------D-2F1212-----------------------------
INT 2F U - DOS 3+ internal - GET LENGTH OF ASCIZ STRING
	AX = 1212h
	ES:DI -> ASCIZ string
Return: CX = length of string
SeeAlso: AX=1225h
--------D-2F1213-----------------------------
INT 2F U - DOS 3+ internal - UPPERCASE CHARACTER
	AX = 1213h
	STACK: WORD character to convert to uppercase
Return: AL = uppercase character
	STACK unchanged
--------D-2F1214-----------------------------
INT 2F U - DOS 3+ internal - COMPARE FAR POINTERS
	AX = 1214h
	DS:SI = first pointer
	ES:DI = second pointer
Return: ZF set if pointers are equal, ZF clear if not equal
--------D-2F1215-----------------------------
INT 2F U - DOS 3+ internal - FLUSH BUFFER
	AX = 1215h
	DS:DI -> disk buffer
	SS = DOS DS (must be using a DOS internal stack)
	STACK: WORD drives for which to skip buffer
		ignore buffer if drive same as high byte, or bytes differ and
		  the buffer is for a drive OTHER than that given in low byte
Return: STACK unchanged
Note:	can be called only from within DOS
SeeAlso: AX=1209h
--------D-2F1216-----------------------------
INT 2F U - DOS 3+ internal - GET ADDRESS OF SYSTEM FILE TABLE ENTRY
	AX = 1216h
	BX = system file table entry number
Return: CF clear if successful
	    ES:DI -> system file table entry
	CF set if BX greater than FILES=
Note:	supported by DR-DOS 5+
SeeAlso: AX=1220h
--------D-2F1217-----------------------------
INT 2F U - DOS 3+ internal - GET CURRENT DIRECTORY STRUCTURE FOR DRIVE
	AX = 1217h
	SS = DOS DS (must be using a DOS internal stack)
	STACK: WORD drive (0 = A:, 1 = B:, etc)
Return: CF set on error
	    (drive > LASTDRIVE)
	CF clear if successful
	    DS:SI -> current directory structure for specified drive
	STACK unchanged
SeeAlso: AX=1219h
--------D-2F1218-----------------------------
INT 2F U - DOS 3+ internal - GET CALLER'S REGISTERS
	AX = 1218h
Return: DS:SI -> saved caller's AX,BX,CX,DX,SI,DI,BP,DS,ES (on stack)
Note:	only valid while within DOS
--------D-2F1219-----------------------------
INT 2F U - DOS 3+ internal - SET DRIVE???
	AX = 1219h
	SS = DOS DS (must be using a DOS internal stack)
	STACK: WORD drive (0 = default, 1 = A:, etc)
Return: ???
	STACK unchanged
Notes:	calls AX=1217h
	builds a current directory structure if inside server call
	  (INT 21/AX=5D00h)
SeeAlso: AX=1217h,AX=121Fh
--------D-2F121A-----------------------------
INT 2F U - DOS 3+ internal - GET FILE'S DRIVE
	AX = 121Ah
	DS:SI -> filename
Return: AL = drive (0 = default, 1 = A:, etc, FFh = invalid)
	DS:SI -> filename without leading X: (if present)
SeeAlso: INT 21/AH=19h,INT 21/AH=60h
--------D-2F121B-----------------------------
INT 2F U - DOS 3+ internal - SET YEAR/LENGTH OF FEBRUARY
	AX = 121Bh
	CL = year - 1980
Return: AL = number of days in February
Note:	requires DS to be set to the DOS data segment
SeeAlso: INT 21/AH=2Bh
--------D-2F121C-----------------------------
INT 2F U - DOS 3+ internal - CHECKSUM MEMORY
	AX = 121Ch
	DS:SI -> start of memory to checksum
	CX = number of bytes
	DX = initial checksum
	SS = DOS DS (must be using a DOS internal stack)
Return: AX, CX destroyed
	DX = checksum
	DS:SI -> first byte after checksummed range
Notes:	used by DOS to determine day count since 1/1/80 given a date
	supported by DR-DOS 5.0+
SeeAlso: AX=121Dh
--------D-2F121D-----------------------------
INT 2F U - DOS 3+ internal - SUM MEMORY
	AX = 121Dh
	DS:SI -> memory to add up
	CX = 0000h
	DX = limit
Return: AL = byte which exceeded limit
	CX = number of bytes before limit exceeded
	DX = remainder after adding first CX bytes
	DS:SI -> byte beyond the one which exceeded the limit
Notes:	used by DOS to determine year or month given day count since 1/1/80
	supported by DR-DOS 5.0+
SeeAlso: AX=121Ch
--------D-2F121E-----------------------------
INT 2F U - DOS 3+ internal - COMPARE FILENAMES
	AX = 121Eh
	DS:SI -> first ASCIZ filename
	ES:DI -> second ASCIZ filename
Return: ZF set if filenames equivalent, ZF clear if not
Note:	supported by DR-DOS 5.0+
SeeAlso: AX=1211h,AX=1221h
--------D-2F121F-----------------------------
INT 2F U - DOS 3+ internal - BUILD CURRENT DIRECTORY STRUCTURE
	AX = 121Fh
	SS = DOS DS (must be using a DOS internal stack)
	STACK: WORD drive letter
Return: ES:DI -> current directory structure (will be overwritten by next call)
	STACK unchanged
--------D-2F1220-----------------------------
INT 2F U - DOS 3+ internal - GET JOB FILE TABLE ENTRY
	AX = 1220h
	BX = file handle
Return: CF set on error
	    AL = 6 (invalid file handle)
	CF clear if successful
	    ES:DI -> JFT entry for file handle in current process
Notes:	the byte pointed at by ES:DI contains the number of the SFT for the
	  file handle, or FFh if the handle is not open
	supported by DR-DOS 5.0+
SeeAlso: AX=1216h,AX=1229h
--------D-2F1221-----------------------------
INT 2F U - DOS 3+ internal - CANONICALIZE FILE NAME
	AX = 1221h
	DS:SI -> file name to be fully qualified
	ES:DI -> 128-byte buffer for resulting canonical file name
	SS = DOS DS (must be using a DOS internal stack)
Return: (see INT 21/AH=60h)
Note:	identical to INT 21/AH=60h
SeeAlso: AX=1123h,INT 21/AH=60h
--------D-2F1222-----------------------------
INT 2F U - DOS 3+ internal - SET EXTENDED ERROR INFO
	AX = 1222h
	SS = DOS data segment
	SS:SI -> 4-byte records
		BYTE	error code, FFh = last record
		BYTE	error class, FFh = don't change
		BYTE	suggested action, FFh = don't change
		BYTE	error locus, FFh = don't change
	SDA error code set
Return: SI destroyed
	SDA error class, error locus, and suggested action fields set
Note:	can be called only from within DOS
SeeAlso: AX=122Dh,INT 21/AH=59h,INT 21/AX=5D0Ah
--------D-2F1223-----------------------------
INT 2F U - DOS 3+ internal - CHECK IF CHARACTER DEVICE
	AX = 1223h
	DS = DOS DS
	SS = DOS DS (must be using a DOS internal stack)
	SDA+218h (DOS 3.10-3.30) = eight-character blank-padded name
	SDA+22Bh (DOS 4.0-6.0) = eight-character blank-padded name
Return: CF set if no character device by that name found
	CF clear if found
	    BH = low byte of device attribute word
Note:	can only be called from within DOS
SeeAlso: INT 21/AX=5D06h,INT 21/AX=5D0Bh
--------D-2F1224-----------------------------
INT 2F U - DOS 3+ internal - SHARING RETRY DELAY
	AX = 1224h
	SS = DOS DS (must be using a DOS internal stack)
Return: after delay set by INT 21/AX=440Bh, unless in server call
	  (INT 21/AX=5D00h)
Note:	delay is dependent on the processor speed, and is skipped entirely if
	  inside a server call
SeeAlso: INT 21/AX=440Bh,INT 21/AH=52h,INT 62/AX=0097h
--------D-2F1225-----------------------------
INT 2F U - DOS 3+ internal - GET LENGTH OF ASCIZ STRING
	AX = 1225h
	DS:SI -> ASCIZ string
Return: CX = length of string
Note:	supported by DR-DOS 5.0+
SeeAlso: AX=1212h
--------D-2F1226-----------------------------
INT 2F U - DOS 3.3+ internal - OPEN FILE
	AX = 1226h
	CL = access mode
	DS:DX -> ASCIZ filename
	SS = DOS DS (must be using a DOS internal stack)
Return: CF set on error
	    AL = error code (see #0789 at INT 21/AH=59h)
	CF clear if successful
	    AX = file handle
Notes:	can only be called from within DOS
	equivalent to INT 21/AH=3Dh
	used by NLSFUNC to access COUNTRY.SYS when invoked by the DOS kernel
SeeAlso: AX=1227h,INT 21/AH=3Dh
--------D-2F1227-----------------------------
INT 2F U - DOS 3.3+ internal - CLOSE FILE
	AX = 1227h
	BX = file handle
	SS = DOS DS (must be using a DOS internal stack)
Return: CF set on error
	    AL = 06h invalid file handle
	CF clear if successful
Notes:	can only be called from within DOS
	equivalent to INT 21/AH=3Eh
	used by NLSFUNC to access COUNTRY.SYS when invoked by the DOS kernel
SeeAlso: AX=1106h,AX=1201h,AX=1226h,INT 21/AH=3Eh
--------D-2F1228BP4200-----------------------
INT 2F U - DOS 3.3+ internal - MOVE FILE POINTER
	AX = 1228h
	BP = 4200h, 4201h, 4202h (see INT 21/AH=42h)
	BX = file handle
	CX:DX = offset in bytes
	SS = DOS DS (must be using a DOS internal stack)
Return: as for INT 21/AH=42h
Notes:	equivalent to INT 21/AH=42h, but may only be called from inside a DOS
	  function call
	sets user stack frame pointer to dummy buffer, moves BP to AX, performs
	  LSEEK, and restores frame pointer
	used by NLSFUNC to access COUNTRY.SYS when invoked by the DOS kernel
SeeAlso: INT 21/AH=42h
--------D-2F1229-----------------------------
INT 2F U - DOS 3.3+ internal - READ FROM FILE
	AX = 1229h
	BX = file handle
	CX = number of bytes to read
	DS:DX -> buffer
	SS = DOS DS (must be using a DOS internal stack)
Return: as for INT 21/AH=3Fh
Notes:	equivalent to INT 21/AH=3Fh, but may only be called when already inside
	  a DOS function call
	used by NLSFUNC to access COUNTRY.SYS when invoked by the DOS kernel
SeeAlso: AX=1226h,INT 21/AH=3Fh
--------D-2F122A-----------------------------
INT 2F U - DOS 3.3+ internal - SET FASTOPEN ENTRY POINT
	AX = 122Ah
	BX = entry point to set (0001h or 0002h)
	DS:SI -> FASTOPEN entry point
		(entry point not set if SI = FFFFh for DOS 4+)
Return: CF set if specified entry point already set
Notes:	entry point in BX is ignored under DOS 3.30
	both entry points set to same handler by DOS 4.01
	DOS 5.0 and 6.0 only set entry point 1

(Table 1279)
Values DOS 3.30+ FASTOPEN is called with:
	AL = 01h  Lookup
	    CX = ??? seems to be offset
	    DI = ??? seems to be offset
	    SI = offset in DOS DS of filename
	AL = 02h  insert file into FASTOPEN cache
	AL = 03h  delete file from FASTOPEN cache
	    SI = offset in DOS DS of filename
	AL = 04h  purge FASTOPEN cache
	    AH = subfunction (00h,01h,02h)
	    ES:DI -> ???
	    CX = ??? (subfunctions 01h and 02h only)
Returns: CF set on error or not installed
Note: function 03h calls function 01h first

(Table 1280)
Values PC-DOS 4.01 FASTOPEN is additionally called with:
	AL = 04h ???
	    AH = 03h
	    ???
	AL = 05h ???
	AL = 0Bh ???
	AL = 0Ch ???
	AL = 0Dh ???
	AL = 0Eh ???
	AL = 0Fh ???
	AL = 10h ???

(Table 1281)
Values MS-DOS 5.0-6.0 FASTOPEN is additionally called with:
	AL = 04h  purge FASTOPEN cache
	    AH = 03h
	    ???
	AL = 05h ???
	    DL = drive (00h = A:)
	    ???
	AL = 06h ???
	    ???
--------D-2F122B-----------------------------
INT 2F U - DOS 3.3+ internal - IOCTL
	AX = 122Bh
	BP = 44xxh
	SS = DOS DS (must be using a DOS internal stack)
	additional registers as appropriate for INT 21/AX=44xxh
Return: as for INT 21/AH=44h
Notes:	equivalent to INT 21/AH=44h, but may only be called when already inside
	  a DOS function call
	sets user stack frame pointer to dummy buffer, moves BP to AX, performs
	  IOCTL, and restores frame pointer
	used by NLSFUNC in accessing COUNTRY.SYS when invoked by the DOS kernel
SeeAlso: INT 21/AH=44h
--------D-2F122C-----------------------------
INT 2F U - DOS 3.3+ internal - GET DEVICE CHAIN
	AX = 122Ch
Return: BX:AX -> header of second device driver (NUL is first) in driver chain
Note:	although this function exists in DR-DOS 5.0, it returns 0000h:0000h
SeeAlso: INT 21/AH=52h
--------D-2F122D-----------------------------
INT 2F U - DOS 3.3+ internal - GET EXTENDED ERROR CODE
	AX = 122Dh
Return: AX = current extended error code
SeeAlso: AX=1222h,INT 21/AH=59h
--------D-2F122E-----------------------------
INT 2F U - DOS 4+ internal - GET OR SET ERROR TABLE ADDRESSES
	AX = 122Eh
	DL = subfunction
	    00h get standard DOS error table (see #1282)
		Return: ES:DI -> error table
				 (DOS 4: errors 00h-12h,50h-5Bh)
				 (DOS 5: errors 00h-26h,4Fh,51h-59h)
	    01h set standard DOS error table
		ES:DI -> error table
	    02h get parameter error table (errors 00h-0Ah)
		Return: ES:DI -> error table
	    03h set parameter error table
		ES:DI -> error table
	    04h get critical/SHARE error table (errors 13h-2Bh)
		Return: ES:DI -> error table
	    05h set critical/SHARE error table
		ES:DI -> error table
	    06h get ??? error table
		Return: ES:DI -> error table or 0000h:0000h
	    07h set ??? error table
		ES:DI -> error table
	    08h get error message retriever (see #1283)
		Return: ES:DI -> FAR procedure to fetch error message
	    09h set ??? error table
		ES:DI -> error table
Notes:	if the returned segment on a "get" is 0001h, then the offset specifies
	  the offset of the error message table within COMMAND.COM, and the
	  procedure returned by DL=08h should be called
	DOS 5+ COMMAND.COM does not allow setting any of the addresses (calls
	  with DL odd are ignored); they are always returned with segment 0001h
	for DOS 5.0, the standard and critical/SHARE error tables are combined
	  into a single error table
SeeAlso: AX=0500h,INT 21/AH=59h

Format of DOS 4.x error table:
Offset	Size	Description	(Table 1282)
 00h	BYTE	FFh
 01h  2 BYTEs	04h,00h (DOS version???)
 03h	BYTE	number of error headers following
 04h 2N WORDs	table of all error headers for table
		Offset	Size	Description
		 00h	WORD	error message number
		 02h	WORD	offset of error message from start of header
				error messages are count byte followed by msg
Note:	DOS 5 error tables consist of one word per error number; each word
	  contains either the offset of a counted string or 0000h

(Table 1283)
Call error retrieval function with:
	AX = error number
	DI = offset of error table
Return: ES:DI -> error message (counted string)
Notes:	this function needs to access COMMAND.COM if the messages were not
	  loaded into memory permanently with /MSG; the caller should assume
	  that the returned message will be overwritten by the next call of
	  the function
	supported by DR-DOS 5.0

(Table 1284)
Values for parameter errors:
 01h	Too many parameters
 02h	Required Parameter missing
 03h	Invalid switch
 04h	Invalid keyword
 06h	Parameter value not in allowed range
 07h	Parameter value not allowed
 08h	Parameter value not allowed
 09h	Parameter format not correct
 0Ah	Invalid parameter
 0Bh	Invalid parameter combination
--------D-2F122F-----------------------------
INT 2F U - DOS 4.x internal - SET DOS VERSION NUMBER TO RETURN
	AX = 122Fh
	DX = DOS version number (0000h = return true DOS version)
Note:	not available under DR-DOS 5.0 or 6.0
SeeAlso: INT 21/AH=30h,INT 21/AX=3306h
--------m-2F12FFBX0006-----------------------
INT 2F U - DR-DOS 6, Novell DOS 7 - EMM386.EXE - VIDEO MEMORY SPACE CONTROL
	AX = 12FFh
	BX = 0006h
	DX = 0000h
	CX = function
	    0000h get status of video memory space (MEMMAX /V)
	    0001h map memory into video memory space (MEMMAX +V)
	    0002h unmap memory from video memory space (MEMMAX -V)
Return: CF clear if successful
	    AX = 0000h (successful)
	    BX = segment of reserved video RAM
	    CX = segment of used video RAM
	    DX = segment of first upper MCB
Notes:	this functionality is provided by EMM386, and partially supported by
	  HIDOS.SYS
	BL specifies which program handles the call, BH is the function number
SeeAlso: AX=D201h/BX=4849h
--------O-2F12FFBX0007-----------------------
INT 2F U - Novell DOS 7 - SCRIPT.EXE - GET ???
	AX = 12FFh
	BX = 0007h
	CX = 0000h
Return: CF clear if installed
	    AX = 0000h
	    BX = ??? (4426h)
	    CX = ??? (0068h)
	    DX = PSP segment of resident code???
	    SI = ??? (4AFAh)
	    ES = resident code segment
--------m-2F12FFBX0106-----------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - GET VERSION???
	AX = 12FFh
	BX = 0106h
Return:	CF clear if successful
	    AX = 0000h (successful)
	    BX = EDC0h (signature)
	    CL = memory manager variant (02h,03h)
		(02h when DPMI/VCPI disabled, 03h when DPMI/VCPI loaded)
	    CH = ??? (00h)
	    DX = version??? (0300h for v3.0)
	    ES = segment of EMM386 low-memory stub
Notes:	BL specifies which program handles the call, BH is the function number
	if the word at ES:0012h is nonzero, if contains the offset within
	  segment ES of the CEMM-compatible entry point (see #1285)
	if no other program has hooked INT 67, an alternate installation
	  check is to test for the string
	  "NOVELL EXPANDED MEMORY MANAGER 386" at offset 14h in the INT 67
	  handler's segment; the word immediately preceding this string
	  contains the offset of the API entry point if it is nonzero
Index:	entry point;Novell EMM386

(Table 1285)
Call Novell EMM386.EXE entry point with:
	AH = 00h get memory manager's status???
	    ???
	AH = 01h set memory manager's status???
	    ???
	AH = 02h Weitek coprocessor support???
	    AL = subfunction???
	more functions???
SeeAlso: #0640 at INT 21/AX=4402h/SF=02h,#1950 at INT 67/AX=FFA5h
--------m-2F12FFBL06-------------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - ???
	AX = 12FFh
	BL = 06h
	BH = function (02h-09h)
	???
Return: ???
--------O-2F12FFBX0EDC-----------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - CHECK IF MULTITASKING SUPPORT LOADED???
	AX = 12FFh
	BX = 0EDCh
Return: AX = 0000h if ??? loaded
	    CF clear
	    BX = 0000h
Notes:	called by Novell DOS 7 TaskMgr
	if this function returns with AX=0000h, then the code necessary to
	  support the API on INT 2F/AX=2780h is loaded and that API becomes
	  available for use
	because the request is handled on the initial trap to the memory
	  manager caused by INT instructions, this function must be invoked
	  with an actual INT 2F instruction instead of some simulation such
	  as a far call to the address in the interrupt vector table
SeeAlso: AX=2780h/CL=01h,AX=2780h/CL=02h,AX=2780h/CL=03h,AX=2780h/CL=04h
--------D-2F13-------------------------------
INT 2F U - DOS 3.2+ - SET DISK INTERRUPT HANDLER
	AH = 13h
	DS:DX -> interrupt handler disk driver calls on read/write
	ES:BX = address to restore INT 13 to on system halt (exit from root
		 shell) or warm boot (INT 19)
Return: DS:DX set by previous invocation of this function
	ES:BX set by previous invocation of this function
Notes:	IO.SYS hooks INT 13 and inserts one or more filters ahead of the
	  original INT 13 handler.  The first is for disk change detection
	  on floppy drives, the second is for tracking formatting calls and
	  correcting DMA boundary errors, the third is for working around
	  problems in a particular version of IBM's ROM BIOS
	before the first call, ES:BX points at the original BIOS INT 13; DS:DX
	  also points there unless IO.SYS has installed a special filter for
	  hard disk reads (on systems with model byte FCh and BIOS date
	  "01/10/84" only), in which case it points at the special filter
	most DOS 3.2+ disk access is via the vector in DS:DX, although a few
	  functions are still invoked via an INT 13 instruction
	this is a dangerous security loophole for any virus-monitoring software
	  which does not trap this call ("INT13", "Nomenklatura", and many
	  Bulgarian viruses are known to use it to get the original ROM entry
	  point)
SeeAlso: INT 13/AH=01h,INT 19,INT 9D"VIRUS"
--------N-2F13-------------------------------
INT 2F U - MS-NET - ???
	AH = 13h
	???
Return: ???
Note:	supposedly used to move (or control the movement of) NCBs
--------U-2F1400-----------------------------
INT 2F C - NLSFUNC.COM - INSTALLATION CHECK
	AX = 1400h
Return: AL = 00h not installed, OK to install
	     01h not installed, not OK
	     FFh installed
Notes:	this function is called by the DOS v3.3+ kernel
	supported by OS/2 v1.3+ compatibility box, which always returns AL=FFh
	supported by DR-DOS 5.0
	documented for MS-DOS 5+, but undocumented in prior versions
SeeAlso: AX=1401h"NLSFUNC",AX=1402h"NLSFUNC"
--------D-2F1400-----------------------------
INT 2F - European MS-DOS 4.0 POPUP - "CheckPu" - INSTALLATION CHECK
	AX = 1400h
Return: AX = FFFFh if installed
	    BX = maximum memory required to save screen and keyboard info
	CF clear if successful
	CF set on error
	    AX = error code
		0002h invalid function
		0004h unknown error
Note:	the POPUP interface is used by background programs (see INT 21/AH=80h)
	  to communicate with the user
SeeAlso: AX=1401h"POPUP",AX=1402h"POPUP",AX=1403h"POPUP"
--------U-2F1401-----------------------------
INT 2F CU - NLSFUNC.COM - CHANGE CODE PAGE
	AX = 1401h
	DS:SI -> internal code page structure (see #1286)
	BX = new code page (see INT 21/AX=6602h)
	DX = country code???
Return: AL = status
	     00h successful
	     else DOS error code
Note:	this function is called by the DOS v3.3+ kernel
SeeAlso: AX=1400h"NLSFUNC",AX=1402h"NLSFUNC",INT 21/AH=66h

Format of DOS 3.30 internal code page structure:
Offset	Size	Description	(Table 1286)
 00h  8 BYTEs	???
 08h 64 BYTEs	name of country information file
 48h	WORD	system code page
 4Ah	WORD	number of supported subfunctions
 4Ch  5 BYTEs	data to return for INT 21/AX=6502h
 51h  5 BYTEs	data to return for INT 21/AX=6504h
 56h  5 BYTEs	data to return for INT 21/AX=6505h
 5Bh  5 BYTEs	data to return for INT 21/AX=6506h
 60h 41 BYTEs	data to return for INT 21/AX=6501h
--------D-2F1401-----------------------------
INT 2F - European MS-DOS 4.0 POPUP - "PostPu" - OPEN/CLOSE POPUP SCREEN
	AX = 1401h
	DL = function (00h open, 01h close)
	DH = wait flag
	    00h block until screen opens
	    01h return error if screen is not available
	    02h urgent--always open screen immediately
Return: CF clear if successful
	    BX = amount of memory needed to save screen and keyboard info,
		0000h if default save location can be used (only if DH was 02h)
	CF set on error
Note:	the application using the screen is frozen until the popup screen is
	  closed
SeeAlso: AX=1400h"POPUP",AX=1402h"POPUP",AX=1403h"POPUP"
--------U-2F1402-----------------------------
INT 2F CU - NLSFUNC.COM - GET EXTENDED COUNTRY INFO
	AX = 1402h
	BP = subfunction (same as AL for INT 21/AH=65h)
	BX = code page (see INT 21/AX=6602h)
	DX = country code (see INT 21/AH=38h)
	DS:SI -> internal code page structure (see #1286)
	ES:DI -> user buffer
	CX = size of user buffer
Return: AL = status
	    00h successful
	    else DOS error code
Notes:	this function is called by the DOS v3.3+ kernel on INT 21/AH=65h
	code page structure apparently only needed for COUNTRY.SYS pathname
SeeAlso: AX=1401h"NLSFUNC",AX=1403h"NLSFUNC",AX=1404h,INT 21/AH=65h
--------D-2F1402-----------------------------
INT 2F - European MS-DOS 4.0 POPUP - "SavePu" - SAVE POPUP SCREEN
	AX = 1402h
	ES:DI -> save buffer (0000h:0000h for default buffer in POPUP)
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1287)
SeeAlso: AX=1400h"POPUP",AX=1401h"POPUP",AX=1403h"POPUP"

(Table 1287)
Values for POPUP error code:
 0001h	process does not own screen
 0004h	unknown error
 0005h	invalid pointer
--------U-2F1403-----------------------------
INT 2F CU - NLSFUNC.COM - SET CODE PAGE
	AX = 1403h
	DS:SI -> internal code page structure (see #1286)
	BX = code page (see INT 21/AX=6602h)
	DX = country code (see INT 21/AH=38h)
Return: AL = status
	     ???
Note:	this function is called by the DOS v3.3+ kernel on INT 21/AH=38h
SeeAlso: AX=1402h"NLSFUNC",AX=1404h,INT 21/AH=38h"SET"
--------D-2F1403-----------------------------
INT 2F - European MS-DOS 4.0 POPUP - "RestorePu" - RESTORE SCREEN
	AX = 1403h
	ES:DI -> buffer containing saved screen
		(0000h:0000h for default buffer in POPUP)
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1287)
SeeAlso: AX=1400h"POPUP",AX=1401h"POPUP",AX=1402h"POPUP"
--------U-2F1404-----------------------------
INT 2F CU - NLSFUNC.COM - GET COUNTRY INFO
	AX = 1404h
	BX = code page (see INT 21/AX=6602h)
	DX = country code (see INT 21/AH=38h)
	DS:SI -> internal code page structure (see #1286)
	ES:DI -> user buffer
Return: AL = status
	     ???
Notes:	this function is called by the DOS v3.3+ kernel on INT 21/AH=38h
	code page structure apparently only needed for COUNTRY.SYS pathname
SeeAlso: AX=1402h,AX=1403h,INT 21/AH=38h"GET"
--------U-2F14FE-----------------------------
INT 2F U - DR-DOS 5.0 NLSFUNC - GET EXTENDED COUNTRY INFORMATION
	AX = 14FEh
	BX = code page (FFFFh=global code page) (see INT 21/AX=6602h)
	DX = country ID (FFFFh=current country) (see INT 21/AH=38h)
	ES:DI -> country information buffer
	CL = info ID
	    01h get general internationalization info
	    02h get pointer to uppercase table
	    04h get pointer to filename uppercase table
	    05h get pointer to filename terminator table
	    06h get pointer to collating sequence table
	    07h get pointer to Double-Byte Character Set table
	CF set (used to return error if not installed)
Return: CF clear if successful
	    DS:SI -> requested information
	CF set on error
Notes:	DR-DOS 5.0 NLSFUNC returns CF set and AX=0001h if AL was not 00h, FEh,
	  or FFh on entry.
	the DR-DOS kernel calls this function on INT 21/AX=6501h
	the value in CL is not range-checked by the DR-DOS 5.0 NLSFUNC
SeeAlso: AX=14FFh,INT 21/AH=65h

Format of DR-DOS COUNTRY.SYS file:
Offset	Size	Description	(Table 1288)
 00h 126 BYTEs	copyright notice (terminated with Ctrl-Z, padded with NULs)
 7Eh	WORD	signature EDC1h
 80h	var	country pointer records
	Offset	Size	Description
	 00h	WORD	country code (0000h if end of array)
	 02h	WORD	code page
	 04h	WORD	??? (0000h)
	 06h  7 WORDs	offsets in file for data tables for subfunctions
			  01h-07h
 var	var	country information
--------U-2F14FF-----------------------------
INT 2F U - DR-DOS 5.0 NLSFUNC - PREPARE CODE PAGE
	AX = 14FFh
	BX = code page
Return: AX = ???
	ZF set if AX=0000h
Notes:	DR-DOS 5.0 NLSFUNC returns CF set and AX=0001h if AL was not 00h, FEh,
	  or FFh on entry.
	passes codepage preparation request to each character device supporting
	  the generic IOCTL call
SeeAlso: AX=14FEh,INT 21/AX=440Ch,INT 21/AX=6602h
--------U-2F1500-----------------------------
INT 2F - DOS 4.00 GRAPHICS.COM - INSTALLATION CHECK
	AX = 1500h
Return: AX = FFFFh
	ES:DI -> ??? (graphics data?)
Note:	this installation check conflicts with the CD-ROM Extensions
	  installation check; moved to AX=AC00h in later versions
SeeAlso: AX=AC00h
--------d-2F1500BX0000-----------------------
INT 2F - CD-ROM - INSTALLATION CHECK
	AX = 1500h
	BX = 0000h
Return: BX = number of CD-ROM drive letters used
	CX = starting drive letter (0=A:)
Notes:	this installation check DOES NOT follow the format used by other
	  software
	this installation check conflicts with the DOS 4.00 GRAPHICS.COM
	  installation check
SeeAlso: INT 2F/AX=D000h/BX=4D44h"Lotus"
--------d-2F1501-----------------------------
INT 2F - CD-ROM - GET DRIVE DEVICE LIST
	AX = 1501h
	ES:BX -> buffer to hold drive letter list (5 bytes per drive letter)
Return: buffer filled, for each drive letter
	  BYTE	subunit number in driver
	  DWORD address of device driver header
--------d-2F1502-----------------------------
INT 2F - CD-ROM - GET COPYRIGHT FILE NAME
	AX = 1502h
	ES:BX -> 38-byte buffer for name of copyright file
	CX = drive number (0=A:)
Return: CF set if drive is not a CD-ROM drive
	    AX = 000Fh (invalid drive)
	CF clear if successful
SeeAlso: AX=1503h
--------d-2F1503-----------------------------
INT 2F - CD-ROM - GET ABSTRACT FILE NAME
	AX = 1503h
	ES:BX -> 38-byte buffer for name of abstract file
	CX = drive number (0=A:)
Return: CF set if drive is not a CD-ROM drive
	    AX = 000Fh (invalid drive)
	CF clear if successful
SeeAlso: AX=1502h,AX=1504h
--------d-2F1504-----------------------------
INT 2F - CD-ROM - GET BIBLIOGRAPHIC DOC FILE NAME
	AX = 1504h
	ES:BX -> 38-byte buffer for name of bibliographic documentation file
	CX = drive number (0=A:)
Return: CF set if drive is not a CD-ROM drive
	    AX = 000Fh (invalid drive)
	CF clear if successful
SeeAlso: AX=1502h,AX=1503h
--------d-2F1505-----------------------------
INT 2F - CD-ROM - READ VTOC
	AX = 1505h
	ES:BX -> 2048-byte buffer
	CX = drive number (0=A:)
	DX = sector index (0=first volume descriptor,1=second,...)
Return: CF set on error
	    AX = error code (15=invalid drive,21=not ready)
	CF clear if successful
	    AX = volume descriptor type (1=standard,FFh=terminator,0=other)
--------d-2F1506-----------------------------
INT 2F - CD-ROM - TURN DEBUGGING ON
	AX = 1506h
	BX = debugging function to enable
Note:	reserved for development
SeeAlso: AX=1507h
--------d-2F1507-----------------------------
INT 2F - CD-ROM - TURN DEBUGGING OFF
	AX = 1507h
	BX = debugging function to disable
Note:	reserved for development
SeeAlso: AX=1506h
--------d-2F1508-----------------------------
INT 2F - CD-ROM - ABSOLUTE DISK READ
	AX = 1508h
	ES:BX -> buffer
	CX = drive number (0=A:)
	SI:DI = starting sector number
	DX = number of sectors to read
Return: CF set on error
	    AL = error code (15=invalid drive,21=not ready)
	CF clear if successful
SeeAlso: AX=1509h
--------d-2F1509-----------------------------
INT 2F - CD-ROM - ABSOLUTE DISK WRITE
	AX = 1509h
	ES:BX -> buffer
	CX = drive number (0=A:)
	SI:DI = starting sector number
	DX = number of sectors to write
Note:	corresponds to INT 26h and is currently reserved and nonfunctional
SeeAlso: AX=1508h
--------d-2F150A-----------------------------
INT 2F - CD-ROM - RESERVED
	AX = 150Ah
--------d-2F150B-----------------------------
INT 2F - CD-ROM v2.00+ - DRIVE CHECK
	AX = 150Bh
	CX = drive number (0=A:)
Return: BX = ADADh if MSCDEX.EXE installed
	    AX = support status
		0000h if drive not supported
		nonzero if supported
SeeAlso: AX=150Dh
--------d-2F150C-----------------------------
INT 2F - CD-ROM v2.00+ - GET MSCDEX.EXE VERSION
	AX = 150Ch
Return: BH = major version
	BL = minor version
Note:	MSCDEX.EXE versions prior to 2.00 return BX=0
--------d-2F150D-----------------------------
INT 2F - CD-ROM v2.00+ - GET CD-ROM DRIVE LETTERS
	AX = 150Dh
	ES:BX -> buffer for drive letter list (1 byte per drive)
Return: buffer filled with drive numbers (0=A:).  Each byte corresponds
	to the drive in the same position for function 1501h
SeeAlso: AX=150Bh
--------d-2F150E-----------------------------
INT 2F - CD-ROM v2.00+ - GET/SET VOLUME DESCRIPTOR PREFERENCE
	AX = 150Eh
	BX = subfunction
	    00h get preference
		DX = 0000h
		Return: DX = preference settings
	    01h set preference
		DH = volume descriptor preference
		    01h = primary volume descriptor
		    02h = supplementary volume descriptor
		DL = supplementary volume descriptor preference
		    01h = shift-Kanji
	CX = drive number (0=A:)
Return: CF set on error
	    AX = error code (15=invalid drive,1=invalid function)
	CF clear if successful
--------d-2F150F-----------------------------
INT 2F - CD-ROM v2.00+ - GET DIRECTORY ENTRY
	AX = 150Fh
	CL = drive number (0=A:)
	CH bit 0 = copy flag
		clear if direct copy
		set if copy to structure which removes ISO/High Sierra diffs
	ES:BX -> ASCIZ path name
	SI:DI -> buffer for directory entry (see #1289)
		 minimum 255 bytes for direct copy
Return: CF set on error
	    AX = error code
	CF clear if successful
	    AX = disk format (0=High Sierra,1=ISO 9660)

Format of CD-ROM directory entry (direct copy):
Offset	Size	Description	(Table 1289)
 00h	BYTE  length of directory entry
 01h	BYTE  length of XAR in Logical Block Numbers
 02h	DWORD LBN of data, Intel (little-endian) format
 06h	DWORD LBN of data, Motorola (big-endian) format
 0Ah	DWORD length of file, Intel format
 0Eh	DWORD length of file, Motorola format
---High Sierra---
 12h  6 BYTEs date and time
 18h	BYTE  bit flags
 19h	BYTE  reserved
---ISO 9660---
 12h  7 BYTEs date and time
 19h	BYTE  bit flags
---both formats---
 1Ah	BYTE  interleave size
 1Bh	BYTE  interleave skip factor
 1Ch	WORD  volume set sequence number, Intel format
 1Eh	WORD  volume set sequence number, Motorola format
 20h	BYTE  length of file name
 21h  N BYTEs file name
	BYTE (optional) padding if filename is odd length
      N BYTEs system data

Format of CD-ROM directory entry (canonicalized):
Offset	Size	Description	(Table 1290)
 00h	BYTE	length of XAR in Logical Block Numbers
 01h	DWORD	Logical Block Number of file start
 05h	WORD	size of disk in logical blocks
 07h	DWORD	file length in bytes
 0Bh  7 BYTEs	date and time
 12h	BYTE	bit flags
 13h	BYTE	interleave size
 14h	BYTE	interleave skip factor
 15h	WORD	volume set sequence number
 17h	BYTE	length of file name
 18h 38 BYTEs	ASCIZ filename
 3Eh	WORD	file version number
 40h	BYTE	number of bytes of system use data
 41h 220 BYTEs	system use data
--------d-2F1510-----------------------------
INT 2F - CD-ROM v2.10+ - SEND DEVICE DRIVER REQUEST
	AX = 1510h
	CX = CD-ROM drive letter (0 = A, 1 = B, etc)
	ES:BX -> CD-ROM device driver request header (see #1265 at AX=0802h)
--------W-2F1600-----------------------------
INT 2F - MS Windows - WINDOWS ENHANCED MODE INSTALLATION CHECK
	AX = 1600h
Return: AL = status
	    00h neither Windows 3.x enhanced mode nor Windows/386 2.x running
	    01h Windows/386 2.x running
	    80h XMS version 1 driver installed (neither Windows 3.x enhanced
		  mode nor Windows/386 2.x running) (obsolete--see note)
	    FFh Windows/386 2.x running
	AL = anything else
	    AL = Windows major version number >= 3
	    AH = Windows minor version number
Notes:	INT 2F/AH=16h comprises an API for non-Windows programs (DOS device
	  drivers, TSRs, and applications) to cooperate with multitasking
	  Windows/386 2.x and Windows 3.x and higher enhanced mode.
	certain calls are also supported in the Microsoft 80286 DOS extender in
	  Windows standard mode
	this function served as the installation check and AX=1610h served to
	  get the driver entry point for XMS version 1, which is now obsolete.
	  Use AX=4300h and AX=4310h instead
SeeAlso: AX=160Ah,AX=1610h,AX=4300h,AX=4680h
Index:	installation check;XMS version 1
--------W-2F1602-----------------------------
INT 2F - MS Windows/386 2.x - GET API ENTRY POINT
	AX = 1602h
Return: ES:DI -> Windows/386 2.x API procedure entry point
Notes:	this interface is supported in Windows 3.x only for 2.x compatibility
	to get the current virtual machine (VM) ID in Windows/386 2.x:
	    AX = 0000h
	    ES:DI -> return address
	    JUMP to address returned from INT 2F/AX=1602h
	After JUMP, at return address:
	    BX = current VM ID.
SeeAlso: AX=C020h
--------W-2F1603-----------------------------
INT 2F - MS Windows/386 - GET INSTANCE DATA
	AX = 1603h
Return: AX = 5248h ('RH') if supported
	    DS:SI -> Windows/386 instance data (see #1291)
Notes:	reportedly supported by RM Nimbus MS-DOS 3.3 kernel
	this function is called by DOSMGR when AX=1607h/BX=0015h is not
	  supported, as is the case in DOS versions prior to 5.0
	see Geoff Chappell's book _DOS_Internals_ for additional discussions of
	  this function, DOSMGR's behavior, and instancing in general
SeeAlso: AX=1607h/BX=0015h

Format of Windows/386 instance data:
Offset	Size	Description	(Table 1291)
 00h	WORD	segment of IO.SYS (0000h = default 0070h)
 02h	WORD	offset in IO.SYS of STACKS data structure (DOS 3.2x)
		0000h if not applicable
 04h	WORD	number of instance data entries (max 32)
 06h	Array of instance data entries
	Offset	Size	Description
	 00h	WORD	segment (0002h = DOS kernel)
	 02h	WORD	offset
	 04h	WORD	size
--------W-2F1605-----------------------------
INT 2F - MS Windows - WINDOWS ENHANCED MODE & 286 DOSX INIT BROADCAST
	AX = 1605h
	ES:BX = 0000h:0000h
	DS:SI = 0000h:0000h
	CX = 0000h
	DX = flags
	    bit 0 = 0 if Windows enhanced-mode initialization
	    bit 0 = 1 if Microsoft 286 DOS extender initialization
	    bits 1-15 reserved (undefined)
	DI = version number (major in upper byte, minor in lower)
Return: CX = 0000h if okay for Windows to load
	CX = FFFFh (other registers unchanged) if Windows 3.0 in standard mode
	CX <> 0 if Windows should not load
	ES:BX -> startup info structure (see #1292)
	DS:SI -> virtual86 mode enable/disable callback or 0000h:0000h
Notes:	the Windows enhanced mode loader and Microsoft 286 DOS extender will
	  broadcast an INT 2F/AX=1605h call when initializing.	Any DOS device
	  driver or TSR can watch for this broadcast and return the appropriate
	  values.  If the driver or TSR returns CX <> 0, it is also its
	  responsibility to display an error message.
	each handler must first chain to the prior INT 2F handler with
	  registers unchanged before processing the call
	if the handler requires local data on a per-VM basis, it must store the
	  returned ES:BX in the "next" field of a startup info structure and
	  return a pointer to that structure in ES:BX
	a single TSR may set the V86 mode enable/disable callback; if DS:SI is
	  already nonzero, the TSR must fail the initialization by setting CX
	  nonzero
	MSD checks for Windows 3.0 running in standard mode by testing whether
	  CX=FFFFh and other registers are unchanged on return
SeeAlso: AX=1606h,AX=1608h,AX=4B05h

Format of Windows Startup Information Structure:
Offset	Size	Description	(Table 1292)
 00h  2 BYTEs	major, minor version of info structure
 02h	DWORD	pointer to next startup info structure or 0000h:0000h
 06h	DWORD	pointer to ASCIZ name of virtual device file or 0000h:0000h
 0Ah	DWORD	virtual device reference data (see #1294)
		(only used if above nonzero)
 0Eh	DWORD	pointer to instance data records (see #1293) or 0000h:0000h

Format of one Instance Item in array:
Offset	Size	Description	(Table 1293)
 00h	DWORD	address of instance data (end of array if 0000h:0000h)
 04h	WORD	size of instance data

Format of Virtual Device Reference Data:
Offset	Size	Description	(Table 1294)
 00h	DWORD	physical address of ??? or 00000000h
 04h	DWORD	physical address of ??? table
 08h	DWORD	"DEST_PAGE" address to which pages must be mapped
 0Ch  N DWORDs	"SRC_PAGE" physical addresses of the pages
		00000000h = end of table
Note:	EMM386.EXE sets the first pointer to the start of the device driver
	  chain, the second pointer to a field of 40h bytes followed by a
	  16-bit offset to the end of the SRC_PAGE table, and DEST_PAGE to
	  the start segment of the UMB area

(Table 1295)
Values Windows virtual mode enable/disable procedure is called with:
	AX = 0000h disable V86 mode
	AX = 0001h enable V86 mode
	interrupts disabled
Return: CF set on error
	CF clear if successful
	interrupts disabled
--------W-2F1606-----------------------------
INT 2F - MS Windows - WINDOWS ENHANCED MODE & 286 DOSX EXIT BROADCAST
	AX = 1606h
	DX = flags
	    bit 0 = 0 if Windows enhanced-mode exit
	    bit 0 = 1 if Microsoft 286 DOS extender exit
	    bits 1-15 reserved (undefined)
Notes:	if the init broadcast fails (AX=1605h returned CX <> 0), then this
	  broadcast will be issued immediately.
	this call will be issued in real mode
SeeAlso: AX=1605h,AX=1609h
--------W-2F1607-----------------------------
INT 2F - MS Windows - VIRTUAL DEVICE CALL OUT API
	AX = 1607h
	BX = virtual device ID (see INT 2F/AX=1684h)
	CX = (usually) callout subfunction
Return: (usually) AX,BX,CX,DX,ES contain results
Notes:	more of a convention than an API, this call specifies a standard
	  mechanism for Windows enhanced-mode virtual devices (VxD's) to talk
	  to DOS device drivers and TSRs
	see below for details on several virtual devices
SeeAlso: AX=1605h,AX=1607h/BX=000Ch,AX=1607h/BX=0014h,AX=1607h/BX=0015h
SeeAlso: AX=1684h,AX=C020h
--------W-2F1607BX0006-----------------------
INT 2F - MS Windows - "V86MMGR" VIRTUAL DEVICE API
	AX = 1607h
	BX = 0006h (VxD identifier of "V86MMGR")
	CX = 0000h
Return: AX = status
	    0000h if local A20 state changed
	    1607h if A20 unchanged
	    other if global A20 state changed
--------W-2F1607BX000C-----------------------
INT 2F - MS Windows - "VMD" VIRTUAL MOUSE DEVICE API
	AX = 1607h
	BX = 000Ch (VxD identifier of "VMD")
Return: CX = nonzero if mouse driver already virtualized
Note:	VMD (Virtual Mouse Driver) calls this and then checks whether CX is
	  nonzero; if yes, it will not automatically virtualize the mouse
	  driver.  This would be used if MOUSE.COM already virtualizes
	  itself using the Windows API.
SeeAlso: AX=1607h/BX=0014h,AX=1607h/BX=0015h
----------2F1607BX0010-----------------------
INT 2F C - MS Windows 3.1 - "BLOCKDEV" VIRTUAL HARD DISK DEVICE API
	AX = 1607h
	BX = 0010h (VxD identifier of "BLOCKDEV")
	CX = function
	    0001h starting FastDisk compatibility tests
	    0002h ending FastDisk compatibility tests
	    0003h check if FastDisk installation allowed
		Return: CX = 0000h if allowed
Note:	this interface is called by the Windows FastDisk driver (such as
	  WDCTRL) when it thinks that the INT 13h handler immediately below
	  IO.SYS's INT 13h code is not in ROM; it should be supported by any
	  program which hooks itself underneath IO.SYS's INT 13h code with
	  INT 2F/AH=13h
SeeAlso: AX=1607h/BX=0014h,INT 2F/AH=13h
--------W-2F1607BX0014-----------------------
INT 2F - MS Windows - "VNETBIOS" VIRTUAL DEVICE API
	AX = 1607h
	BX = 0014h (VxD identifier of "VNETBIOS")
Return: ES:DI -> 128-byte table specifying VNETBIOS actions for each NetBIOS
		command code (see #1296)
Note:	VNETBIOS (Virtual NetBIOS) calls this function to determine whether
	  the NetBIOS has an extensions Windows should know about
SeeAlso: AX=1607h/BX=000Ch,AX=1607h/BX=0010h,AX=1607h/BX=0015h

(Table 1296)
Values for VNETBIOS action code:
 00h	"VN_Unknown" unknown command
 04h	"VN_No_Map"  no memory mapping necessary
 08h	"VN_Map_In"  input buffer is quickly used, so no global mapping needed
 0Ch	"VN_Map_In"  output buffer is quickly used, so no global mapping needed
 10h	"VN_Map_In_Out"	 buffer is quickly used, so no global mapping needed
 14h	"VN_Chain_Send"	 the chain-send command
 18h	"VN_Cancel"	special case for cancel command
 1Ch	"VN_Buffer_In"	buffer is incoming
 20h	"VN_Buffer_Out" buffer is outgoing
 24h	"VN_Buffer_In_Out" buffer used for both incoming and outgoing data
--------D-2F1607BX0015-----------------------
INT 2F C - MS Windows - "DOSMGR" VIRTUAL DEVICE API
	AX = 1607h
	BX = 0015h (VxD identifier of "DOSMGR")
	CX = function
	    0000h query instance processing
		DX = 0000h
		Return: CX = state
			    0000h not instanced
			    other instanced (DOS 5+ kernel returns 0001h)
				DX = segment of DOS drivers or 0000h for
					default of 0070h
				ES:BX -> patch table (see #1298)
	    0001h set patches in DOS
		DX = bit mask of patch requests (see #1297)
		Return: AX = B97Ch
			BX = bit mask of patches applied (see #1297)
			DX = A2ABh
	    0002h remove patches in DOS (ignored by DOS 5.0 kernel)
		DX = bit mask of patch requests (see function 0001h)
		Return: CX = 0000h (DOS 5-6)
		Note:	return values are ignored by DOSMGR in Windows 3.1
	    0003h get size of DOS data structures
		DX = bit mask of request (only one bit can be set)
		    bit 0: Current Directory Structure size
		Return: if supported request:
			    AX = B97Ch
			    CX = size in bytes of requested structure
			    DX = A2ABh
			else:
			    CX = 0000h
			    all other registers preserved
	    0004h determine instanced data structures
		Return: AX = B97Ch if supported
			DX = A2ABh if supported (DOS 5+ kernel returns 0000h)
			BX = bit mask of instanced items
			    bit 0: CDS
			    bit 1: SFT
			    bit 2: device list
			    bit 3: DOS swappable data area
	    0005h get device driver size
		ES = segment of device driver
		Return: DX:AX = 0000h:0000h on error (not dev. driver segment)
			DX:AX = A2ABh:B97Ch if successful
			    BX:CX = size of device driver in bytes
Notes:	DOSMGR (DOS Manager) will check whether the OEM DOS/BIOS data has
	  been instanced via this API and will not perform its own default
	  instancing of the normal DOS/BIOS data if so; if this API is not
	  supported, DOSMGR will also try to access instancing data through
	  INT 2F/AX=1603h
	these functions are supported by the DOS 5+ kernel; DOSMGR contains
	  tables of instancing information for earlier versions of DOS
	see Geoff Chappell's book _DOS_Internals_ for additional discussions of
	  DOSMGR's behavior and instancing in general
SeeAlso: AX=1603h,AX=1605h,AX=1607h/BX=000Ch,AX=1607h/BX=0014h,AX=1684h

Bitfields for DOSMGR patch requests:
Bit(s)	Description	(Table 1297)
 0	enable critical sections
 1	NOP setting/checking user ID
 2	turn INT 21/AH=3Fh on STDIN into polling loop
 3	trap stack fault in "SYSINIT" to WIN386
 4	BIOS patch to trap "Insert disk X:" to WIN386

Format of DOSMGR patch table:
Offset	Size	Description	(Table 1298)
 00h  2 BYTEs	DOS version (major, minor)
 02h	WORD	offset in DOS data segment of "SAVEDS"
 04h	WORD	offset in DOS data segment of "SAVEBX"
 06h	WORD	offset in DOS data segment of InDOS flag
 08h	WORD	offset in DOS data segment of User ID word
 0Ah	WORD	offset in DOS data segment of "CritPatch" table to enable
		  critical section calls (see INT 2A/AH=80h)
 0Ch	WORD	(DOS 5+ only) offset in DOS data segment of "UMB_HEAD",
		  containing segment of last MCB in conventional memory
--------E-2F1607BX22C0-----------------------
INT 2F - Rational Systems DOS/4GW - ???
	AX = 1607h
	BX = 22C0h
	???
Return: ???
SeeAlso: INT 15/AX=BF02h,INT 15/AX=BF04h
--------W-2F1608-----------------------------
INT 2F C - MS Windows - WINDOWS ENHANCED MODE INIT COMPLETE BROADCAST
	AX = 1608h
Notes:	called after all installable devices have been initialized
	real-mode software may be called between the Windows enhanced-mode init
	  call (AX=1605h) and this call; the software must detect this
	  situation
SeeAlso: AX=1605h,AX=1609h
--------W-2F1609-----------------------------
INT 2F C - MS Windows - WINDOWS ENHANCED MODE BEGIN EXIT BROADCAST
	AX = 1609h
Note:	called at the beginning of a normal exit sequence; not made in the
	  event of a fatal system crash
SeeAlso: AX=1606h,AX=1608h
--------W-2F160A-----------------------------
INT 2F - MS Windows 3.1 - IDENTIFY WINDOWS VERSION AND TYPE
	AX = 160Ah
Return: AX = 0000h if call supported
	    BX = version (BH=major, BL=minor)
	    CX = mode (0002h = standard, 0003h = enhanced)
SeeAlso: AX=1600h,AX=4680h
--------W-2F160B-----------------------------
INT 2F - MS Windows 3.1 - IDENTIFY TSRs
	AX = 160Bh
	ES:DI -> communication structure (see #1299) or 0000h:0000h
Return: ES:DI -> communication structure
Desc:	this call allows Windows-aware TSRs to make themselves known to
	  Windows.
Note:	the TSR should allocate a communication structure, place the given
	  ES:DI pointer in the first field, and return a pointer to the new
	  structure
SeeAlso: AX=1605h,AX=160Ch,AX=4B01h,AX=4B05h

Format of TSR-to-Windows communication structure:
Offset	Size	Description	(Table 1299)
 00h	DWORD	pointer to next structure
 04h	WORD	PSP segment
 06h	WORD	API version ID (0100h)
 08h	WORD	EXEC flags
		bit 0: "WINEXEC"
		bit 1: "LOADLIBRARY"
		bit 2: "OPENDRIVER"
 0Ah	WORD	"exec_cmd_show"
 0Ch	DWORD	"exec_cmd"
 10h  4 BYTEs	reserved (0)
 14h	DWORD	pointer to TSR ID block (see #1300)
 18h	DWORD	pointer to TSR data block or 0000h:0000h

Format of Norton Utilities 6.0 TSR ID block:
Offset	Size	Description	(Table 1300)
 00h	WORD	length of name string
 02h  N BYTEs	name of TSR's executable
--------W-2F160C-----------------------------
INT 2F - MS Windows 3.1 - DETECT ROMs
	AX = 160Ch
	???
Return: ???
Note:	used by ROM Windows
SeeAlso: AX=160Bh
--------m-2F1610-----------------------------
INT 2F - XMS v1.x only - GET DRIVER ADDRESS
	AX = 1610h
	details unavailable
Note:	this function and AX=1600h were only used in XMS version 1 and are now
	  obsolete.  Use AX=4300h and AX=4310h instead
SeeAlso: AX=1600h,AX=4310h
--------W-2F1680-----------------------------
INT 2F - MS Windows, DPMI, various - RELEASE CURRENT VIRTUAL MACHINE TIME-SLICE
	AX = 1680h
Return: AL = status
	    00h if the call is supported
	    80h (unchanged) if the call is not supported
Notes:	programs can use this function in idle loops to enhance performance
	  under multitaskers; this call is supported by MS Windows 3.0, DOS 5+,
	  DPMI 1.0+, and will be supported in OS/2 2.0 for multitasking DOS
	  applications
	does not block the program; it just gives up the remainder of the time
	  slice
	should not be used by Windows-specific programs
	when called very often without intermediate screen output under WIN 3+,
	  the VM will go into an idle-state and will not receive the next slice
	  before 8 seconds. This time can be changed in SYSTEM.INI through
	  "IdleVMWakeUpTime=<seconds>". Setting to zero results in a long wait.
SeeAlso: INT 15/AX=1000h,INT 15/AX=5305h,INT 21/AH=89h,INT 7A/BX=000Ah
--------W-2F1681-----------------------------
INT 2F - MS Windows 3+ - BEGIN CRITICAL SECTION
	AX = 1681h
Notes:	used to prevent a task switch from occurring
	should be followed by an INT 2F/AX=1682h call as soon as possible
	nested calls are allowed, and must be followed by an appropriate number
	  of "end critical section" calls
	not supported in Windows/386 2.x. Get INDOS flag with INT 21/AH=34h and
	  increment by hand.
SeeAlso: AX=1682h,INT 15/AX=101Bh,INT 21/AH=34h
--------W-2F1682-----------------------------
INT 2F - MS Windows 3+ - END CRITICAL SECTION
	AX = 1682h
Notes:	not supported in Windows/386 2.x.  Get InDOS flag with INT 21/AH=34h
	  and decrement by hand, taking care not to decrement InDOS flag
	  through zero
SeeAlso: AX=1681h,INT 15/AX=101Ch,INT 21/AH=34h
--------W-2F1683-----------------------------
INT 2F - MS Windows 3+ - GET CURRENT VIRTUAL MACHINE ID
	AX = 1683h
Return: BX = current virtual machine (VM) ID
Notes:	Windows itself currently runs in VM 1, but this can't be relied upon
	VM IDs are reused when VMs are destroyed
	an ID of 0 will never be returned
SeeAlso: AX=1684h,AX=1685h,AX=168Bh
--------W-2F1684-----------------------------
INT 2F - MS Windows - GET DEVICE API ENTRY POINT
	AX = 1684h
	BX = virtual device (VxD) ID (see #1301)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point, or 0:0 if the VxD does not support an API
Note:	some Windows enhanced-mode virtual devices provide services that
	  applications can access.  For example, the Virtual Display Device
	  (VDD) provides an API used in turn by WINOLDAP.
SeeAlso: AX=1683h

(Table 1301)
Values for MS Windows VxD ID:
Value	Name   CallOut V86 PM	Description
 0000h	LPT	    N	N  N	DOS386 LPT Device (Windows for Workgroups 3.11)
 0000h	MSODISUP    N	N  N	MS ODI Support (Windows for Workgroups 3.11)
 0000h	NWNBLINK    N	N  N	Netware NetBIOS (Windows for Workgroups 3.11)
 0000h	SERIAL	    N	N  N	DOS386 Serial Device (Windows for Workgrp 3.11)
 0001h	VMM		N  N	Virtual Machine Manager
 0002h	Debug
 0003h	VPICD		Y  Y	Virtual Prog. Interrupt Controller (PIC) Device
 0004h	VDMAD		N  N	Virtual Direct Memory Access (DMA) Device
 0005h	VTD		Y  Y	Virtual Timer Device
 0006h	V86MMGR	    Y	N  N	Virtual 8086 Mode Device
 0007h	PageSwap	N  N	Paging Device
 0008h	Parity		N  N	Parity-check trapper
 0009h	Reboot		N  Y	Ctrl-Alt-Del handler
 000Ah	VDD		N  Y	Virtual Display Device (GRABBER)
 000Bh	VSD		N  N	Virtual Sound Device
 000Ch	VMD	    Y	Y  Y	Virtual Mouse Device
 000Dh	VKD		N  Y	Virtual Keyboard Device
 000Eh	VCD		N  Y	Virtual COMM Device
 000Fh	VPD			Virtual Printer Device
 0010h	VHD			Virtual Hard Disk Device (Windows 3.0)
 0010h	BLOCKDEV	N  N	Virtual Hard Disk Device (Windows 3.1)
 0010h	IOS	    N	N  N	DOS386 IOS Device (Windows for Workgroups 3.11)
 0010h	IOS		N  Y	(Chicago)
 0011h	VMCPD		Y  Y	Virtual Math CoProcessor Device
 0012h	EBIOS		N  N	Reserve EBIOS page (e.g., on PS/2)
 0013h	BIOSXLAT	N  N	Map ROM BIOS API between prot & V86 mode
 0014h	VNETBIOS    Y	N  N	Virtual NetBIOS Device
 0015h	DOSMGR	    Y	Y  N	DOS data instancing
 0016h	WINLOAD
 0017h	SHELL		N  Y
 0018h	VMPOLL		N  N
 0019h	VPROD
 001Ah	DOSNET		N  N	assures network integrity across VMs
 001Ah	VNETWARE	Y  Y	Novell NetWare DOSNET replacement
 001Bh	VFD		N  N	Virtual Floppy Device
 001Ch	VDD2			Secondary display adapter
 001Ch	LoadHi		N  N	Netroom LoadHi Device (RMLODHI.VXD)
 001Ch	LoadHi		N  N	386MAX LoadHi Device (386MAX.VXD)
 001Ch	LoadHi		N  N	Win386 LoadHi Device (EMM386.EXE)
 001Dh	WINDEBUG	N  Y
 001Dh	TDDebug		N  Y
 001Eh	TSRLoad			TSR instance utility
 001Fh	BiosHook		BIOS interrupt hooker VxD
 0020h	Int13	    N	N  N
 0021h	PageFile	N  Y	Paging File device
 0022h	SCSI
 0023h	MCA_POS
 0024h	SCSIFD			SCSI FastDisk device
 0025h	VPEND			Pen device
 0026h	APM			Advanced Power Management
 0027h	VXDLDR	     N	Y  Y	VXDLDR (Windows for Workgroups 3.11)
 0028h	NDIS	     N	Y  Y	Network Driver Interface Specification
				  (Windows for Workgroups 3.11)
 002Ah	VWIN32		N  Y	(Chicago)
 002Bh	VCOMM	     N	Y  Y	DOS386 VCOMM Device (Windows for Workgrps 3.11)
 0030h	MACH32		N  Y	ATI Mach32 video card
 0030h	MACH32	     N	N  Y	ATI MACH32
 0031h	NETBEUI	     N	N  N	NETBEUI (Windows for Workgroups 3.11)
 0032h	SERVER	     N	Y  Y	Int21 File Server (Windows for Workgroups 3.11)
 0033h	CONFIGMG	Y  Y	(Chicago)
 0033h	EDOS		N  N	Windows DOS Box Enhancer by Mom's Software
 0036h	VFBACKUP	Y  Y	(Chicago)
 0038h	VCOND		Y  Y	(Chicago)
 003Ah	VPMTD	     N	N  Y	IFAX Scheduler Device (Windows for Workgr 3.11)
 0051h	ISAPNP		N  N
 008Dh	ESDI_506	N  N	(Chicago)
 0090h	voltrack	N  N
 00FDh	FAKEIDE		N  N	(Chicago)
 0102h	CV1		N  N	Microsoft C/C++ 7.00+ CodeView for Windows
 0200h	VIPX		Y  Y	NetWare Virtual IPX Driver
 0200h	VIPX		Y  Y	Netware VIPX
 0201h	VNWLSERV	N  N	NetWare Lite 1.1 Server (SERVER.EXE)
 0202h	WINICE		Y  Y	SoftICE/W
 0203h	VCLIENT		N  Y	NetWare Lite 1.1+ Client
 0205h	VCAFT		N  N	Novell Virtual CAFT Driver (LANalyzer for Win)
 0206h	VTXRX		N  N	Novell Virtual TXRX Driver (LANalyzer for Win)
 0234h	VCOMMUTE	Y  Y	PC Tools Commute
 0442h	VTDAPI		N  Y	MMSys Win386 VTAPI Device
 0444h	VADMAD			Autoinitialize DMA (Windows 3.0)
 0445h	VSBD		Y  Y	WinResKit: Sound Blaster Device
 0460h	UNIMODEM	N  Y
 0480h	VNetSup	     N	Y  Y	Virtual Net Support (Windows for Workgrps 3.11)
 0481h	VRedir	     N	N  N	Redirector File System Driver
				  (Windows for Workgroups 3.11)
 0483h	VSHARE		N  N	Windows for Workgroups Virtual SHARE
 0484h	IFSMgr	     Y	Y  N	Installable File System Manager
				  (Windows for Workgroups 3.11)
 0486h	VFAT	     N	Y  Y	Win386 HPFS Driver (Windows for Workgrps 3.11)
 048Bh	VCache	     N	Y  Y	Virtual File Cache (Windows for Workgrps 3.11)
 048Bh	VCACHE		Y  Y
 1021h	VMB		Y  Y	Microsoft C/C++ 7.00 WXSRVR
 1022h	Vpfd		Y  Y	Microsoft C/C++ 7.00
 1025h	MMD		Y  Y	Microsoft C/C++ 8.00, Visual C/C++ 1.00
 21EAh	VADLIBWD	N  Y	Adlib Waveform Driver by John Ridges
 2200h	VFINTD		Y  Y	Norton VFINTD (Norton Desktop)
 22C0h	???	    Y		Rational Systems DOS/4GW ??? 
 2402h	ZMAX		N  N	Qualitas 386MAX v7 DOSMAX handler
 24A0h	VNSS		N  Y	Norton Screen Saver (Norton Desktop)
 24A1h	VNDWD		Y  Y	Norton VNDWD Device (Norton Desktop)
 2640h	VASBID		N  Y	WinResKit: Artisoft Sounding Board Device
 2860h	COMMTASK    N	N  Y	Windows 386-mode preemptive tasker by James
				  A. Kenemuth of Interabang Computing
 28C0h	VXD	    N	Y  Y	Generic VxD for real and protected mode by
				  Andrew Schulman in MSJ February 1993
 2925h	EDOS		Y  Y	Enhanced DOS by Firefly Software
 292Dh	VSBPD		Y  Y	Sound Blaster Pro
 3098h	VstlthD	    N	N  N	for QEMM Stealth ROM mode
 310Eh	WPS		N  N	MS DevNet CD-ROM: Windows Process Status
 7FE0h	VWFD	    N	Y  Y	??? by Neil Sandlin of Microsoft
 7FE1h	VWATCHD	    N	Y  Y	basic driver w/ no functionality except tracing
				  by Keith Jin of Microsoft PSS
 7FE5h	VFINTD	    N	Y  Y	Virtual Floppy Interrupt trapper by Neil
				  Sandlin of Microsoft
 7FE7h	VMPAGES	    N	Y  Y	demonstration of exporting VxD services, by
				  Neil Sandlin of Microsoft
 7FE9h	VIdleD	    N	N  N	demonstration of Call_When_Idle function, by
				  Bernie McIlroy of Microsoft
 7FEBh	VMIOD	    N	N  N	Virtual Monitor I/O Traffic Device, by Neil
				  Sandlin of Microsoft
 7FEDh	VMIRQD	    N	N  N	Virtual Monitor IRQ Traffic Device, by Neil
				  Sandlin of Microsoft
 8888h	VbillD			Bill Potvin II's for reversing Compaq LTE video
Note:	The high bit of the VxD ID is reserved for future use. The
	next 10 bits are the OEM number which is assigned by Microsoft. The
	low 5 bits are the device number.  Naturally, this scheme has not
	been adhered to since there are now more than 32 different VxDs.

(Table 1302)
Call VTD.386 entry point with:
	AX = 0000h get VTD version number
	    Return: AH = major version
		    AL = minor version
	AX = 0100h get current clock tick time
	    Return: EDX:EAX = clock tick time in 840ns units since Windows was
				started
	AX = 0101h get current system time in milliseconds
	    Return: EAX = time in milliseconds that Windows has been running
	AX = 0102h get current virtual machine time
	    Return: EAX = cumulative amount of time the virtual machine has
			been active, in milliseconds
Note:	should only be called directly when TOOLHELP.DLL TimerCount() cannot
	  be called

(Table 1303)
Call DOSMGR entry point with:
	AX = 0000h get DOSMGR version
	    Return: CF clear
		    AX = version (AH = major, AL = minor)
	AX = 0001h set critical focus
	    Return: CF clear
	AX = 0002h crash current virtual machine
	    Return: never
	    Note:   displays message box stating that "application has been
		      stopped by the DOSMGR device"
	AX = 0003h enter critical section
	    Note:   this function assumes that the code for INT 2A/AX=8001h
		      and INT 2A/AX=8002h have been modified for Windows
	AX = 0004h get VM ID byte
	    Return: CF clear if successful
			ES:DI -> VM ID byte
		    CF set on error
	    Note:   this function fails if the INT 2A modifications have not
		      yet been applied
	AX = 0005h inform Windows of possible media change
	    BL = drive number (00h=A:)
	    Return: CF clear if successful
		    CF set on error

(Table 1304)
Call VADMAD entry point with:
	DX = operation
	    0000h set VADMAD mode
		AX = desired mode
	    0001h set VADMAD channel
		AX = desired channel
Note:	after setting mode/channel, start the DMA operation with an OUT to
	  I/O port 0Bh (channels 0-3) or D6h (channels 4-7)

(Table 1305)
Call VbillD entry point with:
	AX = function
	    0001h set reverse video
	    0002h set normal video
Return: ???
--------W-2F1685-----------------------------
INT 2F - MS Windows - SWITCH VMs AND CALLBACK
	AX = 1685h
	BX = VM ID of virtual machine to switch to
	CX = flags (see #1306)
	DX:SI = priority boost (see VMM.INC)
	ES:DI -> FAR procedure to callback
Return: CF set on error
	    AX = error code
		01h invalid VM ID
		02h invalid priority boost
		03h invalid flags
	CF clear if successful
	    event will be or has been called
Notes:	some DOS devices, such as networks, need to call functions in a
	  specific VM. This call forces the appropriate VM to be installed.
	the callback procedure must preserve all registers and return with IRET
SeeAlso: AX=1683h,INT 15/AX=1117h

Bitfields for VM switching flags:
Bit(s)	Description	(Table 1306)
 0	wait until interrupts enabled
 1	wait until critical section unowned
 2-15	reserved (zero)
--------E-2F1686-----------------------------
INT 2F - DOS Protected-Mode Interface - DETECT MODE
	AX = 1686h
Return: AX = 0000h if operating in protected mode under DPMI (INT 31 available)
	AX nonzero if in real/V86 mode or no DPMI (INT 31 not available)
SeeAlso: AX=1687h
--------E-2F1687-----------------------------
INT 2F - DOS Protected-Mode Interface - INSTALLATION CHECK
	AX = 1687h
Return: AX = 0000h if installed
	    BX = flags
		bit 0: 32-bit programs supported
	    CL = processor type (02h=80286, 03h=80386, 04h=80486)
	    DH = DPMI major version
	    DL = two-digit DPMI minor version (binary)
	    SI = number of paragraphs of DOS extender private data
	    ES:DI -> DPMI mode-switch entry point
	AX nonzero if not installed
SeeAlso: AX=1686h,AX=43E0h,AX=DE01h/BX=4450h,AX=FB42h/BX=0001h
SeeAlso: INT 31/AX=0400h,INT 31/AX=5702h,INT 38/AH=10h

(Table 1307)
Call DPMI mode switch entry point with:
	AX = flags
	    bit 0: set if 32-bit program
	ES = real mode segment of buffer for DPMI private data (ignored if
		SI was zero)
Return: CF set on error
	    program still in real mode
	    AX = error code (DPMI 1.0+)
	       8011h unable to allocate all necessary descriptors
	       8021h 32-bit program specified, but 16-bit DPMI host
	CF clear if successful
	    CS = 16-bit selector corresponding to real-mode CS
	    SS = selector corresponding to real-mode SS (64K limit)
	    DS = selector corresponding to real-mode DS (64K limit)
	    ES = selector to program's PSP (100h byte limit)
	    FS = GS = 0
	    high word of ESP = 0 if 32-bit program
	    program now in protected mode
Note:	this entry point is only called for the initial switch to protected
	  mode
--------W-2F1688-----------------------------
INT 2F U - MS Windows 3.0, 386MAX v6.01 - GET SELECTOR TO LDT
	AX = 1688h
Return: AX = status??? (0000h for 386MAX)
	BX = selector for LDT???
--------W-2F1689-----------------------------
INT 2F U - MS Windows 3.0+ - KERNEL IDLE CALL
	AX = 1689h
	???
Return: ???
SeeAlso: AX=1680h,INT 15/AX=1000h,INT 28
--------E-2F168A-----------------------------
INT 2F - DPMI 0.9+ - GET VENDOR-SPECIFIC API ENTRY POINT
	AX = 168Ah
	DS:(E)SI = selector:offset of ASCIZ vendor name
Return: AL = status
	    00h successful
	       ES:(E)DI -> extended API entry point
	    8Ah unsuccessful
Notes:	the vendor name is used to determine which entry point to return; it is
	  case-sensitive
	available in protected mode only
	32-bit applications use ESI and EDI, 16-bit applications use SI and DI
	this call is present but not documented for DPMI 0.9
	the Borland C++ 3.1 DPMILOAD does not handle requests for entry points
	  other than the MS-DOS one gracefully, producing an unhandled
	  exception report; this has been fixed in the Borland Pascal 7 version
SeeAlso: INT 31/AX=0A00h,INT 31/AH=57h

(Table 1308)
Values for DPMI vendor-specific API names:
 "MS-DOS"	??? and 386MAX v6.00+
 "386MAX"	386MAX v6.00+
 "HELIX_DPMI"	Helix Netroom's DPMI server
 "Phar Lap"	Phar Lap 286|DOS-Extender RUN286

(Table 1309)
Call Phar Lap RUN286 entry point with:
	AX = 0000h (function "load MSW")
	BX = new value for MSW register (low word of CR0)
Return: ???
--------W-2F168B-----------------------------
INT 2F - MS Windows 3.1 - SET FOCUS TO SPECIFIED VIRTUAL MACHINE
	AX = 168Bh
	BX = virtual machine ID (see AX=1683h), 0000h for current DOS box
Return: AL = 00h if focus set to specified VM
Notes:	documented on the Microsoft Developer's Network CD-ROM
	if the VM is a windowed DOS box, it will be set to full screen
SeeAlso: AX=1683h
--------W-2F168C-----------------------------
INT 2F - MS Windows 3.1 - RESTART COMMAND
	AX = 168Ch
	???
Return: ???
Note:	WIN.COM executes specified application
--------W-2F1700-----------------------------
INT 2F - MS Windows "WINOLDAP" - IDENTIFY WinOldAp VERSION
	AX = 1700h
Return: AX = 1700h if this version of WINOLDAP doesn't support clipboard
	AX <> 1700h
	    AL = WINOLDAP major version
	    AH = WINOLDAP minor version
Program: WinOldAp (WINOLDAP.MOD) is a Microsoft Windows extension supporting
	  "old" (character-mode) application access to Dynamic Data Exchange,
	  menus, and the Windows clipboard.
Note:	this installation check DOES NOT follow the format used by other
	  software of returning AL=FFh
SeeAlso: AX=1701h,AX=4601h
Index:	installation check;WINOLDAP
--------W-2F1701-----------------------------
INT 2F - MS Windows "WINOLDAP" - OPEN CLIPBOARD
	AX = 1701h
Return: AX = status
	    nonzero success
	    0000h   clipboard is already open
SeeAlso: AX=1700h,AX=1702h,AX=1703h,AX=1704h
--------W-2F1702-----------------------------
INT 2F - MS Windows "WINOLDAP" - EMPTY CLIPBOARD
	AX = 1702h
Return: AX = status
	    nonzero clipboard has been emptied
	    0000h   failure
SeeAlso: AX=1700h,AX=1701h,AX=1703h,AX=1704h
--------W-2F1703-----------------------------
INT 2F - MS Windows "WINOLDAP" - SET CLIPBOARD DATA
	AX = 1703h
	DX = clipboard format supported by WinOldAp (see #1310)
	ES:BX -> data (see #1311,#1312)
	SI:CX = size of data
Return: AX = status
	    nonzero data copied into the Clipboard
	    0000h   failure

(Table 1310)
Values for WinOldAp clipboard format:
 01h	text
 02h	bitmap
 03h	metafile picture
 04h	SYLK
 05h	DIF
 06h	TIFF
 07h	OEM text
 81h	DSP text
 82h	DSP bitmap

Format of Windows Clipboard bitmap:
Offset	Size	Description	(Table 1311)
 00h	WORD	type (0000h)
 02h	WORD	width of bitmap in pixels
 04h	WORD	height of bitmap in pixels
 06h	WORD	bytes per line
 08h	BYTE	number of color planes
 09h	BYTE	number of adjacent color bits in pixel
 0Ah	DWORD	pointer to start of data
 0Eh	WORD	width in 0.1mm units
 10h	WORD	height in 0.1mm units
 12h  N BYTEs	bitmap data

Format of Windows metafile picture:
Offset	Size	Description	(Table 1312)
 00h	WORD	mapping mode
 02h	WORD	X extent
 04h	WORD	Y extent
 06h	WORD	picture data
--------W-2F1704-----------------------------
INT 2F - MS Windows "WINOLDAP" - GET CLIPBOARD DATA SIZE
	AX = 1704h
	DX = clipboard format supported by WinOldAp (see #1310)
Return:	DX:AX = size of data in bytes, including any headers
		0000h:0000h if no data in this format in the Clipboard
Note:	Windows reportedly rounds up the size of the data to a multiple of 32
	  bytes
--------W-2F1705-----------------------------
INT 2F - MS Windows "WINOLDAP" - GET CLIPBOARD DATA
	AX = 1705h
	DX = clipboard format supported by WinOldAp (see #1310)
	ES:BX -> buffer
Return: AX = status
	    nonzero success
	    0000h   error, or no data in this format in Clipboard
--------W-2F1708-----------------------------
INT 2F - MS Windows "WINOLDAP" - CloseClipboard
	AX = 1708h
Return: AX = status
	    0000h failure
	    nonzero success
--------W-2F1709-----------------------------
INT 2F - MS Windows "WINOLDAP" - COMPACT CLIPBOARD
	AX = 1709h
	SI:CX = desired size in bytes
Return: DX:AX = number of bytes in largest block of free memory
Note:	WinOldAp is responsible for including the size of any headers
--------W-2F170A-----------------------------
INT 2F - MS Windows "WINOLDAP" - GET DEVICE CAPABILITIES
	AX = 170Ah
	DX = GDI information index (see #1313)
Return: AX = integer value of the desired item
	      (see #1314,#1315,#1316,#1317,#1318,#1319,#1320)
Note:	This function returns the device-capability bits for the given display

(Table 1313)
Values for GDI information index:
 00h	device driver version
 02h	device classification
 04h	width in mm
 06h	height in mm
 08h	width in pixels
 0Ah	height in pixels
 0Ch	bits per pixel
 0Eh	number of bit planes
 10h	number of brushes supported by device
 12h	number of pens supported by device
 14h	number of markers supported by device
 16h	number of fonts supported by device
 18h	number of colors
 1Ah	size required for device descriptor
 1Ch	curve capabilities
 1Eh	line capabilities
 20h	polygon capabilities
 22h	text capabilities
 24h	clipping capabilities
 26h	bitblt capabilities
 28h	X aspect
 2Ah	Y aspect
 2Ch	length of hypotenuse of aspect
 58h	logical pixels per inch of width
 5Ah	logical pixels per inch of height
SeeAlso: #1314,#1315,#1316,#1317,#1318,#1319,#1320

(Table 1314)
Values for device classification:
 00h	vector plotter
 01h	raster display
 02h	raster printer
 03h	raster camera
 04h	character-stream, PLP
 05h	Metafile, VDM
 06h	display-file
SeeAlso: #1313,#1315,#1316,#1317,#1318,#1319,#1320

Bitfields for curve capabilities:
Bit(s)	Description	(Table 1315)
 0	circles
 1	pie wedges
 2	chord arcs
 3	ellipses
 4	wide lines
 5	styled lines
 6	wide styled lines
 7	interiors
SeeAlso: #1313,#1314,#1316,#1317,#1318,#1319,#1320

Bitfields for line capabilities:
Bit(s)	Description	(Table 1316)
 1	polylines
 2	markers
 3	polymarkers
 4	wide lines
 5	styled lines
 6	wide styled lines
 7	interiors
SeeAlso: #1313,#1314,#1315,#1317,#1318,#1319,#1320

Bitfields for polygon capabilities:
Bit(s)	Description	(Table 1317)
 0	polygons
 1	rectangles
 2	trapezoids
 3	scanlines
 4	wide borders
 5	styled borders
 6	wide styled borders
 7	interiors
SeeAlso: #1313,#1314,#1315,#1316,#1318,#1319,#1320

Bitfields for text capabilities:
Bit(s)	Description	(Table 1318)
 0	output precision character
 1	output precision stroke
 2	clippping precision stroke
 3	90-degree character rotation
 4	arbitrary character rotation
 5	independent X and Y scaling
 6	double-size
 7	integer scaling
 8	continuous scaling
 9	bold
 10	italic
 11	underline
 12	strikeout
 13	raster fonts
 14	vector fonts
 15	reserved
SeeAlso: #1313,#1314,#1315,#1316,#1317,#1319,#1320

(Table 1319)
Values for clipping capabilities:
 00h	none
 01h	clipping to rectangles
SeeAlso: #1313,#1314,#1315,#1316,#1317,#1318,#1320

Bitfields for raster capabilities:
Bit(s)	Description	(Table 1320)
 0	simple bitBLT
 1	device requires banding support
 2	device requires scaling support
 3	supports >64K bitmap
SeeAlso: #1313,#1314,#1315,#1316,#1317,#1318,#1319
----------2F18-------------------------------
INT 2F U - MS-Manager
	AH = 18h
	???
Return: ???
--------l-2F1900-----------------------------
INT 2F U - DOS 4.x only SHELLB.COM - INSTALLATION CHECK
	AX = 1900h
Return: AL = status
	    00h not installed
	    FFh installed
--------l-2F1901-----------------------------
INT 2F U - DOS 4.x only SHELLB.COM - SHELLC.EXE INTERFACE
	AX = 1901h
	BL = SHELLC type
	    00h transient
	    01h resident
	DS:DX -> far call entry point for resident SHELLC.EXE
Return: ES:DI -> SHELLC.EXE workspace within SHELLB.COM
Note:	SHELLB.COM and SHELLC.EXE are parts of the DOS 4.x shell
--------l-2F1902-----------------------------
INT 2F U - DOS 4.x only SHELLB.COM - COMMAND.COM INTERFACE
	AX = 1902h
	ES:DI -> ASCIZ full filename of current batch file, with at least the
		  final filename element uppercased
	DS:DX -> buffer for results
Return: AL = 00h  failed, either
		(a) final filename element quoted at ES:DI does not match
		      identity of shell batch file quoted as parameter of most
		      recent call of SHELLB command, or
		(b) no more Program Start Commands available.
	AL= FFh	 success, then:
		memory at DS:[DX+1] onwards filled as:
		DX+1:	BYTE	count of bytes of PSC
		DX+2: N BYTEs	Program Start Command text
			BYTE	0Dh terminator
Desc:	COMMAND.COM executes the result of this call in preference to
	  reading a command from a batch file.	Thus the batch file does not
	  advance in execution for so long as SHELLB provides PSCs from its
	  workspace.
Note:	The PSCs are planted in SHELLB workspace by SHELLC, the user
	  menu interface.  The final PSC of a sequence is finished with a
	  GOTO COMMON, which causes a loop back in the batch file which called
	  SHELLC so as to execute SHELLC again.	 The check on batch file name
	  permits PSCs to CALL nested batch files while PSCs are still stacked
	  up for subsequent execution.
--------l-2F1903-----------------------------
INT 2F U - DOS 4.x only SHELLB.COM - COMMAND.COM interface
	AX = 1903h
	ES:DI -> ASCIZ batch file name as for AX=1902h
Return: AL = status
	    FFh quoted batch file name matches last SHELLB parameter
	    00h it does not
--------l-2F1904-----------------------------
INT 2F U - DOS 4.x only SHELLB.COM - SHELLB transient to TSR intrface
	AX = 1904h
Return: ES:DI -> name of current shell batch file:
		WORD	number of bytes of name following
		BYTEs	(8 max) uppercase name of shell batch file
--------V-2F1A00-----------------------------
INT 2F - DOS 4+ ANSI.SYS - INSTALLATION CHECK
	AX = 1A00h
Return: AL = FFh if installed
Notes:	AVATAR.SYS also responds to this call
	documented for DOS 5+, but undocumented for DOS 4.x
--------V-2F1A00BX414E-----------------------
INT 2F - ANSIPLUS.SYS - INSTALLATION CHECK
	AX = 1A00h
	BX = 414Eh ('AN')
	CX = 5349h ('SI')
	DX = 2B2Bh ('++')
Return: AL = FFh if installed
	    CF clear
	    ES:BX -> INT 29 entry point
Program: ANSIPLUS.SYS is a CON device driver by Kristofer Sweger which
	  replaces the normal ANSI.SYS is a more powerful version with many
	  additional features
Note:	ANSIPLUS also identifies itself as ANSI.SYS if BX,CX, or DX differ
	  from the magic values above
--------V-2F1A00BX4156-----------------------
INT 2F - AVATAR.SYS - INSTALLATION CHECK
	AX = 1A00h
	BX = 4156h ('AV')
	CX = 4154h ('AT')
	DX = 4152h ('AR')
Return: AL = FFh if installed
	    CF clear
	    BX = AVATAR protocol level supported
	    CX = driver type
		0000h AVATAR.SYS
		4456h DVAVATAR.COM inside DESQview window
	    DX = 0016h
Program: AVATAR.SYS is a CON replacement by George Adam Stanislav which
	  interprets AVATAR command codes in the same way that ANSI interprets
	  ANSI command codes
Notes:	AVATAR also identifies itself as ANSI.SYS if BX, CX, or DX differ from
	  the magic values
--------V-2F1A01-----------------------------
INT 2F U - DOS 4+ ANSI.SYS internal - GET/SET DISPLAY INFORMATION
	AX = 1A01h
	CL = function
	    7Fh for GET
	    5Fh for SET
	DS:DX -> parm block as for INT 21,AX=440Ch,CX=037Fh/035Fh respectively
Return: CF set on error
	    AX = error code (many non-standard)
	CF clear if successful
	    AX destroyed
Note:	presumably this is the DOS IOCTL interface to ANSI.SYS
SeeAlso: AX=1A02h,INT 21/AX=440Ch
--------V-2F1A02-----------------------------
INT 2F U - DOS 4+ ANSI.SYS internal - MISCELLANEOUS REQUESTS
	AX = 1A02h
	DS:DX -> parameter block (see #1321)
Note:	DOS 5+ chains to previous handler if AL > 02h on call
SeeAlso: AX=1A01h

Format of ANSI.SYS parameter block:
Offset	Size	Description	(Table 1321)
 00h	BYTE	subfunction
		00h set/reset interlock
		01h get /L flag
 01h	BYTE	interlock state
		00h=reset, 01h=set
		  This interlock prevents some of the ANSI.SYS post-processing
		  in its hook onto INT 10, AH=00h mode set
 02h	BYTE	(returned)
		00h if /L not in effect
		01h if /L in effect
--------V-2F1A21-----------------------------
INT 2F - AVATAR.SYS - SET DRIVER STATE
	AX = 1A21h (AL='!')
	DS:SI -> command string with one or more state characters (see #1322)
	CX = length of command string
Return: CF set on error (invalid subfunction)
	CF clear if successful
Note:	the characters in the state string are interpreted left to right, and
	  need not be in any particular order
SeeAlso: AX=1A3Fh

(Table 1322)
Values for AVATAR.SYS state characters:
 'a'	activate driver
 'd'	disable driver
 'f'	use fast screen output
 'g'	always convert gray keys (+ and -) to function keys
 'G'	never convert gray keys
 'l'	convert gray keys only when ScrollLock active
 's'	use slow screen output
 't'	Tandy 1000 keyboard (not yet implemented)
--------V-2F1A3C-----------------------------
INT 2F U - AVATAR.SYS v0.11 - ???
	AX = 1A3Ch
	???
Return: CX = 0000h
--------V-2F1A3E-----------------------------
INT 2F U - AVATAR.SYS v0.11 - ???
	AX = 1A3Eh
	CL = ???
	CH = ???
	DL = ???
	DH = ???
Return: CL = ???
	CH = ???
	DL = ???
	DH = ???
--------V-2F1A3F-----------------------------
INT 2F - AVATAR.SYS - QUERY DRIVER STATE
	AX = 1A3Fh (AL='?')
	ES:DI -> buffer
	CX = length of buffer in bytes
Return: CF clear
	CX = actual size of returned info
Note:	the returned information consists of multiple letters whose meanings
	  are described under AX=1A21h
SeeAlso: AX=1A21h
--------S-2F1A42BX4156-----------------------
INT 2F - AVATAR Serial Dispatcher - INSTALL IRQ3 HANDLER
	AX = 1A42h
	BX = 4156h ('AV')
	ES:DI -> FAR handler for serial port using IRQ3
	DS = data segment needed by handler
Return: AX = status/return value
	    0000h if no more room
	    1A42h if ASD not installed
	    else handle to use when uninstalling
Notes:	the handler need not save/restore registers or signal EOI to the
	  interrupt controller
	the handler should return AX=0000h if the interrupt was meant for it,
	  and either leave AX unchanged or return a non-zero value otherwise
	the most recently installed handler will be called first, continuing
	  to earlier handlers until one returns AX=0000h
SeeAlso: AX=1A43h,AX=1A62h
--------S-2F1A43BX4156-----------------------
INT 2F - AVATAR Serial Dispatcher - INSTALL IRQ4 HANDLER
	AX = 1A43h
	BX = 4156h ('AV')
	ES:DI -> FAR handler for serial port using IRQ4
	DS = data segment needed by handler
Return: AX = status/return value
	    0000h if no more room
	    1A43h if ASD not installed
	    else handle to use when uninstalling
Notes:	(see AX=1A42h)
SeeAlso: AX=1A42h,AX=1A63h
--------V-2F1A44BX4156-----------------------
INT 2F - AVATAR.SYS v0.11+ - GET DATA SEGMENT
	AX = 1A44h
	BX = 4156h ('AV')
Return: AX = 0000h
	DS = data segment
	CX = size of data segment
Note:	AVATAR.SYS calls this function whenever it is invoked.	If each
	  process under a multitasker hooks this function and provides a
	  separate data segment, AVATAR.SYS becomes fully reentrant.
SeeAlso: AX=1A21h,AX=1A3Fh
--------V-2F1A52-----------------------------
INT 2F U - AVATAR.SYS v0.11 - GET ???
	AX = 1A52h
	CX = size of buffer
	ES:DI -> buffer
Return: ??? copied into user buffer
Note:	the maximum size of the data which may be copied is returned by
	  AX=1A72h
SeeAlso: AX=1A72h
--------V-2F1A53-----------------------------
INT 2F U - AVATAR.SYS v0.11 - ???
	AX = 1A53h
	CL = ??? (00h-05h)
	???
Return: ???
--------S-2F1A62BX4156-----------------------
INT 2F - AVATAR Serial Dispatcher - UNINSTALL IRQ3 HANDLER
	AX = 1A62h
	BX = 4156h ('AV')
	CX = handle for IRQ routine returned by AX=1A42h
SeeAlso: AX=1A42h,AX=1A63h
--------S-2F1A63BX4156-----------------------
INT 2F - AVATAR Serial Dispatcher - UNINSTALL IRQ4 HANDLER
	AX = 1A63h
	BX = 4156h ('AV')
	CX = handle for IRQ routine returned by AX=1A43h
SeeAlso: AX=1A43h,AX=1A62h
--------V-2F1A72-----------------------------
INT 2F U - AVATAR.SYS v0.11 - GET ??? SIZE
	AX = 1A72h
Return: CX = maximum size of ???
SeeAlso: AX=1A52h
--------V-2F1A7B-----------------------------
INT 2F U - AVATAR.SYS v0.11 - ???
	AX = 1A7Bh
Return: AX = 0000h
	CX = 0000h
--------V-2F1A7D-----------------------------
INT 2F U - AVATAR.SYS v0.11 - ???
	AX = 1A7Dh
Return: AX = ???
--------V-2F1AADDX0000-----------------------
INT 2F U - AVATAR.SYS v0.11 - ???
	AX = 1AADh
	DX = 0000h
	CX = subfunction (00h-0Ch)
	???
Return: AX = 0000h if DX was nonzero
	???
--------m-2F1B00-----------------------------
INT 2F U - DOS 4+ XMA2EMS.SYS extension internal - INSTALLATION CHECK
	AX = 1B00h
Return: AL = FFh if installed
Note:	XMA2EMS.SYS extension is only installed if DOS has page frames to hide.
	This extension hooks onto INT 67/AH=58h and returns from that call data
	  which excludes the physical pages being used by DOS.
SeeAlso: AH=1Bh"FRAME INFO"
--------m-2F1B-------------------------------
INT 2F U - DOS 4+ XMA2EMS.SYS extension internal - GET HIDDEN FRAME INFORMATION
	AH = 1Bh
	AL <> 00h
	DI = hidden physical page number
Return: AX = FFFFh if failed (no such hidden page)
	AX = 0000h if OK, then
	    ES = segment of page frame
	    DI = physical page number
Notes:	this corresponds to the data edited out of the INT 67/AH=58h call
	FASTOPEN makes this call with AL = FFh
SeeAlso: AX=1B00h
--------V-2F2300-----------------------------
INT 2F - DR-DOS 5.0 GRAFTABL - INSTALLATION CHECK
	AX = 2300h
Return: AH = FFh
Note:	this installation check does not follow the usual format
SeeAlso: AH=23h,AX=2E00h
--------V-2F23-------------------------------
INT 2F - DR-DOS 5.0 GRAFTABL - GET GRAPHICS DATA
	AH = 23h
	AL nonzero
Return: AH = FFh
	ES:BX -> graphics data (8 bytes for each character from 80h to FFh)
SeeAlso: AX=2300h,AX=2E00h
--------T-2F2700-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - INSTALLATION CHECK
	AX = 2700h
Return: AL = status
	    00h not installed
	    FFh installed
--------T-2F2701-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - GET STATUS
	AX = 2701h
Return: AX = maximum simultaneous tasks
	BX = index into TASK_IDS of current foreground task
	CX = currently-active tasks
	DX = version number (DL = major, DH = minor)
	    (DR-DOS 6.0 = 0001h, Novell DOS 7 = 0002h)
	ES:SI -> TASK_IDS
	ES:DI -> name table (array of 8-byte names, NUL-terminated if <8 chars)
Notes:	do not attempt to create a new task if CX == AX
	the task's index is its position on the task menu, while its ID is the
	  position within the internal task name table
SeeAlso: AX=2714h,AX=2716h
--------T-2F2702-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - GET PER-TASK EMS LIMIT
	AX = 2702h
Return: DX = maximum pages INT 67/AH=42h will report available
Note:	TaskMAX does not limit EMS allocations other than by limiting the
	  amount which is reported as being available at a given time
SeeAlso: AX=2703h,INT 67/AH=42h
--------T-2F2703-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - SET PER-TASK EMS LIMIT
	AX = 2703h
	DX = maximum pages INT 67/AH=42h should report available
Return: DX = new maximum for reporting
SeeAlso: AX=2702h,INT 67/AH=42h
--------T-2F2704-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - REGISTER/UNREGISTER TASK MANAGER
	AX = 2704h
	DL = subfunction
	    00h unregister task manager
	    01h register task manager
Return: DL = status
	    00h registered
	    01h unregistered
Notes:	a task manager replaces TaskMAX's menu system with its own user
	  interface; while one is registered, the TaskMAX hotkeys and
	  Ctrl-Alt-Del invoke the manager rather than the built-in menu system
	unregister the task manager before terminating it
SeeAlso: AX=2705h
Index:	hotkeys;TaskMAX
--------T-2F2705-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - ENABLE/DISABLE DIRECT SWITCHING
	AX = 2705h
	DL = subfunction
	    00h disable keystrokes for switching to next/prev/specified task
	    01h enable
Return: nothing
Note:	should only be called by a registered task manager (see AX=2704h)
SeeAlso: AX=2704h,AX=2706h
--------T-2F2706-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - SWITCH TO SPECIFIED TASK
	AX = 2706h
	DX = task index (see AX=2701h) of task to be activated
Return: DX = task index of previously-active task
SeeAlso: AX=2705h,AX=2707h,AX=2715h
--------T-2F2707-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - CREATE NEW TASK
	AX = 2707h
	DS:DX -> ASCIZ pathname of executable
	ES:BX -> parameter block (see #1323)
	CX = number of ticks before automatic return to task manager
		(0000h = run until termination or explicitly switched)
Return: DX = new task's task index (FFFFh if task terminated)
SeeAlso: AX=2706h,AX=2708h

Format of TaskMAX parameter block:
Offset	Size	Description	(Table 1323)
 00h	WORD	reserved, should be 0000h
 02h	DWORD	pointer to command tail to be copied into child's PSP
 06h	DWORD	pointer to first FCB to be copied into child's PSP
 0Ah	DWORD	pointer to second FCB to be copied into child's PSP
--------T-2F2708-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - DELETE TASK
	AX = 2708h
	DX = task index
Return: DX = FFFFh (task deleted)
Notes:	this call should only be used for abnormal task termination, after
	  first checking for open files with AX=270Ch; should not be used
	  with programs that allocate EMS or XMS memory
	switches to specified task first
SeeAlso: AX=2707h
--------T-2F2709-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - NAME TASK
	AX = 2709h
	DX = task index
	DS:SI -> 8-byte name (8 NULs = remove name)
Return: AL = task flags
	    00h ID unused or task terminated
	    01h ID in use, task name table entry valid
	    81h ID in use, task name fixed
	BX = task ID
	ES:DI -> name in task name table (see AX=2701h)
Note:	the task retains the given name until it terminates or the name is
	  removed by specifying a name of 8 NULs.
SeeAlso: AX=2701h,AX=2707h
--------T-2F270A-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - CONVERT TASK INDEX TO TASK ID
	AX = 270Ah
	DX = task index
Return: DX = task ID (FFFFh if index invalid)
Note:	task IDs stay constant, while indexes can change when other tasks are
	  deleted
SeeAlso: AX=2701h,AX=270Bh
--------T-2F270B-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - CONVERT TASK ID TO TASK INDEX
	AX = 270Bh
	DX = task ID
Return: DX = task index (FFFFh if task not active)
SeeAlso: AX=270Ah
--------T-2F270C-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - CHECK OPEN FILES
	AX = 270Ch
	DX = task index
Return: AX = number of files currently open for specified task
SeeAlso: AX=2708h
--------T-2F270D-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - CHECK IF TASK RUNNING PRIMARY COMMAND INTERPRETER
	AX = 270Dh
	DX = task index
Return: DX = status
	    0000h if primary command interpreter (COMMAND.COM, etc.) running
	    0001h if not in root shell for task
Note:	TaskMAX will return 0001h if the specified task has spawned another
	  command interpreter with AX=2707h
SeeAlso: AX=2707h,AX=270Ch
--------T-2F270E-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - GET/SET TEXT PASTE LEAD-IN
	AX = 270Eh
	CX = length of string (max 15 keystrokes, 0000h to get current string)
	DS:SI -> pasting lead-in string (character/scan-code pairs)
Return: ES:DI -> current lead-in string
Note:	the specified sequence of keystrokes is sent to the application before
	  every line of a text-mode spreadsheet paste
SeeAlso: AX=270Fh,AX=2710h,AX=2713h
--------T-2F270F-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - GET/SET NUMERIC PASTE LEAD-IN
	AX = 270Fh
	CX = length of string (max 15 keystrokes, 0000h to get current string)
	DS:SI -> pasting lead-in string (character/scan-code pairs)
Return: ES:DI -> current lead-in string
Note:	the specified sequence of keystrokes is sent to the application before
	  every number in a numeric-mode spreadsheet paste
SeeAlso: AX=270Eh,AX=2710h,AX=2711h,AX=2713h
--------T-2F2710-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - GET/SET PASTE LINE TERMINATOR STRING
	AX = 2710h
	CX = length of string (max 15 keystrokes, 0000h to get current string)
	DS:SI -> pasting terminator string (character/scan-code pairs)
Return: ES:DI -> current terminator string
Note:	the specified sequence of keystrokes is sent to the application after
	  every line of a spreadsheet paste operation
SeeAlso: AX=270Eh,AX=270Fh,AX=2713h
--------T-2F2711-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - GET/SET NUMERIC PASTE DECIMAL POINT
	AX = 2711h
	DX = ASCII code for separator (FFFFh to get current)
Return: DL = current separator character
SeeAlso: AX=270Fh
--------T-2F2712-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - INITIATE EXPORTING TASK DATA
	AX = 2712h
	DX = task index
--------T-2F2713-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - INITIATE PASTE OPERATION
	AX = 2713h
	DX = task index
	CX = paste mode
	    0000h alphanumeric
	    0001h numeric
	    0002h text
SeeAlso: AX=270Eh,AX=270Fh,AX=2710h,AX=2711h
--------T-2F2714-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - GET SWAP SPACE INFO
	AX = 2714h
Return: CX = total KB of swap space
	DX = available KB of swap space
SeeAlso: AX=2701h
--------T-2F2715-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - SWITCH TO TASK MANAGER
	AX = 2715h
Return: only after calling task is again selected
SeeAlso: AX=2706h
--------T-2F2716-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - GET PASTE BUFFER STATUS
	AX = 2716h
Return: AX = 0000h if AX=2716h,AX=2717h,AX=2718h supported
	    CX = bytes in paste buffer
	    DX = current generation number (updated after every copy operation)
SeeAlso: AX=2701h,AX=2713h,AX=2714h,AX=2717h,AX=2718h
--------T-2F2717-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - PASTE DATA DIRECTLY TO APPLICATION BUFFER
	AX = 2717h
	CX = bytes in destination buffer
	ES:DI -> destination buffer
Return: AX = 0000h if function supported
	    CX = bytes actually copied (FFFFh if buffer too small)
	    DX = current generation number for paste buffer
Note:	the destination buffer may be too small if another task adds more data
	  to the paste buffer after the AX=2716h call but before this call
SeeAlso: AX=2713h,AX=2716h,AX=2718h
--------T-2F2718-----------------------------
INT 2F - DR-DOS 6.0 TaskMAX - COPY DATA DIRECTLY INTO PASTE BUFFER
	AX = 2718h
	CX = bytes in source buffer
	DS:SI -> source buffer (plain ASCII, lines terminated with CR LF)
Return: AX = 0000h if function supported
	    CX = bytes actually copied
	    DX = current generation number for paste buffer
SeeAlso: AX=2712h,AX=2716h,AX=2717h
--------T-2F2719-----------------------------
INT 2F - Novell DOS 7 TaskMGR - NOP
	AX = 2719h to 271Bh
--------T-2F271C-----------------------------
INT 2F U - Novell DOS 7 TaskMGR - ???
	AX = 271Ch
	DX = ???
	    bit 0: ???
Return: ???
	---if DX bit 0 set---
	AX = 0031h
	CX = 0000h
BUG:	if the task switcher is running, and DX bit 0 is set on call, this
	  function will crash because its exit code attempts to pop several
	  registers which are not pushed when DX bit 0 is set
--------m-2F2780CL01-------------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - MULTITASKING API
	AX = 2780h
	CL = 01h (function number)
	CH = subfunction
	    00h unused
		Return: CX = status (0002h) (see #1324)
	    01h unused
		Return: CX = status (0002h) (see #1324)
	    02h ???
		BX = ??? (0005h-000Fh)
		Return: CX = status (0000h,0030h) (see #1324)
	    03h allocate ???
		DX = ???
		Return: CX = status (0000h,0003h) (see #1324)
	    04h get ???
		Return: CX = 0000h (successful)
			BX = selector for EMM386 data segment
			EBX high word cleared
	    05h ???
		EDX = ???
		Return: ???
	    06h return to real mode via triple fault
	    07h debugger break
		Note:	calls INT 03, then INT 21/AH=02h to output a question
			  mark
	    08h get ???
		Return: CX = 0000h (successful)
			EBX = ??? (0 or 2)
	    09h ???
	    0Ah ???
	    0Bh unused
		Return: CX = status (0002h) (see #1324)
	    0Ch ??? manipulates DOS memory chain
	    0Dh ???
		EBX = ???
		EDX = ???
		Return: ???
	    0Eh ???
		Return: CX = 0000h (successful)
			BL = ???     \ or BX = 0000h
			BH = ???     /
	    0Fh get ???
		Return: CX = 0000h (successful)
			EBX = ???
	    10h get and set ???
		EDX = ???
		Return: CX = 0000h (successful)
			EBX = old value of ???
	    11h get ???
		Return: CX = 0000h (successful)
			EBX = ??? (0100h)
	    12h get and set ???
		DX = ???
		Return: CX = 0000h (successful)
			AX = old value of ???
	    13h ???
		Return: CX = status (0000h,003Fh) (see #1324)
			AX = ???
	    14h ???
		EDX = ???
		Return: CX = status (0000h,003Fh) (see #1324)
	    15h ???
		BX = segment of ???
		Return: CX = 0000h (successful)
			BX = segment of ???
	    16h ???
	    17h ???
		EBX = subfunction (0-2)
		Return: CX = status (0002h if EBX>2) (see #1324)
			???
	    18h unused
		Return: CX = status (0002h) (see #1324)
Return: CX = status (most subfunctions)
	(E)AX and/or (E)BX contain return values, depending on function
Notes:	called by DPMS.EXE and EMM386.EXE
	this API is only available if AX=12FFh/BX=0EDCh returns successfully;
	  because the request is handled on the initial trap to the memory
	  manager caused by INT instructions, this API must be invoked with
	  an actual INT 2F instruction instead of some simulation such as a
	  far call to the address in the interrupt vector table
SeeAlso: AX=12FF/BX=0EDCh,AX=2780h/CL=02h,AX=2780h/CL=03h,AX=2780h/CL=04h

(Table 1324)
Values for Novell DOS 7 EMM386 function status:
 0000h	successful
 0001h	invalid function???
 0002h	invalid subfunction
 0003h	???
 0004h	invalid ??? index
 0005h	???
 0006h	???
 0007h	???
 0009h	???
 000Ah	???
 000Bh	invalid ??? handle
 000Ch	???
 000Dh	???
 000Eh	???
 000Fh	???
 0014h	???
 0023h	???
 0030h	???
 003Fh	???
--------m-2F2780CL02-------------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - MULTITASKING API
	AX = 2780h
	CL = 02h (function number)
	CH = subfunction
	    00h ???
		???
		Return: CX = status (0000h,0023h, others???) (see #1324)
			BX = ??? (0000h if CX=0000h, FFFFh if CX=0023h)
		Note:	calls func 04h/sf 03h, func 04h/sf 1Eh,func 02h/sf 43h,
			  func 02h/sf 0Bh, and func 04h/sf 01h
	    01h get and clear ???
		DX = ??? handle or 0000h for default
		Return: CX = status (0000h,000Bh) (see #1324)
			EBX = old value of ??? if successful
			EDX destroyed
	    02h ???
		DX = index of ???
		Return: CX = status (0000h,0004h,0005h) (see #1324)
			EBX = 0000FFFFh on error, 00000000h if successful
	    03h ???
		DX = index of ???
		Return: CX = status (0000h,0004h,0006h) (see #1324)
			BX = FFFFh on error, 0000h if successful
	    04h ???
		Return: CX = status (0000h,0007h,000Ah) (see #1324)
	    05h ???
		EDX -> ??? data (first 8 bytes seem to be name)
		Return: CX = status (0000h,0009h,000Dh) (see #1324)
	    06h ???
		Note:	calls fn 02h/subfn 05h, then fn 02h/subfn 40h
	    07h ???
		EDX = ???
		Return: CX = status (0000h,0009h,000Eh) (see #1324)
	    08h ???
		EDX = ???
		Return: CX = status (0000h,0009h,000Eh) (see #1324)
	    09h ???
		EDX = ???
		Return: CX = status (0000h,0009h,000Fh) (see #1324)
	    0Ah ???
		EDX = ???
		Return: CX = status (0000h,0009h,000Fh) (see #1324)
	    0Bh ???
		DX = ???
		Return: CX = 0000h (successful)
	    0Ch ???
		Return: CX = 0000h (successful)
	    0Dh ???
		Return: CX = status (0000h,0023h) (see #1324)
			BX = FFFFh on error, 0000h if successful
		Note:	calls fn 04h/subfn 03h, fn 04h/subfn 1Eh,
			  fn 02h/subfn 43h, fn 02h/subfn 0Bh, fn 04h/sub 01h
	    0Eh ???
		???
		Return: CX = status (0000h,000Ch) (see #1324)
			EBX = ??? if successful
	    0Fh ???
		BX = ???
		DX = ??? handle or 0000h for default
		Return: CX = status (0000h,000Bh) (see #1324)
	    10h get ??? handle
		Return: CX = 0000h (successful)
			BX = handle of default ???
			EBX high word cleared
	    11h ???
		DX = ??? handle or 0000h for default
		BX = ??? (handle???)
		Return:	CX = status (0000h,000Bh,0014h) (see #1324)
	    12h ???
		BX = ???
		DX = ???
		Return: CX = 0000h (successful)
	    13h ???
		DX = ???
		Return: CX = status (see #1324)
	    14h ???
		BX = ???
		DX = ???
		Return: CX = status (0000h,0014h) (see #1324)
			BX = FFFFh on error, ??? if successful
	    15h set ??? flags
		BX = ??? (low two bits only)
		DX = ??? handle or 0000h for default
		Return: CX = status (0000h,000Bh) (see #1324)
			BX = new value of ??? flags (entire word)
			EBX high register cleared
	    16h clear ??? flag for default ???
		Return: CX = 0000h (successful)
	    17h ???
	    18h ???
	    19h ???
	    1Ah ???
	    1Bh ???
	    1Ch ???
	    1Dh ???
	    1Eh ???
	    1Fh ???
	    20h ???
	    21h ???
	    22h ???
	    23h ???
	    24h ???
	    25h ???
	    26h ???
	    27h ???
	    28h ???
	    29h ???
	    2Ah ???
	    2Bh ???
	    2Ch ???
	    2Dh ???
	    2Eh ???
	    2Fh ???
	    30h ???
	    31h ???
	    32h ???
	    33h ???
	    34h ???
	    35h ???
	    36h ???
	    37h ???
	    38h ???
	    39h ???
	    3Ah ???
	    3Bh ???
	    3Ch ???
	    3Eh ???
	    3Fh ???
	    40h ???
	    41h ???
	    42h ???
	    43h ???
	    44h ???
	    45h ???
	    46h ???
	    47h ???
Return: CX = status (most subfunctions)
	(E)AX and/or (E)BX contain return values, depending on function
Notes:	called by DPMS.EXE and EMM386.EXE
	this API is only available if AX=12FFh/BX=0EDCh returns successfully;
	  because the request is handled on the initial trap to the memory
	  manager caused by INT instructions, this API must be invoked with
	  an actual INT 2F instruction instead of some simulation such as a
	  far call to the address in the interrupt vector table
SeeAlso: AX=12FF/BX=0EDCh,AX=2780h/CL=01h,AX=2780h/CL=03h,AX=2780h/CL=04h
--------m-2F2780CL03-------------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - MULTITASKING API
	AX = 2780h
	CL = 03h (function number)
	CH = subfunction
	    00h ???	
	    01h ???
	    02h ???
	    03h ???
	    04h ???
	    05h ???
	    06h ???
	    07h ???
	    08h ???
	    09h ???
	    0Ah ???
	    0Bh ???
	    0Ch ???
	    0Dh ???
	    0Eh ???
	    0Fh ???
	    10h ???
	    11h ???
	    12h ???
	    13h ???
	    14h ???
	    15h ???
	    16h ???
	    17h ???
	    18h ???
	    19h ???
	    1Ah ???
	    1Bh ???
	    1Ch ???
	    1Dh ???
	    1Eh ???
	    1Fh ???
	    20h ???
	    21h ???
	    22h ???
	    23h ???
	    24h ???
	    25h ???
	    26h ???
	    27h ???
	    28h ???
	    29h ???
	    2Ah ???
	    2Bh ???
	    2Ch ???
	    2Dh ???
	    2Eh ???
	    2Fh ???
	    30h ???
	    31h ???
	    32h ???
	    33h ???
	    34h ???
	    35h ???
	    36h ???
	    37h ???
Return: CX = status (most subfunctions)
	(E)AX and/or (E)BX contain return values, depending on function
Notes:	called by DPMS.EXE and EMM386.EXE
	this API is only available if AX=12FFh/BX=0EDCh returns successfully;
	  because the request is handled on the initial trap to the memory
	  manager caused by INT instructions, this API must be invoked with
	  an actual INT 2F instruction instead of some simulation such as a
	  far call to the address in the interrupt vector table
SeeAlso: AX=12FF/BX=0EDCh,AX=2780h/CL=01h,AX=2780h/CL=02h,AX=2780h/CL=04h
--------m-2F2780CL04-------------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - MULTITASKING API
	AX = 2780h
	CL = 04h (function number)
	CH = subfunction
	    00h ???	
	    01h ???
	    02h ???
	    03h ???
	    04h ???
	    05h ???
	    06h ???
	    07h ???
	    08h ???
	    09h ???
	    0Ah ???
	    0Bh ???
	    0Ch ???
	    0Dh ???
	    0Eh ???
	    0Fh ???
	    10h ???
	    11h ???
	    12h ???
	    13h ???
	    14h ???
	    15h ???
	    16h ???
	    17h ???
	    18h ???
	    19h ???
	    1Ah ???
	    1Bh ???
	    1Ch ???
	    1Dh ???
	    1Eh ???
	    1Fh ???
	    20h ???
	    21h ???
	    22h ???
	    23h ???
	    24h ???
	    25h ???
	    26h ???
	    27h ???
	    28h ???
	    29h ???
	    2Ah ???
	    2Bh ???
	    2Ch ???
	    2Dh ???
	    2Eh ???
	    2Fh ???
	    30h ???
	    31h ???
	    32h ???
Return: CX = status (most subfunctions)
	(E)AX and/or (E)BX contain return values, depending on function
Notes:	called by DPMS.EXE and EMM386.EXE
	this API is only available if AX=12FFh/BX=0EDCh returns successfully;
	  because the request is handled on the initial trap to the memory
	  manager caused by INT instructions, this API must be invoked with
	  an actual INT 2F instruction instead of some simulation such as a
	  far call to the address in the interrupt vector table
SeeAlso: AX=12FF/BX=0EDCh,AX=2780h/CL=01h,AX=2780h/CL=02h,AX=2780h/CL=03h
--------m-2F2780CL05-------------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - MULTITASKING API
	AX = 2780h
	CL = 05h
	???
Return: ???
Notes:	called by DPMS.EXE and EMM386.EXE
	the handler for this function may be set by one of the subfunctions
	  of AX=2780h/CL=01h; the default handler returns AX=BX=FFFFh and
	  CX=0001h (see #1324)
	this API is only available if AX=12FFh/BX=0EDCh returns successfully;
	  because the request is handled on the initial trap to the memory
	  manager caused by INT instructions, this API must be invoked with
	  an actual INT 2F instruction instead of some simulation such as a
	  far call to the address in the interrupt vector table
SeeAlso: AX=12FF/BX=0EDCh,AX=2780h/CL=01h,AX=2780h/CL=02h,AX=2780h/CL=03h
--------m-2F2780CL06-------------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - MULTITASKING API
	AX = 2780h
	CL = 06h
	???
Return: ???
Notes:	called by DPMS.EXE and EMM386.EXE
	the handler for this function may be set by one of the subfunctions
	  of AX=2780h/CL=01h; the default handler returns AX=BX=FFFFh and
	  CX=0001h (see #1324)
	this API is only available if AX=12FFh/BX=0EDCh returns successfully;
	  because the request is handled on the initial trap to the memory
	  manager caused by INT instructions, this API must be invoked with
	  an actual INT 2F instruction instead of some simulation such as a
	  far call to the address in the interrupt vector table
SeeAlso: AX=12FF/BX=0EDCh,AX=2780h/CL=01h,AX=2780h/CL=02h,AX=2780h/CL=03h
--------m-2F2780-----------------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - MULTITASKING API
	AX = 2780h
	CL = function (07h-0Fh)
	???
Return: ???
Notes:	called by DPMS.EXE and EMM386.EXE
	the handlers for each of these functions may be set individually by
	  one of the subfunctions of AX=2780h/CL=01h; the default handlers
	  return with all registers unchanged
	this API is only available if AX=12FFh/BX=0EDCh returns successfully;
	  because the request is handled on the initial trap to the memory
	  manager caused by INT instructions, this API must be invoked with
	  an actual INT 2F instruction instead of some simulation such as a
	  far call to the address in the interrupt vector table
SeeAlso: AX=12FF/BX=0EDCh,AX=2780h/CL=01h,AX=2780h/CL=02h,AX=2780h/CL=03h
--------T-2F2781-----------------------------
INT 2F U - Novell DOS 7 TaskMGR - BEGIN CRITICAL SECTION???
	AX = 2781h
Return: ???
SeeAlso: AX=2782h
--------T-2F2782-----------------------------
INT 2F U - Novell DOS 7 TaskMGR - END CRITICAL SECTION???
	AX = 2782h
Return: ???
SeeAlso: AX=2781h
--------m-2F2783-----------------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - GET ???
	AX = 2783h
Return: AX = ???
	BX = ???
--------T-2F278F-----------------------------
INT 2F U - Novell DOS 7 TaskMGR - ??? API
	AX = 278Fh
	as for INT 2F/AX=2780h
Return: as for INT 2F/AX=2780h
Note:	Novell DOS 7 TaskMGR passes this call through to INT 2F/AX=2780h
	  without changing any other registers
SeeAlso: AX=2780h,AX=2782h
--------F-2F2A-------------------------------
INT 2F - Gammafax DOS Dispatcher INTERFACE
	AH = 2Ah
Note:	details not available at this time
SeeAlso: AX=8000h"FaxBIOS",AX=C000h/BX=444Bh,AX=CB00h,AX=CBDDh,INT 66"BitFax"
--------V-2F2E00-----------------------------
INT 2F U - Novell DOS 7 - GRAFTABL - INSTALLATION CHECK
	AX = 2E00h
Return: AH = FFh if installed
Note:	this installation check does not follow the usual format of setting
	  AL to FFh
SeeAlso: AX=2300h,AH=2Eh"GRAFTABL"
--------V-2F2E-------------------------------
INT 2F U - Novell DOS 7 - GRAFTABL - GET FONT TABLE
	AH = 2Eh
	AL nonzero
Return: AH = FFh if installed
	    ES:BX -> graphics data (8 bytes per character from 80h to FFh)
SeeAlso: AX=2E00h,AH=23h"GRAFTABL"
--------t-2F3900-----------------------------
INT 2F - Kingswood TSR INTERFACE - COMPATIBILITY MODE
	AX = 3900h
Return: AL = status
	    00h not installed
	    FFh one or more TSRs using this interface is installed
		DX may be destroyed
Note:	this function is provided to that the multiplex number will appear used
	  to other programs
SeeAlso: AH=39h/BL=00h
--------t-2F39--BL00-------------------------
INT 2F - Kingswood TSR INTERFACE - INSTALLATION CHECK
	AH = 39h
	BL = 00h
	AL = TSR ID number (01h-FFh, currently only 01h-1Bh used) (see #1325)
Return: AL = status
	    00h not installed
	    FFh installed
		DX = segment address of resident module
Note:	All of Kingswood Software's TSRs use this interface.  Usually the
	  resident module is installed by allocating a block of upper memory,
	  setting its owner ID to 000Ah (used by DOS), and filling the MCB name
	  field with the TSR's name.
SeeAlso: AX=3900h,AH=39h/BL=01h

(Table 1325)
Values for Kingswood TSR ID number:
 01h	TSR Windows
 02h	NOBUSY
 03h	CD STACK
 04h	DISK WATCH
 05h	PUSHBP
 06h	ALIAS
 07h	KEYMACRO
 08h	SLOWDOWN
 09h	ANSIGRAB
 0Ah	TEE
 0Bh	FASTMOUS
 0Ch	EXTWILD
 0Dh	BREAKOUT
 0Eh	STOPDISK
 0Fh	MEMINIT
 10h	JANUSEXT
 11h	CAPS
 12h	ANSI
 13h	TRAPPER
 14h	EATMEM
 15h	WPJOKE
 16h	SHOWDOS
 17h	LOGINTS
 18h	BLANKVGA
 19h	SWAPEXEC
 1Ah	SHELL
 1Bh	TSRGAMES

Format of Kingswood TSR modules:
Offset	Size	Description	(Table 1326)
 00h  4 BYTEs	signature "FTSR"
 04h	WORD	segment address of this module (used to check validity)
 06h	WORD	number of words to skip (usually 0000h if no PSP present)
 08h  N WORDs	module-defined data that must be at a fixed segment offset
		(usually only a PSP if file access is required)
     5N BYTEs	interrupt list (see #1327)
	BYTE	FFh terminator

Format of Kingswood TSR interrupt list entry:
Offset	Size	Description	(Table 1327)
 00h	BYTE	interrupt number (00h-FEh)
 01h	WORD	offset within segment of DWORD pointer to previous interrupt
 03h	WORD	offset within segment of begin of interrupt handler code
--------t-2F39--BL01-------------------------
INT 2F - Kingswood TSR INTERFACE - REMOVAL CHECK
	AH = 39h
	BL = 01h
	AL = TSR ID number (01h-FFh) (see #1325)
Return: AL = status
	    00h not ready to be removed
	    FFh resident module may be removed by deassigning the interrupts
		  hooked by the TSR and deallocating the TSR's memory block
	AH,BX,CX,DX,ES may be destroyed
SeeAlso: AX=3900h,AH=39h/BL=00h
--------t-2F39-------------------------------
INT 2F - Kingswood TSR INTERFACE - APPLICATION-SPECIFIC FUNCTION CALLS
	AH = 39h
	BL = function number (02h-FFh)
	AL = TSR ID number (01h-FFh) (see #1325)
	CX,DX,SI,DI,DS,ES may contain parameters
	BH reserved for use by the function dispatcher
Return: as appropriate for the called function
SeeAlso: AX=3900h,AH=39h/BL=00h,AX=3901h/BL=02h
--------r-2F3901BL02-------------------------
INT 2F - Kingswood TSR Windows - OPEN WINDOW
	AX = 3901h
	BL = 02h
Return: AX = error code (0000h if successful)
	SI,DI,DS,ES preserved
Notes:	opens the next TSR window on top of any others.	 Only three
	  TSR windows can be opened at any one time.  The three windows
	  are all 40x11 characters, partly overlapping.
SeeAlso: AH=39h/BL=00h,AX=3901h/BL=03h,AX=3901h/BL=05h,AX=3901h/BL=06h
--------r-2F3901BL03-------------------------
INT 2F - Kingswood TSR Windows - HIDE WINDOWS
	AX = 3901h
	BL = 03h
Return: AX = error code (0000h if successful)
	SI,DI,DS,ES preserved
Notes:	Hide any visible TSR windows from view.
SeeAlso: AH=39h/BL=00h,AX=3901h/BL=02h,AX=3901h/BL=05h
--------r-2F3901BL04-------------------------
INT 2F - Kingswood TSR Windows - SHOW WINDOWS
	AX = 3901h
	BL = 04h
Return: AX = error code (0000h if successful)
	SI,DI,DS,ES preserved
Notes:	Re-display all TSR windows after a HIDE WINDOWS call.
SeeAlso: AH=39h/BL=00h,AX=3901h/BL=02h,AX=3901h/BL=03h
--------r-2F3901BL05-------------------------
INT 2F - Kingswood TSR Windows - CLOSE WINDOW
	AX = 3901h
	BL = 05h
Return: AX = error code (0000h if successful)
	SI,DI,DS,ES preserved
Notes:	Close the last opened TSR window.
SeeAlso: AH=39h/BL=00h,AX=3901h/BL=02h
--------r-2F3901BL06-------------------------
INT 2F - Kingswood TSR Windows - SET WINDOW TITLE
	AX = 3901h
	BL = 06h
	DS:SI -> title string
Return: AX = error code (0000h if successful)
	SI,DI,DS,ES preserved
SeeAlso: AH=39h/BL=00h,AX=3901h/BL=02h
--------r-2F3901BL07-------------------------
INT 2F - Kingswood TSR Windows - POSITION CURSOR
	AX = 3901h
	BL = 07h
	CH = Y coordinate (0-10)
	CL = X coordinate (0-39)
Return: AX = error code (0000h if successful)
	SI,DI,DS,ES preserved
Note:	the hardware cursor is always disabled when a TSR window is opened;
	  this call only sets a text position
SeeAlso: AH=39h/BL=00h,AX=3901h/BL=08h,AX=3901h/BL=09h
--------r-2F3901BL08-------------------------
INT 2F - Kingswood TSR Windows - DISPLAY STRING
	AX = 3901h
	BL = 08h
	DS:SI -> string
Return: AX = error code (0000h if successful)
	SI,DI,DS,ES preserved
Notes:	The text is not clipped.
	This routine understands Tab, NewLine and Carriage Return
SeeAlso: AH=39h/BL=00h,AX=3901h/BL=07h
--------r-2F3901BL09-------------------------
INT 2F - Kingswood TSR Windows - SCROLL WINDOW
	AX = 3901h
	BL = 09h
	CL = scroll direction: 01h up, FFh down, 00h clear window
Return: AX = error code (0000h if successful)
	SI,DI,DS,ES preserved
SeeAlso: AH=39h/BL=00h,AX=3901h/BL=07h
--------r-2F3901BL0A-------------------------
INT 2F - Kingswood TSR Windows - SOUND BEEPER
	AX = 3901h
	BL = 0Ah
	DX = sound divisor, or 0 for silence.
	     (divide 1843200 by required frequency to get value for DX)
	CL = sound length in 18.2 Hz clock ticks
Return: AX = error code (0000h if successful)
	SI,DI,DS,ES preserved
SeeAlso: AH=39h/BL=00h
--------r-2F3901BL0B-------------------------
INT 2F - Kingswood TSR Windows - ADD OR REMOVE USER
	AX = 3901h
	BL = 0Bh
	CL = number of users increment: +1 if adding a new user
					-1 if removing a user
Return: AX = error code (0000h if successful)
	SI,DI,DS,ES preserved
Note:	the TSR windows resident module may only be removed when the internal
	  user count is zero
SeeAlso: AH=39h/BL=00h,AX=3901h/BL=02h
--------V-2F3912BL03-------------------------
INT 2F - Kingswood ANSI display driver - SET COMPATIBILITY MODE
	AX = 3912h
	BL = 03h
	CL = new mode (00h fast, FFh BIOS)
Return: AL = old compatibility mode
	SI,DI,DS,ES preserved
SeeAlso: AX=3900h,AX=3912h/BL=04h
--------V-2F3912BL04-------------------------
INT 2F - Kingswood ANSI display driver - SET FLAGS
	AX = 3912h
	BL = 04h
	CL = new flags (see #1328)
Return: AL = old flags
	SI,DI,DS,ES preserved
SeeAlso: AX=3900h,AX=3912h/BL=03h

Bitfields for Kingswood ANSI flags:
Bit(s)	Description	(Table 1328)
 0	do not wrap at end of line
 1	wait for beeps to end before displaying next character
 2	do not use graphics cursor
--------W-2F4000-----------------------------
INT 2F - Windows 3.x (OS/2 2.x???) - GET VIRTUAL DEVICE DRIVER (VDD) CAPABLTIES
	AX = 4000h
Return: AL = video virtualization (see #1329)
Note:	this function is used by display drivers to find out what capabilities
	  exist for the VDD driver and also trigger the VDD driver to call
	  functions 4005h and 4006h.  This function also gives the Video Driver
	  hardware access to the video registers.

(Table 1329)
Values for Windows video virtualization:
 01h	does not virtualize video access
 02h	virtualizes the video when in text mode
 03h	virtualizes the video when in text mode or single plane graphics modes
 04h	virtualizes the video when in text mode, single plane graphics modes,
	  and VGA multiplane modes
 FFh	virtualizes the video fully
--------O-2F4001-----------------------------
INT 2F C - OS/2 compatibility box - SWITCHING DOS TO BACKGROUND
	AX = 4001h
Note:	called by OS/2 when the DOS box is about to be placed in the background
	  and the video driver should save any necessary state
SeeAlso: AX=4002h,AX=4005h
--------O-2F4002-----------------------------
INT 2F C - OS/2 compatibility box - SWITCHING DOS TO FOREGROUND
	AX = 4002h
Note:	called by OS/2 when the DOS box is about to be placed in the foreground
	  and the video driver should restore the previously-saved state
SeeAlso: AX=4001h,AX=4006h
--------W-2F4003-----------------------------
INT 2F - Windows 3.x - ENTERING VIDEO DRIVER CRITICAL SECTION
	AX = 4003h
Note:	This critical section must be exited within 1 second.
SeeAlso: AX=4004h
--------W-2F4004-----------------------------
INT 2F - Windows 3.x - EXITING VIDEO DRIVER CRITICAL SECTION
	AX = 4004h
SeeAlso: AX=4003h
--------W-2F4005-----------------------------
INT 2F C - Windows 3.x - SWITCHING DOS TO BACKGROUND
	AX = 4005h
Note:	called by Windows when the DOS box is about to be placed in the
	  background and the video driver should save any necessary state
	  information (this may be called only in Standard mode)
SeeAlso: AX=4001h,AX=4006h
--------W-2F4006-----------------------------
INT 2F C - Windows 3.x - SWITCHING DOS TO FOREGROUND
	AX = 4006h
Note:	called by Windows when the DOS box is about to be placed in the
	  foreground and the video driver should restore any necessary state
	  information (this may be called only in Standard mode)
SeeAlso: AX=4002h,AX=4005h
--------W-2F4007-----------------------------
INT 2F - Windows 3.x - ENABLE VDD TRAPPING OF VIDEO REGISTERS
	AX = 4007h
Note:	used by Windows Standard mode
--------E-2F4040-----------------------------
INT 2F - PharLap 286|DOS-Extender Lite v2.5 - ???
	AX = 4040h
Return: BX:CX -> ???
--------N-2F4100-----------------------------
INT 2F - DOS Enhanced LAN Manager 2.0+ MINIPOP/NETPOPUP - INSTALLATION CHECK
	AX = 4100h
Return: CF clear if successful
	    AL = FFh
	CF set on error
	    AX = ???
Notes:	MINIPOP and NETPOPUP provide a network message popup service
	LAN Manager enhanced mode adds features beyond the standard redirector
	  file/printer services
SeeAlso: AX=118Ah,AX=4103h,AX=4104h,AH=42h,AH=4Bh
--------N-2F4103-----------------------------
INT 2F - DOS Enhanced LAN Manager 2.0+ MINIPOP/NETPOPUP - ???
	AX = 4103h
Return: ???
SeeAlso: AX=4100h,AX=4104h
--------N-2F4104-----------------------------
INT 2F - DOS Enhanced LAN Manager 2.0+ MINIPOP/NETPOPUP - ???
	AX = 4104h
Return: ???
SeeAlso: AX=4100h,AX=4103h
--------N-2F42-------------------------------
INT 2F - LAN Manager 2.0 DOS Enhanced MSRV.EXE - MESSENGER SERVICE
	AH = 42h
	???
Return: ???
Note:	LAN Manager enhanced mode adds features beyond the standard redirector
	  file/printer services
SeeAlso: AX=118Ah,AX=4100h,AH=4Bh
--------m-2F4300-----------------------------
INT 2F - EXTENDED MEMORY SPECIFICATION (XMS) v2+ - INSTALLATION CHECK
	AX = 4300h
Return: AL = 80h XMS driver installed
	AL <> 80h no driver
Notes:	XMS gives access to extended memory and noncontiguous/nonEMS memory
	  above 640K
	this installation check DOES NOT follow the format used by other
	  software
SeeAlso: AX=4310h
Index:	installation check;XMS version 2+
--------m-2F4308-----------------------------
INT 2F U - HIMEM.SYS v2.77+ - GET A20 HANDLER NUMBER
	AX = 4308h
Return: AL = 43h if supported
	    BL = A20 handler number (value of /MACHINE:nn switch)
	    BH = AT A20 switch time (00h medium, 01h fast, 02h slow)
Note:	if the A20 handler number returned in BL is 00h, an external handler
	  is being used (see AX=4330h)
SeeAlso: AX=4309h,AX=4330h
--------m-2F4309-----------------------------
INT 2F U - HIMEM.SYS v3.09+ - GET XMS HANDLE TABLE
	AX = 4309h
Return: AL = 43h if function supported
	    ES:BX -> XMS handle table (see #1330)
Note:	HIMEM.SYS v3.09 is part of MS-DOS 6.0.
SeeAlso: AX=4308h

Format of XMS handle table:
Offset	Size	Description	(Table 1330)
 00h	BYTE	??? (01h in HIMEM.SYS v3.09)
 01h	BYTE	size of one handle descriptor
 02h	WORD	number of handles (default = 20h)
 04h	DWORD	pointer to XMS handle array (see #1331)
SeeAlso: #1364

Format of XMS handle descriptor [array]:
Offset	Size	Description	(Table 1331)
 00h	BYTE	flag
		01h=free, 02h=used, 04h=in pool but not associated with any EMB
 01h	BYTE	lock count (00h=unlocked)
 02h	DWORD	address of XMS block in KB (shift left by 10 for abs. address)
 06h	DWORD	size of XMS block in KB
--------m-2F4310-----------------------------
INT 2F - EXTENDED MEMORY SPECIFICATION (XMS) v2+ - GET DRIVER ADDRESS
	AX = 4310h
Return: ES:BX -> driver entry point (see #1332,#1333,#1343,#1361)
Notes:	HIMEM.SYS v2.77 chains to previous handler if AH is not 00h or 10h
	HIMEM.SYS requires at least 256 bytes free stack space when calling
	  the driver entry point
SeeAlso: AX=4300h,AX=4310h"Cloaking"

Format of XMS driver entry point:
Offset	Size	Description	(Table 1332)
 00h  5 BYTEs	jump to actual handler
		either short jump (EBh XXh) followed by three NOPs or
		  far jump (EAh XXXX:XXXX) to a program which has hooked itself
		  into the XMS driver chain
Note:	to hook into the XMS driver chain, a program should follow the chain of
	  far jumps until it reaches the short jump of the driver at the end
	  of the chain; this short jump is to be replaced with a far jump to
	  the new handler's entry point, which should contain a short jump
	  followed by three NOPs.  The new handler must return to the address
	  pointed at by the short jump which was overwritten.  Using this
	  method, the new handler becomes the first to see every XMS request.

(Table 1333)
Call the XMS driver "Get XMS version number" function with:
	AH = 00h
Return: AX = XMS version (in BCD, AH=major, AL=minor)
	BX = internal revision number (in BCD for HIMEM.SYS)
	DX = High Memory Area (HMA) state
	    0001h HMA (1M to 1M + 64K) exists
	    0000h HMA does not exist

(Table 1334)
Call the XMS driver "Request High Memory Area" function with:
	AH = 01h
	DX = memory in bytes (for TSR or device drivers)
	    FFFFh if application program
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,81h,90h,91h,92h) (see #1362)
Note:	HIMEM.SYS will fail function 01h with error code 91h if AL=40h and
	  DX=KB free extended memory returned by last call of function 08h

(Table 1335)
Call the XMS driver "Release High Memory Area" function with:
	AH = 02h
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,81h,90h,93h) (see #1362)

(Table 1336)
Call the XMS driver "Global enable A20, for using the HMA" function with:
	AH = 03h
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,81h,82h) (see #1362)

(Table 1337)
Call the XMS driver "Global disable A20" function with:
	AH = 04h
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,81h,82h,94h) (see #1362)

(Table 1338)
Call the XMS driver "Local enable A20" function with:
	AH = 05h
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,81h,82h) (see #1362)
Note:	this function is used for direct access to extended memory

(Table 1339)
Call the XMS driver "Local disable A20" function with:
	AH = 06h
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,81h,82h,94h) (see #1362)

(Table 1340)
Call the XMS driver "Query A20 state" function with:
	AH = 07h
Return: AX = status
	    0001h enabled
	    0000h disabled
		BL = error code (00h,80h,81h) (see #1362)

(Table 1341)
Call the XMS driver "Query free extended memory" function with:
	AH = 08h
	BL = 00h (some implementations leave BL unchanged on success)
Return: AX = size of largest extended memory block in KB
	DX = total extended memory in KB
	BL = error code (00h,80h,81h,A0h) (see #1362)
Note:	this function does not include the HMA in the returned memory sizes

(Table 1342)
Call the XMS driver "Allocate extended memory block" function with:
	AH = 09h
	DX = Kbytes needed
Return: AX = status
	    0001h success
		DX = handle for memory block
	    0000h failure
		BL = error code (80h,81h,A0h) (see #1362)
SeeAlso: #1359

(Table 1343)
Call the XMS driver "Free extended memory block" function with:
	AH = 0Ah
	DX = handle of block to free
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,81h,A2h,ABh) (see #1362)
SeeAlso: #1342,#1359

(Table 1344)
Call the XMS driver "Move extended memory block" function with:
	AH = 0Bh
	DS:SI -> EMM structure (see #1363)
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h-82h,A3h-A9h) (see #1362)
Note:	if either handle in the EMM structure is 0000h, the corresponding
	  offset is considered to be an absolute segment:offset address in
	  directly addressable memory

(Table 1345)
Call the XMS driver "Lock extended memory block" function with:
	AH = 0Ch
	DX = handle of block to lock
Return: AX = status
	    0001h success
		DX:BX = 32-bit linear address of locked block
	    0000h failure
		BL = error code (80h,81h,A2h,ACh,ADh) (see #1362)
Note:	MS Windows 3.x rejects this function for handles allocated after
	  Windows started

(Table 1346)
Call the XMS driver "Unlock extended memory block" function with:
	AH = 0Dh
	DX = handle of block to unlock
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,81h,A2h,AAh) (see #1362)

(Table 1347)
Call the XMS driver "Get handle information" function with:
	AH = 0Eh
	DX = handle for which to get info
Return: AX = status
	    0001h success
		BH = block's lock count
		BL = number of free handles left
		DX = block size in KB
	    0000h failure
		BL = error code (80h,81h,A2h) (see #1362)
BUG:	MS Windows 3.10 acts as though unallocated handles are in use
Note:	MS Windows 3.00 has problems with this call

(Table 1348)
Call the XMS driver "Reallocate extended memory block" function with:
	AH = 0Fh
	DX = handle of block
	BX = new size of block in KB
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,81h,A0h-A2h,ABh) (see #1362)

(Table 1349)
Call the XMS driver "Request upper memory block" function with:
	AH = 10h
	DX = size of block in paragraphs
Return: AX = status
	    0001h success
		BX = segment address of UMB
		DX = actual size of block
	    0000h failure
		BL = error code (80h,B0h,B1h) (see #1362)
		DX = largest available block
Notes:	Upper Memory consists of non-EMS memory between 640K and 1024K
	the XMS driver need not implement functions 10h through 12h to be
	  considered compliant with the standard

(Table 1350)
Call the XMS driver "Release upper memory block" function with:
	AH = 11h
	DX = segment address of UMB to release
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,B2h) (see #1362)
Note:	the XMS driver need not implement functions 10h through 12h to be
	  considered compliant with the standard

(Table 1351)
Call the XMS v3.0+ driver "Reallocate upper memory block" function with:
	AH = 12h
	DX = segment address of UMB to resize
	BX = new size of block in paragraphs
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,B0h,B2h) (see #1362)
		DX = maximum available size (RM386)
Note:	the XMS driver need not implement functions 10h through 12h to be
	  considered compliant with the standard

(Table 1352)
Call the QEMM v5.11 "???" function with:
	AH = 34h  (QEMM 5.11 only, undocumented)
	???
Return: ???

(Table 1353)
Call the QEMM v5.11 "???" function with:
	AH = 44h  (QEMM 5.11 only, undocumented)
	???
Return: ???

(Table 1354)
Call the Netroom RM386 v6.00 "Reallocate upper memory block" function with:
	AH = 80h
	DX = segment address of UMB to resize
	BX = new size of block in paragraphs
Return: AX = status
	    0001h success
	    0000h failure
		BL = error code (80h,B0h,B2h) (see #1362)
		DX = maximum available size
Note:	this function is identical to function 12h

(Table 1355)
Call the Netroom RM386 v6.00 "re-enable HMA allocation" function with:
	AH = 81h
Return: AX = 0001h (success)

(Table 1356)
Call the Netroom RM386 v6.00 "Create new UMB entry" function with:
	AH = 83h
	BX = segment of high-memory block
	DX = first page of start of block
	CX = number of consecutive pages in block
	DI = start of UMB in block
Return: AX = 0001h (success)
	DI = segment of first high-DOS block
Note:	the new UMB is not linked into the high-memory chain

(Table 1357)
Call the Netroom RM386 v6.00 "Get all XMS handles info" function with:
	AH = 84h
	CX = size of buffer for handle info
	ES:DI -> buffer for handle info (see #1364)
Return: AX = 0001h (success)
	DX = current number of allocated XMS handles

(Table 1358)
Call the XMS v3.0 driver "Query free extended memory" function with:
	AH = 88h
Return: EAX = largest block of extended memory, in KB
	BL = status (00h,80h,81h,A0h) (see #1362)
	ECX = physical address of highest byte of memory
	    (valid even on error codes 81h and A0h)
	EDX = total Kbytes of extended memory (0 if status A0h)
BUG:	HIMEM v3.03-3.07 crash on an 80286 machine if any of the 8Xh functions
	  are called
SeeAlso: #1341,#1359

(Table 1359)
Call the XMS v3.0 driver "Allocate any extended memory" function with:
	AH = 89h
	EDX = Kbytes needed
Return: AX = status
	    0001h success
		DX = handle for allocated block (free with AH=0Ah) (see #1343)
	    0000h failure
		BL = status (80h,81h,A0h,A1h,A2h) (see #1362)
SeeAlso: #1342,#1358

(Table 1360)
Call the XMS v3.0 driver "Get extended EMB handle information" function with:
	AH = 8Eh
	DX = handle
Return: AX = status
	    0001h success
		BH = block's lock count
		CX = number of free handles left
		EDX = block size in KB
	    0000h failure
		BL = status (80h,81h,A2h) (see #1362)
BUG:	MS-DOS 6.0 HIMEM.SYS leaves CX unchanged

(Table 1361)
Call the XMS v3.0 driver "Reallocate any extended memory block" function with:
	AH = 8Fh
	DX = unlocked handle
	EBX = new size in KB
Return: AX = status
	    0001h success
	    0000h failure
		BL = status (80h,81h,A0h-A2h,ABh) (see #1362)
BUG:	HIMEM v3.03-3.07 crash on an 80286 machine if any of the 8Xh functions
	  are called

(Table 1362)
Values for XMS error code returned in BL:
 00h	successful
 80h	function not implemented
 81h	Vdisk was detected
 82h	an A20 error occurred
 8Eh	a general driver error
 8Fh	unrecoverable driver error
 90h	HMA does not exist or is not managed by XMS provider
 91h	HMA is already in use
 92h	DX is less than the /HMAMIN= parameter
 93h	HMA is not allocated
 94h	A20 line still enabled
 A0h	all extended memory is allocated
 A1h	all available extended memory handles are allocated
 A2h	invalid handle
 A3h	source handle is invalid
 A4h	source offset is invalid
 A5h	destination handle is invalid
 A6h	destination offset is invalid
 A7h	length is invalid
 A8h	move has an invalid overlap
 A9h	parity error occurred
 AAh	block is not locked
 ABh	block is locked
 ACh	block lock count overflowed
 ADh	lock failed
 B0h	only a smaller UMB is available
 B1h	no UMB's are available
 B2h	UMB segment number is invalid

Format of EMM structure:
Offset	Size	Description	(Table 1363)
 00h	DWORD	number of bytes to move (must be even)
 04h	WORD	source handle
 06h	DWORD	offset into source block
 0Ah	WORD	destination handle
 0Ch	DWORD	offset into destination block
Notes:	if source and destination overlap, only forward moves (source base
	  less than destination base) are guaranteed to work properly
	if either handle is zero, the corresponding offset is interpreted
	  as a real-mode address referring to memory directly addressable
	  by the processor

Format of XMS handle info [array]:
Offset	Size	Description	(Table 1364)
 00h	BYTE	handle
 01h	BYTE	lock count
 02h	DWORD	handle size
 06h	DWORD	handle physical address (only valid if lock count nonzero)
SeeAlso: #1330
--------m-2F4310-----------------------------
INT 2F - Cloaking - REAL-MODE API
	AX = 4310h
Return: ES:BX -> driver entry point (see #1332,#1365,#1366,#1367,#1368)
SeeAlso: AX=4310h"XMS"

(Table 1365)
Call the Cloaking v1.01 "Client Registration" function with:
	AH = 7Eh
	BX = subfunction
	    0000h get client registration count
	    0001h get client registration structures
		ES:DI -> buffer for registration structures
Return: AX = status
	    0000h failed
	    0001h successful
	        ---subfunction 00h---
		BX = size of client structure in bytes
		CX = number of clients installed
		---subfunction 01h---
		ES:DI buffer filled
SeeAlso: #1366,#1368,INT 2C/AX=0033h

(Table 1366)
Call the Cloaking v1.01 "Verify Cloaking Host" function with:
	AH = 7Fh
Return: AX = status
	    0000h failed
	    0001h (successful) if installed
		BX = version (0101h for v1.01)
		CX = flags
		    bit 0: host is VCPI-based
		DS:DX -> ASCIZ Cloaking host signature
		    "CLOAKING.EXE"0, followed by a far-call entry point to
		      uninstall host (see #1367) in Helix's CLOAKING.EXE
SeeAlso: #1365,#1368
Index:	installation check;Cloaking host|installation check;CLOAKING.EXE

(Table 1367)
Call the CLOAKING.EXE "Uninstall Host" function with:
Return:	AX = 4F4Bh ('OK') if successfully uninstalled protected-mode code

(Table 1368)
Call the Cloaking "Start Protected-Mode Client" function with:
	AH = 82h
	DX = XMS handle of locked block containing protected-mode code
	CL = code size (00h 16-bit, else 32-bit)
	ESI, EDI = parameters to pass to protected-mode code
Return: AX = status
	    nonzero success
	    0000h failed
		BL = error code (A2h,B0h) (see #1362)
Notes:	this function calls a user initialization function at offset 0 in
	  the XMS memory block (see #1369)
	supported by Helix's RM386 v6.00 and Helix's CLOAKING.EXE
SeeAlso: #1365,#1366

(Table 1369)
Values user initialization function is called with:
	EBX = physical address of block's start
	ESI = user data from function 82h call
	EDI = user data from function 82h call
	CS = code selector for XMS block at EBX (16-bit or 32-bit)	
	DS = data selector for XMS block, starting at EBX
	ES = selector for V86 memory access to full real-mode 1088K
	GS = selector for full 4G flat address space
	SS:ESP -> stack provided by host
Return: via 32-bit FAR return
Note:	the initialization function may call any protected-mode Cloaking
	  service; it should store the values of DS, ES, and GS for future
	  reference
--------m-2F4320-----------------------------
INT 2F U - HIMEM.SYS - Mach 20 SUPPORT
	AX = 4320h
	???
Return: ???
--------m-2F4330-----------------------------
INT 2F CU - HIMEM.SYS v2.77+ - GET EXTERNAL A20 HANDLER ADDRESS
	AX = 4330h
Return: AL = 80h if external A20 handler provided
	    ES:BX -> external A20 handler (see #1370)
	    CL = A20 detection support
		00h handler is unable to report A20 state
		01h handler supports function 0002h to report A20 state
Note:	HIMEM.SYS calls this function to allow an external program to provide
	  an A20 handler (i.e. to support a machine not supported by HIMEM
	  itself)
SeeAlso: AX=4308h,AX=4310h

(Table 1370)
Call parameters for external A20 handler are:
	AX = function
	    0000h disable A20
	    0001h enable A20
	    0002h get A20 state
Return: AX = status (functions 0000h and 0001h)
	    0000h failure
	    0001h successful
	AX = A20 state (function 0002h)
	    0000h disabled
	    0001h enabled
Note:	HIMEM.SYS only calls function 0002h if the returned CL indicated that
	  the handler supports the call
--------E-2F43E0BX0000-----------------------
INT 2F - DOS Protected Mode Services (DPMS) v1.0 - INSTALLATION CHECK
	AX = 43E0h
	BX = 0000h
	CX = 4450h ('DP')
	DX = 4D53h ('MS')
Return: AX = 0000h if installed
	    CF clear
	    ES:DI -> server structure (see #1371)
	    ES:BX -> registration structure (pre-NWDOS 7 beta spec) (see #1373)
Note:	the DPMS 1.0 server included with the original release of Novell DOS
	  7.0 supports both the beta and 1.0 specification, setting ES:BX even
	  if CX and DX are not as specified on entry (since the beta
	  specification did not use those registers).  However, the DPMS 1.1
	  server included with the March 1994 update does not support the beta
	  specification
SeeAlso: AX=43E1h,AX=43E2h,AX=43E3h,INT 2F/AX=1687h
Index:	signature strings;DPMS

Format of DPMS 1.0 server structure:
Offset	Size	Description	(Table 1371)
 00h  4 BYTEs	signature string "DPMS"
 04h  2 BYTEs	DPMS version (major,minor)
 06h  8 BYTEs	blank-padded server OEM name
 0Eh  2 BYTEs	OEM server version (major,minor)
 10h	WORD	DPMS flags (see #1372)
 12h	BYTE	CPU type
		(02h = 286, 03h = 386 or higher, higher values allowed)

Bitfields for DPMS flags:
Bit(s)	Description	(Table 1372)
 0	fast processor reset available (286 only)
 1	DPMS server is enabled
 2	memory is remapped
 3-15	reserved (undefined)

Format of beta DPMS registration structure:
Offset	Size	Description	(Table 1373)
 00h	DWORD	real-mode API entry point (see #1375)
 04h	DWORD	16-bit protected-mode API entry point (see #1375)
 08h  8 BYTEs	reserved (0)
 10h  8 BYTEs	blank-padded server OEM name
 18h	WORD	flags
		bit 0: fast processor reset available (286 only)
		bits 1-15 reserved (undefined)
 1Ah  2 BYTEs	DPMS version (major,minor)
 1Ch	BYTE	CPU type (02h = 286, 03h = 386 or higher)
----------2F43E1-----------------------------
INT 2F - DOS Protected Mode Services (DPMS) v1.0 - REGISTER CLIENT
	AX = 43E1h
	CX = required protected-mode stack size in bytes
	ES:DI -> DPMS client interface structure (see #1374)
Return: AX = 0000h if supported
	   CF clear
	   ES:DI buffer filled with API entry point code from offset 0Ah
Note:	the client is allowed to copy the returned API code to any location in
	  memory, and need not keep the three code fields together
SeeAlso: AX=43E0h,AX=43E2h,AX=43E3h

Format of DPMS client interface structure:
Offset	Size	Description	(Table 1374)
 00h	WORD	0000h (structure version / flags)
 02h  8 BYTEs	blank-padded client name
 0Ah  7 BYTEs	real/virtual-86 mode API code (see #1375)
 11h	BYTE	space for return instruction
		set to C3h for near return, CBh for far return
 12h  7 BYTEs	16-bit protected-mode API code (see #1375)
 19h	BYTE	space for return instruction
		set to C3h for near return, CBh for far return
 1Ah  9 BYTEs	32-bit protected-mode API code (see #1375)
 23h	BYTE	space for return instruction
		set to C3h for near return, CBh for far return
Note:	the DPMS server fills the return opcode bytes with zeros and DPMS
	  requests will thus crash the system unless the application
	  explicitly sets them (some early versions set them to C3h by
	  default, but one should not rely on that)

(Table 1375)
Call DPMS entry point with:
	AX = 0000h unregister client from server
 ---control transfer functions---
	AX = 0100h call protected-mode procedure
		CX = number of words of stack to copy
		ES:(E)DI -> callup/down register structure (see #1377)
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0101h call real-mode procedure (RETF return)
		CX = number of words of stack to copy
		ES:(E)DI -> callup/down register structure (see #1377)
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0102h call real-mode procedure (IRET return)
		CX = number of words of stack to copy
		ES:(E)DI -> callup/down register structure (see #1377)
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0103h call real-mode interrupt handler
		BL = interrupt number
		CX = number of words of stack to copy
		ES:(E)DI -> callup/down register structure (see #1377)
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0104h register default protected mode procedure
		ES:(E)DI -> default register structure (see #1378)
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0105h register default real-mode procedure (RETF return)
		ES:(E)DI -> default register structure (see #1378)
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
		Note:	the procedure will be called from 16-bit prot. mode
	AX = 0106h register default real-mode procedure (IRET return)
		ES:(E)DI -> default register structure (see #1378)
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
		Note:	the procedure will be called from 16-bit prot. mode
	AX = 0107h register default real-mode interrupt handler
		BL = interrupt number
		ES:(E)DI -> default register structure (see #1378)
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
		Note:	the handler will be called from 16-bit protected mode
	AX = 0108h register default real-mode procedure (RETF return)
		ES:(E)DI -> default register structure (see #1378)
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
		Note:	the procedure will be called from 32-bit prot. mode
	AX = 0109h register default real-mode procedure (IRET return)
		ES:(E)DI -> default register structure (see #1378)
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
		Note:	the procedure will be called from 32-bit prot. mode
	AX = 010Ah register default real-mode interrupt handler
		BL = interrupt number
		ES:(E)DI -> default register structure (see #1378)
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
		Note:	the handler will be called from 32-bit protected mode
 ---descriptor management---
	AX = 0200h allocate descriptors
		CX = number of descriptors to allocate
		Return: CF clear if successful
			    AX = selector for first descriptor allocated
			CF set on error
			    AX = error code (see #1376)
	AX = 0201h free a descriptor
		BX = selector for descriptor
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0202h create alias descriptor
		BX = selector for descriptor to be aliased
		Return: CF clear if successful
			    AX = alias descriptor
			CF set on error
			    AX = error code (see #1376)
	AX = 0203h build alias to real-mode segment
		BX = descriptor
		CX = real-mode segment
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0204h set descriptor base
		BX = descriptor
		CX:DX = base address
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0205h set descriptor limit
		BX = descriptor
		CX = limit
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0206h set descriptor type/attribute
		BX = descriptor
		CL = type
		CH = attribute
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0207h get descriptor base
		BX = descriptor
		Return: CF clear if successful
			    CX:DX = base address
			CF set on error
			    AX = error code (see #1376)
 ---linear memory functions---
	AX = 0300h get size of largest free block of memory
		Return: CF clear if successful
			    BX:CX = size
			CF set on error
			    AX = error code (see #1376)
	AX = 0301h allocate block of extended memory
		BX:CX = required size
		Return: CF clear if successful
			    BX:CX = base address
			    SI:DI = handle
			CF set on error
			    AX = error code (see #1376)
	AX = 0302h free block of extended memory
		SI:DI = handle
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0303h map linear memory
		ES:(E)DI -> DDS (see #1379)
		Return: CF clear if successful
			    BX:CX = base address
			    SI:DI = handle
			CF set on error
			    AX = error code (see #1376)
	AX = 0304h unmap linear memory
		SI:DI = handle
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0305h get page table entries
		ESI = linear address
		(E)CX = count
		ES:(E)DI -> buffer for page table entries
		Return: CF clear if successful
			    ES:(E)DI buffer filled
			CF set on error
			    AX = error code (see #1376)
	AX = 0306h set page table entries
		EBX = linear memory handle
		ESI = linear address
		(E)CX = count
		ES:(E)DI -> buffer containing page table entries
		Return: CF clear if successful
			CF set on error
			    AX = error code (see #1376)
	AX = 0307h get largest mappable block size
		Return: CF clear if successful
			    BX:CX = size
			CF set on error
			    AX = error code (see #1376)
 ---miscellaneous---
	AX = 0400h relocate segment to extended memory
		ES:SI = base address
		CX = limit
		BL = type
		BH = attribute
		DX = selector or 0000h
		Return: CF clear if successful
			    AX = selector
			    BX:CX = new base address
			    SI:DI = handle
			CF set on error
			    AX = error code (see #1376)
Note:	the beta DPMS specification, which is still supported by the Novell
	  DOS 7.0 DPMS host, only supported functions 0100h-0103h, 0200h-0207h,
	  0300h-0304h, and 0400h

(Table 1376)
Values for DPMS error code:
 8000h	general error
 8001h	unsupported function
 8002h	unable to switch to protected mode
 8004h	no default stack defined
 8005h	unknown client
 8010h	resource unavailable
 8011h	descriptor unavailable
 8012h	linear memory unavailable
 8013h	physical memory unavailable
 8021h	invalid value
 8022h	invalid selector
 8023h	invalid handle
 8025h	invalid linear address

Format of DPMS callup/down register structure:
Offset	Size	Description	(Table 1377)
 00h	DWORD	EDI
 04h	DWORD	ESI
 08h	DWORD	EBP
 0Ch  4 BYTEs	reserved (0) (ESP, may be used by DPMS server)
 10h	DWORD	EBX
 14h	DWORD	EDX
 18h	DWORD	ECX
 20h	DWORD	EAX
 24h	DWORD	EIP
 28h	WORD	CS
 2Ah  2 BYTEs	reserved (0)
 2Ch	DWORD	EFLAGS
 30h	DWORD	ESP
 34h	WORD	SS
 36h  2 BYTEs	reserved (0)
 38h	WORD	ES
 3Ah  2 BYTEs	reserved (0)
 3Ch	WORD	DS
 3Eh  2 BYTEs	reserved (0)
 40h	WORD	FS
 42h  2 BYTEs	reserved (0)
 44h	WORD	GS
 46h  2 BYTEs	reserved (0)

Format of DPMS default register structure:
Offset	Size	Description	(Table 1378)
 00h	DWORD	EIP
 04h	WORD	CS
 06h  2 BYTEs	reserved (0)
 08h	WORD	number of words to copy from stack to stack
 0Ah	BYTE	(call) 00h
		(return) nonzero if call could not be made
 0Bh	BYTE	reserved (may be used by some servers)
 0Ch	DWORD	ESP
 10h	WORD	SS
 12h  2 BYTEs	reserved (0)
 14h	WORD	ES
 16h  2 BYTEs	reserved (0)
 18h	WORD	DS
 1Ah  2 BYTEs	reserved (0)
 1Ch	WORD	FS
 1Eh  2 BYTEs	reserved (0)
 20h	WORD	GS
 22h  2 BYTEs	reserved (0)
 24h  9 BYTEs	API entry code (filled in by server)

Format of DPMS lock DDS:
Offset	Size	Description	(Table 1379)
 00h	DWORD	total size in bytes
 04h	DWORD	offset
 08h	WORD	segment or selector
 0Ah	WORD	reserved
 0Ch	WORD	maximum number of physical blocks structure has space for
 0Eh	WORD	number of physical blocks listed
 10h	DWORD	physical address of first block
 14h	DWORD	size in bytes of first block
	...
----------2F43E2-----------------------------
INT 2F - DOS Protected Mode Services (DPMS) v1.0 - ENABLE/DISABLE DPMS
	AX = 43E2h
	BX = new state (0000h disable, 0001h enable)
Return: AX = 0000h if supported
Note:	this function should normally be called only by system software
SeeAlso: AX=43E0h,AX=43E1h,AX=43E3h
----------2F43E3BX0000-----------------------
INT 2F - DOS Protected Mode Services (DPMS) v1.0 - DPMS STARTUP BROADCAST
	AX = 43E3h
	BX = 0000h
	CX = 4450h ('DP')
	DX = 4D53h ('MS')
SeeAlso: AX=43E0h,AX=43E4h 
----------2F43E4BX0000-----------------------
INT 2F - DOS Protected Mode Services (DPMS) v1.0 - DPMS EXIT BROADCAST
	AX = 43E4h
	BX = 0000h
	CX = 4450h ('DP')
	DX = 4D53h ('MS')
SeeAlso: AX=43E0h,AX=43E3h 
--------E-2F44-------------------------------
INT 2F U - DOS Extender support???
	AH = 44h
	AL = function (at least 0Bh, 15h, 17h)
	???
Return: ???
Note:	called by Codeview for Windows
SeeAlso: AH=86h
--------G-2F4500-----------------------------
INT 2F U - Microsoft Profiler (PROF.COM/VPROD.386) - INSTALLATION CHECK
	AX = 4500h
Return: AL = installation status
	    01h if PROF.COM installed
	    02h if VPROD.386 installed
SeeAlso: AX=4501h,AX=4502h
--------G-2F4501-----------------------------
INT 2F U - Microsoft Profiler (PROF.COM/VPROD.386) - SETUP PROFILER
	AX = 4501h
	BX = CSIPS buffer size in KB (first parameter for ProfSetup)
	CX = output limit in KB (second parameter for ProfSetup)
Note:	this call is not supported by PROF.COM
SeeAlso: AX=4502h,AX=4503h
--------G-2F4502-----------------------------
INT 2F U - Microsoft Profiler (PROF.COM/VPROD.386) - SET SAMPLING RATE
	AX = 4502h
	BL = sampling rate for PROF.COM (0 < BL <= 13)
	    (01h = 8192/s, 04h = 1024/s, 08h = 32/s, 0Dh = 1/s)
	CX = sampling rate for VPROD.386
Note:	for PROF.COM, this programs the CMOS clock by setting BL+2 as the
	  low four bits of CMOS register 0Ah.  The interruption rate is
	  1 SHL (15 - BL) per second.
SeeAlso: AX=4501h,AX=4503h
--------G-2F4503-----------------------------
INT 2F U - Microsoft Profiler (PROF.COM/VPROD.386) - START PROFILING
	AX = 4503h
Notes:	Profiling is also turned on by the key combinations
	  LeftShift + RightShift + Alt and LeftShift + RightShift + Ctrl
	for PROF.COM, this call programs the CMOS clock by reading register
	  0Ch, and setting bit 6 of register 0Bh.  It then makes sure that IRQ8
	  is unmasked
SeeAlso: AX=4504h
--------G-2F4504-----------------------------
INT 2F U - Microsoft Profiler (PROF.COM/VPROD.386) - STOP PROFILING
	AX = 4504h
Notes:	profiling is also turned off by the key combination
	  LeftShift + RightShift
	for PROF.COM, this programs the CMOS clock by reading register 0Ch
	  and clearing bit 6 of register 0Bh.  It then masks IRQ8.
SeeAlso: AX=4503h,AX=4505h,AX=4506h,AX=4507h
--------G-2F4505-----------------------------
INT 2F U - Microsoft Profiler (PROF.COM/VPROD.386) - CLEAR PROFILING DATA
	AX = 4505h
SeeAlso: AX=4503h,AX=4504h,AX=4506h
--------G-2F4506-----------------------------
INT 2F U - Microsoft Profiler (PROF.COM/VPROD.386) - "ProfFlush"
	AX = 4506h
SeeAlso: AX=4505h,AX=4507h
--------G-2F4507-----------------------------
INT 2F U - Microsoft Profiler (PROF.COM/VPROD.386) - "ProfFinish"
	AX = 4507h
Note:	this call is essentially a "ProfStop" (AX=4504h) followed by
	  "ProfFlush" (AX=4506h)
SeeAlso: AX=4504h,AX=4505h,AX=4506h
--------G-2F4508-----------------------------
INT 2F U - Microsoft Profiler (PROF.COM/VPROD.386) - ALTERNATE SEGDEBUG IFACE
	AX = 4508h
	BX = ordinal (or 0000h)
	CX = segment
	DX = instance (or 0000h)
	SI = type (or 0000h)
	ES:DI -> ASCIZ module name
Notes:	this call is an alternate entry to the profiler's SEGDEBUG
	  interface, but only to function 0, for notifying the profiler of
	  each new segment loaded.  The SHOWHITS utility then examines the
	  profiler's output files (CSIPS.DAT and SEGENTRY.DAT) in conjunction
	  with symbol files to provide information in a useful form.
	this call does not have a corresponding Windows function
SeeAlso: AX=4500h
--------D-2F4601-----------------------------
INT 2F CU - MS Windows WINOLDAP - SWITCHING ???
	AX = 4601h
Return: ???
Note:	the DOS 5+ kernel intercepts this function and copies the MCB
	   following the caller's PSP memory block into the DOS data segment;
	   in conjunction with AX=4602h, this intercept is used by DOS to
	   avoid corruption of the Windows real-mode heap's end sentinel
SeeAlso: AX=1700h,AX=4602h
--------D-2F4602-----------------------------
INT 2F CU - MS Windows WINOLDAP - SWITCHING ???
	AX = 4602h
Return: ???
Note:	the DOS 5+ kernel intercepts this function and copies the
	  previously-saved MCB from the DOS data segment into the MCB following
	  the caller's PSP memory block; in conjunction with AX=4601h, this
	  intercept is used by DOS to avoid corruption of the Windows real-mode
	  heap's end sentinel
SeeAlso: AX=1700h,AX=4601h
--------E-2F46-------------------------------
INT 2F U - Windows/286 DOS Extender
	AH = 46h
	AL = subfunction (03h,04h)
Return: ???
Note:	these two subfunctions are called by MS Windows 3.0
--------v-2F4653CX0002-----------------------
INT 2F - F-PROT v1.x only - F-LOCK.EXE - API
	AX = 4653h
	CX = 0002h
	BX = subfunction
	    0000h  installation check
		Return: AX = FFFFh
	    0001h  uninstall
		Return: AX,BX,ES destroyed
	    0002h  disable (v1.08 and below only)
	    0003h  enable (v1.08 and below only)
Program: F-LOCK is part of the shareware F-PROT virus/trojan protection
	  package by Fridrik Skulason
SeeAlso: AX=4653h/CX=0003h,AX=CA00h,INT 21/AX=4BEEh
Index:	installation check;F-LOCK|uninstall;F-LOCK
--------v-2F4653CX0003-----------------------
INT 2F - F-PROT v1.x only - F-XCHK.EXE - API
	AX = 4653h
	CX = 0003h
	BX = subfunction
	    0000h  installation check
		Return: AX = FFFFh
	    0001h  uninstall
		Return: AX,BX,ES destroyed
Program: F-XCHK is part of the shareware F-PROT virus/trojan protection
	  package by Fridrik Skulason
SeeAlso: AX=4653h/CX=0002h,AX=4653h/CX=0004h,AX=CA00h
Index:	installation check;F-XCHK|uninstall;F-XCHK
--------v-2F4653CX0004-----------------------
INT 2F - F-PROT v1.x only - F-POPUP.EXE - API
	AX = 4653h
	CX = 0004h
	BX = subfunction
	    0000h  installation check
		Return: AX = FFFFh
	    0001h  uninstall
		Return: AX,BX,ES destroyed
	    0002h  disable (v1.08 and below only)
		   display message (v1.14+)
			other registers: ???
	    0003h  enable (v1.08 and below only)
		   display message (v1.14+)
			other registers: ???
			Return: AX = key pressed by user
Program: F-POPUP is part of the shareware F-PROT virus/trojan protection
	  package by Fridrik Skulason
SeeAlso: AX=4653h/CX=0003h,AX=4653h/CX=0005h,AX=CA00h
Index:	installation check;F-POPUP|uninstall;F-POPUP
--------v-2F4653CX0005-----------------------
INT 2F - F-PROT v1.x only - F-DLOCK.EXE - API
	AX = 4653h
	CX = 0005h
	BX = subfunction
	    0000h installation check
		Return: AX = FFFFh
	    0001h uninstall
		Return: AX,BX,ES destroyed
Program: F-DLOCK is part of the shareware F-PROT virus/trojan protection
	  package by Fridrik Skulason
SeeAlso: AX=4653h/CX=0004h,AX=CA00h
Index:	installation check;F-DLOCK|uninstall;F-DLOCK
--------W-2F4680-----------------------------
INT 2F U - MS Windows v3.0 - INSTALLATION CHECK
	AX = 4680h
Return: AX = result
	    0000h MS Windows 3.0 running in real (/R) or standard (/S) mode,
		  or DOS 5 DOSSHELL active
	    nonzero  no Windows, Windows prior to 3.0, or Windows3 in enhanced
		  mode
Note:	Windows 3.1 finally provides an installation check which works in all
	  modes (see AX=160Ah)
SeeAlso: AX=1600h,AX=160Ah
----------2F47-------------------------------
INT 2F U - ???
	AH = 47h
	???
Return: ???
Note:	reportedly called by Microsoft BASIC Compiler v7.0
--------K-2F4800-----------------------------
INT 2F - DOS 5+ DOSKEY - INSTALLATION CHECK
	AX = 4800h
Return: AL = nonzero if installed (DOS 5.0 and 6.0 return AX=AA02h)
	    ES = segment of DOSKEY resident portion
Note:	DOSKEY chains if AL is not 00h or 10h on entry
SeeAlso: AX=4800h"PCED",AX=4810h
--------K-2F4800-----------------------------
INT 2F - PCED v2.1 - INSTALLATION CHECK
	AX = 4800h
Return: AX = AACDh if installed
	    ES = segment of PCED kernel (PCED has multiple code segments)
Program: PCED v2.1 is a command line editor/history/macro facility by
	  Cove Software.  It is the commercial version of the freeware CED.
Notes:	DOSKEY also responds to this call if installed, returning AX=AA02h.
	unlike DOSKEY, PCED does *not* chain if AL contains an
	  unsupported function code.  It IRETs with all registers intact.
--------K-2F4810-----------------------------
INT 2F - DOS 5+ DOSKEY, PCED v2.1 - READ INPUT LINE FROM CONSOLE
	AX = 4810h
	DS:DX -> line buffer (see INT 21/AH=0Ah)
Return: AX = 0000h if successful
Notes:	the first byte (length) of the buffer MUST be 80h, or DOSKEY chains to
	  the previous handler; PCED allows sizes other than 80h
	if the user's input is a macro name, no text is placed in the buffer
	  even though AX=0000h on return; the program must immediately issue
	  this call again to retrieve the expansion of the macro.  Similarly,
	  if the user enters a special parameter such as $*, this call must
	  be repeated to retrieve the expansion; on the second call, DOSKEY
	  overwrites the macro name on the screen with its expansion.
	unlike DOSKEY, PCED expands all macros on the first call, so it is
	  not necessary to make two calls; since the buffer is not empty on
	  return, DOSKEY-aware programs will not make the second call
	DOSKEY chains if AL is not 00h or 10h on entry
SeeAlso: AX=4800h,INT 21/AH=0Ah
--------K-2F48C0-----------------------------
INT 2F - PCED v2.1 - PCED API
	AX = 48C0h
	DX = API function code
	other registers as required by the specified function
Return: CF clear if successful
	CF set on error
	    AX = PCED error code
	other registers as appropriate for API function
Program: PCED v2.1 is a command line editor/history/macro facility by
	  Cove Software.  It is the commercial version of the freeware CED.
Note:	the full API information is available from Cove Software
SeeAlso: AX=4800h"PCED",AX=48C1h,AX=48C2h,AX=48C3h
----------2F48C1BL00-------------------------
INT 2F - PCED/VSTACK - INSTALLATION CHECK
	AX = 48C1h
	BL = 00h
Return: AX = 0000h if installed
	    BX = VSTACK resident segment
Program: VSTACK is a resident backscroll utility included as part of the PCED
	  package by Cove Software
Note:	chains if BL <> 00h on entry
SeeAlso: AX=48C0h,AX=48C2h
----------2F48C2BL00-------------------------
INT 2F - PCED/ATTRIB - INSTALLATION CHECK
	AX = 48C2h
	BL = 00h
Return: AX = 0000h if installed
	    BX = ATTRIB resident segment
Program: ATTRIB is a resident file attribute changer included as part of the
	  PCED package by Cove Software
Note:	chains if BL <> 00h on entry
SeeAlso: AX=48C0h,AX=48C1h,AX=48C3h
--------K-2F48C3BL00-------------------------
INT 2F - PCED/KEYDEF - INSTALLATION CHECK
	AX = 48C3h
	BL = 00h
Return: AX = 0000h if installed
	    BX = KEYDEF resident segment
Program: KEYDEF is a resident keyboard redefinition utility included as part
	  of the PCED package by Cove Software
Note:	chains if BL <> 00h on entry
SeeAlso: AX=48C0h,AX=48C2h,AX=48C4h
----------2F48C4BL00-------------------------
INT 2F - PCED/FLIST - INSTALLATION CHECK
	AX = 48C4h
	BL = 00h
Return: AX = 0000h if installed
	    BX = FLIST resident segment
Program: FLIST is a resident filelist processor included as part of the PCED
	  package by Cove Software
Note:	chains if BL <> 00h on entry
SeeAlso: AX=48C0h,AX=48C3h,AX=48C5h
----------2F48C4BL00-------------------------
INT 2F - PCED/ASSOC - INSTALLATION CHECK
	AX = 48C4h
	BL = 00h
Return: AX = 0000h if installed
	    BX = ASSOC resident segment
Program: ASSOC is a resident utility included as part of the PCED package which
	  associated files with executable programs based on their extensions
Note:	chains if BL > 02h on entry
SeeAlso: AX=48C0h,AX=48C4h,AX=48C5h/BL=01h,AX=48C5h/BL=02h
----------2F48C5BL01-------------------------
INT 2F - PCED/ASSOC - VERSION CHECK
	AX = 48C5h
	BL = 01h
Return: AX = 0000h if installed
	    BX = binary ASSOC version (BL = major, BH = minor)
Note:	chains if BL > 02h on entry
SeeAlso: AX=48C0h,AX=48C5h/BL=00h,AX=48C5h/BL=02h
----------2F48C5BL02-------------------------
INT 2F - PCED/ASSOC - ASSOCIATION TEST
	AX = 48C5h
	BL = 02h
	DS:SI -> ASCIZ filename
Return: AX = status
	    0000h if filename is unknown
	    0001h if there is an association defined for the file
	BX destroyed
Program: ASSOC is a resident utility included as part of the PCED package which
	  associated files with executable programs based on their extensions
Note:	chains if BL > 02h on entry
SeeAlso: AX=48C0h,AX=48C5h/BL=00h,AX=48C5h/BL=01h
----------2F49-------------------------------
INT 2F U - ???
	AH = 49h
	???
Return: ???
Note:	reportedly called by DOS 5.0 installation
--------D-2F4A00CX0000-----------------------
INT 2F CU - DOS 5+ - FLOPPY-DISK LOGICAL DRIVE CHANGE NOTIFICATION
	AX = 4A00h
	CX = 0000h
	DH = new drive number
	DL = current drive number
Return: CX = FFFFh to skip "Insert diskette for drive X:" message
Note:	called by MS-DOS 5.0+ IO.SYS just before displaying the message
	  "Insert diskette for drive X:" on single-floppy systems
--------D-2F4A01-----------------------------
INT 2F - DOS 5+ - QUERY FREE HMA SPACE
	AX = 4A01h
Return: BX = number of bytes available in HMA (0000h if DOS not using HMA)
	ES:DI -> start of available HMA area (FFFFh:FFFFh if not using HMA)
Note:	called by Windows 3.1 DOSX.EXE
SeeAlso: AX=4310h,AX=4A02h
--------D-2F4A02-----------------------------
INT 2F - DOS 5+ - ALLOCATE HMA SPACE
	AX = 4A02h
	BX = number of bytes
Return: ES:DI -> start of allocated HMA block or FFFFh:FFFFh
	BX = number of bytes actually allocated (rounded up to next paragraph
	      for DOS 5.0 and 6.0)
Notes:	this call is not valid unless DOS is loaded in the HMA (DOS=HIGH)
	called by Windows 3.1 DOSX.EXE
SeeAlso: AX=4A01h
--------T-2F4A05-----------------------------
INT 2F U - DOS 5+ DOSSHELL - TASK SWITCHING API???
	AX = 4A05h
	SI = function
	    0000h reset???
	    0001h ???
		ES:BP -> 80-byte buffer containing ???
	    0002h ???
	    0003h ???
	    0004h ???
		BL = ???
	    0005h ???
	    0006h get ???
		Return: ES:SI -> ???
	    0007h get ???
		Return: AX = ???
	    0008h get ???
		Return: DX:AX -> ??? (internal control data of some kind)
	    0009h get ???
		Return: ES:SI -> ??? (apparently identical to function 0006h)
	    000Ah ???
		BL = length of buffer
		ES:BP -> buffer containing ???
	    000Bh get ???
		Return: AX = ???
	    000Ch ???
		BL = ???
		Return: if BL nonzero on entry
			    DX:AX -> ???
			if BL = 00h on entry
			    ES:SI -> ???
Notes:	DOSSHELL chains to the previous handler if SI is not one of the values
	  listed above
	the DOSSWAP.EXE module calls functions 03h,04h,05h,07h,08h,09h,0Ch
	the Windows 3.1 DSWAP.EXE and WSWAP.EXE task switchers use these calls
SeeAlso: AX=4B01h
--------D-2F4A06-----------------------------
INT 2F CU - DOS 5+ - DOS SUPERVISOR "REBOOT PANEL" - ADJUST MEMORY SIZE
	AX = 4A06h
	DX = segment following last byte of conventional memory
Return: DX = segment following last byte of memory available for use by DOS
Desc:	used to override the default memory size when booting diskless
	  workstations
Notes:	called by MS-DOS 5+ IO.SYS startup code if the signature "RPL" is
	  present three bytes beyond the INT 2F handler; this call overrides
	  the value returned by INT 12
	hooked by RPL code at the top of memory to protect itself from being
	  overwritten; DOS builds a memory block with owner = 0008h and name
	  "RPL" which must be freed by the RPL code when it is done
SeeAlso: INT 12,INT 18
--------N-2F4A07-----------------------------
INT 2F U - RESERVED FOR PROTMAN SUPPORT
	AX = 4A07h
	???
Return: ???
--------c-2F4A10BX0000-----------------------
INT 2F - SMARTDRV v4.00+ - INSTALLATION CHECK AND HIT RATIOS
	AX = 4A10h
	BX = 0000h
	CX = EBABh (v4.1+; see Note)
Return: AX = BABEh if installed
	    DX:BX = cache hits
	    DI:SI = cache misses
	    CX = number of dirty cache elements
	    BP = version in BCD (4.10 = 0410h)
Notes:	most of the SMARTDRV API, including this call, is supported by
	  PC-Cache v8.0 and recent versions of the Norton Caches
	if DBLSPACE.BIN is installed but SMARTDRV has not yet been installed,
	  then calls of this function with CX<>EBABh on entry cause
	  DBLSPACE.BIN to display the error message
	  "Cannot run SMARTDrive 4.0 with DoubleSpace" and abort the caller
	  with INT 21/AX=4C00h
	SMARTDRV v3.x had a completely different API using IOCTL calls, which
	  was also supported by the Norton Caches
SeeAlso: AX=4A10h/BX=0001h,AX=4A10h/BX=0004h,AX=4A10h/BX=0005h
SeeAlso: AX=4A10h/BX=0007h,AX=4A10h/BX=1234h,AX=4A11h/BX=0000h
SeeAlso: INT 21/AX=4402h"SMARTDRV",INT 21/AX=4403h"SMARTDRV"
----------2F4A10BX0000-----------------------
INT 2F U - Novell NWCACHE - ???
	AX = 4A10h
	BX = 0000h
	CX = 0EDCh
Return: ???
SeeAlso: AX=4A10h/BX=0001h"NWCACHE"
--------c-2F4A10BX0001-----------------------
INT 2F - SMARTDRV v4.00+ - FLUSH BUFFERS (COMMIT CACHE)
	AX = 4A10h
	BX = 0001h
Note:	this function is also supported by PC-Cache v8.0.
SeeAlso: AX=4A10h/BX=0000h,AX=4A10h/BX=0002h
----------2F4A10BX0001-----------------------
INT 2F U - Novell NWCACHE - ???
	AX = 4A10h
	BX = 0001h
	CX = 0EDCh
Return: ???
SeeAlso: AX=4A10h/BX=0000h"NWCACHE"
--------c-2F4A10BX0002-----------------------
INT 2F - SMARTDRV v4.00+ - RESET CACHE
	AX = 4A10h
	BX = 0002h
Note:	this function is also supported by PC-Cache v8.0.
SeeAlso: AX=4A10h/BX=0000h,AX=4A10h/BX=0001h
--------c-2F4A10BX0003-----------------------
INT 2F - SMARTDRV v4.00+ - STATUS
	AX = 4A10h
	BX = 0003h
	BP = drive number (0=A, 1=B, etc.)
	DL = subfunction
	    00h only get information
	    01h turn on read cache
	    02h turn off read cache
	    03h turn on write cache
	    04h turn off write cache
Return: AX = BABEh if OK
	DL = status (see #1380)
	DL = FFh if drive does not exist
Notes:	If the read cache is off, reads will not be cached, but writes will
	  continue to be cached if the write-cache is enabled.
	this function is also supported by PC-Cache v8.0.
SeeAlso: AX=4A10h/BX=0000h

Bitfields for SMARTDRV status:
Bit(s)	Description	(Table 1380)
 7	not cached
 6	write-through (not write-cached)
 0-5	real drive number (0=A, 1=B...)
--------c-2F4A10BX0004-----------------------
INT 2F - SMARTDRV v4.00+ - GET CACHE SIZE
	AX = 4A10h
	BX = 0004h
Return: AX = size in elements of full-sized cache
	BX = current size in elements
	CX = size of one element in bytes
	DX = number of elements under Windows
Note:	this function is also supported by PC-Cache v8.0.
SeeAlso: AX=4A10h/BX=0000h,AX=4A10h/BX=0003h,AX=4A10h/BX=0005h
--------c-2F4A10BX0005-----------------------
INT 2F - SMARTDRV v4.00+ - GET DOUBLE-BUFFER STATUS
	AX = 4A10h
	BX = 0005h
	BP = drive number (0=A, 1=B...)
Return: AX = BABEh if double-buffered
	    ES:DI -> 16-byte array of status bytes for fixed disks (see #1381)
SeeAlso: AX=4A10h/BX=0000h,AX=4A10h/BX=0003h,AX=4A10h/BX=0006h

(Table 1381)
Values for SMARTDRV status byte:
 00h	state unknown
 FFh	drive double-buffered
 else	not double-buffered
--------c-2F4A10BX0006-----------------------
INT 2F CU - SMARTDRV v4.00+ - CHECK IF DRIVE CACHEABLE
	AX = 4A10h
	BX = 0006h
	CL = drive number (01h = A:)
Return: AX = 0006h if drive should not be cached by SMARTDRV
Note:	called by SMARTDRV at startup to determine whether it should cache
	  a particular drive
SeeAlso: AX=4A10h/BX=0000h
--------c-2F4A10BX0007-----------------------
INT 2F - SMARTDRV v4.00+ - GET DEVICE DRIVER FOR DRIVE
	AX = 4A10h
	BX = 0007h
	BP = drive number (00h=A:)
Return: DL = unit number within device driver
	ES:DI -> device driver header for drive
Note:	this function is also supported by PC-Cache v8.0.
	this call is reported to always return the driver header of the
	  standard block driver (A:-C:+) for SmartDrive v5.00 from MS-DOS 6.2
SeeAlso: AX=4A10h/BX=0000h,AX=4A11h/BX=0003h,AX=4A11h/BX=0004h
--------c-2F4A10BX0008-----------------------
INT 2F - SMARTDRV v4.20+ - GET/SET FLUSH BEFORE PROMPT, CD-ROM SUPPORT
	AX = 4A10h
	BX = 0008h
	DL = subfunction
	    00h set
		DH = new states
		    bit 0: flush before prompt
		    bits 1-7 reserved (0)
	    01h get
		Return: DH = status flags
			    bit 0: (v4.2+) flush before prompt
			    bit 1: (v5.0+) CD-ROM caching support installed
Note:	v4.2 was an interim release to fix problems in the SMARTDRV included
	  with MS-DOS 6.00; v5.00 is included with MS-DOS 6.2
--------c-2F4A10BX000A-----------------------
INT 2F - SMARTDRV v4.00+ - GET ELEMENT STATUS TABLE
	AX = 4A10h
	BX = 000Ah
Return: ES:BX -> information pointer table (see #1382)
Note:	this function is also supported by PC-Cache v8.0.
SeeAlso: AX=4A10h/BX=0000h

Format of SMARTDRV information pointer table:
Offset	Size	Description	(Table 1382)
 00h	WORD	offset of ??? byte/word array (byte if elements < 2000h bytes)
 02h	WORD	offset of dirty flag byte/word array (byte if elts < 2000h)
		each byte/word is a bit string of the dirty sectors in element
 04h	WORD	offset of word array containing low halves of unique
		  identifiers for the corresponding element's contents
 06h	WORD	offset of word array containing high halves of unique
		  identifiers for the corresponding element's contents
 08h	WORD	offset of WORD containing current number of elements in cache
--------c-2F4A10BX1234-----------------------
INT 2F - SMARTDRV v4.00+ - SIGNAL SERIOUS ERROR
	AX = 4A10h
	BX = 1234h
Desc:	this function pops up a message box saying that a serious error
	  occurred and to hit R to retry, then waits for the keypress
Note:	this function is also supported by PC-Cache v8.0.
SeeAlso: AX=4A10h/BX=0000h
--------k-2F4A11BX0000-----------------------
INT 2F - DBLSPACE.BIN - "GetVersion" - INSTALLATION CHECK
	AX = 4A11h
	BX = 0000h
Return: AX = 0000h (successful)
	BX = 444Dh ("DM")
	CL = first drive letter used by DBLSPACE (41h ['A'] = A:)
	CH = number of drive letters used by DBLSPACE
	DX = internal DBLSPACE.BIN version number (bits 14-0)
		bit 15 set if DBLSPACE.BIN has not yet been relocated to final
		  position in memory (i.e. DBLSPACE.SYS /MOVE)
Program: DBLSPACE.BIN is the resident driver for DoubleSpace, the
	  disk-compression software bundled with MS-DOS 6.0
SeeAlso: AX=4A11h/BX=0001h,AX=4A11h/BX=0002h,AX=4A11h/BX=0003h
SeeAlso: AX=4A11h/BX=0005h,AX=4A11h/BX=0007h,AX=4A11h/BX=FFFFh
SeeAlso: INT 21/AX=4404h"DBLSPACE"
--------k-2F4A11BX0001-----------------------
INT 2F - DBLSPACE.BIN - "GetDriveMapping" - GET DRIVE MAPPING
	AX = 4A11h
	BX = 0001h
	DL = drive number (0=A:)
Return: AX = status (see also #1383)
	    0000h successful
		if DL was compressed drive,
		    BL = host drive (bit 7 set if drive is compressed)
		else if DL was host drive,
		    BL = compressed drive
		else
		    BL = specified drive (if available for DoubleSpace)
		BH = DoubleSpace sequence number
	    other error code (0101h) (see #1383)
		apparently never returned for the MS-DOS 6.2 DoubleSpace
Note:	the compressed volume file for the specified compressed drive is
	  host:\DBLSPACE.sequence
SeeAlso: AX=4A11h/BX=0000h

(Table 1383)
Values for DBLSPACE function status:
 0000h	successful
 0100h	bad function
 0101h	invalid drive
 0102h	not a compressed drive
 0103h	drive already swapped
 0104h	drive not swapped
--------k-2F4A11BX0002-----------------------
INT 2F - DBLSPACE.BIN - "Swap Drive" - SWAP DRIVE LETTERS OF CVF AND HOST DRIVE
	AX = 4A11h
	BX = 0002h
	DL = drive number (0=A:) of compressed drive to swap with its host
Return: AX = status (0000h,0101h,0102h,0103h) (see #1383)
Note:	this function is intended for use by DBLSPACE.EXE only
SeeAlso: AX=4A11h/BX=0000h
--------k-2F4A11BX0003-----------------------
INT 2F - DBLSPACE.BIN - "DSGetEntryPoints" - GET DEVICE DRIVER ENTRY POINTS
	AX = 4A11h
	BX = 0003h
	CL = drive number (0=A:) of compressed drive
Return: CL = FFh on error (not compressed drive)
	CL <> FFh driver unit number of host drive
	    ES:SI -> device driver's strategy routine
	    ES:DI -> device driver's interrupt routine
	BX destroyed
Note:	in conjunction with subfunction 0004h, this call allows disk caches
	  like SMARTDRV to apply a device driver wrapper to DoubleSpaced
	  drives just like SMARTDRV applies to regular block devices
SeeAlso: AX=4A10h/BX=0007h,AX=4A11h/BX=0000h,AX=4A11h/BX=0004h
--------k-2F4A11BX0004-----------------------
INT 2F - DBLSPACE.BIN - "DSSetEntryPoints" - SET DEVICE DRIVER ENTRY POINTS
	AX = 4A11h
	BX = 0004h
	CL = drive number (0=A:) of compressed drive
	DL = unit number for new driver entry points
	DH = 00h
	ES:SI -> device driver strategy routine to call for drive
	ES:DI -> device driver interrupt routine to call for drive
Return: CL = FFh on error (not a compressed drive)
	BX destroyed
Program: DBLSPACE.BIN is the resident driver for DoubleSpace, the
	  disk-compression software bundled with MS-DOS 6.0
Note:	in conjunction with subfunction 0003h, this call allows disk caches
	  like SMARTDRV to apply a device driver wrapper to DoubleSpaced
	  drives just like SMARTDRV applies to regular block devices
SeeAlso: AX=4A10h/BX=0007h,AX=4A11h/BX=0000h,AX=4A11h/BX=0003h
--------k-2F4A11BX0005-----------------------
INT 2F - DBLSPACE.BIN - "ActivateDrive" - MOUNT COMPRESSED DRIVE
	AX = 4A11h
	BX = 0005h
	DL = drive number (0=A:) to assign to new drive
	ES:SI -> activation record (see #1384)
Return: status returned in activation record (see #1385)
SeeAlso: AX=4A11h/BX=0000h,AX=4A11h/BX=0006h

Format of DBLSPACE activation record:
Offset	Size	Description	(Table 1384)
 00h  2 BYTEs	signature "MD" (4Dh 44h)
 02h	BYTE	4Dh ('M') mount command
 03h	BYTE	error code (set to FFh before calling) (see #1385)
 04h	BYTE	host drive number (0=A:)
 05h	???	DISK_UNIT structure (not documented)

(Table 1385)
Values for DBLSPACE Mount error code:
 00h	successful
 01h	drive letter not available for DoubleSpace
 02h	drive letter already in use
 03h	no more disk units (increase MaxRemovableDrives in .INI)
 09h	CVF too fragmented
--------k-2F4A11BX0006-----------------------
INT 2F - DBLSPACE.BIN - "DeactivateDrive" - UNMOUNT COMPRESSED DRIVE
	AX = 4A11h
	BX = 0006h
	DL = drive number (0=A:) to unmount
Return: AX = status (0000h,0102h) (see #1383)
SeeAlso: AX=4A11h/BX=0000h,AX=4A11h/BX=0005h
--------k-2F4A11BX0007-----------------------
INT 2F - DBLSPACE.BIN - "GetDriveSpace" - GET SPACE AVAIL ON COMPRESSED DRIVE
	AX = 4A11h
	BX = 0007h
	DL = compressed drive number (0=A:)
Return: AX = status (0000h,0102h) (see also #1383)
	    0000h successful
		DS:SI -> free space record (see #1386)
Program: DBLSPACE.BIN is the resident driver for DoubleSpace, the
	  disk-compression software bundled with MS-DOS 6.0
SeeAlso: AX=4A11h/BX=0000h,AX=4A11h/BX=0008h

Format of DBLSPACE free space record:
Offset	Size	Description	(Table 1386)
 00h	DWORD	total number of sectors in drive's sector heap
 04h	DWORD	number of free sectors in drive's sector heap
--------k-2F4A11BX0008-----------------------
INT 2F - DBLSPACE.BIN - "GetFileFragmentSpace" - GET SIZE OF FRAGMENT HEAP
	AX = 4A11h
	BX = 0008h
	DL = compressed drive number (0=A:)
Return: AX = status (0000h,0102h) (see also #1383)
	    0000h successful
		BX = maximum entries in File Fragment heap
		CX = available entries in File Fragment heap
SeeAlso: AX=4A11h/BX=0000h,AX=4A11h/BX=0007h,AX=4A11h/BX=0009h
--------k-2F4A11BX0009-----------------------
INT 2F - DBLSPACE.BIN - "GetExtraInfo" - DETERMINE NUMBER OF DISK_UNIT STRUCTS
	AX = 4A11h
	BX = 0009h
	DL = compressed drive number (0=A:)
Return: AX = status (see also #1383)
	    0000h successful
		CL = number of DISK_UNIT structures allocated
			  (see AX=4A11h/BX=0005h)
		CH = DoubleGuard enabled-checks bitflags in bits 6-0 (DOS 6.2)
Note:	the DoubleGuard checks are enabled or disabled as a block by the
	  DoubleGuard= line in DBLSPACE.INI; they may be individually set with
	  the CheckSum= line.
SeeAlso: AX=4A11h/BX=0000h,AX=4A11h/BX=0008h
--------k-2F4A11BX000A-----------------------
INT 2F - DBLSPACE.BIN v6.2 - SET AUTOMOUNT DRIVES
	AX = 4A11h
	BX = 000Ah
	CX:DX = bitmask of drives on which to enable AutoMount
		(DX bit 0 = A:, CX bit 0 = P:, etc.)
Return: AX = 0000h if supported
	    CX:DX = old mask or 0000h:0000h on error
	BX destroyed
SeeAlso: AX=4A11h/BX=000Bh
--------k-2F4A11BX000B-----------------------
INT 2F - DBLSPACE.BIN v6.2 - GET AUTOMOUNT DRIVES
	AX = 4A11h
	BX = 000Bh
Return: AX = 0000h if supported
	    CX:DX = mask of drives with AutoMount enabled
		0000h:0000h on error
	BX destroyed
SeeAlso: AX=4A11h/BX=000Ah
--------k-2F4A11BXFFFE-----------------------
INT 2F U - DBLSPACE.BIN - RELOCATE
	AX = 4A11h
	BX = FFFEh
	ES = segment to which to relocate DBLSPACE.BIN
Return: ???
Notes:	called by DBLSPACE.SYS to relocate DBLSPACE.BIN to its final position
	  in memory
	this function also unhooks and discards the code providing this
	  function and AX=4A11h/BX=FFFFh
SeeAlso: AX=4A11h/BX=FFFFh
--------k-2F4A11BXFFFF-----------------------
INT 2F U - DBLSPACE.BIN - GET RELOCATION SIZE
	AX = 4A11h
	BX = FFFFh
Return: AX = number of paragraphs needed by DBLSPACE.BIN
Note:	used by DBLSPACE.SYS to relocate the DBLSPACE driver to its final
	  position in memory
SeeAlso: AX=4A11h/BX=0000h,AX=4A11h/BX=FFFEh
--------k-2F4A12CX4D52-----------------------
INT 2F - Microsoft Realtime Compression Interface (MRCI) - RAM-BASED SERVER
	AX = 4A12h
	CX = 4D52h ("MR")
	DX = 4349h ("CI")
Return: CX = 4943h ("IC") if installed
	DX = 524Dh ("RM") if installed
	    ES:DI -> MRCINFO structure (see INT 1A/AX=B001h)
Note:	this call is functionally identical to INT 1A/AX=B001h, but should be
	  called first, as the latter call is used for the first, ROM-based
	  MRCI server, while this call is used for RAM-based servers which
	  may be partially or entirely replacing a prior server
SeeAlso: INT 1A/AX=B001h
--------k-2F4A13-----------------------------
INT 2F U - DBLSPACE.BIN - GET ??? ENTRY POINTS
	AX = 4A13h
Return: AX = 134Ah if supported
	    ES:BX -> entry point record (see #1387)
SeeAlso: AX=4A11h/BX=0000h

Format of DBLSPACE entry point record:
Offset	Size	Description	(Table 1387)
 00h	DWORD	pointer to FAR function for ???
 04h  5 BYTEs	FAR JUMP instruction to ???
--------N-2F4B-------------------------------
INT 2F - LAN Manager 2.0 DOS Enh NETWKSTA.EXE - NETWORK WORKSTATION REDIRECTOR
	AH = 4Bh
	???
Return: ???
Note:	LAN Manager enhanced mode adds features beyond the standard redirector
	  file/printer services
SeeAlso: AX=118Ah,AX=4100h,AH=42h
--------T-2F4B01-----------------------------
INT 2F C - DOS 5+ TASK SWITCHER - BUILD CALLOUT CHAIN
	AX = 4B01h
	CX:DX -> task switcher entry point (see #1390)
	ES:BX = 0000h:0000h
Return: ES:BX -> callback info structure (see #1388) or 0000h:0000h
Notes:	called by the task switcher
	this function is hooked by clients which require notification of task
	  switcher activities; the call must first be passed on to the prior
	  handler with registers unchanged using a simulated interrupt.	 On
	  return, the client must build a callback info structure and store
	  the returned ES:BX in the "next" field, then return the address of
	  its own callback info structure.
	a client program must add itself to the notification chain if it
	  provides services to other programs; before terminating, it must
	  remove itself from the chain by calling the task switcher's entry
	  point with AX=0005h (see #1390)
	the task switcher entry point should not be saved, as it is subject to
	  change and will be provided on any notification call
	the Windows 3.1 Standard Mode supports this API
SeeAlso: AX=160Bh,AX=4B02h

Format of task switcher callback info structure:
Offset	Size	Description	(Table 1388)
 00h	DWORD	pointer to next callback info structure
 04h	DWORD	pointer to notification function (see #1389)
 08h	DWORD	reserved
 0Ch	DWORD	address of zero-terminated list of API info structures
		(see #1392)

(Table 1389)
Values task switcher notification function is called with:
	AX = function
	    0000h switcher initialization
		Return: AX = status
			    0000h if OK to load
			    nonzero to abort task switcher
	    0001h query suspend
		BX = session ID
		Return: AX = status
			    0000h if OK to switch session
			    0001h if not
	    0002h suspend session
		BX = session ID
		interrupts disabled
		Return: AX = 0000h if OK to switch session
			   = 0001h if not
	    0003h activate session
		BX = session ID
		CX = session status flags
			bit 0: set if first activation of session
			bits 1-15: reserved (0)
		interrupts disabled
		Return: AX = 0000h
	    0004h session active
		BX = session ID
		CX = session status flags
			bit 0: set if first activation of session
			bits 1-15: reserved (0)
		Return: AX = 0000h
	    0005h create session
		BX = session ID
		Return: AX = 0000h if OK to create session
			   = 0001h if not
	    0006h destroy session
		BX = session ID
		Return: AX = 0000h
	    0007h switcher termination
		BX = flags
		    bit 0: set if calling switcher is only switcher loaded
		    bits 1-15: reserved (0)
		Return: AX = 0000h
	ES:DI -> task switcher entry point (see #1390)
Notes:	function 0000h is generally called by the program which controls or
	  invokes the task switcher, rather than by the task switcher itself;
	  the entry point supplied to this function is not necessarily the
	  entry point to the task switcher itself, and may be 0000h:0000h.  If
	  any client indicates that loading is not possible, all clients will
	  be called with function 0007h; thus it is possible for a client to
	  receive a termination notice without a corresponding initialization
	  notice.
	except for functions 0002h and 0003h, the notification handler is
	  called with interrupts enabled and may make any INT 21h function
	  call; interrupts must not be enabled in functions 0002h and 0003h
	function 0007h may be called with ES:DI = 0000h:0000h if the entry
	  point is no longer valid
--------T-2F4B02BX0000-----------------------
INT 2F - DOS 5+ TASK SWITCHER - INSTALLATION CHECK
	AX = 4B02h
	BX = 0000h
	ES:DI = 0000h:0000h
Return: ES:DI = 0000h:0000h if task switcher not loaded
	ES:DI -> task switcher entry point (see #1390) if loaded
	    AX = 0000h
Notes:	the returned entry point is that for the most-recently loaded task
	  switcher; the entry points for prior task switchers may be determined
	  with the "get version" call (see #1390)
	this function is supported by PC Tools v8+ CPTASK
SeeAlso: AX=4A05h,AX=4B03h

(Table 1390)
Call task switcher entry point with:
	AX = 0000h get version
		Return: CF clear if successful
			    AX = 0000h
			    ES:BX -> task switcher version struct (see #1391)
			CF set if unsupported function
	AX = 0001h test memory region
		ES:DI -> first byte to be tested
		CX = size of region to test
		Return: CF clear if successful
			    AX = memory type of tested region
				0000h global
				0001h global and local
				0002h local (replaced on session switch)
			CF set if unsupported function
	AX = 0002h suspend switcher
		ES:DI -> new task switcher's entry point
		Return: CF clear if successful
			    AX = state
				0000h switcher has been suspended
				0001h switcher not suspended, new switcher must
					abort
				0002h switcher not suspended, but new switcher
					may run anyway
			CF set if unsupported function
	AX = 0003h resume switcher
		ES:DI -> new task switcher's entry point
		Return: CF clear if successful
			    AX = 0000h
			CF set if unsupported function
	AX = 0004h hook notification chain
		ES:DI -> callback info structure to be added to chain
			  (see #1388)
		Return: CF clear if successful
			    AX = 0000h
			CF set if unsupported function
	AX = 0005h unhook notification chain
		ES:DI -> callback info structure to be removed from chain
			  (see #1388)
		Return: CF clear if successful
			    AX = 0000h
			CF set if unsupported function
	AX = 0006h query API support
		BX = asynchronous API identifier
		Return: CF clear if successful
			    AX = 0000h
			    ES:BX -> API info structure (see #1392) for the
				      client which provides the highest
				      level of API support
			CF set if unsupported function

Format of task switcher version structure:
Offset	Size	Description	(Table 1391)
 00h	WORD	major version of supported protocol  (current protocol is 1.0)
 02h	WORD	minor version of supported protocol
 04h	WORD	major version of task switcher
 06h	WORD	minor version of task switcher
 08h	WORD	task switcher ID (see AX=4B03h)
 0Ah	WORD	operation flags
		bit 0: set if task switcher disabled
		bits 1-15: reserved (0)
 0Ch	DWORD	pointer to ASCIZ task switcher name
		("MS-DOS Shell Task Switcher" for DOSSHELL task switcher)
 10h	DWORD	pointer to previous task switcher's entry point or 0000h:0000h

Format of API info structure:
Offset	Size	Description	(Table 1392)
 00h	WORD	size of structure in bytes (000Ah)
 02h	WORD	API identifier
		0001h NetBIOS
		0002h 802.2
		0003h TCP/IP
		0004h LAN Manager named pipes
		0005h Novell NetWare IPX
 04h	WORD	major version \ of highest version of API for which the support
 06h	WORD	minor version / level specified in the next field is provided
 08h	WORD	support level
		0001h minimal support
		0002h API-level support
		0003h switcher compatibility
		0004h seamless compatibility
--------T-2F4B03-----------------------------
INT 2F - DOS 5+ TASK SWITCHER - ALLOCATE SWITCHER ID
	AX = 4B03h
	ES:DI -> task switcher entry point (see #1390)
Return: AX = 0000h
	BX = switcher ID (0001h-000Fh), or 0000h if no more available
Notes:	if a task switcher has determined that it is the first to be loaded, it
	  must allocate an identifier for itself and provide this function to
	  all subsequent task switchers; if it is not the first to be loaded,
	  it must call this function to allocate an ID.	 The switcher ID is
	  used as the high four bits of all session identifiers to ensure
	  unique session IDs.
	if no more switcher IDs are available, the new task switcher making the
	  call must terminate or disable itself
	the task switcher providing the identifiers may call the new task
	  switcher's entry point as needed
	this call is available from within DOSSHELL even if the task switcher
	  is not installed
	this function is supported by PC Tools v8+ CPTASK, but appears to
	  always return an ID of 0000h
SeeAlso: AX=4B02h,AX=4B04h
--------T-2F4B04-----------------------------
INT 2F - DOS 5+ TASK SWITCHER - FREE SWITCHER ID
	AX = 4B04h
	BX = switcher ID
	ES:DI -> task switcher entry point (see #1390)
Return: AX = 0000h
	BX = status
	    0000h successful
	    other error (invalid ID or ID not allocated)
Notes:	called by a task switcher when it exits, unless it was the first loaded
	  and is providing the support for AX=4B03h and AX=4B04h
	the task switcher providing the identifiers may call the terminating
	  task switcher's entry point as needed
	this call is available from within DOSSHELL even if the task switcher
	  is not installed
	this call is supported by PC Tools v8+ CPTASK, but appears to return
	  sucessfully no matter which ID is given
SeeAlso: AX=4B02h,AX=4B03h
--------T-2F4B05-----------------------------
INT 2F C - DOS 5+ TASK SWITCHER - IDENTIFY INSTANCE DATA
	AX = 4B05h
	ES:BX = 0000h:0000h
	CX:DX -> task switcher entry point (see #1390)
Return: ES:BX -> startup info structure (see #1393) or 0000h:0000h
Notes:	called by task switcher
	clients with instance data should hook this call, pass it through to
	  the previous handler with unchanged registers using a simulated
	  interrupt.  On return, the client should create a startup info
	  structure (see #1393), store the returned ES:BX in the "next"
	  field, and return the address of the created structure in ES:BX
	all MS-DOS function calls are available from within this call
SeeAlso: AX=1605h,AX=160Bh,AX=4B02h

Format of task switcher startup info structure:
Offset	Size	Description	(Table 1393)
 00h  2 BYTEs	major, minor version of info structure (03h,00h)
 02h	DWORD	pointer to next startup info structure or 0000h:0000h
 06h	DWORD	0000h:0000h (ignored)
 0Ah	DWORD	ignored
 0Eh	DWORD	pointer to instance data records (see #1394)

Format of one instance data record in array:
Offset	Size	Description	(Table 1394)
 00h	DWORD	address of instance data (end of array if 0000h:0000h)
 04h	WORD	size of instance data
--------W-2F4B20-----------------------------
INT 2F - MS Windows 3 - WIN.COM - SET PROGRAM TO EXECUTE ON EXIT
	AX = 4B20h
Return: AX = 0000h if successful
	    DX:CX -> 256-byte buffer for pathname and commandline (see #1395)
Note:	when the Windows function ExitWindows is called with an exit code of
	  44h, WIN.COM executes the program specified in the returned buffer
	  and then restarts Windows

Format of WIN.COM buffer:
Offset	Size	Description	(Table 1395)
 00h 128 BYTEs	ASCIZ pathname of program to execute
 80h 128 BYTEs	commandline for program
--------p-2F4C-------------------------------
INT 2F U - Advanced Power Management
	AH = 4Ch
	AL = function
	    00h version check
	    01h suspend system requested
	    FFh suspend/resume battery notification
	???
Return: ???
----------2F4D-------------------------------
INT 2F U - ???
	AH = 4Dh
	???
Return: ???
Note:	reportedly called by Kana Kanji Converter and MSKK
--------N-2F4E53BL00-------------------------
INT 2F - SilverNET v2+ - INSTALLATION CHECK
	AX = 4E53h ("NS")
	BL = 00h (function "installation check")
	BH = module ID (see #1396)
Return: AX = 0000h if specified module installed
	BX = 4E53h if installed
Program: SilverNET is an SMB-compatible peer-to-peer NOS for DOS or
	  Windows systems, by Net-Source, Inc. of Santa Clara, CA.
SeeAlso: AX=4E53h/BL=01h,AX=4E53h/BL=02h,AX=B800h,AX=B809h

(Table 1396)
Values for SilverNET module ID:
 01h	SilverCACHE
 02h	Workstation
 03h	NetBIOS
 04h	Peer
 20h	NS Share
 80h	NetWare help TSR
--------N-2F4E53BL01-------------------------
INT 2F - SilverNET - GET RUNTIME PARAMETER
	AX = 4E53h ("NS")
	BL = 01h (function "get runtime parameter")
	BH = module ID (see #1396)
	CX = parameter index (see #1397,#1399,#1400)
Return: AX = WORD value at specified index (see #1398)
Desc:	retrieve a word of data from the specified SilverNET module

(Table 1397)
Values for SilverNET Peer parameter index (* = read-only):
 00h *	maximum outstanding SMB buffers
 02h *	maximum logged-in nodes
 04h *	number of shareable resources
 06h *	number of characters to print per time slice
 08h *	number of printers that can be shared
 0Ah *	number of nodes logged in
 0Ch *	number of files to allow opened
 0Eh	how fast to despool (/PSLICE)
 10h	audit flag
 24h *	far pointer to resource table (each resource is 96 bytes in length)
 32h *	far pointer to SFT (internal if SilverNET files > CONFIG.SYS files,
	else DOS SFT)
 36h	spool flags (see #1398)

Bitfields for spool flags:
Bit(s)	Description	(Table 1398)
 0	LPT1 needs despooling
 1	LPT2 needs despooling
 2	LPT2 needs despooling
 4	COM1 needs despooling
 5	COM2 needs despooling
 6	COM3 needs despooling

(Table 1399)
Values for NS Share parameter index (* = read-only):
 00h	version number (high byte = minor, low byte = major)
 10h *	segment of first lock record (other records in consecutive paragraphs)
	(if PSP field = 0000h, lock record is free)
 12h *	maximum possible number of lock records
 14h *	starting segment of sharing buffer
	(NS Share's sharing records are identical to DOS SHARE except that
	  fields which are normally offsets into SHARE are segment numbers)
 18h *	size of sharing buffer in paragraphs
 1Ah *	total free paragraphs in sharing buffer
 1Ch *	current number of shared files
 1Eh *	current number of locked records

(Table 1400)
Values for Workstation parameter index (* = read-only):
 00h	version number (high byte = minor, low byte = major)
 02h *	size of each network buffer for file operations
 04h *	number of redirector file buffers
 06h *	size of each print cache buffer
 08h *	number of network LPT printers
 0Ch	flush time in ticks (idle time on network printer before flushing)
 0Eh	(16 WORDs) last active time for each printer
 2Eh *	stub segment if program split into two parts
 60h	receive name number for datagram listens
 62h *	18-byte machine name
 74h *	LASTDRIVE (01h = A:, etc.)
 7Ch	row number of message box on screen
 7Eh	message time in clock ticks
 82h *	number of network adapters in use
 84h	station ID broadcast flag (never set on redirectors)
 96h *	NetBIOS names left
 98h *	NCBs left
 9Ah *	sessions left
 A2h *	total number of network printers (LPT+COM)
 A4h *	number of serial network printers
 A8h *	segment containing file cache buffers
 AAh *	segment containing print cache buffers
 ACh *	bytes remaining free in HMA before program loaded
 AEh *	start of free memory in HMA
 B2h *	flag: using HMA
--------N-2F4E53BL02-------------------------
INT 2F - SilverNET - SET RUNTIME PARAMETERS
	AX = 4E53h ("NS")
	BL = 02h (function "set runtime parameters")
	BH = module ID (see #1396)
	CX = parameter index (see #1399,#1400)
	DX = new value for specified parameter
Desc:	set a WORD value in the specified SilverNET module
Note:	not all indexed parameters are writable; modifying a read-only
	  parameter can result in system crashes
SeeAlso: AX=4E53h/BL=00h,AX=4E53h/BL=01h
--------N-2F5100-----------------------------
INT 2F U - ODIHLP.EXE - INSTALLATION CHECK
	AX = 5100h
Return: AL = FFh if installed
	    BX = 0000h
	    DX:SI -> signature string "ODI$HLP$"
Program: ODIHLP is a real-mode helper allowing the Windows for Workgroups 3.11
	  protected-mode NDIS3 protocol to work with real-mode ODI drivers
	  and LSL.COM
Note:	the returned signature string might be the first field of a structure
SeeAlso: AX=C000h"LSL.COM"
--------k-2F5200-----------------------------
INT 2F - JAM.SYS v1.10 - "GetVersion" - INSTALLATION CHECK
	AX = 5200h
Return: AH = 80h (successful)
	BX = internal JAM.SYS version number
	CX = size of JAMINFO structure (see #1401)
	DX = JAM.SYS segment address
Program: JAM.SYS is a main component of the JAM Real-Time Data Compression
	  Utilities by George A. Reznik and friends (JAM Software).
SeeAlso: AX=5201h

Format of JAMINFO structure:
Offset	Size	Description	(Table 1401)
 00h 25 BYTEs	extended BIOS parameter block (BPB)
 25h	DWORD	total number of sectors in JAM archive file
		(size of compressed data area)
 29h	BYTE	flags
		bit 7: full undelete-compatible allocation strategy
		bit 6: no write-behind caching
		bit 5: read-only mode
		bit 4: enable direct write requests
		       (Int 26h, non-DOS requests, etc.)
		bits 3..0 are reserved for internal use
 2Ah 127 BYTEs	full JAM archive file name
 A9h	WORD	the number of fragments in archive file
 ABh 96 BYTEs	archive file fragmentation list -
		array of 16 FRAGMENT structures:
		Offset	Size	Description
		 00h	WORD	starting sector (low word)
		 02h	BYTE	starting sector (high byte)
		 03h	WORD	size of fragment (low word)
		 05h	BYTE	size of fragment (high byte)
10Bh	DWORD	address of the host-drive DPB (Drive Parameter Block)
10Fh	DWORD	number of free sectors in JAM archive file
113h	WORD	device status word (see #1402)

(Table 1402)
Values for JAM.SYS status (high byte):
 00h	successful
 01h	drive is not a JAM drive
 02h	drive is already attached
 03h	archive file cluster size value is larger than driver's one
 04h	drive is not attached
 05h	drive is locked
 06h	drive is not locked
 07h	bad physical-level request
 08h	host drive reading/writing error
 09h	bad entries in JAM descriptor table
 0Ah	compressed data integrity error
 0Bh	archive file overflow
 0Ch	bad DOS request
 0Dh	incorrect parameters in JAMINFO structure
Note:	the low byte of the status is the DOS error code for the Host drive
SeeAlso: #1266 at INT 2F/AX=0802h
--------k-2F5201-----------------------------
INT 2F - JAM.SYS v1.10 - "GetInfo" - GET COMPRESSED DRIVE INFORMATION
	AX = 5201h
	DL = compressed drive number (0-default, 1-A:, etc.)
	DS:BX -> buffer for JAMINFO structure (see #1401)
Return: AH = status (00h,01h) (see #1402)
SeeAlso: AX=5200h
--------k-2F5202-----------------------------
INT 2F - JAM.SYS v1.10 - "Attach" - MOUNT COMPRESSED DRIVE
	AH = 52h
	AL = 02h
	DL = drive number (0-default, 1-A:, etc.) to attach to the JAM
	      archive file
	DS:BX -> pointer to JAMINFO structure (see #1401), which
	      contains parameters of the JAM file to mount, and pointer
	      to the host drive DPB (i.e. DPB of the drive on which the
	      JAM file is located)
Return: AH = status (00h,02h,03h,08h,09h,0Dh) (see also #1402)
	    03h archive file cluster size value is larger than driver's - not
		  mounted
	    09h bad entries in JAM descriptor table - file mounted read-only
	AL = host drive error code (see #1266 at INT 2F/AX=0802h)
SeeAlso: AX=5203h
--------k-2F5203-----------------------------
INT 2F - JAM.SYS v1.10 - "Detach" - UNMOUNT COMPRESSED DRIVE
	AX = 5203h
	DL = drive number (0-default, 1-A:, etc.) to detach
Return: AH = status (00h,01h,04h,05h,08h,09h,0Bh,0Dh) (see #1402)
	AL = host drive error code (see #1266 at INT 2F/AX=0802h)
SeeAlso: AX=5202h
--------k-2F5204-----------------------------
INT 2F - JAM.SYS v1.10 - "Lock" - LOCK COMPRESSED DRIVE
	AX = 5204h
	DL = drive number (0-default, 1-A:, etc.) to lock
Return: AH = status (00h,01h,04h,05h,08h,09h,0Bh,0Dh) (see #1402)
	AL = host drive error code (see #1266 at INT 2F/AX=0802h)
SeeAlso: AX=5205h, AX=5206h, AX=5207h
--------k-2F5205-----------------------------
INT 2F - JAM.SYS v1.10 - "UnLock" - UNLOCK COMPRESSED DRIVE
	AX = 5205h
	DL = drive number (0-default, 1-A:, etc.) to unlock
Return: AH = status (00h,01h,04h,06h,08h,09h,0Dh) (see #1402)
	AL = host drive error code (see #1266 at INT 2F/AX=0802h)
SeeAlso: AX=5204h, AX=5206h, AX=5207h
Note:	Lock and UnLock functions were added to the JAM API to prevent
	  asynchronous physical-level access (see AX=5206h,AX=5207h) to
	  compressed data on JAM drives. In other words, two or more programs
	  which use JAM API (say, JMAX optimizer and JCHKDSK - disk checker)
	  cannot be run on the same JAM drive simultaneously.
--------k-2F5206-----------------------------
INT 2F - JAM.SYS v1.10 - "Read" - PHYSICAL READ DATA FROM JAM ARCHIVE
	AX = 5206h
	DL = drive number (0-default, 1-A:, etc.)
	DS:BX -> disk transfer packet (see #1403)
Return: AH = status (00h,01h,04h,06h,07h,08h,0Dh) (see #1402)
	AL = host drive error code (see #1266 at INT 2F/AX=0802h)
Program: JAM.SYS is a main component of the JAM Real-Time Data Compression
	  Utilities by George A. Reznik and friends (JAM Software).
SeeAlso: AX=5207h

Format of disk transfer packet:
Offset	Size	Description	(Table 1403)
 00h	DWORD	sector number
 04h	WORD	number of sectors to read(write)
 06h	DWORD	transfer address
--------k-2F5207-----------------------------
INT 2F - JAM.SYS v1.10 - "Write" - PHYSICAL WRITE DATA TO JAM ARCHIVE
	AX = 5207h
	DL = drive number (0-default, 1-A:, etc.)
	DS:BX -> disk transfer packet (see #1403)
Return: AH = status (00h,01h,04h,06h,07h,08h,0Dh) (see #1402)
	AL = host drive error code (see #1266 at INT 2F/AX=0802h)
SeeAlso: AX=5206h
--------p-2F53-------------------------------
INT 2F U - POWER.EXE - APM event broadcasting???
	AH = 53h
	AL = event???
	    05h CPU idle
	    0Bh PM event broadcast API
Return: ???
Note:	called by MS Windows 3.1 POWER.DRV; hooked by MS Mouse driver v8.20+
	  and PC-Cache v8.0
SeeAlso: AX=530Bh,AH=54h,INT 33/AX=002Fh
--------p-2F530B-----------------------------
INT 2F U - ??? (MOUSEPWR.COM, others) - ???
	AX = 530Bh
	BX = subfunction
	    0003h ???
	    0004h ???
	???
Return: ???
Note:	it appears that subfunction 0003h reads or restores the current mouse
	  settings (the MS Mouse driver hooks AX=530Bh), and 0004h might be
	  the converse
--------p-2F5400-----------------------------
INT 2F U - POWER.EXE - INSTALLATION CHECK
	AX = 5400h
Return: AX = POWER.EXE version (AH = major, AL = minor) if installed
	BX = 504Dh ("PM")
	CF clear
Note:	called by MS Windows 3.1 POWER.DRV
SeeAlso: AH=53h,AX=5401h,AX=5402h,AX=5481h,AX=5482h
--------p-2F5401-----------------------------
INT 2F U - POWER.EXE - GET/SET POWER STATUS
	AX = 5401h
	BH = function
	    00h get status
		Return: BL = current power management status (see #1404)
	    01h set status
		BL = new power managment status (see #1404)
Return: AX = function status (see #1405)
Note:	called by MS Windows 3.1 POWER.DRV
SeeAlso: AH=53h,AX=5400h,AX=5402h,AX=5403h

Bitfields for power management status:
Bit(s)	Description	(Table 1404)
 0	POWER.EXE power management enabled
 1	APM firmware power management enabled
 2-7	reserved (0)
Notes:	bit 1 is ignored if there is no APM firmware
	bits 1-0: 00 = POWER OFF, 10 = POWER STD, 11 = POWER ADV

(Table 1405)
Values for POWER.EXE function status:
 0000h	successful
 0002h	"ERROR_PM_ALREADY_CONNECTED"
 0003h	"ERROR_PM_NOT_CONNECTED"
 0087h	"ERROR_PM_INVALID_PARAMETER"
--------p-2F5402-----------------------------
INT 2F U - POWER.EXE - GET/SET IDLE DETECTION STRATEGY
	AX = 5402h
	BH = subfunction
	    00h get
	    other set
		BL = detection strategy (00h-0Fh or FFh)
Return: BX = current/new detection strategy
SeeAlso: AH=53h,AX=5400h,AX=5401h,AX=5481h,AX=5482h
--------p-2F5403-----------------------------
INT 2F U - POWER.EXE - GET/SET ADVANCED POWER MANAGEMENT SETTING
	AX = 5403h
	BX = new power management setting or 0000h to get current setting
Return: AX = status
	    0000h successful
		BX = power management setting (see #1406)
	    other error code
SeeAlso: AX=5401h,AX=5480h

(Table 1406)
Values for power management setting:
 0001h-0005h "min"
 0006h	     "reg"
 0007h-0008h "max"
--------t-2F5453-----------------------------
INT 2F - TesSeRact RAM-RESIDENT PROGRAM INTERFACE
	AX = 5453h
	BX = subfunction
	    00h installation check
		CX = 0000h
		DS:SI -> 8-char blank-padded name
		Return: AX = FFFFh installed
				CX = ID number of already-installed copy
			AX = anything else, not installed
				CX = ID number for TSR when installed
	    01h get user parameters
		CX = TSR ID number
		Return: AX = status
			    0000h successful
				ES:BX -> user parameter block (see #1407)
			    nonzero failed
	    02h check if hotkey in use
		CL = scan code of hot key
		Return: AX = FFFFh hot key conflicts with another TSR
			     otherwise safe to use the hotkey
	    03h replace default critical error handler
		CX = TSR ID number
		DS:SI -> new routine for INT 24h
		Return: AX = nonzero, unable to install new handler
	    04h get internal data area
		CX = TSR ID number
		Return: AX = status
			    0000h successful
				ES:BX -> TSR's internal data area (see #1409)
			    nonzero, TSR not found
	    05h set multiple hot keys
		CX = TSR ID number
		DL = number of additional hot keys to allocate
		DS:SI -> table of hot keys
			BYTE  hotkey scan code
			BYTE  hotkey shift state
			BYTE  flag value to pass to TSR (nonzero)
		Return: AX = nonzero, unable to install hot keys
	    06h - 0Fh reserved
	    10h enable TSR
		CX = TSR ID number
		Return: AX = nonzero, unable to enable
	    11h disable TSR
		CX = TSR ID number
		Return: AX = nonzero, unable to disable
	    12h unload TSR
		CX = TSR ID number
		Return: AX = nonzero, invalid TSR number
		Note: if any interrupts used by TSR have been grabbed by
			another TSR, the TesSeRact routines will wait until
			it is safe to remove the indicated TSR from memory
	    13h restart TSR
		CX = TSR ID number of TSR which was unloaded but is still in
		     memory
		Return: AX = nonzero, unable to restart TSR
	    14h get status word
		CX = TSR ID number
		Return: AX = FFFFh invalid ID number
			   = other, successful
				BX = bit flags
	    15h set status word
		CX = TSR ID number
		DX = new bit flags
		Return: AX = nonzero, unable to set status word
	    16h get INDOS state at popup
		CX = TSR ID number
		Return: AX = 0000h successful
			    BX = value of INDOS flag
	    17h - 1Fh reserved
	    20h call user procedure
		CX = TSR ID number
		ES:DI -> user-defined data
		Return: AX = 0000h successful
	    21h stuff keystrokes into keyboard buffer
		CX = TSR ID number
		DL = speed
		    00h stuff keystrokes only when buffer is empty
		    01h stuff up to four keystrokes per clock tick
		    02h stuff up to 15 keystrokes per clock tick
		DH = scan code flag
		    if zero, buffer contains alternating ASCII and scan codes
		    if nonzero, buffer contains only ASCII codes
		SI = number of keystrokes
		ES:DI -> buffer to stuff
		Return: AX = 0000h success
			     F0F0h user aborted with ^C or ^Break
			     other unable to stuff keystrokes
	    22h (v1.10) trigger popup
		CX = TSR ID number
		Return: AX = 0000h success, TSR will either pop up or beep to
				   indicate that it is unable to pop up
			     nonzero invalid ID number
	    23h (v1.10) invoke TSR's background function
		CX = TSR ID number
		Return: AX = 0000h success
			     FFFFh not safe to call background function
			     nonzero invalid ID number
	    24h - 2Fh reserved
Notes:	Borland's THELP.COM popup help system for Turbo Pascal and Turbo C
	  (versions 1.x and 2.x only) fully supports the TesSeRact API, as
	  do the SWAP?? programs by Innovative Data Concepts.
	AVATAR.SYS supports functions 00h and 01h (only the first three fields
	  of the user parameter block) using the name "AVATAR  "
SeeAlso: AX=CAFEh,INT 16/AX=55FFh,INT 2D"AMIS"
Index:	installation check;TesSeRact TSR interface|uninstall;TesSeRact

(Table 1407)
Values for TesSeRact names:
 "AVATAR  "	AVATAR.SYS
 "QeditTSR"	TSR version of SemWare's Qedit editor
 "SCRNBLNK"	Trusted Access screen blanker

Format of TesSeRact User Parameter Block:
Offset	Size	Description	(Table 1408)
 00h  8 BYTEs	blank-padded TSR name
 08h	WORD	TSR ID number
 0Ah	DWORD	bitmap of supported functions
 0Eh	BYTE	scan code of primary hotkey
		00h = pop up when shift states match
		FFh = no popup (if shift state also FFh)
 0Fh	BYTE	shift state of primary hotkey
		FFh = no popup (if scan code also FFh)
 10h	BYTE	number of secondary hotkeys
 11h	DWORD	pointer to extra hotkeys set by func 05h
 15h	WORD	current TSR status flags
 17h	WORD	PSP segment of TSR
 19h	DWORD	DTA for TSR
 1Dh	WORD	default DS for TSR
 1Fh	DWORD	stack at popup
 23h	DWORD	stack at background invocation
Index:	hotkeys;TesSeRact TSR interface

Format of TSR internal data area:
Offset	Size	Description	(Table 1409)
 00h	BYTE	revision level of TesSeRact library
 01h	BYTE	type of popup in effect
 02h	BYTE	INT 08 occurred since last invocation
 03h	BYTE	INT 13 occurred since last invocation
 04h	BYTE	active interrupts
 05h	BYTE	active soft interrupts
 06h	BYTE	DOS major version
 07h	BYTE	how long to wait before popping up
 08h	DWORD	pointer to INDOS flag
 0CH	DWORD	pointer to DOS critical error flag
 10h	WORD	PSP segment of interrupted program
 12h	WORD	PSP segment of prog interrupted by INT 28
 14h	DWORD	DTA of interrupted program
 18h	DWORD	DTA of program interrupted by INT 28
 1Ch	WORD	SS of interrupted program
 1Eh	WORD	SP of interrupted program
 20h	WORD	SS of program interrupted by INT 28
 22h	WORD	SP of program interrupted by INT 28
 24h	DWORD	INT 24 of interrupted program
 28h  3 WORDs	DOS 3+ extended error info
 2Eh	BYTE	old BREAK setting
 2Fh	BYTE	old VERIFY setting
 30h	BYTE	were running MS WORD 4.0 before popup
 31h	BYTE	MS WORD 4.0 special popup flag
 32h	BYTE	enhanced keyboard call in use
 33h	BYTE	delay for MS WORD 4.0
11 times (for INTs 08h,09h,13h,16h,1Ch,21h,28h,2Fh,1Bh,23h, and 24h):
	DWORD	old interrupt vector
	BYTE	interrupt number
	WORD	offset in TesSeRact code segment of new interrupt handler
--------p-2F5480-----------------------------
INT 2F U - POWER.EXE - GET/SET ???
	AX = 5480h
	BX = direction
	    0000h get
	    other set
	CX = size of buffer (at least 0010h)
	DS:SI -> buffer
Return: AX = status
	    0000h successful
	    other error code
SeeAlso: AX=5400h,AX=5481h,AX=548Fh
--------p-2F5481-----------------------------
INT 2F U - POWER.EXE - GET STATISTICS
	AX = 5481h
	BX = which statistics
	    0000h idle detection
	    0001h APM statistics
	CX = length of buffer in bytes
	DS:SI -> buffer for statistics (see #1410,#1411)
Return: AX = status
	    0000h successful
	    0071h "ERROR_PM_BUFFER_TOO_SMALL"
	    0087h "ERROR_PM_INVALID_PARAMETER"
SeeAlso: AH=53h,AX=5400h,AX=5480h,AX=5402h,AX=5482h

Format of POWER.EXE idle detection statistics:
Offset	Size	Description	(Table 1410)
 00h	DWORD	"CPU_ON_TIME" total time CPU is active with POWER.EXE idle
		  detection enabled, in timer ticks
 04h	DWORD	"CPU_IDLE_TIME" timer ticks during which CPU was idle
		(divide by previous to get idle	rate)
 08h	DWORD	total idle calls
 0Ch	DWORD	"TOTAL_APP_IDLE" total INT 2Fh idle calls
 10h	DWORD	"TOTAL_DOS_YIELD" total INT 28h idle calls
 14h	DWORD	"TOTAL_KEY_IDLE" total INT 16h idle calls
 18h	DWORD	"TOTAL_DOS_IDLE" total INT 2Ah idle calls

Format of APM statistics:
Offset	Size	Description	(Table 1411)
 00h	DWORD	"RESUME_COUNT" total number of resumes since last APM_ENABLE
--------p-2F5482-----------------------------
INT 2F U - POWER.EXE - GET/SET APM POLLING FREQUENCY
	AX = 5482h
	BX = new polling frequency or 0000h to get current frequency
Return: AX = 0000h (successful)
	BX = current frequency if BX=0000h on entry
SeeAlso: AH=53h,AX=5400h,AX=5401h,AX=5480h,AX=5481h,AX=548Fh
--------p-2F548F-----------------------------
INT 2F U - POWER.EXE - GET/SET ???
	AX = 548Fh
	BX = ??? or 0000h to get current ???
Return: AX = 0000h (successful)
	BX = current ???
	CX = ???
SeeAlso: AX=5400h,AX=5480h,AX=5482h
--------l-2F5500-----------------------------
INT 2F U - DOS 5+ - COMMAND.COM INTERFACE
	AX = 5500h
Return: AX = 0000h if an instance of COMMAND.COM is already running
	DS:SI -> entry point table
Notes:	used to access the shareable portion of COMMAND.COM, which may have
	  been moved into the HMA; only the primary COMMAND.COM retains this
	  portion
	procedures called from a dispatcher in COMMAND's resident portion;
	  most assume that the segment address of the resident portion is on
	  the stack and are thus not of general use
SeeAlso: AX=5501h
--------l-2F5501-----------------------------
INT 2F U - DOS 5+ - ROM COMMAND.COM INTERFACE
	AX = 5501h
Return: ???
Note:	used to determine whether the caller is the first instance of ROM
	  COMMAND.COM
SeeAlso: AX=5500h
--------R-2F5600DXFFFF-----------------------
INT 2F - INTERLNK - INSTALLATION CHECK
	AX = 5600h
	DX = FFFFh
	BL = instance number (00h = any, 01h = first loaded, etc.)
Return: AL = FFh if installed
	    BL = instance number
	    CX = ???
	    DX = resident CS
SeeAlso: AX=5601h,AX=5602h
--------R-2F5601DXFFFF-----------------------
INT 2F - INTERLNK - CHECK IF REDIRECTED DRIVE
	AX = 5601h
	DX = FFFFh
	BH = drive number (0=A:)
	BL = 00h
Return: (as for AL=00h if redirected drive)
SeeAlso: AX=5600h
--------R-2F5602DXFFFF-----------------------
INT 2F - INTERLNK - GET ???
	AX = 5602h
	DX = FFFFh
Return: CX = ???
SeeAlso: AX=5600h
----------2F57-------------------------------
INT 2F U - ???
	AH = 57h
	???
Return: ???
Note:	reportedly used by Iomega Corp.
--------c-2F5758BX4858-----------------------
INT 2F U - Helix Multimedia Cloaking - CACHECLK - INSTALLATION CHECK
	AX = 5758h
	BX = 4858h ('HX')
	DX = 4443h ('DC')
	CX <> 5758h
Return: BX = 6878h if installed
	DX = 6463h if installed
	   CX = version (CH=major,CL=minor)
Program: CACHECLK is a 'Cloaked' disk cache by Helix Software
Note:	returns with registers unchanged if CX=5758h on entry
SeeAlso: INT 16/AX=5758h/BX=4858h,INT 2F/AX=4310h"Cloaking"
--------X-2F5D00-----------------------------
INT 2F U - PCMCIA - AWARD PCDISK - GET INFO FROM DRIVER ???
	AX = 5D00h
Return: ES:BX -> ???
Note:	supported by Ventura Micro / Award PCDISK.EXE v1.02c PCMCIA/ATA driver
SeeAlso: AX=5D01h,INT 21/AX=440Dh
--------X-2F5D01-----------------------------
INT 2F U - PCMCIA - AWARD PCDISK - PUT INFO INTO DRIVER ???
	AX = 5D01h
	ES:BX -> ???
Return: nothing
Note:	supported by Ventura Micro / Award PCDISK.EXE v1.02c PCMCIA/ATA driver
SeeAlso: AX=5D00h,INT 21/AX=440Dh
--------s-2F60FFDL00-------------------------
INT 2F U - IPLAY v1.00b - INSTALLATION CHECK
	AX = 60FFh
	DL = 00h (function number)
	BX = 5344h ('SD')
	CX = 4D50h ('MP')
Return: AX = 4F4Bh ('OK') if installed
Program: IPLAY is the Inertia Player by Prime and Excalibur for .MODules
	  (digitized music files)
Note:	in version 1.00b, any value for DL except 01h invokes this function
SeeAlso: AX=60FFh/DL=01h
--------s-2F60FFDL00-------------------------
INT 2F U - IPLAY v1.00b - GET DATA SEGMENT
	AX = 60FFh
	DL = 01h (function number)
	BX = 5344h ('SD')
	CX = 4D50h ('MP')
Return: AX = data segment
Program: IPLAY is the Inertia Player by Prime and Excalibur for .MODules
	  (digitized music files)
SeeAlso: AX=60FFh/DL=00h
--------v-2F6282-----------------------------
INT 2F U - PC Tools v7.0+ VDEFEND, VSAFE, VWATCH, DATAMON - SET ??? ADDRESS
	AX = 6282h
	CX:DX -> ??? or 0000h:0000h
	DI = segment of ??? record (see #1412) or 0000h/FFFFh to ignore
Return: BX = 0062h
Note:	if CX:DX = 0000h:0000h on entry, the ??? address is not changed
	  (DATAMON only)
SeeAlso: INT 13/AH=FAh"VSAFE",INT 21/AH=FAh"VDEFEND"

Format of VSAFE/VWATCH record:
Offset	Size	Description	(Table 1412)
 00h	DWORD	???
 04h	WORD	offset of ??? in record's segment
		VSAFE 2.0 sets byte at +01h to 56h or 58h
		VWATCH 2.1 sets byte at +02h to 56h or 58h
 06h  2 BYTEs	???
 08h	BYTE	??? (01h/other)
--------v-2F6284BX0000-----------------------
INT 2F U - PC Tools v7-8 DATAMON, v9+ DPROTECT	- INSTALLATION CHECK
	AX = 6284h
	BX = 0000h
	CX = 0000h
Return: AX = segment of resident code
	BX = 5555h
	CX = 5555h
Note:	also supported by DOS 6 UNDELETE which is licensed from PC Tools
SeeAlso: AX=6284h/BX=0001h,INT 16/AX=FFA3h
--------v-2F6284BX0001-----------------------
INT 2F U - PC Tools v7-8 DATAMON, v9+ DPROTECT - GET ???
	AX = 6284h
	BX = 0001h
	CX = 0001h
Return: AX:BX -> ??? data (see #1413)
	CX = BX
SeeAlso: AX=6284h/BX=0000h

Format of DPROTECT data for v9.0:
Offset	Size	Description	(Table 1413)
 00h  5 BYTEs	???
 05h	WORD	resident code segment (may be segment of DWORD at +03h)
 07h	DWORD	-> FAR function to sound alert tone
	???
--------v-2F6284BX0002-----------------------
INT 2F U - PC Tools v7-8 DATAMON, v9+ DPROTECT - GET OPTIONS
	AX = 6284h
	BX = 0002h
	CX = 0002h
Return: AX = options (see #1414)
	BX = ??? (0000h for v9)
	CX = AX
	DX = BX
Note:	also supported by DOS 6 UNDELETE which is licensed from PC Tools
SeeAlso: AX=6284h/BX=0000h,AX=6284h/BX=0003h

Bitfields for DATAMON/DPROTECT options:
Bit(s)	Description	(Table 1414)
 1	???
 12	disabled
 13	using Delete Sentry
 14	using Delete Tracker
--------v-2F6284BX0003-----------------------
INT 2F U - PC Tools v7-8 DATAMON, v9+ DPROTECT - SET OPTION??? FLAGS
	AX = 6284h
	BX = 0003h
	CX = flags (see #1415)
	DX = flags
	    bit 15: ???
Note:	v9 DPROTECT only checks bit 12 of CX, and ignores DX entirely
SeeAlso: AX=6284h/BX=0002h

Bitfields for DATAMON/DPROTECT CX flags:
Bit(s)	Description	(Table 1415)
 3	???
 5	???
 10	???
 12	disable DATAMON/DPROTECT
--------v-2F6284BX0004-----------------------
INT 2F U - PC Tools v8 DATAMON, v9+ DPROTECT - ???
	AX = 6284h
	BX = 0004h
	CX = 0004h
Return: AX = 5555h
	BX = ??? (0800h)
	CX = ??? (FCCCh for v8, FCCBh for v9)
--------V-2F6400-----------------------------
INT 2F - SCRNSAV2.COM - INSTALLATION CHECK
	AX = 6400h
Return: AL = installation state
	    00h not installed
	    FFh installed
Program: SCRNSAV2.COM is a screen saver for PS/2s with VGA by Alan Ballard
SeeAlso: INT 10/AX=5555h,INT 14/AX=AA01h
Index:	screen saver;SCRNSAV2
--------N-2F7000-----------------------------
INT 2F - License Service API - INSTALLATION CHECK
	AX = 7000h
	CX = license server index (0000h to 001Fh)
Return: AL = status
	    00h not installed
	    FFh installed
Notes:	The License Service API is being maintained by Microsoft but is being
	  supported by a large number of companies including Apple, Banyan,
	  DEC, HP, Lotus, Microsoft, Novell, Software Publishers Association,
	  and Wordperfect (not a complete list!)
	Each license service provider must search for the next free index
	  slot to use
SeeAlso: AX=7001h,AX=7003h,AX=7004h,AX=7005h
--------N-2F7001-----------------------------
INT 2F - License Service API - REQUEST LICENSE
	AX = 7001h
	CX = license server index (0000h to 001Fh)
	DS:DX -> SLSREQUEST structure (see #1416)
Return: AX = status
	    0000h success
	    else  provider error code
	ES:BX = provider specific handle for the license context
SeeAlso: AX=7002h,AX=7004h,AX=7005h

Format of License Service SLSREQUEST structure:
Offset	Size	Description	(Table 1416)
 00h	DWORD	(return) status code
 04h	DWORD	(return) handle identifying context
 08h	DWORD	(call) address of Publisher string
 0Ch	DWORD	(call) address of Product string
 10h	DWORD	(call) address of Version string
 14h	DWORD	units required
 18h	DWORD	address of comment string
 1Ch	DWORD	address of SLSCHALLENGE structure (see #1417)

Format of License Service SLSCHALLENGE structure:
Offset	Size	Description	(Table 1417)
 00h	DWORD	algorithm (currently always 1)
 04h	DWORD	secret to be challenged (1-255)
 08h	DWORD	size of challenge in bytes (1-255)
 0Ch  N BYTEs	challenge data
--------N-2F7002-----------------------------
INT 2F - License Service API - RELEASE LICENSE
	AX = 7002h
	CX = license server index (0000h to 001Fh)
	DS:DX -> SLSRELEASE structure (see #1418)
	ES:BX = provider specific handle for the license context
Return: AL = status
	    00h not installed
	    FFh installed
SeeAlso: AX=7001h,AX=7005h

Format of License Service SLSRELEASE structure:
Offset	Size	Description	(Table 1418)
 00h	DWORD	handle indentifying license context
 04h	DWORD	total units consumed
 08h	DWORD	address of comment string
--------N-2F7003-----------------------------
INT 2F - License Service API - UPDATE
	AX = 7003h
	CX = license server index (0000h to 001Fh)
	DS:DX -> SLSUPDATE structure (see #1419)
	ES:BX = provider specific handle for the license context
Return: AL = status
	    00h not installed
	    FFh installed
SeeAlso: AX=7004h,AX=7005h

Format of License Service SLSUPDATE structure:
Offset	Size	Description	(Table 1419)
 00h	DWORD	(return) status code
 04h	DWORD	(call) handle identifying license context
 08h	DWORD	(call) total units consumed
 0Ch	DWORD	additional units required
 10h	DWORD	address of comment string
 14h	DWORD	address of SLSCHALLENGE structure (see #1417)
--------N-2F7004-----------------------------
INT 2F - License Service API - GET ERROR
	AX = 7004h
	CX = license server index (0000h to 001Fh)
	DS:DX -> SLSGETERROR structure (see #1420)
	ES:BX = provider specific handle for the license context
Return: AL = status
	    00h not installed
	    FFh installed
SeeAlso: AX=7000h,AX=7001h

Format of License Service SLSGETERROR structure:
Offset	Size	Description	(Table 1420)
 00h	DWORD	(return) status code
 04h	DWORD	handle identifying license context
 08h	DWORD	error code
 0Ch	DWORD	buffer size in bytes
 10h  N BYTEs	data buffer
--------N-2F7005-----------------------------
INT 2F - License Service API - QUERY LICENSE
	AX = 7005h
	CX = license server index (0000h to 001Fh)
	DS:DX -> SLSQUERY structure (see #1421)
	ES:BX = provider specific handle for the license context
Return: AL = status
	    00h not installed
	    FFh installed
SeeAlso: AX=7001h,AX=7002h

Format of License Service SLSQUERY structure:
Offset	Size	Description	(Table 1421)
 00h	DWORD	(return) status code
 04h	DWORD	handle identifying license context
 08h	DWORD	information index
 0Ch	DWORD	buffer size in bytes
 10h  N BYTEs	data buffer
--------d-2F7200-----------------------------
INT 2F - SRDISK v1.30 - INSTALLATION CHECK
	AX = 7200h
Return: AL = FFh if installed
	    ES = segment of device driver header (see #1422)
Program: SRDISK is a freeware resizeable RAMdisk by Marko Kohtala

Format of SRDISK device driver header:
Offset	Size	Description	(Table 1422)
 00h 10 BYTEs	same as standard device driver header (see INT 21/AH=52h)
 0Ah	BYTE	number of subunits (drives) supported by driver
 0Bh  3 BYTEs	signature "SRD"
 0Eh  4 BYTEs	memory type string (currently only "XMS ")
 12h  4 BYTEs	ASCII driver version string "N.NN"
 16h	BYTE	00h
 17h	BYTE	configuration format version (currently 00h)
 18h	WORD	offset of drive configuration data
--------N-2F7A00-----------------------------
INT 2F - Novell NetWare - LOW-LEVEL API (IPX) INSTALLATION CHECK
	AX = 7A00h
Return: AL = status
	    00h not installed
	    FFh installed
		ES:DI -> FAR entry point for routines accessed exclusively
			  through INT 7A in NetWare versions through 2.0a.
			  Call with same values as INT 7A
		ES:BX -> two bytes containing IPX major/minor version
			(IPXODI v2.12; BX unchanged by older IPX drivers)
SeeAlso: AX=7AFFh/BX=0000h,AX=D800h,INT 64"Novell",INT 7A"Novell"
--------N-2F7A10-----------------------------
INT 2F U - Novell NetWare - TBMI v1.1+ - GET TBMI STATUS
	AX = 7A10h
Return: DH = major TBMI version number
	DL = minor TBMI version number (01h for v1.1)
	CX = segment address of TBMI resident part
	BX = status word of TBMI (see #1423)
Note:	TBMI is the Task-Switched Buffer Manager Interface
SeeAlso: AX=7A11h,AX=7A12h,AX=7A13h,AX=7A14h

Bitfields for NetWare TBMI status word:
Bit(s)	Description	(Table 1423)
 0	INT2F intercepted by TBMI
 1	INT7A intercepted by TBMI
 2	INT64 intercepted by TBMI
 3-14	reserved or unused ???
 15	outstanding task ID was detected
--------N-2F7A11-----------------------------
INT 2F U - Novell NetWare - TBMI v1.1+ - GET INT2F HANDLERS
	AX = 7A11h
Return: ES:BX -> old INT 2F handler
	DS:DX -> TBMI INT 2F handler
SeeAlso: AX=7A10h,AX=7A12h,AX=7A13h,AX=7A1Ah
--------N-2F7A12-----------------------------
INT 2F U - Novell NetWare - TBMI v1.1+ - GET INT64 HANDLERS
	AX = 7A12h
Return: ES:BX -> old INT 64 handler
	DS:DX -> TBMI INT 64 handler
SeeAlso: AX=7A10h,AX=7A11h,AX=7A13h
--------N-2F7A13-----------------------------
INT 2F U - Novell NetWare - TBMI v1.1+ - GET INT7A HANDLERS
	AX = 7A13h
Return: ES:BX -> old INT 7A handler
	DS:DX -> TBMI INT 7A handler
SeeAlso: AX=7A10h,AX=7A11h,AX=7A12h
--------N-2F7A14-----------------------------
INT 2F U - Novell NetWare - TBMI v1.1+ - GET STATISTICS
	AX = 7A14h
	CX = statistic to retrieve
	    0000h available diagnostic functions???
		Return: CX = maximum available function??? (000Ch for v2.0)
	    0001h buffers in use
		Return: CX = TBMI buffers currently in use
	    0002h maximum buffers used
		Return: CX = maximum number of buffers ever in use
	    0003h unavailable buffers
		Return: CX = count of unavailable TBMI buffers
	    0004h old interrupt usage
		Return: CX = TBMI accesses to intercepted old vectors INT 2F,
			      INT 64, and INT 7A
	    0005h far call usage
		Return: CX = TBMI accesses to IPX/SPX far call handler (not
			      including internal accesses)
	    0006h task buffering
		Return: CX = TBMI task buffering status (enabled/disabled or
			      disable/enable switch count???)
	    0007h current task ID
		Return: CX = TBMI current task ID number (0000h if ???)
	    0008h outstanding ID count
		Return: CX = number of outstanding TBMI IDs
	    0009h configured ECBs
		Return: CX = number of TBMI Event Control Blocks configured
	    000Ah configured data ECBs
		Return: CX = number of TBMI data ECBs configured
	    000Bh configured sockets
		Return: CX = number of TBMI sockets configured (from NETCFG)
	    000Ch current sockets
		Return: CX = number of TBMI sockets currently in use
Return: BX = maximum supported subfunction (000Ch)
SeeAlso: AX=7A10h
--------N-2F7A15-----------------------------
INT 2F OU - Novell NetWare - TBMI v1.1 only - RESET ???
	AX = 7A15h
Return: BX = new value of ???
Desc:	set ??? to its default value
Note:	this call is a NOP under TBMI v2.0 (TBMI2)
SeeAlso: AX=7A17h
--------N-2F7A16-----------------------------
INT 2F OU - Novell NetWare - TBMI v1.1 only - ???
	AX = 7A16h
	CX = ???
	???
Return: ???
Note:	this call is a NOP under TBMI v2.0 (TBMI2)
--------N-2F7A17-----------------------------
INT 2F OU - Novell NetWare - TBMI v1.1 only - ???
	AX = 7A17h
	???
Return: BX = old value of ???
	CX = new value of ???
Note:	this call is a NOP under TBMI v2.0 (TBMI2)
SeeAlso: AX=7A15h
--------N-2F7A18-----------------------------
INT 2F U - Novell NetWare - TASKID v1.0 - INSTALLATION CHECK
	AX = 7A18h
Return: AL = FFh if installed
	    BX = configuration flags (see #1424)
	    CX = resident code segment
SeeAlso: AX=7A10h

Bitfields for NetWare TASKID configuration flags:
Bit(s)	Description	(Table 1424)
 0	INT 2F hooked
 3	INT 08 hooked
 other	unused
--------N-2F7A19-----------------------------
INT 2F U - Novell NetWare - TASKID v1.0 - GET INT 08 HANDLERS
	AX = 7A19h
Return: AL = FFh
	DS:DX -> TASKID INT 08 handler
	ES:BX -> original INT 08 handler
--------N-2F7A1A-----------------------------
INT 2F U - Novell NetWare - TASKID v1.0 - GET INT 2F HANDLERS
	AX = 7A1Ah
Return: AL = FFh
	DX:DX -> TASKID INT 2F handler
	ES:BX -> original INT 2F handler
SeeAlso: AX=7A11h,AX=7A19h
--------N-2F7A1B-----------------------------
INT 2F U - Novell NetWare - TASKID v1.0 - GET DIAGNOSTICS INFORMATION
	AX = 7A1Bh
	CX = desired information
	    0000h supported functions
	    0001h TASKID ID number
		Return: CX = ID number
	    0002h set-ID count
		Return: CX = ID set count
Return: AL = FFh
	BX = highest supported subfunction number (0002h)
SeeAlso: AX=7A14h,AX=7A18h
--------N-2F7A1C-----------------------------
INT 2F U - Novell NetWare - TBMI v1.1+ - ???
	AX = 7A1Ch
	BP = ???
	CX:DX = ???
Return: AX = 70FFh
--------N-2F7A1D-----------------------------
INT 2F U - Novell NetWare - TBMI v1.1+ - ???
	AX = 7A1Dh
	???
Return: ES = ???
	???
	SI destroyed
--------N-2F7A1E-----------------------------
INT 2F U - Novell NetWare - TBMI v1.1+ - ???
	AX = 7A1Eh
	ES:SI -> ???
	???
Return: ???
--------N-2F7A20BX0000-----------------------
INT 2F - Novell NetWare - Adv NetWare 4.0 DOS Requester - GET VLM CALL ADDRESS
	AX = 7A20h
	BX = 0000h
Return: AX = 0000h on success (installed)
	    ES:BX -> far call address for DOS Requester (see #1425)
Notes:	the DOS Requester replaces the NetWare Shell (ANETx, NETx) on
	  NetWare LAN's as of the release of Advanced NetWare 4.0 (1993).  It
	  is backward compatible with NetWare 2.1x through 3.11 servers as
	  well.	 Note that there was a NetWare 4.0 in the early 1980's, which
	  can cause confusion.
	this call is used as the installation check by VLM.EXE, which is the
	  loader for all the modules of the DOS Requester
	.VLMs are standard old .EXE format executables whose normal entry point
	  merely terminates to prevent loading from the command line.  The
	  real entry point is found by looking at the VLM header at the
	  beginning of the load image (see #1428)
Index:	installation check;NetWare 4.0 DOS Requester

(Table 1425)
Call DOS Requester entry point with:
	STACK:	WORD	destination function
		WORD	destination VLM ID
		WORD	source VLM ID (0000h = application program)
	registers as appropriate for function
Return: AX = status code (0000h,8811h,8846h,8848h,8853h) (see #1426)
	other registers as appropriate for function
	STACK popped

(Table 1426)
Values for VLM status code:
 0000h	successful
 88xxh	error generated by requester
 8801h	invalid or non-attached connection handle
 8803h	cannot add CDS
 8804h	bad path
 8811h	nonexistent function called
 8836h	attempted function with invalid parameter
 8846h	???
 8848h	non-loaded or nonexistent VLM called
 884Dh	no more SFT entries (too many handles)
 8850h	too many reply fragments
 8853h	???
 89xxh	error generated by server, low byte = return code from server

(Table 1427)
Values for VLM identifier:
 0001h	VLM.EXE		Virtual Loadable Modules manager (see also #1429)
 0010h	CONN.VLM	connection table manager (see also #1430)
 0020h	TRAN.VLM	transport protocol multiplexor (see also #1431)
 0021h	IPXNCP.VLM	transport protocol implementation using IPX (see #1433)
 0022h	reserved for TCPNCP.VLM
 0030h	NWP.VLM		NetWare protocol multiplexor (see also #1434)
 0031h	BIND.VLM
 0032h	NDS.VLM		NetWare Directory Services (see also #1435)
 0033h	PNW.VLM		Personal NetWare
 0034h	RSA.VLM		RSA encryption for directory services re-authentication
 0040h	REDIR.VLM	DOS redirector (see also #1436)
 0041h	FIO.VLM		file I/O (see also #1438)
 0042h	PRINT.VLM	printer redirector (see also #1439)
 0043h	GENERAL.VLM	misc functions for NETx and REDIR (see also #1440)
 0050h	NETX.VLM	NetWare shell compatibility (see also #1441)
 0060h	AUTO.VLM	auto-reconnect/auto-retry
 0061h	SECURITY.VLM	enhanced security module
 0100h	NMR.VLM		NetWare management responder

Format of VLM header:
Offset	Size	Description	(Table 1428)
 00h	DWORD	-> initialization entry point
 04h	DWORD	-> VLM API entry point
 08h	DWORD	-> ??? entry point
 0Ch	DWORD	-> ??? entry point
 10h	DWORD	-> ??? entry point
	...
 var	DWORD	00000000h (end of entry point list)
      4 BYTEs	signature "NVlm"
	WORD	VLM identifier
Note:	the number of entry points in the header is reported as "Func" in the
	  VLM /D display.

(Table 1429)
Call VLM Manager (VLM.EXE, ID 0001h) with:
Func	Description/Registers
 01h	VLM Statistics

(Table 1430)
Call Connection Manager (CONN.VLM, ID 0010h) with:
Func	Description/Registers
 01h	Conn Get Version
 03h	Conn Statistics
 04h	Conn Alloc Handle
 05h	Conn Validate Handle
 06h	Conn Free Handle
 07h	Conn Get Entry Field
 08h	Conn Set Entry Field
 09h	Conn Reset Entry Field
 0Ah	Conn Lookup Handle
 0Dh	Conn Name Lookup
 0Eh	Conn Name To Handle
	DS:SI -> uppercased server name
	CX = length of server name, 0000h if ASCIZ name
	Return: AX = error code or 0000h if successful
		    CX = connection handle if successful
 0Fh	Conn Get Num Connections

(Table 1431)
Call TRAN.VLM (VLM ID 0020h) with:
Func	Description/Registers
 01h	Tran Get Version
 03h	Tran Statistics
 06h	Tran Request Reply (see INT 21/AH=F2h)
	AL = request code (see #1169 at INT 21/AH=F2h)
	BH = error handler flag
	    00h default error handler
	    01h return network errors to caller
	    02h handle network errors in requester
	BL = request list length (max 5 fragments) (see #1432)
	CX = connection handle
	DH = 00h (reserved)
	DL = reply list length (max 5 fragments) (see #1432)
	DS:SI -> address list
	ES:DI -> address list
	Return: AX = error code, 0000h if successful
		BX,DX destroyed
		reply buffer updated if successful
 08h	Tran Schedule/Cancel Event
 09h	Tran Get Max Size
 0Ah	Tran Broadcast Mux

Format of TRAN.VLM request/reply fragment descriptor (array):
Offset	Size	Description	(Table 1432)
 00h	DWORD	address of buffer
 04h	WORD	length of buffer

(Table 1433)
Call IPXNCP.VLM (VLM ID 0021h) with:
Func	Description/Registers
 01h	IPX Get Version
 03h	IPX Statistics
 06h	IPXNCP Request Reply???
	functionally equivalent to Tran Request Reply???

(Table 1434)
Call NWP.VLM (VLM ID 0030h) with:
Func	Description/Registers
 01h	NWP Get Version
 03h	NWP Statistics
 04h	NWP Connect
 05h	NWP Disconnect
 06h	NWP Attach
 08h	NWP Login
 09h	NWP Logout
 0Ah	NWP Get Bindery Object/Get Message Handler
 0Eh	NWP Ordered Send To All
 0Fh	NWP Preferred Handler
 10h	NWP ???
	AL = subfunction
	    01h get security flags (see also INT 21/AX=B301h)
		Return: BX:CX indicates signature level
				= 0100h:0000h if signature level=0
				= 0300h:0000h if signature level=1
				= 0302h:0000h if signature level=2
				= 0302h:0202h if signature level=3
	    04h set security flags (see also INT 21/AX=B304h)
		BL:CL = new flags

(Table 1435)
Call NDS.VLM (VLM ID 0032h) with:
Func	Description/Registers
 01h	NDS Get Version
 03h	NDS Statistics
 08h	NDS Fragment Request
 0Ch	NDS ???
	BX = subfunction
	    0002h read from TDS
		CX = reply buffer length
		DX = 0110h ???
		SI = offset in TDS
		ES:DI -> reply buffer
	    0003h write to TDS
	    0005h "NWDSChangeResourceConnection/Lock Connection"
	    0007h "NWDSSetMonitoredConnection"

(Table 1436)
Call REDIR.VLM (VLM ID 0040h) with:
Func	Description/Registers
 01h	Redir Get Version
 03h	Redir Statistics
 04h	Redir Build SFT (see INT 21/AH=B4h"NetWare")
	CX = connection handle
	ES:DI -> SFT build request (see #1437)
	Return: AX = 0000h if successful
		    BX = DOS file handle
 05h	Redir DOS To NW Handle
 08h	Redir Specific
	BX = 0000h get item
	    DS:SI -> ASCIZ string "LPTx" (x='1'-'9') or drive spec ("d:")
	    ES:DI -> reply buffer for "\\server\resource",00h,"path",00h

Format of NetWare SFT build request:
Offset	Size	Description	(Table 1437)
 00h  6 BYTEs	NetWare handle
 06h 18 BYTEs	???
 18h	LONG	file size
 1Ch  8 BYTEs	???

(Table 1438)
Call File I/O FIO.VLM (VLM ID 0041h) with:
Func	Description/Registers
 01h	FIO Get Version
 03h	FIO Statistics
 04h	FIO Remote Copy

(Table 1439)
Call PRINT.VLM (VLM ID 0042h) with:
Func	Description/Registers
 01h	Print Get Version
 03h	Print Statistics
 04h	Print Get/Set Data
 05h	Print Open Capture File
 07h	Print Get Num Of Printers
 08h	Print Redirection
	CX = connection handle
	DX = printer (0=LPT1)
	BX = destination
	    0000h redirect device to queue
		AX = length of queue name, 0000h to use queue ID
		DS:SI -> uppercased ASCIZ queue name
		ES:DI -> queue ID, 0000h:0000h to use queue name
	    0003h redirect device to file
		AX = 0000h or 4E57h ('NW')
		ES:DI -> ASCIZ path of file
	Return: AX = 0000h if successful
 09h	Print Flush And Close Job
 0Ch	Print Get/Set Banner Name

(Table 1440)
Call GENERAL.VLM (VLM ID 0043h) with:
Func	Description/Registers
 01h	Gen Get Version
 03h	Gen Statistics
 04h	Gen Get/Set Primary
 09h	Gen Return Drive Info

(Table 1441)
Call NETX.VLM (VLM ID 0050h) with:
Func	Description/Registers
 01h	NetX Get Version
 03h	NetX Statistics
--------N-2F7A20BX0001-----------------------
INT 2F - Novell NetWare - DOS Requester v1.03+ - GET VLM CallA ADDRESS
	AX = 7A20h
	BX = 0001h
Return: AX = 0000h if request was handled
	    ES:BX -> CallA entry point (see #1442)

(Table 1442)
Call VLM CallA entry point with:
	AX = function
	    0000h submit
	    0001h cancel (not implemented)
	ES:DI -> Overlay Asynchronous Control Block structure (see #1443)

Format of Overlay Asynchronous Control Block (OACB):
Offset	Size	Description	(Table 1443)
 00h	DWORD	link to next OACB, 0000h:0000h if last
 04h	DWORD	callback address or 0000h:0000h
 08h	BYTE	InUse flag (00h if complete)
 09h	BYTE	flag, reserved for VLM use
 0Ah	WORD	destination VLM
 0Ch	WORD	destination function
 0Eh	WORD	temporary storage for VLM.EXE
 10h  6 BYTEs	reserved
 16h  6 DWORDs	EAX,EBX,ECX,EDX,ESI,EDI
 2Eh  4 WORDs	DS,ES,FS,GS (FS and GS not used)
--------N-2F7A20BX0002-----------------------
INT 2F - Novell NetWare - DOS Requester v1.03+ - GET VLM MULTIPLEX ADDRESS
	AX = 7A20h
	BX = 0002h
Return: AX = 0000h
	ES:BX -> VLM multiplex entry point (see #1444)
Note:	for v1.10, this function is only available while VLM.EXE is loading
	  the .VLM modules, because ES is destroyed on return

(Table 1444)
Call DOS Requester entry point with:
	BX = function???
	    0000h
		DX = ???
		DI = ???
		BP = ???
	    0002h
		CX = ???
	    0003h
		DX = ???
		BP = ???
	    0006h
		AH = subfunction???
		AL = ???
		STACK: variable (0, 4, 10, 14 bytes seen)
--------N-2F7A20BX0003-----------------------
INT 2F - Novell NetWare - DOS Requester v1.03+ - GET VLM PARSE API ADDRESS
	AX = 7A20h
	BX = 0003h
Return: AX = 0000h if request was handled
	    ES:BX -> VLM parse API entry point
--------N-2F7A20BX0004-----------------------
INT 2F - Novell NetWare - DOS Requester v1.03+ - GET VLM MULTICAST CALLOUT
	AX = 7A20h
	BX = 0004h
Return: AX = 0000h if request was handled
	    ES:BX -> VLM multicast data (see #1445)

Format of DOS Requester data:
Offset	Size	Description	(Table 1445)
 00h	DWORD	pointer to ??? (code)
 04h  4 BYTEs	???
 08h	DWORD	pointer to ??? (code) (see #1446)
	???

(Table 1446)
Call offset 08h function with:
	AL = function (00h-07h)
	???
Return: ???
--------N-2F7A20BX0005-----------------------
INT 2F - Novell NetWare - DOS Requester v1.03+ - GET VLM INT 24 ADDRESS
	AX = 7A20h
	BX = 0005h
Return: AX = 0000h if request was handled
	    ES:BX -> VLM INT 24 handler
--------N-2F7A20BX0006-----------------------
INT 2F - Novell NetWare - DOS Requester v1.03+ - GET ??? ENTRY POINT
	AX = 7A20h
	BX = 0006h
Return: AX = 0000h if request was handled
	    ES:BX -> ??? entry point (RETF in v1.03 and v1.10)
--------N-2F7A20BX0007-----------------------
INT 2F - Novell NetWare - DOS Requester v1.03+ - GET ??? ENTRY POINT
	AX = 7A20h
	BX = 0007h
Return: AX = 0000h
	ES:BX -> ??? entry point (RETF in v1.03 and v1.10)
--------N-2F7A20BX0008-----------------------
INT 2F - Novell NetWare - DOS Requester v1.03+ - GET ??? ENTRY POINT
	AX = 7A20h
	BX = 0008h
Return: AX = 0000h
	ES:BX -> ??? entry point (RETF in v1.03 and v1.10)
--------N-2F7A20BX0080-----------------------
INT 2F - Novell NetWare - DOS Requester v1.03+ - GET ??? ENTRY POINT
	AX = 7A20h
	BX = 0080h
Return: AX = 0000h
	ES:BX -> ??? entry point (RETF in v1.03 and v1.10)
Note:	this function is identical to AX=7A20h/BX=0006h in v1.03 and v1.10
--------N-2F7A20BX0081-----------------------
INT 2F - Novell NetWare - DOS Requester v1.03+ - GET ??? ENTRY POINT
	AX = 7A20h
	BX = 0081h
Return: AX = 0000h
	ES:BX -> ??? entry point (RETF in v1.03 and v1.10)
Note:	this function is identical to AX=7A20h/BX=0007h in v1.03 and v1.10
--------N-2F7A20BX0082-----------------------
INT 2F - Novell NetWare - DOS Requester v1.03+ - GET ??? ENTRY POINT
	AX = 7A20h
	BX = 0082h
Return: AX = 0000h
	ES:BX -> ??? entry point (RETF in v1.03 and v1.10)
Note:	this function is identical to AX=7A20h/BX=0008h in v1.03 and v1.10
--------N-2F7A21-----------------------------
INT 2F C - Novell NetWare - DOS Requester - BROADCAST CALLBACK
	AX = 7A21h
	CX = server connection
Return: CX = 0000h if broadcast handled
SeeAlso: AX=7A22h,AX=7A85h
--------N-2F7A22-----------------------------
INT 2F C - Novell NetWare - DOS Requester - BROADCAST/SFT3 INFORM
	AX = 7A22h
	DL = function
	    21h ('!') broadcast
	    40h ('@') SFT3 inform
Return: AX = 0000h if event handled
SeeAlso: AX=7A21h
--------N-2F7A2F-----------------------------
INT 2F U - Novell NetWare - IPXODI v2.12 - GET ???
	AX = 7A2Fh
Return: AX = 0000h if supported and active
	    BX = version??? (0001h)
	    ES:DI -> entry point (see #1447)
Note:	IPXODI v2.12 is distributed as part of the Personal NetWare system
	  bundled with Novell DOS 7
SeeAlso: INT 7A/BX=001Fh

(Table 1447)
Call IPXODI entry point with:
	BX = function
	    0000h ???
		ES:SI -> ??? data
	    0001h ???
		AX = ???
		Return: ES:SI -> ??? data
	    0002h get ??? address
		Return: ES:SI -> ??? buffer
	    0003h send SPX packet???
		AL = ???
		CX = ???
		DX = ???
		SI = ???
		Return: ??? (registers from a call to INT 7A/BX=0016h)
Return: BX corrupted
--------N-2F7A2FBX0EDC-----------------------
INT 2F U - Personal NetWare - HRMIB - UNINSTALL
	AX = 7A2Fh
	BX = 0EDCh
Return: ???
SeeAlso: AX=7AA0h
--------N-2F7A40-----------------------------
INT 2F U - Novell NetWare - TCP/IP Protocol Stack - INSTALLATION CHECK
	AX = 7A40h
Return: AX = 7AFFh if installed
	    BX = ??? bit flags (see #1448)
	    CX = version (CH=major, CL=minor)
	    DX = 0000h
	    ES:DI -> entry point for TCP/IP stack (see #1449)
Notes:	Novell's LAN Workplace for DOS TCPIP.EXE also supports this interface
	this function is also supported by the Beame&Whiteside BWLWP40 shim,
	  but it only returns AL and ES:DI, and does not support AX=7A41h
SeeAlso: AX=7A41h,INT 15/AX=DE2Eh,INT 60"Excelan"

Bitfields for returned BX:
Bit(s)	Description	(Table 1448)
 0	???
 1	???
 15-2	reserved???

(Table 1449)
Call NetWare TCP/IP entry point with:
	ES:SI -> parameter block (see #1450)
Return: ES:SI parameter block updated

Format of NetWare TCP/IP parameter block:
Offset	Size	Description	(Table 1450)
 00h  4 BYTEs	???
 04h	WORD	(return) ???
 06h	WORD	(return) ???
 08h	DWORD	-> FAR routine called if bit 7 of function code set
 0Ch	BYTE	flags???
 0Dh  7 BYTEs	???
 14h	BYTE	(return) ???
 15h	BYTE	(call) function code (bit 7 set if ???) (see #1451)
 16h	BYTE	socket number
 17h	BYTE	(return) result or error code
 18h  4 WORDs	parameter words 0 to 3 (see #1451 for usage)
 20h	WORD	length of packet sent/received
 22h	WORD	number of pointer/length pairs following
 24h 6N BYTEs	buffer descriptors, each
		Offset	Size	Description
		 00h	DWORD	pointer to buffer
		 04h	WORD	length of buffer

(Table 1451)
Values for NetWare TCP/IP function code:
 01h	"accept"
 02h	"bind"
 03h	close socket
	Call:	socket number field set
 04h	"connect"
 05h	get IP address
	Call:	socket number field set to 0000h
	Return:	parameter words 1 and 2 contain caller's IP address
 06h	get hardware address
 07h	"getpeername"
 08h	get socket name
 0Ah	get netmask
 0Bh	"ioctl"
 0Ch	"listen"
 0Dh	"select"
 10h	"shutdown"
 11h	open socket
	Call:	socket number field set to 0000h
		parameter word 0 = desired protocol (6 = TCP, 17 = UDP)
	Return: socket number set
 12h	"read"
 13h	"recvfrom"
	Call:	socket number set
		packet length and buffer descriptors set
	Return:	packet length and receive buffers updated
		parameter word 1 = source port number
		parameter words 2 and 3 = source IP address
 14h	"write"
 15h	"sendto"
	Call:	socket number set
		flags field = ???
		parameter word 0 = 0000h
		parameter word 1 = destination port number
		parameter words 2 and 3 = destination IP address
		packet length and buffer descriptors set
 16h	get BOOTP data
Note:	these functions are based on the Unix socket interface
--------N-2F7A41-----------------------------
INT 2F - Novell NetWare - TCP/IP Protocol Stack - WINDOWS SUPPORT???
	AX = 7A41h
	ES:DI -> FAR entry point for ??? (will be called with BX=1,2,3,4)
Return: AX = 7AFFh if supported
	    BX = ??? (see #1448)
	    CX = version (CH=major, CL=minor)
	    DX = 0000h
	    ES:SI -> DWORD containing passed value of ES:DI
	    ES:DI -> entry point for TCP/IP stack
Notes:	Novell's LAN Workplace for DOS TCPIP.EXE also supports this interface
	the pointer which is set to ES:DI is cleared to 0000h:0000h when
	  a Windows exit broadcast is received
SeeAlso: AX=7A40h
--------N-2F7A42-----------------------------
INT 2F - Novell NetWare - TCPIP.EXE v4.1 - GET ??? ENTRY POINT
	AX = 7A42h
Return: AX = 7AFFh if supported
	    ES:DI -> ??? entry point (see #1425)

(Table 1452)
Call NetWare TCPIP.EXE entry point with:
	DX = ???
	ES:DI -> ??? (see #1453)
Return: AX = 0000h
	other registers destroyed

Format of data buffer:
Offset	Size	Description	(Table 1453)
 00h	WORD	offset of WORD ??? or 0000h
 02h	WORD	offset of DWORD ??? or 0000h
 04h	WORD	offset of DWORD ??? or 0000h
--------N-2F7A43-----------------------------
INT 2F - Novell NetWare - TCPIP.EXE v4.1 - GET ???
	AX = 7A43h
Return: AX = 7AFFh if supported
	    DX = offset of ???
SeeAlso: AX=7A44h
--------N-2F7A44-----------------------------
INT 2F - Novell NetWare - TCPIP.EXE v4.1 - SET ???
	AX = 7A44h
	DX = offset of ??? (see AX=7A43h)
Return: AX = 7AFFh if supported
SeeAlso: AX=7A43h
--------N-2F7A4C-----------------------------
INT 2F - Novell NetWare - TCPIP.EXE v4.1 - GET ???
	AX = 7A4Ch
Return: AX = 7AFFh if supported
	    BX = ??? (0037h)
	    CX = ??? (001Ch)
--------N-2F7A4DBX0001-----------------------
INT 2F - Novell NetWare - ???
	AX = 7A4Dh
	BX = 0001h
	ES:DI -> ???
Return: AL = FFh if ???
	    ES:DI -> ???
Note:	called by NETBIOS.EXE v3.01
--------N-2F7A4FBX0001-----------------------
INT 2F - Novell NetWare - SNMP.EXE - INSTALLATION CHECK
	AX = 7A4Fh
	BX = 0001h
Return: AX = 7AFFh if installed
--------N-2F7A4FBX0002-----------------------
INT 2F - Novell NetWare - SNMP.EXE - ???
	AX = 7A4Fh
	BX = 0002h
Return: AL = status
	    4Fh if failed
	    FFh if successful
--------N-2F7A80-----------------------------
INT 2F C - Novell NetWare - SHELL 3.01d BROADCAST - ABNORMAL EXIT
	AX = 7A80h
Return: nothing
Notes:	called on abnormal exit of the NetWare shell to notify other Novell
	  TSRs that it is unsafe to call the shell in the future.
	must be passed through so that all interested programs see the exit
	on receiving this call, IPXODI clears an internal pointer to a
	  default value; Novell's NETBIOS.EXE clears its INT 21h pointer to
	  0000h:0000h and stops calling it
SeeAlso: AX=7A81h
--------N-2F7A81-----------------------------
INT 2F C - Novell NetWare - SHELL 3.01d BROADCAST - SET SHELL INT 21 HANDLER
	AX = 7A81h
	CX:DX -> shell's INT 21h entry point
Return: nothing
Notes:	the shell calls this function as it loads to allow interested TSRs
	  and drivers to make a local copy of the shell's entry point
	must be passed through so that all interested programs see it
--------N-2F7A85-----------------------------
INT 2F C - Novell NetWare - shell 3.01 - BROADCAST INFORM
	AX = 7A85h
	CX = broadcast server number
Return: CX = 0000h if broadcast message handled by another program
	CX unchanged if broadcast not handled
SeeAlso: AX=7A21h
--------N-2F7A90-----------------------------
INT 2F U - Novell NetWare - NETBIOS.EXE 3+ - INSTALLATION CHECK
	AX = 7A90h
Return: AL = 00h if present
	    BX = ???
	    CX = PSP segment of NETBIOS resident code
SeeAlso: AX=7AFEh
--------N-2F7AA0-----------------------------
INT 2F U - Personal NetWare - HRMIB - ???
	AX = 7AA0h
	BX = function
	    0000h ???
	    0001h ???
Return: ???
SeeAlso: AX=7A2Fh/BX=0EDCh
--------N-2F7AC1-----------------------------
INT 2F - LAN HiJack - LHR - DISABLE???
	AX = 7AC1h
Program: LAN HiJack is a NetWare utility by KDS Software which allows a user
	  to take over control of a workstation remotely; LHR is the program
	  run on the slave workstation
SeeAlso: AX=7AC8h,AX=7AC9h,AX=7ACFh
--------N-2F7AC2-----------------------------
INT 2F - LAN HiJack - LHR - SYNCHRONIZE SHIFT STATES???
	AX = 7AC2h
Note:	sets BIOS keyboard status byte to an internal variable
SeeAlso: AX=7AC3h,AX=7ACFh
--------N-2F7AC3-----------------------------
INT 2F - LAN HiJack - LHR - CLEAR ??? FLAG
	AX = 7AC3h
SeeAlso: AX=7AC2h,AX=7ACFh
--------N-2F7AC8-----------------------------
INT 2F - LAN HiJack - LHR - ENABLE FUNCTIONS
	AX = 7AC8h
	BL = function(s) to enable (see #1454)
SeeAlso: AX=7AC1h,AX=7AC9h,AX=7ACFh

Bitfields for LAN HiJack function(s) to enable/disable:
Bit(s)	Description	(Table 1454)
 0	???
 1	remote keyboard enabled
 2	support remote's mouse
 3-7	unused
--------N-2F7AC9-----------------------------
INT 2F - LAN HiJack - LHR - DISABLE FUNCTIONS
	AX = 7AC9h
	BL = function(s) to disable (see #1454)
SeeAlso: AX=7AC1h,AX=7AC8h
--------N-2F7ACA-----------------------------
INT 2F - LAN HiJack - LHJ - ???
	AX = 7ACAh
	BL = ???
Return: ???
Program: LAN HiJack is a NetWare utility by KDS Software which allows a user
	  to take over control of a workstation remotely; LHJ is the program
	  run on the controlling workstation
--------N-2F7ACB-----------------------------
INT 2F - LAN HiJack - LHJ - ???
	AX = 7ACBh
	BX = ???
Return: ???
Note:	this function appears to be related to the keyboard
SeeAlso: AX=7ACCh
--------N-2F7ACC-----------------------------
INT 2F - LAN HiJack - LHJ - ???
	AX = 7ACCh
	BX = ???
Return: ???
Note:	this function appears to be related to the mouse
SeeAlso: AX=7ACBh
--------N-2F7ACFBX0000-----------------------
INT 2F - LAN HiJack - LHR - INSTALLATION CHECK
	AX = 7ACFh
	BX = 0000h
Return: BX = segment of resident code if installed
Program: LAN HiJack is a NetWare utility by KDS Software which allows a user
	  to take over control of a workstation remotely; LHR is the program
	  run on the slave workstation
--------N-2F7AF0-----------------------------
INT 2F - Novell NetWare - DOSNP.EXE v1.30G - INSTALLATION CHECK
	AX = 7AF0h
Return: AL = FFh if present
	    ES = 7AF0h
	    CX = PSP segment of resident code
--------N-2F7AF1-----------------------------
INT 2F - Novell NetWare - Access Server Driver - INSTALLATION CHECK
	AX = 7AF1h
	BL = sequence number (01h first driver, 02h second, 00h no driver)
Return: AX <> 7AF1h if present
	    BH = total number of drivers
	    ---if BL nonzero on entry---
	    AL = number of ports provided by specified driver
	    ES:DI -> driver entry point
		      (see #1455,#1456,#1457,#1458,#1459,#1460,#1461,#1462)
	    ES:DX -> ID string
SeeAlso: INT 7A/AX=001Ch

(Table 1455)
Call Access Server driver "initialize port" function with:
	AH = 01h
	AL = port number (00h-0Fh)
	ES:BX -> configuration parameter block (see #1468)
	interrupts disabled
Return: CF clear if successful
	CF set on error

(Table 1456)
Call Access Server driver "get port status" function with:
	AH = 02h
	AL = port number (00h-0Fh)
	interrupts disabled
Return: CF clear if successful
	    BL = transmitter status (see #1465)
	    BH = receiver status (see #1466)
	    DL = external status signals (see #1467)
	CF set on error
	interrupts disabled

(Table 1457)
Call Access Server driver "get input from port" function with:
	AH = 03h
	AL = port number (00h-0Fh)
	CX = size of data buffer
	ES:BX -> buffer for data
	interrupts disabled
Return: CF clear if successful
	CF set on error
	interrupts disabled
	CX = number of bytes read
Note:	the driver will add a NUL to the buffer when a break signal is detected

(Table 1458)
Call driver "send output data to port" function with:
	AH = 04h
	AL = port number (00h-0Fh)
	CX = number of bytes to send
	ES:BX -> buffer containing data
	interrupts disabled
Return: CF clear if successful
	CF set on error
	interrupts disabled
	CX = number of bytes actually written

(Table 1459)
Call driver "get I/O character counts" function with:
	AH = 05h
	AL = port number (00h-0Fh)
	interrupts disabled
Return: CF clear if successful
	    BX = number of bytes pending transmission
	    CX = number of bytes available for reading
	CF set on error
	interrupts disabled

(Table 1460)
Call driver "control XON/XOFF" function with:
	AH = 06h
	AL = port number (00h-0Fh)
	DL = new state
	    (00h software flow control disabled, else enabled)
	interrupts disabled
Return: CF clear if successful
	CF set on error
	interrupts disabled

(Table 1461)
Call driver "get error counts and statistics" function with:
	AH = 07h
	AL = port number (00h-0Fh)
	ES:BX -> buffer for statistics (see #1469)
	interrupts disabled
Return: CF clear if successful
	    ES:BX buffer filled
	CF set on error
	interrupts disabled

(Table 1462)
Call driver "general request" function with:
	AH = 08h
	AL = port number (00h-0Fh)
	DX = requested operations
	    bit 0: flush transmit buffers
	    bit 1: flush receive buffers
	    bit 4: define XON/XOFF characters
	ES:BX -> XON/XOFF characters (see #1470) if DX bit 4 set
	interrupts disabled
Return: CF clear if successful
	CF set on error
	interrupts disabled

(Table 1463)
Call driver "deadman timer management" function with:
	AH = 09h
	AL = port number (00h-0Fh)
	BX = next time interval in seconds (0000h to disable timer)
	interrupts disabled
Return: CF clear
	interrupts disabled

(Table 1464)
Call driver "get buffer sizes" function with:
	AH = 0Ah
	AL = port number (00h-0Fh)
	interrupts disabled
Return: CF clear if successful
	   BX = size of transmit buffer
	   CX = size of receive buffer
	CF set on error
	interrupts disabled

(Table 1465)
Values for Access Server transmitter status:
 00h	uninitialized
 01h	ready, not transmitting
 02h	transmitting
 03h	XOFF received
 04h	transmitting, buffer full
 05h	XOFF received and buffer full

(Table 1466)
Values for Access Server receiver status:
 00h	uninitialized
 01h	ready
 02h	receive buffer full, data may have been lost

Bitfields for external status signals:
Bit(s)	Description	(Table 1467)
 7,6	undefined
 5	CTS active
 4	DSR active
 3	DCD active
 2,1	undefined
 0	ring indicator

Format of Access Server configuration parameter block:
Offset	Size	Description	(Table 1468)
 00h	BYTE	receive baud rate index
		00h 50 bps, 01h 75 bps, 02h 110 bps, 03h 134.5 bps,
		04h 150 bps, 05h 300 bps, 06h 600 bps, 07h 1200 bps,
		08h 1800 bps, 09h 2000 bps, 0Ah 2400 bps, 0Bh 3600 bps,
		0Ch 4800 bps, 0Dh 7200 bps, 0Eh 9600 bps, 0Fh 19200 bps,
		10h 38400 bps, 11h 57600 bps, 12h 115200 bps
 01h	BYTE	receive bits per character (0=5 bits..3=8 bits)
 02h	BYTE	receive stop bits
 03h	BYTE	receive parity
		00h none, 01h odd, 02h even, 03h mark, 04h space
 04h	BYTE	transmit baud rate index (same as receive baud rate)
 05h	BYTE	transmit bits per character (0=5 bits..3=8 bits)
 06h	BYTE	transmit stop bits
 07h	BYTE	transmit parity (same as receive parity)
 08h	BYTE	DTR state (00h off, 01h on)
 09h	BYTE	RTS state (00h off, 01h on)
 0Ah	BYTE	flow control (00h none, 01h XON/XOFF, 02h RTS/CTS, 03h both)
 0Bh	BYTE	break control (00h off, 01h on)

Format of Access Server statistics:
Offset	Size	Description	(Table 1469)
 00h	BYTE	port number
 01h	BYTE	external status signals (see #1467)
 02h	BYTE	transmitter status (see #1465)
 03h	BYTE	receiver status (see #1466)
 04h	DWORD	number of characters received
 08h	DWORD	number of characters transmitted
 0Ch	WORD	input parity errors
 0Eh	WORD	input framing errors
 10h	WORD	lost characters due to hardware overrun
 12h	WORD	lost characters due to data buffer overrun
Note:	the counts are not allowed to wrap around; once a count reaches FFFFh
	  or FFFFFFFFh, it is no longer incremented

Format of Access Server XON/XOFF characters:
Offset	Size	Description	(Table 1470)
 00h	BYTE	04h (number of bytes following)
 01h	BYTE	transmit XON character
 02h	BYTE	transmit XOFF character
 03h	BYTE	receive XON character
 04h	BYTE	receive XOFF character
--------N-2F7AFE-----------------------------
INT 2F - Novell NetWare - DOSNP.EXE - INSTALLATION CHECK
	AX = 7AFEh
Return: AL = FFh if present
	    ES = (data???) segment of DOSNP
Program: DOSNP.EXE provides "named pipes" support for DOS workstations running
	   NetWare
Note:	the NetWare shell calls this function and refuses to load if DOSNP is
	  present
SeeAlso: AX=7A90h
--------N-2F7AFFBX0000-----------------------
INT 2F - Novell NetWare - TBMI v1.1+ - INSTALLATION CHECK / Windows SUPPORT
	AX = 7AFFh
	BX = 0000h
	CX = 4E65h ("Ne")
	DX = 7457h ("tW")
	ES:DI -> Windows support procedure (see #1471)
Return: AL = FFh if installed
	    CX = configured sockets (14h)
	    DS:SI -> data table ???
	    ES:DI -> IPX far call handler
Notes:	for IPX/SPX this call reportedly returns DS:SI pointing to the table
	  of pointers to service events queue head and tail
	this function is also supported by IPXODI; v2.12 does not change DS,
	  but does set SI to an internal address
SeeAlso: AX=7AFFh/BX=0001h

(Table 1471)
Values Windows support procedure called with:
	BP = function
	    0001h Get ECB
		BX = socket number
		Return: ES:SI -> ECB or 0000h:0000h if none available
	    0002h Count Listen ECBs
		AX = BX = socket
		Return: CX = number of listen ECBs for socket
				(must be >= 2 for SPX to work)
	    0003h ???
	    0004h Inform task switcher of ECB locations
		Note:	registers other than those listed above are equal
			  to the values when IPX was called
Note:	the support function will not be called if IPX is called with BX
	  bit 15 set
--------N-2F7AFFBX0001-----------------------
INT 2F - Novell NetWare - TBMI v1.1+, shell v3.01d - INSTALLATION CHECK???
	AX = 7AFFh
	BX = 0001h
	CX = 4E65h ("Ne")
	DX = 7457h ("tW")
Return: AL = FFh if installed
	    CX = ???  (8000h)
	    SI = ??? (or -> ???) (0002h and 0007h seen)
	    ES:DI -> IPX far call handler
	    ES:DX -> 6-byte data area ???
Note:	this function is also supported by IPXODI, but IPXODI v2.12 does not
	  return ES:DX
SeeAlso: AX=7AFFh/BX=0000h
--------d-2F7F00-----------------------------
INT 2F - Jim Harper's CD-ROM redirector SCSI driver - INSTALLATION CHECK
	AX = 7F00h
Return: AL = FFh if installed
SeeAlso: AX=7F01h,AX=7F02h,AX=7F03h
--------d-2F7F01-----------------------------
INT 2F - Jim Harper's CD-ROM redirector SCSI driver - DO COMMAND
	AX = 7F01h
	DS:DX -> command record (see #1472)
Return: AL = status
	    00h successful
	    else error code
SeeAlso: AX=7F00h,AX=7F02h,INT 11/AH=FFh"SDLP",INT 21/AX=4402h"ASPI"
SeeAlso: INT 4F/AX=8100h

Format of CD-ROM redirector command record:
Offset	Size	Description	(Table 1472)
 00h	BYTE	ID
 01h 10 BYTEs	CDB (Command Descriptor Block) for operation
 0Bh	WORD	segment of buffer
 0Dh	WORD	offset of buffer
 0Fh	BYTE	status
 10h	BYTE	sense
 12h	WORD	count
--------d-2F7F02-----------------------------
INT 2F - Jim Harper's CD-ROM redirector SCSI driver - DO RESET
	AX = 7F02h
SeeAlso: AX=7F00h,AX=7F01h
--------d-2F7F03-----------------------------
INT 2F - Jim Harper's CD-ROM redirector SCSI driver - UNINSTALL
	AX = 7F03h
Return: AL = status
	    00h successful
	    01h unable to uninstall
SeeAlso: AX=7F00h
----------2F7F24-----------------------------
INT 2F - Multiplex - ???
	AX = 7F24h
	???
Return: ???
Note:	called by PC/370, an IBM 370 emulator by Donald S. Higgins
----------2F7F26-----------------------------
INT 2F - Multiplex - ???
	AX = 7F26h
	???
Return: ???
Note:	called by PC/370, an IBM 370 emulator by Donald S. Higgins
--------!---Section--------------------------
