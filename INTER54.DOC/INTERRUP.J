Interrupt List, part 10 of 16
Copyright (c) 1989,1990,1991,1992,1993,1994,1995,1996,1997 Ralf Brown
--------N-2A00-------------------------------
INT 2A - NETWORK - INSTALLATION CHECK
	AH = 00h
Return: AH <> 00h if installed
	CF set if NetWare v2.15 NetBIOS emulator installed
Note:	supported by PC LAN Program, LAN Manager, LANtastic, NetWare, 10NET,
	  etc.
SeeAlso: INT 5C"NetBIOS"
--------N-2A0000-----------------------------
INT 2A - AT&T Starlan Extended NetBIOS (var length names) - INSTALLATION CHECK
	AX = 0000h
Return: AH = DDh
SeeAlso: INT 5B"Extended NetBIOS"
--------N-2A01-------------------------------
INT 2A - NETWORK (Microsoft,LANtastic) - EXECUTE NETBIOS REQUEST,NO ERROR RETRY
	AH = 01h
	ES:BX -> NCB (see #2881 at INT 5C"NetBIOS")
Return: AL = NetBIOS error code
	AH = status
	    00h no error
	    01h error occurred
SeeAlso: AH=04h,AX=0500h,INT 5B"Extended NetBIOS",INT 5C"NetBIOS"
--------N-2A02-------------------------------
INT 2A - NETWORK (Microsoft) - SET NET PRINTER MODE
	AH = 02h
	???
Return: ???
--------N-2A0300-----------------------------
INT 2A - NETWORK - CHECK DIRECT I/O
	AX = 0300h
	DS:SI -> ASCIZ device name (may be full path or only drive specifier--
		  must include the colon)
Return: CF clear if direct physical addressing (INT 13,INT 25) permissible
	CF set if access via files only
Notes:	do not use direct disk accesses if this function returns CF set or the
	  device is redirected (INT 21/AX=5F02h)
	use AH=00h to determine whether the network is installed; if not,
	  direct physical access is allowed
	may take some time to execute, so programs which need to check
	  frequently should save the result of the first call
	this function is called by the DOS kernel on INT 25 and INT 26
	supported by PC LAN Program, LAN Manage, LANtastic, NetWare, 10NET,
	  etc.
SeeAlso: INT 13/AH=02h,INT 13/AH=03h,INT 25,INT 26,INT 21/AX=5F02h
--------N-2A04-------------------------------
INT 2A - NETWORK - EXECUTE NetBIOS REQUEST
	AH = 04h
	AL = error retry
	    00h automatically retry request on errors 09h, 12h, and 21h
		  (see #2880 at INT 5C"NetBIOS")
	    01h no retry
	    02h ???
	ES:BX -> Network Control Block (see #2881 at INT 5C"NetBIOS")
Return: AX = 0000h if successful
	AH = 01h on error
	    AL = error code
Notes:	invokes either INT 5B or INT 5C as appropriate
	supported by PC LAN Program, LANtastic, LAN Manager, NetWare, 10NET,
	  etc.
	NetWare 2.15 NetBIOS emulator returns CF clear if successful, CF set
	  on error
	PC LAN Program defines any non-zero return value in AH as an error
	  indicator for subfunction 00h, and any non-zero return value in AX
	  as an error indicator for subfunction 01h
SeeAlso: AH=00h,AH=01h,AX=0500h,INT 5B"Extended NetBIOS",INT 5C"NetBIOS"
--------N-2A0500-----------------------------
INT 2A - NETWORK - GET NETWORK RESOURCE AVAILABILITY
	AX = 0500h
Return: AX reserved
	BX = number of network names available
	CX = number of network control blocks available
	DX = number of network sessions available
Notes:	supported by PC LAN Program, LAN Manager, LANtastic, NetWare, 10NET,
	  etc.
	the application should call this function before using any network
	  resources, and maintain its own count to avoid exceeding the
	  network's resource limits
SeeAlso: AH=00h,AH=01h,AH=04h,INT 5C"NetBIOS"
--------N-2A06-------------------------------
INT 2A - NETBIOS, LANtastic - NETWORK PRINT-STREAM CONTROL
	AH = 06h
	AL = function
	    01h set concatenation mode
		all printer output put in one job until return to DOS prompt
	    02h set truncation mode (default)
		printer open/close or BIOS/DOS output switch starts new job
	    03h flush printer output and start new print job
Return: CF set on error
	    AX = error code
	CF clear if successful
Notes:	subfunction 03h is equivalent to Ctrl/Alt/keypad-*
	supported by PC LAN Program, LANtastic, NetWare, 10NET, etc.
	LANtastic v4.x no longer supports this call
	this function sets the printer mode for all redirected printers
SeeAlso: INT 21/AX=5D08h,INT 21/AX=5D09h,INT 2F/AX=1125h
--------N-2A07-------------------------------
INT 2A U - PC Network v1.00 - RECEIVER.COM - ???
	AH = 07h
	???
Return: ???
Program: PC Network is an early networking package which was renamed the
	  IBM PC Local Area Network Program (PC LAN Program) as of v1.10
SeeAlso: AH=86h
--------N-2A2001-----------------------------
INT 2A - MS Networks or NETBIOS - ???
	AX = 2001h
	???
Return: ???
Note:	intercepted by DESQview 2.x
--------N-2A2002-----------------------------
INT 2A - NETWORK - ???
	AX = 2002h
	???
Return: ???
Note:	called by MS-DOS 3.30-6.00 APPEND
--------N-2A2003-----------------------------
INT 2A - NETWORK - ???
	AX = 2003h
	???
Return: ???
Note:	called by MS-DOS 3.30-6.00 APPEND
--------N-2A4147DX0000-----------------------
INT 2A U - NetSoft DOS-NET v1.20+ - INSTALLATION CHECK
	AX = 4147h ('AG')
	DX = 0000h
Return: DX = 4147h if installed
	    DS:SI -> configuration data (see #2209)
Program: DOS-NET is a shareware networking package by Albert Graham
Note:	this call is supported by CLIENT.COM, SERVER.COM, ROUTER.COM, and
	  NETDOS.COM
SeeAlso: INT 65/DX=4147h,INT 65/DX=4741h

Format of DOS-NET v1.20 configuration data area:
Offset	Size	Description	(Table 2209)
 00h	BYTE	???
 01h	BYTE	interrupt number used by DOS-NET APIs
 02h	WORD	function number to place in AX for above interrupt
 04h	BYTE	minor version as two BCD digits (e.g. 20h for v1.20)
 05h	BYTE	major version number (01h for v1.20)
 06h  2 BYTEs	???
 08h	WORD	??? (used by ARCNET.COM)
		bit 15: ??? (set by MACTEST.COM)
 0Ah	WORD	??? (used by NDIS.COM and ODI.COM)
 0Ch 22 BYTEs	???
 24h	DWORD	-> ??? function (set by PROTECT.COM)
 28h 12 BYTEs	???
 34h	DWORD	-> ??? function (set by FASTVIEW.COM)
 38h	DWORD	-> ??? function (set by FASTVIEW.COM)
 58h	DWORD	-> ??? (offsets 04h and 1Ah from value are used by NETFILES)
	???
 7Ch	WORD	???
 7Eh	WORD	??? (may be high half of a DWORD at 7Ch)
	???
 A8h	DWORD	-> ??? (used by SM.COM)
	???
114h	WORD	???
116h	WORD	??? (may be high half of a DWORD at 114h)
	???
1BDh	BYTE	??? flags
		bit 0: ???
		bit 6: ???
	???
1E1h	BYTE	???
	???
208h	WORD	??? (used by SM.COM, MACTEST)
282h	WORD	???
284h  2 BYTEs	???
286h	WORD	??? flags
		bit 0: ???
	???
31Eh	WORD	???
320h	WORD	??? (used by NDIS.COM and ODI.COM)
322h  8 BYTEs	???
32Ah	WORD	??? (used by NDIS.COM and ODI.COM)
	???
33Eh  4 BYTEs	??? (used by ODI.COM)
342h  N BYTEs	??? (used by NDIS.COM)
	???
3CFh	BYTE	??? flags
		bit 2: ???
3D2h	BYTE	installed-component flags
		bit 0: PROTECT installed
		bit 1: NETCACHE installed
		bit 3: SM.COM installed
		bit 7: NETDEBUG installed
3D3h	BYTE	installed-component flags
		bit 0: NETFILES installed
		bit 6: FASTVIEW installed
	???
3FFh	BYTE	??? (used by NDIS.COM)
400h	BYTE	???
401h	BYTE	??? (used by SM.COM)
402h	BYTE	??? (used by SM.COM)
	???
448h	BYTE	???
449h	BYTE	??? (used by MACTEST)
44Ah	BYTE	??? (used by PROTECT)
44Bh	BYTE	???
44Ch	BYTE	???
44Dh	BYTE	??? (used by SM.COM)
44Eh	BYTE	??? (used by SM.COM, MACTEST)
	???
--------N-2A7802-----------------------------
INT 2A - NETWORK - PC LAN PROG v1.31+ - GET LOGGED ON USER NAME
	AX = 7802h
	ES:DI -> 8-byte buffer to be filled
Return: AL = 00h if no user logged on to Extended Services
	AL <> 00h if user logged on to Extended Services
	    buffer at ES:DI filled with name, padded to 8 chars with blanks.
--------D-2A80-------------------------------
INT 2A CU - NETWORK - BEGIN DOS CRITICAL SECTION
	AH = 80h
	AL = critical section number (00h-0Fh) (see #2210)
Notes:	normally hooked to avoid interrupting a critical section, rather than
	  called
	the handler should ensure that none of the critical sections are
	  reentered, usually by suspending a task which attempts to reenter
	  an active critical section
	the DOS kernel does not invoke critical sections 01h and 02h unless it
	  is patched.  DOS 3.1+ contains a zero-terminated list of words
	  beginning at offset -11 from the Swappable Data Area
	  (see #1339 at INT 21/AX=5D06h); each word contains the offset within
	  the DOS data segment of a byte which must be changed from C3h (RET)
	  to 50h (PUSH AX) under DOS 3.x or from 00h to a nonzero value under
	  DOS 4.0+ to enable use of critical sections.	For DOS 4.0+, all
	  words in this list point at the byte at offset 0D0Ch.
	MS Windows patches the DOS kernel's calls to INT 2A/AH=80h-81h into
	  far calls to its own handler, and does not reflect the calls back
	  to INT 2A unless SYSTEM.INI contains ReflectDOSInt2A=1 or
	  ModifyDOSInt2A=0 in the [386Enh] section
	Novell NETX does not issue INT 2A/AH=80h and INT 2A/AH=81h calls when
	  it intercepts INT 21 calls and processes them itself
SeeAlso: AH=81h,AH=82h,AX=8700h,INT 21/AX=5D06h,INT 21/AX=5D0Bh

(Table 2210)
Values for DOS critical section number:
 01h	DOS kernel, SHARE.EXE, DOSMGR
	apparently for maintaining the integrity of DOS/SHARE/NET
	  data structures
 02h	DOS kernel, DOSMGR
	ensures that no multitasking occurs while DOS is calling an
	  installable device driver
 05h	network redirector
 06h	DOS 4.x only IFSFUNC
 08h	ASSIGN.COM
 0Ah	MSCDEX, CORELCDX
 0Fh	IBM PC LAN server (while intercepting INT 10/AH=06h,07h,0Eh)
--------D-2A81-------------------------------
INT 2A CU - NETWORK - END DOS CRITICAL SECTION
	AH = 81h
	AL = critical section number (00h-0Fh) (see #2210)
Notes:	normally hooked rather than called
	the handler should reawaken any tasks which were suspended due to an
	  attempt to enter the specified critical section
	MS Windows patches the DOS kernel's calls to INT 2A/AH=80h-81h into
	  far calls to its own handler, and does not reflect the calls back
	  to INT 2A unless SYSTEM.INI contains ReflectDOSInt2A=1 or
	  ModifyDOSInt2A=0 in the [386Enh] section
SeeAlso: AH=80h,AH=82h,AX=8700h
--------D-2A82-------------------------------
INT 2A CU - NETWORK - END DOS CRITICAL SECTIONS 0 THROUGH 7
	AH = 82h
Notes:	called by the INT 21h function dispatcher for function 0 and functions
	  greater than 0Ch except 59h, and on process termination
	the handler should reawaken any tasks which were suspended due to an
	  attempt to enter one of the critical sections 0 through 7
SeeAlso: AH=81h
--------N-2A84-------------------------------
INT 2A CU - NETWORK - KEYBOARD BUSY LOOP
	AH = 84h
Note:	similar to DOS's INT 28h, called from inside the DOS keyboard input
	  loop (i.e. INT 21/AH=07h or INT 21/AH=08h) to allow the network
	  software to process requests
SeeAlso: INT 28
--------N-2A86-------------------------------
INT 2A U - PC Network v1.00 - RECEIVER.COM - ???
	AH = 86h
	???
Return: ???
SeeAlso: AH=07h,AH=C4h
--------P-2A8700-----------------------------
INT 2A CU - PRINT - BEGIN BACKGROUND PRINTING
	AX = 8700h
	CF clear
Return: CF clear if OK to print in background now
	CF set if background printing not allowed at this time
Desc:	used to inform interested programs that PRINT is about to start its
	  background processing, and allow those programs to postpone the
	  processing if necessary
Notes:	when PRINT gains control and wants to begin printing, it calls this
	  function.  If CF is clear on return, PRINT begins its background
	  processing, and calls AX=8701h when it is done.  If CF is set on
	  return, PRINT will relinquish control immediately, and will not
	  call AX=8701h
	PCVENUS (an early network shell by IBM and CMU) hooks this call to
	  prevent background printing while its own code is active
SeeAlso: AH=80h,AH=81h,AX=8701h
--------P-2A8701-----------------------------
INT 2A CU - PRINT - END BACKGROUND PRINTING
	AX = 8701h
Desc:	used to inform interested programs that PRINT has completed its
	  background processing
Note:	called by PRINT after it has performed some background printing; not
	  called if AX=8700h returned with CF set.
SeeAlso: AX=8700h
--------N-2A89-------------------------------
INT 2A U - PC Network v1.00 - RECEIVER.COM - ???
	AH = 89h
	AL = ???  (ASSIGN uses 08h)
	???
Return: ???
--------I-2A90-------------------------------
INT 2A U - IBM PC 3270 EMULATION PROGRAM - ???
	AH = 90h
	???
Return: ???
Note:	the LANtastic redirector and SERVER.EXE use this function with AL=01h,
	  03h-07h,0Ch-11h
--------N-2AC2-------------------------------
INT 2A U - Network - ???
	AH = C2h
	AL = subfunction
	    07h ???
	    08h ???
	BX = 0001h
	???
Return: ???
Note:	this function is called by the DOS 3.30-6.00 APPEND
--------N-2AC4-------------------------------
INT 2A U - PC Network v1.00 - RECEIVER.COM - ???
	AH = C4h
	AL = subfunction
	    07h ???
	    08h ???
	BX = ???
	???
Return: ???
SeeAlso: AH=86h
--------N-2AD800-----------------------------
INT 2A U - Novell NetWare Lite - SERVER - SET ???
	AX = D800h
Return: nothing
Desc:	sets ??? flag, and sets ??? to initial value
Note:	called by CLIENT
SeeAlso: AX=D801h,AX=D850h
--------N-2AD801-----------------------------
INT 2A U - Novell NetWare Lite - SERVER - RESET ???
	AX = D801h
Return: nothing
Desc:	clears the ??? flag set by AX=D800h
Note:	called by CLIENT
SeeAlso: AX=D800h,AX=D850h
--------N-2AD850-----------------------------
INT 2A U - Novell NetWare Lite - CLIENT - INCREMENT ???
	AX = D850h
Return: nothing
Desc:	increments an internal byte-sized counter
Note:	this function is intercepted by DV/X 1.10 PEERSERV.DVR and the
	  Advanced NetWare 4.0 DOS Requester
SeeAlso: AX=D851h
--------N-2AD851-----------------------------
INT 2A U - Novell NetWare Lite - CLIENT - RESET ???
	AX = D851h
Return: nothing
Desc:	resets an internal byte-sized counter to zero
Note:	this function is intercepted by DV/X 1.10 PEERSERV.DVR and the
	  Advanced NetWare 4.0 DOS Requester
SeeAlso: AX=D850h
--------N-2AD852-----------------------------
INT 2A U - Novell NetWare - DOS Requester v1.03 - ???
	AX = D852h
Return: ???
Note:	calls the NetWare Lite SERVER installation check, and sets ??? pointer
SeeAlso: AX=D853h,INT 2F/AX=D880h
--------N-2AD853-----------------------------
INT 2A U - Novell NetWare - DOS Requester v1.03 - ???
	AX = D853h
Return: ???
Note:	clears the pointer set by AX=D852h
SeeAlso: AX=D852h
--------N-2AE0-------------------------------
INT 2A U - PC Network 1.00 - ???
	AH = E0h
	AL = subfunction??? (01h,02h, maybe others)
	???
Return: ???
Note:	called by PCNet 1.00 NET.COM, a shell program from which others are run
--------N-2AFF90-----------------------------
INT 2A - PC/TCP PREDIR.EXE - ???
	AX = FF90h
Return: AX = ???
Note:	PREDIR.EXE is the network printer redirector included as part of the
	  PC/TCP system by FTP Software, Inc.
--------N-2AFF91-----------------------------
INT 2A - PC/TCP PREDIR.EXE - ???
	AX = FF91h
	BX = ???
Return: AX = status???
--------N-2AFF92-----------------------------
INT 2A - PC/TCP PREDIR.EXE - INSTALLATION CHECK
	AX = FF92h
Return: AX = 0000h if installed
	   BX = redirected printer port (FFFFh if no printers redirected)
	   CX = version (CH = major, CL = minor)
Note:	PREDIR.EXE is the network printer redirector included as part of the
	  PC/TCP system by FTP Software, Inc.
--------N-2AFF93-----------------------------
INT 2A - PC/TCP PREDIR.EXE - ???
	AX = FF93h
Return: AX = ???
--------N-2AFF94-----------------------------
INT 2A - PC/TCP PREDIR.EXE - ???
	AX = FF94h
	BX = ???
	CX = ???
	DX = ???
Return: AX = ???
Note:	PREDIR.EXE is the network printer redirector included as part of the
	  PC/TCP system by FTP Software, Inc.
--------N-2AFF95-----------------------------
INT 2A - PC/TCP PREDIR.EXE - GET CONFIGURATION STRINGS
	AX = FF95h
	CX = what to get
	    0000h ??? (returned pointer to "C:\COMMAND.COM")
	    0001h spooling program
	    0002h ???
	    0003h spool file name
	    0004h swap file name
Return: AX = status
	    0000h successful
	BX:DX -> ASCIZ configuration string
--------N-2AFF96-----------------------------
INT 2A - PC/TCP PREDIR.EXE - SET PRINT JOB TERMINATION CONFIGURATION
	AX = FF96h
	CX = what to set
	    0000h ???
	    0001h print-on-hotkey state
	    0002h print-on-exit state
	    0003h print job timeout in clock ticks
	    0004h print-on-EOF state
	BX = new value (0000h disabled, 0001h enabled except for timeout)
Return: AX = ???
SeeAlso: AX=FF97h
Note:	PREDIR.EXE is the network printer redirector included as part of the
	  PC/TCP system by FTP Software, Inc.
--------N-2AFF97-----------------------------
INT 2A - PC/TCP PREDIR.EXE - GET PRINT JOB TERMINATION CONFIGURATION
	AX = FF97h
	CX = what to get
	    0000h ???
	    0001h print-on-hotkey state
	    0002h print-on-exit state
	    0003h print job timeout in clock ticks
	    0004h print-on-EOF state
Return: AX = status
	    0000h successful
	BX = old value (0000h disabled, 0001 enabled except for timeout)
SeeAlso: AX=FF96h
--------D-2B---------------------------------
INT 2B - DOS 2+ - RESERVED
Note:	this vector is not used in MS-DOS versions <= 6.22, and points at an
	  IRET instruction
--------D-2B---------------------------------
INT 2B - IBM ROM-DOS v4.0 - ???
	AH = function
	    00h ??? (modifies data in IBMBIO.COM)
	    01h internal operations
	    02h ???
		AL = index (00h-0Ch)
		Return: AX = ??? or (CMOS 2Dh and CMOS 2Eh)
	    03h get ??? data
		Return: AX = (CMOS 2Dh and CMOS 2Eh)
			BX = FFFFh
	    other does nothing
Note:	function 03h is called by ROMSHELL.COM; if BX != 0, then the ES:DI from
	  INT 2F/AX=1982h points at valid data
SeeAlso: INT 2F/AX=1982h
--------D-2C---------------------------------
INT 2C - DOS 2+ - RESERVED
Note:	this vector is not used in DOS versions <= 6.00, and points at an IRET
--------O-2C---------------------------------
INT 2C - STARLITE architecture - KERNEL API
Note:	STARLITE is an architecture by General Software for a series of MS-DOS
	  compatible operating systems (OEM DOS, NETWORK DOS, and SMP DOS) to
	  be released in 1991.	The interrupt number is subject to change
	  before the actual release.
--------m-2C---------------------------------
INT 2C R - Cloaking - CALL PROTECTED-MODE PASSALONG CHAIN
Notes:	when this interrupt is invoked in V86 mode, RM386 will invoke the first
	  in a chain of protected-mode handlers, and will only pass execution
	  to the V86-mode INT 2C handler if none of the handlers in the
	  passalong chain handle the call instead.  This is the method by which
	  the real-mode stub of a cloaked application communicates with the
	  protected-mode portion.
	the cloaking host calls the passalong chain with EAX=58494E33h ('WIN3')
	  when MS Windows starts up and with EAX=334E4958h ('3NIW') when
	  Windows shuts down; between these two broadcasts, the additional
	  Windows-only Cloaking services are available
	this function was first introduced with RM386 (RAM-MAN/386) v6.00, the
	  memory manager included in Helix Software's Netroom
SeeAlso: INT 2C/AX=0009h,INT 2F/AX=4310h"Cloaking"
--------m-2C0000-----------------------------
INT 2C P - Cloaking - ALLOCATE GDT SELECTOR
	AX = 0000h
	EBX = base address
	CL = access mode byte
	CH = extended access mode byte (omit limit field)
	EDX = segment limit
Return: CF clear if successful
	    AX = selector
	CF set on error
	    AX = error code (see #2211)
Notes:	this INT 2C interface is used by Netroom's DPMI.EXE v3.00
	to access extended memory, set the base address to the desired
	  physical address plus 400000h (4M)
	this function was first introduced with RM386 (RAM-MAN/386) v6.00, the
	  memory manager included in Helix Software's Netroom
SeeAlso: AX=0001h,AX=0002h,AX=0003h,AX=0004h,AX=0005h,INT 31/AH=57h,#0420

(Table 2211)
Values for Cloaking error code:
 0001h	no more selectors
 0002h	not a GDT ring 0 selector
 0003h	invalid selector (out of range, not user selector)
 0004h	selector not allocated
--------m-2C0001-----------------------------
INT 2C P - Cloaking - FREE GDT SELECTOR
	AX = 0001h
	SI = selector
Return: CF clear if successful
	CF set on error
	    AX = error code (see #2211)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0000h,INT 2F/AX=4310h"Cloaking"
--------m-2C0002-----------------------------
INT 2C P - Cloaking - SET SEGMENT BASE ADDRESS
	AX = 0002h
	SI = selector
	EBX = new physical base addres
Return: CF clear if successful
	CF set on error
	    AX = error code (see #2211)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0000h,AX=0003h,AX=0004h,INT 31/AX=0007h,#0420
--------m-2C0003-----------------------------
INT 2C P - Cloaking - SET SEGMENT LIMIT
	AX = 0003h
	SI = selector
	EBX = new limit
Return: CF clear if successful
	CF set on error
	    AX = error code (see #2211)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0000h,AX=0002h,AX=0004h,INT 31/AX=0008h
--------m-2C0004-----------------------------
INT 2C P - Cloaking - SET SEGMENT ACCESS MODE
	AX = 0004h
	SI = selector
	CL = new access mode byte (see #0421)
Return: CF clear if successful
	CF set on error
	    AX = error code (see #2211)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0000h,AX=0002h,AX=0003h,AX=0005h,INT 31/AX=0009h
--------m-2C0005-----------------------------
INT 2C P - Cloaking - SET SEGMENT EXTENDED ACCESS MODE
	AX = 0005h
	SI = selector
	CL = new extended access mode byte (limit field ignored) (see #2212)
Return: CF clear if successful
	CF set on error
	    AX = error code (see #2211)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0000h,AX=0002h,AX=0003h,AX=0004h,INT 31/AX=0009h

Bitfields for extended access mode byte:
Bit(s)	Description	(Table 2212)
 7	4K granularity instead of byte granularity
 6	32-bit code segment
 5	reserved (0)
 4	segment available to system
SeeAlso: #0422
--------m-2C0006-----------------------------
INT 2C P - Cloaking - GET PROTECTED-MODE INTERRUPT VECTOR
	AX = 0006h
	CL = vector (00h-7Fh)
Return: CF clear
	DX:EBX -> current interrupt handler
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0007h,INT 31/AX=0204h
--------m-2C0007-----------------------------
INT 2C P - Cloaking - SET PROTECTED-MODE INTERRUPT VECTOR
	AX = 0007h
	CL = vector (00h-7Fh)
	DX:EBX -> interrupt handler
Return: CF clear
Notes:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
	the IDT entry's type remains unchanged
SeeAlso: AX=0006h,INT 31/AX=0205h
--------m-2C0008-----------------------------
INT 2C P - Cloaking - GET PASSALONG ADDRESS
	AX = 0008h
Return: CF clear
	DX:EBX = current passalong address
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0009h,AX=002Ch,INT 2F/AX=4310h"Cloaking"
--------m-2C0009-----------------------------
INT 2C P - Cloaking - SET PASSALONG ADDRESS
	AX = 0009h
	DX:EBX = new value for passalong address (see #2213)
Return: CF clear
Notes:	when an INT 2C instruction is executed in V86 mode, the Cloaking host
	  calls the passalong address.	The handler should check whether the
	  upcall is of interest to it, and if not it should jump to the old
	  passalong address (retrieved with AX=0008h before the handler was
	  installed).  The final handler should return with CF clear to cause
	  the interrupt to be reflected back to V86 mode if none of the
	  passalong handlers is triggered
	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0008h,AX=002Dh,INT 2C"PASSALONG CHAIN"

(Table 2213)
Values Cloaking passalong address is called with:
	EAX = CS:IP of byte following INT 2C instruction invoking passalong
	SS:EBX -> caller registers (see #2214)
	CF clear
	others undefined
Return: CF clear: pass along to V86-mode INT 2C handler
	CF set: return immediately to V86 mode

Format of Cloaking caller registers:
Offset	Size	Description	(Table 2214)
 00h	DWORD	EDI
 04h	DWORD	ESI
 08h	DWORD	EBP
 0Ch	DWORD	reserved (ESP from PUSHAD instruction)
 10h	DWORD	EBX
 14h	DWORD	EDX
 18h	DWORD	ECX
 1Ch	DWORD	EAX
 20h	DWORD	error code
 24h	DWORD	EIP
 28h	WORD	CS
 2Ah	WORD	padding
 2Ch	DWORD	EFLAGS
 30h	DWORD	ESP
 34h	WORD	SS
 36h	WORD	padding
--remainder not available if protected-mode ring3 trap---
 38h	WORD	ES
 3Ah	WORD	padding
 3Ch	WORD	DS
 3Eh	WORD	padding
 40h	WORD	FS
 42h	WORD	padding
 44h	WORD	GS
 46h	WORD	padding
--------m-2C000A-----------------------------
INT 2C P - Cloaking - GET BASE ADDRESS OF GDT SELECTOR
	AX = 000Ah
	SI = selector
Return: CF clear if successful
	    EBX = segment base address
	CF set on error
	    AX = error code (see #2211)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00, the
	  memory manager included in Helix Software's Netroom
SeeAlso: AX=0000h,AX=0002h,AX=000Bh
--------m-2C000B-----------------------------
INT 2C P - Cloaking - GET SELECTOR LIMIT
	AX = 000Bh
	SI = selector
Return: CF clear if successful
	    EBX = segment base address
	CF set on error
	    AX = error code (see #2211)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=000Ah,INT 2F/AX=4310h"Cloaking"
--------m-2C---------------------------------
INT 2C P - RM386 v6.00 - CLOAKING - RESERVED FOR CLOAKED BIOS USE UNDER WINDOWS
	AX = function (000Ch-001Fh)
--------m-2C000F-----------------------------
INT 2C P - Cloaking v1.01 - "Simulate_Shell_Event"
	AX = 000Fh
	ECX = event code (see #2215)
	DX = subfunction for event
	EDX high word = boost value (see #2216)
	SI:EDI -> completion procedure
Return: CF clear if successful (event scheduled)
	CF set on error
Note:	this function is only available while MS Windows is running
SeeAlso: AX=0011h,AX=0012h,INT 2F/AX=1605h,INT 2F/AX=4310h"Cloaking"

(Table 2215)
Values for Cloaking shell event code:
 0414h	Hot key event
	subevent 0000h: Alt-Space
	subevent 0001h: Alt-Enter
	subevent 0002h: Dir-VM
 0415h	Switch context
	subevent 0000h for DOS VM context, nonzero for System VM context
 0416h	Clipboard event
 0417h	Termination event
	subevent 0000h for normal termination, nonzero for error
 0418h	Display message
	subevent 0000h for normal message, nonzero for system model ASAP
 0419h	Crash
 041Ah	Paste complete
	subevent 0000h: normal
	subevent 0001h: cancelled by user
	subevent 0002h: cancelled
 041Bh	Contention event
 041Ch	Screen switch
	subevent 0000h: forward
	subevent 0001h: back
 041Dh	Filesystem change
 041Eh	Check Focus
 041Fh	Panic

Bitfields for boost value:
Bit(s)	Description	(Table 2216)
 0	boost system VM until focus changes
 1	boost system VM on Switcher screen
 2	boost system VM until response
 3	boost system VM during clipboard activity
 4	boost system VM during print screen
 5	boost system VM during update
--------m-2C0011-----------------------------
INT 2C P - Cloaking v1.01 - "Switch_VMs_and_Call_back"
	AX = 0011h
	EBX = handle of VM to be made active
	SI:EDI -> 32-bit FAR completion procedure
Return: CF clear if successful (scheduled)
	CF set on error
Notes:	this function is only available while MS Windows is running
	the completion procedure is called with CF clear if the specified
	  VM has been made active, or with CF set on error
SeeAlso: AX=000Fh,AX=0012h
--------m-2C0012-----------------------------
INT 2C P - Cloaking v1.01 - "Query_Current_VM"
	AX = 0012h
Return: CF clear
	EBX = handle of active VM
	ESI = handle of system VM
	ECX = VM status flags (see #2217)
	EDX = shell flags (see #2218)
Note:	this function is only available while MS Windows is running in enhanced
	  mode
SeeAlso: AX=000Fh,AX=0011h,AX=0013h

Bitfields for VM status flags:
Bit(s)	Description	(Table 2217)
 0	in exclusive mode
 1	runs in background
 2	being created
 3	suspended
 4	not executable
 5	executing in protected mode
 6	contains PM application
 7	32-bit PM application
 8	called from VxD
 9	high priority background
 10	blocked on semaphore
 11	awakening
 12	has pageable V86
 13	has locked V86
 14	is scheduled
 15	idle
 16	closing

Bitfields for shell flags:
Bit(s)	Description	(Table 2218)
 2	windowed
 5	Alt-Tab reserved
 6	Alt-Esc reserved
 7	Alt-Space reserved
 8	Alt-PrtSc reserved
 9	Alt-Enter reserved
 10	Alt-PrtSc reserved
 11	PrtSc reserved
 12	polling enabled
 13	no HMA
 14	has shortcut key
 15	locked EMS handles
 16	locked XMS handles
 17	fast paste enabled
 18	locked V86 memory
 30	close-on-exit enabled
--------m-2C0013-----------------------------
INT 2C P - Cloaking v1.01 - "Issue_System_Modal_Message"
	AX = 0013h
	EDX = message box flags (see #2219)
	DS:ECX -> ASCIZ message text
	DS:EDI -> ASCIZ caption
Return: CF clear
	EAX = response code
Note:	this function is only available while MS Windows is running in enhanced
	  mode
SeeAlso: AX=000Fh,AX=0012h

Bitfields for message box flags:
Bit(s)	Description	(Table 2219)
 3-0	response codes (see #2220)
 7-4	icon codes
	1 = Warning hand
	2 = exclamation mark
	4 = asterisk
 9-8	default response (0 = first button, 1 = second, 2 = third)
 12	message is system model
 15	don't change focus
 29	hang with interrupts enabled
 30	do not window
 31	execute ASAP

(Table 2220)
Values for response codes:
 00h	OK
 01h	OK, Cancel
 02h	Abort, Retry, Ignore
 03h	Yes, No, Cancel
 04h	Yes, No
 05h	Retry, Cancel
--------m-2C001D-----------------------------
INT 2C P - Cloaking v1.01 - GET INT 2C API HANDLER ENTRY POINT
	AX = 001Dh
Return: CF clear
	DX:EBX = selector:offset of Cloaking host INT 2C handler
Desc:	get the Cloaking host's entry point to bypass any other programs
	  which may have hooked INT 2C in protected mode
Note:	the returned entry point must be called with a simulated INT, i.e.
	  a PUSHD must precede the far call to the handler
SeeAlso: INT 2F/AX=4310h"Cloaking"
--------m-2C001E-----------------------------
INT 2C P - Cloaking v1.01 - CLEAR CRITICAL SECTION
	AX = 001Eh
Return: CF clear
Desc:	allow MS Windows to switch to another VM after having prevented it
	  by invoking a critical section
SeeAlso: AX=001Fh,INT 15/AX=101Ch,INT 2F/AX=1682h
--------m-2C001F-----------------------------
INT 2C P - Cloaking v1.01 - SET CRITICAL SECTION
	AX = 001Fh
Return: CF clear
Desc:	prevent MS Windows from switching to another VM
SeeAlso: AX=001Eh,INT 15/AX=101Bh,INT 2F/AX=1681h
--------m-2C0020-----------------------------
INT 2C P - Cloaking - GET SIZE OF PROTECTED-MODE STATE
	AX = 0020h
Return: EAX = number of bytes required for storing state
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0021h,AX=0022h
--------m-2C0021-----------------------------
INT 2C P - Cloaking - SAVE PROTECTED-MODE STATE
	AX = 0021h
	ES:EDI -> buffer for protected-mode state
Return: CF clear
	buffer filled
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0020h,AX=0022h
--------m-2C0022-----------------------------
INT 2C P - Cloaking - RESTORE PROTECTED-MODE STATE
	AX = 0022h
	DS:ESI -> buffer containing previously-saved protected-mode state
Return: CF clear if successful
	    state restored
	CF set on error (invalid buffer contents)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0020h,AX=0021h
--------m-2C0023-----------------------------
INT 2C P - Cloaking - ISSUE PROTECTED-MODE XMS CALL
	AX = 0023h
Notes:	not currently implemented--NOP in RM386 v6.00
	this function was first introduced with RM386 (RAM-MAN/386) v6.00
--------m-2C0024-----------------------------
INT 2C P - Cloaking - SET V86-MODE STACK
	AX = 0024h
	DX:EBX = new value for V86-mode SS:ESP
Return: nothing
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
--------m-2C0025-----------------------------
INT 2C P - Cloaking - CALL V86-MODE PROCEDURE
	AX = 0025h
	DS:EBX -> client register structure (see #2214)
Return: CF clear if successful
	    client register structure updated
	CF set if no more nested procedure call space available
Notes:	this call uses the V86-mode stack supplied in the client structure, and
	  calls the routine specified by CS:IP in the client structure
	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0026h,AX=0027h,INT 31/AX=0301h
--------m-2C0026-----------------------------
INT 2C P - Cloaking - CALL V86-MODE INTERRUPT HANDLER
	AX = 0026h
	DS:EBX -> client register structure (see #2214)
	CX = interrupt number
Return: CF clear if successful
	    client register structure updated
	CF set if no more nested procedure call space available
Notes:	this call uses the V86-mode stack supplied in the client structure
	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0025h,AX=0027h,INT 31/AX=0300h
--------m-2C0027-----------------------------
INT 2C P - Cloaking - CHAIN TO V86-MODE INTERRUPT HANDLER
	AX = 0027h
	DS:EBX -> client register structure (see #2214)
Return: CF clear if successful
	    client register structure updated
	CF set if no more nested procedure call space available
Notes:	this call uses the V86-mode stack supplied in the client structure,
	  and jumps to the address specified by CS:IP in the client structure
	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0025h,AX=0026h
--------m-2C0028-----------------------------
INT 2C P - Cloaking - GET ESP0 FROM TSS
	AX = 0028h
Return: CF clear
	EAX = TSS's ESP0
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00, the
	  memory manager included in Helix Software's Netroom
--------m-2C0029-----------------------------
INT 2C P - Cloaking - SET SECONDARY STACK
	AX = 0029h
	DX:EBX = new value for SS:ESP of ring 3 secondary stack
Return: CF clear
Desc:	inform RM386 of the ring 3 interrupt stack location
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
--------m-2C002A-----------------------------
INT 2C P - Cloaking - SET 8259 IRQ BASE VECTORS
	AX = 002Ah
	BL = base vector of master interrupt controller
	CL = base vector of slave interrupt controller
Notes:	this call merely informs RM386 that the caller has changed the
	  interrupt mappings
	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: INT 67/AX=DE0Bh
--------m-2C002BCH81-------------------------
INT 2C P - Cloaking - PROTECTED-MODE VIRTUAL DMA SERVICES
	AX = 002Bh
	CH = 81h
	CL = subfunction (02h-0Ch)
	other registers as appropriate for subfunction
Return: varies by function
	CF set on error
Notes:	these functions are equivalent to the INT 4B/AX=81xxh subfunctions
	  with the same numbers
	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: INT 4B/AX=8102h,INT 4B/AX=810Ch
--------m-2C002C-----------------------------
INT 2C P - Cloaking - GET PORT-TRAPPING PASSALONG
	AX = 002Ch
Return: CF clear
	DX:EBX = current I/O trapping passalong address
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0008h,AX=002Dh
--------m-2C002D-----------------------------
INT 2C P - Cloaking - SET PORT-TRAPPING PASSALONG
	AX = 002Dh
	DX:EBX = new I/O trapping passalong address (see #2221)
Return: CF clear
Notes:	RM386 calls the passalong address whenever an access to a monitored
	  I/O port is attempted; the handler should check whether it is a port
	  that it is interested in, and if not call the previous passalong
	  address (which was retrieved with AX=002Ch before installing the
	  new handler)
	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0009h,AX=002Ch,INT 67/AX=5DEAh

(Table 2221)
Values Cloaking port-trapping passalong address is called with:
	EAX = CS:IP of faulting instruction (unless executing in protected-mode
		ring 3)
	SS:EBX -> caller register structure (see #2214)
		check EFLAGS V86-mode bit for type
	CX = first two bytes of I/O instruction which was trapped
	DX = port to which I/O is being performed
	CF clear
Return: CF clear if RM386 should perform I/O operation
	CF set if I/O should be skipped
Note:	RM386 skips the trapped I/O instruction, so the passalong handler
	  should not modify the client CS:EIP
--------m-2C002E-----------------------------
INT 2C P - Cloaking - TRAP I/O PORT
	AX = 002Eh
	DX = port number to trap
Return: CF clear if successful
	CF set on error (port out of range or reserved)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=002Fh,AX=0030h
--------m-2C002F-----------------------------
INT 2C PU - Cloaking - UNTRAP I/O PORT
	AX = 002Fh
	DX = port number for which to cancel trapping
Return: CF clear if successful
	CF set on error (port out of range or reserved)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=002Eh,AX=0030h
--------m-2C0030-----------------------------
INT 2C PU - Cloaking - GET TRAPPING STATE OF SPECIFIED PORT
	AX = 0030h
	DX = port number
Return: CF clear if successful
	   BX = current state (0000h not trapped, 0001h trapped)
	CF set on error (port out of range or reserved)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=002Eh,AX=002Fh
--------m-2C0031-----------------------------
INT 2C PU - RM386 v6.00 - BUG
	AX = 0031h
Program: RM386 (RAM-MAN/386) is the memory manager included in Helix
	  Software's Netroom
Note:	due to a fencepost error, RM386 v6.00 will branch unpredictably if
	  invoked with this function
--------m-2C0031-----------------------------
INT 2C P - Cloaking v1.01 - ALLOCATE V86 CALLBACK
	AX = 0031h
	DX:EBX = CS:EIP of protected-mode routine to be invoked by callback
Return: CF clear if successful
	    EBX = CS:IP of V86-mode callback handler
	CF set on error
SeeAlso: AX=0032h
--------m-2C0032-----------------------------
INT 2C P - Cloaking v1.01 - FREE V86 CALLBACK
	AX = 0032h
	EBX = CS:IP of V86-mode callback handler
Return: CF clear if successful
	CF set on error
	    AX = error code
		0005h invalid callback address
		0006h callback already free
SeeAlso: AX=0032h
--------m-2C0033-----------------------------
INT 2C P - Cloaking v1.01 - REGISTER CLOAKING CLIENT
	AX = 0033h
	DS:EDX -> client registration structure (see #2222)
Return: CF clear if successful
	CF set on error (linked list corrupt)
SeeAlso: AX=0034h,#2426 at INT 2F/AX=4310h"Cloaking"

Format of client registration structure:
Offset	Size	Description	(Table 2222)
 00h	PWORD	link to next structure
 06h	PWORD	link to previous structure
 0Ch  2 BYTEs	client version (major, minor)
 0Eh 20 BYTEs	client name
 22h	DWORD	physical address of client start
 26h	DWORD	client's total size in bytes
Note:	the link area should not be modified once the structure has been
	  used for the registration call
--------m-2C0034-----------------------------
INT 2C P - Cloaking v1.01 - UNREGISTER CLOAKING CLIENT
	AX = 0034h
	DS:EDX -> client registration structure (see #2222)
Return: CF clear if successful
	CF set on error (linked list corrupt)
Note:	the client must unregister before freeing the XMS block containing
	  its registration structure(s)
SeeAlso: AX=0033h,#2426 at INT 2F/AX=4310h"Cloaking"
--------D-2D---------------------------------
INT 2D - DOS 2+ - RESERVED
Note:	this vector is not used in DOS versions <= 6.00, and points at an IRET
BUG:	RM386 v6.00-6.02 (as distributed with Helix's Netroom v3.x) contains
	  a stack bug in its protected-mode INT 2D handler which causes a crash
	  when INT 2D is invoked from V86 mode
--------t-2D---------------------------------
INT 2D - ALTERNATE MULTIPLEX INTERRUPT SPECIFICATION (AMIS) [v3.6]
	AH = multiplex number
	AL = function
	    00h installation check
	    01h get private entry point
	    02h uninstall
	    03h request popup
	    04h determine chained interrupts
	    05h get hotkey list
	    06h get device-driver information
	    07h-0Fh reserved for future enhancements
		Return: AL = 00h (not implemented)
	    other  application-dependent
	other registers vary by function (also see individual entries below)
Return: varies by function
Notes:	programs should not use fixed multiplex numbers; rather, a program
	  should scan all multiplex numbers from 00h to FFh, remembering the
	  first unused multiplex in case the program is not yet installed.
	  For multiplex numbers which are in use, the program should compare
	  the first 16 bytes of the signature string to determine whether it
	  is already installed on that multiplex number.  If not previously
	  installed, it should use the first free multiplex number.
	functions other than 00h are not valid unless a program is installed
	  on the selected multiplex number
	to be considered fully compliant with version 3.6 of the specification,
	  programs must implement at least functions 00h, 02h (no resident
	  uninstall code required), and 04h (return value 04h).	 TSRs that
	  provide hotkeys with which the user can activate them must also
	  implement function 05h.  TSRs which provide DOS device drivers must
	  also implement function 06h.	The absolute minimum fully-compliant
	  implementation has an overhead of 64 bytes (80 bytes with function
	  05h) plus 22 bytes per hooked interrupt (for the interrupt sharing
	  protocol header and hook list entry).
	the signature string and description may be used by memory mappers
	  to display the installed programs
	to be considered fully compliant, users of this specification must
	  adhere to the IBM interrupt sharing protocol (see #2223), which will
	  permit removal of TSRs in arbitrary order and interrupt handler
	  reordering.  All TSRs following this specification should be
	  removable unless they are loaded from CONFIG.SYS, though they need
	  not keep the code for removing themselves resident; it is acceptable
	  for a separate program to perform the interrupt unhooking and
	  memory-freeing steps of removal.
	A sample public-domain implementation including example TSRs and
	  utility programs may be found in a separate package distributed as
	  AMISLnnn.ZIP (AMISL092.ZIP as of this writing).
	Please let me know if you choose to follow this proposal.  The
	  signature and a list of the private API calls you use would be
	  appreciated, as well.
SeeAlso: INT 2D/AL=00h,INT 2D/AL=01h,INT 2D/AL=02h,INT 2D/AL=03h,INT 2D/AL=04h
SeeAlso: INT 2D/AL=05h,INT 2D/AL=06h,INT 2F"NOTES"

Format of interrupt sharing protocol interrupt handler entry point:
Offset	Size	Description	(Table 2223)
 00h  2 BYTEs	short jump to actual start of interrupt handler, immediately
		  following this data block (EBh 10h)
 02h	DWORD	address of next handler in chain
 06h	WORD	signature 424Bh
 08h	BYTE	EOI flag
		00h software interrupt or secondary hardware interrupt handler
		80h primary hardware interrupt handler (will issue EOI)
 09h  2 BYTEs	short jump to hardware reset routine
		must point at a valid FAR procedure (may be just RETF)
 0Bh  7 BYTEs	reserved (0) by IBM for future expansion
Note:	when chaining to the prior handler, the interrupt handler must perform
	  an indirect jump/call using the address at offset 02h in the
	  ISP header.  This permits another AMIS TSR to hook itself into
	  the chain at a position other than as the first handler to receive
	  an interrupt.
SeeAlso: INT F1/AH=01h"Common ISDN API",INT F1/AH=06h"CAPI",#3669
--------t-2D--00-----------------------------
INT 2D - AMIS v3.0+ - INSTALLATION CHECK
	AL = 00h
	AH = multiplex number for program
Return: AL = 00h if free
	AL = FFh if multiplex number in use
	    CX = binary version number (CH = major, CL = minor)
	    DX:DI -> signature string (see #2224) identifying the program
		  using the multiplex number
SeeAlso: INT 2D/AL=01h,INT 2D/AL=02h,INT 2D/AL=03h,INT 2D/AL=04h,INT 2D/AL=05h
SeeAlso: INT 2D/AL=06h
Index:	installation check;Alternate Multiplex Interrupt Specification
Index:	installation check;AMIS|installation check;FASTMOUS
Index:	installation check;SPELLER|installation check;Monitor
Index:	installation check;NOLPT|installation check;NOTE
Index:	installation check;RBkeyswp|installation check;SWITCHAR
Index:	installation check;VGABLANK|installation check;EATMEM
Index:	installation check;RECALL|installation check;XPTR2

Format of AMIS signature string:
Offset	Size	Description	(Table 2224)
 00h  8 BYTEs	blank-padded manufacturer's name (possibly abbreviated)
 08h  8 BYTEs	blank-padded product name
 10h 64 BYTEs	ASCIZ product description (optional, may be a single 00h)
Note:	it is not necessary to reserve a full 64 bytes for the description,
	  just enough to store the actual ASCIZ string
SeeAlso: #2225

(Table 2225)
Values for AMIS signatures known to be in use:
 'Byrial J' 'EKLAVO  '	permits keyboard entry of Esperanto accented letters
 'CoveSoft' 'Burnout+'	shareware screen saver Burnout Plus
 'Crynwr  ' 'SPELLER '	TSR spelling-checker
 'CPH1995 ' 'CDTSR   '	resident CD-Audio player
 'CPH1996 ' 'DSAPI   '
 'CSJewell' 'Modula3L'	Curtis Jewell's Modula-3 compiler (non-TSR)
 'DAISYCHA' 'INDRIVER'	Advanced Parallel Port daisy chain driver (vendor name
			  in product description field, if desired)
			(see also INT 2D/AL=DCh)
 'DTown SD' 'DTU     '	DTown Software Development's DTown Utilities
			(see also INT 2D/AL=20h)
 'ECLIPSE ' 'PLUMP   '	Eclipse Software's printer and plotter spooler
 'GraySoft' 'GIPC    '	GraySoft's Inter-Process Communications driver
 'heathh  ' 'Monitor '
 'Helge O '		TSRs by Helge Olav Helgesen
 'J. Berry' 'RATSR   '	RemoteAccess Network Manager workstation module
 'JWB	  ' 'RAMLIGHT'	James Birdsall's on-screen RAMdisk activity indicator
 'M Better' 'iHPFS   '	Marcus Better's HPFS filesystem driver for DOS
 'M. Paul ' 'FREEVER '	DOS version-faking TSR by Matthias Paul
 'Nildram ' 'ST	     '	Screen Thief graphics screen grabber
 'Pino Nav' 'ALTMENU '	activate any program's menu bar by pressing Alt key
 'Pino Nav' 'Keybit  '	Pino Navato's KEYBIT Lite Italian keyboard driver v4+
 'PowrQuot' 'CAPRILOG'
 'PowrQuot' 'CAPRITSR'
 'PowrQuot' 'CAPRIWIN'
 'R-Ware  ' 'dLite   '	run-time data decompression TSR
 'Ralf B  ' 'disaXXYY'	RBdisabl -- disable key scancode XX w/ shift states YY
 'Ralf B  ' 'DUALVGA '	dual-VGA support, screen blanker, and DPMS driver
 'Ralf B  ' 'FASTMOUS'	example TSR included with sample AMIS library code
 'Ralf B  ' 'NoBreak '	disable Ctrl-@, Ctrl-C, and Ctrl-Break keys
 'Ralf B  ' 'NOLPT n '	example TSR -- turn LPTn into bit-bucket
 'Ralf B  ' 'NOTE    '	example TSR -- popup note-taker
 'Ralf B  ' 'RBclock '	RBclock -- on-screen real-time clock
 'Ralf B  ' 'RBclockE'	RBclock -- on-screen elapsed-time clock
 'Ralf B  ' 'RBdvorak'	Dvorak keyboard mapping w/ opt Esc/~, LCtrl/CapsLk swap
 'Ralf B  ' 'RBkcount'	display count of keystrokes on screen
 'Ralf B  ' 'RBkeyswp'	RBkeyswap v3.0+ -- swap Esc/~ and LCtrl/CapsLock keys
 'Ralf B  ' 'RBnoboot'	disable Ctrl-Alt-Del key combination
 'Ralf B  ' 'ShftCaps'	require Shift-CapsLock to turn on CapsLock
 'Ralf B  ' 'ShftNumL'	require Shift-NumLock to turn off NumLock
 'Ralf B  ' 'SWITCHAR'	example TSR -- add switchar() support removed from DOS5
 'Ralf B  ' 'VGABLANK'	VGA-only screen blanker
 'Ralf B  ' 'WINTAME '	yield CPU when program in Win95 DOS box is idle
 'Sally IS' 'Mdisk   '	removeable, resizeable RAMdisk
 'Sally IS' 'Scr2Tex '	screen dumper with output in (La)Tex format
 'SRT	  ' 'STOPBOOT'	reboot preventer by Steve Talbot
 'Thaco	  ' 'NEST    '	Eirik Pedersen's programmer's delimiter matcher
 'TifaWARE' 'EATMEM  '	George A. Theall's public domain memory restrictor for
			testing programs (v1.1+)
 'TifaWARE' 'RECALL  '	public domain commandline editor and history (v1.2+)
 'Todd	  ' 'XPTR2   '	PC-to-Transputer interface by Todd Radel
 'WlkngOwl' 'NoiseSYS'	NOISE.SYS random-number generator
SeeAlso: #2224
--------t-2D--01-----------------------------
INT 2D - AMIS v3.0+ - GET PRIVATE ENTRY POINT
	AL = 01h
	AH = multiplex number for program
Return: AL = 00h if all API calls via INT 2D
	AL = FFh if entry point supported
	    DX:BX -> entry point for bypassing interrupt chain
Note:	this function is not valid unless a program is installed on the
	  specified multiplex number; use INT 2D/AL=00h to check
SeeAlso: INT 2D/AL=00h,INT 2D/AL=02h,INT 2D/AL=03h,INT 2D/AL=04h,INT 2D/AL=05h
SeeAlso: INT 2D/AL=06h
Index:	entry point;Alternate Multiplex Interrupt|entry point;AMIS
--------t-2D--02-----------------------------
INT 2D - AMIS v3.0+ - UNINSTALL
	AL = 02h
	AH = multiplex number for program
	DX:BX = return address for successful uninstall (may be	ignored by TSR)
Return: AL = status
	    00h not implemented (makes TSR non-compliant with specification)
	    01h unsuccessful
	    02h can not uninstall yet, will do so when able
	    03h safe to remove, but no resident uninstaller
		  (TSR still enabled)
		BX = segment of memory block with resident code
	    04h safe to remove, but no resident uninstaller
		  (TSR now disabled)
		BX = segment of memory block with resident code
	    05h not safe to remove now, try again later
	    06h disabled, but can not be removed from memory
		  because loaded from CONFIG.SYS
	    07h safe to remove, but no resident device-driver
		  uninstaller.	Caller must unlink device
		  drivers from DOS device chain as well as
		  unhooking interrupts and freeing memory
		BX = segment of memory block with resident code
	    FFh successful
	return at DX:BX with AX destroyed if successful and TSR honors
	  specific return address
Note:	this function is not valid unless a program is installed on the
	  specified multiplex number; use INT 2D/AL=00h to check
SeeAlso: INT 2D/AL=00h,INT 2D/AL=01h,INT 2D/AL=03h,INT 2D/AL=04h,INT 2D/AL=05h
SeeAlso: INT 2D/AL=06h
Index:	uninstall;Alternate Multiplex Interrupt Specification|uninstall;AMIS
--------t-2D--03-----------------------------
INT 2D - AMIS v3.0+ - REQUEST POP-UP
	AL = 03h
	AH = multiplex number for program
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
Note:	this function is not valid unless a program is installed on the
	  specified multiplex number; use INT 2D/AL=00h to check
SeeAlso: INT 2D/AL=00h,INT 2D/AL=01h,INT 2D/AL=02h,INT 2D/AL=04h,INT 2D/AL=05h
SeeAlso: INT 2D/AL=06h
--------t-2D--04-----------------------------
INT 2D - AMIS v3.0+ - DETERMINE CHAINED INTERRUPTS
	AL = 04h
	AH = multiplex number for program
	BL = interrupt number (except 2Dh)
Return: AL = status
	    00h not implemented (makes TSR non-compliant with specification)
	    01h (obsolete) unable to determine
	    02h (obsolete) interrupt hooked
	    03h (obsolete) interrupt hooked, address returned
		DX:BX -> TSR's interrupt BL handler
	    04h list of hooked interrupts returned
		DX:BX -> interrupt hook list (see #2226)
	    FFh interrupt not hooked
Notes:	BL is ignored if the TSR returns AL=04h; in that case, the caller
	  needs to scan the return list rather than making additional calls
	  to this function.  If the return is not 00h or 04h, then the caller
	  must cycle through the remaining interrupt numbers it wishes to
	  check.
	return values 01h through 03h may not be used by AMIS v3.6-compliant
	  programs; they are included here solely for compatibility with
	  version 3.3, though they were probably never used in any
	  implementation
	for return values 01h through 03h, since INT 2D is known to be hooked,
	  the resident code need not test for BL=2Dh (to minimize its size),
	  and the return value is therefore undefined in that case.
	this function is not valid unless a program is installed on the
	  specified multiplex number; use INT 2D/AL=00h to check
SeeAlso: INT 2D/AL=00h,INT 2D/AL=01h,INT 2D/AL=02h,INT 2D/AL=03h,INT 2D/AL=05h
SeeAlso: INT 2D/AL=06h

Format of AMIS interrupt hook list [array]:
Offset	Size	Description	(Table 2226)
 00h	BYTE	interrupt number (last entry in array is 2Dh)
 01h	WORD	offset within hook list's segment of the interrupt handler
		this will point at the initial short jump of the interrupt
		  sharing protocol header (see #2223)
SeeAlso: #2227
--------t-2D--05-----------------------------
INT 2D - AMIS v3.5+ - GET HOTKEYS
	AL = 05h
	AH = multiplex number for program
Return: AL = status
	    00h not implemented
	    FFh supported
		DX:BX -> hotkey list (see #2227)
Notes:	this function is not valid unless a program is installed on the
	  specified multiplex number; use INT 2D/AL=00h to check
	programs which provide hotkeys are required to provide this function
	  to be fully compliant with this specification
SeeAlso: INT 2D/AL=00h,INT 2D/AL=01h,INT 2D/AL=02h,INT 2D/AL=03h,INT 2D/AL=04h
SeeAlso: INT 2D/AL=06h

Format of AMIS hotkey list:
Offset	Size	Description	(Table 2227)
 00h	BYTE	type of hotkey checking (see #2228)
 01h	BYTE	number of hotkeys (may be zero if TSR can disable hotkeys)
 02h 6N BYTEs	array of hotkey definitions
		(one per hotkey, first should be primary hotkey)
		Offset	Size	Description
		 00h	BYTE	hotkey scan code (00h/80h if shift states only)
				hotkey triggers on release if bit 7 set
		 01h	WORD	required shift states (see #2229)
		 03h	WORD	disallowed shift states (see #2229)
		 05h	BYTE	hotkey flags (see #2230)
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
SeeAlso: #0005

Bitfields for type of AMIS hotkey checking:
Bit(s)	Description	(Table 2228)
 0	checks before chaining INT 09
 1	checks after chaining INT 09
 2	checks before chaining INT 15/AH=4Fh
 3	checks after chaining INT 15/AH=4Fh
 4	checks on INT 16/AH=00h,01h,02h
 5	checks on INT 16/AH=10h,11h,12h
 6	checks on INT 16/AH=20h,21h,22h
 7	reserved (0)
SeeAlso: #2227

Bitfields for AMIS shift states:
Bit(s)	Description	(Table 2229)
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
SeeAlso: #2227,#2230

Bitfields for AMIS hotkey flags:
Bit(s)	Description	(Table 2230)
 0	hotkey chained before processing
 1	hotkey chained after processing
 2	others should pass through this hotkey so that it can be monitored
 3	hotkey will not activate if other keys pressed/released before hotkey
	  press is completed
 4	this key is remapped into some other key
 5	this key is conditionally chained (sometimes passed on, sometimes
	  swallowed)
 6-7	reserved (0)
SeeAlso: #2227,#2229
--------t-2D--06-----------------------------
INT 2D - AMIS v3.6 - GET DEVICE-DRIVER INFORMATION
	AL = 06h
	AH = multiplex number for program
Return: AL = number of device driver headers supplied by prog.
	AH = device-driver flags (see #2231)
	DX:BX -> first device driver header (see #1298)
Program: AMIS is the Alternate Multiplex Interrupt Specification promulgated
	  by Ralf Brown
Notes:	if AL=00h, AH,BX,DX are meaningless and may be destroyed
	this function is not valid unless a program is installed on the
	  specified multiplex number; use INT 2D/AL=00h to check
	programs which provide device drivers are required to support this
	  function to be considered fully compliant with v3.6+ of the
	  specification
SeeAlso: INT 2D/AL=00h,INT 2D/AL=01h,INT 2D/AL=02h,INT 2D/AL=03h,INT 2D/AL=04h
SeeAlso: INT 2D/AL=05h

Bitfields for AMIS device-driver information flags:
Bit(s)	Description	(Table 2231)
 0	program loaded from CONFIG.SYS, and thus can not be removed from memory
	(leave clear if unable to determine)
 1	device driver headers have not been linked into DOS device chain
 2	reentrant device driver(s)
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
	    ES:BX -> parameter block (see #2232)
	CF set on error
Program: dLite is a shareware TSR by Rainer Schuetze which transparently
	  expands compressed files when they are read
SeeAlso: AL=11h"dLite",AL=12h"dLite",INT 21/AX=FEDCh"PCMANAGE"

Format of dLite parameter block:
Offset	Size	Description	(Table 2232)
 00h	BYTE	TSR flags (see #2233)
 01h	WORD	maximum number of programs needing original filesize
 03h	WORD	current number of programs needing original filesize
 05h	WORD	maximum number of files that can be handled by dLite (should
		  be the same as FILES= in CONFIG.SYS)
 07h	WORD	offset (in the same segment as the parameter block) of the
		  table of programs needing the original filesize (8 bytes
		  each,	without path or extension, uppercase, and zero \
		  terminated if	shorter than 8 bytes)

Bitfields for dLite TSR flags:
Bit(s)	Description	(Table 2233)
 0	deny FCB access
 1	dLite sleeping rather than activated
 2	always indicate original filesize when reading directory entries,
	  rather than only for specified programs
 3-7	reserved
SeeAlso: #2232
--------V-2D--10-----------------------------
INT 2D - Burnout Plus v3.00 - GET STATE/CONTROL INFORMATION
	AL = 10h
	AH = AMIS multiplex number for Burnout Plus
Return: AL = 01h
	BX = Burnout Plus status (see #2234)
	CX = record of features loaded (see #2235)
	ES:DI -> Burnout Plus control structure (see #2236)
Program: Burnout Plus is a DOS screen saver from Cove Software
SeeAlso: INT 14/AX=AA01h,INT 2D"AMIS"
Index:	screen saver;Burnout Plus

Bitfields for Burnout Plus status:
Bit(s)	Description	(Table 2234)
 0	screen is blanked
 1	MS Windows is active (Burnout Plus deactivated)
 2-15	reserved

Bitfields for Burnout Plus features loaded/features enabled:
Bit(s)	Description	(Table 2235)
 0	mouse activity monitor
 1	passkey support
 2	password support
 3	continuous clear
 4	software blanking
 5	video activity monitor
 6	disk activity monitor
 7	activating keystroke suppression
SeeAlso: #2236

Format of Burnout Plus control structure:
Offset	Size	Description	(Table 2236)
 00h	BYTE	size of structure in bytes
 01h	WORD	Burnout Plus version
 03h	WORD	screen blanking reset count in clock ticks
 05h	WORD	current countdown value in clock ticks
 07h	BYTE	type of timeout specification
 08h	BYTE	instant-blank hotkey
 09h	WORD	extended status information (see #2237)
		the bits for password, passkey, and software blanking are
		  ignored and cannot be enabled or disabled externally
 0Bh	WORD	features enabled (see #2235)
Note:	all fields except the first two may be modified by external programs
	  to affect the operation of Burnout Plus
Index:	hotkeys;Burnout Plus

Bitfields for extended Burnout Plus status information:
Bit(s)	Description	(Table 2237)
 0	Burnout Plus disabled
 1	force screen to blank on next clock tick
 2	restore screen if currently blanked
 3-15	reserved
Note:	1 and 2 are automatically cleared by Burnout Plus after blanking
	  or restoring the screen
SeeAlso: #2236
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
--------U-2D--10-----------------------------
INT 2D - DTown Utilities v1.40+ - EXTENDED API INSTALLATION CHECK
	AL = 10h
Return: AL = FFh
	BL = extended API availability (00h no, 01h API is loaded)
SeeAlso: INT 2D/AL=11h"DTown",INT 2D/AL=20h,INT 2D/AL=50h
--------s-2D--10-----------------------------
INT 2D - CDTSR - GET INTERNAL VARIABLE TABLE
	AL = 10h
	AH = AMIS multiplex number for CDTSR
Return: CX:DX -> CDTSR internal variable structure (see #2238)
Program: CDTSR is a resident audio CD player by Colin Hill
SeeAlso: INT 2D/AL=11h"CDTSR",INT 2D/AL=12h"CDTSR",INT 2D/AL=13h"CDTSR"

Format of CDTSR internal variable structure:
Offset	Size	Description	(Table 2238)
 00h	BYTE	hotkey scan code (see #0005)
 01h	BYTE	hotkey shift states
 02h	BYTE	flag: repeat
 03h	BYTE	flag: custom repeat
 04h	BYTE	flag: background polling
 05h	DWORD	(read-only) internal timing variable
 09h	DWORD	current track play position, in frames
 0Dh	DWORD	current disk play position, in frames
 11h	BYTE	number of entries in track program
 12h	BYTE	index into track program currently playing (FFh if not playing)
 13h 100 BYTEs	track program (each byte contains one track number)
 77h	BYTE	saved cursor end scan line
 78h	BYTE	saved cursor start scan line
 79h	BYTE	currently playing track
 7Ah	BYTE	CD driver media-change flag
 7Bh	WORD	video base segment during last popup
 7Dh	WORD	video page offset during last popup
 7Fh	BYTE	currently-selected track
 80h	DWORD	begin of custom repeat, in frames
 84h	DWORD	end of custom repeat, in frames
 88h	WORD	track program index of top list item
--------K-2D--10-----------------------------
INT 2D - KEYBIT Lite v5+ - GET POINTER TO STATUS BYTE
	AL = 10h
	AH = AMIS multiplex number for KEYBIT Lite
Return: DX:BX -> status byte (see #2239)
Program: KEYBIT Lite is an enhanced Italian keyboard driver by Pino Navato.
SeeAlso: INT 2D"AMIS"

Bitfields for KEYBIT Lite status byte:
Bit(s)	Description	(Table 2239)
 7	KEYBIT Lite active
 6	E-mail support active
 5-0	reserved
Notes:	E-mail support is one of the original features of KEYBIT Lite.	It is
	  the automatic conversion of the 8-bits ASCII chars produced by some
	  keys available on Italian keyboards to couples of 7-bits chars.
	Message editors should always enable e-mail support, they should also
	  restore its original status before exiting.
	The user can change both status bits by hotkeys.
--------K-2D--10-----------------------------
INT 2D - ALTMENU - GET POINTER TO KEY CODE
	AL = 10h
	AH = AMIS multiplex number for signature 'Pino Nav' 'ALTMENU '
Return: DX:BX -> WORD key code to insert in keyboard buffer on Alt-key tap
Program: Pino Navato's freeware ALTMENU permits activating the menu bar of
	  any program by pressing the Alt key alone.
Notes:	The value in the key code word will be returned in AX by a call to
	  INT 16/AH=00h after the Alt key is pressed by itself
	ALTMENU may be disabled by setting the key code equal to 0000h
SeeAlso: INT 16/AH=00h,INT 2D"AMIS"
--------d-2D--11-----------------------------
INT 2D - dLite 1.0+ - CHECK FOR dPressed FILE AND GET ORIGINAL SIZE
	AL = 11h
	AH = AMIS multiplex number for dLite
	BX = file handle
Return: CF clear if successful
	    DX:AX = size of uncompressed file
	CF set on error (not dPressed file)
SeeAlso: AL=10h"dLite",AL=12h"dLite"
--------U-2D--11-----------------------------
INT 2D - DTown Utilities v1.40+ - UTILITY INSTALLATION CHECK
	AL = 11h
	BL = function
	    00h get number of installed utilities
		Return: BL = number of utilities
	    01h get installed utilities
		DX:DI -> buffer containing one byte for each utility
		Return: DX:DI buffer filled with flags (0=no,1=yes) indicating
			  whether the corresponding utility is loaded
Return: AL = FFh if supported
Note:	this function is only available if the extended API has been installed
	  in the resident portion
SeeAlso: INT 2D/AL=10h"DTown",INT 2D/AL=20h
--------s-2D--11-----------------------------
INT 2D - CDTSR - REPROGRAM CDTSR
	AL = 11h
	AH = AMIS multiplex number for CDTSR
Return: nothing
Program: CDTSR is a resident audio CD player by Colin Hill
Desc:	reprograms CDTSR based on the values in the internal variable
	  structure (see #2238), which may have been changed by an application
SeeAlso: INT 2D/AL=10h"CDTSR",INT 2D/AL=12h"CDTSR",INT 2D/AL=13h"CDTSR"
--------d-2D--12-----------------------------
INT 2D - dLite 1.0+ - CHECK FOR dPressed FILE AND GET COMPRESSED SIZE
	AL = 12h
	AH = AMIS multiplex number for dLite
	BX = file handle
Return: CF clear if successful
	    DX:AX = size of compressed file
	CF set on error (not dPressed file)
SeeAlso: AL=10h"dLite",AL=11h"dLite"
--------s-2D--12-----------------------------
INT 2D - CDTSR - DISABLE POPUP
	AL = 12h
	AH = AMIS multiplex number for CDTSR
Return: nothing
SeeAlso: INT 2D/AL=10h"CDTSR",INT 2D/AL=11h"CDTSR",INT 2D/AL=13h"CDTSR"
--------U-2D--12-----------------------------
INT 2D - FREEVER - GET ORIGINAL DOS VERSION INFO
	AL = 12h
	AH = AMIS multiplex number for FREEVER
Return: AL = FFh if successful
	    BH = major DOS version
	    BL = minor DOS version
	    CH = DOS version flag
	    CL = OEM number
	    DH = major DR DOS version number (FFh if unknown)
	    DL = minor DR DOS version number (FFh if unknown)
Program: FREEVER is an AMIS-conformant freeware DOS version-faking TSR similar
	  to SETVER for any DOS-compatible OS, written by Matthias Paul
SeeAlso: INT 2D/AL=13h"FREEVER",INT 2D/AL=14h"FREEVER",INT 2D/AL=17h"FREEVER"
--------s-2D--13-----------------------------
INT 2D - CDTSR - ENABLE POPUP
	AL = 13h
	AH = AMIS multiplex number for CDTSR
Return: nothing
Program: CDTSR is a resident audio CD player by Colin Hill
SeeAlso: INT 2D/AL=10h"CDTSR",INT 2D/AL=11h"CDTSR",INT 2D/AL=12h"CDTSR"
--------U-2D--13-----------------------------
INT 2D - FREEVER - SET VERSION NUMBERS
	AL = 13h
	AH = AMIS multiplex number for FREEVER
	BH = new major DOS version
	BL = new minor DOS version
	CH = new DOS version flag
	CL = new DOS revision number
	DH = new OEM number
SeeAlso: INT 2D/AL=12h"FREEVER",INT 2D/AL=15h"FREEVER",INT 2D/AL=17h"FREEVER"
--------U-2D--14-----------------------------
INT 2D - FREEVER - ENABLE TSR
	AL = 14h
	AH = AMIS multiplex number for FREEVER
Return: AL = FFh if successful
SeeAlso: INT 2D/AL=12h"FREEVER",INT 2D/AL=15h"FREEVER",INT 2D/AL=16h"FREEVER"
--------U-2D--15-----------------------------
INT 2D - FREEVER - DISABLE TSR
	AL = 15h
	AH = AMIS multiplex number for FREEVER
Return: AL = FFh if successful
SeeAlso: INT 2D/AL=12h"FREEVER",INT 2D/AL=14h"FREEVER",INT 2D/AL=16h"FREEVER"
--------U-2D--16-----------------------------
INT 2D - FREEVER - GET TSR STATUS
	AL = 16h
	AH = AMIS multiplex number for FREEVER
Return: AL = FFh if successful
	    BL = status
		01h resident and active
		02h resident and inactive
SeeAlso: INT 2D/AL=12h"FREEVER",INT 2D/AL=15h"FREEVER",INT 2D/AL=17h"FREEVER"
--------U-2D--17-----------------------------
INT 2D - FREEVER - GET TaskMAX STATUS AT INSTALLATION
	AL = 17h
	AH = AMIS multiplex number for FREEVER
Return: AL = FFh if successful
	    BL = status
		00h if TaskMAX not loaded before SETDRVER
		FFh if TaskMAX was loaded before SETDRVER
Program: FREEVER is an AMIS-conformant freeware DOS version-faking TSR similar
	  to SETVER for any DOS-compatible OS, written by Matthias Paul
SeeAlso: INT 2D/AL=12h"FREEVER",INT 2D/AL=14h"FREEVER",INT 2D/AL=16h"FREEVER"
--------U-2D--20-----------------------------
INT 2D - DTown Utilities v1.40+ - GET POP-UP HANDLER ADDRESS
	AL = 20h
Return: AL = FFh if available
	    DX:DI -> DTU popup-handler
Program: DTown Utilities is a freeware programmer's utility TSR by Jeroen van
	  Disseldorp
Note:	this function is only available if the extended API has been installed
	  in the resident portion
SeeAlso: INT 2D/AL=10h"DTown",INT 2D/AL=21h,INT 2D/AL=50h,INT 2D/AL=51h
SeeAlso: INT 03"DTown"
--------U-2D--21-----------------------------
INT 2D - DTown Utilities v1.40+ - POP UP
	AL = 21h
	BL = which utility to bring up
	    00h active utility
	    01h help screen
	    0Ah ASCII table
	    0Bh memory view
	    0Ch CPU status
	    0Dh calculator
	    0Eh miscellaneous
	    0Fh file viewer
	    10h disassembler
Return: AL = status
	    00h already active
	    FFh popped up successfully
	BX = 0000h
Note:	this function is only available if the extended API has been installed
	  in the resident portion
SeeAlso: INT 2D/AL=10h"DTown",INT 2D/AL=20h,INT 2D/AL=50h
--------U-2D--50-----------------------------
INT 2D - DTown Utilities v1.40+ - MEMORY VIEW SET ADDRESS
	AL = 50h
	CX:DX = new address for start of memory view utility's display
Note:	this function is only available if the extended API has been installed
	  in the resident portion
Return: AL = FFh if supported
SeeAlso: INT 2D/AL=10h"DTown",INT 2D/AL=20h,INT 2D/AL=21h,INT 2D/AL=51h
--------U-2D--51-----------------------------
INT 2D - DTown Utilities v1.40+ - MEMORY VIEW SET REFERENCE
	AL = 51h
	BL = reference ("bookmark") number
	CX:DX = new address for reference
Return: AL = status
	    00h invalid index
	    FFh reference set
Note:	this function is only available if the extended API has been installed
	  in the resident portion
Program: DTown Utilities is a shareware programmer's utility TSR by Jeroen van
	  Disseldorp
SeeAlso: INT 2D/AL=10h"DTown",INT 2D/AL=20h,INT 2D/AL=50h
--------b-2D--DC-----------------------------
INT 2D C - DAISY.SYS - BROADCAST: CHAIN RESCANNED
	AL = DCh
	AH = AMIS multiplex number for signature 'DAISYCHA' 'INDRIVER'
	DL = LPT Port Rescanned
Program: DAISY.SYS is a daisy chain manager for parallel port peripherals
	  conforming to the IEEE 1284.3 Committee's daisy chain specification.
Desc:	This Broadcast is sent whenever daisy chain IDs are reassigned to
	  warn parallel port device drivers that their daisy chain ID may
	  have been changed.
Note:	This function is a callout from DAISY.SYS, NOT a call into DAISY.SYS
SeeAlso: INT 17/AX=0200h"Enhanced Parallel Port",#0550,#2225
--------l-2E---------------------------------
INT 2E U - DOS 2+ - PASS COMMAND TO COMMAND INTERPRETER FOR EXECUTION
	DS:SI -> commandline to execute (see #2240)
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
Offset	Size	Description	(Table 2240)
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
	  experience multiplex number collisions, I have proposed an alternate
	  multiplex interrupt on INT 2D.  If you decide to use the alternate
	  multiplex, please let me know.
	DOS and some other programs return values in the flags register, so
	  any TSR which chains by calling the previous handler rather than
	  jumping to it should ensure that the returned flags are preserved
	  and passed back to the original caller
SeeAlso: INT 2D"ALTERNATE MULTIPLEX"
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
		Return: DX:AX -> vector table (see #2241)
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
Offset	Size	Description	(Table 2241)
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
		   point to author_name_ver table (see #2242)
	AH = FFh
Note:	this interface permits advanced communication with TSRs: it is possible
	  to make a generic uninstall utility, advanced TSR relocator programs
	  in order to fit fragmented memory areas, etc.
See also: INT 2D"AMIS",INT 2F"Compuscience"
Index:	installation check;CiriSOFT TSR interface
Index:	uninstall;CiriSOFT TSR interface

Format of CiriSOFT author_name_ver table:
Offset	Size	Description	(Table 2242)
 -16	WORD	segment of the start of the resident TSR code (CS in programs
		  with PSP, XMS upper memory segment if installed as UMB...)
 -14	WORD	offset of the start of the resident TSR code (frequently 100h
		  in *.COM programs and 0 in upper memory TSR's).
 -12	WORD	memory used by TSR (in paragraphs). Knowing the memory area
		  used by TSR is possible to determine if hooked vectors are
		  still pointing it (and if it is safe to uninstall).
 -10	BYTE	characteristics byte (see #2243)
 -9	BYTE	number of multiplex entry used (redefinition available). Note
		  that the TSR must use THIS variable in it's INT 2Fh handler.
 -8	WORD	offset to vector_area table (see #2244)
 -6	WORD	offset to extra_area table (see #2245,#2243 [bit 7])
 -4   4 BYTEs	signature string "*##*"
 00h	var	"AUTHOR:PROGRAM_NAME:VERSION",0	 (variable length, this area
		  is used in order to determine if the TSR is already resident
		  and it's version code; the ':' char is used as delimiter)

Bitfields for CiriSOFT characteristics byte:
Bit(s)	Description	(Table 2243)
 0-2	type
	000 normal program (with PSP)
	001 upper XMS memory block (needed HIMEM.SYS function to free memory
	      when uninstalling)
	010 device driver (*.SYS)
	011 device driver in EXE format
	1xx others (reserved)
 3-6	reserved
 7	set if extra_table defined and supported (see #2245)
SeeAlso: #2242

Format of CiriSOFT vector_area table:
Offset	Size	Description	(Table 2244)
 -1	BYTE	number of vectors intercepted by TSR
 00h	BYTE	first vector number
 01h	DWORD	first vector pointer before installing the TSR
 05h	BYTE	second vector number
 06h	DWORD	second vector pointer before installing the TSR
 0Ah	...	(and so on)
Note:	the TSR must use these variables to invoke the previous interrupt
	  handler routines
SeeAlso: #2242

Format of extra_area table (needed only to improve relocation feature):
Offset	Size	Description	(Table 2245)
 00h	WORD	offset to external_ctrl table (see #2246)
		0000h if not supported
 02h	WORD	reserved for future use (0)
SeeAlso: #2242

Format of CiriSOFT external_ctrl table:
Offset	Size	Description	(Table 2246)
 00h	BYTE	bit 0: TSR is relocatable (no absolute segment references)
 01h	WORD	offset to a variable which can activate/inhibit the TSR
 ---And if bit 0 in offset 00h is off:
 03h	DWORD	pointer to ASCIZ pathname for executable file which supports
		  /SR parameter (silent installation & inhibit)
 07h	DWORD	pointer to first variable to initialize on the copy reloaded
		  from the previous TSR still resident
 0Bh	DWORD	pointer to last variable (all variables packed in one block)
--------c-2F00-------------------------------
INT 2F U - DOS 2.x only PRINT.COM - SUBMIT FILE FOR PRINTING
	AH = 00h
	DS:DX -> opened FCB (see #1000 at INT 21/AX=0Fh)
Return: AH = number of files currently in print queue
	AL = status
	    00h file successfully added
	    01h queue is full
	ES:BX -> print queue (10 FCBs; first byte of FFh indicates unused)
	ES:DX -> currently-printing FCB (if DX=FFFFh, none printing)
Notes:	DOS 2.x PRINT.COM does not chain to previous INT 2F handler
	values in AH other than 00h or 01h cause PRINT to return the number of
	  files in the queue in AH
SeeAlso: AH=01h"PRINT",AX=0102h
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
INT 2F U - DOS 2.x only PRINT.COM - REMOVE FILE FROM PRINT QUEUE
	AH = 01h
	DS:DX -> FCB (see #1000 at INT 21/AH=0Fh) for file to be canceled
Return: AH = number of files currently in print queue
	AL = 00h (successful)
	ES:BX -> print queue (10 FCBs; first byte of FFh indicates unused)
	ES:DX -> currently-printing FCB (if DX=FFFFh, none printing)
Notes:	DOS 2.x PRINT.COM does not chain to previous INT 2F handler
	values in AH other than 00h or 01h cause PRINT to return the number of
	  files in the queue in AH
SeeAlso: AH=00h"PRINT.COM",AX=0103h
--------c-2F0100-----------------------------
INT 2F - DOS 3.0+ PRINT - INSTALLATION CHECK
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
INT 2F - DOS 3.0+ PRINT - SUBMIT FILE FOR PRINTING
	AX = 0101h
	DS:DX -> submit packet (see #2247)
Return: CF clear if successful
	    AL = status
		01h added to queue
		9Eh now printing
	CF set on error
	    AX = error code (see #2248,#1332 at INT 21/AH=59h/BX=0000h)
SeeAlso: AX=0102h

Format of PRINT submit packet:
Offset	Size	Description	(Table 2247)
 00h	BYTE	level (must be 00h)
 01h	DWORD	pointer to ASCIZ filename (no wildcards)

(Table 2248)
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
	DS:DX -> submit packet (see #2247)
	CL = print options
	    bit 4: use default options
Return: CF clear if successful
	    AL = status
		01h added to queue
		9Eh now printing
	CF set on error
	    AX = error code (see #2248)
Program: PrintCache PRINT.COM is a DOS PRINT replacement included in
	  LaserTools' PrintCache memory/disk-based print spooler package
Note:	if either SI or DI differs from the indicated magic values on entry,
	  PrintCache will use the default print options for the file for
	  compatibility with DOS PRINT
SeeAlso: AX=0100h/SI=20D6h,AX=0101h,AH=00h"PRINT",AX=0107h"PrintCache"
--------c-2F0102-----------------------------
INT 2F - DOS 3.0+ PRINT - REMOVE FILE FROM PRINT QUEUE
	AX = 0102h
	DS:DX -> ASCIZ filename (wildcards allowed)
Return: CF clear if successful
	CF set on error
	    AX = error code (see #2248)
SeeAlso: AX=0101h,AX=0103h,AH=01h"PRINT"
--------c-2F0103-----------------------------
INT 2F - DOS 3.0+ PRINT - CANCEL ALL FILES IN PRINT QUEUE
	AX = 0103h
Return: CF clear if successful
	CF set on error
	    AX = error code (see #2248)
SeeAlso: AX=0102h
--------c-2F0104-----------------------------
INT 2F - DOS 3.0+ PRINT - FREEZE PRINT QUEUE TO READ JOB STATUS
	AX = 0104h
Return: CF clear if successful
	    DX = error count since status last read
	    DS:SI -> print queue
	CF set on error
	    AX = error code (see #2248)
Desc:	get the list of print jobs, temporarily suspending PRINT's activities
	  to avoid changing the list while it is being examined
Notes:	the print queue is an array of 64-byte ASCIZ filenames terminated by
	  an empty filename; the first name is the file currently being printed
	printing is stopped until AX=0105h is called to prevent the queue
	  from changing while the filenames are being read
SeeAlso: AX=0101h,AX=0105h
--------c-2F0105-----------------------------
INT 2F - DOS 3.0+ PRINT - RESTART PRINT QUEUE AFTER STATUS READ
	AX = 0105h
Return: CF clear if successful
	CF set on error
	    AX = error code (see #2248)
Desc:	restart PRINT's activities once an application finishes examining the
	  print queue
SeeAlso: AX=0104h
--------c-2F0106-----------------------------
INT 2F - DOS 3.3+ PRINT - GET PRINTER DEVICE
	AX = 0106h
Return: CF set if files in print queue
	    AX = error code 0008h (queue full)
	    DS:SI -> device driver header (see #1298)
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
INT 2F U - DOS 3.0+ CRITICAL ERROR HANDLER - INSTALLATION CHECK
	AX = 0500h
Return: AL = 00h not installed, OK to install
	     01h not installed, can't install
	     FFh installed
Desc:	determine whether a critical error message override is installed
Note:	this set of functions allows a user program to partially or completely
	  override the default critical error handler's message in COMMAND.COM
SeeAlso: AH=05h,INT 24
--------l-2F05-------------------------------
INT 2F CU - DOS 3.0+ CRITICAL ERROR HANDLER - EXPAND ERROR INTO STRING
	AH = 05h
---DOS 3.x---
	AL = extended error code (not zero)
---DOS 4.0+ ---
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
	DR DOS's COMMAND.COM appends additional info ("0 files copied") to the
	  returned string
SeeAlso: AX=0500h,AX=122Eh,INT 24
--------U-2F0600-----------------------------
INT 2F - DOS 3.0+ ASSIGN - INSTALLATION CHECK
	AX = 0600h
Return: AL = status
	    00h not installed
	    01h not installed, but not OK to install
	    FFh installed
Notes:	ASSIGN is not a TSR in DR DOS 5.0; it is internally replaced by SUBST
	  (see INT 21/AH=52h)
	undocumented prior to the release of DOS 5.0
SeeAlso: AX=0601h,INT 21/AH=52h
--------U-2F0601-----------------------------
INT 2F U - DOS 3.0+ ASSIGN - GET DRIVE ASSIGNMENT TABLE
	AX = 0601h
Return: ES = segment of ASSIGN work area and assignment table
Note:	the 26 bytes starting at ES:0103h specify which drive each of A: to Z:
	  is mapped to.	 Initially set to 01h 02h 03h....
SeeAlso: AX=0600h,AX=AF14h"WinDOS"
--------D-2F0800-----------------------------
INT 2F U - DRIVER.SYS support - INSTALLATION CHECK
	AX = 0800h
Return: AL = status
	    00h not installed, OK to install
	    01h not installed, not OK to install
	    FFh installed
Desc:	determine whether the internal support code used by DRIVER.SYS is
	  present; it is always present in DOS 3.2+
Note:	supported by DR DOS 5.0 and Novell DOS 7
--------D-2F0801-----------------------------
INT 2F U - DRIVER.SYS support - ADD NEW BLOCK DEVICE
	AX = 0801h
	DS:DI -> drive data table (see #2255,#2256,#2257)
Return: AX,BX,SI,ES destroyed
Notes:	moves down internal list of drive data tables, copying and modifying
	  the drive description flags word for tables referencing same physical
	  drive
	the data table is appended to the chain of tables
	supported by DR DOS 5.0 and Novell DOS 7
SeeAlso: AX=0803h
--------D-2F0802-----------------------------
INT 2F U - DRIVER.SYS support - EXECUTE DEVICE DRIVER REQUEST
	AX = 0802h
	ES:BX -> device driver request header (see #2251)
Return: request header updated as per requested operation
	STACK:	WORD	original flags from INT call (left by RETF in device
			  driver, at least in DOS 5.0-6.22)
Notes:	supported by DR DOS 5.0
	DOS 3.2 executes this function on any AL value from 02h through F7h;
	  DOS 4.0+ executes this function on AL=02h and AL=04h-F7h
	the command codes (see #2249) and structures described below apply
	  to all drivers which support the appropriate commands; this call is
	  just one of a number of ways in which a device driver request may
	  be invoked
	supported by Novell DOS 7
SeeAlso: AX=0800h,AX=0801h,AX=0803h,AX=1510h,INT 21/AH=52h,INT 21/AH=99h
SeeAlso: INT 21/AH=9Ah

(Table 2249)
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
 0Dh	(DOS 3.0+) DEVICE OPEN
 0Eh	(DOS 3.0+) DEVICE CLOSE
 0Fh	(DOS 3.0+) REMOVABLE MEDIA (block devices)
 10h	(DOS 3.0+) OUTPUT UNTIL BUSY (character devices)
 11h	(European MS-DOS 4.0) STOP OUTPUT (console screen drivers only)
 12h	(European MS-DOS 4.0) RESTART OUTPUT (console screen drivers only)
 13h	(DOS 3.2+) GENERIC IOCTL
 14h	unused
 15h	(European MS-DOS 4.0) RESET UNCERTAIN MEDIA FLAG
 16h	unused
 17h	(DOS 3.2+) GET LOGICAL DEVICE
 18h	(DOS 3.2+) SET LOGICAL DEVICE
 19h	(DOS 5.0+) CHECK GENERIC IOCTL SUPPORT
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
Bit(s)	Description	(Table 2250)
 15	error
 14-11	reserved
 10	??? set by DOS kernel on entry to some driver calls
 9	busy
 8	done (may be clear on return under European MS-DOS 4.0)
 7-0	error code if bit 15 set (see #2252)

Format of device driver request header:
Offset	Size	Description	(Table 2251)
 00h	BYTE	length of request header
 01h	BYTE	subunit within device driver
 02h	BYTE	command code (see #2249)
 03h	WORD	status (filled in by device driver) (see #2250)
---DOS---
 05h  4 BYTEs	reserved (unused in DOS 2.x and 3.x)
 09h	DWORD	(European MS-DOS 4.0 only) pointer to next request header in
			  device's request queue
		(other versions) reserved (unused in DOS 2.x and 3.x)
---STARLITE architecture---
 05h	DWORD	pointer to next request header
 09h  4 BYTEs	reserved
---command code 00h---
 0Dh	BYTE	(ret) number of units
 0Eh	DWORD	(call) pointer to DOS device helper function (see #2253)
			  (European MS-DOS 4.0 only)
		(call) pointer past end of memory available to driver (DOS 5+)
		(ret) address of first free byte following driver
 12h	DWORD	(call) pointer to commandline arguments
		(ret) pointer to BPB array (block drivers) or
			  0000h:0000h (character drivers)
 16h	BYTE	(DOS 3.0+) drive number for first unit of block driver (0=A)
   ---European MS-DOS 4.0---
 17h	DWORD	pointer to function to save registers on stack
   ---DOS 5+ ---
 17h	WORD	(ret) error-message flag
		0001h MS-DOS should display error msg on init failure
---command code 01h---
 0Dh	BYTE	media descriptor
 0Eh	BYTE	(ret) media status
		00h don't know
		01h media has not changed
		FFh media has been changed
 0Fh	DWORD	(ret, DOS 3.0+) pointer to previous volume ID if the
		  OPEN/CLOSE/RM bit in device header is set and disk changed
---command code 02h---
 0Dh	BYTE	media descriptor
 0Eh	DWORD	transfer address
		-> scratch sector if NON-IBM FORMAT bit in device header set
		-> first FAT sector otherwise
 12h	DWORD	pointer to BPB (set by driver) (see #1315 at INT 21/AH=53h)
---command codes 03h,0Ch---
		  (see also INT 21/AX=4402h"DOS 2+",INT 21/AX=4403h"DOS")
 0Dh	BYTE	media descriptor (block devices only)
 0Eh	DWORD	transfer address
 12h	WORD	(call) number of bytes to read/write
		(ret) actual number of bytes read or written
---command codes 04h,08h,09h (except Compaq DOS 3.31, DR DOS 6)---
 0Dh	BYTE	media descriptor (block devices only)
 0Eh	DWORD	transfer address
 12h	WORD	byte count (character devices) or sector count (block devices)
 14h	WORD	starting sector number (block devices only)
 16h	DWORD	(DOS 3.0+) pointer to volume ID if error 0Fh returned
 1Ah	DWORD	(DOS 4.0+) 32-bit starting sector number (block devices with
		  device attribute word bit 1 set only) if starting sector
		  number above is FFFFh (see INT 21/AH=52h)
---command codes 04h,08h,09h (Compaq DOS 3.31, DR DOS 6)---
 0Dh	BYTE	media descriptor (block devices only)
 0Eh	DWORD	transfer address
 12h	WORD	byte count (character devices) or sector count (block devices)
 14h	DWORD	32-bit starting sector number (block devices only)
	Note:	to reliably determine which variant of the request block for
		  functions 04h,08h,09h has been passed to the driver, check
		  the length field as well as the word at offset 14h.  If the
		  length is 1Eh and 14h=FFFFh, use the DWORD at 1Ah as the
		  starting sector number; if the length is 18h, use the DWORD
		  at 14h; otherwise, use the WORD at 14h.
---command code 05h---
 0Dh	BYTE	byte read from device if BUSY bit clear on return
---command codes 06h,07h,0Ah,0Bh,0Dh,0Eh,0Fh---
 no further fields
---command code 10h---
 0Dh	BYTE	unused
 0Eh	DWORD	transfer address
 12h	WORD	(call) number of bytes to write
		(ret) actual number of bytes written
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
 11h	WORD	offset of device driver header (see #1298)
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
 0Dh	BYTE	addressing mode
		00h HSG (default)
		01h Phillips/Sony Red Book
 0Eh	DWORD	transfer address (ignored)
 12h	WORD	number of sectors to read (ignored)
 14h	DWORD	starting sector number (see also above)
---command code 84h---
 0Dh	BYTE	addressing mode
		00h HSG (default)
		01h Phillips/Sony Red Book
 0Eh	DWORD	starting sector number (see also above)
 12h	DWORD	number of sectors to play
---command codes 85h,88h---
 no further fields
---command codes 86h,87h---
 0Dh	BYTE	addressing mode
		00h HSG (default)
		01h Phillips/Sony Red Book
 0Eh	DWORD	transfer address (ignored in write mode 0)
 12h	WORD	number of sectors to write
 14h	DWORD	starting sector number (also see above)
 18h	BYTE	write mode
		00h mode 0 (write all zeros)
		01h mode 1 (default) (2048 bytes per sector)
		02h mode 2 form 1 (2048 bytes per sector)
		03h mode 2 form 2 (2336 bytes per sector)
 19h	BYTE	interleave size (number of sectors stored consecutively)
 1Ah	BYTE	interleave skip factor
		(number of sectors between consecutive portions)

(Table 2252)
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

(Table 2253)
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
		DS:BX -> character queue structure (see #2254)
		Note:	the queue size field must be set before calling
	    0Dh "QueueWrite" put a character in the queue
		DS:BX -> character queue (see #2254)
		AL = character to append to end of queue
		Return: ZF set if queue is full
			ZF clear if character stored
	    0Eh "QueueRead" get a character from the queue
		DS:BX -> character queue (see #2254)
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
Offset	Size	Description	(Table 2254)
 00h	WORD	size of queue in bytes
 02h	WORD	index of next character out
 04h	WORD	count of characters in the queue
 06h  N BYTEs	queue buffer
--------D-2F0803-----------------------------
INT 2F U - DOS 4.0+ DRIVER.SYS support - GET DRIVE DATA TABLE LIST
	AX = 0803h
Return: DS:DI -> first drive data table in list (see #2255,#2256,#2257)
Note:	not available under DR DOS 5.0, but supported by Novell DOS 7 (using
	  the MS-DOS 4+ data table format)
SeeAlso: AX=0801h

Format of DOS 3.30 drive data table:
Offset	Size	Description	(Table 2255)
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
 28h	BYTE	device type (see #1214 at INT 21/AX=440Dh"DOS 3.2+")
 29h	WORD	bit flags describing drive (see #2258)
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
SeeAlso: #2256,#2257

Format of COMPAQ DOS 3.31 drive data table:
Offset	Size	Description	(Table 2256)
 00h	DWORD	pointer to next table (offset FFFFh if last table)
 04h	BYTE	physical unit number (for INT 13)
 05h	BYTE	logical drive number (0=A:)
 06h 25 BYTEs	BIOS Parameter Block (see #2257)
 1Fh  6 BYTEs	reserved fields from BPB above???
 25h	BYTE	flags
		bit 6: 16-bit FAT instead of 12-bit FAT
		bit 5: large volume???
 26h	WORD	device-open count???
 28h 11 BYTEs	volume label or "NO NAME    " if none (always "NO NAME" for
		  fixed media)
 33h	BYTE	terminating null for volume label
 34h	BYTE	device type (see #1214 at INT 21/AX=440Dh"DOS 3.2+")
 35h	WORD	bit flags describing drive (see #2258)
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
SeeAlso: #2255,#2257

Format of DOS 4.0-7.0 drive data table:
Offset	Size	Description	(Table 2257)
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
		 08h	WORD	total sectors (refer to offset 15h if zero)
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
 22h	BYTE	device type (see #1214 at INT 21/AX=440Dh"DOS 3.2+")
 23h	WORD	bit flags describing drive (see #2258)
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
SeeAlso: #2255,#2256

Bitfields for flags describing drive:
Bit(s)	Description	(Table 2258)
 0	fixed media
 1	door lock ("changeline") supported
 2	current BPB locked
 3	all sectors in a track are the same size
 4	physical drive has multiple logical units
 5	current logical drive for shared physical drive
 6	disk change detected
 7	device parameters were changed (set DASD before formatting)
	(see #1213 at INT 21/AX=440Dh"DOS 3.2+")
 8	disk reformatted (BPB of current media was changed)
 9	access flag (fixed media only, disables reads and writes)
	(see #1219 at INT 21/AX=440Dh"DOS 3.2+")
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
INT 2F U - DR DOS 6.0 SHARE internal - SET ???
	AX = 1001h
	DX:BX -> ???function
Notes:	this function is also supported by SuperStor, a disk-compression
	  program by Addstor which is bundled with DR DOS 6.0, and the
	  Novell DOS 7 DELWATCH.EXE
	the default handler for the pointer set by this call under DELWATCH
	  simply returns with CF set
SeeAlso: AX=1000h,AX=F800h
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
--------O-2F10FE-----------------------------
INT 2F U - Novell DOS 7 DELWATCH.EXE - INSTALLATION CHECK
	AX = 10FEh
Return: AX = 20FFh if installed and active
	    DX:BX -> private entry point (see #2259)

(Table 2259)
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
INT 2F U - Multiplex - DR DOS 5.0 - ???
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
	CF clear if successful
	    CX = number of bytes read (0000h = end of file)
	    SFT updated
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1109h,AX=1229h,INT 21/AH=3Fh"DOS",INT 21/AX=5D06h
--------N-2F1109-----------------------------
INT 2F CU - NETWORK REDIRECTOR - WRITE TO REMOTE FILE
	AX = 1109h
	ES:DI -> SFT
	    SFT DPB field -> DPB of drive containing file
	CX = number of bytes
	SS = DOS DS
	SDA DTA field -> user buffer
Return: CF set on error
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	   AL = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
	STACK unchanged
Notes:	this function is called by the DOS 3.10-3.31 kernel
	the redirector is expected to resolve lock conflicts
SeeAlso: AX=110Bh,INT 21/AH=5Ch
--------N-2F110A-----------------------------
INT 2F CU - NETWORK REDIRECTOR (DOS 4.0+) - LOCK/UNLOCK REGION OF FILE
	AX = 110Ah
	BL = function
	    00h lock
	    01h unlock
	CX = number of lock/unlock parameters (0001h for DOS 4.0-6.1)
	DS:DX -> parameter block (see #2260)
	ES:DI -> SFT
	    SFT DPB field -> DPB of drive containing file
	SS = DOS DS
Return: CF set on error
	   AL = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
Notes:	this function is called by the DOS 4.0+ kernel
	the redirector is expected to resolve lock conflicts
SeeAlso: AX=110Bh,INT 21/AH=5Ch

Format of parameter block entry [array, but currently limited to single entry]:
Offset	Size	Description	(Table 2260)
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
	   AL = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
	STACK unchanged
Note:	this function is called by the DOS 3.1-3.31 kernel; DOS 4.0+ calls
	  AX=110Ah instead
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	STACK: WORD file access and sharing modes (see #1056 at INT 21/AH=3Dh)
Return: CF set on error
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
			low byte = file attributes (see #1055 at INT 21/AH=3Ch)
			high byte = 00h normal create, 01h create new file
Return: CF set on error
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	[DTA] = uninitialized 21-byte findfirst search data
	      (see #1278 at INT 21/AH=4Eh)
	SDA first filename pointer -> fully-qualified search template
	SDA search attribute = attribute mask for search
Return: CF set on error
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
	CF clear if successful
	    [DTA] = updated findfirst search data
		    (bit 7 of first byte must be set)
	    [DTA+15h] = standard directory entry for file (see #1007)
Notes:	this function is called by the DOS 3.1+ kernel
	DOS 4.x IFSFUNC returns CF set, AX=0003h
SeeAlso: AX=111Ah,AX=111Bh,INT 21/AH=1Ah
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
	[DTA] = uninitialized 21-byte findfirst search data
	      (see #1278 at INT 21/AH=4Eh)
	SDA first filename pointer -> fully-qualified search template
	SDA CDS pointer -> current directory structure for drive with file
	SDA search attribute = attribute mask for search
Return: CF set on error
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
	CF clear if successful
	    [DTA] = updated findfirst search data
		    (bit 7 of first byte must be set)
	    [DTA+15h] = standard directory entry for file (see #1007)
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1119h,AX=111Ch,INT 21/AH=1Ah,INT 21/AH=4Eh,INT 21/AH=60h
--------N-2F111C-----------------------------
INT 2F CU - NETWORK REDIRECTOR - FINDNEXT
	AX = 111Ch
	SS = DS = DOS DS
	ES:DI -> CDS
	ES:DI -> DTA (MSDOS v5.0)
	[DTA] = 21-byte findfirst search data
	      (see #1278 at INT 21/AH=4Eh)
Return: CF set on error
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
	CF clear if successful
	    [DTA] = updated findfirst search data
		    (bit 7 of first byte must be set)
	    [DTA+15h] = standard directory entry for file (see #1007)
Note:	this function is called by the DOS 3.1+ kernel
SeeAlso: AX=1119h,AX=111Bh,INT 21/AH=1Ah,INT 21/AH=4Fh
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
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AL = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
Notes:	called by MS-DOS 3.1+ kernel, but not called by DR DOS 5.0 unless the
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
Note:	this function is called by the DOS 3.1+ kernel if AX=1126h
	  returns CF set
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
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = 0001h (invalid function) (see #1332 at INT 21/AH=59h/BX=0000h)
--------N-2F1127BX4E57-----------------------
INT 2F - NetWare 4.0 - REMOTE FILE COPY
	AX = 1127h
	BX = 4E57h ('NW') (signature identifying this as a NetWare call)
	SI = source file handle
	DI = destination file handle
	DX:CX = number of bytes to copy, starting at current file position
Return: CF clear if successful
	CF set on error
	    AX = error code (05h,06h,0Bh,11h,3Bh) (see #1332)
	DX:CX = number of bytes successfully copied (file position updated)
Notes:	this is the only call which may be made directly to the NetWare
	  redirector from an application
	COMMAND.COM's COPY and DOS's XCOPY reportedly call INT 21/AX=1127h in
	  order to speed up copies between files on the same network server;
	  if error code 11h (not same device) is returned, the copy is
	  performed in the usual manner.  However, no such calls appear to
	  be present in MS-DOS 6.22.
--------N-2F1128-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - UNUSED
	AX = 1128h
Return: CF set
	    AX = 0001h (invalid function) (see #1332 at INT 21/AH=59h/BX=0000h)
--------N-2F1129-----------------------------
INT 2F CU - IFSFUNC.EXE (DOS 4.x only) - UNUSED
	AX = 1129h
Return: CF set
	    AX = 0001h (invalid function) (see #1332 at INT 21/AH=59h/BX=0000h)
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
	CF clear if successful
Note:	this function is called by the DOS 4.0 kernel
--------N-2F112C-----------------------------
INT 2F CU - NETWORK REDIRECTOR (DOS 4.0+) - "UPDATE_CB" - ???
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
INT 2F CU - NETWORK REDIRECTOR (DOS 4.0+) - EXTENDED OPEN/CREATE FILE
	AX = 112Eh
	SS = DS = DOS DS
	ES:DI -> uninitialized SFT for file
	STACK: WORD file attribute for created/truncated file
			low byte = file attributes
			high byte = 00h normal create/open, 01h create new file
	SDA first filename pointer -> fully-qualified filename
	SDA extended file open action = action code
	      (see #1424 at INT 21/AX=6C00h)
	SDA extended file open mode = open mode for file (see INT 21/AX=6C00h)
Return: CF set on error
	    AX = error code
	CF clear if successful
	    CX = result code
		01h file opened
		02h file created
		03h file replaced (truncated)
	    SFT initialized (except handle count, which DOS manages itself)
Note:	this function is called by the DOS 4.0+ kernel
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
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
SeeAlso: AX=1100h,AX=1181h,AX=118Eh
--------N-2F1181-----------------------------
INT 2F - LAN Manager Enhanced DOS Services - SET USER NAME???
	AX = 1181h
	???
Return: ???
SeeAlso: AX=1100h,AX=1180h
--------N-2F1182-----------------------------
INT 2F - LAN Manager Enhanced DOS Services - INSTALL SERVICE
	AX = 1182h
	???
Return: ???
SeeAlso: AX=1100h,AX=1180h
--------N-2F1184-----------------------------
INT 2F - LAN Manager Enhanced DOS - ???
	AX = 1184h
	???
Return: ???
--------N-2F1186-----------------------------
INT 2F - LAN Manager Enhanced DOS - DosReadAsynchNmPipe
	AX = 1186h
	DS:SI -> stack frame (see #2261)
Return: CF clear if successful
	CF set if error
	    AX = error code
Note:	LAN Manager enhance mode adds features beyond the standard redirector
	  file/printer services
SeeAlso: AX=118Fh,AX=1190h,AX=1191h,INT 21/AX=5F39h

Format of LAN Manager DosReadAsynchNmPipe stack frame:
Offset	Size	Description	(Table 2261)
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
	DS:SI -> stack frame (see #2262)
Return: CF clear if successful
	CF set if error
	    AX = error code
SeeAlso: AX=1186h,AX=1191h,INT 21/AX=5F3Ah

Format of LAN Manager DosReadAsynchNmPipe stack frame:
Offset	Size	Description	(Table 2262)
 00h	DWORD	-> number of bytes read
 04h	WORD	Size of buffer
 06h	DWORD	-> buffer
 0Ah	DWORD	-> return code
 0Eh	DWORD	function to call on completion as function( char far *buffer )
 12h	WORD	handle
--------N-2F1190-----------------------------
INT 2F - LAN Manager Enhanced DOS - DosReadAsynchNmPipe2
	AX = 1190h
	DS:SI -> stack frame (see #2263)
Return: CF clear if successful
	CF set if error
	    AX = error code
SeeAlso: AX=1186h,AX=1191h

Format of LAN Manager DosReadAsynchNmPipe2 stack frame:
Offset	Size	Description	(Table 2263)
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
	DS:SI -> stack frame (see #2264)
Return: CF clear if successful
	CF set if error
	    AX = error code
SeeAlso: AX=118Fh,AX=1190h,INT 21/AX=5F3Ah

Format of LAN Manager DosReadAsynchNmPipe2 stack frame:
Offset	Size	Description	(Table 2264)
 00h	DWORD	-> number of bytes read
 04h	WORD	size of buffer
 06h	DWORD	-> buffer
 0Ah	DWORD	-> return code
 0Eh	DWORD	function to call on completion as function( char far *buffer )
 12h	WORD	handle
 14h	DWORD	???
--------D-2F1200-----------------------------
INT 2F U - DOS 3.0+ internal - INSTALLATION CHECK
	AX = 1200h
Return: AL = FFh (for compatibility with other INT 2F functions)
--------D-2F1201-----------------------------
INT 2F U - DOS 3.0+ internal - CLOSE CURRENT FILE
	AX = 1201h
	SS = DOS DS (must be using a DOS internal stack)
	SDA current SFT pointer -> SFT of file to close
Return: CF set on error
	BX???
	CX new reference count of SFT
	ES:DI -> SFT for file
SeeAlso: AX=1106h,AX=1227h,INT 21/AH=3Eh
--------D-2F1202-----------------------------
INT 2F U - DOS 3.0+ internal - GET INTERRUPT ADDRESS
	AX = 1202h
	STACK: WORD vector number
Return: ES:BX -> interrupt vector (DWORD containing handler's address)
	STACK unchanged
--------D-2F1203-----------------------------
INT 2F U - DOS 3.0+ internal - GET DOS DATA SEGMENT
	AX = 1203h
Return: DS = data segment of IBMDOS.COM/MSDOS.SYS
Note:	for DOS prior to version 5.0, the data segment is the same as the code
	  segment
--------D-2F1204-----------------------------
INT 2F U - DOS 3.0+ internal - NORMALIZE PATH SEPARATOR
	AX = 1204h
	STACK: WORD character to normalize
Return: AL = normalized character (forward slash turned to backslash, all
		  others unchanged)
	ZF set if path separator
	STACK unchanged
--------D-2F1205-----------------------------
INT 2F U - DOS 3.0+ internal - OUTPUT CHARACTER TO STANDARD OUTPUT
	AX = 1205h
	STACK: WORD character to output
Return: STACK unchanged
Note:	can be called only from within DOS
--------D-2F1206-----------------------------
INT 2F U - DOS 3.0+ internal - INVOKE CRITICAL ERROR
	AX = 1206h
	DI = error code
	BP:SI -> device driver header (see #1298)
	SS = DOS DS (must be using a DOS internal stack)
	STACK: WORD value to be passed to INT 24 in AX
Return: AL = 0-3 for Abort, Retry, Ignore, Fail
	STACK unchanged
SeeAlso: INT 24
--------D-2F1207-----------------------------
INT 2F U - DOS 3.0+ internal - MAKE DISK BUFFER MOST-RECENTLY USED
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
INT 2F U - DOS 3.0+ internal - DECREMENT SFT REFERENCE COUNT
	AX = 1208h
	ES:DI -> SFT
Return: AX = original value of reference count
Notes:	if the reference count was 1, it is set to FFFFh (since 0 indicates
	  that the SFT is not in use).	It is the caller's responsibility to
	  set the reference count to zero after cleaning up.
	used by network redirectors such as MSCDEX
SeeAlso: AX=1106h
--------D-2F1209-----------------------------
INT 2F U - DOS 3.0+ internal - FLUSH AND FREE DISK BUFFER
	AX = 1209h
	DS:DI -> disk buffer
Return: disk buffer marked unused, contents written to disk if buffer dirty
Note:	can be called only from within DOS
SeeAlso: AX=120Eh,AX=1215h
--------D-2F120A-----------------------------
INT 2F U - DOS 3.0+ internal - PERFORM CRITICAL ERROR INTERRUPT
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
INT 2F U - DOS 3.0+ internal - SIGNAL SHARING VIOLATION TO USER
	AX = 120Bh
	ES:DI -> system file table entry for previous open of file
	STACK: WORD extended error code (should be 20h--sharing violation)
Return: CF clear if operation should be retried
	CF set if operation should not be retried
	    AX = error code (20h) (see #1332 at INT 21/AH=59h/BX=0000h)
	STACK unchanged
Notes:	can only be called during a DOS function call
	should only be called if an attempt was made to open an already-open
	  file contrary to the sharing rules
	invokes INT 24 if SFT file opened via FCB or in compatibility mode with
	  inheritance allowed
--------D-2F120C-----------------------------
INT 2F U - DOS 3.0+ internal - OPEN DEVICE AND SET SFT OWNER/MODE
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
INT 2F U - DOS 3.0+ internal - GET DATE AND TIME
	AX = 120Dh
	SS = DOS DS (must be using a DOS internal stack)
Return: AX = current date in packed format (see #1318 at INT 21/AX=5700h)
	DX = current time in packed format (see #1317 at INT 21/AX=5700h)
SeeAlso: INT 21/AH=2Ah,INT 21/AH=2Ch
--------D-2F120E-----------------------------
INT 2F U - DOS 3.0+ internal - MARK ALL DISK BUFFERS UNREFERENCED
	AX = 120Eh
	SS = DOS DS (must be using a DOS internal stack)
Return: DS:DI -> first disk buffer
Notes:	clears "referenced" flag on all disk buffers
	in DOS 5+, this has become essentially a NOP, invoking the same code
	  used by AX=1224h (SHARING DELAY)
SeeAlso: AX=1209h,AX=1210h,INT 21/AH=0Dh
--------D-2F120F-----------------------------
INT 2F U - DOS 3.0+ internal - MAKE BUFFER MOST RECENTLY USED
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
INT 2F U - DOS 3.0+ internal - FIND UNREFERENCED DISK BUFFER
	AX = 1210h
	DS:DI -> first disk buffer to check
Return: ZF clear if found
	    DS:DI -> first unreferenced disk buffer
	ZF set if not found
Note:	in DOS 5+, this has become essentially a NOP, invoking the same code
	  used by AX=1224h (SHARING DELAY)
SeeAlso: AX=120Eh
--------D-2F1211-----------------------------
INT 2F U - DOS 3.0+ internal - NORMALIZE ASCIZ FILENAME
	AX = 1211h
	DS:SI -> ASCIZ filename to normalize
	ES:DI -> buffer for normalized filename
Return: destination buffer filled with uppercase filename, with slashes turned
	to backslashes
SeeAlso: AX=121Eh,AX=1221h
--------D-2F1212-----------------------------
INT 2F U - DOS 3.0+ internal - GET LENGTH OF ASCIZ STRING
	AX = 1212h
	ES:DI -> ASCIZ string
Return: CX = length of string
SeeAlso: AX=1225h
--------D-2F1213-----------------------------
INT 2F U - DOS 3.0+ internal - UPPERCASE CHARACTER
	AX = 1213h
	STACK: WORD character to convert to uppercase
Return: AL = uppercase character
	STACK unchanged
--------D-2F1214-----------------------------
INT 2F U - DOS 3.0+ internal - COMPARE FAR POINTERS
	AX = 1214h
	DS:SI = first pointer
	ES:DI = second pointer
Return: ZF set if pointers are equal, ZF clear if not equal
	CF clear if pointers equal, CF set if not
--------D-2F1215-----------------------------
INT 2F U - DOS 3.0+ internal - FLUSH BUFFER
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
INT 2F U - DOS 3.0+ internal - GET ADDRESS OF SYSTEM FILE TABLE ENTRY
	AX = 1216h
	BX = system file table entry number
Return: CF clear if successful
	    ES:DI -> system file table entry
	    BX = relative entry number in system file table containing entry
	    AX destroyed
	CF set if BX greater than FILES=
Note:	supported by DR DOS 5+
SeeAlso: AX=1220h
--------D-2F1217-----------------------------
INT 2F U - DOS 3.0+ internal - GET CURRENT DIRECTORY STRUCTURE FOR DRIVE
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
INT 2F U - DOS 3.0+ internal - GET CALLER'S REGISTERS
	AX = 1218h
Return: DS:SI -> saved caller's AX,BX,CX,DX,SI,DI,BP,DS,ES (on stack)
Note:	only valid while within DOS
--------D-2F1219-----------------------------
INT 2F U - DOS 3.0+ internal - SET DRIVE???
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
INT 2F U - DOS 3.0+ internal - GET FILE'S DRIVE
	AX = 121Ah
	DS:SI -> filename
Return: AL = drive (0 = default, 1 = A:, etc, FFh = invalid)
	DS:SI -> filename without leading X: (if present)
SeeAlso: INT 21/AH=19h,INT 21/AH=60h
--------D-2F121B-----------------------------
INT 2F U - DOS 3.0+ internal - SET YEAR/LENGTH OF FEBRUARY
	AX = 121Bh
	CL = year - 1980
Return: AL = number of days in February
Note:	requires DS to be set to the DOS data segment
SeeAlso: INT 21/AH=2Bh"DATE"
--------D-2F121C-----------------------------
INT 2F U - DOS 3.0+ internal - CHECKSUM MEMORY
	AX = 121Ch
	DS:SI -> start of memory to checksum
	CX = number of bytes
	DX = initial checksum
	SS = DOS DS (must be using a DOS internal stack)
Return: AX, CX destroyed
	DX = checksum
	DS:SI -> first byte after checksummed range
Notes:	used by DOS to determine day count since 1/1/80 given a date
	supported by DR DOS 5.0+
SeeAlso: AX=121Dh
--------D-2F121D-----------------------------
INT 2F U - DOS 3.0+ internal - SUM MEMORY
	AX = 121Dh
	DS:SI -> memory to add up
	CX = 0000h
	DX = limit
Return: AL = byte which exceeded limit
	CX = number of bytes before limit exceeded
	DX = remainder after adding first CX bytes
	DS:SI -> byte beyond the one which exceeded the limit
Notes:	used by DOS to determine year or month given day count since 1/1/80
	supported by DR DOS 5.0+
SeeAlso: AX=121Ch
--------D-2F121E-----------------------------
INT 2F U - DOS 3.0+ internal - COMPARE FILENAMES
	AX = 121Eh
	DS:SI -> first ASCIZ filename
	ES:DI -> second ASCIZ filename
Return: ZF set if filenames equivalent, ZF clear if not
Note:	supported by DR DOS 5.0+
SeeAlso: AX=1211h,AX=1221h
--------D-2F121F-----------------------------
INT 2F U - DOS 3.0+ internal - BUILD CURRENT DIRECTORY STRUCTURE
	AX = 121Fh
	SS = DOS DS (must be using a DOS internal stack)
	STACK: WORD drive letter
Return: ES:DI -> current directory structure (will be overwritten by next call)
	STACK unchanged
--------D-2F1220-----------------------------
INT 2F U - DOS 3.0+ internal - GET JOB FILE TABLE ENTRY
	AX = 1220h
	BX = file handle
Return: CF set on error
	    AL = 6 (invalid file handle)
	CF clear if successful
	    ES:DI -> JFT entry for file handle in current process
Notes:	the byte pointed at by ES:DI contains the number of the SFT for the
	  file handle, or FFh if the handle is not open
	supported by DR DOS 5.0+
SeeAlso: AX=1216h,AX=1229h
--------D-2F1221-----------------------------
INT 2F U - DOS 3.0+ internal - CANONICALIZE FILE NAME
	AX = 1221h
	DS:SI -> file name to be fully qualified
	ES:DI -> 128-byte buffer for resulting canonical file name
	SS = DOS DS (must be using a DOS internal stack)
Return: (see INT 21/AH=60h)
Note:	identical to INT 21/AH=60h
SeeAlso: AX=1123h,INT 21/AH=60h
--------D-2F1222-----------------------------
INT 2F U - DOS 3.0+ internal - SET EXTENDED ERROR INFO
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
SeeAlso: AX=122Dh,INT 21/AH=59h/BX=0000h,INT 21/AX=5D0Ah
--------D-2F1223-----------------------------
INT 2F U - DOS 3.0+ internal - CHECK IF CHARACTER DEVICE
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
INT 2F U - DOS 3.0+ internal - SHARING RETRY DELAY
	AX = 1224h
	SS = DOS DS (must be using a DOS internal stack)
Return: after delay set by INT 21/AX=440Bh, unless in server call
	  (INT 21/AX=5D00h)
Note:	delay is dependent on the processor speed, and is skipped entirely if
	  inside a server call
SeeAlso: INT 21/AX=440Bh,INT 21/AH=52h,INT 62/AX=0097h
--------D-2F1225-----------------------------
INT 2F U - DOS 3.0+ internal - GET LENGTH OF ASCIZ STRING
	AX = 1225h
	DS:SI -> ASCIZ string
Return: CX = length of string
Note:	supported by DR DOS 5.0+
SeeAlso: AX=1212h
--------D-2F1226-----------------------------
INT 2F U - DOS 3.3+ internal - OPEN FILE
	AX = 1226h
	CL = access mode
	DS:DX -> ASCIZ filename
	SS = DOS DS (must be using a DOS internal stack)
Return: CF set on error
	    AL = error code (see #1332 at INT 21/AH=59h/BX=0000h)
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
Return: as for INT 21/AH=3Fh"DOS"
Notes:	equivalent to INT 21/AH=3Fh, but may only be called when already inside
	  a DOS function call
	used by NLSFUNC to access COUNTRY.SYS when invoked by the DOS kernel
SeeAlso: AX=1226h,INT 21/AH=3Fh"DOS"
--------D-2F122A-----------------------------
INT 2F U - DOS 3.3+ internal - SET FASTOPEN ENTRY POINT
	AX = 122Ah
	BX = entry point to set (0001h or 0002h)
	DS:SI -> FASTOPEN entry point (see #2265,#2266)
		(entry point not set if SI = FFFFh for DOS 4.0+)
Return: CF set if specified entry point already set
Notes:	entry point in BX is ignored under DOS 3.30
	both entry points set to same handler by DOS 4.01
	DOS 5.0 and 6.0 only set entry point 1

(Table 2265)
Values DOS 3.30+ FASTOPEN entry point is called with:
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
SeeAlso: #2266,#2267

(Table 2266)
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
SeeAlso: #2265,#2267

(Table 2267)
Values MS-DOS 5.0-6.0 FASTOPEN is additionally called with:
	AL = 04h  purge FASTOPEN cache
	    AH = 03h
	    ???
	AL = 05h ???
	    DL = drive (00h = A:)
	    ???
	AL = 06h ???
	    ???
SeeAlso: #2265,#2266
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
Note:	although this function exists in DR DOS 5.0 and Novell DOS 7, it
	  always returns 0000h:0000h prior to Novell DOS 7 Update 15
SeeAlso: INT 21/AH=52h
--------D-2F122D-----------------------------
INT 2F U - DOS 3.3+ internal - GET EXTENDED ERROR CODE
	AX = 122Dh
	SS = DOS DS
Return: AX = current extended error code
SeeAlso: AX=1222h,INT 21/AH=59h/BX=0000h
--------D-2F122E-----------------------------
INT 2F U - DOS 4.0+ internal - GET OR SET ERROR TABLE ADDRESSES
	AX = 122Eh
	DL = subfunction
	    00h get standard DOS error table (see #2268)
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
	    08h get error message retriever (see #2269)
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
SeeAlso: AX=0500h,INT 21/AH=59h/BX=0000h

Format of DOS 4.x error table:
Offset	Size	Description	(Table 2268)
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

(Table 2269)
Call error retrieval function with:
	AX = error number (see #2270)
	DI = offset of error table
Return: ES:DI -> error message (counted string)
Notes:	this function needs to access COMMAND.COM if the messages were not
	  loaded into memory permanently with /MSG; the caller should assume
	  that the returned message will be overwritten by the next call of
	  the function
	supported by DR DOS 5.0

(Table 2270)
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
Note:	not available under DR DOS 5.0 or 6.0
SeeAlso: INT 21/AH=30h,INT 21/AX=3306h
--------O-2F12FFBL00-------------------------
INT 2F - FreeDOS - FDAK-DDT - INSTALLATION CHECK / STATUS CHECK
	AX = 12FFh
	BL = 00h
Return: AL = DDh if installed
	    BH = state (00h disabled, nonzero enabled)
	    BL = readonly flag (00h writable, nonzero read-only)
Program: FDAK-DDT is the FreeDOS Alternative Kernel Device Drivers Testing
	  release by Yury A. Semenov
SeeAlso: AX=12FFh/BL=07h
--------O-2F12FFBL01-------------------------
INT 2F - FreeDOS - FDAK-DDT - ENABLE FDAK DRIVERS
	AX = 12FFh
	BL = 01h
SeeAlso: AX=12FFh/BL=00h,AX=12FFh/BL=02h
--------O-2F12FFBL02-------------------------
INT 2F - FreeDOS - FDAK-DDT - DISABLE FDAK DRIVERS
	AX = 12FFh
	BL = 02h
SeeAlso: AX=12FFh/BL=00h,AX=12FFh/BL=01h
--------O-2F12FFBL03-------------------------
INT 2F - FreeDOS - FDAK-DDT - SWITCH BLOCK DEVICE TO READ-ONLY
	AX = 12FFh
	BL = 03h
	???
SeeAlso: AX=12FFh/BL=00h,AX=12FFh/BL=04h
--------O-2F12FFBL04-------------------------
INT 2F - FreeDOS - FDAK-DDT - SWITCH BLOCK DEVICE TO READ-WRITE
	AX = 12FFh
	BL = 04h
	???
SeeAlso: AX=12FFh/BL=00h,AX=12FFh/BL=03h
--------O-2F12FFBL05-------------------------
INT 2F - FreeDOS - FDAK-DDT - TURN ACTIVITY INDICATOR ON
	AX = 12FFh
	BL = 05h
Note:	not yet implemented as of January 1996
SeeAlso: AX=12FFh/BL=00h,AX=12FFh/BL=06h
--------O-2F12FFBL06-------------------------
INT 2F - FreeDOS - FDAK-DDT - TURN ACTIVITY INDICATOR OFF
	AX = 12FFh
	BL = 06h
Note:	not yet implemented as of January 1996
SeeAlso: AX=12FFh/BL=00h,AX=12FFh/BL=05h
--------O-2F12FFBL07-------------------------
INT 2F - FreeDOS - FDAK-DDT - UNINSTALL
	AX = 12FFh
	BL = 07h
Return: ES = segment of FDAK memory block
Note:	the caller must free the memory block returned in ES
	  (via INT 21/AH=49h)
SeeAlso: AX=12FFh/BL=00h
--------m-2F12FFBX0006-----------------------
INT 2F U - DR DOS 6, Novell DOS 7 - EMM386.EXE - VIDEO MEMORY SPACE CONTROL
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
--------O-2F12FFBX0000-----------------------
INT 2F U - Novell DOS 7 - GET ???
	AX = 12FFh
	BX = 0000h
Return: AX = 0000h if supported
	DX = ??? (internal data)
SeeAlso: AX=12FFh/BX=0001h
--------O-2F12FFBX0001-----------------------
INT 2F U - Novell DOS 7 - SET ???
	AX = 12FFh
	BX = 0001h
	DX = new value for ???
Return: AX = 0000h if supported
SeeAlso: AX=12FFh/BX=0000h
--------O-2F12FFBX0002-----------------------
INT 2F U - Novell DOS 7 - GET ??? SIZE
	AX = 12FFh
	BX = 0002h
Return: AX = 0000h if supported
	DX = size of/required-for ??? in paragraphs
SeeAlso: AX=12FFh/BX=0003h
--------O-2F12FFBX0003-----------------------
INT 2F U - Novell DOS 7 - SET ???
	AX = 12FFh
	BX = 0003h
	DX = new value for ???
Return: AX = 0000h if supported
SeeAlso: AX=12FFh/BX=0002h
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
--------O-2F12FFBX0009-----------------------
INT 2F U - Novell DOS 7 - SET ???
	AX = 12FFh
	BX = 0009h
	DX = new value for ???
Return: ???
Note:	the DX value is stored at offset 66h in SYSVARS and offset 18h in
	  the Novell DOS 7 internal variable table
--------m-2F12FFBX0106-----------------------
INT 2F U - Novell DOS 7 - EMM386.EXE - GET VERSION???
	AX = 12FFh
	BX = 0106h
Return: CF clear if successful
	    AX = 0000h (successful)
	    BX = EDC0h (signature)
	    CL = memory manager variant (02h,03h)
		(02h when DPMI/VCPI disabled, 03h when DPMI/VCPI loaded)
	    CH = ??? (00h)
	    DX = version??? (0300h for v3.0)
	    ES = segment of EMM386 low-memory stub
Notes:	BL specifies which program handles the call, BH is the function number
	if the word at ES:0012h is nonzero, if contains the offset within
	  segment ES of the CEMM-compatible entry point (see #2271)
	if no other program has hooked INT 67, an alternate installation
	  check is to test for the string
	  "NOVELL EXPANDED MEMORY MANAGER 386" at offset 14h in the INT 67
	  handler's segment; the word immediately preceding this string
	  contains the offset of the API entry point if it is nonzero
Index:	entry point;Novell EMM386

(Table 2271)
Call Novell EMM386.EXE entry point with:
	AH = 00h get memory manager's status???
	    ???
	AH = 01h set memory manager's status???
	    ???
	AH = 02h Weitek coprocessor support???
	    AL = subfunction???
	more functions???
SeeAlso: #1166 at INT 21/AX=4402h/SF=02h,#3298 at INT 67/AX=FFA5h
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
	BX = 0EDCh ('EDC' = Novell European Development Center)
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
	supported by DR DOS 5.0
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
	DS:SI -> internal code page structure (see #2272)
	BX = new code page (see #1411 at INT 21/AX=6602h)
	DX = country code???
Return: AL = status
	     00h successful
	     else DOS error code
Note:	this function is called by the DOS v3.3+ kernel
SeeAlso: AX=1400h"NLSFUNC",AX=1402h"NLSFUNC",INT 21/AH=66h

Format of DOS 3.30 internal code page structure:
Offset	Size	Description	(Table 2272)
 00h  8 BYTEs	???
 08h 64 BYTEs	name of country information file
 48h	WORD	system code page (see #1411 at INT 21/AX=6602h)
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
	BX = code page (see #1411 at INT 21/AX=6602h)
	DX = country code (see #1054 at INT 21/AH=38h)
	DS:SI -> internal code page structure (see #2272)
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
	    AX = error code (see #2273)
SeeAlso: AX=1400h"POPUP",AX=1401h"POPUP",AX=1403h"POPUP"

(Table 2273)
Values for POPUP error code:
 0001h	process does not own screen
 0004h	unknown error
 0005h	invalid pointer
--------U-2F1403-----------------------------
INT 2F CU - NLSFUNC.COM - SET CODE PAGE
	AX = 1403h
	DS:SI -> internal code page structure (see #2272)
	BX = code page (see #1411 at INT 21/AX=6602h)
	DX = country code (see #1054 at INT 21/AH=38h)
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
	    AX = error code (see #2273)
SeeAlso: AX=1400h"POPUP",AX=1401h"POPUP",AX=1402h"POPUP"
--------U-2F1404-----------------------------
INT 2F CU - NLSFUNC.COM - GET COUNTRY INFO
	AX = 1404h
	BX = code page (see #1411 at INT 21/AX=6602h)
	DX = country code (see #1054 at INT 21/AH=38h)
	DS:SI -> internal code page structure (see #2272)
	ES:DI -> user buffer
Return: AL = status
	     ???
Notes:	this function is called by the DOS v3.3+ kernel on INT 21/AH=38h
	code page structure apparently only needed for COUNTRY.SYS pathname
SeeAlso: AX=1402h,AX=1403h,INT 21/AH=38h"GET"
--------U-2F14FE-----------------------------
INT 2F U - DR DOS 5.0 NLSFUNC - GET EXTENDED COUNTRY INFORMATION
	AX = 14FEh
	BX = code page (FFFFh=global code page) (see #1411 at INT 21/AX=6602h)
	DX = country ID (FFFFh=current country) (see #1054 at INT 21/AH=38h)
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
Notes:	DR DOS 5.0 NLSFUNC returns CF set and AX=0001h if AL was not 00h, FEh,
	  or FFh on entry.
	the DR DOS kernel calls this function on INT 21/AX=6501h
	the value in CL is not range-checked by the DR DOS 5.0 NLSFUNC
SeeAlso: #2274,AX=14FFh,INT 21/AH=65h

Format of DR DOS COUNTRY.SYS file:
Offset	Size	Description	(Table 2274)
 00h 126 BYTEs	copyright notice (terminated with Ctrl-Z, padded with NULs)
 7Eh	WORD	signature EDC1h
 80h	var	country pointer records
	Offset	Size	Description
	 00h	WORD	country code (0000h if end of array)
	 02h	WORD	code page (see #1411 at INT 21/AX=6602h)
	 04h	WORD	??? (0000h)
	 06h  7 WORDs	offsets in file for data tables for subfunctions
			  01h-07h
 var	var	country information
--------U-2F14FF-----------------------------
INT 2F U - DR DOS 5.0 NLSFUNC - PREPARE CODE PAGE
	AX = 14FFh
	BX = code page (see #1411 at INT 21/AX=6602h)
Return: AX = ???
	ZF set if AX=0000h
Notes:	DR DOS 5.0 NLSFUNC returns CF set and AX=0001h if AL was not 00h, FEh,
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
BUG:	this function may return an incorrect starting drive letter when
	  INTERLNK is installed
SeeAlso: AX=150Ch,AX=15FFh,INT 2F/AX=D000h"Lotus"
--------c-2F1500CH90-------------------------
INT 2F U - CDBLITZ v2.11 - INSTALLATION CHECK
	AX = 1500h
	CH = 90h (function number)
	BX = 1234h (magic value for CDBLITZ)
Return: CX = 1234h if installed
	    CF clear
	    DX = BCD version number (DH = major, DL = minor)
Program: CDBLITZ is a CD-ROM cache by Blitz 'n' Software, Inc.
SeeAlso: AX=1500h/CH=99h
--------c-2F1500CH91-------------------------
INT 2F U - CDBLITZ v2.11 - GET STATISTICS
	AX = 1500h
	CH = 91h (function number)
	BX = 1234h (magic value for CDBLITZ)
Return: CF clear
	ES:BX -> statistics record (see #2275)
SeeAlso: AX=1500h/CH=90h,AX=1500h/CH=97h

Format of CDBLITZ statistics record:
Offset	Size	Description	(Table 2275)
 00h	WORD	cache mode (see also AX=1500h/CH=94h)
		0001h 'min', 0002h 'max'
 02h	DWORD	number of read calls???
 06h	DWORD	total number of sectors read
 0Ah	DWORD	unused??? (zero)
 0Eh	DWORD	number of cache hit sectors
 12h	WORD	cache size in KB
 14h	WORD	unused??? (zero)
 16h	WORD	cache state (0000h disabled, 0001h enabled)
--------c-2F1500CH92-------------------------
INT 2F U - CDBLITZ v2.11 - ENABLE CACHE
	AX = 1500h
	CH = 92h (function number)
	BX = 1234h (magic value for CDBLITZ)
Return: CF clear
SeeAlso: AX=1500h/CH=90h,AX=1500h/CH=93h,AX=1500h/CH=94h
--------c-2F1500CH93-------------------------
INT 2F U - CDBLITZ v2.11 - DISABLE CACHE
	AX = 1500h
	CH = 93h (function number)
	BX = 1234h (magic value for CDBLITZ)
Return: CF clear
SeeAlso: AX=1500h/CH=90h,AX=1500h/CH=92h,AX=1500h/CH=95h
--------c-2F1500CH94-------------------------
INT 2F U - CDBLITZ v2.11 - SET 'MAX' MODE (CACHE BOTH DIRECTORIES AND DATA)
	AX = 1500h
	CH = 94h (function number)
	BX = 1234h (magic value for CDBLITZ)
Return: CF clear
SeeAlso: AX=1500h/CH=90h,AX=1500h/CH=92h,AX=1500h/CH=95h
--------c-2F1500CH95-------------------------
INT 2F U - CDBLITZ v2.11 - SET 'MIN' MODE (CACHE ONLY DIRECTORY ENTRIES)
	AX = 1500h
	CH = 95h (function number)
	BX = 1234h (magic value for CDBLITZ)
Return: CF clear
SeeAlso: AX=1500h/CH=90h,AX=1500h/CH=94h
--------c-2F1500CH96-------------------------
INT 2F U - CDBLITZ v2.11 - FLUSH CACHE
	AX = 1500h
	CH = 96h (function number)
	BX = 1234h (magic value for CDBLITZ)
Return: CF clear
Note:	this function resets the counts for number of sectors read and number
	  of cache hits, but no other values in the statistics record
	  (see #2275)
SeeAlso: AX=1500h/CH=90h
--------c-2F1500CH97-------------------------
INT 2F U - CDBLITZ v2.11 - GET CACHE STATISTICS
	AX = 1500h
	CH = 97h (function number)
	BX = 1234h (magic value for CDBLITZ)
Return: CF clear
	AL = cache mode (01h 'min', 02h 'max') (see also AX=1500h/CH=94h)
	AH = cache state (00h disabled, 01h enabled)
	BX = cache size in KB
	DX:CX = total number of reads
	DI:SI = number of cache hits
SeeAlso: AX=1500h/CH=90h,AX=1500h/CH=91h
--------c-2F1500CH99-------------------------
INT 2F U - CDBLITZ v2.11 - UNINSTALL
	AX = 1500h
	CH = 99h (function number)
	BX = 1234h (magic value for CDBLITZ)
Return: CF clear
	???
Program: CDBLITZ is a CD-ROM cache by Blitz 'n' Software, Inc.
SeeAlso: AX=1500h/CH=90h
--------d-2F1501-----------------------------
INT 2F - CD-ROM - GET DRIVE DEVICE LIST
	AX = 1501h
	ES:BX -> buffer to hold drive letter list (5 bytes per drive letter)
Return: buffer filled, for each drive letter
	  BYTE	subunit number in driver
	  DWORD address of device driver header (see #1298)
Note:	reportedly returns AX=0000h and an invalid address under Windows95
SeeAlso: AX=1510h
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
Note:	This function was not supported by Novell DOS 7 NWCDEX prior to the
	  08/16/94 update
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
	    AL = error code (0Fh invalid drive,15h not ready)
	CF clear if successful
Note:	reportedly returns error 15h (not ready) under Windows95
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
INT 2F - CD-ROM v2.00+ - GET MSCDEX.EXE VERSION (GET VERSION)
	AX = 150Ch
Return: BH = major version
	BL = minor version
Notes:	MSCDEX.EXE versions prior to 2.00 return BX=0000h
	Corel's CORELCDX.COM v1.01d returns 2.20, v1.12a returns 2.21
	Meridian Data's CDNETEX.EXE returns its own version number, e.g. 4.70
	Windows95 returns v2.95
SeeAlso: AX=1500h"CD-ROM"
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
	SI:DI -> buffer for directory entry (see #2276,#2277)
		 minimum 255 bytes for direct copy
Return: CF set on error
	    AX = error code
	CF clear if successful
	    AX = disk format (0=High Sierra,1=ISO 9660)
Note:	this function was not supported by Novell DOS 7 NWCDEX prior to the
	  08/16/94 update

Format of CD-ROM directory entry (direct copy):
Offset	Size	Description	(Table 2276)
 00h	BYTE	length of directory entry
 01h	BYTE	length of XAR in Logical Block Numbers
 02h	DWORD	LBN of data, Intel (little-endian) format
 06h	DWORD	LBN of data, Motorola (big-endian) format
 0Ah	DWORD	length of file, Intel format
 0Eh	DWORD	length of file, Motorola format
---High Sierra---
 12h  6 BYTEs	date and time
 18h	BYTE	bit flags
 19h	BYTE	reserved
---ISO 9660---
 12h  7 BYTEs	date and time
		(seventh byte is offset from GMT in 15-minute increments)
 19h	BYTE	bit flags
---both formats---
 1Ah	BYTE	interleave size
 1Bh	BYTE	interleave skip factor
 1Ch	WORD	volume set sequence number, Intel format
 1Eh	WORD	volume set sequence number, Motorola format
 20h	BYTE	length of file name
 21h  N BYTEs	file name
	BYTE	(optional) padding if filename is odd length
      N BYTEs	system data
SeeAlso: #2277,#1007

Format of CD-ROM directory entry (canonicalized):
Offset	Size	Description	(Table 2277)
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
SeeAlso: #2276
--------d-2F1510-----------------------------
INT 2F - CD-ROM v2.10+ - SEND DEVICE DRIVER REQUEST
	AX = 1510h
	CX = CD-ROM drive letter (0 = A, 1 = B, etc)
	ES:BX -> CD-ROM device driver request header (see #2251 at AX=0802h)
Note:	MSCDEX initializes the device driver request header's subunit field
	  based on the drive number specified in CX
BUG:	Novell DOS 7 NWCDEX prior to the 12/13/94 update did not initialize
	  the subunit field
SeeAlso: AX=0802h
--------d-2F15FFBX0000-----------------------
INT 2F - CD-ROM - CORELCDX - INSTALLATION CHECK
	AX = 15FFh
	BX = 0000h
Return: BX = ABCDh if CORELCDX loaded
Note:	Corel's CORELCDX.COM is a replacement for MSCDEX.EXE; it also supports
	  the standard MSCDEX installation check calls AX=1500h and AX=150Ch
SeeAlso: AX=1500h"CD-ROM",AX=150Ch
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
Notes:	this interface is supported in Windows 3.x and Windows95 only for 2.x
	  compatibility
	to get the current virtual machine (VM) ID in Windows/386 2.x:
	    AX = 0000h
	    ES:DI -> return address
	    JUMP to address returned from INT 2F/AX=1602h
	After JUMP, at return address:
	    BX = current VM ID.
SeeAlso: AX=C020h
--------W-2F1603-----------------------------
INT 2F C - MS Windows/386 - GET INSTANCE DATA
	AX = 1603h
Return: AX = 5248h ('RH') if supported
	    DS:SI -> Windows/386 instance data (see #2278)
Notes:	reportedly supported by RM Nimbus MS-DOS 3.3 kernel
	this function is called by DOSMGR when AX=1607h/BX=0015h is not
	  supported, as is the case in DOS versions prior to 5.0
	see Geoff Chappell's book _DOS_Internals_ for additional discussions of
	  this function, DOSMGR's behavior, and instancing in general
SeeAlso: AX=1607h/BX=0015h

Format of Windows/386 instance data:
Offset	Size	Description	(Table 2278)
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
	ES:BX -> startup info structure (see #2279)
	DS:SI -> virtual86 mode enable/disable callback or 0000h:0000h
	      (see #2282)
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
	Novell DOS v7.0 (Update 8 - Update 11) TASKMGR in multitasking mode
	  uses this broadcast, even if TASKMGR.INI sets WinPresent= to OFF
	Microsoft's EMM386.EXE for DOS 5+ when installed with the NOEMS option
	  changes its driver name from EMMQXXX0 to EMMXXXX0 while Windows is
	  active
SeeAlso: AX=1606h,AX=1608h,AX=4B05h

Format of Windows Startup Information Structure:
Offset	Size	Description	(Table 2279)
 00h  2 BYTEs	major, minor version of info structure
 02h	DWORD	pointer to next startup info structure or 0000h:0000h
 06h	DWORD	pointer to ASCIZ name of virtual device file or 0000h:0000h
 0Ah	DWORD	virtual device reference data (see #2281)
		(only used if above nonzero)
 0Eh	DWORD	pointer to instance data records (see #2280) or 0000h:0000h

Format of one Instance Item in array:
Offset	Size	Description	(Table 2280)
 00h	DWORD	address of instance data (end of array if 0000h:0000h)
 04h	WORD	size of instance data

Format of Virtual Device Reference Data:
Offset	Size	Description	(Table 2281)
 00h	DWORD	physical address of ??? or 00000000h
 04h	DWORD	physical address of ??? table
 08h	DWORD	"DEST_PAGE" address to which pages must be mapped
 0Ch  N DWORDs	"SRC_PAGE" physical addresses of the pages
		00000000h = end of table
Note:	EMM386.EXE sets the first pointer to the start of the device driver
	  chain, the second pointer to a field of 40h bytes followed by a
	  16-bit offset to the end of the SRC_PAGE table, and DEST_PAGE to
	  the start segment of the UMB area

(Table 2282)
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
	Novell DOS v7.0 (Update 8 - Update 15) TASKMGR in multitasking mode
	  uses this broadcast, even if TASKMGR.INI sets WinPresent= to OFF
SeeAlso: AX=1605h,AX=1609h
--------W-2F1607-----------------------------
INT 2F - MS Windows - VIRTUAL DEVICE CALL OUT API
	AX = 1607h
	BX = virtual device ID (see #2290)
	CX = (usually) callout subfunction
Return: (usually) AX,BX,CX,DX,ES contain results
Notes:	more of a convention than an API, this call specifies a standard
	  mechanism for Windows enhanced-mode virtual devices (VxD's) to talk
	  to DOS device drivers and TSRs
	see below for details on several virtual devices
SeeAlso: AX=1605h,AX=1607h/BX=000Ch,AX=1607h/BX=0014h,AX=1607h/BX=0015h
SeeAlso: AX=1607h/BX=0018h,AX=1684h"DEVICE API",AX=C020h
--------W-2F1607BX0006-----------------------
INT 2F - MS Windows - "V86MMGR" VIRTUAL DEVICE API
	AX = 1607h
	BX = 0006h (VxD identifier of "V86MMGR")
	CX = 0000h
Return: AX = status
	    0000h if local A20 state changed
	    1607h if A20 unchanged
	    other if global A20 state changed
SeeAlso: AX=1607h"CALL OUT API"
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
--------W-2F1607BX000D-----------------------
INT 2F C - MS Windows95 - "VKD" VIRTUAL DEVICE - ??? CALLOUT
	AX = 1607h
	BX = 000Dh (VxD ID for VKD)
	???
Return: ???
SeeAlso: AX=1607h"CALL OUT API",#2290
--------W-2F1607BX0010-----------------------
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
		command code (see #2283)
Note:	VNETBIOS (Virtual NetBIOS) calls this function to determine whether
	  the NetBIOS has an extensions Windows should know about
SeeAlso: AX=1607h/BX=000Ch,AX=1607h/BX=0010h,AX=1607h/BX=0015h

(Table 2283)
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
				ES:BX -> patch table (see #2285)
	    0001h set patches in DOS
		DX = bit mask of patch requests (see #2284)
		Return: AX = B97Ch
			BX = bit mask of patches applied (see #2284)
			DX = A2ABh
	    0002h remove patches in DOS (ignored by DOS 5.0 kernel)
		DX = bit mask of patch requests (see #2284)
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
SeeAlso: AX=1603h,AX=1605h,AX=1607h/BX=000Ch,AX=1607h/BX=0014h
SeeAlso: AX=1684h"DEVICE API"

Bitfields for DOSMGR patch requests:
Bit(s)	Description	(Table 2284)
 0	enable critical sections
 1	NOP setting/checking user ID
 2	turn INT 21/AH=3Fh on STDIN into polling loop
 3	trap stack fault in "SYSINIT" to WIN386
 4	BIOS patch to trap "Insert disk X:" to WIN386

Format of DOSMGR patch table:
Offset	Size	Description	(Table 2285)
 00h  2 BYTEs	DOS version (major, minor)
 02h	WORD	offset in DOS data segment of "SAVEDS"
 04h	WORD	offset in DOS data segment of "SAVEBX"
 06h	WORD	offset in DOS data segment of InDOS flag
 08h	WORD	offset in DOS data segment of User ID word
 0Ah	WORD	offset in DOS data segment of "CritPatch" table to enable
		  critical section calls (see INT 2A/AH=80h)
 0Ch	WORD	(DOS 5+ only) offset in DOS data segment of "UMB_HEAD",
		  containing segment of last MCB in conventional memory
--------W-2F1607BX0018-----------------------
INT 2F C - MS Windows - "VMPoll" VIRTUAL DEVICE - IDLE CALLOUT
	AX = 1607h
	BX = 0018h (VMPoll VxD ID) (see #2290)
	CX = 0000h
Return: AX = status
	    0000h if timeslice used
	    nonzero if timeslice not needed
Note:	when VMPoll makes this callout, all virtual machines are idle, and any
	  interested TSR can use the opportunity to perform background
	  processing
SeeAlso: AX=1607h"CALL OUT API",AX=1689h
--------W-2F1607BX0021--------------------------------------
INT 2F C - MS Windows - "PageFile" VIRTUAL DEVICE - GET LOCK BYTE
	AX = 1607h
	BX = 0021h (PageFile VxD ID)
	CX = 0000h
Return: AX = status
	    0000h success
		ES:DI -> cache lock byte in disk cacher
	    other no disk cache or unsupported
Notes:	PageFile issues this call on real-mode initialization in order to allow
	  disk caches to provide it with a byte which it can use to temporarily
	  lock the disk cache; VMPOLL also issues this call, so it is made
	  twice each time Windows starts up
	if this call fails, PageFile falls back to other techniques for locking
	  the disk cache
SeeAlso: AX=1607h"CALL OUT API"
--------W-2F1607BX002D-----------------------
INT 2F C - MS Windows - "W32S" VIRTUAL DEVICE - ??? CALLOUT
	AX = 1607h
	BX = 002Dh (VxD ID for W32S)
	???
Return: ???
SeeAlso: AX=1607h"CALL OUT API",#2290
--------W-2F1607BX0040-----------------------
INT 2F C - MS Windows - "IFSMgr" VIRTUAL DEVICE - ??? CALLOUT
	AX = 1607h
	BX = 0040h (VxD ID for IFSMgr)
	???
Return: ???
SeeAlso: AX=1607h"CALL OUT API",#2290
--------W-2F1607BX0446-----------------------
INT 2F C - MS Windows - "VADLIBD" VIRTUAL DEVICE - ??? CALLOUT
	AX = 1607h
	BX = 0446h (VxD ID for VADLIBD)
	???
Return: ???
SeeAlso: AX=1607h"CALL OUT API",#2290
--------W-2F1607BX0484-----------------------
INT 2F C - MS Windows - "IFSMgr" VIRTUAL DEVICE - ??? CALLOUT
	AX = 1607h
	BX = 0484h (VxD ID for IFSMgr)
	???
Return: ???
SeeAlso: AX=1607h"CALL OUT API",#2290
--------W-2F1607BX0487-----------------------
INT 2F C - MS Windows - "NWSUP" VIRTUAL DEVICE - ??? CALLOUT
	AX = 1607h
	BX = 0487h (VxD ID for NWSUP)
	???
Return: ???
SeeAlso: AX=1607h"CALL OUT API",#2290
--------E-2F1607BX22C0-----------------------
INT 2F C - Rational Systems DOS/4GW - ???
	AX = 1607h
	BX = 22C0h
	???
Return: ???
SeeAlso: INT 15/AX=BF02h,INT 15/AX=BF04h,#2290
--------W-2F1607BX28A1-----------------------
INT 2F C - MS Windows - "PharLap" VIRTUAL DEVICE - ??? CALLOUT
	AX = 1607h
	BX = 28A1h (VxD ID for PharLap)
	???
Return: ???
SeeAlso: AX=1607h"CALL OUT API",#2290
--------W-2F1607BX7A5F-----------------------
INT 2F C - MS Windows - "SIWVID" VIRTUAL DEVICE - ??? CALLOUT
	AX = 1607h
	BX = 7A5Fh (VxD ID for SIWVID)
	???
Return: ???
SeeAlso: AX=1607h"CALL OUT API",#2290
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
	ES:DI = 0000h:0000h
Return: ES:DI -> TSR information structure (see #2286)
Desc:	this call allows Windows-aware TSRs to make themselves known to
	  Windows.
Note:	the TSR should first chain to the previous INT 2F handler, then
	  allocate a communication structure, place the returned ES:DI
	  pointer in the first field, and return a pointer to the new
	  structure
SeeAlso: AX=1605h,AX=160Ch,AX=4B01h,AX=4B05h

Format of TSR-to-Windows information structure:
Offset	Size	Description	(Table 2286)
 00h	DWORD	pointer to next structure
 04h	WORD	PSP segment
 06h	WORD	API version ID (0100h)
 08h	WORD	EXEC flags (how to load command specified by "exec_cmd")
		bit 0: "WINEXEC"
		bit 1: "LOADLIBRARY"
		bit 2: "OPENDRIVER"
 0Ah	WORD	"exec_cmd_show" (see #2287)
 0Ch	DWORD	"exec_cmd" pointer to command line to be executed
 10h  4 BYTEs	reserved (0)
 14h	DWORD	pointer to TSR ID block (see #2288)
 18h	DWORD	pointer to TSR data block or 0000h:0000h

(Table 2287)
Values for TSR information structure "exec_cmd_show":
 00h	HIDE
 01h	SHOWNORMAL
 02h	SHOWMINIMIZED
 03h	SHOWMAXIMIZED
 04h	SHOWNOACTIVE
 05h	SHOW
 06h	MINIMIZE
 07h	SHOWMINNOACTIVE
 08h	SHOWNA
 09h	RESTORE
Note:	this value is passed as the second parameter to the WinExec(),
	  LoadLibrary(), or OpenDriver() call used to execute a requested
	  command line
SeeAlso: #2286 

Format of Norton Utilities 6.0 TSR ID block:
Offset	Size	Description	(Table 2288)
 00h	WORD	length of name string
 02h  N BYTEs	name of TSR's executable
SeeAlso: #2286
--------W-2F160C-----------------------------
INT 2F - MS Windows 3.1 - DETECT ROMs
	AX = 160Ch
	???
Return: ???
Note:	used by ROM Windows; appears to be a NOP under standard Windows95
SeeAlso: AX=160Bh,INT 21/AH=6Dh"ROM"
--------D-2F160E-----------------------------
INT 2F U - MS-DOS 7 kernel - BOOT LOGO SUPPORT???
	AX = 160Eh
	BL = subfunction
	    00h get ???
		AX = state of flag manipulated by subfn 04h and 05h
		    0000h clear
		    FFFFh set
		DX = ??? (0000h)
	    01h link in INT 10h??? handlers
	    02h unlink INT 10h??? handlers
	    03h ???
	    04h set ??? flag
	    05h clear ??? flag
Return: AX = 0000h if supported
	    ???
SeeAlso: AX=160Fh,AX=1611h,AX=1614h
--------D-2F160F-----------------------------
INT 2F U - MS-DOS 7 kernel - GET/SET ??? HANDLER
	AX = 160Fh
	BL = subfunction
	    00h get ??? handler
		Return: AX = 0000h if supported
			    CX:DX -> handler to which control is passed after
				      ??? executes
	    01h set ??? handler
		CX:DX -> new handler for ???
		Return: AX = 0000h if supported
Notes:	this function is not supported if ??? in the IO.SYS drivers portion of
	  the kernel is an IRET instruction (as is the case on my system)
	  rather than a FAR JMP
	the indicated handler seems to be related to INT 10 processing
SeeAlso: AX=160Eh,AX=1611h,AX=1614h
--------m-2F1610-----------------------------
INT 2F - XMS v1.x only - GET DRIVER ADDRESS
	AX = 1610h
	details unavailable
Note:	this function and AX=1600h were only used in XMS version 1 and are now
	  obsolete.  Use AX=4300h and AX=4310h instead
SeeAlso: AX=1600h,AX=4310h
--------D-2F1611-----------------------------
INT 2F U - MS-DOS 7 kernel - GET SHELL PARAMETERS
	AX = 1611h
Return: AX = 0000h if supported
	    DS:DX -> primary shell's executable name
	    DS:SI -> prinary shell command line (counted string)
	    BH = ??? (00h)
	    BL = ??? (00h)
Desc:	return the program name and commandline from the CONFIG.SYS SHELL=
	  statement
SeeAlso: AX=160Eh,AX=160Fh,AX=1612h,AX=4A33h
--------D-2F1612-----------------------------
INT 2F U - MS-DOS 7 kernel - GET ???
	AX = 1612h
Return: AX = 0000h if supported
	    ES:BX -> ??? data (see #2289)
Note:	called by VTD.VXD
SeeAlso: AX=160Fh,AX=1611h,AX=1613h

Format of DOS7 ??? kernel data:
Offset	Size	Description	(Table 2289)
 00h	WORD	??? (0001h)
 02h	DWORD	-> ??? function (call with DS=high word of this field)
		the indicated function vectors through the INT 13 hook at
		  0070h:00B4h and then forces the A20 gate open
	???
--------D-2F1613-----------------------------
INT 2F - MS-DOS 7 kernel - GET SYSTEM.DAT (REGISTRY FILE) PATHNAME
	AX = 1613h
	ES:DI -> buffer for full ASCIZ pathname to Windows95 SYSTEM.DAT
	CX = buffer size in bytes
Return: AX = 0000h if supported
	    ES:DI buffer filled
	    CX = number of bytes copied into buffer
SeeAlso: AX=160Eh,AX=1611h,AX=1612h,AX=1614h,AX=1690h
--------D-2F1614-----------------------------
INT 2F U - MS-DOS 7 kernel - SET SYSTEM.DAT (REGISTRY FILE) PATHNAME
	AX = 1614h
	ES:DI -> ASCIZ pathname to Windows95 SYSTEM.DAT
Return: AX = status
	    0000h if successful
	    1614h not supported
	    other: maximum length of pathname (004Eh for v4.00.950)
SeeAlso: AX=160Eh,AX=1611h,AX=1613h,AX=1690h
----------2F1615-----------------------------
INT 2F - Windows95 - SAVE32.COM - INSTALLATION CHECK
	AX = 1615h
Return: AX = 0000h if installed
	    BX = segment of resident code
Program: SAVE32.COM is a TSR included in the Windows95 distribution which
	  preserves the contents of 32-bit registers across invocations of
	  all of the hardware interrupt handlers (which, for some older BIOSes
	  and TSRs, do not properly preserve the high words of the 32-bit
	  registers)
--------W-2F1680-----------------------------
INT 2F - MS Windows, DPMI, various - RELEASE CURRENT VIRTUAL MACHINE TIME-SLICE
	AX = 1680h
Return: AL = status
	    00h if the call is supported
	    80h (unchanged) if the call is not supported
Notes:	programs can use this function in idle loops to enhance performance
	  under multitaskers; this call is supported by MS Windows 3+, DOS 5+,
	  DPMI 1.0+, and in OS/2 2.0+ for multitasking DOS applications
	does not block the program; it just gives up the remainder of the time
	  slice
	should not be used by Windows-specific programs
	when called very often without intermediate screen output under
	  MS Windows 3.x, the VM will go into an idle-state and will not
	  receive the next slice before 8 seconds have elapsed. This time can
	  be changed in SYSTEM.INI through "IdleVMWakeUpTime=<seconds>".
	  Setting it to zero results in a long wait.
	this function has no effect under OS/2 2.10-4.0 if the DOS box has an
	  "Idle Sensitivity" setting of 100
SeeAlso: AX=1689h,INT 15/AX=1000h,INT 15/AX=5305h,INT 21/AH=89h,INT 7A/BX=000Ah
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
SeeAlso: AX=1684h"DEVICE API",AX=1685h,AX=168Bh
--------W-2F1684-----------------------------
INT 2F - MS Windows - GET DEVICE API ENTRY POINT
	AX = 1684h
	BX = virtual device (VxD) ID (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point, or 0:0 if the VxD does not support an API
Note:	some Windows enhanced-mode virtual devices provide services that
	  applications can access.  For example, the Virtual Display Device
	  (VDD) provides an API used in turn by WINOLDAP.
SeeAlso: AX=1684h/BX=0001h,AX=1684h/BX=0015h,AX=1683h,AX=4011h,INT 20"Windows"

(Table 2290)
Values for MS Windows VxD ID:
Value	Name   CallOut V86 PM	Description
 0000h	ACT200L			IrDA Infrared ActiSys framer VxD
 0000h	ACT220L			IrDA Infrared ActiSys 220 framer VxD
 0000h	ADAPTEC			IrDA Infrared Adaptec framer VxD
 0000h	AM1500T		N  N	(Win95)
 0000h	ATI		N  N	(Win95) ATI display driver
 0000h	CDFS		N  N
 0000h	CDTSD		N  N	(Win95) CD-ROM Type-Specific Driver
 0000h	CE2NDIS3	N  N	(W4Wg)
 0000h	CENDIS		N  N	(W4Wg)
 0000h	CHIPS		N  N	(Win95) Chips&Tech display driver
 0000h	CIRRUS		N  N	(Win95) Cirrus display driver
 0000h	CTNDW		N  N	(W4Wg)
 0000h	CTVSD		N  N	(Win95) CD-ROM Vendor-Specific Driver
 0000h	CM2NDIS3	N  N	(W4Wg)
 0000h	COMBUFF		N  N	(Win95)
 0000h	COMPAQ		N  N	(Win95) Compaq display driver
 0000h	CPQNDIS3	N  N	(W4Wg)
 0000h	CRYSTAL			IrDA Infrared Crystal framer VxD
 0000h	DBKVSSD		N  N	(Win95) Databook PCMCIA socket services???
 0000h	DDOM95		N  N
 0000h	DECLAN		N  N	(W4Wg)
 0000h	DiskTSD		N  N	(Win95) hard-disk Type-Specific Driver
 0000h	DiskVSD		N  N	(Win95) hard-disk Vendor-Specific Driver
 0000h	DMICTVXD	N  N
 0000h	DRVSPACX	N  N	(Win95)
 0000h	E30N3		N  N	(W4Wg)
 0000h	E31N3		N  N	(W4Wg)
 0000h	EE16		N  N	(W4Wg)
 0000h	EISA		N  N	(Win95)
 0000h	EL59X		N  N	(Win95)
 0000h	ELNK16		N  N	(W4Wg)
 0000h	ELNK3		N  N	(Win95)
 0000h	ELNKII		N  N	(W4Wg)
 0000h	ELNKMC		N  N	(W4Wg)
 0000h	ELPC3		N  N	(W4Wg)
 0000h	ENABLE2		N  N	(Win95)
 0000h	ENABLE4		N  N	(Win95)
 0000h	EPRO		N  N	(Win95)
 0000h	ES1488V		N  N	(Win95)
 0000h	ES1688V		N  N	(Win95)
 0000h	ES488V		N  N	(Win95)
 0000h	ES688V		N  N	(Win95)
 0000h	ESI			IrDA Infrared ESI framer VxD
 0000h	FILEMON		N  N	DOS386 File Monitor
 0000h	FLS1MTD		N  N	(Win95) flash-memory driver???
 0000h	FLS2MTD		N  N	(Win95) flash-memory driver???
 0000h	HPEISA		N  N	(W4Wg)
 0000h	HPFEND		N  N	(W4Wg)
 0000h	HPISA		N  N	(W4Wg)
 0000h	HPMCA		N  N	(W4Wg)
 0000h	HSFLOP		N  N
 0000h	IBMTOK		N  N	(W4Wg)
 0000h	IBMTOK4		N  N	(Win95)
 0000h	IRCOMM			IrDA Infrared Virtual COM/LPT driver
 0000h	IRLAMPEX		IrDA Infrared Protocol VxD
 0000h	IRLAPFRM		IrDA Infrared Virtual COM/LPT frame driver
 0000h	IRMATRAK	N  N	(W4Wg)
 0000h	JAVASUP		N  N	Internet Explorer JAVA support
 0000h	KEYREMAP	N  N	(Windows95 PowerToys) shift-key remapper
 0000h	LPT	     N	N  N	(Win4Workgroups 3.11) DOS386 LPT Device
 0000h	LPTENUM		N  N
 0000h	MONVSD
 0000h	MGA		N  N	(Win95) Matrox MGA display driver
 0000h	MSMINI		N  N	(Win95)
 0000h	MSODISUP     N	N  N	(Win4Workgroups 3.11) MS ODI Support
 0000h	mvpas		N  N	(Win95) Pro Audio Spectrum driver
 0000h	NECATAPI	N  N	(Win95)
 0000h	NICE		N  N	(Win95)
 0000h	NWNBLINK     N	N  N	(Win4Workgroups 3.11) Netware NetBIOS
 0000h	OAK		N  N	(Win95) Oak Tech display driver
 0000h	OCTK32		N  N	(W4Wg)
 0000h	OTCETH		N  N	(W4Wg)
 0000h	PARALINK	N  N	(Win95)
 0000h	PARALLAX		IrDA Infrared Parallax framer VxD
 0000h	PCNTN3		N  N	(W4Wg)
 0000h	PE3NDIS		N  N	(W4Wg)
 0000h	PPM		N  N	(Win95)
 0000h	PROTEON		N  N	(W4Wg)
 0000h	QEMMFix		N  N
 0000h	QIC117		N  N	(Win95) QIC-117 floppy-ctrl tape drive
 0000h	QPI		N  N	QEMM Programming Interface (see INT 67/AH=3Fh)
 0000h	RMM		N  N	Real-Mode Mapper for hw with real-mode drivers
 0000h	S3		N  N	(Win95) S3 display driver
 0000h	S3INFO		N  N
 0000h	S3MINI		N  N	S3 display driver
 0000h	SAGE		N  N	(Plus!) System Agent
 0000h	scsi1hlp	N  N	(Win95)
 0000h	SERENUM		N  N
 0000h	SERIAL	     N	N  N	(Win4Workgroups 3.11) DOS386 Serial Device
 0000h	SERWAVE		N  N
 0000h	SETP3		N  N	(Win95) Silicon Ethernet Pocket Adapter
 0000h	SMC8000W	N  N	(W4Wg)
 0000h	SMC80PC		N  N	(W4Wg)
 0000h	SMC8100W	N  N	(W4Wg)
 0000h	SMC8232W	N  N	(W4Wg)
 0000h	SMC9000		N  N	(W4Wg)
 0000h	SNIP		N  N	(W4Wg)
 0000h	SOCKET		N  N	(W4Wg)
 0000h	SOCKETSV	N  N	(Win95)
 0000h	SPAP		Y  Y	(Win95)
 0000h	SPENDIS		N  N	(Win95)
 0000h	SRAMMTD		N  N	(Win95) flash-memory driver???
 0000h	STLTH64		N  N	Diamond Stealth64 driver
 0000h	STLTHMON	N  N
 0000h	T20N3		N  N	(W4Wg)
 0000h	T30N3		N  N	(W4Wg)
 0000h	TCTOK		N  N	(W4Wg)
 0000h	TSENG		N  N	(Win95) Tseng Labs display driver
 0000h	UBNEI		N  N	(W4Wg)
 0000h	UNIMODEM		(Win95) Universal Modem Driver
 0000h	VDEF		N  N	(Win95)
 0000h	VGATEWAY	N  Y	(Win95) dialin gateway
 0000h	VIDEO7		N  N	(Win95) Video7 display driver
 0000h	VRomD		N  N	(Win95)
 0000h	VStDspcD		Quarterdeck Stealth D*Space
 0000h	VXDMON
 0000h	WD		N  N	(Win95)
 0000h	WINTOP		N  N	(Windows95 Power Toys)
 0000h	WSHTCP		N  N
 0000h	XGA		N  N	(Win95) XGA display driver
 0001h	VMM		N  N	Virtual Machine Manager
 0001h	VMM		Y  Y	Windows95 Virtual Machine Manager
 0002h	Debug
 0003h	VPICD		Y  Y	Virtual Prog. Interrupt Controller (PIC) Device
 0004h	VDMAD		N  N	Virtual Direct Memory Access (DMA) Device
 0005h	VTD		Y  Y	Virtual Timer Device
 0006h	V86MMGR	     Y	N  N	(Windows3.x) Virtual 8086 Mode Device
 0006h	V86MMGR		N  Y	(Win95) Virtual 8068 Mode Device
 0007h	PageSwap	N  N	Paging Device
 0008h	Parity		N  N	Parity-check trapper
 0009h	Reboot		N  Y	Ctrl-Alt-Del handler
 000Ah	VDD		N  Y	Virtual Display Device (GRABBER)
 000Bh	VSD		N  N	Virtual Sound Device
 000Ch	VMD	     Y	Y  Y	Virtual Mouse Device
 000Dh	VKD		N  Y	Virtual Keyboard Device
 000Eh	VCD		N  Y	Virtual COMM Device
 000Fh	VPD		N  Y	Virtual Printer Device
 0010h	VHD			Virtual Hard Disk Device (Windows 3.0)
 0010h	BLOCKDEV     Y	N  N	Virtual Hard Disk Device (Windows 3.1)
 0010h	IOS	     N	N  N	(Win4Workgroups 3.11) DOS386 IOS Device
 0010h	IOS		Y  Y	Windows95 I/O Supervisor
 0011h	VMCPD		Y  Y	(Windows3.x) Virtual Math CoProcessor Device
 0011h	VMCPD		N  Y	(Win95) Virtual Math CoProcessor Device
 0012h	EBIOS		N  N	Reserve EBIOS page (e.g., on PS/2)
 0013h	BIOSXLAT	N  N	Map ROM BIOS API between prot & V86 mode
 0014h	VNETBIOS     Y	N  N	Virtual NetBIOS Device
 0015h	DOSMGR	     Y	Y  N	DOS data instancing (see #2304)
 0016h	WINLOAD
 0017h	SHELL		N  Y	(Windows3)
 0017h	SHELL		Y  Y	(Win95)
 0018h	VMPOLL	     Y	N  N
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
 0020h	Int13	     N	N  N
 0021h	PageFile     Y	N  Y	Paging File device
 0022h	SCSI
 0022h	APIX		N  Y	(Win95)
 0023h	MCA_POS			Microchannel Programmable Option Select
 0024h	SCSIFD			SCSI FastDisk device
 0025h	VPEND			Pen device
 0026h	APM			Advanced Power Management
 0026h	VPOWERD		Y  Y	(Win95) power management
 0027h	VXDLDR	     N	Y  Y	(Win4Wg 3.11/Win95) VXD Loader
 0028h	NDIS	     N	Y  Y	(Win4Wg 3.11) Network Driver Interface Spec
 0029h	???
 002Ah	VWIN32		N  Y	(Win95)
 002Bh	VCOMM	     N	Y  Y	(Win4Workgroups 3.11) DOS386 VCOMM Device
 002Ch	SPOOLER		N  N	Windows95 print spooler
 002Dh	W32S	     Y	N  Y	WIN32s 32-bit extension to Windows API
 002Eh	???
 002Fh	???
 0030h	MACH32	     N	N  Y	ATI Mach32 video card
 0031h	NETBEUI	     N	N  N	(Win4Workgroups 3.11) NETBEUI
 0032h	SERVER	     N	Y  Y	(Win4Workgroups 3.11) Int21 File Server
 0032h	VSERVER		N  Y	(Win95) Int21 File Server
 0033h	CONFIGMG	Y  Y	(Win95)
 0033h	EDOS		N  N	Windows DOS Box Enhancer by Mom's Software
 0034h	DWCFGMG.SYS	Y	DOS Plug-and-Play configuration manager
 0035h	SCSIPORT	N  N	(Win95) virtualized access to SCSI adapter
 0036h	VFBACKUP	Y  Y	(Win95)
 0037h	ENABLE		Y  Y	(Win95)
 0038h	VCOND		Y  Y	(Win95)
 0039h	???
 003Ah	VPMTD	     N	N  Y	(Win4Workgroups 3.11) IFAX Scheduler Device
 003Bh	DSVXD		Y  N	DoubleSpace VxD from MS-DOS v6.x
 003Ch	ISAPNP		N  N	(Win95)
 003Dh	BIOS		Y  Y	(Win95)
 003Eh	WSOCK		Y  Y	(Win95) WinSock
 003Fh	WSIPX		N  N	(Win95) IPX WinSock
 0040h	IFSMGR		N  N	(Win95)
 0041h	VCDFSD		N  N	(Win95) CD-ROM File System Driver (MSCDEX)
 0042h	MRCI2		N  N	(Win95) DriveSpace3
 0043h	PCI		N  N	(Win95)
 0048h	PERF		N  N	(Win95)
 0051h	ISAPNP		N  N	(Win95) ISA Plug-and-Play manager
 008Dh	ESDI_506	N  N	(Win95) MFM/RLL/ESDI disk driver
 0090h	voltrack	N  N	(Win95) Volume Tracker
 00FDh	FAKEIDE		N  N	(Chicago)
 0102h	CV1		N  N	Microsoft C/C++ 7.00+ CodeView for Windows
 011Fh	VFLATD		N  Y	(Win95)
 0200h	VIPX		Y  Y	NetWare Virtual IPX Driver
 0200h	VTEMPD			dummy template driver by Ray Patch
 0201h	VNWLSERV	N  N	NetWare Lite 1.1 Server (SERVER.EXE)
 0202h	WINICE		Y  Y	SoftICE/W
 0202h	SICE		Y  Y
 0203h	VCLIENT		N  Y	NetWare Lite 1.1+ Client
 0205h	VCAFT		N  N	Novell Virtual CAFT Driver (LANalyzer for Win)
 0205h	BCW		Y  Y	Nu-Mega Bounds Checker for Windows
 0206h	VTXRX		N  N	Novell Virtual TXRX Driver (LANalyzer for Win)
 0207h	DPMS	     N	Y  N	Novell DOS Protected Mode Services
 0234h	VCOMMUTE	Y  Y	PC Tools Commute
 0442h	VTDAPI		N  Y	MMSys Win386 VTAPI Device
 0443h	???
 0444h	VADMAD			Autoinitialize DMA (Windows 3.0)
 0445h	VSBD		Y  Y	WinResKit: Sound Blaster Device
 0446h	VADLIBD	     Y	Y  Y	MMSys Win386 AdLib Device (v3.x)
 0447h	???
 0448h	SETULTRA		Gravis UltraSound setup
 0449h	vjoyd		N  Y	(Win95) joystick
 044Ah	mmdevldr	Y  Y	(Win95)
 044Bh	???
 044Ch	msmpu401	N  N	(Win95) MPU-401 MIDI driver
 044Dh	msopl		N  N	(Win95) OPL-3 (SoundBlaster FM) driver
 044Eh	mssblst		N  N	(Win95) SoundBlaster MIDI driver
 045Dh	VflatD		N  Y	dva.386, part of WIN32s
 045Eh	???
 045Fh	mssndsys		Microsoft Sound System audio driver
 045Fh	azt16		Y  Y	Aztech Sound Galaxy 16 audio driver
 0460h	UNIMODEM	N  Y	Universal Modem driver
 0480h	VNetSup	     N	Y  Y	(Win4Workgrps 3.11) Virtual Network Support
 0481h	VRedir	     N	N  N	(Win4Workgroups 3.11) Redirector File System
 0481h	VREDIR		N  N	(Win95) Redirector File System driver
 0482h	VBrowse		Y  Y	Win386 Virtual Browser
 0482h	SNAPVXD		Y  Y	(Win95)
 0483h	VSHARE		N  N	(Win4Workgroups) Virtual SHARE
 0483h	VSHARE		Y  Y	(Win95) Virtual SHARE
 0484h	IFSMgr	     Y	N  Y	(Win4Wg 3.11) Installable File System Manager
 0485h	???			???
 0486h	VFAT	     N	Y  Y	(Win4Workgroups 3.11) Win386 HPFS Driver
 0487h	NWLINK		Y  Y	Win386 Virtual Packet Exchange Protocol
 0487h	NWSUP	     Y	N  N	NetWare Vnetbios shim
 0488h	VTDI		N  N	(Win95)
 0489h	VIP		Y  N	(Win95)
 048Ah	VTCP		Y
 048Ah	MSTCP		Y  N	(Win95) TCP stack
 048Bh	VCache	     N	Y  Y	(Win4Workgroups 3.11) Virtual File Cache
 048Bh	VCACHE		Y  Y	(Win95) disk cache
 048Ch	???			???
 048Dh	RASMAC		Y  Y	enhanced mode Win4Workgroups RASMAC device
 048Eh	NWREDIR		Y  Y	(Win95)
 048Fh	???			???
 0490h	???			???
 0491h	FILESEC			(Win95) File Access Control Manager
 0492h	NWSERVER		(Win95)
 0493h	SECPROV			(Win95) Security Provider
 0494h	NSCL		Y  Y	(Win95)
 0495h	AFVXD		N  N	(Win95)
 0496h	NDIS2SUP		(W4Wg???)
 0497h	MSODISUP	N  N	(W4Wg???)
 0498h	Splitter	N  N	(Win95)
 0499h	PPPMAC		Y  Y	(Win95)
 049Ah	VDHCP		Y  Y	(Win95)
 049Bh	VNBT		Y  Y	(Win95) NetBIOS-over-TCP/IP driver
 049Ch	???
 049Dh	LOGGER			(Win95)
 04A2h	IRLAMP			IrDA Infrared Enumerator VxD
 097Ch	PCCARD		N  Y	(Win95)
 1020h	VCV			Microsoft C/C++ 7.00 CodeView
 1021h	VMB		Y  Y	Microsoft C/C++ 7.00 WXSRVR
 1022h	Vpfd		Y  Y	Microsoft C/C++ 7.00
 1025h	MMD		Y  Y	Microsoft C/C++ 8.00, Visual C/C++ 1.00
 2020h	PIPE		Y  Y	by Thomas W. Olson, in Windows/DOS DevJrn 5/92
 21EAh	VADLIBWD	N  Y	Adlib Waveform Driver by John Ridges
 2200h	VFINTD		Y  Y	Norton VFINTD (Norton Desktop)
 22C0h	???	     Y		Rational Systems DOS/4GW ???
 2402h	ZMAX		N  N	Qualitas 386MAX v7 DOSMAX handler
 24A0h	VNSS		N  Y	Norton Screen Saver (Norton Desktop)
 24A1h	VNDWD		Y  Y	Norton VNDWD Device (Norton Desktop)
 24A2h	SYMEvent	Y  Y	Norton Utilities v8
 2540h	VILD		Y  N	INTERLNK client from MS-DOS v6.x
 2640h	VASBID		N  Y	WinResKit: Artisoft Sounding Board Device
 2860h	COMMTASK     N	N  Y	Windows 386-mode preemptive tasker by James
				  A. Kenemuth of Interabang Computing
 28A0h	PHARLAPX	Y	PharLap inter-VM communications DLL
 28A1h	PharLap	     Y	Y  Y	PharLap 386|DOS-Extender DOSXNT.386
 28C0h	VXD	     N	Y  Y	Generic VxD for real and protected mode by
				  Andrew Schulman in MSJ February 1993
 28C1h	PUSHKEYS		VKD_Force_Keys device
 28C2h	VCR3D			Virtual CR3, by A.Schulman in MSJ October 1992
 2925h	EDOS		Y  Y	Enhanced DOS by Firefly Software
 292Dh	VSBPD		Y  Y	Sound Blaster Pro
 295Ah	GRVSULTR	Y  Y	Gravis UltraSound / UltraSound ACE
 304Ch	DWCFGMG.SYS	Y	Plug-and-Play configuration access
 3098h	VstlthD	     N	N  N	for QEMM Stealth ROM mode
 3099h	VVidramD	Y  N	for QEMM VIDRAM support
 30F6h	WSVV		N  Y	(Win95) WinSock for Voice-View Modems???
 310Eh	WPS		N  Y	MS DevNet CD-ROM: Windows Process Status
 3110h	VGSSD		Y  Y	VSGLX16.386 for Aztech Sound Galaxy 16
 313Bh	PMC			Power Management Coordinator
 318Ah	LMOUSE		Y  Y	(Win95) Logitech mouse???
 31CFh	STAT.386		Ton Plooy's processor statistics VxD
 3202h	VdspD		N  N	(Win95)
 3203h	vpasd		N  N	(Win95) Pro Audio Spectrum driver
 32A4h	SBAWE		Y  Y	(Win95) SoundBlaster AWE driver
 32A5h	VSB16		N  N	(Win95) SoundBlaster 16 driver
 32CBh	VFRAD		Y  Y	Dr.Franz - Simultan's diagnotics VFRAD.386
 33AAh	DECCORE		Y  Y	(Win95) DEC Pathworks core VxD
 33B4h	DECLICL		N  N	(Win95)
 33F0h	VIWD		Y  Y	Gravis UltraSound Plug-n-Play Interwave v1.x
 33FCh	ASPIENUM	N  N	(Win95)
 34DCh	MAGNARAM	N  Y	Quarterdeck MagnaRAM (MAGNA31.VXD/MAGNA95.VXD)
 357Eh	DSOUND		Y  Y	(Win95) DirectSound
 36AEh	AIB-PC.386	Y  Y	Sunset Laboratory interface hardware driver
 377Bh	MX1501HAD		Cherry keyboard chipcard reader
 38DAh	VIWD		Y  Y	UltraSond PnP InterWave driver v2.0beta
 4321h	POSTMSG		Y  Y	(see #2360)
 4321h	VPCD		N  N	PCache
 4321h	avvxp500	N  N	(Win95) VxP500 driver
 6001h	REGVXD		Y  Y	Windows95 Registry Monitor helper
 7A5Fh	SIWVID	     Y	Y  Y	Soft-ICE for Windows video driver
 7FE0h	VSWITCHD	Y  N	by Jeff Prosise
 7FE0h	VWFD	     N	Y  Y	reports windowed/fullscreen state; by Neil
				  Sandlin of Microsoft, shipped with ANSIPLUS
 7FE1h	VWATCHD	     N	Y  Y	basic driver w/ no functionality except tracing
				  by Keith Jin of Microsoft PSS
 7FE5h	VFINTD	     N	Y  Y	Virtual Floppy Interrupt trapper by Neil
				  Sandlin of Microsoft
 7FE7h	VMPAGES	     N	Y  Y	demonstration of exporting VxD services, by
				  Neil Sandlin of Microsoft
 7FE8h	VPOSTD		Y  Y	PostMessage() demo by Curtis J. Palmer of MS
 7FE9h	VIdleD	     N	N  N	demonstration of Call_When_Idle function, by
				  Bernie McIlroy of Microsoft
 7FEBh	VMIOD	     N	N  N	Virtual Monitor I/O Traffic Device, by Neil
				  Sandlin of Microsoft
 7FEDh	VMIRQD	     N	N  N	Virtual Monitor IRQ Traffic Device, by Neil
				  Sandlin of Microsoft
 8888h	VbillD			Bill Potvin II's for reversing Compaq LTE video
 EEEEh	VEPSD		N  N	Virtual Extended Paging Services for
				  Borland C++ v4.0
Notes:	The high bit of the VxD ID is reserved for future use. Originally,
	  the next 10 bits were the OEM number which was assigned by Microsoft,
	  and the low 5 bits were the device number.  Currently, Microsoft
	  assigns VxD IDs individually for each driver; send blank email to
	  vxdid@microsoft.com for more information.
	"CallOut"=Y indicates that the VxD uses the INT 2F/AX=1607h/BX=VxDID
	  device callout interface; "PM" and "V86" indicate whether the VxD
	  provides an API entry point in protected mode and Virtual-86 mode
	  (e.g. DOS boxes)
--------W-2F1684BX0001-----------------------
INT 2F - MS Windows95 - VMM - GET API ENTRY POINT
	AX = 1684h
	BX = 0001h (virtual device ID for VMM) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2291)
		  0000h:0000h if the VxD does not support an API
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2291)
Call Windows VMM 16-bit entry point with:
	AX = function number
	    ---registry functions---
	    0100h "RegOpenKey"
		STACK:	DWORD	-> DWORD for returned key handle
			DWORD	-> ASCIZ registry key name
			DWORD	HKEY (see #2292)
	    0101h "RegCreateKey"
		STACK:	DWORD	-> DWORD for returned key handle
			DWORD	-> ASCIZ registry key name
			DWORD	HKEY (see #2292)
	    0102h "RegCloseKey"
		STACK:	DWORD	key handle from RegOpenKey or RegCreateKey
	    0103h "RegDeleteKey"
		STACK:	DWORD	-> ASCIZ registry key name
			DWORD	HKEY (see #2292)
	    0104h "RegSetValue"
		STACK:	DWORD	???
			DWORD	-> ???
			DWORD	???
			DWORD	-> ???
			DWORD	HKEY (see #2292)
	    0105h "RegQueryValue"
		STACK:	DWORD	-> DWORD for ???
			DWORD	-> ASCIZ ???
			DWORD	-> ASCIZ ???
			DWORD	HKEY (see #2292)
	    0106h "RegEnumKey"
		STACK:	DWORD	???
			DWORD	-> ASCIZ ???
			DWORD	???
			DWORD	HKEY (see #2292)
	    0107h "RegDeleteValue"
	    0108h "RegEnumValue"
		STACK:	DWORD	-> DWORD for ???
			DWORD	-> BYTE ???
			DWORD	-> DWORD for ???
			DWORD	-> DWORD for ???
			DWORD	-> DWORD for ???
			DWORD	-> ASCIZ ???
			DWORD	???
			DWORD	HKEY (see #2292)
	    0109h "RegQueryValueEx"
	    010Ah "RegSetValueEx"
	    010Bh "RegFlushKey"
	    010Ch "RegLoadKey"
	    010Dh "RegUnLoadKey"
	    010Eh "RegSaveKey"
	    010Fh "RegRestore"
	    0110h "RegRemapPreDefKey"
Return: parameters popped from stack
	DX:AX = return value

(Table 2292)
Values for Windows95 VMM predefined HKEY values:
 80000000h	HKEY_CLASSES_ROOT
 80000001h	HKEY_CURRENT_USER
 80000002h	HKEY_LOCAL_MACHINE
 80000003h	HKEY_USERS
 80000004h	HKEY_PERFORMANCE_DATA
 80000005h	HKEY_CURRENT_CONFIG
 80000006h	HKEY_DYN_DATA
SeeAlso: #2291
--------W-2F1684BX0003-----------------------
INT 2F - MS Windows - VPICD - GET API ENTRY POINT
	AX = 1684h
	BX = 0003h (virtual device ID for VPICD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2293)
		  0000h:0000h if the VxD does not support an API
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2293)
Call VPICD API entry point with:
	EAX = function number
	    0000h get version
		Return: AX = binary version (AH=major, AL=minor)
	    0001h virtualize timer???
	    0002h unvirtualize timer???
--------W-2F1684BX0005-----------------------
INT 2F - MS Windows - VTD - GET API ENTRY POINT
	AX = 1684h
	BX = 0005h (virtual device ID for VTD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2294)
		  0000h:0000h if the VxD does not support an API
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2294)
Call VTD.386/VTD.VXD entry point with:
	AX = function number
	    0000h get VTD version number
		Return: CF clear
			AH = major version
			AL = minor version
	    0100h get current clock tick time
		Return: EDX:EAX = clock tick time in 840ns units since Windows
				  was started
	    0101h get current system time in milliseconds
		Return: EAX = time in milliseconds that Windows has been
				  running
	    0102h get current virtual machine time
		Return: EAX = cumulative amount of time the virtual machine has
				  been active, in milliseconds
Note:	this entry point should only be called directly when TOOLHELP.DLL
	  TimerCount() cannot be called
SeeAlso: #0932,#0934,#0933 at INT 20"Windows"
--------W-2F1684BX0006-----------------------
INT 2F P - MS Windows95 - V86MMGR - GET API ENTRY POINT
	AX = 1684h
	BX = 0006h (virtual device ID for V86MMGR device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2295)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2295)
Call V86MMGR entry point with:
	EAX = function number
	    0000h get V86MMGR version
		Return: CF clear
			AH = major version
			AL = minor version
	    0001h get ???
		Return: CF clear
			EAX = status bits
				bit 0: ???
				bit 1: ???
				bit 2: ???
				bit 3: ???
				bit 4: ???
	    else
		Return: CF set
--------W-2F1684BX0009-----------------------
INT 2F P - MS Windows - REBOOT - GET API ENTRY POINT
	AX = 1684h
	BX = 0009h (virtual device ID for REBOOT device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2296)
		  0000h:0000h if the VxD does not support an API
SeeAlso: INT 14/AH=17h"FOSSIL",INT 16/AX=E0FFh

(Table 2296)
Call REBOOT protected-mode entry point with:
	AX = function
	    0100h warm boot
		Return: never
		Note:	broadcasts "Reboot_Processor" message, which is caught
			  by the VKD device
	    0201h set KERNEL Ctrl-Alt-Del handler
		ES:DI -> new Ctrl-Alt-Del handler
		DS:SI -> KERNEL reboot sanity check byte
		Return: CF clear
		Notes:	if an application installs its own handler and then
			  chains to Windows' handler, Windows will no longer
			  be able to detect hung applications, and will always
			  produce an "Application not responding" dialog
			DS must contain a writable, fixed selector because
			  the provided address is converted to a linear address
			  before being stored
			when Ctrl-Alt-Del is pressed in the system VM, Reboot
			  sets the sanity check byte to zero, schedules a
			  750ms wait, and then tests whether the check byte is
			  still zero; if not, it displays a message that there
			  is no hung application and then exits
	    0202h get KERNEL Ctrl-Alt-Del handler
		Return: CF clear
			ES:DI -> current Ctrl-Alt-Del handler
		Note:	the default handler is located in KERNEL
	    0203h display "Application not responding" dialog box
		ES:DI -> ASCIZ name of hung application
		Return: never if user pressed Ctrl-Alt-Del a second time
			CF clear
			AX = result
			    0000h user pressed Esc
			    0001h user pressed Enter
		Note:	this function is used by the default Windows
			  Ctrl-Alt-Del handler
	    0204h set/reset protected-mode INT 01 handler
		CX:EDX -> new protected-mode INT 01 handler
		CX = 0000h restore protected-mode INT 01 handler
		Return: CF clear
		Notes:	if CX is nonzero, the current handler address is saved
			  internally before the new handler is set; this saved
			  address is then used when CX is zero on entry
			used by Windows' default Ctrl-Alt-Del handler; actual
			  fatal exit to DOS will be done on next INT 01
		Warning: opened files are not closed and remain open as
			  orphaned files in DOS
Note:	functions 0201h and 0203h are not useful outside the system VM
SeeAlso: #0935,#0937
--------W-2F1684BX000A-----------------------
INT 2F P - MS Windows - VDD - GET API ENTRY POINT
	AX = 1684h
	BX = 000Ah (virtual device ID for VDD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2297)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2297)
Call VDD entry point with:
	EAX = function
	    0000h get VDD version
		Return: CF clear
			AH = major version
			AL = minor version
		Note:	also performs an internal initialization
	    0001h ???
		Return: ECX = ???
			???
	    0002h
	    0003h
	    0004h
	    0005h
	    0006h
	    0007h
	    0008h
	    0009h
	    0080h
	    0081h
	    0082h
	    0083h
	    0084h
	    0085h
	    0086h
	    0087h
	    0088h
	    0089h
	    else
		Return: nothing
--------W-2F1684BX000C-----------------------
INT 2F - MS Windows - VMD - GET API ENTRY POINT
	AX = 1684h
	BX = 000Ch (virtual device ID for VMD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2298)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2298)
Call VMOUSE entry point with:
	EAX = function number
	    0000h get VMOUSE version
		Return: CF clear
			AH = major version
			AL = minor version
	    0001h
		EBX = ???
		ECX = ???
		Return: CF clear if successful
			CF set on error (e.g. fn 0003h not yet called)
	    0002h ??? (calls "test system VM handle")
		Return: CF clear if successful (in system VM)
			CF set on error
	    0003h ???
		ECX = ???
		DX = ???
		Return: CF clear
	    0004h ???
		Note: invokes Call_Priority_VM_Event
	    0005h get mouse port data
		Return: CF clear
			AL = ??? (04h)
			AH = mouse IRQ interrupt number (IRQ4=0Ch,etc.)
			CX = mouse I/O port address (e.g. 03F8h)
			DX = COM port number??? (0001h for mouse on COM1)
	    0100h NOP???
		Return: CF clear
	    0101h init???
		Return: CF clear
		Note:	appears to be the same as fn 0005h, but returns no data
	    0102h unimplemented
		Return: CF set
	    0103h check ???
		Return: AX = status (0000h/0001h)
		Note:	checks flag set by fn 0003h
	    else
		Return: CF set
SeeAlso: #2297,#2299
--------W-2F1684BX000D-----------------------
INT 2F P - MS Windows - VKD - GET API ENTRY POINT
	AX = 1684h
	BX = 000Dh (virtual device ID for VKD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2299)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2299)
Call VKD entry point with:
	EAX = function
	    0000h get VKD version
		Return: CF clear
			AH = major version
			AL = minor version
	    0001h ???
		EBX = VM handle or 00000000h to use ??? VM handle
		CH = ???
		CL = ???
		EDX = ??? or FFFFFFFFh
		Return: CF clear if successful
			CF set on error
	    else
		Return: CF set
SeeAlso: #2298,#2300
--------W-2F1684BX000E-----------------------
INT 2F P - MS Windows - VCD - GET API ENTRY POINT
	AX = 1684h
	BX = 000Eh (virtual device ID for VCD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2300)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2300)
Call VCD entry point with:
	EDX = function number
	    0000h get VCD version
		Return: CF clear
			AH = major version
			AL = minor version
	    0001h get ???
		Return: CF clear
			AX = bit mask of ???
	    0002h get ???
		CX = COM port number
		Return: CF clear
			DX:AX -> ???
	    0003h set ???
		CX = COM port number
		DX:AX -> new ???
		Return: CF clear
	    0004h acquire COM port
		AX = ???
		CX = COM port number
		Return: CF clear
			AX = ???
			EBX = ???
			DX = ???
	    0005h release COM port
		CX = COM port number
		Return: CF clear
	    0006h ???
		Return: CF set
			AL = 00h
	    else
		Return: CF set
			EAX = FFFFFFFFh
Note:	these functions are apparently only available from the system VM,
	  returning CF set and EAX=FFFFFFFFh otherwise
SeeAlso: #2299,#2301
--------W-2F1684BX000F-----------------------
INT 2F P - MS Windows - VPD - GET API ENTRY POINT
	AX = 1684h
	BX = 000Fh (virtual device ID for VPD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2301)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2301)
Call VPD entry point with:
	EDX = function number
	    0000h get VPD version
		Return: CF clear
			AH = major version
			AL = minor version
			DX = ??? (CB01h)
	    0001h get valid??? printers
		Return: CF clear
			AX = bitmask of ??? printers (bits 0-2)
	    0002h get ??? for printer
		CX = printer port (0-2)
		Return: CF clear if successful
			    BX:AX = ???
			CF set on error (invalid port number)
	    0003h set ??? for printer
		CX = printer port (0-2)
		BX:AX = ???
		Return:	CF clear if successful
			CF set on error (invalid port number)
	    0004h ???
		CX = printer port (0-2)
		EAX = VM handle
		Return:	CF clear if successful
			CF set on error (invalid port number)
	    0005h ???
		CX = printer port (0-2)
		EAX = VM handle
		Return:	CF clear if successful
			CF set on error (invalid port number or ???)
	    0006h-000Eh unused
		Return: CF set
	    000Fh ???
		CX = printer port (0-2)
		AX = ???
		Return:	CF clear if successful
			CF set on error (e.g. invalid port number)
	    0010h ???
		CX = printer port (0-2)
		Return:	CF clear if successful
			CF set on error (e.g. invalid port number)
	    0011h ???
		CX = printer port (0-2)
		Return:	CF clear if successful
			CF set on error (e.g. invalid port number)
	    0012h get port status
		CX = printer port (0-2)
		Return:	CF clear if successful
			    AX = port status (see #P245 at PORT 03BCh"LPT")
			CF set on error (e.g. invalid port number)
	    else
		Return: CF set
Note:	these functions are apparently only available from the system VM,
	  returning CF set
SeeAlso: #2300,#2302
--------W-2F1684BX0010-----------------------
INT 2F - MS Windows - IOS - GET API ENTRY POINT
	AX = 1684h
	BX = 0010h (virtual device ID for IOS device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2302)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2302)
Call IOS entry point with:
	EAX = function number
	    0000h ???
		Return: CF clear if successful
			    AX = 0000h
			CF set on error
			    AX = FFFFh
	    0001h check if ???
		Return: CF clear if successful
			    AX = 0000h
			CF set on error
			    AX = FFFFh
	    0002h requestor services???
		DL = service number???
		Return: CF clear if successful
			    AX = 0000h
			    DX = ???
			CF set on error
			    AX = FFFFh
		Note:	calls "IOS_Requestor_Service" (see INT 20"Windows")
	    0003h ??? (copies five bytes of data internally)
		Return: CF clear if successful
			    AX = 0000h
			    EDX = ???
			CF set on error
			    AX = FFFFh
	    else
		Return: CF set
			AX = FFFFh
SeeAlso: #2301,#2303
--------W-2F1684BX0011-----------------------
INT 2F - MS Windows - VMCPD - GET API ENTRY POINT
	AX = 1684h
	BX = 0011h (virtual device ID for VMCPD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2303)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2303)
Call Windows95 VMCPD protected-mode entry point with:
	EAX = function number
	    0000h get VMCPD version
		Return: CF clear
			AH = major version
			AL = minor version
	    0001h get ??? flags
		Return: CF clear
			AX = ??? flags
			    bit 0: ???
			    bit 1: ???
			    bit 2: ???
			    bit 3: ???
	    else
		Return: CF set
SeeAlso: #2302,#2304
--------W-2F1684BX0015-----------------------
INT 2F - MS Windows - DOSMGR - GET API ENTRY POINT
	AX = 1684h
	BX = 0015h (virtual device ID for DOSMGR device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2304,#0946)
		  0000h:0000h if the VxD does not support an API
SeeAlso: #0946 at INT 20"Windows"

(Table 2304)
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
SeeAlso: #0946 at INT 20"Windows",#2303,#2305
--------W-2F1684BX0017-----------------------
INT 2F U - MS Windows - SHELL - GET API ENTRY POINT
	AX = 1684h
	BX = 0017h (virtual device ID for SHELL device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2305)
		  0000h:0000h if the VxD does not support an API
SeeAlso: AX=1684h/BX=0021h,#0947 at INT 20"Windows"

(Table 2305)
Call SHELL entry point with:
	EDX = function number (0000h-0027h,0100h-0108h, mostly unknown)
	    0000h get version number
		Return: AX = version number
			EBX = system VM handle
	    0001h "SHELL_Get_SYSVM_Info" get system VM information
		Return: CF clear
			AX bit 0 set if system VM executing exclusively
			BX = background time slice priority
			CX = foreground time slice priority
			SI = minimum time slice in milliseconds
	    0002h "SHELL_Set_SYSVM_Info" set system VM information
		AX bit 0 set if system VM should execute exclusively (ignored?)
		BX = background time slice priority (1-10000)
		CX = foreground time slice priority (1-10000)
		SI = minimum time slice in milliseconds (1-10000)
		Return: CF clear if successful
	    0003h "SHELL_Crt_VM" create a virtual machine
		ES:EDI -> SEB structure (see #2306)
		Return: CF clear if successful
			   EAX = VM handle
			CF set on error
			   EDX,EAX = result from GetSetDetailedVMError()
	    0004h "SHELL_Destroy_VM" destroy a virtual machine
		EBX = VM handle (not system VM)
		Return: nothing
	    0005h "SHELL_Set_Focus"
		EBX = VM handle
		ECX = ???
		Return: nothing
	    0006h "SHELL_Get_VM_State"
		EBX = VM handle (not system VM)
		ES:EDI -> ??? structure
		Return: CF clear if successful
	    0007h "SHELL_Set_VM_State"
		EBX = VM handle (not system VM)
		ES:EDI -> ??? structure
	    0008h "SHELL_Debug_Out"
		???
		Return: ???
		Note:	dummy function in retail version of MS Windows
	    0009h "SHELL_VMDA_Init"
		???
		Return: ???
	    000Ah "SHELL_VMDA_Exit"
		???
		Return: ???
	    000Bh "SHELL_Get_Message_Txt"
		???
		Return: ???
	    000Ch "SHELL_Event_Complete"
		???
		Return: ???
	    000Dh "SHELL_Get_Contention_Info"
		???
		Return: ???
	    000Eh "SHELL_Get_Clip_Info"
		???
		Return: ???
	    000Fh "SHELL_Set_Paste"
		???
		Return: ???
	    0010h "SHELL_Switcher_Assist"
		???
		Return: ???
	    0011h "SHELL_Get_FileSysChng"
		???
		Return: ???
	    0012h "SHELL_Query_Destroy"
		???
		Return: ???
	    0013h "SHELL_SetFocus_Cur_VM" set input focus to current VM
		???
		Return: ???
	    0014h "SHELL_User_Busy_API"
		???
		Return: ???
	    0015h "SHELL_Chng_Hot_Key"
		???
		Return: ???
	    0016h "SHELL_Get_TermInfo"
		???
		Return: ???
	    ---Windows95---
	    0017h ???
	    0018h ???
	    0019h ???
	    001Ah ???
	    001Bh ???
	    001Ch ???
	    001Dh ???
	    001Eh ???
	    001Fh ???
	    0020h ???
	    0021h ???
	    0022h ???
	    0023h ???
	    0024h ???
	    0025h ???
	    0026h ???
		Note:	makes VxDCALL 00178002h (see INT 20"Windows")
	    0027h ???
	    0100h get ??? version
		Return: AX = version??? (0400h for Windows95)
	    0101h not implemented
		Return: CF set
			EAX = FFFFFFFFh
	    0102h not implemented
		Return: CF set
			EAX = FFFFFFFFh
	    0103h not implemented
		Return: CF set
			EAX = FFFFFFFFh
	    0104h ???
	    0105h ???
	    0106h ???
		???
		Return: CF clear if successful
			CF set on error
	    0107h get SDK version for VxD
		AX = VxD identifier
		Return: EAX = VxD ID (high word) and SDK version (low)
			    00000000h if no such VxD loaded
		Note:	makes a VMMCALL 0001013Fh (see INT 20"Windows")
			  followed by ???
	    0108h ???
Return: CF set if called from VM other than system VM
	    EAX = FFFFFFFFh
Note:	except for functions 0013h,0026h,and 010xh, this API may only be
	  called from the system VM
SeeAlso: #0947 at INT 20"Windows"

Format of Shell Execution Block (SEB):
Offset	Size	Description	(Table 2306)
 00h	DWORD	PIF flags (see #2307)
 04h	DWORD	display flags (see #2308)
 08h	PWORD	-> pathname of .EXE to run
 0Eh	PWORD	-> argument list
 14h	PWORD	-> working drive/directory
 1Ah	WORD	desired number of V86 pages for virtual machine
 1Ch	WORD	minimum number of V86 pages for VM
 1Eh	WORD	foreground priority
 20h	WORD	background priority
 22h	WORD	maximum KB of EMS
 24h	WORD	minimum KB of EMS
 26h	WORD	maximum KB of XMS
 28h	WORD	minimum KB of XMS
 2Ah	WORD	maximum KB of DPMI???
 2Ch	WORD	minimum KB of DPMI???
 2Eh 128 BYTEs	title
Note:	the PWORDs at offsets 08h,0Eh, and 14h consist of a DWORD offset
	  followed by a WORD selector

Bitfields for 386 Enhanced Mode PIF flags:
Bit(s)	Description	(Table 2307)
 0	exclusive use of processor when VM is fullscreen
 1	VM runs in background
 2	VM runs in window
 3-4	???
 5	Alt-Tab reserved
 6	Alt-Esc reserved
 7	Alt-Space reserved
 8	Alt-Enter reserved
 9	Alt-PrtSc reserved
 10	PrtSc reserved
 11	Ctrl-Esc reserved
 12	VM will release idle time slice
 13	VM not allowed to use high memory
 14	???
 15	VM expanded memory not pageable
 16	VM extended memory not pageable
 17	Fast paste from clipboard enabled
 18	VM application memory not pageable
 30	Close VM when application exits
SeeAlso: #2306,#2308

Bitfields for SHELL display options:
Bit(s)	Description	(Table 2308)
 0	emulate text mode
 1	monitor text port
 2	monitor low graphics port
 3	monitor high graphics port
 7	Retain video memory
SeeAlso: #2306,#2307
--------W-2F1684BX001A-----------------------
INT 2F - MS Windows - VNETWARE - GET API ENTRY POINT
	AX = 1684h
	BX = 001Ah (virtual device ID for VNETWARE device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX001D-----------------------
INT 2F P - MS Windows - WINDEBUG - GET API ENTRY POINT
	AX = 1684h
	BX = 001Dh (virtual device ID for WINDEBUG device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0021-----------------------
INT 2F PU - MS Windows - PAGEFILE - GET API ENTRY POINT
	AX = 1684h
	BX = 0021h (virtual device ID for PAGEFILE device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2309)
		  0000h:0000h if the VxD does not support an API
SeeAlso: AX=1684h/BX=0017h,#0952 at INT 20"Windows"

(Table 2309)
Call PAGEFILE entry point with:
	AX = function
	    0000h get version
		Return: CF clear
			AX = version (AH = major, AL = minor)
	    0001h get swap file info
		DS:SI -> 128-byte buffer for swap file full pathname
		DS:DI -> 128-byte buffer for SPART.PAR full pathname
		Return: CF clear
			AL = pager type (see #2310)
			AH = flags
			    bit 7: swap file corrupted
			ECX = maximum size of swap file
			DS:SI buffer filled if paging enabled
			DS:DI buffer filled if permanent swap file
	    0002h delete permanent swap file on exit
		Return: CF clear
	    0003h get current temporary swap file size
		Return: CF clear
			DX:AX = current swap file size in bytes
				0000h:0000h if permanent swap file
Note:	this API is only available in protected mode, and may only be called
	  from the system VM
SeeAlso: #0952 at INT 20"Windows",#2311

(Table 2310)
Values for MS Windows PAGEFILE pager type:
 00h	paging disabled
 01h	MSDOS
 02h	BIOS
 03h	32-bit disk access
SeeAlso: #2309
--------W-2F1684BX0022-----------------------
INT 2F P - MS Windows - APIX - GET API ENTRY POINT
	AX = 1684h
	BX = 0022h (virtual device ID for APIX device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2311)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2311)
Call APIX protected-mode entry point with:
	AH = function number
	    00h get APIX version
		Return: CF clear
			AH = major version
			AL = minor version
	    01h ???
		Return: CF clear
			AX = number of ???
	    02h NOP
		Return: CF clear
	    03h ???
		Return: CF clear
			AX = 0000h/FFFFh
	    else
		Return: CF clear (bug?)
SeeAlso: #2309,#2314
--------W-2F1684BX0026-----------------------
INT 2F P - MS Windows - VPOWERD - GET API ENTRY POINT
	AX = 1684h
	BX = 0026h (virtual device ID for VPOWERD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2312)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2312)
Call VPOWERD.VXD entry point with:
	AX = function number
	    0000h get VPOWERD version
		Return: DX = 0000h
			AX = version (AH = major, AL = minor)
	    0001h get APM BIOS version
		Return: DX:AX = APM BIOS version
	    0002h get current power management level
		Return: DX:AX = power management level
	    0003h enable/disable power management (see INT 15/AX=5308h)
		??? = new state of power management
		Return: DX:AX = 0000h:0000h if successful
			   else error code (see #2313)
	    0004h set power state (see INT 15/AX=5307h)
		Return: DX:AX = 0000h:0000h if successful
			   else error code (see #2313)
	    0005h set system power status
		Return: DX:AX = 0000h:0000h if successful
			   else error code (see #2313)
	    0006h restore APM power-on defaults (see INT 15/AX=5309h)
		Return: DX:AX = 0000h:0000h if successful
			   else error code (see #2313)
	    0007h get power status (see INT 15/AX=530Ah)
		Return: ???
	    0008h get APM 1.1 power state (see INT 15/AX=530Ch)
		Return: ???
	    0009h invoke OEM APM function
		??? -> buffer containing parameters for INT 15/AX=5380h
		Return: DX:AX = 0000h:0000h or error code (see #2313)
			buffer updated if successful
	    000Ah register power handler
		???
		Return: DX:AX = 0000h:0000h or error code
	    000Bh deregister power handler
		???
		Return: DX:AX = 0000h:0000h or error code (see #2313)
	    000Ch Win32 get system power status
	    000Dh Win32 set system power status
	    else
		Return: DX = 0000h
			AX = 00FFh
SeeAlso: #2311,#2314

(Table 2313)
Values for VPOWERD.VXD error code:
 000000xxh	APM error code
 000000FFh	function number out of range
 80000001h	??? (service 05h)
 80000002h	??? (service 0Dh)
 80000003h	specified NULL buffer pointer (service 07h,08h,09h)
 80000005h	??? (service 03h)
 80000006h	??? (service 04h)
 80000007h	??? (service 05h)
 80000008h	??? (service 05h)
 80000009h	out of memory (service 0Ah)
 8000000Ah	??? (service 0Ah)
 8000000Bh	invalid power handler (service 0Bh)
 8000000Ch	unsupported/disabled??? function
SeeAlso: #2312,#0953
--------W-2F1684BX0027-----------------------
INT 2F - MS Windows95 - VXDLDR - GET API ENTRY POINT
	AX = 1684h
	BX = 0027h (virtual device ID for VXDLDR device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2314)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2314)
Call VXDLDR entry point with:
	EAX = function number
	    0000h get VXDLDR version
		Return: CF clear
			AX = 0000h (successful)
			DH = major version
			DL = minor version
	    0001h load device
		???
		Return: CF clear if successful
			    AX = 0000h
			CF set on error
			    AX = error code (see #2315)
	    0002h unload device
		BX = ???
		Return: CF clear if successful
			    AX = 0000h
			CF set on error
			    AX = error code (see #2315)
	    else
		Return: CF set
			AX = 000Bh
SeeAlso: #2312,#2316

(Table 2315)
Values for VXDLDR error code:
 0000h	successful
 000Bh	invalid function number
SeeAlso: #2314
--------W-2F1684BX0028-----------------------
INT 2F - MS Windows - NDIS - GET API ENTRY POINT
	AX = 1684h
	BX = 0028h (virtual device ID for NDIS device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2316)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2316)
Call NDIS.VXD entry point with:
	??? = function number
	    0000h set ??? to ???
		??? = new ???
		Return: DX:AX = 0000h:0001h
	    0002h ???
		???
		Return: DX:AX -> ???
	    0003h reset ??? to default
		Return: DX:AX = 0000h:0001h
	    else
		Return: DX:AX = 0000h:0000h
SeeAlso: #2314,#2317
--------W-2F1684BX002A-----------------------
INT 2F P - MS Windows - VWIN32 - GET API ENTRY POINT
	AX = 1684h
	BX = 002Ah (virtual device ID for VWIN32 device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2317)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2317)
Call VWIN32.VXD entry point with:
	AH = function number
	    00h get VWIN32 version and ???
		Return: CF clear
			AH = major version
			AL = minor version
			EDX = ???
	    01h ???
		EBX = ???
		ECX = ???
		Return: CF clear
			EAX = ???
	    02h ???
		Return: CF clear
			AX = ??? or 0000h
	    03h address allocation
		DS:??? -> buffer containing/for page data
		ECX = length of buffer
		AL = subfunction
		    00h reserve page(s)
		    01h commit page(s)
		    02h decommit page(s)
		    03h free page(s)
		Return: CF clear if successful
			CF set on error
		Note:	this function uses ECX bytes of stack
	    04h get ???
		Return: CF clear
			EAX = ???
	    05h ???
		EBX = ???
		Return: CF clear
			EAX = ???
	    06h ???
		EBX = ???
		Return: CF clear
			EAX = ???
	    07h ???
		EBX = ???
		Return: CF clear
			EAX = ???
	    08h get ???
		Return: CF clear
			AX = ???
	    09h ???
		EBX = ???
		ECX = ???
		Return: CF clear
	    0Ah ???
		EBX = ???
		Return: CF clear
	    0Bh ???
		EBX = ???
		Return: CF clear
	    0Ch ???
		EBX = ???
		ECX = ???
		EDX = ???
		???
		Return: CF clear if successful
			    EAX = ???
			CF set on error
	    0Dh clear ???
		Return: CF clear
	    0Eh ???
		EBX = ???
		ECX = ???
		Return: CF clear
	    0Fh ???
		EBX = ???
		ECX = ???
		Return: CF clear
	    10h ???
		Return: CF clear
		Note:	invokes VMMcall 00010184h
	    11h ???
		Return: CF clear
		Note:	invokes VMMcall 00010160h
	    12h ???
		???
	    13h pop up system error dialogue
		Return: CF clear
			AX = ??? or 0000h
	    14h "IFSMgr_GetConversionTablePtrs"
		Return:	CF clear
			DX:AX -> ???
		Note:	invokes VxDcall 00400051h
	    15h "Boost_With_Decay"
		EBX = ???
		ECX = ???
		EDX = ???
		Return: CF clear
	    else
		Return: CF set
SeeAlso: #2316,#2318
--------W-2F1684BX002B-----------------------
INT 2F - MS Windows - VCOMM - GET API ENTRY POINT
	AX = 1684h
	BX = 002Bh (virtual device ID for VCOMM device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2318)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2318)
Call VCOMM.VXD entry point with:
	AX = function number
	    0000h open COM/LPT port
		BX = port number (00h-7Fh = COMx, 80h-FFh = LPTx)
		Return: DX:AX = ???
	    0001h set comm state
		???
		Return: AX = ???
	    0002h setup comm port
		???
		Return: AX = status (0000h failed, FFFFh success)
	    0003h transmit character
		EBX = handle???
		ECX = ???
		Return: AX = status???
	    0004h close comm port
		EBX = handle???
		Return: ???
	    0005h clear comm error
		EBX = handle???
		EAX = ???
		Return: AX = status???
	    0006h "EscapeCommFunction"
		EBX = handle???
		ECX = ???
		EAX = ???
		Return: DX:AX = ???
	    0007h purge buffers
		EBX = handle???
		CX = ???
		Return: AX = status???
	    0008h set comm event mask
		EBX = handle???
		CX = new event mask
		Return: AX = status???
	    0009h get comm event mask
		EBX = handle???
		Return: AX = current event mask
	    000Ah ???
		EBX = handle???
		Return: ???
	    000Bh "WriteComm"
		EBX = handle???
		ECX = number of characters to write
		Return: AX = status
			EAX high word may be destroyed
	    000Ch "ReadComm"
		EBX = handle???
		ECX = number of bytes to read
		Return: AX = status ???
			ZF = ???
	    000Dh set ??? callback
		EBX = handle???
		ECX = ???
		EDX = ???
		Return: AX = status???
	    else
		Return: AX = 0000h
SeeAlso: #2317,#2319
--------W-2F1684BX002D-----------------------
INT 2F P - MS Windows - W32S - GET API ENTRY POINT
	AX = 1684h
	BX = 002Dh (virtual device ID for W32S device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0030-----------------------
INT 2F P - MS Windows - MACH32 - GET API ENTRY POINT
	AX = 1684h
	BX = 0030h (virtual device ID for MACH32 device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0032-----------------------
INT 2F - MS Windows - SERVER / VSERVER - GET API ENTRY POINT
	AX = 1684h
	BX = 0032h (virtual device ID for SERVER device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2319)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",#0959 at INT 20"Windows"

(Table 2319)
Call Windows95 VSERVER.VXD protected-mode entry point with:
	AX = function number
	    0003h NOP
		Return: AX = 0000h
	    0004h NOP
		Return: AX = 0000h
	    0007h NOP
		Return: AX = 0000h
	    0008h NOP
		Return: nothing
	    000Fh ???
		Return: AX = status
			    0000h successful
			    0842h on error
	    0010h ???
		Return: AX = status
			    0000h successful
			    0842h on error
	    else
		Return: AX = 0032h
SeeAlso: #2318,#2320
--------W-2F1684BX0033-----------------------
INT 2F - MS Windows - CONFIGMG - GET API ENTRY POINT
	AX = 1684h
	BX = 0033h (virtual device ID for CONFIGMG device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2320)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2320)
Call CONFIGMG.VXD entry point with:
	AX = function number
	    0000h get CONFIGMG version
		Return: CF clear
			AH = major version
			AL = minor version
	    ...
	    005Ah
	    else
		Return: CF set
			AX = 0020h
SeeAlso: #0960 at INT 20"Windows",#2319,#2321
--------x-2F1684BX0034-----------------------
INT 2F - Intel Plug-and-Play - CONFIGURATION MANAGER - GET ENTRY POINT
	AX = 1684h
	BX = 0034h (ID for Configuration Manager) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> API entry point (see #2321)
		  0000h:0000h if Configuration Manager not loaded
Note:	this API is often provided by a DOS device driver, in which case it
	  is available whether or not MSWindows is running
Index:	installation check;Plug-and-Play Configuration Manager
SeeAlso: AX=1684h/BX=304Ch

(Table 2321)
Call Configuration Manager entry point with:
	AX = function
	    0000h "CM_GetVersion" get supported DDI version
		Return: AH = BCD major version
			AL = BCD minor version
			BX = number of devices identified by configuration
		Note:	returns AX = 0000h if no config manager installed
	    0001h "CM_GetConfig" get device configuration
		BX = device index
		ES:DI -> buffer for configuration information (see #2323)
		Return: AX = status
			    0000h successful
				ES:DI buffer filled
			    other error code (0001h = index out of range)
	    0002h "CM_LockConfig" lock device configuration
		ES:DI -> configuration information (see #2323)
		Return: AX = status
			    0000h successful
				ES:DI buffer filled with assigned config
			    0001h resources conflict
			    0002h invalid request or configuration info
	    0003h "CM_UnlockConfig" unlock device configuration
		ES:DI -> configuration information (see #2323)
		Return: AX = status
			    0000h successful
				ES:DI buffer filled with assigned config
			    0001h invalid request or configuration info
	    0004h "CME_QueryResources" get hot-swappable resources
		ES:DI -> configuration information (see #2323)
		Return: AX = status (see #2322)
	    0005h "CME_AllocResources" remove resources from available pool
		ES:DI -> configuration information (see #2323)
		Return: AX = status (see #2322)
	    0006h "CME_DeallocResources" return resources to available pool
		ES:DI -> configuration information (see #2323)
		Return: AX = status (see #2322)
SeeAlso: #0961 at INT 20"Windows",#2320,#2324

(Table 2322)
Values for Configuration Manager status:
 00h	successful
 01h	device not found, configuration error
 02h	I/O port unavailable
 04h	IRQ unavailable
 08h	DMA channel unavailable
 10h	memory range unavailable
SeeAlso: #2321

Format of Configuration Information Structure:
Offset	Size	Description	(Table 2323)
 00h	DWORD	bus ID
 04h	DWORD	device ID
 08h	DWORD	serial number
 0Ch	DWORD	logical ID
 10h	DWORD	flags
---ISA bus---
 14h	BYTE	Card Select Number
 15h	BYTE	logical device number
 16h	WORD	Read Data port
------
 18h	WORD	number of memory windows
 1Ah  9 DWORDs	physical base addresses of memory windows
 3Eh  9 DWORDs	length of memory windows
 62h  9 WORDs	memory window attributes
 74h	WORD	number of I/O ports
 76h 20 WORDs	I/O port base addresses
 B6h 20 WORDs	lengths of I/O port ranges
 F6h	WORD	number of IRQs
 F8h  7 BYTEs	IRQ registers
 FFh  7 BYTEs	IRQ attributes
106h	WORD	number of DMA channels
108h  7 BYTEs	DMA channels used
10Fh  7 WORDs	DMA channel attributes
11Dh  3 BYTEs	reserved
SeeAlso: #2321
--------W-2F1684BX0036-----------------------
INT 2F - MS Windows - VFBACKUP - GET API ENTRY POINT
	AX = 1684h
	BX = 0036h (virtual device ID for VFBACKUP device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2324)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2324)
Call VFBACKUP.VXD entry point with:
	nothing -- this API is a NOP for the default Windows95 VFBACKUP
SeeAlso: #2321,#0863
--------W-2F1684BX0037-----------------------
INT 2F - MS Windows - ENABLE.VXD - GET API ENTRY POINT
	AX = 1684h
	BX = 0037h (virtual device ID for ENABLE device) (see #2325)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2324)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2325)
Call Windows95 ENABLE.VXD entry point with:
	AX = function number
	    0000h get ENABLE version
		Return:	CF clear
			AX = version (AH = major, AL = minor)
	    0001h
		EBX = ???
		Return: ???
	    0002h get ???
		Return: CF clear
			DX:AX = ???
	    0003h get ???
		Return: CF clear
			DX:AX = ???
	    0004h ???
		EBX = ???
		ECX = ???
		EDX = ???
		Return: CF clear if successful
			CF set on error
	    else
		Return: CF set
SeeAlso: #2324,#2326
--------W-2F1684BX0038-----------------------
INT 2F - MS Windows - VCOND - GET API ENTRY POINT
	AX = 1684h
	BX = 0038h (virtual device ID for VCOND device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2326)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2326)
Call VCOND.VXD virtual-86 entry point with:
	AX = function number
	    0202h
	    0203h
	    0204h
	    0205h
	    0206h
	    0207h
	    0208h
	    0209h
	    020Ah
	    020Bh
	    020Dh
	    020Eh
	    020Fh
	    0210h
	    0401h
	    0402h
	    0403h
	    0404h
	    0405h
	    else
		NOP
SeeAlso: #2327,#2325

(Table 2327)
Call VCOND.VXD protected-mode entry point with:
	AX = function number
	    0301h
	    0302h
	    0303h
	    0304h
	    0305h
	    0306h
	    0307h
	    0308h
	    else
		NOP
SeeAlso: #2326,#2324
--------W-2F1684BX003B-----------------------
INT 2F - MS Windows - DSVXD - GET API ENTRY POINT
	AX = 1684h
	BX = 003Bh (virtual device ID for DSVXD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX003D-----------------------
INT 2F - MS Windows - BIOS VxD - GET API ENTRY POINT
	AX = 1684h
	BX = 003Dh (virtual device ID for BIOS device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2328)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2328)
Call BIOS.VXD entry point with:
	AX = function number
	    0000h get BIOS.VXD version
		Return: CF clear
			AH = major version
			AL = minor version
	    0100h ???
		Return: AX = 0000h
		Note:	calls CONFIGMG services 804Eh/804Fh
	    0200h ???
		Return: CF clear if successful
			    AX = ???
			CF set on error
			    AX = error code???
		Note:	invokes VxDcall 00290002h
	    0300h ???
		Return: CF clear if successful
			    AX = ???
			CF set on error
			    AX = error code???
	    else
		Return: CF set
SeeAlso: #2327,#2329
--------W-2F1684BX003E-----------------------
INT 2F - MS Windows - WSOCK - GET API ENTRY POINT
	AX = 1684h
	BX = 003Eh (virtual device ID for WSOCK device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX011F-----------------------
INT 2F P - MS Windows - VFLATD - GET API ENTRY POINT
	AX = 1684h
	BX = 011Fh (virtual device ID for VFLATD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2329)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2329)
Call VFLATD.VXD entry point with:
	DL = function number
	    00h get VFLATD version and ???
		Return: CF clear
			EAX = version (AH = major, AL = minor)
			EBX = ???
			ECX = ???
			EDX = ??? or 00000000h
	    01h ???
		AX = ???
		CX = ???
		Return: EAX = ???
			EDX = ???
	    02h ???
		???
	    03h ???
		EAX = ???
		EBX = ???
		ESI = ???
		CX = ???
		DH = ???
		Return: EAX = ???
			EDX = ???
			CF clear
	    04h ???
		DH = ???
		EAX = ???
		ECX = ???
		Return: CF clear
			EAX = ???
			EDX = ???
	    05h ???
		???
		Note:	locks some linear memory and calls fn 02h
	    06h ???
		???
		Return: CF clear if successful
			CF set on error
		Note:	calls fn 02h and unlocks some linear memory
	    else
		Return: CF set
SeeAlso: #2328
--------W-2F1684BX0200-----------------------
INT 2F - MS Windows - VIPX - GET API ENTRY POINT
	AX = 1684h
	BX = 0200h (virtual device ID for VIPX device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0202-----------------------
INT 2F - MS Windows - WINICE - GET API ENTRY POINT
	AX = 1684h
	BX = 0202h (virtual device ID for WINICE device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0203-----------------------
INT 2F P - MS Windows - VCLIENT - GET API ENTRY POINT
	AX = 1684h
	BX = 0203h (virtual device ID for VCLIENT device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0205-----------------------
INT 2F - MS Windows - BCW - GET API ENTRY POINT
	AX = 1684h
	BX = 0205h (virtual device ID for BCW device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0207-----------------------
INT 2F R - MS Windows - DPMS VxD - GET API ENTRY POINT
	AX = 1684h
	BX = 0207h (virtual device ID for DPMS device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0234-----------------------
INT 2F - MS Windows - VCOMMUTE - GET API ENTRY POINT
	AX = 1684h
	BX = 0234h (virtual device ID for VCOMMUTE device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0442-----------------------
INT 2F P - MS Windows - VTDAPI - GET API ENTRY POINT
	AX = 1684h
	BX = 0442h (virtual device ID for VTDAPI device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2330)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2330)
Call VTDAPI.VXD entry point with:
	EAX = function number
	    0000h
	    0001h
	    0002h
	    0003h
	    0004h
	    0005h
	    0006h
	    0007h
	    0008h
	    0009h
	    000Ah
	    000Bh
	    else
		Return: nothing???
SeeAlso: #2330
--------W-2F1684BX0444-----------------------
INT 2F - MS Windows - VADMAD - GET API ENTRY POINT
	AX = 1684h
	BX = 0444h (virtual device ID for VADMAD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2331)
		  0000h:0000h if the VxD does not support an API

(Table 2331)
Call VADMAD entry point with:
	DX = operation
	    0000h set VADMAD mode
		AX = desired mode
	    0001h set VADMAD channel
		AX = desired channel
Note:	after setting mode/channel, start the DMA operation with an OUT to
	  I/O port 0Bh (channels 0-3) or D6h (channels 4-7)
SeeAlso: #0932 at INT 20"Windows"
--------W-2F1684BX0445-----------------------
INT 2F - MS Windows - VSBD - GET API ENTRY POINT
	AX = 1684h
	BX = 0445h (virtual device ID for VSBD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0446-----------------------
INT 2F - MS Windows - VADLIBD - GET API ENTRY POINT
	AX = 1684h
	BX = 0446h (virtual device ID for VADLIBD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0449-----------------------
INT 2F P - MS Windows - vjoyd - GET API ENTRY POINT
	AX = 1684h
	BX = 0449h (virtual device ID for "vjoyd" device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2332)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2332)
Call VJOYD.VXD entry point with:
	AX = function number
	    0000h get VJOYD version
		Return: AH = major version
			AL = minor version
	    0001h ???
		DX = ???
		Return: DX:AX = ???
	    0002h ???
		DX = ???
		Return: DX:AX = ???
	    0003h ???
		Retrun: AX = 0001h
	    0004h ???
		DX = ???
		Return: DX:AX = ???
	    0005h ???
		Return: ???
	    else
		Return: EAX = 00000000h
SeeAlso: #2330,#2333
--------W-2F1684BX044A-----------------------
INT 2F - MS Windows - mmdevldr - GET API ENTRY POINT
	AX = 1684h
	BX = 044Ah (virtual device ID for "mmdevldr" device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2333)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2333)
Call MMDEVLDR.VXD entry point with:
	DX = function number
	    0000h ???
		Return: CF clear if successful
			    AX = 0000h
			CF set on error
			    AX = error code (000Bh)
		Note:	invokes VxDCall 17000Eh ("CallAtAppyTime")
	    0001h ???
		Return: CF clear if successful
			    AX = 0000h
			CF set on error
			    AX = error code (000Bh)
		Note:	invokes VxDCall 17000Eh ("CallAtAppyTime")
	    0002h ???
		EDX = ???
		Return: CF clear if successful
			    AX = 0000h
			    EDX = ???
			CF set on error
			    AX = error code
	    0003h ???
		Return: CF clear if successful
			    AX = 0000h
			CF set on error
			    AX = error code
		Note:	invokes VxDcall 2A0002h ("VWIN32_QueueUserApc")
	    0004h set Win32 event
		Return: CF clear if successful
			    AX = 0000h
			CF set on error
			    AX = error code
		Note:	invokes VxDcall 2A000Eh ("VWIN32_SetWin32Event")
	    0005h ??? (allocates some memory)
		Return: CF clear
			AX = 0000h
	    0006h ??? (frees memory)
		Return: CF clear if successful
			    AX = 0000h
			CF set on error
			    AX = error code
	    else
		Return: CF set
			AX = 000Bh (invalid function)
SeeAlso: #2332,#2334
--------W-2F1684BX045D-----------------------
INT 2F P - MS Windows - VflatD - GET API ENTRY POINT
	AX = 1684h
	BX = 045Dh (virtual device ID for VflatD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX045F-----------------------
INT 2F - MS Windows - azt16 - GET API ENTRY POINT
	AX = 1684h
	BX = 045Fh (virtual device ID for "azt16" device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2334)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h/BX=3110h,AX=1684h"DEVICE API",INT 20"Windows"

(Table 2334)
Call azt16.VXD entry point with:
	DX = function number
	    0000h get azt16 version
		Return: CF clear
			AX = version (AH=major, AL=minor)
	    0001h ???
		AX = subfunction
		    0000h ???
			Return:
		    0001h ???
			ECX = ???
		    else error
		Return: CF clear if successful
			    ???
			CF set on error
			    AX = error code
	    0002h ???
		AX = ???
		BX = ???
		Return: ???
	    0003h ???
		AX = ???
		BX = ???
		Return: ???
	    0004h ???
		BX = ???
		CX = ???
		Return: CF clear if successful
			     AX = 0001h
			CF set on error
			     AX = 0000h
	    0005h ???
		BX = ???
		CX = ???
		Return: CF clear if successful
			     AX = 0001h
			CF set on error
			     AX = 0000h
	    0006h ???
		BX = ???
		ECX = ???
		Return: CF clear if succesful
			    AX = ???
			CF set on error
			    AX = FFFFh
	    0100h get azt16 version
		Return: CF clear
			AX = version (AH=major, AL=minor)
	    0101h
		AX = ???
		ECX = ???
		Return: CF clear if successful
			    AX = 0001h
			CF set on error
			    AX = 0000h
	    0102h ???
		AX = ???
		Return: CF clear if successful
			CF set on error
			    AX = reason??? (0/1/2)
	    0103h ???
		AX = ???
		Return: CF clear if successful
			    AX = 0000h
			CF set on error
			    AX = reason??? (1/3)
	    0200h ???
		EDX = ???
		???
		Return: CF clear if successful
			    DX:AX = ???
			CF set on error
			    DX:AX = 0000h:0000h
	    0201h ???
		???
		Return: CF clear
			AX= 0000h
	    else
		Return: CF set
SeeAlso: #2333,#2353
--------W-2F1684BX0460-----------------------
INT 2F P - MS Windows - UNIMODEM - GET API ENTRY POINT
	AX = 1684h
	BX = 0460h (virtual device ID for UNIMODEM device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2335)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2335)
Call UNIMODEM.VXD protected-mode entry point with:
	AX = function number
	    0000h
		Return: AX = ???
	    0001h
		Return: AX = ???
	    0002h
		Return: AX = ???
	    0003h
		Return: AX = ???
	    0004h
		Return: AX = ???
	    0005h
		Return: AX = ???
	    0006h
		Return: AX = ???
	    0007h
		Return: AX = ???
	    else
		Return: AX = 0002h
SeeAlso: #2334,#2336
--------W-2F1684BX0480-----------------------
INT 2F - MS Windows - VNetSup - GET API ENTRY POINT
	AX = 1684h
	BX = 0480h (virtual device ID for VNetSup device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2336)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2336)
Call VNetSup.VXD entry point with:
	AX = function number
	    0000h
		Return: AX = ???
	    0001h
		Return: AX = ???
	    0002h
		Return: AX = ???
	    else
		Return: CF set
			AX = 0001h
SeeAlso: #2335,#2337
--------W-2F1684BX0482-----------------------
INT 2F - MS Windows - VBrowse - GET API ENTRY POINT
	AX = 1684h
	BX = 0482h (virtual device ID for VBrowse device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0483-----------------------
INT 2F - MS Windows - VSHARE - GET API ENTRY POINT
	AX = 1684h
	BX = 0483h (virtual device ID for VSHARE device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2337)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2337)
Call Windows95 VSHARE.VXD entry point with:
	AX = function number
	    0000h get VSHARE version
		Return: AH = major version
			AL = (BCD?) minor version
	    else
		NOP
SeeAlso: #2336
--------W-2F1684BX0484-----------------------
INT 2F P - MS Windows - IFSMgr - GET API ENTRY POINT
	AX = 1684h
	BX = 0484h (virtual device ID for IFSMgr device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0486-----------------------
INT 2F - MS Windows - VFAT - GET API ENTRY POINT
	AX = 1684h
	BX = 0486h (virtual device ID for VFAT device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0487-----------------------
INT 2F - MS Windows - NWLINK - GET API ENTRY POINT
	AX = 1684h
	BX = 0487h (virtual device ID for NWLINK device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX0489-----------------------
INT 2F R - MS Windows - VIP - GET API ENTRY POINT
	AX = 1684h
	BX = 0489h (virtual device ID for VIP device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX048A-----------------------
INT 2F - MS Windows 3.11 - VXDLDR - GET API ENTRY POINT
	AX = 1684h
	BX = 048Ah (virtual device ID for VTCP device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX048A-----------------------
INT 2F - MS Windows - VCACHE - GET API ENTRY POINT
	AX = 1684h
	BX = 048Ah (virtual device ID for VCACHE device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2339)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2338)
Call Windows95 VCACHE.VXD entry point with:
	Return:	CF set
SeeAlso: #2337,#2339
--------W-2F1684BX048D-----------------------
INT 2F - MS Windows - RASMAC - GET API ENTRY POINT
	AX = 1684h
	BX = 048Dh (virtual device ID for RASMAC device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX048E-----------------------
INT 2F - MS Windows - NWREDIR - GET API ENTRY POINT
	AX = 1684h
	BX = 048Eh (virtual device ID for NWREDIR device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2339)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2339)
Call Windows95 NWREDIR.VXD entry point with:
	Return:	CF set
		EAX = FFFFFFFFh
SeeAlso: #2338
--------W-2F1684BX0494-----------------------
INT 2F - MS Windows - NSCL - GET API ENTRY POINT
	AX = 1684h
	BX = 0494h (virtual device ID for NSCL device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2340,#2341)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2340)
Call Windows95 NSCL.VXD virtual-86 entry point with:
	AL = function number
	    00h
	    01h
	    02h
	    03h
	    04h
	    05h
	    06h
	    07h
	    08h
	    09h
	    0Ah
	    else
		Return: AX = FFFFh
SeeAlso: #2339,#2340

(Table 2341)
Call Windows95 NSCL.VXD protected-mode entry point with:
	AL = function number
	    00h
	    01h
	    02h
	    03h
	    else
		Return: AX = FFFFh
SeeAlso: #2340
--------W-2F1684BX0499-----------------------
INT 2F - MS Windows - PPPMAC - GET API ENTRY POINT
	AX = 1684h
	BX = 0499h (virtual device ID for PPPMAC device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX049A-----------------------
INT 2F - MS Windows - VDHCP - GET API ENTRY POINT
	AX = 1684h
	BX = 049Ah (virtual device ID for VDHCP device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX049B-----------------------
INT 2F - MS Windows - VNBT - GET API ENTRY POINT
	AX = 1684h
	BX = 049Bh (virtual device ID for VNBT device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX1021-----------------------
INT 2F - MS Windows - VMB - GET API ENTRY POINT
	AX = 1684h
	BX = 1021h (virtual device ID for VMB device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX28A0-----------------------
INT 2F - MS Windows - PHARLAPX - GET API ENTRY POINT
	AX = 1684h
	BX = 28A0h (virtual device ID for PHARLAPX device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2342)
		  0000h:0000h if the VxD does not support an API

(Table 2342)
Call PHARLAPX VxD entry point with:
	AX = function
	    0001h get PHARLAP.386 version
		Return: AX = version number (AH = major, AL = minor)
	---queue functions---
	    0101h allocate a new message queue
		CX = size of queue data buffer in bytes
		Return: DX:AX = handle for new queue, or 0000h:0000h on error
	    0102h allocate a new key queue
		CX = size of queue data buffer in bytes
		EDX = VM handle into which keys will be pasted
		Return: DX:AX = handle for new queue, or 0000h:0000h on error
	    0103h free message queue
		EDX = queue handle
		Return: AX = status (0000h,0003h,0007h) (see #2343)
	    0104h free key queue
		EDX = queue handle
		Return: AX = status (0000h,0003h,0005h) (see #2343)
	    0105h add message to communications queue
		EDX = queue handle
		BX = length of message data in bytes
		CX = length of message header in bytes
		ES:(E)SI -> message header
		GS:(E)DI -> message data
		Return: AX = status (0000h-0003h,0007h) (see #2343)
	    0106h remove message from queue
		EDX = queue handle
		CX = length of buffer in bytes
		ES:(E)SI -> buffer for message
		Return: AX = status (0000h,0003h,0006h,0007h,0008h) (see #2343)
			CX = length of returned message (if AX=0000h or 0008h)
	    0107h flush queue (remove all data)
		EDX = queue handle
		Return: AX = status (0000h,0003h) (see #2343)
	    0108h add PasteKey structure(s) to key queue
		EDX = queue handle
		CX = number of PasteKey structures in buffer
		ES:(E)SI -> PasteKey array (see #2344)
		Return: AX = status (0000h-0003h) (see #2343)
	    0109h register enqueueing callback function
		EDX = queue handle
		ECX = function argument
		ES:(E)SI -> callback function
		Return: AX = status (0000h,0003h,0009h) (see #2343)
	    010Ah register dequeueing callback function
		EDX = queue handle
		ECX = function argument
		ES:(E)SI -> callback function
		Return: AX = status (0000h,0003h,0009h) (see #2343)
	    010Bh unregister enqueueing callback function
		EDX = queue handle
		Return: AX = status (0000h,0003h,0009h) (see #2343)
	    010Ch unregister dequeueing callback function
		EDX = queue handle
		Return: AX = status (0000h,0003h,0009h) (see #2343)
	    010Dh get message queue status
		EDX = queue handle
		Return: AX = status (0000h,0003h) (see #2343)
			CX = number of pending messages
	    010Eh peek at message in queue
		EDX = queue handle
		BX = number of message in queue (0000h = first)
		CX = size of buffer in bytes
		ES:(E)SI -> buffer for message
		Return: AX = status (0000h,0003h,0006h,0008h) (see #2343)
			CX = length of returned message (if AX=0000h or 0008h)
	    010Fh peek at last message in queue
		EDX = queue handle
		CX = size of buffer in bytes
		ES:(E)SI -> buffer for message
		Return: AX = status (0000h,0003h,0006h,0008h) (see #2343)
			CX = length of returned message (if AX=0000h or 0008h)
	    0110h replace last message in queue
		EDX = queue handle
		CX = length of message header in bytes
		BX = length of message data in bytes
		ES:(E)SI -> message header
		GS:(E)DI -> message data
		Return: AX = status (0000h,0002h,0003h) (see #2343)
	    0111h set permitted message count for queue
		EDX = queue handle
		CX = maximum number of messages to enqueue (FFFFh = unlimited)
		Return: AX = status (0000h,0003h) (see #2343)
	---generalized VxD services---
	    0202h call VxD function
		ES:(E)BX -> in/out register-set buffer
		Return: buffer updated
	    0203h map flat
		???
	--system register functions---
	    0301h read system registers into buffer
		ES:(E)SI -> 512-byte buffer
		Return: AX = 0000h
			buffer filled (mostly zeros)
	    0302h copy linear memory into buffer
		EDX = linear address
		CX = number of bytes to copy
		ES:(E)SI -> buffer
		Return: AX = 0000h
	    0303h copy data into linear memory
		EDX = linear address
		CX = number of bytes to copy
		ES:(E)SI -> buffer
		Return: AX = 0000h
	    0304h freeze VM
		???
	    0305h unfreeze VM
		???
	---name registration functions---
	    0401h register name
		EDX = magic number to associate with name
		ES:(E)SI -> name to register
		Return: AX = status (0000h,0009h) (see #2343)
	    0402h unregister name
		ES:(E)SI -> name to be unregistered
		Return: AX = status (0000h,0009h) (see #2343)
	    0403h look up name
		ES:(E)SI -> name to look up
		Return: DX:AX = magic number or 0000h:0000h if not registered
	    0404h get name list handle
		Return: DX:AX = name list handle
				0000h:0000h if not initialized
	---special DOS server routines (undocumented)---
	    0501h register
	    0502h unregister
	    0503h validate VM
	    0504h get INT9 count
	    0505h get screen line
	    0506h get shift status
	    0507h get server PB pointer
	    0508h initialize DOS shell
	    0509h get last VM handle

(Table 2343)
Values for PHARLAPX function status:
 00h	successful
 01h	data is too large to fit in queue
 02h	queue is full
 03h	invalid queue handle
 04h	invalid VM handle for queue
 05h	error starting a paste operation
 06h	queue is empty
 07h	a VM is blocked waiting on the queue
 08h	message was too long (truncated)
 09h	unable to register or unregister specified callback
SeeAlso: #2342

Format of PHARLAPX PasteKey structure:
Offset	Size	Description	(Table 2344)
 00h	BYTE	ASCII code
 01h	BYTE	scan code (see #0005)
 02h	WORD	shift states
SeeAlso: #2342

Format of PHARLAPX VxD-call register structure:
Offset	Size	Description	(Table 2345)
 00h	DWORD	call number
 04h	WORD	input register map (see #2346)
 06h	WORD	output register map (see #2346)
 08h  7 DWORDs	values for EAX, EBX, ECX, EDX, EBP, ESI, EDI on call
 24h  4	WORDs	values for DS, ES, FG, GS on call
 2Ch	DWORD	EFLAGS on call
 30h  7 DWORDs	returned values of EAX, EBX, ECX, EDX, EBP, ESI, EDI
 4Ch  4 WORDs	returned values of DS, ES, FS, GS
 54h	DWORD	returned EFLAGS
SeeAlso: #2342

Bitfields for PHARLAPX VxD-call register map:
Bit(s)	Description	(Table 2346)
 0	value in EAX field is valid
 1	value in EBX field is valid
 2	value in ECX field is valid
 3	value in EDX field is valid
 4	value in EBP field is valid
 5	value in ESI field is valid
 6	value in EDI field is valid
 7	value in DS field is valid
 8	value in ES field is valid
 9	value in FS field is valid
 10	value in GS field is valid
 11	value in EFLAGS field is valid
SeeAlso: #2345
--------W-2F1684BX28A1-----------------------
INT 2F - MS Windows - PharLap VxD - GET API ENTRY POINT
	AX = 1684h
	BX = 28A1h (virtual device ID for PharLap device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",AX=1684h/BX=28A0h,INT 20"Windows"
--------W-2F1684BX2925-----------------------
INT 2F - MS Windows - EDOS - GET API ENTRY POINT
	AX = 1684h
	BX = 2925h (virtual device ID for EDOS device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2347)
		  0000h:0000h if the VxD does not support an API

(Table 2347)
Call EDOS entry point with:
	AX = 0000h get EDOS version number
	    Return: AH = major version
		    AL = minor version
	AX = 0001h display message
	    CX = 0
	    DX:BX -> ASCIZ Message
	AX = 0002h get EDOS error coded
	    Return: EAX = time in milliseconds that Windows has been running
	AX = 0003h execute windows program
	    Return: EAX = cumulative amount of time the virtual machine has
			been active, in milliseconds
	AX = 0008h get/set priority
	    BX = 0000h??? foreground
		 0001h background
	    DI = 0000h get
		 0001h set
	    DX = priority setting
	    Return: CX = foreground priority
		    DX = background priority
		    BX:AX = flags
			00000001h exclusive ON
			00000010h background ON
		    SI = CPU percentage
--------W-2F1684BX292D-----------------------
INT 2F - MS Windows - VSBPD - GET API ENTRY POINT
	AX = 1684h
	BX = 292Dh (virtual device ID for VSBPD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------W-2F1684BX295A-----------------------
INT 2F - MS Windows - GRVSULTR - GET API ENTRY POINT
	AX = 1684h
	BX = 295Ah (virtual device ID for GRVSULTR device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
--------x-2F1684BX304C-----------------------
INT 2F - Intel Plug-and-Play - CONFIGURATION ACCESS - GET ENTRY POINT
	AX = 1684h
	BX = 304Ch (ID for Configuration Access) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> API entry point (see #2348)
		  0000h:0000h if Configuration Access not loaded
Note:	this API is often provided by a DOS device driver, in which case it
	  is available whether or not MSWindows is running
Index:	installation check;Plug-and-Play Configuration Access
SeeAlso: AX=1684h/BX=0034h

(Table 2348)
Call Plug-and-Play Configuration Access entry point with:
	AX = function
	    0000h "CA_GetVersion"
		Return: AX = BCD version (AH = major, AL = minor)
	    0001h "CA_PCI_Read_Config_Byte" (see also INT 1A/AX=B108h)
	!!!
	    0002h "CA_PCI_Read_Config_Word" (see also INT 1A/AX=B109h)
	    0003h "CA_PCI_Read_Config_DWord" (see also INT 1A/AX=B10Ah)
	    0004h "CA_PCI_Write_Config_Byte" (see also INT 1A/AX=B10Bh)
	    0005h "CA_PCI_Write_Config_Word" (see also INT 1A/AX=B10Ch)
	    0006h "CA_PCI_Write_Config_DWord" (see also INT 1A/AX=B10Dh)
	    0007h "CA_PCI_Generate_Special_Cycle" (see also INT 1A/AX=B106h)
	    0008h "CA_PCI_Get_Routing_Options" (see also INT 1A/AX=B10Eh)
	    0009h invalid function
	    000Ah invalid function
	    000Bh "CA_PnPISA_Get_Info"
	    000Ch "CA_PnPISA_Read_Config_Byte"
	    000Dh "CA_PnPISA_Write_Config_Byte"
	    000Eh "CA_PnPISA_Get_Resource_Data"
	    000Fh invalid function
	    0010h "CA_EISA_Get_Board_ID"
	    0011h "CA_EISA_Get_Slot_Config"
	    0012h "CA_EISA_Get_SlotFunc_Config"
	    0013h "CA_EISA_Clear_NVRAM_Config"
	    0014h "CA_EISA_Write_Config"
	    0015h invalid function
	    0016h "CA_ESCD_Get_Info"
	    0017h "CA_ESCD_Read_Config"
	    0018h "CA_ESCD_Write_Config"
	    0019h invalid function
	    001Ah "CA_Acfg_PCI_Manage_IRQs"
		DL = IRQ???
		ES:DI -> ???
		Return: AX = status
	    001Bh "CA_Acfg_PCI_Get_Routing_Options"
		ES:DI -> IRQ routing table header
			  (see #0924 at INT 1A/AX=B406h)
		Return: AX = status
	    001Ch-001Fh invalid functions
	    0020h "CA_PnPB_Get_Num_Sys_Dev_Nodes"
	    0021h "CA_PnPB_Get_Sys_Dev_Node"
	    0022h "CA_PnPB_Set_Sys_Dev_Node"
	    0023h "CA_PnPB_Get_Stat_Res_Info"
	    0024h "CA_PnPB_Set_Stat_Res_Info"
Return: AX = FFFFh if unsupported function
SeeAlso: #2349
--------W-2F1684BX3099-----------------------
INT 2F - MS Windows - VVidramD - GET API ENTRY POINT
	AX = 1684h
	BX = 3099h (virtual device ID for VVidramD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2349)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2349)
Call VVidramD (VIDRAM.VXD) virtual-86 entry point with:
	AX = function number
	    0000h map page???
		BX = page number???
		Return: CF clear if successful
			CF set on error
	    0001h ???
		Return: CF clear if successful
			CF set on error
	    else
		Return: CF set
SeeAlso: #2348,#2350
--------W-2F1684BX30F6-----------------------
INT 2F P - MS Windows - WSVV - GET API ENTRY POINT
	AX = 1684h
	BX = 30F6h (virtual device ID for WSVV device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2350)
Call WSVV.VXD protected-mode entry point with:
	AX = function number
	    ????
	Return: ???
SeeAlso: #2349,#2351
--------W-2F1684BX310E-----------------------
INT 2F - MS Windows - WPS - GET API ENTRY POINT
	AX = 1684h
	BX = 310Eh (virtual device ID for WPS device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2351)
		  0000h:0000h if the VxD does not support an API
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2351)
Call WPS protected-mode entry point with:
	DX = function
	    0000h get WPS.386 version
		Return: CF clear
			AX = version (AH = major, AL = minor)
	    0001h get number of installed VxDs
		Return: CF clear
			AX = number of installed VxDs
	    0002h get VxD characteristics
		AX = number of VxD
		ES:BX -> buffer for VxD characteristics structure (see #2352)
		Return: CF clear
			ES:BX buffer filled
SeeAlso: #2350,#2354

Format of WPS.386 VxD characteristics structure:
Offset	Size	Description	(Table 2352)
 00h	WORD	VxD ID number
 02h	BYTE	VxD minor version
 03h	BYTE	VxD major version
 04h	BYTE	DDK minor version
 05h	BYTE	DDK major version
 06h	WORD	flags
		bit 0: V86 API supported
		bit 1: PM API supported
		bit 2: services supported
 08h	DWORD	start order
 0Ch  9 BYTEs	ASCIZ VxD name
SeeAlso: #2351
--------W-2F1684BX3110-----------------------
INT 2F - MS Windows - VSGLX16.386 - GET API ENTRY POINT
	AX = 1684h
	BX = 3110h (virtual device ID for VSGLX16.386) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2353)
		  0000h:0000h if the VxD does not support an API
SeeAlso: AX=1684h/BX=045Fh,AX=1684h"DEVICE API",INT 20"Windows"

(Table 2353)
Call VSGLX16.386 entry point with:
	DX = function number
	    0000h get azt16 version
		Return: CF clear
			AX = version returned by "azt16" device
	    0001h get ???
		AX = ??? (always fails if nonzero)
		ES:BX -> buffer for ???
			first DWORD of buffer must be set to length of buffer
			  (in bytes, 1 <= size <= 92) before calling
		Return: CF clear if successful
			    AX = 0001h
			CF set on error (invalid pointer, bad buffer size)
			    AX = 0000h
	    0002h
		AX = ???
		BX = ???
		Return: CF clear if successful
			    AX = ???
			CF set on error
			    AX = error code
	    0003h
		AX = ???
		BX = ???
		Return: CF clear if successful
			CF set on error
	    0004h set ???
		ES:DI -> buffer containing ???
		BX = ???
		CX = number of bytes to copy
		Return: CF clear if successful
			    AX = 0001h
			CF set on error
			    AX = 0000h
	    0005h get ???
		ES:DI -> buffer for ???
		BX = ???
		CX = number of bytes to copy
		Return: CF clear if successful
			    AX = 0001h
			CF set on error
			    AX = 0000h
	    else
		Return: CF set
SeeAlso: #2334
--------W-2F1684BX31CF-----------------------
INT 2F - MS Windows - STAT.386 - GET API ENTRY POINT
	AX = 1684h
	BX = 31CFh (virtual device ID for STAT.386) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2354)
		  0000h:0000h if the VxD does not support an API
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2354)
Call STAT.386 entry point with:
	AX = function
	    0000h get version
		Return: AX = STAT.386 version (AH = major, AL = minor)
	    0001h execute RDMSR/WRMSR/RDTSC
		BH = 00h
		BL = second opcode byte (30h=WRMSR,31h=RDTSC,32h=RDMSR)
		EDX:EDI = value to be written (for BL=30h)
		ECX = MSR number for RDMSR/WRMSR
		Return: EDX:EAX = value read (RDTSR/RDMSR only)
SeeAlso: #2351,#2355
--------W-2F1684BX34DC-----------------------
INT 2F - QEMM v8.01 - MAGNARAM VxD - GET API ENTRY POINT
	AX = 1684h
	BX = 34DCh (virtual device ID for MAGNARAM) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2355)
		  0000h:0000h if the VxD does not support an API
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2355)
Call MAGNARAM MAGNA95.VXD protected-mode entry point with:
	AX = function number
	    0000h get version and ???
		Return: AX = version (AH = major, AL = minor)
			CX = ???
			    bit 0: ???
			    bit 1: ???
	    0001h get ???
		Return: CF clear
			DX:AX = ??? SHL 2
	    0002h
		Return: CF clear if successful
			    AX = ???
			    DX = ???
			CF set on error
	    0003h get ???
		Return: CF clear
			DX:AX = ??? SHL 2
	    0004h ???
		Return: CF clear
			DX:AX = ???
	    0005h ???
		Return: CF clear
			DX:AX = ???
	    0006h ???
		Return: CF clear
			DX:AX = ???
	    0007h ???
		Return: CF clear
			DX:AX = ???
	    0008h ???
		Return: CF clear
			DX:AX = ???
	    0009h ???
		Return: CF clear
			DX:AX = ???
	    000Ah ???
		Return: CF clear
			DX:AX = ???
	    000Bh get ???
		Return: CF clear
			DX:AX = ??? SHL 2
	    000Ch get ???
		Return: CF clear
			DX:AX = ??? SHL 2
	    000Dh get ???
		Return: CF clear
			DX:AX = ??? SHL 2
	    000Eh get ???
		Return: CF clear
			AX = ???
			DX = ???
	    000Fh get ???
		Return: CF clear
			DX:AX = ???
	    0010h get ???
		Return: CF clear
			DX:AX = ???
	    0011h get ???
		Return: CF clear
			DX:AX = ???
	    0012h get ???
		Return: CF clear
			DX:AX = ???
	    0013h get ???
		Return: CF clear
			DX:AX = ???
	    0014h get ???
		Return: CF clear
			DX:AX = ???
	    0015h get ???
		Return: CF clear
			DX:AX = ???
	    else
		Return: CF set
SeeAlso: #2354,#2356
--------W-2F1684BX357E-----------------------
INT 2F - MS Windows - DSOUND - GET API ENTRY POINT
	AX = 1684h
	BX = 357Eh (virtual device ID for DSOUND device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"
----------2F1684BX377B-----------------------
INT 2F - MS Windows - MX1501HAD - GET API ENTRY POINT
	AX = 1684h
	BX = 377Bh (virtual device ID for MX1501HAD device)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2356)
		  0000h:0000h if the VxD does not support an API
Note:	The drivers VCMD95C.VXD and VCMD.386 are part of the driver disks
	  provided with the chip-card-reader/keyboard combination MX 1501 HAD,
	  produced by Cherry
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2356)
Call CHERRY VCMD95C.VXD entry point with:
	AX = function
	    0001h get version
		Return: AX = version number (0100h) (AH = major, AL = minor)
	    0002h hook INT 09 (and 8???)
	    0003h unhook INT 09 (and 8???)
	    0004h get number of bytes in FIFO
		Return: AX = bytes in FIFO
	    0005h get next FIFO-data
		Return: AX = data
			BL = port number
			BH = direction (1=in, 0=out)
			DX:CX = timestamp
	    0006h clear FIFO
	    0007h output byte
		DX = port number
		BL = keyboard command
		Return: data in FIFO (see #2358)
		       (value, port, in/out, timestamp)
	    0008h input byte
		DX = port number
		Return: data in FIFO (see #2358)
			(value, port, in/out, timestamp)
	    0009h input byte immediately
		DX = port number
		Return: AX = data
	    000Ah read next FIFO data (nondestructive)
		Return: AX = data
			BL = port number
			BH = direction (1=in, 0=out)
			DX:CX = timestamp
	    000Bh get timestamp
		Return: DX:CX = timestamp (in ms)
	    000Ch enable IRQ 1
	    000Dh disable IRQ 1
	    000Eh enable data retrieval
		Note:	Sets a flag in the internal mode-byte which
			  tells the driver to recognize the data
	    000Fh disable data retrieval
		Note:	resets a flag in the internal mode-byte
	    0010h get retrieval mode
		Return: AX = current retrieval mode
	    0011h set retrieval mode
		BX = new retrieval mode (see #2357)
		Return: AX = old retrieval mode
	    0012h get command value
		Return: AX = command value
	    0013h set command value
		BX = command value
SeeAlso: #2354,#2359

Bitfields for retrieval mode:
Bit(s)	Description	(Table 2357)
 0	enable data retrieval
 1	0 = interrupt-driven
	1 = polling mode
 2	0 = read port 60h everytime
	1 = read port 60h only when OBF of port 64h is set
 3	0 = don't call old INT 9
	1 = call INT 9 before our INT-handler
 4-7	reserved
SeeAlso: #2356,#2358

Format of FIFO entry (1024 entries in FIFO):
Offset	Size	Description	(Table 2358)
 00h	BYTE	data byte
 01h	BYTE	I/O port
 02h	BYTE	direction (1=in, 0=out)
 03h	BYTE	reserved
 04h	DWORD	timestamp
SeeAlso: #2356,#2357
--------W-2F1684BX38DA-----------------------
INT 2F - MS Windows - VIWD - GET API ENTRY POINT
	AX = 1684h
	BX = 38DAh (virtual device ID for VIWD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2359)
		  0000h:0000h if the VxD does not support API in current mode
SeeAlso: AX=1684h"DEVICE API",INT 20"Windows"

(Table 2359)
Call VIWD.VXD entry point with:
	DX = function number
	    0000h ???
		Return: CF clear
			AX = ???
	    0004h ???
		Return: CF clear
			DX = 0000h
	    0006h
		Return: CF clear
	    000Ah
		AX = ???
		Return: CF clear if successful
			CF set on error
	    000Ch
	    000Dh
	    000Eh
		Return: CF clear
	    000Fh
		Return: CF clear
	    0010h
	    0011h
	    0015h
		Return: CF clear if successful
			    AX = ???
			CF set on error
			    AX = ???
			DX = 0000h
	    0016h
	    0017h
		Return: CF clear if successful
			    AX = ???
			CF set on error
			    AX = ???
			DX = 0000h
	    0018h ???
		CX = ???
		Return: CF clear if successful
			    AX = 0000h
			CF set on error
	    else
		Return: CF set
SeeAlso: #2356,#2360
--------W-2F1684BX4321-----------------------
INT 2F - MS Windows - POSTMSG - GET API ENTRY POINT
	AX = 1684h
	BX = 4321h (virtual device ID for POSTMSG device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2360,#2362)
		  0000h:0000h if the VxD does not support an API

(Table 2360)
Call POSTMSG protected-mode entry point with:
	AX = window handle
	CX:BX -> callback procedure (see #2361)
Return: nothing
Note:	this call registers a WinApp with the VxD; the callback must be in a
	  fixed, non-discardable code segment
SeeAlso: #2362,#2363

(Table 2361)
Values POSTMSG callback routine is called with:
	STACK:	DWORD	"lParam" parameter from DOSApp
		WORD	"wParam" parameter from DOSApp
		WORD	Windows message number (WM_USER + 100h)
		WORD	registered HWND

(Table 2362)
Call POSTMSG V86-mode entry point with:
	BX = wParam value to pass to protected-mode callback
	DX:AX = lParam value to pass to protected-mode callback
Return: CF clear if successful
	CF set on error (no WinApp registered)
SeeAlso: #2360
--------W-2F1684BX7FE0-----------------------
INT 2F - MS Windows - VSWITCHD - GET API ENTRY POINT
	AX = 1684h
	BX = 7FE0h (virtual device ID for VSWITCHD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2363)
		  0000h:0000h if the VxD does not support an API

(Table 2363)
Call VSWITCHD entry point with:
	AX = function
	    0000h toggle windowed mode (simulate Alt-Enter keypress)
		Return: nothing
	    0001h get windowed mode
		Return: CF clear if VM is windowed
			CF set if VM is full-screen
SeeAlso: #2360,#2364
--------W-2F1684BX8888-----------------------
INT 2F - MS Windows - VbillD - GET API ENTRY POINT
	AX = 1684h
	BX = 8888h (virtual device ID for VbillD device) (see #2290)
	ES:DI = 0000h:0000h
Return: ES:DI -> VxD API entry point (see #2364)
		  0000h:0000h if the VxD does not support an API

(Table 2364)
Call VbillD entry point with:
	AX = function
	    0001h set reverse video
	    0002h set normal video
Return: ???
SeeAlso: #2363
--------W-2F1685-----------------------------
INT 2F - MS Windows - SWITCH VMs AND CALLBACK
	AX = 1685h
	BX = VM ID of virtual machine to switch to
	CX = flags (see #2365)
	DX:SI = priority boost (refer to VMM.INC)
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
SeeAlso: AX=1683h,INT 15/AX=1117h,AX=DB06h"WINGO"

Bitfields for VM switching flags:
Bit(s)	Description	(Table 2365)
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
	    ES:DI -> DPMI mode-switch entry point (see #2366)
	AX nonzero if not installed
SeeAlso: AX=1686h,AX=43E0h,AX=DE01h/BX=4450h,AX=FB42h/BX=0001h
SeeAlso: INT 31/AX=0400h,INT 31/AX=5702h,INT D4/AH=10h

(Table 2366)
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
--------W-2F1688BX0BAD-----------------------
INT 2F U - MS Windows 3.0, 386MAX v6.01 - GET ALIAS SELECTOR TO LDT
	AX = 1688h
	BX = 0BADh
Return: AX = 0000h if supported
	    BX = alias selector for LDT
Note:	use the LSL instruction or GetSelectorLimit() to find LDT size
	this call should be considered obsolete for Windows 3.1+, as the
	  alias selector can be retrieved via the API entry point for
	  "MS-DOS" retrieved from INT 2F/AX=168Ah (see #2368)
SeeAlso: AX=1687h,#2368
--------W-2F1689-----------------------------
INT 2F U - MS Windows 3.0+ - KERNEL IDLE CALL
	AX = 1689h
	???
Return: ???
Desc:	the Windows KERNEL idle loop calls this function, which VMM uses as an
	  indication that the system is idle, which in turn generates INT 28
	  and INT 2F/AX=1607h/BX=0018h callouts
SeeAlso: AX=1680h,AX=1607h/BX=0018h,INT 15/AX=1000h,INT 28
--------E-2F168A-----------------------------
INT 2F - DPMI 0.9+ - GET VENDOR-SPECIFIC API ENTRY POINT
	AX = 168Ah
	DS:(E)SI = selector:offset of ASCIZ vendor name (see #2367)
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
SeeAlso: AX=1687h,INT 31/AX=0A00h,INT 31/AH=57h

(Table 2367)
Values for DPMI vendor-specific API names:
 "MS-DOS"	MS Windows and 386MAX v6.00+ (see #2368)
 "386MAX"	386MAX v6.00+
 "HELIX_DPMI"	Helix Netroom's DPMI server
 "Phar Lap"	Phar Lap 286|DOS-Extender RUN286 (see #2369)
 "RATIONAL DOS/4G"  DOS/4G, DOS/4GW
 "VIRTUAL SUPPORT"  Borland 32RTM

(Table 2368)
Call Windows-support ("MS-DOS") entry point with:
	AX = 0100h get LDT alias selector
Return: CF clear if successful
	    AX = alias selector
	CF set on error
SeeAlso: #2367,AX=1688h/BX=0BADh

(Table 2369)
Call Phar Lap RUN286 entry point with:
	AX = 0000h (function "load MSW")
	BX = new value for MSW register (low word of CR0)
Return: ???
SeeAlso: #2367
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
--------W-2F168EDX0000-----------------------
INT 2F - Windows95 - TITLE - SET APPLICATION TITLE
	AX = 168Eh
	DX = 0000h
	ES:DI -> ASCIZ application title (max 79 chars+NUL)
Return: AX = status
	    0000h failed
	    0001h successful
Note:	if ES:DI is 0000h:0000h or points at an empty string, the current
	  title is removed
BUG:	this function can return a successful status even though the title was
	  not changed; reportedly, waiting for two clock ticks after program
	  startup solves this problem
SeeAlso: AX=168Eh/DX=0001h,AX=168Eh/DX=0002h
--------W-2F168EDX0001-----------------------
INT 2F - Windows95 - TITLE - SET VIRTUAL MACHINE TITLE
	AX = 168Eh
	DX = 0001h
	ES:DI -> ASCIZ virtual machine title (max 29 chars+NUL)
Return: AX = status
	    0000h failed
	    0001h successful
Notes:	if ES:DI is 0000h:0000h or points at an empty string, the current
	  title is removed
	the VM title should only be changed on explicit instruction from the
	  user
BUG:	this function can return a successful status even though the title was
	  not changed; reportedly, waiting for two clock ticks after program
	  startup solves this problem
SeeAlso: AX=168Eh/DX=0000h,AX=168Eh/DX=0003h
--------W-2F168EDX0002-----------------------
INT 2F - Windows95 - TITLE - GET APPLICATION TITLE
	AX = 168Eh
	DX = 0002h
	ES:DI -> buffer for ASCIZ application title
	CX = size of buffer in bytes
Return: AX = status
	    0000h failed
	    0001h successful
Desc:	copy as much of the application's window title as possible to the given
	  buffer, appending a terminating NUL to the buffer
SeeAlso: AX=168Eh/DX=0000h,AX=168Eh/DX=0003h
--------W-2F168EDX0003-----------------------
INT 2F - Windows95 - TITLE - GET VIRTUAL MACHINE TITLE
	AX = 168Eh
	DX = 0003h
	ES:DI -> buffer for ASCIZ virtual-machine title
	CX = size of buffer in bytes
Return: AX = status
	    0000h failed
	    0001h successful
Desc:	copy as much of the virtual machine's title as possible to the given
	  buffer, appending a terminating NUL to the buffer
SeeAlso: AX=168Eh/DX=0001h,AX=168Eh/DX=0002h
--------W-2F168FDH00-------------------------
INT 2F - Windows95 - CLOSE-AWARENESS - ENABLE/DISABLE CLOSE COMMAND
	AX = 168Fh
	DH = 00h
	DL = new state
	    00h disabled
	    01h enabled
Return: AX = status
	    0000h successful
	    else failed
Desc:	enable or disable the system menu Close command for an application
SeeAlso: AX=168Fh/DH=01h,AX=168Fh/DH=02h
--------W-2F168FDH01-------------------------
INT 2F - Windows95 - CLOSE-AWARENESS - QUERY CLOSE
	AX = 168Fh
	DH = 01h
	DL = 00h (reserved)
Return: AX = status
	    0000h Close command selected but not yet acknowledged
	    0001h Close command issued and acknowledged
	    168Fh Close command not selected -- application should continue
Desc:	determine whether the user has requested that the application be closed
	  by selecting the system menu's Close option
SeeAlso: AX=168Fh/DH=00h,AX=168Fh/DH=02h
--------W-2F168FDH02-------------------------
INT 2F - Windows95 - CLOSE-AWARENESS - ACKNOWLEDGE CLOSE
	AX = 168Fh
	DH = 02h
	DL = 00h (reserved)
Return: AX = status
	    0000h successful
	    else failed
Note:	once a Close command has been issued, no further keyboard input is
	  available to the application until it calls this function to
	  acknowledge the Close request
SeeAlso: AX=168Fh/DH=00h,AX=168Fh/DH=03h
--------W-2F168FDH03-------------------------
INT 2F - Windows95 - CLOSE-AWARENESS - CANCEL CLOSE
	AX = 168Fh
	DH = 03h
	DL = 00h (reserved)
Return: AX = status
	    0000h successful
	    else failed
Desc:	cancels a close request which has already been acknowledged if the
	  application determines that it will not exit at this time
SeeAlso: AX=168Fh/DH=00h,AX=168Fh/DH=03h
--------D-2F1690-----------------------------
INT 2F U - MS-DOS 7 kernel - GET/SET ???
	AX = 1690h
	ES:BX -> ???
Return: ES:BX -> ??? data (see #2370)
SeeAlso: AX=1611h,AX=1614h

Format of MS-DOS 7 kernel ??? data:
Offset	Size	Description	(Table 2370)
 00h	DWORD	-> ??? data (appears to list the installed drivers)
 04h	DWORD	-> ??? (value passed in via ES:BX is stored here)
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
SeeAlso: AX=1700h,AX=1702h,AX=1703h,AX=1704h,INT 16/AX=CB00h
--------W-2F1702-----------------------------
INT 2F - MS Windows "WINOLDAP" - EMPTY CLIPBOARD
	AX = 1702h
Return: AX = status
	    nonzero clipboard has been emptied
	    0000h   failure
SeeAlso: AX=1700h,AX=1701h,AX=1703h,AX=1704h,INT 16/AX=CB05h
--------W-2F1703-----------------------------
INT 2F - MS Windows "WINOLDAP" - SET CLIPBOARD DATA
	AX = 1703h
	DX = clipboard format supported by WinOldAp (see #2371)
	ES:BX -> data (see #2372,#2373)
	SI:CX = size of data
Return: AX = status
	    nonzero data copied into the Clipboard
	    0000h   failure
SeeAlso: AX=1701h,AX=1705h,INT 16/AX=CB04h

(Table 2371)
Values for WinOldAp clipboard format:
 01h	text
 02h	bitmap
 03h	metafile picture
 04h	SYLK
 05h	DIF
 06h	TIFF
 07h	OEM text
 08h	DIB bitmap
 80h	special format (used by Windows WRITE, maybe other Windows applets???)
 81h	DSP text
 82h	DSP bitmap

Format of Windows Clipboard bitmap:
Offset	Size	Description	(Table 2372)
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
Offset	Size	Description	(Table 2373)
 00h	WORD	mapping mode
 02h	WORD	X extent
 04h	WORD	Y extent
 06h	WORD	picture data
--------W-2F1704-----------------------------
INT 2F - MS Windows "WINOLDAP" - GET CLIPBOARD DATA SIZE
	AX = 1704h
	DX = clipboard format supported by WinOldAp (see #2371)
Return: DX:AX = size of data in bytes, including any headers
		0000h:0000h if no data in this format in the Clipboard
Note:	Windows reportedly rounds up the size of the data to a multiple of 32
	  bytes
SeeAlso: AX=1700h,AX=1703h,AX=1705h
--------W-2F1705-----------------------------
INT 2F - MS Windows "WINOLDAP" - GET CLIPBOARD DATA
	AX = 1705h
	DX = clipboard format supported by WinOldAp (see #2371)
	ES:BX -> buffer
Return: AX = status
	    nonzero success
	    0000h   error, or no data in this format in Clipboard
SeeAlso: AX=1700h,AX=1704h,INT 16/AX=CB03h
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
	DX = GDI information index (see #2374)
Return: AX = integer value of the desired item
	      (see #2375,#2376,#2377,#2378,#2379,#2380,#2381)
Note:	This function returns the device-capability bits for the given display

(Table 2374)
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
SeeAlso: #2375,#2376,#2377,#2378,#2379,#2380,#2381

(Table 2375)
Values for device classification:
 00h	vector plotter
 01h	raster display
 02h	raster printer
 03h	raster camera
 04h	character-stream, PLP
 05h	Metafile, VDM
 06h	display-file
SeeAlso: #2374,#2376,#2377,#2378,#2379,#2380,#2381

Bitfields for curve capabilities:
Bit(s)	Description	(Table 2376)
 0	circles
 1	pie wedges
 2	chord arcs
 3	ellipses
 4	wide lines
 5	styled lines
 6	wide styled lines
 7	interiors
SeeAlso: #2374,#2375,#2377,#2378,#2379,#2380,#2381

Bitfields for line capabilities:
Bit(s)	Description	(Table 2377)
 1	polylines
 2	markers
 3	polymarkers
 4	wide lines
 5	styled lines
 6	wide styled lines
 7	interiors
SeeAlso: #2374,#2375,#2376,#2378,#2379,#2380,#2381

Bitfields for polygon capabilities:
Bit(s)	Description	(Table 2378)
 0	polygons
 1	rectangles
 2	trapezoids
 3	scanlines
 4	wide borders
 5	styled borders
 6	wide styled borders
 7	interiors
SeeAlso: #2374,#2375,#2376,#2377,#2379,#2380,#2381

Bitfields for text capabilities:
Bit(s)	Description	(Table 2379)
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
SeeAlso: #2374,#2375,#2376,#2377,#2378,#2380,#2381

(Table 2380)
Values for clipping capabilities:
 00h	none
 01h	clipping to rectangles
SeeAlso: #2374,#2375,#2376,#2377,#2378,#2379,#2381

Bitfields for raster capabilities:
Bit(s)	Description	(Table 2381)
 0	simple bitBLT
 1	device requires banding support
 2	device requires scaling support
 3	supports >64K bitmap
SeeAlso: #2374,#2375,#2376,#2377,#2378,#2379,#2380
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
----------2F1980-----------------------------
INT 2F U - IBM ROM-DOS v4.0 - INSTALLATION CHECK
	AX = 1980h
Return: AL = FFh if ??? installed/supported
Note:	called at the very beginning of SHELLSTB.COM, which exits if AL is not
	  FFh on return
SeeAlso: AX=1981h,AX=1982h
----------2F1981-----------------------------
INT 2F U - IBM ROM-DOS v4.0 - GET ??? STRING
	AX = 1981h
	DS:DX -> buffer for ???
Return: AL = status
	    FFh if successful
		DS:DX buffer filled (refer to note below)
	    81h on error
Note:	the first byte of the buffer is unchanged; depending on a byte in
	  IBMBIO.COM, the remainder of the buffer is filled with either
	  "C:\ROMSHELL.COM",0Dh or xxh,xxh,0Fh,"C:\ROMSHELL.COM",0Dh
SeeAlso: AX=1980h,AX=1982h
----------2F1982-----------------------------
INT 2F U - IBM ROM-DOS v4.0 - GET ??? TABLE
	AX = 1982h
Return: AL = FFh if supported
	    ES:DI -> ??? table (see #2382)
Note:	called by ROMSHELL.COM
SeeAlso: AX=1980h,AX=1981h

Format of ROM-DOS v4.0 ??? table:
Offset	Size	Description	(Table 2382)
 00h	BYTE	??? (00h)
 01h	BYTE	??? (41h) (ROMSHELL.COM checks if =00h)
 02h	BYTE	??? (00h) (ROMSHELL.COM checks if =01h)
 03h	WORD	??? (0001h) (ROMSHELL.COM checks if =0001h)
 05h	BYTE	??? (00h)
 06h	WORD	??? (04D5h)
--------V-2F1A00-----------------------------
INT 2F - DOS 4.0+ ANSI.SYS - INSTALLATION CHECK
	AX = 1A00h
Return: AL = FFh if installed
Notes:	AVATAR.SYS also responds to this call
	documented for DOS 5+, but undocumented for DOS 4.x
--------V-2F1A00BX414E-----------------------
INT 2F - ANSIPLUS.SYS v2.00+ - INSTALLATION CHECK
	AX = 1A00h
	BX = 414Eh ('AN')
	CX = 5349h ('SI')
	DX = 2B2Bh ('++')
Return: AL = FFh if installed
	    CF clear
	    ES:BX -> INT 29 entry point
	    CX = ANSIPLUS BCD version number (v3.10+, CH=major, CL=minor)
	    DL = capabilities (v4.00+)
		00h full capability driver
		01h reduced capability driver
		2Bh full capability driver (before v4.00)
Program: ANSIPLUS.SYS is a CON device driver by Kristofer Sweger which
	  replaces the normal ANSI.SYS with a more powerful version having
	  many additional features
Notes:	ANSIPLUS also identifies itself as ANSI.SYS if BX,CX, or DX differ
	  from the magic values above
	an additional installation check is to test for the signature
	  "ANSIPLUS" 12 bytes before the INT 29 entry point; the version
	  number is also available as a four-character ASCII string (e.g.
	  "4.00") four bytes before the entry point
SeeAlso: AX=1AA5h,AX=1AA6h,AX=1AA7h,AX=1AA8h,AX=1AA9h,AX=1AAAh,AX=D44Fh
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
SeeAlso: AX=1A21h,AX=1A3Ch,AX=1A3Fh,AX=1A52h,AX=1A72h,AX=1A7Dh,AX=1AADh"AVATAR"
--------V-2F1A01-----------------------------
INT 2F U - DOS 4.0+ ANSI.SYS internal - GET/SET DISPLAY INFORMATION
	AX = 1A01h
	CL = function
	    7Fh for GET
	    5Fh for SET
	DS:DX -> parm block as for INT 21,AX=440Ch,CX=037Fh/035Fh respectively
Return: CF clear if successful
	    AX destroyed
	CF set on error
	    AX = error code (many non-standard)
Note:	presumably this is the DOS IOCTL interface to ANSI.SYS
SeeAlso: AX=1A02h,INT 21/AX=440Ch
--------V-2F1A02-----------------------------
INT 2F U - DOS 4.0+ ANSI.SYS internal - MISCELLANEOUS REQUESTS
	AX = 1A02h
	DS:DX -> parameter block (see #2383)
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	DOS 5+ chains to previous handler if AL > 02h on call
SeeAlso: AX=1A01h

Format of ANSI.SYS parameter block:
Offset	Size	Description	(Table 2383)
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
	DS:SI -> command string with one or more state characters (see #2384)
	CX = length of command string
Return: CF set on error (invalid subfunction)
	CF clear if successful
Note:	the characters in the state string are interpreted left to right, and
	  need not be in any particular order
SeeAlso: AX=1A00h/BX=4156h,AX=1A3Fh

(Table 2384)
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
SeeAlso: AX=1A00h/BX=4156h,AX=1A21h,AX=1A3Eh
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
SeeAlso: AX=1A3Ch,AX=1A3Fh
--------V-2F1A3F-----------------------------
INT 2F - AVATAR.SYS - QUERY DRIVER STATE
	AX = 1A3Fh (AL='?')
	ES:DI -> buffer
	CX = length of buffer in bytes
Return: CF clear
	CX = actual size of returned info
Note:	the returned information consists of multiple letters whose meanings
	  are described under AX=1A21h
SeeAlso: AX=1A00h/BX=4156h,AX=1A21h,AX=1A44h
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
SeeAlso: AX=1A21h,AX=1A3Fh,AX=1A52h
--------V-2F1A52-----------------------------
INT 2F U - AVATAR.SYS v0.11 - GET ???
	AX = 1A52h
	CX = size of buffer
	ES:DI -> buffer
Return: ??? copied into user buffer
Note:	the maximum size of the data which may be copied is returned by
	  AX=1A72h
SeeAlso: AX=1A53h,AX=1A72h
--------V-2F1A53-----------------------------
INT 2F U - AVATAR.SYS v0.11 - ???
	AX = 1A53h
	CL = ??? (00h-05h)
	???
Return: ???
SeeAlso: AX=1A00h/BX=4156h,AX=1A52h,AX=1A72h
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
SeeAlso: AX=1A00h/BX=4156h,AX=1A52h,AX=1A7Bh,AX=1AADh"AVATAR"
--------V-2F1A7B-----------------------------
INT 2F U - AVATAR.SYS v0.11 - ???
	AX = 1A7Bh
Return: AX = 0000h
	CX = 0000h
SeeAlso: AX=1A00h/BX=4156h,AX=1A72h,AX=1A7Dh
--------V-2F1A7D-----------------------------
INT 2F U - AVATAR.SYS v0.11 - ???
	AX = 1A7Dh
Return: AX = ???
SeeAlso: AX=1A00h/BX=4156h,AX=1A7Bh
--------V-2F1AA3-----------------------------
INT 2F - ANSIPLUS v4.03+ - GET/SET ANSIPLUS INTERNAL VARIABLES
	AX = 1AA3h
	BH = function
	    00h get current/default colors
		Return: CH = default colors
			CL = current colors
	    01h set current/default colors
		CH = default colors (00h = leave unchanged)
		CL = current colors
	    02h get current subscreen region
		Return: BH,BL = true screen rows,columns
			CH,CL = top left row,column of region
			DH,DL = bottom right row,column of region
	    03h set subscreen region
		CH,CL = top left row,column of region
		DH,DL = bottom right row,column of region
	    04h get driver features (bits 0-31)
		Return: DX:CX = current feature bits
	    05h set driver features (bits 0-31)
		DX:CX = feature bits
	    06h get driver features (bits 32-63)
		Return: DX:CX = current feature bits
	    07h set driver features (bits 32-63)
		DX:CX = feature bits
	    other: reserved for future use
SeeAlso: AX=1AA4h,AX=1AA5h
--------V-2F1AA4-----------------------------
INT 2F - ANSIPLUS v4.02+ - GET/SET ANSIPLUS SMOOTH SCROLLING RATE
	AX = 1AA4h
	BL = function
	    00h get scrolling rate
	    01h set scrolling rate
		BH = new minimum scrolling rate in scan lines per retrace
Return: BH = smooth scrolling rate
SeeAlso: AX=1AA3h,AX=1AA5h
--------V-2F1AA5-----------------------------
INT 2F - ANSIPLUS v4.00+ - GET/SET ANSIPLUS CLIPBOARD
	AX = 1AA5h
	DH = subfunction
	    00h get clipboard information
	    01h get clipboard text
	    02h set clipboard text
	    03h append text to clipboard
	    04h clear clipboard
	    05h paste clipboard to keyboard
	ES:BX -> data area for subfunctions 01h, 02h, and 03h
	CX = size of data area (maximum size for subfunction 01h, actual size
	    to add to clipboard for subfunctions 02h and 03h)
Return: AL = status
	    00h successful
	    01h unsupported subfunction (reduced capability driver)
	    02h insufficient space
	    A5h unsupported function (ANSIPLUS before v4.00)
	ES:BX -> ANSIPLUS local clipboard data
	CX = number of bytes currently in local clipboard
	DX = maximum size of local clipboard
SeeAlso: AX=1A00h/BX=414Eh,AX=1AA4h,AX=1AA6h
--------V-2F1AA6-----------------------------
INT 2F - ANSIPLUS v4.00+ - ENABLE/DISABLE ANSIPLUS DRIVER
	AX = 1AA6h
	BH = function
	    00h get hooked interrupts
	    01h set hooked interrupts mask
		BL = new interrupts mask (see #2385)
Return: BL = previous interrupts mask (see #2385)
SeeAlso: AX=1A00h/BX=414Eh,AX=1AA7h

Desc:	used to temporarily disable any prior copies of ANSIPLUS when a new
	  copy is installed, such as in a multitasking system like DESQview
Note:	only the most-recently loaded copy of ANSIPLUS on the current INT 2F
	  chain responds to this call

Bitfields for ANSIPLUS hooked interrupts mask:
Bit(s)	Description	(Table 2385)
 0	INT 09 hook disabled
 1	INT 10 hook disabled
 2	INT 15 hook disabled
 3	INT 16 hook disabled
 4	INT 1C hook disabled
 5	reset all bits when INT 29 called
 6	INT 29 hook disabled
 7	INT 33, INT 74, or other mouse event hook disabled
--------V-2F1AA7-----------------------------
INT 2F - ANSIPLUS v4.00+ - ENABLE/DISABLE ANSIPLUS FEATURES
	AX = 1AA7h
	BL = function
	    00h prevent scroll-back saves
	    01h enable scroll-back saves
	    02h disable key reprogramming and lock changes by escape sequences
	    03h enable key reprogramming by escape sequences
	    04h	disable and lock key stacking changes by escape sequences
	    05h allow key stacking by escape sequences
Return: nothing
SeeAlso: AX=1AA6h
--------V-2F1AA8-----------------------------
INT 2F - ANSIPLUS v3.10+ - GET NEXT ANSIPLUS SCROLLBACK LINE
	AX = 1AA8h
Return: AL = status
	    00h successful
		ES:BX -> screen line (character and attribute pairs)
		CX = length of line in bytes, 0000h if no more lines or
		      unsupported video mode
	    01h unsupported video mode active
	    02h screen currently scrolled back
	    03h reduced capability driver
	    A8h unsupported function (driver before v3.10)
SeeAlso: AX=1A00h/BX=414Eh,AX=1AA9h
--------V-2F1AA9-----------------------------
INT 2F - ANSIPLUS v3.10+ - GET ANSIPLUS SCROLLBACK INFORMATION
	AX = 1AA9h
Return: AL = status
	    00h successful
		BX = current number of lines in scrollback buffer
		CX = number of bytes in one line
	    01h unsupported video mode active
	    02h screen currently scrolled back
	    03h reduced capability driver
	    A9h unsupported function (driver before v3.10)
Desc:	determine how much data is in the scrollback buffer and initialize
	  scrollback retrieval to return the first line on the next call to
	  AX=1AA8h
SeeAlso: AX=1A00h/BX=414Eh,AX=1AA8h
--------V-2F1AAA-----------------------------
INT 2F - ANSIPLUS v3.01+ - GET/SET ANSIPLUS SCREEN SAVER BLANKING TIME
	AX = 1AAAh
	BX = function
	    FFFFh to get current blanking time
	    other to set time
		CX = blanking time in clock ticks (0000h-7FFFh)
Return: BX = current blanking time
	CX = blanking time when last set
SeeAlso: AX=1A00h/BX=414Eh,AX=1AABh
--------V-2F1AAB-----------------------------
INT 2F - ANSIPLUS v3.01+ - SET ANSIPLUS KEY REPEAT RATE
	AX = 1AABh
	BX = repeat rate in characters per second
	    0000h use BIOS repeat rate
Return: nothing
SeeAlso: AX=1A00h/BX=414Eh,AX=1AAAh,AX=1AACh
--------V-2F1AAC-----------------------------
INT 2F - ANSIPLUS v3.00+ - LOAD CHARACTER GENERATOR
	AX = 1AACh
	BH = number of bytes per character pattern
	BL = VGA/EGA character table to be loaded
	CX = number of characters to load
	DX = starting character code (offset into Map2 block)
	ES:BP -> user character table to be loaded
Return: AX = 1100h
Desc:	load the EGA/VGA character generator without the BIOS function's
	  side effects of resetting the video mode and color palette
SeeAlso: AX=1A00h/BX=414Eh,AX=1AABh,AX=1AADh"ANSIPLUS",INT 10/AX=1100h
--------V-2F1AAD-----------------------------
INT 2F - ANSIPLUS v2.00+ - ANSIPLUS DEVICE STATUS REPORT
	AX = 1AADh
	BL = report request code (81h-96h for v4.00)
	CX = color selector or key code, if required by request
Return: AX = first reported result
	BX = second result
	CX = third result, if applicable (unchanged otherwise)
	DX = fourth result, if applicable (unchanged otherwise)
Desc:	get device status reports equivalent to those for Esc [#n sequences
	  while bypassing any device redirection and avoiding the need to
	  parse the returned result
Note:	the report request code in BL is identical to the number in the
	  corresponding Esc [#n sequence
SeeAlso: AX=1A00h/BX=414Eh,AX=1AACh
--------V-2F1AADDX0000-----------------------
INT 2F U - AVATAR.SYS v0.11 - ???
	AX = 1AADh
	DX = 0000h
	CX = subfunction (00h-0Ch)
	???
Return: AX = 0000h if DX was nonzero
	???
SeeAlso: AX=1A00h/BX=4156h,AX=1A72h
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
INT 2F - DR DOS 5.0 GRAFTABL - INSTALLATION CHECK
	AX = 2300h
Return: AH = FFh
Note:	this installation check does not follow the usual format
SeeAlso: AH=23h,AX=2E00h
--------V-2F23-------------------------------
INT 2F - DR DOS 5.0 GRAFTABL - GET GRAPHICS DATA
	AH = 23h
	AL nonzero
Return: AH = FFh
	ES:BX -> graphics data (8 bytes for each character from 80h to FFh)
SeeAlso: AX=2300h,AX=2E00h
--------!---Section--------------------------
