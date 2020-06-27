Interrupt List, part 7 of 16
Copyright (c) 1989,1990,1991,1992,1993,1994,1995,1996,1997 Ralf Brown
--------D-215F00-----------------------------
INT 21 - DOS 3.1+ network - GET REDIRECTION MODE
	AX = 5F00h
	BL = redirection type
	    03h printer
	    04h disk drive
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
	    BH = redirection state
		00h off
		01h on
Note:	calls INT 2F/AX=111Eh with AX on top of the stack
SeeAlso: AX=5F01h,INT 2F/AX=111Eh
--------D-215F01-----------------------------
INT 21 - DOS 3.1+ network - SET REDIRECTION MODE
	AX = 5F01h
	BL = redirection type
	    03h printer
	    04h disk drive
	BH = redirection state
	    00h off
	    01h on
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
Notes:	when redirection is off, the local device (if any) rather than the
	  remote device is used
	calls INT 2F/AX=111Eh with AX on top of the stack
SeeAlso: AX=5F00h,INT 2F/AX=111Eh,INT 60/AX=0002h
--------D-215F02-----------------------------
INT 21 - DOS 3.1+ network - GET REDIRECTION LIST ENTRY
	AX = 5F02h
	BX = zero-based redirection list index
	CX = driver signature
	    0000h LANtastic
	    4E57h ('NW') NetWare
	DS:SI -> 16-byte buffer for ASCIZ local device name or drive letter
		  followed by colon
	ES:DI -> 128-byte buffer for ASCIZ network name
Return: CF clear if successful
	    BH = device status
		00h valid
		01h invalid
		02h valid (connected from inside Windows for Workgroups v3.11)
	    BL = device type
		03h printer
		04h disk drive
	    CX = user data previously set with AX=5F03h
	    DS:SI and ES:DI buffers filled
	    DX,BP destroyed
	CF set on error
	    AX = error code (01h,12h) (see #1332 at AH=59h/BX=0000h)
Notes:	this function is passed through to INT 2F/AX=111Eh by the DOS kernel
	error code 12h is returned if BX is greater than the size of the list
	also supported by Banyan VINES, PC-NFS, LANtastic, and 10NET
	supported by LapLink RemoteAccess but returns the local drive letter;
	  the remote drive letter can be obtained with INT 2F/AX=Cxxxh
	  (see INT 2F/AX=C000h"LapLink")
	the returned device name may or may not include a colon, depending on
	  the network software
SeeAlso: AX=5F03h,AX=5F46h,INT 2F/AX=111Eh,INT 2F/AX=C000h"LapLink"
--------D-215F03-----------------------------
INT 21 - DOS 3.1+ network - REDIRECT DEVICE
	AX = 5F03h
	BL = device type
	    03h printer
	    04h disk drive
	CX = user data to save
		0000h for LANtastic
		4E57h ("NW") for NetWare 4.0 requester
	DS:SI -> ASCIZ local device name (16 bytes max)
	ES:DI -> ASCIZ network name + ASCIZ password (128 bytes max total)
Return: CF clear if successful
	CF set on error
	    AX = error code (01h,03h,05h,08h,0Fh,12h) (see #1332 at AH=59h)
Notes:	if device type is disk drive, DS:SI must point at either a null string
	  or a string consisting the drive letter followed by a colon; if a
	  null string, the network attempts to access the destination without
	  redirecting a local drive
	the DOS kernel calls INT 2F/AX=111Eh with AX on top of the stack
	also supported by Banyan VINES, LANtastic, and 10NET
SeeAlso: AX=5F02h,AX=5F04h,INT 2F/AX=111Eh,INT 60/AX=0002h
--------D-215F04-----------------------------
INT 21 - DOS 3.1+ network - CANCEL REDIRECTION
	AX = 5F04h
	DS:SI -> ASCIZ local device name or path
	CX = 4E57h ("NW") for NetWare 4.0 requester
Return: CF clear if successful
	CF set on error
	    AX = error code (01h,03h,05h,08h,0Fh,12h) (see #1332 at AH=59h)
Notes:	the DS:SI string must be either a local device name, a drive letter
	  followed by a colon, or a network directory beginning with two
	  backslashes
	the DOS kernel calls INT 2F/AX=111Eh with AX on top of the stack
	also supported by Banyan VINES, LANtastic, and 10NET
	for NetWare, if only a server name is specified (i.e. "\\SERVER"),
	  the connection to that server will be closed
SeeAlso: AX=5F03h,INT 2F/AX=111Eh,INT 60/AX=0003h
--------D-215F05-----------------------------
INT 21 - DOS 4.0+ network - GET EXTENDED REDIRECTION LIST ENTRY
	AX = 5F05h
	BX = redirection list index
	DS:SI -> buffer for ASCIZ source device name
	ES:DI -> buffer for destination ASCIZ network path
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
	    AX = server's network process ID handle (10NET)
	    BH = device status flag (bit 0 clear if valid)
	    BL = device type (03h if printer, 04h if drive)
	    CX = stored parameter value (user data) from AX=5F03h
	    BP = NETBIOS local session number
	    DS:SI buffer filled
	    ES:DI buffer filled
Notes:	the local session number allows sharing the redirector's session number
	if an error is caused on the NETBIOS LSN, the redirector may be unable
	  to correctly recover from errors
	the DOS kernel calls INT 2F/AX=111Eh with AX on top of the stack
	supported by DR DOS 5.0
	also supported by 10NET v5.0
SeeAlso: AX=5F06h"Network",INT 2F/AX=111Eh
--------O-215F05-----------------------------
INT 21 - STARLITE architecture - MAP LOCAL DRIVE LETTER TO REMOTE FILE SYSTEM
	AX = 5F05h
	DL = drive number (0=A:)
	DS:SI -> ASCIZ name of the object to map the drive to
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
SeeAlso: AX=5F06h"STARLITE",INT 60/AX=0002h
--------N-215F06-----------------------------
INT 21 U - Network - GET FULL REDIRECTION LIST
	AX = 5F06h
	???
Return: ???
Notes:	similar to AX=5F02h and AX=5F05h, but also returns redirections
	  excluded from those calls for various reasons
	calls INT 2F/AX=111Eh with AX on top of the stack
SeeAlso: AX=5F05h"DOS",INT 2F/AX=111Eh
--------O-215F06-----------------------------
INT 21 - STARLITE architecture - UNMAP DRIVE LETTER
	AX = 5F06h
	DL = drive to be unmapped (0=A:)
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
SeeAlso: AX=5F05h"STARLITE",INT 60/AX=0003h
--------D-215F07-----------------------------
INT 21 - DOS 5+ - ENABLE DRIVE
	AX = 5F07h
	DL = drive number (0=A:)
Return: CF clear if successful
	CF set on error
	    AX = error code (0Fh) (see #1332 at AH=59h/BX=0000h)
Notes:	simply sets the "valid" bit in the drive's CDS
	this function is not supported by Novell DOS 7 through at least
	  Update 4, but support was added by Update 13
SeeAlso: AH=52h,AX=5F08h"DOS"
--------O-215F07-----------------------------
INT 21 - STARLITE architecture - MAKE NAMED OBJECT AVAILABLE ON NETWORK
	AX = 5F07h
	DS:SI -> ASCIZ name of object to offer to network
	ES:DI -> ASCIZ name under which object will be known on the network
		MUST begin with three slashes
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
SeeAlso: AX=5F08h"STARLITE"
--------D-215F08-----------------------------
INT 21 - DOS 5+ - DISABLE DRIVE
	AX = 5F08h
	DL = drive number (0=A:)
Return: CF clear if successful
	CF set on error
	    AX = error code (0Fh) (see #1332 at AH=59h/BX=0000h)
Notes:	simply clears the "valid" bit in the drive's CDS
	this function is not supported by Novell DOS 7 through at least
	  Update 4, but support was added by Update 13
SeeAlso: AH=52h,AX=5F07h"DOS"
--------O-215F08-----------------------------
INT 21 - STARLITE architecture - REMOVE GLOBAL NETWORK NAME OF OBJECT
	AX = 5F08h
	DS:SI -> ASCIZ network name (not local name) of object to unshare
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
SeeAlso: AX=5F07h"STARLITE"
--------O-215F09-----------------------------
INT 21 - STARLITE architecture - BIND TO NETWORK DEVICE
	AX = 5F09h
	DS:DX -> ASCIZ name of the device driver to attach to
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
Note:	the STARLITE distributed file system can attach to multiple networks
	  simultaneously
SeeAlso: AX=5F0Ah
--------O-215F0A-----------------------------
INT 21 - STARLITE architecture - DETACH FROM NETWORK DEVICE
	AX = 5F0Ah
	DS:DX -> ASCIZ name of device driver to detach from
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
SeeAlso: AX=5F09h
--------N-215F30-----------------------------
INT 21 U - LAN Manager Enhanced DOS - GET REDIRECTOR VERSION
	AX = 5F30h
Return: AX = version (AH=major,AL=minor)
--------N-215F32-----------------------------
INT 21 u - Named Pipes - LOCAL DosQNmPipeInfo
	AX = 5F32h
	BX = handle
	CX = size of _PIPEINFO structure
	DX = level (must be 0001h)
	DS:SI -> _PIPEINFO structure (see #1353)
Return: CF clear if successful
	    _PIPEINFO structure filled in
	CF set on error
	    AX = error code
Note:	this function was introduced by LAN Manager but is also supported by
	  the Novell DOS Named Pipe Extender, Banyan VINES, OS/2 Virtual DOS
	  Machines, and others
SeeAlso: AX=5F33h,AX=5F34h

Format of Named Pipes _PIPEINFO structure:
Offset	Size	Description	(Table 1353)
 00h	WORD	size of outgoing buffer
 02h	WORD	size of incoming buffer
 04h	BYTE	maximum number of instances allowed
 05h	BYTE	current number of instances
 06h	BYTE	length of the name (including terminating NUL)
 07h  N BYTEs	name
--------N-215F33-----------------------------
INT 21 u - Named Pipes - LOCAL DosQNmPHandState
	AX = 5F33h
	BX = handle
Return: CF clear if successful
	    AH = pipe mode bit mask (see #1354)
	    AL = maximum number of instances
	CF set on error
	    AX = error code
Note:	this function was introduced by LAN Manager but is also supported by
	  the Novell DOS Named Pipe Extender, Banyan VINES, OS/2 Virtual DOS
	  Machines, and others
SeeAlso: AX=5F32h,AX=5F34h

Bitfields for Named Pipes pipe mode:
Bit(s)	Description	(Table 1354)
 7	set if nonblocking, clear if blocking
 6	set if server end, clear if client end
 2	set if write in message mode, clear if write in byte mode
 0	set if read in message mode, clear if read in byte mode
--------N-215F34-----------------------------
INT 21 u - Named Pipes - LOCAL DosSetNmPHandState
	AX = 5F34h
	BX = handle
	CX = pipe mode bit mask
	    bit 15: set if nonblocking, clear if blocking
	    bit	 8: set if read in message mode, clear if read in byte mode
Return: CF clear if successful
	CF set if error
	    AX = error code
Note:	this function was introduced by LAN Manager but is also supported by
	  the Novell DOS Named Pipe Extender, Banyan VINES, OS/2 Virtual DOS
	  Machines, and others
SeeAlso: AX=5F32h,AX=5F33h,AX=5F36h
--------N-215F35-----------------------------
INT 21 u - Named Pipes - LOCAL DosPeekNmPipe
	AX = 5F35h
	BX = handle
	CX = buffer length
	DS:SI -> buffer
Return: CF set on error
	    AX = error code
	CF clear if successful (LAN Manager v1-v2)
	AX = 0000h if successful (LAN Manager 3.x)
	---if successful---
	    CX = bytes read
	    SI = bytes left in the pipe
	    DX = bytes left in the current message
	    AX = pipe status (v1-v2) (see #1355)
	    DI = pipe status (v3.x)
Note:	this function was introduced by LAN Manager but is also supported by
	  the Novell DOS Named Pipe Extender, Banyan VINES, OS/2 Virtual DOS
	  Machines, and others
SeeAlso: AX=5F38h,AX=5F39h,AX=5F51h

(Table 1355)
Values for pipe status:
 0001h	disconnected
 0002h	listening
 0003h	connected
 0004h	closing
--------N-215F36-----------------------------
INT 21 u - Named Pipes - LOCAL DosTransactNmPipe
	AX = 5F36h
	BX = handle
	CX = in buffer length
	DS:SI -> in buffer
	DX = out buffer length
	ES:DI -> out buffer
Return: CF clear if successful
	    CX = bytes read
	CF set on error
	    AX = error code
Note:	this function was introduced by LAN Manager but is also supported by
	  the Novell DOS Named Pipe Extender, Banyan VINES, OS/2 Virtual DOS
	  Machines, and others
SeeAlso: AX=5F34h,AX=5F37h
--------N-215F37-----------------------------
INT 21 u - Named Pipes - DosCallNmPipe
	AX = 5F37h
	DS:SI -> DosCallNmPipe stack frame (see #1356)
Return: CF clear if successful
	    CX = bytes read
	CF set on error
	    AX = error code
Note:	this function was introduced by LAN Manager but is also supported by
	  the Novell DOS Named Pipe Extender, Banyan VINES, OS/2 Virtual DOS
	  Machines, and others
SeeAlso: AX=5F36h,AX=5F38h

Format of Named Pipes DosCallNmPipe stack frame:
Offset	Size	Description	(Table 1356)
 00h	DWORD	timeout
 04h	DWORD	-> bytes read WORD (not used!)
 08h	WORD	out buffer length
 0Ah	DWORD	address of out buffer
 0Eh	WORD	in buffer length
 10h	DWORD	address of in buffer
 14h	DWORD	address of pipe name
--------N-215F38-----------------------------
INT 21 u - Named Pipes - LOCAL DosWaitNmPipe - AWAIT AVAIL. OF PIPE INSTANCE
	AX = 5F38h
	DS:DX -> pipe name
	BX:CX = timeout value
Return: CF clear if successful
	CF set if error
	    AX = error code
Notes:	when a client gets a return code of ERROR_PIPE_BUSY on attempting to
	  open a pipe, it should issue this call to wait until the pipe
	  instance becomes available again; on return from this call, the
	  client must attempt to open the pipe once again
	this function was introduced by LAN Manager but is also supported by
	  the Novell DOS Named Pipe Extender, Banyan VINES, OS/2 Virtual DOS
	  Machines, and others
SeeAlso: AX=5F37h,AX=5F39h
--------N-215F39-----------------------------
INT 21 U - Named Pipes - LOCAL DosRawReadNmPipe
	AX = 5F39h
	BX = handle
	CX = buffer length
	DS:DX -> buffer
Return: CF clear if successful
	    CX = bytes read
	CF set if error
	    AX = error code
Notes:	this function was introduced by LAN Manager but is also supported by
	  the Novell DOS Named Pipe Extender, Banyan VINES, OS/2 Virtual DOS
	  Machines, and others
	not documented in the LAN Manager Toolkit
SeeAlso: AX=5F35h,AX=5F3Ah,INT 2F/AX=1186h
--------N-215F3A-----------------------------
INT 21 U - Named Pipes - LOCAL DosRawWriteNmPipe
	AX = 5F3Ah
	BX = handle
	CX = buffer length
	DS:DX -> buffer
Return: CF clear if successful
	    CX = bytes written
	CF set if error
	    AX = error code
Notes:	this function was introduced by LAN Manager but is also supported by
	  the Novell DOS Named Pipe Extender, Banyan VINES, OS/2 Virtual DOS
	  Machines, and others
	not documented in the LAN Manager Toolkit
SeeAlso: AX=5F39h,AX=5F3Bh,INT 2F/AX=118Fh
--------N-215F3B-----------------------------
INT 21 u - LAN Manager Enhanced DOS - NetHandleSetInfo
	AX = 5F3Bh
	BX = handle
	CX = handle_info_1 structure length or sizeof DWORD
	DI = parameter number to set
	    0000h all
	    0001h number of milliseconds
	    0002h number of characters
	DS:DX -> handle_info_1 structure (DI=0000h) (see #1357)
		or DWORD (DI=0001h or 0002h)
	SI = level of information (0001h)
Return: CF clear if successful
	    CX = total bytes available
	CF set if error
	    AX = error code
SeeAlso: AX=5F3Ch

Format of LAN Manager handle_info_1 structure:
Offset	Size	Description	(Table 1357)
 00h	DWORD	number of milliseconds which workstation collects data before
		  it sends the data to the named pipe
 04h	DWORD	number of characters which workstation collects before it
		  sends the data to the named pipe
--------N-215F3C-----------------------------
INT 21 u - LAN Manager Enhanced DOS - NetHandleGetInfo
	AX = 5F3Ch
	BX = handle
	CX = length of handle_info_1 structure
	DS:DX -> handle_info_1 structure (see #1357)
	SI = level of information (must be 0001h)
Return: CF clear if successful
	    CX = total bytes available
	CF set if error
	    AX = error code
SeeAlso: AX=5F3Bh
--------N-215F3D-----------------------------
INT 21 U - LAN Manager Enhanced DOS - WRITE MAILSLOT???
	AX = 5F3Dh
	???
Return: ???
--------N-215F3E-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL NetSpecialSMB
	AX = 5F3Eh
	???
Return: ???
Note:	This function is not documented anywhere in the LAN Manager 2.x Toolkit
	  but was documented in LAN Manager 1.x manuals.
--------N-215F3F-----------------------------
INT 21 U - LAN Manager Enhanced DOS - REMOTE API CALL
	AX = 5F3Fh
	CX = api number
	ES:DI -> data descriptor
	ES:SI -> parameter descriptor
	ES:DX -> auxiliary descriptor (if DX <> 0)
	???
Return: ???
--------N-215F40-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL NetMessageBufferSend
	AX = 5F40h
	DS:DX -> NetMessageBufferSend parameter structure (see #1358)
Return: AX = error code

Format of LAN Manager NetMessageBufferSend parameter structure:
Offset	Size	Description	(Table 1358)
 00h	DWORD	-> recipient name (name for specific user, name* for domain
		      wide name, * for broadcast)
 04h	DWORD	-> buffer
 08h	WORD	length of buffer
--------N-215F41-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL NetServiceEnum
	AX = 5F41h
	BL = level of detail (0000h, 0001h or 0002h)
	CX = buffer length
	ES:DI -> buffer of service_info_0, service_info_1, or service_info_2
		(see #1359,#1360,#1361)
Return: CF clear if successful
	    CX = entries read
	    DX = total available
	CF set on error
	    AX = error code

Format of LAN Manager service_info_0 structure:
Offset	Size	Description	(Table 1359)
 00h 16 BYTEs	name
SeeAlso: #1360,#1361

Format of service_info_1 structure:
Offset	Size	Description	(Table 1360)
 00h 16 BYTEs	name
 10h	WORD	status bitmask (see #1362)
 12h	DWORD	status code (see #1363)
		(also see Microsoft LAN Manager Programmer's Reference)
 16h	WORD	process id
SeeAlso: #1359,#1361

Format of service_info_2 structure:
Offset	Size	Description	(Table 1361)
 00h 16 BYTEs	name
 10h	WORD	status bitmask (see #1362)
 12h	DWORD	status code (see #1363)
 16h	WORD	process id
 18h 64 BYTEs	text
SeeAlso: #1359,#1360

Bitfields for LAN Manager status bitmask:
Bit(s)	Description	(Table 1362)
 0,1	00 uninstall
		01 install pending
		10 uninstall pending
		11 installed
 2,3	00 active
		01 Continue pending
		10 Pause pending
		11 paused
 4	uninstallable
 5	pausable
 8	disk redirector paused
 9	spooled device redirector paused (printing)
 10	communication device redirector paused

(Table 1363)
Values for LAN Manager status code:
 high word
    3051 Bad parameter value
    3052 A parameter is missing
    3053 An unknown parameter was specified
    3054 The resource is insufficient
    3055 Configuration is faulty
    3056 An MS-DOS or MS OS/2 error occured
    3057 An internal error occured
    3058 An ambiguous parameter name was given
    3059 A duplicate parameter exists
    3060 The service was terminated by NetSeviceControl when it did not respond
    3061 The service program file could not be executed
    3062 The subservice failed to start
    3063 There is a conflict in the value or use of these parameters
    3064 There is a problem with the file
 low word
    3070 There is insufficient memory
    3071 There is insufficeient disk space
    3072 Unable to create thread
    3073 Unable to create process
    3074 A security failure occured
    3075 There is bad or missing default path
    3076 Network software is not installed
    3077 Server software is not installed
    3078 The server could not access the UAS database
    3079 The action requires user-level security
    3080 The log directory is invalid
    3081 The LAN group specificed could not be used
    3082 The computername is being used as a message alias on another computer
    3083 The workstation failed to announce the servername
    3084 The user accounts system is not configured properly
--------N-215F42-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL NetServiceControl
	AX = 5F42h
	DH = opcode
	    00h interrogate status
	    01h pause
	    02h continue
	    03h uninstall
	DL = argument
	    01h disk resource
	    02h print resource
	    04h communications resource (not implemented for DOS)
	ES:BX -> NetServiceControl parameter structure (see #1364)
Return: CF clear if successful
	CF set on error
	    AX = error code

Format of LAN Manager NetServiceControl parameter structure:
Offset	Size	Description	(Table 1364)
 00h	DWORD	-> service name
 04h	WORD	result buffer size
 06h	DWORD	-> result buffer as service_info_2 structure
--------N-215F43-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL DosPrintJobGetId
	AX = 5F43h
	BX = handle of remote print job
	CX = size of PRIDINFO struture
	ES:DI -> PRIDINFO structure (see #1365)
Return: CF clear if successful
	    PRIDINFO filled in
	CF set on error
	    AX = error code

Format of LAN Manager PRIDINFO structure:
Offset	Size	Description	(Table 1365)
 00h	WORD	job id
 02h 16 BYTEs	server name
 12h 13 BYTEs	queue name
 1Fh  1 BYTE	pad
--------N-215F44-----------------------------
INT 21 - LAN Manager Enhanced DOS - LOCAL NetWkstaGetInfo
	AX = 5F44h
	BX = information level (00h, 01h, or 0Ah)
	CX = buffer size
	DX = 0000h
	ES:DI -> buffer in which to store info (see #1366,#1367,#1368),
	      including any returned strings
Return: AX = error code
	DX = amount of buffer required, unchanged if supplied buffer large
	      enough to hold data
SeeAlso: AX=5F45h,AX=5F49h

Format of LAN Manager wksta_info_0 structure:
Offset	Size	Description	(Table 1366)
 00h	WORD	 reserved (0)
 02h	DWORD	 reserved (0)
 06h	DWORD	 -> path to computer's LANMAN directory
 0Ah	DWORD	 -> computername of the workstation
 0Eh	DWORD	 -> username of user logged onto workstation
 12h	DWORD	 -> domain to which workstation belongs
 16h	WORD	 LAN Manager version number (2 bytes, Major, Minor)
 18h	DWORD	 reserved (0)
 1Ch	WORD	 number of seconds workstation waits for resource availability
 1Eh	DWORD	 delay (in millsecs) before sending data to resource
 22h	WORD	 reserved (0)
 24h	WORD	 reserved (0)
 26h	WORD	 ???
 28h	WORD	 number of seconds to maintain an inactive connection
 2Ah	WORD	 number of seconds an inactive search continues
 2Ch	WORD	 threads to dedicate to network (not supported in MSDOS)
 2Eh	WORD	 number of simultaneous commands sent to network
 30h	WORD	 reserved6 (must be 0)
 32h	WORD	 number of internal buffers
 34h	WORD	 size (in bytes) of each internal buffer
 36h	WORD	 max size (in bytes) of an internal cache buffer (not MSDOS)
 38h	WORD	 seconds before disconnecting inactive session (not MSDOS)
 3Ah	WORD	 size (in bytes) of an internal error buffer (not MSDOS)
 3Ch	WORD	 number of clients that can receive alert messages (not MSDOS)
 3Eh	WORD	 number of services that can be started on workstation
 40h	WORD	 max size (in kilobytes) of error log (not MSDOS)
 42h	WORD	 number of secs before closing inactive print jobs (not MSDOS)
 44h	WORD	 number of character buffers for workstation
 46h	WORD	 max size (in bytes) of character buffer
 48h	DWORD	 -> name of server that validated logon
 4Ch	DWORD	 -> workstation heuristics
 50h	WORD	 number of mailslots allowed
Note:	pointers to strings are set to 0000h:0000h if there is insufficient
	  space in the buffer to hold them
SeeAlso: #1367,#1368

Format of LAN Manager wksta_info_1 structure:
Offset	Size	Description	(Table 1367)
 00h 82 BYTEs	wksta_info_0 structure (see #1366)
 52h	DWORD	 -> name of domain which user is logged on to
 56h	DWORD	 -> all domains in which computer is enlisted
 5Ah	WORD	 number of buffers to allocate for receiving datagrams
SeeAlso: #1368

Format of LAN Manager wksta_info_10 structure:
Offset	Size	Description	(Table 1368)
 00h	DWORD	 -> computername of the workstation
 04h	DWORD	 -> username of user logged onto workstation
 08h	DWORD	 -> domain to which workstation belongs
 0Ch	WORD	 LAN Manager version number (2 bytes, Major, Minor)
 0Eh	DWORD	 -> name of domain which user is loggod on to
 12h	DWORD	 -> all domains in which computer is enlisted
Note:	pointers to strings are set to 0000h:0000h if there is insufficient
	  space in the buffer to hold them
SeeAlso: #1366,#1367
--------N-215F45-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL NetWkstaSetInfo
	AX = 5F45h
	BX = level (0000h or 0001h)
	CX = buffer size
	DX = parameter to set
	ES:DI -> buffer
Return: CF clear if successful
	CF set if error
	    AX = error code
SeeAlso: AX=5F44h
--------N-215F46-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL NetUseEnum
	AX = 5F46h
	BX = level (0000h or 0001h)
	CX = size of buffer
	ES:DI -> buffer of use_info_0 or use_info_1 structures
		  (see #1369,#1370)
Return: CF clear if successful
	    CX = entries read
	    DX = total available entries
	CF set if error
	    AX = error code
SeeAlso: AX=5F47h,AX=5F48h,AX=5F4Ch

Format of LAN Manager use_info_0 structure:
Offset	Size	Description	(Table 1369)
 00h  9 BYTEs	local device name
 09h	BYTE	padding
 0Ah	DWORD	-> remote device name in UNC form \\server\share
SeeAlso: #1370

Format of LAN Manager use_info_1 structure:
Offset	Size	Description	(Table 1370)
 00h  9 BYTEs	Local device name
 09h	BYTE	padding
 0Ah	DWORD	-> remote device name in UNC form \\server\share
 0Eh	DWORD	-> password
 12h	WORD	network link status
		(00h OK, 02h disconnected, else unsure)
 14h	WORD	use type (-1 wildcard, 0 disk, 1 print, 2 com, 3 ipc)
 16h	WORD	ignored
 18h	WORD	ignored
SeeAlso: #1369
--------N-215F47-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL NetUseAdd
	AX = 5F47h
	BX = level (0001h)
	CX = size of use_info_1 structure
	ES:DI -> use_info_1 structure (see #1370)
Return: CF clear on success
	CF set on error
	    AX = error code
SeeAlso: AX=5F46h,AX=5F48h
--------N-215F48-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL NetUseDel
	AX = 5F48h
	BX = force level
	    0000h no force
	    0001h force
	    0002h lots of force
	ES:DI -> buffer as either the local device name or UNC remote name
Return: CF clear on success
	CF set on error
	    AX = error code
SeeAlso: AX=5F46h,AX=5F48h,AX=5F49h
--------N-215F49-----------------------------
INT 21 u - LAN Manager Enhanced DOS - NetUseGetInfo
	AX = 5F49h
	DS:DX -> NetUseGetInfo parameter structure (see #1371)
Return: CF clear on success
	    DX = total available
	CF set on error
	    AX = error code
SeeAlso: AX=5F44h,AX=5F47h

Format of LAN Manager NetUseGetInfo parameter structure:
Offset	Size	Description	(Table 1371)
 00h	DWORD	pointer to either the local device name or UNC remote name
 04h	WORD	level of information (0000h or 0001h)
 06h	DWORD	pointer to buffer of use_info_0 or use_info_1 structures
 0Ah	WORD	length of buffer
--------N-215F4A-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL NetRemoteCopy
	AX = 5F4Ah
	DS:DX -> NetRemoteCopy parameter structure (see #1372)
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=5F4Bh

Format of LAN Manager NetRemoteCopy parameter structure:
Offset	Size	Description	(Table 1372)
 00h	DWORD	-> source name as UNC
 04h	DWORD	-> destination name as UNC
 08h	DWORD	-> source password
 0Ch	DWORD	-> destination password
 10h	WORD	destination open bitmap
		if destination path exists
		    0000h open fails
		    0001h file is appended
		    0002h file is overwritten
		if destination path doesn't exist
		    0000h open fails
		    0010h file is created
 12h	WORD	copy control bitmap (see #1373)
 14h	DWORD	-> copy_info buffer
 18h	WORD	length of copy_info buffer

Bitfields for LAN Manager copy control:
Bit(s)	Description	(Table 1373)
 0	destination must be a file
 1	destination must be a directory
 2	destination is opened in ascii mode instead of binary
 3	source is opened in ascii mode instead of binary
 4	verify all write operations
--------N-215F4B-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL NetRemoteMove
	AX = 5F4Bh
	DS:DX -> NetRemoteMove parameter structure (see #1374)
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=5F4Ah

Format of LAN Manager NetRemoteMove parameter structure:
Offset	Size	Description	(Table 1374)
 00h	DWORD	-> source name as UNC
 04h	DWORD	-> destination name as UNC
 08h	DWORD	-> source password
 0Ch	DWORD	-> destination password
 10h	WORD	destination open bitmap
		if destination path exists
		    0000h open fails
		    0001h file is appended
		    0002h file is overwritten
		if destination path doesn't exist
		    0000h open fails
		    0010h file is created
 12h	WORD	move control bitmap
		    0001h destination must be a file
		    0002h destination must be a directory
 14h	DWORD	-> move_info buffer
 18h	WORD	length of move_info buffer
--------N-215F4C-----------------------------
INT 21 u - LAN Manager Enhanced DOS - LOCAL NetServerEnum
	AX = 5F4Ch
	BX = level (0000h or 0001h)
	CX = buffer length
	ES:DI -> buffer in which to store information
Return: CF clear if successful
	    ES:DI -> server_info_X structures (depending on level)
		  (see #1375,#1376)
	    BX = entries read
	    CX = total entries available
	CF set on error
	    AX = error code
Notes:	this function is also supported by the Novell DOS Named Pipe Extender
	this function has been obseleted by NetServerEnum2
SeeAlso: AX=5F53h

Format of LAN Manager server_info_0 structure:
Offset	Size	Description	(Table 1375)
 00h 16 BYTEs	name
SeeAlso: #1376

Format of LAN Manager server_info_1 structure:
Offset	Size	Description	(Table 1376)
 00h 16 BYTEs	name
 10h	BYTE	major version in lower nibble
 11h	BYTE	minor version
 12h	DWORD	server type bitmask (see #1377)
 16h	DWORD	-> comment string
SeeAlso: #1375

Bitfields for LAN Manager server type:
Bit(s)	Description	(Table 1377)
 0	workstation
 1	server
 2	SQL server
 3	primary domain controller
 4	backup domain controller
 5	time server
 6	Apple File Protocol (AFP) server
 7	Novell server
 8	Domain Member (v2.1+)
 9	Print Queue server (v2.1+)
 10	Dialin server (v2.1+)
 11	Unix server (v2.1+)
--------N-215F4D-----------------------------
INT 21 u - LAN Manager Enhanced DOS - DosMakeMailslot
	AX = 5F4Dh
	BX = message size
	CX = mailslot size (must be bigger than message size by at least 1)
			   (minimum 1000h, maximum FFF6h)
			   (buffer must be 9 bytes bigger than this)
	DS:SI -> name
	ES:DI -> memory buffer
Return: CF clear if successful
	    AX = handle
	CF set on error
	    AX = error code
SeeAlso: AX=5F4Eh,AX=5F4Fh,AX=5F50h,AX=5F51h
--------N-215F4E-----------------------------
INT 21 u - LAN Manager Enhanced DOS - DosDeleteMailslot
	AX = 5F4Eh
	BX = handle
Return: CF clear if successful
	    ES:DI -> memory to be freed (allocated during DosMakeMailslot)
	CF set on error
	    AX = error code
SeeAlso: AX=5F4Dh,AX=5F4Fh
--------N-215F4F-----------------------------
INT 21 u - LAN Manager Enhanced DOS - DosMailslotInfo
	AX = 5F4Fh
	BX = handle
Return: CF clear if successful
	    AX = max message size
	    BX = mailslot size
	    CX = next message size
	    DX = next message priority
	    SI = number of messages waiting
	CF set on error
	    AX = error code
SeeAlso: AX=5F4Dh,AX=5F4Eh,AX=5F50h
--------N-215F50-----------------------------
INT 21 u - LAN Manager Enhanced DOS - DosReadMailslot
	AX = 5F50h
	BX = handle
	DX:CX = timeout
	ES:DI -> buffer
Return: CF clear if successful
	    AX = bytes read
	    CX = next item's size
	    DX = next item's priority
	CF set on error
	    AX = error code
SeeAlso: AX=5F4Dh,AX=5F4Fh,AX=5F51h,AX=5F52h
--------N-215F51-----------------------------
INT 21 u - LAN Manager Enhanced DOS - DosPeekMailslot
	AX = 5F51h
	BX = handle
	ES:DI -> buffer
Return: CF clear if successful
	    AX = bytes read
	    CX = next item's size
	    DX = next item's priority
	CF set on error
	    AX = error code
SeeAlso: AX=5F35h,AX=5F4Fh,AX=5F50h,AX=5F52h
--------N-215F52-----------------------------
INT 21 u - LAN Manager Enhanced DOS - DosWriteMailslot
	AX = 5F52h
	BX = class
	CX = length of buffer
	DX = priority
	ES:DI -> DosWriteMailslot parameter structure (see #1378)
	DS:SI -> mailslot name
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=5F4Fh,AX=5F50h,AX=5F51h

Format of LAN Manager DosWriteMailslot parameter structure:
Offset	Size	Description	(Table 1378)
 00h	DWORD	timeout
 04h	DWORD	-> buffer
--------N-215F53-----------------------------
INT 21 u - LAN Manager Enhanced DOS - NetServerEnum2
	AX = 5F53h
	DS:SI -> NetServerEnum2 parameter structure (see #1379)
Return: CF clear if successful
	    BX = entries read
	    CX = total entries available
	CF set on error
	    AX = error code
SeeAlso: AX=5F4Ch

Format of LAN Manager NetServerEnum2 parameter structure:
Offset	Size	Description	(Table 1379)
 00h	WORD	level (0000h or 0001h)
 02h	DWORD	-> buffer as array of server_info_??? structures (see #1381)
 06h	WORD	length of buffer
 08h	DWORD	server type bitmask (see #1380)
 0Ch	DWORD	-> Domain name (may be 0000h:0000h for all local domains)

Bitfields for LAN Manager server type:
Bit(s)	Description	(Table 1380)
 0	workstation
 1	server
 2	SQL server
 3	primary domain controller
 4	backup domain controller
 5	time server
 6	Apple File Protocol (AFP) server
 7	Novell server
 8	Domain Member (v2.1+)
 9	Print Queue server (v2.1+)
 10	Dialin server (v2.1+)
 11	Unix server (v2.1+)
Note:	set all (FFFFFFFFh) for All Types

Format of LAN Manager server_info_0 structure:
Offset	Size	Description	(Table 1381)
 00h 16 BYTEs	name
SeeAlso: #1382

Format of LAN Manager server_info_1 structure:
Offset	Size	Description	(Table 1382)
 00h 16 BYTEs	name
 10h	BYTE	major version in lower nibble
 11h	BYTE	minor version
 12h	DWORD	server type (bits 0-11) (see #1380)
 16h	DWORD	-> comment string
SeeAlso: #1381
--------N-215F55----------------------------
INT 21 U - LAN Manager Enhanced DOS - KILL ALL CONNECTIONS???
	AX = 5F55h
	BX = ???
Return: CF clear if successful
	CF set on error
	    AX = error code
--------N-215F80-----------------------------
INT 21 - LANtastic - GET LOGIN ENTRY
	AX = 5F80h
	BX = login entry index (0-based)
	ES:DI -> 16-byte buffer for machine name
Return: CF clear if successful
	    buffer filled with machine name ("\\" prefix removed)
	    DL = adapter number (v3+)
	CF set on error
	    AX = error code
Note:	the login entry index corresponds to the value BX used in AX=5F83h
SeeAlso: AX=5F83h
--------N-215F81-----------------------------
INT 21 - LANtastic - LOGIN TO SERVER
	AX = 5F81h
	ES:DI -> ASCIZ login path followed immediately by ASCIZ password
	BL = adapter number
	    FFh try all valid adapters
	    00h-07h try only specified adapter
Return: CF clear if successful
	CF set on error
	    AX = error code
Notes:	login path is of form "\\machine\username"
	if no password is used, the string at ES:DI must be terminated with
	  three NULs for compatibility with LANtastic v3.0.
SeeAlso: AX=5F82h,AX=5F84h
--------N-215F82-----------------------------
INT 21 - LANtastic - LOGOUT FROM SERVER
	AX = 5F82h
	ES:DI -> ASCIZ server name (in form "\\machine")
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=5F81h,AX=5F88h,AX=5FCBh
--------N-215F83-----------------------------
INT 21 - LANtastic - GET USERNAME ENTRY
	AX = 5F83h
	BX = login entry index (0-based)
	ES:DI -> 16-byte buffer for username currently logged into
Return: CF clear if successful
	    DL = adapter number (v3+)
	CF set on error
	    AX = error code
Note:	the login entry index corresponds to the value BX used in AX=5F80h
SeeAlso: AX=5F80h
--------N-215F84-----------------------------
INT 21 - LANtastic - GET INACTIVE SERVER ENTRY
	AX = 5F84h
	BX = server index not currently logged into
	ES:DI -> 16-byte buffer for server name which is available for logging
		in to ("\\" prefix omitted)
Return: CF clear if successful
	    DL = adapter number to non-logged in server is on
	CF set on error
	    AX = error code
SeeAlso: AX=5F81h
--------N-215F85-----------------------------
INT 21 - LANtastic - CHANGE PASSWORD
	AX = 5F85h
	ES:DI -> buffer containing "\\machine\oldpassword" 00h "newpassword"00h
Return: CF clear if successful
	CF set on error
	    AX = error code
Notes:	must be logged into the named machine
	this function is illegal for group accounts
--------N-215F86-----------------------------
INT 21 - LANtastic - DISABLE ACCOUNT
	AX = 5F86h
	ES:DI -> ASCIZ machine name and password in form "\\machine\password"
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	must be logged into the named machine and concurrent logins set to 1
	  by NET_MGR.  Requires system manager to re-enable account.
--------N-215F87-----------------------------
INT 21 - LANtastic v3+ - GET ACCOUNT
	AX = 5F87h
	DS:SI -> 128-byte buffer for account information (see #1383)
	ES:DI -> ASCIZ machine name in form "\\machine"
Return: CF clear if successful
	CF set on error
	    AX = error code
	BX destroyed
Note:	must be logged into the specified machine

Format of LANtastic user account structure:
Offset	Size	Description	(Table 1383)
 00h 16 BYTEs	blank-padded username (zero-padded for v4.x)
 10h 16 BYTEs	reserved (00h)
 20h 32 BYTEs	user description
 40h	BYTE	privilege bits (see #1384)
 41h	BYTE	maximum concurrent users
 42h 42 BYTEs	bit map for disallowed half hours, beginning on Sunday
		(bit set if half-hour not an allowed time)
 6Ch	WORD	internal (0002h)
 6Eh  2 WORDs	last login time
 72h  2 WORDs	account expiration date (MS-DOS-format year/month:day)
 76h  2 WORDs	password expiration date (0 = none)
 7Ah	BYTE	number of days to extend password after change (1-31)
		00h if no extension required
---v3.x---
 7Bh  5 BYTEs	reserved
---v4.x---
 7Bh	BYTE	storage for first letter of user name when deleted (first
		  character is changed to 00h when deleting account)
 7Ch	BYTE	extended privileges
 7Dh  3 BYTEs	reserved

Bitfields for LANtastic privilege bits:
Bit(s)	Description	(Table 1384)
 7	bypass access control lists
 6	bypass queue protection
 5	treat as local process
 4	bypass mail protection
 3	allow audit entry creation
 2	system manager
 0	user cannot change password
--------N-215F88-----------------------------
INT 21 - LANtastic v4.0+ - LOGOUT FROM ALL SERVERS
	AX = 5F88h
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=5F82h
--------N-215F97-----------------------------
INT 21 - LANtastic - COPY FILE
	AX = 5F97h
	CX:DX = number of bytes to copy (FFFFFFFFh = entire file)
	SI = source file handle
	DI = destination file handle
Return: CF clear if successful
	    DX:AX = number of bytes copied
	CF set on error
	    AX = error code
Note:	copy is performed by server
--------N-215F98-----------------------------
INT 21 - LANtastic - SEND UNSOLICITED MESSAGE
	AX = 5F98h
	DS:SI -> message buffer (see #1385)
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	v4.1- return no errors
SeeAlso: AX=5F99h

Format of LANtastic message buffer:
Offset	Size	Description	(Table 1385)
 00h	BYTE	reserved
 01h	BYTE	message type
		00h general
		01h server warning
		02h-7Fh reserved
		80h-FFh user-defined
 02h 16 BYTEs	ASCIZ destination machine name
 12h 16 BYTEs	ASCIZ server name which user must be logged into
 22h 16 BYTEs	ASCIZ user name
 32h 16 BYTEs	ASCIZ originating machine name (filled in when received)
 42h 80 BYTEs	message text
--------N-215F99-----------------------------
INT 21 - LANtastic - GET LAST RECEIVED UNSOLICITED MESSAGE
	AX = 5F99h
	ES:DI -> messsage buffer (see #1385)
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=5F98h
--------N-215F9A-----------------------------
INT 21 - LANtastic - GET MESSAGE PROCESSING FLAGS
	AX = 5F9Ah
Return: CF clear if successful
	    DL = bits describing processing of received messages (see #1386)
	CF set on error
	    AX = error code
SeeAlso: AX=5F9Bh,AX=5F9Ch,AX=5F9Dh

Bitfields for unsolicited message processing flags:
Bit(s)	Description	(Table 1386)
 0	beep before message is delivered
 1	deliver message to message service
 2	pop up message automatically (v3+)
--------N-215F9B-----------------------------
INT 21 - LANtastic - SET MESSAGE PROCESSING FLAGS
	AX = 5F9Bh
	DL = bits describing processing for received unsolicited messages
	     (see #1386)
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=5F9Ah,AX=5F9Eh
--------N-215F9C-----------------------------
INT 21 - LANtastic v3+ - POP UP LAST RECEIVED MESSAGE
	AX = 5F9Ch
	CX = time to leave on screen in clock ticks
	DH = 0-based screen line on which to place message
Return: CF clear if successful
	CF set on error
	    AX = error code (0Bh)
Notes:	the original screen contents are restored when the message is removed
	the message will not appear, and an error will be returned, if the
	  screen is in a graphics mode
SeeAlso: AX=5F9Ah
--------N-215F9D-----------------------------
INT 21 - LANtastic v4.1+ - GET REDIRECTOR CONTROL BITS
	AX = 5F9Dh
Return: DL = redirector control bits
		bit 7: set to notify on print job completion
SeeAlso: AX=5F9Ah,AX=5F9Eh
--------N-215F9E-----------------------------
INT 21 - LANtastic v4.1+ - SET REDIRECTOR CONTROL BITS
	AX = 5F9Eh
	DL = redirector control bits (see AX=5F9Dh)
Return: nothing
SeeAlso: AX=5F9Bh,AX=5F9Dh
--------N-215FA0-----------------------------
INT 21 - LANtastic - GET QUEUE ENTRY
	AX = 5FA0h
	BX = queue entry index (0000h is first entry)
	DS:SI -> buffer for queue entry (see #1387)
	ES:DI -> ASCIZ server name in form "\\name"
Return: CF clear if successful
	CF set on error
	    AX = error code
	BX = entry index for next queue entry (BX-1 is current index)
SeeAlso: AX=5FA1h,AX=5FA2h

Format of LANtastic queue entry:
Offset	Size	Description	(Table 1387)
 00h	BYTE	status of entry (see #1388)
 01h	DWORD	size of spooled file
 05h	BYTE	type of entry (see #1389)
 06h	BYTE	output control (see #1390)
 07h	WORD	number of copies
 09h	DWORD	sequence number of queue entry
 0Dh 48 BYTEs	pathname of spooled file
 3Dh 16 BYTEs	user who spooled file
 4Dh 16 BYTEs	name of machine from which file was spooled
 5Dh	WORD	date file was spooled (see #1318 at AX=5700h)
 5Fh	WORD	time file was spooled (see #1317 at AX=5700h)
 61h 17 BYTEs	ASCIZ destination device or user name
 72h 48 BYTEs	comment field

(Table 1388)
Values for status of LANtastic queue entry:
 00h	empty
 01h	being updated
 02h	being held
 03h	waiting for despool
 04h	being despooled
 05h	canceled
 06h	spooled file could not be accessed
 07h	destination could not be accessed
 08h	rush job

(Table 1389)
Values for type of LANtastic queue entry:
 00h	printer queue file
 01h	message
 02h	local file
 03h	remote file
 04h	to remote modem
 05h	batch processor file

Bitfields for output control:
Bit(s)	Description	(Table 1390)
 6	don't delete (for mail)
 5	mail file contains voice mail (v3+)
 4	mail message has been read
 3	response has been requested for this mail
--------N-215FA1-----------------------------
INT 21 - LANtastic - SET QUEUE ENTRY
	AX = 5FA1h
	BX = handle of opened queue entry
	DS:SI -> queue entry (see #1387)
Return: CF clear if successful
	CF set on error
	    AX = error code
Notes:	the only queue entry fields which may be changed are output control,
	  number of copies, destination device, and comment
	the handle in BX is that from a create or open (INT 21/AH=3Ch,3Dh)
	  call on the file "\\server\\@MAIL" or "\\server\@name" (for
	  printer queue entries)
SeeAlso: AX=5FA0h,AX=5FA2h,AX=5FA9h
--------N-215FA2-----------------------------
INT 21 - LANtastic - CONTROL QUEUE
	AX = 5FA2h
	BL = control command
	    00h start despooling (privileged)
	    01h halt despooling (privileged)
	    02h halt despooling at end of job (privileged)
	    03h pause despooler at end of job (privileged)
	    04h print single job (privileged)
	    05h restart current job (privileged)
	    06h cancel the current job
	    07h hold queue entry
	    08h release a held queue entry
	    09h make queue entry a rushed job (privileged)
	CX:DX = sequence number to control (commands 06h-09h)
	DX = physical printer number (commands 00h-05h)
	    00h-02h LPT1-LPT3
	    03h,04h COM1,COM2
	    other	all printers
	ES:DI -> ASCIZ server name in form "\\machine"
Return: CF clear if successful
	CF set on error
	    AX = error code
--------N-215FA3-----------------------------
INT 21 - LANtastic v3+ - GET PRINTER STATUS
	AX = 5FA3h
	BX = physical printer number (00h-02h = LPT1-LPT3, 03h-04h = COM1-COM2)
	DS:SI -> buffer for printer status (see #1391)
	ES:DI -> ASCIZ server name in form "\\machine"
Return: CF clear if successful
	CF set on error
	    AX = error code
	BX = next physical printer number
Note:	you must be logged in to the specified server

Format of LANtastic printer status:
Offset	Size	Description	(Table 1391)
 00h	BYTE	printer state (see #1392)
 01h	WORD	queue index of print job being despooled
		FFFFh if not despooling--ignore all following fields
 03h	WORD	actual characters per second being output
 05h	DWORD	number of characters actually output so far
 09h	DWORD	number of bytes read from spooled file so far
 0Dh	WORD	copies remaining to print

Bitfields for LANtastic printer state:
Bit(s)	Description	(Table 1392)
 7	printer paused
 0-6	0 printer disabled
	1 will stop at end of job
	2 print multiple jobs
--------N-215FA4-----------------------------
INT 21 - LANtastic v3+ - GET STREAM INFO
	AX = 5FA4h
	BX = 0-based stream index number
	DS:SI -> buffer for stream information (see #1393)
	ES:DI -> ASCIZ machine name in form "\\machine"
Return: CF clear if successful
	CF set on error
	    AX = error code
	BX = next stream number
SeeAlso: AX=5FA5h

Format of LANtastic stream information:
Offset	Size	Description	(Table 1393)
 00h	BYTE	queueing of jobs for logical printer (0=disabled,other=enabled)
 01h 11 BYTEs	logical printer resource template (may contain ? wildcards)
--------N-215FA5-----------------------------
INT 21 - LANtastic v3+ - SET STREAM INFO
	AX = 5FA5h
	BX = 0-based stream index number
	DS:SI -> buffer containing stream information (see #1393)
	ES:DI -> ASCIZ machine name in form "\\machine"
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=5FA4h
--------N-215FA7-----------------------------
INT 21 - LANtastic - CREATE USER AUDIT ENTRY
	AX = 5FA7h
	DS:DX -> ASCIZ reason code (max 8 bytes)
	DS:SI -> ASCIZ variable reason string (max 128 bytes)
	ES:DI -> ASCIZ machine name in form "\\machine"
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	you must be logged in to the specified server and have the "U"
	  privilege to execute this call
--------N-215FA9-----------------------------
INT 21 - LANtastic v4.1+ - SET EXTENDED QUEUE ENTRY
	AX = 5FA9h
	BX = handle of opened queue entry
	DS:SI -> queue entry (see #1387)
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	functions exactly the same as AX=5FA1h except the spooled filename is
	  also set.  This call supports direct despooling.
SeeAlso: AX=5FA1h
--------N-215FB0-----------------------------
INT 21 - LANtastic - GET ACTIVE USER INFORMATION
	AX = 5FB0h
	BX = server login entry index
	DS:SI -> buffer for active user entry (see #1394)
	ES:DI -> ASCIZ machine name in form "\\server"
Return: CF clear if successful
	CF set on error
	    AX = error code
	BX = next login index
SeeAlso: AX=5FB2h

Format of LANtastic active user entry:
Offset	Size	Description	(Table 1394)
 00h	WORD	virtual circuit number
 02h	BYTE	login state (see #1395)
 03h	BYTE	last command issued (see #1396)
 04h  5 BYTEs	number of I/O bytes (40-bit unsigned number)
 09h  3 BYTEs	number of server requests (24-bit unsigned)
 0Ch 16 BYTEs	name of user who is logged in
 1Ch 16 BYTEs	name of remote logged in machine
 2Ch	BYTE	extended privileges (v4+???)
		bit 0: user cannot change his password
 2Dh	WORD	time left in minutes (0000h = unlimited) (v4+???)

Bitfields for login state:
Bit(s)	Description	(Table 1395)
 0	fully logged in
 1	remote program load login
 2	user has system manager privileges
 3	user can create audit entries
 4	bypass mail protection
 5	treat as local process
 6	bypass queue protection
 7	bypass access control lists

(Table 1396)
Values for last LANtastic command:
 00h	login
 01h	process termination
 02h	open file
 03h	close file
 04h	create file
 05h	create new file
 06h	create unique file
 07h	commit data to disk
 08h	read file
 09h	write file
 0Ah	delete file
 0Bh	set file attributes
 0Ch	lock byte range
 0Dh	unlock byte range
 0Eh	create subdirectory
 0Fh	remove subdirectory
 10h	rename file
 11h	find first matching file
 12h	find next matching file
 13h	get disk free space
 14h	get a queue entry
 15h	set a queue entry
 16h	control the queue
 17h	return login information
 18h	return link description
 19h	seek on file
 1Ah	get server's time
 1Bh	create audit entry
 1Ch	open file in multitude of modes
 1Dh	change password
 1Eh	disable account
 1Fh	local server file copy
---v3+---
 20h	get username from account file
 21h	translate server's logical path
 22h	make indirect file
 23h	get indirect file contents
 24h	get physical printer status
 25h	get logical print stream info
 26h	set logical print stream info
 27h	get user's account record
---v4+---
 28h	request server shutdown
 29h	cancel server shutdown
 2Ah	stuff server's keyboard
 2Bh	write then commit data to disk
 2Ch	set extended queue entry
 2Dh	terminate user from server
 2Eh	enable/disable logins
 2Fh	flush server caches
 30h	change username
 31h	get extended queue entry
	(same as get queue, but can return named fields blanked)
--------N-215FB1-----------------------------
INT 21 - LANtastic - GET SHARED DIRECTORY INFORMATION
	AX = 5FB1h
	DS:SI -> 64-byte buffer for link description
	ES:DI -> ASCIZ machine and shared directory name in form
		 "\\machine\shared-resource"
Return: CF clear if successful
	    CX = access control list privileges for requesting user (see #1397)
	CF set on error
	    AX = error code

Bitfields for LANtastic access control list:
Bit(s)	Description	(Table 1397)
 4	(I) allow expansion of indirect files
 5	(A) allow attribute changing
 6	(P) allow physical access to device
 7	(E) allow program execution
 8	(N) allow file renaming
 9	(K) allow directory deletion
 10	(D) allow file deletion
 11	(L) allow file/directory lookups
 12	(M) allow directory creation
 13	(C) allow file creation
 14	(W) allow open for write and writing
 15	(R) allow open for read and reading
--------N-215FB2-----------------------------
INT 21 - LANtastic v3+ - GET USERNAME FROM ACCOUNT FILE
	AX = 5FB2h
	BX = username entry index (0 for first)
	DS:SI -> 16-byte buffer for username
	ES:DI -> ASCIZ server name in form "\\machine"
Return: CF clear if successful
	CF set on error
	    AX = error code
	BX = next queue entry index
SeeAlso: AX=5FB0h
--------N-215FB3-----------------------------
INT 21 - LANtastic v3+ - TRANSLATE PATH
	AX = 5FB3h
	DS:SI -> 128-byte buffer for ASCIZ result
	ES:DI -> full ASCIZ path, including server name
	DX = types of translation to be performed
	    bit 0: expand last component as indirect file
	    bit 1: return actual path relative to server's physical disk
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	always expands any indirect files along the path
SeeALso: AX=5FB4h,INT 21/AH=60h
--------N-215FB4-----------------------------
INT 21 - LANtastic v3+ - CREATE INDIRECT FILE
	AX = 5FB4h
	DS:SI -> 128-byte buffer containing ASCIZ contents of indirect file
	ES:DI -> full ASCIZ path of indirect file to create, incl machine name
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	the contents of the indirect file may be any valid server-relative path
SeeAlso: AX=5FB3h,AX=5FB5h
--------N-215FB5-----------------------------
INT 21 - LANtastic v3+ - GET INDIRECT FILE CONTENTS
	AX = 5FB5h
	DS:SI -> 128-byte buffer for ASCIZ indirect file contents
	ES:DI -> full ASCIZ path of indirect file
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=5FB4h
--------N-215FB6-----------------------------
INT 21 - LANtastic v4.1+ - SET AUTO-LOGIN DEFAULTS
	AX = 5FB6h
	ES:DI -> pointer to ASCIZ default user name, immediately followed by
		ASCIZ password
	BL = adapter number to use for default login attempt
	    FFh try all valid adapters
	    00h-05h try adapter 0-5 explicitly
Return: CF clear if successful
	CF set on error
	    AX = error code
Notes:	call with ES:DI -> two nulls to disable auto-login
SeeAlso: AX=5FB7h
--------N-215FB7-----------------------------
INT 21 - LANtastic v4.1+ - GET AUTO-LOGIN DEFAULTS
	AX = 5FB7h
	ES:DI -> pointer to 16-byte buffer to store ASCIZ auto-login user name
Return: CF clear if successful
	    DL = adapter number used for default login attempt
		FFh all valid adapters will be tried
		00h-05h specified adapter will be tried explicitly
	CF set on error
	    AX = error code
SeeAlso: AX=5F81h,AX=5FB6h
--------N-215FC0-----------------------------
INT 21 - LANtastic - GET TIME FROM SERVER
	AX = 5FC0h
	DS:SI -> time block (see #1398)
	ES:DI -> ASCIZ server name to get time from
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AH=E7h"Novell"

Format of LANtastic time block:
Offset	Size	Description	(Table 1398)
 00h	WORD	year
 02h	BYTE	day
 03h	BYTE	month
 04h	BYTE	minutes
 05h	BYTE	hour
 06h	BYTE	hundredths of second
 07h	BYTE	second
--------N-215FC8-----------------------------
INT 21 - LANtastic v4.0+ - SCHEDULE SERVER SHUTDOWN
	AX = 5FC8h
	ES:DI -> ASCIZ server name in form "\\machine"
	DS:SI -> ASCIZ reason string (80 characters)
	CX = number of minutes until shutdown (0 = immediate)
	DX = option flags (see #1399)
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=5FC9h

Bitfields for LANtastic option flags:
Bit(s)	Description	(Table 1399)
 0	auto reboot
 1	do not notify users
 2	halt after shutdown
 3	shutdown due to power fail (used by UPS)
 4-7	reserved
 8-14	user definable
 15	reserved
--------N-215FC9-----------------------------
INT 21 - LANtastic v4.0+ - CANCEL SERVER SHUTDOWN
	AX = 5FC9h
	ES:DI -> ASCIZ server name in form "\\machine"
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	you must have the "S" privilege to use this call
SeeAlso: AX=5FC8h
--------N-215FCA-----------------------------
INT 21 - LANtastic v4.0+ - STUFF SERVER KEYBOARD BUFFER
	AX = 5FCAh
	ES:DI -> ASCIZ server name in form "\\machine"
	DS:SI -> ASCIZ string to stuff (128 bytes)
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	you must have the "S" privilege to use this call
	maximum number of characters that can be stuffed is determined by the
	  server's RUN BUFFER SIZE.
SeeAlso: INT 16/AH=05h
--------N-215FCB-----------------------------
INT 21 - LANtastic v4.1+ - TERMINATE USER
	AX = 5FCBh
	ES:DI -> ASCIZ server name in form "\\machine"
	DS:SI -> blank-padded username.	 A null char = wildcard.
	DS:DX -> blank-padded machine name.  A null char = wildcard.
	CX = minutes until termination (0 = immediate)
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	you must have the "S" privilege to use this call
	you cannot log yourself out using this call
SeeAlso: AX=5F82h
--------N-215FCC-----------------------------
INT 21 - LANtastic v4.1+ - GET/SET SERVER CONTROL BITS
	AX = 5FCCh
	ES:DI -> ASCIZ server name in form "\\machine"
	CX = bit values (value of bits you want to set) (see #1400)
	DX = bit mask (bits you are interested in, 0 = get only) (see #1400)
Return: CF clear if successful
	    CX = control bits after call (see #1400)
	CF set on error
	    AX = error code
Note:	you must have the "S" privilege to SET, anyone can GET.

Bitfields for control bits:
Bit(s)	Description	(Table 1400)
 0	disable logins
--------N-215FCD-----------------------------
INT 21 - LANtastic v4.1+ - FLUSH SERVER CACHES
	AX = 5FCDh
	ES:DI -> ASCIZ server name in form "\\machine"
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	you must have the "S" privilege to use this call.
--------N-215FD0-----------------------------
INT 21 - LANtastic - GET REDIRECTED PRINTER TIMEOUT
	AX = 5FD0h
Return: CF clear if successful
	    CX = redirected printer timeout in clock ticks of 55ms
		0000h if timeout disabled
	CF set on error
	    AX = error code
SeeAlso: AX=5FD1h
--------N-215FD1-----------------------------
INT 21 - LANtastic - SET REDIRECTED PRINTER TIMEOUT
	AX = 5FD1h
	CX = printer timeout in clock ticks of 55ms, 0000h to disable timeouts
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=5FD0h
--------N-215FE0-----------------------------
INT 21 C - LANtastic - GET DOS SERVICE VECTOR
	AX = 5FE0h
Return: CF clear if successful
	    ES:BX -> current FAR service routine
	CF set on error
	    AX = error code
Note:	the service routine is called by the LANtastic redirector whenever DOS
	  may safely be called, permitting external TSRs and drivers to hook
	  into LANtastic's DOS busy flag checking
SeeAlso: AX=5FE1h,INT 28,INT 2A/AH=84h
--------N-215FE1-----------------------------
INT 21 - LANtastic - SET DOS SERVICE VECTOR
	AX = 5FE1h
	ES:BX -> FAR routine to call when DOS services are available
Return: CF clear if successful
	CF set on error
	    AX = error code
Note:	new handler must chain to previous handler as its first action
SeeAlso: AX=5FE0h
--------N-215FE2-----------------------------
INT 21 - LANtastic - GET MESSAGE SERVICE VECTOR
	AX = 5FE2h
Return: CF clear if successful
	    ES:BX -> current FAR message service routine
	CF set on error
	    AX = error code
SeeAlso: AX=5FE0h,AX=5FE3h
--------N-215FE3-----------------------------
INT 21 - LANtastic - SET MESSAGE SERVICE VECTOR
	AX = 5FE3h
	ES:BX -> FAR routine for processing network messages
Return: CF clear if successful
	CF set on error
	    AX = error code
Notes:	handler must chain to previous handler as its first action
	on invocation, ES:BX -> just-received message
SeeAlso: AX=5FE2h
--------D-2160-------------------------------
INT 21 - DOS 3.0+ - "TRUENAME" - CANONICALIZE FILENAME OR PATH
	AH = 60h
	DS:SI -> ASCIZ filename or path
	ES:DI -> 128-byte buffer for canonicalized name
Return: CF set on error
	    AX = error code
		02h invalid component in directory path or drive letter only
		03h malformed path or invalid drive letter
	    ES:DI buffer unchanged
	CF clear if successful
	    AH = 00h or 3Ah (DOS 6.1/6.2 for character device)
	    AL = destroyed (00h or 2Fh or 5Ch or last character of current
		  directory on drive)
	    buffer filled with qualified name of form D:\PATH\FILE.EXT or
	      \\MACHINE\PATH\FILE.EXT
Desc:	determine the canonical name of the specified filename or path,
	  corresponding to the undocumented TRUENAME command in COMMAND.COM
Notes:	the input path need not actually exist
	letters are uppercased, forward slashes converted to backslashes,
	  asterisks converted to appropriate number of question marks, and
	  file and directory names are truncated to 8.3 if necessary.  (DR DOS
	  3.41 and 5.0 do not expand asterisks)
	'.' and '..' in the path are resolved
	filespecs on local drives always start with "d:", those on network
	  drives always start with "\\"
	if path string is on a JOINed drive, the returned name is the one that
	  would be needed if the drive were not JOINed; similarly for a
	  SUBSTed, ASSIGNed, or network drive letter.	Because of this, it is
	  possible to get a qualified name that is not legal under the current
	  combination of SUBSTs, ASSIGNs, JOINs, and network redirections
	under DOS 3.3 through 6.00, a device name is translated differently if
	  the device name does not have an explicit directory or the directory
	  is \DEV (relative directory DEV from the root directory works
	  correctly).  In these cases, the returned string consists of the
	  unchanged device name and extension appended to the string X:/
	  (forward slash instead of backward slash as in all other cases) where
	  X is the default or explicit drive letter.
	under MS-DOS 7.0, this call returns the short name for any
	  long-filename portions of the provided pathname or filename
	functions which take pathnames require canonical paths if invoked via
	  INT 21/AX=5D00h
	supported by OS/2 v1.1 compatibility box
	NetWare 2.1x does not support characters with the high bit set; early
	  versions of NetWare 386 support such characters except in this call.
	  In addition, NetWare returns error code 3 for the path "X:\"; one
	  should use "X:\." instead.
	Novell DOS 7 reportedly has difficulty with non-MS-DOS filenames on
	  network drives, and can return "D:" instead of "SERVER/VOLUME"
	for DOS 3.3-6.0, the input and output buffers may be the same, as the
	  canonicalized name is built in an internal buffer and copied to the
	  specified output buffer as the very last step
	for DR DOS 6.0, this function is not automatically called when on a
	  network.  Device drivers reportedly cannot make this call from their
	  INIT function.  Using the same pointer for both input and output
	  buffers is not supported in the April 1992 and earlier versions of
	  DR DOS
	Windows for Workgroups 3.11, Windows95 and even MS-DOS 7.00 only
	  return the local drive path; to obtain network paths use
	  INT 21/AX=5F02h or INT 21/AX=5F46h instead
	Corel's CORELCDX and MSCDEX without the /S switch return canonical
	  names of the form "\\D.\A.\path", where "D" is the CD-ROM drive
	  letter and "A" appears to indicate the first physical CD-ROM drive;
	  MSCDEX with the /S switch returns a canonical name with embedded
	  blanks.  Novell DOS 7 NWCDEX as of the 11/16/94 update returns the
	  same canonical path as MSCDEX; earlier revisions returned
	  "Cdex.   D:\path", where "D" is the CD-ROM drive letter
	the Windows95 MSCDEX-replacement VxD returns "D:\path", even though the
	  MS-DOS 7.00 MSCDEX behaves identically to older versions (above)
SeeAlso: AX=5F02h,AX=5FB3h,AX=7160h/CL=00h,INT 2F/AX=1123h,INT 2F/AX=1221h
--------D-2161-------------------------------
INT 21 - DOS 3.0+ - UNUSED (RESERVED FOR NETWORK USE)
	AH = 61h
Return: AL = 00h
Note:	this function does nothing and returns immediately
--------O-2161--BP6467-----------------------
INT 21 U - OS/2 v1.x FAPI - OS/2 FILE SYSTEM JOIN/SUBST
	AH = 61h
	BP = 6467h ("dg")
	AL = function
	    00h list (i.e. get)
	    01h add
	    02h delete
	BX = drive number
	CX = size of buffer
	SI = type (0002h JOIN, 0003h SUBST)
	ES:DI -> buffer
Return: CF clear if successful
	    AX = 0000h
	    ES:DI buffer filled, if appropriate
	CF set on error
	    AX = error code
Notes:	used by JOIN and SUBST to communicate with the OS/2 file system
	for function 00h (list), the ES:DI buffer is filled with the ASCIZ
	  JOIN/SUBST path or an empty string if the drive is not JOINed/SUBSTed
	also supported by OS/2 v2.0+ Virtual DOS Machines
--------D-2162-------------------------------
INT 21 - DOS 3.0+ - GET CURRENT PSP ADDRESS
	AH = 62h
Return: BX = segment of PSP for current process
Notes:	this function does not use any of the DOS-internal stacks and may
	  thus be called at any time, even during another INT 21h call
	the current PSP is not necessarily the caller's PSP
	identical to the undocumented AH=51h
SeeAlso: AH=50h,AH=51h
--------U-216262SI1994-----------------------
INT 21 - ENVLOCK - INSTALLATION CHECK
	AX = 6262h
	SI = 1994h
Return: AX = 1994h if installed
	    ES = ENVLOCK's resident segment
Notes:	to deactivate ENVLOCK, zero out the byte at ES:[0102h]
Program: ENVLOCK is a TSR by Alexander Yanovsky (aka PC Hawk) that forces
	  other TSRs to deallocate their environment when they stay resident
--------D-216300-----------------------------
INT 21 - DOS 2.25 only - GET LEAD BYTE TABLE ADDRESS
	AX = 6300h
Return: CF clear if successful
	    DS:SI -> lead byte table (see #1401)
	CF set on error
	    AX = error code (01h) (see #1332 at AH=59h/BX=0000h)
Notes:	does not preserve any registers other than SS:SP
	the US version of MS-DOS 3.30 treats this as an unused function,
	  setting AL=00h and returning immediately
SeeAlso: AX=6301h,AH=07h,AH=08h,AH=0Bh

Format of double-byte character set lead byte table entry:
Offset	Size	Description	(Table 1401)
 00h  2 BYTEs	low/high ends of a range of leading byte of double-byte chars
 02h  2 BYTEs	low/high ends of a range of leading byte of double-byte chars
	...
  N   2 BYTEs	00h,00h end flag
--------D-216300-----------------------------
INT 21 - DOS 3.2+ - GET DOUBLE BYTE CHARACTER SET LEAD-BYTE TABLE
	AX = 6300h
Return: AL = error code
	    00h successful
		DS:SI -> DBCS table (see #1401)
		all other registers except CS:IP and SS:SP destroyed
	    FFh not supported
Notes:	probably identical to AH=63h/AL=00h for DOS 2.25
	the US version of MS-DOS 3.30 treats this as an unused function,
	  setting AL=00h and returning immediately, WITHOUT setting DS:SI;
	  only the Far East versions of MS-DOS 3.2 and 3.3 supported this call
	the US version of DOS 4.0+ accepts this function, but returns an empty
	  list
	IBM DOS 6.1 SYS.COM assumes that CF is set on error
SeeAlso: AX=6300h"DOS 2.25"
--------D-216301-----------------------------
INT 21 - DOS 2.25, DOS 3.2+ - SET KOREAN (HANGEUL) INPUT MODE
	AX = 6301h
	DL = new mode
	    00h return only full characters on DOS keyboard input functions
	    01h return partially-formed (interim) characters also
Return: AL = status
	    00h successful
	    FFh invalid mode
Notes:	Novell DOS 7 simply stores DL in the caller's PSP (see #1032 at AH=26h)
	the US version of MS-DOS 3.30 treats this as an unused function,
	  setting AL=00h and returning immediately; only the Far East versions
	  of MS-DOS 3.2 and 3.3 supported this call
SeeAlso: AH=07h,AH=08h,AH=0Bh,AX=6300h,AX=6302h
--------D-216302-----------------------------
INT 21 - DOS 2.25, DOS 3.2+ - GET KOREAN (HANGEUL) INPUT MODE
	AX = 6302h
Return: AL = status
	    00h successful
		DL = current input mode
		    00h return only full characters (clears interim flag)
		    01h return partial characters (sets interim flag)
	    FFh not supported
Notes:	Novell DOS 7 simply reads the value out of the caller's PSP, so it
	  can return values other than 00h or 01h if the last call to AX=6301h
	  used another value
	the US version of MS-DOS 3.30 treats this as an unused function,
	  setting AL=00h and returning immediately, WITHOUT setting DL; only
	  the Far East versions of MS-DOS 3.2 and 3.3 supported this call
SeeAlso: AH=07h,AH=08h,AH=0Bh,AX=6300h,AX=6301h
--------v-216303------------------------
INT 21 - VIRUS - "DOS IDLE" - INSTALLATION CHECK
	AX = 6303h
Return: BX = 6303h if resident
SeeAlso: AX=5643h"VIRUS",AX=6304h"VIRUS",AX=9AD5h"VIRUS"
--------v-216304------------------------
INT 21 - VIRUS - "Replicator" - INSTALLATION CHECK
	AX = 6304h
Return: BX = 6304h if resident
SeeAlso: AX=6303h"VIRUS",AX=6969h"VIRUS"
--------D-2164-------------------------------
INT 21 - DOS 3.2+ internal - SET DEVICE DRIVER LOOKAHEAD FLAG
	AH = 64h
	AL = flag
		00h (default) call device driver function 5 (non-dest read)
			before INT 21/AH=01h,08h,0Ah
	    nonzero don't call driver function 5
Return: nothing (MS-DOS)
	CF set, AX=error code??? (DR DOS 5.0, which does not support this call)
Notes:	this function is called by the DOS 3.3+ PRINT.COM
	under MS-DOS, this function does not use any of the DOS-internal stacks
	  and may thus be called at any time, even during another DOS call
SeeAlso: AH=01h,AH=08h,AH=0Ah,AX=5D06h
--------O-2164--DX0000-----------------------
INT 21 U - OS/2 v2.0+ Virtual DOS Machine - ENABLE AUTOMATIC TITLE SWITCH
	AH = 64h
	DX = 0000h (function number)
	CX = 636Ch (magic value, "cl")
	BX = 0000h (indicates special request)
Note:	if CX is not 636Ch on entry, INT 21/AH=6Ch is invoked, because a bug
	  in OS/2 1.x FAPI erroneously called AH=64h instead of AH=6Ch
SeeAlso: AH=64h/DX=0001h,INT 21/AH=4Bh
--------O-2164--DX0001-----------------------
INT 21 U - OS/2 v2.0+ Virtual DOS Machine - SET SESSION TITLE
	AH = 64h
	DX = 0001h (function number)
	CX = 636Ch (magic value, "cl")
	BX = 0000h (indicates special request)
	ES:DI -> new ASCIZ title (max 12 char) or "" to restore default title
Note:	if CX is not 636Ch on entry, INT 21/AH=6Ch is invoked, because a bug
	  in OS/2 1.x FAPI erroneously called AH=64h instead of AH=6Ch
SeeAlso: AH=64h/DX=0000h,AH=64h/DX=0002h,INT 15/AH=12h/BH=05h
--------O-2164--DX0002-----------------------
INT 21 U - OS/2 v2.0+ Virtual DOS Machine - GET SESSION TITLE
	AH = 64h
	DX = 0002h (function number)
	CX = 636Ch (magic value, "cl")
	BX = 0000h (indicates special request)
	ES:DI -> 13-byte buffer for current title
Return: buffer filled (single 00h if title never changed)
Note:	if CX is not 636Ch on entry, INT 21/AH=6Ch is invoked, because a bug
	  in OS/2 1.x FAPI erroneously called AH=64h instead of AH=6Ch
SeeAlso: AH=64h/DX=0000h,AH=64h/DX=0001h,INT 15/AH=12h/BH=05h
--------O-2164--DX0003-----------------------
INT 21 U - OS/2 v2.1 Virtual DOS Machine - GET LASTDRIVE
	AH = 64h
	DX = 0003h (function number)
	CX = 636Ch (magic value, "cl")
	BX = 0000h (indicates special request)
Return: AL = highest drive supported
Notes:	if CX is not 636Ch on entry, INT 21/AH=6Ch is invoked, because a bug
	  in OS/2 1.x FAPI erroneously called AH=64h instead of AH=6Ch
	used by WinOS2
	not supported by OS/2 Warp 3.0, check list of lists instead (see #1279)
SeeAlso: AH=52h
--------O-2164--DX0004-----------------------
INT 21 U - OS/2 v2.1+ Virtual DOS Machine - GET SIZE OF PTDA JFT
	AH = 64h
	DX = 0004h (function number)
	CX = 636Ch (magic value, "cl")
	BX = 0000h (indicates special request)
Return: AX = number of entries in OS/2 JFT for VDM
Notes:	if CX is not 636Ch on entry, INT 21/AH=6Ch is invoked, because a bug
	  in OS/2 1.x FAPI erroneously called AH=64h instead of AH=6Ch
	in an OS/2 VDM, the DOS Job File Table in the PSP contains an index
	  into the OS/2 JFT in the Per-Task Data Area rather than an SFT index
	  because the OS/2 SFT can contain more than 255 entries
--------O-2164--DX0005-----------------------
INT 21 U - OS/2 v2.1+ Virtual DOS Machine - GET SECOND SFT FLAGS WORD
	AH = 64h
	DX = 0005h (function number)
	CX = 636Ch (magic value, "cl")
	BX = 0000h (indicates special request)
	DI = DOS file handle
Return: AX = value of second flags word from OS/2 SFT entry for file
Notes:	if CX is not 636Ch on entry, INT 21/AH=6Ch is invoked, because a bug
	  in OS/2 1.x FAPI erroneously called AH=64h instead of AH=6Ch
	the OS/2 SFT has two flags words rather than DOS's one word, and this
	  function provides access to the word which is not present in DOS
--------O-2164--DX0006-----------------------
INT 21 U - OS/2 v2.1+ Virtual DOS Machine - UNLOAD DOSKRNL SYMBOLS & LOAD PROGR
	AH = 64h
	DX = 0006h (function number)
	CX = 636Ch (magic value, "cl")
	BX = 0000h (indicates special request)
	ES:DI -> ASCIZ filespec
	DS = base address for loading
Notes:	if CX is not 636Ch on entry, INT 21/AH=6Ch is invoked, because a bug
	  in OS/2 1.x FAPI erroneously called AH=64h instead of AH=6Ch
	this function is only supported by the kernel debugging version of
	  OS2KRNL
--------O-2164--DX0007-----------------------
INT 21 U - OS/2 v2.1+ Virtual DOS Machine - GET WinOS2 CALL GATE ADDRESS
	AH = 64h
	DX = 0007h (function number)
	CX = 636Ch (magic value, "cl")
	BX = 0000h (indicates special request)
Return: AX = call gate address
Notes:	if CX is not 636Ch on entry, INT 21/AH=6Ch is invoked, because a bug
	  in OS/2 1.x FAPI erroneously called AH=64h instead of AH=6Ch
	used by WinOS2 to make direct calls to OS2KRNL, bypassing the overhead
	  of DOSKRNL
--------O-2164--DX0008-----------------------
INT 21 U - OS/2 v2.1+ Virtual DOS Machine - GET LOADING MESSAGE
	AH = 64h
	DX = 0008h (function number)
	CX = 636Ch (magic value, "cl")
	BX = 0000h (indicates special request)
Return: DS:DX -> '$'-terminated message "Loading.  Please wait."
Notes:	if CX is not 636Ch on entry, INT 21/AH=6Ch is invoked, because a bug
	  in OS/2 1.x FAPI erroneously called AH=64h instead of AH=6Ch
	this function permits National Language Support for the initial message
	  displayed while WinOS2 starts a full-screen session
--------O-2164--CX636C-----------------------
INT 21 U - OS/2 v2.1+ Virtual DOS Machine - OS/2 API support
	AH = 64h
	CX = 636Ch ("cl")
	BX = API ordinal (see #1402)
	other registers as appropriate for API call
Return: as appropriate for API call
SeeAlso: AH=64h/BX=0025h,AH=64h/BX=00B6h,AH=64h/BX=00CBh

(Table 1402)
Values for OS/2 API ordinal:
 0025h	DOS32StartSession
 0082h	DosGetCP
 00B6h	DosQFSAttach
 00BFh	DosEditName
 00CBh	DosForceDelete
 0144h	Dos32CreateEventSem
 0145h	Dos32OpenEvenSem
 0146h	Dos32CloseEventSem
 0147h	Dos32ResetEventSem
 0148h	Dos32PostEventSem
 0149h	Dos32WaitEventSem
 014Ah	Dos32QueryEventSem
 014Bh	Dos32CreateMutexSem
 014Ch	Dos32OpenMutexSem
 014Dh	Dos32CloseMutexSem
 014Eh	Dos32RequestMutexSem
 014Fh	Dos32ReleaseMutexSem
 0150h	Dos32QueryMutexSem
 0151h	Dos32CreateMuxWaitSem
 0152h	Dos32OpenMuxWaitSem
 0153h	Dos32CloseMuxWaitSem
 0154h	Dos32WaitMuxWaitSem
 0155h	Dos32AddMuxWaitSem
 0156h	Dos32DeleteMuxWaitSem
 0157h	Dos32QueryMuxWaitSem
--------O-2164--BX0025-----------------------
INT 21 U - OS/2 v2.1+ Virtual DOS Machine - OS/2 API DOS32StartSession
	AH = 64h
	BX = 0025h (API ordinal)
	CX = 636Ch ("cl")
	DS:SI -> STARTDATA structure (see #1403)
Return: AX = return code
SeeAlso: AH=64h/CX=636Ch,AH=64h/BX=00B6h

Format of OS/2 Virtual DOS Machine STARTDATA structure:
Offset	Size	Description	(Table 1403)
 00h	WORD	length of structure (must be 0018h,001Eh,0020h,0032h,or 003Ch)
 02h	WORD	relation of new process to caller (00h independent, 01h child)
 04h	WORD	fore/background (00h foreground, 01h background)
 06h	WORD	trace options (00h-02h, 00h = no trace)
 08h	DWORD	pointer to ASCIZ program title (max 62 chars) or 0000h:0000h
 0Ch	DWORD	pointer to ASCIZ program name (max 128 chars) or 0000h:0000h
 10h	DWORD	pointer to ASCIZ program args (max 144 chars) or 0000h:0000h
 14h	DWORD	"TermQ" (currently reserved, must be 00000000h)
 18h	DWORD	pointer to environment (max 486 bytes) or 0000h:0000h
 1Ch	WORD	inheritance (00h or 01h)
 1Eh	WORD	session type
		00h OS/2 session manager determines type (default)
		01h OS/2 full-screen
		02h OS/2 window
		03h PM
		04h VDM full-screen
		07h VDM window
 20h	DWORD	pointer to ASCIZ icon filename (max 128 chars) or 0000h:0000h
 24h	DWORD	"PgmHandle" (currently reserved, must be 00000000h)
 28h	WORD	"PgmControl"
 2Ah	WORD	initial column
 2Ch	WORD	initial row
 2Eh	WORD	initial width
 30h	WORD	initial height
 32h	WORD	reserved (0)
 34h	DWORD	"ObjectBuffer" (currently reserved, must be 00000000h)
 38h	DWORD	"ObjectBufferLen" (currently reserved, must be 00000000h)
--------O-2164--BX00B6-----------------------
INT 21 U - OS/2 v2.1+ Virtual DOS Machine - OS/2 API DosQFSAttach
	AH = 64h
	BX = 00B6h (API ordinal)
	CX = 636Ch (magic value "cl")
	DS = user's data segment
	ES:DI -> FSQAttachStruc (see #1404)
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
	    AX = 0000h
	    data buffer filled
SeeAlso: AH=64h/CX=636Ch

Format of OS/2 Virtual DOS Machine FSQAttachStruc:
Offset	Size	Description	(Table 1404)
 00h	DWORD	reserved
 04h	DWORD	pointer to the offset of the data buffer length
 08h	DWORD	pointer to the offset of the data buffer
 0Ch	WORD	FSA Info level
 0Eh	WORD	ordinal index into table
 10h	DWORD	pointer to the offset of the device name
Notes:	The segment value of the buffer, buffer length, and device
	  name MUST all be the same.  It is defined on entry in the DS
	  register.  The details of each info level are defined in the
	  OS/2 CP Reference.
--------O-2164--BX00CB-----------------------
INT 21 U - OS/2 v2.1+ Virtual DOS Machine - OS/2 API DosForceDelete
	AH = 64h
	BX = 00CBh (API ordinal)
	CX = 636Ch (magic value "cl")
	DS:DX -> ASCIZ filename
Return: CF clear if successful
	    AX destroyed
	CF set on error
	    AX = error code (02h,03h,05h) (see #1332 at AH=59h/BX=0000h)
Desc:	delete a file without saving it to the undelete directory
SeeAlso: AH=41h,AH=64h/CX=636Ch
--------D-2165-------------------------------
INT 21 - DOS 3.3+ - GET EXTENDED COUNTRY INFORMATION
	AH = 65h
	AL = info ID
	    01h get general internationalization info
	    02h get pointer to uppercase table
	    04h get pointer to filename uppercase table
	    05h get pointer to filename terminator table
	    06h get pointer to collating sequence table
	    07h (DOS 4.0+) get pointer to Double-Byte Character Set table
	BX = code page (FFFFh=global code page) (see #1411)
	DX = country ID (FFFFh=current country)
	ES:DI -> country information buffer (see #1405)
	CX = size of buffer (>= 5)
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
	    CX = size of country information returned
	    ES:DI -> country information
Notes:	AL=05h appears to return same info for all countries and codepages; it
	  has been documented for DOS 5+, but was undocumented in earlier
	  versions
	NLSFUNC must be installed to get info for countries other than the
	  default
	subfunctions 02h and 04h are identical under OS/2
SeeAlso: AH=38h,AH=70h"MS-DOS 7",INT 2F/AX=1401h,INT 2F/AX=1402h
SeeAlso: INT 2F/AX=14FEh

Format of country information:
Offset	Size	Description	(Table 1405)
 00h	BYTE	info ID
---if info ID = 01h---
 01h	WORD	size
 03h	WORD	country ID (see #1054 at AH=38h)
 05h	WORD	code page (see #1411)
 07h 34 BYTEs	country-dependent info (see #1053 at AH=38h)
---if info ID = 02h---
 01h	DWORD	pointer to uppercase table (see #1406)
---if info ID = 04h---
 01h	DWORD	pointer to filename uppercase table (see #1407)
---if info ID = 05h---
 01h	DWORD	pointer to filename character table (see #1408)
---if info ID = 06h---
 01h	DWORD	pointer to collating table (see #1409)
---if info ID = 07h (DOS 4.0+)---
 01h	DWORD	pointer to DBCS lead byte table (see #1410)
SeeAlso: #1429

Format of uppercase table:
Offset	Size	Description	(Table 1406)
 00h	WORD	table size
 02h 128 BYTEs	uppercase equivalents (if any) of chars 80h to FFh
SeeAlso: #1405,#1407

Format of filename uppercase table:
Offset	Size	Description	(Table 1407)
 00h	WORD	table size
 02h 128 BYTEs	uppercase equivalents (if any) of chars 80h to FFh
SeeAlso: #1405,#1406

Format of filename terminator table:
Offset	Size	Description	(Table 1408)
 00h	WORD	table size (not counting this word)
 02h	BYTE	??? (01h for MS-DOS 3.30-6.00)
 03h	BYTE	lowest permissible character value for filename
 04h	BYTE	highest permissible character value for filename
 05h	BYTE	??? (00h for MS-DOS 3.30-6.00)
 06h	BYTE	first excluded character in range \ all characters in this
 07h	BYTE	last excluded character in range  / range are illegal
 08h	BYTE	??? (02h for MS-DOS 3.30-6.00)
 09h	BYTE	number of illegal (terminator) characters
 0Ah  N BYTEs	characters which terminate a filename:	."/\[]:|<>+=;,
Note:	partially documented for DOS 5+, but undocumented for earlier versions
SeeAlso: #1405

Format of collating table:
Offset	Size	Description	(Table 1409)
 00h	WORD	table size
 02h 256 BYTEs	values used to sort characters 00h to FFh
SeeAlso: #1405

Format of DBCS lead byte table:
Offset	Size	Description	(Table 1410)
 00h	WORD	length
 02h 2N BYTEs	start/end for N lead byte ranges
	WORD	0000h	(end of table)
SeeAlso: #1405
--------D-2165-------------------------------
INT 21 - DOS 4.0+ - COUNTRY-DEPENDENT CHARACTER CAPITALIZATION
	AH = 65h
	AL = function
	    20h capitalize character
		DL = character to capitalize
		Return: DL = capitalized character
	    21h capitalize string
		DS:DX -> string to capitalize
		CX = length of string
	    22h capitalize ASCIZ string
		DS:DX -> ASCIZ string to capitalize
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
Note:	these calls have been documented for DOS 5+, but were undocumented in
	  DOS 4.x.
--------D-216523-----------------------------
INT 21 U - DOS 4.0+ - DETERMINE IF CHARACTER REPRESENTS YES/NO RESPONSE
	AX = 6523h
	DL = character
	DH = second character of double-byte character (if applicable)
Return: CF set on error
	CF clear if successful
	    AX = type
		00h no
		01h yes
		02h neither yes nor no
Note:	supported by Novell DOS 7, though prior to Update 14, the results
	  depended on the kernel variant rather than the COUNTRY= setting
--------D-2165-------------------------------
INT 21 U - DOS 4.0+ internal - COUNTRY-DEPENDENT FILENAME CAPITALIZATION
	AH = 65h
	AL = function
	    A0h capitalize filename character
		DL = character to capitalize
		Return: DL = capitalized character
	    A1h capitalize counted filename string
		DS:DX -> filename string to capitalize
		CX = length of string
	    A2h capitalize ASCIZ filename
		DS:DX -> ASCIZ filename to capitalize
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
Note:	nonfunctional in MS-DOS 4.00 through 6.00 due to a bug (the code sets a
	  pointer depending on the high bit of AL, but doesn't clear the
	  bit before branching by function number).  Supported and
	  functional(!) in Novell DOS 7 (Update 15)
--------D-216601-----------------------------
INT 21 - DOS 3.3+ - GET GLOBAL CODE PAGE TABLE
	AX = 6601h
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
	    BX = active code page (see #1411)
	    DX = system code page (see #1411)
SeeAlso: AX=6602h
--------D-216602-----------------------------
INT 21 - DOS 3.3+ - SET GLOBAL CODE PAGE TABLE
	AX = 6602h
	BX = active code page (see #1411)
	DX = system code page (active page at boot time)
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
	    AX = EB41h (Novell NWDOS v7.0 when NLSFUNC not installed and
		  request was for previously-active code page)
SeeAlso: AX=6601h,INT 2F/AX=14FFh

(Table 1411)
Values for code page:
 437	US
 850	Multilingual
 852	Slavic/Latin II (DOS 5+)
 857	Turkish
 860	Portugal
 861	Iceland
 863	Canada (French)
 865	Norway/Denmark

Format of DOS .CPI (Code Page Information) file header:
Offset	Size	Description	(Table 1412)
 00h	BYTE	ID tag
		FFh FONT file (Standard for generic display or
		      printer font files used by MS-DOS, PC-DOS, DR DOS
		      and Novell DOS)
		7Fh DRFONT file (Used by DR DOS 6.0 / Novell DOS 7 for
		      enhanced & compressed display font files. DR DOS 6.0
		      and Novell DOS 7 still support the standard FONT
		      files, thus allowing leaning of .CPI files from
		      MS-DOS to DR DOS / Novell DOS!)
 01h  7 BYTEs	ID string
		"FONT	" = FONT file (Standard for display or printer)
		"DRFONT " = DRFONT file (Enhanced compressed format used
			    by DR DOS 6.0 / Novell DOS 7 for display fonts)
 08h  8 BYTEs	reserved (0)
 10h	WORD	number of pointers (1)
 12h	BYTE	type of pointers (1)
 13h	DWORD	pointer to file offset of FontInfoHeader
		(Generally pointing to the byte just after FontFileHeader,
		     that is 0000h:0017h. Due to extra data at offset 17h, this
		     value has changed with DR DOS 6.0 / Novell DOS 7 DRFONTs!
		     "MS-DOS 4.0 programmers reference" claimed word offset
		     +15h as an endmarker (0000h), but actually it is the
		     High-Word of the pointer.)
--- Extended FontFileHeader with DR DOS 6.0 / Novell DOS 7 DRFONTs: ---
 17h	BYTE	number of fonts per codepage supported by this file
		     (N=4 with both DR DOS 6.0 / Novell DOS 7 DRFONT files)
 18h  N	BYTEs	cellsize (Height) of fonts 1..N
		the cellsize corresponds with the character boxes height,
		  but is also the count of bytes used for each of the
		  characters inside the font data (as currently all fonts
		  are organized heightx8 and 8 pixel width is just one byte).
 var  N DWORDs	file offsets of DisplayFontData.

Format of DOS .CPI file Font Information Header:
Offset	Size	Description	(Table 1413)
 00h	WORD	number of codepage entries
	var	N codepage entry headers (see #1414)
SeeAlso: #1412

Format of DOS .CPI file CodePage Entry Header:
Offset	Size	Description	(Table 1414)
 00h	WORD	size of this header (normally 1Ch)
 02h	DWORD	offset of next entry, or 0000h:0000h or FFFFh:FFFFh if last
		(if a valid "next" pointer but all of the fonts indicated in
		  the .CPI header have been processed, this field normally
		  points at an optional text area at the end of the .CPI file
		  containing copyright information)
 06h	WORD	device type
		01h display (FONT or DRFONT)
		02h printer (FONT)
 08h  8 BYTEs	blank-padded device name string
 10h	WORD	code page (see #1411)
 12h  3 WORDs	reserved (0)
 18h	DWORD	pointer to Font Data Header (see #0147)
		normally immediately follows this header
SeeAlso: #1412

Format of DOS .CPI file Font Data Header:
Offset	Size	Description	(Table 1415)
 00h	WORD	record type
		0001h FONT
		0002h DRFONT (DR-DOS 6.0/Novell DOS 7 display font)
 02h	WORD	number of fonts
 04h	WORD	length of font data (display fonts)
		??? (printer fonts)
 06h	var	font data (#fonts * fontlength) bytes
SeeAlso: #1412

Format of DOS .CPI file ScreenFONT Header:
Offset	Size	Description	(Table 1416)
 00h  6 BYTEs	display-font header (see #1418)
 06h	var	display font data
SeeAlso: #1412

Format of .CPI file DRFONT Header:
Offset	Size	Description	(Table 1417)
 00h 6N BYTEs	DisplayFONT headers for N fonts (see #1418)
      M WORDs	character index table for cell offsets in font data
		currently 256 words in length
SeeAlso: #1412

Format of .CPI file DisplayFONT header:
Offset	Size	Description	(Table 1418)
 00h	BYTE	height of character cell
 01h	BYTE	width of character cell (currently always 08h)
 02h	BYTE	aspect ratio (height) (currently 00h, unused)
 03h	BYTE	aspect ratio (width) (currently 00h, unused)
 04h	WORD	number of characters per font (256)
SeeAlso: #1412

Format of .CPI file PrinterFONT header:
Offset	Size	Description	(Table 1419)
 00h	WORD	type of printer
		0001h (4201.CPI, 1050.CPI, EPS.CPI)
		0002h (4208.CPI, 5202.CPI, PPDS.CPI)
 02h	WORD	bytes per hardware/download codepage-select escape sequence
		(max 31, typically 12)
 04h  N BYTEs	escape sequence to select hardware codepage
      N BYTEs	escape sequence to select download codepage
	var	download data for printer font (including escape sequence to
		  transfer data)
SeeAlso: #1412
--------D-2167-------------------------------
INT 21 - DOS 3.3+ - SET HANDLE COUNT
	AH = 67h
	BX = size of new file handle table for process
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
Desc:	adjust the size of the per-process open file table, thus raising or
	  lowering the limit on the number of files the caller can open
	  simultaneously
Notes:	if BX <= 20, no action is taken if the handle limit has not yet been
	  increased, and the table is copied back into the PSP if the limit
	  is currently > 20 handles
	for file handle tables of > 20 handles, DOS 3.30 never reuses the
	  same memory block, even if the limit is being reduced; this can lead
	  to memory fragmentation as a new block is allocated and the existing
	  one freed
	only the first 20 handles are copied to child processes in DOS 3.3-6.0
	increasing the file handles here will not, in general, increase the
	  number of files that can be opened using the runtime library of a
	  high-level language such as C
	Novell DOS 7 reportedly terminates the calling program if the JFT is
	  being reduced in size and there are any open file handles beyond
	  the portion of the JFT being retained
BUGS:	the original release of DOS 3.30 allocates a full 64K for the handle
	  table on requests for an even number of handles
	DR DOS 3.41 and 5.0 will lose track of any open file handles beyond
	  the portion of the JFT retained after the call; MS-DOS will indicate
	  error 04h if any of the JFT entries to be removed are open
SeeAlso: AH=26h,AH=86h
--------D-2168-------------------------------
INT 21 - DOS 3.3+ - "FFLUSH" - COMMIT FILE
	AH = 68h
	BX = file handle
Return: CF clear if successful
	    all data still in DOS disk buffers is written to disk immediately,
	      and the file's directory entry is updated
	CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
SeeAlso: AX=5D01h,AH=6Ah,INT 2F/AX=1107h
--------D-2169-------------------------------
INT 21 U - DOS 4.0+ internal - GET/SET DISK SERIAL NUMBER
	AH = 69h
	AL = subfunction
	    00h get serial number
	    01h set serial number
	BL = drive (0=default, 1=A, 2=B, etc)
	BH = info level (00h only for DOS; OS/2 allows other levels)
	DS:DX -> disk info (see #1420)
Return: CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
	    AX destroyed
	    (AL = 00h) buffer filled with appropriate values from extended BPB
	    (AL = 01h) extended BPB on disk set to values from buffer
Notes:	does not generate a critical error; all errors are returned in AX
	error 0005h given if no extended BPB on disk
	does not work on network drives (error 0001h)
	buffer after first two bytes is exact copy of bytes 27h thru 3Dh of
	  extended BPB on disk
	this function is supported under Novell NetWare versions 2.0A through
	  3.11; the returned serial number is the one a DIR would display,
	  the volume label is the NetWare volume label, and the file system
	  is set to "FAT16".
	this function is not supported by Novell DOS 7 through Update 13, but
	  Personal NetWare 1.0 does support this function
	the serial number is computed from the current date and time when the
	  disk is created; the first part is the sum of the seconds/hundredths
	  and month/day, the second part is the sum of the hours/minutes and
	  year
	the volume label which is read or set is the one stored in the extended
	  BPB on disks formatted with DOS 4.0+, rather than the special root
	  directory entry used by the DIR command in COMMAND.COM (use AH=11h
	  to find that volume label)
SeeAlso: AX=440Dh"DOS 3.2+"

Format of disk info:
Offset	Size	Description	(Table 1420)
 00h	WORD	0000h (info level)
 02h	DWORD	disk serial number (binary)
 06h 11 BYTEs	volume label or "NO NAME    " if none present
 11h  8 BYTEs	(AL=00h only) filesystem type (see #1421)

(Table 1421)
Values for filesystem type:
 "FAT12	  "	12-bit FAT
 "FAT16	  "	16-bit FAT
 "CDROM	  "	High-Sierra CD-ROM filesystem
 "CD001	  "	ISO 9660 CD-ROM filesystem
 "CDAUDIO "	audio CD
SeeAlso: #1420
--------O-2169-------------------------------
INT 21 - DR DOS 5.0 - NULL FUNCTION
	AH = 69h
Return: AL = 00h
SeeAlso: AH=18h
--------v-216969-----------------------------
INT 21 - VIRUS - "Rape-747" - INSTALLATION CHECK
	AX = 6969h
Return: AX = 0666h if resident
SeeAlso: AX=58CCh,AX=6304h"VIRUS",AH=71h"VIRUS"
--------d-2169FFDX0000-----------------------
INT 21 U - CUBIT v4.00 - GET CUBIT INT 21 HANDLER
	AX = 69FFh
	DX = 0000h
	BX = CB00h (magic value)
Return: ES:BX -> CUBITR.EXE handler for INT 21
Note:	the installation check consists of testing that the first eight bytes
	  at the returned interrupt handler are EBh 07h "CUBITR" (a short
	  jump around the signature followed by the signature); the byte
	  following the signature (i.e. ES:[BX+8]) indicates whether CUBITR
	  is active (01h) or disabled (00h)
SeeAlso: AX=69FFh/DX=CFBFh
Index:	installation check;CUBIT
--------d-2169FFDXCFBF-----------------------
INT 21 U - CUBIT v4.00 - UNINSTALL
	AX = 69FFh
	DX = CFBFh
	CX = EFCFh
	BX = CB00h (magic value)
Return: ES:BX -> CUBITR.EXE handler for INT 21
	CX = status
	    2020h successful
	    2222h failed
Note:	if DX is neither 0000h nor CFBFh on entry, some other code is executed
SeeAlso: AX=69FFh/DX=0000h
--------D-216A-------------------------------
INT 21 U - DOS 4.0+ - COMMIT FILE
	AH = 6Ah
	BX = file handle
Return: CF clear if successful
	    AH = 68h
	CF set on error
	    AX = error code (06h) (see #1332 at AH=59h/BX=0000h)
Note:	identical to AH=68h in DOS 5.0-6.0; not known whether this is the case
	  in DOS 4.x
SeeAlso: AH=68h
--------D-216B-------------------------------
INT 21 U - DOS 4.0 internal - IFS IOCTL
	AH = 6Bh
	AL = subfunction
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
Return: CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
	CF clear if successful
Note:	passed through to INT 2F/AX=112Fh with AX on top of stack
SeeAlso: AH=6Bh"DOS 5",INT 2F/AX=112Fh
--------D-216B-------------------------------
INT 21 U - DOS 5+ - NULL FUNCTION
	AH = 6Bh
Return: AL = 00h
Note:	this function does nothing and returns immediately
SeeAlso: AH=6Bh"DOS 4"
--------D-216C00-----------------------------
INT 21 - DOS 4.0+ - EXTENDED OPEN/CREATE
	AX = 6C00h
	BL = open mode as in AL for normal open (see also AH=3Dh)
	    bit 7: inheritance
	    bits 4-6: sharing mode
	    bit 3 reserved
	    bits 0-2: access mode
		100 read-only, do not modify file's last-access time (DOS 7.0)
	BH = flags
	    bit 6 = auto commit on every write (see also AH=68h)
	    bit 5 = return error rather than doing INT 24h
	    bit 4 = (FAT32) extended size (>= 2GB)
	CX = create attribute (see #1423)
	DL = action if file exists/does not exist (see #1424)
	DH = 00h (reserved)
	DS:SI -> ASCIZ file name
Return: CF set on error
	   AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
	   AX = file handle
	   CX = status (see #1422)
Notes:	the PC LAN Program only supports existence actions (in DL) of 01h,
	  10h with sharing=compatibility, and 12h
	DR DOS reportedly does not support this function and does not return
	  an "invalid function call" error when this function is used.
	the documented bits of BX are stored in the SFT when the file is opened
	  (see #1293,#1294)
BUG:	this function has bugs (at least in DOS 5.0 and 6.2) when used with
	  drives handled via the network redirector (INT 2F/AX=112Eh):
	    - CX (attribute) is not passed to the redirector if DL=11h,
	    - CX does not return the status, it is returned unchanged because
	      DOS does a PUSH CX/POP CX when calling the redirector.
SeeAlso: AH=3Ch,AH=3Dh,AX=6C01h,AH=71h,INT 2F/AX=112Eh

(Table 1422)
Values for extended open function status:
 01h	file opened
 02h	file created
 03h	file replaced

Bitfields for file create attribute:
Bit(s)	Description	(Table 1423)
 6-15	reserved
 5	archive
 4	reserved
 3	volume label
 2	system
 1	hidden
 0	readonly

Bitfields for action:
Bit(s)	Description	(Table 1424)
 7-4	action if file does not exist
	0000 fail
	0001 create
 3-0	action if file exists
	0000 fail
	0001 open
	0010 replace/open
--------O-216C01-----------------------------
INT 21 U - OS/2 v2.0 - "DosOpen2"
	AX = 6C01h
	BL = open mode as in AL for normal open (see also AH=3Dh)
	    bit 7: inheritance
	    bits 4-6: sharing mode
	    bit 3 reserved
	    bits 0-2: access mode
	BH = flags
	    bit 6 = auto commit on every write (see also AH=68h)
	    bit 5 = return error rather than doing INT 24h
	CX = create attribute (see #1423)
	DL = action if file exists/does not exist (see #1424)
	DH = 00h (reserved)
	DS:SI -> ASCIZ file name
	ES:DI -> EAOP structure
Return: CF set on error
	   AX = error code (see #1332 at AH=59h/BX=0000h)
	CF clear if successful
	   AX = file handle
	   CX = status (see #1422)
Note:	this function is virtually identical to AX=6C00h, but supports OS/2's
	  extended attributes
SeeAlso: AX=5704h,AX=6C00h,AH=6Fh"OS/2"
--------D-216D-------------------------------
INT 21 U - DOS 5+ ROM - FIND FIRST ROM PROGRAM
	AH = 6Dh
	DS:DX -> ASCIZ program name (may contain wildcrds)
Return: CF clear if found
	    Disk Transfer Area filled with ROM search structure (see #1425)
	CF set if not found
	    AX = error code
		0002h name not found in ROM
		0003h name contains colon or backslash
	---if not supported (DOS <5, MS-DOS 5+ non-ROM versions)---
	AL = 00h
Notes:	the '*' wildcard matches all remaining characters in a ROM program's
	  name; any following characters in the search mask are ignored up to
	  another asterisk, which must be matched by an asterisk in the
	  found program's name.
	the search mask and program names may contain multiple periods
SeeAlso: AH=1Ah,AH=4Eh,AH=6Eh,AX=6F00h,AX=6F02h,INT 2F/AX=160Ch

Format of ROM search structure:
Offset	Size	Description	(Table 1425)
 00h 13 BYTEs	ASCIZ name of found ROM program
 0Dh	DWORD	address at which to resume search (do not modify)
 11h	var	ASCIZ search mask passed in (do not modify)
--------O-216D-------------------------------
INT 21 U - OS/2 v1.x FAPI - "DosMkDir2"
	AH = 6Dh
	???
Return: ???
Desc:	create a new directory, with extended attribute information
Note:	also supported by OS/2 v2.0+ Virtual DOS Machines
BUG:	does not work under OS/2 v2.0 because MVDM does not translate the
	  real-mode segment pointer in the Extended Attribute structure
	  (see #1325) into a protected-mode selector; use AH=39h followed by
	  AX=5703h instead
SeeAlso: AH=39h,AX=5702h"OS/2",AX=5703h"OS/2"
--------O-216D-------------------------------
INT 21 U - Novell DOS 7 - NOP
	AH = 6Dh
Return: AX = 0000h
Note:	this function invokes the same code as other NOP functions such as
	  AH=18h and AH=61h
--------D-216E-------------------------------
INT 21 U - DOS 5+ ROM - FIND NEXT ROM PROGRAM
	AH = 6Eh
	Disk Transfer Area contains result of previous FindFirst ROM
	  (see AH=6Dh)
Return: CF clear if found
	    Disk Transfer Area filled with updated ROM search structure
	      (see #1425)
	CF set if not found
	    AX = 0012h (no more matches)
	---if not supported (DOS <5, MS-DOS 5+ non-ROM versions)---
	AL = 00h
SeeAlso: AH=4Fh,AH=6Dh
--------O-216E-------------------------------
INT 21 U - OS/2 v1.x FAPI - "DosEnumAttrib"
	AH = 6Eh
	DS:SI -> parameter packet (see #1426)
Return: CF clear if successful
	    AX = 0000h
	    DS:SI buffer updated
	CF set on error
	    AX = error code
Note:	also supported by OS/2 v2.0+ Virtual DOS Machines
SeeAlso: AX=5703h,AH=6Fh"OS/2",INT 2F/AX=112Dh

Format of OS/2 DosEnumAttrib parameter packet:
Offset	Size	Description	(Table 1426)
 00h	DWORD	reserved (0)
 04h	DWORD	info level (always 00000001h)
 08h	DWORD	(call) number of entries requested
		(ret) actual number of entries returned
 0Ch	DWORD	length of buffer
 10h	DWORD	pointer to buffer for results
 14h	DWORD	number of first entry to return
 18h	DWORD	-> file handle or ASCIZ pathname
 1Ch	WORD	flag: 00h = previous field is file handle, 01h = pathname
--------D-216F00-----------------------------
INT 21 U - DOS 5+ ROM - GET ROM SCAN START ADDRESS
	AX = 6F00h
Return: CF clear
	AL = 00h
	    BX = current ROM scan starting segment if function supported
SeeAlso: AH=6Dh,AX=6F01h,AX=6F02h
--------O-216F00-----------------------------
INT 21 U - OS/2 v1.x FAPI - "DosQMaxEASize" - GET MAXIMUM SIZE OF EXTENDED ATTR
	AX = 6F00h
	DS:SI -> DWORD buffer for maximum size of an extended attribute
Return: CF clear if successful
	    AX = 0000h
	    buffer filled
	CF set on error
	    AX = error code
Note:	also supported by OS/2 v2.0+ Virtual DOS Machines
SeeAlso: AX=5703h,AX=6C01h,AH=6Eh"OS/2"
--------D-216F01-----------------------------
INT 21 U - DOS 5+ ROM - SET ROM SCAN START ADDRESS
	AX = 6F01h
	BX = new ROM scan starting address
Return: CF clear
	AL = 00h
SeeAlso: AX=6F00h,AX=6F03h
--------D-216F02-----------------------------
INT 21 U - DOS 5+ ROM - GET EXCLUSION REGION LIST
	AX = 6F02h
	ES:BX -> buffer for exclusion region list (see #1427)
Return: CF clear
	AL = 00h
	ES:BX = 0000h:0000h on error, unchanged if buffer filled
Note:	for DOS versions which do not support this function, the return value
	  is AL=00h, CF unchanged, ES:BX unchanged, and the ES:BX buffer
	  unchanged
SeeAlso: AX=6F00h,AX=6F03h

Format of ROM exclusion region list:
Offset	Size	Description	(Table 1427)
 00h	WORD	number of entries
 02h 2N WORDs	start/end segments of N excluded regions
--------D-216F03-----------------------------
INT 21 U - DOS 5+ ROM - SET EXCLUSION REGION LIST
	AX = 6F03h
	DS:DX -> new exclusion region list (see #1427)
Return: CF clear
	AL = 00h
Notes:	DOS saves only the pointer and assumes that the contents of the list
	  are never changed, and that regions do not overlap
	if AL > 03h on entry, DOS returns CF set/AL=01h
SeeAlso: AX=6F01h,AX=6F02h
--------D-2170-------------------------------
INT 21 - MS-DOS 7 (Windows95) - GET/SET INTERNATIONALIZATION INFORMATION
	AH = 70h
	AL = subfunction
	    00h get ??? info
		CX = buffer size (3Ah bytes needed)
		ES:DI -> buffer
	    01h set above info
		CX = number of bytes to set
		DS:SI -> buffer containing ??? info (see #1428)
	    02h set general internationalization info
		DS:SI -> buffer containing info (see #1429)
		CX = buffer size in bytes (up to 26h bytes used)
		first three bytes are skipped, the rest is copied to somewhere
		  in the DOS data segment
Return: CF clear if successful
	    ES:DI buffer filled (func 00h) (see #1428)
	    CX = number of bytes actually set or returned
		  (max 003Ah for functions 00h and 01h under v7.00, 0026h for
		  function 02h)
	CF set on error
	    AX = error code
		7000h if function not supported
SeeAlso: AH=38h,AH=65h

Format of MS-DOS v7.0 ??? table:
Offset	Size	Description	(Table 1428)
 00h 58 BYTEs	??? country-specific information
		returned was (among others) "ENU USA GR"..."AM PM M/d/yy"...
		 "dddd,MMMMdd,yyyy" in the German Preview version, and "US"
		 instead of "GR" in the US build 450 version (with German
		 country setting) and the US build 950a version with US
		 country settings
SeeAlso: #1429

Format of MS-DOS v7.0 internationalization table:
Offset	Size	Description	(Table 1429)
 00h  3 BYTEs	unused (and ignored by DOS)
 03h	WORD	country ID (see #1054 at AH=38h)
 05h	WORD	code page (see #1411)
 07h	WORD	date format
 09h  5 BYTEs	ASCIZ current symbol string
 07h  2 BYTEs	ASCIZ thousands separator
 09h  2 BYTEs	ASCIZ decimal separator
 0Bh  2 BYTEs	ASCIZ date separator
 0Dh  2 BYTEs	ASCIZ time separator
 0Fh	BYTE	currency format
		bit 2 = set if currency symbol replaces decimal point
		bit 1 = number of spaces between value and currency symbol
		bit 0 = 0 if currency symbol precedes value
			1 if currency symbol follows value
 10h	BYTE	number of digits after decimal in currency
 11h	BYTE	time format
		bit 0 = 0 if 12-hour clock
			1 if 24-hour clock
 12h	DWORD	address of case map routine
		(FAR CALL, AL = character to map to upper case [>= 80h])
 16h  2 BYTEs	ASCIZ data-list separator
 18h 10 BYTEs	reserved
Note:	this table has the identical format to the extended country information
	  retrieved via AH=65h with info ID = 01h
SeeAlso: #1053,#1405
----------217070BX6060-----------------------
INT 21 - PCW Weather Card interface - GET DATA SEGMENT
	AX = 7070h
	BX = 6060h
	CX = 7070h
	DX = 7070h
	SI = 7070h
	DI = 7070h
Return: AX = segment of data structure (see #1430)
Notes:	the data structure is at offset 516 from this segment
	the update byte is at offset 514 from this segment.  Updates are
	  once per second while this byte is nonzero and it is decremented
	  once per second.  While this byte is 0 updates are once per minute.
SeeAlso: AX=7070h/BX=7070h

Format of PCW Weather Card data structure:
Offset	Type	Description	(Table 1430)
 00h	WORD	hour
 02h	WORD	minute
 04h	WORD	second
 06h	WORD	day
 08h	WORD	month
 0Ah	WORD	year
 0Ch	WORD	???
 0Eh	WORD	relative barometric pressure (in 1/100 inches)
 10h	WORD	???
 12h	WORD	???
 14h	WORD	temperature 1 (in 1/10 degrees F)
 16h	WORD	temperature 1 lowest (in 1/10 degrees F)
 18h	WORD	temperature 1 highest (in 1/10 degrees F)
 1Ah	WORD	temperature 2 (in 1/10 degrees F)
 1Ch	WORD	temperature 2 lowest (in 1/10 degrees F)
 1Eh	WORD	temperature 2 highest (in 1/10 degrees F)
 20h	WORD	wind speed (in MPH)
 22h	WORD	average of 60 wind speed samples (in MPH)
 24h	WORD	highest wind speed (in MPH)
 26h	WORD	wind chill factor  (in 1/10 degrees F)
 28h	WORD	lowest wind chill factor (in 1/10 degrees F)
 2Ah	WORD	???
 2Ch	WORD	wind direction (in degrees)
 2Eh	WORD	accumulated daily rainfall (in 1/10 inches)
 30h	WORD	accumulated annual rainfall (in 1/10 inches)
----------217070BX7070-----------------------
INT 21 - PCW Weather Card interface - INSTALLATION CHECK
	AX = 7070h
	BX = 7070h
	CX = 7070h
	DX = 7070h
	SI = 7070h
	DI = 7070h
Return: AX = 0070h
	BX = 0070h
	CX = 0070h
	DX = 0070h
	SI = 0070h
	DI = 0070h
SeeAlso: AX=7070h/BX=6060h,AX=8080h
--------D-2171-------------------------------
INT 21 - Windows95 - LONG FILENAME FUNCTIONS
	AH = 71h
	AL = function
	    0Dh reset drive
	    39h create directory
	    3Ah remove directory
	    3Bh set current directory
	    41h delete file
	    43h get/set file attributes
	    47h get current directory
	    4Eh find first file
	    4Fh find next file
	    56h move (rename) file
	    60h truename
	    6Ch create/open file
	    A0h get volume information
	    A1h terminate FindFirst/FindNext
	    A6h get file information
	    A7h time conversion
	    A8h generate short filename
	    A9h server create/open file
	    AAh create/terminate SUBST
Return: CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
	CF clear if successful
	    other registers as for corresponding "old" DOS function
Notes:	if error 7100h is returned, the old-style function should be called
	AX=714Eh returns a "search handle" which must be passed to AX=714Fh;
	  when the search is complete, AX=71A1h must be called to terminate
	  the search
	for compatibility with DOS versions prior to v7.00, the carry flag
	  should be set on call to ensure that it is set on exit
SeeAlso: AH=39h,AH=3Ah,AH=3Bh,AH=41h,AX=4300h,AX=4301h,AX=4304h,AX=4306h
SeeAlso: AX=4307h,AH=47h,AH=4Eh,AH=4Fh,AH=56h,AH=6Ch,AX=714Eh,AX=714Fh
SeeAlso: AX=71A0h,AX=71A1h
--------v-2171-------------------------------
INT 21 - VIRUS - "1205" - INSTALLATION CHECK
	AH = 71h
Return: AH = 17h if "1205" is resident
SeeAlso: AX=6969h"VIRUS",AH=76h"VIRUS"
--------D-21710D-----------------------------
INT 21 - Windows95 - RESET DRIVE
	AX = 710Dh
	CX = action (see #1431)
	DX = drive number
Return: CF clear
Note:	for compatibility with DOS versions prior to v7.00, the carry flag
	  should be set on call to ensure that it is set on exit
SeeAlso: AH=0Dh

(Table 1431)
Values for drive reset action:
 0000h	flush filesystem buffers for drive, and reset drive
 0001h	flush filesystem buffers and cache for drive, and reset drive
 0002h	remount DriveSpace volume
--------D-217139-----------------------------
INT 21 - Windows95 - LONG FILENAME - MAKE DIRECTORY
	AX = 7139h
	DS:DX -> ASCIZ long directory name (including path)
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
Note:	for compatibility with DOS versions prior to v7.00, the carry flag
	  should be set on call to ensure that it is set on exit
SeeAlso: AH=39h,AX=713Ah,AX=713Bh
--------D-21713A-----------------------------
INT 21 - Windows95 - LONG FILENAME - REMOVE DIRECTORY
	AX = 713Ah
	DS:DX -> ASCIZ long name of directory to remove
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
Note:	for compatibility with DOS versions prior to v7.00, the carry flag
	  should be set on call to ensure that it is set on exit
SeeAlso: AH=3Ah,AX=7139h
--------D-21713B-----------------------------
INT 21 - Windows95 - LONG FILENAME - CHANGE DIRECTORY
	AX = 713Bh
	DS:DX -> ASCIZ long name of directory to make current
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
Note:	for compatibility with DOS versions prior to v7.00, the carry flag
	  should be set on call to ensure that it is set on exit
SeeAlso: AH=0Eh,AH=3Bh,AX=7139h
--------D-217141-----------------------------
INT 21 - Windows95 - LONG FILENAME - DELETE FILE
	AX = 7141h
	DS:DX -> ASCIZ long name of file to delete
	SI = wildcard and attributes flag
		0000h wildcards are not allowed, and search attributes are
			ignored
		0001h wildcards are allowed, and only files with matching
			names and attributes are deleted
	CL = search attributes
	CH = must-match attributes
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
Note:	for compatibility with DOS versions prior to v7.00, the carry flag
	  should be set on call to ensure that it is set on exit
SeeAlso: AH=41h
--------D-217143-----------------------------
INT 21 - Windows95 - LONG FILENAME - EXTENDED GET/SET FILE ATTRIBUTES
	AX = 7143h
	DS:DX -> ASCIZ filename
	BL = action
	    00h retrieve attributes
		Return:	CX = file attributes (see #1073)
	    01h set attributes
		CX = attributes
	    02h get physical size of compressed file
		Return: DX:AX = actual disk usage of file, in bytes
	    03h set last write date/time
		DI = new last-write date (see #1318)
		CX = new last-write time (see #1317)
	    04h get last write date/time
		Return:	CX = last write time (see #1317)
			DI = last write date (see #1318)
	    05h set last access date
		DI = new last-access date (see #1318)
	    06h get last access date
		Return:	DI = last access date (see #1318)
	    07h set creation date/time
		DI = new creation date (see #1318)
		CX = new creation time (see #1317)
		SI = hundredths (10-millisecond units past time in CX, 0-199)
	    08h get creation date/time
		Return:	CX = creation time (see #1317)
			DI = creation date (see #1318)
			SI = hundredths (10-millisecond units past time in CX)
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
Note:	for compatibility with DOS versions prior to v7.00, the carry flag
	  should be set on call to ensure that it is set on exit
SeeAlso: AX=4300h,AX=4301h
--------D-217147-----------------------------
INT 21 - Windows95 - LONG FILENAME - GET CURRENT DIRECTORY
	AX = 7147h
	DL = drive number (00h = current, 01h = A:, etc.)
	DS:SI -> buffer for ASCIZ directory name
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
Notes:	the returned pathname does not include the drive letter, colon, or
	  leading backslash, and is not necessarily a long filename -- this
	  function returns whatever path was used when changing to the
	  current directory, and may include a mixture of long and short
	  components
	the provided buffer must be at least as large as the value indicated
	  by AX=71A0h
	for compatibility with DOS versions prior to v7.00, the carry flag
	  should be set on call to ensure that it is set on exit
SeeAlso: AH=47h,AX=713Bh,AX=7160h,AX=71A0h
--------D-21714E-----------------------------
INT 21 - Windows95 - LONG FILENAME - FIND FIRST MATCHING FILE
	AX = 714Eh
	CL = allowable-attributes mask (see #1073 at AX=4301h)
	      (bits 0 and 5 ignored)
	CH = required-attributes mask (see #1073)
	SI = date/time format (see #1432)
	DS:DX -> ASCIZ filespec (both "*" and "*.*" match any filename)
	ES:DI -> FindData record (see #1433)
Return: CF clear if successful
	    AX = filefind handle (needed to continue search)
	    CX = Unicode conversion flags (see #1434)
	CF set on error
	    AX = error code
		7100h if function not supported
Notes:	this function is only available when IFSMgr is running, not under bare
	  MS-DOS 7
	the application should close the filefind handle with AX=71A1h as soon
	  as it has completed its search
	for compatibility with DOS versions prior to v7.00, the carry flag
	  should be set on call to ensure that it is set on exit
SeeAlso: AH=4Eh,AX=714Fh,AX=71A1h

(Table 1432)
Values for Windows95 date/time format:
 0000h	use 64-bit file time format
 0001h	use MS-DOS date/time values (see #1317,#1318) in low double-word of
	  file time QWORD (date is high word, time is low word of double-word)

Format of Windows95 long filename FindData record:
Offset	Size	Description	(Table 1433)
 00h	DWORD	file attributes
		bits 0-6 standard DOS attributes (see #1073 at INT 21/AX=4301h)
		bit 8: temporary file
 04h	QWORD	file creation time (number of 100ns intervals since 1/1/1601)
 0Ch	QWORD	last access time
 14h	QWORD	last modification time
 1Ch	DWORD	file size (high 32 bits)
 20h	DWORD	file size (low 32 bits)
 24h  8 BYTEs	reserved
 2Ch 260 BYTEs	ASCIZ full filename
130h 14 BYTEs	ASCIZ short filename (for backward compatibility)

Bitfields for Windows95 Unicode conversion flags:
Bit(s)	Description	(Table 1434)
 0	the returned full filename contains underscores for un-convertable
	  Unicode characters
 1	the returned short filename contains underscores for un-convertable
	  Unicode characters
--------D-21714F-----------------------------
INT 21 - Windows95 - LONG FILENAME - FIND NEXT MATCHING FILE
	AX = 714Fh
	BX = filefind handle (from AX=714Eh)
	SI = date/time format (see #1432)
	ES:DI -> buffer for FindData record (see #1433)
Return: CF clear if successful
	    CX = Unicode conversion flags (see #1434)
	CF set on error
	    AX = error code
		7100h if function not supported
Notes:	this function is only available when IFSMgr is running, not under bare
	  MS-DOS 7
	for compatibility with DOS versions prior to v7.00, the carry flag
	  should be set on call to ensure that it is set on exit
SeeAlso: AH=4Eh,AX=714Eh,AX=71A1h
--------D-217156-----------------------------
INT 21 - Windows95 - LONG FILENAME - RENAME FILE
	AX = 7156h
	DS:DX -> ASCIZ old file or directory name (long names allowed)
	ES:DI -> ASCIZ new name (long names allowed)
Return: CF clear if successful
	CF set on error
	    AX = error code
		7100h if function not supported
Note:	the file may be renamed into a different directory, but not across
	  disks
SeeAlso: AH=56h,AX=7141h
--------D-217160CL00-------------------------
INT 21 - Windows95 - LONG FILENAME - "TRUENAME" - CANONICALIZE PATH
	AX = 7160h
	CL = 00h
	CH = SUBST expansion flag
	    00h return a path containing true path for a SUBSTed drive letter
	    80h return a path containing the SUBSTed drive letter
	DS:SI -> ASCIZ filename or path (either long name or short name)
	ES:DI -> 261-byte buffer for canonicalized name
Return: CF set on error
	    AX = error code
		02h invalid component in directory path or drive letter only
		03h malformed path or invalid drive letter
	    ES:DI buffer unchanged
	CF clear if successful
	    ES:DI buffer filled with fully qualified name
	    AX destroyed
Desc:	determine the canonical name of the specified filename or path,
	  corresponding to the undocumented TRUENAME command in COMMAND.COM
Notes:	if a complete path is given, the result will be a short-form complete
	  path; otherwise, the given relative path is appended to the
	  short-form current directory name, '.'/'..'/'...'/etc. are resolved,
	  and the final result uppercased without converting any remaining
	  long-form names to short-form
	for compatibility with DOS versions prior to v7.00, the carry flag
	  should be set on call to ensure that it is set on exit
SeeAlso: AH=60h,AX=7160h/CL=01h
--------D-217160CL01-------------------------
INT 21 - Windows95 - LONG FILENAME - GET SHORT (8.3) FILENAME FOR FILE
	AX = 7160h
	CL = 01h
	CH = SUBST expansion flag
	    00h return a path containing true path for a SUBSTed drive letter
	    80h return a path containing the SUBSTed drive letter
	DS:SI -> ASCIZ long filename or path
	ES:DI -> 67-byte buffer for short filename
Return: CF set on error
	    AX = error code
		02h invalid component in directory path or drive letter only
		03h malformed path or invalid drive letter
	    ES:DI buffer unchanged
	CF clear if successful
	    ES:DI buffer filled with equivalent short filename (full path,
		  even if relative path given, and all uppercase)
Note:	this call returns the short name for any long-filename portions of
	  the provided pathname or filename
SeeAlso: AH=60h,AX=7160h/CL=00h,AX=7160h/CL=02h
--------D-217160CL02-------------------------
INT 21 - Windows95 - LONG FILENAME - GET CANONICAL LONG FILENAME OR PATH
	AX = 7160h
	CL = 02h
	CH = SUBST expansion flag
	    00h return a path containing true path for a SUBSTed drive letter
	    80h return a path containing the SUBSTed drive letter
	DS:SI -> ASCIZ short filename or path
	ES:DI -> 261-byte buffer for canonicalized long name
Return: CF set on error
	    AX = error code
		02h invalid component in directory path or drive letter only
		03h malformed path or invalid drive letter
	    ES:DI buffer unchanged
	CF clear if successful
	    ES:DI buffer filled with qualified long name (can contain
		  lowercase letters)
Desc:	determine the canonical name of the specified filename or path,
	  corresponding to the undocumented TRUENAME command in COMMAND.COM
Note:	this call returns the short name for any long-filename portions of
	  the provided pathname or filename
BUG:	even though the maximum length of a complete long pathname is 260
	  characters, Windows95 returns CF set/AX=0003h even if the file
	  exists whenever the full pathname is more than 255 characters
SeeAlso: AH=60h,AX=7160h/CL=00h,AX=7160h/CL=01h
--------D-21716C-----------------------------
INT 21 - Windows95 - LONG FILENAME - CREATE OR OPEN FILE
	AX = 716Ch
	BX = access mode and sharing flags (see #1436,also AX=6C00h)
	CX = attributes
	DX = action (see #1435)
	DS:SI -> ASCIZ filename
	DI = alias hint (number to append to short filename for disambiguation)
Return: CF clear if successful
	    AX = file handle
	    CX = action taken
		0001h file opened
		0002h file created
		0003h file replaced
	CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
SeeAlso: AX=6C00h,AX=7141h,AX=7156h,AX=71A9h

Bitfields for Windows95 long-name open action:
Bit(s)	Description	(Table 1435)
 0	open file (fail if file does not exist)
 1	truncate file if it already exists (fail if file does not exist)
 4	create new file if file does not already exist (fail if exists)
Note:	the only valid combinations of multiple flags are bits 4&0 and 4&1

Bitfields for Windows95 file access/sharing modes:
Bit(s)	Description	(Table 1436)
 2-0	file access mode
	000 read-only
	001 write-only
	010 read-write
	100 read-only, do not modify file's last-access time
 6-4	file sharing modes
 7	no-inherit flag
 8	do not buffer data (requires that all reads/writes be exact physical
	  sectors)
 9	do not compress file even if volume normally compresses files
 10	use alias hint in DI as numeric tail for short-name alias
 12-11	unused??? (0)
 13	return error code instead of generating INT 24h if critical error
	  while opening file
 14	commit file after every write operation
SeeAlso: #1056
--------D-2171A0-----------------------------
INT 21 - Windows95 - LONG FILENAME - GET VOLUME INFORMATION
	AX = 71A0h
	DS:DX -> ASCIZ root name (e.g. "C:\")
	ES:DI -> buffer for file system name
	CX = size of ES:DI buffer
Return: CF clear if successful
	    BX = file system flags (see #1437)
	    CX = maximum length of file name [usually 255]
	    DX = maximum length of path [usually 260]
	    ES:DI buffer filled (ASCIZ, e.g. "FAT","NTFS","CDFS")
	CF set on error
	    AX = error code
		7100h if function not supported
Notes:	for the file system name buffer, 32 bytes should be sufficient; that's
	 what is used in some sample code by Walter Oney from Microsoft.
	this function accesses the disk the first time it is called
SeeAlso: AX=714Eh,AX=7160h/CL=00h

Bitfields for long filename volume information flags:
Bit(s)	Description	(Table 1437)
 0	searches are case sensitive
 1	preserves case in directory entries
 2	uses Unicode characters in file and directory names
 3-13	reserved (0)
 14	supports DOS long filename functions
 15	volume is compressed
--------D-2171A1-----------------------------
INT 21 - Windows95 - LONG FILENAME - "FindClose" - TERMINATE DIRECTORY SEARCH
	AX = 71A1h
	BX = filefind handle (from AX=714Eh)
Return: CF clear if successful
	CF set on error
	   AX = error code
		7100h if function not supported
Notes:	this function must be called after starting a search with AX=714Eh,
	  to indicate that the search handle returned by that function will
	  no longer be used
	this function is only available when IFSMgr is running, not under bare
	  MS-DOS 7
SeeAlso: AH=4Eh,AX=714Eh,AX=714Fh
--------D-2171A2-----------------------------
INT 21 U - Windows95 - internal
	AX = 71A2h
	???
Return: ???
Note:	documented as "for internal use by Windows 95 only"
--------D-2171A3-----------------------------
INT 21 U - Windows95 - internal
	AX = 71A3h
	???
Return: ???
Note:	documented as "for internal use by Windows 95 only"
--------D-2171A4-----------------------------
INT 21 U - Windows95 - internal
	AX = 71A4h
	???
Return: ???
Note:	documented as "for internal use by Windows 95 only"
--------D-2171A5-----------------------------
INT 21 U - Windows95 - internal
	AX = 71A5h
	???
Return: ???
Note:	documented as "for internal use by Windows 95 only"
--------D-2171A6-----------------------------
INT 21 - Windows95 - LONG FILENAME - GET FILE INFO BY HANDLE
	AX = 71A6h
	BX = file handle
	DS:DX -> buffer for file information (see #1438)
	CF set
Return: CF clear if successful
	    file information record filled
	CF set on error
	    AX = error code
		7100h if function not supported
SeeAlso: AX=71A7h/BL=00h

Format of Windows95 file information:
Offset	Size	Description	(Table 1438)
 00h	DWORD	file attributes
 04h	QWORD	creation time (0 = unsupported)
 0Ch	QWORD	last access time (0 = unsupported)
 14h	QWORD	last write time
 1Ch	DWORD	volume serial number
 20h	DWORD	high 32 bits of file size
 24h	DWORD	low 32 bits of file size
 28h	DWORD	number of links to file
 2Ch	DWORD	unique file identifier (high 32 bits)
 30h	DWORD	unique file identifier (low 32 bits)
Note:	the file identifer and volume serial number together uniquely identify
	  a file while it is open; the identifier may change when the system
	  is restarted or the file is first opened
--------D-2171A7BL00-------------------------
INT 21 - Windows95 - LONG FILENAME - FILE TIME TO DOS TIME
	AX = 71A7h
	BL = 00h
	DS:SI -> QWORD file time
Return: CF clear if successful
	    CX = DOS time (see #1317)
	    DX = DOS date (see #1318)
	    BH = hundredths (10-millisecond units past time in CX)
	CF set on error
	    AX = error code
		7100h if function not supported
Desc:	convert Win95 64-bit file time (UTC) into DOS-style date and time
	  (local timezone)
Note:	the conversion fails if the file time's value is outside the range
	  1/1/1980 and 12/31/2107
SeeAlso: AX=71A6h,AX=71A7h/BL=01h
--------D-2171A7BL01-------------------------
INT 21 - Windows95 - LONG FILENAME - DOS TIME TO FILE TIME
	AX = 71A7h
	BL = 01h
	CX = DOS time (see #1317)
	DX = DOS date (see #1318)
	BH = hundredths (10-millisecond units past time in CX)
	ES:DI -> buffer for QWORD file time
Return: CF clear if successful
	    ES:DI buffer filled
	CF set on error
	    AX = error code
		7100h if function not supported
Desc:	convert DOS-style date and time (local timezone) into Win95 64-bit
	  file time (UTC)
SeeAlso: AX=71A6h,AX=71A7h/BL=00h
--------D-2171A8-----------------------------
INT 21 - Windows95 - LONG FILENAME - GENERATE SHORT FILENAME
	AX = 71A8h
	DS:SI -> ASCIZ long filename (no path allowed!)
	ES:DI -> buffer for ASCIZ short filename
	DH = short name's format
	    00h 11-char directory entry/FCB filename format
	    01h DOS 8.3
	DL = character sets
	    bits 7-4: short name's character set (see #1439)
	    bits 3-0: long name's character set (see #1439)
Return: CF clear if successful
	    ES:DI buffer filled
	CF set on error
	    AX = error code
		7100h if function not supported
Note:	this function uses the same algorithm as the filesystem except that
	  the returned name never has a numeric tail for disambiguation
SeeAlso: AX=7160h/CL=00h,AX=7160h/CL=02h,AX=71A7h/BL=00h

(Table 1439)
Values for Windows95 filename character set:
 00h	Windows ANSI
 01h	current OEM character set
 02h	Unicode
--------D-2171A9-----------------------------
INT 21 - Windows95 - LONG FILENAME - SERVER CREATE OR OPEN FILE
	AX = 71A9h
	BX = access mode and sharing flags (see #1436,also AX=6C00h)
	CX = attributes
	DX = action (see #1435)
	DS:SI -> ASCIZ filename
	DI = alias hint (number to append to short filename for disambiguation)
Return: CF clear if successful
	    AX = global file handle
	    CX = action taken
		0001h file opened
		0002h file created
		0003h file replaced
	CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
Note:	for use by real-mode servers only
SeeAlso: AX=6C00h,AX=716Ch
--------D-2171AABH00-------------------------
INT 21 - Windows95 - LONG FILENAME - CREATE SUBST
	AX = 71AAh
	BH = 00h
	BL = drive number (00h = default, 01h = A:, etc.)
	DS:DX -> ASCIZ pathname to associate with drive letter
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
SeeAlso: AX=71AAh/BH=01h,AX=71AAh/BH=02h,INT 2F/AX=1000h,#1295
--------D-2171AABH01-------------------------
INT 21 - Windows95 - LONG FILENAME - TERMINATE SUBST
	AX = 71AAh
	BH = 01h
	BL = drive number (01h = A:, etc.)
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
Note:	the specified drive number may not be 00h (default), and presumably not
	  the current drive either
SeeAlso: AX=71AAh/BH=00h,AX=71AAh/BH=02h,INT 2F/AX=1000h,#1295
--------D-2171AABH02-------------------------
INT 21 - Windows95 - LONG FILENAME - QUERY SUBST
	AX = 71AAh
	BH = 02h
	BL = drive number (01h = A:, etc.)
	DS:DX -> buffer for ASCIZ pathname associated with drive letter
Return: CF clear if successful
	    DS:DX buffer filled
	CF set on error
	    AX = error code (see #1332)
		7100h if function not supported
Note:	the specified drive number may not be 00h (default drive)
SeeAlso: AX=71AAh/BH=00h,AX=71AAh/BH=01h,INT 2F/AX=1000h,#1295
--------D-2172-------------------------------
INT 21 - Windows95 beta - LFN-FindClose
	AH = 72h
	details not available
Return:	CF clear if successful
	CF set on error
	    AX = error code (see #1332)
		7200h if function not supported (e.g. under bare MS-DOS 7)
Note:	this function was present in beta versions of Windows95, but is
	  probably not present in the release version
SeeAlso: AX=71A1h
--------D-2173-------------------------------
INT 21 - MS-DOS 7 - DRIVE LOCKING ???
	AH = 73h
	DL = drive (0=current, 1=A:, etc.)
	CL = which flag to get or set
	    00h drive flag???
	    01h ???
	AL = subfunction
	    00h get ???
	    01h set ???
		CH = new values for ??? flags
		    bit 1: ??? (CL=00h only)
		    bit 3: ??? (CL=01h only)
Return: CF clear if successful
	    for AL=00h:
		AL = value of CL on entry
		for CL=00h: AH = new flag and 06h (i.e. bits 1 and 2 used)
		for CL=01h: AH = new flag and 08h (i.e. bit 3 used)
		(flag being taken from a table of bytes)
	CF set on error
	    AX = error code (01h,0Fh,etc.) (see #1332)
		7300h if function not supported
Note:	these two subfunctions are available even when only the MS-DOS kernel
	  is running
--------D-217302-----------------------------
INT 21 - Windows95 - FAT32 - "Get_ExtDPB" - GET EXTENDED DPB
	AX = 7302h
	DL = drive number (00h=default, 01h=A:, etc.)
	ES:DI -> buffer for drive parameter block (DPB) (see #1440)
	CX = length of buffer
Return: CF clear if successful
	    ES:DI buffer filled
	CF set on error
	    AX = error code
SeeAlso: AX=7303h,AX=7304h,AH=1Fh,AH=32h

Format of Extended Drive Parameter Block:
Offset	Size	Description	(Table 1440)
 00h 24 BYTEs	standard DOS 4+ DPB
 18h	BYTE	"dpb_flags" (undocumented)
 19h	DWORD	pointer to next DPB
 1Dh	WORD	cluster at which to start search for free space when writing,
		usually the last cluster allocated
 1Fh	WORD	number of free clusters on drive, FFFFh = unknown
 21h	WORD	high word of free cluster count
 23h	WORD	active FAT/mirroring
		bits 3-0: the 0-based FAT number of the active FAT
		bits 6-4: reserved (0)
		bit 7: do not mirror active FAT to inactive FATs
 25h	WORD	sector number of file system information sector, or
		  FFFFh for none (see also #1441)
 27h	WORD	sector number of backup boot sector
 29h	DWORD	first sector number of the first cluster
 2Dh	DWORD	maximum cluster number
 31h	DWORD	number of sectors occupied by FAT
 35h	DWORD	cluster number of start of root directory
Note:	except for offset 18h, all of the first 33 bytes are identical to
	  the standard DOS 4-6 DPB
SeeAlso: #1049 at AH=32h,#1316

Format of File System Information structure:
Offset	Size	Description	(Table 1441)
 00h	DWORD	signature 61417272h
 04h	DWORD	number of free clusters (FFFFFFFFh if unknown)
 08h	DWORD	most recently allocated cluster
 0Ch 12 BYTEs	reserved
SeeAlso: #1440
--------D-217303-----------------------------
INT 21 - Windows95 - FAT32 - GET EXTENDED FREE SPACE ON DRIVE
	AX = 7303h
	DS:DX -> ASCIZ string for drive ("C:\" or "\\SERVER\Share")
	ES:DI -> buffer for extended free space structure (see #1442)
	CX = length of buffer for extended free space
Return: CF clear if successful
	    ES:DI buffer filled
	CF set on error
	    AX = error code
SeeAlso: AX=7302h,AX=7304h,AX=7305h,AH=36h

Format of extended free space structure:
Offset	Size	Description	(Table 1442)
 00h	WORD	??? "The true size of the drive. Get_ExtFreeSpace returns
		  the value to this field."
 02h	WORD	(call) structure version??? (0000h)
		(ret) ???
 04h	DWORD	number of sectors per cluster (with adjustment for compression)
 08h	DWORD	number of bytes per sector
 0Ch	DWORD	number of available clusters
 10h	DWORD	total number of clusters on the drive
 14h	DWORD	number of physical sectors available on the drive, without
		  adjustment for compression
 18h	DWORD	total number of physical sectors on the drive, without
		  adjustment for compression
 1Ch	DWORD	number of available allocation units, without adjustment
		  for compression
 20h	DWORD	total allocation units, without adjustment for compression
 24h  8 BYTEs	reserved
--------D-217304-----------------------------
INT 21 - Windows95 - FAT32 - Set DPB TO USE FOR FORMATTING
	AX = 7304h
	DL = drive number (00h=default, 01h=A:, etc.)
	ES:DI -> buffer for Set_DPBforFormat structure (see #1443)
Return: CF clear if successful
	    ES:DI buffer updated
	CF set on error
	    AX = error code
SeeAlso: AX=7302h,AX=7303h,AX=7305h

Format of Set_DPBforFormat structure:
Offset	Size	Description	(Table 1443)
 00h	WORD	(call) size
 02h	WORD	(call) structure version???  (0000h)
		(ret) ???
 04h	DWORD	(call) function number
		00h invalidate DPB counts
		01h rebuild DPB from BPB
		02h force media change (next access to drive rebuild DPB)
		03h get/set active FAT number and mirroring
		04h get/set root directory cluster number
---function 00h---
 08h	DWORD	new DPB free count (00000000h=no change, FFFFFFFFh=unknown)
 0Ch	DWORD	new DPB next-free (00000000h=no change, FFFFFFFFh=unknown)
 10h	DWORD	unused
 14h	DWORD	unused
---function 01h---
 08h	DWORD	unused???
 0Ch	DWORD	(call) -> BIOS Parameter Block from which to rebuild DPB
 10h	DWORD	unused
 14h	DWORD	unused
---function 02h---
 08h	DWORD	unused
 0Ch	DWORD	unused
 10h	DWORD	unused
 14h	DWORD	unused
---function 03h---
 08h	DWORD	(call) new active FAT/mirroring state, or FFFFFFFFh to get
		bits 3-0: the 0-based FAT number of the active FAT
		bits 6-4: reserved (0)
		bit 7: do not mirror active FAT to inactive FATs
 0Ch	DWORD	(ret) previous active FAT/mirroring state (as above)
 10h	DWORD	unused
 14h	DWORD	unused
---function 04h---
 08h	DWORD	(call) new root directory cluster number
		    FFFFFFFFh to get current
 0Ch	DWORD	(ret) previous root directory cluster number
 10h	DWORD	unused
 14h	DWORD	unused
--------D-217305CXFFFF-----------------------
INT 21 - Windows95 - FAT32 - EXTENDED ABSOLUTE DISK READ/WRITE
	AX = 7305h
	CX = FFFFh
	DL = drive number (00h=default, 01h=A:, etc.)
	SI = read/write mode flags (see #1444)
	DS:BX -> disk I/O packet (see #2203 at INT 25)
Return: CF clear if successful
	CF set on error
	    AX = error code
SeeAlso: AX=7302h,AX=7304h,INT 25,INT 26

Bitfields for Extended Absolute Disk Read/Write mode flags:
Bit(s)	Description	(Table 1444)
 0	direction (0=read, 1=write)
 12-1	reserved (0)
 14-13	write type (should be 00 on reads)
	00 unknown data
	01 FAT data
	10 directory data
	11 file data
 15	reserved (0)
--------v-217575-----------------------------
INT 21 - VIRUS - "LEGO" -INSTALLATION CHECK
	AX = 7575h
Return: AX = 4321h if resident
SeeAlso: AX=6969h,AH=76h"VIRUS"
--------v-2176-------------------------------
INT 21 - VIRUS - "Klaeren"/"Hate" - INSTALLATION CHECK
	AH = 76h
Return: AL = 48h if resident
SeeAlso: AX=7575h,AX=7700h"VIRUS"
--------v-217700-----------------------------
INT 21 - VIRUS - "Growing Block" - INSTALLATION CHECK
	AX = 7700h
Return: AX = 0920h if resident
SeeAlso: AH=76h,AX=7BCEh,AH=7Fh
--------V-217734-----------------------------
INT 21 U - SCROLLit v1.7 - INSTALLATION CHECK
	AX = 7734h
Return: DX = 3477h if installed
	    AX = segment of resident code
Program: ScrollIt is a shareware backscroll utility by Bromfield Software
	  Products
--------U-217761-----------------------------
INT 21 - WATCH.COM v3.2+ - INSTALLATION CHECK
	AX = 7761h ('wa')
Return: AX = 6177h
Note:	WATCH.COM is part of the "TSR" package by TurboPower Software
SeeAlso: INT 16/AX=7761h
--------v-217BCE-----------------------------
INT 21 - VIRUS - "Whisper"/"Taipan" - INSTALLATION CHECK
	AX = 7BCEh
Return: AX = 7BCEh if resident (???)
SeeAlso: AX=5454h"VIRUS",AX=7700h,AX=7BCFh,AH=7Fh"VIRUS"
--------v-217BCF-----------------------------
INT 21 - VIRUS - "Tai-Pan.666"/"Doom II Death" - INSTALLATION CHECK
	AX = 7BCFh
Return: AX = 7BCFh if resident
SeeAlso: AX=7BCEh"VIRUS",AH=7Dh"VIRUS"
--------v-217D-------------------------------
INT 21 - VIRUS - "OffSpring" - INSTALLATION CHECK
	AH = 7Dh
Return: AH = FAh if installed
SeeAlso: AX=7BCFh"VIRUS",AH=7Fh"VIRUS"
--------v-217F-------------------------------
INT 21 - VIRUS - "Squeaker","ASeXual" - INSTALLATION CHECK
	AH = 7Fh
Return: AH = 80h if resident
SeeAlso: AX=7BCEh,AH=83h"VIRUS"
--------D-2180-------------------------------
INT 21 - European MS-DOS 4.0 - "AEXEC" - EXECUTE PROGRAM IN BACKGROUND
	AH = 80h
	CX = mode
	    0000h place child in zombie mode on exit to preserve exit code
	    0001h discard child process and exit code on termination
	DS:DX -> ASCIZ full program name
	ES:BX -> parameter block (as for AX=4B00h)
Return: CF clear if successful
	    AX = Command Subgroup ID (CSID)
	CF set on error
	    AX = error code (see #1332 at AH=59h/BX=0000h)
Program: European MS-DOS 4.0 was written for Siemens in Germany and then used
	  by several other European OEMs; its release falls between mainstream
	  versions 3.2 and 3.3
Desc:	asynchronously execute a program, creating a new process for it
Notes:	this function is called by the DETACH command
	there is a system-wide limit of 32 processes
	the CSID is used to identify all processes that have been spawned by
	  a given process, whether directly or indirectly
	programs to be run in the background must use the new executable format
	  (see #1248 at AH=4Bh)
	background processes may only perform asynchronous (background) EXECs,
	  either this function or AX=4B04h
	background processes may execute INT 11, INT 12, INT 21, INT 2A, and
	  INT 2F at any time; they may execute INT 10 and INT 16 only while
	  they have opened a popup screen via INT 2F/AX=1401h; no other
	  interrupts may be executed from the background
	background processes may not use drive B: or overlay their code
	  segments
	see AX=8700h for an installation check
	the "NE" new executable format made its first appearance in European
	  MS-DOS 4.0
SeeAlso: AH=4Bh,AH=87h,INT 2F/AX=1400h"POPUP"
----------218080-----------------------------
INT 21 - PCW Weather Card interface - UNINSTALL PCW.COM AND FREE MEMORY
	AX = 8080h
Return: ???
SeeAlso: AX=7070h/BX=7070h
--------D-2181-------------------------------
INT 21 - European MS-DOS 4.0 - "FREEZE" - STOP A PROCESS
	AH = 81h
	BX = flag (00h freeze command subtree, 01h only specified process)
	CX = Process ID of head of command subtree
Return: CF clear if successful
	CF set on error
	    AX = error code (no such process)
Desc:	temporarily suspend a process or a process and all of its children
Note:	if BX=0001h, this call will not return until the process is actually
	  frozen, which may not be until after it unblocks from an I/O
	  operation
SeeAlso: AH=82h,AH=89h,AX=8E00h,INT 15/AX=101Dh
--------D-2182-------------------------------
INT 21 - European MS-DOS 4.0 - "RESUME" - RESTART A PROCESS
	AH = 82h
	BX = flag (00h resume command subtree, 01h only specified process)
	CX = Process ID of head of command subtree
Return: CF clear if successful
	CF set on error
	    AX = error code (no such process)
Desc:	restart a previously-suspended process or a process and all of its
	  children
SeeAlso: AH=81h,INT 15/AX=101Eh
--------D-2183-------------------------------
INT 21 - European MS-DOS 4.0 - "PARTITION" - GET/SET FOREGROUND PARTITION SIZE
	AH = 83h
	AL = function
	    00h get size
	    01h set new size
		BX = new size in paragraphs
Return: CF clear if successful
	    BX = current size (function 00h) or old size (function 01h)
	CF set on error
	    AX = error code (01h,07h,0Dh)(see #1332 at AH=59h/BX=0000h)
Desc:	specify or determine how much memory may be allocated by the foreground
	  process
Note:	if the partition size is set to 0000h, no partition management is done
	  and all memory allocation is compatible with DOS 3.2.
	the partition size can be changed regardless of what use is being made
	  of the changed memory; subsequent allocations will follow the
	  partition rules (foreground processes may allocate only foreground
	  memory; background processes allocate background memory first, then
	  foreground memory)
SeeAlso: AH=48h,AH=4Ah
--------v-2183-------------------------------
INT 21 - VIRUS - "SVC" - INSTALLATION CHECK
	AH = 83h
Return: DX = 1990h if resident
SeeAlso: AH=76h,AH=84h"VIRUS"
--------v-2184-------------------------------
INT 21 - VIRUS - "SVC 5.0" or "SVC 6.0" - INSTALLATION CHECK
	AH = 84h
Return: DX = 1990h if resident
	    BH = version number (major in high nybble, minor in low)
SeeAlso: AH=83h"VIRUS",AH=89h"VIRUS"
--------D-218400-----------------------------
INT 21 - European MS-DOS 4.0 - "CREATMEM" - CREATE A SHARED MEMORY AREA
	AX = 8400h
	BX = size in bytes (0000h = 65536)
	CX = flags
	    bit 6: zero-initialize segment
	DS:DX -> ASCIZ name (must begin with "\SHAREMEM\")
Return: CF clear if successful
	    AX = segment address of shared memory global object
	CF set on error
	    AX = error code (06h,08h) (see #1332 at AH=59h/BX=0000h)
Desc:	create an area of memory which may be accessed by multiple processes
Notes:	shared memory objects are created as special files (thus the
	  restriction on the name)
	on successful creation, the reference count is set to 1
SeeAlso: AX=8401h,AX=8402h,INT 15/AX=DE19h
--------D-218401-----------------------------
INT 21 - European MS-DOS 4.0 - "GETMEM" - OBTAIN ACCESS TO SHARED MEMORY AREA
	AX = 8401h
	CX = flags
	    bit 7: writable segment (ignored by MS-DOS 4.0)
	DS:DX -> ASCIZ name (must begin with "\SHAREMEM\")
Return: CF clear if successful
	    AX = segment address of shared memory global object
	    CX = size in bytes
	CF set on error
	    AX = error code (invalid name)
Desc:	get address of a previously-created area of memory which may be
	  accessed by multiple processes
Note:	this call increments the reference count for the shared memory area
SeeAlso: AX=8400h,AX=8402h
--------D-218402-----------------------------
INT 21 - European MS-DOS 4.0 - "RELEASEMEM" - FREE SHARED MEMORY AREA
	AX = 8402h
	BX = handle (segment address of shared memory object)
Return: CF clear if successful
	CF set on error
	    AX = error code (no such name)
Desc:	indicate that the specified area of shared memory will no longer be
	  used by the caller
Note:	the reference count is decremented and the shared memory area is
	  deallocated if the new reference count is zero
SeeAlso: AX=8400h,AX=8401h,INT 15/AX=DE19h
--------D-2185-------------------------------
INT 21 U - European MS-DOS 4.0 - ???
	AH = 85h
	???
Return: ???
--------D-2186-------------------------------
INT 21 - European MS-DOS 4.0 - "SETFILETABLE" - INSTALL NEW FILE HANDLE TABLE
	AH = 86h
	BX = total number of file handles in new table
Return: CF clear if successful
	CF set on error
	    AX = error code (06h,08h) (see #1332 at AH=59h/BX=0000h)
Desc:	adjust the size of the per-process open file table, thus raising or
	  lowering the limit on the number of files the caller can open
	  simultaneously
Notes:	any currently-open files are copied to the new table
	if the table is increased beyond the default 20 handles, only the
	  first 20 will be inherited by child processes
	error 06h is returned if the requested number of handles exceeds
	  system limits or would require closing currently-open files
SeeAlso: AH=26h,AH=67h
--------D-2187-------------------------------
INT 21 - European MS-DOS 4.0 - "GETPID" - GET PROCESS IDENTIFIER
	AH = 87h
Return: AX = PID
	BX = parent process's PID
	CX = Command Subgroup ID (CSID)
Program: European MS-DOS 4.0 was written for Siemens in Germany and then used
	  by several other European OEMs; its release falls between mainstream
	  versions 3.2 and 3.3
Desc:	determine an identifier by which to access the calling process
Notes:	called by MS C v5.1 getpid() function
	this function apparently must return AX=0001h for INT 21/AH=80h to
	  succeed
	one possible check for European MS-DOS 4.0 is to issue this call with
	  AL=00h and check whether AL is nonzero on return
SeeAlso: AH=30h,AH=62h,AH=80h
Index:	installation check;European MS-DOS 4.0
--------D-2188-------------------------------
INT 21 U - European MS-DOS 4.0 - ???
	AH = 88h
	???
Return: ???
SeeAlso: AH=87h
--------D-2189-------------------------------
INT 21 - European MS-DOS 4.0 - SLEEP
	AH = 89h
	CX = time in milliseconds or 0000h to give up time slice
Return: CF clear if successful
	    CX = 0000h
	CF set on error
	    AX = error code (interrupted system call)
	    CX = sleep time remaining
Desc:	suspend the calling process for the specified duration
Notes:	the sleep interval is rounded up to the next higher increment of the
	  scheduler clock, and may be extended further if other processes are
	  running
	this call may be interrupted by signals (see AH=8Dh)
	reportedly called by Microsoft C 4.0 startup code
	background processes have higher priority than the foreground process,
	  and should thus periodically yield the CPU
SeeAlso: AH=81h,INT 15/AX=1000h,INT 2F/AX=1680h,INT 7A/BX=000Ah
--------v-2189-------------------------------
INT 21 - VIRUS - "Vriest" - INSTALLATION CHECK
	AH = 89h
Return: AX = 0123h if resident
SeeAlso: AH=84h"VIRUS",AH=90h"VIRUS"
--------D-218A-------------------------------
INT 21 - European MS-DOS 4.0 - "CWAIT" - WAIT FOR CHILD TO TERMINATE
	AH = 8Ah
	BL = range (00h command subtree, 01h any child)
	BH = suspend flag
	    00h suspend if children exist but none are dead
	    01h return if no dead children
	CX = Process ID of head of command subtree
Return: CF clear if successful
	    AH = termination type (see #1445)
	    AL = return code from child or aborting signal
	    BX = PID of child (0000h if no dead children)
	CF set on error
	    AX = error code (no child,interrupted system call)
Desc:	get return code from an asynchronously-executed child program,
	  optionally waiting if no return code is available
SeeAlso: AH=4Bh,AH=4Dh,AH=80h,AH=8Dh

(Table 1445)
Values for termination type:
 00h	normal termination
 01h	aborted by Control-C
 02h	aborted by I/O error
 03h	terminate and stay resident
 04h	aborted by signal
 05h	aborted by program error
--------D-218B-------------------------------
INT 21 U - European MS-DOS 4.0 - ???
	AH = 8Bh
	???
Return: ???
SeeAlso: AH=87h
--------D-218C-------------------------------
INT 21 - European MS-DOS 4.0 - SET SIGNAL HANDLER
	AH = 8Ch
	AL = signal number (see #1446)
	BL = action (see #1447)
	DS:DX -> signal handler (see #1448)
Return: CF clear if successful
	    AL = previous action
	    ES:BX -> previous signal handler
	CF set on error
	    AX = error code (01h,invalid SigNumber or Action)
		  (see #1332 at AH=59h/BX=0000h)
Desc:	set the routine which will be invoked on a number of exceptional
	  conditions
Note:	all signals will be sent to the most recently installed handler
SeeAlso: AH=8Dh

(Table 1446)
Values for European MS-DOS 4.0 signal number:
 01h	SIGINTR		Control-C or user defined interrupt key
 08h	SIGTERM		program termination
 09h	SIGPIPE		broken pipe
 0Dh	SIGUSER1	reserved for user definition
 0Eh	SIGUSER2	reserved for user definition

(Table 1447)
Values for signal action:
 00h	SIG_DFL		terminate process on receipt
 01h	SIG_IGN		ignore signal
 02h	SIG_GET		signal is accepted
 03h	SIG_ERR		sender gets error
 04h	SIG_ACK		acknowledge received signal and clear it, but don't
			  change current setting

(Table 1448)
Values signal handler is called with:
	AL = signal number (see #1446)
	AH = signal argument
Return: RETF, CF set: terminate process
	RETF, CF clear, ZF set: abort any interrupted system call with an error
	RETF, CF clear, ZF clear: restart any interrupted system call
	IRET: restart any interrupted system call
Note:	the signal handler may also perform a nonlocal GOTO by resetting the
	  stack pointer and jumping; before doing so, it should dismiss the
	  signal by calling this function with BL=04h
--------D-218D-------------------------------
INT 21 - European MS-DOS 4.0 - SEND SIGNAL
	AH = 8Dh
	AL = signal number (see #1446)
	BH = signal argument
	BL = action
	    00h send to entire command subtree
	    01h send only to specified process
	DX = Process ID
Return: CF clear if successful
	CF set on error
	    AX = error code (01h,06h)(see #1332 at AH=59h/BX=0000h)
Desc:	invoke the exceptional-condition handler for the specified process
Note:	error 06h may be returned if one or more of the affected processes
	  have an error handler for the signal
SeeAlso: AH=8Ch
--------D-218E00BH00-------------------------
INT 21 - European MS-DOS 4.0 - "SETPRI" - GET/SET PROCESS PRIORITY
	AX = 8E00h
	BH = 00h
	BL = action
	    00h set priority for command subtree
	    01h set priority for specified process only
	CX = Process ID
	DH = 00h
	DL = change in priority (00h to get priority)
Return: CF clear if successful
	    DL = process priority
	    DH destroyed
	CF set on error
	    AX = error code (01h,no such process)(see #1332 at AH=59h)
Desc:	specify or determine the execution priority of the specified process
	  or the process and all of its children
SeeAlso: AH=81h
--------D-218F-------------------------------
INT 21 U - European MS-DOS 4.0 - ???
	AH = 8Fh
	???
Return: ???
SeeAlso: AH=87h
--------D-2190-------------------------------
INT 21 U - European MS-DOS 4.0 - ???
	AH = 90h
	???
Return: ???
SeeAlso: AH=87h
--------v-2190-------------------------------
INT 21 - VIRUS - "Carioca" - INSTALLATION CHECK
	AH = 90h
Return: AH = 01h if resident
SeeAlso: AH=89h"VIRUS",AX=9753h"VIRUS"
--------D-2191-------------------------------
INT 21 U - European MS-DOS 4.0 - ???
	AH = 91h
	???
Return: ???
SeeAlso: AH=87h
--------D-2192-------------------------------
INT 21 U - European MS-DOS 4.0 - ???
	AH = 92h
	???
Return: ???
SeeAlso: AH=87h
--------D-2193-------------------------------
INT 21 - European MS-DOS 4.0 - "PIPE" - CREATE A NEW PIPE
	AH = 93h
	CX = size in bytes
Return: CF clear if successful
	    AX = read handle
	    BX = write handle
	CF set on error
	    AX = error code (08h) (see #1332 at AH=59h/BX=0000h)
Desc:	create a communications channel which may be used for interprocess
	  data and command exchanges
SeeAlso: AH=3Ch,AH=3Fh"DOS",AH=40h"DOS",AH=84h
--------D-2194-------------------------------
INT 21 U - European MS-DOS 4.0 - ???
	AH = 94h
	???
Return: ???
SeeAlso: AH=87h
--------D-2195-------------------------------
INT 21 - European MS-DOS 4.0 - HARD ERROR PROCESSING
	AH = 95h
	AL = new state
	   00h enabled
	   01h disabled, automatically fail hard errors
Return: AX = previous setting
Desc:	specify whether hard (critical) errors should automatically fail the
	  system call or invoke an INT 24
SeeAlso: INT 24
--------D-2196-------------------------------
INT 21 U - European MS-DOS 4.0 - ???
	AH = 96h
	???
Return: ???
--------D-2197-------------------------------
INT 21 U - European MS-DOS 4.0 - ???
	AH = 97h
	???
Return: ???
--------v-219753-----------------------------
INT 21 - VIRUS - "Nina" - INSTALLATION CHECK
	AX = 9753h
Return: never (executes original program) if virus resident
SeeAlso: AH=90h"VIRUS",AX=A1D5h"VIRUS",AX=9AD5h"VIRUS"
--------D-2198-------------------------------
INT 21 U - European MS-DOS 4.0 - ???
	AH = 98h
	???
Return: ???
--------D-2199-------------------------------
INT 21 u - European MS-DOS 4.0 - "PBLOCK" - BLOCK A PROCESS
	AH = 99h
	DS:BX -> memory location to block on
	CX = timeout in milliseconds
	DH = nonzero if interruptable
Return: CF clear if awakened by event
	    AX = 0000h
	CF set if unusual wakeup
	    ZF set if timeout, clear if interrupted by signal
	    AX = nonzero
Desc:	suspend calling process until another process sends a "restart" signal
	  or a timeout occurs
SeeAlso: AH=9Ah,INT 2F/AX=0802h
--------D-219A-------------------------------
INT 21 u - European MS-DOS 4.0 - "PRUN" - UNBLOCK A PROCESS
	AH = 9Ah
	DS:BX -> memory location processes may have blocked on
Return: AX = number of processes awakened
	ZF set if no processes awakened
Program: European MS-DOS 4.0 was written for Siemens in Germany and then used
	  by several other European OEMs; its release falls between mainstream
	  versions 3.2 and 3.3
Desc:	restart all processes waiting for the specified "restart" signal
SeeAlso: AH=99h,INT 2F/AX=0802h
--------v-219AD5------------------------
INT 21 - VIRUS - "Massacre/Beavis" - INSTALLATION CHECK
	AX = 9AD5h
Return: AX = 9AD4h if resident
SeeAlso: AX=6969h"VIRUS",AX=A1D5h"VIRUS"
--------I-21A0-------------------------------
INT 21 - Attachmate Extra! - GET 3270 DISPLAY STATE
	AH = A0h
Return: AL = display status (see #1449)
	BX = host window status (see #1450)
Program: Attachmate Extra! is a 3270 emulator by Attachmate Corporation
SeeAlso: AH=A1h

Bitfields for Attachmate Extra! display status:
Bit(s)	Description	(Table 1449)
 7	0=windowed, 1=enlarged
 6-3	current screen profile number 0-9
 2-0	active window number (0=PC, 1-4=host B-E, 5-6=notepad F-G)

Bitfields for host window status:
Bit(s)	Description	(Table 1450)
 15	reserved
 14	0=host E window installed, 1=not
 13	0=host E terminal on, 1=off
 12	0=host E window displayed, 1=not
 11	reserved
 10	0=host D window installed, 1=not
 9	0=host D terminal on, 1=off
 8	0=host D window displayed, 1=not
 7	reserved
 6	0=host C window installed, 1=not
 5	0=host C terminal on, 1=off
 4	0=host C window displayed, 1=not
 3	reserved
 2	0=host B window installed, 1=not
 1	0=host B terminal on, 1=off
 0	0=host B window displayed, 1=not
--------I-21A1-------------------------------
INT 21 - Attachmate Extra! - SET 3270 DISPLAY STATE
	AH = A1h
	AL = new display status byte (see #1449)
SeeAlso: AH=A0h,AH=A2h
--------v-21A1D5-----------------------------
INT 21 - VIRUS - "789"/"Filehider" - INSTALLATION CHECK
	AX = A1D5h
Return: AX = 900Dh if resident
SeeAlso: AX=9753h,AX=9AD5h,AX=A55Ah
--------I-21A2-------------------------------
INT 21 - Attachmate Extra! - SET HOST WINDOW STATE
	AH = A2h
	AL = new host window status byte (see #1451)
SeeAlso: AH=A1h

Bitfields for Attachmate Extra! host window status:
Bit(s)	Description	(Table 1451)
 7	0=power off, 1=power on
 6	0=not installed, 1=installed
 5-3	reserved
 2-0	window number 1-4=host B-E
--------I-21A3-------------------------------
INT 21 - Attachmate Extra! - SEND KEYSTROKES TO HOST WINDOW
	AH = A3h
	AL = window number (1-4=host B-E)
	CX = 0001h
	DS:BX -> keystroke buffer
	DL = zero if keystroke buffer contains host function code (see #1452),
	      non-zero if keystroke buffer contains ASCII character
Return: CX = zero if character sent, non-zero if not
	BX incremented if CX=0

(Table 1452)
Values for Attachmate Extra! host function code:
 00h=reserved	10h=PF16	20h=Clear	30h=SysReq
 01h=PF1	11h=PF17	21h=Print	31h=ErInp
 02h=PF2	12h=PF18	22h=Left	32h=ErEof
 03h=PF3	13h=PF19	23h=Right	33h=Ident
 04h=PF4	14h=PF20	24h=Up		34h=Test
 05h=PF5	15h=PF21	25h=Down	35h=Reset
 06h=PF6	16h=PF22	26h=Home	36h=DevCncl
 07h=PF7	17h=PF23	27h=Fast Left	37h=Dup
 08h=PF8	18h=PF24	28h=Fast Right	38h=FldMark
 09h=PF9	19h=Alt on	29h=Bksp	39h=Enter
 0Ah=PF10	1Ah=Alt off	2Ah=Insert	3Ah=CrSel
 0Bh=PF11	1Bh=Shift on	2Bh=Delete
 0Ch=PF12	1Ch=Shift off	2Ch=Backtab
 0Dh=PF13	1Dh=PA1		2Dh=Tab
 0Eh=PF14	1Eh=PA2		2Eh=Newline
 0Fh=PF15	1Fh=PA3		2Fh=Attn
--------I-21A4-------------------------------
INT 21 - Attachmate Extra! - GET HOST WINDOW BUFFER ADDRESS
	AH = A4h
	AL = window number (1-4=host B-E)
Return: DS:BX -> 3270 display buffer
SeeAlso: AH=A5h,AH=B8h
--------I-21A5-------------------------------
INT 21 - Attachmate Extra! - GET HOST WINDOW CURSOR POSITION
	AH = A5h
	AL = window number (1-4=host B-E)
Return: BX = cursor position (80 * row + column, where 0:0 is upper left)
Note:	if the host window is configured with the Extended Attribute (EAB)
	  feature, multiply the cursor position by 2 to obtain the byte offset
	  into the display buffer
SeeAlso: AH=A4h
--------v-21A55A-----------------------------
INT 21 - VIRUS - "Eddie-2" - INSTALLATION CHECK
	AX = A55Ah
Return: AX = 5AA5h if resident
SeeAlso: AX=A1D5h,AX=AA00h
--------v-21AA00-----------------------------
INT 21 - VIRUS - "Blinker" - INSTALLATION CHECK
	AX = AA00h
Return: AX = 00AAh if resident
SeeAlso: AX=A55Ah,AX=AA03h
--------v-21AA03-----------------------------
INT 21 - VIRUS - "Backtime" - INSTALLATION CHECK
	AX = AA03h
Return: AX = 03AAh if resident
SeeAlso: AX=AA00h,AH=ABh
--------v-21AB-------------------------------
INT 21 - VIRUS - "600" or "Voronezh"-family - INSTALLATION CHECK
	AH = ABh
Return: AX = 5555h if resident
SeeAlso: AX=AA03h,AX=ABCDh,AX=BBBBh"VIRUS"
--------v-21ABCD-----------------------------
INT 21 - VIRUS - Major BBS - INSTALLATION CHECK
	AX = ABCDh
Return: AX = 1234h if installed
SeeAlso: AH=ABh"VIRUS",AX=ABCDh"SuperVirus"
--------v-21ABCD------------------------
INT 21 - VIRUS - "SuperVirus 2" - INSTALLATION CHECK
	AX = ABCDh
Return: AX = DCBAh if resident
SeeAlso: AX=ABCDh"VIRUS",AX=BBBBh"VIRUS"
--------I-21AF-------------------------------
INT 21 - Attachmate Extra! - GET TRANSLATE TABLE ADDRESS
	AH = AFh
Return: DS:BX -> translate tables (see #1453)

Format of Attachmate Extra! translate tables:
Offset	Size	Description	(Table 1453)
 00h 256 BYTEs	ASCII to 3270 buffer code translate table
100h 256 BYTEs	3270 buffer code to ASCII translate table
200h 256 BYTEs	3270 buffer code to EBCDIC translate table
300h 256 BYTEs	EBCDIC to 3270 buffer code translate table
--------v-21B3-------------------------------
INT 21 - VIRUS - "Requires" - INSTALLATION CHECK
	AH = B3h
Return: AX = 9051h if resident
SeeAlso: AH=7Fh"VIRUS",AX=B974h"VIRUS"
--------N-21B300-----------------------------
INT 21 U - Novell NetWare - CHECK LIP/PACKET SIGNING/IPX CHECKSUM SUPPORT???
	AX = B300h
Return: AX = 0000h if supported???
Note:	this function appeared with the packet signing/Large Internet Packets/
	  IPX Checksum-aware NetWare shells
SeeAlso: AX=B301h,AX=B302h
--------N-21B301-----------------------------
INT 21 U - Novell NetWare - CHECK SIGNATURE LEVEL???
	AX = B301h
Return: AX = 0000h if supported???
	    BX:CX indicate signature level (see #1454)
Note:	this function appeared with the packet signing/Large Internet Packets/
	  IPX Checksum-aware NetWare shells
SeeAlso: AX=B300h,AX=B304h,#2522 at INT 2F/AX=7A20h/BX=0000h

(Table 1454)
Values for signature level indicator:
 0000h:0000h = signature level 0
 0002h:0000h = signature level 1
 0202h:0000h = signature level 2
 0202h:0202h = signature level 3
--------N-21B302-----------------------------
INT 21 U - Novell NetWare - START PACKET SIGNING
	AX = B302h
	CX = server connection (1-8)
	DS:SI -> 24-byte buffer containing ???
Return: ???
Notes:	this function appeared with the packet signing/Large Internet Packets/
	  IPX Checksum-aware NetWare shells
	if packet signing is active, this call is required if and only if the
	  last call successfully authenticated the workstation to the server
SeeAlso: AX=B300h,#2522
--------N-21B304-----------------------------
INT 21 U - Novell NetWare - SET SIGNATURE LEVEL
	AX = B304h
	BX:CX = new signature level (see AX=B301h)
Return: ???
Note:	this function appeared with the packet signing/Large Internet Packets/
	  IPX Checksum-aware NetWare shells
SeeAlso: AX=B300h,AX=B301h,AX=B306h,#2522
--------N-21B306-----------------------------
INT 21 - Novell NetWare - RENEGOTIATE SECURITY LEVEL
	AX = B306h
	CX = server connection number (01h-08h)
Return: ???
Note:	this function appeared with the packet signing/Large Internet Packets/
	  IPX Checksum-aware NetWare shells
SeeAlso: AX=B300h,AX=B304h,#2522
--------N-21B4-------------------------------
INT 21 U - Novell NetWare - "AttachHandle"
	AH = B4h
	DS:SI -> input buffer (see #1455)
Return: AX = DOS file handle or return code
Note:	this is an interface provided by NetWare to give DOS file access to
	  NetWare files on non-DOS systems such as Macintosh, OS/2, and Unix
SeeAlso: AX=E909h

Format of Novell NetWare input buffer:
Offset	Size	Description	(Table 1455)
 00h	BYTE	"WorkFileServer"
 01h	BYTE	access code
 02h	DWORD	"OpenHandle"
 06h	WORD	"OpenHandleCount"
 08h	DWORD	"OpenFileSize"
Note:	the six bytes at 02h-07h appear to be the six-byte NetWare handle
	  returned by AX=E909h
--------N-21B500-----------------------------
INT 21 U - Novell NetWare - VNETWARE.386 API - GET INSTANCE DATA
	AX = B500h
Return: ES:BX -> data
	CX = length
SeeAlso: AX=B501h,AX=B502h
--------N-21B501-----------------------------
INT 21 U - Novell NetWare - VNETWARE.386 API - END VIRTUAL MACHINE
	AX = B501h
SeeAlso: AX=B500h,AX=B502h
--------N-21B502-----------------------------
INT 21 U - Novell NetWare - VNETWARE.386 API - START VIRTUAL MACHINE
	AX = B502h
SeeAlso: AX=B500h,AX=B501h
--------N-21B5-------------------------------
INT 21 - Novell NetWare shell 3.01 - TASK MODE CONTROL
	AH = B5h
	AL = subfunction
	    03h get task mode
		Return: AH = 00h
			AL = current task mode byte (see #1456)
	    04h get task mode pointer
		Return: ES:BX -> task mode byte
Notes:	the task mode byte specifies how task cleanup should be performed, but
	  is declared to be version-dependent
	allows a program to disable the automatic cleanup for programs managing
	  task swapping, etc.

(Table 1456)
Values for NetWare task mode byte in version 3.01:
 00h-03h reserved
 04h	 no task cleanup
--------N-21B505-----------------------------
INT 21 U - Novell NetWare - VNETWARE.386 API - SET VIRTUAL MACHINE ID
	AX = B505h
	???
Return: ???
SeeAlso: AX=B502h,AX=B506h
--------N-21B506-----------------------------
INT 21 U - Novell NetWare - VNETWARE.386 API - GET VIRTUAL MACH SUPPORT LEVEL
	AX = B506h
Return: AX = ??? (0002h)
SeeAlso: AX=B505h
--------N-21B507-----------------------------
INT 21 - Novell NetWare - NetWare Shell - GET NUMBER OF PACKET BURST BUFFERS
	AX = B507h
Return: AL = number of packet burst buffers (configured at shell load time)
--------N-21B6-------------------------------
INT 21 - Novell NetWare - FILE SERVICES - EXTENDED FILE ATTRIBUTES
	AH = B6h
	AL = subfunction
	    00h get extended file attributes
	    01h set extended file attributes
		CL = extended file attributes (see #1457)
	DS:DX -> ASCIZ pathname (max 255 bytes)
Return: CF set on error
	    AL = error code
		8Ch caller lacks privileges
		FEh not permitted to search directory
		FFh file not found
	CF clear if successful
	    AL = 00h (success)
	    CL = current extended file attributes (see #1457)
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AX=4300h,AH=E3h/SF=0Fh

Bitfields for NetWare extended file attributes:
Bit(s)	Description	(Table 1457)
 2-0	search mode (executables only)
	000 none (use shell's default search)
	001 search on all opens without path
	010 do not search
	011 search on read-only opens without path
	100 reserved
	101 search on all opens
	110 reserved
	111 search on all read-only opens
 3	reserved
 4	transactions on file tracked
 5	file's FAT indexed
 6	read audit (to be implemented)
 7	write audit (to be implemented)
--------N-21B7-------------------------------
INT 21 U - Novell NetWare - "HoldFileModeSet" (obsolete)
	AH = B7h
	AL = new value for HoldFileFlag
Return: AL = previous value of HoldFileFlag
Note:	this function provided backward compatibility with a bug in early
	  DOS versions and CP/M, but is no longer used or supported
--------I-21B8-------------------------------
INT 21 - Attachmate Extra! - DISABLE HOST BUFFER UPDATES
	AH = B8h
	AL = window number (1-4=host B-E)
	DL = 01h
Notes:	only valid in CUT mode
	next AID keystroke (eg Enter) enables host buffer updates
SeeAlso: AH=A4h
--------N-21B800-----------------------------
INT 21 - Novell NetWare - PRINT SERVICES - GET DEFAULT CAPTURE FLAGS
	AX = B800h
	CX = size of reply buffer (01h-3Fh)
	ES:BX -> reply buffer for capture flags table (see #1458)
Return: AL = status
	    00h successful
Note:	this function is supported by Advanced NetWare 2.0+
SeeAlso: AX=B801h,AX=B802h,AH=DFh/DL=00h,AH=DFh/DL=04h

Format of NetWare capture flags table:
Offset	Size	Description	(Table 1458)
 00h	BYTE	status (used internally, should be set to 00h)
 01h	BYTE	print flags (see #1459)
 02h	BYTE	tab size (01h-12h, default 08h)
 03h	BYTE	printer number on server (00h-04h, default 00h)
 04h	BYTE	number of copies to print (00h-FFh, default 01h)
 05h	BYTE	form type required in printer (default 00h)
 06h	BYTE	reserved
 07h 13 BYTEs	text to be placed on banner page
 14h	BYTE	reserved
 15h	BYTE	default local printer (00h = LPT1)
 16h	WORD	(big-endian) timeout in clock ticks for flushing capture file
		  on inactivity, or 0000h to disable timeout
 18h	BYTE	flush capture file on LPT close if nonzero
 19h	WORD	(big-endian) maximum lines per page
 1Bh	WORD	(big-endian) maximum characters per line
 1Dh 13 BYTEs	name of form required in printer
 2Ah	BYTE	LPT capture flag
		00h inactive, FFh LPT device is being captured
 2Bh	BYTE	file capture flag
		00h if no file specified, FFh if capturing to file
 2Ch	BYTE	timing out (00h if no timeout in effect, FFh if timeout counter
		  running)
 2Dh	DWORD	(big-endian) address of printer setup string
 31h	DWORD	(big-endian) address of printer reset string
 35h	BYTE	target connection ID
 36h	BYTE	capture in progress if FFh
 37h	BYTE	job queued for printing if FFh
 38h	BYTE	print job valid if FFh
 39h	DWORD	bindery object ID of print queue if previous byte FFh
 3Dh	WORD	(big-endian) print job number (1-999)

Bitfields for NetWare print flags:
Bit(s)	Description	(Table 1459)
 2	print capture file if interrupted by loss of connection
 3	no automatic form feed after print job
 6	printing control sequences interpreted by print service
 7	print banner page before capture file
--------N-21B801-----------------------------
INT 21 - Novell NetWare - PRINT SERVICES - SET DEFAULT CAPTURE FLAGS
	AX = B801h
	CX = size of buffer (01h-3Fh)
	ES:BX -> buffer containing capture flags table (see #1458)
Return: AL = status
	    00h successful
Note:	this function is supported by Advanced NetWare 2.0+
SeeAlso: AX=B800h,AX=B803h,AH=DFh/DL=00h,AH=DFh/DL=04h
--------N-21B802-----------------------------
INT 21 - Novell NetWare - PRINT SERVICES - GET SPECIFIC CAPTURE FLAGS
	AX = B802h
	CX = size of reply buffer (01h-3Fh)
	DH = LPT port (00h-02h)
	ES:BX -> reply buffer for capture flags table (see #1458)
Return: AL = status
	    00h successful
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AX=B800h,AX=B803h,AH=DFh/DL=00h,AH=DFh/DL=04h
--------N-21B803-----------------------------
INT 21 - Novell NetWare - PRINT SERVICES - SET SPECIFIC CAPTURE FLAGS
	AX = B803h
	CX = size of buffer (01h-3Fh)
	DH = LPT port (00h-02h)
	ES:BX -> buffer containing capture flags table (see #1458)
Return: AL = status
	    00h successful
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AX=B800h,AX=B803h,AH=DFh/DL=00h,AH=DFh/DL=04h
--------N-21B804-----------------------------
INT 21 - Novell NetWare - PRINT SERVICES - GET DEFAULT LOCAL PRINTER
	AX = B804h
Return: DH = default LPT port (00h-02h)
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AX=B800h,AX=B805h,AH=DFh/DL=00h
--------N-21B805-----------------------------
INT 21 - Novell NetWare - PRINT SERVICES - SET DEFAULT LOCAL PRINTER
	AX = B805h
	DH = new default LPT port (00h-02h)
Return: AL = status
	    00h successful
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AX=B800h,AX=B804h,AH=DFh/DL=00h
--------N-21B806-----------------------------
INT 21 - Novell NetWare - PRINT SERVICES - SET CAPTURE PRINT QUEUE
	AX = B806h
	DH = LPT port (00h-02h)
	BX:CX = print queue's object ID
Return: AL = status
	    00h successful
	    FFh job already set
Desc:	specify the print queue on which a print job is to be placed the next
	  time a capture is started on the given printer port
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AX=B801h,AX=B807h,AH=E0h/SF=09h
--------N-21B807-----------------------------
INT 21 - Novell NetWare - PRINT SERVICES - SET CAPTURE PRINT JOB
	AX = B807h
	DH = LPT port (00h-02h)
	BX = job number (see AH=E3h/SF=68h)
	SI:DI:CX = NetWare file handle (see AH=E3h/SF=68h)
Return: AL = status
	    00h successful
	    FFh job already queued
Desc:	specify the capture file and print job to be used for subsequent
	  output to the given printer port
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AX=B801h,AX=B806h,AH=E0h/SF=09h,AH=E3h/SF=68h
--------N-21B808-----------------------------
INT 21 - Novell NetWare - PRINT SERVICES - GET BANNER USER NAME
	AX = B808h
	ES:BX -> 12-byte buffer for user name
Return: AL = status
	    00h successful
Desc:	get the user name which is printed on the banner page
Notes:	this function is supported by Advanced NetWare 2.1+
	the default name is the login name of the user
SeeAlso: AX=B809h
--------N-21B809-----------------------------
INT 21 - Novell NetWare - PRINT SERVICES - SET BANNER USER NAME
	AX = B809h
	ES:BX -> 12-byte buffer containing user name
Return: AL = status
	    00h successful
Desc:	specify the user name which is printed on the banner page
Notes:	this function is supported by Advanced NetWare 2.1+
	the default name is the login name of the user
SeeAlso: AX=B808h
--------N-21B9-------------------------------
INT 21 U - Novell NetWare - "SpecialAttachableFunction"
	AH = B9h
	AL = FFh to hook this function
	    ES:BX -> function to invoke on AH=B9h when AL<>FFh
Note:	this function is no longer used or supported by current versions of
	  NetWare
--------v-21B974-----------------------------
INT 21 - VIRUS - "Tracker" - INSTALLATION CHECK
	AX = B974h
Return: AX = 2888h if resident
SeeAlso: AH=B3h"VIRUS",AH=D0h"VIRUS"
--------N-21BA-------------------------------
INT 21 U - Novell NetWare - "ReturnCommandComPointers"
	AH = BAh
Return: DX = environment segment
	ES:DI -> COMMAND.COM drive
Desc:	used to edit the COMSPEC and PATH variables in the master environment
	  when mapping network drives
Note:	this function was documented in older Novell documents which are no
	  longer available
--------N-21BB-------------------------------
INT 21 - Novell NetWare - WORKSTATION - SET END OF JOB STATUS
	AH = BBh
	AL = new EOJ flag
	    00h disable EOJs
	    01h enable EOJs
Return: AL = old EOJ flag
Desc:	specify whether the network shell should automatically generate an
	  End of Job call when the root command processor regains control
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=19h,AH=D6h
--------v-21BBBB-----------------------------
INT 21 - VIRUS - "Hey You" - INSTALLATION CHECK
	AX = BBBBh
Return: AX = 6969h
SeeAlso: AH=ABh"VIRUS",AH=BEh"VIRUS"
--------N-21BC-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - LOG PHYSICAL RECORD
	AH = BCh
	AL = flags (see #1461)
	BX = file handle
	CX:DX = starting offset in file
	SI:DI = length of region to lock
	BP = timeout in timer ticks (1/18 sec)
		0000h = don't wait if already locked
Return: AL = status (see #1460)
Desc:	add the specified physical record to the log table, optionally locking
	  it
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=5Ch,AH=BDh,AH=BEh,AH=BFh,AH=C2h,AH=D0h

(Table 1460)
Values for NetWare status:
 00h	successful
 96h	no dynamic memory for file
 FEh	timed out
 FFh	failed

Bitfields for NetWare flags:
Bit(s)	Description	(Table 1461)
 0	lock as well as log record
 1	non-exclusive lock
--------N-21BD-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - RELEASE PHYSICAL RECORD
	AH = BDh
	BX = file handle
	CX:DX = starting offset in file
	SI:DI = length of record
Return: AL = status
	    00h successful
	    FFh record not locked
Desc:	unlock the specified physical record but do not remove it from log
	  table
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=BCh,AH=BEh"NetWare",AH=C0h,AH=C3h,AH=D2h
--------N-21BE-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - CLEAR PHYSICAL RECORD
	AH = BEh
	BX = file handle
	CX:DX = starting offset within file
	SI:DI = record length in bytes
Return: AL = status
	    00h successful
	    FFh specified record not locked
Desc:	unlock the physical record and remove it from the log table
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=5Ch,AH=BCh,AH=BDh,AH=C1h,AH=C4h,AH=D4h
--------v-21BE-------------------------------
INT 21 - VIRUS - "Datalock" - INSTALLATION CHECK
	AH = BEh
Return: AX = 1234h if resident
SeeAlso: AX=BBBBh,AX=BE00h
--------v-21BE00-----------------------------
INT 21 - VIRUS - "USSR-1049" - INSTALLATION CHECK
	AX = BE00h
	CF set
Return: CF clear if resident
SeeAlso: AH=BEh"VIRUS",AH=C0h"VIRUS"
--------N-21BF-------------------------------
INT 21 O - Novell NetWare, Alloy NTNX - LOG/LOCK RECORD (FCB)
	AH = BFh
	AL = flags (see #1461)
	DS:DX -> opened FCB (see #1000 at AH=0Fh)
	BX:CX = offset
	BP = lock timeout in timer ticks (1/18 sec) if AL nonzero
	SI:DI = length
Return: AL = error code (see #1460)
Note:	this function was added in NetWare 4.6, but was removed some time prior
	  to Advanced NetWare 2.15, and is no longer listed in current Novell
	  documentation
SeeAlso: AH=BCh,AH=C0h"NetWare",AH=C2h"NetWare"
--------N-21C0-------------------------------
INT 21 O - Novell NetWare, Alloy NTNX - RELEASE RECORD (FCB)
	AH = C0h
	DS:DX -> non-extended FCB (see #1000 at AH=0Fh)
	BX:CX = offset
Return: AL = error code (see #1460)
Notes:	unlocks record but does not remove it from log table
	this function was added in NetWare 4.6, but was removed some time prior
	  to Advanced NetWare 2.15, and is no longer listed in current Novell
	  documentation
SeeAlso: AH=BDh,AH=BFh,AH=C1h"NetWare",AH=C3h
--------v-21C0-------------------------------
INT 21 - VIRUS - "Slow"/"Zerotime", "Solano" - INSTALLATION CHECK
	AH = C0h
Return: AX = 0300h if "Slow"/"Zerotime" resident
	AX = 1234h if "Solano" resident
SeeAlso: AX=BE00h,AX=C000h"VIRUS",AX=C301h"VIRUS"
--------v-21C000-----------------------------
INT 21 - VIRUS - "QUICKY" - INSTALLATION CHECK
	AX = C000h
	BX = most files infected by any other infected file
Return: AX = 76F3h if resident
SeeAlso: AH=C0h"VIRUS",AX=C001h,AX=C002h,AH=C1h"VIRUS"
--------v-21C001-----------------------------
INT 21 - VIRUS - "QUICKY" - TURN INFECTION OFF
	AX = C001h
Return: nothing
Note:	if the virus is already memory resident this call disables any
	  further infections
SeeAlso: AX=C000h,AX=C002h
--------v-21C002-----------------------------
INT 21 - VIRUS - "QUICKY" - TURN INFECTION ON
	AX = C002h
Return: nothing
Note:	if the virus is already memory resident and infection is disabled,
	  this call re-enables it
SeeAlso: AX=C000h,AX=C001h
--------N-21C1-------------------------------
INT 21 O - Novell NetWare, Alloy NTNX - CLEAR RECORD (FCB)
	AH = C1h
	DS:DX -> opened FCB (see #1000 at AH=0Fh)
	BX:CX = offset
Return: AL = error code (see #1460)
Note:	unlocks record and removes it from log table
	this function was added in NetWare 4.6, but was removed some time prior
	  to Advanced NetWare, and is no longer listed in current Novell
	  documentation
SeeAlso: AH=BEh,AH=C0h"NetWare",AH=C4h
--------v-21C1-------------------------------
INT 21 - VIRUS - "Solano" - ???
	AH = C1h
	???
Return: ???
SeeAlso: AH=C0h"VIRUS"
--------N-21C2-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - LOCK PHYSICAL RECORD SET
	AH = C2h
	AL = flags
	    bit 1: non-exclusive lock
	BP = lock timeout in timer ticks (1/18 sec) 0000h = no wait
Return: AL = status
	    00h successful
	    FEh timed out
	    FFh failed
Desc:	attempt to lock all physical records listed in the log table
Notes:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	status FFh will be returned if one or more physical records have been
	  exclusively locked by another process
SeeAlso: AH=BFh,AH=C3h,AH=D1h
--------v-21C2-------------------------------
INT 21 - VIRUS - "Scott's Valley" - ???
	AH = C2h
	???
Return: ???
SeeAlso: AH=C0h"VIRUS"
--------N-21C3-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - RELEASE PHYS RECORD SET
	AH = C3h
Desc:	unlock all currently-locked physical records in the log table, but do
	  not remove them from the table
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=BDh,AH=C0h,AH=C2h"NetWare",AH=C4h,AH=D3h
--------v-21C301DXF1F1-----------------------
INT 21 - VIRUS - "905"/"Backfont" - INSTALLATION CHECK
	AX = C301h
	DX = F1F1h
Return: DX = 0E0Eh if resident
SeeAlso: AH=C0h"VIRUS",AX=C500h"VIRUS"
--------N-21C4-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - CLEAR PHYSICAL RECORD SET
	AH = C4h
Desc:	unlock all physical records in the log table and remove them from the
	  log table
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=BEh,AH=C1h,AH=D5h
--------N-21C500-----------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - OPEN SEMAPHORE
	AX = C500h
	DS:DX -> semaphore name (counted string, max 127 bytes)
	CL = initial value for semaphore
Return: AL = status
	    00h successful
		BL = number of processes having semaphore open
		CX:DX = semaphore handle
	    03h name length greater than 127
		(refer to Novell document FYI.A.4611)
	    FEh invalid name length
	    FFh invalid semaphore value
Notes:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	the semaphore's value is incremented by AX=C503h and decremented by
	  AX=C502h
SeeAlso: AX=C501h,AX=C502h,AX=C503h,AX=C504h,AX=F220h/SF=00h
--------v-21C500-----------------------------
INT 21 - VIRUS - "Sverdlov" - INSTALLATION CHECK
	AX = C500h
Return: AX = 6731h if resident
SeeAlso: AX=C301h"VIRUS",AH=C6h"VIRUS"
--------N-21C501-----------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - EXAMINE SEMAPHORE
	AX = C501h
	CX:DX = semaphore handle
Return: AL = status
	    00h successful
		CX = semaphore value (-127 to 127)
		DL = count of processes which have the semaphore open
	    FFh invalid handle
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AX=C500h"NetWare",AX=C502h,AX=C504h,AX=F220h/SF=01h
--------N-21C502-----------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - WAIT ON SEMAPHORE
	AX = C502h
	CX:DX = semaphore handle
	BP = timeout limit in timer ticks (1/18 sec)
		0000h return immediately if semaphore already zero or negative
Return: AL = status
	    00h successful
	    FEh timeout
	    FFh invalid handle
Desc:	decrement the semaphore's value, optionally waiting until its value
	  becomes positive before decrementing
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AX=C500h"NetWare",AX=C501h,AX=C503h,AX=F220h/SF=02h
--------N-21C503-----------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - SIGNAL SEMAPHORE
	AX = C503h
	CX:DX = semaphore handle
Return: AL = status
	    00h successful
	    01h semaphore value overflowed
	    FFh invalid handle
Desc:	increment the semaphore's value and signal the first process (if any)
	  in the queue waiting on the semaphore
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AX=C500h"NetWare",AX=C502h,AX=F220h/SF=03h
--------N-21C504-----------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - CLOSE SEMAPHORE
	AX = C504h
	CX:DX = semaphore handle
Return: AL = status
	    00h successful
	    FFh invalid handle
Desc:	decrement the semaphore's open count, and delete the semaphore if the
	  count reaches zero
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AX=C500h"NetWare",AX=C501h,AX=F220h/SF=04h
--------N-21C6-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - GET OR SET LOCK MODE
	AH = C6h
	AL = subfunction
	    00h set old "compatibility" mode (default)
	    01h set new extended locks mode
	    02h get lock mode
Return: AL = current lock mode
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	the locking mode should be 01h for NetWare 4.61+ and Advanced
	  NetWare 1.0+ locking calls, and 00h for all older calls
SeeAlso: AH=BCh,AH=C4h,AH=D0h
--------v-21C6-------------------------------
INT 21 - VIRUS - "Socha" - INSTALLATION CHECK
	AH = C6h
Return: AL = 55h if resident
SeeAlso: AX=C500h"VIRUS",AX=C603h
--------v-21C603-----------------------------
INT 21 - VIRUS - "Yankee Doodle" or "MLTI" - INSTALLATION CHECK
	AX = C603h
	BX = version number (002Ch or 002Dh)
	CF set
Return: CF clear if resident
	ZF set if resident and input BX matches version
SeeAlso: AX=C500h"VIRUS",AX=C700h"VIRUS"
--------N-21C700-----------------------------
INT 21 - Novell NetWare - TRANSACTION TRACKING SYSTEM - BEGIN TRANSACTION
	AX = C700h
Return: CF clear if successful
	    AL = 00h
	CF set on error
	    AL = error code
		96h out of memory
		FEh implicit transaction already active, converted to explicit
		FFh explicit transaction already active
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AX=C701h,AX=C702h,AX=C703h,AX=F222h/SF=01h
--------v-21C700-----------------------------
INT 21 - VIRUS - "MH-757" - INSTALLATION CHECK
	AX = C700h
Return: AL = 07h if resident
SeeAlso: AX=C603h"VIRUS",AH=CBh"VIRUS"
--------N-21C701-----------------------------
INT 21 - Novell NetWare - TRANSACTION TRACKING SYSTEM - END TRANSACTION
	AX = C701h
Return: AL = status (00h,FDh-FFh) (see #1462)
	    00h successful
		CX:DX = transaction number
	CF clear except when AL=FFh
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AX=C700h"NetWare",AX=C703h,AX=F222h/SF=02h

(Table 1462)
Values for NetWare TTS status:
 00h	successful
 FDh	transaction tracking disabled
 FEh	transaction ended records locked
 FFh	no explicit transaction active
--------N-21C702-----------------------------
INT 21 - Novell NetWare - TRANSACTION TRACKING SYSTEM - INSTALLATION CHECK
	AX = C702h
Return: AL = status
	    00h not available
	    01h available
	    FDh available but disabled
Desc:	determine whether the default file server supports TTS
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AX=C700h,AX=C701h,AX=C703h,AX=F222h/SF=00h
--------N-21C703-----------------------------
INT 21 - Novell NetWare - TRANSACTION TRACKING SYSTEM - ABORT TRANSACTION
	AX = C703h
Return: CF clear if successful
	    AL = 00h
	CF set on error
	    AL = error code (FDh-FFh) (see #1462)
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AX=C700h"NetWare",AX=C701h,AX=C704h,AX=F222h/SF=03h
--------N-21C704-----------------------------
INT 21 - Novell NetWare - TRANSACTION TRACKING SYSTEM - TRANSACTION STATUS
	AX = C704h
	CX:DX = transaction number (see AX=C701h)
Return: AL = status
	    00h successful
	    FFh not yet written to disk
Desc:	verify that a transaction has actually been written to disk
Notes:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
	transactions are written to disk in the order in which they are ended,
	  but it may take as much as five seconds for the data to be written
SeeAlso: AX=C700h"NetWare",AX=C701h,AX=C703h,AX=F222h/SF=04h
--------N-21C705-----------------------------
INT 21 - Novell NetWare - TRANSACTION TRACKING SYSTEM - GET APPLICTN THRESHOLDS
	AX = C705h
Return: AL = status
	    00h successful
	CL = maximum logical record locks (default 0)
	CH = maximum physical record locks (default 0)
Desc:	get the per-application limits on record locks allowed before an
	  implicit transaction is begun
Notes:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
	if either limit is FFh, implicit transactions are disabled for the
	  corresponding lock type
SeeAlso: AX=C706h,AX=C707h,AX=F222h/SF=05h
--------N-21C706-----------------------------
INT 21 - Novell NetWare - TRANSACTION TRACKING SYSTEM - SET APPLICTN THRESHOLDS
	AX = C706h
	CL = maximum logical record locks (default 0)
	CH = maximum physical record locks (default 0)
Return: AL = status
	    00h successful
Desc:	specify the per-application limits on record locks allowed before an
	  implicit transaction is begun
Notes:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
	if either limit is set to FFh, implicit transactions are disabled for
	  the corresponding lock type
SeeAlso: AX=C705h,AX=C708h,AX=F222h/SF=06h
--------N-21C707-----------------------------
INT 21 - Novell NetWare - TRANSACTION TRACKING SYSTEM - GET WORKSTN THRESHOLDS
	AX = C707h
Return: AL = status
	    00h successful
	CL = maximum logical record locks (default 0)
	CH = maximum physical record locks (default 0)
Desc:	get the per-workstation limits on record locks allowed before an
	  implicit transaction is begun
Notes:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
	if either limit is FFh, implicit transactions are disabled for the
	  corresponding lock type
SeeAlso: AX=C705h,AX=C708h,AX=F222h/SF=07h
--------N-21C708-----------------------------
INT 21 - Novell NetWare - TRANSACTION TRACKING SYSTEM - SET WORKSTN THRESHOLDS
	AX = C708h
	CL = maximum logical record locks (default 0)
	CH = maximum physical record locks (default 0)
Return: AL = status
	    00h successful
Desc:	specify the per-workstation limits on record locks allowed before an
	  implicit transaction is begun
Notes:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
	if either limit is set to FFh, implicit transactions are disabled for
	  the corresponding lock type
SeeAlso: AX=C706h,AX=C707h,AX=F222h/SF=08h
--------N-21C8-------------------------------
INT 21 O - Novell NetWare - BEGIN LOGICAL FILE LOCKING
	AH = C8h
	if function C6h lock mode 00h:
	    DL = mode
		00h no wait
		01h wait
	if function C6h lock mode 01h:
	    BP = timeout in timer ticks (1/18 sec)
Return: AL = error code
Desc:	used to provide TTS support for applications which are not aware of
	  Novell's Transaction Tracking System
Note:	this function was added in NetWare 4.0, but was removed some time prior
	  to Advanced NetWare 2.15, and is no longer listed in current Novell
	  documentation
SeeAlso: AH=C9h
--------N-21C9-------------------------------
INT 21 O - Novell NetWare - END LOGICAL FILE LOCKING
	AH = C9h
Return: AL = error code
Desc:	used to provide TTS support for applications which are not aware of
	  Novell's Transaction Tracking System
Note:	this function was added in NetWare 4.0, but was removed some time prior
	  to Advanced NetWare 2.15, and is no longer listed in current Novell
	  documentation
SeeAlso: AH=C8h
--------N-21CA-------------------------------
INT 21 O - Novell NetWare, Alloy NTNX - LOG/LOCK PERSONAL FILE (FCB)
	AH = CAh
	DS:DX -> FCB (see #1000 at AH=0Fh)
	if function C6h lock mode 01h:
	    AL = log and lock flag
		00h log file only
		01h lock as well as log file
	    BP = lock timeout in timer ticks (1/18 sec)
Return: AL = error code
	    00h successful
	    96h no dynamic memory for file
	    FEh timeout
	    FFh failed
Desc:	provides file locking support for FCBs
Note:	this function was added in NetWare 4.0, but was removed some time prior
	  to Advanced NetWare 2.15, and is no longer listed in current Novell
	  documentation
SeeAlso: AH=CBh
--------v-21CA15-----------------------------
INT 21 - VIRUS - "Piter" - ???
	AX = CA15h
	???
Return: ???
SeeAlso: AH=CCh"VIRUS"
--------N-21CB-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - LOCK FILE SET
	AH = CBh
	if function C6h lock mode 00h:
	    DL = mode (00h no wait, 01h wait)
	if function C6h lock mode 01h:
	    BP = lock timeout in timer ticks (1/18 sec), 0000h = no wait
Return: AL = status (00h,FEh,FFh) (see #1463)
Desc:	attempt to lock all files listed in the log table
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	status FFh will be returned if one or more of the files have already
	  been exclusively locked by another process
SeeAlso: AH=CAh,AH=CDh,AH=D1h,AH=EBh

(Table 1463)
Values for NetWare status:
 00h	successful
 FEh	timed out
 FFh	failed
--------v-21CB-------------------------------
INT 21 - VIRUS - "Milous" - INSTALLATION CHECK
	AH = CBh
Return: AL = 07h if resident
SeeAlso: AX=C700h"VIRUS",AX=CB02h
--------v-21CB02-----------------------------
INT 21 - VIRUS - "Witcode" - INSTALLATION CHECK
	AX = CB02h
Return: AX = 02CBh if resident
SeeAlso: AH=CBh"VIRUS",AH=CCh"VIRUS"
--------N-21CC-------------------------------
INT 21 O - Novell NetWare, Alloy NTNX - RELEASE FILE (FCB)
	AH = CCh
	DS:DX -> FCB (see #1000 at AH=0Fh)
Return: none
Desc:	unlocks file, but does not remove it from the log table or close it
Note:	this function was added in NetWare 4.0, but was removed some time prior
	  to Advanced NetWare 2.15, and is no longer listed in current Novell
	  documentation
SeeAlso: AH=CAh,AH=CDh
--------v-21CC-------------------------------
INT 21 - VIRUS - "Westwood" - INSTALLATION CHECK
	AH = CCh
Return: AX = 0700h if resident
SeeAlso: AX=CB02h,AH=CDh"VIRUS",AX=D000h"VIRUS"
--------N-21CD-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - RELEASE FILE SET
	AH = CDh
Return: none
Desc:	unlock all files listed in the log table, but don't remove them from
	  the table
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=CBh,AH=CCh,AH=CFh,AH=D3h
--------v-21CD-------------------------------
INT 21 - VIRUS - "Westwood" - ???
	AH = CDh
	???
Return: ???
SeeAlso: AH=CCh"VIRUS"
--------N-21CE-------------------------------
INT 21 O - Novell NetWare, Alloy NTNX - CLEAR FILE (FCB)
	AH = CEh
	DS:DX -> FCB (see #1000 at AH=0Fh)
Return: AL = error code
Desc:	unlocks file and removes it from log table, then closes all opened and
	  logged occurrences
Note:	this function was added in NetWare 4.0, but was removed some time prior
	  to Advanced NetWare 2.15, and is no longer listed in current Novell
	  documentation
SeeAlso: AH=CAh,AH=CFh,AH=EDh"NetWare"
--------N-21CF-------------------------------
INT 21 - LANstep - ???
	AH = CFh
	???
Return: ???
Program: LANstep is a redesign of the Waterloo Microsystems PORT network
--------N-21CF-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - CLEAR FILE SET
	AH = CFh
Return: AL = 00h
Desc:	unlock and remove all files from log table
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=CAh,AH=CEh,AH=EBh"NetWare"
--------N-21D0-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - LOG LOGICAL RECORD
	AH = D0h
	DS:DX -> record string (counted string, max 99 data bytes)
	if function C6h lock mode 01h: (Novell, NTNX only)
	    AL = flags
		bit 0: lock as well as log the record
		bit 1: non-exclusive lock
	    BP = lock timeout in timer ticks (1/18 sec)
Return: AL = status
	    00h successful
	    96h no dynamic memory for file
	    FEh timed out
	    FFh unsuccessful
Desc:	add the specified logical record name to the log table, and optionally
	  lock the record
Notes:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+,
	  Banyan VINES, and Alloy NTNX
	locks on logical record names are advisory and may be ignored by other
	  applications
SeeAlso: AH=BCh,AH=D1h,AH=D2h,AH=D4h,AH=EBh
--------v-21D0-------------------------------
INT 21 - VIRUS - "MALAGA" - INSTALLATION CHECK
	AH = D0h
Return: AX = 00D0h if resident
SeeAlso: AH=B3h"VIRUS",AH=D0h"ANTIARJ",AX=D000h"VIRUS"
--------v-21D0-----------------------------
INT 21 - VIRUS - "ANTIARJ" -INSTALLATION CHECK
	AH = D0h
Return: AH = D1h if resident
SeeAlso: AH=D0h"MALAGA"
--------v-21D000-----------------------------
INT 21 - VIRUS - "Fellowship" - INSTALLATION CHECK
	AX = D000h
Return: BX = 1234h if resident
SeeAlso: AH=CCh"VIRUS",AH=D0h"ANTIARJ",AX=D000h"Warlock",AH=D5h"VIRUS",AX=D5AAh
--------v-21D000-----------------------------
INT 21 - VIRUS - "Warlock" - INSTALLATION CHECK
	AX = D000h
	CF clear
Return: CF set if resident (normal DOS return would be CF clear)
SeeAlso: AX=D000h"VIRUS",AH=D5h"VIRUS"
--------N-21D1-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - LOCK LOGICAL RECORD SET
	AH = D1h
	AL = lock type (00h exclusive, 01h shareable)
	if function C6h lock mode 00h:
	    DL = mode (00h no wait, 01h wait)
	if function C6h lock mode 01h: (Novell only)
	    BP = lock timeout in timer ticks (1/18 sec), 0000h no wait
Return: AL = status (see #1463)
Desc:	attempt to lock all logical record names listed in the log table
Notes:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+,
	  Banyan VINES, and Alloy NTNX
	status FFh will be returned if one or more logical records have been
	  exclusively locked by another process
	locks on logical record names are advisory and may be ignored by other
	  applications
SeeAlso: AH=C2h,AH=CBh,AH=D0h,AH=D3h,AH=D5h
--------N-21D2-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - RELEASE LOGICAL RECORD
	AH = D2h
	DS:DX -> semaphore identifier (counted string up to 99 chars long)
Return: AL = status
	    00h successful
	    FFh no such record
Desc:	unlock the logical record name but do not remove it from the log table
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+,
	  Banyan VINES, and Alloy NTNX
	locks on logical record names are advisory and may be ignored by other
	  applications
SeeAlso: AH=BDh,AH=D0h,AH=D3h,AH=D4h
--------v-21D2-------------------------------
INT 21 - VIRUS???
	AH = D2h
	???
Return: ???
Note:	this call is intercepted by the Search&Destroy SDRes v27.03 bundled
	  with Novell DOS 7, and is presumably some virus's installation check
SeeAlso: AH=4Ah/BX=00B6h
--------N-21D3-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - RELEASE LOGICAL RECORD SET
	AH = D3h
Desc:	unlock all currently-locked logical record names in the log table, but
	  do not remove them from the table
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+,
	  Banyan VINES, and Alloy NTNX
	locks on logical record names are advisory and may be ignored by other
	  applications
SeeAlso: AH=C3h,AH=CDh,AH=D1h,AH=D2h,AH=D5h
--------N-21D4-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - CLEAR LOGICAL RECORD
	AH = D4h
	DS:DX -> logical record name (counted string up to 99 chars long)
Return: AL = status (00h,FFh) (see #1464)
Desc:	unlock and remove the logical record name from the log table
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+,
	  Banyan VINES, and Alloy NTNX
	locks on logical record names are advisory and may be ignored by other
	  applications
SeeAlso: AH=BEh,AH=D0h,AH=D2h,AH=D5h

(Table 1464)
Values for NetWare status:
 00h	successful
 FFh	no such record name
--------N-21D5-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - CLEAR LOGICAL RECORD SET
	AH = D5h
Return: AL = error code (00h,FFh) (see #1464)
Desc:	unlock and remove all logical record name from the log table
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+,
	  Banyan VINES, and Alloy NTNX
	locks on logical record names are advisory and may be ignored by other
	  applications
SeeAlso: AH=D1h,AH=D3h,AH=D4h
--------v-21D5-------------------------------
INT 21 - VIRUS - "Carfield" - ???
	AH = D5h
	???
Return: ???
SeeAlso: AX=D5AAh,AH=F3h"Carfield"
--------v-21D5AA-----------------------------
INT 21 - VIRUS - "Diamond-A", "Diamond-B" - INSTALLATION CHECK
	AX = D5AAh
Return: AX = 2A55h if "Diamond-A" resident
	AX = 2A03h if "Diamond-B"-family virus resident
SeeAlso: AX=D000h,AH=D5h"VIRUS",AX=D5AAh/BP=DEAAh
--------v-21D5AABPDEAA-----------------------
INT 21 - VIRUS - "Dir" - INSTALLATION CHECK
	AX = D5AAh
	BP = DEAAh
Return: SI = 4321h if resident
SeeAlso: AX=D5AAh,AX=DADAh"VIRUS"
--------N-21D6-------------------------------
INT 21 - Novell NetWare - WORKSTATION - END OF JOB
	AH = D6h
	BX = job flag (0000h current job, FFFFh all processes on workstation)
Return: AL = error code
Desc:	unlocks and clears all locked or logged files and records held by the
	  process(es), closes all files, resets error and lock modes, and
	  releases all network resources
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=BBh"NetWare",AH=D7h
--------N-21D7-------------------------------
INT 21 - Novell NetWare - CONNECTION SERVICES - SYSTEM LOGOUT
	AH = D7h
Return: AL = error code
Desc:	this function closes the caller's open files, logs it out from all
	  file servers, detaches the workstation from all non-default file
	  servers, and maps a drive to the default server's SYS:LOGIN directory
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=D6h,AH=E3h/SF=14h,AH=F1h"NetWare"
--------N-21D8-------------------------------
INT 21 - Novell NetWare, Banyan VINES - ALLOCATE RESOURCE
	AH = D8h
	DL = resource number
Return: AL = status (00h successful, FFh unsucessful)
Note:	this function is no longer used or supported by NetWare, and is not
	  documented in Novell documents
SeeAlso: AH=D9h
--------N-21D9-------------------------------
INT 21 - Novell NetWare, Banyan VINES - DEALLOCATE RESOURCE
	AH = D9h
	DL = resource number
Return: AL = status (00h successful, FFh unsucessful)
Note:	this function is no longer used or supported by NetWare, and is not
	  documented in Novell documents
SeeAlso: AH=D8h
--------N-21DA-------------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET VOLUME INFO WITH NUMBER
	AH = DAh
	DL = volume number
	ES:DI -> reply buffer (see #1465)
Return: AL = 00h
Notes:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
	operator console rights are not required to make this call
	reported total blocks and total unused blocks include the Hot Fix
	  Table; the NetWare shell's implementation of INT 21/AH=36h will
	  report values larger than 268MB as 268MB.
SeeAlso: AH=36h,AH=E2h/SF=15h,AH=E3h/SF=E9h

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1465)
 00h	WORD	sectors/block
 02h	WORD	total blocks on volume
 04h	WORD	unused blocks
 06h	WORD	total directory entries
 08h	WORD	unused directory entries
 0Ah 16 BYTEs	volume name, null padded
 1Ah	WORD	removable flag, 0000h = not removable
Note:	all words are big-endian
--------v-21DADA-----------------------------
INT 21 - VIRUS - "Gotcha" - INSTALLATION CHECK
	AX = DADAh
Return: AH = A5h
SeeAlso: AX=D5AAh,AX=DAFEh"VIRUS"
--------v-21DAFE-----------------------------
INT 21 - VIRUS - "Plovdiv 1.3" - INSTALLATION CHECK
	AX = DAFEh
Return: AX = 1234h if resident
SeeAlso: AX=DADAh,AH=DDh"VIRUS",AH=DEh"VIRUS"
--------N-21DB-------------------------------
INT 21 - Novell NetWare - WORKSTATION - GET NUMBER OF LOCAL DRIVES
	AH = DBh
Return: AL = number of local disks as set by LASTDRIVE in CONFIG.SYS
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=0Eh
--------N-21DC-------------------------------
INT 21 - Novell NetWare - CONNECTION SERVICES - GET CONNECTION NUMBER
	AH = DCh
Return: AL = logical connection number
	    00h if NetWare not loaded or this machine is a non-dedicated server
	CX = station number in ASCII (CL = first digit)
Notes:	this function is supported by NetWare 4.0+, Banyan VINES, and Alloy
	  NTNX
	station number only unique for those PCs connected to same semaphore
	  service
SeeAlso: AH=F2h"NetWare"
--------d-21DC-------------------------------
INT 21 - PCMag PCMANAGE/DCOMPRES - TURN ON/OFF
	AH = DCh
	DX = state
	    0000h turn on
	    0001h turn off
SeeAlso: AX=FEDCh
--------v-21DC28-----------------------------
INT 21 - VIRUS - "Monika" - INSTALLATION CHECK
	AX = DC28h
Return: AX = 1973h if resident
SeeAlso: AX=D000h"VIRUS",AX=DCBAh"VIRUS"
--------v-21DCBA-----------------------------
INT 21 - VIRUS - "Red Spider" - INSTALLATION CHECK
	AX = DCBAh
Return: AX = ABCDh if resident
SeeAlso: AX=DC28h"VIRUS",AX=DEFEh"VIRUS"
--------N-21DD-------------------------------
INT 21 - Novell NetWare - WORKSTATION - SET NetWare ERROR MODE
	AH = DDh
	DL = error mode
	    00h invoke INT 24 on critical I/O errors (default)
	    01h return NetWare extended error code in AL
	    02h return error code in AL, mapped to standard DOS error codes
Return: AL = previous error mode
Note:	this function is supported by Advanced NetWare 2.0+
SeeAlso: INT 24
--------v-21DD-------------------------------
INT 21 - VIRUS - "Jerusalem"-family - RELOCATE VIRUS???
	AH = DDh
	CX = number of bytes to copy
	DS:SI -> source of copy
	ES:DI -> destination of copy
Return: does not return normally; return address is caller's CS:0100h with
	  AX = ???
SeeAlso: AX=DDEFh,AH=E0h"VIRUS",AH=EEh"VIRUS"
--------v-21DDEF------------------------
INT 21 - VIRUS- "GOLGI" - INSTALLATION CHECK
	AX = DDEFh
Return: AX = EFDDh if resident
SeeAlso: AH=DDh"VIRUS",AH=DEh"VIRUS"
--------v-21DE-------------------------------
INT 21 - VIRUS - "Durban" - INSTALLATION CHECK
	AH = DEh
Return: AH = DFh if resident
SeeAlso: AX=DAFEh,AX=DDEFh,AH=DEh"April 1st",AX=DEADh"90210"
--------v-21DE-------------------------------
INT 21 - VIRUS - "April 1st EXE" - ???
	AH = DEh
	???
Return: ???
SeeAlso: AH=DEh"Durban",AX=DEADh"90210"
--------N-21DE-------------------------------
INT 21 - Novell NetWare - MESSAGE SERVICES - SET BROADCAST MODE
	AH = DEh
	DL = broadcast mode
	    00h receive server and workstation broadcasts (default)
	    01h receive server broadcasts, discard user messages
	    02h store server broadcasts for retrieval
	    03h store all broadcasts for retrieval
Return: AL = new broadcast mode
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
--------N-21DE--DL04-------------------------
INT 21 - Novell NetWare - MESSAGE SERVICES - GET BROADCAST MODE
	AH = DEh
	DL = 04h
Return: AL = current broadcast mode
	    00h receive server and workstation broadcasts (default)
	    01h receive server broadcasts, discard user message
	    02h store server broadcasts for retrieval
	    03h store all broadcasts for retrieval
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
--------N-21DE-------------------------------
INT 21 - Novell NetWare - SHELL TIMER INTERRUPT CHECKS
	AH = DEh
	DL = function
	    05h disable shell timer interrupt checks
	    06h enable shell timer interrupt checks
Return: ???
Note:	this function was added in NetWare 4.0, but is not listed in current
	  Novell documentation and is probably no longer supported
--------v-21DEAD------------------------
INT 21 - VIRUS - "90210" - INSTALLATION CHECK
	AX = DEADh
Return: AX = AAAAh if resident
SeeAlso: AH=DEh"April 1st",AX=DEADh"Shifting",AX=DEDEh"VIRUS"
--------v-21DEAD------------------------
INT 21 - VIRUS - "Shifting Objective" - RELOCATE CODE ???
	AX = DEADh
SeeAlso: AX=FEADh
SeeAlso: AX=DEADh"90210",AX=DEDEh"VIRUS"
--------v-21DEDE-----------------------------
INT 21 - VIRUS - "Brothers" - INSTALLATION CHECK
	AX = DEDEh
Return: AH = 41h if resident
SeeAlso: AX=DEADh"Shifting",AX=DEFEh"VIRUS"
--------v-21DEFE-----------------------------
INT 21 - VIRUS - "Maze" - INSTALLATION CHECK
	AX = DEFEh
Return: AX = ABCDh if resident
SeeAlso: AX=DCBAh"VIRUS",AX=DEDEh"VIRUS",AH=E0h"VIRUS"
--------N-21DF--DL00-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - START LPT CAPTURE
	AH = DFh
	DL = 00h
Return: AL = status
	    00h successful
Desc:	this function redirects the default LPT to a capture file on the file
	  server
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX; under NTNX, it sends a print break (see INT 17/AH=84h)
	a print job is queued when the first character of output is captured
SeeAlso: AX=B800h,AX=B804h,AH=DFh/DL=01h,AH=DFh/DL=02h,AH=DFh/DL=03h
SeeAlso: AH=DFh/DL=04h,AX=F003h
--------N-21DF--DL01-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - END LPT CAPTURE
	AH = DFh
	DL = 01h
Return: AL = status
	    00h successful
Desc:	stop redirecting the default LPT, close the capture file, and release
	  the job in the print queue for printing
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX; under NTNX, it sends a print break (see INT 17/AH=84h)
	after this call, the default LPT defaults to local printing
SeeAlso: AH=DFh/DL=00h,AH=DFh/DL=02h,AH=DFh/DL=03h,AH=DFh/DL=05h
--------N-21DF--DL02-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - CANCEL LPT CAPTURE
	AH = DFh
	DL = 02h
Return: AL = status
	    00h successful
Desc:	this function ends the capture of the default LPT, removes the job from
	  the print queue, and deletes the capture file unless it is a
	  permanent capture file
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX; under NTNX, it sends a print break (see INT 17/AH=84h)
	after this call, the default LPT defaults to local printing
SeeAlso: AH=DFh/DL=00h,AH=DFh/DL=06h
--------N-21DF--DL03-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - FLUSH LPT CAPTURE
	AH = DFh
	DL = 03h
Return: AL = status
	    00h successful
Desc:	this function closes the current capture file for the default LPT
	  and starts printing it if it is not a permanent capture file
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX; under NTNX, it sends a print break (see INT 17/AH=84h)
	if more data is sent to the LPT port after this call, a new capture
	  file will be opeend
SeeAlso: AH=DFh/DL=00h,AH=DFh/DL=01h,AH=DFh/DL=02h,AH=DFh/DL=07h
--------N-21DF--DL04-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - START SPECIFIC LPT CAPTURE
	AH = DFh
	DL = 04h
	DH = LPT port (00h-02h)
Return: AL = status
	    00h successful
Desc:	this function redirects the specified LPT to a capture file on the file
	  server
Notes:	this function is supported by Advanced NetWare 2.1+
	a print job is queued when the first character of output is captured
SeeAlso: AX=B800h,AH=DFh/DL=00h,AH=DFh/DL=05h,AH=DFh/DL=06h,AH=DFh/DL=07h
SeeAlso: AX=F003h
--------N-21DF--DL05-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - END SPECIFIC LPT CAPTURE
	AH = DFh
	DL = 05h
	DH = LPT port (00h-02h)
Return: AL = status
	    00h successful
Desc:	stop redirecting the specified LPT, close the capture file, and release
	  the job in the print queue for printing
Notes:	this function is supported by Advanced NetWare 2.1+
	after this call, the specified LPT defaults to local printing
SeeAlso: AH=DFh/DL=01h,AH=DFh/DL=04h,AH=DFh/DL=06h,AH=DFh/DL=07h
--------N-21DF--DL06-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - CANCEL SPECIFIC LPT CAPTURE
	AH = DFh
	DL = 06h
	DH = LPT port (00h-02h)
Return: AL = status
	    00h successful
Desc:	this function ends the capture of the specified LPT, removes the job
	  from the print queue, and deletes the capture file unless it is a
	  permanent capture file
Notes:	this function is supported by Advanced NetWare 2.1+
	after this call, the specified LPT defaults to local printing
SeeAlso: AH=DFh/DL=02h,AH=DFh/DL=04h,AH=DFh/DL=05h,AH=DFh/DL=07h
--------N-21DF--DL07-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - FLUSH SPECIFIC LPT CAPTURE
	AH = DFh
	DL = 07h
	DH = LPT port (00h-02h)
Return: AL = status
	    00h successful
Desc:	this function closes the current capture file for the specified LPT
	  and starts printing it if it is not a permanent capture file
Notes:	this function is supported by Advanced NetWare 2.1+
	if more data is sent to the LPT port after this call, a new capture
	  file will be opeend
SeeAlso: AH=DFh/DL=03h,AH=DFh/DL=04h,AH=DFh/DL=05h,AH=DFh/DL=06h
--------T-21DF00DX534C-----------------------
INT 21 U - Software Carousel - INSTALLATION CHECK
	AX = DF00h
	DX = 534Ch ("SL")
	DI = 534Ch ("SL")
Return: AX = 00FFh if installed
	    ???
Program: Software Carousel is a task switcher by SoftLogic Solutions, Inc.
--------T-21DF01-----------------------------
INT 21 - Software Carousel - SWITCH TO ANOTHER TASK
	AX = DF01h
	BL = task number (00h = next task)
Return: AL = status
	    00h Carousel not running
	    01h successful
	    FFh unsucessful
		AH = error code (01h,02h) (see #1466)

(Table 1466)
Values for Software Carousel error code:
 00h	invalid subfunction in AL
 01h	invalid task number
 02h	tried to switch to task with no memory size
 03h	tried to kill program in partition with no program running
 04h	tried to change size of an active memory partition
 05h	invalid memory size
 06h	tried to send command to task with a pending previous command
--------T-21DF02-----------------------------
INT 21 - Software Carousel - KILL PROGRAM IN MEMORY PARTITION
	AX = DF02h
	BL = task number
Return: AL = status
	    00h Carousel not running
	    01h successful
	    FFh unsucessful
		AH = error code (01h,03h) (see #1466)
--------T-21DF03-----------------------------
INT 21 - Software Carousel - GET PARTITION SIZE AND PROGRAM STATUS
	AX = DF03h
	BL = task number
Return: AL = status
	    00h Carousel not running
	    01h successful
		BL = partition state (00h no program running, 01h prog running)
		DX = partition size in KB
	    FFh unsucessful
		AH = error code (01h) (see #1466)
SeeAlso: AX=DF05h
--------T-21DF04-----------------------------
INT 21 - Software Carousel - GET PARTITION NAME
	AX = DF04h
	BL = task number
Return: AL = status
	    00h Carousel not running
	    01h successful
		CX = length of name (00h if default partition name)
		ES:BX -> partition name (if CX nonzero)
	    FFh unsucessful
		AH = error code (01h) (see #1466)
SeeAlso: AX=DF06h
--------T-21DF05-----------------------------
INT 21 - Software Carousel - CHANGE PARTITION SIZE
	AX = DF05h
	BL = task number
	DX = new size in KB
Return: AL = status
	    00h Carousel not running
	    01h successful
	    FFh unsucessful
		AH = error code (01h,04h,05h) (see #1466)
	BX = minimum size allowed
	CX = maximum size available
SeeAlso: AX=DF03h
--------T-21DF06-----------------------------
INT 21 - Software Carousel - CHANGE PARTITION NAME
	AX = DF06h
	BL = task number
	CX = length of new name (00h to use default, max 18h)
	DS:SI -> new name
Return: AL = status
	    00h Carousel not running
	    01h successful
	    FFh unsucessful
		AH = error code (01h) (see #1466)
SeeAlso: AX=DF04h
--------T-21DF07-----------------------------
INT 21 - Software Carousel - SEND COMMAND TO MEMORY SECTION
	AX = DF07h
	BL = task number
	CX = length of command (max 8 chars)
	DS:SI -> command line
Return: AL = status
	    00h Carousel not running
	    01h successful
	    FFh unsucessful
		AH = error code (01h,06h) (see #1466)
Note:	the maximum length seems too small and may be a typo for 80 characters
--------T-21DF08-----------------------------
INT 21 - Software Carousel - SELECTIVELY ENABLE/DISABLE MENU AND SWITCHING
	AX = DF08h
	BL = new state of keyboard (00h disabled, 01h enabled)
Return: AL = status
	    00h Carousel not running
	    01h successful
Program: Software Carousel is a task switcher by SoftLogic Solutions, Inc.
Note:	when the keyboard is is disabled, the user may neither access the
	  Carousel menu nor switch to another memory section
--------T-21DF09-----------------------------
INT 21 - Software Carousel - BOOT THE SYSTEM
	AX = DF09h
Return: AL = status
	    00h Carousel not running
	    FFh unsucessful
		AH = error code (01h,03h) (see #1466)
Note:	this function never returns if successful
--------T-21DF0A-----------------------------
INT 21 - Software Carousel - GET MEMORY SIZE/PARTITION NUMBER OF CURRENT TASK
	AX = DF0Ah
Return: AL = status
	    00h Carousel not running
	    01h successful
		BL = task number
		DX = memory size in KB
	    FFh unsucessful
		AH = error code (01h,03h) (see #1466)
--------T-21DF0B-----------------------------
INT 21 - Software Carousel - SET TASK SWITCH CALLBACK
	AX = DF0Bh
	BH = interrupt number or 00h
	BL = function number to invoke on partition switch
	CL = function number to call when it is safe for resident programs
		to perform DOS calls
	DS:DX -> FAR function to call if BH=00h
Return: AL = status
	    00h Carousel not running
	    01h successful
	    FFh unsucessful
		AH = error code (01h,03h) (see #1466)
Notes:	the specified interrupt or FAR function is called with AH set to the
	  appropriate one of the values specified in BL and CL, and BL set to
	  the new task number
	the function specified by CL will not be called until the notification
	  is enabled with AX=DF0Ch
SeeAlso: AX=DF0Ch
--------T-21DF0C-----------------------------
INT 21 - Software Carousel - ENABLE DOS-CALL SAFETY NOTIFICATION
	AX = DF0Ch
Return: AL = status
	    00h Carousel not running
	    01h successful
Program: Software Carousel is a task switcher by SoftLogic Solutions, Inc.
SeeAlso: AX=DF0Bh
--------O-21E0-------------------------------
INT 21 - Digital Research DOS Plus - CALL BDOS
	AH = E0h
	CL = BDOS function number (see #3651 at INT E0"CP/M-86")
	other registers as appropriate for function
Return: as appropriate for function
SeeAlso: AX=4459h,INT E0"CP/M-86"
--------E-21E0-------------------------------
INT 21 - OS/286, OS/386 - INITIALIZE REAL PROCEDURE
	AH = E0h
	???
Return: ???
SeeAlso: AH=E1h"OS/286"
--------T-21E0-------------------------------
INT 21 - DoubleDOS - MENU CONTROL
	AH = E0h
	AL = subfunction
	    01h exchange tasks
	    73h resume invisible job if suspended
	    74h kill other job
	    75h suspend invisible job
Note:	identical to AH=F0h
SeeAlso: AH=F0h"DoubleDOS"
--------v-21E0-------------------------------
INT 21 - VIRUS - "Jerusalem", "Armagedon" - INSTALLATION CHECK
	AH = E0h
Return: AX = 0300h if "Jerusalem" resident
	AX = DADAh if "Armagedon" resident
SeeAlso: AH=DEh"VIRUS",AX=DEDEh"VIRUS",AX=E00Fh
--------N-21E0-------------------------------
INT 21 - Novell NetWare, Alloy NTNX - PRINT SPOOLING
	AH = E0h
	DS:SI -> request buffer (see #1467)
	ES:DI -> reply buffer
Return: AL = status
Note:	this function was added in NetWare 4.0, but is no longer listed in
	  current Novell documentation and may no longer be supported
SeeAlso: AH=E3h/SF=68h,AX=F211h/SF=06h,AX=F211h/SF=0Ah

Format of NetWare print spooling request buffer:
Offset	Size	Description	(Table 1467)
 00h	WORD	length of following data
 02h	BYTE	subfunction
		00h spool data to a capture file
		01h close and queue capture file
		02h set spool flags
		03h spool existing file
		04h get spool queue entry
		05h remove entry from spool queue
 03h	???
SeeAlso: #1756
--------N-21E0--SF06-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - GET PRINTER STATUS
	AH = E0h subfn 06h
	DS:SI -> request buffer (see #1468)
	ES:DI -> reply buffer (see #1469)
Return: AL = status
	    00h successful
	    FFh no such printer
Desc:	get current state of specified printer attached to the server
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX

Format of NetWare "Get Printer Status" request buffer:
Offset	Size	Description	(Table 1468)
 00h	WORD	0002h (length of following data)
 02h	BYTE	06h (subfunction "Get Printer Status")
 03h	BYTE	printer number (00h-04h)
SeeAlso: #1469

Format of NetWare "Get Printer Status" reply buffer:
Offset	Size	Description	(Table 1469)
 00h	WORD	(call) 0004h (size of following results buffer)
 02h	BYTE	flag: 00h printer active, FFh printer halted
 03h	BYTE	flag: 00h printer online, 01h printer offline
 04h	BYTE	current form type
 05h	BYTE	target printer number (00h-04h)
		same as number in request buffer unless rerouted by server
		  console
SeeAlso: #1468
--------N-21E0--SF09-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - SPECIFY CAPTURE FILE
	AH = E0h subfn 09h
	DS:SI -> request buffer (see #1470)
	ES:DI -> reply buffer (see #1471)
Return: AL = status
	    00h successful
	    9Ch invalid path
Desc:	create a permanent capture file for the next print capture to be
	  started
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	the caller must have read, write, and create rights for the directory
	  containing the capture file

Format of NetWare "Specify Capture File" request buffer:
Offset	Size	Description	(Table 1470)
 00h	WORD	length of following data (max 102h)
 02h	BYTE	09h (subfunction "Specify Capture File")
 03h	BYTE	directory handle or 00h
 04h	BYTE	length of filename
 05h  N BYTEs	name of capture file
SeeAlso: #1471

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1471)
 00h	WORD	(call) 0000h (no results returned)
SeeAlso: #1470
--------v-21E00F-----------------------------
INT 21 - VIRUS - "8-tunes" - INSTALLATION CHECK
	AX = E00Fh
Return: AX = 4C31h if resident
SeeAlso: AH=E0h"VIRUS",AH=E1h"VIRUS"
--------E-21E1-------------------------------
INT 21 - OS/286, OS/386 - ISSUE REAL PROCEDURE CALL
	AH = E1h
	???
Return: ???
Note:	protected mode only???
SeeAlso: AH=E0h"OS/286",AH=E2h"OS/286",AH=E3h"OS/286",AX=250Eh,INT 31/AX=0301h
--------T-21E1-------------------------------
INT 21 - DoubleDOS - CLEAR KEYBOARD BUFFER FOR CURRENT JOB
	AH = E1h
SeeAlso: AH=E2h"DoubleDOS",AH=E3h"DoubleDOS",AH=E8h"DoubleDOS"
SeeAlso: AH=F1h"DoubleDOS"
--------v-21E1-------------------------------
INT 21 - VIRUS - "Mendoza", "Fu Manchu" - INSTALLATION CHECK
	AH = E1h
Return: AX = 0300h if "Mendoza" resident
	AX = 0400h if "Fu Manchu" resident
SeeAlso: AX=E00Fh,AH=E4h"VIRUS"
--------N-21E1--SF00-------------------------
INT 21 - Novell NetWare - MESSAGE SERVICES - SEND BROADCAST MESSAGE
	AH = E1h subfn 00h
	DS:SI -> request buffer (see #1472)
	ES:DI -> reply buffer (see #1473)
Return: AL = status
	    00h successful
	    FEh I/O error or out of dynamic workspace
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AH=DEh"NetWare",AH=DEh/DL=04h,AH=E1h/SF=01h,AH=E1h/SF=04h
SeeAlso: AH=E1h/SF=09h

Format of NetWare "Send Broadcast Message" request buffer:
Offset	Size	Description	(Table 1472)
 00h	WORD	length of following data (max 9Eh)
 02h	BYTE	00h (subfunction "Send Broadcast Message")
 03h	BYTE	number of connections (01h-64h)
 04h  N BYTEs	list of connections to receive broadcast message
	BYTE	length of message (01h-37h)
      N BYTEs	broadcast message (no control characters or characters > 7Eh)
SeeAlso: #1473

Format of NetWare "Send Broadcast Message" reply buffer:
Offset	Size	Description	(Table 1473)
 00h	WORD	(call) size of following results buffer (max 65h)
 02h	BYTE	number of connections
 03h  N BYTEs	list of per-connection results
		00h successful
		FCh message rejected due to lack of buffer space
		FDh invalid connection number
		FFh blocked (see also AH=E1h/SF=02h)
SeeAlso: #1472
--------N-21E1--SF01-------------------------
INT 21 - Novell NetWare - MESSAGE SERVICES - GET BROADCAST MESSAGE (OLD)
	AH = E1h subfn 01h
	DS:SI -> request buffer (see #1474)
	ES:DI -> reply buffer (see #1475)
Return: AL = status
	    00h successful
	    FCh full message queue
	    FEh out of dynamic workspace
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AH=DEh/DL=04h,AH=E1h/SF=00h,AH=E1h/SF=05h,AH=E1h/SF=09h
SeeAlso: AX=F215h/SF=01h,AX=F215h/SF=0Bh

Format of NetWare "Get Broadcast Message" request buffer:
Offset	Size	Description	(Table 1474)
 00h	WORD	0001h (length of following data)
 02h	BYTE	01h (subfunction "Get Broadcast Message")
SeeAlso: #1475,#1764

Format of NetWare "Get Broadcast Message" reply buffer:
Offset	Size	Description	(Table 1475)
 00h	WORD	(call) size of following results buffer (max 38h)
 02h	BYTE	length of message (00h-37h)
		00h if no broadcast messages pending
 03h  N BYTEs	message (no control characters or characters > 7Eh)
SeeAlso: #1474,#1762,#1765
--------N-21E1--SF02-------------------------
INT 21 - Novell NetWare - MESSAGE SERVICES - DISABLE BROADCAST MESSAGES
	AH = E1h subfn 02h
	DS:SI -> request buffer (see #1477)
	ES:DI -> reply buffer (see #1478)
Return: AL = error code
Note:	these functions are supported by NetWare 4.0+ but are not listed in
	  _NetWare_System_Calls--DOS_; they may be obsolete
SeeAlso: AH=E1h/SF=00h,AH=E1h/SF=03h,AH=E1h/SF=04h,AH=E1h/SF=09h
SeeAlso: AX=F215h/SF=02h

Format of NetWare "Disable Broadcasts" request packet:
Offset	Size	Description	(Table 1476)
 00h	WORD	0001h (length of following data)
 02h	BYTE	02h (subfunction "Enable Broadcast Messages")
SeeAlso: #1477,#1478
--------N-21E1--SF03-------------------------
INT 21 - Novell NetWare - MESSAGE SERVICES - ENABLE BROADCAST MESSAGES
	AH = E1h subfn 03h
	DS:SI -> request buffer (see #1477)
	ES:DI -> reply buffer (see #1478)
Return: AL = error code
Note:	these functions are supported by NetWare 4.0+ but are not listed in
	  _NetWare_System_Calls--DOS_; they may be obsolete
SeeAlso: AH=E1h/SF=00h,AH=E1h/SF=02h,AH=E1h/SF=04h,AH=E1h/SF=09h
SeeAlso: AX=F215h/SF=03h

Format of NetWare "Enable Broadcast Messages" request buffer:
Offset	Size	Description	(Table 1477)
 00h	WORD	0001h (length of following data)
 02h	BYTE	03h (subfunction "Enable Broadcast Messages")
SeeAlso: #1478,#1476

Format of NetWare "Enable/Disable Broadcast Messages" reply buffer:
Offset	Size	Description	(Table 1478)
 00h	WORD	(call) 0000h (no data returned)
SeeAlso: #1477,#1476
--------N-21E1--SF04-------------------------
INT 21 O - Novell NetWare - MESSAGE SERVICES - SEND PERSONAL MESSAGE
	AH = E1h subfn 04h
	DS:SI -> request buffer (see #1479)
	ES:DI -> reply buffer (see #1480)
Return: AL = status
	    00h successful
	    FEh I/O error or out of dynamic workspace
Notes:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0-2.x
	message pipes use CPU time on the file server; IPX, SPX, or NetBIOS
	  connections should be used for peer-to-peer communications as these
	  protocols do not use file server time
SeeAlso: AH=E1h/SF=00h,AH=E1h/SF=05h,AH=E1h/SF=06h,AH=E1h/SF=08h

Format of NetWare "Send Personal Message" request buffer:
Offset	Size	Description	(Table 1479)
 00h	WORD	length of following data (max E5h)
 02h	BYTE	04h (subfunction "Send Personal Message")
 03h	BYTE	number of connections (01h-64h)
 04h  N BYTEs	list of connections to receive broadcast message
	BYTE	length of message (01h-7Eh)
      N BYTEs	message (no control characters or characters > 7Eh)
SeeAlso: #1480

Format of NetWare "Send Personal Message" reply buffer:
Offset	Size	Description	(Table 1480)
 00h	WORD	(call) size of following results buffer (max 65h)
 02h	BYTE	number of connections
 03h  N BYTEs	list of per-connection results
		00h successful
		FCh message rejected because queue is full (contains 6 msgs)
		FDh incomplete pipe
		FFh failed
SeeAlso: #1479
--------N-21E1--SF05-------------------------
INT 21 O - Novell NetWare - MESSAGE SERVICES - GET PERSONAL MESSAGE
	AH = E1h subfn 05h
	DS:SI -> request buffer (see #1481)
	ES:DI -> reply buffer (see #1482)
Return: AL = status
	    00h successful
	    FEh out of dynamic workspace
Desc:	return the oldest message in the default file server's message queue
	  for the calling workstation
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0-2.x
SeeAlso: AH=E1h/SF=01h,AH=E1h/SF=04h,AH=E1h/SF=06h,AH=E1h/SF=08h

Format of NetWare "Get Personal Message" request buffer:
Offset	Size	Description	(Table 1481)
 00h	WORD	0001h (length of following data)
 02h	BYTE	05h (subfunction "Get Personal Message")
SeeAlso: #1482

Format of NetWare "Get Personal Message" reply buffer:
Offset	Size	Description	(Table 1482)
 00h	WORD	(call) size of following results buffer (max 80h)
 02h	BYTE	connection number of sending station
 03h	BYTE	length of message (00h-7Eh)
		00h if no personal messages pending
 04h  N BYTEs	message (no control characters or characters > 7Eh)
SeeAlso: #1481
--------N-21E1--SF06-------------------------
INT 21 O - Novell NetWare - MESSAGE SERVICES - OPEN MESSAGE PIPE
	AH = E1h subfn 06h
	DS:SI -> request buffer (see #1483)
	ES:DI -> reply buffer (see #1484)
Return: AL = status
	    00h successful
	    FEh out of dynamic workspace
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0-2.x
SeeAlso: AH=E1h/SF=04h,AH=E1h/SF=07h,AH=E1h/SF=08h

Format of NetWare "Open Message Pipe" request buffer:
Offset	Size	Description	(Table 1483)
 00h	WORD	length of following data (max 66h)
 02h	BYTE	06h (subfunction "Open Message Pipe")
 03h	BYTE	number of pipes to open (01h-64h)
 04h  N BYTEs	list of connection numbers
SeeAlso: #1484,#1485,#1488

Format of NetWare "Open Message Pipe" reply buffer:
Offset	Size	Description	(Table 1484)
 00h	WORD	(call) size of following results buffer (max 65h)
 02h	BYTE	number of connections
 03h  N BYTEs	list of results
		00h successful
		FEh incomplete (target half not yet created)
		FFh failed
SeeAlso: #1483,#1486,#1489
--------N-21E1--SF07-------------------------
INT 21 O - Novell NetWare - MESSAGE SERVICES - CLOSE MESSAGE PIPE
	AH = E1h subfn 07h
	DS:SI -> request buffer (see #1485)
	ES:DI -> reply buffer (see #1486)
Return: AL = status
	    00h successful
	    FCh full message queue
	    FEh out of dynamic workspace
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0-2.x
SeeAlso: AH=E1h/SF=05h,AH=E1h/SF=06h,AH=E1h/SF=08h

Format of NetWare "Close Mesage Pipe" request buffer:
Offset	Size	Description	(Table 1485)
 00h	WORD	length of following data (max 66h)
 02h	BYTE	07h (subfunction "Close Message Pipe")
 03h	BYTE	number of pipes to close (01h-64h)
 04h  N BYTEs	list of connection numbers
SeeAlso: #1483,#1486

Format of NetWare "Close Message Pipe" reply buffer:
Offset	Size	Description	(Table 1486)
 00h	WORD	(call) size of following results buffer (max 65h)
 02h	BYTE	number of connections
 03h  N BYTEs	list of results
		00h successful
		FDh failed
		FFh no such pipe
SeeAlso: #1484,#1485
--------N-21E1--SF08-------------------------
INT 21 O - Novell NetWare - MESSAGE SERVICES - CHECK PIPE STATUS
	AH = E1h subfn 08h
	DS:SI -> request buffer (see #1488)
	ES:DI -> reply buffer (see #1489)
Return: AL = status (see #1487)
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0-2.x
SeeAlso: AH=E1h/SF=05h,AH=E1h/SF=06h,AH=E1h/SF=07h,AX=F215h/SF=08h

(Table 1487)
Values for NetWare function status:
 00h	successful
 FCh	full message queue
 FEh	out of dynamic workspace
SeeAlso: #1492

Format of NetWare "Check Pipe Status" request buffer:
Offset	Size	Description	(Table 1488)
 00h	WORD	length of following data (max 66h)
 02h	BYTE	08h (subfunction "Check Pipe Status")
 03h	BYTE	number of pipes to monitor (01h-64h)
 04h  N BYTEs	list of connection numbers
SeeAlso: #1483,#1489

Format of NetWare "Check Pipe Status" reply buffer:
Offset	Size	Description	(Table 1489)
 00h	WORD	(call) size of following results buffer (max 65h)
 02h	BYTE	number of connections
 03h  N BYTEs	list of pipe statuses
		00h open
		FEh incomplete
		FFh closed
SeeAlso: #1484,#1488,#1763
--------N-21E1--SF09-------------------------
INT 21 - Novell NetWare - MESSAGE SERVICES - BROADCAST TO CONSOLE
	AH = E1h subfn 09h
	DS:SI -> request buffer (see #1490)
	ES:DI -> reply buffer (see #1491)
Return: AL = status (see #1487)
Desc:	send a one-line message to the system console on the default file
	  server
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AH=DEh/DL=04h,AH=E1h/SF=00h,AH=E1h/SF=01h,AH=E3h/SF=D1h
SeeAlso: AX=F215h/SF=09h

Format of NetWare "Broadcast to Console" request buffer:
Offset	Size	Description	(Table 1490)
 00h	WORD	length of following data (max 3Eh)
 02h	BYTE	09h (subfunction "Broadcast to Console")
 03h	BYTE	length of message (01h-3Ch)
 04h  N BYTEs	message (no control characters or characters > 7Eh)
SeeAlso: #1491

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1491)
 00h	WORD	(call) 0000h (no results returned)
SeeAlso: #1490
--------E-21E2-------------------------------
INT 21 - OS/286, OS/386 - SET REAL PROCEDURE SIGNAL HANDLER
	AH = E2h
	???
Return: ???
SeeAlso: AH=E0h"OS/286",AH=E1h"OS/286",AH=E6h"OS/286"
--------N-21E2-------------------------------
INT 21 - DoubleDOS - SEND CHARACTER TO KEYBOARD BUFFER OF OTHER JOB
	AH = E2h
	AL = character
Return: AL = 00h successful
	     01h buffer full (128 characters)
SeeAlso: AH=E1h"DoubleDOS",AH=E3h"DoubleDOS",AH=E8h"DoubleDOS"
SeeAlso: AH=F2h"DoubleDOS"
--------N-21E2--SF00-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - SET DIRECTORY HANDLE
	AH = E2h subfn 00h
	DS:SI -> request buffer (see #1493)
	ES:DI -> reply buffer (see #1494)
Return: AL = status (00h,98h,9Bh,9Ch) (see #1492)
Desc:	set the target handle to reference the directory specified by the
	  source handle and the source path; both handles must refer to the
	  same file server
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	the target handle is not changed if this function fails
SeeAlso: AH=E2h/SF=01h,AH=E2h/SF=12h,AH=E2h/SF=13h,AX=F216h/SF=00h

(Table 1492)
Values for NetWare function status:
 00h	successful
 84h	not permitted to create
 8Ah	not permitted to delete
 8Bh	not permitted to rename
 8Ch	not permitted to modify
 98h	nonexistent volume
 9Bh	invalid directory handle
 9Ch	invalid path
 9Eh	invalid filename
 9Fh	directory currently in use
 A0h	directory not empty
 C6h	no console rights
 FCh	no such bindery object
SeeAlso: #1487,#1519

Format of NetWare "Set Directory Handle" request buffer:
Offset	Size	Description	(Table 1493)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	00h (subfunction "Set Directory Handle")
 03h	BYTE	directory handle of target
 04h	BYTE	directory handle of source
 05h	BYTE	length of source directory path (01h-FFh)
 06h  N BYTEs	source directory path
SeeAlso: #1494

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1494)
 00h	WORD	(call) 0000h (no results returned)
SeeAlso: #1493
--------N-21E2--SF01-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET DIRECTORY PATH
	AH = E2h subfn 01h
	DS:SI -> request buffer (see #1495)
	ES:DI -> reply buffer (see #1496)
Return: AL = status (00h,9Bh) (see #1492)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=02h,AH=E2h/SF=03h,AH=E2h/SF=1Ah,AH=E9h,AX=F216h/SF=01h

Format of NetWare "Get Directory Path" request buffer:
Offset	Size	Description	(Table 1495)
 00h	WORD	0002h (length of following data)
 02h	BYTE	01h (subfunction "Get Directory Path")
 03h	BYTE	directory handle
SeeAlso: #1496,#1497

Format of NetWare "Get Directory Path" reply buffer:
Offset	Size	Description	(Table 1496)
 00h	WORD	(call) length of following data buffer
 02h	BYTE	length of directory path (01h-FFh)
 03h  N BYTEs	full directory path including volume
SeeAlso: #1495,#1498
--------N-21E2--SF02-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - SCAN DIRECTORY INFORMATION
	AH = E2h subfn 02h
	DS:SI -> request buffer (see #1497)
	ES:DI -> reply buffer (see #1498)
Return: AL = status (00h,98h,9Bh,9Ch) (see #1492)
Desc:	get information about the first or next subdirectory of the specified
	  directory
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=01h,AH=E2h/SF=03h,AH=E2h/SF=19h,AX=F216h/SF=02h

Format of NetWare "Scan Directory Information" request buffer:
Offset	Size	Description	(Table 1497)
 00h	WORD	length of following data (max 104h)
 02h	BYTE	02h (subfunction "Scan Directory Information")
 03h	BYTE	directory handle
 04h	WORD	(big-endian) subdirectory number
		0000h for first call, returned subdir number + 1 on next call
 06h	BYTE	length of directory path
 07h  N BYTEs	directory path
SeeAlso: #1495,#1498

Format of NetWare "Scan Directory Information" reply buffer:
Offset	Size	Description	(Table 1498)
 00h	WORD	(call) 001Ch (length of following data buffer)
 02h 16 BYTEs	subdirectory name
 12h	DWORD	(big-endian) date and time of creation (see #1499)
 16h	DWORD	(big-endian) object ID of owner
 1Ah	BYTE	maximum directory rights (see #1502)
 1Bh	BYTE	unused
 1Ch	WORD	(big-endian) subdirectory number
SeeAlso: #1496,#1497,#1766 at AX=F216h/SF=02h

Bitfields for NetWare date and time:
Bit(s)	Description	(Table 1499)
 31-25	year-1980
 24-21	month
 20-16	day
 15-11	hour
 10-5	minute
 4-0	second
--------N-21E2--SF03-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET EFFECTIVE DIRECTORY RIGHTS
	AH = E2h subfn 03h
	DS:SI -> request buffer (see #1500)
	ES:DI -> reply buffer (see #1501)
Return: AL = status (00h,98h,9Bh) (see #1492)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=01h,AH=E2h/SF=02h,AX=F216h/SF=03h

Format of NetWare "Get Effective Directory Rights (old)" request buffer:
Offset	Size	Description	(Table 1500)
 00h	WORD	length of following data (max 102h)
 02h	BYTE	03h (subfunction "Get Effective Directory Rights (old)")
 03h	BYTE	directory handle
 04h	BYTE	length of directory path (00h-FFh)
 05h  N BYTEs	directory path
SeeAlso: #1501,#1503

Format of NetWare "Get Effective Directory Rights" reply buffer:
Offset	Size	Description	(Table 1501)
 00h	WORD	(call) 0001h (length of following data buffer)
 02h	BYTE	effective directory rights (see #1502)
SeeAlso: #1500

Bitfields for NetWare directory rights:
Bit(s)	Description	(Table 1502)
 0	reading allowed
 1	writing allowed
 2	opens allowed
 3	file creation allowed
 4	deletion allowed
 5	"parental" may create/delete subdirectories and grant/revoke trustee
	  rights
 6	directory search allowed
 7	file attributes may be changed
SeeAlso: #1501,#1503
--------N-21E2--SF04-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - MODIFY MAXIMUM RIGHTS MASK
	AH = E2h subfn 04h
	DS:SI -> request buffer (see #1503)
	ES:DI -> reply buffer (see #1504)
Return: AL = status (00h,8Ch,98h,9Ch) (see #1492)
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=03h,AH=E2h/SF=0Ah,AH=E2h/SF=0Dh,AX=F216h/SF=04h

Format of NetWare "Modify Maximum Rights Mask" request buffer:
Offset	Size	Description	(Table 1503)
 00h	WORD	length of following data (max 104h)
 02h	BYTE	04h (subfunction "Modify Maximum Rights Mask")
 03h	BYTE	directory handle
 04h	BYTE	rights to grant (see #1502)
 05h	BYTE	rights to revoke (see #1502)
 06h	BYTE	length of directory path (00h-FFh)
 07h  N BYTEs	directory path
Note:	the rights specified at offset 05h are revoked first, and then the
	  rights specified at offset 04h are added to the resulting rights
	  mask
SeeAlso: #1500,#1504

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1504)
 00h	WORD	(call) 0000h (no results returned)
SeeAlso: #1503
--------N-21E2--SF05-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET VOLUME NUMBER
	AH = E2h subfn 05h
	DS:SI -> request buffer (see #1505)
	ES:DI -> reply buffer (see #1506)
Return: AL = status (00h,98h) (see #1492)
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=DAh,AH=E2h/SF=02h,AH=E2h/SF=05h,AH=E2h/SF=15h,AH=E3h/SF=E9h
SeeAlso: AX=F216h/SF=05h

Format of NetWare "Get Volume Number" request buffer:
Offset	Size	Description	(Table 1505)
 00h	WORD	length of following data (max 12h)
 02h	BYTE	05h (subfunction "Get Volume Number")
 03h	BYTE	length of volume name (01h-10h)
 04h  N BYTEs	volume name
SeeAlso: #1506,#1768 at AX=F216h/SF=05h

Format of NetWare "Get Volume Number" reply buffer:
Offset	Size	Description	(Table 1506)
 00h	WORD	(call) 0001h (length of following results buffer)
 02h	BYTE	volume number
SeeAlso: #1505,#1768 at AX=F216h/SF=05h
--------N-21E2--SF06-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET VOLUME NAME
	AH = E2h subfn 06h
	DS:SI -> request buffer (see #1507)
	ES:DI -> reply buffer (see #1508)
Return: AL = status (00h,98h) (see #1492)
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=DAh,AH=E2h/SF=02h,AH=E2h/SF=05h,AH=E2h/SF=15h,AH=E2h/SF=1Ah
SeeAlso: AH=E3h/SF=E9h,AX=F216h/SF=06h

Format of NetWare "Get Volume Name" request buffer:
Offset	Size	Description	(Table 1507)
 00h	WORD	0002h (length of following data)
 02h	BYTE	06h (subfunction "Get Volume Name")
 03h	BYTE	volume number
SeeAlso: #1508,#1769 at AX=F216h/SF=06h

Format of NetWare "Get Volume Name" reply buffer:
Offset	Size	Description	(Table 1508)
 00h	WORD	(call) 0011h (length of following results buffer)
 02h	BYTE	length of volume name
 03h 16 BYTEs	NUL-padded volume name
SeeAlso: #1507,#1769 at AX=F216h/SF=06h
--------N-21E2--SF0A-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - CREATE DIRECTORY
	AH = E2h subfn 0Ah
	DS:SI -> request buffer (see #1509)
	ES:DI -> reply buffer (see #1510)
Return: AL = status (00h,84h,98h,FCh) (see #1492)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=39h,AH=E2h/SF=0Bh,AH=E2h/SF=0Fh,AX=F216h/SF=0Ah

Format of NetWare "Create Directory" request buffer:
Offset	Size	Description	(Table 1509)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	0Ah (subfunction "Create Directory")
 03h	BYTE	directory handle
 04h	BYTE	maximum directory rights (see #1502)
 05h	BYTE	length of directory path (00h-FFh)
 06h  N BYTEs	directory path
SeeAlso: #1510,#1511

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1510)
 00h	WORD	(call) 0000h (no data returned)
SeeAlso: #1509,#1511
--------N-21E2--SF0B-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - DELETE DIRECTORY
	AH = E2h subfn 0Bh
	DS:SI -> request buffer (see #1511)
	ES:DI -> reply buffer (see #1510)
Return: AL = status (00h,8Ah,98h,9Bh,9Ch,9Fh,A0h) (see #1492)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=3Ah,AH=E2h/SF=0Ah,AH=E2h/SF=0Fh,AX=F216h/SF=0Bh

Format of NetWare "Delete Directory" request buffer:
Offset	Size	Description	(Table 1511)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	0Bh (subfunction "Delete Directory")
 03h	BYTE	directory handle
 04h	BYTE	unused
 05h	BYTE	length of directory path (00h-FFh)
 06h  N BYTEs	directory path
SeeAlso: #1509,#1510
--------N-21E2--SF0C-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - SCAN DIRECTORY FOR TRUSTEES
	AH = E2h subfn 0Ch
	DS:SI -> request buffer (see #1512)
	ES:DI -> reply buffer (see #1513)
Return: AL = status (00h,9Ch) (see also #1492)
	    9Ch no more trustees
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E2h/SF=0Dh,AH=E2h/SF=0Eh,AH=E3h/SF=47h,AX=F216h/SF=0Ch

Format of NetWare "Scan Directory For Trustees" request buffer:
Offset	Size	Description	(Table 1512)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	0Ch (subfunction "Scan Directory For Trustees")
 03h	BYTE	directory handle
 04h	BYTE	sequence number
		00h on first call, increment for each subsequent call
 05h	BYTE	length of directory path (00h-FFh)
 06h  N BYTEs	directory path
SeeAlso: #1513,#1514,#1770 at AX=F216h/SF=0Ch

Format of NetWare "Scan Directory For Trustees" reply buffer:
Offset	Size	Description	(Table 1513)
 00h	WORD	(call) 0031h (length of following results buffer)
 02h 16 BYTEs	directory name
 12h  4 BYTEs	date and time of creation
 16h	DWORD	(big-endian) object ID of owner
 1Ah  5 DWORDs	(big-endian) object IDs of Trustees 0 through 4
		00000000h = end of group
 2Eh  5 BYTEs	directory rights for Trustees 0 through 4 (see #1502)
SeeAlso: #1512,#1516,#1770 at AX=F216h/SF=0Ch
--------N-21E2--SF0D-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - ADD TRUSTEE TO DIRECTORY
	AH = E2h subfn 0Dh
	DS:SI -> request buffer (see #1514)
	ES:DI -> reply buffer (see #1516)
Return: AL = status (00h,8Ch,FCh) (see #1492)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=0Ch,AH=E2h/SF=0Eh,AH=E3h/SF=47h,AX=F216h/SF=0Dh

Format of NetWare "Add Trustee To Directory" request buffer:
Offset	Size	Description	(Table 1514)
 00h	WORD	length of following data (max 107h)
 02h	BYTE	0Dh (subfunction "Add Trustee To Directory")
 03h	BYTE	directory handle
 04h	DWORD	(big-endian) object ID of trustee
 08h	BYTE	trustee directory rights (see #1502)
 09h	BYTE	length of directory path (00h-FFh)
 0Ah  N BYTEs	directory path
SeeAlso: #1516
--------N-21E2--SF0E-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - DELETE TRUSTEE FROM DIRECTORY
	AH = E2h subfn 0Eh
	DS:SI -> request buffer (see #1515)
	ES:DI -> reply buffer (see #1516)
Return: AL = status (00h,98h,9Bh,9Ch) (see #1492)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=0Ch,AH=E2h/SF=0Dh,AX=F216h/SF=0Eh

Format of NetWare "Delete Trustee From Directory" request buffer:
Offset	Size	Description	(Table 1515)
 00h	WORD	length of following data (max 107h)
 02h	BYTE	0Eh (subfunction "Delete Trustee From Directory")
 03h	BYTE	directory handle
 04h	DWORD	(big-endian) object ID of trustee
 08h	BYTE	unused
 09h	BYTE	length of directory path (00h-FFh)
 0Ah  N BYTEs	directory path
SeeAlso: #1516

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1516)
 00h	WORD	(call) 0000h (no data returned)
SeeAlso: #1515,#1517,#1518
--------N-21E2--SF0F-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - RENAME DIRECTORY
	AH = E2h subfn 0Fh
	DS:SI -> request buffer (see #1517)
	ES:DI -> reply buffer (see #1516)
Return: AL = status (00h,8Bh,9Bh,9Ch,9Eh) (see #1492)
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	directories SYS:LOGIN, SYS:MAIL, and SYS:PUBLIC must not be renamed
SeeAlso: AH=56h,AH=E2h/SF=0Ah,AH=E2h/SF=0Bh,AX=F216h/SF=0Fh

Format of NetWare "Rename Directory" request buffer:
Offset	Size	Description	(Table 1517)
 00h	WORD	length of following data (max 111h)
 02h	BYTE	0Fh (subfunction "Rename Directory")
 03h	BYTE	directory handle
 04h	BYTE	length of directory path (00h-FFh)
 05h  N BYTEs	directory path
	BYTE	length of new directory name (01h-0Eh)
      N BYTEs	new directory name
SeeAlso: #1516
--------N-21E2--SF10-------------------------
INT 21 - Novell NetWare - FILE SERVICES - PURGE ERASED FILES (OLD)
	AH = E2h subfn 10h
	DS:SI -> request buffer (see #1518)
	ES:DI -> reply buffer (see #1516)
Return: AL = status (00h,C6h) (see #1519)
Desc:	purges files marked for deletion on the file server by the calling
	  workstation
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=13h,AH=41h,AH=E2h/SF=11h,AH=E3h/SF=CEh,AX=F244h,AX=F216h/SF=10h

Format of NetWare "Purge Erased Files" request buffer:
Offset	Size	Description	(Table 1518)
 00h	WORD	0001h (length of following data)
 02h	BYTE	10h (subfunction "Purge Erased Files")
SeeAlso: #1516
--------N-21E2--SF11-------------------------
INT 21 - Novell NetWare - FILE SERVICES - RESTORE ERASED FILE (OLD)
	AH = E2h subfn 11h
	DS:SI -> request buffer (see #1520)
	ES:DI -> reply buffer (see #1521)
Return: AL = status (00h,98h,FFh) (see #1519)
Desc:	restores one file marked for deletion which has not yet been purged
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=13h,AH=41h,AH=E2h/SF=10h,AH=E3h/SF=CEh,AX=F244h

(Table 1519)
Values for NetWare function status:
 00h	successful
 98h	nonexistent volume
 9Ch	invalid path
 C6h	no console rights
 FFh	no more erased files
SeeAlso: #1492,#1552

Format of NetWare "Restore Erased File" request buffer:
Offset	Size	Description	(Table 1520)
 00h	WORD	length of following data (max 13h)
 02h	BYTE	11h (subfunction "Restore Erased File")
 03h	BYTE	directory handle or 00h
 04h	BYTE	length of volume name
 05h  N BYTEs	volume name (including colon)
Note:	if both a directory handle and a volume name are specified, the volume
	  name overrides the handle
SeeAlso: #1521,#1771

Format of NetWare "Restore Erased File" reply buffer:
Offset	Size	Description	(Table 1521)
 00h	WORD	(call) 001Eh (size of following results buffer)
 02h 15 BYTEs	ASCIZ name of erased file
 11h 15 BYTEs	ASCIZ name under which file was restored
SeeAlso: #1520,#1771
--------N-21E2--SF12-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - ALLOC PERMANENT DIRECTORY HANDLE
	AH = E2h subfn 12h
	DS:SI -> request buffer (see #1522)
	ES:DI -> reply buffer (see #1523)
Return: AL = status (00h,98h,9Ch) (see #1519)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=00h,AH=E2h/SF=13h,AH=E2h/SF=14h,AX=F216h/SF=12h

Format of NetWare "Allocate Permanent Directory Handle" request buffer:
Offset	Size	Description	(Table 1522)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	12h (subfunction "Allocate Permanent Directory Handle")
 03h	BYTE	directory handle
 04h	BYTE	drive ('A'-'Z')
 05h	BYTE	length of directory path
 06h  N BYTEs	directory path
SeeAlso: #1523,#1524,#1773

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1523)
 00h	WORD	(call) 0002h (size of following results buffer)
 02h	BYTE	new directory handle
 03h	BYTE	effective directory rights (see #1502)
SeeAlso: #1522,#1773
--------N-21E2--SF13-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - ALLOC TEMPORARY DIRECTORY HANDLE
	AH = E2h subfn 13h
	DS:SI -> request buffer (see #1524)
	ES:DI -> reply buffer (see #1523)
Return: AL = status (00h,98h,9Ch) (see #1519)
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	this call is the same as AH=E2h/SF=12h except that the directory handle
	  will be automatically deallocated when the calling application
	  executes an End of Job call (AH=D6h) or terminates
SeeAlso: AH=D6h,AH=E2h/SF=00h,AH=E2h/SF=12h,AH=E2h/SF=14h,AH=E2h/SF=16h
SeeAlso: AX=F216h/SF=13h

Format of NetWare "Allocate Temporary Directory Handle" request buffer:
Offset	Size	Description	(Table 1524)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	13h (subfunction "Allocate Temporary Directory Handle")
 03h	BYTE	directory handle
 04h	BYTE	drive ('A'-'Z')
 05h	BYTE	length of directory path
 06h  N BYTEs	directory path
SeeAlso: #1522,#1525
--------N-21E2--SF14-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - DEALLOCATE DIRECTORY HANDLE
	AH = E2h subfn 14h
	DS:SI -> request buffer (see #1525)
	ES:DI -> reply buffer (see #1526)
Return: AL = status (00h,9Bh) (see #1492)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=12h,AH=E2h/SF=13h,AX=F216h/SF=14h

Format of NetWare "Deallocate Directory Handle" request buffer:
Offset	Size	Description	(Table 1525)
 00h	WORD	0002h (length of following data)
 02h	BYTE	14h (subfunction "Deallocate Directory Handle")
 03h	BYTE	directory handle
SeeAlso: #1526

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1526)
 00h	WORD	(call) 0000h (no returned data)
SeeAlso: #1525
--------N-21E2--SF15-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET VOLUME INFO WITH HANDLE
	AH = E2h subfn 15h
	DS:SI -> request buffer (see #1527)
	ES:DI -> reply buffer (see #1528)
Return: AL = status
	    00h successful
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=DAh,AH=E2h/SF=02h,AH=E2h/SF=06h,AH=E2h/SF=19h,AH=E3h/SF=E9h
SeeAlso: AX=F216h/SF=15h

Format of NetWare "Get Volume Info with Handle" request buffer:
Offset	Size	Description	(Table 1527)
 00h	WORD	0002h (length of following data)
 02h	BYTE	15h (subfunction "Get Volume Info With Handle")
 03h	BYTE	directory handle
SeeAlso: #1528,#1774

Format of NetWare "Get Volume Info with Handle" reply buffer:
Offset	Size	Description	(Table 1528)
 00h	WORD	(call) 001Ch (length of following results buffer)
 02h	WORD	(big-endian) sectors per block
 04h	WORD	(big-endian) total blocks on volume
 06h	WORD	(big-endian) blocks available on volume
 08h	WORD	(big-endian) total directory slots
 0Ah	WORD	(big-endian) directory slots available
 0Ch 16 BYTEs	NUL-padded volume name
 1Ch	WORD	(big-endian) flag: volume removable if nonzero
SeeAlso: #1527,#1774
--------N-21E2--SF16-------------------------
INT 21 u - Novell NetWare - DIRECTORY SERVICES - ALLOC SPECIAL TEMP DIR HANDLE
	AH = E2h subfn 16h
	DS:SI -> request buffer (see #1529)
	ES:DI -> reply buffer (see #1526)
Return: AL = status
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX,
	  but is not described in _NetWare_System_Calls--DOS_
SeeAlso: AH=E2h/SF=13h,AH=E2h/SF=14h,AX=F216h/SF=16h

Format of NetWare "Alloc Special Temporary Directory Handle" request buffer:
Offset	Size	Description	(Table 1529)
 00h	WORD	length of following data
 02h	BYTE	16h (subfunction "Allocate Special Temporary Directory Handle")
 03h	BYTE	source directory handle
 04h	BYTE	drive name ('A'-'Z')
 05h	BYTE	path length
 06h  N BYTEs	directory path
SeeAlso: #1526
--------N-21E2--SF17-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - SAVE DIRECTORY HANDLE
	AH = E2h subfn 17h
	DS:SI -> request buffer (see #1530)
	ES:DI -> reply buffer (see #1531)
Return: AL = status
	    00h successful
	    else network error code
Note:	this function is supported by Advanced NetWare 2.0+ and Alloy NTNX
SeeAlso: AH=E2h/SF=12h,AH=E2h/SF=17h,AX=F216h/SF=17h

Format of NetWare "Save Directory Handle" request buffer:
Offset	Size	Description	(Table 1530)
 00h	WORD	0002h (length of following data)
 02h	BYTE	17h (subfunction "Save Directory Handle")
 03h	BYTE	directory handle
SeeAlso: #1531,#1532

Format of NetWare "Save Directory Handle" reply buffer:
Offset	Size	Description	(Table 1531)
 00h	WORD	(call) 0010h (length of following results buffer)
 02h 16 BYTEs	save buffer
SeeAlso: #1530,#1533
--------N-21E2--SF18-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - RESTORE DIRECTORY HANDLE
	AH = E2h subfn 18h
	DS:SI -> request buffer (see #1532)
	ES:DI -> reply buffer (see #1533)
Return: AL = status
	    00h successful
	    else network error code
Desc:	restore a previously saved directory handle to reproduce an executing
	  environment, possibly on a different execution site
Note:	this function is supported by Advanced NetWare 2.0+ and Alloy NTNX
SeeAlso: AH=E2h/SF=12h,AH=E2h/SF=17h,AX=F216h/SF=18h

Format of NetWare "Restore Directory Handle" request buffer:
Offset	Size	Description	(Table 1532)
 00h	WORD	0011h (length of following data)
 02h	BYTE	18h (subfunction "Restore Directory Handle")
 03h 16 BYTEs	save buffer
SeeAlso: #1530,#1533

Format of NetWare "Restore Directory Handle" reply buffer:
Offset	Size	Description	(Table 1533)
 00h	WORD	(call) 0002h (length of following results buffer)
 02h	BYTE	new directory handle
 03h	BYTE	effective rights (see #1502)
SeeAlso: #1532
--------N-21E2--SF19-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - SET DIRECTORY INFORMATION
	AH = E2h subfn 19h
	DS:SI -> request buffer (see #1534)
	ES:DI -> reply buffer (see #1535)
Return: AL = status (00h,9Bh,9Ch) (see #1492)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E2h/SF=02h,AH=E2h/SF=0Fh,AX=F216h/SF=19h

Format of NetWare "Set Directory Information" request buffer:
Offset	Size	Description	(Table 1534)
 00h	WORD	length of following data (max 10Bh)
 02h	BYTE	19h (subfunction "Set Directory Information")
 03h	BYTE	directory handle
 04h	DWORD	(big-endian) date and time of creation
 08h	DWORD	(big-endian) object ID of owner
 0Ch	BYTE	maximum directory rights (see #1502)
 0Dh	BYTE	length of directory path
 0Eh  N BYTEs	directory path
SeeAlso: #1535

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1535)
 00h	WORD	(call) 0000h (no results returned)
SeeAlso: #1534
--------N-21E2--SF1A-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET PATH FROM DIRECTORY ENTRY
	AH = E2h subfn 1Ah
	DS:SI -> request buffer (see #1536)
	ES:DI -> reply buffer (see #1537)
Return: AL = status
	    00h successful
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=01h,AH=E2h/SF=06h,AH=E3h/SF=D7h,AX=F216h/SF=1Ah

Format of NetWare "Get Path from Directory Entry" request buffer:
Offset	Size	Description	(Table 1536)
 00h	WORD	0004h (length of following data)
 02h	BYTE	1Ah (subfunction "Get Path From Directory Entry")
 03h	BYTE	volume number (00h-1Fh)
 04h	WORD	(big-endian) directory entry number
SeeAlso: #1537,#1777

Format of NetWare "Get Path from Directory Entry" reply buffer:
Offset	Size	Description	(Table 1537)
 00h	WORD	(call) size of following results record (max 200h)
 02h 256 BYTEs	path
SeeAlso: #1536,#1777
--------!---Section--------------------------
