Interrupt List, part 6 of 12
This compilation is Copyright (c) 1989,1990,1991,1992,1993,1994 Ralf Brown
--------N-21C0-------------------------------
INT 21 O - Novell NetWare, Alloy NTNX - RELEASE RECORD (FCB)
	AH = C0h
	DS:DX -> non-extended FCB (see #0486 at AH=0Fh)
	BX:CX = offset
Return: AL = error code (see #0888)
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
SeeAlso: AX=BE00h,AH=C1h"VIRUS",AX=C301h"VIRUS"
--------N-21C1-------------------------------
INT 21 O - Novell NetWare, Alloy NTNX - CLEAR RECORD (FCB)
	AH = C1h
	DS:DX -> opened FCB (see #0486 at AH=0Fh)
	BX:CX = offset
Return: AL = error code (see #0888)
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
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - RELEASE PHYSICAL RECRD SET
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
	    03h name length greater than 127 (see Novell document FYI.A.4611)
	    FEh invalid name length
	    FFh invalid semaphore value
Notes:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	the semaphore's value is incremented by AX=C503h and decremented by
	  AX=C502h
SeeAlso: AX=C501h,AX=C502h,AX=C503h,AX=C504h
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
SeeAlso: AX=C500h"NetWare",AX=C502h,AX=C504h
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
SeeAlso: AX=C500h"NetWare",AX=C501h,AX=C503h
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
SeeAlso: AX=C500h"NetWare",AX=C502h
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
SeeAlso: AX=C500h"NetWare",AX=C501h
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
INT 21 - VIRUS - "Yankee" or "MLTI" - INSTALLATION CHECK
	AX = C603h
	CF set
Return: CF clear if resident
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
SeeAlso: AX=C701h,AX=C702h,AX=C703h
--------v-21C700-----------------------------
INT 21 - VIRUS - "MH-757" - INSTALLATION CHECK
	AX = C700h
Return: AL = 07h if resident
SeeAlso: AX=C603h"VIRUS",AH=CBh"VIRUS"
--------N-21C701-----------------------------
INT 21 - Novell NetWare - TRANSACTION TRACKING SYSTEM - END TRANSACTION
	AX = C701h
Return: AL = status (00h,FDh-FFh) (see #0890)
	    00h successful
		CX:DX = transaction number
	CF clear except when AL=FFh
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AX=C700h"NetWare",AX=C703h

(Table 0890)
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
--------N-21C703-----------------------------
INT 21 - Novell NetWare - TRANSACTION TRACKING SYSTEM - ABORT TRANSACTION
	AX = C703h
Return: CF clear if successful
	    AL = 00h
	CF set on error
	    AL = error code (FDh-FFh) (see #0890)
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AX=C700h"NetWare",AX=C701h,AX=C704h
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
SeeAlso: AX=C700h"NetWare",AX=C701h,AX=C703h
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
SeeAlso: AX=C706h,AX=C707h
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
SeeAlso: AX=C705h,AX=C708h
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
SeeAlso: AX=C705h,AX=C708h
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
SeeAlso: AX=C706h,AX=C707h
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
	DS:DX -> FCB (see #0486 at AH=0Fh)
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
Return: AL = status (00h,FEh,FFh) (see #0891)
Desc:	attempt to lock all files listed in the log table
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	status FFh will be returned if one or more of the files have already
	  been exclusively locked by another process
SeeAlso: AH=CAh,AH=CDh,AH=D1h,AH=EBh

(Table 0891)
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
	DS:DX -> FCB (see #0486 at AH=0Fh)
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
	DS:DX -> FCB (see #0486 at AH=0Fh)
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
--------v-21D000-----------------------------
INT 21 - VIRUS - "Fellowship" - INSTALLATION CHECK
	AX = D000h
Return: BX = 1234h if resident
SeeAlso: AH=CCh"VIRUS",AH=D5h"VIRUS",AX=D5AAh
--------N-21D1-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - LOCK LOGICAL RECORD SET
	AH = D1h
	AL = lock type (00h exclusive, 01h shareable)
	if function C6h lock mode 00h:
	    DL = mode (00h no wait, 01h wait)
	if function C6h lock mode 01h: (Novell only)
	    BP = lock timeout in timer ticks (1/18 sec), 0000h no wait
Return: AL = status (see #0891)
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
Return: AL = status (00h,FFh) (see #0892)
Desc:	unlock and remove the logical record name from the log table
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+,
	  Banyan VINES, and Alloy NTNX
	locks on logical record names are advisory and may be ignored by other
	  applications
SeeAlso: AH=BEh,AH=D0h,AH=D2h,AH=D5h

(Table 0892)
Values for NetWare status:
 00h	successful
 FFh	no such record name
--------N-21D5-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - CLEAR LOGICAL RECORD SET
	AH = D5h
Return: AL = error code (00h,FFh) (see #0892)
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
SeeAlso: AH=BBh,AH=D7h
--------N-21D7-------------------------------
INT 21 - Novell NetWare - CONNECTION SERVICES - SYSTEM LOGOUT
	AH = D7h
Return: AL = error code
Desc:	this function closes the caller's open files, logs it out from all
	  file servers, detaches the workstation from all non-default file
	  servers, and maps a drive to the default server's SYS:LOGIN directory
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=D6h,AH=E3h/SF=14h,AH=F1h
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
	ES:DI -> reply buffer (see #0893)
Return: AL = 00h
Notes:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
	operator console rights are not required to make this call
	reported total blocks and total unused blocks include the Hot Fix
	  Table; the NetWare shell's implementation of INT 21/AH=36h will
	  report values larger than 268MB as 268MB.
SeeAlso: AH=36h,AH=E2h/SF=15h,AH=E3h/SF=E9h

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0893)
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
SeeAlso: AH=E0h"VIRUS",AH=EEh"VIRUS"
--------v-21DE-------------------------------
INT 21 - VIRUS - "Durban" - INSTALLATION CHECK
	AH = DEh
Return: AH = DFh if resident
SeeAlso: AX=DAFEh,AX=DEDEh"VIRUS"
--------v-21DE-------------------------------
INT 21 - VIRUS - "April 1st EXE" - ???
	AH = DEh
	???
Return: ???
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
--------v-21DEDE-----------------------------
INT 21 - VIRUS - "Brothers" - INSTALLATION CHECK
	AX = DEDEh
Return: AH = 41h if resident
SeeAlso: AH=DEh"VIRUS",AH=E0h"VIRUS"
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
		AH = error code (01h,02h) (see #0894)

(Table 0894)
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
		AH = error code (01h,03h) (see #0894)
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
		AH = error code (01h) (see #0894)
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
		AH = error code (01h) (see #0894)
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
		AH = error code (01h,04h,05h) (see #0894)
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
		AH = error code (01h) (see #0894)
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
		AH = error code (01h,06h) (see #0894)
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
		AH = error code (01h,03h) (see #0894)
Note:	this function never returns is successful
--------T-21DF0A-----------------------------
INT 21 - Software Carousel - GET MEMORY SIZE/PARTITION NUMBER OF CURRENT TASK
	AX = DF0Ah
Return: AL = status
	    00h Carousel not running
	    01h successful
		BL = task number
		DX = memory size in KB
	    FFh unsucessful
		AH = error code (01h,03h) (see #0894)
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
		AH = error code (01h,03h) (see #0894)
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
	CL = BDOS function number (see INT E0"CP/M")
	other registers as appropriate for function
Return: as appropriate for function
SeeAlso: AX=4459h,INT E0"CP/M"
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
	DS:SI -> request buffer (see #0895)
	ES:DI -> reply buffer
Return: AL = status
Note:	this function was added in NetWare 4.0, but is no longer listed in
	  current Novell documentation and may no longer be supported
SeeAlso: AH-E3h/SF=68h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0895)
 00h	WORD	length of following data
 02h	BYTE	subfunction
		00h spool data to a capture file
		01h close and queue capture file
		02h set spool flags
		03h spool existing file
		04h get spool queue entry
		05h remove entry from spool queue
 03h	???
--------N-21E0--SF06-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - GET PRINTER STATUS
	AH = E0h subfn 06h
	DS:SI -> request buffer (see #0896)
	ES:DI -> reply buffer (see #0897)
Return: AL = status
	    00h successful
	    FFh no such printer
Desc:	get current state of specified printer attached to the server
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX

Format of NetWare request buffer:
Offset	Size	Description	(Table 0896)
 00h	WORD	0002h (length of following data)
 02h	BYTE	06h (subfunction "Get Printer Status")
 03h	BYTE	printer number (00h-04h)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0897)
 00h	WORD	(call) 0004h (size of following results buffer)
 02h	BYTE	flag: 00h printer active, FFh printer halted
 03h	BYTE	flag: 00h printer online, 01h printer offline
 04h	BYTE	current form type
 05h	BYTE	target printer number (00h-04h)
		same as number in request buffer unless rerouted by server
		  console
--------N-21E0--SF09-------------------------
INT 21 - Novell NetWare - PRINT SERVICES - SPECIFY CAPTURE FILE
	AH = E0h subfn 09h
	DS:SI -> request buffer (see #0898)
	ES:DI -> reply buffer (see #0899)
Return: AL = status
	    00h successful
	    9Ch invalid path
Desc:	create a permanent capture file for the next print capture to be
	  started
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	the caller must have read, write, and create rights for the directory
	  containing the capture file

Format of NetWare request buffer:
Offset	Size	Description	(Table 0898)
 00h	WORD	length of following data (max 102h)
 02h	BYTE	09h (subfunction "Specify Capture File")
 03h	BYTE	directory handle or 00h
 04h	BYTE	length of filename
 05h  N BYTEs	name of capture file

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0899)
 00h	WORD	(call) 0000h (no results returned)
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
	DS:SI -> request buffer (see #0900)
	ES:DI -> reply buffer (see #0901)
Return: AL = status
	    00h successful
	    FEh I/O error or out of dynamic workspace
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AH=DEh"NetWare",AH=DEh/DL=04h,AH=E1h/SF=01h,AH=E1h/SF=04h
SeeAlso: AH=E1h/SF=09h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0900)
 00h	WORD	length of following data (max 9Eh)
 02h	BYTE	00h (subfunction "Send Broadcast Message")
 03h	BYTE	number of connections (01h-64h)
 04h  N BYTEs	list of connections to receive broadcast message
	BYTE	length of message (01h-37h)
      N BYTEs	broadcast message (no control characters or characters > 7Eh)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0901)
 00h	WORD	(call) size of following results buffer (max 65h)
 02h	BYTE	number of connections
 03h  N BYTEs	list of per-connection results
		00h successful
		FCh message rejected due to lack of buffer space
		FDh invalid connection number
		FFh blocked (see also AH=E1h/SF=02h)
--------N-21E1--SF01-------------------------
INT 21 - Novell NetWare - MESSAGE SERVICES - GET BROADCAST MESSAGE
	AH = E1h subfn 01h
	DS:SI -> request buffer (see #0902)
	ES:DI -> reply buffer (see #0903)
Return: AL = status
	    00h successful
	    FCh full message queue
	    FEh out of dynamic workspace
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AH=DEh/DL=04h,AH=E1h/SF=00h,AH=E1h/SF=05h,AH=E1h/SF=09h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0902)
 00h	WORD	0001h (length of following data)
 02h	BYTE	01h (subfunction "Get Broadcast Message")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0903)
 00h	WORD	(call) size of following results buffer (max 38h)
 02h	BYTE	length of message (00h-37h)
		00h if no broadcast messages pending
 03h  N BYTEs	message (no control characters or characters > 7Eh)
--------N-21E1-------------------------------
INT 21 - Novell NetWare - MESSAGE SERVICES - ENABLE/DISABLE BROADCAST MESSAGES
	AH = E1h
	DS:SI -> request buffer (see #0904)
	ES:DI -> reply buffer (see #0905)
Return: AL = error code
Note:	these functions are supported by NetWare 4.0+ but are not listed in
	  _NetWare_System_Calls--DOS_; they may be obsolete
SeeAlso: AH=E1h/SF=00h,AH=E1h/SF=04h,AH=E1h/SF=09h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0904)
 00h	WORD	length of following data (max 9Eh)
 02h	BYTE	subfunction
		02h disable station broadcasts
		03h enable station broadcasts
 03h	???

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0905)
 00h	WORD	(call) size of following results buffer
 02h	???
--------N-21E1--SF04-------------------------
INT 21 O - Novell NetWare - MESSAGE SERVICES - SEND PERSONAL MESSAGE
	AH = E1h subfn 04h
	DS:SI -> request buffer (see #0906)
	ES:DI -> reply buffer (see #0907)
Return: AL = status
	    00h successful
	    FEh I/O error or out of dynamic workspace
Notes:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0-2.x
	message pipes use CPU time on the file server; IPX, SPX, or NetBIOS
	  connections should be used for peer-to-peer communications as these
	  protocols do not use file server time
SeeAlso: AH=E1h/SF=00h,AH=E1h/SF=05h,AH=E1h/SF=06h,AH=E1h/SF=08h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0906)
 00h	WORD	length of following data (max E5h)
 02h	BYTE	04h (subfunction "Send Personal Message")
 03h	BYTE	number of connections (01h-64h)
 04h  N BYTEs	list of connections to receive broadcast message
	BYTE	length of message (01h-7Eh)
      N BYTEs	message (no control characters or characters > 7Eh)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0907)
 00h	WORD	(call) size of following results buffer (max 65h)
 02h	BYTE	number of connections
 03h  N BYTEs	list of per-connection results
		00h successful
		FCh message rejected because queue is full (contains 6 msgs)
		FDh incomplete pipe
		FFh failed
--------N-21E1--SF05-------------------------
INT 21 O - Novell NetWare - MESSAGE SERVICES - GET PERSONAL MESSAGE
	AH = E1h subfn 05h
	DS:SI -> request buffer (see #0908)
	ES:DI -> reply buffer (see #0909)
Return: AL = status
	    00h successful
	    FEh out of dynamic workspace
Desc:	return the oldest message in the default file server's message queue
	  for the calling workstation
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0-2.x
SeeAlso: AH=E1h/SF=01h,AH=E1h/SF=04h,AH=E1h/SF=06h,AH=E1h/SF=08h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0908)
 00h	WORD	0001h (length of following data)
 02h	BYTE	05h (subfunction "Get Personal Message")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0909)
 00h	WORD	(call) size of following results buffer (max 80h)
 02h	BYTE	connection number of sending station
 03h	BYTE	length of message (00h-7Eh)
		00h if no personal messages pending
 04h  N BYTEs	message (no control characters or characters > 7Eh)
--------N-21E1--SF06-------------------------
INT 21 O - Novell NetWare - MESSAGE SERVICES - OPEN MESSAGE PIPE
	AH = E1h subfn 06h
	DS:SI -> request buffer (see #0910)
	ES:DI -> reply buffer (see #0911)
Return: AL = status
	    00h successful
	    FEh out of dynamic workspace
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0-2.x
SeeAlso: AH=E1h/SF=04h,AH=E1h/SF=07h,AH=E1h/SF=08h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0910)
 00h	WORD	length of following data (max 66h)
 02h	BYTE	06h (subfunction "Open Message Pipe")
 03h	BYTE	number of pipes to open (01h-64h)
 04h  N BYTEs	list of connection numbers

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0911)
 00h	WORD	(call) size of following results buffer (max 65h)
 02h	BYTE	number of connections
 03h  N BYTEs	list of results
		00h successful
		FEh incomplete (target half not yet created)
		FFh failed
--------N-21E1--SF07-------------------------
INT 21 O - Novell NetWare - MESSAGE SERVICES - CLOSE MESSAGE PIPE
	AH = E1h subfn 07h
	DS:SI -> request buffer (see #0912)
	ES:DI -> reply buffer (see #0913)
Return: AL = status
	    00h successful
	    FCh full message queue
	    FEh out of dynamic workspace
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0-2.x
SeeAlso: AH=E1h/SF=05h,AH=E1h/SF=06h,AH=E1h/SF=08h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0912)
 00h	WORD	length of following data (max 66h)
 02h	BYTE	07h (subfunction "Close Message Pipe")
 03h	BYTE	number of pipes to close (01h-64h)
 04h  N BYTEs	list of connection numbers

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0913)
 00h	WORD	(call) size of following results buffer (max 65h)
 02h	BYTE	number of connections
 03h  N BYTEs	list of results
		00h successful
		FDh failed
		FFh no such pipe
--------N-21E1--SF08-------------------------
INT 21 O - Novell NetWare - MESSAGE SERVICES - CHECK PIPE STATUS
	AH = E1h subfn 08h
	DS:SI -> request buffer (see #0915)
	ES:DI -> reply buffer (see #0916)
Return: AL = status (see #0914)
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0-2.x
SeeAlso: AH=E1h/SF=05h,AH=E1h/SF=06h,AH=E1h/SF=07h

(Table 0914)
Values for NetWare function status:
 00h	successful
 FCh	full message queue
 FEh	out of dynamic workspace

Format of NetWare request buffer:
Offset	Size	Description	(Table 0915)
 00h	WORD	length of following data (max 66h)
 02h	BYTE	08h (subfunction "Check Pipe Status")
 03h	BYTE	number of pipes to monitor (01h-64h)
 04h  N BYTEs	list of connection numbers

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0916)
 00h	WORD	(call) size of following results buffer (max 65h)
 02h	BYTE	number of connections
 03h  N BYTEs	list of pipe statuses
		00h open
		FEh incomplete
		FFh closed
--------N-21E1--SF09-------------------------
INT 21 - Novell NetWare - MESSAGE SERVICES - BROADCAST TO CONSOLE
	AH = E1h subfn 09h
	DS:SI -> request buffer (see #0917)
	ES:DI -> reply buffer (see #0918)
Return: AL = status (see #0914)
Desc:	send a one-line message to the system console on the default file
	  server
Note:	this function is supported by NetWare 4.0+ and Advanced NetWare 1.0+
SeeAlso: AH=DEh/DL=04h,AH=E1h/SF=00h,AH=E1h/SF=01h,AH=E3h/SF=D1h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0917)
 00h	WORD	length of following data (max 3Eh)
 02h	BYTE	09h (subfunction "Broadcast to Console")
 03h	BYTE	length of message (01h-3Ch)
 04h  N BYTEs	message (no control characters or characters > 7Eh)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0918)
 00h	WORD	(call) 0000h (no results returned)
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
	DS:SI -> request buffer (see #0920)
	ES:DI -> reply buffer (see #0921)
Return: AL = status (00h,98h,9Bh,9Ch) (see #0919)
Desc:	set the target handle to reference the directory specified by the
	  source handle and the source path; both handles must refer to the
	  same file server
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	the target handle is not changed if this function fails
SeeAlso: AH=E2h/SF=01h,AH=E2h/SF=12h,AH=E2h/SF=13h

(Table 0919)
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

Format of NetWare request buffer:
Offset	Size	Description	(Table 0920)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	00h (subfunction "Set Directory Handle")
 03h	BYTE	directory handle of target
 04h	BYTE	directory handle of source
 05h	BYTE	length of source directory path (01h-FFh)
 06h  N BYTEs	source directory path

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0921)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E2--SF01-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET DIRECTORY PATH
	AH = E2h subfn 01h
	DS:SI -> request buffer (see #0922)
	ES:DI -> reply buffer (see #0923)
Return: AL = status (00h,9Bh) (see #0919)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=02h,AH=E2h/SF=03h,AH=E2h/SF=1Ah,AH=E9h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0922)
 00h	WORD	0002h (length of following data)
 02h	BYTE	01h (subfunction "Get Directory Path")
 03h	BYTE	directory handle

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0923)
 00h	WORD	(call) length of following data buffer
 02h	BYTE	length of directory path (01h-FFh)
 03h  N BYTEs	full directory path including volume
--------N-21E2--SF02-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - SCAN DIRECTORY INFORMATION
	AH = E2h subfn 02h
	DS:SI -> request buffer (see #0924)
	ES:DI -> reply buffer (see #0925)
Return: AL = status (00h,98h,9Bh,9Ch) (see #0919)
Desc:	get information about the first or next subdirectory of the specified
	  directory
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=01h,AH=E2h/SF=03h,AH=E2h/SF=19h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0924)
 00h	WORD	length of following data (max 104h)
 02h	BYTE	02h (subfunction "Scan Directory Information")
 03h	BYTE	directory handle
 04h	WORD	(big-endian) subdirectory number
		0000h for first call, returned subdir number + 1 on next call
 06h	BYTE	length of directory path
 07h  N BYTEs	directory path

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0925)
 00h	WORD	(call) 001Ch (length of following data buffer)
 02h 16 BYTEs	subdirectory name
 12h	DWORD	(big-endian) date and time of creation (see #0926)
 16h	DWORD	(big-endian) object ID of owner
 1Ah	BYTE	maximum directory rights (see #0929)
 1Bh	BYTE	unused
 1Ch	WORD	(big-endian) subdirectory number

Bitfields for NetWare date and time:
Bit(s)	Description	(Table 0926)
 31-25	year-1980
 24-21	month
 20-16	day
 15-11	hour
 10-5	minute
 4-0	second
--------N-21E2--SF03-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET EFFECTIVE DIRECTORY RIGHTS
	AH = E2h subfn 03h
	DS:SI -> request buffer (see #0927)
	ES:DI -> reply buffer (see #0928)
Return: AL = status (00h,98h,9Bh) (see #0919)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=01h,AH=E2h/SF=02h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0927)
 00h	WORD	length of following data (max 102h)
 02h	BYTE	03h (subfunction "Get Effective Directory Rights")
 03h	BYTE	directory handle
 04h	BYTE	length of directory path (00h-FFh)
 05h  N BYTEs	directory path

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0928)
 00h	WORD	(call) 0001h (length of following data buffer)
 02h	BYTE	effective directory rights (see #0929)

Bitfields for NetWare directory rights:
Bit(s)	Description	(Table 0929)
 0	reading allowed
 1	writing allowed
 2	opens allowed
 3	file creation allowed
 4	deletion allowed
 5	"parental" may create/delete subdirectories and grant/revoke trustee
	  rights
 6	directory search allowed
 7	file attributes may be changed
--------N-21E2--SF04-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - MODIFY MAXIMUM RIGHTS MASK
	AH = E2h subfn 04h
	DS:SI -> request buffer (see #0930)
	ES:DI -> reply buffer (see #0931)
Return: AL = status (00h,8Ch,98h,9Ch) (see #0919)
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=03h,AH=E2h/SF=0Ah,AH=E2h/SF=0Dh

Format of NetWare request buffer:
Offset	Size	Description	(Table 0930)
 00h	WORD	length of following data (max 104h)
 02h	BYTE	04h (subfunction "Modify Maximum Rights Mask")
 03h	BYTE	directory handle
 04h	BYTE	rights to grant (see #0929)
 05h	BYTE	rights to revoke (see #0929)
 06h	BYTE	length of directory path (00h-FFh)
 07h  N BYTEs	directory path
Note:	the rights specified at offset 05h are revoked first, and then the
	  rights specified at offset 04h are added to the resulting rights
	  mask

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0931)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E2--SF05-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET VOLUME NUMBER
	AH = E2h subfn 05h
	DS:SI -> request buffer (see #0932)
	ES:DI -> reply buffer (see #0933)
Return: AL = status (00h,98h) (see #0919)
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=DAh,AH=E2h/SF=02h,AH=E2h/SF=05h,AH=E2h/SF=15h,AH=E3h/SF=E9h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0932)
 00h	WORD	length of following data (max 12h)
 02h	BYTE	05h (subfunction "Get Volume Number")
 03h	BYTE	length of volume name (01h-10h)
 04h  N BYTEs	volume name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0933)
 00h	WORD	(call) 0001h (length of following results buffer)
 02h	BYTE	volume number
--------N-21E2--SF06-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET VOLUME NAME
	AH = E2h subfn 06h
	DS:SI -> request buffer (see #0934)
	ES:DI -> reply buffer (see #0935)
Return: AL = status (00h,98h) (see #0919)
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=DAh,AH=E2h/SF=02h,AH=E2h/SF=05h,AH=E2h/SF=15h,AH=E2h/SF=1Ah
SeeAlso: AH=E3h/SF=E9h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0934)
 00h	WORD	0002h (length of following data)
 02h	BYTE	06h (subfunction "Get Volume Name")
 03h	BYTE	volume number

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0935)
 00h	WORD	(call) 0011h (length of following results buffer)
 02h	BYTE	length of volume name
 03h 16 BYTEs	NUL-padded volume name
--------N-21E2--SF0A-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - CREATE DIRECTORY
	AH = E2h subfn 0Ah
	DS:SI -> request buffer (see #0936)
	ES:DI -> reply buffer (see #0937)
Return: AL = status (00h,84h,98h,FCh) (see #0919)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=39h,AH=E2h/SF=0Bh,AH=E2h/SF=0Fh

Format of NetWare request buffer:
Offset	Size	Description	(Table 0936)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	0Ah (subfunction "Create Directory")
 03h	BYTE	directory handle
 04h	BYTE	maximum directory rights (see #0929)
 05h	BYTE	length of directory path (00h-FFh)
 06h  N BYTEs	directory path

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0937)
 00h	WORD	(call) 0000h (no data returned)
--------N-21E2--SF0B-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - DELETE DIRECTORY
	AH = E2h subfn 0Bh
	DS:SI -> request buffer (see #0938)
	ES:DI -> reply buffer (see #0937)
Return: AL = status (00h,8Ah,98h,9Bh,9Ch,9Fh,A0h) (see #0919)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=3Ah,AH=E2h/SF=0Ah,AH=E2h/SF=0Fh

Format of NetWare request buffer:
Offset	Size	Description	(Table 0938)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	0Bh (subfunction "Delete Directory")
 03h	BYTE	directory handle
 04h	BYTE	unused
 05h	BYTE	length of directory path (00h-FFh)
 06h  N BYTEs	directory path
--------N-21E2--SF0C-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - SCAN DIRECTORY FOR TRUSTEES
	AH = E2h subfn 0Ch
	DS:SI -> request buffer (see #0939)
	ES:DI -> reply buffer (see #0940)
Return: AL = status (00h,9Ch) (see also #0919)
	    9Ch no more trustees
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E2h/SF=0Dh,AH=E2h/SF=0Eh,AH=E3h/SF=47h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0939)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	0Ch (subfunction "Scan Directory For Trustees")
 03h	BYTE	directory handle
 04h	BYTE	sequence number
		00h on first call, increment for each subsequent call
 05h	BYTE	length of directory path (00h-FFh)
 06h  N BYTEs	directory path

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0940)
 00h	WORD	(call) 0031h (length of following results buffer)
 02h 16 BYTEs	directory name
 12h  4 BYTEs	date and time of creation
 16h	DWORD	(big-endian) object ID of owner
 1Ah  5 DWORDs	(big-endian) object IDs of Trustees 0 through 4
		00000000h = end of group
 2Eh  5 BYTEs	directory rights for Trustees 0 through 4 (see #0929)
--------N-21E2--SF0D-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - ADD TRUSTEE TO DIRECTORY
	AH = E2h subfn 0Dh
	DS:SI -> request buffer (see #0941)
	ES:DI -> reply buffer (see #0943)
Return: AL = status (00h,8Ch,FCh) (see #0919)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=0Ch,AH=E2h/SF=0Eh,AH=E3h/SF=47h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0941)
 00h	WORD	length of following data (max 107h)
 02h	BYTE	0Dh (subfunction "Add Trustee To Directory")
 03h	BYTE	directory handle
 04h	DWORD	(big-endian) object ID of trustee
 08h	BYTE	trustee directory rights (see #0929)
 09h	BYTE	length of directory path (00h-FFh)
 0Ah  N BYTEs	directory path
--------N-21E2--SF0E-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - DELETE TRUSTEE FROM DIRECTORY
	AH = E2h subfn 0Eh
	DS:SI -> request buffer (see #0942)
	ES:DI -> reply buffer (see #0943)
Return: AL = status (00h,98h,9Bh,9Ch) (see #0919)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=0Ch,AH=E2h/SF=0Dh

Format of NetWare request buffer:
Offset	Size	Description	(Table 0942)
 00h	WORD	length of following data (max 107h)
 02h	BYTE	0Eh (subfunction "Delete Trustee From Directory")
 03h	BYTE	directory handle
 04h	DWORD	(big-endian) object ID of trustee
 08h	BYTE	unused
 09h	BYTE	length of directory path (00h-FFh)
 0Ah  N BYTEs	directory path

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0943)
 00h	WORD	(call) 0000h (no data returned)
--------N-21E2--SF0F-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - RENAME DIRECTORY
	AH = E2h subfn 0Fh
	DS:SI -> request buffer (see #0944)
	ES:DI -> reply buffer (see #0943)
Return: AL = status (00h,8Bh,9Bh,9Ch,9Eh) (see #0919)
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	directories SYS:LOGIN, SYS:MAIL, and SYS:PUBLIC must not be renamed
SeeAlso: AH=56h,AH=E2h/SF=0Ah,AH=E2h/SF=0Bh

Format of NetWare request buffer:
Offset	Size	Description	(Table 0944)
 00h	WORD	length of following data (max 111h)
 02h	BYTE	0Fh (subfunction "Rename Directory")
 03h	BYTE	directory handle
 04h	BYTE	length of directory path (00h-FFh)
 05h  N BYTEs	directory path
	BYTE	length of new directory name (01h-0Eh)
      N BYTEs	new directory name
--------N-21E2--SF10-------------------------
INT 21 - Novell NetWare - FILE SERVICES - PURGE ERASED FILES
	AH = E2h subfn 10h
	DS:SI -> request buffer (see #0945)
	ES:DI -> reply buffer (see #0943)
Return: AL = status (00h,C6h) (see #0946)
Desc:	purges files marked for deletion on the file server by the calling
	  workstation
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=13h,AH=41h,AH=E2h/SF=11h,AH=E3h/SF=CEh,AX=F244h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0945)
 00h	WORD	0001h (length of following data)
 02h	BYTE	10h (subfunction "Purge Erased Files")
--------N-21E2--SF11-------------------------
INT 21 - Novell NetWare - FILE SERVICES - RESTORE ERASED FILE
	AH = E2h subfn 11h
	DS:SI -> request buffer (see #0947)
	ES:DI -> reply buffer (see #0948)
Return: AL = status (00h,98h,FFh) (see #0946)
Desc:	restores one file marked for deletion which has not yet been purged
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=13h,AH=41h,AH=E2h/SF=10h,AH=E3h/SF=CEh,AX=F244h

(Table 0946)
Values for NetWare function status:
 00h	successful
 98h	nonexistent volume
 9Ch	invalid path
 C6h	no console rights
 FFh	no more erased files

Format of NetWare request buffer:
Offset	Size	Description	(Table 0947)
 00h	WORD	length of following data (max 13h)
 02h	BYTE	11h (subfunction "Restore Erased File")
 03h	BYTE	directory handle or 00h
 04h	BYTE	length of volume name
 05h  N BYTEs	volume name (including colon)
Note:	if both a directory handle and a volume name are specified, the volume
	  name overrides the handle

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0948)
 00h	WORD	(call) 001Eh (size of following results buffer)
 02h 15 BYTEs	ASCIZ name of erased file
 11h 15 BYTEs	ASCIZ name under which file was restored
--------N-21E2--SF12-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - ALLOC PERMANENT DIRECTORY HANDLE
	AH = E2h subfn 12h
	DS:SI -> request buffer (see #0949)
	ES:DI -> reply buffer (see #0950)
Return: AL = status (00h,98h,9Ch) (see #0946)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=00h,AH=E2h/SF=13h,AH=E2h/SF=14h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0949)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	12h (subfunction "Alloc Permanent Directory Handle")
 03h	BYTE	directory handle
 04h	BYTE	drive ('A'-'Z')
 05h	BYTE	length of directory path
 06h  N BYTEs	directory path

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0950)
 00h	WORD	(call) 0002h (size of following results buffer)
 02h	BYTE	new directory handle
 03h	BYTE	effective directory rights (see #0929)
--------N-21E2--SF13-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - ALLOC TEMPORARY DIRECTORY HANDLE
	AH = E2h subfn 13h
	DS:SI -> request buffer (see #0951)
	ES:DI -> reply buffer (see #0953)
Return: AL = status (00h,98h,9Ch) (see #0946)
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	this call is the same as AH=E2h/SF=12h except that the directory handle
	  will be automatically deallocated when the calling application
	  executes an End of Job call (AH=D6h) or terminates
SeeAlso: AH=D6h,AH=E2h/SF=00h,AH=E2h/SF=12h,AH=E2h/SF=14h,AH=E2h/SF=16h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0951)
 00h	WORD	length of following data (max 103h)
 02h	BYTE	13h (subfunction "Alloc Temporary Directory Handle")
 03h	BYTE	directory handle
 04h	BYTE	drive ('A'-'Z')
 05h	BYTE	length of directory path
 06h  N BYTEs	directory path
--------N-21E2--SF14-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - DEALLOCATE DIRECTORY HANDLE
	AH = E2h subfn 14h
	DS:SI -> request buffer (see #0952)
	ES:DI -> reply buffer (see #0953)
Return: AL = status (00h,9Bh) (see #0919)
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=12h,AH=E2h/SF=13h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0952)
 00h	WORD	0002h (length of following data)
 02h	BYTE	14h (subfunction "Deallocate Directory Handle")
 03h	BYTE	directory handle

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0953)
 00h	WORD	(call) 0000h (no returned data)
--------N-21E2--SF15-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET VOLUME INFO WITH HANDLE
	AH = E2h subfn 15h
	DS:SI -> request buffer (see #0954)
	ES:DI -> reply buffer (see #0955)
Return: AL = status
	    00h successful
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=DAh,AH=E2h/SF=02h,AH=E2h/SF=06h,AH=E2h/SF=19h,AH=E3h/SF=E9h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0954)
 00h	WORD	0002h (length of following data)
 02h	BYTE	15h (subfunction "Get Volume Info With Handle")
 03h	BYTE	directory handle

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0955)
 00h	WORD	(call) 001Ch (length of following results buffer)
 02h	WORD	(big-endian) sectors per block
 04h	WORD	(big-endian) total blocks on volume
 06h	WORD	(big-endian) blocks available on volume
 08h	WORD	(big-endian) total directory slots
 0Ah	WORD	(big-endian) directory slots available
 0Ch 16 BYTEs	NUL-padded volume name
 1Ch	WORD	(big-endian) flag: volume removable if nonzero
--------N-21E2--SF16-------------------------
INT 21 u - Novell NetWare - DIRECTORY SERVICES - ALLOC SPECIAL TEMP DIR HANDLE
	AH = E2h subfn 16h
	DS:SI -> request buffer (see #0956)
	ES:DI -> reply buffer
Return: AL = status
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX,
	  but is not described in _NetWare_System_Calls--DOS_
SeeAlso: AH=E2h/SF=13h,AH=E2h/SF=14h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0956)
 00h	WORD	length of following data
 02h	BYTE	16h (subfunction "Allocate Special Temporary Directory Handle")
	???
--------N-21E2--SF17-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - SAVE DIRECTORY HANDLE
	AH = E2h subfn 17h
	DS:SI -> request buffer (see #0957)
	ES:DI -> reply buffer (see #0958)
Return: AL = status
	    00h successful
	    else network error code
Note:	this function is supported by Advanced NetWare 2.0+ and Alloy NTNX
SeeAlso: AH=E2h/SF=12h,AH=E2h/SF=17h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0957)
 00h	WORD	0002h (length of following data)
 02h	BYTE	18h (subfunction "Restore Directory Handle")
 03h	BYTE	directory handle

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0958)
 00h	WORD	(call) 0010h (length of following results buffer)
 02h 16 BYTEs	save buffer
--------N-21E2--SF18-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - RESTORE DIRECTORY HANDLE
	AH = E2h subfn 18h
	DS:SI -> request buffer (see #0959)
	ES:DI -> reply buffer (see #0960)
Return: AL = status
	    00h successful
	    else network error code
Desc:	restore a previously saved directory handle to reproduce an executing
	  environment, possibly on a different execution site
Note:	this function is supported by Advanced NetWare 2.0+ and Alloy NTNX
SeeAlso: AH=E2h/SF=12h,AH=E2h/SF=17h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0959)
 00h	WORD	0011h (length of following data)
 02h	BYTE	18h (subfunction "Restore Directory Handle")
 03h 16 BYTEs	save buffer

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0960)
 00h	WORD	(call) 0002h (length of following results buffer)
 02h	BYTE	new directory handle
 03h	BYTE	effective rights (see #0929)
--------N-21E2--SF19-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - SET DIRECTORY INFORMATION
	AH = E2h subfn 19h
	DS:SI -> request buffer (see #0961)
	ES:DI -> reply buffer (see #0962)
Return: AL = status (00h,9Bh,9Ch) (see #0919)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E2h/SF=02h,AH=E2h/SF=0Fh

Format of NetWare request buffer:
Offset	Size	Description	(Table 0961)
 00h	WORD	length of following data (max 10Bh)
 02h	BYTE	19h (subfunction "Set Directory Information")
 03h	BYTE	directory handle
 04h	DWORD	(big-endian) date and time of creation
 08h	DWORD	(big-endian) object ID of owner
 0Ch	BYTE	maximum directory rights (see #0929)
 0Dh	BYTE	length of directory path
 0Eh  N BYTEs	directory path

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0962)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E2--SF1A-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET PATH FROM DIRECTORY ENTRY
	AH = E2h subfn 1Ah
	DS:SI -> request buffer (see #0963)
	ES:DI -> reply buffer (see #0964)
Return: AL = status
	    00h successful
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=01h,AH=E2h/SF=06h,AH=E3h/SF=D7h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0963)
 00h	WORD	0004h (length of following data)
 02h	BYTE	1Ah (subfunction "Get Path From Directory Entry")
 03h	BYTE	volume number (00h-1Fh)
 04h	WORD	(big-endian) directory entry number

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0964)
 00h	WORD	(call) size of following results record (max 200h)
 02h 256 BYTEs	path
--------E-21E3-------------------------------
INT 21 - OS/286, OS/386 - ISSUE REAL INTERRUPT
	AH = E3h
	AL = interrupt number
	???
Return: ???
Note:	protected mode only???
SeeAlso: AH=E1h"OS/286",INT 31/AX=0300h
--------T-21E3-------------------------------
INT 21 - DoubleDOS - ADD CHARACTER TO KEYBOARD BUFFER OF CURRENT JOB
	AH = E3h
	AL = character
Return: AL = status
	    00h successful
	    01h buffer full (128 characters)
SeeAlso: AH=E1h"DoubleDOS",AH=E2h"DoubleDOS",AH=E8h"DoubleDOS"
SeeAlso: AH=F3h"DoubleDOS"
--------N-21E3-------------------------------
INT 21 - Novell NetWare - CONNECTION CONTROL
	AH = E3h
	DS:SI -> request buffer (see #0965)
	ES:DI -> reply buffer (see #0966)
Return: AL = status
	    00h successful
	    else error code
Note:	supported by NetWare 4.0+, Advanced NetWare 1.0+, and Alloy NTNX
SeeAlso: AH=E3h/SF=0Ah,AH=E3h/SF=32h,AH=E3h/SF=64h,AH=E3h/SF=C8h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0965)
 00h	WORD	length of following data
 02h	BYTE	subfunction number
		00h login
		01h change password
		02h map user to station set
		03h map object to number
		04h map number to object
		05h get station's logged information
		06h get station's root mask (obsolete)
		07h map group name to number
		08h map number to group name
		09h get memberset M of group G
	var	depends on subfunction
Notes:	the above subfunctions are not described in _NetWare_System_Calls--DOS_
	see separate entries below for other subfunctions

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0966)
 00h	WORD	(call) length of following buffer space for results
	var	depends on subfunction

Format of NetWare object property:
Offset	Size	Description	(Table 0967)
 00h 1-16 BYTEs property name (see also #0968)
  N	BYTE	flags
		bit 0: property is dynamic
		bit 1: property is a set rather than an item
 N+1	BYTE	security levels (see #0969)
	???

(Table 0968)
Values for names of well-known NetWare properties:
 ACCOUNT_BALANCE
 ACCOUNT_SERVERS
 GROUP_MEMBERS
 GROUPS_I'M_IN
 IDENTIFICATION		user's name
 LOGIN_CONTROL
 NET_ADDRESS
 OPERATORS
 PASSWORD
 SECURITY_EQUALS

(Table 0969)
Values for NetWare security levels:
 00h	"anyone" everyone may access
 01h	"logged" only logged-in clients may access
 02h	"object" only clients logged-in with object's name, type, and password
 03h	"supervisor" only clients logged-in with supervisor privileges
 04h	"NetWare" only NetWare may access
Note:	the above values are stored in a nybble; the high half-byte is write
	  access and the low half-byte is read access

(Table 0970)
Values for NetWare object type:
 0000h	unknown
 0001h	user
 0002h	user group
 0003h	print queue
 0004h	file server
 0005h	job server
 0006h	gateway
 0007h	print server
 0008h	archive queue
 0009h	archive server
 000Ah	job queue
 000Bh	administration
 0026h	remote bridge server
 0047h	advertising print server
 0048h-8000h reserved
 FFFFh	wild (used only for finding objects)
--------N-21E3--SF0A-------------------------
INT 21 - Novell NetWare - CONNECTION SERVICES - ENTER LOGIN AREA
	AH = E3h subfn 0Ah
	DS:SI -> request buffer (see #0971)
	ES:DI -> reply buffer (see #0972)
Return: AL = status
	    00h successful
Desc:	change the login directory for the calling workstation
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=D7h,AH=E3h/SF=14h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0971)
 00h	WORD	length of following data (max 102h)
 02h	BYTE	0Ah (subfunction "Enter Login Area")
 03h	BYTE	number of local drives
 04h	BYTE	length of subdirectory name (00h-FFh)
 05h  N BYTEs	name of subdirectory under SYS:LOGIN where to find the login
		  utility

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0972)
 00h	WORD	(call) 0000h (no data returned)
--------N-21E3--SF0C-------------------------
INT 21 U - Novell NetWare - VERIFY NETWORK SERIAL NUMBER
	AH = E3h subfn 0Ch
	DS:SI -> request buffer (see #0973)
	ES:DI -> reply buffer (see #0974)
Return: AL = status
	    00h successful
Note:	if the network serial number to be verified is correct, the reply
	  buffer will contain the corresponding application number
SeeAlso: AH=E3h/SF=12h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0973)
 00h	WORD	0005h (length of following data)
 02h	BYTE	0Ch (subfunction "Verify Network Serial Number")
 03h	DWORD	(big-endian) network serial number to verify

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0974)
 00h	WORD	(call) 0002h (size of following results buffer)
 02h	WORD	(big-endian) application number
--------N-21E3--SF0D-------------------------
INT 21 - Novell NetWare - MESSAGE SERVICES - LOG NETWORK MESSAGE
	AH = E3h subfn 0Dh
	DS:SI -> request buffer (see #0975)
	ES:DI -> reply buffer (see below)
Return: AL = status
	    00h successful
Desc:	append a line to the default file server's NET$LOG.MSG file
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E1h/SF=09h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0975)
 00h	WORD	length of following data (max 52h)
 02h	BYTE	0Dh (subfunction "Log Network Message")
 03h	BYTE	length of message (01h-50h)
 04h  N BYTEs	message (no control characters or characters > 7Eh)
--------N-21E3--SF0E-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET DISK UTILIZATION
	AH = E3h subfn 0Eh
	DS:SI -> request buffer (see #0977)
	ES:DI -> reply buffer (see #0978)
Return: AL = status (00h,98h,F2h) (see #0976)
Notes:	this function is supported by Advanced NetWare 2.1+
	the caller must have bindery object read privileges
SeeAlso: AH=E3h/SF=11h,AH=E3h/SF=D6h,AH=E3h/SF=D9h,AH=E3h/SF=E6h,AH=E3h/SF=E9h

(Table 0976)
Values for NetWare function status:
 00h	successful
 98h	nonexistent volume
 F2h	not permitted to read object

Format of NetWare request buffer:
Offset	Size	Description	(Table 0977)
 00h	WORD	0005h (length of following data)
 02h	BYTE	0Eh (subfunction "Get Disk Utilization")
 03h	BYTE	volume number (00h-1Fh)
 04h	DWORD	(big-endian) object ID

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0978)
 00h	WORD	(call) 000Bh (size of following results buffer)
 02h	BYTE	volume number (00h-1Fh)
 03h	DWORD	(big-endian) object ID
 07h	WORD	(big-endian) directories used by object
 09h	WORD	(big-endian) files created by object
 0Bh	WORD	(big-endian) disk blocks used by object-created files
--------N-21E3--SF0F-------------------------
INT 21 - Novell NetWare - FILE SERVICES - SCAN FILE INFORMATION
	AH = E3h subfn 0Fh
	DS:SI -> request buffer (see #0980)
	ES:DI -> reply buffer (see #0981)
Return: AL = status (see #0979)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=B6h,AH=E3h/SF=10h

(Table 0979)
Values for NetWare function status:
 00h	successful
 89h	not permitted to search directory
 FFh	no more matching files

Format of NetWare request buffer:
Offset	Size	Description	(Table 0980)
 00h	WORD	length of following data (max 105h)
 02h	BYTE	0Fh (subfunction "Scan File Information")
 03h	WORD	(big-endian) sequence number
		FFFFh on first call
 05h	BYTE	directory handle or 00h
 06h	BYTE	search attributes (see #0554 at AX=4301h)
 07h	BYTE	length of filespec
 08h  N BYTEs	ASCIZ uppercase filespec

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0981)
 00h	WORD	(call) 005Eh (size of following results buffer)
 02h	WORD	next sequence number (place in request buffer for next call)
 04h 14 BYTEs	ASCIZ filename
 12h	BYTE	file attributes (see #0554 at AX=4301h)
 13h	BYTE	extended file attributes (see #0885 at AH=B6h)
 14h	DWORD	(big-endian) file size in bytes
 18h	WORD	(big-endian) file's creation date (see #0781 at AX=5700h)
 1Ah	WORD	(big-endian) date of last access (see #0780 at AX=5700h)
 1Ch	DWORD	(big-endian) date and time of last update (see #0926)
 20h	DWORD	(big-endian) object ID of owner
 24h	DWORD	(big-endian) date and time last archived (see #0926)
 28h 55 BYTEs	reserved
Note:	the official documentation erroneously lists the field at offset 04h as
	  15 bytes and thus shifts the remaining fields by one byte
--------N-21E3--SF10-------------------------
INT 21 - Novell NetWare - FILE SERVICES - SET FILE INFORMATION
	AH = E3h subfn 10h
	DS:SI -> request buffer (see #0982)
	ES:DI -> reply buffer (see #0983)
Return: AL = status
	    00h successful
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
	the caller must have modify privileges on the directory containing the
	  file
SeeAlso: AH=B6h,AH=E3h/SF=0Fh

Format of NetWare request buffer:
Offset	Size	Description	(Table 0982)
 00h	WORD	length of following data (max 151h)
 02h	BYTE	10h (subfunction "Set File Information")
 03h	BYTE	file attributes (see #0554 at AX=4301h)
 04h	BYTE	extended file attributes (see #0885 at AH=B6h)
 05h  4 BYTEs	reserved
 09h	WORD	(big-endian) file's creation date (see #0781 at AX=5700h)
 0Bh	WORD	(big-endian) date of last access (see #0780 at AX=5700h)
 0Dh	DWORD	(big-endian) date and time of last update (see #0926)
 11h	DWORD	(big-endian) object ID of owner
 15h	DWORD	(big-endian) date and time last archived (see #0926)
 19h 56 BYTEs	reserved
 51h	BYTE	directory handle or 00h
 52h	BYTE	search attributes (see #0554 at AX=4301h)
 53h	BYTE	length of filename
 54h  N BYTEs	filename

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0983)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E3--SF11-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET FILE SERVER INFORMATION
	AH = E3h subfn 11h
	DS:SI -> request buffer (see #0984)
	ES:DI -> reply buffer (see #0985)
Return: AL = status
	    00h successful
Desc:	determine the version of software installed on the file server and
	  how it is configured
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AH=E3h/SF=0Eh,AE3h/SF=12h,AH=E3h/SF=CDh,AH=E3h/SF=D3h,AH=E3h/SF=E7h
SeeAlso: AH=E7h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0984)
 00h	WORD	0001h (length of following data)
 02h	BYTE	11h (subfunction "Get File Server Information")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0985)
 00h	WORD	(call) 0080h (size of following results buffer)
 02h 48 BYTEs	server's name
 32h	BYTE	NetWare version
 33h	BYTE	NetWare subversion (0-99)
 34h	WORD	(big-endian) number of connections supported
 36h	WORD	(big-endian) number of connections in use
 38h	WORD	(big-endian) maximum connected volumes
---Advanced NetWare 2.1+ ---
 3Ah	BYTE	operating system revision number
 3Bh	BYTE	fault tolerance (SFT) level
 3Ch	BYTE	TTS level
 3Dh	WORD	(big-endian) maximum simultaneously-used connections
 3Fh	BYTE	accounting version
 40h	BYTE	VAP version
 41h	BYTE	queueing version
 42h	BYTE	print server version
 43h	BYTE	virtual console version
 44h	BYTE	security restrictions level
 45h	BYTE	internetwork bridge version
 46h 60 BYTEs	reserved
--------N-21E3--SF12-------------------------
INT 21 - Novell NetWare - GET NETWORK SERIAL NUMBER
	AH = E3h subfn 12h
	AL = 00h
	BX = CX = DX = 0000h
	DS:SI -> request buffer (see #0986)
	ES:DI -> reply buffer (see #0987)
Return: AL = status
	    00h successful
Desc:	return the serial number and application number for the software
	  installed on the file server
Notes:	this function is supported by Advanced NetWare 2.1+
	reportedly, the workstation crashes if AL,BX,CX, and DX are not all
	  zero
SeeAlso: AH=E3h/SF=0Ch,AH=E3h/SF=11h

Format of NetWare request buffer:
offset	 size	description	(Table 0986)
 00h	 WORD	0001h (length of following data)
 02h	 BYTE	12h (subfunction "Get Serial Number")

Format of NetWare reply buffer:
offset	 size	description	(Table 0987)
 00h	 WORD	(call) 0006h (size of following results buffer)
 02h   4 BYTEs	(big-endian) NetWare server serial number
 06h   2 BYTEs	(big-endian) NetWare application serial number
--------N-21E3--SF13-------------------------
INT 21 - Novell NetWare - CONNECTION SERVICES - GET INTERNET ADDRESS
	AH = E3h subfn 13h
	DS:SI -> request buffer (see #0988)
	ES:DI -> reply buffer (see #0989)
Return: AL = status
	    00h successful
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=DCh"NetWare",AH=E3h/SF=16h,AH=EEh"NetWare"

Format of NetWare request buffer:
Offset	Size	Description	(Table 0988)
 00h	WORD	0002h (length of following data)
 02h	BYTE	13h (subfunction "Get Internet Address")
 03h	BYTE	logical connection number (01h-64h)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0989)
 00h	WORD	(call) 000Ch (length of following results buffer)
 02h  4 BYTEs	network number
 06h  6 BYTEs	physical node address
 0Ch  2 BYTEs	socket number
--------N-21E3--SF14-------------------------
INT 21 - Novell NetWare - CONNECTION SERVICES - LOGIN TO FILE SERVER
	AH = E3h subfn 14h
	DS:SI -> request buffer (see #0990)
	ES:DI -> reply buffer (see #0991)
Return: AL = status
	    00h successful
Desc:	this function retrieves a list indicating the connection numbers under
	  which a bindery object is logged into the default file server
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=D7h"NetWare",AH=F1h"NetWare"

Format of NetWare request buffer:
Offset	Size	Description	(Table 0990)
 00h	WORD	length of following data (max B3h)
 02h	BYTE	14h (subfunction "Login To File Server")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object's name
	BYTE	length of password
      N BYTEs	password

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0991)
 00h	WORD	(call) 0000h (no data returned)
--------N-21E3--SF15-------------------------
INT 21 - Novell NetWare - CONNECTION SERVICES - GET OBJECT CONNECTION NUMBERS
	AH = E3h subfn 15h
	DS:SI -> request buffer (see #0992)
	ES:DI -> reply buffer (see #0993)
Return: AL = status
	    00h successful
Desc:	this function retrieves a list indicating the connection numbers under
	  which a bindery object is logged into the default file server
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=DCh"NetWare",AH=E3h/SF=16h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0992)
 00h	WORD	length of following data (max 33h)
 02h	BYTE	15h (subfunction "Get Object Connection Numbers")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object's name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0993)
 00h	WORD	(call) length of following results buffer (max 65h)
 02h	BYTE	number of connections
 03h  N BYTEs	connection list
--------N-21E3--SF16-------------------------
INT 21 - Novell NetWare - CONNECTION SERVICES - GET CONNECTION INFORMATION
	AH = E3h subfn 16h
	DS:SI -> request buffer (see #0994)
	ES:DI -> reply buffer (see #0995)
Return: AL = status
	    00h successful
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=D7h,AH=DCh"NetWare",AH=E3h/SF=14h

Format of NetWare request buffer:
Offset	Size	Description	(Table 0994)
 00h	WORD	0002h (length of following data)
 02h	BYTE	16h (subfunction "Get Connection Information")
 03h	BYTE	logical connection number (01h-64h)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0995)
 00h	WORD	(call) 003Eh (length of following results buffer)
 02h	DWORD	(big-endian) object ID for object logged in on the connection
		00000000h if no object logged in
 06h	WORD	(big-endian) type of object
 08h 48 BYTEs	name of object
 38h  7 BYTEs	login time (see #0996)
Note:	much of the Novell documentation incorrectly states the reply buffer
	  length as 3Fh instead of 40h, which corresponds to a results length
	  of 3Dh (61) bytes instead of the correct 3Eh (62) bytes

Format of NetWare login time:
Offset	Size	Description	(Table 0996)
 00h	BYTE	year (80-99 = 1980-1999, 00-79 = 2000-2079)
 01h	BYTE	month (1-12)
 02h	BYTE	day (1-31)
 03h	BYTE	hour (0-23)
 04h	BYTE	minute (0-59)
 05h	BYTE	second (0-59)
 06h	BYTE	day of week (0 = Sunday)
--------N-21E3--SF32-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - CREATE BINDERY OBJECT
	AH = E3h subfn 32h
	DS:SI -> request buffer (see #0998)
	ES:DI -> reply buffer (see #0999)
Return: AL = status (see #0997)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=33h,AH=E3h/SF=34h,AH=E3h/SF=38h,AH=E3h/SF=39h

(Table 0997)
Values for NetWare function status:
 00h	successful
 96h	server out of memory
 EEh	object already exists
 EFh	invalid name
 F0h	wildcard not allowed
 F1h	invalid bindery security level
 F3h	not permitted to rename object
 F4h	not permitted to delete objects
 F5h	not permitted to create objects
 FCh	no such object
 FEh	server bindery locked
 FFh	bindery failure

Format of NetWare request buffer:
Offset	Size	Description	(Table 0998)
 00h	WORD	length of following data (max 35h)
 02h	BYTE	32h (subfunction "Create Bindery Object")
 03h	BYTE	object flag (00h static, 01h dynamic)
 04h	BYTE	object security levels
 05h	WORD	(big-endian) type of object
 07h	BYTE	length of object's name
 08h  N BYTEs	object's name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 0999)
 00h	WORD	0000h (no data returned)
--------N-21E3--SF33-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - DELETE BINDERY OBJECT
	AH = E3h subfn 33h
	DS:SI -> request buffer (see #1000)
	ES:DI -> reply buffer (see #0999)
Return: AL = status (see #0997)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=32h,AH=E3h/SF=34h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1000)
 00h	WORD	length of following data (max 33h)
 02h	BYTE	33h (subfunction "Delete Bindery Object")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object's name
--------N-21E3--SF34-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - RENAME BINDERY OBJECT
	AH = E3h subfn 34h
	DS:SI -> request buffer (see #1001)
	ES:DI -> reply buffer (see #0999)
Return: AL = status (see #0997)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=32h,AH=E3h/SF=33h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1001)
 00h	WORD	length of following data (max 63h)
 02h	BYTE	34h (subfunction "Rename Bindery Object")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object's name
	BYTE	length of new name (01h-2Fh)
      N BYTEs	new name
--------N-21E3--SF35-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - GET BINDERY OBJECT ID
	AH = E3h subfn 35h
	DS:SI -> request buffer (see #1002)
	ES:DI -> reply buffer (see #1003)
Return: AL = status (00h,96h,FCh,FEh,FFh) (see #1004)
Notes:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
	the requesting workstation must be logged into the file server with
	  read access to the bindery object
SeeAlso: AH=E3h/SF=36h,AH=E3h/SF=44h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1002)
 00h	WORD	length of following data (max 33h)
 02h	BYTE	35h (subfunction "Get Bindery Object ID")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name
 06h  N BYTEs	object's name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1003)
 00h	WORD	(call) 0036h (length of following buffer space)
 02h	DWORD	(big-endian) object ID
 06h	WORD	(big-endian) type of object
 08h 48 BYTEs	object name
--------N-21E3--SF36-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - GET BINDERY OBJECT NAME
	AH = E3h subfn 36h
	DS:SI -> request buffer (see #1005)
	ES:DI -> reply buffer (see #1006)
Return: AL = status (see #1004)
Notes:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
	the requesting workstation must be logged into the file server with
	  read access to the bindery object
SeeAlso: AH=E3h/SF=35h,AH=E3h/SF=44h

(Table 1004)
Values for NetWare function status:
 00h	successful
 96h	server out of memory
 EFh	invalid name
 F0h	wildcard not allowed
 FCh	no such object
 FEh	server bindery locked
 FFh	bindery failure

Format of NetWare request buffer:
Offset	Size	Description	(Table 1005)
 00h	WORD	0005h (length of following data)
 02h	BYTE	36h (subfunction "Get Bindery Object Name")
 03h	DWORD	(big-endian) object ID

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1006)
 00h	WORD	(call) 0036h (length of following buffer space)
 02h	DWORD	(big-endian) object ID
 06h	WORD	(big-endian) type of object
 08h 48 BYTEs	object name
--------N-21E3--SF37-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - SCAN BINDERY OBJECT
	AH = E3h subfn 37h
	DS:SI -> request buffer (see #1007)
	ES:DI -> reply buffer (see #1008)
Return: AL = status (see #1004)
Notes:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
	the requesting workstation must be logged into the file server with
	  read access to the bindery object
SeeAlso: AH=E3h/SF=32h,AH=E3h/SF=33h,AH=E3h/SF=38h,AH=E3h/SF=3Ch

Format of NetWare request buffer:
Offset	Size	Description	(Table 1007)
 00h	WORD	length of following data (max 37h)
 02h	BYTE	37h (subfunction "Scan Bindery Object")
 03h	DWORD	(big-endian) last object ID
 07h	WORD	(big-endian) type of object
 09h	BYTE	length of object's name
 0Ah  N BYTEs	object's name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1008)
 00h	WORD	(call) 0039h (length of following buffer space)
 02h	DWORD	(big-endian) object ID
		FFFFFFFFh for first call
 06h	WORD	(big-endian) type of object
 08h 48 BYTEs	object name (counted string)
 38h	BYTE	object flag (00h static, 01h dynamic)
 39h	BYTE	object's security levels
 3Ah	BYTE	object properties flag (00h no, FFh yes)
--------N-21E3--SF38-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - CHANGE BINDERY OBJECT SECURITY
	AH = E3h subfn 38h
	DS:SI -> request buffer (see #1009)
	ES:DI -> reply buffer (see #1012)
Return: AL = status (00h,96h,F0h,F1h,FBh,FCh,FEh,FFh) (see #1010)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=32h,AH=E3h/SF=3Bh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1009)
 00h	WORD	length of following data (max 34h)
 02h	BYTE	38h (subfunction "Change Bindery Object Security")
 03h	BYTE	new security levels
 04h	WORD	(big-endian) type of object
 06h	BYTE	length of object's name (01h-2Fh)
 07h  N BYTEs	object name
--------N-21E3--SF39-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - CREATE PROPERTY
	AH = E3h subfn 39h
	DS:SI -> request buffer (see #1011)
	ES:DI -> reply buffer (see #1012)
Return: AL = status (see #1010)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=32h,AH=E3h/SF=3Bh

(Table 1010)
Values for NetWare function status:
 00h	successful
 96h	server out of memory
 EDh	property already exists
 EFh	invalid name
 F0h	wildcard not allowed
 F1h	invalid bindery security level
 F6h	not permitted to delete properties
 F7h	not permitted to create properties
 FBh	no such property
 FCh	no such object
 FEh	server bindery locked
 FFh	bindery failure

Format of NetWare request buffer:
Offset	Size	Description	(Table 1011)
 00h	WORD	length of following data (max 45h)
 02h	BYTE	39h (subfunction "Create Property")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object's name
	BYTE	property flags
	BYTE	property security levels
	BYTE	length of property's name (01h-0Fh)
      N BYTEs	property's name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1012)
 00h	WORD	(call) 0000h (no data returned)
--------N-21E3--SF3A-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - DELETE PROPERTY
	AH = E3h subfn 3Ah
	DS:SI -> request buffer (see #1013)
	ES:DI -> reply buffer (see #1012)
Return: AL = status (see #1010)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=32h,AH=E3h/SF=39h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1013)
 00h	WORD	length of following data (max 43h)
 02h	BYTE	3Ah (subfunction "Delete Property")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object's name
	BYTE	length of property's name (01h-0Fh)
      N BYTEs	property's name
--------N-21E3--SF3B-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - CHANGE PROPERTY SECURITY
	AH = E3h subfn 3Bh
	DS:SI -> request buffer (see #1015)
	ES:DI -> reply buffer (see #1012)
Return: AL = status (see #1014)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=38h

(Table 1014)
Values for NetWare function status:
 00h	successful
 96h	server out of memory
 F0h	wildcard not allowed
 F1h	invalid bindery security level
 FBh	no such property
 FCh	no such object
 FEh	server bindery locked
 FFh	bindery failure

Format of NetWare request buffer:
Offset	Size	Description	(Table 1015)
 00h	WORD	length of following data (max 44h)
 02h	BYTE	3Bh (subfunction "Change Property Security")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object name
	BYTE	new property security levels
	BYTE	length of property's name
      N BYTEs	property name
--------N-21E3--SF3C-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - SCAN PROPERTY
	AH = E3h subfn 3Ch
	DS:SI -> request buffer (see #1016)
	ES:DI -> reply buffer (see #1017)
Return: AL = status (00h,96h,F1h,FBh,FCh,FEh,FFh) (see #1014)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=37h,AH=E3h/SF=3Bh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1016)
 00h	WORD	length of following data (max 47h)
 02h	BYTE	3Ch (subfunction "Scan Property")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object name
	DWORD	(big-endian) sequence number
		FFFFFFFFh for first call
	BYTE	length of property's name (01h-0Fh)
      N BYTEs	property's name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1017)
 00h	WORD	(call) 0018h (length of following results buffer)
 02h 16 BYTEs	property name
 12h	BYTE	property flags
 13h	BYTE	property security levels
 14h	DWORD	(big-endian) sequence number
 18h	BYTE	property value flag (00h no, FFh yes)
 19h	BYTE	more properties (00h no, FFh yes)
--------N-21E3--SF3D-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - READ PROPERTY VALUE
	AH = E3h subfn 3Dh
	DS:SI -> request buffer (see #1019)
	ES:DI -> reply buffer (see #1020)
Return: AL = status (see #1018)
Desc:	retrieve one 128-byte segment of the specified property's value
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=39h,AH=E3h/SF=3Ch,AH=E3h/SF=3Eh

(Table 1018)
Values for NetWare function status:
 00h	successful
 96h	server out of memory
 E8h	not item property
 ECh	no such segment
 F0h	wildcard not allowed
 F1h	invalid bindery security level
 F8h	not permitted to write property
 F9h	not permitted to read property
 FBh	no such property
 FCh	no such object
 FEh	server bindery locked
 FFh	bindery failure

Format of NetWare request buffer:
Offset	Size	Description	(Table 1019)
 00h	WORD	length of following data (max 44h)
 02h	BYTE	3Dh (subfunction "Read Property Value")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object name
	BYTE	segment number (01h on first call, increment until done)
	BYTE	length of property's name (01h-0Fh)
      N BYTEs	property name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1020)
 00h	WORD	(call) 0082h (length of following results buffer)
 02h 128 BYTEs	property's value
 82h	BYTE	more segments (00h no, FFh yes)
 83h	BYTE	property's flags
--------N-21E3--SF3E-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - WRITE PROPERTY VALUE
	AH = E3h subfn 3Eh
	DS:SI -> request buffer (see #1021)
	ES:DI -> reply buffer (see #1022)
Return: AL = status (see #1018)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=39h,AH=E3h/SF=3Ch,AH=E3h/SF=3Eh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1021)
 00h	WORD	length of following data (max C5h)
 02h	BYTE	3Eh (subfunction "Write Property Value")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object name
	BYTE	segment number (01h on first call, increment until done)
	BYTE	erase remaining segments (00h no, FFh yes)
	BYTE	length of property's name (01h-0Fh)
      N BYTEs	property name
    128 BYTEs	property value segment

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1022)
 00h	WORD	(call) 0000h (no data returned)
--------N-21E3--SF3F-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - VERIFY BINDERY OBJECT PASSWORD
	AH = E3h subfn 3Fh
	DS:SI -> request buffer (see #1024)
	ES:DI -> reply buffer (see #1022)
Return: AL = status (see #1023)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=40h

(Table 1023)
Values for NetWare function status:
 00h	successful
 96h	server out of memory
 F0h	wildcard not allowed
 FBh	no such property
 FCh	no such object
 FEh	server bindery locked
 FFh	bindery failure: no such object, bad password, no password for object,
	  or invalid old password

Format of NetWare request buffer:
Offset	Size	Description	(Table 1024)
 00h	WORD	length of following data (max 133h)
 02h	BYTE	3Fh (subfunction "Verify Bindery Object Password")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object name
	BYTE	length of password (00h-7Fh)
      N BYTEs	password
--------N-21E3--SF40-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - CHANGE BINDERY OBJECT PASSWORD
	AH = E3h subfn 40h
	DS:SI -> request buffer (see #1025)
	ES:DI -> reply buffer (see #1026)
Return: AL = status (see #1023)
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=3Fh,AH=E3h/SF=41h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1025)
 00h	WORD	length of following data (max 133h)
 02h	BYTE	40h (subfunction "Change Bindery Object Password")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name (01h-2Fh)
 06h  N BYTEs	object name
	BYTE	length of old password (00h-7Fh)
      N BYTEs	old password
	BYTE	length of new password (00h-7Fh)
      N BYTEs	new password

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1026)
 00h	WORD	(call) 0000h (no data returned)
--------N-21E3--SF41-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - ADD BINDERY OBJECT TO SET
	AH = E3h subfn 41h
	DS:SI -> request buffer (see #1028)
	ES:DI -> reply buffer (see #1026)
Return: AL = status (see #1027)
Desc:	add the specified object to a set property
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=40h,AH=E3h/SF=42h,AH=E3h/SF=43h

(Table 1027)
Values for NetWare function status:
 00h	successful
 96h	server out of memory
 E9h	member already exists
 EAh	member does not exist
 EBh	not a group property
 F0h	wildcard not allowed
 F8h	can't write property
 F9h	not permitted to read property
 FBh	no such property
 FCh	no such object
 FEh	server bindery locked
 FFh	bindery failure

Format of NetWare request buffer:
Offset	Size	Description	(Table 1028)
 00h	WORD	length of following data (max 75h)
 02h	BYTE	41h (subfunction "Add Bindery Object to Set")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name
 06h  N BYTEs	object name
	BYTE	length of property name (01h-0Fh)
      N BYTEs	property name
	WORD	(big-endian) type of member object
	BYTE	length of member object's name
      N BYTEs	member object's name
--------N-21E3--SF42-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - DELETE BINDERY OBJECT FROM SET
	AH = E3h subfn 42h
	DS:SI -> request buffer (see #1029)
	ES:DI -> reply buffer (see #1030)
Return: AL = status (see #1027)
Desc:	delete the specified object from a set property
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=40h,AH=E3h/SF=42h,AH=E3h/SF=43h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1029)
 00h	WORD	length of following data (max 75h)
 02h	BYTE	42h (subfunction "Delete Bindery Object from Set")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name
 06h  N BYTEs	object name
	BYTE	length of property name (01h-0Fh)
      N BYTEs	property name
	WORD	(big-endian) type of member object
	BYTE	length of member object's name
      N BYTEs	member object's name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1030)
 00h	WORD	(call) 0000h (no data returned)
--------N-21E3--SF43-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - IS BINDERY OBJECT IN SET
	AH = E3h subfn 43h
	DS:SI -> request buffer (see #1031)
	ES:DI -> reply buffer (see #1030)
Return: AL = status (see #1027)
Desc:	determine whether the specified object is a member of the given set
	  property
Notes:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
	the caller must have read access to the property
SeeAlso: AH=E3h/SF=41h,AH=E3h/SF=42h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1031)
 00h	WORD	length of following data (max 75h)
 02h	BYTE	43h (subfunction "Is Bindery Object In Set")
 03h	WORD	(big-endian) type of object
 05h	BYTE	length of object's name
 06h  N BYTEs	object's name
	BYTE	length of property's name
      N BYTEs	property's name
	WORD	(big-endian) type of member object
	BYTE	length of member object's name
      N BYTEs	member object's name
--------N-21E3--SF44-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - CLOSE BINDERY
	AH = E3h subfn 44h
	DS:SI -> request buffer (see #1032)
	ES:DI -> reply buffer (see #1030)
Return: AL = status
	    00h successful
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E3h/SF=45h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1032)
 00h	WORD	0001h (length of following data)
 02h	BYTE	44h (subfunction "Close Bindery")
--------N-21E3--SF45-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - OPEN BINDERY
	AH = E3h subfn 45h
	DS:SI -> request buffer (see #1033)
	ES:DI -> reply buffer (see #1030)
Return: AL = status
	    00h successful
Notes:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
	the bindery may only be opened by the supervisor or an object with
	  equivalent privileges
SeeAlso: AH=E3h/SF=44h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1033)
 00h	WORD	0001h (length of following data)
 02h	BYTE	45h (subfunction "Open Bindery")
--------N-21E3--SF46-------------------------
INT 21 - Novell NetWare - BINDERY SERVICES - GET BINDERY ACCESS LEVEL
	AH = E3h subfn 46h
	DS:SI -> request buffer (see #1034)
	ES:DI -> reply buffer (see #1035)
Return: AL = status
	    00h successful
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX

Format of NetWare request buffer:
Offset	Size	Description	(Table 1034)
 00h	WORD	0001h (length of following data)
 02h	BYTE	46h (subfunction "Get Bindery Access Level")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1035)
 00h	WORD	0005h (length of following buffer)
 02h	BYTE	security levels
 03h	DWORD	(big-endian) object ID
--------N-21E3--SF47-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - SCAN BINDERY OBJ TRUSTEE PATHS
	AH = E3h subfn 47h
	DS:SI -> request buffer (see #1036)
	ES:DI -> reply buffer (see #1037)
Return: AL = status (00h,96h,F0h,F1h,FCh,FEh,FFh) (see #1038)
Desc:	iterate through the directories to which an object is a trustee
Note:	this function is supported by Advanced NetWare 1.0+ and Alloy NTNX
SeeAlso: AH=E2h/SF=0Ch,AH=E2h/SF=0Dh,AH=E2h/SF=0Eh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1036)
 00h	WORD	0008h (length of following data)
 02h	BYTE	47h (subfunction "Scan Bindery Object Trustee Paths")
 03h	BYTE	volume number (00h-1Fh)
 04h	WORD	(big-endian) last sequence number (FFFFh on first call)
 06h	DWORD	(big-endian) object ID

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1037)
 00h	WORD	(call) length of following results buffer (max 107h)
 02h	WORD	(big-endian) next sequence number
 04h	DWORD	(big-endian) object ID
 08h	BYTE	trustee directory rights (see #0929 at AH=E2h/SF=03h)
 09h	BYTE	length of trustee path
 0Ah  N BYTEs	trustee path
--------N-21E3--SF64-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - CREATE QUEUE
	AH = E3h subfn 64h
	DS:SI -> request buffer (see #1039)
	ES:DI -> reply buffer (see #1040)
Return: AL = status (00h,96h,99h,9Bh,9Ch,EDh-F1h,F5h,F7h,FCh,FEh,FFh)
		(see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be on a workstation with supervisor privileges
SeeAlso: AH=E3h/SF=65h,AH=E3h/SF=66h,AH=E3h/SF=68h,AH=E3h/SF=6Bh

(Table 1038)
Values for NetWare function status:
 00h	successful
 96h	server out of memory
 99h	directory full
 9Bh	invalid directory handle
 9Ch	invalid path
 D0h	queue error
 D1h	no such queue
 D2h	no server for queue
 D3h	no queue rights
 D4h	queue full
 D5h	no queue job
 D6h	no job rights
 D7h	queue servicing error
 D9h	station is not a server
 DAh	queue halted
 DBh	too many queue servers
 EDh	property already exists
 EEh	object already exists
 EFh	invalid name
 F0h	wildcard not allowed
 F1h	invalid bindery security level
 F5h	not permitted to create object
 F7h	not permitted to create property
 FCh	no such object
 FEh	server bindery locked
 FFh	bindery failure

Format of NetWare request buffer:
Offset	Size	Description	(Table 1039)
 00h	WORD	length of following data (max ABh)
 02h	BYTE	64h (subfunction "Create Queue")
 03h	WORD	(big-endian) queue type
 05h	BYTE	length of queue's name (01h-2Fh)
 06h  N BYTEs	queue's name
	BYTE	directory handle or 00h
	BYTE	length of path name (01h-76h)
      N BYTEs	path name of directory in which to create queue subdirectory

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1040)
 00h	WORD	(call) 0004h (size of following results buffer)
 02h	DWORD	(big-endian) object ID of queue
--------N-21E3--SF65-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - DESTROY QUEUE
	AH = E3h subfn 65h
	DS:SI -> request buffer (see #1041)
	ES:DI -> reply buffer (see #1046)
Return: AL = status (00h,96h,9Ch,D0h,D1h,FFh) (see also AH=E3h/SF=64h)
	    FFh hardware failure
Desc:	abort all active jobs, detach all job servers, remove all job entries,
	  delete all job files, remove the queue object and its properties
	  from the bindery, and delete the queue's subdirectory
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must have SUPERVISOR privileges
SeeAlso: AH=E3h/SF=64h,AH=E3h/SF=66h,AH=E3h/SF=68h,AH=E3h/SF=6Ah,AH=E3h/SF=70h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1041)
 00h	WORD	0005h (length of following data)
 02h	BYTE	65h (subfunction "Destroy Queue")
 03h	DWORD	(big-endian) object ID of queue
--------N-21E3--SF66-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - READ QUEUE CURRENT STATUS
	AH = E3h subfn 66h
	DS:SI -> request buffer (see #1042)
	ES:DI -> reply buffer (see #1043)
Return: AL = status (00h,96h,9Ch,D1h-D3h,F1h,FCh,FEh,FFh) (see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be on a workstation which is security-equivalent to a
	  member of the queue's Q_USERS or Q_OPERATORS properties
SeeAlso: AH=E3h/SF=64h,AH=E3h/SF=67h,AH=E3h/SF=6Fh,AH=E3h/SF=76h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1042)
 00h	WORD	0005h (length of following data)
 02h	BYTE	66h (subfunction "Read Queue Current Status")
 03h	DWORD	(big-endian) object ID of queue

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1043)
 00h	WORD	(call) 0085h (size of following results)
 02h	DWORD	(big-endian) object ID of queue
 06h	BYTE	status of queue (see #1044)
 07h	BYTE	number of jobs in queue (00h-FAh)
 08h	BYTE	number of servers attached to queue (00h-19h)
 09h 25 DWORDs	list of object IDs of attached servers
 6Dh 25 BYTEs	list of attached servers' stations
 86h	BYTE	(call) maximum number of servers to return

Bitfields for NetWare queue status:
Bit(s)	Description	(Table 1044)
 0	operator disabled addition of new jobs
 1	operator refuses additional job servers attaching
 2	operator disabled job servicing
--------N-21E3--SF67-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - SET QUEUE CURRENT STATUS
	AH = E3h subfn 67h
	DS:SI -> request buffer (see #1045)
	ES:DI -> reply buffer (see #1046)
Return: AL = status (00h,96h,9Ch,D0h,D1h,D3h,FEh,FFh) (see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must have operator privileges
SeeAlso: AH=E3h/SF=64h,AH=E3h/SF=66h,AH=E3h/SF=6Fh,AH=E3h/SF=76h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1045)
 00h	WORD	0006h (length of following data)
 02h	BYTE	67h (subfunction "Set Queue Current Status")
 03h	DWORD	(big-endian) object ID of queue
 07h	BYTE	queue status (see #1044)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1046)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E3--SF68-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - CREATE QUEUE JOB AND FILE
	AH = E3h subfn 68h
	DS:SI -> request buffer (see #1047)
	ES:DI -> reply buffer (see #1048)
Return: AL = status (00h,96h,99h,9Ch,D0h-D4h,DAh,EDh,EFh-F1h,F7h,FCh,FEh,FFh)
		(see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be on a workstation which is security-equivalent to a
	  member of the queue's Q_USER property
SeeAlso: AX=B807h,AH=E0h"SPOOLING",AH=E3h/SF=69h,AH=E3h/SF=6Ah,AH=E3h/SF=6Eh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1047)
 00h	WORD	0107h (length of following data)
 02h	BYTE	68h (subfunction "Close File and Start Queue Job")
 03h	DWORD	(big-endian) object ID of queue
 07h	BYTE	client station
 08h	BYTE	client task number
 09h	DWORD	(big-endian) object ID of client
 0Dh	DWORD	(big-endian) object ID of target server
		FFFFFFFh if any server acceptable
 11h  6 BYTEs	target execution time (year,month,day,hour,minute,second)
		FFFFFFFFFFFFh to execute as soon as possible
 17h  6 BYTEs	job entry time (year,month,day,hour,minute,second)
 1Dh	WORD	(big-endian) job number
 1Fh	WORD	(big-endian) job type
 21h	BYTE	job position
 22h	BYTE	job control flags
 23h 14 BYTEs	ASCIZ job file name
 31h  6 BYTEs	job file handle
 37h	BYTE	server station
 38h	BYTE	server task number
 39h	DWORD	(big-endian) object ID of server
 3Dh 50 BYTEs	ASCIZ job description string
 6Fh 152 BYTEs	client record area

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1048)
 00h	WORD	(call) 0036h (size of following results buffer)
 02h	BYTE	client station
 03h	BYTE	client task number
 04h	DWORD	(big-endian) object ID of client
 08h	DWORD	(big-endian) object ID of target server
 0Ch  6 BYTEs	target execution time (year,month,day,hour,minute,second)
 12h  6 BYTEs	job entry time (year,month,day,hour,minute,second)
 18h	WORD	(big-endian) job number
 1Ah	WORD	(big-endian) job type
 1Ch	BYTE	job position
 1Dh	BYTE	job control flags
 1Eh 14 BYTEs	ASCIZ job file name
 2Ch  6 BYTEs	job file handle
 32h	BYTE	server station
 33h	BYTE	server task number
 34h	DWORD	(big-endian) object ID of server or 00000000h
--------N-21E3--SF69-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - CLOSE FILE AND START QUEUE JOB
	AH = E3h subfn 69h
	DS:SI -> request buffer (see #1049)
	ES:DI -> reply buffer (see #1050)
Return: AL = status (00h,96h,D0h,D1h,D3h,D5h,D6h,FEh,FFh) (see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be on the workstation which created the job
SeeAlso: AH=E3h/SF=68h,AH=E3h/SF=6Ah,AH=E3h/SF=6Eh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1049)
 00h	WORD	0007h (length of following data)
 02h	BYTE	69h (subfunction "Close File and Start Queue Job")
 03h	DWORD	(big-endian) object ID of queue
 07h	WORD	(big-endian) job number

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1050)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E3--SF6A-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - REMOVE JOB FROM QUEUE
	AH = E3h subfn 6Ah
	DS:SI -> request buffer (see #1051)
	ES:DI -> reply buffer (see #1050)
Return: AL = status (00h,96h,D0h,D1h,D5h,D6h,FEh,FFh) (see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must have created the job or be an operator
SeeAlso: AH=E3h/SF=68h,AH=E3h/SF=6Ah,AH=E3h/SF=6Eh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1051)
 00h	WORD	0007h (length of following data)
 02h	BYTE	6Ah (subfunction "Remove Job From Queue")
 03h	DWORD	(big-endian) object ID of queue
 07h	WORD	(big-endian) job number
--------N-21E3--SF6B-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - GET QUEUE JOB LIST
	AH = E3h subfn 6Bh
	DS:SI -> request buffer (see #1052)
	ES:DI -> reply buffer (see #1053)
Return: AL = status (00h,96h,9Ch,D0h-D3h,FCh,FEh,FFh) (see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be on a workstation which is security-equivalent to a
	  member of the Q_USERS or Q_OPERATORS properties
SeeAlso: AH=E3h/SF=68h,AH=E3h/SF=6Ah,AH=E3h/SF=6Eh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1052)
 00h	WORD	0005h (length of following data)
 02h	BYTE	6Bh (subfunction "Get Queue Job List")
 03h	DWORD	(big-endian) object ID of queue

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1053)
 00h	WORD	(call) size of following results buffer (max 1F6h)
 02h	WORD	(big-endian) job count
 04h  N WORDs	(big-endian) list of job numbers by position in queue
	WORD	maximum job numbers
--------N-21E3--SF6C-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - READ QUEUE JOB ENTRY
	AH = E3h subfn 6Ch
	DS:SI -> request buffer (see #1054)
	ES:DI -> reply buffer (see #1055)
Return: AL = status (00h,96h,D0h-D3h,D5h,FCh,FEh,FFh) (see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be on a workstation which is security-equivalent to a
	  member of the Q_USERS, Q_OPERATORS, or Q_SERVERS properties
SeeAlso: AH=E3h/SF=68h,AH=E3h/SF=6Ah,AH=E3h/SF=6Eh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1054)
 00h	WORD	0007h (length of following data)
 02h	BYTE	6Ch (subfunction "Read Queue Job Entry")
 03h	DWORD	(big-endian) object ID of queue
 07h	WORD	(big-endian) job number

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1055)
 00h	WORD	(call) 0100h (size of following results)
 02h	BYTE	client station number
 03h	BYTE	client task number
 04h	DWORD	object ID of client
 08h	DWORD	(big-endian) object ID of target server
		FFFFFFFFh if any server acceptable
 0Ch  6 BYTEs	target execution time (year,month,day,hour,minute,second)
		FFFFFFFFFFFFh if serviced as soon as possible
 12h  6 BYTEs	job entry time (year,month,day,hour,minute,second)
 18h	WORD	(big-endian) job number
 1Ah	WORD	(big-endian) job type
 1Ch	BYTE	job position
 1Dh	BYTE	job control flags (see #1056)
 1Eh 14 BYTEs	ASCIZ job filename
 2Ch  6 BYTEs	job file handle
 32h	BYTE	server station
 33h	BYTE	server task number
 34h	DWORD	object ID of server
 38h 50 BYTEs	ASCIZ job description string
 6Ah 152 BYTEs	client record area

Bitfields for NetWare job control flags:
Bit(s)	Description	(Table 1056)
 3	job will be serviced automatically if connection broken
 4	job remains in queue after server aborts job
 5	client has not filled associated job file
 6	User Hold--job advances, but cannot be serviced until this is
	  cleared by user or operator
 7	Operator Hold--job advances, but cannot be serviced until this is
	  cleared by an operator
--------N-21E3--SF6D-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - CHANGE QUEUE JOB ENTRY
	AH = E3h subfn 6Dh
	DS:SI -> request buffer (see #1057)
	ES:DI -> reply buffer (see #1059)
Return: AL = status (00h,96h,D0h,D1h,D5h,D7h,FEh,FFh) (see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be an operator or the user who created the job
SeeAlso: AH=E3h/SF=68h,AH=E3h/SF=6Ah,AH=E3h/SF=6Ch,AH=E3h/SF=6Eh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1057)
 00h	WORD	0105h (length of following data)
 02h	BYTE	6Dh (subfunction "Change Queue Job Entry")
 03h	DWORD	(big-endian) object ID of queue
 07h	BYTE	client station number
 08h	BYTE	client task number
 09h	DWORD	(big-endian) object ID of client
 0Dh	DWORD	(big-endian) object ID of target server
 11h  6 BYTEs	target execution time (year,month,day,hour,minute,second)
 17h  6 BYTEs	job entry time (year,month,day,hour,minute,second)
 1Dh	WORD	(big-endian) job number
 1Fh	WORD	(big-endian) job type
 21h	BYTE	job position
 22h	BYTE	job control flags (see #1056)
 23h 14 BYTEs	ASCIZ job filename
 31h  6 BYTEs	job file handle
 37h	BYTE	server station
 38h	BYTE	server task number
 39h	DWORD	object ID of server
 3Dh 50 BYTEs	ASCIZ job description string
 6Fh 152 BYTEs	client record area
--------N-21E3--SF6E-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - CHANGE QUEUE JOB POSITION
	AH = E3h subfn 6Eh
	DS:SI -> request buffer (see #1058)
	ES:DI -> reply buffer (see #1059)
Return: AL = status (00h,96h,D0h,D1h,D5h,D6h,FEh,FFh) (see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be an operator
	if the specified position is greater than the number of jobs in the
	  queue, the job is placed at the end of the queue
SeeAlso: AH=E3h/SF=68h,AH=E3h/SF=6Ah,AH=E3h/SF=6Ch,AH=E3h/SF=6Dh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1058)
 00h	WORD	0008h (length of following data)
 02h	BYTE	6Eh (subfunction "Change Queue Job Position")
 03h	DWORD	(big-endian) object ID of queue
 07h	WORD	(big-endian) job number
 09h	BYTE	new position in queue (01h-FAh)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1059)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E3--SF6F-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - ATTACH QUEUE SERVER TO QUEUE
	AH = E3h subfn 6Fh
	DS:SI -> request buffer (see #1060)
	ES:DI -> reply buffer (see #1059)
Return: AL = status (00h,96h,9Ch,D0h,D1h,D3h,DAh,DBh,FEh,FFh)
		(see also AH=E3h/SF=64h)
	    FFh bindery failure, or no such property, or no such member
Desc:	attach the calling job server to the specified queue
Notes:	this function is supported by Advanced NetWare 2.1+
	a queue may have up to 25 job servers attached
	the calling workstation must be security-equivalent to a member of the
	  queue's Q_SERVERS property
SeeAlso: AH=E3h/SF=70h,AH=E3h/SF=71h,AH=E3h/SF=72h,AH=E3h/SF=73h,AH=E3h/SF=76h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1060)
 00h	WORD	0005h (length of following data)
 02h	BYTE	6Fh (subfunction "Attach Queue Server To Queue")
 03h	DWORD	(big-endian) object ID of queue
--------N-21E3--SF70-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - DETACH QUEUE SERVER FROM QUEUE
	AH = E3h subfn 70h
	DS:SI -> request buffer (see #1061)
	ES:DI -> reply buffer (see #1059)
Return: AL = status (00h,96h,9Ch,D0h,D1h,D2h,FEh,FFh) (see #1038)
Desc:	remove the calling job server from the specified queue's list of
	  servers
Notes:	this function is supported by Advanced NetWare 2.1+
	the caller must have previously attached itself to the queue
SeeAlso: AH=E3h/SF=6Fh,AH=E3h/SF=72h,AH=E3h/SF=73h,AH=E3h/SF=76h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1061)
 00h	WORD	0005h (length of following data)
 02h	BYTE	70h (subfunction "Detach Queue Server From Queue")
 03h	DWORD	(big-endian) object ID of queue
--------N-21E3--SF71-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - SERVICE QUEUE JOB AND OPEN FILE
	AH = E3h subfn 71h
	DS:SI -> request buffer (see #1062)
	ES:DI -> reply buffer (see #1048)
Return: AL = status (00h,96h,9Ch,D0h,D1h,D3h,D5h,D9h,DAh,FEh,FFh)
		(see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	the caller must be on a workstation which is security-equivalent to a
	  member of the queue's Q_USERS, Q_OPERATORS, or Q_SERVERS properties
SeeAlso: AH=E3h/SF=6Fh,AH=E3h/SF=72h,AH=E3h/SF=73h,AH=E3h/SF=76h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1062)
 00h	WORD	0007h (length of following data)
 02h	BYTE	71h (subfunction "Service Queue Job and Open File")
 03h	DWORD	(big-endian) object ID of queue
 07h	WORD	(big-endian) target job type
		FFFFh any
--------N-21E3--SF72-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - FINISH SERVICING QUEUE JOB AND FILE
	AH = E3h subfn 72h
	DS:SI -> request buffer (see #1063)
	ES:DI -> reply buffer (see #1065)
Return: AL = status (00h,96h,D0h,D1h,D6h) (see #1038)
Desc:	inform the Queue Management System (QMS) that the queue server has
	  completed a job
Notes:	this function is supported by Advanced NetWare 2.1+
	the caller must be a job server which has previously obtained a job
	  for servicing
SeeAlso: AH=E3h/SF=6Fh,AH=E3h/SF=71h,AH=E3h/SF=73h,AH=E3h/SF=76h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1063)
 00h	WORD	000Bh (length of following data)
 02h	BYTE	72h (subfunction "Finish Servicing Queue Job and File")
 03h	DWORD	(big-endian) object ID of queue
 07h	WORD	(big-endian) job number
 09h	DWORD	(big-endian) charge
--------N-21E3--SF73-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - ABORT SERVICING QUEUE JOB AND FILE
	AH = E3h subfn 73h
	DS:SI -> request buffer (see #1064)
	ES:DI -> reply buffer (see #1065)
Return: AL = status (00h,96h,D0h,D1h,D6h,D9h) (see #1038)
Desc:	inform the Queue Management System (QMS) that the queue server is
	  unable to service a previously-accepted job
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AH=E3h/SF=6Fh,AH=E3h/SF=71h,AH=E3h/SF=72h,AH=E3h/SF=76h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1064)
 00h	WORD	0007h (length of following data)
 02h	BYTE	73h (subfunction "Abort Servicing Queue Job and File")
 03h	DWORD	(big-endian) object ID of queue
 07h	WORD	(big-endian) job number

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1065)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E3--SF74-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - CHANGE TO CLIENT RIGHTS
	AH = E3h subfn 74h
	DS:SI -> request buffer (see #1066)
	ES:DI -> reply buffer (see #1065)
Return: AL = status (00h,96h,D0h,D1h,D5h,D9h) (see #1038)
Desc:	temporarily assume the login identity of the client submitting the
	  job being serviced
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be a job server which has obtained a job for servicing
SeeAlso: AH=E3h/SF=75h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1066)
 00h	WORD	0007h (length of following data)
 02h	BYTE	74h (subfunction "Change To Client Rights")
 03h	DWORD	(big-endian) object ID of queue
 07h	WORD	(big-endian) job number
--------N-21E3--SF75-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - RESTORE QUEUE SERVER RIGHTS
	AH = E3h subfn 75h
	DS:SI -> request buffer (see #1067)
	ES:DI -> reply buffer (see #1065)
Return: AL = status (00h,96h,9Ch,D0h,D1h,D3h,D5h,D9h,DAh,FEh,FFh) (see #1038)
Desc:	restore server's own identity after assuming the login identity of the
	  client submitting the job being serviced
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be a job server which has previously changed its identity
SeeAlso: AH=E3h/SF=74h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1067)
 00h	WORD	0001h (length of following data)
 02h	BYTE	75h (subfunction "Change To Client Rights")
--------N-21E3--SF76-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - READ QUEUE SERVER CURRENT STATUS
	AH = E3h subfn 76h
	DS:SI -> request buffer (see #1068)
	ES:DI -> reply buffer (see #1069)
Return: AL = status (00h,96h,9Ch,D1h-D3h,F1h,FCh,FEh,FFh) (see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be on a workstation which is security-equivalent to a
	  member of the Q_USERS or Q_OPERATORS properties
SeeAlso: AH=E3h/SF=68h,AH=E3h/SF=6Ch,AH=E3h/SF=6Fh,AH=E3h/SF=77h,AH=E3h/SF=78h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1068)
 00h	WORD	000Ah (length of following data)
 02h	BYTE	76h (subfunction "Read Queue Server Current Status")
 03h	DWORD	(big-endian) object ID of queue
 07h	DWORD	(big-endian) object ID of server
 0Bh	BYTE	server station

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1069)
 00h	WORD	(call) 0040h (size of following results)
 02h 64 BYTEs	server status record (format depends on server)
		first four bytes should contain estimated "price" for an
		  average job
--------N-21E3--SF77-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - SET QUEUE SERVER CURRENT STATUS
	AH = E3h subfn 77h
	DS:SI -> request buffer (see #1070)
	ES:DI -> reply buffer (see #1071)
Return: AL = status (00h,96h,9Ch,D0h,D1h,FEh,FFh) (see #1038)
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be a job server which has attached itself to the queue
SeeAlso: AH=E3h/SF=68h,AH=E3h/SF=6Ch,AH=E3h/SF=6Fh,AH=E3h/SF=76h,AH=E3h/SF=78h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1070)
 00h	WORD	0045h (length of following data)
 02h	BYTE	77h (subfunction "Set Queue Server Current Status")
 03h	DWORD	(big-endian) object ID of queue
 02h 64 BYTEs	server status record (format depends on server)
		first four bytes should contain estimated "price" for an
		  average job

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1071)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E3--SF78-------------------------
INT 21 - Novell NetWare - QUEUE SERVICES - GET QUEUE JOB'S FILE SIZE
	AH = E3h subfn 78h
	DS:SI -> request buffer (see #1072)
	ES:DI -> reply buffer (see #1073)
Return: AL = status (see also #1038)
	    00h successful
Notes:	this function is supported by Advanced NetWare 2.1+
	caller must be on a workstation which is security-equivalent to a
	  member of the queue's Q_USERS, Q_OPERATORS, or Q_SERVERS properties
SeeAlso: AH=E3h/SF=68h,AH=E3h/SF=6Ch,AH=E3h/SF=71h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1072)
 00h	WORD	0007h (length of following data)
 02h	BYTE	78h (subfunction "Get Queue Job's File Size")
 03h	DWORD	(big-endian) object ID of queue
 07h	WORD	(big-endian) job number

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1073)
 00h	WORD	(call) 000Ah (size of following results)
 02h	DWORD	(big-endian) object ID of queue
 06h	WORD	(big-endian) job number
 08h	DWORD	(big-endian) size of job file in bytes
--------N-21E3--SF96-------------------------
INT 21 - Novell NetWare - ACCOUNTING SERVICES - GET ACCOUNT STATUS
	AH = E3h subfn 96h
	DS:SI -> request buffer (see #1075)
	ES:DI -> reply buffer (see #1076)
Return: AL = status (00h,C0h,C1h) (see #1074)
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AH=E3h/SF=97h,AH=E3h/SF=98h,AH=E3h/SF=99h

(Table 1074)
Values for NetWare function status:
 00h	successful
 C0h	no account privileges
 C1h	no account balance
 C2h	credit limit exceeded
 C3h	too many holds on account

Format of NetWare request buffer:
Offset	Size	Description	(Table 1075)
 00h	WORD	length of following data (max 33h)
 02h	BYTE	96h (subfunction "Get Account Status")
 03h	WORD	(big-endian) type of bindery object
 05h	BYTE	length of object name (01h to 2Fh)
 06h  N BYTEs	object name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1076)
 00h	WORD	(call) length of following buffer space
 02h	DWORD	(big-endian) account balance
 06h	DWORD	(big-endian) credit limit
		signed number indicating lowest allowable account balance
 0Ah 120 BYTEs	reserved
 82h	DWORD	(big-endian) object ID, server 1
 86h	DWORD	(big-endian) hold amount, server 1
	...
 F8h	DWORD	(big-endian) object ID, server 16
 FCh	DWORD	(big-endian) hold amount, server 16
Note:	the reply buffer lists the servers which have placed holds on a portion
	  of the account balance, and the amount reserved by each
--------N-21E3--SF97-------------------------
INT 21 - Novell NetWare - ACCOUNTING SERVICES - SUBMIT ACCOUNT CHARGE
	AH = E3h subfn 97h
	DS:SI -> request buffer (see #1077)
	ES:DI -> reply buffer (see #1079)
Return: AL = status (00h,C0h-C2h) (see #1074)
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AH=E3h/SF=96h,AH=E3h/SF=98h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1077)
 00h	WORD	length of following data (max 13Fh)
 02h	BYTE	97h (subfunction "Submit Account Charge")
 03h	WORD	(big-endian) service type
 05h	DWORD	(big-endian) amount to be charged to account
 09h	DWORD	(big-endian) amount of prior hold to be cancelled
 0Dh	WORD	(big-endian) type of bindery object
 0Fh	WORD	(big-endian) type of comment
		8000h-FFFFh reserved for experimental use
 11h	BYTE	length of object's name
 12h  N BYTEs	object name
	BYTE	length of comment
      N BYTEs	comment
--------N-21E3--SF98-------------------------
INT 21 - Novell NetWare - ACCOUNTING SERVICES - SUBMIT ACCOUNT HOLD
	AH = E3h subfn 98h
	DS:SI -> request buffer (see #1078)
	ES:DI -> reply buffer (see #1079)
Return: AL = status (00h,C0h-C3h) (see #1074)
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AH=E3h/SF=96h,AH=E3h/SF=97h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1078)
 00h	WORD	length of following data (max 37h)
 02h	BYTE	98h (subfunction "Submit Account Hold")
 03h	DWORD	(big-endian) amount of account balance to reserve
 07h	WORD	(big-endian) type of bindery object
 09h	BYTE	length of object's name
 0Ah  N BYTEs	object name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1079)
 00h	WORD	0000h (no data returned)
--------N-21E3--SF99-------------------------
INT 21 - Novell NetWare - ACCOUNTING SERVICES - SUBMIT ACCOUNT NOTE
	AH = E3h subfn 99h
	DS:SI -> request buffer (see #1080)
	ES:DI -> reply buffer (see #1079)
Return: AL = status (00h,C0h) (see #1074)
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AH=E3h/SF=96h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1080)
 00h	WORD	length of following data (max 137h)
 02h	BYTE	99h (subfunction "Submit Account Note")
 03h	WORD	(big-endian) type of service
 05h	WORD	(big-endian) type of bindery object
 07h	WORD	(big-endian) type of comment
		8000h-FFFFh reserved for experimental use
 09h	BYTE	length of object's name
 0Ah  N BYTEs	object name
	BYTE	length of comment
      N BYTEs	comment
--------N-21E3--SFC8-------------------------
INT 21 - Novell NetWare - FILE SERVER - CHECK CONSOLE PRIVILEGES
	AH = E3h subfn C8h
	DS:SI -> request buffer (see #1081)
	ES:DI -> reply buffer (see #1079)
Return: AL = status (00h,C6h) (see #1084)
Desc:	determine whether the caller is a console operator
Notes:	this function is supported by Advanced NetWare 2.1+
	NetWare determines console privileges by checking the file server's
	  OPERATOR property for the caller's object ID
SeeAlso: AH=E3h/SF=C9h,AH=E3h/SF=D1h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1081)
 00h	WORD	0001h (length of following data)
 02h	BYTE	C8h (subfunction "Check Console Privileges")
--------N-21E3--SFC9-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET FILE SERVER DESCRIPTION STRINGS
	AH = E3h subfn C9h
	DS:SI -> request buffer (see #1082)
	ES:DI -> reply buffer (see #1083)
Return: AL = status
	    00h successful
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must be attached to the file server
SeeAlso: AH=E3h/SF=11h,AH=E3h/SF=CDh,AH=E3h/SF=E8h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1082)
 00h	WORD	0001h (length of following data)
 02h	BYTE	C9h (subfunction "Get File Server Description Strings")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1083)
 00h	WORD	(call) 0200h (size of following results buffer)
 02h	var	ASCIZ name of company distributing this copy of NetWare
	var	ASCIZ version and revision
      9 BYTEs	ASCIZ revision date (mm/dd/yy)
	var	ASCIZ copyright notice
--------N-21E3--SFCA-------------------------
INT 21 - Novell NetWare - FILE SERVER - SET FILE SERVER DATE AND TIME
	AH = E3h subfn CAh
	DS:SI -> request buffer (see #1085)
	ES:DI -> reply buffer (see below)
Return: AL = status (00h,C6h) (see #1084)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=2Bh,AH=2Dh,AH=E3h/SF=C8h,AH=E7h

(Table 1084)
Values for NetWare function status:
 00h	successful
 C6h	no console rights

Format of NetWare request buffer:
Offset	Size	Description	(Table 1085)
 00h	WORD	0007h (length of following data)
 02h	BYTE	CAh (subfunction "Set File Server Date And Time")
 03h	BYTE	year (00-79 = 2000-2079, 80-99 = 1980-1999)
 04h	BYTE	month (1-12)
 05h	BYTE	day (1-31)
 06h	BYTE	hour (0-23)
 07h	BYTE	minute
 08h	BYTR	second
--------N-21E3--SFCB-------------------------
INT 21 - Novell NetWare - FILE SERVER - DISABLE FILE SERVER LOGIN
	AH = E3h subfn CBh
	DS:SI -> request buffer (see #1086)
	ES:DI -> reply buffer (see #1087)
Return: AL = status (00h,C6h) (see #1084)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=CCh,AH=E3h/SF=D3h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1086)
 00h	WORD	0001h (length of following data)
 02h	BYTE	CBh (subfunction "Disable File Server Login")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1087)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E3--SFCC-------------------------
INT 21 - Novell NetWare - FILE SERVER - ENABLE FILE SERVER LOGIN
	AH = E3h subfn CCh
	DS:SI -> request buffer (see #1088)
	ES:DI -> reply buffer (see #1087)
Return: AL = status (00h,C6h) (see #1084)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=CBh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1088)
 00h	WORD	0001h (length of following data)
 02h	BYTE	CCh (subfunction "Enable File Server Login")
--------N-21E3--SFCD-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET FILE SERVER LOGIN STATUS
	AH = E3h subfn CDh
	DS:SI -> request buffer (see #1089)
	ES:DI -> reply buffer (see #1090)
Return: AL = status (00h,C6h) (see #1084)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=CBh,AH=E3h/SF=CCh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1089)
 00h	WORD	0001h (length of following data)
 02h	BYTE	CDh (subfunction "Get File Server Login Status")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1090)
 00h	WORD	(call) 0001h (size of following results buffer)
 02h	BYTE	login state (00h disabled, 01h enabled)
--------N-21E3--SFCE-------------------------
INT 21 - Novell NetWare - FILE SERVICES - PURGE ALL ERASED FILES
	AH = E3h subfn CEh
	DS:SI -> request buffer (see #1091)
	ES:DI -> reply buffer (see #1093)
Return: AL = status (00h,C6h) (see #1084)
Desc:	all files marked for deletion on the file server are purged, regardless
	  of which workstation actually erased them
Notes:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
	the calling workstation must have console operator privileges
SeeAlso: AH=13h,AH=E2h/SF=10h,AH=E3h/SF=C8h,AX=F244h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1091)
 00h	WORD	0001h (length of following data)
 02h	BYTE	CEh (subfunction "Purge All Erased Files")
--------N-21E3--SFCF-------------------------
INT 21 - Novell NetWare - FILE SERVER - DISABLE TRANSACTION TRACKING
	AH = E3h subfn CFh
	DS:SI -> request buffer (see #1092)
	ES:DI -> reply buffer (see #1093)
Return: AL = status (00h,C6h) (see #1084)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=D0h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1092)
 00h	WORD	0001h (length of following data)
 02h	BYTE	CFh (subfunction "Disable Transaction Tracking")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1093)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E3--SFD0-------------------------
INT 21 - Novell NetWare - FILE SERVER - ENABLE TRANSACTION TRACKING
	AH = E3h subfn D0h
	DS:SI -> request buffer (see #1094)
	ES:DI -> reply buffer (see #1093)
Return: AL = status (00h,C6h) (see #1098)
Desc:	restart transaction tracking after being stopped either explicitly by
	  AH=E3h/SF=CFh or automatically due to a full transaction volume
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=CFh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1094)
 00h	WORD	0001h (length of following data)
 02h	BYTE	D0h (subfunction "Enable Transaction Tracking")
--------N-21E3--SFD1-------------------------
INT 21 - Novell NetWare - FILE SERVER - SEND CONSOLE BROADCAST
	AH = E3h subfn D1h
	DS:SI -> request buffer (see #1095)
	ES:DI -> reply buffer (see #1097)
Return: AL = status (00h,C6h) (see #1098)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
	the broadcast message will not be received by workstations which have
	  disabled broadcasts with AH=E1h/SF=02h
SeeAlso: AH=E1h/SF=02h,AH=E1h/SF=09h,AH=E3h/SF=C8h,AH=E3h/SF=D3h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1095)
 00h	WORD	length of following data (max A2h)
 02h	BYTE	D1h (subfunction "Send Console Broadcast")
 03h	BYTE	number of connections to receive message
		00h = all, else specific list below
 04h  N BYTEs	connection list
	BYTE	length of message (max 3Ch)
      N BYTEs	message
--------N-21E3--SFD2-------------------------
INT 21 - Novell NetWare - FILE SERVER - CLEAR CONNECTION NUMBER
	AH = E3h subfn D2h
	DS:SI -> request buffer (see #1096)
	ES:DI -> reply buffer (see #1097)
Return: AL = status (00h,C6h) (see #1098)
Desc:	close the open files and release all file locks for a connection,
	  abort transactions if a TTS file server, and detach from the file
	  server
Notes:	this function is supported by Advanced NetWare 2.1+
	the caller must have SUPERVISOR privileges
SeeAlso: AH=E3h/SF=C9h,AH=E3h/SF=D1h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1096)
 00h	WORD	0002h (length of following data)
 02h	BYTE	D2h (subfunction "Clear Connection Number")
 03h	BYTE	connection number

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1097)
 00h	WORD	(call) 0000h (no results returned)
--------N-21E3--SFD3-------------------------
INT 21 - Novell NetWare - FILE SERVER - DOWN FILE SERVER
	AH = E3h subfn D3h
	DS:SI -> request buffer (see #1099)
	ES:DI -> reply buffer (see #1097)
Return: AL = status (00h,C6h,FFh) (see #1098)
Desc:	take down the file server
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have SUPERVISOR privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=CBh,AH=E3h/SF=CFh,AH=E3h/SF=D1h

(Table 1098)
Values for NetWare function status:
 00h	successful
 C6h	no console rights
 FFh	files open

Format of NetWare request buffer:
Offset	Size	Description	(Table 1099)
 00h	WORD	0002h (length of following data)
 02h	BYTE	D3h (subfunction "Down File Server")
 03h	BYTE	flag: force down even if files open if nonzero
--------N-21E3--SFD4-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET FILE SYSTEM STATISTICS
	AH = E3h subfn D4h
	DS:SI -> request buffer (see #1100)
	ES:DI -> reply buffer (see #1101)
Return: AL = status (00h,C6h) (see #1098)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=0Eh,AH=E3h/SF=C8h,AH=E3h/SF=D9h,AH=E3h/SF=E7h,AH=E3h/SF=E8h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1100)
 00h	WORD	0001h (length of following data)
 02h	BYTE	D4h (subfunction "Get File System Statistics")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1101)
 00h	WORD	(call) 0028h (size of following results buffer)
 02h	DWORD	clock ticks since system started
 06h	WORD	maximum open files set by configuration
 08h	WORD	maximum files open concurrently
 0Ah	WORD	current number of open files
 0Ch	DWORD	total files opened
 10h	DWORD	total file read requests
 14h	DWORD	total file write requests
 18h	WORD	current changed FATs
 1Ah	WORD	total changed FATs
 1Ch	WORD	number of FAT write errors
 1Eh	WORD	number of fatal FAT write errors
 20h	WORD	number of FAT scan errors
 22h	WORD	maximum concurrently-indexed files
 24h	WORD	current number of indexed files
 26h	WORD	number of attached indexed files
 28h	WORD	number of indexed files available
Note:	all fields except the first are big-endian
--------N-21E3--SFD5-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET TRANSACTION TRACKING STATISTICS
	AH = E3h subfn D5h
	DS:SI -> request buffer (see #1102)
	ES:DI -> reply buffer (see #1103)
Return: AL = status (00h,C6h) (see #1098)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=CFh,AH=E3h/SF=D0h,AH=E3h/SF=E8h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1102)
 00h	WORD	0001h (length of following data)
 02h	BYTE	D5h (subfunction "TTS Get Statistics")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1103)
 00h	WORD	(call) length of following results buffer (max 1BCh)
 02h	DWORD	(big-endian) clock ticks since system started
 06h	BYTE	transaction tracking supported if nonzero
		(all following fields are invalid if zero)
 07h	BYTE	transaction tracking enabled
 08h	WORD	(big-endian) transaction volume number
 0Ah	WORD	(big-endian) maximum simultaneous transactions configured
 0Ch	WORD	(big-endian) maximum simultaneous transactions since startup
 0Eh	WORD	(big-endian) current transactions in progress
 10h	DWORD	(big-endian) total transactions performed
 14h	DWORD	(big-endian) total write transactions
 18h	DWORD	(big-endian) total transactions backed out
 1Ch	WORD	(big-endian) number of unfilled backout requests
 1Eh	WORD	(big-endian) disk blocks used for transaction tracking
 20h	DWORD	(big-endian) blocks allocated for tracked-file FATs
 24h	DWORD	(big-endian) number of file size changes during a transaction
 28h	DWORD	(big-endian) number of file truncations during a transaction
 2Ch	BYTE	number of records following
 2Dh	Active Transaction Records [array]
	Offset	Size	Description
	 00h	BYTE	logical connection number
	 01h	BYTE	task number
--------N-21E3--SFD6-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET DISK CACHE STATISTICS
	AH = E3h subfn D6h
	DS:SI -> request buffer (see #1104)
	ES:DI -> reply buffer (see #1105)
Return: AL = status (00h,C6h) (see #1098)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=D5h,AH=E3h/SF=D8h,AH=E3h/SF=D9h,AH=E3h/SF=E6h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1104)
 00h	WORD	0001h (length of following data)
 02h	BYTE	D6h (subfunction "Get Disk Cache Statistics")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1105)
 00h	WORD	(call) 004Eh (length of following results buffer)
 02h	DWORD	clock ticks since system started
 06h	WORD	number of cache buffers
 08h	WORD	size of cache buffer in bytes
 0Ah	WORD	number of dirty cache buffers
 0Ch	DWORD	number of cache read requests
 10h	DWORD	number of cache write requests
 14h	DWORD	number of cache hits
 18h	DWORD	number of cache misses
 1Ch	DWORD	number of physical read requests
 20h	DWORD	number of physical write requests
 24h	WORD	number of physical read errors
 26h	WORD	number of physical write errors
 28h	DWORD	cache get requests
 2Ch	DWORD	cache full write requests
 30h	DWORD	cache partial write requests
 34h	DWORD	background dirty writes
 38h	DWORD	background aged writes
 3Ch	DWORD	total cache writes
 40h	DWORD	number of cache allocations
 44h	WORD	thrashing count
 46h	WORD	number of times LRU block was dirty
 48h	WORD	number of reads on cache blocks not yet filled by writes
 4Ah	WORD	number of times a fragmented write occurred
 4Ch	WORD	number of cache hits on unavailable block
 4Eh	WORD	number of times a cache block was scrapped
Note:	all fields except the first are big-endian
--------N-21E3--SFD7-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET DRIVE MAPPING TABLE
	AH = E3h subfn D7h
	DS:SI -> request buffer (see #1106)
	ES:DI -> reply buffer (see #1107)
Return: AL = status (00h,C6h) (see #1098)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=D6h,AH=E3h/SF=D9h,AH=E3h/SF=E6h,AH=E3h/SF=E9h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1106)
 00h	WORD	0001h (length of following data)
 02h	BYTE	D7h (subfunction "Get Drive Mapping Table")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1107)
 00h	WORD	(call) 00ECh (length of following results buffer)
 02h	DWORD	(big-endian) clock tick elapsed since system started
 06h	BYTE	fault tolerance (SFT) level
 07h	BYTE	number of logical drives attached to server
 08h	BYTE	number of physical drives attached to server
 09h  5 BYTEs	disk channel types (00h none, 01h XT, 02h AT, 03h SCSI,
		  04h disk coprocessor drive, 32h-FFh value-added drive types)
 0Eh	WORD	(big-endian) number of outstanding controller commands
 10h 32 BYTEs	drive mapping table (FFh = no such drive)
 30h 32 BYTEs	drive mirror table (secondary physical drive, FFh = none)
 50h 32 BYTEs	dead mirror table (last drive mapped to, FFh if never mirrored)
 70h	BYTE	physical drive being remirrored (FFh = none)
 71h	BYTE	reserved
 72h	DWORD	(big-endian) remirrored block
 76h 60 BYTEs	SFT error table (internal error counters)
--------N-21E3--SFD8-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET PHYSICAL DISK STATISTICS
	AH = E3h subfn D8h
	DS:SI -> request buffer (see #1108)
	ES:DI -> reply buffer (see #1109)
Return: AL = status (00h,C6h) (see #1098)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=D9h,AH=E3h/SF=E9h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1108)
 00h	WORD	0002h (length of following data)
 02h	BYTE	D8h (subfunction "Get Physical Disk Statistics")
 03h	BYTE	physical disk number

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1109)
 00h	WORD	(call) 005Dh (size of following results record)
 02h	DWORD	(big-endian) clock ticks since system started
 06h	BYTE	physical disk channel
 07h	BYTE	flag: drive removable if nonzero
 08h	BYTE	physical drive type
 09h	BYTE	drive number within controller
 0Ah	BYTE	controller number
 0Bh	BYTE	controller type
 0Ch	DWORD	(big-endian) size of drive in 4K disk blocks
 10h	WORD	(big-endian) number of cylinders on drive
 12h	BYTE	number of heads
 13h	BYTE	number of sectors per track
 14h 64 BYTEs	ASCIZ drive make and model
 54h	WORD	(big-endian) number of I/O errors
 56h	DWORD	(big-endian) start of Hot Fix table
 5Ah	WORD	(big-endian) size of Hot Fix table
 5Ch	WORD	(big-endian) number of Hot Fix blocks available
 5Eh	BYTE	flag: Hot Fix disabled if nonzero
--------N-21E3--SFD9-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET DISK CHANNEL STATISTICS
	AH = E3h subfn D9h
	DS:SI -> request buffer (see #1110)
	ES:DI -> reply buffer (see #1111)
Return: AL = status (00h,C6h) (see #1098)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=D8h,AH=E3h/SF=E6h,AH=E3h/SF=E9h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1110)
 00h	WORD	0002h (length of following data)
 02h	BYTE	D9h (subfunction "Get Disk Channel Statistics")
 03h	BYTE	channel number

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1111)
 00h	WORD	(call) 00A8h (size of following results record)
 02h	DWORD	(big-endian) clock ticks since system started
 06h	WORD	(big-endian) channel run state (see #1112)
 08h	WORD	(big-endian) channel synchronization state (see #1113)
 0Ah	BYTE	driver type
 0Bh	BYTE	major version of driver
 0Ch	BYTE	minor version of driver
 0Dh 65 BYTEs	ASCIZ driver description
 4Eh	WORD	(big-endian) first I/O address used
 50h	WORD	(big-endian) length of first I/O address
 52h	WORD	(big-endian) second I/O address used
 54h	WORD	(big-endian) length of second I/O address
 56h  3 BYTEs	first shared memory address
 59h  2 BYTEs	length of first shared memory address
 5Bh  3 BYTEs	second shared memory address
 5Eh  2 BYTEs	length of second shared memory address
 60h	BYTE	first interrupt number in-use flag
 61h	BYTE	first interrupt number used
 62h	BYTE	second interrupt number in-use flag
 63h	BYTE	second interrupt number used
 64h	BYTE	first DMA channel in-use flag
 65h	BYTE	first DMA channel used
 66h	BYTE	second DMA channel in-use flag
 67h	BYTE	second DMA channel used
 68h	BYTE	flags
 69h	BYTE	reserved
 6Ah 80 BYTEs	ASCIZ configuration description

(Table 1112)
Values for channel run state:
 0000h	running
 0001h	being stopped
 0002h	stopped
 0003h	nonfunctional

(Table 1113)
Values for channel synchronization state:
 0000h	not in use
 0002h	used by NetWare, no other requests
 0004h	used by NetWare, other requests
 0006h	in use, not needed by NetWare
 0008h	in use, needed by NetWare
 000Ah	channel released, NetWare should use it
--------N-21E3--SFDA-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET CONNECTION'S TASK INFORMATION
	AH = E3h subfn DAh
	DS:SI -> request buffer (see #1114)
	ES:DI -> reply buffer (see #1115)
Return: AL = status (00h,C6h) (see #1126)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=DBh,AH=E3h/SF=DFh,AH=E3h/SF=E1h,AH=E3h/SF=E5h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1114)
 00h	WORD	0003h (length of following data)
 02h	BYTE	DAh (subfunction "Get Connection's Task Information")
 03h	WORD	(big-endian) logical connection number

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1115)
 00h	WORD	(call) size of following results record (max 1FEh)
 02h	BYTE	lock status of connection (see #1116)
 03h	var	Lock Status Information (see #1117)
 N	BYTE	number of records following
 N+1	Active Task Information Records [array]
	Offset	Size	Description
	 00h	BYTE	task number (01h-FFh)
	 01h	BYTE	task state
			01h in TTS explicit transaction
			02h in TTS implicit transaction
			04h shared fileset lock active

(Table 1116)
Values for lock status of connection:
 00h	no locks
 01h	waiting on physical record lock
 02h	waiting on file lock
 03h	waiting on logical record lock
 04h	waiting on semaphore

Format of Lock Status Information:
Offset	Size	Description	(Table 1117)
---lock status 00h---
 no fields
---lock status 01h---
 00h	BYTE	number of waiting task
 01h	DWORD	start address
 05h	DWORD	end address
 09h	BYTE	volume number
 0Ah	WORD	directory entry number
 0Ch 14 BYTEs	ASCIZ filename
---lock status 02h---
 00h	BYTE	number of waiting task
 01h	BYTE	volume number
 02h	WORD	directory entry number
 04h 14 BYTEs	ASCIZ filename
---lock status 03h---
 00h	BYTE	number of waiting task
 01h	BYTE	length of record name
 02h  N BYTEs	ASCIZ record name
---lock status 04h---
 00h	BYTE	number of waiting task
 01h	BYTE	length of semaphore's name
 02h  N BYTEs	ASCIZ semaphore name
--------N-21E3--SFDB-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET CONNECTION'S OPEN FILES
	AH = E3h subfn DBh
	DS:SI -> request buffer (see #1118)
	ES:DI -> reply buffer (see #1119)
Return: AL = status (00h,C6h) (see #1126)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E2h/SF=1Ah,AH=E3h/SF=C8h,AH=E3h/SF=DAh,AH=E3h/SF=DCh,AH=E3h/SF=DFh
SeeAlso: AH=E3h/SF=E1h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1118)
 00h	WORD	0005h (length of following data)
 02h	BYTE	DBh (subfunction "Get Connection's Open Files")
 03h	WORD	(big-endian) logical connection number
 05h	WORD	(big-endian) last record seen (0000h on first call)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1119)
 00h	WORD	(call) size of following results record (max 1FEh)
 02h	WORD	next request record (place in "last record" field on next call)
		0000h if no more records
 04h	BYTE	number of records following
 05h	var	array of File Information Records (see #1120)

Format of NetWare File Information Record:
Offset	Size	Description	(Table 1120)
 00h	BYTE	task number
 01h	BYTE	lock flags (see #1121)
 02h	BYTE	access flags (see #1122)
 03h	BYTE	lock type
		00h no lock
		FEh file lock
		FFh locked by Begin Share File Set
 04h	BYTE	volume number (00h-1Fh)
 05h	WORD	(big-endian) directory entry
 07h 14 BYTEs	ASCIZ filename

Bitfields for lock flags:
Bit(s)	Description	(Table 1121)
 0	file is locked
 1	file opened Shareable
 2	logged
 3	file opened Normal
 6	TTS holding lock
 7	Transaction Flag set on file

Bitfields for access flags:
Bit(s)	Description	(Table 1122)
 0	file open for reading by calling station
 1	file open for writing by calling station
 2	deny reads by other stations
 3	deny writes by other stations
 4	file detached
 5	TTS Holding Detach
 6	TTS Holding Open
--------N-21E3--SFDC-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET CONNECTIONS USING A FILE
	AH = E3h subfn DCh
	DS:SI -> request buffer (see #1123)
	ES:DI -> reply buffer (see #1124)
Return: AL = status (00h,C6h) (see #1126)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=DAh,AH=E3h/SF=DBh,AH=E3h/SF=DFh,AH=E3h/SF=E1h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1123)
 00h	WORD	length of following data (max 104h)
 02h	BYTE	DCh (subfunction "Get Connections Using a File")
 03h	WORD	(big-endian) last record (0000h on first call)
 05h	BYTE	directory handle
 06h	BYTE	length of file path
 07h  N BYTEs	ASCIZ file path

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1124)
 00h	WORD	(call) size of following results record (max 1FEh)
 02h	WORD	(big-endian) count of tasks which have opened or logged file
 04h	WORD	(big-endian) count of tasks which have opened file
 06h	WORD	(big-endian) count of opens for reading
 08h	WORD	(big-endian) count of opens for writing
 0Ah	WORD	(big-endian) deny read count
 0Ch	WORD	(big-endian) deny write count
 0Eh	WORD	next request record (place in "last record" field on next call)
		0000h if no more records
 10h	BYTE	locked flag
		00h not locked exclusively
		else locked exclusively
 11h	BYTE	number of records following
 12h	var	array of File Usage Information Records (see #1125)

Format of NetWare File Usage Information Record:
Offset	Size	Description	(Table 1125)
 00h	WORD	(big-endian) logical connection number
 02h	BYTE	task number
 03h	BYTE	lock flags (see #1121)
 04h	BYTE	access flags (see #1122)
 05h	BYTE	lock type
		00h no lock
		FEh file lock
		FFh locked by Begin Share File Set
--------N-21E3--SFDD-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET PHYSICAL RECORD LOCKS BY CONN&FILE
	AH = E3h subfn DDh
	DS:SI -> request buffer (see #1127)
	ES:DI -> reply buffer (see #1128)
Return: AL = status (00h,C6h,FFh) (see #1126)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=DEh,AH=E3h/SF=DFh

(Table 1126)
Values for NetWare function status:
 00h	successful
 C6h	no console rights
 FFh	file not open

Format of NetWare request buffer:
Offset	Size	Description	(Table 1127)
 00h	WORD	0016h (length of following data)
 02h	BYTE	DDh (subfunction "Get Physical Record Locks by Connection and
		  File")
 03h	WORD	(big-endian) logical connection number
 05h	WORD	(big-endian) last record seen (0000h on first call)
 07h	BYTE	volume number (00h-1Fh)
 08h	WORD	(big-endian) directory handle
 0Ah 14 BYTEs	ASCIZ filename

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1128)
 00h	WORD	(call) size of following results record (max 1FEh)
 02h	WORD	next request record (place in "last record" on next call)
		0000h if no more records
 04h	BYTE	number of physical record locks
 05h	BYTE	number of records following
 06h	var	array of Physical Record Lock Info records (see #1129)

Format of NetWare Physical Record Lock Info:
Offset	Size	Description	(Table 1129)
 00h	BYTE	task number
 01h	BYTE	lock status (see #1130)
 02h	DWORD	(big-endian) starting offset of record in file
 06h	DWORD	(big-endian) ending offset of record in file

Bitfields for lock status:
Bit(s)	Description	(Table 1130)
 0	exclusive lock
 1	shareable lock
 2	logged
 6	lock held by TTS
--------N-21E3--SFDE-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET PHYSICAL RECORD LOCKS BY FILE
	AH = E3h subfn DEh
	DS:SI -> request buffer (see #1131)
	ES:DI -> reply buffer (see #1132)
Return: AL = status (00h,C6h,FFh) (see #1126)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=DDh,AH=E3h/SF=DFh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1131)
 00h	WORD	length of following data (max 104h)
 02h	BYTE	DEh (subfunction "Get Physical Record Locks by File")
 03h	WORD	(big-endian) last record seen (0000h on first call)
 05h	BYTE	directory handle
 06h	BYTE	length of filename
 07h  N BYTEs	ASCIZ filename

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1132)
 00h	WORD	(call) size of following results record (max 1FEh)
 02h	WORD	next request record (place in "last record" on next call)
		0000h if no more records
 04h	BYTE	number of physical record locks
 05h	BYTE	number of records following
 06h	var	array of Physical Record Lock Info records (see #1133)

Format of NetWare Physical Record Lock Info:
Offset	Size	Description	(Table 1133)
 00h	WORD	(big-endian) number of tasks logging record
 02h	WORD	(big-endian) number of tasks with shareable lock
 04h	DWORD	(big-endian) starting offset of record in file
 08h	DWORD	(big-endian) ending offset of record in file
 0Ch	WORD	(big-endian) logical connection number
 0Eh	BYTE	task number
 0Fh	BYTE	lock type
		00h none
		FEh file lock
		FFh Begin Share File Set lock
--------N-21E3--SFDF-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET LOGICAL RECORDS BY CONNECTION
	AH = E3h subfn DFh
	DS:SI -> request buffer (see #1134)
	ES:DI -> reply buffer (see #1135)
Return: AL = status (00h,C6h) (see #1126)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=DDh,AH=E3h/SF=E0h,AH=E3h/SF=E2h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1134)
 00h	WORD	0005h (length of following data)
 02h	BYTE	DFh (subfunction "Get Logical Records By Connection")
 03h	WORD	(big-endian) logical connection number
 05h	WORD	(big-endian) last record seen (0000h on first call)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1135)
 00h	WORD	(call) size of following results record (max 1FEh)
 02h	WORD	next request record (place in "last record" field on next call)
		0000h if no more locked records
 09h	BYTE	number of records following
 0Ah	var	array of Logical Lock Information Records (see #1136)

Format of NetWare Logical Lock Information Record:
Offset	Size	Description	(Table 1136)
 00h	BYTE	task number
 01h	BYTE	lock status (see #1130)
 02h	BYTE	length of logical lock's name
 03h  N BYTEs	logical lock's name
--------N-21E3--SFE0-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET LOGICAL RECORD INFORMATION
	AH = E3h subfn E0h
	DS:SI -> request buffer (see #1137)
	ES:DI -> reply buffer (see #1138)
Return: AL = status (00h,C6h) (see #1126)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=DDh,AH=E3h/SF=DFh,AH=E3h/SF=E2h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1137)
 00h	WORD	length of following data (max 67h)
 02h	BYTE	E0h (subfunction "Get Logical Record Information")
 03h	WORD	(big-endian) last record seen (0000h on first call)
 05h	BYTE	length of logical record's name
 06h  N BYTEs	logical record's name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1138)
 00h	WORD	(call) size of following results record (max 200h)
 02h	WORD	(big-endian) number of logical connections logging the record
 04h	WORD	(big-endian) number of logical connections with shareable lock
 06h	WORD	(big-endian) next request record (place in "last record" field
		  on next call)
 08h	BYTE	locked exclusively if nonzero
 09h	BYTE	number of records following
 0Ah	var	array of Task Information Records (see #1139)

Format of NetWare Task Information Record:
Offset	Size	Description	(Table 1139)
 00h	WORD	(big-endian) logical connection number
 02h	BYTE	task number
 03h	BYTE	lock status (see #1130)
--------N-21E3--SFE1-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET CONNECTION'S SEMAPHORES
	AH = E3h subfn E1h
	DS:SI -> request buffer (see #1140)
	ES:DI -> reply buffer (see #1141)
Return: AL = status (00h,C6h) (see #1126)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=DBh,AH=E3h/SF=DFh,AH=E3h/SF=E2h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1140)
 00h	WORD	0005h (length of following data)
 02h	BYTE	E1h (subfunction "Get Connection's Semaphores")
 03h	WORD	(big-endian) logical connection number
 05h	WORD	(big-endian) last record seen (0000h on first call)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1141)
 00h	WORD	(call) size of following results record (max 1FEh)
 02h	WORD	next request record (place in "last record" field on next call)
 04h	BYTE	number of records following
 05h	var	array of Semaphore Information Records (see #1142)

Format of NetWare Semaphore Information Record:
Offset	Size	Description	(Table 1142)
 00h	WORD	(big-endian) open count
 02h	BYTE	semaphore value (-128 to 127)
 03h	BYTE	task number
 04h	BYTE	lock type
 05h	BYTE	length of semaphore's name
 06h  N BYTEs	semaphore's name
     14 BYTEs	filename
--------N-21E3--SFE2-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET SEMAPHORE INFORMATION
	AH = E3h subfn E2h
	DS:SI -> request buffer (see #1143)
	ES:DI -> reply buffer (see #1144)
Return: AL = status (00h,C6h) (see #1148)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=E1h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1143)
 00h	WORD	length of following data (max 83h)
 02h	BYTE	E2h (subfunction "Get LAN Driver's Configuration Information")
 03h	WORD	(big-endian) last record seen (0000h on first call)
 05h	BYTE	length of semaphore's name (01h-7Fh)
 06h  N BYTEs	semaphore's name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1144)
 00h	WORD	(call) size of following results buffer (max 1FEh)
 02h	WORD	next request record (place in "last record" on next call)
		0000h if no more
 04h	WORD	(big-endian) number of logical connections opening semaphore
 06h	BYTE	semaphore value (-127 to 128)
 07h	BYTE	number of records following
 08h	var	array of Semaphore Information records (see #1145)

Format of NetWare Semaphore Information:
Offset	Size	Description	(Table 1145)
 00h	WORD	(big-endian) logical connection number
 02h	BYTE	task number
--------N-21E3--SFE3-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET LAN DRIVER'S CONFIGURATION INFO
	AH = E3h subfn E3h
	DS:SI -> request buffer (see #1146)
	ES:DI -> reply buffer (see #1147)
Return: AL = status (00h,C6h) (see #1148)
Notes:	this function is supported by Advanced NetWare 2.1+
	the calling workstation must have console operator privileges
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=E7h,AH=E3h/SF=E8h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1146)
 00h	WORD	0002h (length of following data)
 02h	BYTE	E3h (subfunction "Get LAN Driver's Configuration Information")
 03h	BYTE	LAN board (00h-03h)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1147)
 00h	WORD	(call) 00ACh (size of following results buffer)
 02h  4 BYTEs	network number
 06h  6 BYTEs	node number
 0Ch	BYTE	LAN driver installed (00h no--remaining fields invalid)
 0Dh	BYTE	option number selected at configuration time
 0Eh 160 BYTEs	configuration text
		ASCIZ hardware type
		ASCIZ hardware settings
--------N-21E3--SFE5-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET CONNECTION'S USAGE STATISTICS
	AH = E3h subfn E5h
	DS:SI -> request buffer (see #1149)
	ES:DI -> reply buffer (see #1150)
Return: AL = status (00h,C6h) (see #1148)
Notes:	this function is supported by Advanced NetWare 2.1+
	one must have console operator privileges to get statistics for logical
	  connections other than one's own
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=DAh,AH=E3h/SF=DBh,AH=E3h/SF=E1h

(Table 1148)
Values for NetWare function status:
 00h	successful
 C6h	no console rights

Format of NetWare request buffer:
Offset	Size	Description	(Table 1149)
 00h	WORD	0003h (length of following data)
 02h	BYTE	E5h (subfunction "Get Connection's Usage Statistics")
 03h	WORD	(big-endian) logical connection number

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1150)
 00h	WORD	(call) 0014h (size of following results record)
 02h	DWORD	(big-endian) clock ticks since server started
 06h  6 BYTEs	bytes read
 0Ch  6 BYTEs	bytes written
 12h	DWORD	(big-endian) total request packets
--------N-21E3--SFE6-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET BINDERY OBJECT DISK SPACE LEFT
	AH = E3h subfn E6h
	DS:SI -> request buffer (see #1151)
	ES:DI -> reply buffer (see #1152)
Return: AL = status (00h,C6h) (see #1148)
Notes:	this function is supported by Advanced NetWare 2.1+
	one must have console operator privileges to get the free space for
	  other bindery objects
SeeAlso: AH=E3h/SF=C8h,AH=E3h/SF=E8h,AH=E3h/SF=E9h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1151)
 00h	WORD	0005h (length of following data)
 02h	BYTE	E6h (subfunction "Get Bindery Object Disk Space Left")
 03h	DWORD	(big-endian) object ID

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1152)
 00h	WORD	(call) 000Fh (size of following results buffer)
 02h	DWORD	(big-endian) clock ticks elapsed since server started
 06h	DWORD	(big-endian) object ID
 0Ah	DWORD	(big-endian) 4K disk blocks available to user
 0Eh	BYTE	restrictions (00h enforced, FFh not enforced)
--------N-21E3--SFE7-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET FILE SERVER LAN I/O STATISTICS
	AH = E3h subfn E7h
	DS:SI -> request buffer (see #1153)
	ES:DI -> reply buffer (see #1154)
Return: AL = status
	    00h successful
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AH=E3h/SF=0Eh,AH=E3h/SF=11h,AH=E3h/SF=D3h,AH=E3h/SF=E8h,AH=E7h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1153)
 00h	WORD	0001h (length of following data)
 02h	BYTE	E7h (subfunction "Get File Server LAN I/O Statistics")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1154)
 00h	WORD	(call) 0042h (size of following results buffer)
 02h	DWORD	clock ticks since system started
 06h	WORD	total routing buffers
 08h	WORD	maximum routing buffers used
 0Ah	WORD	current routing buffers used
 0Ch	DWORD	total file service packets
 10h	WORD	number of file service packets buffered
 12h	WORD	number of invalid connection packets
 14h	WORD	packets with bad logical connection numbers
 16h	WORD	number of packets received during processing
 18h	WORD	number of requests reprocessed
 1Ah	WORD	packets with bad sequence numbers
 1Ch	WORD	number of duplicate replies sent
 1Eh	WORD	number of acknowledgements sent
 20h	WORD	number of packets with bad request types
 22h	WORD	requests to attach to ws for which a request is being processed
 24h	WORD	requests to attach from ws which is already attaching
 26h	WORD	number of forged detach requests
 28h	WORD	detach requests with bad connection number
 2Ah	WORD	requests to detach from ws for which requests pending
 2Ch	WORD	number of cancelled replies
 2Eh	WORD	packets discarded due to excessive hop count
 30h	WORD	packets discarded due to unknown net
 32h	WORD	incoming packets discarded for lack of DGroup buffer
 34h	WORD	outgoing packets discarded due to lack of buffer
 36h	WORD	received packets destined for B,C, or D side drivers
 38h	DWORD	number of NetBIOS packets propagated through net
 3Ch	DWORD	total number of non-file-service packets
 40h	DWORD	total number of routed packets
Note:	all fields except the first are big-endian
--------N-21E3--SFE8-------------------------
INT 21 - Novell NetWare - FILE SERVER - GET FILE SERVER MISC INFORMATION
	AH = E3h subfn E8h
	DS:SI -> request buffer (see #1155)
	ES:DI -> reply buffer (see #1156)
Return: AL = status (00h,C6h) (see #1148)
Note:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AH=E3h/SF=0Eh,AH=E3h/SF=11h,AH=E3h/SF=CDh,AH=E3h/SF=E7h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1155)
 00h	WORD	0001h (length of following data)
 02h	BYTE	E8h (subfunction "Get File Server Misc Information")

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1156)
 00h	WORD	(call) size of following results buffer (max 0048h)
 02h	DWORD	(big-endian) clock ticks since system started
 06h	BYTE	CPU type
		00h Motorola 68000
		01h Intel 8086, 8088, or V20
		02h Intel 80286+
 07h	BYTE	reserved
 08h	BYTE	number of service processes in server
 09h	BYTE	server utilization in percent
 0Ah	WORD	(big-endian) maximum bindery objects set by configuration
		0000h = unlimited
 0Ch	WORD	(big-endian) maximum number of bindery objects used
 0Eh	WORD	(big-endian) current number of bindery objects in use
 10h	WORD	(big-endian) total server memory in KB
 12h	WORD	(big-endian) wasted server memory in KB
		normally 0000h
 14h	WORD	number of records following (01h-03h)
 16h	var	array of Dynamic Memory Information records (see #1157)

Format of NetWare Dynamic Memory Information:
Offset	Size	Description	(Table 1157)
 00h	DWORD	(big-endian) total dynamic space
 04h	DWORD	(big-endian) maximum dynamic space used
 08h	DWORD	(big-endian) current dynamic space usage
--------N-21E3--SFE9-------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET VOLUME INFORMATION
	AH = E3h subfn E9h
	DS:SI -> request buffer (see #1158)
	ES:DI -> reply buffer (see #1159)
Return: AL = status
	    00h successful
Notes:	this function is supported by Advanced NetWare 2.1+
SeeAlso: AH=DAh,AH=E2h/SF=15h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1158)
 00h	WORD	0002h (length of following data)
 02h	BYTE	E9h (subfunction "Get Volume Information")
 03h	BYTE	directory handle

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1159)
 00h	WORD	(call) 0028h (length of following results buffer)
 02h	DWORD	(big-endian) elapsed system time
 06h	BYTE	volume number
 07h	BYTE	logical drive number
 08h	WORD	(big-endian) sectors per block
 0Ah	WORD	(big-endian) starting block
 0Ch	WORD	(big-endian) total blocks on volume
 0Eh	WORD	(big-endian) blocks available on volume
 10h	WORD	(big-endian) total directory slots
 12h	WORD	(big-endian) directory slots available
 14h	WORD	(big-endian) maximum directory entries actually used
 16h	BYTE	flag: volume hashed if nonzero
 17h	BYTE	flag: volume cached if nonzero
 18h	BYTE	flag: volume removable if nonzero
 19h	BYTE	flag: volume mounted if nonzero
 1Ah 16 BYTEs	NUL-padded volume name
--------N-21E4-------------------------------
INT 21 O - Novell NetWare - SET FILE ATTRIBUTES (FCB)
	AH = E4h
	CL = file attributes (see #1160)
	DX:DX -> FCB (see #0486 at AH=0Fh)
Return: AL = error code
Note:	this function was added in NetWare 4.0, but was removed some time prior
	  to Advanced NetWare 2.15, and is no longer listed in current Novell
	  documentation
SeeAlso: AX=4301h

Bitfields for NetWare file attributes:
Bit(s)	Description	(Table 1160)
 0	read only
 1	hidden
 2	system
 7	shareable
--------v-21E4-------------------------------
INT 21 - VIRUS - "Anarkia" - INSTALLATION CHECK
	AH = E4h
Return: AH = 04h if resident
SeeAlso: AH=E1h"VIRUS",AH=E7h"VIRUS"
--------T-21E400-----------------------------
INT 21 - DoubleDOS - INSTALLATION CHECK/PROGRAM STATUS
	AX = E400h
Return: AL = program status
	    00h if DoubleDOS not present
	    01h if running in visible DoubleDOS partition
	    02h if running in the invisible DoubleDOS partition
SeeAlso: AH=E5h"DoubleDOS",AX=F400h
--------E-21E400-----------------------------
INT 21 - OS/286, OS/386 - CHAIN TO REAL-MODE HANDLER
	AX = E400h
	???
Return: ???
Note:	protected mode only???
--------E-21E402-----------------------------
INT 21 - OS/286, OS/386 - SET PROTECTED-MODE TASK GATE
	AX = E402h
	???
Return: ???
Note:	protected mode only???
SeeAlso: AX=E403h
--------E-21E403-----------------------------
INT 21 - OS/286, OS/386 - REMOVE PROTECTED-MODE TASK GATE
	AX = E403h
	???
Return: ???
Note:	protected mode only???
SeeAlso: AX=E402h
--------N-21E5-------------------------------
INT 21 O - Novell NetWare - UPDATE FILE SIZE (FCB)
	AH = E5h
	DS:DX -> FCB (see #0486 at AH=0Fh)
Return: AL = (unreliable) return code
Notes:	this function was added in NetWare 4.0, but was removed some time prior
	  to Advanced NetWare 2.15, and is no longer listed in current Novell
	  documentation
	on success, NetWare sets AL to zero; on errors it restores AL
--------T-21E5-------------------------------
INT 21 - DoubleDOS - OTHER PROGRAM STATUS
	AH = E5h
Return: AL = status
	    00h no program in other partition
	    01h program in other partition is running
	    02h program in other partition is suspended
SeeAlso: AX=E400h"DoubleDOS",AH=F5h"DoubleDOS"
--------E-21E500-----------------------------
INT 21 - OS/286, OS/386 - HEAP MANAGEMENT STRATEGY
	AX = E500h
	???
Return: ???
SeeAlso: AX=E501h
--------E-21E501-----------------------------
INT 21 - OS/286, OS/386 - FORCE HEAP COMPACTION
	AX = E501h
	???
Return: ???
SeeAlso: AX=E500h
--------N-21E6-------------------------------
INT 21 O - Novell NetWare - COPY FILE TO FILE (FCB)
	AH = E6h
	CX:DX = number of bytes to copy
	DS:SI -> opened source FCB
	ES:DI -> opened destination FCB
Return: AL = error code
	CX = ???
	DX = ???
Note:	this function was added in NetWare 4.0, but was removed some time prior
	  to Advanced NetWare 2.15, and is no longer listed in current Novell
	  documentation
--------E-21E6-------------------------------
INT 21 P - OS/286, OS/386 - ISSUE REAL PROCEDURE SIGNAL FROM PROTECTED MODE
	AH = E6h
	???
Return: ???
SeeAlso: AH=E2h"OS/286"
--------N-21E7-------------------------------
INT 21 - Novell NetWare - FILE SERVER - GET FILE SERVER DATE AND TIME
	AH = E7h
	DS:DX -> date/time buffer (see #1161)
Return: AL = error code
	    00h successful
	    FFh unsuccessful
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+,
	  Alloy NTNX, and Banyan VINES
SeeAlso: AH=2Ah,AH=2Ch,AX=5FC0h,AH=E3h/SF=CAh

Format of NetWare date/time buffer:
Offset	Size	Description	(Table 1161)
 00h	BYTE	year (80-99 = 1980-1999, 0-79 = 2000-2079)
 01h	BYTE	month (1=Jan)
 02h	BYTE	day
 03h	BYTE	hours
 04h	BYTE	minutes
 05h	BYTE	seconds
 06h	BYTE	day of week (0 = Sunday) (Novell and NTNX only)
--------E-21E7-------------------------------
INT 21 - OS/286, OS/386 - CREATE CODE SEGMENT
	AH = E7h
	???
Return: ???
SeeAlso: AH=E8h"OS/286",AH=E9h"OS/286",AH=EAh"OS/286"
--------v-21E7-------------------------------
INT 21 - VIRUS - "Spyer"/"Kiev" - INSTALLATION CHECK
	AH = E7h
Return: AH = 78h if resident
SeeAlso: AH=E4h"VIRUS",AX=EC59h
--------N-21E8-------------------------------
INT 21 O - Novell NetWare, Alloy NTNX - SET FCB RE-OPEN MODE
	AH = E8h
	DL = mode
	    00h no automatic re-open
	    01h auto re-open
Return: AL = error code
Desc:	provided backward compatibility with a bug in CP/M and early DOS vers
Note:	this function was added in NetWare 4.6, but was removed some time prior
	  to Advanced NetWare 2.15, and is no longer listed in current Novell
	  documentation
--------E-21E8-------------------------------
INT 21 - OS/286, OS/386 - SEGMENT CREATION
	AH = E8h
	AL = type
	    00h data segment
	    01h data window/alias
	    02h real segment
	    03h real window/alias
		CX:DX = size in bytes
		SI:BX -> start of desired memory block
		Return:	AX = selector
	    06h shareable segment
	???
Return: ???
SeeAlso: AH=E7h"OS/286",AH=E9h"OS/286"
--------T-21E8-------------------------------
INT 21 - DoubleDOS - SET/RESET KEYBOARD CONTROL FLAGS
	AH = E8h
	AL = program for which to set flags (00h this program, 01h other)
	DX = keyboard control flags (see #1162)
Return: DX = previous flags
Notes:	disabling Ctrl-PrtSc will allow the program to intercept the keystroke;
	  disabling any of the other keystrokes disables them completely
	identical to AH=F8h
SeeAlso: AH=E1h"DoubleDOS",AH=E2h"DoubleDOS",AH=E3h"DoubleDOS"
SeeAlso: AH=F8h"DoubleDOS"

Bitfields for DoubleDOS keyboard control flags:
Bit(s)	Description	(Table 1162)
 0	menu
 1	exchange
 2	entire keyboard enable/disable
 3	Ctrl-C
 4	Ctrl-PrtSc
 5	Alt/Erase
 6	Ctrl-Break
 7	Ctrl-NumLock
 8	shift-PrtSc
 9-13	undefined
 14	cancel key (clear keyboard buffer)
 15	suspend key
Note:	setting a enables the corresponding key or operatin, clearing a
	  disables it
--------E-21E9-------------------------------
INT 21 P - OS/286, OS/386 - CHANGE SEGMENTS
	AH = E9h
	AL = function
	    01h change code segment parameters
	    02h change data segment parameters
	    05h adjust segment limit
	    06h change segment base address
	???
Return: ???
SeeAlso: AH=E7h"OS/286",AH=E8h"OS/286",AH=EAh"OS/286",AH=EDh"OS/286"
SeeAlso: INT 31/AX=0007h,INT 31/AX=0008h
--------T-21E9-------------------------------
INT 21 - DoubleDOS - SET TIMESHARING PRIORITY
	AH = E9h
	AL = new priority (see #1163)
Return: AL = priority setting if AL=05h on entry
Note:	identical to AH=F9h
SeeAlso: AH=EAh"DoubleDOS",AH=EBh"DoubleDOS",AH=F9h"DoubleDOS"

(Table 1163)
Values for DoubleDOS timesharing priority:
 00h	visible program gets 70%, invisible gets 30% (default)
 01h	visible program gets 50%, invisible gets 50%
 02h	visible program gets 30%, invisible gets 70%
 03h	Top program gets 70%, bottom program gets 30%
 04h	Top program gets 30%, bottom program gets 70%
 05h	get current priority
--------N-21E900-----------------------------
INT 21 - Novell NetWare - DIRECTORY SERVICES - GET DIRECTORY HANDLE
	AX = E900h
	DX = drive number to check (0 = A:, ..., 25 = Z:, 26 ... 31)
Return: AL = directory handle
	AH = flags (drive not mapped if none set)
	    bit 0: permanent handle
	    bit 1: temporary handle
	    bit 7: mapped to local drive
Note:	this function is supported by NetWare 4.0+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E2h/SF=00h,AH=E2h/SF=01h,AH=E2h/SF=0Ah
--------N-21E905-----------------------------
INT 21 - Novell NetWare shell 3.01 - MAP A FAKE ROOT DIRECTORY
	AX = E905h
	BL = drive number (0=default, 1=A:, ...)
	DS:DX -> ASCIZ path for fake root (may include server name or be empty)
Return: CF set on error
	    AL = error code (03h,0Fh,11h) (see #0789 at AH=59h)
	CF clear if successful
Note:	if drive is not currently mapped, a drive mapping will be created
SeeAlso: AX=E906h
--------N-21E906-----------------------------
INT 21 - Novell NetWare shell 3.01 - DELETE FAKE ROOT DIRECTORY
	AX = E906h
	BL = drive number (0=default, 1=A:, ...)
Note:	drive remains mapped
SeeAlso: AX=E905h
--------N-21E907-----------------------------
INT 21 - Novell NetWare shell 3.01 - GET RELATIVE DRIVE DEPTH
	AX = E907h
	BL = drive number (0=default, 1=A:, ...)
Return: AL = number of directories below the fake root
	    FFh if no fake root assigned
SeeAlso: AX=E905h
--------N-21E908BL00-------------------------
INT 21 - Novell NetWare shell 3.01 - SET SHOW DOTS
	AX = E908h
	BL = 00h	don't return '.' or '..' during directory scans
	   = nonzero	directory scans will return '.' or '..' entries
Return: BL = previous show-dots setting
--------N-21E909-----------------------------
INT 21 - Novell NetWare - NetWare shell - CONVERT DOS FILE HANDLE TO NETWARE
	AX = E909h
	BX = DOS file handle
Return: AX = 0000h if successful
	    BX:CX:DX = NetWare file handle
Notes:	this function is partially a reverse of "AttachHandle" (AH=B4h)
	many NetWare 3.x functions use a four-byte file handle, which appears
	  to be the high four bytes of the six-byte NetWare handle
SeeAlso: AH=B4h"NetWare"
--------N-21EA-------------------------------
INT 21 - Novell NetWare, Alloy NTNX - RETURN SHELL VERSION
	AH = EAh
	AL = return version environment string
	    00h		don't return string
	    nonzero	return string in 40-byte buffer pointed to by ES:DI
		Return: buffer filled with three null-terminated entries:
			major operating system
			version
			hardware type
Return: AH = operating system (00h = MS-DOS)
	AL = hardware type
	    00h IBM PC
	    01h Victor 9000
	BH = major shell version
	BL = minor shell version
	CH = (v3.01+) shell type
	    00h conventional memory
	    01h expanded memory
	    02h extended memory
	CL = shell revision number
Note:	this function is supported by NetWare 4.6 and Advanced NetWare 1.0+
--------T-21EA-------------------------------
INT 21 - DoubleDOS - TURN OFF TASK SWITCHING
	AH = EAh
Return: task switching turned off
SeeAlso: AH=E9h"DoubleDOS",AH=EBh"DoubleDOS",AH=FAh"DoubleDOS"
SeeAlso: INT FA"DoubleDOS"
--------E-21EA-------------------------------
INT 21 - OS/286, OS/386 - ALLOCATE HUGE SEGMENT
	AH = EAh
	???
Return: ???
Note:	protected mode only???
SeeAlso: AH=E7h"OS/286",AH=E8h"OS/286",AH=E9h"OS/286"
--------N-21EB-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - LOG FILE
	AH = EBh
	DS:DX -> ASCIZ filename
	if function C6h lock mode 01h:
	    AL = flags
		00h log file only
		01h lock as well as log file
		    BP = lock timeout in timer ticks (1/18 second)
			0000h = don't wait if file already locked
Return: AL = status (see #1164)
Desc:	add the location and size of the specified file to the log table and
	  optionally lock the file
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=BCh"NetWare",AH=CAh,AH=D0h,AH=ECh"NetWare",AH=EDh"NetWare"

(Table 1164)
Values for NetWare status:
 00h	successful
 96h	no dynamic memory for file
 FEh	timed out
 FFh	failed
--------T-21EB-------------------------------
INT 21 - DoubleDOS - TURN ON TASK SWITCHING
	AH = EBh
Return: task switching turned on
SeeAlso: AH=E9h"DoubleDOS",AH=EAh"DoubleDOS",AH=FBh"DoubleDOS"
SeeAlso: INT FB"DoubleDOS"
--------E-21EB00-----------------------------
INT 21 - OS/386 VMM - GET A PAGE TABLE ENTRY BY LINEAR ADDRESS
	AX = EB00h
	???
Return: ???
Note:	protected mode only???
SeeAlso: AX=EB02h,AX=EB04h,INT 31/AX=0506h
--------E-21EB02-----------------------------
INT 21 - OS/386 VMM - GET A PAGE TABLE ENTRY BY 16-BIT SEGMENT:OFFSET
	AX = EB02h
	???
Return: ???
Note:	protected mode only???
SeeAlso: AX=EB00h,AX=EB04h
--------E-21EB03-----------------------------
INT 21 - OS/386 VMM - FREE MAPPED PAGES
	AX = EB03h
	???
Return: ???
Note:	protected mode only???
SeeAlso: AX=EB05h,INT 31/AX=0801h
--------E-21EB04-----------------------------
INT 21 - OS/386 VMM - GET A PAGE TABLE ENTRY BY 32-BIT SEGMENT:OFFSET
	AX = EB04h
	???
Return: ???
Note:	protected mode only???
SeeAlso: AX=EB00h,AX=EB02h
--------E-21EB05-----------------------------
INT 21 - OS/386 VMM - MAP PAGES
	AX = EB05h
	???
Return: ???
Note:	protected mode only???
SeeAlso: AX=EB03h,INT 31/AX=0800h
--------E-21EB06-----------------------------
INT 21 - OS/386 VMM - LOCK PAGES IN MEMORY
	AX = EB06h
	???
Return: ???
Note:	protected mode only???
SeeAlso: AX=EB07h,INT 31/AX=0600h
--------E-21EB07-----------------------------
INT 21 - OS/386 VMM - UNLOCK MEMORY PAGES
	AX = EB07h
	???
Return: ???
Note:	protected mode only???
SeeAlso: AX=EB06h,INT 31/AX=0601h
--------N-21EC-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - RELEASE FILE
	AH = ECh
	DS:DX -> ASCIZ filename
Return: AL = status
	    00h successful
	    FFh file not found
Desc:	unlock the specified file but retain it in the log table
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=CDh,AH=EBh"NetWare",AH=EDh"NetWare"
--------T-21EC-------------------------------
INT 21 - DoubleDOS - GET VIRTUAL SCREEN ADDRESS
	AH = ECh
Return: ES = segment of virtual screen
Desc:	determine the address of the virtual screen to which the program
	  should write instead of the actual video memory, so that the
	  multitasked programs do not interfere with each other's output
Notes:	screen address can change if task-switching is on!!
	identical to AH=FCh
SeeAlso: INT 10/AH=FEh,AH=FCh"DoubleDOS",INT FC"DoubleDOS"
--------E-21EC-------------------------------
INT 21 - OS/286, OS/386 - BLOCK TRANSFER
	AH = ECh
	???
Return: ???
--------v-21EC59-----------------------------
INT 21 - VIRUS - "Terror" - INSTALLATION CHECK
	AX = EC59h
Return: BP = EC59h if resident
SeeAlso: AH=E7h"VIRUS",AH=EEh"VIRUS"
--------N-21ED-------------------------------
INT 21 - Novell NetWare - SYNCHRONIZATION SERVICES - CLEAR FILE
	AH = EDh
	DS:DX -> ASCIZ filename
Return: AL = status
	    00h successful
	    FFh no files found
Desc:	unlock the file and remove it from the log table
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=CBh"NetWare",AH=CEh,AH=CFh,AH=EBh"NetWare",AH=ECh"NetWare"
--------E-21ED-------------------------------
INT 21 - OS/286, OS/386 - GET SEGMENT OR WINDOW DESCRIPTOR
	AH = EDh
	???
Return: ???
Note:	protected mode only???
SeeAlso: AH=E9h"OS/286"
--------N-21EE-------------------------------
INT 21 - Novell NetWare - CONNECTION SERVICES - GET PHYSICAL STATION ADDRESS
	AH = EEh
Return: CX:BX:AX = six-byte physical address
Note:	this function is supported by NetWare 4.6+, Advanced NetWare 1.0+, and
	  Alloy NTNX
SeeAlso: AH=E3h/SF=13h
--------T-21EE-------------------------------
INT 21 - DoubleDOS - GIVE AWAY TIME TO OTHER TASKS
	AH = EEh
	AL = number of 55ms time slices to give away
Return: returns after giving away time slices
SeeAlso: AH=FEh"DoubleDOS",INT FE"DoubleDOS"
--------v-21EE-------------------------------
INT 21 - VIRUS - "Jerusalem-G", "Pregnant" - INSTALLATION CHECK
	AH = EEh
Return: AX = 0300h if "Jerusalem-G" resident
	AL = 05h if "Pregnant" resident
SeeAlso: AH=DDh"VIRUS",AX=EC59h,AH=F0h"VIRUS"
--------N-21EF00-----------------------------
INT 21 - Novell NetWare - WORKSTATION - GET DRIVE HANDLE TABLE
	AX = EF00h
Return: ES:SI -> network shell's 32-byte drive handle table
	AX = 0000h
Notes:	this function is supported by Advanced NetWare 1.0+
	each byte in the drive handle table contains the directory handle for
	  the corresponding drive, or 00h if not mapped to a directory
SeeAlso: AX=EF01h,AX=EF02h,AX=EF03h,AX=EF04h
--------N-21EF01-----------------------------
INT 21 - Novell NetWare - WORKSTATION - GET DRIVE FLAG TABLE
	AX = EF01h
Return: ES:SI -> network shell's 32-byte drive flag table (see #1165)
	AX = 0000h
Notes:	this function is supported by Advanced NetWare 1.0+
	each byte in the drive flag table corresponds to a drive
SeeAlso: AX=EF00h,AX=EF02h,AX=EF03h

(Table 1165)
Values in NetWare drive flag table:
 00h	drive is not mapped
 01h	permanent network drive
 02h	temporary network drive
 80h	mapped to local drive
 81h	local drive used as permanent network drive
 82h	local drive used as temporary network drive
--------N-21EF02-----------------------------
INT 21 - Novell NetWare - WORKSTATION - GET DRIVE CONNECTION ID TABLE
	AX = EF02h
Return: ES:SI -> network shell's 32-byte drive conection ID table
	AX = 0000h
Notes:	this function is supported by Advanced NetWare 1.0+
	each byte in the connection ID table corresponds to a drive and
	  contains either the connection ID (1-8) of the server for that drive
	  or 00h if the drive is not mapped to a file server
SeeAlso: AX=EF01h,AX=EF03h,AX=F002h
--------N-21EF03-----------------------------
INT 21 - Novell NetWare - WORKSTATION - GET CONNECTION ID TABLE
	AX = EF03h
Return: ES:SI -> network shell's connection ID table (see #1166)
	AX = 0000h
Note:	this function is supported by Advanced NetWare 1.0+
SeeAlso: AX=EF00h,AX=EF02h,AX=EF04h,AX=F002h

Format of NetWare connection ID table [one entry of eight-element array]:
Offset	Size	Description	(Table 1166)
 00h	BYTE	in-use flag
		E0h AES temporary
		F8h IPX in critical section
		FAh processing
		FBh holding
		FCh AES waiting
		FDh waiting
		FEh receiving
		FFh sending
 01h	BYTE	order number assigned to server (1-8)
 02h	DWORD	(big-endian) file server's network address
 06h  6 BYTEs	(big-endian) file server's node address
 0Ch	WORD	(big-endian) socket number
 0Eh	WORD	(big-endian) base receive timeout in clock ticks
 10h  6 BYTEs	(big-endian) preferred routing node
 16h	BYTE	packet sequence number
 17h	BYTE	connection number (FFh = no connection)
 18h	BYTE	connection status (00h if active)
 19h	WORD	(big-endian) maximum receive timeout in clock ticks
 1Bh  5 BYTEs	reserved
--------N-21EF04-----------------------------
INT 21 - Novell NetWare - WORKSTATION - GET FILE SERVER NAME TABLE
	AX = EF04h
Return: ES:SI -> network shell's file server name table (see #1167)
	AX = 0000h
Note:	this function is supported by Advanced NetWare 1.0+
SeeAlso: AX=EF03h

Format of file server name table:
Offset	Size	Description	(Table 1167)
 00h 48 BYTEs	ASCIZ server name for first entry in connection ID table
 30h 48 BYTEs	ASCIZ server name for second entry in connection ID table
	...
150h 48 BYTEs	ASCIZ server name for eighth entry in connection ID table
--------T-21F0-------------------------------
INT 21 - DoubleDOS - MENU CONTROL
	AH = F0h
	AL = subfunction
	    01h exchange tasks
	    73h resume invisible job if suspended
	    74h kill other job
	    75h suspend invisible job
Note:	identical to AH=E0h
SeeAlso: AH=E0h"DoubleDOS"
--------v-21F0-------------------------------
INT 21 - VIRUS - "Frere Jacques" - INSTALLATION CHECK
	AH = F0h
Return: AX = 0300h if resident
SeeAlso: AH=EEh"VIRUS",AH=F1h"VIRUS"
--------N-21F000-----------------------------
INT 21 - Novell NetWare - WORKSTATION - SET PREFERRED CONNECTION ID
	AX = F000h
	DL = connection ID of prefered file server (1-8) or 00h for none
Notes:	this function is supported by Advanced NetWare 1.0+
	the preferred connection ID is set to 00h by the shell on EOJ
SeeAlso: AH=D6h,AX=EF03h,AX=F001h,AX=F002h,AX=F005h
--------N-21F001-----------------------------
INT 21 - Novell NetWare - WORKSTATION - GET PREFERRED CONNECTION ID
	AX = F001h
Return: AL = connection ID of preferred file server (1-8), 00h if not set
Notes:	this function is supported by Advanced NetWare 1.0+
	the preferred connection ID is set to 00h by the shell on EOJ
SeeAlso: AH=D6h,AX=EF03h,AX=F000h,AX=F002h,AX=F005h
--------N-21F002-----------------------------
INT 21 - Novell NetWare - WORKSTATION - GET DEFAULT CONNECTION ID
	AX = F002h
Return: AL = connection ID of current default file server (1-8) (see AX=EF03h)
Note:	this function is supported by Advanced NetWare 1.0+
SeeAlso: AX=EF03h,AX=F000h,AX=F004h
--------N-21F003-----------------------------
INT 21 - Novell NetWare - PRINT SERVICES - GET LPT CAPTURE STATUS
	AX = F003h
Return: AH = status
	    00h not active
	    FFh active
		AL = connection ID (01h-08h)
Note:	this function is supported by Advanced NetWare 1.0+
SeeAlso: AX=B800h,AX=B804h,AH=DFh/DL=00h,AH=DFh/DL=04h
--------N-21F004-----------------------------
INT 21 - Novell NetWare - WORKSTATION - SET PRIMARY CONNECTION ID
	AX = F004h
	DL = connection ID of primary file server (1-8) or 00h for none
Note:	this function is supported by Advanced NetWare 2.0+
SeeAlso: AH=D6h,AX=EF03h,AX=F000h,AX=F002h,AX=F005h
--------N-21F005-----------------------------
INT 21 - Novell NetWare - WORKSTATION - GET PRIMARY CONNECTION ID
	AX = F005h
Return: AL = connection ID of primary file server (1-8), 00h if not set
Notes:	this function is supported by Advanced NetWare 2.0+
	by default, the primary file server is the one from which the login
	  script executed; it is set to 00h if the workstation is not logged in
	  and when it detaches from its primary file server
SeeAlso: AH=D6h,AX=EF03h,AX=F000h,AX=F002h,AX=F004h
--------N-21F1-------------------------------
INT 21 - Novell NetWare - CONNECTION SERVICES - FILE SERVER CONNECTION
	AH = F1h
	AL = subfunction
	    00h attach to file server
		DL = preferred file server (01h-08h)
	    01h detach from file server
		DL = connection ID
	    02h logout from file server
		DL = connection ID
Return: AL = status (see #1168)
Note:	these functions are supported by Advanced NetWare 1.0+
SeeAlso: AH=D7h"NetWare",AH=E3h/SF=14h

(Table 1168)
Values for NetWare function status:
 00h	successful
 F8h	already attached to server
 F9h	connection table full
 FAh	no more server slots
 FCh	unknown file server
 FEh	server bindery locked
 FFh	no response from server, or connection does not exist
--------T-21F1-------------------------------
INT 21 - DoubleDOS - CLEAR KEYBOARD BUFFER FOR CURRENT JOB
	AH = F1h
SeeAlso: AH=E1h"DoubleDOS",AH=F2h"DoubleDOS",AH=F3h"DoubleDOS"
SeeAlso: AH=F8h"DoubleDOS"
--------v-21F1-------------------------------
INT 21 - VIRUS - "F1-337" - ???
	AH = F1h
	???
Return: ???
SeeAlso: AH=F0h"VIRUS",AX=F1E9h
--------v-21F1E9-----------------------------
INT 21 - VIRUS - "Tremor" - INSTALLATION CHECK
	AX = F1E9h
Return: AX = installation state
	    CADEh installed, and calling program is infected
	    F100h not installed (normal DOS return value)
	    else  installed, but calling program is not infected
SeeAlso: AH=F1h"VIRUS",AX=F2AAh
--------N-21F2-------------------------------
INT 21 u - Novell NetWare v3.01+ shell interface - MULTIPLEXOR
	AH = F2h
	AL = function (see #1169)
	    (subfunction stored at DS:SI for AL=56h,57h,
	      DS:SI+2 for AL=15h-17h,23h)
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (contents vary by function)
	ES:DI -> reply buffer (contents vary by function)
Return: AL = status
	reply buffer filled as appropriate for function
Note:	this is a multiplexor providing a "raw" interface to the underlying
	  NetWare Core Protocol.  Many functions which were accessed via a
	  separate AH function in older versions can also be accessed here,
	  but some NetWare 3.x calls appear to be available only here.
SeeAlso: AX=F244h

(Table 1169)
Values for NetWare Core Protocol functions:
Fnc/Subfn	Description
01h	File Set Lock
02h	File Release Lock
03h	Log File (see AH=EBh"NetWare")
04h	Lock File Set (see AH=CBh"NetWare")
05h	Release File (see AH=CCh,AH=ECh"NetWare")
06h	Release File Set (see AH=CDh"NetWare")
07h	Clear File (see AH=CEh,AH=EDh"NetWare")
08h	Clear File Set (see AH=CFh"NetWare")
09h	Log Logical Record (see AH=D0h"NetWare")
0Ah	Lock Logical Record Set (see AH=D1h"NetWare")
0Bh	Clear Logical Record (see AH=D4h"NetWare")
0Ch	Release Logical Record (see AH=D2h"NetWare")
0Dh	Release Logical Record Set (see AH=D3h"NetWare")
0Eh	Clear Logical Record Set (see AH=D5h"NetWare")
0Fh	Allocate Resource (see AH=D8h"NetWare")
10h	Deallocate Resource (see AH=D9h"NetWare")
11h/0Ah	Get Printer Queue
11h/xxh	print spooling (see AX=E0xxh"NetWare")
12h	Get Volume Info with Number (see AH=DAh"NetWare")
13h	Get Station Number (see AH=DCh"NetWare")
14h	Get File Server Date and Time (see AH=E7h"NetWare")
15h/xxh	broadcast services (see AX=E1xxh"NetWare")
16h/0Fh	Rename Directory
16h/1Bh	Scan Salvagable Files
16h/1Ch	Recover Salvagable File
16h/1Dh	Purge Salvagable File
16h/1Eh	Scan Dir Entry
16h/1Fh	Get Dir ENtry
16h/20h	Scan Volume for Restrictions
16h/21h	Add User Disk Space Restriction (see AX=F216h/SF=21h)
16h/22h	Clear Volume Restrictions
16h/23h	Scan Dir Restrictions
16h/24h	Set Directory Disk Space Restriction (see AX=F216h/SF=24h)
16h/25h	Set Entry
16h/26h	Scan File or Directory For Extended Trustees (see AX=F216h/SF=26h)
16h/27h	Add Extended Trustee to Directory or File (see AX=F216h/SF=27h)
16h/28h	Scan File Physical
16h/29h	Get Object Disk Restrictions (see AX=F216h/SF=29h)
16h/2Ah	Get Effective Rights
16h/2Bh	Delete Trustee
16h/2Ch	Get Volume Usage
16h/2Dh	Get Dir Info
16h/2Eh	Move Entry
16h/2Fh	Fill Name Space Buffer
16h/30h	Get Name Space Entry
16h/31h	Open Data Stream
16h/32h	Get Object Effective Rights
16h/33h	Get Extended Volume Info
16h/F3h	Map Directory Number to Path
16h/xxh file/directory services (see AX=E2xxh"NetWare")
17h/17h	Get Encryption Key
17h/18h	Login Object Encrypted
17h/1Ch	Get Connection Information (see AX=F217h/SF=1Ch)
17h/1Fh	Get Connection List from Object
17h/48h	Get Bindery Object Access Level
17h/49h	Is Station a Manager?
17h/4Ah	Verify Bindery Object Password Encrypted
17h/4Bh	Change Bindery Object Password Encrypted
17h/4Ch	Get Relation of an Object
17h/D2h Clear Connection Number (Logout Station) (see AX=F217h/SF=D2h)
17h/EBh	Get Connection's Open Files (see AX=F217h/SF=EBh)
17h/ECh	Get Connections Using a File (see AX=F217h/SF=ECh)
17h/EEh	Get Physical Record Locks by File (see AX=F217h/SF=EEh)
17h/F2h Get Semaphore Information (see AX=F217h/SF=F2h)
17h/F3h Map Directory Number to Path (see AX=F217h/SF=F3h)
17h/F4h	Convert Path to Directory Entry (see AX=F217h/SF=F4h)
17h/xxh	connection control (see AX=E3xxh"NetWare")
18h	End of Job (see AH=D6h"NetWare")
19h	Logout (see AH=D7h"NetWare")
1Ah	Log Physical Record (see AH=BCh"NetWare")
1Bh	Lock Physical Record Set (see AH=C2h"NetWare")
1Ch	Release Physical Record (see AH=BDh"NetWare")
1Dh	Release Physical Record Set (see AH=C3h"NetWare")
1Eh	Clear Physical Record (see AH=BEh"NetWare")
1Fh	Clear Physical Record Set (see AH=C4h"NetWare")
20h/xxh	semaphore services (see AX=C5xxh"NetWare")
21h	Negotiate Buffer
22h/00h	TTS Is Available (see AX=C702h"NetWare")
22h/01h	TTS Begin Transaction (see AX=C700h"NetWare")
22h/02h	TTS End Transaction (see AX=C701h"NetWare")
22h/03h	TTS Abort Transaction (see AX=C703h"NetWare")
22h/04h	TTS Transaction Status (see AX=C704h"NetWare")
22h/05h	TTS Get Application Thresholds (see AX=C705h"NetWare")
22h/06h	TTS Set Application Thresholds (see AX=C706h"NetWare")
22h/07h	TTS Get Workstation Thresholds (see AX=C707h"NetWare")
22h/08h	TTS Set Workstation Thresholds (see AX=C708h"NetWare")
22h/09h	TTS Get Control Flags
22h/0Ah	TTS Set Control Flags
23h/01h	AFP Create Directory
23h/02h	AFP Create File
23h/03h	AFP Delete
23h/04h	AFP Get Entry ID From Name
23h/05h	AFP Get FIle Infomration
23h/06h	AFP Get Entry ID From NetWare Handle
23h/07h	AFP Rename
23h/08h	AFP Open File Fork
23h/09h	AFP Set File Information
23h/0Ah	AFP Scan File Information
23h/0Bh	AFP Alloc Temporary Dir Handle
23h/0Ch	AFP Get Entry ID From Path Name
3Dh	Commit File
3Eh	File Search Initialize (FindFirst)
3Fh	File Search Continue (FindNext)
40h	Search File
42h	File Close
43h	File Create
44h	Erase Files
45h	File Rename
46h	Set File Attributes
47h	Get File Size
48h	File Read
49h	File Write
4Ah	File Server Copy (see AH=F3h"NetWare")
4Bh	Set File Time and Date
4Ch	File Open
4Dh	Create New File
4Eh	Allow Task Access to File
4Fh	Set Extended File Attributes (see AH=B6h"NetWare")
55h	Get File Bit Map
56h/xx	extended attribute services (OS/2)
56h/01h	close extended attribute
56h/02h	write extended attribute
56h/03h	read extended attribute
56h/04h	enumerate extended attribute
56h/05h	duplicate EA
57h/01h	open/create file/directory
57h/02h	init search, continue with 57h/03h
57h/03h	Scan NS Entry Info
57h/04h	rename file/directory
57h/05h	scan for trustees
57h/06h	Get NS Entry Info (see AX=F257h/SF=06h)
57h/07h	Set NS Entry DOS Info
57h/08h	delete file/directory
57h/09h	set short directory handle
57h/0Ah	Add Trustee
57h/0Bh	Delete Trustee
57h/0Ch	Allocate Temp NS Dir Handle
57h/13h	Read NS Info
57h/15h	get path string for short directory handle
57h/16h	Get Directory Base
57h/17h	Get NS Info
57h/19h	Write NS Info
57h/1Ah	Read Extended NS Info
57h/1Bh	Write Extended NS Infor
57h/1Ch	Get NS Path
57h/1Dh	Get Effective Rights
58h/01h	Get Volume Audit Statistics
58h/02h	Add Audit Property
58h/03h	Login as Volume Auditor
58h/04h Change Auditor Password
58h/05h Check Audit Access
58h/06h	Remove Audit Property
58h/07h	Disable Auditing on Volume
58h/08h	Enable Auditing on Volume
58h/09h	Is User Audited?
58h/0Ah	Read Auditing Bit Map
58h/0Bh	Read Audit Config Header
58h/0Dh	Logout as Volume Auditor
58h/0Eh	Reset Auditing File
58h/0Fh	Reset Audit History File
58h/10h	Write Auditing Bit Map
58h/11h	Write Audit Config Header
58h/13h	Get Auditing Flags
58h/14h	Close Old Auditing File
58h/15h	Delete Old Auditing File
58h/16h	Check Audit Level Two Access
5Ah/01h	Get DM Info
61h	Negotiate LIP Buffer, packet signing, and IPX checksums
65h	Packet Burst Connection
68h/xxh NetWare 4.x directory services (subfn at DS:[SI+11h])
68h/01h NDS resolve name
68h/03h	NDS read property
68h/35h NDS get server address
68h/36h NDS set keys
68h/39h NDS begin login
68h/3Ah NDS finish login
68h/3Bh NDS begin authenticate
68h/3Ch NDS finish authenticate
7Bh/01h	Get Cache Information
7Bh/02h	Get File Server Information
7Bh/03h	Get NetWare File Systems Information
7Bh/04h	Get User Information
7Bh/05h	Get Packet Burst Information
7Bh/06h	Get IPX/SPX Information
7Bh/07h	Get Garbage Collection Information
7Bh/08h	Get CPU Information
7Bh/09h	Get Volume Switch Information
7Bh/0Ah	Get NLM Loaded List
7Bh/0Bh	Get NLM Information
7Bh/0Ch	Get Directory Cache Information
7Bh/0Dh	Get OS Version Information
7Bh/0Eh	Get Active Connection List by Type
7Bh/0Fh	Get NLM's Resource Tag List
7Bh/14h	Get Active LAN Board List
7Bh/15h	Get LAN Configuration Information
7Bh/16h	Get LAN Common Counters Information
7Bh/17h	Get LAN Custom Counters Information
7Bh/18h	Get LAN Config Strings
7Bh/19h	Get LSL Informatino
7Bh/1Ah	Get LSL Logical Board Statistics
7Bh/1Eh	Get Media Manager Object Information
7Bh/1Fh	Get Media Manager Object List
7Bh/20h	Get Media Manager Object Children List
7Bh/21h	Get Volume Segment List
7Bh/28h	Get Active Protocol Stacks
7Bh/29h	Get Protocol Stack Configuration Information
7Bh/2Ah	Get Protocol Stack Statistics Information
7Bh/2Bh	Get Protocol Stack Custom Information
7Bh/2Ch	Get Protocol Stack Numbers By Media Number
7Bh/2Dh	Get Protocol Stack Numbers By LAN Board Number
7Bh/2Eh	Get Media Name by Media Number
7Bh/2Fh	Get Loaded Media Number List
7Bh/32h	Get General Router and SAP Information
7Bh/33h	Get Network Router Information
7Bh/34h	Get Network Routers Information
7Bh/35h	Get Known Networks Information
7Bh/36h	Get Server Information
7Bh/38h	Get Known Servers Information
7Bh/3Ch	Get Server Set Commands Information
7Bh/3Dh	Get Server Set Categories
Note:	the subfunction is stored at DS:SI for AL=56h,57h, DS:SI+2 for
	  AL=15h-17h,23h
--------T-21F2-------------------------------
INT 21 - DoubleDOS - SEND CHARACTER TO KEYBOARD BUFFER OF OTHER JOB
	AH = F2h
	AL = character
Return: AL = status
	    00h successful
	    01h buffer full (128 characters)
SeeAlso: AH=E2h"DoubleDOS",AH=F1h"DoubleDOS",AH=F3h"DoubleDOS"
SeeAlso: AH=F8h"DoubleDOS"
--------N-21F216SF21-------------------------
INT 21 - Novell NetWare v3+ - ADD USER DISK SPACE RESTRICTION
	AX = F216h subfn 21h
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1170)
	ES:DI -> reply buffer (ignored)
Return: AL = status
SeeAlso: AX=F216h/SF=24h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1170)
 00h	WORD	000Ah (length of following data)
 02h	BYTE	21h (subfunction "Add User Disk Space Restriction")
 03h	BYTE	volume number
 04h	DWORD	(big-endian) object ID
 08h	DWORD	(big-endian) disk space limit in 4K blocks
		00000000h to 40000000h
--------N-21F216SF24-------------------------
INT 21 - Novell NetWare v3+ - SET DIRECTORY DISK SPACE RESTRICTION
	AX = F216h subfn 24h
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1171)
	ES:DI -> reply buffer (ignored)
Return: AL = status
SeeAlso: AX=F216h/SF=21h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1171)
 00h	WORD	0006h (length of following data)
 02h	BYTE	24h (subfunction "Set Directory Disk Space Restriction")
 03h	BYTE	directory handle
 04h	DWORD	(big-endian) disk space limit in 4K blocks
		00000000h to remove restriction, negative to set to 0 blocks
--------N-21F216SF26-------------------------
INT 21 - Novell NetWare v3+ - SCAN FILE OR DIRECTORY FOR EXTENDED TRUSTEES
	AX = F216h subfn 26h
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1172)
	ES:DI -> reply buffer (see #1173)
Return: AL = status
Desc:	get up to 20 extended trustee entries per call for a file or directory

Format of NetWare request buffer:
Offset	Size	Description	(Table 1172)
 00h	WORD	length of following data
 02h	BYTE	26h (subfunc "Scan File or Directory For Extended Trustees")
 03h	BYTE	directory handle
 04h	BYTE	sequence number
		00h for first call, increment by number of returned entries
 05h	BYTE	length of path
 06h  N BYTEs	pathname

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1173)
 00h	BYTE	number of entries returned (max 20)
 01h 20 DWORDs	(big-endian) list of object IDs
 51h 20 WORDs	list of associated trustee rights
--------N-21F216SF27-------------------------
INT 21 - Novell NetWare v3+ - ADD EXTENDED TRUSTEE TO DIRECTORY OR FILE
	AX = F216h subfn 27h
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1174)
	ES:DI -> reply buffer (ignored)
Return: AL = status

Format of NetWare request buffer:
Offset	Size	Description	(Table 1174)
 00h	WORD	length of following data
 02h	BYTE	27h (subfunction "Add Extended Trustee to Directory or File")
 03h	BYTE	directory handle
 04h	DWORD	(big-endian) object ID
 08h	WORD	trustee rights (see #1175)
 0Ah	BYTE	path length
 0Bh  N BYTEs	path name

Bitfields for NetWare trustee rights:
Bit(s)	Description	(Table 1175)
 0	read
 1	write
 3	create
 4	delete
 5	access
 6	file
 7	modify
 8	supervisor
--------N-21F216SF29-------------------------
INT 21 - Novell NetWare v3+ - GET OBJECT DISK RESTRICTIONS
	AX = F216h subfn 29h
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1176)
	ES:DI -> reply buffer (see #1177)
Return: AL = status
	reply buffer filled
Note:	this function returns successfully, showing no restriction, if an
	  invalid object ID is specified
SeeAlso: AX=F216h/SF=24h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1176)
 00h	WORD	0006h (length of following data)
 02h	BYTE	21h (subfunction "Get Object Disk Restrictions")
 03h	BYTE	volume number
 04h	DWORD	(big-endian) object ID

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1177)
 00h	DWORD	disk space limit
 04h	DWORD	disk space currently in use by object
--------N-21F217SF1C-------------------------
INT 21 - Novell NetWare v3+ - GET CONNECTION INFORMATION
	AX = F217h subfn 1Ch
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1178)
	ES:DI -> reply buffer (see #1179)
Return: AL = status
	reply buffer filled

Format of NetWare request buffer:
Offset	Size	Description	(Table 1178)
 00h	WORD	0005h (length of following data)
 02h	BYTE	1Ch (subfunction "Get Connection Information")
 03h	DWORD	target connection number
Note:	connection numbers greater than the maximum supported by the server
	  can cause ABENDs

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1179)
 00h	DWORD	(big-endian) unique user ID, 00000000h if no one logged in
 04h	WORD	(big-endian) user type
 06h 48 BYTEs	user name
 36h  7 BYTEs	login time (see #1161)
 3Dh	BYTE	reserved
--------N-21F217SFD2-------------------------
INT 21 - Novell NetWare v3+ - CLEAR CONNECTION NUMBER (LOGOUT STATION)
	AX = F217h subfn D2h
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1180)
	ES:DI -> reply buffer (ignored)
Return: AL = status
	reply buffer filled

Format of NetWare request buffer:
Offset	Size	Description	(Table 1180)
 00h	WORD	0002h (length of following data)
 02h	BYTE	D2h (subfunction "Clear Connection Number")
 03h	BYTE	connection number
--------N-21F217SFEB-------------------------
INT 21 - Novell NetWare v3+ - GET CONNECTION'S OPEN FILES
	AX = F217h subfn EBh
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1181)
	ES:DI -> reply buffer (see #1182)
Return: AL = status
	reply buffer filled

Format of NetWare request buffer:
Offset	Size	Description	(Table 1181)
 00h	WORD	0005h (length of following data)
 02h	BYTE	EBh (subfunction "Get Connection's Open Files")
 03h	WORD	target connection number
 05h	WORD	last record seen (set to 0000h for first call)
Note:	connection numbers greater than the maximum supported by the server
	  can cause ABENDs

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1182)
 00h	WORD	next request record
 02h	WORD	number of records returned (max 28)
 04h 29N BYTEs	array of connection records (see #1183)

Format of NetWare connection record:
Offset	Size	Description	(Table 1183)
 00h	WORD	task number
 02h	BYTE	lock type
 03h	BYTE	access control
 04h	BYTE	lock flag
 05h	BYTE	volume number
 06h	DWORD	parent directory entry number
 0Ah	DWORD	directory entry number
 0Eh	BYTE	reserved
 0Fh	BYTE	data stream type
 10h	BYTE	file name length
 11h 12 BYTEs	file name
--------N-21F217SFEC-------------------------
INT 21 - Novell NetWare v3+ - GET CONNECTIONS USING A FILE
	AX = F217h subfn ECh
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1184)
	ES:DI -> reply buffer (see #1185)
Return: AL = status
	reply buffer filled

Format of NetWare request buffer:
Offset	Size	Description	(Table 1184)
 00h	WORD	0009h (length of following data)
 02h	BYTE	ECh (subfunction "Get Connections Using a File")
 03h	BYTE	data stream type
 04h	BYTE	volume number
 05h	DWORD	directory entry number
 09h	WORD	last record seen (0000h for first call)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1185)
 00h	WORD	next request record
 02h	WORD	use count
 04h	WORD	open count
 06h	WORD	number of times open for reading
 08h	WORD	number of times open for writing
 0Ah	WORD	Deny Read count
 0Ch	WORD	Deny Write count
 0Eh	BYTE	flag: locked
 0Fh	BYTE	data stream type
 10h	WORD	number of records returned (max 70)
 12h 7N BYTEs	returned records (see #1186)

Format of returned record:
Offset	Size	Description	(Table 1186)
 00h	WORD	connection number
 02h	WORD	task number
 04h	BYTE	lock type
 05h	BYTE	access flag
 06h	BYTE	lock flag
--------N-21F217SFEE-------------------------
INT 21 - Novell NetWare v3+ - GET PHYSICAL RECORD LOCKS BY FILE
	AX = F217h subfn EEh
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1187)
	ES:DI -> reply buffer (see #1188)
Return: AL = status
	reply buffer filled

Format of NetWare request buffer:
Offset	Size	Description	(Table 1187)
 00h	WORD	0009h (length of following data)
 02h	BYTE	EEh (subfunction "Get Physical Record Locks by File")
 03h	BYTE	data stream number
 04h	BYTE	volume number
 05h	DWORD	directory entry number
 09h	WORD	last record seen (0000h for first call)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1188)
 00h	WORD	next request record
 02h	WORD	number of locks
 04h 17N BYTEs	array of lock records, one per lock (see #1189)

Format of NetWare lock record:
Offset	Size	Description	(Table 1189)
 00h	WORD	logged count
 02h	WORD	number of shareable locks
 04h	DWORD	start offset of record
 08h	DWORD	end offset of record
 0Ch	WORD	logical connection number
 0Eh	WORD	task number
 10h	BYTE	lock type
--------N-21F217SFF2-------------------------
INT 21 - Novell NetWare v3+ - GET SEMAPHORE INFORMATION
	AX = F217h subfn F2h
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1190)
	ES:DI -> reply buffer (see #1191)
Return: AL = status
	reply buffer filled

Format of NetWare request buffer:
Offset	Size	Description	(Table 1190)
 00h	WORD	length of following data (max 84h)
 02h	BYTE	F2h (subfunction "Get Semaphore Information")
 03h	WORD	last record seen (0000h on first call)
 05h	BYTE	length of semaphore name (max 128)
 06h  N BYTEs	semaphore name

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1191)
 00h	WORD	next request record
 02h	WORD	open count
 04h	BYTE	value of semaphore
 05h	WORD	number of records returned
 07h 2N WORDs	list of logical connection number/task number pairs
--------N-21F217SFF3-------------------------
INT 21 - Novell NetWare v3+ - MAP DIRECTORY NUMBER TO PATH
	AX = F217h subfn F3h
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1192)
	ES:DI -> reply buffer (see #1193)
Return: AL = status
	reply buffer filled
SeeAlso: AX=F217h/SF=F4h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1192)
 00h	WORD	0007h (length of following data)
 02h	BYTE	F3h (subfunction "Map Directory Number to Path")
 03h	BYTE	volume number
 04h	DWORD	directory entry number
 08h	BYTE	name space type

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1193)
 00h	BYTE	directory path length
 01h  N BYTEs	directory path (NetWare style, separated by length descriptors
		  rather than slashes or backslashes)
--------N-21F217SFF4-------------------------
INT 21 - Novell NetWare v3+ - CONVERT PATH TO DIRECTORY ENTRY
	AX = F217h subfn F4h
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1194)
	ES:DI -> reply buffer (see #1195)
Return: AL = status
	reply buffer filled
SeeAlso: AX=F217h/SF=F3h

Format of NetWare request buffer:
Offset	Size	Description	(Table 1194)
 00h	WORD	length of following data
 02h	BYTE	F4h (subfunction "Convert Path to Directory Entry")
 03h	BYTE	directory handle or 00h for none
 04h	BYTE	length of directory path
 05h  N BYTEs	directory path (must be fully qualified if no handle specified)

Format of NetWare reply buffer:
Offset	Size	Description	(Table 1195)
 00h	BYTE	(return) volume number
 01h	DWORD	(return) directory entry number
--------N-21F244-----------------------------
INT 21 - Novell NetWare - FILE SERVICES - ERASE FILES
	AX = F244h
	DS:SI -> request buffer (see #1197)
	ES:DI -> reply buffer (ignored???)
Return: AL = status (see #1196)
Note:	this function only marks the file for deletion; use AH=E2h/SF=CEh to
	  actually delete all marked files
SeeAlso: AH=13h,AH=41h,AH=E2h/SF=0Bh,AH=E3h/SF=CEh

(Table 1196)
Values for NetWare function status:
 00h	successful
 98h	nonexistent volume
 9Bh	invaid directory handle
 9Ch	invalid path
 FFh	no files found

Format of NetWare request buffer:
Offset	Size	Description	(Table 1197)
 00h	BYTE	directory handle
 01h	BYTE	search attributes (see #0554 at AX=4301h)
 02h	BYTE	length of filespec
 03h  N BYTEs	ASCIZ filespec (may include wildcards)
--------N-21F257SF06-------------------------
INT 21 - Novell NetWare v3+ - GET INFORMATION ABOUT FILE OR DIRECTORY
	AX = F257h subfn 06h
	CX = length of request buffer in bytes
	DX = length of reply buffer in bytes
	DS:SI -> request buffer (see #1198)
	ES:DI -> reply buffer (see #1200)
Return: AL = status
	reply buffer filled

Format of NetWare request buffer:
Offset	Size	Description	(Table 1198)
 00h	BYTE	06h (subfunction "Get NS Entry Info")
 01h	BYTE	name space
 02h	BYTE	destination name space
 03h	WORD	search attributes
 05h	DWORD	return information mask (see #1199)
 09h	BYTE	volume number
 0Ah	DWORD	directory base
 0Eh	BYTE	handle flag
		00h first byte of dir base is dir handle; ignore volume number
		01h dir base = unique ID, volume number set
		FFh volume number and dir base ignored, volume part of path
 0Fh	BYTE	number of path components
 10h  N BYTEs	list of path components (each a counted string)

Bitfields for return information mask:
Bit(s)	Description	(Table 1199)
 0	include filename
 1	data stream space allocated info
 2	attributes info
 3	data stream size info
 4	total space allocated for all data streams
 5	extended attributes info
 6	archive info
 7	modify info
 8	create info
 9	name space info
 10	directory info
 11	rights info

Format of NetWare reply buffer for name space info:
Offset	Size	Description	(Table 1200)
 00h 72 BYTEs	reserved
 48h	DWORD	creator's name space number
 4Ch 257 BYTEs	reserved
--------v-21F2AA-----------------------------
INT 21 - VIRUS - "PcVrsDs" - INSTALLATION CHECK
	AX = F2AAh
Return: AH = AAh if resident
SeeAlso: AH=F1h"VIRUS",AH=F3h"VIRUS"
--------N-21F3-------------------------------
INT 21 - Novell NetWare - FILE SERVICES - FILE SERVER FILE COPY
	AH = F3h
	ES:DI -> request buffer (see #1201)
Return: AL = status/error code
	CX:DX = number of bytes copied
Notes:	this function is supported by Advanced NetWare 2.0+
	both source and destination must be on the same file server
SeeAlso: AH=3Ch,AH=3Fh

Format of NetWare request buffer:
Offset	Size	Description	(Table 1201)
 00h	WORD	source file handle (as returned by AH=3Ch or AH=3Dh)
 02h	WORD	destination file handle
 04h	DWORD	starting offset in source
 08h	DWORD	starting offset in destination
 0Ch	DWORD	number of bytes to copy
--------T-21F3-------------------------------
INT 21 - DoubleDOS - ADD CHARACTER TO KEYBOARD BUFFER OF CURRENT JOB
	AH = F3h
	AL = character
Return: AL = 00h successful
	     01h buffer full (128 characters)
SeeAlso: AH=E3h"DoubleDOS",AH=F1h"DoubleDOS",AH=F2h"DoubleDOS"
SeeAlso: AH=F8h"DoubleDOS"
--------v-21F3-------------------------------
INT 21 - VIRUS - "Carfield" - INSTALLATION CHECK
	AH = F3h
Return: AX = 0400h if resident
SeeAlso: AH=D5h"Carfield",AX=F2AAh,AH=F7h"VIRUS"
--------T-21F400-----------------------------
INT 21 - DoubleDOS - INSTALLATION CHECK/PROGRAM STATUS
	AX = F400h
Return: AL = program status
	    00h if DoubleDOS not present
	    01h if running in visible DoubleDOS partition
	    02h if running in the invisible DoubleDOS partition
SeeAlso: AX=E400h,AH=F5h"DoubleDOS"
--------T-21F5-------------------------------
INT 21 - DoubleDOS - OTHER PROGRAM STATUS
	AH = F5h
Return: AL = program status
	    00h no program in other partition
	    01h program in other partition is running
	    02h program in other partition is suspended
SeeAlso: AH=E5h"DoubleDOS",AX=F400h"DoubleDOS"
--------v-21F7-------------------------------
INT 21 - VIRUS - "GP1" - INSTALLATION CHECK
	AH = F7h
Return: AX = 0300h if resident
SeeAlso: AH=F0h"VIRUS",AH=FBh"VIRUS"
--------D-21F8-------------------------------
INT 21 - DOS v2.11 - SET OEM INT 21 HANDLER
	AH = F8h
	DS:DX -> OEM INT 21 handler for functions F9h to FFh
		 FFFFh:FFFFh disables OEM handler
Notes:	this function is supported by Toshiba T1000 ROM MS-DOS 2.11
	calls to AH=F9h through AH=FFH will return AL=00h if no handler set
	handler is called with all registers exactly as set by caller, and
	  should exit with IRET
SeeAlso: AH=F9h"OEM"
--------T-21F8-------------------------------
INT 21 - DoubleDOS - SET/RESET KEYBOARD CONTROL FLAGS
	AH = F8h
	AL = program for which to set flags
	    00h this program
	    01h other program
	DX = keyboard control flags (see #1162 at AH=E8h"DoubleDOS")
Return: DX = previous flags
Notes:	disabling Ctrl-PrtSc will allow the program to intercept the keystroke;
	  disabling any of the other keystrokes disables them completely
	this function is identical to AH=E8h
SeeAlso: AH=E8h"DoubleDOS",AH=F1h"DoubleDOS",AH=F2h"DoubleDOS"
SeeAlso: AH=F3h"DoubleDOS"
--------D-21F9-------------------------------
INT 21 - DOS v2.11 - OEM FUNCTION
	AH = F9h
SeeAlso: AH=F8h"OEM",AH=FAh"OEM"
--------T-21F9-------------------------------
INT 21 - DoubleDOS - SET TIMESHARING PRIORITY
	AH = F9h
	AL = priority
	    00h visible program gets 70%, invisible gets 30% (default)
	    01h visible program gets 50%, invisible gets 50%
	    02h visible program gets 30%, invisible gets 70%
	    03h Top program gets 70%, bottom program gets 30%
	    04h Top program gets 30%, bottom program gets 70%
	    05h get current priority
		Return: AL = priority setting
Note:	identical to AH=E9h
SeeAlso: AH=E9h"DoubleDOS",AH=FAh"DoubleDOS",AH=FBh"DoubleDOS"
--------D-21FA-------------------------------
INT 21 - DOS v2.11 - OEM FUNCTION
	AH = FAh
SeeAlso: AH=F8h"OEM",AH=F9h"OEM",AH=FBh"OEM"
--------T-21FA-------------------------------
INT 21 - DoubleDOS - TURN OFF TASK SWITCHING
	AH = FAh
Return: task switching turned off
SeeAlso: AH=EAh"DoubleDOS",AH=F9h"DoubleDOS",AH=FBh"DoubleDOS"
SeeAlso: INT FA"DoubleDOS"
--------v-21FA--DX5945-----------------------
INT 21 U - PC Tools v7+ VDEFEND, VSAFE, VWATCH - API
	AH = FAh
	DX = 5945h
	AL = function (00h-02h for VDEFEND, 00h-07h for VSAFE and VWATCH)
Return: varies by function
Note:	this API is identical to the API on INT 13/AH=FAh and INT 16/AH=FAh,
	  so it is listed in its entirety only under INT 16/AX=FA00h and
	  following
SeeAlso: INT 13/AX=FA00h,INT 16/AX=FA00h
--------D-21FB-------------------------------
INT 21 - DOS v2.11 - OEM FUNCTION
	AH = FBh
SeeAlso: AH=F8h"OEM",AH=FAh"OEM",AH=FCh"OEM"
--------T-21FB-------------------------------
INT 21 - DoubleDOS - TURN ON TASK SWITCHING
	AH = FBh
Return: task switching turned on
SeeAlso: AH=EBh"DoubleDOS",AH=F9h"DoubleDOS",AH=FAh"DoubleDOS"
SeeAlso: INT FB"DoubleDOS"
--------v-21FB-------------------------------
INT 21 - VIRUS - "Cinderella" - INSTALLATION CHECK
	AH = FBh
Return: AH = 00h if resident
SeeAlso: AH=F7h"VIRUS",AX=FB0Ah
--------v-21FB0A-----------------------------
INT 21 - VIRUS - "dBASE" - INSTALLATION CHECK
	AX = FB0Ah
Return: AX = 0AFBh if resident
SeeAlso: AH=FBh"VIRUS",AH=FCh"VIRUS"
--------D-21FC-------------------------------
INT 21 - DOS v2.11 - OEM FUNCTION
	AH = FCh
SeeAlso: AH=F8h"OEM",AH=FBh"OEM",AH=FDh"OEM"
--------T-21FC-------------------------------
INT 21 - DoubleDOS - GET VIRTUAL SCREEN ADDRESS
	AH = FCh
Return: ES = segment of virtual screen
Desc:	Determine the address of the virtual screen to which the program
	  should write instead of the actual video memory, so that the
	  multitasked programs do not interfere with each other's output.
Notes:	screen address can change if task-switching is on!!
	identical to AH=ECh
SeeAlso: AH=ECh"DoubleDOS",INT FC"DoubleDOS"
--------v-21FC-------------------------------
INT 21 - VIRUS - "Troi" - INSTALLATION CHECK
	AH = FCh
Return: AL = A5h if resident
SeeAlso: AX=FB0Ah"VIRUS",AH=FDh"VIRUS"
--------D-21FD-------------------------------
INT 21 - DOS v2.11 - OEM FUNCTION
	AH = FDh
SeeAlso: AH=F8h"OEM",AH=FCh"OEM",AH=FEh"OEM"
--------v-21FD-------------------------------
INT 21 - VIRUS - "Border" - INSTALLATION CHECK
	AH = FDh
Return: AH = 13h if resident
SeeAlso: AH=FCh"VIRUS",AH=FEh"VIRUS"
--------D-21FE-------------------------------
INT 21 - DOS v2.11 - OEM FUNCTION
	AH = FEh
SeeAlso: AH=F8h"OEM",AH=FDh"OEM",AH=FFh"OEM"
--------T-21FE-------------------------------
INT 21 - DoubleDOS - GIVE AWAY TIME TO OTHER TASKS
	AH = FEh
	AL = number of 55ms time slices to give away
Return: returns after giving away time slices
SeeAlso: AH=EEh"DoubleDOS",INT FE"DoubleDOS"
--------v-21FE-------------------------------
INT 21 - VIRUS - "483" - INSTALLATION CHECK
	AH = FEh
Return: AH = 00h if resident
SeeAlso: AH=FDh"VIRUS",AX=FE01h
--------v-21FE01-----------------------------
INT 21 - VIRUS - "Flip" - INSTALLATION CHECK
	AX = FE01h
Return: AX = 01FEh if resident
SeeAlso: AH=FEh"VIRUS",AX=FE02h
--------v-21FE02-----------------------------
INT 21 - VIRUS - "2468"/"Tequila" - INSTALLATION CHECK
	AX = FE02h
Return: AX = 01FDh if resident
SeeAlso: AX=FE01h,AX=FE03h,AX=FEDCh"VIRUS"
--------v-21FE03-----------------------------
INT 21 - VIRUS - "2468"/"Tequila" - DISPLAY VIRUS MESSAGE
	AX = FE03h
SeeAlso: AX=FE02h
--------d-21FEDC-----------------------------
INT 21 - PCMag PCMANAGE/DCOMPRES - INSTALLATION CHECK
	AX = FEDCh
Return: AX = CDEFh if installed
Program: the PCMANAGE/DCOMPRES combination from PC Magazine permits
	  infrequently-used files to be compressed to save space and
	  transparently expanded when accessed
SeeAlso: AH=DCh,INT 2D/AL=10h"dLite"
--------v-21FEDC-----------------------------
INT 21 - VIRUS - "Black Monday" - INSTALLATION CHECK
	AX = FEDCh
Return: AL = DCh if resident
SeeAlso: AX=FE02h,AX=FEFEh
--------v-21FEFE-----------------------------
INT 21 - VIRUS - "CIDER" - INSTALLATION CHECK
	AX = FEFEh
Return: SI = 1994h if resident
SeeAlso: AX=FEDCh"VIRUS",AH=FFh"VIRUS"
--------D-21FF-------------------------------
INT 21 - DOS v2.11 - OEM FUNCTION
	AH = FFh
SeeAlso: AH=F8h"OEM",AH=FEh"OEM"
--------K-21FF-------------------------------
INT 21 - CED (Command EDitor) - INSTALLABLE COMMANDS
	AH = FFh
	AL = subfunction
	    00h add installable command
		BL = mode
		    bit 0 = 1 callable from DOS prompt
		    bit 1 = 1 callable from application
		DS:SI -> CR-terminated command name
		ES:DI -> FAR routine entry point
	    01h remove installable command
		DS:SI -> CR-terminated command name
	    02h reserved, may be used to test for CED installation
Return: CF clear if successful
	CF set on error
	    AX = error code
		01h invalid function
		02h command not found (subfunction 01h only)
		08h insufficient memory (subfunction 00h only)
		0Eh bad data (subfunction 00h only)
	AH = FFh if CED not installed
Program: CED is a shareware DOS command-line enhancer by Christopher J. Dunford
SeeAlso: AX=0A00h
--------E-21FF-------------------------------
INT 21 - DJ GO32.EXE 80386+ DOS extender - DOS EXTENSIONS
	AH = FFh
	AL = function
	    01h create file
	    02h open file
	    03h get file statistics
	    04h get time of day
	    05h set time of day
	    06h stat
	    07h system
Program: GO32.EXE is a DOS extender included as part of the 80386 port of the
	  GNU C/C++ compiler by DJ Delorie and distributed as DJGPP
SeeAlso: INT 10/AH=FFh"GO32"
--------K-21FF-------------------------------
INT 21 - DOSED.COM - INSTALLATION CHECK
	AH = FFh
	DS:SI -> "DOSED"
	ES = 0000h
Return: ES:DI -> "DOSED" if installed
Program: DOSED is a free DOS commandline editor/history buffer by Sverre H.
	  Huseby
--------v-21FF-------------------------------
INT 21 - VIRUS - "Sunday", "Tumen 0.5", "Hero" - INSTALLATION CHECK
	AH = FFh
Return: AH = 00h if "Tumen 0.5" or "Hero" resident
	AX = 0400h if "Sunday" resident
SeeAlso: AX=FEDCh"VIRUS",AX=FF0Fh
--------E-21FF-------------------------------
INT 21 UP - Rational Systems DOS/4GW - API
	AH = FFh
	DH = function (00h-17h) (see also separate entries below)
	DL = subfunction or argument
Return: CF clear if valid function number
	    AX = status???
	CF set if invalid function
SeeAlso: INT 15/AX=BFDCh
--------E-21FF--DH02-------------------------
INT 21 UP - Rational Systems DOS/4GW - SET ???
	AH = FFh
	DH = 02h
	DL = ???
Return: CF clear
--------E-21FF--DH05-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 05h
	BX = ???
Return: ???
--------E-21FF--DH06-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 06h
	BX = ???
Return: ???
--------E-21FF--DH07-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 07h
	BX = ???
Return: ???
--------E-21FF--DH08-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 08h
	BX = ???
	CX = ???
	ES = ???
Return: ???
--------E-21FF--DH09-------------------------
INT 21 UP - Rational Systems DOS/4GW - GET ???
	AH = FFh
	DH = 09h
Return: ES:BX -> ???
--------E-21FF--DH0A-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 0Ah
	AL = ???
	BX = ???
	CX = ???
Return: ES = ??? or 0000h
--------E-21FF--DH0B-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 0Bh
	AL = ???
	BX = ???
	CX = ???
Return: ???
--------E-21FF--DH0C-------------------------
INT 21 UP - Rational Systems DOS/4GW - GET/SET ???
	AH = FFh
	DH = 0Ch
	DL = ??? (00h or 01h)
Return: CF clear if successful
	    AL = previous value of ???
	CF set on error (DL out of range)
	    AX = FFFFh
--------E-21FF--DH0D-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 0Dh
	???
Return: ???
--------E-21FF--DH0E-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 0Eh
Return: DX:AX -> XBRK structure (see INT 15/AX=BF02h)
	BX = ???
	CX = ???
SeeAlso: INT 15/AX=BF02h
--------E-21FF--DH0F-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 0Fh
	???
Return: ???
--------E-21FF--DH10-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 10h
	AL = ???
	BX = ???
	CX = ???
	DI = ???
	SI = ???
Return: ???
Note:	among other things, frees two memory blocks via INT 21/AH=49h
--------E-21FF--DH11-------------------------
INT 21 UP - Rational Systems DOS/4GW - NOP
	AH = FFh
	DH = 11h
--------E-21FF--DH12-------------------------
INT 21 UP - Rational Systems DOS/4GW - EXCHANGE ??? POINTERS
	AH = FFh
	DH = 12h
	DS:SI -> new ???
	ES:DI -> new ???
Return: DS:SI -> previous ???
	ES:DI -> previous ???
--------E-21FF--DH13-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 13h
	AL = ???
	ES = ???
Return: ???
--------E-21FF--DH14-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFh
	DH = 14h
	BX = ???
	CX = ???
Return: CF clear
	    AX = ???
	    DX = ???
--------E-21FF--DH15-------------------------
INT 21 UP - Rational Systems DOS/4GW - GET ??? FUNCTIONS
	AH = FFh
	DH = 15h
Return: CF clear
	    DX:AX -> FAR function for ???
	    CX:BX -> FAR function for ???
	    SI:DI -> FAR function for ???
--------E-21FF--DH16-------------------------
INT 21 UP - Rational Systems DOS/4GW - GET ???
	AH = FFh
	DH = 16h
Return: AX = ???
--------E-21FF--DH17-------------------------
INT 21 UP - Rational Systems DOS/4GW - ???
	AH = FFH
	DH = 17h
	AL = ???
	DL = ???
Return: ???
--------N-21FF00-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET SYSTEM INFORMATION
	AX = FF00h
	CL = what to get
	    00h user information
	    01h drive mapping
	    02h printer server(s)
	    05h local DOS drive number
Return: ES:BX -> desired information (see #1202)
Program: TopWare Network Operating System is manufactured by Grand Computer
	  Company
Note:	this call is only supported on Workstations, not on the server
SeeAlso: AX=FF04h,INT 2F/AX=FF00h

Format of TopWare user information:
Offset	Size	Description	(Table 1202)
 00h	BYTE	node ID
 01h 15 BYTEs	user name
 10h	WORD	user number
 12h	BYTE	group number

Format of TopWare drive mapping [array]:
Offset	Size	Description	(Table 1203)
 00h	BYTE	bits 6-0: drive number (1=A:, etc.)
		bit 7: this is a server drive
 01h  3 BYTEs	mapping drive (for example, "C:\")
 04h 64 BYTEs	current directory
--------E-21FF00DX0078-----------------------
INT 21 - Rational Systems DOS/4G - INSTALLATION CHECK
	AX = FF00h
	DX = 0078h
Return: AL <> 00h if installed
	    GS = segment of kernel if nonzero
SeeAlso: INT 15/AX=BF02h
--------N-21FF04-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET/SET DEFAULT FILE PROTECTION ATTRIBS
	AX = FF04h
	CL = function
	    00h get protections
		Return: BH = read attribute
			BL = write attribute
	    01h set protections
		BH = read attribute
		BL = write attribute
Note:	this function is supported only on Workstations, not on the server
SeeAlso: AX=FF00h"TopWare"
--------v-21FF0F-----------------------------
INT 21 - FLU_SHOT+ v1.83 - INSTALLATION CHECK
	AX = FF0Fh
Return: AX = 0101h if resident
Program: FLU_SHOT+ is an antivirus/antitrojan program by Ross M. Greenberg and
	  Software Concepts Design
Note:	the "PSQR/1720" virus calls this function to determine whether
	  FLU_SHOT+ is present
SeeAlso: AH=FFh"VIRUS",AX=FF10h
--------v-21FF10-----------------------------
INT 21 - VIRUS - "Twins" - INSTALLATION CHECK
	AX = FF10h
Return: AL = 07h if resident
SeeAlso: AX=FF0Fh,AX=FFFEh
--------N-21FF80DHFF-------------------------
INT 21 - TopWare Network OS v5.10+ - SEND MESSAGE
	AX = FF80h
	DH = FFh
	DL = destination address (FFh for broadcast)
	CX = message length (max 2000)
	DS:SI -> message to be sent (see #1204)
Return: nothing
Program: TopWare Network Operating System is manufactured by Grand Computer
	  Company
Notes:	this function is supported on both Workstations and the server
	there is no guarantee that the message will be received correctly, or
	  at all, by the destination

Format of TopWare message:
Offset	Size	Description	(Table 1204)
 00h	BYTE	type code
		07h TopSend
		11h user application
		other reserved for TopWare
 01h	var	data
Note:	sending messages with a type code other than 11h will cause
	  unpredictable results
--------N-21FF82-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET STATION ADDRESS
	AX = FF82h
Return: AL = station address
Note:	this function is supported on both Workstations and the server
SeeAlso: AX=FF91h
--------N-21FF8C-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET STATUS OF TopShow/Emulated FUNCTION
	AX = FF8Ch
	BL = subfunction
	    00h get TopShow status
	    FFh get Emulated status
Return: AL = status
	    00h not installed
	    01h already installed
--------N-21FF8D-----------------------------
INT 21 - TopWare Network OS v5.10+ - CALL TopShow FUNCTION
	AX = FF8Dh
	CH = monochrome flag (01h monochrome, 00h not monochrome)
	CL = screen mode of station to be viewed (see #1205)
	BL = graphic page number for monochrome
Return: AL = status (00h successful, else failed)
SeeAlso: AX=FF8Eh,AX=FFCFh

(Table 1205)
Values for TopWare screen mode:
 00h	text mode
 01h	720x348
 02h	640x408
 03h	720x352
 04h	640x390
 05h	reserved
--------N-21FF8E-----------------------------
INT 21 - TopWare Network OS v5.10+ - CANCEL TopShow FUNCTION
	AX = FF8Eh
Return: AL = 00h (successful, TopShow removed)
SeeAlso: AX=FF8Dh
--------N-21FF91-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET FILE SERVER STATION NUMBER
	AX = FF91h
Return: AL = station number of file server
SeeAlso: AX=FF82h
--------N-21FF97-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET MAXIMUM STATION NUMBER (server only)
	AX = FF97h
Return: AL = maximum station number
SeeAlso: AX=FF98h
--------N-21FF98-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET MAXIMUM FILE NUMBER (server only)
	AX = FF98h
Return: AL = maximum file
SeeAlso: AX=FF97h
--------N-21FF9A-----------------------------
INT 21 - TopWare Network OS v5.10+ - RECEIVE OF USER-DEFINED PACKETS
	AX = FF9Ah
	ES:BX -> buffer for user-defined packet (see #1206)
Return: nothing

Format of TopWare user-defined packet:
Offset	Size	Description	(Table 1206)
 00h	BYTE	FFh
 01h	WORD	(call) length of data field plus 3
		(return) length of received message (0000h if none received)
 03h	BYTE	destination ID (FFh for broadcast message)
 04h	BYTE	sending station ID
 05h	BYTE	type code (11h; all other codes reserved for TopWare)
 06h  N BYTEs	received message
--------N-21FF9F-----------------------------
INT 21 - TopWare Network OS v5.10+ - ENABLE/DISABLE TopTerm SERVICE
	AX = FF9Fh
	CL = new state (00h disable [disregard TopTerm packets], 01h enable)
Return: AL = status (00h successful, FFh failed)
Note:	this function is only supported by Workstations, not the server
--------N-21FFB0-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET SPOOLER PRINTING PRIORITY
	AX = FFB0h
Return: AL = priority status (see #1207)
SeeAlso: AX=FFB1h

Bitfields for TopWare printer priority status:
Bit(s)	Description	(Table 1207)
 2	LPT3 has high priority
 1	LPT2 has high priority
 0	LPT1 has high priority
--------N-21FFB1-----------------------------
INT 21 - TopWare Network OS v5.10+ - SET SPOOLER PRINTING PRIORITY
	AX = FFB1h
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
	CH = new priority (00h normal, 01h high)
Return: nothing
SeeAlso: AX=FFB0h
--------N-21FFB3-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET DEFAULT START-OF-JOB FORMFEED STATUS
	AX = FFB3h
Return: AL = starting formfeed status (see #1208)
SeeAlso: AX=FFB4h,AX=FFC0h

Bitfields for TopWare printer start-of-job formfeed status:
Bit(s)	Description	(Table 1208)
 2	LPT3 has formfeed enabled
 1	LPT2 has formfeed enabled
 0	LPT1 has formfeed enabled
--------N-21FFB4-----------------------------
INT 21 - TopWare Network OS v5.10+ - SET DEFAULT START-OF-JOB FORMFEED STATUS
	AX = FFB4h
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
	CH = new formfeed status (00h off, 01h on)
Return: nothing
SeeAlso: AX=FFB3h,AX=FFC1h
--------N-21FFBB-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET PRINTER SERVER STATION ADDRESS
	AX = FFBBh
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
Return: AL = current mapping printer server station number
	    00h if local
SeeAlso: AX=FFBCh
--------N-21FFBC-----------------------------
INT 21 - TopWare Network OS v5.10+ - CANCEL TopShow FUNCTION
	AX = FFBCh
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
	CL = printer server station address or 00h for local printer
Return: AL = status (00h successful, else failed)
SeeAlso: AX=FFBBh
--------N-21FFBD-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET CURRENT AUTOPRINT TIME
	AX = FFBDh
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
Return: AX = current AutoPrint timeout in clock ticks
SeeAlso: AX=FFBEh
--------N-21FFBE-----------------------------
INT 21 - TopWare Network OS v5.10+ - SET AUTOPRINT TIME
	AX = FFBEh
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
	BX = timeout in clock ticks
SeeAlso: AX=FFBDh
--------N-21FFBF-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET LOGON USER INFORMATION
	AX = FFBFh
	DX:BX -> buffer for logon information (see #1209)
Return: AL = status (00h successful, else failed)
	AH = number of logged-in stations

Format of TopWare logon information:
Offset	Size	Description	(Table 1209)
 00h	BYTE	station address
 01h 15 BYTEs	username
--------N-21FFC0-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET DEFAULT END-OF-JOB FORMFEED STATUS
	AX = FFC0h
Return: AL = ending formfeed status (see #1210)
SeeAlso: AX=FFB3h,AX=FFC1h

Bitfields for TopWare printer end-of-job formfeed status:
Bit(s)	Description	(Table 1210)
 2	LPT3 has formfeed enabled
 1	LPT2 has formfeed enabled
 0	LPT1 has formfeed enabled
--------N-21FFC1-----------------------------
INT 21 - TopWare Network OS v5.10+ - SET DEFAULT END-OF-JOB FORMFEED STATUS
	AX = FFC1h
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
	CH = new formfeed status (00h off, 01h on)
Return: nothing
SeeAlso: AX=FFB4h,AX=FFC0h
--------N-21FFC2-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET DEFAULT COPIES OF SPOOLING FILE
	AX = FFC2h
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
Return: AL = default number of copies printed
SeeAlso: AX=FFC7h
--------N-21FFC3-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET SHARING STATUS OF PRINTER SERVER
	AX = FFC3h
Return: AL = sharing status of printers (see #1211)
	    FFh if not a printer server

Bitfields for TopWare printer sharing status:
Bit(s)	Description	(Table 1211)
 2	LPT3 is shared
 1	LPT2 is shared
 0	LPT1 is shared
--------N-21FFC4-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET/SET LPT PORT ON PRINT SERVER
	AX = FFC4h
	BL = subfunction
	    00h get
		Return: AL = mapped printer port on print server
	    01h set
		CL = network printer port (00h LPT1, 01h LPT2, 02h LPT3)
	CH = local printer (00h LPT1, 01h LPT2, 02h LPT3)
--------N-21FFC6-----------------------------
INT 21 - TopWare Network OS v5.10+ - SET DEFAULT PRINT FILE HEADER
	AX = FFC6h
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
	CL = header state (00h off, 01h on)
SeeAlso: AX=FFC8h
--------N-21FFC7-----------------------------
INT 21 - TopWare Network OS v5.10+ - SET DEFAULT PRINT COPIES
	AX = FFC7h
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
	CL = new default number of copies to print
SeeAlso: AX=FFC2h
--------N-21FFC8-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET DEFAULT PRINT FILE HEADER STATUS
	AX = FFC8h
Return: AL = header status for printers (see #1212)
SeeAlso: AX=FFC6h

Bitfields for TopWare print header status:
Bit(s)	Description	(Table 1212)
 2	LPT3 has headers enabled
 1	LPT2 has headers enabled
 0	LPT1 has headers enabled
--------N-21FFC9-----------------------------
INT 21 - TopWare Network OS v5.10+ - SET PRINTER SHARING
	AX = FFC9h
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
	CL = new sharing state (00h off, 01h on)
Return: AL = status (00h successful, FFh not printer server)
--------N-21FFCA-----------------------------
INT 21 - TopWare Network OS v5.10+ - MOVE FILE FROM ONE PRINT SERVER TO ANOTHER
	AX = FFCAh
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
	CL = original printer server station address
	BL = target printer server station address
	DS:DX -> filename (12 bytes)
Return: AL = status (00h successful, else failed)
SeeAlso: AX=FFCBh
--------N-21FFCB-----------------------------
INT 21 - TopWare Network OS v5.10+ - DELETE FILE FROM SPOOLING QUEUE
	AX = FFCBh
	CH = printer number (00h LPT1, 01h LPT2, 02h LPT3)
	CL = printer server station address
	DS:DX -> filename (12 bytes)
Return: AL = status (00h successful, else failed)
SeeAlso: AX=FFCAh
--------N-21FFCC-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET PRINT SERVER'S SPOOLING QUEUE STATUS
	AX = FFCCh
	CL = printer server station address
	BH = start item number of spooling file for print server
	BL = number of the item to be retrieved
	DS:DX -> buffer for queued file information (see #1213)
Return: AL = status
	    00h successful
		AH = number of spool files
		DS:DX buffer filled
	    nonzero failed

Format of TopWare queued file information buffer [16-item array, one element]:
Offset	Size	Description	(Table 1213)
 00h 12 BYTEs	filename
 0Ch	DWORD	size
 10h	WORD	date
 12h	WORD	time
 14h 15 BYTEs	username
 23h	BYTE	count
 24h	BYTE	flag: header
 25h	BYTE	print number
--------N-21FFCD-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET STATUS OF ALL PRINT SERVERS
	AX = FFCDh
	DS:DX -> buffer for server status (see #1214)
Return: AL = status
	    00h successful
		AH = number of print servers
	    nonzero failed

Format of TopWare server status:
Offset	Size	Description	(Table 1214)
 00h	BYTE	station address
 01h 15 BYTEs	username
 10h	BYTE	flag: 01h printer is shared, 00h sharing disabled
 11h	BYTE	number of files pending in queue
--------N-21FFCF-----------------------------
INT 21 - TopWare Network OS v5.10+ - CALL TopLook FUNCTION
	AX = FFCFh
	DH = page number (0-2, 2 is text mode)
	DL = type
	    00h look at specific screen
	    01h AutoLook on
	    FFh AutoLook off
	BH = station number wishing to look
	BL = station number to be looked at
	CH = monochrome flag (01h monochrome, 00h not monochrome)
	CL = screen mode (see #1205)
Return: AL = status (00h successful, nonzero failed)
SeeAlso: AX=FF8Dh
--------N-21FFD6-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET KEYCARD SERIAL NUMBER AND MAX USERS
	AX = FFD6h
	ES:BX -> 12-byte buffer for keycard serial number
Return: CX = maximum number of users
	ES:BX buffer filled
--------N-21FFD7-----------------------------
INT 21 - TopWare Network OS v5.10+ - GET NETWORK PROTECTION ATTRIBUTES STATUS
	AX = FFD7h
Return: AL = status (00h disabled, 01h enabled)
--------N-21FFE3DL00-------------------------
INT 21 - TopWare Network OS v5.10+ - INITIATE ACCESS TO SPECIFIC PACKET TYPE
	AX = FFE3h
	DL = 00h
	BX = packet type for Ethernet header (IP = 0800h, ARP = 0806h, etc.)
	ES:DI -> receive routine (see #1216)
Return: CF clear if successful
	    AX = handle number
	CF set on error
	    DH = error code (03h,05h,09h,0Ah,11h) (see #1215)
SeeAlso: AX=FFE3h/DL=01h

(Table 1215)
Values for TopWare error code:
 01h	invalid handle
 03h	no interfaces of the specified type found
 05h	bad packet type
 09h	insufficient space
 0Ah	type already being accessed
 0Ch	unable to send packet (usually hardware error)
 11h	invalid function

(Table 1216)
Values TopWare receive routine is called with:
	AX = function
	    0000h request packet buffer
		CX = packet size
		Return: ES:DI -> buffer or 0000h:0000h to discard packet
	    0001h packet copied
		CX = packet size
		DS:SI -> copied packet (same as returned ES:DI above)
--------N-21FFE3DL01-------------------------
INT 21 - TopWare Network OS v5.10+ - END ACCESS TO SPECIFIC PACKET TYPE
	AX = FFE3h
	DL = 01h
	BX = handle returned by AX=FFE3h/DL=00h
Return: CF clear if successful
	CF set on error
	    DH = error code (01h,11h) (see #1215)
Note:	the specified access handle will no longer be valid after this call
SeeAlso: AX=FFE3h/DL=00h
--------N-21FFE3DL02-------------------------
INT 21 - TopWare Network OS v5.10+ - SEND PACKET
	AX = FFE3h
	DL = 02h
	CX = length of data buffer
	DS:SI -> buffer containing data
Return: CF clear if successful
	CF set on error
	    DH = error code (0Ch,11h) (see #1215)
--------N-21FFE3DL03-------------------------
INT 21 - TopWare Network OS v5.10+ - GET LOCAL NETWORK INTERFACE ADDRESS
	AX = FFE3h
	DL = 03h
	ES:DI -> 6-byte buffer for address
SeeAlso: AX=FFE3h/DL=00h
--------v-21FFFE-----------------------------
INT 21 - VIRUS - "08/15"/"Many Fingers" - INSTALLATION CHECK
	AX = FFFEh
Return: AX = 0815h if resident
SeeAlso: AX=FF10h,AX=FFFFh
--------v-21FFFF-----------------------------
INT 21 - VIRUS - "Ontario", "Year 1992"/"B1M92" - INSTALLATION CHECK
	AX = FFFFh
Return: AX = 0000h if "Ontario" resident
	AX = 1992h if "Year 1992"/"B1M92" resident
SeeAlso: AX=FF0Fh,AX=FFFFh/CX=0000h,INT 6B"VIRUS"
--------v-21FFFFCX0000-----------------------
INT 21 - VIRUS - "Revenge" - INSTALLATION CHECK
	AX = FFFFh
	CX = 0000h
Return: CX = 0006h if resident
SeeAlso: AX=FFFFh,INT 6B"VIRUS"
--------D-22---------------------------------
INT 22 - DOS 1+ - PROGRAM TERMINATION ADDRESS
Desc:	this vector specifies the address of the routine which is to be given
	  control after a program is terminated; it should never be called
	  directly, since it does not point at an interrupt handler
Notes:	this vector is restored from the DWORD at offset 0Ah in the PSP during
	  termination, and then a FAR JMP is performed to the address in INT 22
	normally points at the instruction immediately following INT 21/AH=4Bh
	  call which loaded the current program
SeeAlso: INT 20,INT 21/AH=00h,INT 21/AH=31h,INT 21/AH=4Ch
--------G-22---------------------------------
INT 22 - COMTROL HOSTESS i/ISA DEBUGGER - CHANGE FIRMWARE DEBUGGING PORT
	AL = new firmware debugging port
Return: ???
SeeAlso: INT 21"COMTROL",INT 23"COMTROL"
--------D-23---------------------------------
INT 23 - DOS 1+ - CONTROL-C/CONTROL-BREAK HANDLER
---DOS 1.x---
Return: AH = 00h abort program
	if all registers preserved, restart DOS call
---DOS 2+---
	CF clear
Return: all registers preserved
	return via RETF with CF set or (MS-DOS 1,DR-DOS) RETF 2 with CF set
	    DOS will abort program with errorlevel 0
	else (RETF/RETF 2 with CF clear or IRET with CF ignored)
	    interrupted DOS call is restarted
Notes:	this interrupt is invoked whenever DOS detects a ^C or ^Break; it
	  should never be called directly
	MS-DOS 1.25 also invokes INT 23 on a divide overflow (INT 00)
	MS-DOS remembers the stack pointer before calling INT 23, and if it is
	  not the same on return, pops and discards the top word; this is what
	  permits a return with RETF as well as IRET or RETF 2
	MS-DOS 2.1+ ignores the returned CF if SP is the same on return as it
	  was when DOS called INT 23, so RETF 2 will not terminate the program
	Novell DOS 7 always pops a word if CF is set on return, so one should
	  not return with RETF 2 and CF set or IRET with the stored flags' CF
	  set
	any DOS call may safely be made within the INT 23 handler, although
	  the handler must check for a recursive invocation if it does
	  call DOS
SeeAlso: INT 1B
--------G-23---------------------------------
INT 23 - COMTROL HOSTESS i/ISA DEBUGGER - GET CONFIGURATION INFORMATION
	AL = query type
	    00h get old config map
		Return: AX = old config map
	    01h get dual-ported RAM map
		Return: BX:AX = dual-ported RAM map
	    02h get SCC port map
		Return: BX:AX = SCC port map
SeeAlso: INT 22"COMTROL",INT 26"COMTROL"
--------D-24---------------------------------
INT 24 - DOS 1+ - CRITICAL ERROR HANDLER
Note:	invoked when a critical (usually hardware) error is encountered; should
	  never be called directly
SeeAlso: INT 21/AH=95h

(Table 1217)
Values critical error handler is called with:
	AH = type and processing flags (see #1218)
	AL = drive number if AH bit 7 clear
	BP:SI -> device driver header (BP:[SI+4] bit 15 set if char device)
	DI low byte contains error code if AH bit 7 set (see #1219)
	STACK:	DWORD	return address for INT 24 call
		WORD	flags pushed by INT 24
		WORD	original AX on entry to INT 21
		WORD	BX
		WORD	CX
		WORD	DX
		WORD	SI
		WORD	DI
		WORD	BP
		WORD	DS
		WORD	ES
		DWORD	return address for INT 21 call
		WORD	flags pushed by INT 21
Return:	AL = action code (see #1220)
	SS,SP,DS,ES,BX,CX,DX preserved
Notes:	the only DOS calls the handler may make are INT 21/AH=01h-0Ch,30h,59h
	if the handler returns to the application by popping the stack, DOS
	  will be in an unstable state until the first call with AH > 0Ch
	for DOS 3.1+, IGNORE (AL=00h) is turned into FAIL (AL=03h) on network
	  critical errors
	if IGNORE specified but not allowed, it is turned into FAIL
	if RETRY specified but not allowed, it is turned into FAIL
	if FAIL specified but not allowed, it is turned into ABORT
	(DOS 3+) if a critical error occurs inside the critical error handler,
	  the DOS call is automatically failed

Bitfields for critical error type and processing flags:
Bit(s)	Description	(Table 1218)
 7	clear = disk I/O error
	set   = -- if block device, bad FAT image in memory
		-- if char device, error code in DI
 6	unused
 5	Ignore allowed (DOS 3+)
 4	Retry allowed (DOS 3+)
 3	Fail allowed (DOS 3+)
 2-1	disk area of error
	00 = DOS area	01 = FAT
	10 = root dir	11 = data area
 0	set if write, clear if read

(Table 1219)
Values for critical error code:
 00h	write-protection violation attempted
 01h	unknown unit for driver
 02h	drive not ready
 03h	unknown command given to driver
 04h	data error (bad CRC)
 05h	bad device driver request structure length
 06h	seek error
 07h	unknown media type
 08h	sector not found
 09h	printer out of paper
 0Ah	write fault
 0Bh	read fault
 0Ch	general failure
 0Dh	(DOS 3+) sharing violation
 0Eh	(DOS 3+) lock violation
 0Fh	invalid disk change
 10h	(DOS 3+) FCB unavailable
 11h	(DOS 3+) sharing buffer overflow
 12h	(DOS 4+) code page mismatch
 13h	(DOS 4+) out of input
 14h	(DOS 4+) insufficient disk space

(Table 1220)
Values for critical error handler action code:
 00h	ignore error and continue processing request
 01h	retry operation
 02h	terminate program as though INT 21/AH=4Ch called (INT 20h for DOS 1.x)
 03h	fail system call in progress
--------D-25---------------------------------
INT 25 - DOS 1+ - ABSOLUTE DISK READ (except partitions > 32M)
	AL = drive number (00h = A:, 01h = B:, etc)
	CX = number of sectors to read (not FFFFh)
	DX = starting logical sector number (0000h - highest sector on drive)
	DS:BX -> buffer for data
Return: CF clear if successful
	CF set on error
	    AH = status (see #1221)
	    AL = error code (same as passed to INT 24 in DI)
	    AX = 0207h if more than 64K sectors on drive -- use new-style call
	may destroy all other registers except segment registers
Notes:	original flags are left on stack, and must be popped by caller
	this call bypasses the DOS filesystem
	examination of CPWIN386.CPL indicates that if this call fails with
	  error 0408h on an old-style (<32M) call, one should retry the
	  call with the high bit of the drive number in AL set
BUGS:	DOS 3.1 through 3.3 set the word at ES:[BP+1Eh] to FFFFh if AL is an
	  invalid drive number
	DR-DOS 3.41 will return with a jump instead of RETF, leaving the
	  wrong number of bytes on the stack; use the huge-partition version
	  (INT 25/CX=FFFFh) for all partition sizes under DR-DOS 3.41
SeeAlso: INT 13/AH=02h,INT 25/CX=FFFFh,INT 26

(Table 1221)
Values for disk I/O status:
 80h	device failed to respond (timeout)
 40h	seek operation failed
 20h	controller failed
 10h	data error (bad CRC)
 08h	DMA failure
 04h	requested sector not found
 03h	write-protected disk (INT 26 only)
 02h	bad address mark
 01h	bad command
--------D-25----CXFFFF-----------------------
INT 25 - DOS 3.31+ - ABSOLUTE DISK READ (>32M hard-disk partition)
	CX = FFFFh
	AL = drive number (0=A, 1=B, etc)
	DS:BX -> disk read packet (see #1222)
Return: CF clear if successful
	CF set on error
	    AH = status (see #1221)
	    AL = error code (same as passed to INT 24 in DI)
	    AX = 0207h if more than 64K sectors on drive -- use new-style call
	may destroy all other registers except segment registers
Notes:	partition is potentially >32M (and requires this form of the call) if
	  bit 1 of the device attribute word in the device driver is set
	original flags are left on stack, and must be removed by caller
	this call bypasses the DOS filesystem
SeeAlso: INT 13/AH=02h,INT 25,INT 26/CX=FFFFh

Format of disk read packet:
Offset	Size	Description	(Table 1222)
 00h	DWORD	sector number
 04h	WORD	number of sectors to read
 06h	DWORD	transfer address
--------k-25CDCD-----------------------------
INT 25 - Stacker - GET DEVICE DRIVER ADDRESS
	AX = CDCDh
	DS:BX -> buffer for address (see #1223)
	CX = 0001h
	DX = 0000h
Return: AX = CDCDh if Stacker installed
	    DS:BX buffer filled

Format of Stacker driver address buffer:
Offset	Size	Description	(Table 1223)
 00h	WORD	signature CDCDh
 02h	WORD	??? 0001h
 04h	DWORD	pointer to start of Stacker device driver (see #1224)

Format of Stacker device driver:
Offset	Size	Description	(Table 1224)
 00h	WORD	signature A55Ah
 02h	WORD	Stacker version * 64h
 04h	WORD	offset of volume-specific information offset table
		(list of WORDs, one per drive, containing offsets to various
		  information)
 06h 56 BYTEs	n/a
 3Eh	BYTE	volume number, set after INT 21/AX=4404h
		(use to index into volume-specific info offset table)
 3Fh 19 BYTEs	n/a
 52h  4 BYTEs	ASCII string "SWAP"
 56h 26 BYTEs	drive mapping table (one byte for each drive A: through Z:)

Format of Stacker boot record:
Offset	Size	Description	(Table 1225)
1F0h  8 BYTEs	Stacker signature (first byte is CDh)
1F8h	DWORD	pointer to start of Stacker device driver
1FCh	WORD	Stacker volume number
1FEh	WORD	???
--------c-25--FFSI4358-----------------------
INT 25 - PC-CACHE.SYS - INSTALLATION CHECK
	AL = FFh
	SI = 4358h
Return: SI = 6378h if installed
	    CX = segment of device driver PC-CACHE.SYS
	    DX = version (major in DH, minor in DL)
Program: PC-CACHE.SYS is a small device driver used by PC-Cache v5.x to obtain
	  access to certain disk drivers for devices such as Bernoulli drives
SeeAlso: INT 13/AH=A0h
--------D-26---------------------------------
INT 26 - DOS 1+ - ABSOLUTE DISK WRITE (except partitions > 32M)
	AL = drive number (00h = A:, 01h = B:, etc)
	CX = number of sectors to write (not FFFFh)
	DX = starting logical sector number (0000h - highest sector on drive)
	DS:BX -> data to write
Return: CF clear if successful
	CF set on error
	    AH = status (see #1221)
	    AL = error code (same as passed to INT 24 in DI)
	    AX = 0207h if more than 64K sectors on drive -- use new-style call
	may destroy all other registers except segment registers
Notes:	original flags are left on stack, and must be popped by caller
	this call bypasses the DOS filesystem, though DOS 5+ invalidates any
	  disk buffers referencing sectors which are written with this call
	examination of CPWIN386.CPL indicates that if this call fails with
	  error 0408h on an old-style (<32M) call, one should retry the
	  call with the high bit of the drive number in AL set
BUGS:	DOS 3.1 through 3.3 set the word at ES:[BP+1Eh] to FFFFh if AL is an
	  invalid drive number
	DR-DOS 3.41 will return with a jump instead of RETF, leaving the
	  wrong number of bytes on the stack; use the huge-partition version
	  (INT 26/CX=FFFFh) for all partition sizes under DR-DOS 3.41
SeeAlso: INT 13/AH=03h,INT 25,INT 26/CX=FFFFh
--------D-26----CXFFFF-----------------------
INT 26 - DOS 3.31+ - ABSOLUTE DISK WRITE (>32M hard-disk partition)
	CX = FFFFh
	AL = drive number (0=A, 1=B, etc)
	DS:BX -> disk write packet (see #1226)
Return: CF clear if successful
	CF set on error
	    AH = status (see #1221)
	    AL = error code (same as passed to INT 24 in DI)
	    AX = 0207h if more than 64K sectors on drive -- use new-style call
	may destroy all other registers except segment registers
Notes:	partition is potentially >32M (and requires this form of the call) if
	  bit 1 of the device attribute word in the device driver is set
	original flags are left on stack, and must be removed by caller
	this call bypasses the DOS filesystem, though DOS 5+ invalidates any
	  disk buffers referencing sectors which are written with this call
SeeAlso: INT 13/AH=03h,INT 25/CX=FFFFh,INT 26

Format of disk write packet:
Offset	Size	Description	(Table 1226)
 00h	DWORD	sector number
 04h	WORD	number of sectors to read
 06h	DWORD	transfer address
--------G-26---------------------------------
INT 26 - COMTROL HOSTESS i/ISA DEBUGGER - ENTER/EXIT EXTENDED ADDRESSING MODE
	???
Return: ???
SeeAlso: INT 23"COMTROL",INT 27"COMTROL"
--------D-27---------------------------------
INT 27 - DOS 1+ - TERMINATE AND STAY RESIDENT
	DX = number of bytes to keep resident (max FFF0h)
	CS = segment of PSP
Return: never
Notes:	this is an obsolete call
	INT 22, INT 23, and INT 24 are restored from the PSP
	does not close any open files
	the minimum number of bytes which will remain resident is 110h for
	  DOS 2.x and 60h for DOS 3+; there is no minimum for DOS 1.x, which
	  implements this service in COMMAND.COM rather than the DOS kernel
SeeAlso: INT 21/AH=31h
--------G-27---------------------------------
INT 27 - COMTROL HOSTESS i/ISA DEBUGGER - INVOKE REMOTE TURBO DEBUGGER KERNEL
	???
Return: ???
Desc:	invoke a copy of the remote Turbo Debugger kernel on the Hostess i
	  controller
SeeAlso: INT 20"COMTROL",INT 26"COMTROL"
--------D-28---------------------------------
INT 28 C - DOS 2+ - DOS IDLE INTERRUPT
	SS:SP = top of MS-DOS stack for I/O functions
Return: all registers preserved
Desc:	This interrupt is invoked each time one of the DOS character input
	  functions loops while waiting for input.  Since a DOS call is in
	  progress even though DOS is actually idle during such input waits,
	  hooking this function is necessary to allow a TSR to perform DOS
	  calls while the foreground program is waiting for user input.	 The
	  INT 28h handler may invoke any INT 21h function except functions
	  00h through 0Ch.
Notes:	under DOS 2.x, the critical error flag (the byte immediately after the
	  InDOS flag) must be set in order to call DOS functions 50h/51h from
	  the INT 28h handler without destroying the DOS stacks.
	calls to INT 21/AH=3Fh,40h from within an INT 28 handler may not use a
	  handle which refers to CON
	at the time of the call, the InDOS flag (see INT 21/AH=34h) is normally
	  set to 01h; if larger, DOS is truly busy and should not be reentered
	the default handler is an IRET instruction
	supported in OS/2 compatibility box
	the _MS-DOS_Programmer's_Reference_ for DOS 5.0 incorrectly documents
	  this interrupt as superseded
SeeAlso: INT 21/AH=34h,INT 2A/AH=84h,INT 2F/AX=1680h
--------D-29---------------------------------
INT 29 C - DOS 2+ - FAST CONSOLE OUTPUT
	AL = character to display
Return: nothing
Notes:	automatically called when writing to a device with bit 4 of its device
	  driver header set (see also INT 21/AH=52h)
	COMMAND.COM v3.2 and v3.3 compare the INT 29 vector against the INT 20
	  vector and assume that ANSI.SYS is installed if the segment is larger
	the default handler under DOS 2.x and 3.x simply calls INT 10/AH=0Eh
	the default handler under DESQview 2.2 understands the <Esc>[2J
	  screen-clearing sequence, calls INT 10/AH=0Eh for all others
SeeAlso: INT 21/AH=52h,INT 2F/AX=0802h,INT 79
--------N-2A00-------------------------------
INT 2A - NETWORK (Microsoft, LANtastic) - INSTALLATION CHECK
	AH = 00h
Return: AH <> 00h if installed
	CF set if NetWare v2.15 NetBIOS emulator installed
Note:	also supported by Lantastic, NetWare, 10NET, etc.
SeeAlso: INT 5C
--------N-2A0000-----------------------------
INT 2A - AT&T Starlan Extended NetBIOS (var length names) - INSTALLATION CHECK
	AX = 0000h
Return: AH = DDh
SeeAlso: INT 5B
--------N-2A01-------------------------------
INT 2A - NETWORK (Microsoft,LANtastic) - EXECUTE NETBIOS REQUEST,NO ERROR RETRY
	AH = 01h
	ES:BX -> NCB (see INT 5C)
Return: AL = NetBIOS error code
	AH = status
	    00h no error
	    01h error occurred
SeeAlso: AH=04h,AX=0500h,INT 5B,INT 5C"NetBIOS"
--------N-2A02-------------------------------
INT 2A - NETWORK (Microsoft) - SET NET PRINTER MODE
	AH = 02h
	???
Return: ???
--------N-2A0300-----------------------------
INT 2A - NETWORK (Microsoft,LANtastic) - CHECK DIRECT I/O
	AX = 0300h
	DS:SI -> ASCIZ device name (may be full path or only drive specifier--
		  must include the colon)
Return: CF clear if direct physical addressing (INT 13,INT 25) permissible
	CF set if access via files only
Notes:	do not use direct disk accesses if this function returns CF set or the
	  device is redirected (INT 21/AX=5F02h)
	may take some time to execute
	this function is called by the DOS kernel on INT 25 and INT 26
	also supported by Lantastic, NetWare, 10NET, etc.
SeeAlso: INT 13,INT 25,INT 26,INT 21/AX=5F02h
--------N-2A04-------------------------------
INT 2A - NETWORK (Microsoft,LANtastic) - EXECUTE NetBIOS REQUEST
	AH = 04h
	AL = error retry
	    00h automatically retry request on errors 09h, 12h, and 21h
	    01h no retry
	    02h ???
	ES:BX -> Network Control Block (see INT 5C"NetBIOS")
Return: AX = 0000h if successful
	AH = 01h on error
	    AL = error code
Notes:	invokes either INT 5B or INT 5C as appropriate
	also supported by Lantastic, NetWare, 10NET, etc.
	NetWare 2.15 NetBIOS emulator returns CF clear if successful, CF set
	  on error
SeeAlso: AH=01h,AX=0500h,INT 5B,INT 5C"NetBIOS"
--------N-2A0500-----------------------------
INT 2A - NETWORK (Microsoft,LANtastic) - GET NETWORK RESOURCE AVAILABILITY
	AX = 0500h
Return: AX reserved
	BX = number of network names available
	CX = number of network control blocks available
	DX = number of network sessions available
Note:	also supported by Lantastic, NetWare, 10NET, etc.
SeeAlso: AH=01h,AH=04h,INT 5C"NetBIOS"
--------N-2A06-------------------------------
INT 2A - NETBIOS, LANtastic - NETWORK PRINT-STREAM CONTROL
	AH = 06h
	AL = function
	    01h set concatenation mode (all printer output put in one job)
	    02h set truncation mode (default)
		printer open/close starts new print job
	    03h flush printer output and start new print job
Return: CF set on error
	    AX = error code
	CF clear if successful
Notes:	subfunction 03h is equivalent to Ctrl/Alt/keypad-*
	also supported by LANtastic, NetWare, 10NET, etc.
	LANtastic v4.x no longer supports this call
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
	AL = critical section number (00h-0Fh) (see #1227)
Notes:	normally hooked to avoid interrupting a critical section, rather than
	  called
	the handler should ensure that none of the critical sections are
	  reentered, usually by suspending a task which attempts to reenter
	  an active critical section
	the DOS kernel does not invoke critical sections 01h and 02h unless it
	  is patched.  DOS 3.1+ contains a zero-terminated list of words
	  beginning at offset -11 from the Swappable Data Area
	  (see INT 21/AX=5D06h); each word contains the offset within the
	  DOS data segment of a byte which must be changed from C3h (RET)
	  to 50h (POP AX) under DOS 3.x or from 00h to a nonzero value under
	  DOS 4+ to enable use of critical sections.  For DOS 4+, all words in
	  this list point at the byte at offset 0D0Ch.
SeeAlso: AH=81h,AH=82h,AX=8700h,INT 21/AX=5D06h,INT 21/AX=5D0Bh

(Table 1227)
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
 0Ah	MSCDEX
 0Fh	IBM PC LAN server (while intercepting INT 10/AH=06h,07h,0Eh)
--------D-2A81-------------------------------
INT 2A CU - NETWORK - END DOS CRITICAL SECTION
	AH = 81h
	AL = critical section number (00h-0Fh) (see #1227)
Notes:	normally hooked rather than called
	the handler should reawaken any tasks which were suspended due to an
	  attempt to enter the specified critical section
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
Note:	this vector is not used in DOS versions <= 6.00, and points at an IRET
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
	    AX = error code (see #1228)
Notes:	this INT 2C interface is used by Netroom's DPMI.EXE v3.00
	to access extended memory, set the base address to the desired
	  physical address plus 400000h (4M)
	this function was first introduced with RM386 (RAM-MAN/386) v6.00, the
	  memory manager included in Helix Software's Netroom
SeeAlso: AX=0001h,AX=0002h,AX=0003h,AX=0004h,AX=0005h,INT 31/AH=57h

(Table 1228)
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
	    AX = error code (see #1228)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0000h,INT 2F/AX=4310h"Cloaking"
--------m-2C0002-----------------------------
INT 2C P - Cloaking - SET SEGMENT BASE ADDRESS
	AX = 0002h
	SI = selector
	EBX = new physical base addres
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1228)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0000h,AX=0003h,AX=0004h,INT 31/AX=0007h
--------m-2C0003-----------------------------
INT 2C P - Cloaking - SET SEGMENT LIMIT
	AX = 0003h
	SI = selector
	EBX = new limit
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1228)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0000h,AX=0002h,AX=0004h,INT 31/AX=0008h
--------m-2C0004-----------------------------
INT 2C P - Cloaking - SET SEGMENT ACCESS MODE
	AX = 0004h
	SI = selector
	CL = new access mode byte
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1228)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0000h,AX=0002h,AX=0003h,AX=0005h,INT 31/AX=0009h
--------m-2C0005-----------------------------
INT 2C P - Cloaking - SET SEGMENT EXTENDED ACCESS MODE
	AX = 0005h
	SI = selector
	CL = new extended access mode byte (limit field ignored) (see #1229)
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1228)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0000h,AX=0002h,AX=0003h,AX=0004h,INT 31/AX=0009h

Bitfields for extended access mode byte:
Bit(s)	Description	(Table 1229)
 7	4K granularity instead of byte granularity
 6	32-bit code segment
 5	reserved (0)
 4	segment available to system
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
	DX:EBX = new value for passalong address
Return: CF clear
Notes:	when an INT 2C instruction is executed in V86 mode, the Cloaking host
	  calls the passalong address.  The handler should check whether the
	  upcall is of interest to it, and if not it should jump to the old
	  passalong address (retrieved with AX=0008h before the handler was
	  installed).  The final handler should return with CF clear to cause
	  the interrupt to be reflected back to V86 mode if none of the
	  passalong handlers is triggered
	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0008h,AX=002Dh,INT 2C"CLOAKING"

(Table 1230)
Values Cloaking passalong address is called with:
	EAX = CS:IP of byte following INT 2C instruction invoking passalong
	SS:EBX -> caller registers (see #1231)
	CF clear
	others undefined
Return: CF clear: pass along to V86-mode INT 2C handler
	CF set: return immediately to V86 mode

Format of Cloaking caller registers:
Offset	Size	Description	(Table 1231)
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
	    AX = error code (see #1228)
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
	    AX = error code (see #1228)
Note:	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=000Ah,INT 2F/AX=4310h"Cloaking"
--------m-2C---------------------------------
INT 2C P - RM386 v6.00 - CLOAKING - RESERVED FOR CLOAKED BIOS USE UNDER WINDOWS
	AX = function (000Ch-001Fh)
--------m-2C000F-----------------------------
INT 2C P - Cloaking v1.01 - "Simulate_Shell_Event"
	AX = 000Fh
	ECX = event code (see #1232)
	DX = subfunction for event
	EDX high word = boost value (see #1233)
	SI:EDI -> completion procedure
Return: CF clear if successful (event scheduled)
	CF set on error
Note:	this function is only available while MS Windows is running
SeeAlso: AX=0011h,AX=0012h,INT 2F/AX=1605h,INT 2F/AX=4310h"Cloaking"

(Table 1232)
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
Bit(s)	Description	(Table 1233)
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
--------m-2C0011-----------------------------
INT 2C P - Cloaking v1.01 - "Query_Current_VM"
	AX = 0012h
Return: CF clear
	EBX = handle of active VM
	ESI = handle of system VM
	ECX = VM status flags (see #1234)
	EDX = shell flags (see #1235)
Note:	this function is only available while MS Windows is running in enhanced
	  mode
SeeAlso: AX=000Fh,AX=0011h,AX=0013h

Bitfields for VM status flags:
Bit(s)	Description	(Table 1234)
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
Bit(s)	Description	(Table 1235)
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
	EDX = message box flags (see #1236)
	DS:ECX -> ASCIZ message text
	DS:EDI -> ASCIZ caption
Return: CF clear
	EAX = response code
Note:	this function is only available while MS Windows is running in enhanced
	  mode
SeeAlso: AX=000Fh,AX=0012h

Bitfields for message box flags:
Bit(s)	Description	(Table 1236)
 3-0	response codes (see #1237)
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

(Table 1237)
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
--------m-2C001E-----------------------------
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
	DS:EBX -> client register structure (see #1231)
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
	DS:EBX -> client register structure (see #1231)
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
	DS:EBX -> client register structure (see #1231)
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
	DX:EBX = new I/O trapping passalong address
Return: CF clear
Notes:	RM386 calls the passalong address whenever an access to a monitored
	  I/O port is attempted; the handler should check whether it is a port
	  that it is interested in, and if not call the previous passalong
	  address (which was retrieved with AX=002Ch before installing the
	  new handler)
	this function was first introduced with RM386 (RAM-MAN/386) v6.00
SeeAlso: AX=0009h,AX=002Ch,INT 67/AX=5DEAh

(Table 1238)
Values Cloaking port-trapping passalong address is called with:
	EAX = CS:IP of faulting instruction (unless executing in protected-mode
		ring 3)
	SS:EBX -> caller register structure (see #1231)
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
Program: RM386 (RAM-MAN/386) is the memory manager included in Helix Software's
	  Netroom
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
----------2C0033-----------------------------
INT 2C P - Cloaking v1.01 - REGISTER CLOAKING CLIENT
	AX = 0033h
	DS:EDX -> client registration structure (see #1239)
Return: CF clear if successful
	CF set on error (linked list corrupt)
SeeAlso: AX=0034h,#1365 at INT 2F/AX=4310h"Cloaking"

Format of client registration structure:
Offset	Size	Description	(Table 1239)
 00h	PWORD	link to next structure
 06h	PWORD	link to previous structure
 0Ch  2 BYTEs	client version (major, minor)
 0Eh 20 BYTEs	client name
 22h	DWORD	physical address of client start
 26h	DWORD	client's total size in bytes
Note:	the link area should not be modified once the structure has been
	  used for the registration call
----------2C0033-----------------------------
INT 2C P - Cloaking v1.01 - UNREGISTER CLOAKING CLIENT
	AX = 0034h
	DS:EDX -> client registration structure (see #1239)
Return: CF clear if successful
	CF set on error (linked list corrupt)
Note:	the client must unregister before freeing the XMS block containing
	  its registration structure(s)
SeeAlso: AX=0033h,#1365 at INT 2F/AX=4310h"Cloaking"
--------!---Section--------------------------
