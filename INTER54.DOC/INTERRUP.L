Interrupt List, part 12 of 16
Copyright (c) 1989,1990,1991,1992,1993,1994,1995,1996,1997 Ralf Brown
--------F-2FC0-------------------------------
INT 2F - MTEZ XpressFax Hardware TSR (CLASS2) - API
	AH = C0h
	AL = function code (01h to 15h)
Return: ???
SeeAlso: AX=C000h/BX=444Bh,AX=CB00h/BX=4D53h
--------N-2FC000-----------------------------
INT 2F - Novell ODI Link Support Layer (LSL.COM) - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	    DX:BX -> FAR entry point (see #2631,#2632,#2633)
	    ES:SI -> signature string "LINKSUP$"
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
Note:	on return, ES = DX for LSL v1.10 and v2.05; LSL makes use of this in
	  its search for a previous installation
SeeAlso: AX=5100h,AX=C000h"NESL"

(Table 2631)
Call LSL function "Request MLID Registration" with:
	BX = 0001h
	ES:SI -> registration??? record (see #2635)
	DS:DI -> buffer for LSL information block (see #2636)
Return: AX = completion code (0000h,8001h) (see #2634)
	DS:DI buffer filled if successful
	BX,CX corrupted
Note:	see "Novell LAN Driver Developer's Guide, Volume III" for more details

(Table 2632)
Call LSL function "get support entry points" with:
	BX = 0002h
	ES:SI -> buffer for entry point record (see #2637)
Return: ES:SI buffer filled

(Table 2633)
Call LSL function "Request MLID API entry point" with:
	BX = 0003h
Return: ES:SI -> MLID (Multiple Link Interface Driver) API entry point
		(call with BX=function 00h-10h, not range-checked)
Note:	LSL v1.10 and v2.05 execute BX=0003h for BX=0000h and any BX >= 0003h

(Table 2634)
Values for LSL completion code:
 0000h	successful
 8001h	out of resources
 8002h	bad parameter
 8003h	no more items
 8004h	item not present
 8005h	failed
 8006h	receive overflow
 8007h	canceled
 8008h	bad command
 8009h	duplicate entry
 800Ah	no such handler
 800Bh	no such driver

Format of LSL registration record:
Offset	Size	Description	(Table 2635)
 00h	DWORD	-> ??? FAR function (to be called with ES:SI -> ??? and
		  returning AX = completion code)
 04h	DWORD	-> ???
 08h	DWORD	-> ??? data (at least 3Eh bytes)

Format of LSL information block:
Offset	Size	Description	(Table 2636)
 00h	DWORD	-> ??? entry point (called with BX=function 00h-11h)
 04h	WORD	???
 06h	WORD	???
Note:	due to a fencepost error, LSL v2.05 (distributed with Novell DOS 7)
	  will crash if the above entry point is called with BX=0012h

Format of entry point record:
Offset	Size	Description	(Table 2637)
 00h	DWORD	pointer to protocol support entry point in LSL (see #2638)
 04h	DWORD	pointer to general support entry point in LSL (see #2639)

(Table 2638)
Call protocol support entry point with:
	BX = function number
	    0000h ???
	    0001h ???
	    0002h ???
	    0003h "ScheduleAESEvent"
		ES:SI -> AES ECB to be scheduled (see #2642)
		Return: ES,SI preserved
	    0004h "CancelAESEvent"
		ES:SI -> ECB to be cancelled (see #2642)
		Return: ES,SI preserved
	    0005h "GetIntervalMarker"
		Return: DX:AX = current interval marker in milliseconds
			all other registers preserved
	    0006h "RegisterStack"
		AX = logical board number
		ES:SI -> bound stack info structure (see #2652)
		Return: BX = assigned Stack ID if AX=0000h
	    0007h "DeRegisterStack"
		AX = protocol stack's assigned Stack ID
	    0008h "RegisterDefaultStack"
		AX = logical board number
		ES:SI -> stack info structure (see #2653)
	    0009h "DeRegisterDefaultStack"
		AX = logical board number
	    000Ah "RegisterPrescanStack"
		AX = logical board number
		ES:SI -> stack info structure (see #2653)
	    000Bh "DeRegisterPrescanStack"
		AX = logical board number
	    000Ch "SendPacket"
		ES:SI -> send ECB
		Return: interrupts disabled
	    000Dh ???
	    000Eh ???
	    000Fh ???
	    0010h "GetStackIDFromName"
		ES:SI -> counted NUL-terminated protocol name (max 15 chars)
		Return: BX = Stack ID if AX=0000h
	    0011h "GetPIDFromStackIDBoard"
		AX = Stack ID for protocol
		CX = logical board number
		ES:SI -> 6-byte buffer for protocol ID
	    0012h "GetMLIDControlEntry"
		AX = logical board number
		Return: ES:SI -> MLID control handler (see #2640) if AX=0000h
	    0013h "GetProtocolControlEntry"
		AX = Stack ID or
			FFFEh Prescan stack
			    CX = logical board number
			FFFFh default protocol
			    CX = logical board number
		Return: ES:SI -> protocol stack control entry point if AX=0000h
				  (see #2641)
	    0014h "GetLSLStatistics"
		Return: AX = 0000h (successful)
			ZF set
			ES:SI -> LSL statistics table (see #2644)
	    0015h "BindStack"
		AX = protocol stack's assigned Stack ID
		CX = logical board number
	    0016h "UnbindStack"
		AX = protocol stack's assigned Stack ID
		CX = logical board number
	    0017h "AddProtocolID"
		AX = frame type ID code
		ES:SI -> 6-byte protocol ID
		CX:DI -> counted NUL-terminated short protocol name (max 15 ch)
	    0018h "RelinquishControl"
		Return: after LSL performs any necessary background processing
	    0019h "GetLSLConfiguration"
		Return: AX = 0000h (successful)
			ZF set
			ES:SI -> LSL configuration table (see #2643)
	    001Ah "GetTickMarker"
		Return: AX = number of 55ms ticks since LSL loaded
			BX destroyed
Return: AX = completion code (see #2634)
	ZF set if successful
	SS:SP, DS, BP preserved; most other registers may be destroyed

(Table 2639)
Call general support entry point with:
	BX = function number
	    0000h "Allocate Memory" (obsolete)
		 always returns AX=8008h (BAD_COMMAND)
	    0001h "Free Memory" (obsolete)
		 always returns AX=8008h (BAD_COMMAND)
	    0002h "Realloc Memory" (obsolete)
		 always returns AX=8008h (BAD_COMMAND)
	    0003h "Memory Statistics" (obsolete)
		 always returns AX=8008h (BAD_COMMAND)
	    0004h "Add Memory To Pool" (obsolete)
		 always returns AX=8008h (BAD_COMMAND)
	    0005h "AddGeneralService"
		ES:SI -> General Service Control Block (see #2654)
	    0006h "RemoveGeneralService"
		ES:SI -> General Service Control Block (see #2654)
	    0007h "GetNETcfgPath"
		Return: AX = 0000h (successful)
			DS:DX -> ASCIZ pathname for NET.CFG
	    0008h U ???	 (in LSL 1.10)
		Return: AX = 0000h
			ES:SI -> ??? (a 22-byte data area)
	    000Ah "GetCriticalSectionStatus"
		Return: BX = total outstanding calls to "StartCriticalSection"
	    000Bh "ServiceEvents"
		interrupts disabled
		Return: interrupts disabled
	    0010h "GetStackECB"
		DS:DI -> Lookahead structure (see #2655)
		interrupts disabled
		Return: ES:SI -> ECB if successful (AX=0000h,ZF set)
			interrupts disabled
	    8000h-FFFFh reserved for user general service providers
Return: AX = completion code (see #2634)
	ZF set if successful
	SS:SP, DS, BP preserved

(Table 2640)
Call MLID control handler with:
	AX = logical board number
	BX = function number
	    0000h "GetMLIDConfiguration"
		Return: ES:SI -> MLID's configuration table if successful
				  (see #2647 for format)
	    0001h "GetMLIDStatistics"
		Return: ES:SI -> MLID's statistics table if successful
				  (see #2647 for format)
	    0002h "AddMulticastAddress"
		ES:SI -> 6-byte multicast address to add
	    0003h "DeleteMulticastAddress"
		ES:SI -> 6-byte multicast address to delete
	    0005h "MLIDShutdown"
		CX = type
		    0000h permanent (also deregisters from LSL)
		    other temporary (shutdown hardware only)
	    0006h "MLIDReset" reinitialize board / restart from temp shutdown
	    0007h "Create Connection" (obsolete?)
		???
	    0008h "Delete Connection" (obsolete?)
		???
	    0009h "SetLookAheadSize"
		CX = requested lookahead size (00h-80h)
	    000Ah "PromiscuousChange"
		CX = what to receive promiscuously
		    bit 0: MAC frames
		    bit 1: non-MAC frames
	    000Bh "RegisterReceiveMonitor"
		CX = subfunction
		    0000h disable receive monitoring
		    else  enable receive monitoring
		ES:SI -> monitor receive routine
		ES:DI -> monitor transmit routine
	    000Ch "Driver Poll" (obsolete?)
		???
Return: AX = completion code (see #2634)
	ZF set if successful
Note:	not all boards/MLIDs support function 0010h; see bit 13 in the MLID
	  mode flags field of the MLID's configuration table

(Table 2641)
Call protocol stack control entry point with:
	BX = function number
	    0000h "GetProtocolStackConfiguration"
		Return: ES:SI -> protocol stack's configuration table
				   (see #2646)
	    0001h "GetProtocolStackStatistics"
		Return: ES:SI -> protocol stack's statistics table (see #2645)
	    0002h "BindToMLID"
		CX = board number to bind to
		ES:SI -> implementation-dependant parameter string
	    0003h "UnBindFromMLID"
		CX = board number from which protocol should unbind
		ES:SI -> optional implementation-dependant parameter string
	    0004h "MLIDDeRegistered"
		CX = board number that has de-registered from LSL
Return: AX = status
	    0000h successful
	    else implementation-dependant error codes
	ZF set if successful
	SS:SP, DS, BP preserved

Format of AES ECB:
Offset	Size	Description	(Table 2642)
 00h	DWORD	"AESLink" pointer used by LSL for list management
 04h	DWORD	number of milliseconds to wait
 08h	DWORD	"AESStatus" (is set to 00000000h when AES ESR is invoked)
 0Ch	DWORD	-> function to be invoked when time expires
		ES:SI will point to this structure on entry,
		DS, BP, and SS:SP must be preserved.
SeeAlso: #2656

Format of LSL Configuration Table:
Offset	Size	Description	(Table 2643)
 00h	BYTE	major version of configuration table
 01h	BYTE	minor version of configuration table (decimal, 0-99)
 02h  8 BYTEs	reserved
 0Ah	BYTE	LSL major version (decimal)
 0Bh	BYTE	LSL minor version (decimal, 0-99)
---LSL 1.0x ---
 0Ch 14 BYTEs	reserved
---LSL 1.10+ ---
 0Ch	WORD	maximum number of boards which LSL can handle
 0Eh	WORD	maximum number of protocol IDs which LSL can handle
 10h 12 BYTEs	reserved

Format of LSL Statistics Table:
Offset	Size	Description	(Table 2644)
 00h	BYTE	major version of statistics table format
 01h	BYTE	minor version of statistics table format (decimal, 0-99)
 02h	WORD	"GenericCounters" number of counters in static portion of
		  table
 04h	DWORD	"ValidCountersMask" bit mask indicating which generic
		  counters are actually used.  Bit 31 = TotalTxPackets, bit 30
		  is the next field, etc.
 08h	DWORD	"TotalTxPackets" total SendPacket requests made
 0Ch	DWORD	reserved
 10h	DWORD	reserved
 14h	DWORD	"AESEventsCount" number of completed AES events
 18h	DWORD	"PostponedEvents" number of events postponed due to critical
		  sections inside the MLIDs
 1Ch	DWORD	"CancelAESFailures" number of times CancelAESEvent failed
 20h	DWORD	reserved
 24h	DWORD	reserved
 28h	DWORD	"TotalRxPackets" total number of GetStackECB requests
 2Ch	DWORD	"UnclaimedPackets" total number of packets not consumed by a
		  protocol stack
 30h	WORD	"NumberCustom" number of custom variables that follow
 32h  N DWORDs	custom counters
      N DWORDs	-> CustomCounterStrN (one per custom counter)
	var	length-prepended and NULL terminated string for Counter 0
	...
	var	length-prepended and NULL terminated string for Counter N-1
SeeAlso: #2645,#2651

Format of Protocol Stack Statistics Table:
Offset	Size	Description	(Table 2645)
 00h	BYTE	statistics table major version
 01h	BYTE	statistics table minor version (decimal, 0-99)
 02h	WORD	number of generic counters following
 04h	DWORD	"ValidCountersMask" (bitmask, bit 31 is TotalTxPackets)
 08h	DWORD	TotalTxPackets
 0Ch	DWORD	TotalRxPackets
 10h	DWORD	IgnoredRxPackets
 14h	WORD	number of custom counters
 16h  N DWORDs	custom counters
      N DWORDs	-> CustomCounterStrN (one per custom counter)
	var	length-prepended and NULL terminated string for Counter 0
	...
	var	length-prepended and NULL terminated string for Counter N-1
SeeAlso: #2644,#2651

Format of Protocol Stack Configuration Table:
Offset	Size	Description	(Table 2646)
 00h	BYTE	configuration table major version
 01h	BYTE	configuration table minor version (decimal, 0-99)
 02h	DWORD	-> counted NUL-terminated long descriptive name for protocol
 06h	DWORD	-> counted NUL-terminated short name for protocol (15 chars)
 0Ah	BYTE	protocol stack major version
 0Bh	BYTE	protocol stack minor version (decimal, 0-99)
 0Ch 16 BYTEs	reserved for future use

Format of MLID Configuration Table:
Offset	Size	Description	(Table 2647)
 00h 26 BYTEs	signature 'HardwareDriverMLID	     ' (8 spaces on end)
 1Ah	BYTE	configuration table major version
 1Bh	BYTE	configuration table minor version (decimal, 0-99)
 1Ch  6 BYTEs	node address
 22h	WORD	MLID mode flags (see #2648)
 24h	WORD	board number
 26h	WORD	board instance (if more than one of same board installed)
 28h	WORD	maximum packet size
 2Ah	WORD	BestDataSize
 2Ch	WORD	WorstDataSize
 2Eh	DWORD	-> counted NUL-terminated long name for NIC
 32h	DWORD	-> counted NUL-terminated short name for NIC (8 chars max)
 36h	DWORD	-> counted NUL-terminated Frame and Media type
 3Ah	WORD	reserved (0000h)
 3Ch	WORD	frame type ID
 3Eh	WORD	TransportTime (milliseconds)
 40h	DWORD	-> SourceRouteHandler for TokenRing. (Used by ROUTE.COM)
 44h	WORD	lookahead size
 46h	WORD	line speed (Mbps if high bit clear, else Kbps)
 48h	WORD	QueueDepth
 4Ah  6 BYTEs	reserved (0)
 50h	BYTE	driver major version
 51h	BYTE	driver minor version (decimal, 0-99)
 52h	WORD	bus/multicast flags (see #2649)
 54h	WORD	send retries
 56h	DWORD	ConfigTableLink
 5Ah	WORD	MLID sharing flags (see #2650)
 5Ch	WORD	slot number
 5Eh	WORD	I/O address 1
 60h	WORD	I/O range 1
 62h	WORD	I/O address 2
 64h	WORD	I/O range 2
 66h	DWORD	memory address 1
 6Ah	WORD	memory size 1
 6Ch	DWORD	memory address 2
 70h	WORD	memory size 2
 72h	BYTE	interrupt line 1
 73h	BYTE	interrupt line 2
 74h	BYTE	DMA line 1
 75h	BYTE	DMA line 2

Bitfields for MLID mode flags:
Bit(s)	Description	(Table 2648)
 15	MLID supports Octet Reversal
 14	node address is non-canonical
 13	promiscuous mode is supported
 12-8	reserved
 7	LDataSize field in LookAhead structure supported
 6	raw send supported
 5	MLID needs to be polled by LSL
 4	reserved (0)
 3	multicasting is supported
 2	not currently used by DOS ODI, set to 0.
 1	network card uses DMA.
 0	RealDriverBit, always set to 1.

Bitfields for bus/multicast flags:
Bit(s)	Description	(Table 2649)
 10-9	specialized multicast support
	00 = Group addressing is default for medium
	01 = Invalid
	10 = Filter group address in MLID.
	11 = Adapter filters group address.
 2	supports Micro Channel cards
 1	supports ISA cards
 0	supports EISA cards

Bitfields for MLID sharing flags:
Bit(s)	Description	(Table 2650)
 8	NIC can share DMA2
 7	NIC can share DMA1
 6	NIC can share IRQ2
 5	NIC can share IRQ1
 4	NIC can share Memory2
 3	NIC can share Memory1
 2	NIC can share IO2
 1	NIC can share IO1
 0	MLID is currently shut down

Format of MLID Statistics Table:
Offset	Size	Description	(Table 2651)
 00h	BYTE	driver statistics table major version
 01h	BYTE	driver statistics table minor version (decimal, 0-99)
 02h	WORD	number of generic counters (typically 13)
 04h	DWORD	"ValidCountersMask" (bit mask, bit 31 is TotalTxCount)
 08h	DWORD	TotalTxCount
 0Ch	DWORD	TotalRxCount
 10h	DWORD	NoECBAvailableCount
 14h	DWORD	TxTooBigCount
 18h	DWORD	TxTooSmallCount
 1Ch	DWORD	RxOverflowCount
 20h	DWORD	RxTooBigCount
 24h	DWORD	RxTooSmallCount
 28h	DWORD	TxMiscCount
 2Ch	DWORD	RxMiscCount
 30h	DWORD	TxRetryCount
 34h	DWORD	RxChecksumErrorCount
 38h	DWORD	RxMismatchCount
 3Ch	WORD	number of custom counters
 3Eh  N DWORDs	custom counters
      N DWORDs	-> CustomCounterStrN (one per custom counter)
	var	length-prepended and NULL terminated string for Counter 0
	...
	var	length-prepended and NULL terminated string for Counter N-1
SeeAlso: #2644,#2645

Format of bound stack info structure:
Offset	Size	Description	(Table 2652)
 00h	DWORD	-> protocol stack's short name (counted, NUL-terminated)
 04h	DWORD	-> receive handler
 08h	DWORD	-> control handler

Format of stack info structure:
Offset	Size	Description	(Table 2653)
 00h	DWORD	-> receive handler
 04h	DWORD	-> control handler

Format of General Service Control Block:
Offset	Size	Description	(Table 2654)
 00h	DWORD	-> next GSCB (maintained internally by LSL)
 04h	DWORD	-> entry point for general service handler
 08h	WORD	command code for this general service (8000h-FFFFh)
Note:	the control block must not be altered or deallocated until the general
	  service is removed

Format of Lookahead structure:
Offset	Size	Description	(Table 2655)
 00h	DWORD	-> Media header
 04h	DWORD	-> lookahead buffer
 08h	WORD	length of lookahead buffer
 0Ah  6 BYTEs	protocol ID
 10h	WORD	logical board number
 12h	WORD	lookahead size

Format of ODI ECB:
Offset	Size	Description	(Table 2656)
 00h	DWORD	link to next ECB
 04h	DWORD	link to previous ECB
 08h	WORD	general status
		0000h received successfully
		8006h packet overflow
		8007h reception aborted (data not valid)
 0Ah	DWORD	-> event service routine or RETF (never 0000h:0000h)(see #2657)
 0Eh	WORD	protocol stack identifier
 10h  6 BYTEs	protocol ID (sending only)
 16h	WORD	MLID board number (sending only)
 18h  6 BYTEs	MAC destination address
 1Eh  4 BYTEs	driver workspace
 22h  8 BYTEs	protocol workspace
 2Ah	WORD	total length of sent buffer
 2Ch	WORD	fragment count
 2Eh  2 WORDs	segment,offset of first fragment buffer
 32h	WORD	length of first fragment buffer
	...
SeeAlso: #2642

(Table 2657)
Values event service routine is called with:
	ES:SI -> associated ODI ECB (see #2656)
	interrupts disabled
Return: DS,BP,SS,SP preserved
	interrupt disabled
Notes:	the service routine may invoke any IPX/ODI function except CloseSocket
	it is safe to send a packet and wait for completion if enough stack
	  space is available
--------N-2FC000-----------------------------
INT 2F - Novell NetWare Event Service Layer (NESL) 1.0 - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	    DX:BX -> FAR entry point (see #2658,#2659,#2660,#2661,#2662,#2663)
	    ES:SI -> signature string "NESL_EVENTS"
Program: NESL is a generic interface for event handling in ODI drivers and
	  other NetWare-oriented modules.  Primarily intended to support
	  power management and "hot swapping" of PCMCIA cards, but it is not
	  limited to this.
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"Link Support Layer",AX=C000h"NETWARN"

(Table 2658)
Call NESL function GetNESLConfigPointer with:
	BX = 0000h
Return: AX = completion code (0000h,8008h) (see #2664)
	ES:SI -> NESL configuration table if successful (see #2665)
	BP,DS,STACK preserved
Desc:	Obtain a pointer to the NESL Configuration Table
SeeAlso: #2659,#2662

(Table 2659)
Call NESL function RegisterEventProducer with:
	BX = 0001h
	ES:SI -> Producer Event Control Block (PECB) (see #2666)
Return: AX = completion code (0000h, 8005h, 8008h) (see #2664)
	ES:SI -> still points to PECB
	BP,DS,STACK preserved
Desc:	Allows a module to register as a producer of a given event class
Note:	PECB_ClassName and PECB_Flags must be filled in on entry
SeeAlso: #2517,#2660,#2661,#2662

(Table 2660)
Call NESL function DeRegisterEventProducer with:
	BX = 0002h
	ES:SI -> PECB previously passed to RegisterEventProducer (see #2666)
Return: AX = completion code (0000h, 8002h, 8008h) (see #2664)
	ES:SI -> still points to PECB
	BP,DS,STACK preserved
Desc:	Allows a module to de-register as a producer of a given event class
SeeAlso: #2659,#2663

(Table 2661)
Call NESL function EventNotification with:
	BX = 0003h
	ES:SI -> PECB previously registered (see #2666)
Return: AX = completion code (0h, 8005h, 8008h) (see #2664)
	ES:SI -> still points to PECB
	BP,DS,STACK preserved
Desc:	Allows a module to signal that an event has just occurred in a given
	  event class.
Notes:	Once called, NESL will generate corresponding callouts for this
	  event, as described in Table #2668.
	on entry, the PECB_DataPtr must point at an Event Parameter Block (EPB)
	  (see #2669) filled in to match the desired event
SeeAlso: #2659

(Table 2662)
Call NESL function RegisterEventConsumer with:
	BX = 0004h
	ES:SI -> Consumer Event Control Block (CECB) (see #2667)
Return: AX = completion code (0h, 8005h, 8008h) (see #2664)
	ES:SI -> still points to CECB
	BP,DS,STACK preserved
Desc:	Allows a module to register as a consumer of a given event class
Note:	on entry, the CECB_ClassName, CECB_NotifProc and CECB_OSILevel must be
	  filled in.
SeeAlso: #2659,#2663

(Table 2663)
Call NESL function DeRegisterEventConsumer with:
	BX = 0005h
	ES:SI -> CECB previously passed to RegisterEventConsumer (see #2667)
Return: AX = completion code (0h, 8002h, 8008h) (see #2664)
	ES:SI -> still points to CECB
	BP,DS,STACK preserved
Desc:	Allows a module to de-register as a consumer of a given event class
SeeAlso: #2660,#2662

(Table 2664)
Values for NESL Error code:
 0000h	Successful
 8002h	Bad Parameter
 8005h	Fail
 8008h	Bad Command

Format of NESL Configuration Table:
Offset	Size	Description	(Table 2665)
 00h	WORD	NESL_Cfg_MajVer	 Major Version of this table (=1)
 02h	WORD	NESL_Cfg_MinVer	 Minor Version of this table (=0)
 04h	DWORD	NESL_Cfg_ModLName   -> ASCIZ long name of NESL module
		(typically -> "NetWare Event Service Layer for 16-Bit DOS")
 08h	DWORD	NESL_Cfg_ModSName   -> ASCIZ short name of NESL module
		(typically -> "NESL")
 0Ch	WORD	NESL_Cfg_ModMajVer  Major Version of NESL itself (=1)
 0Eh	WORD	NESL_Cfg_ModMinVer  Minor Version of NESL itself (=0)

Format of NESL Producer Event Control Block (PECB):
Offset	Size	Description	(Table 2666)
 00h	WORD	PECB_MajVer  Major Version of this structure (=1)
 02h	WORD	PECB_MinVer  Minor Version of this structure (=0)
 04h	DWORD	PECB_NextProducer   -> next PECB.  NULL if last.
 08h	DWORD	PECB_ClassName	    -> ASCIZ string identifying event
					  class (see #2670)
 0Ch	DWORD	PECB_ConsumerList   -> list of consumers for this event class
 10h	DWORD	PECB_DataPtr	    -> points to additional data during events
 14h	DWORD	PECB_Flags
		Bit 0	=0  consumers should be called "top down" for this
			    event class.  (OSI level 7 down to OSI level 1)
			=1  consumers should be called "bottom up"
		Bits 1-31   Reserved =0
 18h  8 BYTEs	PECB_Reserved (all zeros)
Note:	Although the event producer provides the memory for the PECB, the
	  NESL module controls this memory until the event class is
	  de-registered.
	While owned by NESL, this structure should be treated as read-only,
	  except for the PECB_DataPtr field.

Format of NESL Consumer Event Control Block (CECB):
Offset	Size	Description	(Table 2667)
 00h	WORD	CECB_MajVer  Major Version of this structure (=1)
 02h	WORD	CECB_MinVer  Minor Version of this structure (=0)
 04h	DWORD	CECB_NextConsumer   -> next CECB.  NULL if last.
 08h	DWORD	CECB_ClassName	    -> ASCIZ string identifying event
					  class (see #2670)
 0Ch	DWORD	CECB_NotifProc	    -> FAR CALL event handler (see #2668)
 10h	WORD	CECB_OSILevel
		Bits 4-7 = OSI Layer of this module (1 through 7)
		Bits 0-3 = relative ordering with other modules on same layer
 13h 14 BYTEs	CECB_Reserved (all zeros)
Note:	Although the event consumer provides the memory for the CECB, the
	  NESL module controls this memory until the consumer is de-registered.
	While owned by NESL, this structure should be treated as read-only,

(Table 2668)
Values NESL Consumer Notification Procedure is called with:
	ES:SI -> Event Parameter Block (EPB) (see #2669)
Return: AX = completion code (0000h, 8005h) (see #2664)
	ES:SI -> still points to EPB
Desc:	Called by NESL to notify the consumer when an event has occurred in
	  an event class for which it has registered.
SeeAlso: #2667

Format of NESL Event Parameter Block (EPB):
Offset	Size	Description	(Table 2669)
 00h	WORD	EPB_MajVer  Major Version of this structure (=1)
 02h	WORD	EPB_MinVer  Minor Version of this structure (=0)
 04h	DWORD	EPB_ClassName  -> ASCIZ string identifying event class
				  (see #2670)
 08h	DWORD	EPB_EventName  -> ASCIZ string identifying event within
				  class (see #2671)
 0Ch	DWORD	EPB_ModuleName -> ASCIZ string identifying module
				  producing event
 10h	DWORD	EPB_DataPtr0   -> event-defined data or NULL if not used
 14h	DWORD	EPB_DataPtr1   -> event-defined data or NULL if not used
 18h  8 BYTEs	EPB_Reserved (all zeros)

(Table 2670)
Values for NESL Event Class Names:
 Event Class		Description
 -------------------	-----------------------------------------
 Service Suspend	Suspension of a service.  Called top-down.
 Service Resume		Resumption/availability of a service. Called bottom-up.
 Service/Status Change	Change in status or level of service.  Called top-down.
 Suspend Request	Request to suspend a service.  Called bottom-up.
Note:	Contact Novell Labs to register new event classes.

(Table 2671)
Values for NESL Event Names:
 Event Name			Class		    Description
 --------------------------	-------------	    ---------------------------
 MLID Cable Disconnect		Service Suspend	    Cable disconnected from NIC
 MLID Card Removal		Service Suspend	    PCMCIA card removed
 MLID Hardware Failure		Service Suspend	    Serious hardware
							  failure in NIC
 MLID Not In Range		Service Suspend	    Wireless access point
							  is out of range
 MLID Shutdown			Service Suspend	    MLID was shut down
 MLID Media Access Denied	Service Suspend	    Access to physical
							  medium unsuccessful
 MLID Cable Reconnect		Service Resume	    Cable re-connected to NIC
 MLID Card Insertion Complete	Service Resume	    PCMCIA card inserted
 MLID In Range			Service Resume	    Wireless access point
							  in range
 MLID Reset			Service Resume	    MLID was just reset
 MLID Access Point Change	Serv/Status Change  Station has moved to
							  new access point
 MLID Speed Change		Serv/Status Change  Change in communic. speed
Note:	Contact Novell Labs to register new event names.
	For all predefined events above, EPB_DataPtr0 (see #2669) points
	  to the MLID Configuration table (see AX=C000h"ODI") for the
	  affected MLID.
--------N-2FC000-----------------------------
INT 2F - Novell NetWare Connect NETWARN - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	    SI = segment of resident portion
Program: NETWARN is a utility supplied with NetWare Connect to warn a
	  remote dialup user when programs are about to be loaded slowly over
	  the modem link.
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
Note:	on return, verify that it is NETWARN responding by examining signature
	  at in NETWARN's data table in the resident segment (see #2672)
SeeAlso: AX=C000h"ODI",AX=C000h"NESL"

Format of NETWARN Configuration structure:
Offset	Size	Description	(Table 2672)
 103h 7 BYTEs	signature string "NETWARN"
 10Ah	BYTE	major version in ASCII (="1")
 10Bh	BYTE	minor version in ASCII (="0")
 10Ch	DWORD	minimum size of EXE cared about in bytes (/S=xxxx)
 110h	WORD	same value in kilobytes (see #2673 [bit 4])
 112h	BYTE	multiplex code (AH value) actually being used
 113h	WORD	options (see #2673)
 115h	DWORD	INT 21h vector before NETWARN loaded
 119h	DWORD	INT 2Fh vector before NETWARN loaded
 11Dh 16 BYTEs	ASCIIZ local name of last device which was checked
 12Dh 128 BYTEs ASCIIZ remote name of last device which was checked
Note:	the specified offsets are from the start of the resident segment

Bitfields for NETWARN options:
Bit(s)	Description	(Table 2673)
 0	??? (=0)
 1	/U (Unload) selected (never in resident)
 2	/E (Enabled) Will trap & check EXEC's
 3	/D (Disabled) No EXEC checking done
 4	/S (Size) was set (see #2672 [offsets 010Ch and 0110h])
 5	/P (Path shown)
 6	/H or /? (Help) (never in resident)
SeeAlso: #2672
--------f-2FC000-----------------------------
INT 2F - FN32 32 character filename utilities - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	   ES:DI -> signature string "FN32 32CHAR TSR"
Program: FN32 is a TSR which supports 32 character filenames under PC/MS-DOS
Note:	the TSR intercepts INT 21 calls and performs filename substitution by
	  managing dictionary files in each directory which contains long
	  filenames
--------M-2FC000-----------------------------
INT 2F - QMR - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	    ES:DI -> signature string "QMR1!"
Program: QMR (Cove Software, Quick Mouse Reset) monitors the mouse
	  service interrupt (int 33h) and substitutes a fast software
	  reset (mouse fn 21h) for the slow hardware reset (mouse fn 0).
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C001h"QMR",AX=C002h"QMR",AX=C003h"QMR"
--------V-2FC000-----------------------------
INT 2F - VGAsave v1.93 - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	    BX = segment of resident code
Program: VGAsave is a freeware VGA-specific, mouse-aware screenblanker by Bill
	  Javurek
Range:	AH=C0h to AH=FFh, selected by scanning for a free multiplex number
Note:	the transient portion of VGAsave compares the first 38 bytes of the
	  resident code (addressed through BX) against its own copy of the
	  resident code to complete the installation check
SeeAlso: INT 14/AX=AA01h,INT 2F/AH=93h
Index:	screen saver;VGAsave
--------V-2FC000-----------------------------
INT 2F - AD-DOS - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	    BX = 4144h ('AD')
	    CX = 2D44h ('-D')
	    DX = 4F53h ('OS')
Program: AD-DOS is the DOS version of the After Dark screen blanker for
	  MS Windows
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C001h"AD-DOS",AX=C003h"AD-DOS",AX=C005h"AD-DOS",AX=C007h"AD-DOS"
SeeAlso: AX=C009h"AD-DOS",AX=C020h"AD-DOS",INT 14/AX=AA01h
Index:	screen saver;AD-DOS
--------U-2FC000-----------------------------
INT 2F U - WANG_ER.COM - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	    ES = segment of resident code
Program: WANG_ER is a TSR from Compaq which permits Compaq systems equipped
	  with 3-mode floppy drives to read Wang document diskettes
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
Note:	The installation check is completed by comparing the resident code
	  with the copy in the transient program
--------i-2FC000-----------------------------
INT 2F O - ASPIHOOK.SYS - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if multiplex number in use
	    ES:DI -> ASCIZ signature "ASPIHOOK" if ASPIHOOK.SYS installed
Program: ASPIHOOK is a device driver for monitoring SCSI activity through an
	  ASPI host manager; it is part of the Personal Measure system
	  activity monitor from Spirit of Performance, Inc.
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"PMEASURE"
--------i-2FC000-----------------------------
INT 2F - PMEASURE.EXE - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if multiplex number in use
	    ES:DI -> ASCIZ signature "PMEASURE.EXE" if PMEASURE.EXE installed
Program: PMEASURE.EXE is a TSR for monitoring system hardware activity which
	  is part of the Personal Measure system activity monitor from Spirit
	  of Performance, Inc.
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
Note:	If a Personal Measure Hook Module, such as ASPIHOOK.SYS, is already
	  installed, PMEASURE.EXE uses the next highest free multiplex number.
SeeAlso: AX=C000h"ASPIHOOK",AX=C000h"PERSONAL MEASURE"
--------i-2FC000-----------------------------
INT 2F - PERSONAL MEASURE - HOOK MODULE INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	ES:DI -> signature string "PMEASUREHOOK"
	AX = C000 if not installed, per mux id conventions
	DH = major release number (binary)
	DL = minor release number (binary)
Program: The Personal Measure system activity monitor from Spirit of
	  Performance, Inc. uses an extensible series of modules to hook
	  into various operating system interfaces and monitor system calls.
	  Current hook modules are ASPIHOOK.SYS for ASPI device activity
	  and CDRHOOK.SYS for non-ASPI CD-ROM activity.	 All hook modules
	  share the same mux id.
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"PMEASURE.EXE",AX=C001h"PERSONAL MEASURE"
--------c-2FC000-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	    SI = signature value 20D6h
	    DI = signature value 8761h
	    ES:BX -> configuration table (see #2674)
	    CX = ??? (0300h)
	    DX = ??? (0020h)
Program: PCACHE is the resident print spooler portion of PrintCache by
	  LaserTools; it may use either memory or disk space to spool output
Range:	AH=C0h to AH=FFh, selected by commandline switch
SeeAlso: AX=0100h/SI=20D6h,AX=C001h"PCACHE"

Format of PrintCache configuration table:
Offset	Size	Description	(Table 2674)
 00h 26 BYTEs	ASCIZ signature string "TORQ Configuration Table: "
 1Ah  2 BYTEs	???
 1Ch	DWORD	-> data table (see #2675)
 20h  4 BYTEs	ASCIZ version string ("3.1" for v3.1)
 24h  5 BYTEs	???
 29h 12 BYTEs	ASCIZ version date string ("Aug 31 1993" for v3.1)
 35h	WORD	buffered port type (01h = LPT, 02h = COM)
 37h	WORD	buffered port BIOS port number
 39h  5 BYTEs	ASCIZ buffered port name ("LPTn" or "COMn")
 3Eh	WORD	physical port type (01h = LPT, 02h = COM)
 40h	WORD	physical port BIOS port number
 42h  5 BYTEs	ASCIZ physical port name ("LPTn" or "COMn")
 47h	BYTE	port driver IRQ
 48h 21 BYTEs	???
 5Dh	WORD	buffer size in K
 5Fh 27 BYTEs	???
 7Ah	BYTE	popup hotkey shift states (see #0499 at INT 16/AH=02h)
 7Bh	BYTE	popup hotkey scan code (see #0005 at INT 09"IRQ1")
 7Ch  4 BYTEs	???
 80h 20 BYTEs	ASCIZ printer type name
	???

Format of PrintCache data table:
Offset	Size	Description	(Table 2675)
 00h  2 BYTEs	???
 02h	DWORD	-> ??? entry point
	???
--------U-2FC000-----------------------------
INT 2F - Frank Kintrup TSR Utilities - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	    BX = program ID (see #2676)
	    CX = 464Bh (signature "FK")
	    DX = revision number (DH = major, DL = minor)
	    ES = resident segment of TSR
Range:	AH=C0h to AH=FFh, selected by searching for a free multiplex number
SeeAlso: AX=C001h"Kintrup",AX=C002h"Kintrup"

(Table 2676)
Values for Frank Kintrup TSR program ID:
 4153h	"AS"	ASCII.COM	ASCII table with paste function
 434Ch	"CL"	CLOCK.COM	clock with date/time display and alarm
 5043h	"PC"	PCALC.COM	programmer's calculator with paste function
 5343h	"SC"	SCRSAVE.COM	screen saver with mouse support and hotkey
 5544h	"UD"	UNDEL.COM	undelete program like SMARTCAN or DPROTECT
--------K-2FC000-----------------------------
INT 2F U - HP 100LX/200LX - PUSHKEYS - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if possibly installed
Range:	AH=C0h to AH=FFh, selected by scanning for signature with AL=AEh
SeeAlso: AX=C001h"HP 100LX",AX=C0AEh"HP 100LX",AX=C0AFh"HP 100LX"
--------V-2FC000-----------------------------
INT 2F - DIMWIT - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if installed
	    ES:DI -> signature string "DIMDOS" or "DIMWIN"
Program: DIMWIT is a freeware Windows-aware screen blanker by Larry Board
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"AD-DOS",AX=C001h"DIMWIT"
Index:	screen saver;DIMWIT
--------F-2FC000BX444B-----------------------
INT 2F - MTEZ XpressFax Hardware TSR (CLASS2) - INSTALLATION CHECK
	AX = C000h
	BX = 444Bh ('DK')
	CX = 4A4Eh ('AN')
Return: AL = status
	    00h not installed, OK to install
	    FFh installed
		BX = 646Bh ('dk')
		CX = 6A6Eh ('an')
Range:	AH=C0h to AH=FFh, selected automatically
SeeAlso: AH=C0h"MTEZ"
--------V-2FC000-----------------------------
INT 2F U - TSENGP.COM - INSTALLATION CHECK
	AX = C000h
Return: AL = status
	    00h not installed, OK to install
	    FFh installed
		DS = segment of resident code
Program: TSENGP.COM is a TSR supplied by Compaq to fix an incompatibility
	  between some applications and Tseng ET4000-based video adapters
Range:	AH=C0h to AH=FFh, selected automatically
Note:	the installation check is completed by comparing the first eleven
	  bytes at DS:005Fh against the TSR's code (80h FCh 06h 74h 0Ah
	  80h FCh 07h 74h 05h EAh)
--------N-2FC000-----------------------------
INT 2F U - LapLink RemoteAccess (LLRA) - INSTALLATION CHECK
	AX = C000h
Return: AL = FFh if one of the components is installed
	CX:BX -> signature within LLRA component:
	    "TSI_LapLinkCore" for LLRA1.EXE
	    "TSI_Blackbird"   for LLRA2.EXE
	    "TSI_Redirector"  for LLRA3.EXE
	    "TSI_Compression" for LLRA4.EXE
	DL = major version number
	DH = minor version number
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
Note:	LapLink components are installed in the order listed above, but not
	  necessarily all four; each gets its own multiplex number (default
	  C0h-C3h)
SeeAlso: AX=C002h"LapLink",AX=C205h"LapLink",AX=C2F0h"LapLink"
SeeAlso: AX=C2F1h"LapLink",AX=C301h"LapLink",AX=C3F0h"LapLink"
SeeAlso: AX=C3F1h"LapLink"
--------M-2FC001-----------------------------
INT 2F - QMR - REQUEST HARDWARE RESET
	AX = C001h
Return: ES = QMR code segment
	AL destroyed
Desc:	this function is used to force a full mouse reset when QMR is installed
SeeAlso: AX=C000h"QMR",AX=C002h"QMR"
--------V-2FC001-----------------------------
INT 2F - DIMWIT - GET CONFIGURATION DATA
	AX = C001h
Return: ES:DI -> TSR configuration data (see #2677)
Program: DIMWIT is a freeware Windows-aware screen blanker by Larry Board
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"DIMWIT",AX=C001h"AD-DOS"
Index:	screen saver;DIMWIT

Format of DIMWIT TSR configuration data:
Offset	Size	Description	(Table 2677)
 00h	WORD	blanking delay in clock ticks
 02h	BYTE	instant-blanking hotkey scan code (see #0005)
		Ctrl and Alt must also be pressed
--------V-2FC001ES0000-----------------------
INT 2F - AD-DOS - GET RESIDENT CODE SEGMENT
	AX = C001h
	ES = 0000h
Return: AL = 00h if successful
	    ES = AD-DOS TSR Code Segment
SeeAlso: AX=C000h"AD-DOS",AX=C001h"DIMWIT"
Index:	screen saver;AD-DOS
--------c-2FC001-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - GET ENTRY POINTS
	AX = C001h
Return: AL = FFh if installed
	    ES:BX -> ???
	    ES:DX -> ???
	    ES:SI -> ???
	    ES:DI -> ??? (equivalent to AX=C002h)
SeeAlso: AX=C000h"PCACHE",AX=C002h"PCACHE"
--------U-2FC001-----------------------------
INT 2F - Frank Kintrup TSR Utilities - CLOCK - DISABLE DISPLAY UPDATE
	AX = C001h
Range:	AH=C0h to AH=FFh, selected by searching for a free multiplex number
SeeAlso: AX=C000h"Kintrup",AX=C002h"Kintrup"
--------K-2FC001CX03FB-----------------------
INT 2F U - HP 100LX/200LX - PUSHKEYS - INTERNAL - UNINSTALL
	AX = C001h
	CX = 03FBh return address to continue uninstall if possible
Return: program uninstalled
Range:	AH=C0h to AH=FFh, selected by scanning for signature with AL=AEh
SeeAlso: AX=C000h"HP 100LX",AX=C0AEh"HP 100LX",AX=C0AFh"HP 100LX"
--------i-2FC001-----------------------------
INT 2F - PERSONAL MEASURE - PASS PARAMETERS TO HOOK MODULE(S)
	AX = C001h
	DX = segment of PMEASURE.EXE or 0000h
	BX = offset in PMEASURE.EXE or 0000h
	CX = offset in PMEASURE.EXE or 0000h
Return: None
Program: PMEASURE.EXE is a TSR for monitoring system hardware activity which
	  is part of the Personal Measure system activity monitor from Spirit
	  of Performance, Inc.	PMEASURE uses this call to inform its hook
	  modules whether or not it is running and to pass information about
	  shared data and procedures.
Warning: This information documents a function that is private to Personal
	  Measure and is provided as information only.	It should NOT be called
	  by any software other than Personal Measure.
SeeAlso: AX=C000h"PERSONAL MEASURE"
--------V-2FC002-----------------------------
INT 2F - AD-DOS - CHECK FOR NEW INPUT
	AX = C002h
Return: AL = 00h if successful
	    BX = status
		0000h no input since last check
		0001h new input available
Note:	this call also resets the new-input flag
SeeAlso: AX=C000h"AD-DOS",AX=C004h
Index:	screen saver;AD-DOS
--------M-2FC002-----------------------------
INT 2F - QMR - DISABLE QMR
	AX = C002h
Return: ES = QMR code segment
	AL destroyed
Desc:	this call temporarily disables QMR
SeeAlso: AX=C000h"QMR",AX=C003h"QMR"
--------c-2FC002-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - GET BUFFER SIZE
	AX = C002h
Return: AX = ??? in K
	BX = size of print buffer in K
Program: PCACHE is the resident print spooler portion of PrintCache by
	  LaserTools; it may use either memory or disk space to spool output
SeeAlso: AX=C000h"PCACHE"
--------U-2FC002-----------------------------
INT 2F - Frank Kintrup TSR Utilities - CLOCK - ENABLE DISPLAY UPDATE
	AX = C002h
Range:	AH=C0h to AH=FFh, selected by searching for a free multiplex number
SeeAlso: AX=C000h"Kintrup",AX=C002h"Kintrup"
--------N-2FC002-----------------------------
INT 2F U - LapLink RemoteAccess (LLRA) - Core - ???
	AX = C002h
	details not yet available
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"LapLink",AX=C002h"LapLink",AX=C2F0h"LapLink"
SeeAlso: AX=C2F1h"LapLink",AX=C301h"LapLink"
--------V-2FC003-----------------------------
INT 2F - AD-DOS - SET MINUTES TO WAIT
	AX = C003h
	BX = minutes to wait before blanking screen
Return: AL = 00h if successful
Program: AD-DOS is the DOS version of the After Dark screen blanker for
	  MS Windows
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
Note:	this call also resets the delay timer
SeeAlso: AX=C000h"AD-DOS",AX=C004h
Index:	screen saver;AD-DOS
--------M-2FC003-----------------------------
INT 2F - QMR - ENABLE QMR
	AX = C003h
Return: ES = QMR code segment
	AL destroyed
Desc:	this call enables QMR after it has been disabled
SeeAlso: AX=C000h"QMR",AX=C002h"QMR"
--------c-2FC003-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - SET ??? FLAG
	AX = C003h
Return: BX destroyed
SeeAlso: AX=C004h"PCACHE"
--------V-2FC004-----------------------------
INT 2F - AD-DOS - GET MINUTES TO WAIT
	AX = C004h
Return: AL = 00h if successful
	    BX = minutes to wait before blanking screen
SeeAlso: AX=C000h"AD-DOS",AX=C003h"AD-DOS"
Index:	screen saver;AD-DOS
--------c-2FC004-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - CLEAR ??? FLAG
	AX = C004h
Return: BX destroyed
SeeAlso: AX=C003h"PCACHE"
--------V-2FC005-----------------------------
INT 2F - AD-DOS - SET BLANKER STATUS
	AX = C005h
	BX = new state (0000h inactive, 0001h active) (default 0001h)
Return: AL = 00h if successful
SeeAlso: AX=C006h"AD-DOS"
Index:	screen saver;AD-DOS
--------c-2FC005-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - ???
	AX = C005h
	???
Return: BX destroyed
	???
Program: PCACHE is the resident print spooler portion of PrintCache by
	  LaserTools; it may use either memory or disk space to spool output
Range:	AH=C0h to AH=FFh, selected by commandline switch
SeeAlso: AX=C000h"PCACHE"
--------V-2FC006-----------------------------
INT 2F - AD-DOS - GET BLANKER STATUS
	AX = C006h
Return: AL = 00h if successful
	    BX = current state of screen blanker (0000h inactive, 0001h active)
Program: AD-DOS is the DOS version of the After Dark screen blanker for
	  MS Windows
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"AD-DOS",AX=C005h"AD-DOS"
Index:	screen saver;AD-DOS
--------c-2FC006-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - ???
	AX = C006h
	???
Return: BX destroyed
	???
Note:	this function appears to be identical to AX=C007h
SeeAlso: AX=C000h"PCACHE",AX=C007h"PCACHE"
--------V-2FC007-----------------------------
INT 2F - AD-DOS - SET HOT KEY
	AX = C007h
	BX = hot key
	CL = hot key shift status
Return: AL = 00h if successful
SeeAlso: AX=C008h"AD-DOS"
Index:	screen saver;AD-DOS
--------c-2FC007-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - ???
	AX = C007h
	???
Return: BX destroyed
	???
Note:	this function appears to be identical to AX=C006h
SeeAlso: AX=C000h"PCACHE",AX=C006h"PCACHE"
--------V-2FC008-----------------------------
INT 2F - AD-DOS - GET CURRENT HOT KEY
	AX = C008h
Return: AX = status
	    0000h successful
		BX = Hot Key
		CL = Hot Key Shift Status
	    0008h otherwise
SeeAlso: AX=C000h"AD-DOS",AX=C007h"AD-DOS"
Index:	screen saver;AD-DOS
--------c-2FC008-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - CLEAR ??? FLAG
	AX = C008h
Return: BX destroyed
SeeAlso: AX=C000h"PCACHE",AX=C009h"PCACHE"
--------V-2FC009-----------------------------
INT 2F - AD-DOS - UNBLANK MONITOR
	AX = C009h
Return: AL = 00h if successful
Program: AD-DOS is the DOS version of the After Dark screen blanker for
	  MS Windows
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
Note:	this function works by simulating keyboard activity
Index:	screen saver;AD-DOS
--------c-2FC009-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - SET ??? FLAG
	AX = C009h
Return: BX destroyed
Program: PCACHE is the resident print spooler portion of PrintCache by
	  LaserTools; it may use either memory or disk space to spool output
Range:	AH=C0h to AH=FFh, selected by commandline switch
SeeAlso: AX=C000h"PCACHE",AX=C008h"PCACHE"
--------V-2FC00A-----------------------------
INT 2F - AD-DOS - ???
	AX = C00Ah
Return: AX = status
	    0000h successful
		BH = ??
		BL = ??
	    000Ah failed
Index:	screen saver;AD-DOS
--------c-2FC00A-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - ???
	AX = C00Ah
	???
Return: AH = bit flags
	    bit 5: ???
	AL = bit flags
	    bit 4: ???
	    bit 3: ???
	BX destroyed
	???
SeeAlso: AX=C000h"PCACHE"
--------V-2FC00B-----------------------------
INT 2F - AD-DOS - ???
	AX = C00Bh
Return: AX = status
	    0000h successful
	    000Bh failed
Index:	screen saver;AD-DOS
--------c-2FC00B-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - NOP
	AX = C00Bh
Return: BX destroyed
SeeAlso: AX=C000h"PCACHE"
--------V-2FC00C-----------------------------
INT 2F - AD-DOS - SET ??? INTERNAL FLAG TO 01h
	AX = C00Ch
Return: AX = status
	    0000h successful
	    000Ch failed
Program: AD-DOS is the DOS version of the After Dark screen blanker for
	  MS Windows
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
Index:	screen saver;AD-DOS
--------c-2FC00C-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - GET ???
	AX = C00Ch
Return: AX = ??? (0000h)
	BX = ??? (0000h)
	CX = ??? (0100h)
	DL = ???
	DH = ???
SeeAlso: AX=C000h"PCACHE"
--------c-2FC00D-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - SET ???
	AX = C00Dh
	DL = ???
Return: BX destroyed
Program: PCACHE is the resident print spooler portion of PrintCache by
	  LaserTools; it may use either memory or disk space to spool output
Range:	AH=C0h to AH=FFh, selected by commandline switch
SeeAlso: AX=C000h"PCACHE"
--------V-2FC00E-----------------------------
INT 2F - AD-DOS - SET PASSWORD STATUS
	AX = C00Eh
	BX = new state (0000h disabled, 0001h enabled)
Return: ???
SeeAlso: AX=C000h"AD-DOS",AX=C00Fh"AD-DOS"
Index:	screen saver;AD-DOS
--------c-2FC00E-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - INSTALL ???
	AX = C00Eh
	ES:DX -> ???
Return: BX destroyed
Note:	ES:DX is stored internally if the variable is currently 0000h:0000h,
	  but ignored if already set; a counter is incremented
SeeAlso: AX=C000h"PCACHE",AX=C00Fh"PCACHE"
--------V-2FC00F-----------------------------
INT 2F - AD-DOS - GET PASSWORD STATUS
	AX = C00Fh
Return: BX = current state (0000h disabled, 0001h enabled)
SeeAlso: AX=C00Eh"AD-DOS"
Index:	screen saver;AD-DOS
--------c-2FC00F-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - REMOVE ???
	AX = C00Fh
Return: BX destroyed
Note:	this function decrements the counter used by AX=C00Eh, and clears the
	  internal pointer variable to 0000h:0000h when it reaches zero
SeeAlso: AX=C000h"PCACHE",AX=C00Eh"PCACHE"
--------c-2FC010-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - GET ???
	AX = C010h
	CX = index of ??? table (00h-02h, others treated as 00h)
	SI = offset into data table
Return: AL = byte at specified offset into table
	BX destroyed
SeeAlso: AX=C000h"PCACHE"
--------c-2FC011-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - GET ???
	AX = C011h
Return: AX = ??? (0007h)
	BX = ??? (0001h)
	CH = ???
	CL = ???
SeeAlso: AX=C000h"PCACHE"
--------c-2FC012-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - GET ???
	AX = C012h
Return: AX = ???
	BX = ???
	CX = ???
	DX = ???
SeeAlso: AX=C000h"PCACHE"
--------c-2FC013-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - ???
	AX = C013h
	???
Return: BX destroyed
	???
Program: PCACHE is the resident print spooler portion of PrintCache by
	  LaserTools; it may use either memory or disk space to spool output
Range:	AH=C0h to AH=FFh, selected by commandline switch
SeeAlso: AX=C000h"PCACHE"
--------c-2FC014-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - ???
	AX = C014h
	???
Return: BX destroyed
	???
SeeAlso: AX=C000h"PCACHE"
--------c-2FC015-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - ???
	AX = C015h
	???
Return: BX destroyed
	???
SeeAlso: AX=C000h"PCACHE"
--------c-2FC016-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - INCREMENT ???
	AX = C016h
Return: BX destroyed
SeeAlso: AX=C000h"PCACHE",AX=C017h"PCACHE"
--------c-2FC017-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - DECREMENT ???
	AX = C017h
Return: BX destroyed
SeeAlso: AX=C000h"PCACHE",AX=C016h"PCACH"
--------c-2FC018-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - ???
	AX = C018h
	???
Return: BX destroyed
	???
Note:	the first instruction of this function is an indirect jump which points
	  at a RET by default
SeeAlso: AX=C000h"PCACHE",AX=C019h"PCACHE"
--------c-2FC019-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - ???
	AX = C019h
	???
Return: BX destroyed
	???
Note:	the first instruction of this function is an indirect jump which points
	  at a RET by default
SeeAlso: AX=C000h"PCACHE",AX=C018h"PCACHE"
--------c-2FC01A-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - CLEAR ??? FLAG
	AX = C01Ah
Return: BX destroyed
SeeAlso: AX=C000h"PCACHE",AX=C01Bh"PCACHE"
--------c-2FC01B-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - SET ??? FLAG
	AX = C01Bh
Return: BX destroyed
SeeAlso: AX=C000h"PCACHE",AX=C01Ah"PCACHE"
--------c-2FC01C-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - ???
	AX = C01Ch
	???
Return: AX = ???
	BX destroyed
SeeAlso: AX=C000h"PCACHE"
--------c-2FC01D-----------------------------
INT 2F U - PrintCache v3.1 PCACHE.EXE - NOP
	AX = C01Dh to C01Fh
Return: BX destroyed
Program: PCACHE is the resident print spooler portion of PrintCache by
	  LaserTools; it may use either memory or disk space to spool output
Range:	AH=C0h to AH=FFh, selected by commandline switch
SeeAlso: AX=C000h"PCACHE"
--------V-2FC020-----------------------------
INT 2F - AD-DOS - GET AND RESET VxD API STATUS
	AX = C020h
Return: AL = 00h if successful
	    BX = VxD API Status
		0000h no error
		0001h error
		0100h neither Windows 3.X enhanced mode nor Windows/386 2.x
			  is running
		0200h VM API entry point not found (VxD not installed)
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
Note:	this call resets the VxD API Status to zero
SeeAlso: AX=1602h,AX=1607h"CALL OUT API"
Index:	screen saver;AD-DOS
--------V-2FC04E-----------------------------
INT 2F - Explosiv v2.00+ - NON-TSR EXECUTING CHECK
	AX = C04Eh
Return: AL = 4Fh if Explosiv is running but not memory-resident
Program: Explosiv is a shareware animated screen blanker for DOS and Windows 3
	  by H&G Software (Reidar Gresseth and Chris Hook)
Range:	AH=C0h to AH=C9h, selected by configuration
SeeAlso: AX=C050h
Index:	screen saver;Explosiv
--------V-2FC050-----------------------------
INT 2F - Explosiv v2.00+ - INSTALLATION CHECK
	AX = C050h
Return: AL = 51h if installed
	---v3.0+ ---
	    BX = interval in clock ticks
	    CH = animation display color (00h mono, 01h tinge, 02h color)
	    CL = animation delay factor
	    DH = animation parameters
	    DL = INT 10 checking (00h on, 01h off)
	    SI = number of bytes available for animation code
	    DI = display type (00h VGA, 01h EGA, 02h CGA, 03h HGC, 04h MDA)
Program: Explosiv is a shareware animated screen blanker for DOS and Windows 3
	  by H&G Software (Reidar Gresseth and Chris Hook)
Range:	AH=C0h to AH=C9h, selected by configuration
SeeAlso: AH=93h,AX=C000h"AD-DOS",AX=C04Eh,AX=C052h,AX=C054h"v3"
SeeAlso: INT 14/AX=AA01h
Index:	screen saver;Explosiv
--------V-2FC052-----------------------------
INT 2F - Explosiv v2.00+ - UNINSTALL
	AX = C052h
	DX:BX = address to return to on successful uninstall
Return: at specified address if successful
	AL = 53h on error
Note:	specified return address must have the segment of the caller's PSP
SeeAlso: AX=C050h
Index:	screen saver;Explosiv
--------V-2FC054-----------------------------
INT 2F - Explosiv v2.x - GET ANIMATION DELAY FACTOR
	AX = C054h
Return: AL = delay factor
SeeAlso: AX=C057h
Index:	screen saver;Explosiv
--------V-2FC054-----------------------------
INT 2F - Explosiv v3.0+ - UPDATE PARAMETERS
	AX = C054h
	BX = new interval in clock ticks
	CH = animation display color (00h mono, 01h tinge, 02h color)
	CL = animation delay factor
	DH = animation parameters
	DL = INT 10 checking (00h on, 01h off)
SeeAlso: AX=C050h
Index:	screen saver;Explosiv
--------V-2FC055-----------------------------
INT 2F - Explosiv v2.x - SET BLANKING INTERVAL
	AX = C055h
	BX = new interval in clock ticks
Index:	screen saver;Explosiv
--------V-2FC056-----------------------------
INT 2F - Explosiv v2.x - SET ANIMATION DISPLAY TYPE
	AX = C056h
	BL = animated display type (00h mono, 01h color)
SeeAlso: AX=C058h"v2.x"
Index:	screen saver;Explosiv
--------V-2FC056-----------------------------
INT 2F - Explosiv v3.0+ - ENABLE/DISABLE EXPLOSIV
	AX = C056h
	BX = new state
	    0000h disabled
	    0100h enabled
	    0101h enabled, but never blank
	    0102h enabled, always blank
--------V-2FC057-----------------------------
INT 2F - Explosiv v2.x - SET ANIMATION DELAY FACTOR
	AX = C057h
	BL = delay factor
SeeAlso: AX=C054h"v2.x"
Index:	screen saver;Explosiv
--------V-2FC058-----------------------------
INT 2F - Explosiv v2.x - SET ANIMATION PARAMETER
	AX = C058h
	BL = animation parameter
Note:	the animation parameter has different interpretations for each display
SeeAlso: AX=C056h"v2.x"
Index:	screen saver;Explosiv
--------V-2FC058-----------------------------
INT 2F - Explosiv v3.0+ - LOAD NEW ANIMATION DISPLAY CODE
	AX = C058h
	BX = file handle for file containing display code
	CX = number of bytes to load
	DX = offset at which animation code should be loaded
Return: AL = status (see #2678)
Note:	if AL=00h-03h on return, the file will be closed
Index:	screen saver;Explosiv

(Table 2678)
Values for Explosiv function status:
 00h	successful
 01h	code too large to available space
 02h	no data read, load aborted
 03h	incomplete load, default blanking display loaded instead
 58h	unexpected offset in DX
--------V-2FC059-----------------------------
INT 2F - Explosiv v2.x - DISABLE EXPLOSIV
	AX = C059h
Note:	clears flag set by AX=C05Ah
SeeAlso: AX=C05Ah
Index:	screen saver;Explosiv
--------V-2FC05A-----------------------------
INT 2F u - Explosiv v2.x - ENABLE EXPLOSIV
	AX = C05Ah
	BL = ???
Note:	sets flag cleared by AX=C059h then stores BL
SeeAlso: AX=C059h,AX=C05Bh
Index:	screen saver;Explosiv
--------V-2FC05B-----------------------------
INT 2F - Explosiv v2.x - CHANGE ANIMATION DISPLAY
	AX = C05Bh
	BL = animation display
Note:	this function fails silently if the requested display is not in memory
SeeAlso: AX=C05Ah,AX=C05Ch
Index:	screen saver;Explosiv
--------V-2FC05C-----------------------------
INT 2F - Explosiv v2.x - SET INT 10 CHECKING
	AX = C05Ch
	BL = new state of INT 10 checking (00h enabled, 01h disabled)
SeeAlso: AX=C05Bh
Index:	screen saver;Explosiv
--------v-2FC080-----------------------------
INT 2F U - AMI IAM.SYS - INSTALL ??? CALLBACK
	AX = C080h
	CX:DX -> ??? callback
	DI = segment of ??? buffer (first WORD copied into IAM.SYS)
Program: IAM.SYS is the Illegal Activity Monitor portion of American
	  Megatrends, Inc.'s PC-Defender anti-virus product
Note:	also sets ??? flag
SeeAlso: AX=C081h

Format of IAM.SYS buffer:
Offset	Size	Description	(Table 2679)
 00h	BYTE	???
 01h	BYTE	???
 02h  N BYTEs	??? (ASCIZ strings)
--------v-2FC081-----------------------------
INT 2F U - AMI IAM.SYS - CLEAR ???
	AX = C081h
Desc:	clears the ??? flag that AX=C080h sets
SeeAlso: AX=C080h
--------K-2FC0AE-----------------------------
INT 2F U - HP 100LX/200LX - PUSHKEYS - INSTALLATION CHECK
	AX = C0AEh
Return: AX = 4453h if installed
	CX = 5259h if installed
Range:	AH=C0h to AH=FFh, selected by scanning for signature
SeeAlso: AX=C000h"HP 100LX",AX=C001h"HP 100LX",AX=C0AFh"HP 100LX"
--------K-2FC0AF-----------------------------
INT 2F U - HP 100LX/200LX - PUSHKEYS - INTERNAL - GET BUFFER ADDRESS
	AX = C0AFh
Return: ES:DI -> buffer (behind code)
Range:	AH=C0h to AH=FFh, selected by scanning for signature with AL=AEh
SeeAlso: AX=C000h"HP 100LX",AX=C001h"HP 100LX",AX=C0AEh"HP 100LX"
--------N-2FC100-----------------------------
INT 2F U - Personal NetWare - STPIPX v1.00 - INSTALLATION CHECK
	AX = C100h
Return: AL = FFh if installed
	    ES:SI -> signature string "STP-IPX$"
	    BX = version??? (0001h for v1.00)
	    DI corrupted
Note:	AH=C1h is the default value; STPIPX probably scans a range of
	  multiplex numbers to find a free one, as LSL does
SeeAlso: AX=C000h"LSL",AX=C101h
--------N-2FC101-----------------------------
INT 2F U - Personal NetWare - STPIPX v1.00 - UNINSTALL
	AX = C101h
Return: AL = status???
	BX corrupted
SeeAlso: AX=C101h
--------N-2FC205-----------------------------
INT 2F U - LapLink RemoteAccess (LLRA) - Redirector - ???
	AX = C205h
	details not yet available
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"LapLink",AX=C002h"LapLink",AX=C2F0h"LapLink"
SeeAlso: AX=C2F1h"LapLink",AX=C301h"LapLink"
--------N-2FC2F0-----------------------------
INT 2F U - LapLink RemoteAccess (LLRA) - Redirector - ???
	AX = C2F0h
	details not yet available
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"LapLink",AX=C002h"LapLink",AX=C205h"LapLink"
SeeAlso: AX=C2F1h"LapLink",AX=C301h"LapLink"
--------N-2FC2F1-----------------------------
INT 2F U - LapLink RemoteAccess (LLRA) - Redirector - ???
	AX = C2F1h
	details not yet available
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"LapLink",AX=C002h"LapLink",AX=C205h"LapLink"
SeeAlso: AX=C2F0h"LapLink",AX=C301h"LapLink"
--------d-2FC300-----------------------------
INT 2F - SETWPR.COM - INSTALLATION CHECK
	AX = C300h
Return: AL = FFh if installed
Program: SETWPR is a hard-disk write-protection TSR by Jaroslaw Rafa
SeeAlso: AX=C302h"SETWPR"
--------k-2FC300DX0000-----------------------
INT 2F U - SpaceManager - INSTALLATION CHECK
	AX = C300h
	DX = 0000h
Return: AL = FFh if any SpaceManager programs installed
	    BX = 6F73h
	    CX = 6F68h
Program: SpaceManager is an enhancement for MS-DOS DoubleSpace by Vertisoft
	  Systems, Inc.
Range:	AH=C3h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C300h/BX=4F53h
--------k-2FC300BX4F53-----------------------
INT 2F U - SpaceManager - INSTALLATION VERIFICATION
	AX = C300h
	BX = 4F53h ('OS')
	CX = 4F48h ('OH')
	DX = program identifier (see #2680) or 0666h for any SpaceManager prog
Return: AL = FFh if BX/CX as specified and specified program installed
	    BX = 6F73h ('os')
	    CX = 6F68h ('oh')
Range:	AH=C3h to AH=FFh, selected by scanning for first free multiplex number
Note:	this call is chained if BX,CX, or DX are not as specified above
SeeAlso: AX=C300h/DX=0000h

(Table 2680)
Values for SpaceManager program identifier:
 9000h	SMOUNT (SuperMount)
 9001h	SELECTC (SelectCompress)
 9002h	SUPERX (SuperExchange)
 9003h	FORTUNE (FortuneTeller)
--------k-2FC301-----------------------------
INT 2F U - SpaceManager - ???
	AX = C301h
	DX = program identifier (9000h,9001h,9003h) (see #2680)
	???
Return: ???
--------N-2FC301-----------------------------
INT 2F U - LapLink RemoteAccess (LLRA) - Compression - ???
	AX = C301h
	details not yet available
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"LapLink",AX=C002h"LapLink",AX=C205h"LapLink"
SeeAlso: AX=C2F0h"LapLink",AX=C3F0h"LapLink",AX=C3F1h"LapLink"
--------k-2FC302-----------------------------
INT 2F U - SpaceManager - ENABLE PROGRAM
	AX = C302h
	DX = program identifier (9000h,9001h,9003h) (see #2680)
Return: AX destroyed
SeeAlso: AX=C303h,AX=C306h
--------d-2FC302-----------------------------
INT 2F - SETWPR.COM - SET WRITE-PROTECTION STATE
	AX = C302h
	BL = new state
	    00h disk may be written
	    01h disk write-protected
Return: AL = FFh if installed
Program: SETWPR is a hard-disk write-protection TSR by Jaroslaw Rafa
SeeAlso: AX=C300h"SETWPR"
--------k-2FC303-----------------------------
INT 2F U - SpaceManager - DISABLE PROGRAM
	AX = C303h
	DX = program identifier (9000h,9001h,9003h) (see #2680)
Return: AX destroyed
SeeAlso: AX=C302h,AX=C306h
--------k-2FC304-----------------------------
INT 2F U - SpaceManager - GET PER-DRIVE ENABLEMENT TABLE
	AX = C304h
	DX = program identifier (9000h,9001h,9003h) (see #2680)
Return: ES:BX -> 26-byte drive table (00h disabled for drive, 01h enabled)
	AX destroyed
--------k-2FC305DX9003-----------------------
INT 2F U - SpaceManager - FORTUNE.EXE - NOP
	AX = C305h
	DX = 9003h
Return: AX destroyed
--------k-2FC305-----------------------------
INT 2F U - SpaceManager - ???
	AX = C305h
	DX = program identifier (9000h,9001h) (see #2680)
	???
Return: ???
--------k-2FC306-----------------------------
INT 2F U - SpaceManager - CHECK WHETHER PROGRAM ENABLED
	AX = C306h
	DX = program identifier (9000h,9001h,9003h) (see #2680)
Return: AL = current state (00h disabled, FAh enabled)
	AH destroyed
SeeAlso: AX=C302h,AX=C303h
--------k-2FC307DX9001-----------------------
INT 2F U - SpaceManager - SELECTC - ???
	AX = C307h
	DX = 9001h
	BX = ???
	CX = ???
	???
Return: ???
--------k-2FC308DX9001-----------------------
INT 2F U - SpaceManager - SELECTC - ???
	AX = C308h
	DX = 9001h
	???
Return: ???
--------N-2FC3F0-----------------------------
INT 2F U - LapLink RemoteAccess (LLRA) - Compression - ???
	AX = C3F0h
	details not yet available
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"LapLink",AX=C002h"LapLink",AX=C205h"LapLink"
SeeAlso: AX=C2F0h"LapLink",AX=C301h"LapLink",AX=C3F1h"LapLink"
--------N-2FC3F1-----------------------------
INT 2F U - LapLink RemoteAccess (LLRA) - Compression - ???
	AX = C3F1h
	details not yet available
Range:	AH=C0h to AH=FFh, selected by scanning for first free multiplex number
SeeAlso: AX=C000h"LapLink",AX=C002h"LapLink",AX=C205h"LapLink"
SeeAlso: AX=C2F0h"LapLink",AX=C301h"LapLink",AX=C3F0h"LapLink"
--------d-2FC64CBX5553-----------------------
INT 2F U - Smart Prompt - INSTALLATION CHECK
	AX = C64Ch
	BX = 5553h
Return: AX = 4CC6h if installed
	BX = 5355h if installed
Program: Smart Prompt (SMARTPMT) is a freeware TSR by Steve Gibson which
	  forces an immediate flush of SmartDrive's (and compatible caches')
	  buffers on returning to the DOS prompt
--------V-2FC700CX434C-----------------------
INT 2F u - COLAP - INSTALLATION CHECK
	AX = C700h
	CX = 434Ch  "CL"
Return: AL = FFh if installed
Program: colap.com is a freeware TSR by Eric Meyer which controls contrast
	  and brightness of color laptops by changing the VGA palette colors;
	  for Toshiba laptops there are more hotkeys for shutting off display
	  and harddisk.
--------v-2FC900BP0000-----------------------
INT 2F U - ThunderByte??? - INSTALLATION CHECK
	AX = C900h
	BP = 0000h
Return: AL = FFh if installed
	    BP >= 0014h
Note:	called by TBSCANX
SeeAlso: AX=C987h,AX=CA00h
--------v-2FC987-----------------------------
INT 2F U - ThunderByte??? - DISINFECT FILE???
	AX = C987h
	BX:DX -> filename
	BX:CX -> virus name
Return: AX = status
	    0000h successful???
Note:	called by TBSCANX
SeeAlso: AX=CA00h
--------r-2FC9FF-----------------------------
INT 2F C - StackMan - INSTALLATION BROADCAST
	AX = C9FFh
	BL = BCD version number
	CX = number of stacks
	DX = stack size in bytes
Program: StackMan is a freeware stack manager by Franz Veldman of ESaSS B.V.
	  which functions as a replacement for the DOS STACK= command as well
	  as permitting multiple TSRs to share a pool of stack space
Notes:	called by StackMan when it goes resident to inform interested TSRs that
	  its API is available
	the installation check consists of testing for the string "STACKXXX" at
	  offset 0Ah from the INT B4 handler
SeeAlso: INT B4"StackMan",INT B5"StackMan"
Index:	installation check;STACKMAN|broadcasts;STACKMAN installation
--------F-2FCA-------------------------------
INT 2F - FAXPLUS - FAX TSR
	AH = CAh
	???
Return: ???
Program: FAXTSR is a resident FAX send/receive module for FAXPLUS by Frans
	  Veldman
SeeAlso: AH=2Ah"Gammafax"
--------v-2FCA00BX5442-----------------------
INT 2F - TBSCANX - INSTALLATION CHECK
	AX = CA00h
	BX = 5442h ('TB')
Return: AL = state
	    00h not installed
	    FFh installed
		BX = 7462h ('tb') if BX was 5442h on entry
Program: TBSCANX is a resident virus scanning module by Frans Veldman.
Note:	programs may perform virus checks on themselves, other program files,
	  or their data files by invoking the TBSCANX API.
SeeAlso: AX=4653h/CX=0002h,AX=4653h/CX=0007h,AX=C900h
--------v-2FCA01-----------------------------
INT 2F - TBSCANX - GET STATUS
	AX = CA01h
Return: AH = BCD version number (v2.2+)
	    CAh for versions before 2.2
	AL = state (00h = disabled, 01h = enabled)
	CX = number of signatures which will be searched
---v2.0---
	BX = EMS handle, 0000h if not using EMS
---v2.3+---
	BX = segment of swap area, 0000h if not swapped
	DX = EMS or XMS handle (XMS handle if BX=0000h), FFFFh if not using EMS
SeeAlso: AX=CA02h
--------v-2FCA02-----------------------------
INT 2F - TBSCANX - SET STATE
	AX = CA02h
	BL = new state (00h = disabled, 01h = enabled)
SeeAlso: AX=CA01h
--------v-2FCA03-----------------------------
INT 2F - TBSCANX - SCAN BUFFER
	AX = CA03h
	CX = size of buffer
	DS:DX -> buffer containing data to scan
Return: CF clear if no virus signatures found
	    BX,ES destroyed
	CF set if signature found
	    ES:BX -> ASCIZ virus name (v2.3+)
	    DS:DX -> ASCIZ virus name (v2.0)
	AX,CX,DX destroyed (v2.3+)
	all other registers except CS:IP and SS:SP destroyed (v2.0)
SeeAlso: AX=CA04h
--------v-2FCA04-----------------------------
INT 2F - TBSCANX - SCAN FILE
	AX = CA04h
	DS:DX -> filename
Return: CF clear if no virus signatures found
	    BX,ES destroyed
	CF set if signature found
	    ES:BX -> ASCIZ virus name
	AX,CX,DX destroyed
Note:	this function requires at least 4K free memory
SeeAlso: AX=CA03h
--------U-2FCAFEBX0000-----------------------
INT 2F U - THELP v3.0 - INSTALLATION CHECK
	AX = CAFEh
	BX = 0000h
Return: BX = segment of resident code if installed
	    0000h if not installed
SeeAlso: AX=5453h,INT 2D"AMIS"
--------F-2FCB00-----------------------------
INT 2F - Communicating Applications Specification - INSTALLATION CHECK
	AX = CB00h
Return: AL = status
	    00h not installed, OK to install
	    01h not installed, not OK to install
	    FFh installed
Note:	AH = CBh is the default identifier, but may be reconfigured
SeeAlso: AH=2Ah,AX=8000h"FaxBIOS",AX=CB0Eh,AX=CBDCh
--------F-2FCB00BX4D53-----------------------
INT 2F - MTEZ XpressFax CASMGR - INSTALLATION CHECK
	AX = CB00h
	BX = 4D53h ('MS')
	CX = 4949h ('II')
Return: AL = status
	    00h not installed, OK to install
	    01h not installed, not OK to install
	    FFh installed
		BX = 6D73h ('ms')
		CX = 6969h ('ii')
Note:	this function is equivalent to the standard CASMGR installation check,
	  but uses the additional magic values to identify which CAS is
	  installed
SeeAlso: AH=2Ah,AX=8000h"FaxBIOS",AX=C000h/BX=444Bh,AX=CB0Eh,AX=CB16h
--------F-2FCB01-----------------------------
INT 2F - Communicating Applications Specification - SUBMIT A TASK
	AX = CB01h
	DS:DX -> ASCIZ name of task control file
Return: AX >= 0: event handle
	AX < 0: two's complement of error code (see #2681)
Note:	files needed for an event must be kept until task is complete or error
SeeAlso: AX=CB0Bh,AX=CB15h

(Table 2681)
Values for CAS error code:
  (AH = class, AL = subcode, value passed back is 2's complement)
  Class 00h	--- FAX warnings
	Subcode 00h	no error
		02h	bad scanline count
		03h	page sent with errors, could not retransmit
		04h	received data lost
		05h	invalid or missing logo file
		06h	filename does not match nonstandard format (NSF) header
		07h	file size does not match NSF header
  Class 01h	--- DOS warnings (data was sent)
	Subcode 01h	invalid function
		05h	access denied
		06h	invalid handle
		others	see #1332 at INT 21/AH=59h/BX=0000h
  Class 02h	--- fatal errors (data not sent)
	Subcode 00h	multiplex handler failed
		01h	unknown command
		02h	bad event handle
		03h	FIND NEXT attempted before FIND FIRST
		04h	no more events
		07h	invalid queue type
		08h	bad control file
		09h	communication board busy
		0Ah	invalid command parameter
		0Bh	can't uninstall resident code
		0Ch	file exists
		80h	unknown task type
		81h	bad phone number
		82h	bad .PCX file header
		83h	unexpected EOF
		84h	unexpected disconnect
		85h	too many dialing retries
		86h	no file specified for send
		87h	communication board timeout
		88h	received too many pages (>1023) of data
		89h	manual connect initiated too long ago
		8Ah	hardware command set error
		8Bh	bad NonStandard Format (NSF) header file
  Class 03h	--- fatal DOS errors
	Subcode 02h	file not found
		03h	path not found
		others	see #1332 at INT 21/AH=59h/BX=0000h
  Class 04h	--- FAX errors
	Subcode 01h	remote unit not Group 3 compatible
		02h	remote unit did not send capabilities
		03h	other FAX machine incompatible
		04h	other FAX incapable of file transfers
		05h	exceeded retrain or FAX resend limit
		06h	line noise or failure to agree on bit rate
		07h	remote disconnected after receiving data
		08h	no response from remote after sending data
		09h	remote's capabilities incompatible
		0Ah	no dial tone (v1.2+)
		0Bh	invalid response from remote unit after sending data
		0Dh	phone line dead or remote unit disconnected
		0Eh	timeout while waiting for secondary dial tone (v1.2+)
		11h	invalid command from remote after receiving data
		15h	tried to receive from incompatible hardware
		5Ch	received data overflowed input buffer
		5Dh	remote unexpectedly stopped sending data
		5Eh	other FAX machine jammed (no data sent)
		5Fh	remote took too long to send fax scan line
		63h	can't get through to remote unit
		64h	user canceled event
  Class 05h	--- application-specific (v1.2+)
  ---Intel FAXPOP.EXE
	Subcode 00h	tried to send while in graphics mode
		01h	insufficient disk space
		02h	internal buffer overflow
  Class 06h	--- CAS implementation-specific (v1.2+)
--------F-2FCB02-----------------------------
INT 2F - Communicating Applications Specification - ABORT CURRENT EVENT
	AX = CB02h
Return: AX >= 0: event handle of aborted event
	AX < 0: error code (see #2681)
Note:	termination could take up to 30 seconds
SeeAlso: AX=CB08h,AX=CB10h
--------F-2FCB05-----------------------------
INT 2F - Communicating Applications Specification - FIND FIRST QUEUE ENTRY
	AX = CB05h
	CX = status of events to find
	    0000h successful completion
	    0001h waiting to be processed
	    0002h number has been dialed
	    0003h connection established, sending
	    0004h connection established, receiving
	    0005h event aborted
	    FFFFh find any event, regardless of status
	    other negative values, match error code
	DH = direction
	    00h chronological order, earliest to latest
	    01h reverse chronological order, latest to earliest
	DL = queue to search
	    00h task queue
	    01h receive queue
	    02h log queue
Return: AX = 0000h successful
	    BX = event handle for found event
	AX < 0	   error code (see #2681)
SeeAlso: AX=CB06h,AX=CB07h
--------F-2FCB06-----------------------------
INT 2F - Communicating Applications Specification - FIND NEXT QUEUE ENTRY
	AX = CB06h
	DL = queue to search
	    00h task queue
	    01h receive queue
	    02h log queue
Return: AX = 0000h successful
	    BX = event handle for found event
	AX < 0	   error code (see #2681)
Note:	direction of search is same as preceding FIND FIRST call
SeeAlso: AX=CB05h
--------F-2FCB07-----------------------------
INT 2F - Communicating Applications Specification - OPEN FILE
	AX = CB07h
	BX = event handle from find (AL=05h,06h) or submit task (AL=01h)
	CX = receive file number (ignored for task queue and log queue)
	    0000h  open receive control file
	    N	   open Nth received data file
	DL = queue
	    00h task queue
	    01h receive queue control file or received file, as given by CX
	    02h log queue
	    03h group file in task queue (v1.2+)
	    04h group file in log queue (v1.2+)
Return: AX = 0000h successful
	    BX = DOS file handle for requested file
	AX < 0	   error code (see #2681)
Note:	the returned file handle has been opened in read-only mode and should
	  be closed with INT 21/AH=3Eh after use
SeeAlso: AX=CB01h,AX=CB05h,AX=CB14h
--------F-2FCB08-----------------------------
INT 2F - Communicating Applications Specification - DELETE FILE
	AX = CB08h
	BX = event handle
	CX = receive file number
	    0000h delete ALL received files and receive control file
	    N	  delete Nth received file
	DL = queue
	    00h delete control file in task queue and corresponding group file
		  if it exists
	    01h delete file in receive queue, as given by CX
	    02h delete control file in log queue (individual deletions not
		  recommended, to maintain integrity of log) and corresponding
		  group file if it exists
Return: AX = 0000h successful
	AX < 0	   error code (see #2681)
SeeAlso: AX=CB02h,AX=CB09h
--------F-2FCB09-----------------------------
INT 2F - Communicating Applications Specification - DELETE ALL FILES IN Q
	AX = CB09h
	DL = queue
	    00h delete all control files in task queue, including all group
		  files
	    01h delete all files in receive queue
	    02h delete all control files in log queue, including all group
		  files
Return: AX = 0000h successful
	AX < 0	   error code (see #2681)
SeeAlso: AX=CB08h
--------F-2FCB0A-----------------------------
INT 2F - Communicating Applications Specification - GET EVENT DATE
	AX = CB0Ah
	BX = event handle
	DL = queue
	    00h task queue
	    01h receive queue
	    02h log queue
Return: AX = 0000h successful
	    CX = year
	    DH = month
	    DL = day
	AX < 0	   error code (see #2681)
SeeAlso: AX=CB0Bh,AX=CB0Ch
--------F-2FCB0B-----------------------------
INT 2F - Communicating Applications Specification - SET TASK DATE
	AX = CB0Bh
	BX = event handle (task event only)
	CX = year
	DH = month
	DL = day
Return: AX = 0000h successful
	AX < 0	   error code (see #2681)
Note:	setting a task's date and time to before the current date and time
	  causes it to execute immediately
SeeAlso: AX=CB01h,AX=CB0Ah,AX=CB0Dh
--------F-2FCB0C-----------------------------
INT 2F - Communicating Applications Specification - GET EVENT TIME
	AX = CB0Ch
	BX = event handle
	DL = queue
	    00h task queue
	    01h receive queue
	    02h log queue
Return: AX = 0000h successful
	    CH = hour
	    CL = minute
	    DH = second
	    DL = 00h
	AX < 0	   error code (see #2681)
SeeAlso: AX=CB0Ah,AX=CB0Dh
--------F-2FCB0D-----------------------------
INT 2F - Communicating Applications Specification - SET TASK TIME
	AX = CB0Dh
	BX = event handle (task events only)
	CH = hour
	CL = minute
	DH = second
	DL unused
Return: AX = 0000h successful
	AX < 0	   error code (see #2681)
Note:	setting a task's date and time to before the current date and time
	  causes it to execute immediately
SeeAlso: AX=CB0Bh,AX=CB0Ch,AX=CB10h
--------F-2FCB0E-----------------------------
INT 2F - Communicating Applications Specification - GET EXTERNAL DATA BLOCK
	AX = CB0Eh
	DS:DX -> 256-byte buffer for external data block (see #2682)
Return: AX = 0000h successful
	    DS:DX buffer filled
	AX < 0	   error code (see #2681)

Format of CAS external data block:
Offset	Size	Description	(Table 2682)
 00h	BYTE	CAS major version
 01h	BYTE	CAS minor version
 02h 68 BYTEs	ASCIZ path to directory containing CAS software, ends in slash
 46h 13 BYTEs	ASCIZ name of current phonebook (in CAS directory)
 53h 13 BYTEs	ASCIZ name of current logo file (in CAS directory)
 60h 32 BYTEs	ASCIZ default sender name
 80h 21 BYTEs	ASCIZ CCITT identification of fax device
 95h 107 BYTEs	reserved
--------F-2FCB0F-----------------------------
INT 2F - Communicating Applications Specification - GET/SET AUTORECEIVE
	AX = CB0Fh
	DL = subfunction
	    00h get current autoreceive state
	    01h set autoreceive state
		DH = number of rings before answer, 00h = never
Return: AX = 0000h autoreceive disabled
	AX = N	   number of rings before answer
	AX < 0	   error code (see #2681)
--------F-2FCB10-----------------------------
INT 2F - Communicating Applications Specification - GET CURRENT EVENT STATUS
	AX = CB10h
	DS:DX -> 512-byte buffer for status area (see #2684)
Return: AX = 0000h successful
		BX = event handle of current event or negative error code if
		      no current event
		buffer filled
	AX < 0	   error code (see #2681)
SeeAlso: AX=CB02h,AX=CB0Dh

(Table 2683)
Values for CAS event type:
 00h	send
 01h	receive
 02h	polled send
 03h	polled receive
 04h to 7Fh reserved
 FFh	serious hardware error

Format of CAS status area:
Offset	Size	Description	(Table 2684)
 00h	BYTE	event type (see #2683)
 01h	BYTE	transfer type
		00h 200x200 dpi, FAX mode
		01h 100x200 dpi, FAX mode
		02h file transfer mode
		03h to 7Fh reserved
 02h	WORD	event status (see #2685)
 04h	WORD	event time (packed DOS time format, see INT 21/AX=5700h)
 06h	WORD	event date (packed DOS date format, see INT 21/AX=5700h)
 08h	WORD	number of files to transfer, max 7FFFh
 0Ah	WORD	offset of file transfer record
 0Ch 47 BYTEs	ASCIZ phone number to call
 3Bh 64 BYTEs	ASCIZ application-specific tag string
 7Bh	BYTE	reserved (00h)
 7Ch	BYTE	connect time, seconds
 7Dh	BYTE	connect time, minutes
 7Eh	BYTE	connect time, hours
 7Fh	DWORD	total number of pages in all files
 83h	DWORD	pages already transmitted
 87h	WORD	number of files already transmitted
 89h	BYTE	cover page flag
		00h don't transmit cover page
		01h transmit cover page
		02h to 7Fh reserved
 8Ah	WORD	total number of transmission errors
 8Ch 78 BYTEs	reserved (zeros)
 DAh 21 BYTEs	ASCIZ remote FAX's CCITT identification
 EFH 32 BYTEs	ASCIZ destination name
10Fh 32 BYTEs	ASCIZ sender name
12Fh 80 BYTEs	filename of PCX logo file (max 1780x800 pixels)
17Fh 128 BYTEs	file transfer record for current event (see #2686)

(Table 2685)
Values for CAS event status:
 0000h	completed successfully
 0001h	waiting
 0002h	number dialed
 0003h	connected, sending
 0004h	connected, receiving
 0005h	aborted
 0006h to 007Fh reserved
 0080h to 7FFFh application-specific events
 8000h to FFFFh error codes

Format of CAS file transfer record:
Offset	Size	Description	(Table 2686)
 00h	BYTE	file type (ignored unless FAX)
		00h ASCII
		01h PCX
		02h DCX
		03h to 7Fh reserved
 01h	BYTE	text size for ASCII FAX file
		00h = 80 columns by 66 lines (11 inches)
		01h = 132 columns by 88 lines (11 inches)
		02h to 7Fh reserved
 02h	BYTE	status of file
		00h untouched
		01h opened
		02h moved
		03h deleted
		04h not yet received
		05h to 7Fh reserved
 03h	DWORD	bytes already transmitted
 07h	DWORD	file size in bytes
 0Bh	WORD	pages alread transmitted
 0Dh	WORD	number of pages in file
 0Fh 80 BYTEs	ASCIZ filename
 5Fh	BYTE	1/8 inch page length
		if page length below set to 01h through 7Fh, this value
		  specifies additional 1/8 inch increments to page length
 60h	BYTE	page length
		00h = 11 inches
		01h to 7Fh = page length is this number of inches plus value of
			  1/8 inch field above
		80h to FEh reserved
		FFh = ASCII pages ending with formfeed
 61h 31 BYTEs	reserved (zeros)
--------F-2FCB11-----------------------------
INT 2F - Communicating Applications Specification - GET QUEUE STATUS
	AX = CB11h
	DL = queue to get status of
	    00h task queue
	    01h receive queue
	    02h log queue
	    03h send events (v1.2+)
	    04h receive events (v1.2+)
Return: AX >= 0	 total number of changes made to queue, modulo 32768
	    BX = number of control files currently in queue
	    CX = number of received files (zero for task and log queues)
	AX < 0	error code (see #2681)
SeeAlso: AX=CB12h
--------F-2FCB11DL03-------------------------
INT 2F - Communicating Applications Spec v1.2+ - GET NUMBER OF SEND EVENTS
	AX = CB11h
	DL = 03h
Return: AX = number of successful sends since resident manager started
	BX = number of unsuccessful sends, including warnings
SeeAlso: AX=CB11h/DL=04h
--------F-2FCB11DL04-------------------------
INT 2F - Communicating Applications Spec v1.2+ - GET NUMBER OF RECEIVE EVENTS
	AX = CB11h
	DL = 04h
Return: AX = number of received file events since resident manager started
	BX = number of received FAX events
SeeAlso: AX=CB11h/DL=03h
--------F-2FCB12-----------------------------
INT 2F - Communicating Applications Specification - GET HARDWARE STATUS
	AX = CB12h
	DS:DX -> 128-byte status buffer (see #2687,#2689)
Return: AX = 0000h successful
	    DS:DX buffer filled with hardware-dependent status information
	   < 0	   error code (see #2681)
SeeAlso: AX=CB10h,AX=CB11h

Format of status buffer for Intel Connection CoProcessor:
Offset	Size	Description	(Table 2687)
 00h	BYTE	Connection CoProcessor connection status flags (see #2690)
 01h	BYTE	number of kilobytes of free buffer space
 02h	BYTE	page buffer status
		bit 7: Connection CoProcessor has documents to send
		bits 6-0: number of pages in buffer
 03h	BYTE	number of retries left for dialing number
 04h	BYTE	page number to retransmit
 05h	BYTE	communications status (see #2691)
 06h	BYTE	baud rate (see #2688)
 07h  3 BYTEs	reserved
 0Ah	BYTE	Connection CoProcessor hardware status (see #2692)
 0Bh	BYTE	Connection CoProcessor switch states (see #2693)
 0Ch	BYTE	communications flags (see #2694)
 0Dh	BYTE	reserved
 0Eh	WORD	error count (only valid while busy, reset when idle)
 10h	DWORD	size of nonstandard format (NSF) file in bytes
 14h	BYTE	'A' if Connection CoProcessor board present
 15h  9 BYTEs	reserved
 1Eh 21 BYTEs	ASCIZ CCITT identification
 33h 77 BYTEs	reserved
Note:	the Intel Connection CoProcessor and SatisFAXtion may be distinguished
	  by examining the byte at offset 14h

Bitfields for Connection CoProcessor baud rate:
Bit(s)	Description	(Table 2688)
 7	reserved
 6-4	baud rate
	000 = 300 baud	(V.21 SDLC or HDLC mode)
	100 = 2400 baud (V.27 ter)
	101 = 4800 baud (V.27 ter)
	110 = 7200 baud (V.29)
	111 = 9600 baud (V.29)
 3-0	reserved, should be 0110

Format of status buffer for Intel SatisFAXtion board:
Offset	Size	Description	(Table 2689)
 00h	BYTE	SatisFAXtion connection status flags (see #2695)
 01h	BYTE	SatisFAXtion board state (see #2696)
 02h	BYTE	number of KB free in buffer
 03h	BYTE	number of pages or files in buffer
 04h	BYTE	number of redials remaining on current number
 05h	BYTE	FAX page number to retransmit
 06h	BYTE	current page/file in block transfer
 07h	BYTE	number of rings received (only if auto-answer enabled)
 08h	WORD	error count
 0Ah	DWORD	length of file being transferred
 0Eh  6 BYTEs	reserved
 14h	BYTE	'B' if SatisFAXtion board present
 15h 13 BYTEs	ASCIZ transfer agent name
 22h  5 BYTEs	ASCIZ transfer agent version number
 27h 13 BYTEs	ASCIZ resident loader name
 34h  5 BYTEs	ASCIZ resident loader version number
 39h 21 BYTEs	ASCIZ remote CSID
 4Eh 13 BYTEs	ASCIZ resident manager name
 5Bh  5 BYTEs	ASCIZ resident manager version number
 60h 32 BYTEs	reserved
Note:	the Intel Connection CoProcessor and SatisFAXtion may be distinguished
	  by examining the byte at offset 14h

Bitfields for Connection CoProcessor connection status flags:
Bit(s)	Description	(Table 2690)
 7	hardware busy sending or receiving
 6	last page of data
 5	no data on current page
 4	retransmit request for current page being transmitted
 3	NSF (nonstandard file) mode active
 2-0	reserved

Bitfields for communications status:
Bit(s)	Description	(Table 2691)
 7	originating call
 6	FAX message to be sent
 5	on line
 4	ring detected and receive enabled
 3	buffer dumped on receive
 2-0	hardware sequence state
	000 idle
	001 dial
	010 answer
	011 transmit
	100 receive
	101 pre-message
	110 post-message
	111 disconnect

Bitfields for Connection CoProcessor hardware status:
Bit(s)	Description	(Table 2692)
 7	modem option installed
 6	Connection CoProcessor has control of DAA (not latched)
 5	on line (not latched)
 4	ring detected (not latched)
 3	data in command buffer (not latched)
 2	set if using DMA channel 1, clear if using DMA channel 3
 1	line length compensation 1 set (not latched)
 0	line length compensation 0 set (not latched)

Bitfields for Connection CoProcessor switch states:
Bit(s)	Description	(Table 2693)
 7	reserved
 6	unused
 5	spare switch open
 4	FAX ADR1 switch open
 3	FAX ADR0 switch open
 2	alternate interrupt switch open
 1	COM SEL 1 switch open
 0	COM SEL 0 switch open
Note:	valid combinations of 0-2 are
	000  COM2 IRQ3 IObase 2F8h
	001  COM1 IRQ4 IObase 3F8h
	010  COM4 IRQ3 IObase 2E8h
	011  COM3 IRQ4 IObase 3E8h
	110  COM4 IRQ2 IObase 2E8h
	111  COM3 IRQ5 IObase 3E8h

Bitfields for communications flags:
Bit(s)	Description	(Table 2694)
 7	reserved
 6	auxiliary relay forced ON
 5	modem select relay forced ON
 4	offhook relay forced ON
 3	9600 bps enabled
 2	7200 bps enabled
 1	4800 bps enabled
 0	2400 bps enabled

Bitfields for SatisFAXtion connection status flags:
Bit(s)	Description	(Table 2695)
 7	busy in T.30 CCITT fax protocol
 6	data on current page/file (only used for block xfers)
 5	retransmission of last page requested
 4	in file transfer mode
 3	data in buffer
 2	data buffer dumped on receive
 1	200x100 dpi resolution instead of 200x200 dpi
 0	data modem in use, FAX image modem not available

Bitfields for SatisFAXtion board state:
Bit(s)	Description	(Table 2696)
 7	reserved
 6	handset jack active, data and FAX modems not available
 5-3	current rate
	000  300 bps (V.21 HDLC)
	100 2400 bps (V.27 ter)
	101 4800 bps (V.27 ter)
	110 7200 bps (V.29)
	111 9600 bps (V.29)
 2-0	T.30 CCITT protocol state
	000 idle
	001 dialing
	010 answering
	011 transmitting
	100 receiving
	101 pre-message
	110 post-message
	111 disconnect
--------F-2FCB13DL00-------------------------
INT 2F - Communicating Applications Specification - GET DIAGNOSTICS RESULTS
	AX = CB13h
	DL = 00h
Return: AX = 0040h in progress
	   >= 0	   passed
	   < 0	   hardware-dependent failure code (see #2697,#2698)
SeeAlso: AX=CB13h/DL=01h

Bitfields for Intel Connection CoProcessor failure codes:
Bit(s)	Description	(Table 2697)
 3	9600 bps FAX modem module failed
 2	SDLC chip failed
 1	RAM failed
 0	ROM checksum failed

Bitfields for Intel SatisFAXtion failure codes:
Bit(s)	Description	(Table 2698)
 1	2400 bps data modem failed
 0	9600 bps FAX modem failed
--------F-2FCB13DL01-------------------------
INT 2F - Communicating Applications Specification - START DIAGNOSTICS
	AX = CB13h
	DL = 01h
Return: AX = 0000h successfully started
	AX < 0	   error code (see #2681)
SeeAlso: AX=CB13h/DL=00h
--------F-2FCB14-----------------------------
INT 2F - Communicating Applications Specification - MOVE RECEIVED FILE
	AX = CB14h
	BX = event handle
	CX = receive file number
	    0001h first received file
	    N	  Nth received file
	DS:DX -> ASCIZ string specifying new name for file (must not exist)
Return: AX = 0000h successful
	AX < 0	   error code (see #2681)
--------F-2FCB15-----------------------------
INT 2F - Communicating Applications Specification - SUBMIT FILE TO SEND
	AX = CB15h
	DS:DX -> variable-length data area (see #2699)
Return: AX >= 0 event handle
	AX < 0	error code (see #2681)
SeeAlso: AX=CB01h

Format of CAS file submission data area:
Offset	Size	Description	(Table 2699)
 00h	BYTE	transfer type
		00h = 200x200 dpi, fax mode
		01h = 100x200 dpi, fax mode
		02h = file transfer mode
		03h to 7Fh reserved
 01h	BYTE	text size
		00h = 80 columns
		01h = 132 columns
		02h to 7Fh reserved
 02h	WORD	time to send (DOS packed time, see #1317 at INT 21/AX=5700h)
 04h	WORD	date to send (DOS packed date, see #1318 at INT 21/AX=5700h)
 06h 32 BYTEs	ASCIZ destination name
 26h 80 BYTEs	ASCIZ name of file to send
 76h 47 BYTEs	ASCIZ phone number to dial
 A5h 64 BYTEs	ASCIZ application-specific tag string
 E5h	BYTE	reserved (00h)
 E6h	BYTE	cover page
		00h don't send cover page
		01h send cover page
		02h to 7Fh reserved
 E7h 23 BYTEs	reserved (zeros)
 FEh variable	ASCIZ string containing text of cover page (if cover page flag
		set to 01h)
--------F-2FCB16BX1234-----------------------
INT 2F - Communicating Applications Spec v1.2+ - UNLOAD RESIDENT MANAGER
	AX = CB16h
	BX = 1234h
	CX = 5678h
	DX = 9ABCh
Return: AX = 0000h successful
	AX < 0	   error code
Note:	the MTEZ XpressFax CASMGR ignores the values in BX,CX, and DX
SeeAlso: AX=C000h/BX=444Bh,AX=CB00h
Index:	uninstall;CAS Manager
--------F-2FCB17-----------------------------
INT 2F - Communicating Applications Spec v1.2+ - SET COVER PAGE STATUS
	AX = CB17h
	BX = event handle
	CL = cover page status
	    00h not read
	    01h read by user
Return: AX = 0000h successful
	AX < 0	   error code
--------F-2FCB80-----------------------------
INT 2F - Intel SatisFAXtion CASMGR - ???
	AX = CB80h
	???
Return: ???
--------F-2FCB81-----------------------------
INT 2F - Intel SatisFAXtion CASMGR - ???
	AX = CB81h
	???
Return: ???
--------F-2FCB82-----------------------------
INT 2F - Intel SatisFAXtion CASMGR - ???
	AX = CB82h
	???
Return: ???
--------F-2FCBDCBL56-------------------------
INT 2F - Comwave Microfax Specification - GET STATUS ARRAY
	AX = CBDCh
	BL = 56h
	BH = line number (starts with 1)
	CX:DX -> 32-byte status buffer or 80 character string
Return: AX = number of cards installed, or FFFFh on error
Program: Comwave manufacturers the Microfax line of fax cards which are a
	  high-performance multi-card FAX solution for OEMs.
Note:	defaults to AH=CBh but can be changed
SeeAlso: AX=CBDDh,AX=DA00h
--------F-2FCBDDBL56-------------------------
INT 2F - Comwave Microfax Specification - COMMAND SUBMISSION
	AX = CBDDh
	BL = 56h
	BH = ?
	CX:DX -> command to execute
Return: AX = status
	    0000h success
	    FFFFh on error
SeeAlso: AH=2Ah,AX=CBDCh,AX=80FBh
--------c-2FCC--SI5453-----------------------
INT 2F U - PC-Kwik Programs - API
	AH = CCh
	SI = 5453h or 7473h
	AL = function number (at least 00h,01h,04h,05h,07h,80h)
	DL = program identifier (see #2700)
Return: SI = 7473h
	other registers vary by function
Note:	Qualitas Qcache v4.00 is an OEM version of Super PC-Kwik v4.00, and
	  thus supports this call
SeeAlso: INT 21/AH=2Bh/CX=4358h

(Table 2700)
Values for PC-Kwik program identifier:
 00h	all installed PowerPak programs
 01h	SUPERPCK/SUPER/QCACHE v4.00+ (disk cache)
 02h	PCKSPL (print spooler)
 04h	PCKSCRN (screen accelerator)
 05h	PCKKEY (keyboard enhancer)
 06h	PCKRAMD (RAM disk)
 08h	PCKWIK.SYS
 10h	PCKCDROM (CD-ROM support for SUPERPCK)
--------N-2FCC00-----------------------------
INT 2F - Tsoft NFSDRVR - INSTALLATION CHECK
	AX = CC00h
Return: AX = 7777h
	BX = ???
	CX = ???
	DX = ???
	ES = data segment of resident portion
SeeAlso: AX=CC01h,AX=CC06h
--------N-2FCC01-----------------------------
INT 2F - Tsoft NFSDRVR - ???
	AX = CC01h
	???
Return: ???
SeeAlso: AX=CC00h
--------N-2FCC02-----------------------------
INT 2F - Tsoft NFSDRVR - ???
	AX = CC02h
	???
Return: ???
SeeAlso: AX=CC00h
--------N-2FCC03-----------------------------
INT 2F - Tsoft NFSDRVR - ???
	AX = CC03h
	???
Return: ???
SeeAlso: AX=CC00h
--------N-2FCC04-----------------------------
INT 2F - Tsoft NFSDRVR - ???
	AX = CC04h
	???
Return: ???
SeeAlso: AX=CC00h
--------N-2FCC05-----------------------------
INT 2F - Tsoft NFSDRVR - ???
	AX = CC05h
	???
Return: ???
SeeAlso: AX=CC00h
--------N-2FCC06-----------------------------
INT 2F - Tsoft NFSDRVR - ???
	AX = CC06h
	???
Return: ???
SeeAlso: AX=CC00h
--------P-2FCD00-----------------------------
INT 2F - Intel Image Processing Interface - INSTALLATION CHECK
	AX = CD00h
Return: AL = state
	    00h not installed, OK to install
	    01h not installed, not OK to install
	    FFh installed
SeeAlso: AX=CD02h"Image"
--------P-2FCD00-----------------------------
INT 2F - LaserPort Interface - INSTALLATION CHECK
	AX = CD00h
Return: AL = status
	    FFh installed
SeeAlso: AX=CD0Fh"LaserPort"
--------U-2FCD00-----------------------------
INT 2F - SWELL.EXE - INSTALLATION CHECK
	AX = CD00h
Return: AX = 00FFh installed
	    BH = major version
	    BL = minor version
Program: SWELL.EXE is a TSR which swaps programs to disk when they EXEC a
	  child process with INT 21/AH=4Bh
--------s-2FCD00BX464F-----------------------
INT 2F - Forte/Gravis ULTRAMID - INSTALLATION CHECK
	AX = CD00h
	BX = 464Fh ('FO')
	CX = 5254h ('RT')
	DX = 4520h ('E ')
Return: AL = FFh if installed
	    BX = 4155h ('AU')
	    CX = 4449h ('DI')
	    DX = 4F20h ('O ')
	    ES:SI -> program ID string
Program: ULTRAMID is a MIDI driver for the Gravis UltraSound which allows use
	  of AIL drivers with other software
Range:	AH=CDh-ECh, selected by scanning for an available multiplex number
SeeAlso: INT 21/AX=FD12h,AX=CD00h/DX=4957h
--------s-2FCD00DX4957-----------------------
INT 2F R - InterWave Game API - INSTALLATION CHECK
	AX = CD00h
	DX = 4957h ('IW')
	SI = 5645h ('VE')
Return: AL = FFh if installed
	    DX = 4554h ('ET')
	    SI = 454Bh ('EK')
Range:	AH=CDh-ECh, selected by scanning for an available multiplex number
SeeAlso: AX=CD00h/BX=464Fh,AX=CD01h"InterWave",AX=CD21h"InterWave"
SeeAlso: AX=CD80h"InterWave"
--------P-2FCD01-----------------------------
INT 2F - Intel Image Processing Interface - SET DEVICE NAME
	AX = CD01h
	CX:BX -> ASCIZ character device name ("LPTn", "COMn", "PRN")
Return: AL = status
	    00h successful
		CX:BX -> internal character device name
	    80h error
--------U-2FCD01-----------------------------
INT 2F - SWELL.EXE - SUSPEND ONCE
	AX = CD01h
Return: AX = 0000h
SeeAlso: AX=CD02h"SWELL"
--------s-2FCD01BX0000-----------------------
INT 2F R - InterWave Game API - GET NUMBER OF INTERWAVE PROGRAMS / PROGRAM ID
	AX = CD01h
	BX = 0000h
Return: BX = number of programs currently installed on the Game API
Desc:	get the number of programs supporting the InterWave Game API which are
	  currently installed in memory, which also forms the next program ID
	  number if the caller wishes to go resident on the API
Range:	AH=CDh-ECh, selected by scanning for an available multiplex number
Notes:	the first program to install on the IW Game API must use ID 00h
	the AMD-recommended implementation is for the handler to increment
	  BX and chain to the previous handler (if any), but this will fail
	  if TSRs are unloaded out-of-order
SeeAlso: AX=CD00h"InterWave",AX=CD02h"InterWave",AX=CD03h"InterWave"
SeeAlso: AX=CD05h"InterWave",AX=CD21h"InterWave",AX=CD80h"InterWave"
--------P-2FCD02-----------------------------
INT 2F - Intel Image Processing Interface - GET VERSION NUMBER
	AX = CD02h
Return: AL = status
	    00h/01h successful
		BH = major version number (BCD)
		BL = minor version number (BCD)
	    80h error
Note:	if return AL = 01h, the IPI supports network redirection
SeeAlso: AX=CD00h"Image"
--------U-2FCD02-----------------------------
INT 2F - SWELL.EXE - SUSPEND
	AX = CD02h
Return: AX = 0000h
SeeAlso: AX=CD03h"SWELL"
--------s-2FCD02-----------------------------
INT 2F R - InterWave Game API - GET PROGRAM STATUS AND INFORMATION
	AX = CD02h
	BX = program identifier
Return: CX = program status
	    bit 0: using synthesizer
	    bit 1: using Codec
	    bit 2: supports at least one Game Device (see AX=CD21h,AX=CD22h)
	BX = supported API version (BCD, BH=major, BL=minor) if CX bit 2 set
	ES:DI -> ASCIZ identification string
Range:	AH=CDh-ECh, selected by scanning for an available multiplex number
Note:	ordinarily, an application will loop through all valid program
	  identifiers (as returned by AX=CD01h); if any of the installed
	  programs conflicts with the use the caller wishes to make of the
	  InterWave chip, it should be disabled with AX=CD03h first
SeeAlso: AX=CD00h"InterWave",AX=CD01h"InterWave",AX=CD03h"InterWave"
SeeAlso: AX=CD05h"InterWave",AX=CD21h"InterWave",AX=CD80h"InterWave"
--------P-2FCD03-----------------------------
INT 2F - Intel Image Processing Interface - SELECT SCAN LINE
	AX = CD03h
	BX = scan line
	CX = requested density in dots per inch (300, 600, or 1200)
Return: AL = status (see also AX=CD04h"Image")
	    00h successful
		CX = density at which scan line was mapped
		ES:DI -> start of scan line
	    80h unsuccessful
	    81h scan line out of range
	    82h unsupported scan line density
	    83h out of memory
SeeAlso: AX=CD04h"Image"
--------U-2FCD03-----------------------------
INT 2F - SWELL.EXE - ACTIVATE
	AX = CD03h
Return: AX = 0000h
SeeAlso: AX=CD02h"SWELL"
--------s-2FCD03-----------------------------
INT 2F R - InterWave Game API - SUSPEND PROGRAM
	AX = CD03h
	BX = installed program identifier
	CX = InterWave section to be released
	    0000h all
	    0001h synthesizer
	    0002h Codec
Return: AL = status
	    00h successful
		BX = base port
		CL = IRQ
		CH = DMA channel (Codec only)
	    else failed
SeeAlso: AX=CD00h"InterWave",AX=CD01h"InterWave",AX=CD02h"InterWave"
SeeAlso: AX=CD04h"InterWave",AX=CD21h"InterWave",AX=CD80h"InterWave"
--------P-2FCD04-----------------------------
INT 2F - Intel Image Processing Interface - MOVE BITMAP TO SCANLINE
	AX = CD04h
	CX:BX -> structure (see #2702)
Return: AL = status (see #2701)
SeeAlso: AX=CD03h"Image"

(Table 2701)
Values for IPI function status:
 00h	successful
 80h	unsuccessful
 81h	scan line out of range
 82h	unsupported scan line density
 83h	out of memory
 84h	unrecognized source
 85h	initialization error

Format of structure:
Offset	Size	Description	(Table 2702)
 00h	WORD	image source (0 = conventional memory, 1 = expanded memory)
 02h	DWORD	pointer to image data
 06h	WORD	scan line on which to place
 08h	WORD	bit offset from start of scan line at which to place
 0Ah	WORD	density of bitmap data (300, 600, or 1200 dpi)
 0Ch	WORD	width in bits of data
 0Eh	WORD	source logical page number
 10h	WORD	source handle (only if source in expanded memory)
 12h	WORD	source offset (only if source in expanded memory)
--------U-2FCD04-----------------------------
INT 2F - SWELL.EXE - TURN OFF VERBOSE MODE
	AX = CD04h
Return: AX = 0000h
SeeAlso: AX=CD05h"SWELL"
--------s-2FCD04-----------------------------
INT 2F R - InterWave Game API - WAKE PROGRAM
	AX = CD04h
	BX = installed program identifier
Return: AL = status
	    00h successful
	    else failed
Note:	this function should only be called after the program has been
	  suspended with AX=CD03h
SeeAlso: AX=CD00h"InterWave",AX=CD01h"InterWave",AX=CD03h"InterWave"
SeeAlso: AX=CD05h"InterWave",AX=CD21h"InterWave",AX=CD80h"InterWave"
SeeAlso: INT 7E/AL=84h"IWSBSDRV"
--------P-2FCD05-----------------------------
INT 2F - Intel Image Processing Interface - PRINT PAGE
	AX = CD05h
Return: AL = status (00h,80h) (see #2701)
Note:	page image is retained, so multiple calls will print multiple copies of
	  the page
SeeAlso: AX=CD06h"Image"
--------U-2FCD05-----------------------------
INT 2F - SWELL.EXE - TURN ON VERBOSE MODE
	AX = CD05h
Return: AX = 0000h
SeeAlso: AX=CD04h"SWELL"
--------s-2FCD05-----------------------------
INT 2F R - InterWave Game API - UNINSTALL RESIDENT DEVICE DRIVER
	AX = CD05h
	BX = installed program identifier
Return: AL = status
	    00h successful
	    else failed
SeeAlso: AX=CD00h"InterWave",AX=CD01h"InterWave",AX=CD02h"InterWave"
SeeAlso: AX=CD03h"InterWave",AX=CD21h"InterWave",AX=CD80h"InterWave"
--------P-2FCD06-----------------------------
INT 2F - Intel Image Processing Interface - CLEAR PAGE
	AX = CD06h
Return: AL = status (00h,80h) (see #2701)
Note:	palette is reset to default
SeeAlso: AX=CD09h"Image"
--------U-2FCD06-----------------------------
INT 2F - SWELL.EXE - UNINSTALL
	AX = CD06h
Return: AX = status
	    0000h uninstalled
	    8002h programs still swapped, not uninstalled
--------P-2FCD07-----------------------------
INT 2F - Intel Image Processing Interface - reserved
	AX = CD07h
SeeAlso: AX=CD00h"Image"
--------U-2FCD07-----------------------------
INT 2F - SWELL.EXE - GET INFO
	AX = CD07h
	ES:BX -> 32-byte buffer for info (see #2703)
Return: AX = status
	    0000h successful
		ES:BX buffer filled
	    8001h buffer wrong size

Format of SWELL.EXE info buffer:
Offset	Size	Description	(Table 2703)
 00h	WORD	20h  (total size of buffer)
 02h	BYTE	suspend-once mode active if nonzero
 03h	BYTE	00h active, 01h suspended
 04h	BYTE	00h quiet, 01h verbose
 05h	BYTE	"Borland support" (allowing INT 21/AX=4B01h) on if nonzero
 06h 26 BYTEs	unused???
--------P-2FCD08-----------------------------
INT 2F - Intel Image Processing Interface - SCREEN IMAGE
	AX = CD08h
	CX:BX -> structure (see #2704)
Return: AL = status (00h,80h-85h) (see #2701)
SeeAlso: AX=CD05h"Image",AX=CD09h"Image"

Format of IPI screen image structure:
Offset	Size	Description	(Table 2704)
 00h	WORD	image source (0 = conventional memory, 1 = expanded memory)
 02h	DWORD	pointer to image data
 06h	WORD	horizontal position on paper of left edge (in 1200 dpi units)
 08h	WORD	vertical position on paper of top edge (in 1200 dpi units)
 0Ah	WORD	left cropping (currently must be zero)
 0Ch	WORD	top cropping (currently must be zero)
 0Eh	WORD	width (currently must be 8000h)
 10h	WORD	height (currently must be 8000h)
 12h	WORD	horizontal size of image in 1200 dpi units
 14h	WORD	vertical size of image in 1200 dpi units
 16h	WORD	aspect ratio (currently reserved)
 18h	WORD	initialization flag (if 01h, initialization is performed)
 1Ah	WORD	pixels per line of source data
 1Ch	WORD	number of scan lines in source data
 1Eh	WORD	number of scan lines in packet
 20h	WORD	bits per pixel (1,2,4,6, or 8)
 22h	WORD	pixels per byte (1,2,4, or 8)
 24h	WORD	compression type (currently only 00h [uncompressed] supported)
 26h	WORD	source page number (if in expanded memory)
 28h	WORD	source handle (if in expanded memory)
 2Ah	WORD	source offset (if in expanded memory)
--------U-2FCD08-----------------------------
INT 2F - SWELL.EXE - UNUSED
	AX = CD08h
Return: AX = FFFFh (error)
--------P-2FCD09-----------------------------
INT 2F - Intel Image Processing Interface - LOAD SCREEN
	AX = CD09h
	CX:BX -> structure (see #2705)
Return: AL = status (00h,80h) (see #2701)
SeeAlso: AX=CD06h"Image Processing",AX=CD0Ah"Image Processing"

Format of IPI load screen structure:
Offset	Size	Description	(Table 2705)
 00h	BYTE	style
		44h ('D') diamond style
		4Ch ('L') line style
 01h	BYTE	reserved (00h)
 02h	WORD	frequency in lines per inch [sic]
		currently, coerced to nearest of 50, 60, 68, 70, 75, 85, or 100
 04h	WORD	screen angle in degrees (-360 to 360)
		currently coerced to nearest of -45, 0, 45, or 90
--------U-2FCD09-----------------------------
INT 2F - SWELL.EXE - TURN OFF "BORLAND SUPPORT"
	AX = CD09h
Return: AX = 0000h
SeeAlso: AX=CD0Ah"SWELL"
--------P-2FCD0A-----------------------------
INT 2F - Intel Image Processing Interface - LOAD PALETTE
	AX = CD0Ah
	CX:BX -> palette structure (see #2706)
Return: AL = status (00h,80h) (see #2701)
SeeAlso: AX=CD09h"Image Processing"

Format of IPI palette structure:
Offset	Size	Description	(Table 2706)
 00h	BYTE	bits per pixel for which palette is to be used (1,2,4,6, or 8)
 01h	2**N	palette translation values, one per possible pixel value
--------U-2FCD0A-----------------------------
INT 2F - SWELL.EXE - TURN ON "BORLAND SUPPORT"
	AX = CD0Ah
Return: AX = 0000h
SeeAlso: AX=CD09h"SWELL"
--------P-2FCD0F-----------------------------
INT 2F - LaserPort Interface - EXECUTE FUNCTION
	AX = CD0Fh
	BL = function
		01h enable
		02h disable
		03h ???
Return: AL = status
	    00h success
SeeAlso: AX=CD00h"LaserPort"
--------s-2FCD21-----------------------------
INT 2F R - InterWave Game API - OPEN GAME DEVICE
	AX = CD21h
	BX = installed program identifier
	ES:DI -> ASCIZ device name
	    "MIDISIMPLE"
	    "MIDICOMPLEX"
	    "DIRECTCODEC"
Return: AL = status
	    00h successful
		DX = device handle
		---MIDISIMPLE and MIDICOMPLEX---
		BX = real-mode interrupt number (see #2707,#2708)
		---DIRECTCODEC---
		BX = base port
		CL = IRQ
		CH = DMA channel (04h = no DMA)
		SI = size of FIFO in bytes (0000h = use DMA)
	    nonzero failed (not supported or already in use)
	AH may be destroyed
Range:	AH=CDh-ECh, selected by scanning for an available multiplex number
SeeAlso: AX=CD00h"InterWave",AX=CD01h"InterWave",AX=CD02h"InterWave"
SeeAlso: AX=CD05h"InterWave",AX=CD22h"InterWave",AX=CD80h"InterWave"

(Table 2707)
Call MIDISIMPLE with:
	EAX = function number
	    0001h MIDI byte out
		BL = MIDI byte to send
	    0002h MIDI string out
		ECX = length of MIDI string in bytes
		ES:EDI -> MIDI string to send (should not include timing info)
	DX = device handle
	INT xxh (as returned by AX=CD21h)
Return: EAX = status
	    00000000h if successful
	    FFFFFFFFh on error (bad handle)
SeeAlso: #2708,INT 7E/AX=0001h"IWSBSDRV",INT 7E/AX=0002h"IWSBSDRV"

(Table 2708)
Call MIDICOMPLEX with:
	EAX = function number
	    ??? (specification is still in development)
	DX = device handle
	INT xxh (as returned by AX=CD21h)
Return: EAX = status
	    00000000h if successful
	    FFFFFFFFh on error (bad handle)
SeeAlso: #2707
--------s-2FCD22-----------------------------
INT 2F R - InterWave Game API - CLOSE GAME DEVICE
	AX = CD22h
	BX = installed program identifier
	DX = device handle (from AX=CD21h)
Return: AL = status
	    00h successful
	    FFh inavlid handle or device is not open
Range:	AH=CDh-ECh, selected by scanning for an available multiplex number
SeeAlso: AX=CD00h"InterWave",AX=CD01h"InterWave",AX=CD02h"InterWave"
SeeAlso: AX=CD05h"InterWave",AX=CD21h"InterWave",AX=CD80h"InterWave"
--------s-2FCD80-----------------------------
INT 2F RC - InterWave Game API - MIXER SETTINGS CHANGED BROADCAST
	AX = CD80h
Return: nothing
Desc:	called by an application controlling the InterWave chip's mixer
	  whenever the mixer's settings are changed
Range:	AH=CDh-ECh, selected by scanning for an available multiplex number
Note:	when an application intercepts this function call, it must read the
	  new mixer settings from the InterWave chip
SeeAlso: AX=CD00h"InterWave",AX=CD01h"InterWave",AX=CD02h"InterWave"
SeeAlso: AX=CD05h"InterWave",AX=CD21h"InterWave",AX=CD22h"InterWave"
--------K-2FCF00-----------------------------
INT 2F - TEMPLEXX 1.0 - INSTALLATION CHECK
	AX = CF00h
Return: AL = FFh if installed
Program: TEMPLEXX is a popup keyboard template by Henson Scientific, Inc.
Note:	values in AL other than 00h cause an immediate return without modifying
	  any registers
--------G-2FD000-----------------------------
INT 2F C - MDEBUG display driver - GET DRIVER STATUS
	AX = D000h
Return: CF set on error
	    all other registers must be unchanged)
	CF clear if successful
	    AL = FFh
	    AH = driver semaphor
		00h driver is not active
		01h driver is active
	    BX = CS of the driver
	    CX = driver version (CH = major, CL = minor, must be >= 013Ch)
	    DL = buffer semaphor
		00h driver is not pending
		01h driver is pending between functions 02h and 03h
	    DH = show semaphor
		00h driver is not pending
		01h driver is pending between functions 04h and 05h
Program: MDEBUG is a shareware memory-resident debugging tool by Bernd
	  Schemmer, including a memory monitor, an interpreter and a
	  disassembler
Range:	AH=C0h to AH=FFh, selected by switch or programmatically
Notes:	MDEBUG can use any two consecutive multiplex numbers between C0h and
	  FFh; the default is D0h for the display driver and D1h for the
	  command driver (call INT 60/AH=00h"MDEBUG" for the actual multiplex
	  numbers used)
	this function MUST be reentrant, as MDEBUG calls it after every popup
	  before any other actions.  The handler should not change any
	  registers if the display is in an unsupported mode or in a mode
	  MDEBUG supports itself, e.g. a normal text mode with at least 80x25
	  characters (i.e. 80x43 or 132x44 (v1.60+)). In this case MDEBUG will
	  not call any of the other functions for this popup session.
	MDEBUG will not call the other functions if the returned version is
	  less than the actual version of MDEBUG.
	if the driver is reentrant, DL and DH should be 00h
SeeAlso: AX=D001h,AX=D002h,AX=D003h,AX=D004h,AX=D005h
--------M-2FD000-----------------------------
INT 2F - ZWmous - INSTALLATION CHECK
	AX = D000h
Return: AX = 5A57h ("ZW") if installed
	    BX = segment of resident code
Program: ZWmous is a shareware TSR by Zen Wu which permits the use of a mouse
	  with many non-mouse applications by entering the letter under the
	  mouse cursor on button presses
SeeAlso: INT 33/AX=0003h
--------N-2FD000-----------------------------
INT 2F - Lotus CD/Networker - INSTALLATION CHECK
	AX = D000h
Return: AL = FFh if CD/Networker TSR is loaded
	BX = 4D44h ("MD") signature
	CX = Windows mode word (from INT 2F/AX=1600h) at time of TSR load
	DX = bitmap identifying all loaded CD/Networker TSRs.
Notes:	INT 2F/AH=D0h is used by CD/Networker to communicate between a
	  resident redirector TSR and a transient program that controls the
	  TSR's CD-ROM drive emulation (volume attachments, caching, etc).
	At present there is only one CD/Networker TSR; the bitmap always = 4.
SeeAlso: AX=D002h"Lotus",INT 2F/AX=1500h"CD-ROM"
--------G-2FD001-----------------------------
INT 2F C - MDEBUG display driver - INITIALIZE DRIVER
	AX = D001h
Return: CF set on error
	AL = driver semaphor
	AH = buffer semaphor
Range:	AH=C0h to AH=FFh, selected by switch or programmatically
Notes:	MDEBUG calls this function after every successful call of the function
	  00h. The function should reset all internal data and the status of
	  the driver. If this function returns an error, MDEBUG will not call
	  the other functions in this popup session.
	MDEBUG can use any two consecutive multiplex numbers between C0h and
	  FFh; the default is D0h for the display driver and D1h for the
	  command driver
SeeAlso: AX=D000h
--------G-2FD002-----------------------------
INT 2F C - MDEBUG display driver - SAVE GRAPHIC DATA
	AX = D002h
Return: CF set on error
	CF clear if successful
	    display memory saved and display switched to one of the text modes
	      02h, 03h or 07h.
Note:	MDEBUG calls this function only once every popup session before
	  displaying its windows.
SeeAlso: AX=D000h,AX=D003h
--------N-2FD002BX4D44-----------------------
INT 2F - Multiplex - Lotus CD/Networker GET DATA AREA
	AX = D002h
	BX = 4D44h
	DX = bitmap identifying one loaded CD/Networker TSR
Return: ES:DI -> data area owned by TSR
Note:	the format of the data area changes with each minor revision, so it
	  cannot be counted on
SeeAlso: AX=D000h"Lotus"
--------G-2FD003-----------------------------
INT 2F C - MDEBUG display driver - RESTORE GRAPHIC DATA
	AX = D003h
Return: CF set on error
	CF clear if successful
	    display restored to the mode it was in before calling AX=D002h and
	      the display memory is restored
Note:	MDEBUG calls this function only once every popup session just before
	 it exits to normal DOS.
SeeAlso: AX=D000h,AX=D002h
--------G-2FD004-----------------------------
INT 2F - MDEBUG display driver - SHOW SAVED DATA
	AX = D004h
Return: CF set on error
	CF clear if successful
	    display switched to mode it was in before calling AX=D002h and the
	      display memory is restored
Note:	This function needn't save the display memory before changing it.
SeeAlso: AX=D000h,AX=D005h
--------G-2FD005-----------------------------
INT 2F - MDEBUG display driver - SWITCH BACK TO TEXT SCREEN
	AX = D005h
Return: CF set on error
	CF clear if successful
	    display restored to mode it was in before calling AX=D004h
Note:	This function needn't save or change the display memory
SeeAlso: AX=D000h,AX=D004h
--------G-2FD0-------------------------------
INT 2F - MDEBUG display driver - RESERVED FUNCTION NUMBERS
	AH = D0h
	AL = 06h-7Fh
Note:	these functions are reserved for future use
--------G-2FD0-------------------------------
INT 2F - MDEBUG display driver - USER DEFINED FUNCTION NUMBERS
	AH = D0h
	AL = 80h-FFh
Note:	these functions numbers are reserved for user defined features (e.g.
	  communication between the transient und resident parts of the driver)
--------G-2FD100-----------------------------
INT 2F C - MDEBUG command driver - GET STATUS
	AX = D100h
	BX = version of MDEBUG (BH = major, BL = minor)
	CX = command driver counter
---v1.60+---
	DS:SI -> MDEBUG identification table (see #2709)
	ES = segment of display memory used by MDEBUG
	DI = size of video mode used by MDEBUG
	    (high byte = lines, low byte = columns)
Return: DL = FFh
	BX = version number of the driver if it is less than the version in BX,
	      else unchanged
	CX incremented
Program: MDEBUG is a shareware memory-resident debugging tool by Bernd
	  Schemmer, including a memory monitor, an interpreter, and a
	  disassembler
Range:	AH=C0h to AH=FFh, selected by switch or programmatically
Notes:	called by MDEBUG at start of popup session; if the version number
	  returned in BX is less than 1.52 (1.60 for MDEBUG v1.70), MDEBUG will
	  not call any of the other functions during this popup session
	MDEBUG can use any two consecutive multiplex numbers between C0h and
	  FFh; the default is D0h for the display driver and D1h for the
	  command driver (call INT 60/AH=00h"MDEBUG" for the multiplex numbers
	  actually used)
	this function must end with a far call to the old INT 2F handler after
	  changing the registers
	this function MUST be reentrant
	command drivers must also declare the following data at the given
	  offsets in the code segment
		100h  3 BYTEs	JMP-command in .COM-files
		103h	BYTE	NOP-command (90h)
		104h 26 BYTEs	signature "Kommandotreiber fÅr MDEBUG"
		11Eh 12 BYTEs	name of driver, e.g. "MDHISDRV.COM"
				each driver must have a unique name
	MDEBUG will pass every key and command to the command driver(s) before
	  checking for a valid internal command
SeeAlso: AX=D000h,AX=D101h

Format of MDEBUG identification table:
Offset	Size	Description	(Table 2709)
 -2	WORD	entry offset
 00h	WORD	CS of MDEBUG
 02h	DWORD	old INT 08h vector
 06h	DWORD	old INT 09h vector
 0Ah	DWORD	address INT 16h routine used by MDEBUG
 0Eh	BYTE	length of version string
 0Fh  N BYTEs	version string
--------G-2FD101-----------------------------
INT 2F - MDEBUG command driver - INITIALIZE DRIVER
	AX = D101h
	CX = command driver counter
Return: DL = status
	    FFh if successful
		CX incremented
	    else error: all registers unchanged
Note:	this function must end with a  far call to the old INT 2F handler after
	  changing the registers
	this function must be reentrant
--------G-2FD102-----------------------------
INT 2F - MDEBUG command driver - EXECUTE INTERPRETER COMMAND
	AX = D102h
	BL = first character of the interpreter command
	BH = last character of the interpreter command (or blank)
	DS:SI -> parameter for the interpreter command as ASCIZ string
	DS:DI -> MDEBUG data structure (see #2711)
Return: AL = FFh
	CF set on error
	    AH = error number (see #2710)
	    DS:SI -> ASCIZ error message (max 30 characters) if AH=0Ch
	CF clear if successful
	    AH = return code
		00h continue processing the command line
		01h leave MDEBUG popup session
		02h leave MDEBUG popup session and automatically popup again
		      if the InDOS flag is zero
		03h not used (same as 00h)
		04h not used (same as 00h)
		05h put new command line into the input buffer,
		    DS:SI -> new command line (ASCIZ string, max 66 chars)
		06h process new command line
		    DS:SI -> new command line (ASCIZ string, max 66 chars)
	       else unknown status, but continue processing commmand line
Note:	this function must end with a far call to the old INT 2F handler (with
	  registers unchanged) if the driver does not support the interpreter
	  command in BX.  Otherwise, the driver must not chain to the old
	  INT 2F.

(Table 2710)
Values for MDEBUG error number:
 01h	syntax error
 02h	first shell of the command.com is activ
 03h	Esc pressed
 04h	break pressed
 05h	DOS is busy
 06h	command ended
 07h	division by zero
 08h	invalid display driver
 09h	invalid command driver
 0Ah	error 8 and 9
 0Bh	unknown error
 0Ch	new error
 else	unknown error

Format of MDEBUG data structure:
Offset	Size	Description	(Table 2711)
 00h	WORD	register SE
 02h	WORD	register OF
 04h	WORD	register FS
 06h	WORD	register FO
 08h	WORD	register AX
 0Ah	WORD	register BX
 0Ch	WORD	register CX
 0Eh	WORD	register DX
 10h	WORD	register SI
 12h	WORD	register DI
 14h	WORD	register DS
 16h	WORD	register ES
 18h	WORD	register BP
 1Ah	WORD	register SS
 1Ch	WORD	register SP
 1Eh	WORD	register FL (flags)
 20h	WORD	register R0
 22h	WORD	register R1
 24h	WORD	register R2
 26h	WORD	register R3
 28h	WORD	register R4
 2Ah	WORD	register R5
 2Ch	WORD	register R6
 2Eh	WORD	register R7
 30h	WORD	register R8
 32h	WORD	register CS, return-address
 34h	WORD	register IP, return-address
 36h	DWORD	saved pointer to data for key <F6> (v1.60)
		saved monitor address (v1.70)
 3Ah 12 WORDs	saved register values on last popup entry (for <F8> key)
		(original register values at popup entry of MDEBUG)
		AX, BX, CX, DX, SI, DI, DS, ES, BP, SS, SP, flags
 52h 12 WORDs	saved register values on last popup exit (for <SHIFT-F8> key)
		AX, BX, CX, DX, SI, DI, DS, ES, BP, SS, SP, flags
 6Ah	DWORD	address of the DOS-invars-table
 6Eh	DWORD	address of the InDOS flag
 72h	WORD	offset of the register which is used for the segment of the
		  first monitor window
 74h	WORD	offset of the register which is used for the offset of the
		  first monitor window
 76h	WORD	name of the register which is used for the segment of the
		  first monitor segment
 78h	WORD	name of the register which is used for the offset of the first
		  monitor window
 7Ah	WORD	pseudo register 1
 7Ch	WORD	pseudo register 2
--------G-2FD103-----------------------------
INT 2F - MDEBUG command driver - EXECUTE KEY IN THE MONITOR
	AX = D103h
	BX = key code (like result of an interrupt 16h call)
	CX = cursor position
	    0000h in the ASCII column of the monitor
	    0001h in one of the hex fields of the monitor
	DS:SI -> MDEBUG data structure (see #2711)
	ES:DI -> actual byte in the monitor
Return: AL = FFh
	AH = return code
	    00h key processed, read next key
	    01h leave MDEBUG popup session
	    02h leave MDEBUG popup session and automatically popup again if DOS
		  is not busy
	    03h signal an error (beep)
	    04h driver has redefined the key, proceed with the new key
		BX = new key code
		MDEBUG will not pass the new key to the command driver(s)
	   else treat like code 00h
Note:	this function must end with a far call to the old INT 2F handler (with
	  registers unchanged) if the driver does not support the key in BX.
	  Otherwise, the driver must not chain to the old INT 2F.
SeeAlso: AX=D104h
--------G-2FD104-----------------------------
INT 2F - MDEBUG command driver - EXECUTE KEY IN THE INTERPRETER
	AX = D104h
	DS:SI -> MDEBUG data structure (see #2711)
Return: AL = FFh
	AH = return code
	    00h key processed, read next key
	    01h leave MDEBUG popup session
	    02h leave MDEBUG popup session and automactically popup again if
		  DOS is not busy
	    03h signal an error (beep)
	    04h driver has redefined the key, proceed with the new key
		BX = new key code
		MDEBUG won't pass the new key to the command driver(s)
	    05h put new command line into the input buffer
		DS:SI -> new command line (ASCIZ string, max 66 chars)
	    06h process new command line
		DS:SI -> new command line (ASCIZ string, max 66 chars)
	   else treat like code 00h
Note:	this function must end with a far call to the old INT 2F handler if the
	  driver does not support the key in BX.  Otherwise, the driver must
	  not chain to the old INT 2F.
SeeAlso: AX=D103h
--------G-2FD1-------------------------------
INT 2F - MDEBUG command driver - RESERVED FUNCTIONS
	AH = D1h
	AL = 05h-0Ah
Note:	these functions are reserved for future use
--------G-2FD110-----------------------------
INT 2F - MDEBUG command driver - GET ADDRESS OF THE OLD INT 2F
	AX = D110h
Return: DL = FFh
	ES:BX -> next program in the chain for INT 2F
	CX = code segment of this driver
	DI = offset of driver identification table (see #2712) (v1.60+)
Notes:	only called by the transient part of the driver
	must be reentrant and the driver must not chain this function to the
	  old INT 2F

Format of the MDEBUG driver identification table:
Offset	Size	Description	(Table 2712)
 00h  26 BYTEs	 signature "Kommandotreiber fÅr MDEBUG"
					     ^- Note: ASCII 129,German U-umlaut
 27h  12 BYTEs	 name of driver, e.g. "MDHISDRV.COM"
		 each driver must have a unique name
--------G-2FD111-----------------------------
INT 2F - MDEBUG command driver - START DRIVER
	AX = D111h
Return: DL = FFh
Notes:	only called by the transient part of the driver to inform the resident
	  part that it is installed
	the function must be reentrant and the driver mustn't chain this
	  function to the old INT 2F
SeeAlso: AX=D101h,AX=D112h
--------G-2FD112-----------------------------
INT 2F - MDEBUG command driver - END DRIVER
	AX = D112h
Return: DL = FFh
Notes:	only called by the transient part of the driver to inform the resident
	  part that it will be released after this function
	the function must be reentrant and the driver mustn't chain this
	  function to the old INT 2F
SeeAlso: AX=D101h,AX=D111h
--------G-2FD1-------------------------------
INT 2F - MDEBUG command driver - RESERVED FUNCTIONS
	AH = D1h
	AL = 13h-7Fh
Note:	these functions are reserved for future use
--------G-2FD1-------------------------------
INT 2F - MDEBUG command driver - USER DEFINED FUNCTIONS
	AH = D1h
	AL = 80h-FFh
Note:	these functions are reserved for user defined features (e.g.
	  communication between the transient und resident parts of the driver)
--------U-2FD200-----------------------------
INT 2F - PCL-838.EXE - INSTALLATION CHECK
	AX = D200h
Return: AL = FFh if installed??? (documented as AX = return value)
Program: PCL-838 is a resident utility for controlling a stepmotor adapter
	  board by Advantec
SeeAlso: AX=D201h"PCL-838",AX=D202h"PCL-838"
--------Q-2FD200BX5144-----------------------
INT 2F - Quarterdeck RPCI - INSTALLATION CHECK
	AX = D200h
	BX = 5144h ("QD")
	CX = 4D45h ("ME")
	DX = 4D30h ("M0")
Return: AL = FFh installed
	if BX,CX,DX registers were as specified on entry:
	    BX = 4D45h ("ME")
	    CX = 4D44h ("MD")
	    DX = 5652h ("VR")
Range:	AH=C0h to AH=FFh, selected by scanning AH=D2h-FFh, then AH=C0h-D1h
Notes:	the Quarterdeck RPCI (Resident Program Communication Interface) is
	  supported by QEMM v5.0+, QRAM, MANIFEST, VIDRAM, etc.
	for AL <> 0, if the BX/CX/DX values don't match the identifier of a
	  Quarterdeck product, it just chains to the previous INT 2F handler
SeeAlso: AX=D201h/BX=4849h,AX=D201h/BX=4D41h,AX=D201h/BX=4D45h
SeeAlso: AX=D201h/BX=5145h,AX=D201h/BX=5649h
--------U-2FD201-----------------------------
INT 2F - PCL-838.EXE - UNINSTALL
	AX = D201h
Return: AX = return value
SeeAlso: AX=D200h"PCL-838",AX=D202h"PCL-838"
--------m-2FD201BX4849-----------------------
INT 2F - Quarterdeck RPCI - GET QD HIMEM PRESENCE
	AX = D201h
	BX = 4849h ("HI")
	CX = 4D45h ("ME")
	DX = 4D51h ("MQ")
Return: BX = 4F4Bh ("OK")
	ES:DI -> HIMEM entry point
Range:	AH=C0h to AH=FFh, selected by scanning AH=D2h-FFh, then AH=C0h-D1h
SeeAlso: AX=D200h,AX=D201h/BX=5145h
--------m-2FD201BX4849-----------------------
INT 2F - Quarterdeck RPCI - QEMM/QRAM v5.0+ - GET HIRAM MEMORY CHAIN
	AX = D201h
	BX = 4849h ("HI")
	CX = 5241h ("RA")
	DX = 4D30h ("M0")
Return: BX = 4F4Bh ("OK")
	CX = segment of start of HIRAM chain
	DX = reserved block owner (QEMM/QRAM code segment)
Range:	AH=C0h to AH=FFh, selected by scanning AH=D2h-FFh, then AH=C0h-D1h
Note:	the HIRAM memory chain has the same format as the regular DOS 4.0
	  memory chain (see #1280 at INT 21/AH=52h), except that XMS Upper
	  Memory Blocks have the block header program name field set to
	  "UMB"; blocks whose "owner" field is set to the reserved segment
	  returned in DX are locked-out regions such as video memory and ROMs.
SeeAlso: AX=12FFh/BX=0006h,AX=D200h
--------G-2FD201BX4D41-----------------------
INT 2F U - Quarterdeck RPCI - MANIFEST v1.0+ - INSTALLATION CHECK
	AX = D201h
	BX = 4D41h ("MA")
	CX = 4E49h ("NI")
	DX = 4645h ("FE")
Return: BX = 5354h ("ST") if installed
Range:	AH=C0h to AH=FFh, selected by scanning AH=D2h-FFh, then AH=C0h-D1h
SeeAlso: AX=D200h
--------E-2FD201BX4D45-----------------------
INT 2F U - Quarterdeck RPCI - DVDOS4GX.DVR - ???
	AX = D201h
	BX = 4D45h ("ME")
	CX = 5155h ("QU")
	DX = 5044h ("PD")
Return: AL = FFh
	BX = 4F4Bh ("OK")
Range:	AH=C0h to AH=FFh, selected by scanning AH=D2h-FFh, then AH=C0h-D1h
Note:	this function is called by QEMM 6.03
	performs a variety of actions before setting return registers
SeeAlso: AX=D200h
--------m-2FD201BX5145-----------------------
INT 2F - Quarterdeck RPCI - QEMM v5.0+ - INSTALLATION CHECK
	AX = D201h
	BX = 5145h ("QE")
	CX = 4D4Dh ("MM")
	DX = 3432h ("42")
Return: BX = 4F4Bh ("OK")
	ES:DI -> QEMM API entry point (see INT 67/AH=3Fh)
Range:	AH=C0h to AH=FFh, selected by scanning AH=D2h-FFh, then AH=C0h-D1h
Note:	this call is not available under QEMM v6.00 unless Windows3 support
	  has been disabled with the NW3 switch to QEMM386.SYS
SeeAlso: AX=D200h,AX=D201h/BX=4849h,INT 67/AH=3Fh
--------V-2FD201BX5649-----------------------
INT 2F u - Quarterdeck RPCI - VIDRAM v5.0+ - INSTALLATION CHECK
	AX = D201h
	BX = 5649h ("VI")
	CX = 4452h ("DR")
	DX = 414Dh ("AM")
Return: BX = 4F4Bh ("OK")
	ES:DI -> VIDRAM entry point (see #2713)
Range:	AH=C0h to AH=FFh, selected by scanning AH=D2h-FFh, then AH=C0h-D1h
SeeAlso: AX=D200h

(Table 2713)
Call VIDRAM entry point with:
	AH = 00h get status
		Return: AL = VIDRAM state (see #2714)
			BL = extra RAM status (see #2715)
			BH = feature flags (see #2716)
			CL = current monitor (01h = mono, 80h = color)
			SI = current top of memory (paragraph)
			DI = segment of start of HiRAM chain
	AH = 01h setup
		AL = VIDRAM state (see #2714)
		BL = extra RAM status (see #2715)
		BH = feature flags (see #2716)
		CL = monitor (01h = monochrome, 80h = color)
		SI = new top of memory (paragraph)
		DI = segment of start of HiRAM chain
	AH = 02h get end address of VIDRAM code
		Return: ES:DI -> VIDRAM partial map context (see #2717,#2718)
Return: CF set on error
	CF clear if successful

(Table 2714)
Values for VIDRAM state:
 00h	off
 01h	no EGA graphics
 02h	no graphics at all

(Table 2715)
Values for VIDRAM extra RAM status:
 00h	VIDRAM does not use extra RAM
 01h	VIDRAM uses EMS as extra RAM
 02h	VIDRAM uses EGA as extra RAM

Bitfields for VIDRAM feature flags:
Bit(s)	Description	(Table 2716)
 0	override enabled
 1	mapped memory detected in A000h-B000h range
 2	top of memory not at 640K
 3	MDA detected
 4	high RAM exists in video area
 5	mapped memory detected in video area
 6-7	reserved???

Format of VIDRAM partial map context (EMS 3.2):
Offset	Size	Description	(Table 2717)
 00h	BYTE	EMS version ID (32h)
 01h	WORD	EMM handle for this entry
 03h	BYTE	number of frames
 04h	BYTE	first page frame
 05h	WORD	offset from ES to previously saved map

Format of VIDRAM partial map context (EMS 4.0):
Offset	Size	Description	(Table 2718)
 00h	BYTE	EMS version ID (40h)
 01h	WORD	mappable segment count
 03h  N WORD	mappable segments
	WORD	offset to previously saved map???
--------U-2FD202-----------------------------
INT 2F - PCL-838.EXE - EXECUTE PCL838 COMMANDS
	AX = D202h
	CX:BX -> parameter table
Return: AX = return value
SeeAlso: AX=D200h"PCL-838",AX=D201h"PCL-838"
--------R-2FD300BX4562-----------------------
INT 2F U - TeleReplica - INSTALLATION CHECK
	AX = D300h
	BX = 4562h
	CX = 2745h
	DX = serial port I/O base address??? (03F8h for v3.9)
Return: SI = segment of resident code
	AX = 251Dh
	BX = DF21h
	CX = F321h
	DX = ???
--------R-2FD3CB-----------------------------
INT 2F U - LapLink Quick Connect v6 - API
	AX = D3CBh
	CX = function
	    0002h get ???
		Return: BX:AX -> ???
			CL = ???
			CH = ???
			DX = ???
			DI = COM1 I/O port???
			SI = COM2 I/O port???
	    0003h initialization???
	    0004h ???
	    0005h initialization???
	    0006h reset/clear ???
		Return: AX = 0000h
			ES:DI -> next byte after ??? cleared by this call
	    0007h initialization???
	    0008h uninstall
		Return: BX = status
			    0000h successful
			    FFFFh incomplete, stub remains in memory
Return: CX = 534Bh (except function 0002h)
Index:	uninstall;LapLink Quick Connect
--------K-2FD3D3BH00-------------------------
INT 2F - KDRIVE v2.x - INSTALLATION CHECK
	AX = D3D3h
	BH = 00h
Return: BX = 3D3Dh if installed
	CF clear if installed
	    AX = driver ID??? (returns 0087h for KDRIVE.EXE and 0880h for
		  KDRIVOS2.EXE in one examined version)
Program: KDRIVE is a shareware extended German keyboard driver by Martin
	  Austermeier, originally based on K3 by Martin Gerdes as published
	  in c't magazine 7/1988
--------l-2FD44D-----------------------------
INT 2F - 4DOS.COM v2.1+ - API
	AX = D44Dh
	BH = function
	    00h installation check
		Return: AX = 44DDh
			BL = major version number
			BH = minor version number
			CX = PSP segment address for current invocation
			DL = 4DOS shell number (0 for the first (root) shell,
			      updated each time a new copy is loaded)
	    01h (internal, v2.1-3.03) terminate current copy of 4DOS
		Return: nothing
		(internal, v4.0+) ???
		Return: AX = 44DDh
			ES:BX -> data area (see #2719)
	    02h ???
		DX = ???
		Note:	v5.52 signals "unrecoverable error" and then terminates
			  with INT 21/AH=4Ch or enters a deliberate infinite
			  loop if ???
	---v2.1-3.03 only---
	    03h EXEC program
		CX:DX -> EXEC record (see #2720)
	    FEh deallocate shell number (passed through to root shell)
		???
	    FFh allocate shell number (passed through to root shell)
	---v5.52---
	    03h get ???
		BL = ??? (00h/01h)
		Return: DX = current value of ???
	    04h set ???
		BL = ??? (00h/01h)
		DX = new value for ???
Note:	a bug in v3.00 will crash the system if unrecognized value in BH
SeeAlso: AX=D44Eh,AX=D44Fh/BX=0000h,AX=E44Dh,INT 21/AX=4403h"DOS"
Index:	installation check;4DOS|installation check;NDOS

Format of 4DOS v4.0 data area:
Offset	Size	Description	(Table 2719)
 00h  2 BYTEs	???
 06h	WORD	XMS handle for swapping
	???
SeeAlso: #2720

Format of 4DOS EXEC v2.1-v3.03 record:
Offset	Size	Description	(Table 2720)
 00h	WORD	offset of ASCIZ program name in same segment as EXEC record
 02h	WORD	offset of DOS commandline in same segment as EXEC record
 04h	WORD	segment of environment for child process (see INT 21/AH=26h)
SeeAlso: #2719
--------l-2FD44E-----------------------------
INT 2F C - 4DOS v3.0+ - AWAITING USER INPUT
	AX = D44Eh
---4DOS v3.01+---
	BX = condition
	    0000h 4DOS is ready to display prompt
	    0001h 4DOS has displayed the prompt, about to accept user input
Return: the handler must preserve SI, DI, BP, SP, DS, ES, and SS
Note:	v3.00 only makes the call corresponding to BX=0001h, does not set BX
SeeAlso: AX=D44Dh
--------K-2FD44FBX0000-----------------------
INT 2F - 4DOS v4.0+ - KSTACK.COM - INSTALLATION CHECK
	AX = D44Fh
	BX = 0000h
Return: AX = 44DDh if installed
Note:	this function is also supported by ANSIPLUS v3.01+ and K3PLUS v6.20+,
	  which emulate the 4DOS and NDOS keystack
SeeAlso: AX=D44Dh,AX=D44Fh/BX=0001h,AX=E44Fh/BX=0000h
--------K-2FD44FBX0001-----------------------
INT 2F - 4DOS v4.0+ - KSTACK.COM - PLACE KEYSTROKES INTO KEYSTACK
	AX = D44Fh
	BX = 0001h
	CX = number of keystrokes (01h-FFh)
	DS:DX -> keystroke list (one word per keystroke)
Return: AX = status
	    0000h successful
	    nonzero failed
	BX,CX,DX destroyed
Notes:	the keystrokes are the exact values to return from subsequent calls to
	  INT 16 with AH=00h,01h,10h, or 11h, with the following exceptions:
		0000h causes subfunctions 01h and 11h to indicate an empty
		      keyboard buffer
		FFFFh is followed by a word indicating the number of clock
		      ticks to delay before the next faked keystroke
	v4.00 KSTACK overwrites any unread keystrokes from the previous
	  invocation, and does not range-check CX; it will overwrite memory
	  following the resident portion if CX is greater than 100h.
	this function is also supported by ANSIPLUS v3.01+ and K3PLUS v6.20+,
	  which emulate the 4DOS and NDOS keystack
SeeAlso: AX=D44Dh,AX=D44Fh/BX=0000h,INT 16/AH=00h,INT 21/AX=4403h"DOS"
--------G-2FD600-----------------------------
INT 2F - HEART.COM - INSTALLATION CHECK
	AX = D600h
Return: AX = 0303h (two hearts) if installed
	    ES:DI -> buffer (see #2721)
Program: HEART.COM is a CPU lock-up/critical indicator utility by Mitch Davis.
Notes:	Once the host program has identified the address of the data area, it
	  can change this to indicate safe/critical, alternate colours, etc.
	The entries for the color table are in char/attrib form.  Every two
	  entries form a pair which is alternated between 68 times a minute.
	  The first half of the table is for color videos, the second mono.
	  Within each half, the first half is for the safe chars, and the
	  second for the critical chars.

Format of HEART.COM buffer:
Offset	Size	Description	(Table 2721)
 00h  8 WORDs	table of colors/attributes (refer to notes above)
 10h	BYTE	flags
		bit 0: program is in critical section, so flash double
		      exclamation mark
		bit 1: program is in safe code, so flash the heart character
 11h	WORD	position of heartbeat on screen, normally 009Eh (last column
		of second line)
--------T-2FD600-----------------------------
INT 2F U - VEDIT VSWAP - INSTALLATION CHECK
	AX = D600h
Return: AL = D6h if installed
Program: VSWAP is the resident portion of VEDIT's "swapper" capability; VEDIT
	  is a programmer's text editor by Greenview Data.
SeeAlso: AX=D601h,AX=D602h
--------T-2FD601-----------------------------
INT 2F U - VEDIT VSWAP - ???
	AX = D601h
	BL = subfunction number???
Return: BL = return code ???
	ES = resident portion's data??? segment
	DX = resident portion's code segment
SeeAlso: AX=D600h"VSWAP"
--------T-2FD602-----------------------------
INT 2F U - VEDIT VSWAP - EXEC PROGRAM WITH SWAP
	AX = D602h
	other registers set as for INT 21/AX=4B00h
Return: CF set on error
	    AL = error code
		82h = failure due to ???
	CF clear on success
SeeAlso: AX=D600h"VSWAP",INT 21/AH=4Bh"EXEC"
--------N-2FD701BX0000-----------------------
INT 2F - Banyan VINES v4+ - GET BANV INTERRUPT NUMBER
	AX = D701h
	BX = 0000h
Return: AX = 0000h if installed
	    BX = interrupt number (60h to 66h)
	   nonzero not present
Note:	if AX is nonzero, VINES 3.x or earlier may be installed, thus it is
	  necessary to examine the four bytes preceding the handlers for
	  INT 60 through INT 66 for the string "BANV"
SeeAlso: AX=D702h,AX=D703h,AX=D704h
--------N-2FD702-----------------------------
INT 2F U - Banyan VINES v4+ - PCPRINT interface
	AX = D702h
	BX = function
	???
Return: ???
SeeAlso: AX=D701h,AX=D703h,INT 61/AX=0005h"Banyan"
--------N-2FD703-----------------------------
INT 2F U - Banyan VINES v4+ - MAIL interface
	AX = D703h
	BX = function
	???
Return: ???
SeeAlso: AX=D702h,AX=D704h
--------N-2FD704-----------------------------
INT 2F U - Banyan VINES v4+ - Streettalk Directory Assistance interface
	AX = D704h
	BX = function
	???
Return: ???
SeeAlso: AX=D703h,INT 61/AX=0007h/BX=0002h"Banyan",INT 61/AX=0007h/BX=0008h
--------N-2FD800-----------------------------
INT 2F U - Novell NetWare Lite - CLIENT.EXE - INSTALLATION CHECK
	AX = D800h
Return: AL = FFh if installed
	    DX = version number (0100h for v1.0, 0101h for v1.1)
	    BX = data segment of resident copy
	    ES:DI -> private API entry point (see #2722)
	    SI = segment of resident code
SeeAlso: AX=7A00h,AX=D880h

(Table 2722)
Call CLIENT API entry point with:
	BX = function
	    0000h get ???
		Return: DX = CLIENT version??? (0101h for v1.1)
			ES:BX -> ??? data
	    0001h ???
	    0002h ???
	    0003h ???
	    0004h ???
	    0005h ???
		DL = ???
		???
		Return: ???
	    0006h get module name???
		ES:DI -> 16-byte buffer
		Return: CX = ???
			ES:DI filled with "NWLITE_CLIENT" 00h 00h 00h
	    0007h ???
		DX:CX = ???
		???
		Return: ???
	    0008h ???
	    0009h ???
		DL = ???
		ES:DI -> 16-byte buffer for ???
		Return: CF clear if successful
			    AX = 0000h
			    CX = 0000h
			    SI,DI destroyed
			CF set on error
			    AX = error code 4903h
	    000Ah ???
		AH = subfunction
		    00h get ???
		    01h clear/set ??? flag
			AL = new state (00h cleared, 01h set)
		    02h set ???
			DX = new value of ???
		Return: DX = old value of ???
	    000Bh ???
		AX = ???
		???
		Return: ???
	    000Ch ???
		AX = ???
		???
		Return: ???
	    000Dh ???
		AX = ???
		???
		Return: ???
	    000Eh get original INT 17
		Return: CF clear
			ES:BX -> original INT 17
	    000Fh ???
	    0010h ???
		AX = ???
		???
		Return: ???
	    0011h get ???
		Return: CF clear
			DL = ???
	    0012h get ???
		AL = index of ???
		ES:DI -> 10-byte buffer for ???
		Return: CF clear if successful
			    ES:DI buffer filled
			    AX,CX destroyed
			CF set on error
			    AX = error code (4907h if AL out of range)
	    0013h get ???
		Return: CF clear
			DH = ???
			DL = ???
	    0014h ???
		DL = ???
		???
		Return: CF clear if successful
			    ???
			CF set on error
			    AX = error code 8056h
	    0015h ???
		DX = ???
		Return: ES:DI -> ???
	    other
		Return: CF set
			AX = 0001h (invalid function)
--------N-2FD856-----------------------------
INT 2F U - Novell NetWare Lite v1.1 - SERVER - GET ???
	AX = D856h
Return: AX = 0001h if supported???
	BX = ??? (0004h for v1.1)
	CX = ??? (0F20h for v1.1)
	DS = segment of resident code
	ES = data segment of resident copy
Note:	this function is also supported by Personal NetWare SERVER, bundled
	  with Novell DOS 7
--------N-2FD880-----------------------------
INT 2F U - Novell NetWare Lite v1.0+ - SERVER - INSTALLATION CHECK
	AX = D880h
Return: AL = FFh if installed
	    DX = version number (0100h for v1.0, 0101h for v1.1)
	    BX = data segment of resident copy
	    CL = current state (00h SERVER is disabled, 01h SERVER is active)
	    ES:DI -> private API entry point (see #2723)
	    SI = ??? (offset of configuration info?)
Note:	this function is also supported by Personal NetWare SERVER, but DI is
	  not set; instead, ES:SI points at the API entry point
SeeAlso: AX=7A00h,AX=D800h,INT 2A/AX=D852h

(Table 2723)
Call SERVER API entry point with:
	BX = function
	    0000h ???
		???
		Return: ???
		Note: closes open files by calling INT 21/AH=3Eh
	    0001h get connection information
		DX = connection number (0001h-max connections)
		ES:DI -> 28-byte buffer for connection information
		Return: CF clear if successful
			    ES:DI buffer filled
			CF set on error
			    AX = FFFFh
	---Personal NetWare only---
	    0002h ???
	    0003h ???
	    0004h ???
	    0005h ???
	    0006h ???
	    0007h ???
	    other
		Return: CF set
			AX = 0001h (invalid function)
--------d-2FD8C0-----------------------------
INT 2F U - Novell NLCACHE,NWCACHE - INSTALLATION CHECK
	AX = D8C0h
Return: AL = FFh if installed
	    CL = cache variant (01h NLCACHEC, 02h NLCACHEX, 03h NLCACHEM)
	    DH = major version??? (01h for v1.1)
	    DL = minor version??? (01h for v1.1)
	    ES:DI -> private API entry point (see #2724)
Program: NLCACHE is a disk cache included with NetWare Lite
SeeAlso: AX=D800h,AX=D880h

(Table 2724)
Call NLCACHE/NWCACHE API entry point with:
	BX = function
	    0000h ???
		???
		Return: CF clear if successful
			    AX = 0000h
			    ???
			CF set on error
			    AX = error code
	    0001h (NWCACHE only) ???
		ES:DI -> buffer for ???
		Return: ???
	    other
		Return: CF set
			AX = 0001h (invalid function)
--------F-2FDA00-----------------------------
INT 2F - ZyXEL ZFAX v1.x - INSTALLATION CHECK
	AX = DA00h
Return: AH = enabled state (00h = enabled, 01h = disabled)
	AL = 5Ah installed
Program: ZFAX is the bundled FAX software which comes with the ZyXEL model
	  fax modems.
Note:	This function, and the other DAxxh functions, may apply only to version
	  1 of the software; see AX=DB00h for the version 2 installation check
SeeAlso: AX=CBDCh,AX=DA01h,AX=DA02h,AX=DA03h,AX=DB00h
--------F-2FDA01-----------------------------
INT 2F - ZyXEL ZFAX v1.x - UNINSTALL
	AX = DA01h
Return: AL = 00h Success
	     01h Failure
SeeAlso: AX=DA00h,AX=DB01h
--------F-2FDA02-----------------------------
INT 2F - ZyXEL ZFAX v.1x - DISABLE
	AX = DA02h
Return: AL = 00h
SeeAlso: AX=DA03h,AX=DB02h
--------F-2FDA03-----------------------------
INT 2F - ZyXEL ZFAX v1.x - ENABLE
	AX = DA03h
Return: AL = 00h
SeeAlso: AX=DA02h,AX=DB03h
--------G-2FDA55-----------------------------
INT 2F U - TRAP.COM - INSTALLATION CHECK
	AX = DA55h
	DL = interrupt number
	DH = ???
Return: if installed
	    AH = interrupt number
	    AL = ???
	    ES:BX -> ???
Program: TRAP is an interrupt call tracer by Patrick Phillipot/Udo Chrosziel
Note:	a separate copy of TRAP is loaded for each interrupt to be traced; thus
	  the interrupt number is part of the installation check
--------N-2FDAB2-----------------------------
INT 2F U - Beame&Whiteside BWSNMP - INSTALLATION CHECK
	AX = DAB2h
Return: AX = 00FFh if installed
	    BX:CX -> MIB table
Program: BWSNMP is part of the BW-NFS package
SeeAlso: INT 62/AH=00h"ETHDEV"
--------F-2FDB00-----------------------------
INT 2F - ZyXEL ZFAX v2+ - INSTALLATION CHECK
	AX = DB00h
Return: AL = 5Bh if installed (v2.x)
	    ES:BX -> configuration table???
	AX = 00DBh if installed (v3)
	    ES:BX -> ZFAX configuration table (see #2725)
Program: ZFAX is the bundled FAX software which comes with the ZyXEL model
	  Fax modems.
SeeAlso: AX=CBDCh,AX=DA00h,AX=DB01h,AX=DB02h,AX=DB03h

Format of ZFAX Configuration Table:
Offset	Size	Description	(Table 2725)
 00h	WORD	table version number (0300h for v3.0-v4.01)
 02h	BYTE	reserved
 03h 70 BYTEs	ZFAX working path
 49h 128 BYTEs	path to external editor
 C9h 128 BYTEs	path to external terminal emulator
149h 128 BYTEs	path to Ring Shell
1C9h 128 BYTEs	path to DOS Shell
249h 128 BYTEs	path to Data Shell
2C9h 70 BYTEs	path to Chinese font
30Fh	BYTE	printer type (see #2726)
310h	BYTE	printer port (00h = LPT1, etc.)
311h	BYTE	type of graphics adapter
		(00h auto-detect, 01h VGA, 02h EGA, 03h CGA, 04h Hercules)
312h	BYTE	display type
		(00h auto-detect, 01h LCD, 02h color, 03h mono)
313h	BYTE	scan code for ZFAX hotkey (see #0005)
314h	BYTE	shift mask for ZFAX hotkey
315h	BYTE	tone/pulse dialing (00h tone, 01h pulse)
316h	BYTE	Caller ID (00h disabled, 01h enabled)
317h	BYTE	Distinctive Ring (00h disabled, 01h enabled)
318h	BYTE	normal ring answer type (see #2727)
319h	BYTE	Ring 1 answer type (see #2727)
31Ah	BYTE	Ring 2 answer type (see #2727)
31Bh	BYTE	Ring 3 answer type (see #2727)
31Ch	BYTE	COM port for modem
31Dh	BYTE	speaker volume (00h-07h)
31Eh	BYTE	modem dial timer, seconds
31Fh	WORD	user-defined COM port I/O address
321h	BYTE	user-defined COM port IRQ number
322h 81 BYTEs	dial prefix string
373h 79 BYTEs	dial postfix string
3C2h	BYTE	ring count until automatic answer
3C3h	BYTE	retry count on busy signal
3C4h	BYTE	redial delay in seconds
3C5h	WORD	system password
3C7h	BYTE	reserved
3C8h	BYTE	voice file compression format
		00h CELP at 9600bps
		01h two-bit ADPCM at 19200bps
		02h three-bit ADPCM at 28800bps
3C9h	BYTE	voice system: DTMF 0 action (see #2728)
3CAh	BYTE	voice system: DTMF 1 action
3CBh	BYTE	voice system: DTMF 2 action
3CCh	BYTE	voice system: DTMF 3 action
3CDh	BYTE	voice system: DTMF 4 action
3CEh	BYTE	voice system: DTMF 5 action
3CFh	BYTE	voice system: DTMF 6 action
3D0h	BYTE	voice system: DTMF 7 action
3D1h	BYTE	voice system: DTMF 8 action
3D2h	BYTE	voice system: DTMF 9 action (see #2728)
3D3h	WORD	reserved
3D5h 25 BYTEs	local FAX ID to display on page header
3EEh 20 BYTEs	local FAX ID sent to remote FAX
402h	BYTE	FAX page size
		00h A4 (210x297mm)
		01h B4 (250x353mm)
		02h A3 (297x420mm)
403h	BYTE	FAX resolution
		00h normal (3.85 pixels/mm)
		01h high (7.7 pixels/mm)
404h	BYTE	FAX coding scheme
		00h 1-D, modified Huffman coding
		01h 2-D, modified READ coding
405h	BYTE	left margin for text in millimeters
406h	BYTE	vertical insertion for text in mm (0-20)
407h	BYTE	horizontal insertion in mm (0-20)
408h	BYTE	maximum text lines per page
409h	BYTE	text type (00h ASCII, 01h WordStar-formatted)
40Ah	BYTE	PCX image resize (00h disabled, 01h enabled)
40Bh	BYTE	AutoPrint (00h disabled, 01h enabled)
40Ch	BYTE	cover page (00h disabled, 01h enabled)
40Dh 81 BYTEs	cover page logo filename
45Eh 65 BYTEs	cover page sender name
49Fh	BYTE	print capture (00h disabled, 01h enabled)
4A0h	BYTE	send immediately (00h disabled, 01h enabled)
4A1h	BYTE	print capture printer port
4A2h	BYTE	print capture timer in seconds
4A3h	BYTE	scan code for print capture hotkey (see #0005)
4A4h	BYTE	shift mask for print capture hotkey
4A5h	BYTE	DataShell type
		00h internal Zmodem, 01h Data Shell, 02h disable
4A6h	BYTE	video I/O type
		00h auto-detect, 01h use BIOS, 02h direct writes
4A7h	BYTE	call transfer digits (0-9)
4A8h	WORD	voice recorder maximum time in seconds (0-999)

(Table 2726)
Values for ZFAX printer type:
 00h	EPSON FX (9 pins)
 01h	EPSON LQ (24 pins)
 02h	HP Laser Jet II, letter size
 03h	HP Laser Jet II, legal size
 04h	HP Laser Jet II, A4 size
 05h	HP Laser Jet III, letter size
 06h	HP Laser Jet III, legal size
 07h	HP Laser Jet III, A4 size
SeeAlso: #2725

(Table 2727)
Values for Ring Answer Type:
 00h	voice system
 01h	FAX only
 02h	Data Shell
 03h	Ring Shell
 04h	DOS Shell
 05h	ignore
SeeAlso: #2725

(Table 2728)
Values for DTMF action:
 00h	none
 01h	page operator
 02h	FaxBack
 03h	announcement
 04h	call transfer
 05h	receive FAX
 06h	receive data
 07h	voice mailbox
 08h	DOS Shell Out
 09h	Data Shell Out
SeeAlso: #2725
--------U-2FDB00-----------------------------
INT 2F U - WINGO.COM - INSTALLATION CHECK
	AX = DB00h
Return: AX = FFFFh if installed
	CX = 5749h ('WI') if installed
	DX = 4E47h ('NG') if installed
	    ES = segment of resident code
Program: WINGO.COM is TSR for starting Windows programs from DOS
	  prompt (together with companion Windows program
	  WINSTART.EXE) written by Douglas Boling, contributing editor of
	  PC Magazine
Range:	AH=DBh to AH=FFh, selected by scanning for a free multiplex number
SeeAlso: AX=DB01h"WINGO",AX=DB02h"WINGO",AX=DB03h"WINGO",AX=DB04h"WINGO"
SeeAlso: AX=DB05h"WINGO",AX=DB06h"WINGO"
--------F-2FDB01-----------------------------
INT 2F - ZyXEL ZFAX v2+ - UNINSTALL
	AX = DB01h
Return: AX = status
	    0000h successful
	    0001h ZFAX is busy
	    0002h another program resident above ZFAX
Note:	this function unhooks the vectors taken by the ZFAX TSR if they have
	  not been hooked by other TSRs and releases the TSR's memory
	ZFAX v2.x crashes the contributor's machine when this function is
	  called
SeeAlso: AX=DA01h,AX=DB00h"ZFAX",AX=DB02h"ZFAX"
--------U-2FDB01-----------------------------
INT 2F U - WINGO.COM - SET CALLBACK FUNCTION POINTER
	AX = DB01h
	CX:DX -> new callback function
Return: AX = 0000h
	CX:DX -> end of resident code (stack ???)
Desc:	the callback function is used for WINGO <-> WINSTART communication
SeeAlso: AX=DB00h"WINGO",AX=DB02h"WINGO",AX=DB03h"WINGO",AX=DB04h"WINGO"
SeeAlso: AX=DB05h"WINGO",AX=DB06h"WINGO"
--------F-2FDB02-----------------------------
INT 2F - ZyXEL ZFAX v2.x - DISABLE
	AX = DB02h
Return: AL = 00h
SeeAlso: AX=DA02h,AX=DB00h"ZFAX",AX=DB01h"ZFAX",AX=DB03h"ZFAX"
--------U-2FDB02-----------------------------
INT 2F U - WINGO.COM - RESET CALLBACK FUNCTION POINTER
	AX = DB02h
Return: AX = 0000h
Desc:	the callback function is used for WINGO <-> WINSTART communication
SeeAlso: AX=DB00h"WINGO",AX=DB01h"WINGO",AX=DB03h"WINGO",AX=DB04h"WINGO"
SeeAlso: AX=DB05h"WINGO",AX=DB06h"WINGO"
--------F-2FDB03-----------------------------
INT 2F - ZyXEL ZFAX v2.x - ENABLE
	AX = DB03h
Return: AL = 00h
SeeAlso: AX=DA03h,AX=DB00h"ZFAX",AX=DB02h"ZFAX"
--------U-2FDB03-----------------------------
INT 2F U - WINGO.COM - SET ??? FLAG
	AX = DB03h
Return: AX = 0000h
SeeAlso: AX=DB00h"WINGO",AX=DB04h"WINGO",AX=DB05h"WINGO",AX=DB06h"WINGO"
--------U-2FDB04-----------------------------
INT 2F U - WINGO.COM - RESET ??? FLAG
	AX = DB04h
Return: AX = 0000h
SeeAlso: AX=DB00h"WINGO",AX=DB03h"WINGO",AX=DB05h"WINGO",AX=DB06h"WINGO"
--------U-2FDB05-----------------------------
INT 2F U - WINGO.COM - GET ??? FLAG
	AX = DB05h
Return: AX = 0000h
	DX = unknown flag - 0 or 1
Program: WINGO.COM is TSR for starting Windows programs from DOS
	  prompt (together with companion Windows program
	  WINSTART.EXE) written by Douglas Boling, contributing editor of
	  PC Magazine
SeeAlso: AX=DB00h"WINGO",AX=DB03h"WINGO",AX=DB04h"WINGO"
--------U-2FDB06-----------------------------
INT 2F U - WINGO.COM - CALL CALLBACK FUNCTION
	AX = DB06h
Return: AX = return value of INT 2F/AX=1685h
Note:	uses Windows service INT 2F/AX=1685h (SWITCH VMs AND CALLBACK) to
	  call the callback function previously set by AX=DB01h
	used for WINGO <-> WINSTART communication
SeeAlso: AX=1685h, AX=DB00h"WINGO",AX=DB01h"WINGO",AX=DB02h"WINGO",
SeeAlso: AX=DB03h"WINGO",AX=DB04h"WINGO",AX=DB05h"WINGO"
--------F-2FDB10-----------------------------
INT 2F - ZyXEL ZFAX v3+ - EXECUTE ZFAX MAIN MENU
	AX = DB10h
SeeAlso: AX=DB00h"ZFAX",AX=DB11h"ZFAX"
--------F-2FDB11-----------------------------
INT 2F - ZyXEL ZFAX v3+ - SEND FAX
	AX = DB11h
	DS:SI -> filename including path (max 128 characters)
	DS:BX -> remote FAX number
Return: AX = status (see #2729)
SeeAlso: AX=DB00h"ZFAX",AX=DB12h,AX=DB13h,AX=DB14h,AX=DB15h,AX=DB20h,AX=DB21h

(Table 2729)
Values for ZFAX status:
 00h	OK
 01h	invalid DOS function
 02h	file not found
 03h	path not found
 04h	no file handle available
 05h	access denied by DOS
 06h	invalid handle
 07h	disk full
 10h	printer error
 11h	no graphics font
 12h	no ZFAX font
 20h	DCD dropped while sending
 21h	not ZyXEL modem
 22h	busy
 23h	no response from COM port
 24h	no carrier
 25h	no dial tone
 26h	no answer
 27h	no response
 28h	failed to send FAX
 30h	user aborted
 40h	critical error on disk
 50h	parameter error
--------F-2FDB12-----------------------------
INT 2F - ZyXEL ZFAX v3+ - PRINT FAX
	AX = DB12h
	DS:SI -> filename, including path (max 128 characters)
Return: AX = status (see #2729)
SeeAlso: AX=DB11h,AX=DB13h,AX=DB14h
--------F-2FDB13-----------------------------
INT 2F - ZyXEL ZFAX v3+ - CONVERT FAX
	AX = DB13h
	DS:SI -> source filename, including path (max 128 characters)
	DS:BX -> destination filename, including path (max 80 characters)
	CX = destination file format
	    00h FAX, 01h PCX, 02h TIFF, 03h PRN
Return: AX = status (see #2729)
SeeAlso: AX=DB11h,AX=DB12h,AX=DB14h,AX=DB22h
--------F-2FDB14-----------------------------
INT 2F - ZyXEL ZFAX v3+ - VIEW FAX
	AX = DB14h
	DS:SI -> source filename, including path (max 128 characters)
Return: AX = status (see #2729)
SeeAlso: AX=DB11h,AX=DB12h,AX=DB14h
--------F-2FDB15-----------------------------
INT 2F - ZyXEL ZFAX v4.01 - SEND FAX WITH LOGO AND SIGNATURE
	AX = DB15h
	DS:SI -> source filename, including path (max 128 characters)
	DS:BX -> remote FAX number
	DS:CX -> Logo filename
	DS:DX -> Signature filename
Return: AX = status (see #2729)
SeeAlso: AX=DB00h"ZFAX",AX=DB11h
--------F-2FDB16-----------------------------
INT 2F - ZyXEL ZFAX v4.01 - QUOTE PREVIOUS STATUS
	AX = DB16h
Return: DX:AX -> previous receive state transaction log (see #2730)
	BX = type (00h incoming FAX, 01h incoming data, 02h incoming voice)
SeeAlso: AX=DB00h"ZFAX",AX=DB11h,AX=DB17h

Format of ZFAX transaction log receive state:
Offset	Size	Description	(Table 2730)
 00h	WORD	year
 02h	WORD	date
 04h	WORD	time
 06h	WORD	extension number
 08h	WORD	type: 00h incoming FAX, 01h outgoing FAX, 02h voice message
 0Ah	WORD	status: 00h normal, 01h remote delete
 0Ch 125 BYTEs	filename
 89h 24 BYTEs	caller ID
 A1h 20 BYTEs	FAX number
 B5h 20 BYTEs	remote FAX ID
 C9h	WORD	error code
 CBh	WORD	connection direction (00h transmit, 01h receive)
 CDh	BYTE	connection time minutes
 CEh	BYTE	connection time seconds
 CFh	BYTE	???
 D0h	WORD	connection speed (24, 48, 72, 96, 12, 144)
 D2h	WORD	connection page size (A4, B4, A3)
 D4h	WORD	connection coding scheme (1-DN, 1-DH, 2-DN, 2-DH)
 D6h	WORD	page count
--------F-2FDB17-----------------------------
INT 2F - ZyXEL ZFAX v4.01 - BEGIN RECEIVING INCOMING CALL
	AX = DB17h
Return: AX = status (0000h successful, 0001h unable to start at this time)
SeeAlso: AX=DB00h"ZFAX"
--------F-2FDB18-----------------------------
INT 2F - ZyXEL ZFAX v4.01 - SCHEDULE CALL
	AX = DB18h
	DS:SI -> schedule data (see #2730)
Return: AX = status (see #2729)
SeeAlso: AX=DB00h"ZFAX"
--------F-2FDB20-----------------------------
INT 2F - ZyXEL ZFAX v3+ - POLL FAX
	AX = DB20h
	DS:SI -> remote FAX number
Return: AX = status (see #2729)
SeeAlso: AX=DB11h,AX=DB21h
--------F-2FDB21-----------------------------
INT 2F - ZyXEL ZFAX v3+ - SEND VOICE
	AX = DB21h
	DS:SI -> filename including path (max 128 characters)
	DS:BX -> remote phone number
Return: AX = status (see #2729)
SeeAlso: AX=DB11h,AX=DB20h,AX=DB22h,AX=DB23h,AX=DB24h
--------F-2FDB22-----------------------------
INT 2F - ZyXEL ZFAX v3+ - CONVERT VOICE FILE
	AX = DB22h
	DS:SI -> source filename, including path (max 128 characters)
	DS:BX -> destination filename, including path (max 80 characters)
	CX = destination format
	    00h two-bit ADPCM, 01h three-bit ADPCM, 02h VOC
Return: AX = status (see #2729)
SeeAlso: AX=DB13h,AX=DB20h,AX=DB21h,AX=DB23h
--------F-2FDB23-----------------------------
INT 2F - ZyXEL ZFAX v3+ - RECORD VOICE FILE
	AX = DB23h
	DS:SI -> destination filename, including path (max 128 characters)
	CX = recording channel (0 = telephone line, 1 = microphone/speaker)
	DX = voice file format
	    00h CELP, 01h two-bit ADPCM, 02h three-bit ADPCM
Return: AX = status (see #2729)
SeeAlso: AX=DB21h,AX=DB22h,AX=DB24h
--------F-2FDB24-----------------------------
INT 2F - ZyXEL ZFAX v3+ - PLAY VOICE FILE
	AX = DB24h
	DS:SI -> name of voice file, including path (max 128 characters)
	CX = playback channel (0 = telephone line, 1 = microphone/speaker)
Return: AX = status (see #2729)
SeeAlso: AX=DB21h,AX=DB22h,AX=DB24h
--------F-2FDB25-----------------------------
INT 2F - ZyXEL ZFAX v3+ - ANSWER MODEM WITH VOICE SYSTEM
	AX = DB25h
Return: AX = status (see #2729)
SeeAlso: AX=DB21h,AX=DB22h,AX=DB26h,AX=DB27h,AX=DB28h
--------F-2FDB26-----------------------------
INT 2F - ZyXEL ZFAX v3+ - DIAL PHONE
	AX = DB26h
	DS:SI -> remote phone number
Return: AX = status (see #2729)
SeeAlso: AX=DB25h
--------F-2FDB27-----------------------------
INT 2F - ZyXEL ZFAX v3+ - RECEIVE FAX - ANSWER MODEM AND SET TO FAX MODE
	AX = DB27h
Return: AX = status (see #2729)
SeeAlso: AX=DB25h,AX=DB28h
--------F-2FDB28-----------------------------
INT 2F - ZyXEL ZFAX v3+ - RECEIVE FAX DATA - ANSWER MODEM IN MULTI-AUDIO MODE
	AX = DB28h
Return: AX = status (see #2729)
SeeAlso: AX=DB25h,AX=DB27h,AX=DB41h
--------F-2FDB40-----------------------------
INT 2F - ZyXEL ZFAX v3+ - INTERNAL TERMINAL
	AX = DB40h
Return: AX = status (see #2729)
SeeAlso: AX=DB00h
--------F-2FDB41-----------------------------
INT 2F - ZyXEL ZFAX v3+ - SEND DATA - DIAL NUMBER AND UPLOAD FILE WITH ZMODEM
	AX = DB41h
	DS:SI -> source file name, including path (max 128 characters)
	DS:BX -> remote data number
Return: AX = status (see #2729)
SeeAlso: AX=DB00h,AX=DB28h
--------K-2FDC00-----------------------------
INT 2F - GOLD.COM - INSTALLATION CHECK
	AX = DC00h
Return: AL = state
	    00h not installed
	    FFh installed
Program: GOLD is a TSR by Bob Eager which makes the NumLock key return the
	  code for F1; the purpose is to improve Kermit's VTxxx emulation
--------K-2FDC01-----------------------------
INT 2F - GOLD.COM - GET STATE
	AX = DC01h
Return: AL = status
	    00h off
	    01h on
SeeAlso: AX=DC00h,AX=DC02h
--------K-2FDC02-----------------------------
INT 2F - GOLD.COM - SET STATE
	AX = DC02h
	DL = new state
	    00h off
	    01h on
Return: AL = 00h (OK)
SeeAlso: AX=DC01h
--------t-2FDD-------------------------------
INT 2F - CappaCom programs - API
	AH = DDh
	AL = 00h general installation check
	    Return: AL = FFh if any CappaCom programs are resident
	AL = FEh get info
	    Return: ES:BX -> TSR info list (see #2731)
	AL = program identifier
	    BH = function
		FDh get version
		    Return: BX = version
		FFh installation check
		    Return: AL = FFh if installed
				BX = version
				ES = segment of resident code
		others vary by program
Return: AL = status
	    bit 7 set on error
	    AL = 81h unknown function
Note:	CappaCom was originally SoftCom but changed its name due to a trademark
	  conflict
Index:	installation check;SoftCom programs
Index:	installation check;CappaCom programs

Format of CappaCom TSR info list:
Offset	Size	Description	(Table 2731)
 00h  9 BYTEs	blank-padded ASCIZ program name
 09h	BYTE	program ID
 0Ah	WORD	program's PSP segment
 0Ch	WORD	program version (major in high byte)
 0Eh	DWORD	pointer to next item in info list or 0000h:0000h
 12h	BYTE	number of interrupts hooked
 13h  5 BYTEs	interrupt numbers hooked by program
 18h  8 BYTEs	reserved
----------2FDD-------------------------------
INT 2F - MIXFIX.EXE - API
	AH = DDh
	AL = function
	    00h installation check
		Return: AX = 00DDh if installed
			    BX = version (BH = major, BL = minor)
	    41h/61h get From: address
		Return: AX = 0001h
			ES:BX -> ASCIZ 4d address of mail sender ("1:2/3.4")
	    49h/69h get To: address
		Return: AX = 0001h
			ES:BX -> ASCIZ 4d address of recipient ("1:2/3.4")
	    4Ah/6Ah get subject of mail
		Return: AX = 0001h
			ES:BX -> ASCIZ subject of handled mail
	    4Dh/6Dh get mail name
		Return: AX = 0001h
			ES:BX -> ASCIZ full name of current mail file
	    4Eh/6Eh get From: field
		Return: AX = 0001h
			ES:BX -> ASCIZ From: field of mail (mail sender's name)
Program: MIXFIX by "KIV without Co" is a FidoNet mail robot which may execute
	  other programs for mail handling.  The called programs may use the
	  services described here to retrieve information about the mail being
	  handled.
Index: installation check;MIXFIX.EXE
--------d-2FDD--BX7844-----------------------
INT 2F - xDISK v3.32+ - INSTALLATION CHECK
	AH = DDh
	BX = 7844h ('xD')
	CX = 4953h ('IS')
	DX = 4B3Fh ('K?')
	AL = desired drive (01h-1Ah) or 00h to check for xDISK on any drive
	ES:DI -> 25-byte data buffer (see #2732)
Return: AX = DDFFh if installed (on specified drive if AL nonzero on entry)
	   BX = 87BBh
	   DX = B4C0h
	   ES:DI buffer filled
	CX,CF destroyed
SeeAlso: INT 21/AX=4404h"xDISK",INT 21/AX=4405h"xDISK"

Format of xDISK data buffer:
Offset	Size	Description	(Table 2732)
 00h	DWORD	pointer to ASCIZ driver signature "xDISK unit: X"
 04h	BYTE	flag: 01h if disk linked to DOS, 00h if unlinked
 05h	BYTE	flag: 01h if write protected, 00h if not
 06h	BYTE	flag: 01h if root directory full, 00h if not
 07h	BYTE	flag: 01h if free space uncompacted, 00h if compacted
 08h	BYTE	resizing state: 00h not resizable, 01h resized, 80h resizable
 09h	BYTE	flag: 01h inelastic resizable disk, 00h elastic
 0Ah  2 BYTEs	reserved
 0Ch	BYTE	flag: 01h collapsed disk, 00h not collapsed
 0Dh	BYTE	flag: 01h using all EMS, 00h some EMS free
 0Eh	BYTE	flag: 01h password enabled, 00h disabled
 0Fh	BYTE	flag: 01h password audio feedback, 00h no feedback
 10h	BYTE	flag: 01h password video feedback, 00h no feedback
 11h	BYTE	flag: 01h confirm changes, 00h no confirmation
 12h	BYTE	flag: 01h terse display, 00h verbose display
 13h	BYTE	flag: 01h click speaker on disk access, 00h no click
 14h	BYTE	flag: 01h flash icon on disk access, 00h no icon flash
 15h	BYTE	FAT entry size: 00h 12-bit, FFh 16-bit
 16h	WORD	count of open files in RAM disk
 18h	BYTE	unused
--------N-2FDE00BL00-------------------------
INT 2F U - Novell Netware - RPRINTER, NPRINTER - INSTALLATION CHECK
	AX = DE00h
	BL = 00h
Return: AL = FFh If Rprinter/Nprinter Installed
	BX -> Program Segment Prefix N/Rprinter.exe
--------Q-2FDE00BX4456-----------------------
INT 2F - DESQview v2.26+ External Device Interface - INSTALLATION CHECK
	AX = DE00h
	BX = 4456h ("DV")
	CX = 5844h ("XD")
	DX = 4931h ("I1")
Return: AL = FFh if installed (even if other registers do not match)
	if BX,CX, and DX were as specified on entry,
	    BX = 4845h ("HE")
	    CX = 5245h ("RE")
	    DX = 4456h ("DV")
Range:	AH=C0h to AH=FFh, selected by scanning AH=DEh-FFh, then AH=C0h-DDh
Note:	the XDI handler should not issue any DOS or BIOS calls, nor should it
	  issue DESQview API calls other than those allowed from hardware ints
SeeAlso: AX=DE02h,INT 15/AX=5400h
--------Q-2FDE01-----------------------------
INT 2F - DESQview v2.26+ External Device Interface - DRIVER CUSTOM SUBFUNCTION
	AX = DE01h
	BX = driver ID
	other registers as needed by driver
Notes:	XDI drivers should pass this call through to previous handler if ID
	  does not match
	DESQview never calls this function
--------Q-2FDE01BX4450-----------------------
INT 2F U - Quarterdeck QDPMI.SYS v1.0 - INSTALLATION CHECK
	AX = DE01h
	BX = 4450h ("DP")
	CX = 4D49h ("MI")
	DX = 3039h ("09")
Return: AL = FFh if installed
	    BX = 4D42h ("MB")
	    CX = 4921h ("I!")
	    DX = 8F4Fh
	    ES:DI -> filename of DPMI host overlay
Note:	the installation check consists of testing for the existence of the
	  character device QDPMI$$$
SeeAlso: INT 2F/AX=1687h,INT 31/AX=0000h
Index:	installation check;QDPMI
--------U-2FDE01BX5242-----------------------
INT 2F - DESQview v2.26+ XDI - CUSTOM SUBFUNCTION, Ralf Brown's XDI drivers
	AX = DE01h
	BX = 5242h ("RB")
	CX:DX = program identifier
		656F7000h ("eop",0) for DVeop
Return: AX = 5242h ("RB") if installed
	    ES:BX -> data or entry point (see #2733)
	    CX = version number (CH = major, CL = minor)

(Table 2733)
Call DVeop entry point with:
	ES:DI -> callback address or 0000h:0000h to remove callback
Return: AX = status
	    0000h failed (callback table full or attempted to remove non-
		  existent callback)
	    0001h successful
		ES:DI -> chaining address
	BX,CX,DX destroyed
Notes:	the callback function is called with a simulated interrupt when the
	  DESQview window containing it is closed; it should perform all
	  necessary cleanup and then perform a FAR jump to the chaining address
	  or an IRET if the chaining address is 0000h:0000h
	if the program wishes to remove itself before the window is closed, it
	  should call the DVeop entry point with the previously returned
	  chaining address and ignore the returned chaining address.
--------U-2FDE01BX7474-----------------------
INT 2F - DESQview v2.26+ XDI - CUSTOM SUBFUNCTION, DVTXDI.COM
	AX = DE01h
	BX = 7474h
	CL = function
	    00h installation check
		Return: AL = FFh
	    01h get process handle
		DX = keys on Open Window menu (DL = first, DH = second)
		Return: AX = process handle or 0000h if not running
	    02h (v1.3+) set TMAN handle
		DX = TMAN process handle
	    03h (v1.3+) set open keys to ignore on next CL=01h call
		DX = keys on Open Window menu (DL = first, DH = second)
Return: BX = 4F4Bh ("OK")
	DL destroyed
Note:	DVTXDI is distributed as part of the shareware products DVTree (DOS
	 shell/DESQview process manager) and DVTMAN by Mike Weaver
Index:	installation check;DVTXDI
--------U-2FDE01BX7575-----------------------
INT 2F - DESQview v2.26+ XDI - CUSTOM SUBFUNCTION, DVSIXDI.COM
	AX = DE01h
	BX = 7575h
	CX = function
	    0000h installation check
		Return: AX = 00FFh if installed
	    0001h turn on notification (currently unused)
		Return: AX = 0001h
	    0002h turn off notification (currently unused)
		Return: AX = 0001h
	    0003h get process information
		Return: AX = status
			    0000h failed
			    0001h successful
				BX = last instantaneous time slice
				    in 1/100s (v1.10)
				    in 1/18s (v1.11+)
				CX = number of processes
				DX = number of "(starting)" records (v2.00+)
				SI = number of records in process info array
				      (v2.00+) (always 15 for v1.x)
				ES:DI -> process info array (see #2734,#2735)
	    0004h get version
		Return: AH = major version
			AL = minor version
	    0005h (v1.10+) get time since DESQview started
		Return: DX:AX = 1/100s since DV start (v1.10)
			DX:AX = 1/18s since DV start (v1.11+)
	    0006h (v1.10+) get number of task switches
		Return: DX:AX = total task switches
			CX = task switches in last instantaneous interval
Notes:	DVSIXDI is part of the DVSI (DESQview System Information) package by
	  Daniel J. Bodoh
	for v1.00, function 0003h allocates common memory, which the caller
	  must deallocate after reading the process information; only the
	  currently used records are placed in the buffer
	for v1.10+, function 0003h merely returns a pointer to the internal
	  array of process information; the caller should make a copy of the
	  array while inside a critical section (see INT 15/AX=101Bh).	Only
	  those records with bit 7 of the first byte set are valid.
Index:	installation check;DVSIXDI

Format of DVSIXDI v1.00 information for one process:
Offset	Size	Description	(Table 2734)
 00h	BYTE	flags
		bit 7: process slot is valid
 01h	WORD	offset into DESQVIEW.DVO of program's record if started from
		  Open Windows menu, else undefined
 03h	WORD	Switch Windows window number
 05h	WORD	segment of process handle
 07h	WORD	number of tasks owned by process
 09h	WORD	mapping context of process (see #0335 at INT 15/AX=1016h)
 0Bh	DWORD	hook for other programs

Format of DVSIXDI v1.10-v2.00 information for one process:
Offset	Size	Description	(Table 2735)
 00h	BYTE	process flags (see #2736)
 01h	WORD	Open Window keys
 03h	WORD	Switch Windows number
 05h	WORD	segment of process handle
 07h	WORD	number of tasks for process
 09h	WORD	process mapping context
 0Bh	DWORD	time process started (relative to start of DESQview)
 0Fh	DWORD	time process last got CPU (relative to start of DESQview)
 13h	DWORD	time process last gave up CPU (relative to start of DESQview)
 17h	DWORD	total CPU time since process started
 1Bh	DWORD	CPU time at start of current instantaneous interval
 1Fh	DWORD	CPU time in current instantaneous interval
 23h	DWORD	hook for other programs
Note:	all times are in 1/100s for v1.10, in 1/18s for v1.11+

Bitfields for DVSIXDI process flags:
Bit(s)	Description	(Table 2736)
 7	valid record
 6	(v2.00+) record is allocated; if bit 7 clear, process is "(starting)"
	  and only offsets 01h and 09h are valid
 5	(v2.00+) this app currently owns the CPU
 4	reserved (0)
 3	DESQview system task
 2	reserved (0)
 1	task has keyboard (currently unused)
 0	task swapped out (currently unused)
--------Q-2FDE01BXFFFE-----------------------
INT 2F U - DESQview v2.26+ XDI - DVXMS.DVR - ???
	AX = DE01h
	BX = FFFEh
	CX = 4D47h ("MG")
	DX = 0052h (0,"R")
Return: AL = FFh
	DX = 584Dh
--------Q-2FDE02-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - DV INITIALIZATION COMPLETE
	AX = DE02h
	BX = mapping context of DESQview
	DX = handle of DESQview system task
Note:	driver should pass this call to previous handler after doing its work
SeeAlso: AX=DE03h,AX=DE0Fh,INT 15/AX=5400h
--------Q-2FDE03-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - DV TERMINATION
	AX = DE03h
	BX = mapping context of DESQview
	DX = handle of DESQview system task
Notes:	driver should pass this call to previous handler before doing its work
	DESQview makes this call when it is exiting, but before unhooking any
	  interrupt vectors
SeeAlso: AX=DE02h,AX=DE0Fh,INT 15/AX=5407h
--------Q-2FDE04-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - ADD PROCESS
	AX = DE04h
	BX = mapping context of new process (see #0335 at INT 15/AX=1016h)
	DX = handle of process
Return: nothing
Notes:	XMS XDI handler (installed by default) allocates a 22-byte record
	  (see #2737) from "common" memory to control access to XMS memory
	all DOS, BIOS, and DV API calls are valid in handler
	driver should pass this call to previous handler after processing it
SeeAlso: AX=DE05h,AX=DE06h,INT 15/AX=5401h

Format of XMS XDI structure:
Offset	Size	Description	(Table 2737)
 00h	DWORD	pointer to 10-byte record???
 04h	DWORD	pointer to next XMS XDI structure
 08h	WORD	mapping context
 0Ah	BYTE	???
 0Bh  5 BYTEs	XMS entry point to return for INT 2F/AX=4310h"XMS"
		(FAR jump to next field)
 10h  6 BYTEs	FAR handler for XMS driver entry point
		(consists of a FAR CALL followed by RETF)
--------Q-2FDE05-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - REMOVE PROCESS
	AX = DE05h
	BX = mapping context of process (see #0335 at INT 15/AX=1016h)
	DX = handle of last task in process
Return: nothing
Notes:	XMS XDI handler releases the structure allocated by AX=DE04h
	driver should pass this call to previous handler before processing it
	all DOS, BIOS, and DV API calls except those generating a task switch
	  are valid in handler
SeeAlso: AX=DE04h,AX=DE07h,INT 15/AX=5402h
--------Q-2FDE06-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - CREATE TASK
	AX = DE06h
	BX = mapping context of process containing task
	DX = handle of new task
Notes:	driver should pass this call to previous handler after processing it
	all DOS, BIOS, and DV API calls are valid in handler
--------Q-2FDE07-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - TERMINATE TASK
	AX = DE07h
	BX = mapping context of process containing task
	DX = handle of task
Notes:	driver should pass this call to previous handler before processing it
	all DOS, BIOS, and DV API calls except those generating a task switch
	  are valid in handler
SeeAlso: AX=DE04h,AX=DE06h,AX=DE10h
--------Q-2FDE08-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - SAVE STATE
	AX = DE08h
	BX = mapping context of task being switched from
	      (see #0335 at INT 15/AX=1016h)
	DX = handle of task being switched from
Notes:	invoked prior to task swap, interrupts, etc
	driver should pass this call to previous handler after processing it
SeeAlso: AX=DE09h,INT 15/AX=5403h,INT 15/AX=DE27h
--------Q-2FDE09-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - RESTORE STATE
	AX = DE09h
	BX = mapping context of task being switched to
	      (see #0335 at INT 15/AX=1016h)
	DX = handle of task being switched to
Notes:	state is restored except for interrupts
	driver should pass this call to previous handler before processing it
SeeAlso: AX=DE08h,INT 15/AX=5404h,INT 15/AX=DE27h
--------Q-2FDE0A-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - CHANGE KEYBOARD FOCUS
	AX = DE0Ah
	BX = mapping context of task receiving focus
	DX = handle of running task
Notes:	driver should pass this call to previous handler before processing it
	this call often occurs inside a keyboard interrupt
	DV 2.42 does not provide this call to XDI handlers running inside a
	  window; instead, it directly calls the INT 2F handler which was
	  active at the time DV started
SeeAlso: INT 15/AX=DE26h,INT 15/AX=DE2Fh
--------Q-2FDE0B-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - DVP PROCESSING COMPLETE
	AX = DE0Bh
	BX = mapping context of DESQview system task
	CX = number of system memory paragraphs required for the use of all
	      XDI drivers (DV will add this to system memory in DVP buffer)
	DX = handle of DESQview system task
	SI = mapping context of new process if it starts
	ES:DI -> DVP buffer
Return: CX incremented as needed
Notes:	once DV invokes this function, the DVP buffer contents may be changed
	driver should pass this call to previous handler before processing it
--------Q-2FDE0C-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - SWAP OUT PROCESS
	AX = DE0Ch
	BX = mapping context of task being swapped out
	      (see #0335 at INT 15/AX=1016h)
	DX = handle of DESQview system task
Note:	driver should pass this call to previous handler after processing it
--------Q-2FDE0D-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - SWAP IN PROCESS
	AX = DE0Dh
	BX = mapping context of process just swapped in
	      (see #0335 at INT 15/AX=1016h)
	DX = handle of DESQview system task
Note:	driver should pass this call to previous handler before processing it
--------Q-2FDE0E-----------------------------
INT 2F C - DESQview v2.26+ External Dev Interface - DVP START FAILED
	AX = DE0Eh
	BX = mapping context of DESQview system task
	DX = handle of DESQview system task
	SI = mapping context of failed process (same as for call to AX=DE0Bh)
Note:	driver should pass this call to previous handler after processing it
--------Q-2FDE0F-----------------------------
INT 2F C - DESQview v2.50+ External Dev Interface - INITIALIZE DV
	AX = DE0Fh
Note:	DESQview 2.50+ calls this function just before it completes its
	  initialization.  At the time of the call, DESQview has not yet
	  changed any interrupt vectors
SeeAlso: AX=DE02h
--------Q-2FDE10-----------------------------
INT 2F C - DESQview v2.50+ External Dev Interface - FREE TASK
	AX = DE10h
	BX = mapping context of process (see #0335 at INT 15/AX=1016h)
	DX = task handle of process
Note:	DESQview 2.50+ calls this function before it frees the task; it is
	  similar to AX=DE07h but allows the XDI handler to make calls which
	  cause context switches
SeeAlso: AX=DE06h,AX=DE07h
--------c-2FDF00-----------------------------
INT 2F - HyperWare programs - INSTALLATION CHECK
	AX = DF00h
	BX = product code (see #2738)
	CX = 0000h
	DX = 0000h
Return: AL = status
	    00h not installed
	    FFh multiplex number in use
		CX = 5948h ('YH') if selected product installed
		---HyperDisk---
		BX = code segment of resident portion
		DX = HyperDisk local data version
Program: HyperDisk is a shareware disk cache by HyperWare (Roger Cross)
Range:	AH=C0h to AH=FFh, selected by scanning AH=DFh, then AH=C0h-FFh
SeeAlso: INT 13/AX=8EEDh
Index:	installation check;HyperDisk|installation check;HyperStb
Index:	installation check;HyperKey|installation check;HyperScreen
Index:	HyperDisk;installation check|HyperStb;installation check
Index:	HyperKey;installation check|HyperScreen;installation check

(Table 2738)
Values for HyperWare product code:
 4248h	('BH') HyperStb
 4448h	('DH') HyperDisk v4.20+
 4B48h	('KH') HyperKey
 5348h	('SH') HyperScreen
--------Q-2FDF00BX5445-----------------------
INT 2F U - Quarterdeck TELTSR.COM - INSTALLATION CHECK
	AX = DF00h
	BX = 5445h ('TE')
	CX = 4C54h ('LT')
	DX = 5352h ('SR')
Return: BX = 5454h ('TT') if installed
	CX = 494Eh ('IN') if installed
	DX = 5454h ('ST') if installed
Program: TELTSR is a Telnet TSR included with Quarterdeck's DESQview/X v2.00
	  which provides an INT 14h interface to the network
Range:	AH=DEh to AH=FFh and AH=C0h to AH=DDh, selected by scanning
SeeAlso: AX=DF01h"TELTSR",AX=DF02h"TELTSR",INT 14/AH=56h
--------N-2FDF01BX0000-----------------------
INT 2F U - MSG.COM - INSTALLATION CHECK
	AX = DF01h
	BX = 0000h
Return: AX = FDFFh if installed
	   BX = segment of resident code
Program: MSG.COM is a TSR for intercepting incoming Novell broadcast
	  messages written by Gary Dobbins (Dobbins@Arizona.Edu)
--------c-2FDF01BX4448-----------------------
INT 2F - HyperDisk v4.50+ - GET CURRENT CACHE STATE
	AX = DF01h
	BX = 4448h ('DH')
Return: AX = 0000h if function supported
	    BX = number of cache buffers in use
	    CX = number of cache buffers which have been modified
	    DL = caching flags (see #2739)
Range:	AH=C0h to AH=FFh, selected by scanning AH=DFh, then AH=C0h-FFh
SeeAlso: AX=DF00h,AX=DF02h

Bitfields for HyperDisk caching flags:
Bit(s)	Description	(Table 2739)
 0	staged writes enabled for floppy disks
 1	staged writes enabled for hard disks
 2	writes verified on floppy disks
 3	writes verified on hard disks
 4	reserved (0)
 5	reserved (0)
 6	floppy caching enabled
 7	all caching functions enabled
--------Q-2FDF01-----------------------------
INT 2F U - Quarterdeck TELTSR.COM - CLOSE CONNECTION
	AX = DF01h
Return: nothing???
Note:	invokes the DESQview/X socket API (see INT 15/AX=DE2Eh) function 0006h
	  to close the socket corresponding to the file handle set with
	  AX=DF02h; NOP if no file handle was ever set
SeeAlso: AX=DF00h"TELTSR",AX=DF02h"TELTSR"
--------c-2FDF02BX4448-----------------------
INT 2F - HyperDisk v4.50+ - SET CACHE STATE
	AX = DF02h
	BX = 4448h ('DH')
	DL = new caching flags (see #2739)
Return: AX = 0000h if supported
	    BX = number of cache buffers in use
	    CX = number of cache buffers which have been modified
	    DL = previous caching flags (see #2739)
Program: HyperDisk is a shareware disk cache by HyperWare (Roger Cross)
Range:	AH=C0h to AH=FFh, selected by scanning AH=DFh, then AH=C0h-FFh
SeeAlso: AX=DF00h,AX=DF01h
--------Q-2FDF02-----------------------------
INT 2F U - Quarterdeck TELTSR.COM - OPEN CONNECTION
	AX = DF02h
	BX = file handle for connection's socket
Return: AX = status
	    0000h successful
	    FFFFh no more room in TELTSR's JFT
Program: TELTSR is a Telnet TSR included with Quarterdeck's DESQview/X v2.00
Notes:	the indicated file handle becomes owned by TELTSR, and is closed in
	  the caller's JFT
	multiple calls to this function will override the previous assignment
	  without closing the previous file; use AX=DF01h before further calls
SeeAlso: AX=DF00h"TELTSR",AX=DF01h"TELTSR"
--------U-2FE000-----------------------------
INT 2F - SETDRVER.COM v2.10+ - INSTALLATION CHECK
	AX = E000h
Return: AX = 4A52h ("JR") if present
Program: SETDRVER is a public domain TSR by Jacob Rieper which sets the
	  apparent DOS version analogously to MS-DOS SETVER
Notes:	this installation check differs from the usual one of returning AL=FFh
	the SETDRVER API is fully emulated by Matthias Paul's FREEVER
SeeAlso: AX=E000h/DX=4D50h,AX=E001h,INT 21/AH=52h
--------j-2FE000-----------------------------
INT 2F - KAOSHIDE - INSTALLATION CHECK
	AX = E000h
Return: AL = FFh if installed
Program: KAOSHIDE ('Hidden Kaos') is a PD joke TSR which randomly capitalizes
	  alphabetic keys, written by Philip Maland. Although not a virus,
	  v2.0 uses some viral-like techniques to hide itself from
	  memory-reports by reducing DOS memory size.
--------U-2FE000DX4D50-----------------------
INT 2F - FREEVER v1.0+ - INSTALLATION CHECK
	AX = E000h
	DX = 4D50h ('MP')
Return: AL = FFh if installed
	    AH = AMIS INT 2Dh multiplex ID
	    CX = FREEVER version (CH=major, CL=minor)
	    DX:DI -> AMIS-compliant signature (see #2224)
		(vendor ID is "M. Paul ", program name is "FREEVER ")
Program: FREEVER is an AMIS-conformant freeware DOS version-faking TSR similar
	  to SETVER for any DOS-compatible OS, written by Matthias Paul
Note:	FREEVER emulates INT 21/AH=30h, INT 21/AX=3306h, INT 21/AX=4412h,
	  INT 21/AX=4452h, and SETDRVER's API on INT 2F/AX=E00xh, as well as
	  providing an AMIS API on INT 2Dh
SeeAlso: AX=E000h"SETDRVER",INT 21/AH=30h,INT 21/AX=3306h,INT 21/AX=4452h
--------K-2FE000DX5354-----------------------
INT 2F - StuffIt v3.21+ - INSTALLATION CHECK
	AX = E000h
	DX = 5354h ("ST")
Return: AL = FFh if installed
	    BX = version (BH = major, BL = BCD minor)
	    DX = segment of resident code
Program: StuffIt is a freeware delayed keyboard stuffer by Terje Mathisen
--------U-2FE001-----------------------------
INT 2F - SETDRVER.COM v2.10+ - GET SETDRVER VERSION
	AX = E001h
Return: AH = major version
	AL = minor version
SeeAlso: AX=E000h
--------U-2FE002-----------------------------
INT 2F - SETDRVER.COM v2.10+ - GET ORIGINAL DOS VERSION INFO
	AX = E002h
Return: AL = FFh if successful
	    BH = major DOS version
	    BL = minor DOS version
	    CH = DOS version flag
	    CL = OEM number
	    DH = major DR DOS version number (FFh if unknown)
	    DL = minor DR DOS version number (FFh if unknown)
SeeAlso: AX=E003h,AX=E007h,INT 21/AH=30h
--------U-2FE003-----------------------------
INT 2F - SETDRVER.COM v2.10+ - RESET INTERNAL VARIABLES
	AX = E003h
	BH = new major DOS version
	BL = new minor DOS version
	CH = new DOS version flag
	CL = new DOS revision number
	DH = new OEM number
SeeAlso: AX=E002h
--------U-2FE004-----------------------------
INT 2F - SETDRVER.COM v2.10+ - ENABLE TSR
	AX = E004h
Return: AL = FFh if successful
SeeAlso: AX=E000h,AX=E005h,AX=E006h
--------U-2FE005-----------------------------
INT 2F - SETDRVER.COM v2.10+ - DISABLE TSR
	AX = E005h
Return: AL = FFh if successful
SeeAlso: AX=E000h,AX=E004h,AX=E006h
--------U-2FE006-----------------------------
INT 2F - SETDRVER.COM v2.10+ - GET TSR STATUS
	AX = E006h
Return: AL = FFh if successful
	    BL = status
		01h resident and active
		02h resident and inactive
--------U-2FE007-----------------------------
INT 2F - SETDRVER.COM v2.10+ - GET TaskMAX STATUS AT INSTALLATION
	AX = E007h
Return: AL = FFh if successful
	    BL = status
		00h if TaskMAX not loaded before SETDRVER
		FFh if TaskMAX was loaded before SETDRVER
SeeAlso: AX=E003h
--------U-2FE0-------------------------------
INT 2F - SETDRVER.COM - RESERVED FOR FUTURE USE
	AH = E0h
	AL = 08h-10h
--------K-2FE100-----------------------------
INT 2F - Phantom2 v1.1+ - INSTALLATION CHECK
	AX = E100h
Return: AX = 0001h if installed
	    DS:SI -> ASCIZ hotkey name
	    DS:DI -> ASCIZ recording filename
Program: Phantom of the Keyboard II is a shareware keystroke recorder/replayer
	  by P2 Enterprises
SeeAlso: AX=E101h,AX=E102h,AX=E103h,AX=E300h
Index:	hotkeys;Phantom2
--------K-2FE101-----------------------------
INT 2F - Phantom2 v1.1+ - FUNCTION REQUEST
	AX = E101h
	BX = function mask (see #2740)
	CX = code for hotkey (as returned by INT 16/AH=00h) if BX bit 6 set
	DS:DX -> ASCIZ filespec if BX bit 7 set
SeeAlso: AX=E100h
Index:	hotkeys;Phantom2

Bitfields for Phantom2 function mask:
Bit(s)	Description	(Table 2740)
 0	record
 1	play
 2	QuickPlay
 3	loop
 4	mode display toggle
 5	sound toggle
 6	set hotkey
 7	set filespec
--------K-2FE102-----------------------------
INT 2F - Phantom2 v1.1+ - UNINSTALL
	AX = E102h
Return: AX = status
	    0001h removal successful
	    0002h not installed as TSR
	    FFFFh disabled but not removed
SeeAlso: AX=E100h
--------K-2FE103-----------------------------
INT 2F - Phantom2 v2.8 - SET ??? FLAG
	AX = E103h
Return: AX = 0001h
SeeAlso: AX=E100h
--------y-2FE200-----------------------------
INT 2F - SecureDevice - LOGIN TO DRIVE
	AX = E200h
	DL = drive number (0 = A:)
	DS:SI -> 104-byte key
Return: AL = status
	    00h unable to determine key's validity
	    01h key is valid
	    FFh key is invalid
Program: SecureDevice is a copylefted device driver by Max Loewenthal and
	  Arthur Helwig which turns one or more disk files into encrypted
	  logical drives
SeeAlso: AX=E201h,AX=E203h,AX=E209h
--------y-2FE201-----------------------------
INT 2F - SecureDevice - GET INFORMATION
	AX = E201h
	DX = driver index (0000h = first loaded)
Return: AL = number of volumes handled by driver
	DL = drive number of first volume (00h = A:)
SeeAlso: AX=E200h,AX=E203h,AX=E209h
--------y-2FE203-----------------------------
INT 2F - SecureDevice - DESTROY PASSWORD (LOGOUT FROM DRIVE)
	AX = E203h
	DL = drive number (00h = A:) or FFh for all drives
Return: nothing
SeeAlso: AX=E200h,AX=E209h
--------y-2FE209DX0000-----------------------
INT 2F - SecureDevice - INSTALLATION CHECK
	AX = E209h
	DX = 0000h
Return: AX = 1DEAh if installed
	    DX = number of drivers installed
--------K-2FE300-----------------------------
INT 2F - ANARKEY.COM - INSTALLATION CHECK
	AX = E300h
Return: AL = state
	    00h not installed
	    FEh if installed but suspended (v3.0+)
	    FFh installed
Program: ANARKEY.COM is a commandline recall program by Steven Calwas
Range:	AH=C0h to AH=FFh, selected by commandline switch
SeeAlso: AX=E100h,AX=E301h,AX=E302h,AX=E303h,AX=E304h,AX=E305h,AX=E306h
SeeAlso: AX=E307h,INT 66"Newkey"
--------V-2FE300-----------------------------
INT 2F - Blank - INSTALLATION CHECK
	AX = E300h
Return: AL = FFh if installed
	    ES = resident code segment
Program: Blank is a shareware screen blanker by Yonah Schmeidler
Note:	AH=E3h is the default, which may be reconfigured by the installation
	  program in the registered version
SeeAlso: AH=93h,AX=C050h,INT 14/AX=AA01h
Index:	screen saver;Blank
--------K-2FE301-----------------------------
INT 2F U - ANARKEY.COM v2+ - GET ???
	AX = E301h
Return: DX:BX -> ??? (see #2741,#2742)
SeeAlso: AX=E300h

Format of returned data structure for ANARKEY v2.0:
Offset	Size	Description	(Table 2741)
 -7   7 BYTEs	signature ('ANARKEY')
 00h	WORD	??? (I see 0001h in v2.0)
 02h	WORD	??? (I see 0001h in v2.0)
 04h	WORD	??? (I see 0 in v2.0)
 06h	WORD	PSP segment of next program loaded

Format of returned data structure for ANARKEY v3+:
Offset	Size	Description	(Table 2742)
 -1	BYTE	multiplex number
 00h	WORD	??? (I see 0001h in v3.0-4.0)
 02h	WORD	??? (I see 0001h in v3.0-4.0)
 04h	BYTE	??? (I see 0 in v3.0-4.0)
 05h	WORD	PSP segment of next program loaded
--------K-2FE302-----------------------------
INT 2F U - ANARKEY.COM v3+ - ???
	AX = E302h
	BL = ???
Return: ???
SeeAlso: AX=E300h
--------K-2FE303-----------------------------
INT 2F U - ANARKEY.COM v3+ - ANARKMD API
	AX = E303h
	BL = function
	    01h toggle insert mode
	    02h display contents of history buffer
	    03h write history buffer to file
		ES:DX -> file name
	    04h clear history buffer
	    05h undefine all aliases
	    06h show aliases
	    07h list programs using Unix switchar
	    08h jump to bottom of history buffer
	    09h (v4.0) add string to history buffer
		ES:DX -> ASCIZ string
	    0Ah (v4.0) ???
		ES:DX -> ???
	    0Bh (v4.0) copy string to edit buffer for use as next input line
		ES:DX -> ASCIZ string
	    0Ch (v4.0) ???
	    0Dh (v4.0) copy ??? to ???
	    0Eh (v4.0) ???
	    0Fh (v4.0) ???
	    10h (v4.0) set ??? flag
	    11h (v4.0) display error message about running in EMS under Windows
Return: ???
SeeAlso: AX=E300h
--------K-2FE304-----------------------------
INT 2F U - ANARKEY.COM v2+ - ???
	AX = E304h
	BL = ???
Return: ???
SeeAlso: AX=E300h
--------K-2FE305-----------------------------
INT 2F U - ANARKEY.COM v3+ - ENABLE/SUSPEND ANARKEY
	AX = E305h
	BL = new state
	    01h suspended
	    00h enabled
SeeAlso: AX=E300h
--------K-2FE306-----------------------------
INT 2F U - ANARKEY.COM v4.0 - GET ???
	AX = E306h
Return: AX = ???
SeeAlso: AX=E300h
--------K-2FE307-----------------------------
INT 2F U - ANARKEY.COM v4.0 - GET ???
	AX = E307h
Return: AX = ???
	BL = ???
SeeAlso: AX=E300h
--------K-2FE337-----------------------------
INT 2F - INT16.COM - INSTALLATION CHECK
	AX = E337h
Return: AX = 0013h if installed
Program: INT16.COM is an INT16 keyboard BIOS replacement for
	  INT 16/AH=00h-02h,10h-12h (based on K3) written by Martin Gerdes
	  and published in c't 05/1990.
SeeAlso: AX=ED58h
--------l-2FE44D-----------------------------
INT 2F - NDOS - API
	AX = E44Dh
Program: NDOS is a version of 4DOS licensed to Symantec for inclusion in the
	  Norton Utilities
Note:	as NDOS is a licensed version of 4DOS v3.03, the API is identical to
	  that for 4DOS, except that AH=E4h instead of D4h and the installation
	  check returns AX=44EEh instead of AX=44DDh
SeeAlso: AX=D44Dh,AX=E44Eh
--------l-2FE44E-----------------------------
INT 2F C - NDOS - AWAITING USER INPUT
	AX = E44Eh
	BX = condition
	    0000h NDOS is ready to display prompt
	    0001h NDOS has displayed the prompt, about to accept user input
Return: handler must preserve SI, DI, BP, SP, DS, ES, and SS
SeeAlso: AX=E44Dh
--------K-2FE44FBX0000-----------------------
INT 2F - NDOS v4.0+ - KSTACK.COM - INSTALLATION CHECK
	AX = E44Fh
	BX = 0000h
Return: AX = 44EEh if installed
Program: NDOS is a version of 4DOS licensed to Symantec for inclusion in the
	  Norton Utilities
Note:	this function is also supported by ANSIPLUS v3.01+ and K3PLUS v6.20+,
	  which emulate the 4DOS and NDOS keystack
SeeAlso: AX=D44Fh/BX=0000h,AX=E44Fh/BX=0001h
--------K-2FE44FBX0001-----------------------
INT 2F - NDOS v4.0+ - KSTACK.COM - PLACE KEYSTROKES INTO KEYSTACK
	AX = E44Fh
	BX = 0001h
	CX = number of keystrokes (01h-FFh)
	DS:DX -> keystroke list (one word per keystroke)
Return: AX = status
	    0000h successful
	    nonzero failed
	BX,CX,DX destroyed
Notes:	the keystrokes are the exact values to return from subsequent calls to
	  INT 16 with AH=00h,01h,10h, or 11h, with the following exceptions:
		0000h causes subfunctions 01h and 11h to indicate an empty
		      keyboard buffer
		FFFFh is followed by a word indicating the number of clock
		      ticks to delay before the next faked keystroke
	v4.00 KSTACK overwrites any unread keystrokes from the previous
	  invocation, and does not range-check CX; it will overwrite memory
	  following the resident portion if CX is greater than 100h.
	this function is also supported by ANSIPLUS v3.01+ and K3PLUS v6.20+,
	  which emulate the 4DOS and NDOS keystack
SeeAlso: AX=E44Fh/BX=0000h,INT 16/AH=00h,INT 21/AX=4403h"DOS"
--------U-2FE600CL30-------------------------
INT 2F - Virtual 486 - INSTALLATION CHECK
	AX = E600h
	CL = 30h
	BX = C0DEh
Return: BX = DEC0h if installed
Program: Virtual 486 is a 80486 CPU emulator for an 80386 by Solar Designer
----------2FE700BX4158-----------------------
INT 2F - Multiplex - ??? - INSTALLATION CHECK???
	AX = E700h
	BX = 4158h ("AX")
	CX = 4953h ("IS")
	DX = 4845h ("HE")
Return: AL = FFh if installed
	    BX = 4C4Fh ("LO") if ??? installed
	    CX = 4F4Bh ("OK")
	    DX = 4F55h ("OU")
		ES:DI -> ???
Range:	AH=C0h to AH=FFh, selected by scanning AH=E7-FFh, then AH=C0h-E6h
Note:	called by QDPMI when its Real to Protected Mode Switch Entry Point
	  is called
--------f-2FE77EBX0000-----------------------
INT 2F - CTDEMN - INSTALLATION CHECK
	AX = E77Eh
	BX = 0000h
	CX = 4F4Dh ('OM')
	DX = 5453h ('TS')
Return: AX = 7EE7h if installed
	    BX = resident code segment
	    CX = 6F6Dh ('om')
	    DX = 7473h ('ts')
Program: CTDEMN is a file daemon TSR by Simultan AG
--------E-2FED00-----------------------------
INT 2F - Phar Lap DOS EXTENDERS - INSTALLATION CHECK
	AX = ED00h
	BL = DOS extender ID (see #2743)
Return: AL = status
	    00h not installed
	    FFh installed
		SI = 5048h ("PH")
		DI = 4152h ("AR")
		CH = major version number
		CL = minor version number
		DX = flags
		    bit 0: running under DPMI
		    bit 1: running under Phar Lap VMM
		if running under DPMI:
		    BX = DPMI version (BH = major, BL = minor)
SeeAlso: AH=A1h,AX=F100h,AX=FBA1h

(Table 2743)
Values for Phar Lap DOS extender ID:
 01h	286dosx v1.3+ (Software Development Kit)
 02h	286dosx v1.3+ (Run-Time Kit)
 03h	386dosx v4.0+ (SDK)
 04h	386dosx v4.0+ (RTK)
--------E-2FED03-----------------------------
INT 2F R - Phar Lap 386/DOS-Extender v4.1 - GET EXTENDER ENTRY POINT
	AX = ED03h
	CX = real-mode code segment
	DX = real-mode data segment
Return: CF clear if successful
	    CX = protected-mode code segment selector
	    DX = protected-mode data segment selector
	    ES:DI -> real-mode entry point for calling protected-mode functions
		      (see INT 21/AX=250Dh)
	CF set on error
	    AX = error code
		0008h unable to allocate LDT descriptors
--------E-2FED10BL05-------------------------
INT 2F - Pharlap DOS Extender - ???
	AX = ED10h
	BL = 05h
	ES:SI -> ??? structure
Return: AX = ???
	SI = ???
	DI = ???
SeeAlso: AX=ED00h,AX=ED11h
--------E-2FED11BL05-------------------------
INT 2F - Pharlap DOS Extender - FATAL EXIT TO REAL MODE ???
	AX = ED11h
	BL = 05h
	CX = ???
	DX = ???
	ES:SI -> ??? structure
	SS:SP = new stack ???
Return: ???
Note:	called immediately prior to terminating program with INT 21/AX=4CFFh
SeeAlso: AX=ED00h,AX=ED10h
--------K-2FED58-----------------------------
INT 2F U - K5.COM - INSTALLATION CHECK
	AX = ED58h
Return: AX = 000Dh if installed
	    ES = resident code segment
	    BX = ??? (9999h)
	    ???
Program: K5 is an extended keyboard driver by Martin Gerdes, based on his K3
SeeAlso: AX=E337h,INT 16/AX=AF20h
--------E-2FED80-----------------------------
INT 2F - Phar Lap 286|DOS Extender Lite v2.5 - ???
	AX = ED80h
	BL = DOS extender ID (see #2743)
	SI = 5048h ("PH")
	DI = 4152h ("AR")
	???
Return: ???
--------O-2FEDC8BX0000-----------------------
INT 2F - Novell ??? - INSTALLATION CHECK???
	AX = EDC8h ('EDC' = Novell European Development Center)
	BX = 0000h
	CX = 0000h
	DX = 1234h
Return: ???
Desc:	called by Novell DOS 7 LOCK command during installation; purpose
	  unknown
--------y-2FEE00-----------------------------
INT 2F - GRIDLOC.EXE - INSTALLATION CHECK
	AX = EE00h
Return: AL = FFh if installed
Program: GRIDLOC is a PC security program by Intelligent Security Systems, Inc.
SeeAlso: INT 21/AH=40h"NB.SYS"
--------U-2FEE00-----------------------------
INT 2F - XVIEW - INSTALLATION CHECK
	AX = EE00h
Return: AX = 00FFh if installed
Program: XVIEW is a hypertext viewer by Flambeaux Software, Inc.
--------N-2FEE00-----------------------------
INT 2F - WEB v4.02 - INSTALLATION CHECK
	AX = EE00h
Return: AL = status
	    00h not installed
	    FFh installed
Program: WEB is an IPX-based peer-to-peer network by Webcorp.
SeeAlso: AH=EEh"WEB",AX=EEF0h
--------U-2FEE01-----------------------------
INT 2F - XVIEW - POP UP GIVING TOPIC SEARCH KEYWORD
	AX = EE01h
	DS:DX -> ASCIZ string containing case-insensitive keyword to look up
Return: AX = status (see #2744)
Note:	the specified keyword should be a hyperlink in the _IndexPage of some
	  database; the current database is searched first
SeeAlso: AX=EE00h"XVIEW",AX=EE02h,AX=EE03h,AX=EE04h,AX=EE06h

(Table 2744)
Values for XVIEW function status:
 0000h	successful
 00F1h	unknown subfunction
 00F2h	unable to pop up
--------U-2FEE02-----------------------------
INT 2F - XVIEW - POP UP GIVING A PAGE NUMBER
	AX = EE02h
	DX = physical page number or anchor page number (see #2745)
Return: AX = status (see #2744)
Note:	physical page numbers are assigned by the hypertext compiler, and
	  will change if a page is inserted in the middle
SeeAlso: AX=EE00h"XVIEW",AX=EE01h,AX=EE05h,AX=EE06h

(Table 2745)
Values for XVIEW anchor page number:
 FFEAh	_Credits
 FFECh	_SearchTopics
 FFEDh	_SearchText
 FFF0h	_ManualList
 FFF5h	_HelpOnHelp
 FFF8h	_HomePage
 FFF9h	_IndexPage
--------U-2FEE03-----------------------------
INT 2F - XVIEW - POP UP GIVING FILENAME AND SEARCH TOPIC OR PAGE NUMBER
	AX = EE03h
	DS:DX -> data packet (see #2746)
Return: AX = status (see #2744)
SeeAlso: AX=EE00h"XVIEW",AX=EE01h,AX=EE02h,AX=EE06h

Format of XVIEW data packet:
Offset	Size	Description	(Table 2746)
 00h	DWORD	-> ASCIZ database filespec (0000h:0000h for current database)
 04h	DWORD	-> ASCIZ text to look up or 0000h:0000h
 08h	WORD	page number (0000h if keyword used)
 0Ah  6 BYTEs	reserved
--------U-2FEE04-----------------------------
INT 2F - XVIEW - POP UP AND READ SCREEN FOR SEARCH TOPIC KEYWORD
	AX = EE04h
Return: AX = status (see #2744)
Note:	equivalent to the action taken when the user presses the Alt-L hotkey
SeeAlso: AX=EE00h"XVIEW",AX=EE01h,AX=EE03h,AX=EE06h
--------U-2FEE05-----------------------------
INT 2F - XVIEW - POP UP TO MOST-RECENTLY VIEWED PAGE
	AX = EE05h
Return: AX = status (see #2744)
Note:	equivalent to the action taken when the user presses the Alt-H hotkey
SeeAlso: AX=EE00h"XVIEW",AX=EE02h,AX=EE06h
--------U-2FEE06-----------------------------
INT 2F - XVIEW - WAIT FOR POP-DOWN AND GET EXIT CODE
	AX = EE06h
Return: AX = status (see also AX=EE01h)
	    0001h specified filename is not an xText database
	    0002h no databases found
	    0003h bad data in file
	    0004h memory shortage
	    0005h unable to open the requested file
	    0007h invalid page number for file
Note:	although this call is not required, the exit code can alert the
	  caller to problems; if the call is not made, the program should
	  enforce a delay of about 1/2 second to allow the viewer to pop up,
	  and should not get keyboard input or attempt disk accesses during
	  the delay
SeeAlso: AX=EE00h"XVIEW",AX=EE01h,AX=EE02h,AX=EE03h,AX=EE04h,AX=EE05h
--------N-2FEE-------------------------------
INT 2F - WEB v4.02 - WEB MODULE INSTALLATION CHECK
	AH = EEh
	AL = module ID (see #2747)
Return: AX = 0000h if installed
	    ES:DI -> far entry point for module-specific API calls
		  (see #2748,#2749,#2750,#2751,#2752)
Program: WEB is an IPX-based peer-to-peer network by Webcorp.
SeeAlso: AX=EE00h"WEB"

(Table 2747)
Values for WEB module ID:
 10h	server module (SERVER.EXE)
 20h	client module (CLIENT.EXE)
 30h	mail module (MAIL.EXE)
 40h	spooler (PCSPOOL.EXE)
 50h	kernel module (KERNEL.EXE)
 60h	SAP module (KERNEL.EXE)
 70h	resident station manager (SM.EXE)
 90h	router module (ROUTER.EXE)

(Table 2748)
Call server module entry point with:
	BX = function
	    0000h remove server module
		Return: AX = status (0000h if successful, else WEB error code)
	    0001h create SYSINFO file
		Note:	the SYSINFO file is used by the station manager when
			  displaying info for a particular station
	    0002h get server object table
		Return: CX = number of server objects
			ES:DI -> server object table
		Note:	server objects include drives and devices that the
			  server module controls
	    0003h get server variables
		Return: ES:DI -> server variables

(Table 2749)
Call client module entry point with:
	BX = function
	    0000h remove client module
		Return: AX = status (0000h if successful, else WEB error code)
	    0001h decrement client-only flag
	    0002h increment client-only flag
	    0005h set device capture
		Note:	decrements DeviceOutput flag, telling the spooler that
			  it may trap device output again
	    0006h clear device capture
		Note:	increments DeviceOutput flag, telling the spooler that
			  it should not trap device output (this is used
			  internally by the spooler to prevent it from trapping
			  its own output)
	    0007h get client debug pointer
		Return: ES:DI -> client debug data structure (see #2753)
	    0008h get root drive
		Return: AL = WEB startup drive
	    0009h get maximum possible drive/device redirections
		Return: AL = maximum drive redirections
			CH = maximum LPTx redirections
			CL = maximum COMx redirections
	    000Ah suspend client
		Return: AX = previous value of Suspend flag
	    000Bh resume client
		Return: AX = previous value of Suspend flag
	    000Ch get instance data
		CX = maximum number of structures in array
		ES:DI -> buffer for array of WIN_INSTANCE_DATA structures
			  (see #2754)
		Return: CX = number of structures actually returned
		Note:	used internally by WEB4WIN

(Table 2750)
Call mail module entry point with:
	BX = function
	    0000h remove mail module
		Return: AX = status (0000h successful, else WEB error code)
	    0001h set mail poll
		Note:	schedules the WEB mail module
	    0002h set mail notify
		Note:	sets the Notify flag, which determines whether the
			  user will be notified when mail is received
	    0003h clear mail notify
		Note:	clears the Notify flag, which determines whether the
			  user will be notified when mail is received
	    0004h check whether new mail has arrived
		Return: AL = new mail status
			    00h no new mail since last call
			    else new mail has arrived
		Note:	also clears the new-mail flag after retrieving it
	    0005h send notify
		ES:DI -> name of WEB user to be notified
	    0006h get post office
		Return: ES:DI -> full network path of Post Office subdirectory

(Table 2751)
Call spooler entry point with:
	BX = function
	    0000h remove PCSpool module
		Return: AX = status (0000h successful, else WEB error code)
	    0001h set spooler poll
		Note:	schedules the WEB spooler
	    0002h check spooler changed
		Return:	AX = 0000h
		Note:	this call is a NOP in current versions of WEB

(Table 2752)
Call kernel entry point with:
	BX = function
	    0000h remove kernel module
		Return: AX = status (0000h successful, else WEB error code)
	    0001h set kernel ^S filter
		DL = new state (00h don't filter ^S, nonzero do filter)
	    0002h get kernel data area
		Return: ES:DI -> kernel data area
	    0003h display dialog box
		CL = dialog box type
		    00h password
		    01h E-Note received notification
		    02h Novell login
		    03h general notification
		DL = number of rows to display
		ES:SI -> array of far pointers to rows to be displayed
		ES:DI -> Pascal-style input buffer
		Return: AX = status (0000h successful, else error code)
	    0004h kernel service events
	    0005h get kernel's in-critical-section flag
		Return: ES:DI -> kernel InCriticalSection flag
	    0006h schedule DOS event
		AL = directive
		    00h do not ignore WEB ExtraBusy flag
		    01h ignore ExtraBusy flag
		    02h (WEB4WIN) check that current Windows VM is foregrnd VM
		ES:SI -> WEB AES Event Control Block (ECB) (see #2755)
		Notes:	the WEB Asynchronous Event Scheduler is similar to the
			  one used by IPX; this call schedules a special ECB
			  to be executed at a later time.  Unlike IPX ECBs,
			  the timeout must be set explicitly by the caller
			this function also calls function 0004h
	    0007h check busy
		AL = directive
		    00h do not ignore WEB ExtraBusy flag
		    01h ignore ExtraBusy flag
		    02h (WEB4WIN) check that current Windows VM is foregrnd VM
		Return: AX = status (0000h not busy, else busy)
	    0008h set keyboard intercept
		Note:	currently a NOP which returns immediately
	    0009h get keyboard intercept
		Note:	currently a NOP which returns immediately
	    000Ah get dialog flags
		Return: ES:DI -> kernel dialog flags (see #2756)
	    000Bh get network path
		Return: ES:DI -> fully-qualified network path of file where
				the screen is stored on Dialog calls
	    000Ch kernel alternate dialog
		CL = dialog box type
		    00h password
		    01h E-Note received notification
		    02h Novell login
		    03h general notification
		DL = number of rows to display
		ES:SI -> array of far pointers to rows to be displayed
		ES:DI -> Pascal-style input buffer
		Return: AX = status (0000h successful, else error code)
		Note:	this function is identical to function 0003h except
			  that it does not notify WEB4WIN of the impending
			  dialog request
	    000Dh get machine/operating system type
		Return: AX = machine/operating system type
			    01h IBM PC, MS-DOS
			    02h IBM PC, DOSV (Japanese)
			    03h NEC PC-9800, JDOS (Japanese)
			    04h IBM PC, Korean DBC DOS

Format of client debug data structure:
Offset	Size	Description	(Table 2753)
 00h	WORD	total files
 02h	WORD	files free
 04h	WORD	no files
 06h	WORD	minimum files
 08h	WORD	total FCBs
 0Ah	WORD	total safe FCBs
 0Ch	WORD	FCBs in use
 0Eh	WORD	wrong FCB
 10h	WORD	compressed
 12h	WORD	retransmits

Format of WIN_INSTANCE_DATA structure:
Offset	Size	Description	(Table 2754)
 00h	DWORD	real-mode pointer to data to be instanced
 04h	WORD	size of data to be instanced

Format of WEB AES Event Control Block:
Offset	Size	Description	(Table 2755)
 00h	DWORD	link address
 04h	WORD	ESR address
 08h	BYTE	InUse flag
 09h	BYTE	completion code
 0Ah  3 BYTEs	reserved
 0Dh	WORD	timeout
 0Fh	BYTE	IgnoreExtra flag
 10h	WORD	PSP
 12h	DWORD	DTA
 16h	WORD	AX value for DOS critical information
 18h	WORD	BX value for DOS critical information
 1Ah	WORD	CX value for DOS critical information
 1Ch	WORD	DX value for DOS critical information

(Table 2756)
Values for kernel dialog flags:
 01h	dialog will timeout
 02h	display stars instead of entered keystrokes
--------N-2FEEF0-----------------------------
INT 2F - WEB v4.02 - WEB GENERAL NOTIFICATION
	AX = EEF0h
	BX = notification function ID (see #2757)
Return: varies by notification function
Program: WEB is an IPX-based peer-to-peer network by Webcorp.
Note:	the notification functions are used internally by WEB modules to notify
	  other modules and external programs of actions or event, and should
	  never be called by an application
SeeAlso: AX=EE00h"WEB"

(Table 2757)
Values for WEB Notification Function ID:
 00h	node added
 01h	node deleted
 02h	dial attempt
 03h	dial failed
 04h	file close
 05h	close connection
 07h	check Windows mode
 20h	link up
 21h	link down
--------K-2FF000-----------------------------
INT 2F U - 4MAP - INSTALLATION CHECK
	AX = F000h
Return: AX = 00FFh
Program: 4MAP is a keybinding program for 4DOS (see AX=D44Dh) by Ho-Ping Tseng
Note:	returns AX=00FFh for any value of AL not listed here
SeeAlso: AX=D44Dh,AX=F001h,AX=F002h
--------K-2FF001-----------------------------
INT 2F U - 4MAP - GET KEY MAPPINGS
	AX = F001h
Return: ES:BX -> key mappings
SeeAlso: AX=F000h
--------K-2FF002-----------------------------
INT 2F U - 4MAP - INSERT CHARACTER INTO ???
	AX = F002h
	BL = character to insert
Return: AX = status
	    0000h successful
	    0001h buffer full
SeeAlso: AX=F000h,AX=F003h
--------K-2FF003-----------------------------
INT 2F U - 4MAP - INSERT CHARACTER INTO ???
	AX = F003h
	BL = character to insert
Return: AX = status
	    0000h successful
	    0001h buffer full
Program: 4MAP is a keybinding program for 4DOS (see AX=D44Dh) by Ho-Ping Tseng
SeeAlso: AX=F000h,AX=F002h
--------m-2FF1-------------------------------
INT 2F U - MIN-MEM v2.11 - INSTALLATION CHECK
	AH = F1h
	AL <> F1h
Return: AL = F1h if installed
Program: MIN-MEM is a shareware TSR manager by Biologic which permits up to 24
	  popup TSRs to be loaded but swapped out to disk, EMS, or XMS.	 One
	  TSR at a time is brought back into memory at the user's request.
--------E-2FF100-----------------------------
INT 2F - DOS EXTENDER INSTALLATION CHECK
	AX = F100h
Return: AL = FFh if DOS extender present
	    SI = 444Fh ("DO")
	    DI = 5358h ("SX")
Note:	supported or soon to be supported by Phar Lap, Rational, Ergo, and IGC
SeeAlso: AH=A1h,AX=ED00h,AX=FBA1h/BX=0081h,INT 15/AX=BF02h
--------W-2FF200-----------------------------
INT 2F - WINX - INSTALLATION CHECK
	AX = F200h
Return: AX = 00FFh if installed
Program: WINX is a DOS/Windows utilities by Al Williams which can be used to
	  launch Windows applications from a DOS Box; it was published in
	  "DOS and Windows Protected Mode-Programming with DOS Extenders"
	  (Addison-Wesley) and should not be confused with the Windows driver
	  of the same name which is part of the DESQview/X package
--------W-2FF201-----------------------------
INT 2F - WINX - RETURN ADDRESS OF SERVER BUFFER
	AX = F201h
Return: AX = status
	    FFFFh if WINX is busy processing a different request
	    0000h if successful
		BX:CX = address of server buffer (see #2758)

Format of WINX server buffer:
Offset	Size	Description	(Table 2758)
 00h	BYTE	command/status
		00h buffer available
		01h buffer contains result
		02h change directory
		03h execute program
		FFh terminate windows portion of WINX
 01h  ? BYTEs	command (03h) or directory (02h)
  or
 01h	DWORD	result (01h)
--------W-2FF202-----------------------------
INT 2F - WINX - SET SERVER'S WORKING DIRECTORY
	AX = F202h
	BX:CX -> directory
Return: AX = status
	    FFFFh if WINX is busy processing a different request
	    0000h if successful
SeeAlso: AX=F200h,AX=F203h
--------W-2FF203-----------------------------
INT 2F - WINX - EXECUTE COMMAND
	AX = F203h
	BX:CX -> command
Return: AX = status
	    0000h if successful
	    FFFFh if WINX is busy processing a different request
SeeAlso: AX=F200h,AX=F202h
--------G-2FF400-----------------------------
INT 2F - FINDIRQ.COM - INSTALLATION CHECK
	AX = F400h
Return: AL = 01h if installed
Program: FINDIRQ is a program by Rick Knoblaugh published in the 9/28/93 issue
	  of PC Magazine; when run as a TSR it can determine which IRQs are
	  used only when a device is active
SeeAlso: AX=F401h
--------N-2FF400-----------------------------
INT 2F - PowerLAN - INSTALLATION CHECK???
	AX = F400h
	???
Return: ???
Note:	this function is called by PowerLAN's NET.EXE just prior to calling
	  AX=F401h (get version)
SeeAlso: AX=F401h"PowerLAN"
--------N-2FF401-----------------------------
INT 2F - PowerLAN - GET VERSION
	AX = F401h
Return: ES:BX -> WORD containing 100*version (in decimal)
Program: PowerLAN is a networking product by Performance Technology
SeeAlso: AX=F400h"PowerLAN",AX=F483h"PowerLAN"
--------G-2FF401CX5121-----------------------
INT 2F - FINDIRQ.COM - GET HOOKED INTERRUPTS
	AX = F401h
	CX = 5121h ('Q!')
Return: AX:DX -> hooked interrupt table (see #2759)
SeeAlso: AX=F400h

Format of FINDIRQ hooked interrupt table:
Offset	Size	Description	(Table 2759)
 00h	BYTE	1Ch
 01h	DWORD	FINDIRQ's INT 1C handler
 05h	DWORD	original INT 1C handler
 09h	BYTE	28h
 0Ah	DWORD	FINDIRQ's INT 28 handler
 0Eh	DWORD	original INT 28 handler
 12h	BYTE	2Fh
 13h	DWORD	FINDIRQ's INT 2F handler
 17h	DWORD	original INT 2F handler
--------N-2FF483-----------------------------
INT 2F - PowerLAN - ???
	AX = F483h
	???
Return: ???
SeeAlso: AX=F400h"PowerLAN",AX=F401h"PowerLAN"
--------d-2FF700-----------------------------
INT 2F - AUTOPARK.COM - INSTALLATION CHECK
	AX = F700h
Return: AL = state
	    00h not installed
	    FFh installed
Program: AUTOPARK.COM is a resident hard disk parker by Alan D. Jones
--------d-2FF701-----------------------------
INT 2F - AUTOPARK.COM - SET PARKING DELAY
	AX = F701h
	BX:CX = 32-bit count of 55ms timer ticks
--------d-2FF800CX4455-----------------------
INT 2F U - SuperStor PRO 2XON.COM - INSTALLATION CHECK
	AX = F800h
	CX = 4455h ("DU")
	DL = 45h ("E")
Return: AL = FFh if installed
	    ES:BX -> ASCII signature "Universal Data Exchange"
Program: SuperStor is a disk-compression program by Addstor.
Note:	returns AX=0001h if AL is not 00h or 01h
SeeAlso: AX=1001h,AX=F801h
--------d-2FF801CX4455-----------------------
INT 2F U - SuperStor PRO 2XON.COM - UNINSTALL
	AX = F801h
	CX = 4455h ("DU")
	DL = 45h ("E")
	ES:BX = return address if successful
Return: at specified address if successfully removed from memory
	else
	    AL = error code
	    ???
Program: SuperStor is a disk-compression program by Addstor.
Note:	returns AX=0001h if AL is not 00h or 01h
SeeAlso: AX=1001h,AX=F800h
----------2FFA00-----------------------------
INT 2F - Multiplex - ??? - INSTALLATION CHECK???
	AX = FA00h
	BX = ??? (0408h)
	CX = ??? (001Fh)
	DX = ??? (0102h)
	SI = ??? (5ACCh)
	DI = ??? (0632h)
Return: ???
Note:	called by WinEmacs at startup
----------2FFA00-----------------------------
INT 2F - Multiplex - ??? - INSTALLATION CHECK???
	AX = FA00h
	BX = ??? (03FCh)
	CX = ??? (003Fh)
	DX = ??? (00FFh)
	SI = ??? (5AA6h)
	DI = ??? (0620h)
Return: ???
Note:	called by Matlab at startup
--------*-2FFB-------------------------------
INT 2F - Multiplex - RESERVED BY BORLAND INTERNATIONAL
	AH = FBh
SeeAlso: AX=FB42h/BX=0001h
--------f-2FFB-------------------------------
INT 2F U - Conner Backup Exec AUTORES - API
	AH = FBh
	BL = function number (00h-07h)
	???
Return: ???
Program: AUTORES is a resident program launcher for unattended backups
--------a-2FFB00-----------------------------
INT 2F U - AutoBraille v1.1A - INSTALLATION CHECK
	AX = FB00h
Return: AX = 00FFh if installed
Program: AutoBraille is a shareware text-to-braille converter by KANSYS, Inc.
SeeAlso: INT 10/AX=3800h,INT 14/AX=F0F1h
--------U-2FFB00-----------------------------
INT 2F U - Jot-It! v1.50 - INSTALLATION CHECK
	AX = FB00h
Return: AX = FFFFh if installed
	    BX = version (BCD, BH=major, BL=minor)
SeeAlso: AX=FB03h"Jot-It",AX=FB01h"Jot-It"
--------a-2FFB01-----------------------------
INT 2F U - AutoBraille v1.1A - ???
	AX = FB01h
	???
Return: ???
--------U-2FFB01-----------------------------
INT 2F U - Jot-It! v1.50 - GET USER NAME
	AX = FB01h
Return: DX:BX -> ASCIZ user name
SeeAlso: AX=FB02h"Jot-It"
--------a-2FFB02-----------------------------
INT 2F U - AutoBraille v1.1A - ???
	AX = FB02h
Return: AH = ???
	AL = ???
--------U-2FFB02-----------------------------
INT 2F U - Jot-It! v1.50 - GET MESSAGE DIRECTORY
	AX = FB02h
Return: DX:BX -> ASCIZ name of directory in which messages are stored
SeeAlso: AX=FB01h"Jot-It"
--------a-2FFB03-----------------------------
INT 2F U - AutoBraille v1.1A - GET NEXT ???
	AX = FB03h
Return: AX = ???
--------U-2FFB03-----------------------------
INT 2F U - Jot-It! v1.50 - UNINSTALL
	AX = FB03h
Return: resident code removed from memory
Note:	CAUTION: NO checks are performed to ensure that the interrupt vectors
	  being unhooked (08h,09h,28h,2Fh) actually point at the Jot-It! code
SeeAlso: AX=FB00h"Jot-It"
--------a-2FFB-------------------------------
INT 2F U - AutoBraille v1.1A - SET ???
	AH = FBh
	AL = 04h-08h
Return: AX = 0000h
--------a-2FFB-------------------------------
INT 2F U - AutoBraille v1.1A - SET ???
	AH = FBh
	AL = 09h-0Fh (???, 0Eh = COM1, 0Fh = COM2)
Return: ???
Program: AutoBraille is a shareware text-to-braille converter by KANSYS, Inc.
--------a-2FFB-------------------------------
INT 2F U - AutoBraille v1.1A - SET ???
	AH = FBh
	AL = 10h-1Fh
	???
Return: ???
--------a-2FFB20-----------------------------
INT 2F U - AutoBraille v1.1A - SET ??? FLAGS
	AX = FB20h
	BL = flags to set
SeeAlso: AX=FB21h"AutoBraille"
--------a-2FFB21-----------------------------
INT 2F U - AutoBraille v1.1A - CLEAR ??? FLAGS
	AX = FB21h
	BL = flags to clear
SeeAlso: AX=FB20h"AutoBraille"
--------a-2FFB22-----------------------------
INT 2F U - AutoBraille v1.1A - SET ???
	AX = FB22h
	BL = ???
Program: AutoBraille is a shareware text-to-braille converter by KANSYS, Inc.
--------a-2FFB28-----------------------------
INT 2F U - AutoBraille v1.1A - ???
	AX = FB28h
	BX = ???
	???
Return: ???
SeeAlso: AX=FB29h"AutoBraille"
--------a-2FFB29-----------------------------
INT 2F U - AutoBraille v1.1A - ???
	AX = FB29h
	BX = ???
	???
Return: ???
SeeAlso: AX=FB28h"AutoBraille"
--------a-2FFB-------------------------------
INT 2F U - AutoBraille v1.1A - SET ???
	AH = FBh
	AL = 2Bh-34h
	BX = ???
--------a-2FFB35-----------------------------
INT 2F U - AutoBraille v1.1A - SET ???
	AX = FB35h
	BL = ???
--------a-2FFB36-----------------------------
INT 2F U - AutoBraille v1.1A - SET ???
	AX = FB36h
	BL = ???
--------a-2FFB37-----------------------------
INT 2F U - AutoBraille v1.1A - SET ???
	AX = FB37h
	BL = ???
Program: AutoBraille is a shareware text-to-braille converter by KANSYS, Inc.
--------E-2FFB42BX0001-----------------------
INT 2F PU - Borland C++ DPMILOAD.EXE - INSTALLATION CHECK???
	AX = FB42h
	BX = 0001h
Return: AX = version number??? (AL=major, AH=minor)
	CX = next-selector increment
---BC2.0---
	ES:BX -> 80-byte buffer for ???
	DX = DPMI version
---BC3.0---
	BX = ??? (0000h)
	DX = ???
	ES:SI -> list of valid selectors ???
Notes:	The version of DPMILOAD distributed with BC++ v2.0 identifies itself
	  as version 1.000, while the version distributed with BC++ 3.0
	  identifies itself as version 1.0; the former is 10864 bytes, the
	  latter 22180 bytes.  The BC2.0 version is a DPMI loader, while
	  the BC3.0 version also adds a DPMI host and DOS extender
	the BC++ 2.0 version displays an error message if called with BX
	  values other than 0001h-0008h
SeeAlso: AX=1687h,AX=FB42h/BX=1001h,AX=FB43h
--------E-2FFB42BX0002-----------------------
INT 2F PU - Borland C++ 2.0 DPMILOAD.EXE - ALLOCATE MEMORY
	AX = FB42h
	BX = 0002h
	CX = size in bytes
	DX = bit flags
	    bit 2: set to allocate DOS memory, clear for DPMI memory
	SI = selector of descriptor to be modified to access allocated memory
	DI = selector of a second descriptor to be modified
Return: AX = ??? or 0000h on error
	CX:DX = linear base address of DPMI memory block
	SI:DI = handle for DPMI memory block or FFFFh:FFFFh
	???
Note:	two segment descriptors may be set if a code and an aliased data
	  segment are required; if only one descriptor is needed, SI should
	  equal DI on entry
BUG:	when allocating DOS memory, the code computes the linear address by
	  multiplying the segment number by 4 rather than shifting by 4
SeeAlso: AX=FB42h/BX=0003h,AX=FB42h/BX=0008h,INT 31/AX=0501h
--------E-2FFB42BX0002-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ALLOCATE MEMORY
	AX = FB42h
	BX = 0002h
	ES:SI -> memory block info (see #2760)
Return: ???
Note:	The version of DPMILOAD distributed with BC++ v2.0 identifies itself
	  as version 1.000, while the version distributed with BC++ 3.0
	  identifies itself as version 1.0; the former is 10864 bytes, the
	  latter 22180 bytes.
SeeAlso: AX=FB42h/BX=0003h,AX=FB42h/BX=0008h,INT 31/AX=0501h

Format of DPMILOAD memory block info:
Offset	Size	Description	(Table 2760)
 00h	WORD	flags (see #2761)
 02h	DWORD	block size in bytes
---DPMI memory block---
 06h	DWORD	DPMI memory block handle
---DOS memory block---
 06h	WORD	real-mode segment of memory block
 08h	WORD	selector of memory block
---
 0Ah	DWORD	linear address of memory
 0Eh	WORD	memory operation error code
		0008h no more free LDT descriptors
---if flags bit 0 clear---
 10h	WORD	code segment selector for memory block or 0000h or FFFFh
 12h	WORD	data alias selector for memory block or 0000h or FFFFh
---if flags bit 0 set---
 10h	WORD	data segment selector for memory block or 0000h or FFFFh
 12h	WORD	unused???

Bitfields for DPMILOAD memory block flags:
Bit(s)	Description	(Table 2761)
 0	set if data segment rather than code segment
 1	information valid
 2	set if DOS memory block rather than DPMI memory block
 4	???
 15	set if no LDT selectors for memory block???
SeeAlso: #2760
--------E-2FFB42BX0003-----------------------
INT 2F PU - Borland C++ DPMILOAD.EXE - GET AVAILABLE MEMORY
	AX = FB42h
	BX = 0003h
Return: DX:AX = size of largest free block in paragraphs
		0000h:0000h on error (BC3.0 version only)
Note:	AX and DX are destroyed on error, but no other error indicator is
	  returned, under the BC++ 2.0 version of DPMILOAD
SeeAlso: AX=FB42h/BX=0002h
--------E-2FFB42BX0004-----------------------
INT 2F PU - Borland C++ DPMILOAD.EXE - LOAD PROTECTED-MODE EXECUTABLE???
	AX = FB42h
	BX = 0004h
	DS:DX -> ASCIZ filename of protected-mode executable
Return: CX = selector of ??? or 0000h
---BC3.0---
	DX = status (0000h,FFF4h,others???) (see #2762)
Note:	the filename may also be terminated by a CR rather than a NUL under the
	  BC++ 3.0 version of DPMILOAD

(Table 2762)
Values for DPMILOAD function status:
 0000h	successful
 0001h	??? failure
 0002h	invalid selector
 0004h	unknown error
 0008h	no more LDT descriptors available???
 FFDEh	unable to set descriptor
 FFDFh	unable to get segment base address
 FFE0h	???
 FFF2h	invalid parameter value
 FFF4h	component of filename too long (name not in 8.3 format)
 FFF5h	pathname too long (>79 chars)
 FFF6h	???
 FFF8h	???
 FFF9h	index out of range
 FFFAh	???
 FFFCh	invalid access to code segment???
 FFFEh	???
 FFFFh	general error
--------E-2FFB42BX0005-----------------------
INT 2F PU - Borland C++ DPMILOAD.EXE - GET ADDRESS OF ??? BY NAME
	AX = FB42h
	BX = 0005h
	CX = selector of DPMILOAD data (see #2763)
	DS:DX -> ASCIZ or CR-terminated name of ??? (case ignored)
Return: DX = status (see #2762)
	    0000h successful
		AX:BX -> ??? FAR function (called with two words on top of stk)
	    else
		BX destroyed
SeeAlso: AX=FB42h/BX=0006h,AX=FB42h/BX=000Eh

Format of DPMILOAD data:
Offset	Size	Description	(Table 2763)
 00h 12 BYTEs	???
 0Ch	WORD	??? bit flags
 0Eh 14 BYTEs	???
 1Ch	WORD	number of memory control records (see #2766)
 1Eh 25 BYTEs	???
 37h	BYTE	??? bit flags
		bit 4: data valid???
 38h  4 BYTEs	???
 3Ch	WORD	???
 3Eh 12 BYTEs	???
 46h	BYTE	??? counter
 47h	BYTE	???
 48h	BYTE	???
 49h	BYTE	???
 4Ah	WORD	???
 4Ch  2 BYTEs	???
 4Eh	WORD	offset of array of 64-byte memory control records
 52h	WORD	offset of name list (see #2764)
 54h  4 BYTEs	???
 58h	WORD	offset of array of 6-byte objects (see #2765)
 5Ah  8 BYTEs	???
 62h  9 BYTEs	ASCIZ name for ???
 6Bh  9 BYTEs	ASCIZ name for ???
	???

Format of name list entry [array]:
Offset	Size	Description	(Table 2764)
 00h	BYTE	length of name (00h if end of array)
 01h  N BYTEs	name
 N+1	WORD	1-based index into array of unknown 6-byte objects

Format of 6-byte objects:
Offset	Size	Description	(Table 2765)
 00h	BYTE	???
 01h	BYTE	???
 02h	BYTE	???
 03h	BYTE	1-based index of memory control record
 04h	WORD	???

Format of memory control record:
Offset	Size	Description	(Table 2766)
 00h 20 BYTEs	memory block info (see #2760)
 14h  6 BYTEs	???
 1Ah	BYTE	???
 1Bh  2 BYTEs	???
 1Dh	BYTE	??? bit flags
 1Eh 14 BYTEs	???
 2Ch	DWORD	pointer to ??? memory control record or 0000h:0000h
 30h	DWORD	pointer to ??? memory control record or 0000h:0000h
 34h	DWORD	pointer to next??? memory control record or 0000h:0000h
 38h	DWORD	pointer to prev??? memory control record or 0000h:0000h
 3Ch  4 BYTEs	???
Note:	the pointers at offsets 2Ch and 30h form a doubly-linked list, as do
	  the pointers at offsets 34h and 38h
--------E-2FFB42BX0006-----------------------
INT 2F PU - Borland C++ DPMILOAD.EXE - GET ADDRESS OF ??? BY NUMBER
	AX = FB42h
	BX = 0006h
	CX = selector of DPMILOAD data (see #2763)
	DX = 1-based index into array of ??? 6-byte objects
Return: DX = status (see #2762)
	    0000h successful
		AX:BX -> ??? FAR function (called with two words on top of stk)
	    else
		BX destroyed
SeeAlso: AX=FB42h/BX=0005h,AX=FB42h/BX=000Eh
--------E-2FFB42BX0007-----------------------
INT 2F PU - Borland C++ 2.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 0007h
	CX = selector of ???
Return: ???
Note:	The version of DPMILOAD distributed with BC++ v2.0 identifies itself
	  as version 1.000, while the version distributed with BC++ 3.0
	  identifies itself as version 1.0; the former is 10864 bytes, the
	  latter 22180 bytes.
--------E-2FFB42BX0007-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 0007h
	CX = selector of DPMILOAD data (see #2763)
	???
Return: DX = status (see #2762)
	    0000h successful
		AX = ???
--------E-2FFB42BX0008-----------------------
INT 2F PU - Borland C++ 2.0 DPMILOAD.EXE - FREE MEMORY BLOCK
	AX = FB42h
	BX = 0008h
	CX = bit flags
	    bit 2: set if DPMI memory, clear if DOS memory
	DX = selector of DOS memory block
	SI:DI = handle of DPMI memory block
Return: DX = 0000h on error, unchanged if succcessful
Note:	The version of DPMILOAD distributed with BC++ v2.0 identifies itself
	  as version 1.000, while the version distributed with BC++ 3.0
	  identifies itself as version 1.0; the former is 10864 bytes, the
	  latter 22180 bytes.
SeeAlso: AX=FB42h/BX=0002h
--------E-2FFB42BX0008-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - FREE MEMORY BLOCK
	AX = FB42h
	BX = 0008h
	ES:SI -> memory block info (see #2760)
Return: ???
SeeAlso: AX=FB42h/BX=0009h
--------E-2FFB42BX0009-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - RESIZE MEMORY BLOCK
	AX = FB42h
	BX = 0009h
	ES:SI -> memory block info (see #2760)
	???
Return: ???
SeeAlso: AX=FB42h/BX=0008h"3.0"
--------E-2FFB42BX000A-----------------------
INT 2F RU - Borland C++ 3.0 DPMILOAD.EXE - INIT DPMI HOST AND SPAWN SUBSHELL
	AX = FB42h
	BX = 000Ah
	CX = 0001h
	DX = ???
	SI = ???
Return: after user exits subshell
Notes:	this call is used by DPMIRES; unlike most of the DPMILOAD calls, this
	  function is not available in protected mode.
	the BC2.0 version of DPMILOAD is purely a DPMI loader, while the BC3.0
	  version also adds a DPMI host and DOS extender.
SeeAlso: AX=FB42h/BX=0004h,AX=FB42h/BX=0015h
--------E-2FFB42BX000B-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - UNUSED
	AX = FB42h
	BX = 000Bh
--------E-2FFB42BX000C-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - FREE DESCRIPTORS FOR MEMORY BLOCK???
	AX = FB42h
	BX = 000Ch
	ES:SI -> memory block info ??? (see #2760)
Return: DX = status???
SeeAlso: AX=FB42h/BX=000Fh
--------E-2FFB42BX000D-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - SIMULATE REAL MODE INTERRUPT
	AX = FB42h
	BX = 000Dh
	CX = number of words to copy from protected-mode to real mode stack
	DL = interrupt number
	DH = flags
	    bit 0: reset the interrupt controller and A20 line
	ES:DI -> real-mode call structure (see #2780 at INT 31/AX=0300h)
Return: CX = status
	    0000h successful
	    0001h failed
SeeAlso: INT 31/AX=0300h
--------E-2FFB42BX000E-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - GET ADDRESS OF ???
	AX = FB42h
	BX = 000Eh
	DS:DX -> ASCIZ or CR-terminated name of ???
Return: CX = selector of DPMILOAD data (see #2763) corresponding to name,
	      0000h on error
SeeAlso: AX=FB42h/BX=0006h,AX=FB42h/BX=001Fh
--------E-2FFB42BX000F-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - REALLOCATE LDT DESCRPS TO MEMBLK???
	AX = FB42h
	BX = 000Fh
	ES:SI -> memory block info (see #2760)
Return: ???
SeeAlso: AX=FB42h/BX=000Ch
--------E-2FFB42BX0010-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - CONVERT SEGMENT TO SELECTOR
	AX = FB42h
	BX = 0010h
	DX = segment number
Return: CX = status (0000h,0008h) (see also AX=FB42h/BX=0004h)
	    0000h successful
		DX = selector number for descriptor
	    0008h failed
SeeAlso: AX=FB42h/BX=0023h
--------E-2FFB42BX0011-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 0011h
	CX = selector of DPMILOAD data (see #2763)
	???
Return: DX = status (0000h,0002h,FFFEh) (see also #2762)
	    0000h successful
		AX:BX -> ??? name
	    FFFEh ??? error
--------E-2FFB42BX0012-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 0012h
	CX = selector for ???
Return: CX = selector for ???
--------E-2FFB42BX0013-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 0013h
	CX = selector of DPMILOAD data (see #2763)
	DX = 1-based index of ???
Return: CX = status (0000h,0002h,FFF9h) (see also #2762)
	    0000h successful
		BX = ??? or 0000h
	    FFF9h ??? error
--------E-2FFB42BX0014-----------------------
INT 2F RU - Borland C++ 3.0 DPMILOAD.EXE - INSTALLATION CHECK
	AX = FB42h
	BX = 0014h
	CX = 0001h
Return: BX = 0000h if installed
Note:	unlike most of the DPMILOAD functions, this call is available only in
	  real or V86 mode
SeeAlso: AX=FB42h/BX=0001h,AX=FB42h/BX=000Ah
--------E-2FFB42BX0015-----------------------
INT 2F RU - Borland C++ 3.0 DPMILOAD.EXE - UNINSTALL
	AX = FB42h
	BX = 0015h
	CX = 0001h
Return: ???
Note:	unlike most of the DPMILOAD functions, this call is available only in
	  real or V86 mode
SeeAlso: AX=FB42h/BX=000Ah
--------E-2FFB42BX0016-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - GET ???
	AX = FB42h
	BX = 0016h
	CX = selector of DPMILOAD data (see #2763)
Return: DX = status (see also AX=FB42h/BX=0004h)
	    0000h successful
		CX = ???
--------E-2FFB42BX0017-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 0017h
	CX = ???
	DX = ???
	???
Return: DX = status (0000h,0001h) (see #2762)
--------E-2FFB42BX0018-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - SET ???
	AX = FB42h
	BX = 0018h
	CX = ???
--------E-2FFB42BX0019-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 0019h
	CX = selector for ???
	???
Return: DX = status (see also AX=FB42h/BX=0004h)
	    0000h successful
		CX = selector for ???
--------E-2FFB42BX001A-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 001Ah
	CX = selector for ???
	???
Return: DX = status (see also AX=FB42h/BX=0004h)
	    0000h successful
	    0004h failed
	CX:BX -> ???
--------E-2FFB42BX001B-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 001Bh
	CX = selector of DPMILOAD data (see #2763)
	DX = offset of ???
Return: DX = status (0000h,0002h) (see also #2762)
	    0000h successful
		BX = selector for ???
		CX = selector for ???
--------E-2FFB42BX001C-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 001Ch
	ES = selector for DPMILOAD data (see #2763)
	CX = 1-based index of ???
	DX = 1-based index of ???
Return: DX = status (0000h,0002h,FFF9h) (see #2762)
--------E-2FFB42BX001D-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - GET ???
	AX = FB42h
	BX = 001Dh
Return: CX:DX = ???
--------E-2FFB42BX001E-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 001Eh
	CX = ???
	???
Return: DX = status (see also AX=FB42h/BX=0004h)
	    0000h successful
	    FFF7h ??? error
	CX:BX -> ???
--------E-2FFB42BX001F-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - GET ADDRESS OF ???
	AX = FB42h
	BX = 001Fh
	DS:DX -> 8-character name of ???
	???
Return: CX = selector of DPMILOAD data (see #2763) for ???
		0000h on error
SeeAlso: AX=FB42h/BX=000Eh
--------E-2FFB42BX0020-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - NULL FUNCTION???
	AX = FB42h
	BX = 0020h
Return: DX = ??? (always 0000h)
--------E-2FFB42BX0021-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - GET PROCESSOR EXCEPTION HANDLER VECT
	AX = FB42h
	BX = 0021h
	CL = exception number (00h-1Fh)
Return: DX = status (see also AX=FB42h/BX=0004h)
	    0000h successful
		AX:BX = selector:offset of handler
	    FFF2h unable to get exception handler vector
SeeAlso: AX=FB42h/BX=0022h,AX=FB42h/BX=0024h,INT 31/AX=0202h
--------E-2FFB42BX0022-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - SET PROCESSOR EXCEPTION HANDLER VECT
	AX = FB42h
	BX = 0022h
	CL = exception number (00h-1Fh)
	SI:DX = selector:offset of new handler
Return: DX = status (0000h,0004h,FFF2h) (see #2762)
SeeAlso: AX=FB42h/BX=0021h,AX=FB42h/BX=0025h,INT 31/AX=0203h
--------E-2FFB42BX0023-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - CONVERT SELECTOR TO SEGMENT NUMBER
	AX = FB42h
	BX = 0023h
	CX = selector
Return: DX = status (see also AX=FB42h/BX=0004h)
	    0000h successful
		CX = real-mode segment number
	    FFF2h descriptor has invalid base address for real-mode segment
SeeAlso: AX=FB42h/BX=0010h
--------E-2FFB42BX0024-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - GET PROTECTED-MODE INTERRUPT VECTOR
	AX = FB42h
	BX = 0024h
	CL = interrupt number
Return: DX = status (0000h) (see also AX=FB42h/BX=0004h)
	AX:BX = selector:offset of handler
SeeAlso: AX=FB42h/BX=0025h,INT 31/AX=0204h
--------E-2FFB42BX0025-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - SET PROTECTED-MODE INTERRUPT VECTOR
	AX = FB42h
	BX = 0025h
	CL = interrupt number
	SI:DX = selector:offset of new handler
Return: DX = status (0000h,0004h,FFF2h) (see #2762)
SeeAlso: AX=FB42h/BX=0024h,INT 31/AX=0205h
--------E-2FFB42BX0026-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - ???
	AX = FB42h
	BX = 0026h
	CX = selector of DPMILOAD data (see #2763)
	DX = 1-based index of ???
	???
Return: DX = status (0000h,0002h,FFF9h) (see #2762)
	    0000h successful
		BX = offset of ??? within data structure
--------E-2FFB42BX0027-----------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - GET ???
	AX = FB42h
	BX = 0027h
	CX = selector of DPMILOAD data (see #2763)
	DX = offset of ???
Return: DX = status (see also AX=FB42h/BX=0004h)
	    0000h successful
		BX = ???
--------E-2FFB42BX0080-----------------------
INT 2F U - ??? - CALLED BY Borland C++ 3.0 DPMILOAD.EXE
	AX = FB42h
	BX = 0080h
	???
Return: AX = ???
	???
--------E-2FFB42BX0081-----------------------
INT 2F U - ??? - CALLED BY Borland C++ 3.0 DPMILOAD.EXE
	AX = FB42h
	BX = 0081h
	???
Return: AX = ???
	???
--------E-2FFB42BX1001-----------------------
INT 2F U - Borland RTM.EXE 1.0 - INSTALLATION CHECK???
	AX = FB42h
	BX = 1001h
Return: BX = 0000h
SeeAlso: AX=FB42h/BX=0001h,AX=FB42h/BX=1002h,AX=FB42h/BX=1003h
--------E-2FFB42BX1002-----------------------
INT 2F U - Borland RTM.EXE 1.0 - ???
	AX = FB42h
	BX = 1002h
	???
Return: ???
SeeAlso: AX=FB42h/BX=1001h
--------E-2FFB42BX1003-----------------------
INT 2F U - Borland RTM.EXE 1.0 - ???
	AX = FB42h
	BX = 1003h
	???
Return: ???
SeeAlso: AX=FB42h/BX=1001h
--------E-2FFB43-----------------------------
INT 2F PU - Borland C++ 3.0 DPMILOAD.EXE - NULL FUNCTION
	AX = FB43h
	BX = subfunction (at least 0000h-000Eh)
Notes:	this function is only present in protected mode; it does nothing but
	  an immediate IRET
	DPMILOAD.EXE itself calls various subfunctions:
	    subfunction 0004h is called with CX=selector of ???, DI=selector
		  of DPMILOAD data
	    subfunction 0008h is called with CX=selector of DPMILOAD data
SeeAlso: AX=FB42h/BX=0001h
--------G-2FFB43BX0100-----------------------
INT 2F PU - Borland TDX - INSTALLATION CHECK
	AX = FB43h
	BX = 0100h
Return: BX = FB43h if loaded
Program: TDX is Borland's Turbo Debugger variant for DPMI programs
Note:	Borland Pascal 7 DPMI programs use this call to check whether they
	  should install their own stack and general protection exception
	  handlers, or allow TDX to handle those exceptions
--------a-2FFB64-----------------------------
INT 2F U - AutoBraille v1.1A - GET ???
	AX = FB64h
Return: AX = ??? (0006h seen)
Program: AutoBraille is a shareware text-to-braille converter by KANSYS, Inc.
--------E-2FFBA1BX0081-----------------------
INT 2F U - TKERNEL (Borland DOS extender) - INSTALLATION CHECK
	AX = FBA1h
	BX = 0081h
	ES:DI -> 16-byte buffer
Return: if installed, first four bytes of ES:DI buffer are "IABH"
Program: TKERNEL is a licensed version of AI Architects/Ergo's OS/x86.
Note:	TKERNEL was present only in Borland C++ 2.0; with version 3.0, the DOS
	  extender was moved into DPMILOAD.
SeeAlso: AH=A1h,AX=F100h,AX=FBA1h/BX=0082h,AX=FBA1h/BX=0084h,INT 15/AX=BF02h
SeeAlso: INT 21/AX=4403h"AI Architects"
--------E-2FFBA1BX0082-----------------------
INT 2F U - TKERNEL (Borland DOS extender) - GET ENTRY POINT
	AX = FBA1h
	BX = 0082h
	ES:DI -> response buffer (see #2767)
Return: ES:DI buffer filled
SeeAlso: AX=FBA1h/BX=0081h,AX=FBA1h/BX=0084h

Format of TKERNEL response buffer:
Offset	Size	Description	(Table 2767)
 00h  4 BYTEs	signature "IABH"
 04h	DWORD	pointer to FAR extender entry point (see #2768)

(Table 2768)
Call TKERNEL entry point with:
	AX = function number
	    0000h initialize???
		STACK:	WORD  ???
		Return: AX = status???
			STACK unchanged
	    0001h get version???
		Return: AX = 0200h for v2.0.34
	    0002h get ???
		Return: AX = ??? (011Eh or 0182h seen)
	    0003h load protected-mode executable
		STACK:	DWORD -> ASCIZ filename of executable
			DWORD	???
			DWORD -> program arguments (counted string plus CR)
			DWORD -> environment for protected-mode executable
				(terminated with two consecutive NULs)
			DWORD -> WORD buffer for ???
		Return: AX = status???
			STACK unchanged
	    0004h get descriptor
		STACK:	WORD	selector for which to get descriptor
			WORD	segment number (when running in real mode)
			DWORD -> buffer for descriptor
		Return: CF clear if successful
			    buffer filled
			CF set on error
			    AX destroyed???
			STACK unchanged
	    0005h ???
		STACK:	WORD	selector for ???
			WORD	subfunction number???
				0000h run previously-loaded program???
				0001h ??? (similar to 0000h)
				0002h
				0003h
				0005h ??? (similar to 0000h and 0001h)
		Return: AX = status???
			STACK unchanged
	    0006h ???
		STACK:	WORD ???
			DWORD -> WORD (call) max iterations of ???
				      (ret) remaining iterations
		Return: AX = ???
			STACK unchanged
	    0007h unused
		Return: AX = 0001h
	    0008h unused
		Return: AX = 0001h
	    0009h copy protected-mode memory into conventional memory
		STACK:	WORD	selector for source segment
			WORD	segment of source if in real mode???
			DWORD	offset of source
			WORD	number of bytes to copy
			DWORD -> low-memory destination
		Return: AX = status
			STACK unchanged
	    000Ah copy conventional memory into protected-mode memory
		STACK:	WORD	selector for destination segment
			WORD	segment of destination if in real mode???
			DWORD	offset of destination
			WORD	number of bytes to copy
			DWORD -> low-memory source
		Return: AX = status
			STACK unchanged
	    000Bh get ??? pointers
		STACK:	WORD desired pointer
				0000h get ???
				0002h get protected-mode CR3
				0003h get 4K page table buffer pointer
				else Return: DX:AX = FFFFh:FFFFh
		Return: DX:AX = requested pointer
			STACK unchanged
	    000Ch set ??? pointers
		STACK:	WORD desired pointer
				0000h set ???
				0002h set protected-mode CR3
				0003h set 4K page table buffer pointer
				else ignore
			DWORD new value for pointer
		Return: STACK unchanged
	    000Dh get ??? pointers
		STACK:	WORD desired pointer
				0000h get ???
				0001h get ???
				0002h get ???
				0003h get ???
				0004h get ???
				0005h get ???
				0006h get ???
				0007h get ???
				else Return: DX:AX = FFFFh:FFFFh
		Return: DX:AX = desired pointer
			STACK unchanged
	    000Eh set ??? pointer
		STACK:	WORD desired pointer
				0000h set ???
				0001h set ???
				0002h set ???
				0003h set ???
				0004h set ???
				0005h set ???
				0006h set ???
				0007h set ???
				else Return: DX:AX = FFFFh:FFFFh
		Return: STACK unchanged
	    000Fh get ???
		Return: AX = ??? (seen 0008h)
	    0010h get ???
		Return: AX = ???
	    0011h determine whether selector is valid
		STACK:	WORD	possible selector
		Return: AX = selector or 0000h if invalid
			STACK unchanged
	    0012h get physical address
		STACK:	WORD	selector for desired segment
			WORD	segment number if in real mode
			DWORD	offset within segment
		Return: DX:AX = 32-bit physical address or 00000000h on error
			BX destroyed
			STACK unchanged
	    0013h ???
		Note:	normally jumps to code for function 0012h
	    0014h copy protected-mode memory to conventional memory, with ???
		STACK:	WORD	selector for source segment
			WORD	segment of source if in real mode???
			DWORD	offset of source
			WORD	number of bytes to copy
			DWORD -> low-memory destination
		Return: AX = status???
			STACK unchanged
	    0015h copy conventional memory to protected-mode memory, with ???
		STACK:	WORD	selector for destination segment
			WORD	segment of destination if in real mode???
			DWORD	offset of destination
			WORD	number of bytes to copy
			DWORD -> low-memory source
		Return: AX = status???
			STACK unchanged
	    0016h set ??? pointer
		STACK:	WORD	unused
			DWORD -> ??? or 0000h:0000h
		Return: AX = 0000h
			STACK unchanged
	    0017h allocate real-mode procedure???
		STACK:	DWORD	ASCIZ name of procedure
			DWORD ???
			DWORD	address of subroutine to invoke
		Return: AX = status
			    0032h procedure by that name exists
			    0033h no more real-mode procedures available
			DX destroyed
			STACK unchanged
	    0018h unused
		Return: AX = 0001h
	    0019h get parameter block
		Return: DX:AX -> parameter block (format unknown at this time,
				  but 92h bytes)
				  (preceded by signature "!!PARAM-BLOCK!!")
	    001Ah get ???
		Return: AX = ??? (0148h seen)
	    001Bh free real-mode procedure???
		STACK:	DWORD -> ASCIZ name of procedure
		Return: ???
			STACK unchanged
	    001Ch check whether packets from protected mode task pending
		Return: AX = 0001h if packets pending, 0000h if not
	    001Dh set ???
		STACK:	DWORD ??? or 0000h:0000h
		Return: AX,BX destroyed
			STACK unchanged
	    001Eh ???
		STACK:	WORD ??? (high byte ignored)
			DWORD -> data structure (below)
		Return: AX,BX,CX,DX destroyed
			data structure updated
			STACK unchanged
		Format of data structure:
		Offset	Size	Description
		 00h  2 BYTEs	unused
		 02h	WORD	???
		 04h	WORD	???
		 06h	WORD	???
		 08h  2 BYTEs	unused
		 0Ah	WORD	???
		 0Ch	WORD	(call) ???
				(ret) offset of this data structure (BUG?)
	    001Fh set ???
		STACK:	WORD ??? (set to 0001h if zero)
		Return: AX destroyed
			STACK unchanged
	    0020h ???
		STACK:	DWORD -> ??? (8 bytes of data)
		Return: AX = ???
			STACK unchanged
	    0021h ???
		STACK:	DWORD -> ??? (8 bytes of data)
			WORD	???
			WORD	???
		Return: AX = ???
			STACK unchanged
	    0022h ???
		STACK:	DWORD -> ??? (8 bytes of data)
			DWORD -> 4-byte buffer for results
		Return: AX = ???
			STACK unchanged
	    0023h ???
		STACK:	DWORD -> ??? (8 bytes of data)
		Return: AX = ???
			STACK unchanged
	    0024h set ???
		STACK:	WORD ???
		Return: AX destroyed
			STACK unchanged
	    0025h get ???
		Return: AX = ??? (value set with func 0024h)
	    0026h BUG: jumps to hyperspace due to fencepost error
	    FFFFh set DOS memory management functions
		BX:SI -> FAR routine for allocating DOS memory
			  (called with AH=48h,BX=number of paragraphs to alloc;
			  returns CF clear, AX=segment of allocated memory, or
				  CF set on error)
		CX:DI -> FAR routine for freeing DOS memory
			  (called with AH=49h,ES=segment of block to free;
			  returns CF set on error, AX=error code)
		Note: each of these pointers normally points at INT 21/RETF
	    other Return: AX = 0001h
Note:	BX may be destroyed by any of the API calls
--------E-2FFBA1BX0084-----------------------
INT 2F U - TKERNEL (Borland DOS extender) - UNINSTALL
	AX = FBA1h
	BX = 0084h
	ES:DI -> response buffer (see #2769)
Return: ES:DI buffer filled
SeeAlso: AX=FBA1h/BX=0081h,AX=FBA1h/BX=0084h

Format of TKERNEL response buffer:
Offset	Size	Description	(Table 2769)
 00h  4 BYTEs	signature "IABH"
 04h	WORD	success indicator
		0001h failed (INT 2F hooked by another program)
		unchanged if successful
 06h	WORD	segment of ???
 08h	WORD	segment of ??? memory block to free if nonzero
 0Ah	WORD	segment of ??? memory block to free if nonzero
--------s-2FFBFBES0000-----------------------
INT 2F U - SoundBlaster speech driver - INSTALLATION CHECK
	AX = FBFBh
	ES = 0000h
Return: ES nonzero if installed
	    ES:BX -> entry point data structure (see #2770)
SeeAlso: INT 80/BX=0000h,INT F3"SoundBlaster"

Format of SoundBlaster entry point data structure:
Offset	Size	Description	(Table 2770)
 00h  3 BYTEs	signature "FB "
 03h	BYTE	driver major version number???
 04h	DWORD	speech driver entry point (see #2771)
 08h 24 BYTEs	???
 20h  ? BYTEs	data buffer for calling speech driver
		  (can be 117 bytes or more)

(Table 2771)
Call SoundBlaster speech driver entry point with:
	AL = function
	    07h speak a string
		data buffer (see #2770) contains:
			BYTE  length of string
		      N BYTEs string to speak
--------K-2FFD12-----------------------------
INT 2F - KS/KEYSTKCT.EXE - INSTALLATION CHECK
	AX = FD12h
Return: AX = 0093h if installed
	    ES = resident code segment
	    ES:CX -> internal "putbuf" routine
Program: KS/KEYSTKCT.EXE is a key stacking utility (4DOS KEYSTACK.SYS
	  look-alike) by Martin Gerdes, published in c't 11/1991, which can be
	  loaded as a device driver or as a TSR. It does not emulate 4DOS
	  KSTACK API
Note:	the default buffer size is 128 keys
--------N-2FFE00BX4454-----------------------
INT 2F - PC-NFS ??? - INSTALLATION CHECK
	AX = FE00h
	BX = 4454h ("DT")
	CX = 4B52h ("KR")
	DX = 4E4Dh ("NM")
Return: AL = FFh if installed
	   BX = 524Eh ("RM")
	   CX = 4D44h ("MD")
	   DX = 544Bh ("TK")
Note:	DV/X 1.10 DVPCNFS.DVR searches AH=FEh,FFh,C0h-FDh for a valid response
SeeAlso: AX=FE08h
--------N-2FFE00BX4454-----------------------
INT 2F - PC-NFS ??? - INSTALLATION CHECK
	AX = FE00h
	BX = 4454h ("DT")
	CX = 4B52h ("KR")
	DX = 544Dh ("TM")
Return: AL = FFh if installed
	   BX = 5254h ("RT")
	   CX = 4D44h ("MD")
	   DX = 544Bh ("TK")
Note:	DV/X 1.10 DVPCNFS.DVR searches AH=FEh,FFh,C0h-FDh for a valid response
SeeAlso: AX=FE08h
--------U-2FFE00DI4E55-----------------------
INT 2F U - NORTON UTILITIES 5.0+ TSRs - INSTALLATION CHECK/STATUS REPORT
	AX = FE00h
	DI = 4E55h ("NU")
	SI = TSR identifier (see #2772)
Return: SI = TSR reply
	    lowercase version of SI on entry (i.e. SI OR 2020h)
	    execpt SMARTCAN v8.0, which returns SI=6673h ('fs')
	AH = status
	    00h installed but disabled internally
	    01h installed and enabled
	AL = installed product
	    00h NCACHE-x or DISKREET
	    01h SPEEDRV / FILESAVE / EP / DISKMON v6+ installed
	    02h NCACHE2 / SMARTCAN
	    45h DISKMON v5 installed
	BX = length of *.INI file (DISKMON and FILESAVE/EP/SMARTCAN only)
	      (see #2773,#2774)
	CX = segment of resident portion
	    FFFFh if completely loaded high (NCACHE)
---FILESAVE/EP---
	DL = ??? (apparently always 00h)
---DISKMON---
	DX = ??? (apparently always 1AE6h [v5] / 1B86h [v6] / 1C26h [v7])
Notes:	the value returned in CX is incorrect for NCACHE 6.00
	all Norton Caches install as SMARTAAR drivers like SMARTDRV v3
	NCACHE2 and SPEEDRV both support the SMARTDRV v4+ installation check
	to detect Diskreet NDisk drives use CDS/DPB (see INT 21/AH=52h)
SeeAlso: AX=4A10h/BX=0000h,AX=FE01h,AX=FE02h,AX=FE03h,AX=FE04h,AX=FE05h
SeeAlso: INT 21/AX=4402h"SMARTDRV"

(Table 2772)
Values for Norton Utilities TSR identifier:
 4346h	("CF") NCACHE-F (v5) / NCACHE (v6) / NCACHE2 (v7+) / SPEEDRV
 4353h	("CS") NCACHE-S (v5 only)
 4443h	("DC") DISKREET
 444Dh	("DM") DISKMON
 4653h	("FS") FILESAVE (v5) / EP (v6) / SMARTCAN (v7+)

Format of DISKMON.INI file:
Offset	Size	Description	(Table 2773)
-6Ch 108 BYTEs	(in memory copy only)
		list of filenames which are always protected:
		  IBMBIO.COM/IBMDOS.COM, IO.SYS/MSDOS.SYS, TBIOS.SYS/TDOS.SYS,
		  MIO.SYS/IO.BIN, COMMAND.COM
 00h	BYTE	??? always 01h
 01h	BYTE	disk light (00h off, 01h on)
 02h	BYTE	disk protection (00h off, 01h on)
 03h	BYTE	protected areas
		01h system area
		02h files
		03h system area and files
		04h entire disk
 04h	BYTE	floppy access (00h not allowed, 01h allowed)
 05h 27 BYTEs	filename extension list (9 entries)
		(lowercase, blank padded or = 000000h)
 20h 240 BYTEs	filename list (20 entries)
		(lowercase, name and extension blank padded, with '.')
Note:	CX:0508h -> copy in installed TSR (v5)
	CX:052Fh -> copy in installed TSR (v6)
	CX:04E0h -> copy in installed TSR (v7-v8)

Format of FILESAVE.INI / EP.INI / SMARTCAN.INI file:
Offset	Size	Description	(Table 2774)
 00h 26 BITs	drive list (bit set: file protection on, cleared: off):
 00h	BYTE	drives	A: - H:
 01h	BYTE	drives	I: - P:
 02h	BYTE	drives	Q: - X:
 03h	BYTE	drives	Y: - Z:
 04h	BYTE	which files to protect
		00h all files
		01h all files with extension in list
		02h all files except those with extension in list
 05h 27 BYTEs	filename extension list (9 entries, uppercase, ASCIZ)
 20h	BYTE	include files with archive bit clear (00h no, 01h yes)
 21h	WORD	number of days after which files are purged (0 = never)
 23h	WORD	max kilobytes of erased file space to hold (0 = all)
Note:	CX:03D2h -> copy in installed TSR (v5)
	CX:03F5h -> copy in installed TSR (v6)
	CX:0434h -> copy in installed TSR (v7-v8)
--------U-2FFE00DX474F-----------------------
INT 2F - GO! v3.22+ - API
	AX = FE00h
	DX = 474Fh ('GO')
	SI = function number
	    0063h (BCD for '?') installation check
	    0078h (BCD for 'N') non-registered search (two levels only)
	    0082h (BCD for 'R') reserved for registered version
	    0083h (BCD for 'S') reserved for registered version
	    0085h (BCD for 'U') uninstall
	BX:CX -> buffer (for search functions)
		buffer filled with search spec, i.e. "APL" to get first
		  directory containing the substring APL, ":\APL" to find
		  the first top-level directory beginning with the letters
		  APL
Return: BX:CX buffer filled with result (search functions only)
		result is counted ASCIZ directory name, empty string if
		no matches (i.e. first byte is length of name, followed by
		name)
Program: GO! is a shareware directory locator TSR by Steve Ryckman
Note:	the application-supplied buffer for the requests and results which
	  BX:CX points at must lie outside the conventional (low-640K)
	  memory, since the TSR swaps memory on pop-up; a common location is
	  the last 96 bytes of the video memory or a UMB
--------U-2FFE01DI4E55-----------------------
INT 2F U - NORTON UTILITIES 5.0+ TSRs - ENABLE
	AX = FE01h
	DI = 4E55h ("NU")
	SI = TSR identifier (see #2772)
Return: SI = TSR reply (lowercase version of entry SI, i.e. SI OR 2020h)
	AX = status
	    0002h successful (DISKMON, FILESAVE, EP)
	    FE00h successful (NCACHE-x, DISKREET)
Notes:	if the enable/disable calls are used on DISKMON or NCACHE-x, the status
	  report generated by the programs still indicates the previous state,
	  and DISKMON.INI is not updated
	apparently has no effect on DISKREET
SeeAlso: AX=FE00h,AX=FE02h
--------U-2FFE02DI4E55-----------------------
INT 2F U - NORTON UTILITIES 5.0+ TSRs - DISABLE
	AX = FE02h
	DI = 4E55h ("NU")
	SI = TSR identifier (see #2772)
Return: SI = TSR reply (lowercase version of entry SI, i.e. SI OR 2020h)
	AX = status
	    0004h successful (DISKMON, FILESAVE)
	    FE00h successful (NCACHE-x, DISKREET)
Notes:	(see also AX=FE01h)
	this function appears to be unsafe, as the cache buffers are not
	  flushed
SeeAlso: AX=FE00h,AX=FE01h
--------U-2FFE03DI4E55-----------------------
INT 2F U - NORTON UTILITIES 5.0+ TSRs - FLUSH BUFFERS
	AX = FE03h
	DI = 4E55h ("NU")
	SI = TSR identifier (see #2772)
Return: SI = TSR reply (lowercase version of entry SI, i.e. SI OR 2020h)
	AX = status
	    0006h successful???
Notes:	only supported by DISKMON, FILESAVE, and NCACHE-x
	useful for flushing NCACHE before rebooting
SeeAlso: AX=FE00h,AX=FE10h
--------U-2FFE04DI4E55-----------------------
INT 2F U - NORTON UTILITIES 5.0+ DISKMON, FILESAVE / EP - internal - ???
	AX = FE04h
	DI = 4E55h ("NU")
	SI = TSR identifier (see #2772)
Return: SI = TSR reply (lowercase version of entry SI, i.e. SI or 2020h)
	AX = status
	    0008h successful???
SeeAlso: AX=FE00h
--------U-2FFE05DI4E55-----------------------
INT 2F U - NORTON UTILITIES 5.0+ DISKMON, FILESAVE / EP - internal - ???
	AX = FE05h
	DI = 4E55h ("NU")
	SI = TSR identifier (see #2772)
Return: SI = TSR reply (lowercase version of entry SI, i.e. SI or 2020h)
	AX = status
	    000Ah successful???
Note:	reportedly dangerous
SeeAlso: AX=FE00h
--------N-2FFE08-----------------------------
INT 2F - PC-NFS ??? - GET ???
	AX = FE08h
Return: ES:BX -> ???
Notes:	DV/X 1.10 DVPCNFS.DVR searches AH=FEh,FFh,C0h-FDh for a valid response
	both the driver responding to AX=FE00h/DX=4E4Dh and the one responding
	  to AX=FE00h/DX=544Dh support this function
SeeAlso: AX=FE00h/BX=4454h
--------U-2FFE10DI4E55-----------------------
INT 2F U - NORTON UTILITIES 6.0 NCACHE - REBOOT
	AX = FE10h
	DI = 4E55h ("NU")
	SI = TSR identifier (see #2772)
Return: SI = TSR reply (lowercase version of entry SI, i.e. SI or 2020h)
	AX = status
Note:	probably used to flush NCACHE buffers and reboot when Ctrl-Alt-Del is
	  detected
SeeAlso: AX=FE03h
--------S-2FFEEF-----------------------------
INT 2F - RTS Control TSR - INSTALLATION CHECK
	AX = FEEFh
Return: AX = EFFEh if installed
	    BX = port address
Program: RTS Control TSR is a utility by Michal Szokolo to lower the RTS
	  signal on a COM port during disk accesses to avoid losing incoming
	  data
--------N-2FFF00-----------------------------
INT 2F - Topware Network Operating System - INSTALLATION CHECK
	AX = FF00h
Return: AL = status
	    00h not installed, OK to install
	    01h not installed, not OK to install
	    FFh installed
SeeAlso: AX=FF01h,AX=FF02h,AX=FF10h,INT 21/AX=FF00h"Topware",INT 7A"Topware"
--------N-2FFF01-----------------------------
INT 2F - Topware Network Operating System - GET VERSION
	AX = FF01h
Return: AX = version
SeeAlso: AX=FF00h,AX=FF02h
--------N-2FFF02-----------------------------
INT 2F - TopWare Network OS v5.10+ - GET TopNet VERSION STRING
	AX = FF02h
Return: ES:BX -> version string
SeeAlso: AX=FF00h,AX=FF01h
--------N-2FFF10-----------------------------
INT 2F - TopWare Network OS v5.10+ - TopTerm - INSTALLATION CHECK
	AX = FF10h
Return: AL = status (00h not installed, 01h installed)
SeeAlso: AX=FF00h,AX=FF11h,AX=FF12h,AX=FF13h
--------N-2FFF11-----------------------------
INT 2F - TopWare Network OS v5.10+ - TopTerm - ENABLE KEYBOARD SERVICE
	AX = FF11h
Note:	this function is only available on workstations, not on the server
SeeAlso: AX=FF10h,AX=FF12h
--------N-2FFF12-----------------------------
INT 2F - TopWare Network OS v5.10+ - TopTerm - DISABLE KEYBOARD SERVICE
	AX = FF12h
Note:	this function is only available on workstations, not on the server
SeeAlso: AX=FF10h,AX=FF11h
--------N-2FFF13-----------------------------
INT 2F - TopWare Network OS v5.10+ - TopTerm - SET INSTALLATION FLAG
	AX = FF13h
	CL = new state (00h off, 01h on)
SeeAlso: AX=FF10h
--------N-2FFF14-----------------------------
INT 2F - TopWare Network OS v5.10+ - START BACKGROUND RECEIVE VIDEO DATA
	AX = FF14h
Note:	this function is only available on workstations, not on the server
SeeAlso: AX=FF10h,AX=FF15h
--------N-2FFF15-----------------------------
INT 2F - TopWare Network OS v5.10+ - END BACKGROUND RECEIVE VIDEO DATA
	AX = FF15h
Note:	this function is only available on workstations, not on the server
SeeAlso: AX=FF10h,AX=FF14h
--------N-2FFF16-----------------------------
INT 2F - TopWare Network OS v5.10+ - SET CONTROL NUMBER OF "SHOW" SCREEN
	AX = FF16h
	BL = which to set (00h TopShow, FFh TopTerm)
	CX = destination screen
	    0000h all stations
	    0000h-00FFh (TopTerm only) send to group CL
	    8001h-80FEh send to station CL
SeeAlso: AX=FF18h
--------N-2FFF18-----------------------------
INT 2F - TopWare Network OS v5.10+ - SEND FULL SCREEN OF DATA FOR TopShow
	AX = FF18h
SeeAlso: AX=FF00h,AX=FF16h,AX=FF27h
--------N-2FFF23-----------------------------
INT 2F - TopWare Network OS v5.10+ - CLOSE SPOOL FILES AND START PRINTING
	AX = FF23h
SeeAlso: AX=FF00h
--------N-2FFF27-----------------------------
INT 2F - TopWare Network OS v5.10+ - GET "SHOW" TYPE
	AX = FF27h
Return: AL = type (00h complete version, 01h simple version)
	BL = "show" functions flag (00h disabled, 01h enabled)
SeeAlso: AX=FF16h,AX=FF18h
--------D-30---------------------------------
INT 30 - (NOT A VECTOR!) - DOS 1+ - FAR JMP instruction for CP/M-style calls
   the CALL 5 entry point does a FAR jump to here
Note:	under DOS 2+, the instruction at PSP:0005 points two bytes too low in
	  memory
SeeAlso: INT 21/AH=26h
--------V-30---------------------------------
INT 30 - QRIP/TSR - USED BY GRAPHICS LIBRARY
Program: QRIP/TSR is a shareware TSR by Shane Hathaway implementing the Remote
	  Imaging Protocol (RIP, RIPscrip) used by several BBS systems to
	  provide a graphical user interface
SeeAlso: INT 2F/AX=ACF0h
--------W-30---------------------------------
INT 30 P - MS Windows 3.1+ - PROTECTED-MODE CALLBACK
SeeAlso: INT 20"Windows"
--------D-31---------------------------------
INT 31 - overwritten by CP/M jump instruction in INT 30
--------v-31---------------------------------
INT 31 - VIRUS - "Vacsina" series - INSTALLATION CHECK (NOT A VECTOR!)
Note:	if one of the Vacsina viruses is resident, the low byte of this
	  interrupt still contains the last byte of the INT 30 CP/M JMP
	  instruction, but the remaining three bytes are 7Fh 39h followed
	  by the Vacsina version number
SeeAlso: INT 21/AX=FFFFh"VIRUS",INT 32"VIRUS"
--------E-310000-----------------------------
INT 31 P - DPMI 0.9+ - ALLOCATE LDT DESCRIPTORS
	AX = 0000h
	CX = number of descriptors to allocate
Return: CF clear if successful
	    AX = base selector
	CF set on error
	    AX = error code (DPMI 1.0+) (see #2775)
Notes:	DPMI is the DOS Protected-Mode Interface
	the base and limit of the returned descriptors will be 0, and the type
	  will be "data"
	add the value returned by INT 31/AX=0003h to move to subsequent
	  descriptors if multiple descriptors were allocated
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0001h,AX=000Dh,INT 21/AX=3501h

(Table 2775)
Values for DPMI 1.0 error code:
 0000h-7FFFh DOS error passed through by DPMI
 8001h	unsupported function
 8002h	object in wrong state for function
 8003h	system integrity would be endangered
 8004h	deadlock detected
 8005h	pending serialization request cancelled
 8010h	out of DPMI internal resources
 8011h	descriptor unavailable
 8012h	linear memory unavailable
 8013h	physical memory unavailable
 8014h	backing store unavailable
 8015h	callback unavailable
 8016h	handle unavailable
 8017h	maximum lock count exceeded
 8018h	shared memory already serialized exclusively by another
 8019h	shared memory already serialized shared by another client
 8021h	invalid value for numeric or flag parameter
 8022h	invalid segment selector
 8023h	invalid handle
 8024h	invalid callback
 8025h	invalid linear address
 8026h	request not supported by hardware
--------E-310001-----------------------------
INT 31 P - DPMI 0.9+ - FREE LDT DESCRIPTOR
	AX = 0001h
	BX = selector to free
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8022h) (see #2775)
Notes:	only one descriptor is freed per call
	the program's initial CS, DS, and SS descriptors may be freed
	(DPMI 1.0+) any segment registers containing the freed selector are
	  set to 0000h
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0000h,AX=000Ah,AX=000Dh,INT 21/AX=3502h
--------E-310002-----------------------------
INT 31 P - DPMI 0.9+ - SEGMENT TO DESCRIPTOR
	AX = 0002h
	BX = real mode segment
Return: CF clear if successful
	    AX = selector corresponding to real mode segment (64K limit)
	CF set on error
	    AX = error code (DPMI 1.0+) (8011h) (see #2775)
Notes:	multiple calls for the same real mode segment return the same selector
	the returned descriptor can never be modified or freed
	not supported by MS Windows 3.0 in Standard mode
--------E-310003-----------------------------
INT 31 P - DPMI 0.9+ - GET NEXT SELECTOR INCREMENT VALUE
	AX = 0003h
Return: CF clear
	    AX = value to add to get next sequential selector
Notes:	the increment will be a power of two
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0000h
--------E-310004-----------------------------
INT 31 P - DPMI 0.9+ - LOCK SELECTOR
	AX = 0004h
	BX = selector to lock (prevent paging)
Return: ???
Note:	although marked as reserved in versions 0.9 and 1.0 of the DPMI
	  specification, this function is called by MS Windows TASKMAN,
	  PROGMAN, and KERNEL
SeeAlso: AX=0005h,AX=0600h
--------E-310005-----------------------------
INT 31 P - DPMI 0.9+ - UNLOCK SELECTOR
	AX = 0005h
	BX = selector to unlock (permit paging)
Return: ???
Note:	although marked as reserved in versions 0.9 and 1.0 of the DPMI
	  specification, this function is called by MS Windows TASKMAN,
	  PROGMAN, and KERNEL
SeeAlso: AX=0004h,AX=0601h
--------E-310006-----------------------------
INT 31 P - DPMI 0.9+ - GET SEGMENT BASE ADDRESS
	AX = 0006h
	BX = selector
Return: CF clear if successful
	    CX:DX = linear base address of segment
	CF set on error
	    AX = error code (DPMI 1.0+) (8022h) (see #2775)
Note:	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0007h,INT 21/AX=3504h
--------E-310007-----------------------------
INT 31 P - DPMI 0.9+ - SET SEGMENT BASE ADDRESS
	AX = 0007h
	BX = selector
	CX:DX = linear base address
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8022h,8025h) (see #2775)
Notes:	only modify descriptors allocated with INT 31/AX=0000h
	only the low 24 bits of the address will be used by 16-bit DPMI
	  implementations even on a 386 or higher
	DPMI 1.0+ automatically reloads any segment registers containing the
	  selector being modified
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0006h,AX=0008h,AX=0009h,AX=000Ch,INT 21/AX=3503h
SeeAlso: INT 21/AH=E9h"OS/286",INT 2C/AX=0002h
--------E-310008-----------------------------
INT 31 P - DPMI 0.9+ - SET SEGMENT LIMIT
	AX = 0008h
	BX = selector
	CX:DX = segment limit
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8021h,8022h,8025h) (see #2775)
Notes:	CX must be zero for 16-bit DPMI implementations
	limits greater than 1MB must be page aligned (low 12 bits set)
	only modify descriptors allocated with INT 31/AX=0000h
	DPMI 1.0+ automatically reloads any segment registers containing the
	  selector being modified
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0007h,AX=0009h,AX=000Ch,INT 21/AX=3505h,INT 21/AH=E9h"OS/286"
SeeAlso: INT 2C/AX=0003h,#0420 at INT 15/AH=89h
--------E-310009-----------------------------
INT 31 P - DPMI 0.9+ - SET DESCRIPTOR ACCESS RIGHTS
	AX = 0009h
	BX = selector
	CL = access rights/type byte (see #0421 at INT 15/AH=89h)
	CH = 80386 extended rights/type byte (see #0422 at INT 15/AH=89h)
	    (32-bit DPMI implementations only)
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8021h,8022h,8025h) (see #2775)
Notes:	if the Present bit is clear, CL bits 0-3 may have any value
	DPMI 1.0+ automatically reloads any segment registers containing the
	  selector being modified
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0007h,AX=0008h,AX=000Ch,INT 21/AX=2514h,INT 2C/AX=0004h
SeeAlso: INT 2C/AX=0005h
--------E-31000A-----------------------------
INT 31 P - DPMI 0.9+ - CREATE ALIAS DESCRIPTOR
	AX = 000Ah
	BX = selector
Return: CF clear if successful
	    AX = new data selector
	CF set on error
	    AX = error code (DPMI 1.0+) (8011h,8022h) (see #2775)
Notes:	fails if selector in BX is not a code segment or is invalid
	use INT 31/AX=0001h to free new selector
	future changes to the original selector will not be reflected in the
	  returned alias selector
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0001h
--------E-31000B-----------------------------
INT 31 P - DPMI 0.9+ - GET DESCRIPTOR
	AX = 000Bh
	BX = LDT selector
	ES:(E)DI -> 8-byte buffer for copy of descriptor
Return: CF clear if successful
	    buffer filled
	CF set on error
	    AX = error code (DPMI 1.0+) (8022h) (see #2775)
Notes:	16-bit programs use ES:DI as pointer, 32-bit must use ES:EDI
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=000Ch
--------E-31000C-----------------------------
INT 31 P - DPMI 0.9+ - SET DESCRIPTOR
	AX = 000Ch
	BX = LDT selector
	ES:(E)DI -> 8-byte buffer containing descriptor
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8021h,8022h,8025h) (see #2775)
Notes:	16-bit programs use ES:DI as pointer, 32-bit must use ES:EDI
	only modify descriptors allocated with INT 31/AX=0000h
	DPMI 1.0+ automatically reloads any segment registers containing the
	  selector being modified
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=000Bh
--------E-31000D-----------------------------
INT 31 P - DPMI 0.9+ - ALLOCATE SPECIFIC LDT DESCRIPTOR
	AX = 000Dh
	BX = LDT selector
Return: CF clear if successful
	    descriptor allocated
	CF set on error
	    AX = error code (DPMI 1.0+) (8011h,8022h) (see #2775)
Notes:	free descriptor with INT 31/AX=0001h
	the first 16 descriptors (04h-7Ch) are reserved for this function, but
	  some may already be in use by other applications under DPMI 0.9;
	  DPMI 1.0 guarantees 16 descriptors per client
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0000h,AX=0001h
--------E-31000E-----------------------------
INT 31 P - DPMI 1.0+ - GET MULTIPLE DESCRIPTORS
	AX = 000Eh
	CX = number of descriptors to copy
	ES:(E)DI -> descriptor buffer (see #2776)
Return: CF clear if successful
	    descriptors copied
	CF set on error
	    AX = error code (8022h) (see #2775)
	    CX = number of descriptors successfully copied
Notes:	16-bit programs use ES:DI as pointer, 32-bit must use ES:EDI
	if the function fails, the first CX descriptors are valid; the
	  remainder are not modified
SeeAlso: AX=000Bh,AX=000Fh

Format of DPMI descriptor buffer entry (one per descriptor to get):
Offset	Size	Description	(Table 2776)
 00h	WORD	selector (set by client)
 02h	QWORD	descriptor (set by host)
--------E-31000F-----------------------------
INT 31 P - DPMI 1.0+ - SET MULTIPLE DESCRIPTORS
	AX = 000Fh
	CX = number of descriptors to copy
	ES:(E)DI -> descriptor buffer (see #2777)
Return: CF clear if successful
	    descriptors copied
	CF set on error
	    AX = error code (8021h,8022h,8025h) (see #2775)
	    CX = number of descriptors successfully copied
Notes:	16-bit programs use ES:DI as pointer, 32-bit must use ES:EDI
	if the function fails, the first CX descriptors are valid; the
	  remainder are not modified
	DPMI 1.0+ automatically reloads any segment registers containing a
	  selector being modified
SeeAlso: AX=000Ch,AX=000Eh

Format of DPMI descriptor buffer entry (one per descriptor to set):
Offset	Size	Description	(Table 2777)
 00h	WORD	selector
 02h	QWORD	descriptor
--------E-310100-----------------------------
INT 31 P - DPMI 0.9+ - ALLOCATE DOS MEMORY BLOCK
	AX = 0100h
	BX = number of paragraphs to allocate
Return: CF clear if successful
	    AX = real mode segment of allocated block
	    DX = first selector for allocated block
	CF set on error
	    AX = DOS error code (07h,08h) (see #1332 at INT 21/AH=59h/BX=0000h)
		(DPMI 1.0+) DPMI error code (8011h) (see #2775)
	    BX = size (in paragraphs) of largest available block
Notes:	multiple contiguous selectors are allocated for blocks of more than 64K
	  if the caller is a 16-bit program
	never modify or deallocate returned descriptors
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0101h,AX=0501h
--------E-310101-----------------------------
INT 31 P - DPMI 0.9+ - FREE DOS MEMORY BLOCK
	AX = 0101h
	DX = selector of block
Return: CF set if successful
	CF set on error
	    AX = DOS error code (07h,09h) (see #1332 at INT 21/AH=59h/BX=0000h)
Notes:	all descriptors allocated for the block are automatically freed
	DPMI 1.0+ automatically zeros any segment registers containing a
	  selector freed by this function
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0100h,AX=0102h,AX=0502h
--------E-310102-----------------------------
INT 31 P - DPMI 0.9+ - RESIZE DOS MEMORY BLOCK
	AX = 0102h
	BX = new block size in paragraphs
	DX = selector of block
Return: CF clear if successful
	CF set on error
	    AX = DOS error code (07h,08h,09h)
		  (see #1332 at INT 21/AH=59h/BX=0000h)
		(DPMI 1.0+) DPMI error code (8011h,8022h) (see #2775)
	    BX = maximum block size (in paragraphs) possible
Notes:	increasing the size of a block past a 64K boundary will fail if the
	  next descriptor in the LDT is already in use
	shrinking a block past a 64K boundary will cause some selectors to be
	  freed; DPMI 1.0+ automatically zeros any segment registers containing
	  a selector freed by this function
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0100h
--------E-310200-----------------------------
INT 31 P - DPMI 0.9+ - GET REAL MODE INTERRUPT VECTOR
	AX = 0200h
	BL = interrupt number
Return: CF clear
	CX:DX = segment:offset of real mode interrupt handler
Note:	the DPMI implementation is required to support all 256 vectors
SeeAlso: AX=0201h,AX=0204h,INT 21/AX=2503h
--------E-310201-----------------------------
INT 31 P - DPMI 0.9+ - SET REAL MODE INTERRUPT VECTOR
	AX = 0201h
	BL = interrupt number
	CX:DX = segment:offset of real mode handler
Return: CF clear
Note:	all memory that may be touched by a hardware interrupt handler must be
	  locked down with INT 31/AX=0600h
SeeAlso: AX=0200h,AX=0205h,AX=0600h,INT 21/AX=2505h
--------E-310202-----------------------------
INT 31 P - DPMI 0.9+ - GET PROCESSOR EXCEPTION HANDLER VECTOR
	AX = 0202h
	BL = exception number (00h-1Fh)
Return: CF clear if successful
	    CX:(E)DX = selector:offset of handler
	CF set on error
	    AX = error code (DPMI 1.0+) (8021h) (see #2775)
Notes:	16-bit programs receive the pointer in CX:DX, 32-bit programs in CX:EDX
	DPMI 1.0+ supports this function only for backward compatibility; use
	   AX=0210h or AX=0211h instead
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0203h,AX=0210h,AX=0211h,INT 2F/AX=FB42h/BX=0021h
--------E-310203-----------------------------
INT 31 P - DPMI 0.9+ - SET PROCESSOR EXCEPTION HANDLER VECTOR
	AX = 0203h
	BL = exception number (00h-1Fh)
	CX:(E)DX = selector:offset of handler
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8021h,8022h) (see #2775)
Notes:	32-bit programs must supply an offset in EDX and use a 32-bit interrupt
	  stack frame on chaining to the next exception handler
	the handler should return using a FAR return
	all fault stack frames contain an error code, but it is only valid for
	  exceptions 08h and 0Ah-0Eh
	handlers will only be called if the exception occurs in protected mode,
	  and the DPMI host does not transparently handle the exception
	the handler may change certain values on the stack frame
	  (see #2778,#2779)
	DPMI 1.0+ supports this function only for backward compatibility; use
	   AX=0212h or AX=0213h instead
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0202h,AX=0212h,AX=0213h,INT 2F/AX=FB42h/BX=0022h

Format of stack frame for 16-bit programs: (offset from SS:SP)
Offset	Size	Description	(Table 2778)
 00h	DWORD	return CS:IP (do not change)
 04h	WORD	error code
 06h	DWORD	CS:IP of exception
 0Ah	WORD	flags
 0Ch	DWORD	SS:SP

Format of stack frame for 32-bit programs: (offset from SS:ESP)
Offset	Size	Description	(Table 2779)
 00h	DWORD	return EIP (do not change)
 04h	WORD	return CS selector (do not change)
 06h	WORD	reserved (do not change)
 08h	DWORD	error code
 0Ch	DWORD	EIP of exception
 10h	WORD	CS selector of exception
 12h	WORD	reserved (do not change)
 14h	DWORD	EFLAGS
 18h	DWORD	ESP
 1Ch	WORD	SS
 1Eh	WORD	reserved (do not change)
--------E-310204-----------------------------
INT 31 P - DPMI 0.9+ - GET PROTECTED MODE INTERRUPT VECTOR
	AX = 0204h
	BL = interrupt number
Return: CF clear
	CX:(E)DX = selector:offset of handler
Notes:	16-bit programs use CX:DX, 32-bit programs use CX:EDX
	DPMI implementations are required to support all 256 vectors
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0200h,AX=0205h,INT 21/AX=2502h,INT 2C/AX=0006h
SeeAlso: INT 2F/AX=FB42h/BX=0024h
--------E-310205-----------------------------
INT 31 P - DPMI 0.9+ - SET PROTECTED MODE INTERRUPT VECTOR
	AX = 0205h
	BL = interrupt number
	CX:(E)DX = selector:offset of handler
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8022h) (see #2775)
Notes:	16-bit programs use CX:DX, 32-bit programs use CX:EDX
	32-bit programs must use a 32-bit interrupt stack frame when chaining
	  to the next handler
	DPMI implementations are required to support all 256 vectors
	hardware interrupts are reflected to the virtual machine's primary
	  client, software interrupts to the current client
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0201h,AX=0204h,INT 21/AX=2504h,INT 2C/AX=0007h
SeeAlso: INT 2F/AX=FB42h/BX=0025h
--------E-310210-----------------------------
INT 31 P - DPMI 1.0+ - GET PROTECTED MODE EXTENDED PROCESSOR EXCEPTION HANDLER
	AX = 0210h
	BL = exception number (00h-1Fh)
Return: CF clear if successful
	    CX:(E)DX = selector:offset of exception handler
	CF set on error
	    AX = error code (8021h) (see #2775)
Note:	DPMI host reflects exception to current client's handler
SeeAlso: AX=0202h,AX=0211h,AX=0212h
--------E-310211-----------------------------
INT 31 P - DPMI 1.0+ - GET REAL MODE EXTENDED PROCESSOR EXCEPTION HANDLER
	AX = 0211h
	BL = exception number (00h-1Fh)
Return: CF clear if successful
	    CX:(E)DX = selector:offset of exception handler
	CF set on error
	    AX = error code (8021h) (see #2775)
Notes:	returns address of protected-mode handler for real-mode exception
	DPMI host performs a switch to protected mode, reflects the exception
	  to the virtual machine's primary client, and returns to real mode
	  on the handler's completion
SeeAlso: AX=0202h,AX=0210h,AX=0213h
--------E-310212-----------------------------
INT 31 P - DPMI 1.0+ - SET PROTECTED MODE EXTENDED PROCESSOR EXCEPTION HANDLER
	AX = 0212h
	BL = exception or fault number (00h-1Fh)
	CX:(E)DX = exception handler selector:offset
Return: CF clear if successful
	CF set on error
	    AX = error code (8021h,8022h) (see #2775)
Note:	DPMI host sends exception to current client's handler
SeeAlso: AX=0203h,AX=0210h,AX=0213h
--------E-310213-----------------------------
INT 31 P - DPMI 1.0+ - SET REAL MODE EXTENDED PROCESSOR EXCEPTION HANDLER
	AX = 0213h
	BL = exception or fault number (00h-1Fh)
	CX:(E)DX = exception handler selector:offset
Return: CF clear if successful
	CF set on error
	    AX = error code (8021h,8022h) (see #2775)
Notes:	specifies address of protected-mode handler for real-mode exception
	DPMI host performs a switch to protected mode, reflects the exception
	  to the virtual machine's primary client, and returns to real mode
	  on the handler's completion
SeeAlso: AX=0203h,AX=0211h,AX=0212h
--------E-310300-----------------------------
INT 31 P - DPMI 0.9+ - SIMULATE REAL MODE INTERRUPT
	AX = 0300h
	BL = interrupt number
	BH = flags
	    bit 0: reset the interrupt controller and A20 line (DPMI 0.9)
		    reserved, must be 0 (DPMI 1.0+)
	    others: reserved, must be 0
	CX = number of words to copy from protected mode to real mode stack
	ES:(E)DI = selector:offset of real mode call structure (see #2780)
Return: CF clear if successful
	    real mode call structure modified (all fields except SS:SP, CS:IP
	      filled with return values from real mode interrupt)
	CF set on error
	    AX = error code (DPMI 1.0+) (8012h,8013h,8014h,8021h)(see #2775)
	protected mode stack unchanged
Notes:	16-bit programs use ES:DI as pointer, 32-bit programs use ES:EDI
	CS:IP in the real mode call structure is ignored for this call,
	  instead, the indicated interrupt vector is used for the address
	the flags in the call structure are pushed on the real mode stack to
	  form an interrupt stack frame, and the trace and interrupt flags are
	  clear on entry to the handler
	DPMI will provide a small (30 words) real mode stack if SS:SP is zero
	the real mode handler must return with the stack in the same state as
	  it was on being called
SeeAlso: AX=0302h,AX=FF01h,INT 21/AX=2511h,INT 21/AH=E3h"OS/286"
SeeAlso: INT 2C/AX=0026h,INT 2F/AX=FB42h/BX=000Dh

Format of DPMI real mode call structure:
Offset	Size	Description	(Table 2780)
 00h	DWORD	EDI
 04h	DWORD	ESI
 08h	DWORD	EBP
 0Ch	DWORD	reserved (00h)
 10h	DWORD	EBX
 14h	DWORD	EDX
 18h	DWORD	ECX
 1Ch	DWORD	EAX
 20h	WORD	flags
 22h	WORD	ES
 24h	WORD	DS
 26h	WORD	FS
 28h	WORD	GS
 2Ah	WORD	IP
 2Ch	WORD	CS
 2Eh	WORD	SP
 30h	WORD	SS
--------E-310301-----------------------------
INT 31 P - DPMI 0.9+ - CALL REAL MODE PROCEDURE WITH FAR RETURN FRAME
	AX = 0301h
	BH = flags
	    bit 0: reset the interrupt controller and A20 line (DPMI 0.9)
		    reserved, must be 0 (DPMI 1.0+)
	    others: reserved must be 0
	CX = number of words to copy from protected mode to real mode stack
	ES:(E)DI = selector:offset of real mode call structure
		  (see #2780 at INT 31/AX=0300h)
Return: CF clear if successful
	    real mode call structure modified (all fields except SS:SP, CS:IP
	      filled with return values from real mode interrupt)
	CF set on error
	    AX = error code (DPMI 1.0+) (8012h,8013h,8014h,8021h)(see #2775)
	protected mode stack unchanged
Notes:	16-bit programs use ES:DI as pointer, 32-bit programs use ES:EDI
	the real mode procedure must exit with a FAR return
	DPMI will provide a small (30 words) real mode stack if SS:SP is zero
	the real mode handler must return with the stack in the same state as
	  it was on being called
SeeAlso: AX=0300h,AX=0302h,AX=FF02h,INT 21/AX=250Eh,INT 21/AH=E1h"OS/286"
SeeAlso: INT 2C/AX=0025h
--------E-310302-----------------------------
INT 31 P - DPMI 0.9+ - CALL REAL MODE PROCEDURE WITH IRET FRAME
	AX = 0302h
	BH = flags
	    bit 0: reset the interrupt controller and A20 line (DPMI 0.9)
		    reserved, must be 0 (DPMI 1.0+)
	    others: reserved, must be 0
	CX = number of words to copy from protected mode to real mode stack
	ES:(E)DI = selector:offset of real mode call structure
		  (see #2780 at INT 31/AX=0300h)
Return: CF clear if successful
	    real mode call structure modified (all fields except SS:SP, CS:IP
	      filled with return values from real mode interrupt)
	CF set on error
	    AX = error code (DPMI 1.0+) (8012h,8013h,8014h,8021h)(see #2775)
	protected mode stack unchanged
Notes:	16-bit programs use ES:DI as pointer, 32-bit programs use ES:EDI
	the flags in the call structure are pushed on the real mode stack to
	  form an interrupt stack frame, and the trace and interrupt flags are
	  clear on entry to the handler
	the real mode procedure must exit with an IRET
	DPMI will provide a small (30 words) real mode stack if SS:SP is zero
	the real mode handler must return with the stack in the same state as
	  it was on being called
SeeAlso: AX=0300h
--------E-310303-----------------------------
INT 31 P - DPMI 0.9+ - ALLOCATE REAL MODE CALLBACK ADDRESS
	AX = 0303h
	DS:(E)SI = selector:offset of procedure to call
	ES:(E)DI = selector:offset of real mode call structure (see #2780)
Return: CF clear if successful
	    CX:DX = segment:offset of real mode call address (see #2781)
	CF set on error
	    AX = error code (DPMI 1.0+) (8015h) (see #2775)
Notes:	the real mode call structure is static, causing reentrancy problems;
	  its contents are only valid at the time of a callback
	the called procedure must modify the real mode CS:IP before returning
	values are returned to real mode by modifying the real mode call struc
	DPMI hosts must provide at least 16 callbacks per client
	the limited DPMI host built into Phar Lap's 286|DOS-Extender v2.5 does
	  not support this function
SeeAlso: AX=0304h,AX=0C00h

(Table 2781)
Values DPMI real-mode callback procedure is called with:
	DS:(E)SI = selector:offset of real mode SS:SP
	ES:(E)DI = selector:offset of real mode call structure
	SS:(E)SP = locked protected mode API stack
	interrupts disabled
Return: (with IRET)
	ES:(E)DI = selector:offset of real mode call structure to restore
--------E-310304-----------------------------
INT 31 P - DPMI 0.9+ - FREE REAL MODE CALLBACK ADDRESS
	AX = 0304h
	CX:DX = real mode callback address
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8024h) (see #2775)
Note:	the limited DPMI host built into Phar Lap's 286|DOS-Extender v2.5 does
	  not support this function
SeeAlso: AX=0303h
--------E-310305-----------------------------
INT 31 P - DPMI 0.9+ - GET STATE SAVE/RESTORE ADDRESSES
	AX = 0305h
Return: CF clear
	AX = size in bytes of state buffer
	BX:CX = real mode address of procedure to save/restore state
	SI:(E)DI = protected mode procedure to save/restore state (see #2782)
Notes:	the buffer size will be zero if it is not necessary to preserve state
	16-bit programs should call SI:DI, 32-bit programs should call SI:EDI
	this function is only needed if using the raw mode switch service
SeeAlso: AX=0306h

(Table 2782)
Call DPMI state-save procedures with:
	AL = direction
	    00h save state
	    01h restore state
	ES:(E)DI -> state buffer
Return: all registers preserved
--------E-310306-----------------------------
INT 31 P - DPMI 0.9+ - GET RAW MODE SWITCH ADDRESSES
	AX = 0306h
Return: CF clear
	BX:CX -> procedure to switch from real to protected mode (see #2783)
	SI:(E)DI -> procedure to switch from protected to real mode
Notes:	16-bit programs should jump to SI:DI, 32-bit programs should use SI:EDI
	the caller must save and restore the state of the task with AX=0305h
	not supported by MS Windows 3.0 in Standard mode
SeeAlso: AX=0305h

(Table 2783)
Values to JUMP at mode-switch procedures with:
	AX = new DS
	CX = new ES
	DX = new SS
	(E)BX = new (E)SP
	SI:(E)DI = new CS:(E)IP
Notes:	BP/EBP is preserved across the call, but AX/EAX, BX/EBX, CX/ECX,
	  DX/EDX, SI/ESI, and DI/EDI will be undefined; FS and GS will be 0000h
	interrupts will stay disabled during the entire mode switch if they
	  are disabled on entry to the mode-switch procedure
--------E-310400-----------------------------
INT 31 P - DPMI 0.9+ - GET DPMI VERSION
	AX = 0400h
Return: CF clear
	AH = major version of DPMI spec supported
	AL = two-digit minor version of DPMI spec supported
	BX = DPMI host flags (see #2784)
	CL = processor type (02h=80286, 03h=80386, 04h=80486)
	DH = curr value of virtual master interrupt controller base interrupt
	DL = curr value of virtual slave interrupt controller base interrupt
BUG:	Windows NT versions from the March 1993 beta to at least the Final
	  release with fixes to CSD002 report version 0090h (0.144); this has
	  reportedly been corrected in the Windows NT 3.5 beta
SeeAlso: AX=0401h,INT 21/AX=250Ch,INT 2F/AX=1687h,INT 4B/AX=8102h/DX=0000h
SeeAlso: INT 67/AX=DE0Ah

Bitfields for DPMI host flags:
Bit(s)	Description	(Table 2784)
 0	running under an 80386 (32-bit) implementation
 1	processor returns to real mode for reflected interrupts instead of V86
	  mode
 2	virtual memory supported
 3	reserved (undefined)
 4-15	reserved (zero)
--------E-310401-----------------------------
INT 31 P - DPMI 1.0+ - GET DPMI CAPABILITIES
	AX = 0401h
	ES:(E)DI -> 128-byte buffer for host description (see #2785)
Return: CF clear if successful
	    AX = capabilities (see #2786)
	    CX = reserved (00h)
	    DX = reserved (00h)
	    buffer filled
	CF set on error (DPMI 0.9 only)
SeeAlso: AX=0400h

Format of DPMI host description:
Offset	Size	Description	(Table 2785)
 00h	BYTE	host major version number
 01h	BYTE	host minor version number
 02h 126 BYTEs	ASCIZ host vendor name

Bitfields for DPMI capabilities:
Bit(s)	Description	(Table 2786)
 0	paged accessed/dirty supported (see AX=0506h,AX=0507h)
 1	exceptions restartability supported
 2	device mapping supported (see AX=0508h)
 3	conventional memory mapping supported (see AX=0509h)
 4	demand zero-fill supported
 5	write-protect client capability supported
 6	write-protect host capability supported
 7-15	reserved
--------E-310500-----------------------------
INT 31 P - DPMI 0.9+ - GET FREE MEMORY INFORMATION
	AX = 0500h
	ES:(E)DI -> buffer for memory information (see #2787)
Return: CF clear
Notes:	16-bit programs use ES:DI, 32-bit programs use ES:EDI
	this function must be considered advisory because other applications
	  may affect the results at any time after the call
	fields not supported by the DPMI implementation are filled with
	  FFFFFFFFh
	DPMI 1.0+ supports this function solely for backward compatibility; use
	  AX=050Bh instead
	the limited DPMI host built into Phar Lap's 286|DOS-Extender v2.5 only
	  returns the first field in the memory information record
SeeAlso: AX=0501h,AX=050Bh,AX=0604h

Format of DPMI memory information:
Offset	Size	Description	(Table 2787)
 00h	DWORD	largest available block in bytes
 04h	DWORD	maximum unlocked page allocation
 08h	DWORD	maximum locked page allocation
 0Ch	DWORD	total linear address space in pages
 10h	DWORD	total unlocked pages
 14h	DWORD	free pages
 18h	DWORD	total physical pages
 1Ch	DWORD	free linear address space in pages
 20h	DWORD	size of paging file/partition in pages
 24h 12 BYTEs	reserved
--------E-310501-----------------------------
INT 31 P - DPMI 0.9+ - ALLOCATE MEMORY BLOCK
	AX = 0501h
	BX:CX = size in bytes
Return: CF clear if successful
	    BX:CX = linear address of block
	    SI:DI = memory block handle for resizing and freeing block
	CF set on error
	    AX = error code (DPMI 1.0+) (8012h-8014h,8016h,8021h)(see #2775)
Notes:	no selectors are allocated
	the memory block is allocated unlocked (can be locked with AX=0600h)
	allocations are often page granular (see AX=0604h)
	under MS Windows 3.10 Enhanced mode with paging enabled, it is possible
	  for this function to fail even if AX=0500h indicates that enough
	  memory is available
SeeAlso: AX=0000h,AX=0100h,AX=0500h,AX=0502h,AX=0503h,AX=0504h,AX=0D00h
SeeAlso: INT 2F/AX=FB42h/BX=0002h
--------E-310502-----------------------------
INT 31 P - DPMI 0.9+ - FREE MEMORY BLOCK
	AX = 0502h
	SI:DI = handle of memory block
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8023h) (see #2775)
Note:	any selectors allocated for the memory block must also be freed,
	  preferably before freeing the memory block
SeeAlso: AX=0001h,AX=0101h,AX=0501h,AX=0D01h
--------E-310503-----------------------------
INT 31 P - DPMI 0.9+ - RESIZE MEMORY BLOCK
	AX = 0503h
	BX:CX = new size in bytes (nonzero)
	SI:DI = handle of memory block
Return: CF clear if successful
	    BX:CX = new linear address
	    SI:DI = new handle of memory block
	CF set on error
	    AX = error code (DPMI 1.0+) (8012h-8014h,8016h,8021h,8023h)
		(see #2775)
Notes:	any selectors pointing at the block must be updated
	the previous memory block handle becomes invalid
	an error is returned if the new size is 0
SeeAlso: AX=0102h,AX=0501h,AX=0505h
--------E-310504-----------------------------
INT 31 P - DPMI 1.0+ - ALLOCATE LINEAR MEMORY BLOCK
	AX = 0504h
	EBX = page-aligned linear address of memory block (00000000h if any
	      address is acceptable)
	ECX = size in bytes (nonzero)
	EDX = flags
	    bit 0: set to create committed pages instead of uncommitted pages
	    bits 1-31 reserved (0)
Return: CF clear if successful
	    EBX = linear address of memory block
	    ESI = memory block handle
	CF set on error
	    AX = error code (8001h,8012h-8014h,8016h,8021h,8025h)(see #2775)
Note:	only supported by 32-bit DPMI hosts, but may be used by 16-bit clients
SeeAlso: AX=0501h,AX=0505h
--------E-310505-----------------------------
INT 31 P - DPMI 1.0+ - RESIZE LINEAR MEMORY BLOCK
	AX = 0505h
	ESI = memory block handle
	ECX = new size in bytes (nonzero)
	EDX = flags
	    bit 0: create committed pages rather than uncommitted pages
	    bit 1: segment descriptor update required
		ES:EBX -> buffer containing array of WORDs with selectors
		EDI = number of selectors in array
	    bits 2-31 reserved (0)
Return: CF clear if successful
	    EBX = new linear base address
	    ESI = new memory block handle
	CF set on error
	    AX = error code (8001h,8012h-8014h,8016h,8021h,8023h)(see #2775)
Notes:	only supported by 32-bit DPMI hosts, but may be used by 16-bit clients
	the old memory block handle becomes invalid
	if EDX bit 1 set and the block's base address is changed, DPMI updates
	  all descriptors for selectors in the update buffer which fall within
	  the memory block
SeeAlso: AX=0503h,AX=0504h
--------E-310506-----------------------------
INT 31 P - DPMI 1.0+ - GET PAGE ATTRIBUTES
	AX = 0506h
	ESI = memory block handle
	EBX = offset in memory block of first page
	ECX = number of pages
	ES:EDX -> array of WORDs to hold page attributes (see #2788)
Return: CF clear if successful
	    buffer filled
	CF set on error
	    AX = error code (8001h,8023h,8025h) (see #2775)
Notes:	only supported by 32-bit DPMI hosts, but may be used by 16-bit clients
	if EBX is not page-aligned, it will be rounded down
SeeAlso: AX=0504h,AX=0507h,INT 21/AX=251Dh,INT 21/AX=EB00h

Bitfields for DPMI page attribute word:
Bit(s)	Description	(Table 2788)
 0-2	page type
	000 uncommitted
	001 committed
	010 mapped (see AX=0508h,AX=0509h)
	other currently unused
 3	page is read/write rather than read-only
 4	accessed/dirty bits supplied in bits 5 and 6
 5	page has been accessed (only valid if bit 4 set)
 6	page has been written (only valid if bit 4 set)
 7-15	reserved (0)
--------E-310507-----------------------------
INT 31 P - DPMI 1.0+ - MODIFY PAGE ATTRIBUTES
	AX = 0507h
	ESI = memory block handle
	EBX = offset in memory block of first page
	ECX = number of pages
	ES:EDX -> array of WORDs with new page attributes (see #2788)
Return: CF clear if successful
	CF set on error
	    AX = error code (8001h,8002h,8013h,8014h,8021h,8023h,8025h)
		(see #2775)
	    ECX = number of pages which have been set
Notes:	only supported by 32-bit DPMI hosts, but may be used by 16-bit clients
	if EBX is not page-aligned, it will be rounded down
SeeAlso: AX=0504h,AX=0506h,INT 21/AX=251Eh
--------E-310508-----------------------------
INT 31 P - DPMI 1.0+ - MAP DEVICE IN MEMORY BLOCK
	AX = 0508h
	ESI = memory block handle
	EBX = page-aligned offset within memory block of page(s) to be mapped
	ECX = number of pages to map
	EDX = page-aligned physical address of device
Return: CF clear if successful
	CF set on error
	    AX = error code (8001h,8003h,8023h,8025h) (see #2775)
Notes:	only supported by 32-bit DPMI hosts, but may be used by 16-bit clients
	support of this function is optional; hosts are also allowed to support
	  the function for some devices but not others
SeeAlso: AX=0504h,AX=0509h,AX=0800h,AX=0801h
--------E-310509-----------------------------
INT 31 P - DPMI 1.0+ - MAP CONVENTIONAL MEMORY IN MEMORY BLOCK
	AX = 0509h
	ESI = memory block handle
	EBX = page-aligned offset within memory block of page(s) to map
	ECX = number of pages to map
	EDX = page-aligned linear address of conventional (below 1M) memory
Return: CF clear if successful
	CF set on error
	    AX = error code (8001h,8003h,8023h,8025h) (see #2775)
Notes:	only supported by 32-bit DPMI hosts, but may be used by 16-bit clients
	support of this function is optional
SeeAlso: AX=0504h,AX=0508h,AX=0801h
--------E-31050A-----------------------------
INT 31 P - DPMI 1.0+ - GET MEMORY BLOCK SIZE AND BASE
	AX = 050Ah
	SI:DI = memory block handle
Return: CF clear if successful
	    SI:DI = size in bytes
	    BX:CX = base address
	CF set on error
	    AX = error code (8023h) (see #2775)
SeeAlso: AX=0501h,AX=0504h
--------E-31050B-----------------------------
INT 31 P - DPMI 1.0+ - GET MEMORY INFORMATION
	AX = 050Bh
	ES:(E)DI -> 128-byte buffer for memory information (see #2789)
Return: CF clear if successful
	CF set on error (DPMI 0.9 only)
Note:	16-bit programs use ES:DI, 32-bit programs must use ES:EDI
SeeAlso: AX=0500h

Format of DPMI memory information:
Offset	Size	Description	(Table 2789)
 00h	DWORD	total allocated bytes of physical memory controlled by host
 04h	DWORD	total allocated bytes of virtual memory controlled by host
 08h	DWORD	total available bytes of virtual memory controlled by host
 0Ch	DWORD	total allocated bytes of virtual memory for curr virtual mach
 10h	DWORD	total available bytes of virtual memory for curr virtual mach
 14h	DWORD	total allocated bytes of virtual memory for current client
 18h	DWORD	total available bytes of virtual memory for current client
 1Ch	DWORD	total locked bytes for current client
 20h	DWORD	maximum locked bytes for current client
 24h	DWORD	highest linear address available to current client
 28h	DWORD	largest available memory block in bytes
 2Ch	DWORD	minimum allocation unit in bytes
 30h	DWORD	allocation alignment unit size in bytes
 34h 76 BYTEs	reserved (00h)
--------E-310600-----------------------------
INT 31 P - DPMI 0.9+ - LOCK LINEAR REGION
	AX = 0600h
	BX:CX = starting linear address
	SI:DI = size of region in bytes
Return: CF clear if successful
	CF set on error
	    none of the memory is locked
	    AX = error code (DPMI 1.0+) (8013h,8017h,8025h) (see #2775)
Notes:	pages at beginning and end will be locked if the region overlaps them
	may be called multiple times for a given page; the DPMI host keeps a
	  lock count for each page
SeeAlso: AX=0004h,AX=0601h,INT 21/AX=251Ah,INT 21/AX=EB06h
--------E-310601-----------------------------
INT 31 P - DPMI 0.9+ - UNLOCK LINEAR REGION
	AX = 0601h
	BX:CX = starting linear address
	SI:DI = size of region in bytes
Return: CF clear if successful
	CF set on error
	    none of the memory is unlocked
	    AX = error code (DPMI 1.0+) (8002h,8025h) (see #2775)
Notes:	pages at beginning and end will be unlocked if the region overlaps them
	memory whose lock count has not reached zero remains locked
SeeAlso: AX=0005h,AX=0600h,INT 21/AX=251Bh,INT 21/AX=EB07h
--------E-310602-----------------------------
INT 31 P - DPMI 0.9+ - MARK REAL MODE REGION AS PAGEABLE
	AX = 0602h
	BX:CX = starting linear address
	SI:DI = size of region in bytes
Return: CF clear if successful
	CF set on error
	    none of the memory is made pageable
	    AX = error code (DPMI 1.0+) (8002h,8025h) (see #2775)
Notes:	must relock all unlocked real mode memory before terminating process
	  for DPMI 0.9; DPMI 1.0+ automatically relocks real mode memory
	pages at beginning and end will be unlocked if the region overlaps them
	pageability of real mode pages is binary, not a count
SeeAlso: AX=0600h,AX=0603h
--------E-310603-----------------------------
INT 31 P - DPMI 0.9+ - RELOCK REAL MODE REGION
	AX = 0603h
	BX:CX = starting linear address
	SI:DI = size of region in bytes
Return: CF clear if successful
	CF set on error
	    none of the memory is relocked
	    AX = error code (DPMI 1.0+) (8002h,8013h,8025h) (see #2775)
Notes:	pages at beginning and end will be relocked if the region overlaps them
	pageability of real mode pages is binary, not a count
SeeAlso: AX=0602h
--------E-310604-----------------------------
INT 31 P - DPMI 0.9+ - GET PAGE SIZE
	AX = 0604h
Return: CF clear if successful
	    BX:CX = page size in bytes
	CF set on error
	    AX = error code (DPMI 1.0+) (see also #2775)
		8001h unsupported, 16-bit host
BUG:	the Borland C++ 3.1 DPMILOAD returns with CF clear but BX and CX
	  unchanged
--------E-310700-----------------------------
INT 31 Pu - DPMI 0.9+ - MARK PAGES AS PAGING CANDIDATES
	AX = 0700h
	BX:CX = starting linear page number
	SI:DI = number of pages to mark as paging candidates
Return: ???
Note:	although marked as reserved in versions 0.9 and 1.0 of the DPMI
	  specification, this function is called by MS Windows TASKMAN,
	  PROGMAN, and KERNEL
SeeAlso: AX=0701h,AX=0702h
--------E-310701-----------------------------
INT 31 Pu - DPMI 0.9+ - DISCARD PAGES
	AX = 0701h
	BX:CX = starting linear page number
	SI:DI = number of pages to discard
Return: ???
Note:	although marked as reserved in versions 0.9 and 1.0 of the DPMI
	  specification, this function is called by MS Windows TASKMAN,
	  PROGMAN, and KERNEL
SeeAlso: AX=0700h,AX=0703h
--------E-310702-----------------------------
INT 31 P - DPMI 0.9+ - MARK PAGE AS DEMAND PAGING CANDIDATE
	AX = 0702h
	BX:CX = starting linear address
	SI:DI = number of bytes to mark as paging candidates
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8025h) (see #2775)
Notes:	this function is advisory, and does not force immediate paging
	partial pages will not be discarded
SeeAlso: AX=0700h,AX=0703h
--------E-310703-----------------------------
INT 31 P - DPMI 0.9+ - DISCARD PAGE CONTENTS
	AX = 0703h
	BX:CX = starting linear address
	SI:DI = number of bytes to mark as discarded
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8025h) (see #2775)
Notes:	this function is advisory, and may be ignored by DPMI implementations
	partial pages will not be discarded
SeeAlso: AX=0701h,AX=0702h
--------E-310800-----------------------------
INT 31 P - DPMI 0.9+ - PHYSICAL ADDRESS MAPPING
	AX = 0800h
	BX:CX = physical address (should be above 1 MB)
	SI:DI = size in bytes
Return: CF clear if successful
	    BX:CX = linear address which maps the requested physical memory
	CF set on error
	    AX = error code (DPMI 1.0+) (8003h,8021h) (see #2775)
Notes:	implementations may refuse this call because it can circumvent protects
	the caller must build an appropriate selector for the memory
	do not use for memory mapped in the first megabyte
SeeAlso: AX=0002h,AX=0508h,AX=0509h,AX=0801h,INT 21/AX=250Ah,INT 21/AX=EB05h
--------E-310801-----------------------------
INT 31 P - DPMI 1.0+ - FREE PHYSICAL ADDRESS MAPPING
	AX = 0801h
	BX:CX = linear address returned by AX=0800h
Return: CF clear if successful
	CF set on error
	    AX = error code (8025h) (see #2775)
Note:	should be called at end of access to device mapped with AX=0800h
SeeAlso: AX=0508h,AX=0509h,AX=0800h,INT 21/AX=EB03h
--------E-310900-----------------------------
INT 31 P - DPMI 0.9+ - GET AND DISABLE VIRTUAL INTERRUPT STATE
	AX = 0900h
Return: CF clear
	virtual interrupts disabled
	AL = previous interrupt state (00h disabled, 01h enabled)
	AH preserved
Notes:	the previous state may be restored simply by executing another INT 31
	a CLI instruction may be used if the previous state is unimportant,
	  but should be assumed to be very slow due to trapping by the host
SeeAlso: AX=0901h,AX=0902h
--------E-310901-----------------------------
INT 31 P - DPMI 0.9+ - GET AND ENABLE VIRTUAL INTERRUPT STATE
	AX = 0901h
Return: CF clear
	virtual interrupts enabled
	AL = previous interrupt state (00h disabled, 01h enabled)
	AH preserved
Notes:	the previous state may be restored simply by executing another INT 31
	a STI instruction may be used if the previous state is unimportant,
	  but should be assumed to be very slow due to trapping by the host
SeeAlso: AX=0900h,AX=0902h
--------E-310902-----------------------------
INT 31 P - DPMI 0.9+ - GET VIRTUAL INTERRUPT STATE
	AX = 0902h
Return: CF clear
	AL = current interrupt state (00h disabled, 01h enabled)
Note:	should be used rather than PUSHF because that instruction yields the
	  physical interrupt state rather than the per-client virtualized
	  interrupt flag
SeeAlso: AX=0900h,AX=0901h
--------E-310A00-----------------------------
INT 31 P - DPMI 0.9+ - GET VENDOR SPECIFIC API ENTRY POINT
	AX = 0A00h
	DS:(E)SI -> case-sensitive ASCIZ vendor name or identifier
Return: CF clear if successful
	    ES:(E)DI -> FAR extended API entry point
	    DS, FS, GS, EAX, EBX, ECX, EDX, ESI, EBP destroyed
	CF set on error
	    AX = error code (DPMI 1.0+) (8001h) (see #2775)
Notes:	extended API parameters are vendor-specific
	DPMI 1.0+ supports this function solely for backward compatibility; use
	  INT 2F/AX=168Ah instead
	this function is not supported by MS Windows 3.10, BC++ 3.1 DPMILOAD,
	  or QDPMI v1.0x; use INT 2F/AX=168Ah instead.	It is supported by
	  386MAX v7.01.
SeeAlso: INT 2F/AX=168Ah
--------E-310B00-----------------------------
INT 31 P - DPMI 0.9+ - SET DEBUG WATCHPOINT
	AX = 0B00h
	BX:CX = linear address
	DL = size (1,2,4 bytes)
	DH = type (00h execute, 01h write, 02h read/write)
Return: CF clear if successful
	    BX = watchpoint handle
	CF set on error
	    AX = error code (DPMI 1.0+) (8016h,8021h,8025h) (see #2775)
SeeAlso: AX=0212h,AX=0601h
--------E-310B01-----------------------------
INT 31 P - DPMI 0.9+ - CLEAR DEBUG WATCHPOINT
	AX = 0B01h
	BX = watchpoint handle
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8023h) (see #2775)
Note:	the watchpoint handle is freed
SeeAlso: AX=0B00h
--------E-310B02-----------------------------
INT 31 P - DPMI 0.9+ - GET STATE OF DEBUG WATCHPOINT
	AX = 0B02h
	BX = watchpoint handle
Return: CF clear if successful
	    AX = status flags
		bit 0: watch point has been executed since AX=0B00h or AX=0B03h
	CF set on error
	    AX = error code (DPMI 1.0+) (8023h) (see #2775)
SeeAlso: AX=0B00h,AX=0B03h
--------E-310B03-----------------------------
INT 31 P - DPMI 0.9+ - RESET DEBUG WATCHPOINT
	AX = 0B03h
	BX = watchpoint handle
Return: CF clear if successful
	CF set on error
	    AX = error code (DPMI 1.0+) (8023h) (see #2775)
SeeAlso: AX=0B02h
--------E-310C00-----------------------------
INT 31 P - DPMI 1.0+ - INSTALL RESIDENT HANDLER INIT CALLBACK
	AX = 0C00h
	ES:(E)DI -> resident service provider structure (see #2790)
Return: CF clear if successful
	CF set on error
	    AX = error code (8015h,8021h,8025h) (see #2775 at AX=0000h)
Note:	calling this function declares an intent to provide resident
	  protected mode services after terminating with AX=0C01h
SeeAlso: AX=0303h,AX=0C01h

Format of DPMI resident service provider structure:
Offset	Size	Description	(Table 2790)
 00h	QWORD	descriptor for 16-bit data segment
 08h	QWORD	descriptor for 16-bit code segment (zeros if not supported)
 10h	WORD	offset of 16-bit callback procedure
 12h  2 BYTEs	reserved
 14h	QWORD	descriptor for 32-bit data segment
 1Ch	QWORD	descriptor for 32-bit code segment (zeros if not supported)
 24h	DWORD	offset of 32-bit callback procedure
--------E-310C01-----------------------------
INT 31 P - DPMI 1.0+ - TERMINATE AND STAY RESIDENT
	AX = 0C01h
	BL = return code
	DX = number of paragraphs of DOS memory to reserve (0 or >= 6)
Return: never
Notes:	should only be used if the program will only provide services to
	  other DPMI programs
	any protected mode memory remains allocated to the program unless
	  explicitly freed before this call
	must first call AX=0C00h or program will simply be terminated
SeeAlso: AX=0C00h,INT 21/AH=31h
--------E-310D00-----------------------------
INT 31 P - DPMI 1.0+ - ALLOCATE SHARED MEMORY
	AX = 0D00h
	ES:(E)DI -> shared memory allocation request structure (see #2791)
Return: CF clear if successful
	    request structure updated
	CF set on error
	    AX = error code (8012h,8013h,8014h,8016h,8021h) (see #2775)
Note:	first 16 bytes of memory block will be initialized to zeros on the
	  first allocation
SeeAlso: AX=0501h,AX=0D01h,AX=0D02h

Format of DPMI shared memory allocation request structure:
Offset	Size	Description	(Table 2791)
 00h	DWORD	requested length of shared memory block in bytes
 04h	DWORD	(ret) allocated length of block
 08h	DWORD	(ret) shared memory handle
 0Ch	DWORD	(ret) linear address of memory block
 10h	PWORD	selector:offset32 of ASCIZ name for memory block
		(name max 128 bytes)
 16h  2 BYTEs	reserved
 18h  4 BYTEs	reserved (00h)
--------E-310D01-----------------------------
INT 31 P - DPMI 1.0+ - FREE SHARED MEMORY
	AX = 0D01h
	SI:DI = shared memory block handle
Return: CF clear if successful
	CF set on error
	    AX = error code (8023h) (see #2775)
Notes:	handle becomes invalid after this call
	DPMI maintains separate global and virtual machine use counts for each
	  shared memory block; when the global use counts reaches zero, the
	  block is finally destroyed
SeeAlso: AX=0502h,AX=0D00h
--------E-310D02-----------------------------
INT 31 P - DPMI 1.0+ - SERIALIZE SHARED MEMORY
	AX = 0D02h
	SI:DI = shared memory block handle
	DX = flags
	    bit 0: return immediately rather than suspending if serialization
		  unavailable
	    bit 1: shared rather than exclusive serialization
	    bits 2-15 reserved (0)
Return: CF clear if successful
	CF set on error
	    AX = error code (8004h,8005h,8017h-8019h,8023h) (see #2775)
Notes:	an exclusive serialization blocks any other serialization attempts for
	  the same block by another virtual machine; a shared serialization
	  blocks attempts at exclusive serialization by another virtual machine
	hosts are not required to detect deadlock
	a client's interrupt handler can cancel a serialization call which
	  caused it to block by calling AX=0D03h
SeeAlso: AX=0D00h,AX=0D03h
--------E-310D03-----------------------------
INT 31 P - DPMI 1.0+ - FREE SERIALIZATION ON SHARED MEMORY
	AX = 0D03h
	SI:DI = shared memory block handle
	DX = flags
	    bit 0: release shared serialization rather than exclusive serialztn
	    bit 1: free pending serialization
	    bits 2-15 reserved (0)
Return: CF clear if successful
	CF set on error
	    AX = error code (8002h,8023h) (see #2775 at AX=0000h)
SeeAlso: AX=0D00h,AX=0D02h
--------E-310E00-----------------------------
INT 31 P - DPMI 1.0+ - GET COPROCESSOR STATUS
	AX = 0E00h
Return: CF clear
	AX = coprocessor status (see #2792)
Note:	supported by 386MAX v6.01, which otherwise only supports DPMI 0.9
SeeAlso: AX=0E01h

Bitfields for DPMI coprocessor status:
Bit(s)	Description	(Table 2792)
 0	numeric coprocessor enabled for current client
 1	client is emulating coprocessor
 2	numeric coprocessor is present
 3	host is emulating coprocessor instructions
 4-7	coprocessor type
	0000 none
	0010 80287
	0011 80387
	0100 80486 with numeric coprocessor
	other reserved
 8-15	not used
--------E-310E01-----------------------------
INT 31 P - DPMI 1.0+ - SET EMULATION
	AX = 0E01h
	BX = coprocessor flag bits (see #2793)
Return: CF clear if successful
	CF set on error
	    AX = error code (8026h) (see #2775 at AX=0000h)
Note:	supported by 386MAX v6.01, which otherwise only supports DPMI 0.9
SeeAlso: AX=0E00h

Bitfields for DPMI coprocessor flags:
Bit(s)	Description	(Table 2793)
 0	enable numeric coprocessor for current client
 1	client will emulate coprocessor
 2-15	not used
--------E-3157-------------------------------
INT 31 - Netroom3 DPMI.EXE v3.00 - ???
	AH = 57h
	AL = subfunction (at least 02h,03h,04h,05h,07h,08h,09h,0Ah)
	???
Return: ???
SeeAlso: INT 2C/AX=0000h"Cloaking"
--------E-315702-----------------------------
INT 31 - Netroom3 DPMI.EXE v3.00 - SWITCH TO PROTECTED MODE
	AX = 5702h
	DX = PSP segment of caller
	STACK: WORD	???
	       WORD	flags (bit 0 set if 32-bit program)
Return: as for DPMI mode-switch entry point (see #2366 at INT 2F/AX=1687h)
Note:	this function is called by the real-mode DPMI mode-switch entry point
SeeAlso: INT 2F/AX=1687h
--------E-31EE00------------------------
INT 31 - DOS32 v3.0+ - GET DOS32 VERSION AND SELECTOR VALUES
	AX = EE00h
Return: AL = minor version (BCD)
	AH = major version (BCD)
	DL = system type (1=raw DOS, 2=XMS, 4=VCPI, 8=DPMI)
	BX = selector of 4GB data segment with zero base address
Program: DOS32 is a 32 bit DOS extender by Adam Seychell.
SeeAlso: AX=EE02h
--------E-31EE02------------------------
INT 31 - DOS32 v3.0+ - GET DOS32 ADDRESS INFORMATION
	AX = EE02h
Return: AX = real-mode segment of temporary 8K buffer (v3.1+)
	EBX = 32bit linear address of the program segment
	EDX = Total size in bytes of the programs .EXE file after linking.
	ESI = offset address of PSP
	EDI = offset address of program environment
	ECX = offset address of the program's .EXE ASCIZ file name and path
SeeAlso: AX=EE00h,AX=EE20h
--------E-31EE10------------------------
INT 31 - DOS32 v3.2+ - SET UP A DOS32 LOADABLE LIBRARY
	AX = EE10h
	EDX -> library ASCIZ path\filename
	EBX = number of bytes to seek from beginning of file
Return: CF clear if successful
	    EAX = size of memory block required to store library
	    EBX = size of library file
	CF set on error
	    AL = error code.
		01h error opening or reading file
		02h bad DOS32 library file
SeeAlso: AX=EE00h,AX=EE11h
--------E-31EE11------------------------
INT 31 - DOS32 v3.2+ - LOAD LIBRARY FILE
	AX = EE11h
	EDX -> near pointer of memory block to store library
Return: CF clear if successful
	    EDX = near pointer to the dynamic library public
	CF set on error
Note:	must first successfuly call function AX=EE10h before calling this
	  function
SeeAlso: AX=EE00h,AX=EE10h
--------E-31EE20------------------------
INT 31 - DOS32 v3.0+ - GET REAL MODE CALL BACK ADDRESS WITH RETF STACK FRAME
	AX = EE20h
	ESI = offset of the real mode call back function
Return: CF clear if successful
	    CX:DX = real mode address to call up to the protected mode
		  procedure
	CF set on error
SeeAlso: AX=EE00h,AX=EE02h,AX=EE21h
--------E-31EE21------------------------
INT 31 - DOS32 v3.0+ - GET REAL MODE CALL BACK ADDRESS WITH IRET STACK FRAME
	AX = EE21h
	ESI = offset of the real mode call back function
Return: CF clear if successful
	    CX:DX = real mode address to call up to the protected mode
		  procedure
	CF set on error
SeeAlso: AX=EE20h
--------E-31EE30------------------------
INT 31 - DOS32 v3.0+ - TERMINATE AND STAY RESIDENT
	AX = EE30h
SeeAlso: AX=EE21h,AX=EE40h,INT 21/AH=31h
--------E-31EE40------------------------
INT 31 - DOS32 v3.0+ - UNDO PREVIOUS MEMORY ALLOCATION or DMA BUFFER
	AX = EE40h
Return: CF clear if successful
	CF set on error
SeeAlso: AX=EE41h,AX=EE42h
--------E-31EE41------------------------
INT 31 - DOS32 v3.0+ - ALLOCATE 16KB DMA BLOCK
	AX = EE41h
Return: CF clear if successful
	    EBX -> 16KB DMA block (physical address)
	    EDX -> 16KB DMA block (offset address)
	CF set on error
SeeAlso: AX=EE40h,AX=EE42h
--------E-31EE42------------------------
INT 31 - DOS32 v3.0+ - ALLOCATE MEMORY BLOCK
	AX = EE42h
	EDX = size in bytes
Return: CF clear if successful
	    EAX = size in bytes
	    EDX -> memory block
	CF set on error
Note:	size is rounded off to the next 4KB boundary
SeeAlso: AX=EE40h,AX=EE41h
--------E-31FF00-----------------------------
INT 31 P - CauseWay - "Info" - GET SYSTEM SELECTORS/FLAGS
	AX = FF00h
Return: AX = selector for flag address space (base 00000000h, limit 4GB)
	BX = selector for current PSP segment (limit 0100h)
	(E)CX = size of DOS transfer buffer (max 64K)
	DX = real-mode segment address of DOS transfer buffer
	ES:(E)SI = protected-mode address of DOS transfer buffer
	EDI = system flags (see #2794)
Program: CauseWay is a 386 DOS extender by Michael Devore and John Wildsmith
	  for use with Watcom C++ or assembly language programs
Notes:	the entire transfer buffer can be addressed with a 16-bit offset in
	  protected mode
	CauseWay always maps selector 0040h to the BIOS data segment at
	  real-mode segment 0040h; when not running under a DPMI host, CauseWay
	  also provides selectors A000h, B000h, and B800h mapped to video
	  memory
SeeAlso: AX=FF25h

Bitfields for CauseWay system flags:
Bit(s)	Description	(Table 2794)
 0	32-bit code
 1	virtual memory manage enabled
 3-2	mode: 00 raw extended memory, 01 VCPI, 10 DPMI
 4	DPMI available
 5	VCPI available
 6	no memory managers
 7	application descriptor table type: 0 = GDT, 1 = LDT
 14-8	reserved
 15	debugging engine present
--------E-31FF01-----------------------------
INT 31 P - CauseWay - "IntXX" - SIMULATE REAL-MODE INTERRUPT
	AX = FF01h
	BL = interrupt number
	ES:(E)DI -> real-mode register list (see #2780 at AX=0300h)
Return: register list updated
Note:	CauseWay fills in the values for SS, SP, and FLAGS itself, and ignores
	  the values specified for CS and IP
SeeAlso: AX=0300h,AX=FF02h
--------E-31FF02-----------------------------
INT 31 P - CauseWay - "FarCallReal" - SIMULATE REAL-MODE FAR CALL
	AX = FF02h
	ES:(E)DI -> real-mode register list (see #2780 at AX=0300h)
Return: register list updated
SeeAlso: AX=0301h,AX=FF01h
--------E-31FF03-----------------------------
INT 31 P - CauseWay - "GetSel" - ALLOCATE NEW SELECTOR
	AX = FF03h
Return: CF clear if successful
	    BX = new selector
	CF set on error
Note:	the new selector is initialized with a base address of 000000h, a limit
	  of 0000h, and attributes read/write expand-up data
SeeAlso: AX=FF04h,AX=FF05h,AX=FF06h
--------E-31FF04-----------------------------
INT 31 P - CauseWay - "RelSel" - RELEASE A SELECTOR
	AX = FF04h
	BX = selector
Return: CF clear if successful
	CF set on error
SeeAlso: AX=FF03h,AX=FF06h
--------E-31FF05-----------------------------
INT 31 P - CauseWay - "CodeSel" - CONVERT SELECTOR TO EXECUTABLE CODE SELECTOR
	AX = FF05h
	BX = selector
	CL = default operation size (00h = 16-bit, 01h = 32-bit)
Return: CF clear if successful
	CF set on error
SeeAlso: AX=FF03h
--------E-31FF06-----------------------------
INT 31 P - CauseWay - "AliasSel" - CREATE READ/WRITE DATA ALIAS SELECTOR
	AX = FF06h
	BX = original selector
Return: CF clear if successful
	    AX = new data selector aliasing original selector
	CF set on error
SeeAlso: AX=FF03h,AX=FF04h
--------E-31FF07-----------------------------
INT 31 P - CauseWay - "GetSelDet" - GET SELECTOR BASE AND LIMIT
	AX = FF07h
	BX = selector
Return: CF clear if successful
	    CX:DX = base address
	    SI:DI = limit (bytes)
	CF set on error
SeeAlso: AX=FF08h,AX=FF09h
--------E-31FF08-----------------------------
INT 31 P - CauseWay - "GetSelDet32" - GET SELECTOR BASE AND LIMIT (32-bit)
	AX = FF08h
Return: CF clear if successful
	    EDX = base address
	    ECX = limit (bytes)
	CF set on error
SeeAlso: AX=FF07h,AX=FF0Ah
--------E-31FF09-----------------------------
INT 31 P - CauseWay - "SetSelDet" - SET SELECTOR BASE AND LIMIT
	AX = FF09h
	BX = selector
	CX:DX = new base address
	SI:DI = new byte-granular limit
Return: CF clear if successful
	CF set on error
SeeAlso: AX=FF07h,AX=FF0Ah
--------E-31FF0A-----------------------------
INT 31 P - CauseWay - "SetSelDet32" - SET SELECTOR BASE AND LIMIT (32-bit)
	AX = FF0Ah
	BX = selector
	EDX = new base address
	ECX = new byte-granular limit
Return: CF clear if successful
	CF set on error
SeeAlso: AX=FF08h,AX=FF09h
--------E-31FF0B-----------------------------
INT 31 P - CauseWay - "GetMem" - ALLOCATE BLOCK OF MEMORY
	AX = FF0Bh
	CX:DX = size in bytes (FFFFh:FFFFh to get size of largest available)
Return: CF clear if successful
	    BX = selector for accessing block if requested size not FFFFh:FFFFh
	    CX:DX = size of largest available block if requested FFFFh:FFFFh
	CF set on error
SeeAlso: AX=FF0Ch,AX=FF0Dh,AX=FF0Fh,AX=FF10h,AX=FF2Ch
--------E-31FF0C-----------------------------
INT 31 P - CauseWay - "GetMem32" - ALLOCATE BLOCK OF MEMORY (32-bit)
	AX = FF0Ch
	ECX = size in bytes (FFFFFFFFh to get size of largest available block)
Return: CF clear if successful
	    BX = selector for accessing block if requested size not FFFFh:FFFFh
	    ECX = size of largest available block if requested FFFFh:FFFFh
	CF set on error
SeeAlso: AX=FF0Bh,AX=FF0Eh,AX=FF0Fh,AX=FF11h
--------E-31FF0D-----------------------------
INT 31 P - CauseWay - "ResMem" - RESIZE MEMORY BLOCK
	AX = FF0Dh
	BX = selector for block to be resized
	CX:DX = new size in bytes
Return: CF clear if successful
	CF set on error
Note:	the memory block may have to be copied to another location in order
	  to satisfy the requested new size, in which case the base address
	  of the selector is updated
SeeAlso: AX=FF0Bh,AX=FF0Eh,AX=FF12h
--------E-31FF0E-----------------------------
INT 31 P - CauseWay - "ResMem32" - RESIZE MEMORY BLOCK (32-bit)
	AX = FF0Eh
	BX = selector for block to be resized
	ECX = new size in bytes
Return: CF clear if successful
	CF set on error
Note:	the memory block may have to be copied to another location in order
	  to satisfy the requested new size, in which case the base address
	  of the selector is updated
SeeAlso: AX=FF0Ch,AX=FF0Dh,AX=FF13h
--------E-31FF0F-----------------------------
INT 31 P - CauseWay - "RelMem" - RELEASE PREVIOUSLY ALLOCATED MEMORY
	AX = FF0Fh
	BX = selector for block to be released
Return: CF clear if successful
	CF set on error
SeeAlso: AX=FF0Bh,AX=FF0Ch,AX=FF14h
--------E-31FF10-----------------------------
INT 31 P - CauseWay - "GetMemLinear" - ALLOCATE MEMORY WITHOUT SELECTOR
	AX = FF10h
	CX:DX = size of block in bytes
Return: CF clear if successful
	    SI:DI = linear address of allocated block
	CF set on error
Note:	this function may return addresses above 16M
SeeAlso: AX=FF0Bh,AX=FF11h,AX=FF12h,AX=FF14h
--------E-31FF11-----------------------------
INT 31 P - CauseWay - "GetMemLinear32" - ALLOCATE MEMORY WITHOUT SELECTOR
	AX = FF11h
	ECX = size of block in bytes
Return: CF clear if successful
	    ESI = linear address of allocated block
	CF set on error
Note:	this function may return addresses above 16M
SeeAlso: AX=FF0Ch,AX=FF10h,AX=FF13h,AX=FF14h
--------E-31FF12-----------------------------
INT 31 P - CauseWay - "ResMemLinear" - RESIZE LINEAR MEMORY BLOCK
	AX = FF12h
	CX:DX = new size in bytes
	SI:DI = linear address of block to be resized
Return: CF clear if successful
	   SI:DI = new linear address of block
	CF set on error
SeeAlso: AX=FF0Dh,AX=FF10h,AX=FF13h
--------E-31FF13-----------------------------
INT 31 P - CauseWay - "ResMemLinear32" - RESIZE LINEAR MEMORY BLOCK (32-bit)
	AX = FF13h
	ECX = new size in bytes
	ESI = linear address of block to be resized
Return: CF clear if successful
	   ESI = new linear address of block
	CF set on error
SeeAlso: AX=FF0Eh,AX=FF11h,AX=FF12h
--------E-31FF14-----------------------------
INT 31 P - CauseWay - "RelMemLinear" - RELEASE LINEAR MEMORY BLOCK
	AX = FF14h
	SI:DI = linear address of block to be released
Return: CF clear if successful
	CF set on error
SeeAlso: AX=FF0Fh,AX=FF10h,AX=FF15h
--------E-31FF15-----------------------------
INT 31 P - CauseWay - "RelMemLinear32" - RELEASE LINEAR MEMORY BLOCK (32-bit)
	AX = FF15h
	ESI = linear address of block to be released
Return: CF clear if successful
	CF set on error
SeeAlso: AX=FF0Fh,AX=FF11h,AX=FF15h
--------E-31FF16-----------------------------
INT 31 P - CauseWay - "GetMemNear" - ALLOCATE APPLICATION-RELATIVE MEMORY
	AX = FF16h
	EBX = size in bytes of block to allocate
Return: CF clear if successful
	   ESI = application-relative linear address of allocated block
	CF set on error
SeeAlso: AX=FF17h,AX=FF18h,AX=FF19h
--------E-31FF17-----------------------------
INT 31 P - CauseWay - "ResMemNear" - RESIZE APPLICATION-RELATIVE MEMORY BLOCK
	AX = FF17h
	EBX = size in bytes of block to allocate
	ESI = application-relative linear address of block
Return: CF clear if successful
	    ESI = new application-relative linear address of block
	CF set on error
SeeAlso: AX=FF16h,AX=FF18h,AX=FF19h
--------E-31FF18-----------------------------
INT 31 P - CauseWay - "RelMemNear" - RELEASE APPLICATION-RELATIVE MEMORY BLOCK
	AX = FF18h
	ESI = application-relative linear address of block
Return: CF clear if successful
	CF set on error
SeeAlso: AX=FF16h,AX=FF17h,AX=FF19h
--------E-31FF19-----------------------------
INT 31 P - CauseWay - "Linear2Near" - CONVERT LINEAR TO APP-RELATIVE ADDRESS
	AX = FF19h
	ESI = linear address
Return: ESI = application-relative linear address
SeeAlso: AX=FF1Ah
--------E-31FF1A-----------------------------
INT 31 P - CauseWay - "Near2Linear" - CONVERT APP-RELATIVE TO LINEAR ADDRESS
	AX = FF1Ah
	ESI = application-relative linear address
Return: ESI = linear address
SeeAlso: AX=FF19h
--------E-31FF1B-----------------------------
INT 31 P - CauseWay - "LockMem" - LOCK REGION OF MEMORY
	AX = FF1Bh
	BX:CX = starting linear address
	SI:DI = size of region in bytes
Return: CF clear if successful
	CF set on error
Desc:	prevent memory from being swapped out by the virtual memory manager
Note:	locks are applied on 4K page boundaries, so memory above and below
	  the specified region may be locked as well
SeeAlso: AX=FF1Ch,AX=FF1Dh
--------E-31FF1C-----------------------------
INT 31 P - CauseWay - "LockMem32" - LOCK REGION OF MEMORY (32-bit)
	AX = FF1Ch
	ESI = starting linear address
	ECX = size of region in bytes
Return: CF clear if successful
	CF set on error
Desc:	prevent memory from being swapped out by the virtual memory manager
Note:	locks are applied on 4K page boundaries, so memory above and below
	  the specified region may be locked as well
SeeAlso: AX=FF1Bh,AX=FF1Eh,AX=FF1Fh
--------E-31FF1D-----------------------------
INT 31 P - CauseWay - "UnLockMem" - UNLOCK REGION OF MEMORY
	AX = FF1Dh
	BX:CX = starting linear address
	SI:DI = size of region in bytes
Return: CF clear if successful
	CF set on error
Desc:	allow memory to be swapped out by the virtual memory manager
Note:	locks are applied on 4K page boundaries, so memory above and below
	  the specified region may be unlocked as well
SeeAlso: AX=FF1Bh,AX=FF1Eh
--------E-31FF1E-----------------------------
INT 31 P - CauseWay - "UnLockMem32" - UNLOCK REGION OF MEMORY (32-bit)
	AX = FF1Eh
	ESI = starting linear address
	ECX = size of region in bytes
Return: CF clear if successful
	CF set on error
Desc:	allow memory to be swapped out by the virtual memory manager
Note:	locks are applied on 4K page boundaries, so memory above and below
	  the specified region may be unlocked as well
SeeAlso: AX=FF1Ch,AX=FF1Dh,AX=FF20h
--------E-31FF1F-----------------------------
INT 31 P - CauseWay - "LockMemNear" - LOCK APPLICATION-RELATIVE MEMORY REGION
	AX = FF1Fh
	ESI = starting application-relative linear address
	EBX = size of region in bytes
Return: CF clear if successful
	CF set on error
Desc:	prevent memory from being swapped out by the virtual memory manager
Note:	locks are applied on 4K page boundaries, so memory above and below
	  the specified region may be locked as well
SeeAlso: AX=FF1Ch,AX=FF20h
--------E-31FF20-----------------------------
INT 31 P - CauseWay - "UnLockMemNear" - UNLOCK APP-RELATIVE MEMORY REGION
	AX = FF20h
	ESI = starting application-relative linear address
	ECX = size of region in bytes
Return: CF clear if successful
	CF set on error
Desc:	allow memory to be swapped out by the virtual memory manager
Note:	locks are applied on 4K page boundaries, so memory above and below
	  the specified region may be unlocked as well
SeeAlso: AX=FF1Eh,AX=FF1Fh
--------E-31FF21-----------------------------
INT 31 P - CauseWay - "GetMemDOS" - ALLOCATE CONVENTIONAL MEMORY
	AX = FF21h
	BX = number of paragraphs to allocate
Return: CF clear if successful
	    AX = real-mode segment of allocated block
	    DX = initial selector for block
	CF set on error
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
	    BX = size of largest available block
Note:	if the requested size is greater than 64K, contiguous selectors will
	  be allocated, one for each 64K; for 32-bit applications, the first
	  selector's limit will be set to the size of the entire block, while
	  that selector will have a limit of 64K for 16-bit applications.  All
	  selectors after the first one have a limit of 64K except the final
	  one
SeeAlso: AX=FF22h,AX=FF23h,INT 21/AH=48h
--------E-31FF22-----------------------------
INT 31 P - CauseWay - "ResMemDOS" - RESIZE CONVENTIONAL MEMORY BLOCK
	AX = FF22h
	BX = new size in paragraphs
	DX = initial selector for block
Return: CF clear if successful
	CF set on error
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
	    BX = maximum number of paragraphs available
Note:	this function will also fail if the block is expanded past a 64K
	  boundary and the next selector is already in use
SeeAlso: AX=FF21h,AX=FF23h,INT 21/AH=49h
--------E-31FF23-----------------------------
INT 31 P - CauseWay - "RelMemDOS" - RELEASE CONVENTIONAL MEMORY BLOCK
	AX = FF23h
	DX = initial selector for block
Return: CF clear if successful
	CF set on error
	    AX = DOS error code (see #1332 at INT 21/AH=59h/BX=0000h)
Note:	all descriptors allocated for the block are freed
SeeAlso: AX=FF21h,AX=FF22h,INT 21/AH=4Ah
--------E-31FF24-----------------------------
INT 31 P - CauseWay - "ExecOverlay" - LOAD AND OPTIONALLY EXECUTE APP CODE
	AX = FF24h
	EBX = flags
	    bit 0: don't execute (overlay only)
	    bit 1: don't preserve relocation information
	ES:EDX -> filename (see also #2795)
	FS:ESI -> commandline (ESI = 00000000h if no commandline)
	GS:EDI -> name (CW's /o option)
Return: CF clear if successful
	    ---EBX bit 0 set---
	    CX:EDX = program entry point (CS:EIP)
	    SI = segment of PSP
	    ---EBX bit 1 set---
	    BX:EAX = initial SS:ESP
	    EDI high word = base segment
	    EDI low word = number of segments
	    EBP = start of segment definitions
	CF set on error
	    AX = error code
		0001h DOS file access error
		0002h not a CuaseWay 3P file
		0003h not enough memory
SeeAlso: AX=FF2Ah,INT 21/AH=4Bh

Format of CauseWay executable:
Offset	Size	Description	(Table 2795)
 00h  2 BYTEs	signature "3P"
 02h	DWORD	size of header data in bytes
 06h	DWORD	size of EXE image data in bytes
 0Ah	DWORD	number of bytes of program memory required
 0Eh	WORD	number of segment definitions (see #2797)
 10h	DWORD	number of relocation table entries
 14h	DWORD	offset of program entry point
 18h	WORD	segment list entry number for entry point's CS
 1Ah	DWORD	initial ESP
 1Eh	WORD	segment list entry number for initial SS
 20h	DWORD	control flags (see #2796)
 24h	DWORD	automatic stack size in bytes if ESP entry = 00000000h
 28h	BYTE	length of name (name follows program image)
 29h 23 BYTEs	reserved
SeeAlso: #1246,#1261 at INT 21/AH=4Bh

Bitfields for CauseWay executable control flags:
Bit(s)	Description	(Table 2796)
 0	16-bit interrupt stack frame
 7	descriptor table type (0 = GDT, 1 = LDT)
 14	16-bit default data size
 31	compressed EXE image
Note:	bits 0 and 14 should always be equal
SeeAlso: #2795

Format of CauseWay segment definition [array]:
Offset	Size	Description	(Table 2797)
 00h	DWORD	start offset within program image
 04h	DWORD	length and type
		bits 0-19: length
		bit 20:	   granularity (if set, length is in 4K pages)
		bits 21-24: type
			0000 code
			0001 read/write data
			0010 stack
			0011 read-only data
		bit 25: force segment descriptor's D bit to 0
		bit 26: force segmetn descriptor's D bit to 1
SeeAlso: #2795
--------E-31FF25-----------------------------
INT 31 P - CauseWay - "GetDOSTrans" - GET DOS TRANSFER BUFFER
	AX = FF25h
Return: BX = real-mode segment of transfer buffer
	ECX = transfer buffer size
	DX = protected-mode selector for transfer buffer
Note:	the default buffer size of 8K is sufficient for most applications,
	  but an application performing large amounts of file I/O may benefit
	  from allocating its own, larger buffer
SeeAlso: AX=FF00h,AX=FF26h
--------E-31FF26-----------------------------
INT 31 P - CauseWay - "SetDOSTrans" - SET DOS TRANSFER BUFFER
	AX = FF26h
	BX = real-mode segment of new transfer buffer
	ECX = new transfer buffer size
	DX = protected-mode selector for new transfer buffer
Return: nothing
Note:	the specific buffer must be located in conventional memory; only the
	  first 64K will be used
SeeAlso: AX=FF25h
--------E-31FF27-----------------------------
INT 31 P - CauseWay v1.3 - "GetMCBSize" - GET CURRENT MCB ALLOCATION BLOCK SIZE
	AX = FF27h
Return: ECX = current threshold
Desc:	determine the memory allocation size below which CauseWay will use
	  internal MCB chains rather than allocating full 4K pages via DPMI
SeeAlso: AX=FF00h,AX=FF28h
--------E-31FF28-----------------------------
INT 31 P - CauseWay v1.3 - "SetMCBSize" - SET MCB MEMORY ALLOCATION BLOCK SIZE
	AX = FF28h
	ECX = new threshold (0000000h to disable MCB memory allocation system)
Return: CF clear if successful
	    threshold unchanged (default 16K)
	CF set on error (threshold > 64K)
Desc:	specify the memory allocation size below which CauseWay will use
	  internal MCB chains rather than allocating full 4K pages via DPMI
Note:	the specified threshold will be rounded up to the next higher multiple
	  of 4K
SeeAlso: AX=FF00h,AX=FF27h
--------E-31FF29-----------------------------
INT 31 P - CauseWay v1.3 - "GetSels" - ALLOCATE MULTIPLE SELECTORS
	AX = FF29h
	CX = number of selectors to allocate
Return: BX = base selector
Desc:	allocate multiple contiguous selectors, initializing each to have a
	  base address and limit of zero
SeeAlso: AX=FF00h,AX=FF04h
--------E-31FF2A-----------------------------
INT 31 P - CauseWay v1.3 - "cwLoad" - LOAD ANOTHER CAUSEWAY PROGRAM AS OVERLAY
	AX = FF2Ah
	DS:EDX -> filename
Return: CF clear if successful
	    CX:EDX = CS:EIP of entry point
	    BX:EAX = initial SS:ESP for program
	    SI = PSP for overlay program
	CF set on error
	    AX = error code (01h file error, 02h not a 3P file, 03h no memory)
Note:	the returned PSP can be given to "RelMem" (AX=FF0Fh) to release the
	  overlay's memory and selectors; only selectors and memory allocated
	  during loading will be freed by RelMem unless one switches PSPs with
	  INT 21/AH=50h
SeeAlso: AX=FF00h,AX=FF24h
--------E-31FF2B-----------------------------
INT 31 P - CauseWay v1.3 - "cwcInfo" - VALIDATE AND GET SIZE OF CWC FILE
	AX = FF2Bh
	BX = file handle for CWC-compressed file
Return: CF clear if successful
	    ECX = expanded file size
	CF set on error (not a CWC-compressed file)
SeeAlso: AX=FF00h,AX=FFFBh
--------E-31FF2C-----------------------------
INT 31 P - CauseWay v1.3 - "GetMemSO" - ALLOCATE MEMORY AND RETURN SEL:OFFSET
	AX = FF2Ch
	CX:DX = block size in bytes
Return: CF clear if successful
	   SI:DI = selector:offset of allocated memory
	CF set on error
Note:	unlike "GetMem" (AX=FF0Bh), this function will reuse selectors until a
	  segment is full, rather than allocating a new selector for each
	  memory block
SeeAlso: AX=FF00h,AX=FF2Dh,AX=FF2Eh
--------E-31FF2D-----------------------------
INT 31 P - CauseWay v1.3 - "ResMemSO" - RESIZE SELECTOR:OFFSET MEMORY BLOCK
	AX = FF2Dh
	SI:DI = selector:offset for memory block
	CX:DX = new size of block
Return: CF clear if successful
	   SI:DI = new selector:offset for memory block
	CF set on error
SeeAlso: AX=FF00h,AX=FF2Ch,AX=FF2Eh
--------E-31FF2E-----------------------------
INT 31 P - CauseWay v1.3 - "RelMemSO" - RELEASE SELECTOR:OFFSET MEMORY BLOCK
	AX = FF2Eh
	SI:DI = selector:offset for memory block
SeeAlso: AX=FF00h
--------E-31FFFB-----------------------------
INT 31 P - Causeway v1.3 - "cwcLoad" - LOAD/EXPAND CWC-COMPRESSED FILE
	AX = FFFBh
	BX = source file handle
	ES:EDI -> memory buffer into which to expand file
Return: CF clear if successful
	    ECX = expanded data length
	CF set on error
	    EAX = error code (01h file error, 02h bad data, 03h not CWC file)
Note:	the provided file may consist of the concatenation of several CWC
	  files; the one beginning at the current file position will be
	  expanded
SeeAlso: AX=FF2Bh
--------v-32---------------------------------
INT 32 - VIRUS - reportedly used by "Tiny" Viruses
SeeAlso: INT 21/AX=FFFFh"VIRUS",INT 31"VIRUS",INT 44"VIRUS"
--------v-32---------------------------------
INT 32 - VIRUS - "Plovdiv 1.3"/"Damage 1.3" - ORIGINAL INT 21h VECTOR
SeeAlso: INT 31"VIRUS",INT 9E"VIRUS"
--------y-326E-------------------------------
INT 32 - NOISE.SYS 0.53 - API
	AH = 6Eh (function ID)
	AL = subfunction (see INT 32/AX=6E00h)
Return: CF set on error
	    AL = error code (see #2798)
	CF clear if successful
Notes:	INT 32 is only a proposed interface for NOISE.SYS. Use the IOCTL READ
	  from the RANDOM device to determine the interrupt and function ID
	  used by the driver, since future versions may use the Alternate
	  Multiplex Interrupt (AMIS) at INT 2Dh.
	the beta v0.51 had a substantially different API on INT 32/AH=6Eh

(Table 2798)
Values for NOISE.SYS error codes:
 00h	subfunction not supported
 FBh	random pool is empty
 FCh	quality of sample is too low
 FDh	too many processes using the API or driver
 FEh	subfunction is disabled in the current build
 FFh	successful
--------y-326E00-----------------------------
INT 32 - NOISE.SYS v0.53+ - INSTALLATION CHECK
	AX = 6E00h
Return: AL = installation status
	    00h not installed
	    FFh installed
		CX = version (ie, 0123h = Version 1.2.3)
		DX:DI -> signature string
--------y-326E01-----------------------------
INT 32 - NOISE.SYS v0.53+ - GET ENTRY POINT
	AX = 6E01h
Return: AL = FFh
	DX:DI -> far call hook
----------326E04-----------------------------
INT 32 - NOISE.SYS v0.55+ - GET INTERRUPT HOOK LIST
	AX = 6E04h
Return: AL = status
	    00h = unimplemented
	    04h = DX:BX -> interrupt hook list
	    FEh = subfunction disabled
Note:	the hook list array ends with API interrupt (usually 32h, although
	  it will differ if the API is installed at another interrupt)
----------326E06-----------------------------
INT 32 - NOISE.SYS v0.55+ - GET DEVICE DRIVER HEADER
	AX = 6E06h
Return: AL = number of device drivers in NOISE.SYS chain
	    02h = default (for RANDOM and URANDOM devices)
	AH = AMIS device driver flags (set to 00h for now)
	DX:BX -> first device in chain (see #1298)
SeeAlso: INT 2D/AL=06h
--------y-326E10-----------------------------
INT 32 - NOISE.SYS v0.53+ - STATUS CHECK
	AX = 6E10h
Return: CF set on error
	    AL = error code (FDh) (see #2798)
	CF clear if successful
	    AL = status
		FFh successful
	    BH = number of processes using the API
	    CX = number of random bytes waiting
	    DX = maximum possible bytes waiting
		(if CX=DX, the pool is full)
Note:	this subfunction is a convenient way to check the driver if any
	  fresh bytes are waiting in the output pool.
SeeAlso: INT 32/AH=6Eh,AX=6E00h,AX=6E11h
--------y-326E11-----------------------------
INT 32 - NOISE.SYS v0.53+ - GET ENTROPY ESTIMATE
	AX = 6E11h
Return: CF set on error
	    AL = error code (00h,FDh,FEh) (see #2798)
	CF clear if successful
	    EBX = estimated bit count (refer to note below)
	    CL = FRACBITS (number of fractional bits)
	    EDX = low 32-bits of total number of samples added
Note:  the estimated number of fresh random bits is equal to
	  (EAX >> FRACBITS) + ((EAX & ((1 << FRACBITS)-1) / (1 << FRACBITS))
SeeAlso: AH=6Eh,AX=6E00h
--------y-326E12-----------------------------
INT 32 - NOISE.SYS v0.53+ - ADD SAMPLE FROM FAST TIMER
	AX = 6E12h
Return: CF set on error
	    AL = error code (FCh,FDh,FEh) (see #2798)
	CF clear if successful
	    CX = number of random bytes waiting
Note:	subfunctions 12h and 13h are meant for applications or devices
	  which are able to gather entropy from other sources which are
	  not polled by NOISE.SYS (for example, a communications driver
	  could use this call to sample packet arrival times).
SeeAlso: AX=6E00h,AX=6E10h,AX=6E13h
--------y-326E13-----------------------------
INT 32 - NOISE.SYS v0.53+ - ADD 16-BIT SAMPLE TO RANDOM POOL
	AX = 6E13h
	DX = sample
Return: CF set on error
	    AL = error code (FCh,FEh) (see #2798)
	CF clear if successful
	    CX = number of random bytes waiting
SeeAlso: AX=6E00h,AX=6E11h
--------y-326E14-----------------------------
INT 32 - NOISE.SYS v0.53+ - GET FLAGS
	AX = 6E14h
Return: BX = flags (see #2799)
	CX = mask of settable flags in BX
SeeAlso: AX=6E00h,AX=6E15h

Bitfields for NOISE.SYS flags:
Bit(s)	Description	(Table 2799)
 0	MS Windows active
 1-5	reserved
 6	clock drift sampling
 7	video retrace drift sampling
 8	network access sampling (not implemented yet in 0.53)
 9	CD-ROM access sampling (not implemented yet in 0.53)
 10	DOS spinner
 11	DOS process start/end and miscellaneous process activity sampling
 12	mouse movement/button sampling
 13	disk sampling (INT 13)
 14	keystroke timings
 15	reserved for hardware RNG
--------y-326E15-----------------------------
INT 32 - NOISE.SYS v0.53+ - SET FLAGS
	AX = 6E15h
	BX = flags (see #2799)
Return: BX = new flags
Note:	flags which AX=6E14h indicates are not settable should be masked off
	  by ANDing with the CX returned by AX=6E14h
SeeAlso: AX=6E00h,AX=6E14h
--------y-326E16-----------------------------
INT 32 - NOISE.SYS v0.53+ - READ URANDOM BYTES
	AX = 6E16h
	CX = number of bytes
	ES:DI -> buffer
Return: CF set on error
	    AL = error code (FDh,FEh) (see #2798)
	CF clear if successful
	    CX = number of random bytes read
SeeAlso: AX=6E00h,AX=6E12h,AX=6E17h
--------y-326E17-----------------------------
INT 32 - NOISE.SYS v0.53+ - READ RANDOM BYTES
	AX = 6E17h
	CX = number of bytes
	ES:DI -> buffer
Return: CF set on error
	    AL = error code (FBh,FDh,FEh) (see #2798)
	CF clear if successful
	    CX = number of random bytes read
SeeAlso: AX=6E00h,AX=6E16h
----------326E18-----------------------------
INT 32 - NOISE.SYS v0.6+ - READ CONTROL RECORD
	AX = 6E18h
	CX = buffer size
	ES:DI -> buffer
Return: AL = status
	    00h unimplemented (before v0.6)
	    FEh subfunction is disabled
	    FFh successful
		CX = number of bytes read
Note:	the control record corresponds to the IOCTL Read record for the RANDOM
	  device
----------326E-------------------------------
INT 32 - NOISE.SYS - RESERVED FOR FUTURE USE
	AH = 6Eh
	AL = 19h to 3Fh
Return: AL = 00h
Note:	these functions are reserved for future use; user additions to the
	  the driver should use subfunctions 40h to FFh.
--------!---Section--------------------------
