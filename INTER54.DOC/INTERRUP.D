Interrupt List, part 4 of 16
Copyright (c) 1989,1990,1991,1992,1993,1994,1995,1996,1997 Ralf Brown
--------b-166F00-----------------------------
INT 16 - HP Vectra EX-BIOS - "F16_INQUIRE" - Extended BIOS INSTALLATION CHECK
	AX = 6F00h
	BX <> 4850h (usually set to 0000h for simplicity)
Return: BX = 4850h ("HP") if present
Notes:	called by recent MS Mouse drivers looking for an HP-HIL mouse
	supported by the original HP Vectra AT and ES/QS/RS series HP Vectras
SeeAlso: AX=6F01h,AX=6F04h,AX=6F07h,AX=6F09h,AX=6F0Dh,AX=6F11h,AX=6F12h
SeeAlso: INT 14/AX=6F00h,INT 17/AX=6F00h,INT 33/AX=6F00h
SeeAlso: INT 6F/AH=00h"HP Vectra"
--------b-166F01-----------------------------
INT 16 - HP Vectra EX-BIOS - "F16_DEF_ATTR" - GET DEFAULT TYPEMATIC VALUES
	AX = 6F01h
Return: AH = 00h (successful)
	CX = 0004h (size of returned buffer)
	ES:SI -> buffer for typematic info (see #0513)
Note:	supported by the original HP Vectra AT and ES/QS/RS series HP Vectras
SeeAlso: AX=6F00h,AX=6F02h,AX=6F03h,AX=6F04h

Format of HP Vectra EX-BIOS typematic info:
Offset	Size	Description	(Table 0513)
 00h	BYTE	delay before repeat for all non-Cursor Control Pad keys
		(see #0514)
 01h	BYTE	typematic rate for all non-Cursor Control Pad keys (see #0515)
 02h	BYTE	delay before repeat for Cursor Control Pad keys	(see #0516)
 03h	BYTE	typematic rate for Cursor Control Pad keys (see #0515)

(Table 0514)
Values for HP Vectra EX-BIOS non-CCP delay time:
 00h	17 ms
 01h	150 ms
 02h	283 ms
 03h	417 ms
 04h	550 ms
 05h	683 ms
 06h	817 ms
 07h	950 ms
 08h	1083 ms
 09h	1217 ms
 0Ah	1350 ms
 0Bh	1483 ms
 0Ch	1617 ms
 0Dh	1750 ms
 0Eh	1883 ms
 0Fh	2017 ms
Note:	the above values assume that the key repeat rate has been set to 60 Hz;
	  double the times if set to 30 Hz
SeeAlso: #0513,#0515,#0516

(Table 0515)
Values for HP Vectra EX-BIOS typematic rate:
 00h	60 / sec
 01h	30 / sec
 02h	20
 03h	15
 04h	12
 05h	10
 06h	8.57
 07h	7.5
 08h	6.66
 09h	6 / sec
 0Ah	5.45
 0Bh	5
 0Ch	4.62
 0Dh	4.28
 0Eh	4 / sec
 0Fh	typematic disabled
Note:	the above values assume that the key repeat rate has been set to 60 Hz;
	  halve the rates if set to 30 Hz
SeeAlso: #0514,#0516

(Table 0516)
Values for HP Vectra EX-BIOS CCP delay time:
 00h	17 ms
 01h	83 ms
 02h	150 ms
 03h	217 ms
 04h	283 ms
 05h	350 ms
 06h	417 ms
 07h	483 ms
 08h	550 ms
 09h	617 ms
 0Ah	683 ms
 0Bh	750 ms
 0Ch	817 ms
 0Dh	883 ms
 0Eh	950 ms
 0Fh	1017 ms
Note:	the above values assume that the key repeat rate has been set to 60 Hz;
	  double the times if set to 30 Hz
SeeAlso: #0514,#0515
--------b-166F02-----------------------------
INT 16 - HP Vectra EX-BIOS - "F16_GET_ATTR" - GET CURRENT TYPEMATIC VALUES
	AX = 6F02h
Return: AH = 00h (successful)
	CX = 0004h (size of returned buffer)
	ES:SI -> buffer for typematic info (see #0513)
Note:	supported by the original HP Vectra AT and ES/QS/RS series HP Vectras
SeeAlso: AX=6F00h,AX=6F02h,AX=6F03h,AX=6F04h
SeeAlso: AX=6F00h,AX=6F01h,AX=6F03h
--------b-166F03-----------------------------
INT 16 - HP Vectra EX-BIOS - "F16_SET_ATTR" - SET TYPEMATIC VALUES
	AX = 6F03h
	ES:SI -> buffer containing typematic info (see #0513)
Return: AH = 00h (successful)
Note:	supported by the original HP Vectra AT and ES/QS/RS series HP Vectras
SeeAlso: AX=6F00h,AX=6F02h,AX=6F03h,AX=6F04h
SeeAlso: AX=6F00h,AX=6F01h,AX=6F02h
--------b-166F04-----------------------------
INT 16 - HP Vectra EX-BIOS - "F16_DEF_MAPPING" - GET DEFAULT KEY MAPPINGS
	AX = 6F04h
	ES:SI -> mapping buffer (see #0517)
Return: AH = 00h (successful)
	CX = 001Eh (number of bytes in buffer)
	ES:SI buffer filled
Notes:	supported by the original HP Vectra AT and ES/QS/RS series HP Vectras
	the HIL input system translates the HIL keyboard events to simulate
	  an IBM-compatible keyboard; the translation can be altered
	  dynamically by applications
SeeAlso: AX=6F00h,AX=6F05h,AX=6F06h

Format of HP Vectra EX-BIOS keyboard mapping info:
Offset	Size	Description	(Table 0517)
 00h  3 WORDs	entry for V_QWERTY driver (IP, CS, DS)
 06h  3 WORDs	entry for V_SOFTKEY driver (IP, CS, DS)
 0Ch  3 WORDs	entry for V_FUNCTION driver
 12h  3 WORDs	entry for V_NUMPAD driver
 18h  3 WORDs	entry for V_CCP driver
--------b-166F05-----------------------------
INT 16 - HP Vectra EX-BIOS - "F16_GET_MAPPING" - GET CURRENT KEY MAPPINGS
	AX = 6F05h
	ES:SI -> mapping buffer (see #0517)
Return: AH = 00h (successful)
	CX = 001Eh (number of bytes in buffer)
	ES:SI buffer filled
Note:	supported by the original HP Vectra AT and ES/QS/RS series HP Vectras
SeeAlso: AX=6F04h,AX=6F06h
--------b-166F06-----------------------------
INT 16 - HP Vectra EX-BIOS - "F16_SET_MAPPING" - SET KEY MAPPINGS
	AX = 6F06h
	CX = number of bytes in buffer (001Eh)
	ES:SI -> mapping buffer (see #0517)
Return: AH = 00h (successful)
Notes:	supported by the original HP Vectra AT and ES/QS/RS series HP Vectras
	any application which modifies the key mappings should restore them
	  before terminating
	drivers installed with this function are assured of 32 bytes of stack
	  space when they are invoked
SeeAlso: AX=6F04h,AX=6F05h,AX=6F07h
--------b-166F07-----------------------------
INT 16 - HP Vectra EX-BIOS - "F16_SET_XLATORS" - SET CCP AND SOFTKEY PADS
	AX = 6F07h
	BL = translation to set (see #0518)
Return: AH = 00h (successful)
Notes:	supported by the original HP Vectra AT and ES/QS/RS series HP Vectras
	this function may no longer work properly if the application has
	  modified the key mappings with AX=6F06h
SeeAlso: AX=6F06h,AX=6F09h

(Table 0518)
Values for HP Vectra keyboard translation specifier:
 00h	map V_CCP to V_CCPCUR, forcing the cursor pad to return cursor keys
 01h	map V_CCP to V_CCPNUM, forcing the cursor pad to always return numbers
 02h	map V_CCP to V_OFF, disabling the cursor pad
 03h	map V_CCP to V_CCPGID, converting cursor pad keys to GID data
 04h	map V_CCP to V_RAW, passing cursor pad data untranslated to INT 09
 05h	map V_SOFTKEY to V_SKEY2KFEY, translating into standard function keys
 06h	map V_SOFTKEY to V_RAW, passing Softkey scancodes direct to INT 09
 07h	map V_SOFTKEY to V_OFF, disabling HP Softkeys
SeeAlso: #0519

(Table 0519)
Values for HP Vectra scancodes and BIOS keycodes for V_RAW translator:
	      INT 09		 INT 16 keycode
    Key	     scan code	Default	 Shifted   Ctrl	     Alt
 * (NumPd)	37h	2Ah	 (Prt Sc)  00/72h    00/37H
 Sysreq		54h	  --	 --	   --	     --
 CCP-Up		60h	00/D9h	 00/BFh	   00/A5h    00/8BH
 CCP-Left	61h	00/DAh	 00/C0h	   00/A6h    00/8CH
 CCP-Down	62h	00/DBh	 00/C1h	   00/A7h    00/8DH
 CCP-Right	63h	00/DCh	 00/C2h	   00/A8h    00/8EH
 CCP-Home	64h	00/DDh	 00/C3h	   00/A9h    00/8FH
 CCP-PgUp	65h	00/DEh	 00/C4h	   00/AAh    00/90H
 CCP-End	66h	00/DFh	 00/C5h	   00/ABh    00/91H
 CCP-PgDn	67h	00/E0h	 00/C6h	   00/ACh    00/92H
 CCP-Ins	68h	00/E1h	 00/C7h	   00/ADh    00/93H
 CCP-Del	69h	00/E2h	 00/C8h	   00/AEh    00/94H
 CCP-CNTR	6Ah	00/E3h	 00/C9h	   00/AFh    00/95H
 f1		70h	00/E9h	 00/CFh	   00/B5h    00/9BH
 f2		71h	00/EAh	 00/D0h	   00/B6h    00/9CH
 f3		72h	00/EBh	 00/D1h	   00/B7h    00/9DH
 f4		73h	00/ECh	 00/D2h	   00/B8h    00/9EH
 f5		74h	00/EDh	 00/D3h	   00/B9h    00/9FH
 f6		75h	00/EEh	 00/D4h	   00/BAh    00/A0H
 f7		76h	00/EFh	 00/D5h	   00/BBh    00/A1H
 f8		77h	00/F0h	 00/D6h	   00/BCh    00/A2H
Note:	only HP-specific codes are listed in this table; see INT 09 for a full
	  list of standard scan codes
SeeAlso: #0005,#0518
--------b-166F08-----------------------------
INT 16 - HP Vectra EX-BIOS - "F16_KBD" - GET KEYBOARD INFORMATION
	AX = 6F08h
Return: AH = status
	   00h successful
	   02h unsupported (non-HIL, i.e. standard, keyboard)
	BH = HP-HIL address (HP Vectra AT only???)
	BL = HP-HIL ID (HP Vectra AT only???)
	BL = keyboard language (ES/QS/RS only???) (see #0520)
Notes:	supported by the original HP Vectra AT and ES/QS/RS series HP Vectras
	the driver's address in the HP_VECTOR_TABLE (see INT 6F/AH=00h) may
	  be computed as (BH-1)*6 + N, where N is the address of the first
	  HP-HIL device driver (see INT 6F/AH=0Ah"F_INQUIRE_FIRST")
SeeAlso: AX=6F05h,AX=6F09h,INT 6F/AH=0Ah"F_INQUIRE_FIRST"

(Table 0520)
Values for HP HIL keyboard language code:
 00h	reserved
 01h	Arabic-French
 02h	Kanji
 03h	Swiss-French
 04h	Portugese
 05h	Arabic
 06h	Hebrew
 07h	Canadian-English
 08h	Turkish
 09h	Greek
 0Ah	Thai
 0Bh	Italian
 0Ch	Hangul (Korean)
 0Dh	Dutch
 0Eh	Swedish
 0Fh	German
 10h	Chinese (PRC)
 11h	Chinese (Taiwan)
 12h	Swiss (French ii)
 13h	Spanish
 14h	Swiss (German ii)
 15h	Belgian (Flemish)
 16h	Finish
 17h	United Kingdom
 18h	French-Canadian
 19h	French-German
 1Ah	Norwegian
 1Bh	French
 1Ch	Danish
 1Dh	Katakana
 1Eh	Latin American Spanish
 1Fh	United States-American
 20h-FEh reserved
 FFh	non-HP keyboard (IBM AT keyboard and IBM Enhanced keyboard)
--------b-166F09-----------------------------
INT 16 - HP Vectra EX-BIOS - "F16_KBD_RESET" - RESET KEYBOARD TO DEFAULTS
	AX = 6F09h
Return: AH = 00h (successful)
Desc:	reset all keyboard mappings to their default translators, and reset
	  typematic values to their defaults
Note:	supported by the original HP Vectra AT and ES/QS/RS series HP Vectras
SeeAlso: AX=6F04h,AX=6F07h,AX=6F08h
--------b-166F0A-----------------------------
INT 16 - HP Vectra ES/QS/RS EX-BIOS - READ PROCESSOR SPEED
	AX = 6F0Ah
Return: AH = 00h (successful)
	BX = speed code
	    0Bh for low speed (see #0521)
	    12h for medium speed (see #0521)
	    0Ch for high speed (see #0521)
Note:	supported by ES, QS, and RS series of HP Vectras
SeeAlso: AX=6F00h

(Table 0521)
Values for HP Vetra CPU speed:
	Vectra		Low	    Medium	High
	ES		8 MHz	     -		 8 MHz
	ES/12		8 MHz	     -		12 MHz
	QS/16, RS/16	8 MHz	     -		16 MHz
	QS/16S		8 MHz	     -		16 MHz
	QS/20, RS/20	8 MHz	     -		20 MHz
	RS/20C		5 MHz	    10 MHz	20 MHz
	RS/25C		5 MHz	    12.5 MHz	25 MHz
--------b-166F0B-----------------------------
INT 16 - HP Vectra ES/QS/RS EX-BIOS - SET PROCESSOR SPEED TO LOW
	AX = 6F0Bh
Return: AH = 00h (successful)
Notes:	see AX=6F0Ah for speed definitions
	supported by ES, QS, and RS series of HP Vectras
SeeAlso: AX=6F00h,AX=6F0Ah
--------b-166F0C-----------------------------
INT 16 - HP Vectra ES/QS/RS EX-BIOS - SET PROCESSOR SPEED TO HIGH
	AX = 6F0Ch
Return: AH = 00h (successful)
Notes:	see AX=6F0Ah for speed definitions
	supported by ES, QS, and RS series of HP Vectras
SeeAlso: AX=6F00h,AX=6F0Ah
--------b-166F0D-----------------------------
INT 16 - HP Vectra ES/QS/RS EX-BIOS - GET HIL Extended BIOS INTERRUPT NUMBER
	AX = 6F0Dh
Return: AH = interrupt number (default 6Fh, 02h means 6Fh as well)
Notes:	supported by ES, QS, and RS series of HP Vectras
	called by MS Windows HPSYSTEM.DRV and HPEBIOS.386 to support the HP-HIL
	  input system
SeeAlso: AX=6F00h,AX=6F0Eh,INT 6F/AH=00h"HP Vectra",INT 6F/AH=0Ah"HP"
--------b-166F0E-----------------------------
INT 16 - HP Vectra ES/QS/RS EX-BIOS - SET HIL Extended BIOS INTERRUPT NUMBER
	AX = 6F0Eh
	BL = new interrupt number (60h-6Fh,78h-7Fh)
Return: AH = status (00h = successful)
Desc:	allows the HIL Extended BIOS software to use a non-default interrupt
	  number in case of an interrupt conflict with another application
Notes:	supported by ES, QS, and RS series of HP Vectras
	called by MS Windows HPSYSTEM.DRV and HPEBIOS.386 to support the HP-HIL
	  input system
SeeAlso: AX=6F00h,AX=6F0Dh,INT 6F/AH=00h"HP",INT 6F/AH=0Ah"HP"
--------b-166F0F-----------------------------
INT 16 - HP Vectras RS/20C and RS/25C - ENABLE MEMORY CACHING
	AX = 6F0Fh
Return: AH = status
	    00h successful
	    FEh cache subsystem is bad
SeeAlso: AX=6F00h,AX=6F10h,AX=6F11h
--------b-166F10-----------------------------
INT 16 - HP Vectras RS/20C and RS/25C - DISABLE MEMORY CACHING
	AX = 6F10h
Return: AH = 00h (successful)
SeeAlso: AX=6F00h,AX=6F0Fh,AX=6F11h
--------b-166F11-----------------------------
INT 16 - HP Vectras RS/20C and RS/25C - GET MEMORY CACHING STATE
	AX = 6F11h
Return: AH = 00h (successful)
	AL bit 0 = cache state
	    0 cache disabled
	    1 cache enabled
SeeAlso: AX=6F00h,AX=6F0Fh,AX=6F10h
--------b-166F12-----------------------------
INT 16 - HP Vectras RS/20C and RS/25C - SET PROCESSOR SPEED TO MEDIUM
	AX = 6F12h
Return: AH = 00h (successful)
Note:	see AX=6F0Ah for speed definitions
SeeAlso: AX=6F00h,AX=6F0Ah
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
	DS:SI -> array of tones (see #0522)
Program: FAKEY is a keystroke faking utility by System Enhancement Associates
SeeAlso: INT 15/AX=1019h

Format of FAKEY.COM tone array entries:
Offset	Size	Description	(Table 0522)
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
	AL = baud rate (see #0523)
SeeAlso: AX=7B00h,AH=7Eh

(Table 0523)
Values for pcANYWHERE III baud rate:
 00h	50 baud
 01h	75 baud
 02h	110 baud
 03h	134.5 baud
 04h	150 baud
 05h	300 baud
 06h	600 baud
 07h	1200 baud
 08h	1800 baud
 09h	2000 baud
 0Ah	2400 baud
 0Bh	4800 baud
 0Ch	7200 baud
 0Dh	9600 baud
 0Eh	19200 baud
SeeAlso: #0228
--------R-167D-------------------------------
INT 16 - pcANYWHERE III - GET/SET TERMINAL PARAMETERS
	AH = 7Dh
	AL = subfunction
	    00h set terminal parameters
	    01h get terminal parameters
	    02h get configuration header and terminal parameters
	DS:CX -> terminal parameter block
SeeAlso: AH=7Ch,AH=7Eh
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
SeeAlso: AH=7Ch
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
--------K-1687-------------------------------
INT 16 - DK.COM v1.03 - INSTALLATION CHECK
	AH = 87h
Return: AX = 4A57h ('JW') if installed
Program: DK.COM is the resident part of a small keyboard macro utility
	  by Digital Mechanics.
--------U-168765BX4321-----------------------
INT 16 - AT.COM version 8/26/87 - API
	AX = 8765h
	BX = 4321h
	CX = ??? or FFFFh
	if CX = FFFFh
		DX = number of event to remove or FFFFh
Return: ES:BX -> event record array (see #0524)
Program: AT.COM is a resident scheduler by Bill Frolik

Format of AT.COM event record:
Offset	Size	Description	(Table 0524)
 00h	BYTE	in-use flag (00h free, 01h in use, FFh end of array)
 01h	BYTE	day of date on which to trigger
 02h	BYTE	month of date on which to trigger
 03h	BYTE	trigger time, minute
 04h	BYTE	trigger time, hour
 05h	WORD	offset of command to be executed
--------K-1692-------------------------------
INT 16 - KEYB.COM KEYBOARD CAPABILITIES CHECK (not an actual function!)
	AH = 92h
Return: AH <= 80h if enhanced keyboard functions (AH=10h-12h) supported
Desc:	this function is called by the DOS 3.2 KEYBxx.COM and DOS 5+ KEYB.COM
	  to determine the highest supported keyboard function
Note:	many BIOSes (including at least some versions of Phoenix and AMI) will
	  destroy AH on return from functions higher than AH=12h, returning
	  12h less than was in AH on entry (due to a chain of DEC/JZ
	  instructions)
SeeAlso: AH=05h"PCjr",AH=A2h,INT 2F/AX=AD80h
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
--------K-16A2-------------------------------
INT 16 - KEYB.COM KEYBOARD CAPABILITIES CHECK (not an actual function!)
	AH = A2h
Return: AH <= 80h if 122-key keyboard functions (AH=20h-22h) supported
Desc:	this function is called by the DOS 3.2 KEYBxx.COM and DOS 5+ KEYB.COM
	  to determine the highest supported keyboard function
Note:	many BIOSes (including at least some versions of Phoenix and AMI) will
	  destroy AH on return from functions higher than AH=12h, returning
	  12h less than was in AH on entry (due to a chain of DEC/JZ
	  instructions)
SeeAlso: AH=05h"PCjr",AH=92h,INT 2F/AX=AD80h
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
--------K-16AF20BX4B33-----------------------
INT 16 - K3PLUS v6.00+ (API v2.0+) - GET EXTENDED BUFFER STATE
	AX = AF20h
	BX = 4B33h ('K3')
Return: AX = K3 version (same as returned in BX by AX=AF4Dh)
	ES:BX -> extended keyboard buffer start
	ES:DX -> extended keyboard buffer end
	ES:SI -> next keystroke
	ES:DI -> last keystroke in buffer
	CX = number of keystrokes in buffer
Program: K3PLUS is an extended keyboard driver by Matthias Paul and Axel C.
	  Frinke, originally based on the K3 extended German keyboard driver
	  by Martin Gerdes published in c't magazine in 1988
Note:	this function replaces the identical function AH=20h"K3"
SeeAlso: AH=20h"K3",AX=AF25h,AX=AF4Dh,AX=AF50h,INT 2F/AX=ED58h
--------K-16AF25BX4B33-----------------------
INT 16 - K3PLUS v6.00+ (API v2.0+) - COPY INTO EXTENDED BUFFER
	AX = AF25h
	BX = 4B33h ('K3')
	CX = number of keystrokes to copy
	ES:SI -> buffer containing keystrokes
Return: CF clear if successful
	CF set on error (i.e. buffer full)
	    CX = number of keystrokes NOT transferred
	    ES:SI -> first keystroke not transferred
Note:	this function replaces the identical function AH=25h"K3"
SeeAlso: AH=25h"K3",AX=AF20h,AX=AF4Dh,AX=AF50h,INT 2F/AX=D44Fh/BX=0001h
--------K-16AF4DBX4B33-----------------------
INT 16 - K3PLUS v6.00+ (API v2.0+) - GET VERSION INFORMATION
	AX = AF4Dh
	BX = 4B33h ('K3')
Return: AL = 50h if installed
	    BX = K3 version
	    DX = API version
	    ES:CX -> K3 structure (version-dependent) (see #0525)
Program: K3PLUS is an extended keyboard driver by Matthias Paul and Axel C.
	  Frinke, originally based on the K3 extended German keyboard driver
	  by Martin Gerdes published in c't magazine in 1988
SeeAlso: AX=AF20h,AX=AF50h,AX=AF80h,AX=AF82h/BX=4B33h,INT 2F/AX=D44Fh/BX=0000h
SeeAlso: INT 2F/AX=ED58h
Index:	installation check;K3PLUS

Format of internal K3 structure:
Offset	Size	Description	(Table 0525)
 00h  3 BYTEs	signature "K3$"
 03h	BYTE	length of structure, including this byte and signature
 04h	WORD	compiler switch option flags A (see #0526)
 06h	WORD	compiler switch option flags B (see #0527)
 08h	BYTE	internal flags A (see #0528)
 09h	BYTE	internal flags B (see #0529)
 0Ah	WORD	DOS version recorded at startup
 0Ch	WORD	"ActTypeSpeed"
 0Eh	WORD	last Keyboard-ID sent
		41ABh translated, 83ABh native (pass-through)
 10h	WORD	offset of K3TAB Special
 12h	WORD	offset of K3TAB German
 14h	WORD	offset of K3TAB Alt
 16h	WORD	offset of K3TAB AltGr
 18h	WORD	offset of K3TAB Ctrl
 1Ah	WORD	offset of K3TAB NPad
 1Ch	WORD	offset of K3TAB CtrlNPad
 1Eh	WORD	offset of K3TAB AltNPad
 20h	WORD	offset of K3TAB ApoTbl or 0000h
 22h	WORD	offset of K3TAB UmlautTbl or 0000h
 24h	WORD	offset of K3TAB UmlautTblExp or 0000h
 26h	WORD	length of video mode table
 28h	WORD	offset of VidMdTbl or 0000h
 2Ah	BYTE	'$' end marker

Bitfields for K3PLUS compiler switch option flags A:
Bit(s)	Description	(Table 0526)
 15	GuINT16Fct2 (general use of INT 16 function 2)
 14	Int15df (INT 15 has to be predefined)
 13	GuAltNP (general use of Alt Numpad)
 12	SupAT (ATs+ supported)
 11	GuINT16Fct3 (general use of INT 16 function 3)
 10	GuINT16Ret (general use of INT16 bad function return)
 9-8	Layout (0-2, 3 reserved; 0=PC, 1=AT, 2=MF)
 7	ForceMF (force MF decode without read-ID)
 6	KXlate (translate keys for special keyboard)
 5	UmlautX (umlaut translation capability included)
 4	ApoX (translate apostrophe)
 3	DoINT16 (INT 16 handler included)
 2	UseCC (CopyCursor included)
 1-0	UseEB
	0=no extended keystroke buffer, 1=reserve mem, 2=use PSP, 3=reserved

Bitfields for K3 compiler switch option flags B:
Bit(s)	Description	(Table 0527)
 15-11	reserved (0)
 10	CtrlSeq (Ctrl macro capability included)
 9-8	SupINT16fct55FE
 6	DoInstallCheck (check for double installation)
 5	SupINT16fct5PcJr (INT 16/AH=05h"PCjr" supported)
 4	SendOut (sound and message output supported)
 3	SupInt16fct5500 (INT 16/AX=5500h supported)
 2	GuINT15Fct4F (calls to INT 15/AH=4Fh supported)
 1-0	UseBufferStart (0=use standard area, 1=set standard area,
	2=use internal indexes, 3=reserved)

Bitfields for K3 internal flags A:
Bit(s)	Description	(Table 0528)
 7	DoingUmlautExp
 6	CallINT15fct4F
 5	Beep1 (requires SendOut set in option flags B)
 4	ATflag (set for AT, 386, PS/2 Models 50-80)
 3	XTflag (set for PC, PC/XT, Micromint PC, Pencock PC, PS/2 Model 30)
 2	KeyClick
 1	UmlautExp
 0	UmlautTrans

Bitfields for K3 internal flags B:
Bit(s)	Description	(Table 0529)
 7-5	reserved
 4	TranslateE0 enabled
 3	Boot enabled
 2	PrintScreen enabled
 1	Break enabled
 0	ApoPendingBeep
--------K-16AF50BX4B33-----------------------
INT 16 - K3PLUS v6.00+ (API v2.0+) - CHECK IF FUNCTION SUPPORTED
	AX = AF50h
	BX = 4B33h ('K3')
	CH = function
	    00h get function flags
		CL = 00h
		Return: CX = supported function flags (see #0530)
	    nonzero reserved for extensions
SeeAlso: AX=AF20h,AX=AF4Dh,AX=AF51h,AX=AF80h

Bitfields for K3PLUS supported function list:
Bit(s)	Description	(Table 0530)
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
--------K-16AF51BX4B33-----------------------
INT 16 - K3PLUS v6.00+ (API v2.00+) - SET OPTIONS
	AX = AF51h
	BX = 4B33h ('K3')
	CX = switches
Return: AL = status
	    00h done
		CX = previous switch settings
	    01h switch not supported
	    FFh other error
SeeAlso: AX=AF4Dh,AX=AF50h,AX=AF80h
--------K-16AF80BX4B33-----------------------
INT 16 - K3PLUS v6.00+ (API v2.00+) - GET ORIGINAL INT 09h VECTOR
	AX = AF80h
	BX = 4B33h ('K3')
Return: AL = status
	    00h not supported
	    81h if successful
		ES:CX -> original INT 09 handler
SeeAlso: AX=AF4Dh,AX=AF50h,AX=AF81h,AX=AF82h
--------K-16AF81BX4B33-----------------------
INT 16 - K3PLUS v6.00+ (API v2.00+) - GET ORIGINAL INT 16h HANDLER
	AX = AF81h
	BX = 4B33h ('K3')
Return: AL = status
	    00h not supported
	    82h if successful
		ES:CX -> original INT 16 handler
SeeAlso: AX=AF4Dh,AX=AF50h,AX=AF80h,AX=AF82h
--------K-16AF82BX4B33-----------------------
INT 16 - K3PLUS v6.00+ (API v2.00+) - GET ORIGINAL INT 10h HANDLER
	AX = AF82h
	BX = 4B33h ('K3')
Return: AL = status
	    00h not supported
	    83h if successful
		ES:CX -> original INT 10 handler
Program: K3PLUS is an extended keyboard driver by Matthias Paul and Axel C.
	  Frinke, originally based on the K3 extended German keyboard driver
	  by Martin Gerdes published in c't magazine in 1988
SeeAlso: AX=AF4Dh,AX=AF50h,AX=AF80h,AX=AF81h,INT 2F/AX=ED58h
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
Program: EGAPAL is a TSR supplied with STACKEY which makes EGA palette
	  settings permanent across mode switches
SeeAlso: AX=CA00h/BX=7670h
--------V-16CA00BX7670-----------------------
INT 16 - CtrlAlt Associates VGAPAL.COM v1.00 - INSTALLATION CHECK
	AX = CA00h
	BX = 7670h ("vp")
	CX = 7670h
Return: AX = CAFFh if installed
	    BX = segment of resident code
	    CX = ??? (0090h)
Program: VGAPAL is a TSR supplied with STACKEY which makes VGA palette
	  settings permanent across mode switches
SeeAlso: AX=CA00h/BX=6570h
--------U-16CB00-----------------------------
INT 16 - PUPClip v1.12+ - INSTALLATION CHECK
	AX = CB00h
Return: BX = 4342h if installed
	    AX = version (AH = major version, AL = BCD minor version)
Program: PUPClip is the freeware PopUP Clipboard for DOS and Windows DOS
	 sessions by SkullC0DEr
SeeAlso: AX=CB01h,AX=CB02h,AX=CB03h,AX=CB04h,AX=CB05h,AX=CB06h,AX=CB08h
SeeAlso: INT 2F/AX=1701h
--------U-16CB01-----------------------------
INT 16 - PUPClip v1.12+ - GET CLIPBOARD CURSOR POSITION
	AX = CB01h
Return: BL = column (0-79)
	BH = row (0-49)
SeeAlso: AX=CB00h,AX=CB02h,AX=CB03h
--------U-16CB02-----------------------------
INT 16 - PUPClip v1.12+ - SET CLIPBOARD CURSOR POSITION
	AX = CB02h
	BL = column (0-79)
	BH = row (0-49)
Return: CF clear if successful
	CF set on error (invalid position)
SeeAlso: AX=CB00h,AX=CB01h,AX=CB04h
--------U-16CB03-----------------------------
INT 16 - PUPClip v1.12+ - GET CHARACTER FROM CURRENT CLIPBOARD CURSOR POSITION
	AX = CB03h
Return: BL = ASCII character at current position
SeeAlso: AX=CB00h,AX=CB02h,AX=CB04h,INT 2F/AX=1705h
--------U-16CB04-----------------------------
INT 16 - PUPClip v1.12+ - WRITE CHARACTER TO CURRENT CLIPBOARD CURSOR POSITION
	AX = CB04h
	BL = ASCII character to store
SeeAlso: AX=CB00h,AX=CB02h,AX=CB03h,AX=CB05h,INT 2F/AX=1703h
--------U-16CB05-----------------------------
INT 16 - PUPClip v1.12+ - CLEAR CLIPBOARD CONTENTS
	AX = CB05h
Return: nothing
SeeAlso: AX=CB00h,AX=CB04h,AX=CB06h,AX=CB07h,INT 2F/AX=1702h
--------U-16CB06-----------------------------
INT 16 - PUPClip v1.12+ - SCROLL UP CLIPBOARD CONTENTS
	AX = CB06h
Return: nothing
SeeAlso: AX=CB00h,AX=CB05h,AX=CB07h
--------U-16CB07-----------------------------
INT 16 - PUPClip v1.12+ - SCROLL DOWN CLIPBOARD CONTENTS
	AX = CB07h
Return: nothing
SeeAlso: AX=CB00h,AX=CB05h,AX=CB06h
--------U-16CB08-----------------------------
INT 16 - PUPClip v1.12+ - POP UP
	AX = CB08h
Return: CF clear if successful
	CF set on error (unsupported video mode)
SeeAlso: AX=CB00h
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
--------v-16DD--------------------------
INT 16 - VIRUS - "Frumble" - INSTALLATION CHECK
	AH = DDh
Return: AL = DDh if resident
SeeAlso: INT 13/AX=FD50h,INT 21/AX=010Fh,INT 21/AX=0B56h
--------s-16DFDF-----------------------------
INT 16 U - Corel PowerSCSI - FDAUDIO.COM - INSTALLATION CHECK
	AX = DFDFh
Return: ES:DI -> ASCII signature "FDAUDIO/CD" followed by ASCII date, i.e.
	  "06/18/93" if installed
--------b-16E000-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - GET VERSION NUMBER
	AX = E000h
Return: CF clear if successful
	    AL = FAh
	    BX = version number (BCD) (0200h = v2.00)
	CF set on error (not implemented)
Notes:	this interface is available on AMI BIOSes built from AMI core version
	  8/8/93 (HiFlex BIOS) or 11/15/93 (WinBIOS) or later
	the "Meningitis" virus uses this API when attacking a system equipped
	  with an AMI BIOS; it is supposedly able to write itself into the
	  Flash ROM and thus make itself part of the BIOS
SeeAlso: AX=E001h,AX=E004h,AX=E006h,AX=E008h,AX=E00Ah,AX=E00Bh,AX=E0FFh
--------b-16E001-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - GET CHIPSET SAVE/RESTORE SIZE
	AX = E001h
Return: CF clear if successful
	    AL = FAh
	    BX = number of bytes required to save chipset configuration
	CF set on error
SeeAlso: AX=E000h,AX=E002h,AX=E003h
--------b-16E002-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - SAVE CHIPSET STATUS & PREPARE CHPSET
	AX = E002h
	ES:DI -> buffer for storing chipset status
Return: CF clear if successful
	    AL = FAh
	CF set on error
SeeAlso: AX=E000h,AX=E001h,AX=E003h
--------b-16E003-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface -  RESTORE CHIPSET STATUS
	AX = E003h
	ES:DI -> buffer in which chipset status was previously stored
Return: CF clear if successful
	    AL = FAh
	CF set on error
SeeAlso: AX=E000h,AX=E001h,AX=E002h
--------b-16E004-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - LOWER PROGRAMMING VOLTAGE Vpp
	AX = E004h
Return: CF clear if successful
	    AL = FAh
	CF set on error
Note:	this function does not return until the voltage level stabilizes
SeeAlso: AX=E000h,AX=E005h,AX=E006h
--------b-16E005-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - RAISE PROGRAMMING VOLTAGE Vpp
	AX = E005h
Return: CF clear if successful
	    AL = FAh
	CF set on error
Note:	this function does not return until the voltage level stabilizes
SeeAlso: AX=E000h,AX=E004h,AX=E007h
--------b-16E006-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - FLASH WRITE PROTECT
	AX = E006h
Return: CF clear if successful
	    AL = FAh
	CF set on error
Note:	this function performs any delay required to allow the Flash ROM to
	  stabilize in the write-protected state
SeeAlso: AX=E000h,AX=E004h,AX=E007h
--------b-16E007-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - FLASH WRITE ENABLE
	AX = E007h
Return: CF clear if successful
	    AL = FAh
	CF set on error
Note:	this function performs any delay required to allow the Flash ROM to
	  stabilize in the write-enabled state
SeeAlso: AX=E000h,AX=E005h,AX=E006h,AX=E008h
--------b-16E008-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - FLASH SELECT
	AX = E008h
Return: CF clear if successful
	    AL = FAh
	CF set on error
Desc:	select the Flash ROM if the system contains both EPROM and Flash ROM
Note:	this function performs any delay required to allow the Flash ROM to
	  stabilize in the selected state; if no EPROM is present, this
	  function always returns successfully
SeeAlso: AX=E000h,AX=E007h,AX=E009h
--------b-16E009-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - FLASH DE-SELECT
	AX = E009h
Return: CF clear if successful
	    AL = FAh
	CF set on error
Desc:	select the EPROM if the system contains both EPROM and Flash ROM
Note:	this function performs any delay required to allow the Flash ROM to
	  stabilize in the de-selected state; if no EPROM is present, this
	  function always returns successfully
SeeAlso: AX=E000h,AX=E006h,AX=E008h
--------b-16E00A-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - VERIFY ALLOCATED MEMORY
	AX = E00Ah
	BX = number of paragraphs
	ES = starting segment of memory
Return: CF clear if successful
	    AL = FAh
	CF set on error
Desc:	determine whether the specified memory may be used for flash
	  programming
Note:	always returns error if BX is zero on entry
SeeAlso: AX=E000h,AX=E00Bh
--------b-16E00B-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - SAVE INTERNAL CACHE STATUS
	AX = E00Bh
	ES:DI -> buffer for internal cache status (minimum 4Kbytes)
Return: CF clear if successful
	    AL = FAh
	CF set on error
Note:	always returns error if the hardware does not contain internal
	  cache or this call is made in protected mode
SeeAlso: AX=E000h,AX=E00Ah,AX=E00Ch
--------b-16E00C-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - RESTORE INTERNAL CACHE STATUS
	AX = E00Ch
	ES:DI -> buffer containing internal cache status (minimum 4Kbytes)
Return: CF clear if successful
	    AL = FAh
	CF set on error
Note:	always returns error if the hardware does not contain internal
	  cache or this call is made in protected mode
SeeAlso: AX=E000h,AX=E00Bh
--------t-16E0E0-----------------------------
INT 16 - TurboPower TSRs - ALTERNATE INSTALLATION CHECK
	AX = E0E0h
Return: AX = 1F1Fh if installed
	    DWORD 0040h:00F0h -> last data block in TSR list (see #0532)
Note:	the returned TSR list provides support for communication among TSRs
	  built with TurboPower's Turbo Professional and Object Professional
	  libraries for Turbo Pascal
SeeAlso: AX=F0F0h
--------b-16E0FF-----------------------------
INT 16 - AMI BIOS - BIOS-FLASH Interface - GENERATE CPU RESET
	AX = E0FFh
Return: never
SeeAlso: AX=E000h,INT 14/AH=17h"FOSSIL"
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
	AL = speed code (see #0531)
	if AL=09h,
	    CX = speed value, 1 (slowest) to 50 (full), 3 ~= 8088
Note:	also supported by some versions of AMI BIOS dated June 1992 or later;
	  speed codes 0 or 1 are used for Low Speed, 2 for High Speed
SeeAlso: AH=F1h,AH=F3h

(Table 0531)
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
	    ES:DI -> last data block in TSR list (see #0532)
Note:	the returned TSR list provides support for communication among TSRs
	  built with TurboPower's Turbo Professional and Object Professional
	  libraries for Turbo Pascal
SeeAlso: AX=E0E0h

Format of TurboPower TSR data block:
Offset	Size	Description	(Table 0532)
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
Return: AL = speed code (see #0531)
	if AL = 09h, CX = speed code
Note:	also supported by some versions of AMI BIOS dated June 1992 or later
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
	BH = BIOS scan code of current hot key
	BL = ASCII code of current hot key
Note:	NG.EXE was written by John Socha
--------b-16F400-----------------------------
INT 16 - Compaq Systempro and higher - CACHE CONTROLLER STATUS
	AX = F400h
Return: AH = E2h (*)
	AL = status
	    00h not present
	    01h enabled
	    02h disabled
	CX = cache memory size
	    bit 15:	cache size information is NOT valid
	    bits 14-0:	cache memory size in kilobytes
	DH = cache write technology
	    bit 7:	cache write information is NOT valid
	    bits 6-1:	reserved (0)
	    bit 0:	0 = Write-through caching
			1 = Write-back caching
	DL = cache type
	    bit 7:	cache type information is NOT valid
	    bits 6-1:	reserved (0)
	    bit 0:	0 = Direct mapped
			1 = Two-way set-associative
Notes:	also supported by some versions of AMI BIOS dated June 1992 or later
	many (most) BIOSes return a modified AH when called for an unsupported
	  or non-keyboard function (typically, the highest supported keyboard
	  function [normally 12h] is subtracted from the original AH)
SeeAlso: AX=F401h,AX=F402h
--------b-16F401-----------------------------
INT 16 - Compaq Systempro and higher - ENABLE CACHE CONTROLLER
	AX = F401h
Return: AX = E201h
Notes:	also supported by some versions of AMI BIOS dated June 1992 or later
	many (most) BIOSes return a modified AH when called for an unsupported
	  or non-keyboard function (typically, the highest supported keyboard
	  function [normally 12h] is subtracted from the original AH)
SeeAlso: AX=F400h,AX=F402h
--------b-16F402-----------------------------
INT 16 - Compaq Systempro and higher - DISABLE CACHE CONTROLLER
	AX = F402h
Return: AX = E202h
Notes:	also supported by some versions of AMI BIOS dated June 1992 or later
	many (most) BIOSes return a modified AH when called for an unsupported
	  or non-keyboard function (typically, the highest supported keyboard
	  function [normally 12h] is subtracted from the original AH)
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
	BL = new parameter flags (see #0533)
Return: CF clear
	DI = 4559h
	CL = old value of parameter flags

Bitfields for VSAFE/VWATCH parameter flags:
Bit(s)	Description	(Table 0533)
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
SeeAlso: INT 61/AX=0000h"OPTIMA",INT 61/AX=0005h"OPTIMA"
Index:	hotkeys;OPTIMA 1024 VGA
----------16FF--BH00-------------------------
INT 16 - FREEZE.COM - INSTALLATION CHECK
	AH = FFh
	BH = 00h
Return: BH = FFh if installed
Program: FREEZE is a PC Magazine utility
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
Return: AX = flags (see #0534)
SeeAlso: AX=FF80h/BX=0004h,AX=FF80h/BX=0006h

Bitfields for CPTASK flags:
Bit(s)	Description	(Table 0534)
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
	DS:DX -> buffer for ??? (see #0535)
Return: ???

Format of PC Tools DESKTOP buffer:
Offset	Size	Description	(Table 0535)
 00h 48 BYTEs	???
 30h 128 BYTEs	???
--------U-16FF98-----------------------------
INT 16 U - PC Tools v7+ DESKTOP - OPEN \DESK.OVL FILE AND SEEK TO OVERLAY
	AX = FF98h
	DX = byte offset in file of overlay header (see #0536)
Return: BX = file handle for DESK.OVL file
Desc:	open the DESK.OVL file, seek to the specified offset, read in the
	  overlay header, and seek to the offset specified by the header

Format of PC Tools DESKTOP overlay header:
Offset	Size	Description	(Table 0536)
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
--------d-16FFA3BXFFA3-----------------------
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
	    ES:DI -> internal data (see #0537)
	    CL = cache state
		01h enabled
		02h disabled
SeeAlso: INT 13/AH=27h,INT 13/AH=A0h,INT 21/AH=2Bh/CX=4358h

Format of PC-Cache internal data:
Offset	Size	Description	(Table 0537)
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
	BX = window specifier (000Fh to 0019h) (see #0538)
	DX = 0000h get, nonzero = set
	ES:DI -> window parameter buffer (see #0539)
SeeAlso: AX=FFCBh

(Table 0538)
Values for PC Tools DESKTOP window specifier:
 000Fh	comm/FAX
 0014h	hotkey selection
 0015h	ASCII table
 0016h	system colors menu

Format of PC Tools DESKTOP window parameters:
Offset	Size	Description	(Table 0539)
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
	ES:DI -> data structure (see #0540)
	???
Return: AX = ???
Note:	available only when popped up
SeeAlso: AX=FFC2h,AX=FFC3h

Format of PC Tools DESKTOP data structure:
Offset	Size	Description	(Table 0540)
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
	ES:DI -> data structure (see #0540)
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
	ES:DI -> data structure (see #0540)
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
	    DS:SI -> list of pointers (see #0541)

Format of PC Tools PCShell returned pointer list:
Offset	Size	Description	(Table 0541)
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
	DS:SI -> pulldown menu system description (see #0542)
Return: AX destroyed
Notes:	available only when popped up
	if the accessory does not need any menu items of its own, it should
	  call AX=FFFAh instead
SeeAlso: AX=FFF7h,AX=FFFAh

Format of PC Tools DESKTOP pulldown menu system description:
Offset	Size	Description	(Table 0542)
 00h	WORD	offset of menu bar contents (counted string)
 02h	WORD	number of items on menu bar
 04h 10 BYTEs	scan codes for hotkeying to each of up to ten menu items
 0Eh 10 BYTEs	which character to highlight in each menu item (01h=first)
 18h	WORD	offset of first menu definition (see #0543)
 1Ah	WORD	offset of second menu definition
	...

Format of PC Tools DESKTOP menu definition:
Offset	Size	Description	(Table 0543)
 00h	WORD	offset of menu contents (see #0544)
 02h	WORD	number of entries in menu
 04h	for each entry:
		Offset	Size	Description
		 00h	BYTE	scancode of Alt-key to invoke entry
		 01h	BYTE	character to highlight (01h=first, etc)
		 02h	WORD	offset of FAR routine to handle selection

Format of PC Tools DESKTOP menu contents:
Offset	Size	Description	(Table 0544)
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
Return: ES:BX -> screen attributes data structure (see #0545)
	AL = ??? (v6.0+)

Format of PC Tools DESKTOP attribute data structure:
Offset	Size	Description	(Table 0545)
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
	DS = segment of editor buffer structure (see #0546)
	BX = ???
	DX = segment of window parameters structure (see #0539)
Return: ???
Note:	available only when popped up
SeeAlso: AX=FFF4h

Format of PC Tools DESKTOP editor buffer structure:
Offset	Size	Description	(Table 0546)
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
	DS:0000h -> window parameters structure (see #0539)
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
Return: ES:BX -> hotkey table (see #0547)
	DS:DX = original INT 09 vector

Format of PC Tools DESKTOP hotkey table:
Offset	Size	Description	(Table 0547)
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
Return: AH = printer status (see #0548)
SeeAlso: AH=02h,AH=84h"AX",AX=6F02h,AH=F1h,INT 16/AX=FFE3h,INT 1A/AH=11h"NEC"
SeeAlso: INT 4B/AH=00h

Bitfields for printer status:
Bit(s)	Description	(Table 0548)
 7	not busy
 6	acknowledge
 5	out of paper
 4	selected
 3	I/O error
 2-1	unused
 0	timeout
Note:	for Tandy 2000, bit 7 indicates printer-busy when set rather than clear
--------B-1701-------------------------------
INT 17 - PRINTER - INITIALIZE PORT
	AH = 01h
	DX = printer number (00h-02h)
Return: AH = printer status (see #0548)
Note:	some printers report that they are ready immediately after
	  initialization when they actually are not; a more reliable result may
	  be obtained by calling AH=02h after a brief delay
SeeAlso: AH=02h,AH=FFh"PC-MOS",INT 1A/AH=10h"NEC",INT 4B/AH=01h
--------B-1702-------------------------------
INT 17 - PRINTER - GET STATUS
	AH = 02h
	DX = printer number (00h-02h)
Return: AH = printer status (see #0548)
Note:	PRINTFIX from MS-DOS 5.0 hooks this function and always returns AH=90h
SeeAlso: AH=01h,AH=F2h,INT 1A/AH=12h"NEC",INT 4B/AH=02h
--------P-1702--DX0000-----------------------
INT 17 - INSET - INSTALLATION CHECK
	AH = 02h
	DX = 0000h
	CX = 07C3h (1987d)
Return: CX = 07C2h (1986d) if installed
Program: INSET is a text/graphics integration program
--------b-170200BX5050-----------------------
INT 17 - Enhanced Parallel Port (EPP) BIOS - INSTALLATION CHECK
	AX = 0200h
	BX = 5050h ('PP')
	CH = 45h   ('E')
	DX = printer port number (00h-02h)
Return: AH = status
	    00h if installed and port is an enhanced parallel port
		CX:AL = installed BIOS type
		    5050h:45h ('PPE') if EPP v3.0+ BIOS installed
		    4550h:50h ('EPP') if EPP v1.0 BIOS installed
		---EPP 1.0, 3.0---
		DX:BX -> far entry point to Advanced BIOS (see #0549)
		---EPP Revision 7---
		DX = EPP I/O base address
		ES:BX -> far entry point to EPP BIOS (see #0549,#0550)
	    03h if installed but specified port not supported
		CF set
Program: The Enhanced Parallel Port BIOS provides support for parallel
	  port peripherals using the enhanced modes of the IEEE 1284.
SeeAlso: AH=E0h,MEM 0040h:0008h,MEM 0040h:00DCh

(Table 0549)
Call EPP BIOS entry point with:
	DL = port number (v1.0,v3.0)
	DX = (Revision 7) EPP port I/O base address
	AH = function
	    00h Query Configuration
		Return: AH = 00h if successful
			    AL = IRQ number used by port or FFh if no IRQ
			    BH = EPP BIOS revision (major in high nybble,
				  minor in low nybble)
			    BL = I/O capabilities (see #0552)
			    ES:DI -> ASCIZ driver information/version text
			    ---v1.0,v3.0---
			    CX = I/O port base address for parallel port
			    ---Revision 7---
			    CL = EPP chipset code (see #0553)
			    CH = hardware manufacturer's product code
	    01h Set Mode
		AL = mode bits (see #0554)
		Return: AX,BX destroyed
	    02h Get Mode
		Return: AL = mode bits (see also #0554)
				bit 7: EPP port interrupts enabled
			AH = 00h
			CF clear
			BX destroyed
	    03h Interrupt Control
		AL = subfunction
		    00h enable parallel port interrupts
		    01h disable parallel port interrupts
		Return: AH = status (00h,05h,06h) (see also #0551)
	    04h EPP Reset
		Return: AH = 00h if successful
			AL destroyed
	    05h perform Address-Write/Device-Select I/O cycle
		AL = device address
		Return: AH = status
			AL destroyed
	    06h perform Address-Read I/O cycle
		Return: AL = returned address/device data
			AH = status
	    07h write byte
		AL = data byte to write
		Return: AH = status
	    08h output block of data
		DS:SI -> block of data to be sent to parallel port
		CX = number of bytes to output
		Return: AH = status (see #0551)
			CX = number of unsent bytes
	    09h read byte of data
		Return: AH = status (see #0551)
			AL = byte read from parallel port
	    0Ah read block of data
		ES:DI -> buffer for received data
		CX = number of bytes to read from paralle port
		Return: AH = status (see #0551)
			ES:DI buffer filled if successful
			CX = number of bytes not transferred
	    0Bh Address/Byte-Read
		AL = device address
		Return: AH = status (see #0551)
			AL = byte read if successful
	    0Ch Address/Byte-Write
		AL = device address
		DH = data byte (v1.0,v3.0)
		CL = data byte (Revision 7)
		Return: AH = status (see #0551)
	    0Dh Address/Block-Read
		AL = device address
		ES:DI -> buffer for received data
		CX = number of bytes to read
		Return: AH = status (see #0551)
			CX = number of bytes NOT transferred
	    0Eh Address/Block-Write
		AL = device address
		ES:DI -> data to be sent (v1.0,v3.0)
		DS:SI -> data to be send (Revision 7)
		CX = number of bytes to write
		Return: AH = status (see #0551)
			CX = number of bytes NOT transferred
	    0Fh Lock Port
		AL = multiplexor port number
			bits 7-4: daisy chain port number (1-8)
			bits 3-0: mux device port number (1-8, 0 if no mux)
		Return: AH = status (00h,03h,05h) (see #0551)
	    10h Unlock Port
		AL = multiplexor port number
			bits 7-4: daisy chain port number (1-8)
			bits 3-0: mux device port number (1-8, 0 if no mux)
		Return: AH = status (00h,03h,05h) (see #0551)
	    11h Device Interrupt
		BL = multiplexor port number
			00h if no multiplexor, else mux device port (01h-08h)
		AL = subfunction
		    00h disable device interrupts
		    01h enable device interrupt
			ES:DI -> interrupt event handler
		Return: AH = status (00h,03h,05h,06h) (see #0551)
		Note:	AMI BIOS v1.00.12.AX1T ignores the multiplexor port
			  number; it also always sets INT 0F to the address
			  specified in ES:DI
	    12h Real-Time Mode
		AL = subfunction
		    00h check whether any real-time devices present
		    01h add (advertise) real-time device
		    02h remove real-time device
		Return: AH = status (00h,05h,06h,07h) (see #0551)
			AL = real-time devices present? (00h no, 01h yes)
		Note:	unlike all other functions, this one does not use DL/DX
Return: AH = status (see #0551)
	CF clear if successful
	CF set on error
	BX destroyed
SeeAlso: #0550

(Table 0550)
Call EPP BIOS (Revision 7) entry point multiplexor functions with:
	DX = EPP port base I/O address
	AH = function
	    40h Query Mux
		Return: AH = status (see #0551)
			AL = currently-selected port
			CH = status flags
				bit 0: channel locked
				bit 1: interrupt pending
			BH destroyed
		Note:	the PhoenixBIOS v4.0 documentation lists BL as the
			  currently-selected port and AL as the status flags
	    41h Query Device Port
		AL = EPP multiplex device port (1-8)
		Return: AH = status (see #0551)
			CH = status flags (see #0555)
			BX = EPP product/device ID (0000h if undefined)
		Note:	the PhoenixBIOS v4.0 documentation lists AL as the
			  status flags and CX as the device ID
	    42h Set Product ID
		AL = EPP multiplex device port (1-8)
		CX = EPP product ID
		Return: AH = status (see #0551)
			BX destroyed
	    50h Query Daisy Chain
		AL = EPP multiplexor device port (1-8)
		Return: AH = status (see #0551)
			CH = status flags
				bit 0: channel locked
				bit 1: interrupt pending
			BL = currently-selected device
			BH = EPP daisy chain revision (high nybble = major)
			CL = daisy-chain depth (00h if no daisy chain)
			ES:DI -> ASCIZ driver vendor identification string
		Note:	the PhoenixBIOS v4.0 documentation lists AH=51h as
			  "Query Daisy Chain" and BL as the multiplexor port;
			  it also lists AL as status flags on return
	    51h Rescan Daisy Chain (dynamically reassign port numbers)
		AL = EPP multiplexor device port (1-8)
		Return: AH = status (see #0551)
			BX destroyed
		Note:	the PhoenixBIOS v4.0 documentation lists AH=50h as
			  "Rescan Daisy Chain" and BL as the multiplexor port
Notes:	these functions are only valid if a port multiplexor or daisy chain
	  is present
	PhoenixBIOS 4.0 documents function 50h as "Rescan" and 51h as
	  "Query Daisy Chain"
SeeAlso: #0549,INT 2D/AL=DCh

(Table 0551)
Values for EPP BIOS function status:
 00h	successful
 02h	unsupported command/feature
 03h	unsupported parallel port
 05h	unsupported in current mode
 06h	invalid subfunction
 07h	already ???
 20h	multiplexor not present (AMI)
 40h	multiplexor not present
 41h	multiplexor currently locked
 80h	I/O timeout
 FFh	invalid/unsupported function
SeeAlso: #0549,#0550

Bitfields for EPP (v3.0, Revision 7) I/O capabilities:
Bit(s)	Description	(Table 0552)
 0	multiplexor present
 1	PS/2 bi-directional capable
 2	daisy chain present
 3	ECP capable
 4	EPP software emulation supported
 5	EPP capable
 6	fast Centronics supported
 7	standard EPP I/O map
SeeAlso: #0549

(Table 0553)
Values for EPP (Revision 7) chipset code:
 00h	Intel SL
 01h	FarPoint Communications
 02h	SMC
 03h	Chips&Technologies
 04h	Western Digital
 05h	National Semiconductor
SeeAlso: #0549

Bitfields for EPP BIOS mode bits:
Bit(s)	Description	(Table 0554)
 0	set compatibility mode
 1	set bi-directional mode
 2	set EPP mode
---Revision 7,v3.0---
 3	set ECP mode
 4	set EPP software emulation
 5	set fast Centronics mode
 6-7 reserved (0)
SeeAlso: #0549,#M052

Bitfields for EPP BIOS multiplex status flags:
Bit(s)	Description	(Table 0555)
 0	port is selected
 1	port is locked
 2	interrupts are enabled
 3	interrupt pending
SeeAlso: #0550
--------P-1703-------------------------------
INT 17 U - Emulaser ELTSR - INSTALL INTERRUPT HANDLERS
	AH = 03h
Return: BX = ???
	CX = ???
Program: ELTSR is the resident portion of the Emulaser PostScript emulator by
	  Vertisoft Systems, Inc.
SeeAlso: AH=04h"Emulaser",AH=0Eh,INT 1A/AH=E5h
----------1703-------------------------------
INT 17 - IBM SurePath BIOS - Officially "Private" Function
	AH = 03h
SeeAlso: AH=04h"IBM",AH=05h"IBM"
--------c-1703-------------------------------
INT 17 - PC-MOS/386 v5.01 - PRINT SPOOLER - PRINT STRING
	AH = 03h
	DX = printer port number
	CX = number of characters to print
	DS:SI -> string
Return: AH = printer status (see #0548)
	CX = number of characters actually printed
Desc:	send an entire string of chars to the print spooler with a single call
Program: PC-MOS/386 v5.01 is a multitasking, multiuser MS-DOS 5.0-compatible
	  operating system by The Software Link, Inc.
SeeAlso: AH=00h,AH=01h,AH=02h,AH=FFh"PC-MOS"
--------c-1703--BX5A00-----------------------
INT 17 - DMP Print Spooler v2.03 - INSTALLATION CHECK
	AH = 03h
	BX = 5A00h
Return: AX = 5ACBh
	DI = 0000h
	ES = DMP code segment (also data segment)
Program: DMP is a Printer driver/spooler, by DMP (USA), available on the
	  PCTODAY disk, volume 10, March 1991
--------N-170300-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - "socket"
	AX = 0300h
	CX = type of socket from  socket( domain, type, protocol )
	DX = local identifier of socket (0 - 31)
Return: AX = 0000h success
	    CX = segment of 4500 byte transfer buffer
	    DX = offset of 4500 byte transfer buffer
	   = FFFFH failure
	    CX = error code
		ENFILE	    23
Program: DOSISODE is the ISO developers environment which has been ported to
	  DOS and will run with the Waterloo TCP turned into a resident TSR.
	  Currently it allows a maximum of 6 open sockets.
Note:	this function will initialize the interface the first time it is
	  called
SeeAlso: AX=0400h"DOSISODE",AX=0600h"DOSISODE",AX=0800h"DOSISODE"
SeeAlso: AX=0A00h"DOSISODE",AX=0C00h"DOSISODE",AX=0E00h"DOSISODE"
--------P-1704-------------------------------
INT 17 U - Emulaser ELTSR - BEGIN CAPTURING OUTPUT
	AH = 04h
Note:	has no effect unless ELTSR is deactivated (see AX=0503h)
SeeAlso: AH=03h"Emulaser",AX=0503h,INT 1A/AH=E5h
----------1704-------------------------------
INT 17 - IBM SurePath BIOS - Officially "Private" Function
	AH = 04h
SeeAlso: AH=03h"IBM",AH=05h"IBM"
--------N-170400-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - "bind"
	AX = 0400h
Note:	this function just returns
SeeAlso: AX=0300h"DOSISODE",AX=0500h"DOSISODE",AX=0C00h"DOSISODE"
----------1705-------------------------------
INT 17 - IBM SurePath BIOS - Officially "Private" Function
	AH = 05h
SeeAlso: AH=03h"IBM",AH=04h"IBM"
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
--------N-170500-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - "connect"
	AX = 0500h
SeeAlso: AX=0400h"DOSISODE",AX=0700h"DOSISODE",AX=0C00h"DOSISODE"
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
SeeAlso: AX=0500h,AX=0503h,AH=07h"ELTSR",INT 1A/AH=E5h
--------N-170600-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - "listen"
	AX = 0600h
Note:	this function just returns
SeeAlso: AX=0300h"DOSISODE",AX=0700h"DOSISODE",AX=0C00h"DOSISODE"
SeeAlso: AX=0E00h"DOSISODE"
--------P-1707-------------------------------
INT 17 U - Emulaser ELTSR - OPEN CAPTURE FILE
	AH = 07h
	ES:DX -> ASCIZ filename to be opened
Return: ???
Note:	new output will be appended to the specified file
SeeAlso: AH=08h,INT 1A/AH=E5h
--------N-170700-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - "accept"
	AX = 0700h
Note:	this function just returns
SeeAlso: AX=0600h"DOSISODE",AX=0800h"DOSISODE",AX=0C00h"DOSISODE"
--------P-1708-------------------------------
INT 17 U - Emulaser ELTSR - CLOSE CAPTURE FILE
	AH = 08h
	???
Return: ???
Desc:	close the file previously opened by function 07h
SeeAlso: AH=07h,INT 1A/AH=E5h
--------N-170800-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - "recvfrom"
	AX = 0800h
SeeAlso: AX=0500h"DOSISODE",AX=0900h"DOSISODE",AX=0A00h"DOSISODE"
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
--------N-170900-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - "sendto"
	AX = 0900h
SeeAlso: AX=0700h"DOSISODE",AX=0800h"DOSISODE",AX=0A00h"DOSISODE"
--------P-170A-------------------------------
INT 17 U - Emulaser ELTSR - SET ??? FILENAME
	AH = 0Ah
	ES:BX -> ??? buffer
	CX = length of ??? buffer
Return: ???
Note:	copies the specified name into the buffer passed to ELSPL as the
	  filename by AH=09h
SeeAlso: AH=09h,INT 1A/AH=E5h
--------N-170A00-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - "select"
	AX = 0A00h
SeeAlso: AX=0800h"DOSISODE",AX=0B00h"DOSISODE",AX=0E00h"DOSISODE"
--------P-170B-------------------------------
INT 17 U - Emulaser ELTSR - GET ???
	AH = 0Bh
Return: AX:BX -> ???
SeeAlso: AH=0Ah,INT 1A/AH=E5h
----------170B-------------------------------
INT 17 - IBM SurePath BIOS - Officially "Private" Function
	AH = 0Bh
SeeAlso: AH=03h"IBM",AH=0Ch"IBM"
--------N-170B00-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - "ioctl"
	AX = 0B00h
	DX = local identifier of socket (0 - 31)
Note:	this function sets the socket into non_block mode
SeeAlso: AX=0A00h"DOSISODE",AX=0C00h"DOSISODE",AX=0E00h"DOSISODE"
--------P-170C-------------------------------
INT 17 U - Emulaser ELTSR - SET ??? FLAG
	AH = 0Ch
	???
Return: ???
SeeAlso: AH=0Bh,INT 1A/AH=E5h
----------170C-------------------------------
INT 17 - IBM SurePath BIOS - Officially "Private" Function
	AH = 0Ch
SeeAlso: AH=0Bh"IBM",AH=0Dh"IBM"
--------N-170C00-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - "close"
	AX = 0C00h
SeeAlso: AX=0300h"DOSISODE",AX=0500h"DOSISODE",AX=0D00h"DOSISODE"
--------P-170D-------------------------------
INT 17 U - Emulaser ELTSR - GET TRUE ScrlLk STATE
	AH = 0Dh
Return: AX = state (0000h off, 0010h on)
Desc:	determine the actual state of ScrlLk even when Emulaser is controlling
	  the ScrlLk light as its activity indicator
SeeAlso: AH=0Ch,INT 16/AH=02h,INT 1A/AH=E5h
----------170D-------------------------------
INT 17 - IBM SurePath BIOS - Officially "Private" Function
	AH = 0Dh
SeeAlso: AH=0Ch"IBM",AH=0Eh"IBM"
--------N-170D00-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - "shutdown" - SHUTDOWN INTERFACE
	AX = 0D00h
Note:	this function is used to shutdown the interface
SeeAlso: AX=0C00h"DOSISODE",AX=0E00h"DOSISODE"
--------P-170E-------------------------------
INT 17 U - Emulaser ELTSR - BACKGROUND PROCESSING
	AH = 0Eh
Program: ELTSR is the resident portion of the Emulaser PostScript emulator by
	  Vertisoft Systems, Inc.
Note:	this function is called by ELTSR on every INT 08 to allow data to be
	  processed in the background, but may also be called by applications
	  to give Emulaser additional CPU time
SeeAlso: AH=0Dh,INT 1A/AH=E5h
----------170E-------------------------------
INT 17 - IBM SurePath BIOS - Officially "Private" Function
	AH = 0Eh
SeeAlso: AH=03h"IBM",AH=0Dh"IBM",AH=80h"IBM"
--------N-170E00-----------------------------
INT 17 - DOSISODE to WATTCP TSR Interface - INSTALLATION CHECK
	AX = 0E00h
Return: CX = 1234h if installed
Program: DOSISODE is the ISO developers environment which has been ported to
	  DOS and will run with the Waterloo TCP turned into a resident TSR.
	  Currently it allows a maximum of 6 open sockets.
Note:	this function is used to check if the interface is loaded
SeeAlso: AX=0300h"DOSISODE",AX=0A00h"DOSISODE"
--------P-172000-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - INSTALLATION CHECK
	AX = 2000h
	BL = printer number???
Return: AX = status (see #0556)
	BX = driver version number (BH=major,BL=minor)
	CH = ??? (00h)
	CL = ???
	DX = ??? (0100h)
Note:	also enables the remaining printer driver functions (2001h-2007h)
SeeAlso: AX=2001h,AX=2002h,AX=2003h,AX=2004h,AX=2005h,AX=2006h,AX=2007h

(Table 0556)
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
Return: AX = status (see #0556)
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
Return: AX = status (see #0556)
SeeAlso: AX=2000h,AX=2004h
--------P-172003-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - ???
	AX = 2003h
	ES:BX -> ???
Return: AX = status (see #0556)
SeeAlso: AX=2000h,AX=2004h
--------P-172004-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - GET ???
	AX = 2004h
	BL = printer number???
Return: AX = status (see #0556)
	ES:DI -> ???
SeeAlso: AX=2000h,AX=2003h
--------P-172005-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - ADVANCE PRINTER TO NEXT PAGE
	AX = 2005h
	BL = printer number???
Return: AX = status (see #0556)
Note:	this function also clears the flag set by AX=2001h
SeeAlso: AX=2000h,AX=2001h,AX=2006h
--------P-172006-----------------------------
INT 17 - PC Paint Plus 2.0 - PRINTER DRIVER - ADVANCE TO NEXT PAGE & SHUT DOWN
	AX = 2006h
	BL = printer number???
Return: AX = status (see #0556)
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
	AL = status (see #0557)
SeeAlso: AX=2403h,INT 16/AX=4500h

(Table 0557)
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
Return: AL = status (see #0557)
	DX:BX -> receive buffer
SeeAlso: AX=2402h,AX=2404h,AX=2408h
--------N-172402-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - TRANSMIT BLOCK, NO HANDSHAKE
	AX = 2402h
	transmit buffer filled (see AX=2403h)
Return: AL = status (see #0557)
SeeAlso: AX=2401h,AX=2403h,AX=2404h,AX=2409h
--------N-172403-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - GET STATUS AND TRANSMISSION BUFFER
	AX = 2403h
Return: AL = status (see #0557)
	CX = number of characters in receive ring buffer
	DX:BX -> transmit buffer
SeeAlso: AX=2400h,AX=2402h
--------N-172404-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - SEND ACK BLOCK
	AX = 2404h
	BX = target address
Return: AL = status (see #0557)
SeeAlso: AX=2402h,AX=2405h
--------N-172405-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - SEND NAK BLOCK
	AX = 2405h
	BX = target address
Return: AL = status (see #0557)
SeeAlso: AX=2402h,AX=2404h
--------N-172406-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - PREPARE CHARACTER-ORIENTED RECEIVE
	AX = 2406h
Return: AL = status (see #0557)
SeeAlso: AX=2407h,AX=240Ah
--------N-172407-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - RECEIVE CHARACTER FROM REMOTE
	AX = 2407h
Return: AL = status (see also #0557)
	    06h end of data
	DL = received character
SeeAlso: AX=2406h
--------N-172408-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - RECEIVE BLOCK, WITH HANDSHAKE
	AX = 2408h
Return: AL = status (see also #0557)
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
Return: AL = status (see also #0557)
	    03h no response
	    06h remote currently unable to perform command
SeeAlso: AX=2405h,AX=2408h
--------N-17240A-----------------------------
INT 17 - Shamrock Software NET.24 v3.11+ - PREPARE CHARACTER-ORIENTED TRANSMIT
	AX = 240Ah
Return: AL = status (see #0557)
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
	ES:SI -> settings (see #0558)
Program: T2PS is a shareware ASCII-to-PostScript converter by A.N.D.
	  Technologies
SeeAlso: AH=62h,AH=64h,INT 05/AX=4E57h

Format of T2PS settings:
Offset	Size	Description	(Table 0558)
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
	ES:SI -> buffer for settings (see #0558)
Return: ES:SI buffer filled
SeeAlso: AH=62h,AH=63h,INT 05/AX=5053h
--------b-176F00BX0000-----------------------
INT 17 - HP Vectra - EXTENDED BIOS - "F17_INQUIRE" - INSTALLATION CHECK
	AX = 6F00h
	BX = 0000h
Return: BX = 4850h ("HP") if HP Extended BIOS printer extensions available
SeeAlso: AX=6F02h,INT 14/AX=6F00h,INT 10/AX=6F00h,INT 14/AX=6F00h
SeeAlso: INT 33/AX=6F00h,INT 6F/AH=00h"HP Vectra"
--------b-176F02-----------------------------
INT 17 - HP Vectra - EXTENDED BIOS - "F17_PUT_BUFFER" - PRINT BUFFER
	AX = 6F02h
	CX = size of buffer in bytes
	DX = port number (0-3)
	ES:DI -> buffer containing characters to be printed
Return: AH = printer status (see #0548)
	CX = number of bytes successfully printed
	---on error (AH bit 0 set)---
	    ES:DI -> next byte to be sent
	---if successful---
	    ES:DI unchanged
SeeAlso: AH=00h,AX=6F00h,INT 14/AX=6F02h
----------1780-------------------------------
INT 17 - IBM SurePath BIOS - Officially "Private" Function
	AH = 80h
SeeAlso: AH=03h"IBM",AH=0Bh"IBM"
--------N-1781-------------------------------
INT 17 - Alloy NTNX, MW386 - CANCEL JOBS FOR CURRENT USER
	AH = 81h
	AL = 00h (NTNX compatibility mode)
	CL = number of jobs to cancel
Return: AL = status (see #0559)
Note:	this function cancels the last CL printouts for the current task
SeeAlso: AH=82h

(Table 0559)
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
Return: AL = status (see #0559)
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
Return: AL = status (see #0559)
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
Return: AH = printer status (see #0548)
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
		DX = NTNX printer number (see #0560)
	    01h MW386
		DX = MW386 printer number
Return: AH = status (see #0559)
Note:	removes specified printer from the spooler's list of printers
SeeAlso: AH=89h,AH=8Bh

(Table 0560)
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
		DX = NTNX printer number (see #0560)
	    01h MW386
		DX = MW386 printer number
Return: AL = status (see #0559)
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
Return: AL = status (see #0559)
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
Return: AL = status (see #0559)
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
Return: AL = status (see #0559)
SeeAlso: AH=8Ch
--------N-1792-------------------------------
INT 17 - Alloy NTNX - CHECK PRINTER DRIVER
	AH = 92h
	AL = 00h
	CL = 00h
Return: CL = driver state
	    01h initialized
	    80h not initialized
	AX = status (see #0559)
SeeAlso: AH=8Ah
--------N-1794-------------------------------
INT 17 - Alloy NTNX, MW386 - SELECT PRINTER
	AH = 94h
	AL = mode
	    00h NTNX compatibility
		DX = NTNX printer number (see #0560)
	    01h MW386
		DX = MW386 printer number
	    02h MW386 v2+
		BX = logical printer number
		DX = MW386 printer number
Return: AL = status (see #0559)
Note:	modes 00h and 01h affect only logical LPT1
SeeAlso: AH=8Bh,AH=95h
--------N-1795-------------------------------
INT 17 - Alloy NTNX, MW386 - GET CURRENT PRINTER
	AH = 95h
	AL = mode
	    00h NTNX compatibility
		Return: DX = NTNX printer number (see #0560)
			    (FFFFh if current printer not compatible with NTNX)
	    01h MW386
		Return: DX = MW386 printer number
	    02h MW386 v2+
		BX = logical device number
		    00h-03h = LPT1-LPT4
		    04h-07h = COM1-COM4
		Return: DX = MW386 printer number (FFFFh = none)
Return: AL = status (see #0559)
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
Return: AL = status (see #0559)
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
		DL = NTNX printer number (see #0560)
			(FFh = task's current logical LPT1)
		DH = mode (see #0561)
	    01h MW386
		DX = MW386 printer number
		CL = mode (as for DH above)
Return: AL = status (see #0559)
	DH = mode (bits 1 and 2 set as above)
	DL = printer owner's user number if not spooled

Bitfields for Alloy printer mode:
 0	get mode if 1, set mode if 0	(Table 0561)
 1	private ("attached")
 2	direct instead of spooled
 3-7	reserved (0)
--------N-179A-------------------------------
INT 17 - Alloy NTNX,MW386 - SET TAB EXPANSION
	AH = 9Ah
	AL = mode
	    00h NTNX compatibility
		DX = NTNX printer number (see #0560)
			(FFFFh = current logical LPT1)
	    01h MW386
		DX = MW386 printer number
	CL = tab length (00h = no expansion, 01h-63h = spaces per tab)
Return: AL = status (see #0559)
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
Return: AL = status (see #0559)
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
Return: AL = status (see #0559)
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
Return: AL = status (see #0559)
Note:	only affects the current logical LPT1
SeeAlso: AH=9Ah,AH=A6h,INT 7F/AH=05h"NTNX (Host)"
--------N-17A6-------------------------------
INT 17 - Alloy MW386 - ENABLE/DISABLE BANNER PAGE
	AH = A6h
	AL = new state
	    00h banner page before print job disabled
	    01h banner page enabled
Return: AL = status (see #0559)
Note:	only affects the current logical LPT1
SeeAlso: AH=A4h
--------N-17A7-------------------------------
INT 17 - Alloy MW386 v2+ - GET/SET SPOOL FLAGS
	AH = A7h
	AL = spool flags (see #0562)
	BX = logical device number
	    00h-03h = LPT1-LPT4
	    04h-07h = COM1-COM4
Return: AL = status (see #0559)
Note:	the documentation does not state which register contains the result of
	  a GET
SeeAlso: AH=A4h,AH=A6h

Bitfields for Alloy spool flags:
Bit(s)	Description	(Table 0562)
 0	banner page enabled (see AH=A6h)
 1	form feed enabled (see AH=A4h)
 2-6	reserved (0)
 7	set flags if 1, get flags if 0
--------N-17A8-------------------------------
INT 17 - Alloy MW386 - DEFINE TEMPORARY FILENAME
	AH = A8h
	CX:SI -> ASCIZ filename without extension (max 8 chars)
Return: AL = status (see #0559)
Note:	allows application to specify banner page filename for spool files
	  collected from the application's printer output
SeeAlso: AH=A9h
--------N-17A9-------------------------------
INT 17 - Alloy MW386 - CHANGE TEMPORARY SPOOL DRIVE
	AH = A9h
	AL = new spool drive (2=C:,3=D:,etc)
Return: AL = status (see #0559)
Note:	does not remove previous spooling directory since jobs may be pending
SeeAlso: AH=A8h
--------N-17AA-------------------------------
INT 17 - Alloy MW386 v2+ - GET REAL-TIME PRINTER STATUS
	AH = AAh
	AL = mode
	    00h NTNX
		DX = NTNX printer number (see #0560)
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
Return: ES:BX -> control block (see #0563)
SeeAlso: AH=C1h

Format of PCSpool control block:
Offset	Size	Description	(Table 0563)
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
	ES:SI -> FAR routine for linked mode (see #0564)
Return: CX = 07C2h
SeeAlso: AX=CD02h,AX=CD08h

(Table 0564)
Values INSET linked-mode routine is called with:
	AL = function
	    00h send character to printer
		BL = character to send
	    01h send string to printer
		CX = number of bytes to send
		DS:DX -> buffer containing data
	    02h move print head to horizontal starting position of image
Return: AX = status
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
--------P-17E0-------------------------------
INT 17 - EPP BIOS - INSTALLATION CHECK
	AH = E0h
Return: ??? (AH <> E0h if installed ???)
SeeAlso: AX=0200h"EPP",AH=E1h,AH=E2h
--------P-17E1-------------------------------
INT 17 - EPP BIOS - DISABLE EPP
	AH = E1h
	???
Return: ???
SeeAlso: AX=0200h"EPP",AH=E0h,AH=E2h
--------P-17E2-------------------------------
INT 17 - EPP BIOS - ENABLE EPP
	AH = E2h
	???
Return: ???
SeeAlso: AX=0200h"EPP",AH=E0h,AH=E1h
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
Return: AH = printer status (see #0548 at AH=00h)
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
Return: BH = status
	    00h no keystrokes available
	    01h keystroke available
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
	    others
	???
Return: ???
Notes:	details are not available at this time
	text video RAM is located at segments A000h (characters) and A200h
	  (attributes), graphics video RAM at segment C000h

Bitfields for NEC PC-9800 series video attributes:
Bit(s)	Description	(Table 0565)
 0	disable drawing character
 1	blinking
 2	reverse video
 3	underline
 4	vertical line
 7-5	color
	(0=black, 1=blue, 2=red, 3=purple, 4=green, 5=cyan, 6=yellow, 7=white)
--------J-180E-------------------------------
INT 18 - NEC PC-9800 series - SET SINGLE DISPLAY AREA
	AH = 0Eh
	DX = offset of first byte to display???
Return: ???
SeeAlso: AH=1Bh,MEM 0050h:0001h
--------J-181B-------------------------------
INT 18 - NEC PC-9800 series - SET DISPLAY MODE
	AH = 1Bh
	AL = ??? (00h for text mode)
Return: ???
--------r-185350BX4849-----------------------
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
	  table (see #0567).  After loading the master boot sector at
	  0000h:7C00h, the master bootstrap loader is given control
	  (see #0570).	It will scan the partition table for an active
	  partition, and will then load the operating system's bootstrap
	  loader (contained in the first sector of the active partition) and
	  give it control.
	true IBM PCs and most clones issue an INT 18 if neither floppy nor hard
	  disk have a valid boot sector
	to accomplish a warm boot equivalent to Ctrl-Alt-Del, store 1234h in
	  0040h:0072h and jump to FFFFh:0000h.	For a cold boot equivalent to
	  a reset, store 0000h at 0040h:0072h before jumping.
	VDISK.SYS hooks this interrupt to allow applications to find out how
	  much extended memory has been used by VDISKs (see #0566).  DOS 3.3+
	  PRINT hooks INT 19 but does not set up a correct VDISK header block
	  at the beginning of its INT 19 handler segment, thus causing some
	  programs to overwrite extended memory which is already in use.
	the default handler is at F000h:E6F2h for 100% compatible BIOSes
	MS-DOS 3.2+ hangs on booting (even from floppy) if the hard disk
	  contains extended partitions which point at each other in a loop,
	  since it will never find the end of the linked list of extended
	  partitions
	under Windows Real and Enhanced modes, calling INT 19 will hang the
	  system in the same was as under bare DOS; under Windows Standard
	  mode, INT 19 will successfully perform a cold reboot as it appears
	  to have been redirected to a MOV AL,0FEh/OUT 64h,AL sequence
BUG:	when loading the remainder of the DOS system files fails, various
	  versions of IBMBIO.COM/IO.SYS incorrectly restore INT 1E before
	  calling INT 19, assuming that the boot sector had stored the
	  contents of INT 1E at DS:SI instead of on the stack as it actually
	  does
SeeAlso: INT 14/AH=17h,INT 18"BOOT HOOK",INT 49"Tandy 2000",INT 5B"PC Cluster"

Format of VDISK header block (at beginning of INT 19 handler's segment):
Offset	Size	Description	(Table 0566)
 00h 18 BYTEs	n/a (for VDISK.SYS, the device driver header)
 12h 11 BYTEs	signature string "VDISK	 Vn.m" for VDISK.SYS version n.m
 1Dh 15 BYTEs	n/a
 2Ch  3 BYTEs	linear address of first byte of available extended memory

Format of hard disk master boot sector:
Offset	Size	Description	(Table 0567)
 00h 446 BYTEs	Master bootstrap loader code
1BEh 16 BYTEs	partition record for partition 1 (see #0568)
1CEh 16 BYTEs	partition record for partition 2
1DEh 16 BYTEs	partition record for partition 3
1EEh 16 BYTEs	partition record for partition 4
1FEh	WORD	signature, AA55h indicates valid boot block

Format of partition record:
Offset	Size	Description	(Table 0568)
 00h	BYTE	boot indicator (80h = active partition)
 01h	BYTE	partition start head
 02h	BYTE	partition start sector (bits 0-5)
 03h	BYTE	partition start track (bits 8,9 in bits 6,7 of sector)
 04h	BYTE	operating system indicator (see #0569)
 05h	BYTE	partition end head
 06h	BYTE	partition end sector (bits 0-5)
 07h	BYTE	partition end track (bits 8,9 in bits 6,7 of sector)
 08h	DWORD	sectors preceding partition
 0Ch	DWORD	length of partition in sectors
SeeAlso: #0567

(Table 0569)
Values for operating system indicator:
 00h	empty
 01h	DOS 12-bit FAT
 02h	XENIX root file system
 03h	XENIX /usr file system (obsolete)
 04h	DOS 16-bit FAT (up to 32M)
 05h	DOS 3.3+ extended partition
 06h	DOS 3.31+ Large File System (16-bit FAT, over 32M)
 07h	QNX
 07h	OS/2 HPFS
 07h	Windows NT NTFS
 07h	Advanced Unix
 08h	OS/2 (v1.0-1.3 only)
 08h	AIX bootable partition, SplitDrive
 08h	Commodore DOS
 08h	DELL partition spanning multiple drives
 09h	AIX data partition
 09h	Coherent filesystem
 0Ah	OS/2 Boot Manager
 0Ah	OPUS
 0Ah	Coherent swap partition
 0Bh	Windows95 with 32-bit FAT
 0Ch	Windows95 with 32-bit FAT (using LBA-mode INT 13 extensions)
 0Eh	logical-block-addressable VFAT (same as 06h but using LBA-mode INT 13)
 0Fh	logical-block-addressable VFAT (same as 05h but using LBA-mode INT 13)
 10h	OPUS
 11h	OS/2 Boot Manager hidden 12-bit FAT partition
 12h	Compaq Diagnostics partition
 14h	(resulted from using Novell DOS 7.0 FDISK to delete Linux Native part)
 14h	OS/2 Boot Manager hidden sub-32M 16-bit FAT partition
 16h	OS/2 Boot Manager hidden over-32M 16-bit FAT partition
 17h	OS/2 Boot Manager hidden HPFS partition
 18h	AST special Windows swap file ("Zero-Volt Suspend" partition)
 21h	officially listed as reserved
 23h	officially listed as reserved
 24h	NEC MS-DOS 3.x
 26h	officially listed as reserved
 31h	officially listed as reserved
 33h	officially listed as reserved
 34h	officially listed as reserved
 36h	officially listed as reserved
 38h	Theos
 3Ch	PowerQuest PartitionMagic recovery partition
 40h	VENIX 80286
 41h	Personal RISC Boot
 42h	SFS (Secure File System) by Peter Gutmann
 50h	OnTrack Disk Manager, read-only partition
 51h	OnTrack Disk Manager, read/write partition
 51h	NOVEL
 52h	CP/M
 52h	Microport System V/386
 53h	OnTrack Disk Manager, write-only partition???
 54h	OnTrack Disk Manager (DDO)
 56h	GoldenBow VFeature
 61h	SpeedStor
 63h	Unix SysV/386, 386/ix
 63h	Mach, MtXinu BSD 4.3 on Mach
 63h	GNU HURD
 64h	Novell NetWare 286
 65h	Novell NetWare (3.11)
 67h	Novell
 68h	Novell
 69h	Novell
 70h	DiskSecure Multi-Boot
 71h	officially listed as reserved
 73h	officially listed as reserved
 74h	officially listed as reserved
 75h	PC/IX
 76h	officially listed as reserved
 80h	Minix v1.1 - 1.4a
 81h	Minix v1.4b+
 81h	Linux
 81h	Mitac Advanced Disk Manager
 82h	Linux Swap partition
 82h	Prime
 83h	Linux native file system (ext2fs/xiafs)
 84h	OS/2-renumbered type 04h partition (related to hiding DOS C: drive)
 86h	FAT16 volume/stripe set (Windows NT)
 87h	HPFS Fault-Tolerant mirrored partition
 87h	NTFS volume/stripe set
 93h	Amoeba file system
 94h	Amoeba bad block table
 A0h	Phoenix NoteBIOS Power Management "Save-to-Disk" partition
 A1h	officially listed as reserved
 A3h	officially listed as reserved
 A4h	officially listed as reserved
 A5h	FreeBSD, BSD/386
 A6h	officially listed as reserved
 B1h	officially listed as reserved
 B3h	officially listed as reserved
 B4h	officially listed as reserved
 B6h	officially listed as reserved
 B7h	BSDI file system (secondarily swap)
 B8h	BSDI swap partition (secondarily file system)
 C1h	DR DOS 6.0 LOGIN.EXE-secured 12-bit FAT partition
 C4h	DR DOS 6.0 LOGIN.EXE-secured 16-bit FAT partition
 C6h	DR DOS 6.0 LOGIN.EXE-secured Huge partition
 C6h	corrupted FAT16 volume/stripe set (Windows NT)
 C7h	Syrinx Boot
 C7h	corrupted NTFS volume/stripe set
 D8h	CP/M-86
 DBh	CP/M, Concurrent CP/M, Concurrent DOS
 DBh	CTOS (Convergent Technologies OS)
 E1h	SpeedStor 12-bit FAT extended partition
 E3h	DOS read-only
 E3h	Storage Dimensions
 E4h	SpeedStor 16-bit FAT extended partition
 E5h	officially listed as reserved
 E6h	officially listed as reserved
 F1h	Storage Dimensions
 F2h	DOS 3.3+ secondary partition
 F3h	officially listed as reserved
 F4h	SpeedStor
 F4h	Storage Dimensions
 F6h	officially listed as reserved
 FEh	LANstep
 FEh	IBM PS/2 IML
 FFh	Xenix bad block table
Note:	for partition type 07h, one should inspect the partition boot record
	  for the actual file system type
SeeAlso: #0568

(Table 0570)
Values Bootstrap loader is called with (IBM BIOS):
	CS:IP = 0000h:7C00h
	DH = access
	    bits 7-6,4-0: don't care
	    bit 5: =0 device supported by INT 13
	DL = boot drive
	    00h first floppy
	    80h first hard disk
--------B-1A00-------------------------------
INT 1A - TIME - GET SYSTEM TIME
	AH = 00h
Return: CX:DX = number of clock ticks since midnight
	AL = midnight flag, nonzero if midnight passed since time last read
Notes:	there are approximately 18.2 clock ticks per second, 1800B0h per 24 hrs
	  (except on Tandy 2000, where the clock runs at 20 ticks per second)
	IBM and many clone BIOSes set the flag for AL rather than incrementing
	  it, leading to loss of a day if two consecutive midnights pass
	  without a request for the time (e.g. if the system is on but idle)
	since the midnight flag is cleared, if an application calls this
	  function after midnight before DOS does, DOS will not receive the
	  midnight flag and will fail to advance the date
SeeAlso: AH=01h,AH=02h,INT 21/AH=2Ch,INT 55"Tandy 2000",INT 4E/AH=02h"TI"
SeeAlso: INT 62/AX=0099h,MEM 0040h:006Ch
--------B-1A01-------------------------------
INT 1A - TIME - SET SYSTEM TIME
	AH = 01h
	CX:DX = number of clock ticks since midnight
Return: nothing
Notes:	there are approximately 18.2 clock ticks per second, 1800B0h per 24 hrs
	  (except on Tandy 2000, where the clock runs at 20 ticks per second)
	this call resets the midnight-passed flag
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
Note:	this function is also supported by the Sperry PC, which predates the
	  IBM AT; the data is returned in binary rather than BCD on the Sperry,
	  and DL is always 00h
SeeAlso: AH=00h,AH=03h,AH=04h,INT 21/AH=2Ch
--------b-1A02-------------------------------
INT 1A - Tandy 2000 - TIME - GET DATE AND TIME
	AH = 02h
Return: BX = number of days since January 1, 1980
	CH = hours
	CL = minutes
	DH = seconds
	DL = hundredths
SeeAlso: AH=03h"Tandy 2000",INT 55"Tandy 2000"
--------B-1A03-------------------------------
INT 1A - TIME - SET REAL-TIME CLOCK TIME (AT,XT286,PS)
	AH = 03h
	CH = hour (BCD)
	CL = minutes (BCD)
	DH = seconds (BCD)
	DL = daylight savings flag (00h standard time, 01h daylight time)
Return: nothing
Note:	this function is also supported by the Sperry PC, which predates the
	  IBM AT; the data is specified in binary rather than BCD on the
	  Sperry, and the value of DL is ignored
SeeAlso: AH=01h,AH=03h,AH=05h,INT 21/AH=2Dh,INT 4B/AH=01h
--------b-1A03-------------------------------
INT 1A - Tandy 2000 - TIME - SET DATE AND TIME
	AH = 03h
	BX = number of days since January 1, 1980
	CH = hours
	CL = minutes
	DH = seconds
	DL = hundredths
Return: nothing
SeeAlso: AH=02h"Tandy 2000",INT 55"Tandy 2000"
--------B-1A04-------------------------------
INT 1A - TIME - GET REAL-TIME CLOCK DATE (AT,XT286,PS)
	AH = 04h
Return: CF clear if successful
	    CH = century (BCD)
	    CL = year (BCD)
	    DH = month (BCD)
	    DL = day (BCD)
	CF set on error
SeeAlso: AH=02h,AH=04h"Sperry",AH=05h,INT 21/AH=2Ah,INT 4B/AH=02h"TI"
--------b-1A04-------------------------------
INT 1A - Sperry PC - GET REAL-TIME CLOCK DATE
	AH = 04h
Return: CF clear if successful
	    CL = year-1980
	    DH = month (binary) (01h-0Ch)
	    DL = day (binary) (01h-1Fh)
	CF set on error
SeeAlso: AH=02h,AH=04h,AH=05h"Sperry",INT 21/AH=2Ah,INT 4B/AH=02h"TI"
--------B-1A05-------------------------------
INT 1A - TIME - SET REAL-TIME CLOCK DATE (AT,XT286,PS)
	AH = 05h
	CH = century (BCD)
	CL = year (BCD)
	DH = month (BCD)
	DL = day (BCD)
Return: nothing
SeeAlso: AH=04h,INT 21/AH=2Bh"DATE",INT 4B/AH=00h"TI"
--------b-1A05-------------------------------
INT 1A - Sperry PC - SET REAL-TIME CLOCK DATE
	AH = 05h
	CL = year-1980
	CH = 00h (???)
	DH = month (binary) (01h-0Ch)
	DL = day (binary) (01h-1Fh)
Return: nothing
SeeAlso: AH=02h,AH=04h"Sperry",AH=05h,INT 21/AH=2Bh"DATE"
--------B-1A06-------------------------------
INT 1A - TIME - SET ALARM (AT,XT286,PS)
	AH = 06h
	CH = hour (BCD)
	CL = minutes (BCD)
	DH = seconds (BCD)
Return: CF set on error (alarm already set or clock stopped for update)
	CF clear if successful
Notes:	the alarm occurs every 24 hours until turned off, invoking INT 4A each
	  time
	the BIOS does not check for invalid values for the time, so the CMOS
	  clock chip's "don't care" setting (any values between C0h and FFh)
	  may be used for any or all three parts.  For example, to create an
	  alarm once a minute, every minute, call with CH=FFh, CL=FFh, and
	  DH=00h.
SeeAlso: AH=07h,AH=0Ch,INT 4A"SYSTEM"
--------B-1A07-------------------------------
INT 1A - TIME - CANCEL ALARM (AT,XT286,PS)
	AH = 07h
Return: alarm disabled
Note:	does not disable the real-time clock's IRQ
SeeAlso: AH=06h,AH=0Dh,INT 70
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
--------B-1A0C-------------------------------
INT 1A - TIME - SET RTC DATE/TIME ACTIVATED POWER-ON MODE (IBM)
	AH = 0Ch
	CH = hours (BCD)
	CL = minutes (BCD)
	DH = seconds (BCD)
	DL = day of month (BCD)
Return: CF clear if successful
	CF set on error (alarm already set or clock nonfunctional)
Desc:	set an automatic power-on for a given time in the future
Note:	IBM classifies this function as optional
SeeAlso: AH=06h,AH=0Dh,AH=0Eh,INT 4A
--------B-1A0D-------------------------------
INT 1A - TIME - RESET RTC DATE/TIME ACTIVATED POWER-ON MODE (IBM)
	AH = 0Dh
Return: CF clear if successful
	CF set on error
Desc:	cancel a previously-set power-on alarm
Note:	IBM classifies this function as optional
SeeAlso: AH=07h,AH=0Ch,AH=0Eh
--------B-1A0E-------------------------------
INT 1A - TIME - GET RTC DATE/TIME ALARM AND STATUS (IBM)
	AH = 0Eh
Return: CF clear if successful
	    BH = alarm status
		00h disabled
		01h enabled but will not power-up system
		02h enabled, system will power-up on activation
	    CH = alarm time, hours (BCD)
	    CL = alarm time, minutes (BCD)
	    DH = seconds (BCD)
	    DL = day of month (BCD)
	CF set on error
SeeAlso: AH=0Ch,AH=0Dh,AH=0Fh
--------B-1A0F-------------------------------
INT 1A - TIME - INITIALIZE REAL-TIME CLOCK
	AH = 0Fh
	AL = reserved (0)
Return: CF clear if successful
	CF set on error
SeeAlso: AH=0Ch,AH=0Dh,AH=0Eh
--------J-1A10-------------------------------
INT 1A - NEC PC-9800 series - PRINTER - INITIALIZE
	AH = 10h
	???
Return: ???
SeeAlso: AH=11h,AH=12h,INT 17/AH=01h
--------J-1A1000-----------------------------
INT 1A - NEC PC-9800 series - INSTALLATION CHECK
	AX = 1000h
Return: AX <> 1000h if NEC
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
Return: AX = status (see #0571)
	STACK unchanged
Program: SNAP.EXE is a TSR written by IBM and Carnegie Mellon University
	  which implements the Simple Network Application Protocol
SeeAlso: AX=6205h

(Table 0571)
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
Return: AX = status (see #0571)
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
		WORD	offset of "Cparms" structure (see #0572)
Return: ???
	STACK unchanged
Note:	all stacked offsets are within the SNAP data segment (use AX=6A01h
	  to allocate a buffer)
SeeAlso: AX=6405h,AX=7202h

Format of SNAP.EXE Cparms structure:
Offset	Size	Description	(Table 0572)
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
Return: AX = status (see #0571)
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
			  structure (see #0572)
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
	    AH = error code (see #0573)
SeeAlso: AH=83h"PCMCIA"

(Table 0573)
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
 15h	function not supported
 16h	invalid mode
 17h	invalid speed
 18h	busy
--------X-1A81-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - REGISTER STATUS CHANGE CALLBACK
	AH = 81h
	DS:DX -> callback routine (see #0574) or 0000h:0000h to disable
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (see #0573)
Note:	the callback will be invoked on any socket changes whose notification
	  has not been disabled with the status change enable mask; it may be
	  invoked either while processing a hardware interrupt from the adapter
	  or while processing the following Socket Services request
SeeAlso: AH=80h"PCMCIA",AH=82h"PCMCIA"

(Table 0574)
Values PCMCIA callback routine is invoked with:
	AL = adapter number
	BH = status change interrupt enable mask (see #0575)
	BL = socket number
	DH = current socket status (see #0576)
	DL = current card status (see #0577)
Return: all registers preserved
Notes:	the callback may be invoked during a hardware interrupt, and may not
	  call on Socket Services
	the callback will be invoked once for each socket with a status change

Bitfields for PCMCIA status change interrupt enable mask:
Bit(s)	Description	(Table 0575)
 7	card detect change
 6	ready change
 5	battery warning change
 4	battery dead change
 3	insertion request
 2	ejection request
 1-0	reserved (0)

Bitfields for PCMCIA current socket status:
Bit(s)	Description	(Table 0576)
 7	card changed
 6	reserved (0)
 5	card insertion complete
 4	card ejection complete
 3	card insertion request pending
 2	card ejection request pending
 1	card locked
 0	reserved (0)

Bitfields for PCMCIA current card status:
Bit(s)	Description	(Table 0577)
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
	DS:DX -> callback routine (see #0578) or 0000h:0000h
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (see #0573)
Note:	the callback is invoked on a Write Multiple request with an unsupported
	  card technology type
SeeAlso: AH=81h"PCMCIA",AH=94h

(Table 0578)
Values PCMCIA callback routine is invoked with:
	ES:AX -> Low-Level Socket Services Routines (see #0580)
	BH = socket attributes (see #0579)
	CX = number of bytes or words to write
	DS:SI -> data buffer to be written
	DX:DI -> 26-bit linear card address
	BP = card technology type
Return: CF clear if successful
	CF set on error
	    AH = error code (07h,0Ch,12h,14h) (see #0573)

Bitfields for PCMCIA socket attributes:
Bit(s)	Description	(Table 0579)
 7-4	reserved (0)
 3	packed buffer
 2	even bytes only (only valid if 1 set)
 1	data width (clear = byte, set = word)
 0	memory type (clear = common, set = attribute)

Format of PCMCIA Low-Level Socket Services Routines:
Offset	Size	Description	(Table 0580)
 00h	WORD	offset of Write Many routine (see #0581)
 02h	WORD	offset of Write One routine (see #0582)
 04h	WORD	offset of Read One routine (see #0583)
 06h	WORD	offset of Increment Offset routine (see #0584)
 08h	WORD	offset of Set Offset routine (see #0585)
 0Ah	WORD	offset of Get Status routine (see #0586)

(Table 0581)
Call Write Many routine with:
	BH = socket attributes (see #0579)
	CX = number of bytes or words to write
	DS:SI -> data to be written
Return: CF clear if successful
	CF set on error

(Table 0582)
Call Write One routine with:
	AL/AX = data to be written
	BH = socket attributes (see #0579)
Return: CF clear if successful
	CF set on error

(Table 0583)
Call Read One routine with:
	BH = socket attributes (see #0579)
Return: CF clear if successful
	    AL/AX = data read
	CF set on error

(Table 0584)
Call Increment Offset routine with:
	BH = socket attributes (see #0579)
Return: CF clear if successful
	CF set on error

(Table 0585)
Call Set Offset routine with:
	DX:DI = new offset address
Return: CF clear if successful
	CF set on error

(Table 0586)
Call Get Status routine with:
	nothing
Return: AL = current card status (see #0577)
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
	    AH = error code (01h) (see #0573)
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
	    DH = capabilities (see #0587)
	    DL = status change interrupt used (only if DH bit 3 set)(see #0588)
	CF set on error
	    AH = error code (01h) (see #0573)
SeeAlso: AH=80h"PCMCIA",AH=85h"PCMCIA",AH=87h

Bitfields for PCMCIA capabilities:
Bit(s)	Description	(Table 0587)
 7-6	reserved (0)
 5	status change interrupt is hardware shareable
 4	status change interrupt is software shareable
 3	status change interrupt
 2	data bus width is per-socket rather than per-window
 1	power management is per-adapter rather than per-socket
 0	indicators are per-adapter rather than per-socket

(Table 0588)
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
	    DH = adapter attributes (see #0589)
	CF set on error
	    AH = error code (01h) (see #0573)
SeeAlso: AH=84h"PCMCIA",AH=86h

Bitfields for PCMCIA adapter attributes:
Bit(s)	Description	(Table 0589)
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
	DH = new adapter attributes (see #0589)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h) (see #0573)
SeeAlso: AH=84h"PCMCIA",AH=85h"PCMCIA"
--------X-1A87-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - INQUIRE WINDOW
	AH = 87h
	AL = adapter number
	BH = window number
Return: CF clear if successful
	    AH destroyed
	    BL = capabilities (see #0590)
	    CX = bitmap of assignable sockets
	    DH = EISA A15-A12 address lines (in bits 7-4, bits 3-0 = 0)
	    DL = supported access speeds (see #0591)
	    DS:SI -> Memory Window Characteristics table (see #0592)
	    DS:DI -> I/O Window Characteristics table (see #0593)
	CF set on error
	    AH = error code (01h,11h) (see #0573)
SeeAlso: AH=84h"PCMCIA",AH=88h,AH=89h,AH=8Ch

Bitfields for PCMCIA window capabilities:
Bit(s)	Description	(Table 0590)
 7-5	reserved (0)
 4	separate enable for EISA comon space
 3	EISA I/O mappable
 2	I/O space
 1	attribute memory
 0	common memory

Bitfields for PCMCIA supported access speeds:
Bit(s)	Description	(Table 0591)
 7	reserved (0)
 6	600 ns
 5	300 ns
 4	250 ns
 3	200 ns
 2	150 ns
 1	100 ns
 0	WAIT line monitoring

Format of PCMCIA Memory Window Characteristics table:
Offset	Size	Description	(Table 0592)
 00h	WORD	window capabilities (see #0594)
 02h	WORD	minimum base address in 4K pages
 04h	WORD	maximum base address in 4K pages
 06h	WORD	minimum window size in 4K pages
 08h	WORD	maximum window size in 4K pages
 0Ah	WORD	window size granularity (4K units)
 0Ch	WORD	required base address alignment (4K units)
 0Eh	WORD	required card offset alignment (4K units)

Format of PCMCIA I/O Window Characteristics table:
Offset	Size	Description	(Table 0593)
 00h	WORD	window capabilities (see #0594)
 02h	WORD	minimum base address in bytes
 04h	WORD	maximum base address in bytes
 06h	WORD	minimum window size in bytes
 08h	WORD	maximum window size in bytes
 0Ah	WORD	window size granularity (bytes)

Bitfields for PCMCIA window capabilities:
Bit(s)	Description	(Table 0594)
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
	    DH = window attributes (see #0595)
	    DL = access speed (only one bit set) (see #0591)
	    SI = window base address (bytes if I/O, 4K units if memory)
	    DI = card offset address (memory only, 4K units)
	CF set on error
	    AH = error code (01h,11h) (see #0573)
SeeAlso: AH=87h,AH=89h,AH=8Ah

Bitfields for PCMCIA window attributes:
Bit(s)	Description	(Table 0595)
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
	DH = window attributes (see #0595)
	DL = access speed (only one bit set) (see #0591)
	SI = window base address (bytes if I/O, 4K units if memory window)
	DI = card offset addrress (memory only, 4K units)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,03h,07h,08h,0Ah,0Bh,0Dh,10h,11h) (see #0573)
SeeAlso: AH=87h,AH=88h,AH=8Bh
--------X-1A8A-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - GET PAGE
	AH = 8Ah
	AL = adapter number
	BH = window number
	BL = page number
Return: CF clear if successful
	    AH destroyed
	    DX = page attributes (see #0596)
	    DI = memory card offset (4K units)
	CF set on error
	    AH = error code (01h,08h,11h) (see #0573)
Notes:	this function is only valid for memory-mapped windows
	the socket being operated on is implied by the previous AH=89h call
SeeAlso: AH=88h,AH=8Bh

Bitfields for PCMCIA page attributes:
Bit(s)	Description	(Table 0596)
 0	page enabled
 15-1	reserved (0)
--------X-1A8B-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - SET PAGE
	AH = 8Bh
	AL = adapter number
	BH = window number
	BL = page number
	DX = page attributes (see #0596)
	DI = memory card offset (4K units)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,02h,07h,08h,11h) (see #0573)
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
	    DH = capabilities (see #0597)
	    DL = hardware indicators (see #0598)
	    DS:SI -> Socket Characteristics table (see #0599)
	    DS:DI -> Power Management table (see #0601)
	CF set on error
	    AH = error code (01h,0Bh) (see #0573)
SeeAlso: AH=87h,AH=8Dh,AH=8Eh

Bitfields for PCMCIA socket capabilities:
Bit(s)	Description	(Table 0597)
 0	card change
 1	card lock
 2	insert card (motor control)
 3	eject card (motor control)
 4-7	reserved (0)

Bitfields for PCMCIA socket hardware indicators:
Bit(s)	Description	(Table 0598)
 0	busy status
 1	write-protected
 2	battery status
 3	card lock status
 4	XIP status (eXecute-In-Place)
 5-7	reserved (0)

Format of PCMCIA Socket Characteristics table:
Offset	Size	Description	(Table 0599)
 00h	WORD	supported card types (see #0600)
 02h	WORD	steerable IRQ levels (bit 0 = IRQ0 to bit 15 = IRQ15)
 04h	WORD	additional steerable IRQ levels
		bit 0: NMI
		bit 1: I/O check
		bit 2: bus error
		bit 3: vendor-unique
		bits 4-7 reserved (0)

Bitfields for supported card types:
Bit(s)	Description	(Table 0600)
 0	memory card
 1	I/O card
 2-7	reserved (0)

Format of PCMCIA Power Management table:
Offset	Size	Description	(Table 0601)
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
	    BH = status change interrupt enable mask (see #0575)
	    CH = Vcc level (lower nybble) (see #0601)
	    CL = Vpp1 level (upper nybble) and Vpp2 level (lower nybble)
	    DH = current socket status (see #0576)
	    DL = indicators (see #0598)
	    SI = card type (see #0602)
	    DI = IRQ level steering (I/O only) (see #0603)
	CF set on error
	    AH = error code (01h,0Bh) (see #0573)
SeeAlso: AH=8Ch,AH=8Eh

Bitfields for PCMCIA card type:
Bit(s)	Description	(Table 0602)
 0	memory
 1	I/O
 2-15	reserved (0)

Bitfields for PCMCIA I/O level steering:
Bit(s)	Description	(Table 0603)
 15	interrupt steering enabled
 14-5	reserved (0)
 4-0	IRQ level (0-15=IRQ,16=NMI,17=I/O check,18=bus error,19=vendor)
--------X-1A8E-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - SET SOCKET
	AH = 8Eh
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
	BH = status change interrupt enable mask (see #0575)
	CL = Vpp1 level (upper nybble) and Vpp2 level (lower nybble)
	DH = current socket status (see #0576)
	DL = indicators (see #0598)
	SI = card type (see #0602)
	DI = IRQ level steering (I/O only) (see #0603)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,02h,05h,06h,0Bh,0Eh,0Fh) (see #0573)
SeeAlso: AH=8Ch,AH=8Dh
--------X-1A8F-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - GET CARD
	AH = 8Fh
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
Return: CF clear if successful
	    AH destroyed
	    DL = current card status (see #0577)
	CF set on error
	    AH = error code (01h,0Bh) (see #0573)
SeeAlso: AH=8Dh,AH=90h
--------X-1A90-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - RESET CARD
	AH = 90h
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,0Bh,14h) (see #0573)
Note:	toggles RESET pin of the specified card, but does not wait after
	  toggling the pin; it is the caller's responsibility to avoid
	  accessing the card before it is ready again
--------X-1A91-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - READ ONE
	AH = 91h
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
	BH = attributes (see #0604)
	DX:SI = card address
Return: CF clear if successful
	    AH destroyed
	    CL/CX = value read
	CF set on error
	    AH = error code (01h,07h,09h,0Bh,14h) (see #0573)
	    CX may be destroyed
Note:	this function is only valid for I/O-mapped sockets
SeeAlso: AH=92h,AH=93h,INT 21/AX=440Dh"DOS 3.2+"

Bitfields for PCMCIA attributes:
Bit(s)	Description	(Table 0604)
 2	even bytes only
 1	word rather than byte
 0	attribute memory instead of common memory
--------X-1A92-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - WRITE ONE
	AH = 92h
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
	BH = attributes (see #0604)
	CL/CX = value to write
	DX:SI = card address
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,07h,0Bh,12h,14h) (see #0573)
Note:	this function is only valid for I/O-mapped sockets; it also does not
	  implement Card Technology handling--use AH=94h when writing to
	  non-RAM technologies
SeeAlso: AH=91h,AH=94h,INT 21/AX=440Dh"DOS 3.2+"
--------X-1A93-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - READ MULTIPLE
	AH = 93h
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
	BH = attributes (see #0604)
	CX = number of bytes or words to read
	DX:SI = card address
	DS:DI -> data buffer to be filled
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,07h,09h,0Bh,14h) (see #0573)
Note:	this function is only available on I/O-mapped sockets
SeeAlso: AH=91h,AH=94h,INT 21/AX=440Dh"DOS 3.2+"
--------X-1A94-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - WRITE MULTIPLE
	AH = 94h
	AL = adapter number
	BL = socket number (01h to maximum supported by adapter)
	BH = attributes (see #0604)
	CX = number of bytes or words to read
	DX:DI = card address
	DS:SI -> buffer containing data
	BP = Card Technology type (0000h = RAM)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,07h,0Bh,0Ch,12h,14h) (see #0573)
Notes:	this function is only available on I/O-mapped sockets
	Socket Services calls the Card Technology callback (see #0578) for
	  any card technology it does not directly support
SeeAlso: AH=82h"PCMCIA",AH=92h,AH=93h,INT 21/AX=440Dh"DOS 3.2+"
--------X-1A95-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - INQUIRE ERROR DETECTION CODE
	AH = 95h
	AL = adapter number
	BH = EDC generator number
Return: CF clear if successful
	    AH destroyed
	    CX = bitmap of assignable sockets
	    DH = EDC capabilities (see #0605)
	    DL = supported EDC types (see #0606)
	CF set on error
	    AH = error code (01h,04h) (see #0573)
SeeAlso: AH=96h,AH=9Ch

Bitfields for EDC capabilities:
Bit(s)	Description	(Table 0605)
 0	unidirectional only generation
 1	bidirectional only generation
 2	register-based (I/O-mapped) support
 3	memory-mapped support
 4	pausable
 5-7	reserved (0)

Bitfields for supported EDC types:
Bit(s)	Description	(Table 0606)
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
	    DH = EDC attributes (see #0607)
	    DL = EDC type (see #0606) (only one bit set)
	CF set on error
	    AH = error code (01h,04h) (see #0573)
SeeAlso: AH=95h,AH=97h,AH=9Ch

Bitfields for EDC attributes:
Bit(s)	Description	(Table 0607)
 0	unidirectional only
 1	(if 0 set) clear=read, set=write
 2-7	reserved (0)
--------X-1A97-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - SET ERROR DETECTION CODE
	AH = 97h
	AL = adapter number
	BH = EDC generator
	BL = socket number
	DH = EDC attributes (see #0607)
	DL = EDC type (see #0606) (only one bit may be set)
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,02h,04h,0Bh) (see #0573)
SeeAlso: AH=96h,AH=9Ch
--------X-1A98-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - START ERROR DETECTION CODE
	AH = 98h
	AL = adapter number
	BH = EDC generator
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,04h) (see #0573)
SeeAlso: AH=96h,AH=99h,AH=9Bh,AH=9Ch
--------X-1A99-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - PAUSE ERROR DETECTION CODE
	AH = 99h
	AL = adapter number
	BH = EDC generator
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,04h) (see #0573)
SeeAlso: AH=9Ah
--------X-1A9A-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - RESUME ERROR DETECTION CODE
	AH = 9Ah
	AL = adapter number
	BH = EDC generator
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (01h,04h) (see #0573)
SeeAlso: AH=99h,AH=98h
--------X-1A9B-------------------------------
INT 1A - PCMCIA Socket Services v1.00 - STOP ERROR DETECTION CODE
	AH = 9Bh
	AL = adapter number
	BH = EDC generator
Return: CF clear if successful
	    AH destroyed
	CF set on error
	    AH = error code (see #0573)
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
	    AH = error code (01h,04h) (see #0573)
SeeAlso: AH=95h,AH=96h,AH=98h,AH=99h,AH=9Bh
--------X-1A9D-------------------------------
INT 1A - PCMCIA Socket Services v2.1??? - GET VENDOR INFO
	AH = 9Dh
	AL = adapter number
	BH = EDC generator
	ES:EDI -> vendor information structure (see #0608)
Return: CF clear if successful
	    AH destroyed
	    DX = vendor release number in BCD
	    ES:EDI unchanged
	CF set on error
	    AH = error code (01h,15h) (see #0573)
Notes:	this API is supported by recent versions of the AMI BIOS
	the low-level API described here is hidden by the higher-level
	  ExCA API once Card Services has been installed
SeeAlso: AH=9Dh"ExCA"

Format of Vendor Information structure:
Offset	Size	Description	(Table 0608)
 00h	WORD	buffer length (set to size of buffer below)
 04h	WORD	(ret) data length
 08h  x BYTEs	implementor name (ASCIIZ string)
--------X-1A9D-------------------------------
INT 1A - Intel PCMCIA ExCA Card Services - API
	AH = 9Dh
	AL = subfunction (see #0609)
	???
Return: ???
SeeAlso: AH=9Dh"ExCA",#0803

(Table 0609)
Values for PCMCIA ExCA Card Services subfunction number:
 00h	Client Services: Get Number of Sockets
 01h	Advanced Client Utilities: Initialize
 02h	Client Services: Register Client
 03h	Client Services: Deregister Client
 04h	Advanced Client Utilities: Enumerate Clients
 05h	Client Services: Register SCB
 06h	Client Services: Deregister SCB
 07h	Advanced Client Utilities: Register MTD
 08h	Advanced Client Utilities: Deregister MTD
 09h	Advanced Client Utilities: Enumerate MTD
 0Ah	Client Services: Get Status
 0Bh	Client Services: Reset Card
 0Ch	Client Utilities: Get First Tuple
 0Dh	Client Utilities: Get Next Tuple
 0Eh	Client Utilities: Determine First Region
 0Fh	Client Utilities: Determine Next Region
 10h	Client Utilities: Get First Region
 11h	Client Utilities: Get Next Region
 12h	Client Utilities: Get First Partition
 13h	Client Utilities: Get Next Partition
 14h	Bulk Memory Services: Open Region
 15h	Bulk Memory Services: Read Memory
 16h	Bulk Memory Services: Write Memory
 17h	Bulk Memory Services: Copy Memory
 18h	Bulk Memory Services: Erase Memory
 19h	Resource Management: Request I/O
 1Ah	Resource Management: Release I/O
 1Bh	Resource Management: Request Memory
 1Ch	Client Services: Modify Window
 1Dh	Resource Management: Release Memory
 1Eh	Client Services: Map Mem Page
 1Fh	Advanced Client Utilities: Return SS Entry
 20h	Advanced Client Utilities: Map Log to Phy
 21h	Advanced Client Utilities: Map Log Phy to Log
 22h	Resource Management: Request IRQ
 23h	Resource Management: Release IRQ
 24h	Bulk Memory Services: Close Region
--------X-1A9E-------------------------------
INT 1A - PCMCIA Socket Services v2.1 - ACKNOWLEDGE INTERRUPT
	AH = 9Eh
	AL = adapter number
Return: CF clear if successful
	    AH destroyed
	    CX = bitmap representing sockets which have changed status
	CF set on error
	    AH = error code (01h) (see #0573)
Note:	this API is supported by recent versions of the AMI BIOS
--------X-1A9F-------------------------------
INT 1A - PCMCIA Socket Services v2.1 - GET/SET PRIOR INT 1A HANDLER
	AH = 9Fh
	AL = adapter number
	BL = mode
	    00h get prior INT 1Ah handler
	    01h set prior INT 1Ah handler
		CX:DX -> new prior handler
Return: CF clear if successful
	    AH destroyed
	    CX:DX -> old prior handler
	CF set on error
	    AH = error code (01h,15h,18h) (see #0573)
Desc:	allows hooking of INT 16h "behind" the Socket Services hook
Note:	this API is supported by recent versions of the AMI BIOS
SeeAlso: AH=9Eh,AH=A0h"PCMCIA",AH=AEh"PCMCIA"
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
--------X-1AA0-------------------------------
INT 1A - PCMCIA Socket Services v2.1 - GET/SET SOCKET SERVICES ADDRESS
	AH = A0h
	AL = adapter number
	BH = mode
	    00h real mode
	    01h 16:16 protected mode
	    02h 16:32 protected mode
	    03h 00:32 (Flat) protected mode
	BL = subfunction
	    00h return number of additional data areas (see #0610)
	    01h return description of additional data areas (see #0611)
	    02h accept mode-specific pointers to data areas (see #0612)
	ES:EDI -> buffer supplied by caller
Return: CF clear if successful
	    AH destroyed
	    CX = number of additional data areas
	    ES:EDI unchanged
	CF set on error
	    AH = error code (01h,02h,15h,16h,18h) (see #0573)
SeeAlso: AH=9Fh,AH=AEh

Format of PCMCIA Subfunction 00h Buffer Table Entry structure:
Offset	Size	Description	(Table 0610)
 00h	DWORD	32-bit linear base address of the code segment
 04h	DWORD	segment limit of the code segment
 08h	DWORD	entry point offset
 0Ch	DWORD	32-bit linear base address of the data segment
		(ignored in 00:32 flat mode)
 10h	DWORD	segment limit of the data segment
 14h	DWORD	data area offset.  Only used in 32-bit protected mode.
SeeAlso: #0611,#0612

Format of PCMCIA Additional Data Area Description structure [array]:
Offset	Size	Description	(Table 0611)
 00h	DWORD	32-bit linear base address of the additional data segment
		(ignored in 00:32 flat mode)
 04h	DWORD	segment limit of the code segment
 08h	DWORD	data area offset (only used in 32-bit protected mode)
SeeAlso: #0610,#0612

Format of PCMCIA Subfunction 02h Buffer Table Entry structure:
Offset	Size	Description	(Table 0612)
 00h	DWORD	32-bit offset(ignored in 16:16 protected mode)
 04h	DWORD	selector (only used in 00:32 flat mode)
 08h	DWORD	reserved
SeeAlso: #0610,#0611
--------X-1AA1-------------------------------
INT 1A - PCMCIA Socket Services v2.1 - GET ACCESS OFFSETS
	AH = A1h
	AL = adapter number
	BH = Mode
	     00h = Real Mode
	     01h = 16:16 Protected Mode
	     02h = 16:32 Protected Mode
	     03h = 00:32 Protected Mode
	CX = Number of access offsets
	ES:EDI -> buffer supplied by caller, CX words long (see #0613)
Return: CF clear if successful
	    AH destroyed
	    DX = number of access offsets supported
	    ES:EDI unchanged
	CF set on error
	    AH = error code (01h,15h,16h) (see #0573)
Desc:	Returns an array of low-level adapter-specific optimized
	PC Card access routines for adapters that use registers
	or I/O ports to access PC Card memory.	Adapters that access
	PC Card memory through windows mapped to host system memory
	do not support this function.
Note:	offsets returned are 16-bit offsets into the
	Socket Services code segment.  They must be called
	appropriately for the processor mode selected.
	(Real, 16:16 and 16:32 modes use FAR CALL,
	Flat 00:32 mode uses a 32-bit NEAR CALL).
SeeAlso: AH=AEh

Format of Offset Table structure:
Offset	Size	Description	(Table 0613)
 00h	WORD	Set Address
 02h	WORD	Set Auto Increment
 04h	WORD	Read Byte
 06h	WORD	Read Word
 08h	WORD	Read Byte with Auto Increment
 0Ah	WORD	Read Word with Auto Increment
 0Ch	WORD	Read Words
 0Eh	WORD	Read Words with Auto Increment
 10h	WORD	Write Byte
 12h	WORD	Write Word
 14h	WORD	Write Byte with Auto Increment
 16h	WORD	Write Word with Auto Increment
 18h	WORD	Write Words
 1Ah	WORD	Write Words with Auto Increment
 1Ch	WORD	Compare Byte
 1Eh	WORD	Compare Byte with Auto Increment
 20h	WORD	Compare Words
 22h	WORD	Compare Words with Auto Increment
--------X-1AA2-------------------------------
INT 1A - CardBus Socket Services - ACCESS CONFIGURATION SPACE
	AH = A2h
	??? details not available
Return: ???
--------X-1AA4-------------------------------
INT 1A - CardBus Socket Services - GET BRIDGE WINDOW / WINDOW CAPABILITIES
	AH = A4h
	??? details not available
Return: ???
SeeAlso: AH=A5h"CardBus"
--------X-1AA5-------------------------------
INT 1A - CardBus Socket Services - SET BRIDGE WINDOW
	AH = A5h
	??? details not available
Return: ???
SeeAlso: AH=A4h"CardBus"
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
	AL = function code (see #0614)
Return: AH = 00h if successful
SeeAlso: AH=ABh

(Table 0614)
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
--------X-1AAE-------------------------------
INT 1A - PCMCIA Socket Services v2.1 - VENDOR SPECIFIC
	AH = AEh
	AL = adapter number
	all other registers are vendor-specific
Return: vendor specific
SeeAlso: AH=A1h,AH=AFh
--------X-1AAE-------------------------------
INT 1A - PCMCIA Socket Services v2.1 - API
	AH = AEh
	SI = function
	    0002h ???
	    0100h ???
	    0101h ???
	    8000h ???
	    8001h ???
	details not yet available
Return: CF clear if successful
	CF set on error
	    AH = error code (02h,0Bh,11h,15h,17h) (see #0573)
SeeAlso: AH=9Eh
--------X-1AAF-------------------------------
INT 1A - PCMCIA v2 Card Services - API
	AH = AFh
	AL = function
	    00h close memory
	    01h copy memory
	    02h deregister client
	    03h get client information (see #0619)
	    04h get configuration information (see #0621)
	    05h get first partition
	    06h get first region
	    07h get first tuple (see #0628)
	    08h get next partition
	    09h get next region
	    0Ah get next tuple
	    0Bh	get Card Services information (see #0617)
	    0Ch get status
	    0Dh	get tuple data (see #0629)
	    0Eh	get first client (see #0618)
	    0Fh get/register Erase Queue
	    10h	register client (see #0630)
	    11h reset function
	    12h map logical socket
	    13h map logical window
	    14h map memory page
	    15h map physical socket
	    16h map physical window
	    17h modify window
	    18h open memory
	    19h read memory
	    1Ah register MTD
	    1Bh release I/O
	    1Ch release IRQ (see #0632)
	    1Dh release window
	    1Eh release configuration (see #0633)
	    1Fh request I/O (see #0634)
	    20h request IRQ (see #0635)
	    21h reqeust window (see #0637)
	    22h request socket mask
	    23h return SS entry
	    24h write memory
	    25h deregister Erase Queue
	    26h check Erase Queue
	    27h modify configuration
	    28h register timer
	    29h set region
	    2Ah get next client
	    2Bh validate CIS
	    2Ch request exclusive access (see #0640)
	    2Dh release exclusive access (see #0640)
	    2Eh get event mask
	    2Fh release socket mask
	    30h request configuration (see #0641)
	    31h set event mask
	    32h add Socket Service
	    33h replace Socket Service
	    34h vendor-specific
	    35h adjust resource information
	    36h access configuration register
	    37h get first window
	    38h get next window
	    39h get memory page
	    3Ah request DMA
	    3Bh release DMA
	further details not yet available
Return: ??? = result code (see #0615)
SeeAlso: AH=AEh

(Table 0615)
Values for PCMCIA Card Services result codes:
 00h	successful
 01h	invalid adapter number
 02h	bad value for attribute field
 03h	bad value for base system memory address
 04h	invalid EDC generator specified
 05h	(reserved for historical reasons)
 06h	invalid IRQ level specified
 07h	invalid PC Card memory array offset
 08h	invalid page number specified
 09h	unable to complete read request
 0Ah	invalid size specified
 0Bh	invalid socket number
 0Ch	(reserved for historical reasons)
 0Dh	invalid window or interface type
 0Eh	invalid Vcc power level specified
 0Fh	invalid Vpp1 or Vpp2 power level specified
 10h	(reserved for historical reasons)
 11h	invalid window number
 12h	unable to complete write request
 13h	(reserved for historical reasons)
 14h	no PC Card in socket
 15h	service not supported by implementation
 16h	unsupported processor mode
 17h	specified speed not available
 18h	busy -- retry later
 19h	undefined error (general failure)
 1Ah	storage medium write protected
 1Bh	argument length in (E)CX is invalid
 1Ch	bad value(s) in argument packet
 1Dh	configuration has already been locked
 1Eh	requested resource already in use
 1Fh	no more items of requested type available
 20h	out of resources
 21h	invalid client handle
 22h	unsupported client version

(Table 0616)
Values for Card Services Callback Event codes:
 01h	battery dead
 02h	battery low
 03h	card locked
 04h	card has become ready
 05h	card removed
 06h	card unlocked
 07h	motorized ejection complete
 08h	ejection requested
 09h	insertion complete
 0Ah	insertion requested
 0Bh	power management: resume
 0Ch	power management: suspend
 0Dh	exclusive access granted
 0Eh	exclusive access requested
 0Fh	perform physical reset
 10h	physical reset requested
 11h	card has been reset
 12h	MTD request (read/write/etc)
 14h	request for client info
 15h	timer has expired
 16h	Socket Service was modified
 17h	write-protected
 18h	attention requested
 40h	card insertion
 80h	reset complete
 81h	erase complete
 82h	registration complete

Format of Card Services Information:
Offset	Size	Description	(Table 0617)
 00h	WORD	length of information record in bytes
 02h	WORD	signature
 04h	WORD	number of sockets
 06h	WORD	revision level
 08h	WORD	Card Services level
 0Ah	WORD	offset of vendor string
 0Ch	WORD	length of vendor string
 0Eh	WORD	number of functions
 10h 255 BYTEs	vendor string
SeeAlso: #0619

Format of Card Services Client structure:
Offset	Size	Description	(Table 0618)
 00h	WORD	PCMCIA socket number
 02h	WORD	client attributes

Format of Cards Services Client Information:
Offset	Size	Description	(Table 0619)
 00h	WORD	maximum length of data in bytes (180)
 02h	WORD	(ret) length of returned data
 04h	WORD	attributes (see #0620)
 06h	WORD	revision level (BCD)
 08h	WORD	Card Services level (BCD)
 0Ah	WORD	revision date (DOS packed date format) (see #1318)
 0Ch	WORD	offset to name
 0Eh	WORD	length of name
 10h	WORD	offset to vendor string
 12h	WORD	length of vendor string
 14h 80 BYTEs	buffer for name
 64h 80 BYTEs	buffer for vendor string
SeeAlso: #0617,#0621

Bitfields for Card Services client attributes:
Bit(s)	Description	(Table 0620)
 0	memory client
 1	MTD client
 2	I/O client
 3	all clients can share this card
 4	only one client can use this card at a time
SeeAlso: #0619

Format of Card Services configuration information:
Offset	Size	Description	(Table 0621)
 00h	WORD	socket (usually 0000h)
 02h	WORD	attributes (see #0622)
 04h	BYTE	Vcc value
 05h	BYTE	Vpp1 value
 06h	BYTE	Vpp2 value
 07h	BYTE	interface type (see #0623)
 08h	DWORD	base address of configuration registers
 0Ch	BYTE	card's Status register setting (if present)
 0Dh	BYTE	card's Pin register setting (if present)
 0Eh	BYTE	card's Socket/Copy register setting (if present)
 0Fh	BYTE	card's Option register setting (if present)
 10h	BYTE	bitmap of present card configuration registers
 11h	BYTE	first device type
 12h	BYTE	function code
 13h	BYTE	SysInit mask
 14h	WORD	manufacturer code
 16h	WORD	manufacturer information
 18h	BYTE	valie card register values
 19h	BYTE	IRQ number assigned to PC Card
 1Ah	WORD	IRQ attributes (see #0625)
 1Ch	WORD	base port address (for I/O range 1)
 1Eh	BYTE	number of contiguous ports (for I/O range 1)
 1Fh	BYTE	bitmap of port attributes (for I/O range 1) (see #0626)
 20h	WORD	base port address (for I/O range 2)
 22h	BYTE	number of contiguous ports (for I/O range 2)
 23h	BYTE	bitmap of port attributes (for I/O range 2) (see #0626)
 24h	BYTE	number of I/O address lines decoded (16-bit PC Card only)
 25h	BYTE	extended status register setting (if present)
 26h	BYTE	bitmap of DMA attributes (see #0627)
		(note: value at call is used to set!)
 27h	BYTE	assigned DMA channel
 28h	BYTE	number of I/O windows in use on logical socket
 29h	BYTE	number of memory windows in use on logical socket
SeeAlso: #0620,#0641

Bitfields for Card Services Configuration attributes:
Bit(s)	Description	(Table 0622)
 0	exclusive
 1	IRQ active
 2	CardBus card
 3-5	reserved (0)
 6	DMA channel is active
 7	reserved (0)
 8	valid client
 9	overwrite voltage value
 10-15	reserved (0)
SeeAlso: #0621

Bitfields for Card Services Configuration interface type:
Bit(s)	Description	(Table 0623)
 0	memory interface
 1	I/O and memory interface
 2	CardBus interface
 3-7	reserved (0)
SeeAlso: #0621

Bitfields for Card Services Configuration registers:
Bit(s)	Description	(Table 0624)
 0	option value is value
 1	status value
 2	pin-replacement value
 3	copy value
 4	extended status value
 5-7	reserved (0)
SeeAlso: #0621

Bitfields for Card Services Configuration IRQ attributes:
Bit(s)	Description	(Table 0625)
 1-0	sharing
	00 no sharing
	01 time-multiplex sharing
	10 dynamic sharing
	11 reserved
 2	force pulse mode
 3	first used together
 4-7	reserved
 8	pulse IRQ has been assigned
 9-15	reserved
SeeAlso: #0621,#0626,#0627,#0632,#0635

Bitfields for Card Services Configuration Port attributes:
Bit(s)	Description	(Table 0626)
 0	shared I/O ports
 1	"CS_FirstCommonUsedCard"
 2	force alias access
 3	=1 sixteen-bit I/O
	=0 eight-bit I/O
 7-4	reserved (0)
SeeAlso: #0621,#0625,#0627,#0634

Bitfields for Card Services Configuration DMA attributes:
Bit(s)	Description	(Table 0627)
 1-0	sharing mode
	00 no sharing
	01 time-multiplex sharing
	10 dynamic sharing
	11 reserved
 3-2	DMA request signal
	00 reserved
	01 DMARQ uses pin SPKR#
	10 DMARQ uses pin IOIS16#
	11 DMARQ uses pin INPACK#
 4	DMA size
	0 eight bits
	1 sixteen bits
 7-5	reserved (0)
SeeAlso: #0621,#0625,#0626

Format of Card Services Tuple information:
Offset	Size	Description	(Table 0628)
 00h	WORD	logical socket number
 02h	WORD	attributes
		bit 0: return Link tuples
 04h	BYTE	code value of desired tuple
 05h	BYTE	reserved (0)
 06h	WORD	(ret) TupleFlags
 08h	DWORD	(ret) -> Card Services Link State Information
 0Ch	DWORD	(ret) -> Card Services CIS State Information
 10h	BYTE	(ret) code for tuple
 11h	BYTE	(ret) link value for tuple
SeeAlso: #0629

Format of Card Services GetTupleData record:
Offset	Size	Description	(Table 0629)
 00h	WORD	logical socket
 02h	WORD	attributes
 04h	BYTE	code value of desired tuple
 05h	BYTE	offset into tuple from link byte
 06h	WORD	flags
 08h	DWORD	-> Link
 0Ch	DWORD	-> CIS
 10h	WORD	(call) maximum amount of data to return (0004h)
 12h	WORD	(ret) amount of data returned
 14h	DWORD	(ret) tuple data
SeeAlso: #0628

Format of Card Services Client Registration record:
Offset	Size	Description	(Table 0630)
 00h	WORD	attributes
 02h	WORD	event mask
 04h	WORD	client data (passed to client event handler in DI)
--- 16-bit code ---
 06h	WORD	client data selector (passed to event handler in DS)
 08h	WORD	client data offset (passed to event handler in SI)
 0Ah	WORD	reserved
--- 32-bit code ---
 06h	WORD	reserved
 08h	DWORD	client data offset (passed to event handler in ESI)
------
 0Ch	WORD	expected Card Services version (0210h for v2.10)

Bitfields for Card Services client event codes:
Bit(s)	Description	(Table 0631)
 0	change in write-protect status
 1	change in card lock
 2	ejection request
 3	insertion request
 4	battery is dead
 5	battery low
 6	change in Ready
 7	change in Card Detect
 8	power management change
 9	reset
 10	Socket Services updated
 11	extended status change
SeeAlso: #0630

Format of Card Services ReleaseIRQ record:
Offset	Size	Description	(Table 0632)
 00h	WORD	logical socket number
 02h	WORD	attributes (see #0625)
 04h	BYTE	assigned IRQ number to be released

Format of Card Services Release Configuration record:
Offset	Size	Description	(Table 0633)
 00h	WORD	logical socket number

Format of Card Services Request I/O record:
Offset	Size	Description	(Table 0634)
 00h	WORD	logical socket number
 02h	WORD	base port 1
 04h	BYTE	size of port range 1
 05h	BYTE	attributes for port range 1 (see #0626)
 06h	WORD	base port 2
 08h	BYTE	size of port range 2
 09h	BYTE	attributes for port range 2 (see #0626)
 0Ah	BYTE	number of address lines (typically 16)
SeeAlso: #0635,#0633

Format of Card Services Request IRQ record:
Offset	Size	Description	(Table 0635)
 00h	WORD	logical socket number
 02h	WORD	attributes (see #0625)
 04h	BYTE	(ret) assigned IRQ number, if successful
 05h	BYTE	IRQ info (see #0636)
 06h	WORD	bitmap of available IRQs (bit 0 = IRQ0, etc.)
		(only if bit 4 of IRQ info set)
SeeAlso: #0634,#0633

Bitfields for Card Services Request IRQ info flags:
Bit(s)	Description	(Table 0636)
 7	IRQ is shared
 6	pulse (edge-triggered) interrupt
 5	level interrupt
 4	use IRQ bitmap
--- bit 4 set ---
 3	vendor-specific interrupt
 2	bus error
 1	I/O check interrupt
 0	NMI
--- bit 4 clear ---
 3-0	IRQ number
SeeAlso: #0635

Format of Card Services Request Window record:
Offset	Size	Description	(Table 0637)
 00h	WORD	logical socket number
 02h	WORD	attributes (see #0638)
 04h	DWORD	system base adress
 08h	DWORD	size of memory window
 0Ch	BYTE	additional info
		if attributes bit ??? is set, this is the address-lines field
		otherwise, this is the access-speed field (see #0639)

Bitfields for Card Services Request Window attributes:
Bit(s)	Description	(Table 0638)
 0	I/O window instead of memory window
 1	attribute memory instead of normal memory (16-bit PC Cards only)
 2	window enabled
 3	16-bit data path instead of 8-bit path (16-bit PC Cards only, v2.10+)
	(ignored if bit 9 set)
 4	size is given in 16K pages (invalid for CardBus PC Cards)
 5	shared (invalid for CardBus)
 6	first shared (invalid for CardBus)
 7	"CS_BindingSpecific" (memory window only)
 8	card offsets are window-size granular (16-bit PC Card memory window)
 9	32-bit data path (CardBus only)
 10	reserved (0)
 12-11	prefetch/cache
	00 neither prefetchable nor cacheable
	01 prefetchable but not cacheable
	10 prefetchable and cachable
	11 reserved
 15-13	decoded base address register number (CardBus only)
SeeAlso: #0637,#0639

Bitfields for Card Services Request Window access-speed:
Bit(s)	Description	(Table 0639)
 6-3	mantissa
	0000 use device speed code
	0001  1.0
	0010  1.2
	0011  1.2 ???
	0100  1.5
	0101  2.0
	0110  2.5
	0111  3.0
	1000  3.5
	1001  4.0
	1010  4.5
	1011  5.0
	1100  5.5
	1101  6.0
	1110  7.0
	1111  8.0
--- if mantissa==0 ---
 2-0	device speed code
	000 reserved
	001 250 ns
	010 200 ns
	011 150 ns
	100 100 ns
	101-111 reserved
--- if mantissa<>0 ---
 2-0	speed exponent
	000	1 ns
	001    10 ns
	010   100 ns
	011	1 us
	100    10 us
	101   100 us
	110	1 ms
	111    10 ms
SeeAlso: #0637,#0638

Format of Card Services Request/Release Exclusive Access record:
Offset	Size	Description	(Table 0640)
 00h	WORD	logical socket number
 02h	WORD	attributes (currently all reserved, must be 0000h)

Format of Card Services Request Configuration record:
Offset	Size	Description	(Table 0641)
 00h	WORD	socket (usually 0000h)
 02h	WORD	attributes (see #0622)
 04h	BYTE	Vcc value
 05h	BYTE	Vpp1 value
 06h	BYTE	Vpp2 value
 07h	BYTE	interface type (see #0623)
 08h	DWORD	base address of configuration registers
 0Ch	BYTE	card's Status register setting (if present)
 0Dh	BYTE	card's Pin register setting (if present)
 0Eh	BYTE	card's Socket/Copy register setting (if present)
 0Fh	BYTE	card's Option register setting (if present)
 10h	BYTE	bitmap of present card configuration registers
 11h	BYTE	extended status register setting (if present)
SeeAlso: #0621
--------X-1AB000-----------------------------
INT 1A U - HP 100LX/200LX - PCMCIA - ???
	AX = B000h
	ES:BX -> parameter block ???
Return: CF clear if ???
	CF set if ???
Note:	called by HP 100LX/200LX PCMCIA client CIC100.EXE
--------d-1AB001CX4D52-----------------------
INT 1A - Microsoft Real-Time Compression Interface (MRCI) - ROM-BASED SERVER
	AX = B001h
	CX = 4D52h ("MR")
	DX = 4349h ("CI")
Return: CX = 4943h ("IC") if installed
	DX = 524Dh ("RM") if installed
	    ES:DI -> MRCINFO structure (see #0642)
Note:	this call is functionally identical to INT 2F/AX=4A12h, which should
	  be called first, as this call is used for the first, ROM-based
	  MRCI server, while the other call is used for RAM-based servers
	  which may be partially or entirely replacing a prior server
SeeAlso: INT 2F/AX=4A12h

Format of MRCINFO structure:
Offset	Size	Description	(Table 0642)
 00h  4 BYTEs	vendor signature
		"MSFT" Microsoft
 04h	WORD	server version (high=major)
 06h	WORD	MRCI specification version
 08h	DWORD	address of server entry point (see #0644)
 0Ch	WORD	bit flags: server capabilities (see #0643)
 0Eh	WORD	bit flags: hardware assisted capabilities (see #0643)
 10h	WORD	maximum block size supported by server (at least 8192 bytes)

Bitfields for MRCI capabilities:
Bit(s)	Description	(Table 0643)
 0	standard compress
 1	standard decompress
 2	update compress
 3	MaxCompress (not present in initial public release)
 4	reserved
 5	incremental decompress
 6	MRCI 2.0 standard compress
 7	MRCI 2.0 standard decompress
 8-14	reserved
 15	this structure is in ROM and can't be modified
	(server capabilities only)

(Table 0644)
Call MRCI entry point with:
	DS:SI -> MRCREQUEST structure (see #0645)
	CX = type of client (0000h application, 0001h file system)
	AX = operation
	    0001h perform standard compression
	    0002h perform standard decompression
	    0004h perform update compression
	    0008h perform MaxCompress
	    0020h perform incremental decompression
	    0040h perform MRCI 2.0 standard compression
	    0080h perform MRCI 2.0 standard decompression
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
Offset	Size	Description	(Table 0645)
 00h	DWORD	pointer to source buffer
 04h	WORD	size of source buffer (0000h = 64K)
 06h	WORD	(UpdateCompress only)
		(call) offset in source buffer of beginning of changed data
		(ret) offset in destination buffer of beginning of changed
			  compressed data
 08h	DWORD	pointer to destination buffer
		must contain original compressed data for UpdateCompress
 0Ch	WORD	size of destination buffer (0000h = 64K)
		any compression: size of buffer for compressed data
		standard decompression: number of bytes to be decompressed
		incremental decompression: number of byte to decompress now
		(ret) actual size of resulting data
 0Eh	WORD	client compressed data storage allocation size
 10h	DWORD	incremental decompression state data
		set to 00000000h before first incremental decompression call
Notes:	the source and destination buffers may not overlap
	the source and destination buffer sizes should normally be the same
	application should not update the contents of the MRCREQUEST structure
	  between incremental decompression calls
--------X-1AB101-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - INSTALLATION CHECK
	AX = B101h
	EDI = 00000000h
Return: AH = 00h if installed
	    CF clear
	    EDX = 20494350h (' ICP')
	    EDI = physical address of protected-mode entry point (see #0648)
	    AL = PCI hardware characteristics (see #0647)
	    BH = PCI interface level major version (BCD)
	    BL = PCI interface level minor version (BCD)
	    CL = number of last PCI bus in system
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	some BIOSes do not change EDI, so applications looking for the
	  protected-mode entry point should set EDI to 00000000h before
	  calling this function
SeeAlso: AX=B181h

(Table 0646)
Values for PCI BIOS v2.0c+ status codes:
 00h	successful
 81h	unsupported function
 83h	bad vendor ID
 86h	device not found
 87h	bad PCI register number

Bitfields for PCI hardware characteristics:
Bit(s)	Description	(Table 0647)
 0	configuration space access mechanism 1 supported
 1	configuration space access mechanism 2 supported
 2-3	reserved
 4	Special Cycle generation mechanism 1 supported
 5	Special Cycle generation mechanism 2 supported
 6-7	reserved

(Table 0648)
Call protected-mode entry point with:
	registers as for real/V86-mode INT call
	CS = ring 0 descriptor with access to full address space
Return: as for real/V86-mode call
--------X-1AB102-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - FIND PCI DEVICE
	AX = B102h
	CX = device ID (see #0652,#0658,#0659,#0785,#0787)
	DX = vendor ID (see #0649)
	SI = device index (0-n)
Return: CF clear if successful
	CF set on error
	AH = status (00h,83h,86h) (see #0646)
	    00h successful
		BH = bus number
		BL = device/function number (bits 7-3 device, bits 2-0 func)
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	device ID FFFFh may be reserved as a wildcard in future implementations
	the meanings of BL and BH on return were exchanged between the initial
	  drafts of the specification and final implementation
	all devices sharing a single vendor ID and device ID may be enumerated
	  by incrementing SI from 0 until error 86h is returned
SeeAlso: AX=B182h

(Table 0649)
Values for PCI vendor ID:
 003Dh	Martin-Marietta Corporation
 0E11h	Compaq (see #0650)
 1000h	Symbios Logic Inc (formerly NCR) (see #0651)
 1002h	ATI (see #0652)
 1003h	ULSI Systems
 1004h	VLSI Technologies (see #0653)
 1005h	Avance Logics (ADL) (see #0654)
 1006h	Reply Group
 1007h	Netframe Systems Inc.
 1008h	Epson
 100Ah	Phoenix Technologies
 100Bh	National Semiconductor (see #0655)
 100Ch	Tseng Labs (see #0656) (also ID 10BEh)
 100Dh	AST Research
 100Eh	Weitek (see #0657)
 1010h	Video Logic Ltd
 1011h	DEC (see #0658)
 1012h	Micronics Computers
 1013h	Cirrus Logic (see #0659,#0028)
 1014h	IBM (see #0660)
 1015h	LSI Logic Corp. of Canada
 1016h	ICL Personal Systems
 1017h	SPEA Software AG
 1018h	Unisys
 1019h	EliteGroup Computer Sys
 101Ah	NCR/AT&T GIS
 101Bh	Vitesse Semiconductor
 101Ch	Western Digital (see #0661)
 101Eh	AMI (see #0662)
 101Fh	Picturetel
 1020h	Hitachi Computer Electronics
 1021h	Oki Electric Industry
 1022h	Advanced Micro Devices (see #0663)
 1023h	Trident Microsystems (see #0664)
 1024h	Zenith Data Systems
 1025h	Acer
 1028h	Dell Computer Corporation
 1029h	Siemens Nixdorf
 102Ah	LSI Logic, Headland Division (see #0665)
 102Bh	Matrox (see #0666)
 102Ch	Chips & Technologies (see #0667)
 102Dh	Wyse Technologies
 102Eh	Olivetti Advanced Technology
 102Fh	Toshiba America (see #0668)
 1030h	TMC Research
 1031h	Miro / Micro Computer Products AG (see #0669)
 1032h	Compaq
 1033h	NEC Corporation (see #0670)
 1034h	Burndy Corporation
 1035h	Computers and Communications Research Lab
 1036h	Future Domain (see #0671)
 1037h	Hitachi Micro Systems
 1038h	AMP Incorporated
 1039h	Silicon Integrated System (SIS) (see #0672)
 103Ah	Seiko Epson Corporation
 103Bh	Tatung Corp. of America
 103Ch	Hewlett-Packard (see #0673)
 103Eh	Solliday
 103Fh	Logic Modeling
 1040h	Kubota Pacific
 1041h	Computrend
 1042h	PC Technology (see #0674,#0890) (see also PORT 03F0h"PCTech")
 1043h	Asustek
 1044h	Distributed Processing Technology (DPT) (see #0675)
 1045h	OPTi (see #0676)
 1046h	IPC Corporation, Ltd.
 1047h	Genoa Systems Corp.
 1048h	Elsa GmbH
 1049h	Fountain Technology
 104Ah	SGS Thomson Microelectric (see #0677)
 104Bh	BusLogic (see #0678)
 104Ch	Texas Instruments (see #0679)
 104Dh	Sony Corporation
 104Eh	Oak Technology (see #0680)
 104Fh	Co-Time Computer Ltd.
 1050h	Winbond (see #0681)
 1051h	Anigma Corp.
 1052h	Young Micro Systems
 1054h	Hitachi, Ltd. (see #0682)
 1055h	EFAR Microsystems (see #0683)
 1056h	ICL
 1057h	Motorola (see #0684)
 1058h	Electronics and Telecommunications Research
 1059h	Teknor Microsystems
 105Ah	Promise Technology (see #0685)
 105Bh	Foxconn International
 105Ch	Wipro Infotech Ltd.
 105Dh	Number 9 Computer Company (see #0686)
 105Eh	VTech Engineering Canada, Ltd.
 105Fh	Infotronic America, Inc.
 1060h	United Microelectronics (UMC) (see #0687)
 1061h	8x8 (X Tech) (see #0688)
 1062h	Maspar Computer Copr.
 1063h	Ocean Office Automation
 1064h	Alcatel Cit
 1065h	Texas Microsystems
 1066h	PicoPower Technology (see #0689)
 1067h	Mitsubishi Electronics
 1068h	Diversified Technology
 1069h	Mylex Corporation (see #0690)
 106Ah	Aten Research
 106Bh	Apple Computer
 106Ch	Hyundai Electronics America
 106Dh	Sequent
 106Eh	DFI Inc.
 106Fh	City Gate Development, Ltd.
 1070h	Daewoo Telecom Ltd.
 1071h	Mitac
 1072h	GIT Co., Ltd.
 1073h	Yamaha Corporation (see #0691)
 1074h	NexGen Microsystems (see #0692)
 1075h	Advanced Integration Research
 1076h	Chaintech Computer Co. Ltd.
 1077h	Q Logic (see #0693)
 1078h	Cyrix Corporation
 1079h	I-Bus
 107Ah	Networth
 107Bh	Gateway 2000
 107Ch	Goldstar Co. Ltd.
 107Dh	Leadtek Research (see #0694)
 107Eh	Interphase Corporation (see #0695)
 107Fh	Data Technology Corporation (DTC) (see #0696)
 1080h	Contaq Microsystems (see #0697)
 1081h	Supermac Technology
 1082h	EFA Corporation of America
 1083h	Forex Computer Corporation (see #0698)
 1084h	Parador
 1085h	Tulip Computers Int'l BV
 1086h	J. Bond Computer Systems
 1087h	Cache Computer
 1088h	Microcomputer Systems (M) Son
 1089h	Data General Corporation
 108Ah	Bit3 Computer (see #0699)
 108Ch	Elonex PLC (Oakleigh Systems, Inc)
 108Dh	Olicom (see #0700)
 108Eh	Sun Microsystems
 108Fh	Systemsoft Corporation
 1090h	Encore Computer Corporation
 1091h	Intergraph Corporation (see #0701)
 1092h	Diamond Computer Systems
 1093h	National Instruments (see #0702)
 1094h	First International Computers (FIC)
 1095h	CMD Technology, Inc. (see #0703)
 1096h	Alacron
 1097h	Appian Technology (see #0704)
 1098h	Vision / Quantum Designs Ltd (see #0705)
 1099h	Samsung Electronics Co. Ltd.
 109Ah	Packard Bell
 109Bh	Gemlight Computer Ltd.
 109Ch	Megachips Corporation
 109Dh	Zida Technologies
 109Eh	Brooktree Corporation (see #0706)
 109Fh	Trigem Computer Inc.
 10A0h	Meidensha Corporation
 10A1h	Juko Electronics Inc. Ltd.
 10A2h	Quantum Corporation
 10A3h	Everex Systems Inc.
 10A4h	Globe Manufacturing Sales
 10A5h	Racal Interlan
 10A6h	Informtech Industrial Ltd.
 10A7h	Benchmarq Microelectronics
 10A8h	Sierra Semiconductor (see #0707)
 10A9h	Silicon Graphics
 10AAh	ACC Microelectronics (see #0708)
 10ABh	Digicom
 10ACh	Honeywell IASD
 10ADh	Symphony Labs (see #0709)
 10AEh	Cornerstone Technology
 10AFh	Microcomputer Systems
 10B0h	CardExpert Technology
 10B1h	Cabletron Systems, Inc.
 10B2h	Raytheon Company
 10B3h	Databook Inc
 10B4h	STB Systems
 10B5h	PLX Technology (see #0710)
 10B6h	Madge Networks (see #0711)
 10B7h	3com Corporation (see #0712)
 10B8h	Standard Microsystems Corporation (SMC) (see #0713)
 10B9h	Acer Labs Inc. (see #0714)
 10BAh	Mitsubishi Electronics Corp.
 10BBh	Dapha Electronics Corporation
 10BCh	Advanced Logic Research Inc. (ALR)
 10BDh	Surecom Technology (see #0715)
 10BEh	Tseng Labs International Corp. (see #0656)
 10BFh	Most Inc.
 10C0h	Boca Research Inc.
 10C1h	ICM Corp. Ltd.
 10C2h	Auspex Systems Inc.
 10C3h	Samsung Semiconductors
 10C4h	Award Software International Inc.
 10C5h	Xerox Corporation
 10C6h	Rambus Inc.
 10C7h	Media Vision
 10C8h	Neomagic Corporation (see #0716)
 10C9h	DataExpert Corporation
 10CAh	Fujitsu
 10CBh	Omron Corporation
 10CCh	Mentor Arc Inc.
 10CDh	Advanced System Products (see #0717)
 10CEh	Radius Inc.
 10CFh	Citicorp TTI (see #0718)
 10D0h	Fujitsu Limited
 10D1h	Future+ Systems
 10D2h	Molex Incorporated
 10D3h	Jabil Circuit Inc.
 10D4h	Hualon Microelectronics
 10D5h	Autologic Inc.
 10D6h	Cetia
 10D7h	BCM Advanced Research
 10D8h	Advanced Peripherals Labs
 10D9h	Macronix International Co. Ltd
 10DAh	Thomas-Conrad Corporation
 10DBh	Rohm Research
 10DCh	CERN/ECP/EDU (see #0719)
 10DDh	Evans & Sutherland (see #0720)
 10DEh	NVidia Corporation
 10DFh	Emulex Corporation (see #0721)
 10E0h	Integrated Micro Solutions (IMS) (see #0722)
 10E1h	TekRAM Technology Corporation Ltd. (see #0723)
 10E2h	Aptix Corporation
 10E3h	Newbridge Microsystems (see #0724)
 10E4h	Tandem Computers
 10E5h	Micro Industries
 10E6h	Gainbery Computer Products Inc.
 10E7h	Vadem
 10E8h	Applied Micro Circuits Corp. (see #0725)
 10E9h	Alps Electronic Corp. Ltd.
 10EAh	Integraphics Systems (see #0726)
 10EBh	Artist Graphics (see #0727)
 10ECh	Realtek Semiconductor (see #0728)
 10EDh	ASCII Corporation (see #0729)
 10EEh	Xilinx Corporation
 10EFh	Racore Computer Products
 10F0h	Peritek Corporation
 10F1h	Tyan Computer
 10F2h	Achme Computer Inc.
 10F3h	Alaris Inc.
 10F4h	S-MOS Systems
 10F5h	NKK Corporation (see #0730)
 10F6h	Creative Electronic Systems SA
 10F7h	Matsushita Electric Industrial Corp. Ltd.
 10F8h	Altos India Ltd.
 10F9h	PC Direct
 10FAh	Truevision (see #0731)
 10FBh	Thesys Microelectronics
 10FCh	I/O Data Device Inc.
 10FDh	Soyo Technology Corp. Ltd.
 10FEh	Fast Electronic GmbH
 10FFh	N-Cube
 1100h	Jazz Multimedia
 1101h	Initio Corporation (see #0732)
 1102h	Creative Labs
 1103h	Triones Technologies Inc.
 1104h	Rasterops
 1105h	Sigma Designs, Inc.
 1106h	VIA Technologies (see #0733)
 1107h	Stratus Computer
 1108h	Proteon Inc. (see #0734)
 1109h	Cogent Data Technologies (see #0735)
 110Ah	Siemens AG / Siemens Nixdorf AG (see #0736)
 110Bh	Xenon Microsystems
 110Ch	Mini-Max Technology Inc.
 110Dh	ZNyX Corporation
 110Eh	CPU Technology
 110Fh	Ross Technology
 1110h	Powerhouse Systems
 1111h	Santa Cruz Operation (SCO)
 1112h	Rockwell / RNS division of Meret Communications Inc. (see #0737)
 1113h	Accton Technology Corporation
 1114h	Atmel Corporation
 1115h	DuPont Pixel Systems
 1116h	Data Translation
 1117h	Datacube Inc. (see #0738)
 1118h	Berg Electronics
 1119h	Vortex Computersysteme GmbH (see #0739)
 111Ah	Efficient Networks, Inc. (see #0740)
 111Bh	Teledyne Electronic Systems
 111Ch	Tricord Systems, Inc.
 111Dh	Integrated Device Technology
 111Eh	Eldec Corporation
 111Fh	Precision Digital Images
 1120h	EMC Corporation
 1121h	Zilog
 1122h	Multi-tech Systems, Inc.
 1124h	Leutron Vision AG
 1125h	Eurocore
 1126h	Vigra
 1127h	FORE Systems (see #0741)
 1128h	???
 1129h	Firmworks
 112Ah	Hermes Electronics Co.
 112Bh	Linotype - Hell AG
 112Dh	Ravicad
 112Eh	Infomedia MicroElectronics Inc (see #0742)
 112Fh	Imaging Technology (see #0743)
 1130h	Computervision
 1131h	Philips Semiconductors
 1132h	Mitel Corp
 1133h	Eicon Technology Corporation
 1134h	Mercury Computer Systems Inc (see #0744)
 1135h	Fuji Xerox Co Ltd (see #0745)
 1136h	Momentum Data Systems
 1137h	Cisco Systems Inc
 1138h	Ziatech Corporation (see #0746)
 1139h	Dynamic Pictures Inc (see #0747)
 113Ah	FWB Inc
 113Ch	Cyclone Microsystems (PLX) (see #0748)
 113Dh	Leading Edge Products Inc
 113Eh	Sanyo Electric Co
 113Fh	Equinox Systems
 1140h	Intervoice Inc
 1141h	Crest Microsystem Inc (see #0749)
 1142h	Alliance Semiconductor Corp (see #0750)
 1143h	Netpower, Inc.
 1144h	Cincinnati Milacron (see #0751)
 1145h	Workbit Corp
 1146h	Force Computers
 1147h	Interface Corp.
 1148h	Schneider & Koch Co. (see #0752)
 1149h	Win System Corporation
 114Ah	VMIC (see #0753)
 114Bh	Canopus Co.
 114Ch	Annabooks
 114Dh	IC Corporation
 114Eh	Nikon Systems Inc
 114Fh	Digi International / Stargate (see #0754)
 1150h	Thinking Machines Corp.
 1151h	JAE Electronics Inc.
 1152h	Megatek
 1153h	Land Win Electronic Corp.
 1154h	Melco Inc.
 1155h	Pine Technology Ltd.
 1156h	Periscope Engineering
 1157h	Avsys Corporation
 1158h	Voarx R&D Inc. (see #0755)
 1159h	MuTech (see #0756)
 115Ah	Harleguin Ltd.
 115Bh	Parallax Graphics
 115Ch	???
 115Dh	Xircom
 115Eh	Peer Protocols Inc.
 115Fh	???
 1160h	Megasoft Inc.
 1161h	PFU Ltd. (see #0757)
 1162h	OA Laboratory Co Ltd.
 1163h	Creative Labs (see #0758)
 1164h	Advanced Peripherals Tech
 1165h	Imagraph Corporation (see #0759)
 1166h	Pequr Technology Inc.
 1167h	Mutoh Industries, Inc.
 1168h	Thine Electronics Inc
 1169h	???
 116Ah	Polaris Communications
 116Bh	Connectware Inc
 116Ch	???
 116Dh	???
 116Eh	???
 116Fh	Workstation Technology
 1170h	Inventec Corporation
 1171h	Loughborough Sound Images
 1172h	Altera Corporation
 1173h	Adobe Systems
 1174h	Bridgeport Machines
 1175h	Mitron Computer Inc.
 1176h	SBE
 1177h	Silicon Engineering
 1178h	Alfa Inc (see #0760)
 1179h	Toshiba America Info Systems
 117Ah	A-Trend Technology
 117Bh	???
 117Ch	Atto Technology
 117Dh	???
 117Eh	T/R Systems
 117Fh	???
 1180h	Ricoh Co Ltd
 1181h	Telmatics International
 1182h	???
 1183h	Fujikura Ltd
 1184h	Forks Inc
 1185h	Dataworld
 1186h	D-Link System Inc
 1187h	Advanced Technology Laboratories
 1188h	Shima Seiki Manufacturing Ltd.
 1189h	Matsushita Electronics (see #0761)
 118Ah	Hilevel Technology
 118Bh	???
 118Ch	Corollary Inc (see #0762)
 118Dh	BitFlow Inc (see #0763)
 118Eh	Hermstedt GmbH
 118Fh	???
 1190h	???
 1191h	Artop Electric (see #0764)
 1192h	Densan Co. Ltd
 1193h	Zeitnet Inc. (see #0765)
 1194h	Toucan Technology
 1195h	Ratoc System Inc
 1196h	Hytec Electronics Ltd
 1197h	Gage Applied Sciences Inc.
 1198h	Lambda Systems Inc
 1199h	Digital Communications Associates Inc,
 119Ah	Mind Share Inc.
 119Bh	Omega Micro Inc.
 119Ch	Information Technology Inst.
 119Dh	Bug Sapporo Japan
 119Eh	Fujitsu
 119Fh	Bull Hn Information Systems
 11A0h	Convex Computer Corporation
 11A1h	Hamamatsu Photonics K.K.
 11A2h	Sierra Research and Technology
 11A4h	Barco
 11A5h	MicroUnity Systems Engineering, Inc.
 11A6h	Pure Data
 11A7h	Power Computing Corp.
 11A9h	InnoSys Inc. (see #0766)
 11AAh	Actel
 11ABh	Galileo Technology Ltd. (see #0767)
 11ACh	Canon Information Systems
 11ADh	Lite-On Communications Inc
 11AEh	Scitex Corporation Ltd
 11AFh	Pro-Log Corporation
 11B0h	V3 Semiconductor Inc. (see #0768)
 11B1h	Apricot Computers
 11B2h	Eastman Kodak
 11B3h	Barr Systems Inc.
 11B4h	Leitch Technology International
 11B5h	Radstone Technology Plc
 11B6h	United Video Corp
 11B7h	Motorola
 11B8h	Xpoint Technologies Inc
 11B9h	Pathlight Technology Inc. (see #0769)
 11BAh	Videotron Corp
 11BBh	Pyramid Technology
 11BCh	Network Peripherals Inc
 11BDh	Pinnacle Systems Inc.
 11BEh	International Microcircuits Inc
 11C3h	NEC Corporation
 11C4h	Document Technologies Ind.
 11C5h	Shiva Corporatin
 11C7h	D.C.M. Data Systems
 11C8h	Dolphin Interconnect Solutions (see #0770)
 11C9h	MAGMA
 11CAh	LSI Systems Inc
 11CBh	Specialix Research Ltd. (see #0771)
 11CCh	Michels & Kleberhoff Computer GmbH
 11CDh	HAL Computer Systems Inc.
 11DEh	Zoran Corporation
 11F8h	PMC-Sierra Inc. (see #0772)
 11FEh	RP ??? (see #0773)
 120Eh	Cyclades (see #0774)
 1220h	Ariel Corporation (see #0775)
 122Dh	Aztech Systems Ltd
 1239h	The 3DO Company
 124Dh	Stallion Technologies
 1254h	Linear Systems Ltd.
 125Ch	Aurora Technologies, Inc.
 1275h	Network Appliance
 127Ah	Rockwell Semiconductor Systems
 1296h	Kofax Image Products
 12C5h	Picture Elements, Inc. (see #0776)
 1C1Ch	Symphony (see #0777)
 1DE1h	TekRAM (see #0778)
 3D3Dh	3DLabs (see #0779)
 4005h	Avance Logic, Inc. (see #0780)
 4B10h	Buslogic Inc. (see #0781)
 5333h	S3 (see also #0782)
 5700h	Netpower
 6374h	c't Magazin fuer Computertechnik (see #0783)
 8008h	Quancom Electronic GmbH (see #0784)
 8086h	Intel (see also #0785)
 8800h	Trigem Computer (see #0786)
 8E0Eh	Computone Corporation
 9004h	Adaptec (see #0787)
 907Fh	Atronics (see #0788)
 EDD8h	Ark Logic Inc (see #0789)
SeeAlso: #0790

(Table 0650)
Values for Compaq PCI device code:
 0001h	EISA Bridge
 0002h	ISA Bridge
 1000h	Triflex/PCI CPU Bridge
 2000h	Triflex/PCI CPU Bridge
 3032h	QVision
 3033h	QVision 1280/p
 3034h	QVision 1280
 4000h	Triflex/PCI CPU Bridge
 F130h	ThunderLAN
SeeAlso: #0649

(Table 0651)
Values for Symbios Logic (formerly NCR) PCI device code:
 0001h	PCI revision ID:
	00-0Fh 53C810 (fast SCSI)
	10-1Fh 53C810A (fast SCSI)
	20-2Fh 53C810ALV (fast SCSI)
 0002h	53C820 (fast wide SCSI)
 0003h	PCI revision ID:
	00-0Fh 53C825 (fast wide SCSI)
	10-1Fh 53C825A (Ultra wide SCSI)
 0004h	53C815 (fast SCSI)
 0005h	53C810AP (fast SCSI)
 0006h	PCI revision ID:
	00-0Fh 53C860 (Ultra SCSI)
	10-1Fh 53C860LV (Ultra SCSI)
 000Fh	53C875 (Ultra wide SCSI)
SeeAlso: #0649

(Table 0652)
Values for ATI PCI device code:
 4158h	68800AX (Mach32)
 4354h	215CT222
 4358h	210888CX
 4758h	210888GX (Mach64)
SeeAlso: #0649

(Table 0653)
Values for VLSI Technologies PCI device code:
 0005h	82C592 CPU Bridge
 0006h	82C593 ISA Bridge
 0007h	82C594 Wildcat System Ctrlr
 0008h	VL82C597 Wildcat ISA Bridge
 0009h	82C597
 000Ch	82C541
 000Dh	82C543
 0101h	82C532
 0102h	82C534
 0104h	82C535
 0105h	82C147
 0200h	82C975 RISC GUI Accelerator
 0280h	82C925 RISC GUI Accelerator
SeeAlso: #0649

(Table 0654)
Values for Avance Logic, Inc. (Avance Logics) PCI device code:
 2301h	ALG2301 GUI accelerator
 2302h	ALG2302 GUI accelerator
SeeAlso: #0649,INT 10/AX=4F70h

(Table 0655)
Values for National Semiconductor PCI device code:
 0001h	DP83810 Ethernet
 D001h	NS87410 EIDE controller
SeeAlso: #0649

(Table 0656)
Values for Tseng Labs PCI device code:
 3202h	ET4000/W32p-2
 3205h	ET4000/W32p-B
 3206h	ET4000/W32p-C
 3207h	ET4000/W32p-D
 3208h	ET6000
SeeAlso: #0649

(Table 0657)
Values for Weitek PCI device code:
 9000h	Power9000???
 9001h	Power9001
 9100h	Power9100
SeeAlso: #0649

(Table 0658)
Values for DEC PCI device code:
 0001h	DC21050	DEC BRD PCI-PCI bridge
 0002h	DC21040	Tulip
 0009h	DC21140	Tulip Fast
 000Fh	DEFPA	FDDI
 0014h	DC21041	Tulip Plus
 0016h	DGLPB	ATM
 0019h	DC21143 PCI/Cardbus Ethernet
 0024h	21151	PCI-PCI Bridge
SeeAlso: #0649

(Table 0659)
Values for Cirrus Logic PCI device code:
 00A0h	Cirrus 5430
 00A4h	Cirrus 5434-4
 00A8h	Cirrus 5434-8
 00A8h	Cirrus 5434-8
 00ACh	Cirrus 5436
 00B8h	Cirrus GD5446
 1100h	Cirrus 6729
 1200h	Cirrus 7542
 1202h	Cirrus 7543
 1204h	Cirrus 7541
SeeAlso: #0649

(Table 0660)
Values for IBM PCI device code:
 0002h	MCA Bridge
 0005h	Alta Lite CPU Bridge
 0007h	Alta MP CPU Bridge
 000Ah	ISA Bridge
 0017h	CPU Bridge
 0018h	Auto LANStreamer
 001Bh	GXT-150P Graphics Adapter
 001Dh	82G2675
 0020h	MCA Bridge
 0022h	PCI-PCI Bridge
 0036h	Miami/PCI  32-bit LocalBus Bridge
 0047h	???
 0048h	???
 004Ah	???
 004Bh	???
 004Ch	???
 004Dh	???
 004Eh	???
 004Fh	???
 0050h	???
 0051h	???
 0052h	???
 0053h	???
 0055h	???
 0059h	???
 005Ah	???
 005Bh	???
SeeAlso: #0649

(Table 0661)
Values for Western Digital PCI device code:
 0193h	WD33C193A 8-bit SCSI
 0196h	SCSI Bridge
 0197h	WD33C197A 16-bit SCSI
 0296h	WD33C296A 16-bit SCSI
 3193h	WD7193 Fast SCSI-II
 3197h	WD7197 Fast-Wide SCSI-II
 3296h	WD7197
 4296h	WD33C296 Wide Fast-20 Bridge
 C24Ah	90C?
SeeAlso: #0649

(Table 0662)
Values for AMI PCI device code:
 9010h	MegaRAID
 9030h	??? IDE Controller
 9031h	??? IDE Controller
 9032h	??? IDE/SCSI Controller
 9033h	??? SCSI Controller
 9040h	??? Multimedia card
SeeAlso: #0649

(Table 0663)
Values for Advanced Micro Devices (AMD) PCI device code:
 2000h	Am79C970 (Lance), Am79C971 (PCnet-FAST, PCI revision ID is 2xh)
 2020h	Am53c974 SCSI
 2040h	Am79C974 Ethernet/SCSI
SeeAlso: #0649

(Table 0664)
Values for Trident PCI device code:
 9320h	??? 32-bit GUI accelerator
 9350h	??? 32-bit GUI accelerator
 9360h	??? Flat-Panel controller
 9420h	Trident 9420
 9440h	Trident 9440
 9460h	Trident 9460
 9660h	Trident 9660
 9682h	??? Multimedia accelerator
SeeAlso: #0649

(Table 0665)
Values for LSI Logic PCI device code:
 0000h	Hydra (Pentium chipset)
 0010h	Aspen (486 chipset)
SeeAlso: #0649

(Table 0666)
Values for Matrox PCI device code:
 0518h	MGA-II (Ultima)
 0519h	Millenium (2064W)
 0D10h	MGA-I (Impression)
SeeAlso: #0649

(Table 0667)
Values for Chips & Technologies PCI device code:
 00B8h	C&T 64310 GUI Accelerator
 00D0h	C&T 65545 Flat Panel/CRT VGA
 00D8h	F65545
 00DCh	F65548
SeeAlso: #0649

(Table 0668)
Values for Toshiba America PCI device code:
 0009h	r4x00 Bridge
SeeAlso: #0649

(Table 0669)
Values for Miro / Micro Computer Products AG PCI device code:
 5601h	36050
 5607h	video in/out w/ MPEG
SeeAlso: #0649

(Table 0670)
Values for NEC Corporation PCI device code:
 0001h	PCI-to-486 Bridge
 0002h	PCI-to-VL98 Bridge
 0003h	ATM LAN controller
 0004h	r4000PCI Bridge
 0005h	PCI-to-486 Bridge
 0006h	GUI Accelerator
 0007h	PCI-to-UXbus Bridge
 0008h	GUI Accelerator
 0009h	PC-98 Graphics Controller
SeeAlso: #0649

(Table 0671)
Values for Future Domain PCI device code:
 0000h	TMC-36C70 / TMC-18C30 (fast SCSI)
SeeAlso: #0649

(Table 0672)
Values for Silicon Integrated System (SIS) PCI device code:
 0001h	SiS6201
 0002h	SiS6202
 0006h	SI 85C501/2
 0008h	SI 85C503/5513
 0205h	SiS6205
 0406h	SiS501
 0496h	SiS496
 0596h	Pentium chipset
 0601h	SiS601
 3602h	IDE controller
 5401h	486 chipset
 5511h	SiS5511 Pentium chipset
 5513h	SiS5513 EIDE controller
 5581h	Pentium chipset
 5582h	ISA Bridge
 5596h	Pentium chipset
 6204h	video decoder/MPEG
 6205h	PCI VGA controller
SeeAlso: #0649

(Table 0673)
Values for Hewlett-Packard PCI device code:
 1030h	J2585A
 2910h	E2910A PCI-bus exerciser
 2925h	E2925A PCI-bus exerciser
SeeAlso: #0649

(Table 0674)
Values for PC Technology PCI device code:
 1000h	RZ1000
 1001h	RZ1001
SeeAlso: #0649

(Table 0675)
Values for Distributed Processing Technology (DPT) PCI device code:
 A400h	2124A/9X EATA SmartCache/RAID SCSI
SeeAlso: #0649

(Table 0676)
Values for OPTi PCI device code:
 C557h	82C557
 C558h	82C558
 C621h	82C621
 C822h	82C822
SeeAlso: #0649

(Table 0677)
Values for SGS Thomson Microelectronics PCI device code:
 0008h	SGS 2000
 0009h	SGS 1764
SeeAlso: #0649

(Table 0678)
Values for BusLogic PCI device code:
 0140h	MultiMaster NC
 1040h	MultiMaster
 8130h	FlashPoint
SeeAlso: #0649

(Table 0679)
Values for Texas Instruments PCI device code:
 0500h	100 Mbit LAN controller
 0508h	tms380c2x
 1000h	TI PCI Eagle i/f
 A001h	TDC1570	 64-bit ATM sar
 A100h	TDC1561	 32-bit ATM sar
 AC10h	PCI1050	 PCCard controller
 AC11h	PCI1053	 PCCard controller
 AC12h	PCI1130	 PCCard controller
SeeAlso: #0649

(Table 0680)
Values for Oak Technology PCI device code:
 0107h	OTI-0107 (Spitfire)
SeeAlso: #0649

(Table 0681)
Values for Winbond PCI device code:
 0000h	??? Ethernet controller
 0001h	83769
 0105h	82C105
SeeAlso: #0649

(Table 0682)
Values for Hitachi Ltd. PCI device code:
 0001h	PCI Bridge
 0002h	PCI-bus controller
SeeAlso: #0649

(Table 0683)
Values for EFAR Microsystems PCI device code:
 0810h	486 Bridge
 0922h	Pentium/P54C Bridge
 0926h	ISA Bridge
SeeAlso: #0649

(Table 0684)
Values for Motorola PCI device code:
 0001h	MPC105 PowerPC chipset
SeeAlso: #0649

(Table 0685)
Values for Promise Technology PCI device code:
 5300h	Promise 5300
SeeAlso: #0649

(Table 0686)
Values for Number 9 Computer Company PCI device code:
 2309h	Imagine 128
 2339h	Imagine 128-2
SeeAlso: #0649

(Table 0687)
Values for United Microelectronics (UMC) PCI device code:
 0001h	UM82C881 (486 chipset)
 0002h	UM82C776 (ISA Bridge)
 0101h	UM8673F
 0881h	UM8881 (486 chipset)
 0886h	UM8886F (ISA Bridge)
 0891h	UM8891A
 1001h	UM886A (dual IDE controller)
 673Ah	UM8886BF
 8710h	UM8710 VGA controller
 886Ah	UM8886A
 8881h	UM8881F
 8886h	UM8886F
 8891h	UM8891 (Pentium chipset)
 9017h	UM9017F
 E881h	UM8881 (486 chipset)
 E886h	UM8886N
 E891h	UM8891N
SeeAlso: #0649

(Table 0688)
Values for 8x8 (X Tech) PCI device code:
 0001h	AGX-016
 0002h	IIT3204/3501 MPEG decoder
SeeAlso: #0649

(Table 0689)
Values for PicoPower PCI device code:
 0000h	PT80C826 VL Bridge
SeeAlso: #0649

(Table 0690)
Values for Mylex Corporation PCI device code:
 0001h	DAC960P Wide SCSI + RAID
SeeAlso: #0649

(Table 0691)
Values for Yamaha Corporation PCI device code:
 0001h	?? 3D graphics controller
 0002h	YGV615	RPA3 3D graphics controller
SeeAlso: #0649

(Table 0692)
Values for NexGen Microsystems PCI device code:
 4E78h	NexGen 82C501
SeeAlso: #0649

(Table 0693)
Values for Q Logic PCI device code:
 1020h	ISP1020 Fast-Wide SCSI
 1022h	ISP1022 Fast-Wide SCSI
SeeAlso: #0649

(Table 0694)
Values for Leadtek Research PCI device code:
 0000h	LeadTek 805
SeeAlso: #0649

(Table 0695)
Values for Interphase PCI device code:
 0001h	ATM interface
 0002h	100 vg amylan controller
SeeAlso: #0649

(Table 0696)
Values for Data Technology Corporation (DTC) PCI device code:
 0802h	SL82C105  EIDE Controller
SeeAlso: #0649

(Table 0697)
Values for Contaq Microsystems PCI device code:
 0600h	Contaq 82C599
SeeAlso: #0649

(Table 0698)
Values for Forex Computer Corporation PCI device code:
 0001h	FR710  EIDE Controller
 0613h	??? Host Bridge
SeeAlso: #0649

(Table 0699)
Values for Bit3 Computer PCI device code:
 0001h	Model 617  PCI-VME Bus Adapter
SeeAlso: #0649

(Table 0700)
Values for Olicom PCI device code:
 0001h	??? Ethernet Controller
SeeAlso: #0649

(Table 0701)
Values for Intergraph Corporation PCI device code:
 0020h	3D graphics processor
 0021h	3D graphics processor w/texture
 0040h	3D graphics frame buffer
 0041h	3D graphics frame buffer
 0060h	proprietary bus bridge
 0720h	Motion JPEG codec
SeeAlso: #0649

(Table 0702)
Values for National Instruments PCI device code:
 C801h	PCI-GPIB
SeeAlso: #0649

(Table 0703)
Values for CMD Technology, Inc. PCI device code:
 0640h	CMD 640
 0642h	IDE controller with RAID-1
 0646h	CMD 646 EIDE
 0650h	PBC0650A Fast SCSI-II
SeeAlso: #0649

(Table 0704)
Values for Appian Technology:
 0038h	??? EIDE Controller
SeeAlso: #0649

(Table 0705)
Values for Vision / Quantum Designs Ltd. PCI device code:
 0001h	QD8500
 0002h	QD8580
SeeAlso: #0649

(Table 0706)
Values for Brooktree Corporation PCI device code:
 0350h	BT848  TV/PCI with DMA Push
 2115h	BtV 2115 Mediastream Controller
 2125h	BtV 2125 Mediastream Controller
 8230h	???
SeeAlso: #0649

(Table 0707)
Values for Sierra Semiconductor PCI device code:
 0000h	STB 64-bit GUI accelerator
SeeAlso: #0649

(Table 0708)
Values for ACC Microelectronics PCI device code:
 0000h	ACC 2056
SeeAlso: #0649

(Table 0709)
Values for Symphony Labs PCI device code:
 0001h	83769
 0103h	sl82c103 PCI-IDE Controller
 0105h	82C105 bus-master PCI-IDE controller
SeeAlso: #0649

(Table 0710)
Values for PLX Technology PCI device code:
 9036h	PCI9036 interface chip
 9060h	PCI9060xx interface chip
SeeAlso: #0649

(Table 0711)
Values for Madge Networks PCI device code:
 0001h	Smart 16/4 Ringnode
 1000h	Collage 25 ATM adapter
 1001h	Collage 155 ATM adapter
SeeAlso: #0649

(Table 0712)
Values for 3com Corporation PCI device code:
 5900h	3C590
 5950h	3C595TX
 5951h	3C595T4
 5952h	3C595MII
 8811h	token ring
 9000h	3C900-TPO Fast Etherlink
 9001h	3C900-COMBO Fast Etherlink
 9050h	3C905-TX Fast Etherlink 10/100
SeeAlso: #0649

(Table 0713)
Values for Standard Microsystems Corporation (SMC) PCI device code:
 1000h	37C665 floppy disk controller
 1001h	37C922 floppy disk controller
SeeAlso: #0649

(Table 0714)
Values for Acer Labs Inc. PCI device code:
 1435h	M1435 VL Bridge
 1445h	ALI M1445 VL bridge + EIDE
 1449h	ALI M1449 ISA bridge
 1451h	ALI M1451 Pentium chipset
 1461h	ALI M1461 P54C chipset
 1489h	ALI M1489
 1511h	ALI M1511
 1513h	ALI M1513
 3141h	M3141 GUI accelerator VRAM
 3143h	M3143 GUI accelerator VRAM/DAC
 3145h	M3145 GUI accelerator VRAM
 3147h	M3147 GUI accelerator VRAM/DAC
 3149h	M3149 GUI accelerator VRAM
 3151h	M3151 GUI accelerator VRAM
 5212h	M4803
 5215h	ALI MS4803 EIDE controller
 5217h	m5217 I/O
 5219h	m5219 I/O
 5235h	m5225 I/O
SeeAlso: #0649

(Table 0715)
Values for Surecom Technology PCI device code:
 5240h	IDE Controller
 5241h	PCMCIA Bridge
 5242h	general-purpose controller
 5243h	Bus controller
 5244h	Floppy-disk controller
SeeAlso: #0649

(Table 0716)
Values for Neomagic Corporation:
 0000h	graphics controller
SeeAlso: #0649

(Table 0717)
Values for Advanced System Products PCI device code:
 1100h	ABP940 revision A??? SCSI
 1200h	ABP940 revision B??? Fast SCSI-2
 1300h	Fast-Wide SCSI controller
SeeAlso: #0649

(Table 0718)
Values for Citicorp TTI PCI device code:
 2001h	mb86605 Wide SCSI-2
SeeAlso: #0649

(Table 0719)
Values for CENR/ECP/EDU PCI device code:
 0001h	SPSB PMC
 0002h	SPSB PCI
 10DCh	ATT 2C15-3 FPGA
SeeAlso: #0649

(Table 0720)
Values for Evans & Sutherland PCI device code:
 0001h	3D graphics processor
SeeAlso: #0649

(Table 0721)
Values for Emulex Corporation PCI device code:
 1AE5h	Fibre Channel Host Adapter
SeeAlso: #0649

(Table 0722)
Values for Integrated Micro Solutions PCI device code:
 5026h	IMS5026/27/28 VL Bridge
 5028h	ISA Bridge
 8849h	IMS 8849
 8853h	ATM network card
 9128h	IMS9129 GUI accelerator
SeeAlso: #0649

(Table 0723)
Values for TekRAM Technology Corporation Ltd. PCI device code:
 690Ch	TekRAM 690c
SeeAlso: #0649

(Table 0724)
Values for Newbridge Microsystems PCI device code:
 0000h	CA91C042 VMEbus Bridge
SeeAlso: #0649

(Table 0725)
Values for Applied Micro Circuits Corp. PCI device code:
 4750h	S5933 PCI controller
 8043h	MyriNet
SeeAlso: #0649

(Table 0726)
Values for Integraphics Systems PCI device code:
 1680h	1680
SeeAlso: #0649

(Table 0727)
Values for Artist Graphics PCI device code:
 0101h	3GA 64-bit graphics processor
SeeAlso: #0649

(Table 0728)
Values for Realtek Semiconductor PCI device code:
 8029h	Realtek 8029
SeeAlso: #0649

(Table 0729)
Values for ASCII Corporation PCI device code:
 7310h	V7310 VGA Video Overlay
SeeAlso: #0649

(Table 0730)
Values for NKK Corporation PCI device code:
 A001h	NDR4000	  NR4600 Bridge
SeeAlso: #0649

(Table 0731)
Values for Truevision PCI device code:
 0000h	??? GUI Accelerator
 0001h	??? GUI Accelerator
 0002h	??? GUI Accelerator
 0003h	??? GUI Accelerator
 0004h	??? GUI Accelerator
 0005h	??? GUI Accelerator
 0006h	??? GUI Accelerator
 0007h	??? GUI Accelerator
 0008h	??? GUI Accelerator
 0009h	??? GUI Accelerator
 0010h	??? GUI Accelerator
 0011h	??? GUI Accelerator
 0012h	??? GUI Accelerator
 0013h	??? GUI Accelerator
 0014h	??? GUI Accelerator
 0015h	??? GUI Accelerator
SeeAlso: #0649

(Table 0732)
Values for Initio Corporation PCI device code:
 9100h	320P
 9400h	Fast-Wide SCSI
 9700h	Fast-Wide SCSI
SeeAlso: #0649

(Table 0733)
Values for VIA Technologies PCI device code:
 0505h	VIA 82C505
 0561h	VIA 82C561
 0576h	VIA 82C576
 1000h	82C570MV P54 Controller
 1106h	82C570MV ISA Bridge + IDE
 1571h	VIA 82C416
SeeAlso: #0649

(Table 0734)
Values for Proteon Inc. PCI device code:
 0100h	p1690plus-AA  Token Ring
 0101h	p1690plus-AB 2-port Token Ring
SeeAlso: #0649

(Table 0735)
Values for Cogent Data Technologies PCI device code:
 1400h	EM110TX PCI Fast Ethernet
SeeAlso: #0649

(Table 0736)
Values for Siemens Nixdorf PCI device code:
 6120h	SZB6120 Multimedia Adapter
SeeAlso: #0649

(Table 0737)
Values for Rockwell PCI device code:
 2200h	FDDI adapter
 2300h	Fast Ethernet adapter
 2340h	four-port Fast Ethernet
 2400h	ATM adapter
SeeAlso: #0649

(Table 0738)
Values for Datacube Inc. PCI device code:
 9500h	MAX-LC SuperVGA
 9501h	MAX-LC image processing
SeeAlso: #0649

(Table 0739)
Values for Vortex Computersysteme GmbH PCI device code:
 0000h	GDT60x0 SCSI RAID
 0001h	GDT6000B SCSI RAID
 0002h	GDT6x10 SCSI RAID
 0003h	GDT6x20 two-channel SCSI RAID
 0004h	GDT6530 three-channel SCSI RAID
 0005h	GDT6550 five-channel SCSI RAID
 0006h	GDT6x17
 0007h	GDT6x27
 0008h	GDT6537
 0009h	GDT6557
 000Ah	GDT6x15
 000Bh	GDT6x25
 000Ch	GDT6535
 000Dh	GDT6555
SeeAlso: #0649

(Table 0740)
Values for Efficient Networks, Inc. PCI device code:
 0000h	155P-MF1 ATM FPGA
 0002h	ATM ASIC
SeeAlso: #0649

(Table 0741)
Values for FORE Systems PCI device code:
 0210h	PCA200PC
 0300h	PCA200E
SeeAlso: #0649

(Table 0742)
Values for Infomedia MicroElectronics PCI device code:
 0000h	EIDE/HD and IDE/CD-ROM controller
 000Bh	EIDE/HD and IDE/CD-ROM controller
SeeAlso: #0649

(Table 0743)
Values for Imaging Technology PCI device code:
 0000h	ICPCI
 0001h	video frame grabber/processor
SeeAlso: #0649

(Table 0744)
Values for Mercury Computer Systems PCI device code:
 0001h	Raceway Bridge
SeeAlso: #0649

(Table 0745)
Values for Fuji Xerox Co Ltd. PCI device code:
 0001h	Printer Controller
SeeAlso: #0649

(Table 0746)
Values for Ziatech Corporation PCI device code:
 8905h	8905 STD-32 Bridge
SeeAlso: #0649

(Table 0747)
Values for Dynamic Pictures Inc. PCI device code:
 0001h	VGA-compatible 3D graphics
SeeAlso: #0649

(Table 0748)
Values for Cyclone Microsystems (PLX Technology???) PCI device code:
 0001h	PLX 9060
 0911h	PCI 911	 i960Jx Intelligent I/O
 0912h	PCI 912	 i960Cx Intelligent I/O
 0913h	PCI 913	 i960Hx Intelligent I/O
SeeAlso: #0649

(Table 0749)
Values for Crest Microsystem PCI device code:
 0001h	EIDE/ATAPI super adapter
SeeAlso: #0649

(Table 0750)
Values for Alliance Semiconductor Corp. PCI device code:
 3210h	Pro Motion 3210
 6410h	GUI Accelerator
 6412h	GUI Accelerator
 6420h	GUI Accelerator
 6422h	Pro Video
 6424h	GUI Accelerator
 6426h	GUI Accelerator
SeeAlso: #0649

(Table 0751)
Values for Cincinnati Milacron PCI device code:
 0001h	Noservo Controller
SeeAlso: #0649

(Table 0752)
Values for Schneider & Koch Co. PCI device code:
 4000h	FDDI adapter
SeeAlso: #0649

(Table 0753)
Values for VMIC PCI device code:
 7587h	VME
SeeAlso: #0649

(Table 0754)
Values for Digi International / Stargate PCI device code:
 0003h	RightSwitch
SeeAlso: #0649

(Table 0755)
Values for Voarx R&D Inc. PCI device code:
 3011h	Tokenet/vg 1001/10m anylan
 9050h	Lanfleet/Truevalue
SeeAlso: #0649

(Table 0756)
Values for MuTech PCI device code:
 0001h	MV1000
SeeAlso: #0649

(Table 0757)
Values for PFU Ltd. PCI device code:
 0001h	Host Bridge
SeeAlso: #0649

(Table 0758)
Values for Creative Labs (vendor ID 1163h) PCI device code:
 0001h	3D Blaster
SeeAlso: #0649

(Table 0759)
Values for Imagraph Corporation PCI device code:
 0001h	Motion JPEG record/play w/ audio
SeeAlso: #0649

(Table 0760)
Values for Alfa Inc. PCI device code:
 AFA1h	Fast Ethernet
SeeAlso: #0649

(Table 0761)
Values for Matsushita Electronics PCI device code:
 1592h	???
SeeAlso: #0649

(Table 0762)
Values for Corollary Inc. PCI device code:
 0014h	PCIB  C-bus II to PCI bridge chip
SeeAlso: #0649

(Table 0763)
Values for BitFlow Inc. PCI device code:
 0001h	Raptor-PCI frame grabber
SeeAlso: #0649

(Table 0764)
Values for Artop Electric PCI device code:
 0001h	IDE controller
 0002h	IDE controller
 0003h	SCSI-2 cache controller
 0004h	ATP8400 ASIC cache accelerator
 8001h	SCSI-2 cache controller
 8002h	SCSI-2 controller
SeeAlso: #0649

(Table 0765)
Values for Zeitnet Inc. PCI device code:
 0001h	Zeitnet 1221
 0002h	Zeitnet 1225
SeeAlso: #0649

(Table 0766)
Values for InnoSys Inc. PCI device code:
 4240h	AMCC S5933Q Intelligent Serial Card
SeeAlso: #0649

(Table 0767)
Values for Galileo Technology PCI device code:
 0146h	GT-64010 System Controller for R46xx CPU
 4801h	GT-48001 8-port switched Ethernet ctrlr
SeeAlso: #0649

(Table 0768)
Values for V3 Semiconductor Inc. PCI device code:
 0292h	V292PBC	 Am29030/40 Bridge
 0960h	V96xPBC	 i960 Bridge
 C960h	V96DPC	 i960 dual PCI Bridge
SeeAlso: #0649

(Table 0769)
Values for Pathlight Technology PCI device code:
 C0EDh	SSA Controller
SeeAlso: #0649

(Table 0770)
Values for Dolphin Interconnect Solutions PCI device code:
 0658h	PSB  PCI-SCI Bridge
SeeAlso: #0649

(Table 0771)
Values for Specialix Research Ltd. PCI device code:
 2000h	PCI-9050 Target Interface
 4000h	Specialix XIO (SUPI-1 Target Interface)
 8000h	Specialix RIO (T255 Bridge)
SeeAlso: #0649

(Table 0772)
Values for PMC-Sierra Inc. PCI device code:
 7375h	PM7375 LASAR-155 ATM SAR
SeeAlso: #0649

(Table 0773)
Values for RP PCI device code:
 0001h	RP8OCTA
 0002h	RP8INTF
 0003h	RP16INTF
 0004h	RP32INTF
SeeAlso: #0649

(Table 0774)
Values for Cyclades PCI device code:
 0100h	Cyclom Y Lo multiport serial card
 0101h	Cyclom Y Hi
 0200h	Cyclom Z Lo multiport serial card
 0201h	Cyclom Z Hi
SeeAlso: #0649

(Table 0775)
Values for Ariel Corporation PCI device code:
 1220h	AMCC 5933  TMS320C80 DSP/Imaging Board
SeeAlso: #0649

(Table 0776)
Values for Picture Elements PCI device code:
 0081h	PCIVST	PCI Thresholding Engine
SeeAlso: #0649

(Table 0777)
Values for Symphony PCI device code:
 0001h	Symphony 82C101 IDE controller
SeeAlso: #0649

(Table 0778)
Values for TekRAM PCI device code:
 DC29h	DC290 / DC290M EIDE controller
SeeAlso: #0649

(Table 0779)
Values for 3DLabs PCI device code:
 0004h	3C0SX GUI Accelerator
SeeAlso: #0649

(Table 0780)
Values for Avance Logic, Inc. PCI device code:
 2301h	AVL2301 GUI Accelerator
 2303h	AVG2302 GUI Accelerator
SeeAlso: #0649

(Table 0781)
Values for BusLogic Inc. PCI device code:
 3080h	??? SCSI-ti
 4010h	??? Fast-Wide SCSI-2
SeeAlso: #0649

(Table 0782)
Values for S3 PCI device code:
 5631h	86C325 ViRGE 3D GUI Accelerator
 8800h	Vision 866
 8801h	Vision 964
 8810h	S3 Trio32
 8811h	S3 Trio32, Trio64, or Trio64V+
 8812h	S3 Trio64UV+
 8813h	S3 Trio64? v3
 888xh	S3 868
 88Bxh	S3 928
 88C0h	S3 864-1
 88C1h	S3 864-2
 88C2h	S3 864-3
 88C3h	S3 864-4
 88D0h	S3 964-1
 88D1h	S3 964-2
 88D2h	S3 964-3
 88D3h	S3 964-4
 88F0h	S3 968
 88F1h	S3 968-2
 88F2h	S3 968-3
 88F3h	S3 968-3
SeeAlso: #0649,#0785

(Table 0783)
Values for c't Magazin fÅr Computer PCI device code:
 6773h	GPPCI  PCI interface
SeeAlso: #0649

(Table 0784)
Values for Quancom Electronic PCI device code:
 0010h	PCI-WDOG1 Watchdog
 0011h	PWDOG2 Watchdog2/PCI
SeeAlso: #0649

(Table 0785)
Values for Intel PCI device code:
 0482h	82375 EISA
 0483h	82424 Cache Controller
 0484h	82378/82379 Bus Interface (Mercury/Saturn/Neptune chipsets) (see #0817)
 0486h	82425EX/82430
 04A3h	82434 (Neptune) (see #0815)
 0960h	i960 RP Microprocessor/Bridge
 1221h	82092AA PCMCIA Bridge
 1222h	82092AA IDE Controller
 1223h	Intel SAA7116
 1226h	82596
 1227h	82865
 1228h	EtherExpress Pro/100 Smart
 1229h	82557 Fast Ethernet
 122Dh	82437FX (Triton)
 122Eh	82371FB ISA Bridge (Triton)
 1230h	82338 IDE controller / 82371FB IDE function (Triton)
 1234h	82371MX
 1235h	82437MX
 1237h	82441FX (see #0879)
 1239h	82371FB IDE Interface (Triton)
 1250h	82439HX (430HX chipset) (see #0843)
 1960h	80960RP i960RP Microprocessor
 7000h	82371SB ISA Bridge (see #0865)
 7010h	82371SB IDE controller (see #0866)
 7020h	82371SB (see #0867)
 7030h	82437VX (430VX chipset) (see #0846)
 84C4h	82450KX/GX PCI Bridge (Orion)
 84C5h	82450KX/GX Memory Ctrlr (Orion)
SeeAlso: #0649,#0782

(Table 0786)
Values for Trigem Computer PCI device code:
 2008h	video assistant
SeeAlso: #0649

(Table 0787)
Values for Adaptec PCI device code:
 1078h	AIC-7810C RAID Coprocessor
 5078h	x940 Fast-Wide SCSI-II Ctrlr
 5578h	AHA-2830P SCSI Controller
 7078h	AHA-294x/AIC-7870P Fast-Wide SCSI-II
 7178h	AHA-2940 Fast-Wide SCSI-II
 7278h	x940 two-channel Fast-Wide SCSI
 7378h	AHA-3985 4-channel RAID SCSI
 7478h	AHA-2944 SCSI
 7810h	AIC-7810 memory control IC
 7850h	AIC-7850 SCSI IC
 7855h	AHA-2930 SCSI
 7870h	AIC-7870 SCSI IC
 7871h	AHA-2940
 7872h	AHA-3940
 7873h	AHA-3980
 7874h	AHA-2944 Differential SCSI
 7880h	AIC-7880 Fast-20 SCSI
 8078h	Adaptec 7880
 8178h	Adaptec 7881
 8278h	AHA-3940U/UW
 8378h	Adaptec 7883
 8478h	Adaptec 7884
SeeAlso: #0649

(Table 0788)
Values for Atronics PCI device code:
 2015h	Atronics 2015
SeeAlso: #0649

(Table 0789)
Values for Ark Logic Inc. PCI device code:
 A091h	ARK 1000PV ??? Stingray
 A099h	ARK 2000PV ??? Stingray
 A0A1h	ark2000mt 64-bit GUI Accel w/DCI
SeeAlso: #0649
--------X-1AB103-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - FIND PCI CLASS CODE
	AX = B103h
	ECX = class code (see also #F059,#0790)
	    bits 31-24 unused
	    bits 23-16 class
	    bits 15-8  subclass
	    bits 7-0   programming interface
	SI = device index (0-n)
Return: CF clear if successful
	CF set on error
	AH = status (00h,86h) (see #0646)
	    00h successful
		BH = bus number
		BL = device/function number (bits 7-3 device, bits 2-0 func)
	    86h device not found
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on return were exchanged between the initial
	  drafts of the specification and final implementation
	all devices sharing the same Class Code may be enumerated by
	  incrementing SI from 0 until error 86h is returned
SeeAlso: AX=B183h
--------X-1AB106-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - PCI BUS-SPECIFIC OPERATIONS
	AX = B106h
	BL = bus number
	EDX = Special Cycle data
Return: CF clear if successful
	CF set on error
	AH = status (00h,81h) (see #0646)
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Note:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
SeeAlso: AX=B186h,INT 2F/AX=1684h/BX=304Ch
--------X-1AB108-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - READ CONFIGURATION BYTE
	AX = B108h
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	BH = bus number
	DI = register number (0000h-00FFh) (see #0790)
Return: CF clear if successful
	    CL = byte read
	CF set on error
	AH = status (00h,87h) (see #0646)
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B109h,AX=B10Ah,AX=B188h,INT 2F/AX=1684h/BX=304Ch
--------X-1AB109-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - READ CONFIGURATION WORD
	AX = B109h
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	BH = bus number
	DI = register number (0000h-00FFh) (see #0790)
Return: CF clear if successful
	    CX = word read
	CF set on error
	AH = status (00h,87h) (see #0646)
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B108h,AX=B10Ah,AX=B189h,INT 2F/AX=1684h/BX=304Ch
--------X-1AB10A-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - READ CONFIGURATION DWORD
	AX = B10Ah
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh) (see #0790)
Return: CF clear if successful
	    ECX = dword read
	CF set on error
	AH = status (00h,87h) (see #0646)
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B108h,AX=B109h,AX=B18Ah,INT 2F/AX=1684h/BX=304Ch

Format of PCI Configuration Data:
Offset	Size	Description	(Table 0790)
 00h	WORD	vendor ID (read-only) (see #0649 at AX=B102h)
		FFFFh returned if requested device non-existent
 02h	WORD	device ID (read-only)
 04h	WORD	command register (see #0791)
 06h	WORD	status register (see #0792)
 08h	BYTE	revision ID
 09h  3 BYTEs	class code
		bits 7-0: programming interface
		bits 15-8: sub-class
		bits 23-16: class code (see also #F059)
 0Ch	BYTE	cache line size
 0Dh	BYTE	latency timer
 0Eh	BYTE	header type
		bits 6-0: header format
			00h other
			01h PCI-to-PCI bridge
			02h PCI-to-CardBus bridge
		bit 7: multi-function device
 0Fh	BYTE	Built-In Self-Test result (see #0793)
---header type 00h---
 10h	DWORD	base address 0 (see #0794)
		(OpenHCI) base address of host controller registers (see #0891)
 14h	DWORD	base address 1
 18h	DWORD	base address 2
 1Ch	DWORD	base address 3
 20h	DWORD	base address 4
 24h	DWORD	base address 5
 28h	DWORD	CardBus CIS pointer (read-only) (see #0801)
 2Ch	WORD	subsystem vendor ID or 0000h
 2Eh	WORD	subsystem ID or 0000h
 30h	DWORD	expansion ROM base address (see #0795)
 34h	BYTE	offset of capabilities list within configuration space (R/O)
		(only valid if status register bit 4 set) (see #0796)
 35h  3 BYTEs	reserved
 38h	DWORD	reserved
 3Ch	BYTE	interrupt line
		00h = none, 01h = IRQ1 to 0Fh = IRQ15
 3Dh	BYTE	interrupt pin (read-only)
		(00h = none, else indicates INTA# to INTD#)
 3Eh	BYTE	minimum time bus master needs PCI bus ownership, in 250ns units
		(read-only)
 3Fh	BYTE	maximum latency, in 250ns units (bus masters only) (read-only)
 40h 48 DWORDs	varies by device (see #0813,#0814,#0815,#0836)
---header type 01h---
 10h	DWORD	base address 0 (see #0794)
 14h	DWORD	base address 1
 18h	BYTE	primary bus number (for bus closer to host processor)
 19h	BYTE	secondary bus number (for bus further from host processor)
 1Ah	BYTE	subordinate bus number
 1Bh	BYTE	secondary latency timer
 1Ch	BYTE	I/O base (see #0811)
 1Dh	BYTE	I/O limit (see #0811)
 1Eh	WORD	secondary status
 20h	WORD	memory base (see #0812)
 22h	WORD	memory limit
 24h	WORD	prefetchable memory base
 26h	WORD	prefetchable memory limit
 28h	DWORD	prefetchable base, upper 32 bits
 2Ch	DWORD	prefetchable limit, upper 32 bits
 30h	WORD	I/O base, upper 16 bits
 32h	WORD	I/O limit, upper 16 bits
 34h	DWORD	reserved
 38h	DWORD	expansion ROM base address
 3Ch	BYTE	interrupt line
 3Dh	BYTE	interrupt pin (read-only)
 3Eh	WORD	bridge control
 40h 48 DWORDs	varies by device (see #0813,#0814,#0815,#0836)
---header type 02h---
 10h	DWORD	CardBus Socket/ExCa base address (see #0802)
		bits 31-12: start address of socket interface register block
			  in 4K blocks
		bits 11-0: reserved (0)
 14h	BYTE	offset of capabilities list within configuration space (R/O)
		(only valid if status register bit 4 set) (see #0796)
 15h	BYTE	reserved
 16h	WORD	secondary status
 18h	BYTE	PCI bus number
 19h	BYTE	CardBus bus number
 1Ah	BYTE	subordinate bus number
 1Bh	BYTE	CardBus latency timer
 1Ch	DWORD	memory base address 0
 20h	DWORD	memory limit 0
 24h	DWORD	memory base address 1
 28h	DWORD	memory limit 1
 2Ch	WORD	I/O base address 0
 2Eh	WORD	I/O base address 0 high word (optional)
 30h	WORD	I/O limit 0
 32h	WORD	I/O limit 0 high word (optional)
 34h	WORD	I/O base address 1
 36h	WORD	I/O base address 1 high word (optional)
 38h	WORD	I/O limit 1
 3Ah	WORD	I/O limit 1 high word (optional)
 3Ch	BYTE	interrupt line
 3Dh	BYTE	interrupt pin (read-only) (no interrupt used if 00h)
 3Eh	WORD	bridge control
 40h	WORD	subsystem vendor ID
 42h	WORD	subsystem device ID
 44h	DWORD	16-bit PC Card legacy mode base address (for accessing ExCa
		  registers)
 48h 14 DWORDs	reserved
 80h 32 DWORDs	varies by device (see #0813,#0814,#0815,#0836)

Bitfields for PCI Configuration Command Register:
Bit(s)	Description	(Table 0791)
 0	I/O access enabled
 1	memory access enabled
 2	bus master enable
 3	special cycle recognition enabled
 4	memory write and invalidate enabled
 5	VGA palette snoop enabled
 6	parity error response enabled
 7	wait cycles enabled
 8	system error (SERR# line) enabled
 9	fast back-to-back transactions enabled
 15-10	reserved
SeeAlso: #0790,#0792

Format of PCI Configuration Status Register:
Bit(s)	Description	(Table 0792)
 3-0	reserved (0)
 4	new capabilities list is present (first entry pointed at by byte at
	  34h or 14h)
 5	capable of running at 66 MHz
 6	UDF supported
 7	capable of fast back-to-back transactions
 8	data parity error reported
 10-9	device select timing
	00 fast
	01 medium
	10 slow
	11 reserved
 11	signaled target abort
 12	received target abort
 13	received master abort
 14	signaled system error (device is asserting SERR# line)
 15	detected parity error (set even if parity error reporting is disabled)
Note:	bits 12, 13 and 15 are cleared by writing a 1 into the corresponding
	  bit
SeeAlso: #0790,#0791

Bitfields for PCI Configuration Built-In Self-Test register:
Bit(s)	Description	(Table 0793)
 3-0	completion code (0000 = successful)
 5-4	reserved
 6	start BIST (set to one to start, cleared automatically on completion)
 7	BIST-capable
Notes:	this register is hardwired to 00h if no BIST capability
	software should timeout the BIST after two seconds
SeeAlso: #0790

Bitfields for PCI Configuration Base Address:
Bit(s)	Description	(Table 0794)
 0	address type (0 = memory space, 1 = I/O space)
---memory address---
 2-1	address type
	00 anywhere in first 4GB
	01 below 1MB
	10 anywhere in 64-bit address space
	11 reserved
 3	prefetchable
 31-4	bits 31-4 of base memory address if addressable in first 1MB or 4GB
 63-4	bits 63-4 of base memory address if addressable in 64-bit memory
	(bits 63-32 are stored in the following base address DWORD)
---I/O address---
 1	reserved
 31-2	bits 31-2 of base I/O port
SeeAlso: #0790,#0891

Bitfields for PCI Configuration Expansion ROM Address:
Bit(s)	Description	(Table 0795)
 0	address decode enable (ROM address is valid)
 10-1	reserved
 31-11	bits 31-11 of ROM's starting physical address
SeeAlso: #0790

Format of PCI Capabilities List:
Offset	Size	Description	(Table 0796)
 00h	BYTE	capability identifier
		01h PCI Power Managment
 01h	BYTE	offset of next item (within configuration space) or 00h
      N	BYTEs	varies by capability type
---PCI Power Management---
 02h	WORD	power managment capabilities (see #0797) (read-only)
 04h	WORD	power managment capabilities status register (see #0798)
 06h	BYTE	PMCSR bridge support extensions (see #0799)
 07h	BYTE	(optional) read-only data register (see #0800)
Note:	this information is from the v0.93 draft of the specification and is
	  subject to change
SeeAlso: #0790,#0792

Bitfields for PCI Power Management Capabilities:
Bit(s)	Description	(Table 0797)
 15	reserved (0)
 14-12	PME# support
	bit 12: PME# can be asserted from power state D0
	bit 13: PME# can be asserted from power state D1
	bit 14: PME# can be asserted from power state D2
 11	reserved (0)
 10	D2 power state supported
 9	D1 power state supported
 8	full-speed clock is required in state D0 for proper operation
	(if clear, device may be run at reduced clock except when actually
	  being accessed)
 7-6	dynamic clock control support
	00 not bridge, no dynamic clock control, or secondary bus' clock is
	      is tied to primary bus' clock
	01 bridge is capable of dynamic clock control
	10 reserved
	11 secondary bus has independent clock, but dynamic clock not supported
 5	device-specific initialization is required
 4-3	reserved (0)
 2-0	specification version
	001 = v1.0; four bytes of power management registers
Note:	this information is from the v0.93 draft of the specification and is
	  subject to change
SeeAlso: #0796,#0798,#0799

Bitfields for PCI Power Management Capabilities Status Register:
Bit(s)	Description	(Table 0798)
 15	PME status: if set, PME# is (or would be) asserted
	writing a 1 to this bit clears it
 14-13	(read-only) scale factor to apply to contents of Data register
	00 unknown (or unimplemented data)
	01 x0.1
	10 x0.01
	11 x0.001
 12-9	(read-write) data select (see #0800)
 8	(read-write) enable PME# assertion
 7-5	reserved (0)
 4	(read-write) enable dynamic data reporting
	when set, PME# is asserted whenever the value in the Data register
	  changes significantly
 3-2	reserved (0)
 1-0	(read-write) current power state
	00 = D0
	...
	11 = D3
Note:	this information is from the v0.93 draft of the specification and is
	  subject to change
SeeAlso: #0796,#0797,#0799

Bitfields for PCI Power Management PMCSR bridge support extension:
Bit(s)	Description	(Table 0799)
 7	(read-only) Bus Power Control Enable
 6	(read-only) Bus Power State B3 supported
 5	(read-only) Bus Power State B2 supported
 4	dynamic clock control enable
 3-0	reserved (0)
Note:	this information is from the v0.93 draft of the specification and is
	  subject to change
SeeAlso: #0796,#0797,#0798

(Table 0800)
Values for PCI Power Management Data Select:
 00h	D0-state power consumed in watts (+20%/-10%)
 01h	D1-state power consumed in watts (+20%/-10%)
 02h	D2-state power consumed in watts (+20%/-10%)
 03h	D3-state power consumed in watts (+20%/-10%)
 04h	D0-state power dissipated into chassis in watts
 05h	D1-state power dissipated into chassis in watts
 06h	D2-state power dissipated into chassis in watts
 07h	D3-state power dissipated into chassis in watts
 08h-0Fh reserved
SeeAlso: #0798

Bitfields for PCI Configuration CardBus CIS Pointer:
Bit(s)	Description	(Table 0801)
 2-0	address space
	000 in device's device-specific configuration space
	001 in memory pointed to by base address register 0
	...
	110 in memory pointed to by base address register 5
	111 in device's expansion ROM
 27-3	offset within address space defined by bits 2-0
 31-28	ROM image number
SeeAlso: #0790

Format of CardBus Socket/ExCA socket interface register space:
Offset	Size	Description	(Table 0802)
 00h	DWORD	Socket Event Register (see #0804)
 04h	DWORD	Socket Mask Register (see #0805)
 08h	DWORD	Socket Present State Register (see #0806)
 0Ch	DWORD	Socket Force Event Register (see #0807)
 10h	DWORD	Socket Control Register (see #0808)
 14h  3 DWORDs	reserved
 20h	DWORD	Socket Power Management Register
 90h	BYTE	(TI PCI1130) Retry Status Register
 91h	BYTE	(TI PCI1130) Card Control Register (see #0809)
 92h	BYTE	(TI PCI1130) Device Control Register (see #0810)
 93h	BYTE	(TI PCI1130) Buffer Control Register
800h 64+ BYTEs	ExCa Socket Interface Registers (see #0803)

Format of ExCa memory-mapped registers:
Offset	Size	Description	(Table 0803)
 00h	BYTE	identification and revision register
 01h	BYTE	interface status register
 02h	BYTE	power control register
 03h	BYTE	interrupt and general control
 04h	BYTE	card status change
 05h	BYTE	card status change interrupt configuration
 06h	BYTE	address window enable
 07h	BYTE	I/O window control register
 08h	WORD	I/O window 0 start address
 0Ah	WORD	I/O window 0 end address
 0Ch	WORD	I/O window 1 start address
 0Eh	WORD	I/O window 1 end address
 10h	WORD	memory window 0 start address
 12h	WORD	memory window 0 end address
 14h	WORD	memory window 0 offset address
 16h  2 BYTEs	user-defined
 18h	WORD	memory window 1 start address
 1Ah	WORD	memory window 1 end address
 1Ch	WORD	memory window 1 offset address
 1Eh	BYTE	user-defined
 1Fh	BYTE	reserved
 20h	WORD	memory window 2 start address
 22h	WORD	memory window 2 end address
 24h	WORD	memory window 2 offset address
 26h  2 BYTEs	user-defined
 28h	WORD	memory window 3 start address
 2Ah	WORD	memory window 3 end address
 2Ch	WORD	memory window 3 offset address
 2Eh  2 BYTEs	user-defined
 30h	WORD	memory window 4 start address
 32h	WORD	memory window 4 end address
 34h	WORD	memory window 4 offset address
 36h 10 BYTEs	user-defined
---optional---
 40h	BYTE	memory window 0 start address high byte
 41h	BYTE	memory window 1 start address high byte
 42h	BYTE	memory window 2 start address high byte
 43h	BYTE	memory window 3 start address high byte
 44h	BYTE	memory window 4 start address high byte
 45h-7FFh	user-defined
SeeAlso: #0802

Bitfields for CardBus Socket Event Register:
Bit(s)	Description	(Table 0804)
 0	CSTSCHG pin asserted (status change)
 1	CCD1# (card detect 1) changed state
 2	CCD2# (card detect 2) changed state
 3	interface power cycle completed
31-4	reserved (0)
Note:	the bits in this register are set by the bridge, and cleared by writing
	  a one into the bits one wishes to clear
SeeAlso: #0802,#0805,#0807

Bitfields for CardBus Socket Event Mask Register:
Bit(s)	Description	(Table 0805)
 0	write-protect (enable status-change interrupt on WriteProtect switch)
 1	ready mask (allow status-change interrupt on Ready line change)
 3-2	battery condition (allow status-change int on battery-condition change)
 4	general wakeup enabled
 5	binary audio mode enabled on CAUDIO pin
 6	Pulse Width Modulation enabled on CAUDIO pin
	(CAUDIO state undefined if both bits 5 and 6 set)
 13-7	reserved (0)
 14	Wakeup mask (enable wakeup events via status-change pin)
 15	enable card interrupts via CINT# pin and wakeup events
 31-16	reserved
SeeAlso: #0802,#0804,#0806

Bitfields for CardBus Socket Present State Register:
Bit(s)	Description	(Table 0806)
 0	CSTSCHG pin asserted (status change)
 1	CCD1# (card detect 1) changed state
 2	CCD2# (card detect 2) changed state
 3	interface power cycle completed
 4	16-bit PC card inserted
 5	CardBus card inserted
 6	card's interrupt pin asserted
 7	card inserted but type can not be determined
 8	data may have been lost due to abrupt card removal
 9	attempted to apply Vcc voltage not supported by the card
 10	card can accept Vcc = 5.0 volts
 11	card can accept Vcc = 3.3 volts
 12	card can accept Vcc = X.X volts
 13	card can accept Vcc = Y.Y volts
 27-14	reserved (0)
 28	socket can accept Vcc = 5.0 volts
 29	socket can accept Vcc = 3.3 volts
 30	socket can accept Vcc = X.X volts
 31	socket can accept Vcc = Y.Y volts
Note:	bits 0-3 may be cleared by writing a 1 into the respective bits
SeeAlso: #0802,#0804,#0805,#0808

Bitfields for CardBus Socket Force Event Register:
Bit(s)	Description	(Table 0807)
 0	write-protect
 1	ready
 2	battery voltage detect 2
 3	battery voltage detect 1
 4	general wakeup
 14-5	reserved (0)
 15	enable card interrupts via CINT# pin
 31-16	reserved
Note:	this register can simulate events by forcing the values of some of the
	  bits in the Event Mask Register; any bit of this register which is
	  set to 1 forces the corresponding bit in the Mask Register to 1,
	  while bits set to 0 leave the corresponding bit unchanged
SeeAlso: #0802,#0804,#0808

Bitfields for CardBus Socket Control Register:
Bit(s)	Description	(Table 0808)
 2-0	Vpp control
	000 power off
	001 12.0 Volts
	010 5.0 Volts
	011 3.3 Volts
	100 reserved (X.X Volts)
	101 reserved (Y.Y Volts)
	110 reserved
	111 reserved
 3	reserved (0)
 6-4	Vcc control (as for Vpp, but 12.0V not supported)
 31-7	reserved (0)
SeeAlso: #0802,#0805,#0807

Bitfields for TI PCI1130 Card Control Register:
Bit(s)	Description	(Table 0809)
 0	interrupt pending
 1	speaker output enabled
 2	reserved
 3	enable status-change interrupt routing (to INTA# for socket A, INTB#
	  for socket B)
 4	function interrupt routed to corresponding PCI interrupt pin
 5	PCI interrupts enabled
 6	ZOOM video mode enabled
 7	Ring Indicator enabled on IRQ15/RI_OUT pin
SeeAlso: #0802,#0810

Bitfields for TI PCI1130 Device Control Register:
Bit(s)	Description	(Table 0810)
 0	reserved (0)
 2-1	interrupt mode enable
	00 no interrupt
	01 ISA mode (direct IRQ routing)
	10 serialized interrupt mode
	11 reserved
 4-3	reserved
 5	3volt Socket Capable force bit
 6	5volt Socket Capable force bit
 7	reserved
SeeAlso: #0802,#0809

Bitfields for PCI Configuration I/O base and limit:
Bit(s)	Description	(Table 0811)
 3-0	(read-only) address decoding type
	0000 16-bit
	0001 32-bit
	other reserved
 7-4	bits 15-12 of I/O address range
SeeAlso: #0790,#0812

Bitfields for PCI Configuration memory base and limit:
Bit(s)	Description	(Table 0812)
 3-0	address decode type
	0000 32-bit address decoder
	0001 64-bit address decoder
	other reserved
 15-4	bits 31-20 of memory address range
SeeAlso: #0790,#0811

Format of PCI Configuration Data for VLSI VL82C591 Host/PCI bridge:
Offset	Size	Description	(Table 0813)
 00h 64 BYTEs	header (see #0790)
		(device ID 0005h)
 40h	BYTE	bus number
 41h	BYTE	subordinate bus number
 42h	WORD	reserved
 44h  4 DWORDs	reserved
 54h  2 BYTEs	device-specific configuration registers
 56h	WORD	reserved
 58h  2 BYTEs	device-specific configuration registers
 5Ah	WORD	reserved
 5Ch  5 BYTEs	device-specific configuration registers
	...
 FFh	BYTE	device-specific configuration register
SeeAlso: #0790,#0649,#0814

Format of PCI Configuration data for VLSI VL82C593 PCI/ISA bridge:
Offset	Size	Description	(Table 0814)
 00h 64 BYTEs	header (see #0790)
		(device ID 0006h)
 40h  4 DWORDs	reserved
 50h 11 BYTEs	device-specific configuration registers
 5Bh	BYTE	reserved
 5Ch 25 BYTEs	device-specific configuration registers
 75h 138 BYTEs	reserved
 FFh	BYTE	device-specific configuration register
SeeAlso: #0790,#0813

Format of PCI Configuration data for Intel 82434 Cache/DRAM Controller:
Offset	Size	Description	(Table 0815)
 00h 64 BYTEs	header (see #0790)
		(vendor ID 8086h, device ID 04A3h)
		(revision numbers < 10h vary slightly from revision 10h)
 40h 16 BYTEs	unused (hard-wired to 00h)
 44h	BYTE	??? (AMI BIOS writes 00h)
 45h	BYTE	??? (AMI BIOS writes 00h)
 50h	BYTE	secondary (L2) cache control???
		bit 2: enable L2 cache
		bits 1-0: ??? (set according to external bus speed)
 51h	BYTE	deturbo frequency control register
		when deturbo mode is selected (see PORT 0CF9h), the chipset
		  places a hold on the memory bus for a fraction of the
		  time inversely proportional to the value in this register
		  (i.e. C0h = 1/4, 80h = 1/2, 40h = 3/4, 20h = 7/8, etc.)
		  (only bits 7-6 writable, bits 5-0 hardwired to 0)
 52h	BYTE	???cache control???
		bits 6-7: ???
		bits 4-3: ???
		bit 1: ???
		bit 0: ???
 53h	BYTE	CPU control???
		bit 3: ???
		bit 1: enable CPU-to-PCI posted writes
		bit 0: enable CPU-to-memory posted writes
 54h	BYTE	PCI control
		bit 0: enable PCI-to-memory posted writes
		bit 1: enable PCI burst
		bit 2: ???
 55h  2 BYTEs	???
 57h	BYTE	DRAM Control???
		bit 0: ???
		bit 2: ???
		bit 5: disable parity detection mode???
 58h	BYTE	DRAM Timing??? (see also #0855)
		bit 0: ???
 59h  7	BYTEs	Programmable Attribute Map registers 0-6 (see #0856)
 60h  8	BYTEs	DRAM Row Boundary registers 0-7
		(chip revisions numbered < 10h only support six rows of DRAM)
		each register N indicates the amount of cumulative amount of
		  memory in SIMM banks 0-N, in multiples of 1M; offset 67h
		  (65h on pre-revision 10h 82434's) contains the total amount
		  of memory installed in the system
 68h	BYTE	DRAM Row Type???
		(each bit indicates parity/nonparity ???)
 69h  3 BYTEs	???
 6Ch	DWORD	unused??? (apparently hardwired to 00000000h)
 70h	BYTE	???Multi-Transaction Timer???
		bits 1-0: ???
 71h	BYTE	???
		bit 3: memory has parity???
 72h	BYTE	System Management RAM control (see also #0860)
		bits 2-0: SMRAM memory address???
		bit 5:	map SMM-mode memory (64K) into address space when bits
			2-0 = 010 (default 3000h:0000h; can be changed by
			first SMM event)
 73h  5 BYTEs	???
 78h	WORD	???
		bits 7-4: bottom of ISA memory hole in MB???
		bits 14-12: size of ISA hole in MB (less 1)???
		bit 15: enable ISA hole???
 7Ah  2 BYTEs	???
 7Ch	DWORD	???
		bits 0-3: ???
		bit 9: ???
		bit 13: byte merging enabled
		bit 29: ???
		bit 31: ???
 80h 128 BYTEs	unused???
Note:	the 82434 is part of the Intel Neptune chipset
SeeAlso: #0817,#0836

Format of PCI Configuration data for Intel 82424 Cache Controller:
Offset	Size	Description	(Table 0816)
 00h 64 BYTEs	header (see #0790)
		(vendor ID 8086h, device ID 0483h)
 40h	BYTE	bus number
 41h	BYTE	subordinate bus number
 42h	BYTE	disconnect timer
 50h	BYTE	host CPU selection
 51h	BYTE	deturbo frequency control
		when deturbo mode is selected (see PORT 0CF9h), the chipset
		  places a hold on the memory bus for a fraction of the
		  time inversely proportional to the value in this register
		  (i.e. C0h = 1/4, 80h = 1/2, 40h = 3/4, 20h = 7/8, etc.)
 52h	BYTE	secondary cache control
 53h	BYTE	write buffer control
 54h	BYTE	PCI features control
 55h	BYTE	DRAM Operation Mode Select
 56h	BYTE	System Exception Handling
 57h	BYTE	SMM Control Register
 58h	BYTE	reserved
 59h  7	BYTEs	Programmable Attribute Map registers 0-6 (see also #0856)
 60h  4 BYTEs	DRAM Row Boundary registers 0-3
		each register N indicates amount of memory in rows 0-N (each
		  row is 64 bits wide)
		boundary register 3 (offset 63h) contains the total system
		  memory, which may not exceed 128M
 64h  4 BYTEs	unused???
 68h	WORD	Memory Hole-0
 6Ah	WORD	Memory Hole-1
Note:	the above field names are those given by EduWARE's PCI Configuration
	  Manager v1.2
SeeAlso: #0815,#0836,#0846

Format of PCI Configuration data for Intel 82378 and 82379 ISA Bridges:
Offset	Size	Description	(Table 0817)
 00h 64 BYTEs	header (see #0790)
		(vendor ID 8086h, device ID 0484h)
		(revision ID:
		    bits 7-4: reserved
		    bits 3-0: revision
			0011 82378ZB A0-step
			1000 82379AB A0-step)
 40h	BYTE	PCI Control (see #0818)
 41h	BYTE	PCI Arbiter Control (see #0819)
 42h	BYTE	PCI Arbiter Priority Control (see #0820)
 43h	BYTE	(82378ZB) PCI Arbiter Priority Control Extension Register
		bit 0: bank 3 fixed priority mode select (see also #0820)
		    =0 REQ2# has higher priority
		    =1 REQ3# has higher priority
 44h	BYTE	MEMCS# Control (see #0821)
 45h	BYTE	MEMCS# Bottom of Hole (address bits 23-16)
 46h	BYTE	MEMCS# Top of Hole (address bits 23-16)
 47h	BYTE	MEMCS# Top of Memory
		(address bits 28-21 == size in 2M increments, less 1)
 48h	BYTE	ISA Address Decoder Control (see #0822)
 49h	BYTE	ISA Address Decoder ROM Block Enable (see #0823)
 4Ah	BYTE	ISA Address Decoder Bottom of Hole (address bits 23-16)
 4Bh	BYTE	ISA Address Decoder Top of Hole (address bits 23-16)
 4Ch	BYTE	ISA Controller Recovery Time (see #0840)
 4Dh	BYTE	ISA Clock Divisor (see #0824)
 4Eh	BYTE	Utility Bus Chip Select Enable A (see #0825)
 4Fh	BYTE	Utility Bus Chip Select Enable B (see #0826)
 50h  4 BYTEs	reserved
 54h	BYTE	MEMCS# Attribute Register #1 (see #0827)
		attributes for 16K blocks from C0000h-CFFFFh
 55h	BYTE	MEMCS# Attribute Register #2 (see #0827)
		attributes for 16K blocks from D0000h-DFFFFh
 56h	BYTE	MEMCS# Attribute Register #3 (see #0827)
		attributes for 16K blocks from E0000h-EFFFFh
 57h	BYTE	(82378) Scatter/Gather Relocation Base Adress (see #0828)
		(82379AB) reserved
 58h  8 BYTEs	reserved
 60h	BYTE	(82378ZB) IRQ0# Route Control (see #0829)
 61h	BYTE	(82378ZB) IRQ1# Route Control (see #0829)
 62h	BYTE	(82378ZB) IRQ2# Route Control (see #0829)
 63h	BYTE	(82378ZB) IRQ3# Route Control (see #0829)
 64h 12 BYTEs	reserved
 70h	BYTE	(82378) reserved
		(82379AB, write-only) PIC/APIC Configuration Control
			  (see #0830)
 71h	BYTE	(82378) reserved
		(82379AB, write-only) APIC Base Address Relocation
		  (see #0831,MEM FEC00000h)
 72h 14 BYTEs	reserved
 80h	WORD	BIOS timer base address (see PORT 0078h)
		bits 15-2 are bits 15-2 of BIOS timer port address
		bit 1: reserved (0)
		bit 0: timer enabled (if disabled, other bits ignored)
 82h 30 BYTEs	unused???
 A0h	BYTE	SMI Control (see #0832)
 A1h	BYTE	reserved
 A2h	WORD	SMI Enable (see #0833)
 A4h	DWORD	System Event Enable (SEE) (see #0834)
 A8h	BYTE	Fast-Off Timer (in minutes)
 A9h	BYTE	reserved
 AAh	WORD	active SMI Requests (see #0835)
 ACh	BYTE	(82378ZB) Clock Throttle STPCLK# Low Timer
		duration of STPCLK# low period in 32 microsecond units
 ADh	BYTE	reserved
 AEh	BYTE	(82378ZB) Clock Throttle STPCLK# High Timer
		duration of STPCLK# high period in 32 microsecond units
 AFh 81 BYTEs	reserved
SeeAlso: #0815,#0865,PORT 040Ah"82378ZB"

Bitfields for Intel 82378/82379 PCI Control:
Bit(s)	Description	(Table 0818)
 7	reserved (0)
 6	DMA Reserved Page Register Aliasing Control
	=0 alias PORT 80h-8Fh to PORT 90h-9Fh
 5	Interrupt Acknowledge Enable
	=0 ignore INTA cycles on the PCI bus, but still allow 8259 register
	  access and poll-mode functions
 4-3	Subtractive Decoding Sample Point
	00 slow sample point
	01 typical
	10 fast sample point
	11 reserved
 2	PCI Posted Write Buffer Enable
 1	ISA Master Line Buffer Configuration
	=0 single-transaction mode
	=1 eight-byte mode for ISA bus master transfers
 0	DMA Line Buffer Configuration
	=0 single-transaction mode
	=1 eight-byte mode
SeeAlso: #0817,#0819

Bitfields for Intel 82378/82379 PCI Arbiter Control:
Bit(s)	Description	(Table 0819)
 7-5	reserveed (0)
 4-3	Master Retry Timer
	00 disabled (retries never masked)
	01 retries unmasked after 16 PCICLKs
	10 retries unmasked after 32 PCICLKs
	11 retries unmasked after 64 PCICLKs
 2	Bus Park
	=1 park CPUREQ# on PCI bus when 82378 detects PCI bus idle
 1	Bus Lock
	=0 resource lock
	=1 Bus lock
 0	Guaranteed Access Time
	=1 ISA bus masters are guaranteed 2.5 microsecond CHRDY time-out
SeeAlso: #0817,#0818

Bitfields for Intel 82378/82379 PCI Arbiter Priority Control:
Bit(s)	Description	(Table 0820)
 7	bank 3 rotate control
 6	bank 2 rotate control
 5	bank 1 rotate control
 4	bank 0 rotate control
 3	bank 2 fixed priority mode select B
 2	bank 2 fixed priority mode select A
 1	bank 1 fixed priority mode select
 0	bank 0 fixed priority mode select
Note:	if both 'rotate' and 'fixed' bits are set for a given bank,
	  that bank will be in rotating-priority mode
SeeAlso: #0817,#0819

Bitfields for Intel 82378/82379 MEMCS# Control Register:
Bit(s)	Description	(Table 0821)
 7-5	reserved (0)
 4	MEMCS# Master Enable
 3	write enable for 0F0000h-0FFFFFh
 2	read enable for 0F0000h-0FFFFFh
 1	write enable for 080000h-09FFFFh
 0	read enable for 080000h-09FFFFh
SeeAlso: #0817

Bitfields for Intel 82378/82379 ISA Address Decoder Control Register:
Bit(s)	Description	(Table 0822)
 7-4	ISA memory cycle forwarding to PCI
	0000-1111 = 1M-16M top of ISA memory; any accesses above programmed
		  limit are forwarded to PCI bus
 3-0	ISA/DMA memory cycle to PCI bus enables
	bit 3: 896K-960K (E000h-EFFFh)
	bit 2: 640K-768K (A000h-BFFFh)
	bit 1: 512K-640K (8000h-9FFFh)
	bit 0: 0K-512K	 (0000h-7FFFh)
SeeAlso: #0817,#0823

Bitfields for Intel 82378/82379 ISA Address Decoder ROM Block Enable:
Bit(s)	Description	(Table 0823)
 7	enable 880K-896K (EC00h-EFFFh)
 6	enable 864K-880K (E800h-EBFFh)
 5	enable 848K-864K (E400h-E7FFh)
 4	enable 832K-848K (E000h-E3FFh)
 3	enable 816K-832K (DC00h-DFFFh)
 2	enabel 800K-816K (D800h-DBFFh)
 1	enable 784K-800K (D400h-D7FFh)
 0	enable 768K-784K (D000h-D3FFh)
Note:	ISA accesses within any enabled ranges are forwarded to the PCI bus
SeeAlso: #0817,#0822

Bitfields for Intel 82378/82379 ISA Clock Divisor Register:
Bit(s)	Description	(Table 0824)
 7	reserved (0)
 6	enable positive decode of upper 64K BIOS at 000F0000h-000FFFFFh,
	  FFEF0000h-FFEFFFFFh, and FFFF0000h-FFFFFFFFh
 5	coprocessor error enable
	=1 FERR# is driven onto IRQ13
 4	IRQ12/Mouse Function Enable
	=0 standard IRQ12
	=1 mouse
 3	RSTDRV enable
	=1 assert RSTDRV until this bit cleared (for use in changing ISA bus
	  speed)
 2-0	PCICLK-to-ISA SYSCLK divisor
	000	4
	001	3
	other	reserved
SeeAlso: #0817,#0822

Bitfields for Intel 82378/82379 Utility Bus Chip Select A Register:
Bit(s)	Description	(Table 0825)
 7	extended BIOS enable (decode accesses to FFF80000h-FFFDFFFFh)
 6	lower BIOS enable (decode accesses to E0000h-EFFFFh,
	  FFEE0000h-FFEEFFFFh, and FFFE0000h-FFFEFFFFh)
 5	(82378ZB) floppy disk primary/secondary address select
	=1 use secondary address range
 4	(82378ZB) IDE Decode enable
 3,2	floppy disk address locations enable
 1	keyboard controller address location enable
	enables I/O addresses 60h,62h,64h,66h (82378ZB) or 60h/64h (82379AB)
 0	RTC address location enabled
	=1 enable decode of I/O ports 70h-77h
SeeAlso: #0817,#0842,#0826

Bitfields for Intel 82378ZB/82379 Utility Bus Chip Select B Register:
Bit(s)	Description	(Table 0826)
 7	configuration RAM decode enable
	=1 permit write accesses to I/O port 0C00h and r/w to ports 08xxh
 6	enable PORT 0092h
 5-4	parallel port enable
	00 LPT1 (ports 03BCh-03BFh)
	01 LPT2 (ports 0378h-037Fh)
	10 LPT3 (ports 0278h-027Fh)
	11 disabled
 3-2	serial port B enable
	00 COM1 (03F8h-03FFh)
	01 COM2 (02F8h-02FFh)
	10 reserved
	11 port B disabled
 1-0	serial port A enable
	00 COM1 (03F8h-03FFh)
	01 COM2 (02F8h-02FFh)
	10 reserved
	11 port A disabled
Note:	if both serial ports are set to the same address, port B is disabled
SeeAlso: #0817,#0825,PORT 0092h

Bitfields for Intel 82378/82379 MEMCS# Attribute Register 1/2/3:
Bit(s)	Description	(Table 0827)
 7	write-enable xC000h-xFFFFh expansion ROM
 6	read-enable xC000h-xFFFFh expansion ROM
 5	write-enable x8000h-xBFFFh expansion ROM
 4	read-enable x8000h-xBFFFh expansion ROM
 3	write-enable x4000h-x7FFFh expansion ROM
 2	read-enable x4000h-x7FFFh expansion ROM
 1	write-enable x0000h-x3FFFh expansion ROM
 0	read-enable x0000h-x3FFFh expansion ROM
Note:	x = C/D/E depending on the attribute register
SeeAlso: #0817

Bitfields for Intel 82378ZB Scatter Gather Relocation Base Address:
Bit(s)	Description	(Table 0828)
 (no details in Intel documentation)
SeeAlso: #0817,#0827,#0829,PORT 040Ah"82378ZB"

Bitfields for Intel 82378/82379 PCI IRQ Route Control Register:
Bit(s)	Description	(Table 0829)
 7	disable IRQ routing
 6-4	reserved (0)
 3-0	ISA IRQ number to which to route the PCI IRQ
Note:	IRQs 0-2, 8, and 13 are reserved
SeeAlso: #0817,#0865

Bitfields for Intel 82379AB PIC/APIC Configuration Control Register:
Bit(s)	Description	(Table 0830)
 7-2	reserved
 1	SMI Routing Control
	=1 SMI via APIC
	=0 SMI via SMI# signal
 0	INT Routing Control
	=1 INT disabled (requires that APIC be enabled)
	=0 INT enabled
SeeAlso: #0817,#0831

Bitfields for Intel 82379AB/82371 APIC Base Address Relocation:
Bit(s)	Description	(Table 0831)
 7	reserved
 6	(82379AB) reserved
 6	(82371) A12 mask
	=1 ignore address bit 12 in APIC address
 5-0	bits 15-10 of APIC memory address (ORed with FEC00000h to form base
	  address)
SeeAlso: #0817,#0865,#0830,MEM FEC00000h

Bitfields for Intel 82378/82379 SMI Control Register:
Bit(s)	Description	(Table 0832)
 7	reserved
 6	(82378) reserved
	(82379) require Stop Grant bus cycle before asserting STPCLK#
 5-4	reserved
 3	Fast-Off Timer freeze
 2	STPCLK# scaling enable
	=1 enable Clock Throttle bytes in PCI configuration space
 1	STPCLK# signal enable
	=1 assert STPCLK# on read from PORT 00B2h
 0	SMI# Gate
	=1 enable SMI# on system management interrupt
Notes:	bit 1 is cleared either with an explicit write of 0 here, or by any
	  write to PORT 00B2h
	bit 0 does not affect the recording of SMI events, so a pending SMI
	  will cause an immediate SMI# when the bit is set
SeeAlso: #0817,#0833,#0834,#0874,PORT 00B2h

Bitfields for Intel 82371/82378/82379 SMI Enable Register:
Bit(s)	Description	(Table 0833)
 15-9	reserved
 8	(82371SB only) Legacy USB SMI enable
 7	APMC Write SMI enable
	=1 generate SMI on write to PORT 00B2h
 6	EXTSMI# SMI enable
 5	Fast-Off Timer SMI enable
 4	IRQ12 (PS/2 mouse) SMI enable
 3	IRQ8 (RTC alarm) SMI enable
 2	IRQ4 (COM1/COM3) SMI enable
 1	IRQ3 (COM2/COM4) SMI enable
 0	IRQ1 (keyboard) SMI enable
SeeAlso: #0817,#0832,#0834,#0865,PORT 00B2h

Bitfields for Intel 82371/82378/82379 System Event Enable Register:
Bit(s)	Description	(Table 0834)
 31	Fast-Off SMI enable (system and break events)
 30	(82379 only) Fast-Off Interrupt Enable (break events only)
 30	(82371 only) INTR enable (break events only)
 29	Fast-Off NMI enable (system and break events)
 28	(82371SB only) Fast-Off APIC enable (break events only)
 27	(82379 only) Fast-Off COM enable (system events only)
 26	(82379 only) Fast-Off LPT enable (system events only)
 25	(82379 only) Fast-Off Drive enable (system events only)
 24	(82379 only) Fast-Off DMA enable (system events only)
 23-16	reserved
 15-3	Fast-Off IRQ (15-3) enable (system and break events)
 2	reserved
 1-0	Fast-Off IRQ (1-0) enable (system and break events)
Note:	any enabled system event restarts the Fast-Off Timer, thus preventing
	  a Fast-Off powerdown; any enabled break event awakens the system from
	  powerdown
SeeAlso: #0817,#0832,#0833,#0835,#0865

Bitfields for Intel 82371/82378/82379 SMI Request Register:
Bit(s)	Description	(Table 0835)
 15-9	reserved
 8	(82371SB only) Legacy USB SMI status
 7	APM SMI Status (write to PORT 00B2h triggered SMI)
 6	EXTSMI# SMI Status (EXTSMI# line triggered SMI)
 5	Fast-Off Timer expired
 4	IRQ12 triggered SMI
 3	IRQ8 triggered SMI
 2	IRQ4 triggered SMI
 1	IRQ3 triggered SMI
 0	IRQ1 triggered SMI
Note:	software must explicitly reset the appropriate bits
SeeAlso: #0817,#0834,#0865

Format of PCI Configuration data for Intel 82425EX PSC:
Offset	Size	Description	(Table 0836)
 00h 64 BYTEs	header (see #0790)
		(vendor ID 8086h, device ID 0486h)
 40h	BYTE	PCI control register (see #0837)
 41h  3 BYTEs	???
 44h	BYTE	host device control register (see #0838)
 45h  3 BYTEs	???
 48h	WORD	PCI local-bus IDE control register (see #0839)
 4Ah  2 BYTEs	???
 4Ch	BYTE	ISA I/O recovery timer register (see #0840)
 4Dh	BYTE	part revision register (see #0841)
 4Eh	BYTE	X-bus Chip Select A register (see #0842)
 4Fh	BYTE	X-bus Chip Select B register???
 50h	BYTE	host select register
 51h	BYTE	deturbo frequency control register
		when deturbo mode is selected (see PORT 0CF9h), the chipset
		  places a hold on the memory bus for a fraction of the
		  time inversely proportional to the value in this register
		  (i.e. C0h = 1/4, 80h = 1/2, 40h = 3/4, 20h = 7/8, etc.)
 52h	WORD	secondary (L2) cache control register
 54h  2 BYTEs	???
 56h	WORD	DRAM control register
 58h	BYTE	???
 59h  7 BYTEs	Programmable Attribute Map (PAM) registers 0-6 (see also #0856)
 60h  5 BYTEs	DRAM row boundary registers 0-4
		each register N indicates amount of memory in rows 0-N (each
		  row is 64 bits wide); the fifth row of memory (if
		  implemented) must contain either 8M or 16M, depending on
		  system configuration
		boundary register 4 (offset 64h) contains the total system
		  memory, which may not exceed 128M
 65h	BYTE	???
 66h	BYTE	PIRQ route control register 0
 67h	BYTE	PIRQ route control register 1
 68h	BYTE	DRAM memory hole register
 69h	BYTE	top of memory
 6Ah  6 BYTEs	???
 70h	BYTE	SMRAM control register
 71h 47 BYTEs	unused???
 A0h	BYTE	SMI control register
 A1h	BYTE	???
 A2h	WORD	SMI enable register
 A4h	DWORD	system event enable
 A8h	BYTE	fast off timer register
 A9h	BYTE	???
 AAh	WORD	SMI request register
 ACh	BYTE	clock throttle STPCLK# low timer
 ADh	BYTE	unused???
 AEh	BYTE	clock throttle STPCLK# high timer
 AFh	BYTE	???
 B0h 80 BYTEs	unused???
SeeAlso: #0790,#0816,#0815,#0846,#0865

Bitfields for Intel 82425EX PCI control register:
Bit(s)	Description	(Table 0837)
 0	CPU-to-PCI byte merging
 1	CPU-to-PCI bursting enable
 2	PCI posted-write buffer enable
 4-3	subtractive decode sampling point
	00 slow
	01 typical
	10 fast
	11 reserved
 5	DRAM parity error enable
 6	target abort error enable
 7	reserved
SeeAlso: #0836,#0838,#0839,#0840

Bitfields for Intel 82425EX host device control register:
Bit(s)	Description	(Table 0838)
 0	HRDY# maximum signal sampling point
	0 slow timing
	1 fast timing
 1	HDEV# signal sampling point
	0 slow timing
	1 fast timing
 2	host device present
 7-3	reserved
SeeAlso: #0836,#0837

Bitfields for Intel 82425EX local-bus IDE control register:
Bit(s)	Description	(Table 0839)
 1-0	primary/secondary PCI IDE enable
	00 IDE disabled
	01 primary (ports 01F0h-01F7h,03F6,03F7h)
	10 secondary (ports 0170h-017Fh,0376h,0377h)
	11 reserved
 3-2	fast timing bank drive select 1
	bit 2 = drive 0 enabled
	bit 3 = drive 1 enabled
 5-4	IORDY sample point Enable Drive Select
	bit 4 = drive 0 enabled
	bit 5 = drive 1 enabled
 7-6	reserved
 9-8	IORDY sample point
	00 6 clocks
	01 5 clocks
	10 4 clocks
	11 3 clocks
 12-10	recover time (000 = 8 PCI clocks, 001 = 7, ..., 101 = 3, 110/111 = 3)
 15-13	reserved
SeeAlso: #0836,#0837

Bitfields for Intel chipset ISA I/O recovery timer register:
Bit(s)	Description	(Table 0840)
 1-0	16-bit I/O recovery time
	00 = 4 SYSCLKs
	01-11 = 1-3 SYSCLKs
 2	16-bit I/O recovery enable
 5-3	8-bit I/O recovery time
	000 = 8 SYSCLKs
	001-110 = 1-7 SYSCLKs
 6	8-bit I/O recovery enable
 7	(82425EX/82371) DMA reserved page register aliasing disable
	=0 ports 0090h-009Fh alias ports 0080h-008Fh
	=1 ports 0090h-009Fh forwarded to ISA bus
SeeAlso: #0817,#0836,#0837,#0865

Bitfields for Intel 82425EX part revision register:
Bit(s)	Description	(Table 0841)
 7-5	fabrication house identifier (read-only)
 4	E0000h-EFFFFh ISA-to-main-memory forwarding enabled
 3-0	revision ID (read-only)
SeeAlso: #0836,#0842

Bitfields for Intel 82425EX/82371 X-bus Chip Select A register:
Bit(s)	Description	(Table 0842)
 7	extended BIOS enabled at FFF80000h-FFFDFFFFh
 6	lower (E000h) BIOS enabled
 5	trigger IRQ13 on FERR#
 4	IRQ12 mouse function enabled
 3	reserved (0)
 2	BIOS memory write protect
 1	keyboard controller addresses (60h,62h,64h,66h) enabled
 0	RTC addresses (70h-77h) enabled
SeeAlso: #0836,#0865,#0841

Format of PCI Configuration Data for Intel 82439HX:
Offset	Size	Description	(Table 0843)
 00h 64 BYTEs	header (see #0790)
		(vender ID 8086h, device ID 1250h)
		(revision ID 00h = A0 stepping)
 40h 16 BYTEs	reserved
 50h	BYTE	PCI Control (see #0848)
 51h	BYTE	reserved
 52h	BYTE	cache control (see #0850)
 53h  3 BYTEs	reserved
 56h	BYTE	DRAM extended control (see #0853)
 57h	BYTE	DRAM control (see #0854)
 58h	BYTE	DRAM timing (see #0855)
 59h  7 BYTEs	Programmable Attribute Map registers 0-6 (see #0856)
 60h  8 BYTEs	DRAM Row Boundary registers 0-7
		each register N indicates cumulative amount of memory in rows
		  0-N (each 64 bits wide), in 4M units
 68h	BYTE	DRAM Row Type (see #0857)
		bits 0-7 indicate whether each row 0-7 contains EDO DRAM
		  instead of page-mode DRAM
 69h	BYTE	???
 6Ah  8 BYTEs	reserved
 72h	BYTE	System Management RAM control (see #0860)
 73h 29 BYTEs	reserved
 90h	BYTE	Error Command (see #0863)
 91h	BYTE	Error Status (see #0864) (read-only)
 92h	BYTE	Error Syndrome (read-only)
		latest non-zero ECC error syndrome
 93h 109 BYTEs	reserved
SeeAlso: #0846,#0879

Format of PCI Configuration Data for Intel 82437MX:
Offset	Size	Description	(Table 0844)
 00h 64 BYTEs	header (see #0790)
		(vendor ID 8086h, device ID 1235h)
 40h 16 BYTEs	reserved
 50h	BYTE	PCI Control (see #0849)
 51h	BYTE	reserved
 52h	BYTE	cache control (see #0850)
 53h  4 BYTEs	reserved
 57h	BYTE	DRAM Control (see #0854)
 58h	BYTE	DRAM timing (see #0855)
 59h  7 BYTEs	Programmable Attribute Map registers 0-6 (see #0856)
 60h  4 BYTEs	DRAM Row Boundary Registers 0-3
		each register N indicates cumulative amount of memory in rows
		  0-N, in 4M units (each row is 64 bits wide)
 64h  4 BYTEs	reserved
 68h	BYTE	DRAM Row Type (see #0858)
 69h  9 BYTEs	reserved
 72h	BYTE	System Management RAM control (see #0860)
 73h 141 BYTEs	reserved
SeeAlso: #0846,#0845

Format of PCI Configuration Data for Intel 82437FX:
Offset	Size	Description	(Table 0845)
 00h 64 BYTEs	header (see #0790)
		(vendor ID 8086h, device ID 0122h) (see #0785)
 40h 16 BYTEs	reserved
 50h	BYTE	PCI Control (see #0849)
 51h	BYTE	reserved
 52h	BYTE	cache control (see #0850)
 53h  4 BYTEs	reserved
 57h	BYTE	DRAM Control (see #0854)
 58h	BYTE	DRAM timing (see #0855)
 59h  7 BYTEs	Programmable Attribute Map registers 0-6 (see #0856)
 60h  5 BYTEs	DRAM Row Boundary Registers 0-4
		each register N indicates cumulative amount of memory in rows
		  0-N, in 4M units (each row is 64 bits wide)
 65h  3 BYTEs	reserved
 68h	BYTE	DRAM Row Type (see #0858)
 69h  9 BYTEs	reserved
 72h	BYTE	System Management RAM control (see #0860)
 73h 141 BYTEs	reserved
SeeAlso: #0844,#0846

Format of PCI Configuration Data for Intel 82437VX:
Offset	Size	Description	(Table 0846)
 00h 64 BYTEs	header (see #0790)
		(vendor ID 8086h, device ID 7030h)
		(revision ID 00h = A0 stepping)
 40h 15 BYTEs	reserved
 4Fh	BYTE	arbitration control (see #0847)
 50h	BYTE	PCI Control (see #0848)
 51h	BYTE	reserved
 52h	BYTE	cache control (see #0850)
 53h	BYTE	cache control extensions (see #0851)
 54h	WORD	SDRAM control (see #0852)
 55h	BYTE	reserved
 56h	BYTE	DRAM extended control (see #0853)
 57h	BYTE	DRAM control (see #0854)
 58h	BYTE	DRAM timing (see #0855)
 59h  7 BYTEs	Programmable Attribute Map registers 0-6 (see #0856)
 60h  5 BYTEs	DRAM Row Boundary registers 0-4
		each register N indicates amount of memory in rows 0-N in 4M
		  units (each row is 64 bits wide); the fifth row of memory (if
		  implemented) must contain either 8M or 16M, depending on
		  system configuration
		boundary register 4 (offset 64h) contains the total system
		  memory, which may not exceed 128M
 65h  2 BYTEs	reserved
 67h	BYTE	DRAM Row Type (high)
		defines memory type in DRAM row 4 in bits 4,0 (see #0857)
 68h	BYTE	DRAM Row Type (low) (see #0857)
 69h	BYTE	PCI TRDY timer (see #0859)
 6Ah  6 BYTEs	reserved
 70h	BYTE	Multi-Transaction Timer
		number of PCLKs guaranteed to the current agent before the
		  82437 will grant the bus to another PCI agent on request
 71h	BYTE	reserved
 72h	BYTE	System Management RAM control (see #0860)
 73h	BYTE	shared memory buffer control (see #0861)
 74h	BYTE	shared memory buffer start address, in 0.5MB units
		end address is top-of-memory at offset 64h or start of an
		  enabled PCI memory hole when top-of-memory is 16M
 76h  2 BYTEs	reserved
 78h	BYTE	graphics controller latency timers (see #0862)
 79h 135 BYTEs	reserved
SeeAlso: #0785,#0816,#0836,#0843,#0844

Bitfields for Intel 82437VX arbitration control:
Bit(s)	Description	(Table 0847)
 7	extended CPU-to-PIIX PHLDA# signalling enabled
 6-4	reserved
 3	CPU priority enable
	=1 CPU gets PCI bus after two PCI slots
	=0 CPU gets PCI bus after three PCI slots
 2-0	reserved
SeeAlso: #0846,#0848

Bitfields for Intel 82437VX/82439HX PCI Control register:
Bit(s)	Description	(Table 0848)
 7-4	reserved (82437VX)
 7	DRAM ECC/Parity Select (82439HX)
	=1 ECC
	=0 parity
 6	ECC TEST enable (82439HX)
 5	shutdown to port 92h (82439HX)
	=1 send 01h to PORT 0092h on Shutdown special cycle on host bus
 4	dual-processor NA# enable (82439HX)
 3	PCI Concurrency Enable
	=1 CPU can access DRAM/L2 during non-PIIX PCI master cycles
	=0 CPU kept off PCI bus during all PCI bus-master cycles
 2	SERR# Output Type (82439HX only)
	=1 SERR# is actively driven high when negated
	=0 SERR# is PCI-compatible open-drain output
 1	reserved
 0	Global TXC Enable (82439HX only)
	=1 enable new 82439HX features
SeeAlso: #0846,#0843,#0850,#0849

Bitfields for Intel 82437FX/82437MX PCI Control register:
Bit(s)	Description	(Table 0849)
 7-5	CPU inactivity timer (in PCI Clocks less 1)
 4	reserved
 3	enable PCI Peer Concurrency
	=1 CPU can access DRAM/L2 during non-PIIX PCI master cycles
	=0 CPU kept off PCI bus during all PCI bus-master cycles
 2	disable PCI Bursting
 1	disable PCI Streaming
 0	disable Bus Concurrency
SeeAlso: #0844,#0845,#0848

Bitfields for Intel 82437/82439HX cache control register:
Bit(s)	Description	(Table 0850)
 7-6	secondary cache size
	00 none
	01 256K
	10 512K
	11 reserved
 5-4	L2 RAM type
	00 pipelined burst SRAM/DRAM
	01 reserved
	10 asynchronous SRAM (82437FX/MX/VX only)
	11 two banks of pipelined burst cache
 3	NA disable
	=1 never assert NA# pin
 2	reserved (82437FX/82437MX/82437VX)
 2	Extended Cacheability Enable (82439HX)
	=1 cache up to 512M
	=0 cache only first 64M
 1	Secondary Cache Force Miss or Invalidate
	=1 force all memory accesses to bypass L2 cache
 0	First Level Cache Enable
	=1 all memory accesses made non-cacheable by CPU L1 cache
SeeAlso: #0846,#0843,#0848,#0851,#0852,#0844

Bitfields for Intel 82437VX cache control extensions register:
Bit(s)	Description	(Table 0851)
 7-6	reserved
 5	DRAM cache detected (read-only)
 4-0	DRAM cache refresh timer
	number of HCLKs 82437VX remains idle during DRAM cache refresh
SeeAlso: #0846,#0850

Bitfields for Intel 82437VX SDRAM control register:
Bit(s)	Description	(Table 0852)
 15-9	reserved
 8-6	Special SDRAM Mode Select
	000 normal mode (default)
	001 enable NOP command
	010 enable All Banks Precharge command
	011 enable Mode Register Command
	100 enable CBR Cycle
	101 reserved
	11x reserved
 5	reserved
 4	CAS# latency
	=1 latency is 2 for all SDRAM cycles
	=0 latency is 3
 3	RAS# precharge and refresh timing
	=0 slower
	=1 faster
 2-0	reserved
SeeAlso: #0846,#0850

Bitfields for Intel 82437VX/82439HX DRAM extended control register:
Bit(s)	Description	(Table 0853)
 7	reserved
 6	(82437VX) refresh RAS# assertion length (0=4 clocks, 1=5 clocks)
 5	(82437VX) Fast EDO Path Select
 4	Speculative Leadoff Disable
 3	(82439HX) Turn-Around Insertion Enable
	=1 insert one extra clock of turnaround time after asserting MWE#
 2-1	Memory Address Drive Strength
	82437VX:		82439HX:
	    00 reserved		    00 8mA
	    01 10mA (default)	    01 8mA/12mA (MAA/MWE#)
	    10 16mA		    10 12mA/8mA (MAA/MWE#)
	    11 reserved		    11 12mA
 0	(82437VX) DRAM Symmetry Detect Mode
	(used to force some memory address lines to fixed value for detecting
	  DRAM symmetry row-by-row)
 0	(82439HX) 64MBit Mode Enable
	=1 enable support for 64M SIMMs
SeeAlso: #0846,#0843,#0854

Bitfields for Intel 82437/82439HX DRAM control register:
Bit(s)	Description	(Table 0854)
 7-6	DRAM Hole Enable
	00 none
	01 512K-640K
	10 15M-16M (82437FX/MX/VX only)
	11 14M-16M (82437VX only)
 5	reserved
 4	(82437MX only) refresh type during Suspend
	=1 self-refreshing DRAMs in system
	=0 CAS-before-RAS refresh
 3	EDO Detect Mode enable
	(used to detect whether memory is EDO bank-by-bank)
 2-0	DRAM refresh rate
	     FX/VX/HX	MX
	000 disabled	15.6 us
	001 50 MHz	31.2 us
	010 60 MHz	62.4 us
	011 66 MHz	125 us
	100 reserved	250 us
	1xx reserved	reserved
SeeAlso: #0846,#0843,#0853,#0844

Bitfields for Intel 82437FX/82437MX/82437VX/82439HX DRAM timing register:
Bit(s)	Description	(Table 0855)
 7	(82437FX) reserved
 7	(82437MX) MA[11:2] buffer strength
	=0 8mA
	=1 12mA
 7	(82437VX) MA-to-RAS# Delay
	=1 one clock
	=0 two clocks
 7	(82439HX) Turbo Read Leadoff
	=1 bypass first register in DRAM data pipeline, saving one clock
	(may only be set in a cacheless configuration)
 6-5	DRAM Read Burst Timing
	00 x444 (EDO and Standard Page Mode)
	01 x333 (EDO), x444 (SPM)
	10 x222 (EDO), x333 (SPM)
	11 x322 (EDO), x333 (SPM) (82437VX only)
	11 reserved (other)
 4-3	DRAM Write Burst Timing
	00 x444
	01 x333
	10 x222
	11 reserved
 2	RAS-to-CAS Delay
	=1 two clocks
	=0 three clocks
 1-0	DRAM Leadoff Timing
	82437VX Read Leadoff  Write Leadoff  RAS# Precharge
	    00		11	7		3
	    01		10	6		3
	    10		11	7		4
	    11		10	6		4
	82437FX/MX Read Lead  Write Leadoff  RAS# Precharge
	    00		8	6		3
	    01		7	5		3
	    10		8	6		4
	    11		7	5		4
	82437VX Read Leadoff  Write Leadoff  RAS# Precharge
	    00		7	6		3
	    01		6	5		3
	    10		7	6		4
	    11		6	5		4
SeeAlso: #0846,#0854,#0844,#0845

Bitfields for Intel 82434/82437/82439HX Programmable Attribute Map Register:
Bit(s)	Description	(Table 0856)
 7	reserved
 6	cache enable (region 1)
 5	write enable (region 1)
 4	read enable (region 1)
 3	reserved
 2	cache enable (region 0)
 1	write enable (region 0)
 0	read enable (region 0)
Notes:	each programmable attribute map register controls two memory
	  regions at the top of the first megabyte of memory
	for the Intel 82441FX, bits 6 and 2 are reserved, as cacheability is
	  set using the Pentium Pro's MTRR registers (see MSR 000000FEh)
	Intel 82434/82437FX/82437MX/82437VX/82439HX/82441FX PAM
	  registers/regions:
		PAM0 low: reserved [*]
		PAM0 hi:  segment F000-FFFF
		PAM1 low: segment C000-C3FF
		PAM1 hi:  segment C400-C7FF
		PAM2 low: segment C800-CBFF
		PAM2 hi:  segment CC00-CFFF
		PAM3 low: segment D000-D3FF
		PAM3 hi:  segment D400-D7FF
		PAM4 low: segment D800-DBFF
		PAM4 hi:  segment DC00-DFFF
		PAM5 low: segment E000-E3FF
		PAM5 hi:  segment E400-E7FF
		PAM6 low: segment E800-EBFF
		PAM6 hi:  segment EC00-EFFF
	[*] on the 82434 (and possibly other Intel chipsets), the low nybble of
	  PAM0 controls segment 8000-9FFF
SeeAlso: #0815,#0846,#0843,#0879,#0844,#0845

Bitfields for Intel 82437VX DRAM Row Type register:
Bit(s)	Description	(Table 0857)
 7,3	row 3 type
 6,2	row 2 type
 5,1	row 1 type
 4,0	row 0 type
	00 SPM DRAM
	01 EDO DRAM
	10 SDRAM
	11 reserved
SeeAlso: #0846,#0856

Bitfields for Intel 82437FX/82437MX DRAM Row Type register:
Bit(s)	Description	(Table 0858)
 7-4	reserved
 3-0	DRAM Row N is EDO instead of page-mode DRAM
SeeAlso: #0844,#0845

Bitfields for Intel 82437VX PCI TRDY timer:
Bit(s)	Description	(Table 0859)
 7-3	reserved
 2-0	TRDY timeout value
	000 2 PCICLKs
	001 4 PCICLKs
	010 6 PCICLKs
	011 8 PCICLKs
	1xx reserved
SeeAlso: #0846,#0860

Bitfields for Intel 82437/82439HX System Management RAM control register:
Bit(s)	Description	(Table 0860)
 7	reserved
 6	SMM Space Open
	=1 make SMM DRAM visible even when not in SMM if bit 4 =0
 5	SMM Space Closed
	=1 no data references permitted to SMM DRAM even in SMM
 4	SMM Space Locked
	=1 force bits 4 and 6 to become read-only; and clear bit 6
 3	SMRAM Enable
	=1 128K DRAM are accessible for use at A000 while in SMM
 2-0	SMM Space Base Segment
	010 segment A000-BFFF
	100 segment C000-CFFF (82437MX only)
	other reserved
Note:	bits 5 and 6 must never both be set at the same time
SeeAlso: #0846,#0843,#0861,#0844,#0845

Bitfields for Intel 82437VX Shared Memory Buffer control register:
Bit(s)	Description	(Table 0861)
 7-2	reserved
 1	enable shared memory buffer
 0	redirect shared memory buffer access
	=0 treat SMB area as a hole in system DRAM
SeeAlso: #0846,#0860,#0862

Bitfields for Intel 82437VX Graphics Controller Latency Timer:
Bit(s)	Description	(Table 0862)
 7-6	reserved
 5-3	GC latency for PCI reads (in 4 HCLK multiples) (default=100)
 2-0	GC latency for CPU and PCI writes (in 4 HCLK multiples) (default=011)
SeeAlso: #0846,#0861

Bitfields for Intel 82439HX Error Command register:
Bit(s)	Description	(Table 0863)
 7	SERR# duration
	=0 one PCI clock
	=1 until error flags are cleared
 6-3	reserved
 2	force bad parity on multiple-bit uncorrectable error
 1	assert SERR# on multiple-bit uncorrectable error
 0	assert SERR# on single-bit correctable error
SeeAlso: #0843,#0864

Bitfields for Intel 82439HX Error Status register:
Bit(s)	Description	(Table 0864)
 7-5	DRAM row associated with multi-bit error
 4	multi-bit uncorrectable error occurred (write 1 bit to clear)
 3-1	DRAM row associated with single-bit correctable error
 0	single-bit correctable error occurred (write 1 bit to clear)
SeeAlso: #0843,#0863

Format of PCI Configuration for Intel 82371FB/82371SB Function 0 (ISA Bridge):
Offset	Size	Description	(Table 0865)
 00h 64 BYTEs	header (see #0790)
		(vendor ID 8086h, device ID 122Eh/7000h)
		(revision ID 00h = 82371SB step A-1)
		(revision ID 01h = 82371SB step B-0)
 40h 12 BYTEs	reserved
 4Ch	BYTE	ISA I/O Controller Recovery Timer (see #0840)
 4Dh	BYTE	reserved
 4Eh	BYTE	X-Bus Chip Select Enable (see #0842)
 4Fh	BYTE	(82371SB) X-Bus Chip Select Enable High
		bit 0: I/O APIC enabled
 4Fh	BYTE	(82371FB) reserved
 50h 16 BYTEs	reserved
 60h  4 BYTEs	PCI IRQ Route Control (see #0829)
 64h  5 BYTEs	reserved
 69h	BYTE	top of memory (see #0868)
 6Ah	WORD	miscellaneous status (see #0869)
 6Ch  4 BYTEs	reserved
 70h	BYTE	motherboard IRQ Route Control 0 (see #0870)
 71h	BYTE	(82371FB) motherboard IRQ Route Control 1 (see #0870)
 72h  4 BYTEs	reserved
 76h  2 BYTEs	motherboard DMA control (see #0871)
 78h	WORD	programmable chip select control (see #0872)
 7Ah  6 BYTEs	reserved
 80h	BYTE	(82371SB) APIC Base Address Relocation (see #0831)
 81h	BYTE	reserved
 82h	BYTE	(82371SB) Deterministic Latency Control (see #0873)
 83h 29 BYTEs	reserved
 A0h	BYTE	SMI Control (see #0874)
 A1h	BYTE	reserved
 A2h	WORD	SMI Enable (see #0833)
 A4h	DWORD	System Event Enable (SEE) (see #0834)
 A8h	BYTE	Fast-Off Timer (in minutes, PCICLKs, or milliseconds)
		value is count less one; timer must be stopped before
		  changing its value
 A9h	BYTE	reserved
 AAh	WORD	SMI Request (see #0835)
 ACh	BYTE	Clock Scale STPCLK# Low Timer
		STPCLK# stays low for 1+1056*(value+1) PCICLKs
 ADh	BYTE	reserved
 AEh	BYTE	Clock Scale STPCLK# High Timer
		STPCLK# stays high for 1+1056*(value+1) PCICLKs
 AFh 81 BYTEs	reserved
SeeAlso: #0866,#0867,#0817,#0836,#0846,#0843

Format of PCI Configuration for Intel 82371FB/82371SB Function 1 (IDE):
Offset	Size	Description	(Table 0866)
 00h 64 BYTEs	header (see #0790)
		(vender ID 8086h, device ID 1230h/7010h)
 20h	DWORD	Bus Master Interface Base Address
		(see PORT xxxxh"Intel 82371SB")
 40h	WORD	IDE timing modes, primary channel (see #0875)
 42h	WORD	IDE timing modes, secondary channel (see #0875)
 44h	BYTE	(82371SB) slave IDE timing register (see #0876)
 45h 187 BYTEs	reserved
SeeAlso: #0865,#0867,PORT xxxxh"Intel 82371SB"

Format of PCI Configuration for Intel 82371SB Function 2 (USB):
Offset	Size	Description	(Table 0867)
 00h 64 BYTEs	header (see #0790)
		(vendor ID 8086h, device ID 7020h)
 20h	DWORD	I/O space base address
		(see PORT xxxxh"Intel 82371SB")
 40h 32 BYTEs	reserved
 60h	BYTE	Serial Bus Specification release number
		00h pre-release 1.0
		10h Release 1.0
 61h  9 BYTEs	reserved
 6Ah	WORD	miscellaneous status (see #0877)
 6Ch 84 BYTEs	reserved
 C0h	WORD	legacy support (see #0878)
 C2h 62 BYTEs	reserved
SeeAlso: #0865,#0866,PORT xxxxh"Intel 82371SB"

Bitfields for Intel 82371FB/82371SB top of memory register:
Bit(s)	Description	(Table 0868)
 7-4	top of ISA memory (in megabytes, less 1; i.e. 0001 = 2M)
 3	ISA/DMA lower BIOS forwarding enable
 2	(82371SB) enable A000/B000 segment forwarding to PCI bus
 1	enable forwarding ISA/DMA 512K-640K region to PCI bus
 0	reserved
SeeAlso: #0865,#0869

Bitfields for Intel 82371FB/82371SB miscellaneous status register:
Bit(s)	Description	(Table 0869)
 15	(82371SB) enable SERR# on delayed transaction
	write 1 to clear this bit
 14-8	reserved
 7	(82371SB) NB Retry Enable
 6	(82371SB) EXTSMI# Mode Enable
	allow special SERR# protocol between PCI bridge and 82371
 5	reserved
 4	(82371SB) enable USB
	disable USB's master enable and I/O decode enable prior to
	 clearing this bit!
 3	reserved
 2	(82371FB) PCI Header Type Bit enable
	=1 report multifunction device in PCI configuration header
 1	(82371FB) internal ISA DMA/external DMA Mode status (read-only)
	=0 normal DMA operation
 0	(82371FB) ISA Clock Divisor status (read-only)
	(82371SB) ISA Clock Divisor (read-write)
	=1 SYSCLK clock divisor is 3
	=0 SYSCLK clock divisor is 4
SeeAlso: #0865,#0868

Bitfields for Intel 82371FB/82371SB motherboard IRQ Route Control:
Bit(s)	Description	(Table 0870)
 7	disable IRQ routing
 6	enable MIRQx/IRQx sharing
 5	(82371SB) enable IRQ0 output
 4	reserved (0)
 3-0	ISA IRQ number to which to route the PCI IRQ
Note:	IRQs 0-2, 8, and 13 are reserved
SeeAlso: #0865,#0868,#0871

Bitfields for Intel 82371FB/82371SB motherboard DMA control:
Bit(s)	Description	(Table 0871)
 7	type F and DMA buffer enable
 6-4	reserved
 3	(82371FB) disable motherboadr DMA channel
 2-0	DMA channel number
	(82371FB) Type F and Motherboard DMA
	(82371SB) Type F DMA
SeeAlso: #0865,#0870

Bitfields for Intel 82371FB/83271SB programmable chip select control register:
Bit(s)	Description	(Table 0872)
 15-2	I/O address which will assert PCS# signal
 1-0	PCS address mask
	00 four bytes
	01 eight contiguous bytes
	10 disabled
	11 sixteen contiguous bytes
SeeAlso: #0865,#0871,#0873

Bitfields for Intel 82371SB Deterministic Latency Control register:
Bit(s)	Description	(Table 0873)
 7-4	reserved
 3	enable SERR# on delayed transaction timeout
 2	enable USB passive release
 1	enable passive release
 0	enable delayed transactions
SeeAlso: #0865,#0872

Bitfields for Intel 82371FB/82371SB SMI Control Register:
Bit(s)	Description	(Table 0874)
 7-5	reserved
 4-3	Fast-Off Timer freeze/granularity selection
	00 one minute granularity (assuming 33 MHz PCICLK)
	01 disabled (frozen)
	10 one PCICLK
	11 one millisecond
 2	STPCLK# scaling enable
	=1 enable Clock Scale bytes in PCI configuration space
 1	STPCLK# signal enable
	=1 assert STPCLK# on read from PORT 00B2h
 0	SMI# Gate
	=1 enable SMI# on system management interrupt
Notes:	bit 1 is cleared either with an explicit write of 0 here, or by any
	  write to PORT 00B2h
	bit 0 does not affect the recording of SMI events, so a pending SMI
	  will cause an immediate SMI# when the bit is set
SeeAlso: #0865,#0832

Bitfields for Intel 82371FB/82371SB IDE timing modes:
Bit(s)	Description	(Table 0875)
 15	IDE decode enable
 14	(82371SB) slave IDE timing register enable (see #0876)
 13-12	IORDY# sample point
	00 five clocks after DIOx# assertion
	01 four clocks
	10 three clocks
	11 two clocks
 11-10	reserved
 9-8	recovery time between IORDY# sample point and DIOx#
	00 four clocks
	01 three clocks
	10 two clocks
	11 one clock
 7	DMA timing enable only, drive 1
 6	prefetch and posting enable, drive 1
 5	IORDY# sample point enable drive select 1
 4	fast timing bank drive select 1
 3	DMA timing enable only, drive 0
 2	prefetch and posting enable, drive 0
 1	IORDY# sample point enable drive select 0
 0	fast timing bank drive select 0
SeeAlso: #0866

Bitfields for Intel 82371SB slave IDE timing register:
Bit(s)	Description	(Table 0876)
 7-6	secondary drive 1 IORDY# sample point
	00 five clocks after DIOx# assertion
	01 four clocks
	10 three clocks
	11 two clocks
 5-4	secondary drive 1 recovery time
	00 four clocks
	01 three clocks
	10 two clocks
	11 one clock
 3-2	primary drive 1 IORDY# sample point
 1-0	primary drive 1 recovery time
SeeAlso: #0875

Bitfields for Intel 82371SB miscellaneous status:
Bit(s)	Description	(Table 0877)
 15-1	reserved
 0	USB clock selection
	=1 48 MHz
	=0 24 MHz
SeeAlso: #0867,#0878

Bitfields for Intel 82371SB legacy support register:
Bit(s)	Description	(Table 0878)
 15	A20GATE pass-through sequence ended
	write 1 to clear this bit
 14	reserved
 13	USB PIRQ enabled
 12	USR IRQ status (read-only)
 11	trap caused by write to PORT 0064h
	write 1 to clear this bit
 10	trap caused by read from PORT 0064h
	write 1 to clear this bit
 9	trap caused by write to PORT 0060h
	write 1 to clear this bit
 8	trap caused by read from PORT 0060h
	write 1 to clear this bit
 7	enable SMI at end of A20GATE Pass-Through
 6	A20GATE pass-through sequence in progress (read-only)
 5	enable A20GATE pass-through sequence
	(write PORT 64h,D1h; write 60h,xxh; read 64h; write 64h,FFh)
 4	enable trap/SMI on USB IRQ
 3	enable trap/SMI on PORT 0064h write
 2	enable trap/SMI on PORT 0064h read
 1	enable trap/SMI on PORT 0060h write
 0	enable trap/SMI on PORT 0060h read
SeeAlso: #0867,#0877

Format of PCI Configuration Data for Intel 82441FX:
Offset	Size	Description	(Table 0879)
 00h 64 BYTEs	header (see #0790)
		(vendor ID 8086h, device ID 1237h) (see #0785)
 40h 16 BYTEs	reserved
 50h	WORD	PMC Configuration (see #0880)
 52h	BYTE	deturbo counter control
		when deturbo mode is selected (see PORT 0CF9h), the chipset
		  places a hold on the memory bus for a fraction of the
		  time inversely proportional to the value in this register
		  (i.e. C0h = 1/4, 80h = 1/2, 40h = 3/4, 20h = 7/8, etc.)
 53h	BYTE	DBX buffer control (see #0881)
 54h	BYTE	auxiliary control (see #0882)
 55h	WORD	DRAM Row Type (see #0883)
 57h	BYTE	DRAM Control (see #0884)
 58h	BYTE	DRAM Timing (see #0885)
 59h  7 BYTEs	Programmable Attribute Map registers 0-6 (see #0856)
 60h  8 BYTEs	DRAM Row Buondary registers 0-7
		each register N indicates cumulative amount of memory in rows
		  0-N (each 64 bits wide), in 8M units
 68h	BYTE	Fixed DRAM Hole Control
 69h  7 BYTEs	reserved
 70h	BYTE	Multi-Transaction Timer
		number of PCLKs guaranteed to the current agent before the
		  82441 will grant the bus to another PCI agent on request
 71h	BYTE	CPU Latency Timer (see #0886)
 72h	BYTE	System Management RAM control (see #0860)
 73h 29 BYTEs	reserved
 90h	BYTE	Error Command (see #0887)
 91h	BYTE	Error Status (see #0888)
 92h	BYTE	reserved
 93h	BYTE	Turbo Reset Control (see #0889)
 94h 108 BYTEs	reserved
SeeAlso: #0843,#0846

Bitfields for Intel 82441FX PMC Configuration Register:
Bit(s)	Description	(Table 0880)
 15	WSC Protocol Enable
 14	Row Select/Extra Copy select (read-only)
	=1 pins on PMC configured as two additional row selects (6/7)
	=0 extra copy of two lowest memory address bits enabled
 13-10	reserved
 9-8	host frequence select
	00 reserved
	01 60 MHz
	10 66 MHz
	11 reserved
 7	reserved
 6	ECC/Parity TEST enable
 5-4	DRAM Data Integrity Mode
	00 no parity/ECC
	01 parity generated and checked
	10 ECC generated and checked, correction disabled
	10 ECC generated and checked, correction enabled
 3	reserved
 2	In-Order Queue size (0=one, 1=four)
 1-0	reserved
SeeAlso: #0879,#0881

Bitfields for Intel 82441FX DBX buffer control register:
Bit(s)	Description	(Table 0881)
 7	enable delayed transactions
 6	enable CPU-to-PCI IDE posting
 5	enable USWC Write Post during I/O Bridge access
 4	disable PCI Delayed Transaction timer
 3	enable CPU-to-PCI Write Post
 2	enable PCI-to-DRAM pipeline
 1	enable PCI Burst Write Combining
 0	enable Read-Around-Write
SeeAlso: #0879,#0880

Bitfields for Intel 82441FX auxiliary control register:
Bit(s)	Description	(Table 0882)
 7	enable RAS precharge
 6-2	reserved
 1	Lower Memory Address Buffer Set A
	=0 8mA
	=1 12mA
 0	reserved
SeeAlso: #0879

Bitfields for Intel 82441FX DRAM Row Type register:
Bit(s)	Description	(Table 0883)
 15-14	row 7 DRAM type
 13-12	row 6 DRAM type
 11-10	row 5 DRAM type
 9-8	row 4 DRAM type
 7-6	row 3 DRAM type
 5-4	row 2 DRAM type
 3-2	row 1 DRAM type
 1-0	row 0 DRAM type
	00 fast page-mode DRAM
	01 EDO DRAM
	10 BEDO DRAM
	11 empty row
SeeAlso: #0879,#0884

Bitfields for Intel 82441FX DRAM Control register:
Bit(s)	Description	(Table 0884)
 7	reserved
 6	enable DRAM Refresh Queue
 5	enable DRAM EDO Auto-Detect Mode
 4	DRAM Refresh Type
	=0 CAS before RAS
	=1 RAS only
 3	reserved
 2-0	DRAM refresh rate
	000 disabled
	001 normal (as set by PMCCFG register)
	01x reserved
	1xx reserved
	111 fast refresh (every 32 host clocks)
SeeAlso: #0879,#0883,#0885

Bitfields for Intel 82441FX DRAM Timing register:
Bit(s)	Description	(Table 0885)
 7	reserved
 6	enable WCBR Mode
 5-4	DRAM Read Burst Timing
		BEDO	EDO	FPM
	00	x333	x444	x444
	01	x222	x333	x444
	10	x222	x222	x333
	11	res.	res.	res.
 3-2	DRAM Write Burst Timing
		(B)EDO	FPM
	00	x444	x444
	01	x333	x444
	10	x333	x333
	11	x222	x333
 1	RAS-to-CAS delay
	=1 one clock
	=0 zero clocks
 0	insert one MA Wait State
SeeAlso: #0879,#0884

Bitfields for Intel 82441FX CPU Latency Timer register:
Bit(s)	Description	(Table 0886)
 7-5	reserved
 4-0	snoop stall count value
SeeAlso: #0879

Bitfields for Intel 82441FX Error Command register:
Bit(s)	Description	(Table 0887)
 7-5	reserved
 4	enable SERR# on receiving Target Abort
 3	enable SERR# on PCI Parity Error (PERR#)
 2	reserved
 1	enable SERR# on receiving multiple-bit ECC/Parity error
 0	enable SERR# on receiving single-bit ECC error
SeeAlso: #0879,#0888

Bitfields for Intel 82441FX Error Status register:
Bit(s)	Description	(Table 0888)
 7-5	DRAM row causing first multi-bit error (read-only)
 4	multiple-bit uncorrectable error detected
	write 1 to this bit to clear it
 3-1	DRAM row causing first single-bit error (read-only)
 0	single-bit correctable ECC error detected
	write 1 to this bit to clear it
SeeAlso: #0879,#0887

Bitfields for Intel 82441FX Turbo Reset Control register:
Bit(s)	Description	(Table 0889)
 7-4	reserved
 3	enable BIST on hard reset
 2	reset CPU
 1	reset mode
	0 soft reset
	1 hard reset
 0	deturbo mode
SeeAlso: #0879,PORT 0CF9h

Format of PC Technology RZ-1000 EIDE controller:
Offset	Size	Description	(Table 0890)
 00h 64 BYTEs	header (see #0790)
		(vendor ID 1042h, device ID 1000h)
 10h	DWORD	base address for controller I/O registers
		(set to 01F1h for primary controller, 0171h for secondary)
 14h	DWORD	base address for controller digital I/O port
		(set to 03F5h for primary, 0375h for secondary)
 40h	DWORD	???
		bits 7-1: ???
		bit 16: ???
 44h	DWORD	???
 48h  8 BYTEs	???
 50h 176 BYTEs	unused???

Format of OpenHCI Host Controller memory-mapped registers:
Offset	Size	Description	(Table 0891)
 00h	DWORD	"HcRevision"		OpenHCI revision (see #0892)
 04h	DWORD	"HcControl"		HC operating modes (see #0893)
 08h	DWORD	"HcCommandStatus"	command/status (see #0894)
 0Ch	DWORD	"HcInterruptStatus"	interrupt status (see #0895)
 10h	DWORD	"HcInterruptEnable"	enable interrupts (see #0896)
 14h	DWORD	"HcInterruptDisable"	disable interrupts (see #0896)
 18h	DWORD	"HcHCCA"		HC Communications Area (see #0897)
 1Ch	DWORD	"HcPeriodCurrentED"	Endpoint Descriptor addr (see #0898)
 20h	DWORD	"HcControlHeadED"	Control Endpoint Descriptor (see #0899)
 24h	DWORD	"HcControlCurrentED"	Control Endpoint Descriptor (see #0899)
 28h	DWORD	"HcBulkHeadED"		Bulk Endpoint Descriptor (see #0900)
 2Ch	DWORD	"HcBulkCurrentED"	Bulk Endpoint Descriptor (see #0900)
 30h	DWORD	"HcDoneHead"		last completed Xfer Descr. (see #0901)
 34h	DWORD	"HcFmInterval"		Frame bit-time interval (see #0902)
 38h	DWORD	"HcFmRemaining"		bit time remaining in Frame (see #0903)
 3Ch	DWORD	"HcFmNumber"		Frame Number (bits 15-0)
 40h	DWORD	"HcPeriodicStart"	earliest time to start periodic list
					(bits 13-0)
 44h	DWORD	"HcLSThreshold"		threshold for Low Speed transaction
					(bits 11-0)
 48h	DWORD	"HcRhDescriptorA"	Root Hub Descriptor A (see #0904)
 4Ch	DWORD	"HcRhDescriptorB"	Root Hub Descriptor B (see #0905)
 50h	DWORD	"HcRhStatus"		Root Hub status (see #0906)
 54h  N DWORDs	"HCRhPortStatus[1-N]"	Root Hub port status N (see #0907)
Note:	OpenHCI reserves a full 4K page of the systems address space for its
	  memory-mapped registers
SeeAlso: #0790,#0794,#F059

Bitfields for OpenHCI "HcRevision" register:
Bit(s)	Description	(Table 0892)
 31-8	reserved
 7-0	BCD OpenHCI specification number (10h = 1.0, 11h = 1.1)
Note:	this register is read-only
SeeAlso: #0891,#0893

Bitfields for OpenHCI "HcControl" register:
Bit(s)	Description	(Table 0893)
 31-11	reserved
 10	RWE	enable Remote Wakeup feature
 9	RWC	controller supports Remote Wakeup signalling
 8	IR	Interrupt Routing
		0 normal host bus interrupt
		1 System Managment Interrupt
 7-6	HCFS	USB Host Controller Functional State
		00 USBReset
		01 USBResume
		10 USBOperational
		11 USBSuspend
 5	BLE	enable Bulk List processing in next frame
 4	CLE	enable Control List processing in next frame
 3	IE	enable Isochronous ED processing
 2	PLE	enable processing of Periodic List in next frame
 1-0	CBSR	Control Bulk Service Ratio
		00  1:1 Control EDs:Bulk EDs served
		01  2:1
		10  3:1
		11  4:1
SeeAlso: #0891,#0892,#0894

Bitfields for OpenHCI "HcCommandStatus" register:
Bit(s)	Description	(Table 0894)
 31-18	reserved
 17-16	SOC	scheduling-overrun count
 15-4	reserved
 3	OCR	ownership change request is pending
 2	BLF	bulk list contains TDs
 1	CLF	control list contains TDs
 0	HCR	host controller software reset
Note:	writing a 1 bit sets the corresponding bit, while a 0 bit leaves the
	  corresponding bit unchanged
SeeAlso: #0891,#0892,#0895

Bitfields for OpenHCI "HcInterruptStatus" register:
Bit(s)	Description	(Table 0895)
 31	reserved (0)
 30	OC	ownership change
 29-7	reserved
 6	RHSC	Root Hub status changed
 5	FNO	frame number overflowed
 4	UE	unrecoverable error
 3	RD	resume detected
 2	SF	start of frame
 1	WDH	writeback done
 0	SO	scheduling overrun
Note:	writing a 1 bit clears the corresponding bit of the register
SeeAlso: #0891,#0892,#0894,#0896

Bitfields for OpenHCI "HcInterruptEnable" and "HcInterruptDisable" registers:
Bit(s)	Description	(Table 0896)
 31	MIE	master interrupt enable
 30	OC	ownership change
 29-7	reserved
 6	RHSC	Root Hub status change
 5	FNO	frame number overflow
 4	UE	unrecoverable error
 3	RD	Resume Detect
 2	SF	start of frame
 1	WDH	HcDoneHead writeback
 0	SO	scheduling overrun
Note:	writing a 1 bit to HcInterruptEnable enables the corresponding
	  interrupt, while writing a 1 bit to HcInterruptDisable disables it;
	  zero bits are ignored.  On reading, both registers return the
	  same value, which reflects the currently enabled interrupts
SeeAlso: #0891

Bitfields for OpenHCI "HcHCCA" register:
Bit(s)	Description	(Table 0897)
 31-8	physical address of Host Controller Communications Area (bits 31-8)
 7-0	reserved (0)
Note:	the required alignment for the HCCA may be determined by writing
	  FFFFFFFFh to this register and determining the number of low-order
	  zero bits
SeeAlso: #0891,#0898,#0899

Bitfields for OpenHCI "HcPeriodCurrentED" register:
Bit(s)	Description	(Table 0898)
 31-4	physical address of current Isochronous/Interrupt Endpoint Descriptor
	  (bits 31-4)
 3-0	reserved (0)
SeeAlso: #0891,#0897,#0899

Bitfields for OpenHCI "HcControlHeadED"/"HcControlCurrentED" register:
Bit(s)	Description	(Table 0899)
 31-4	physical address of first/current Endpoint Descriptor (bits 31-4)
 3-0	reserved (0)
Note:	HcControlCurrentED is set to 0000000h to indicate the end of the
	  Control list
SeeAlso: #0891,#0897,#0898

Bitfields for OpenHCI "HcBulkHeadED"/"HcBulkCurrentED" register:
Bit(s)	Description	(Table 0900)
 31-4	physical address of first/current Endpoint Descriptor in the Bulk
	  list (bits 31-4)
 3-0	reserved (0)
Note:	HcBulkCurrentED is set to 0000000h to indicate the end of the Bulk
	  list
SeeAlso: #0891,#0897,#0899

Bitfields for OpenHCI "HcDoneHead" register:
Bit(s)	Description	(Table 0901)
 31-4	physical address of most-recently completed Transfer Descriptor added
	  to the Done queue (bits 31-4)
 3-0	reserved (0)
SeeAlso: #0891,#0898,#0900

Bitfields for OpenHCI "HcFmInterval" register:
Bit(s)	Description	(Table 0902)
 31	"FIT"	toggled each time a new value is loaded into bits 13-0
 30-16	"FSMPS"	largest data packet in bits
 15-14	reserved
 13-0	"FI"	Frame Interval (between to consecutive SOFs)
SeeAlso: #0891,#0903

Bitfields for OpenHCI "HcFmRemaining" register:
Bit(s)	Description	(Table 0903)
 31	"FRT"	loaded from bit 31 of HcFmInterval whenever FR reaches 0
 30-14	reserved
 13-0	"FR"	FrameRemaining -- bits times left in current frame
SeeAlso: #0891,#0902

Bitfields for OpenHCI "HcRhDescriptorA" register:
Bit(s)	Description	(Table 0904)
 31-24	"POTPGT" power-on to power-good time in 2ms units
 23-13	reserved
 12	"NOCP"	no over-current protection supported
 11	"OCPM"	over-current status reported per-port
 10	"DT"	device type - is root hub compound device?
 9	"NPS"	NoPowerSwitching -- ports are always powered up
 8	"PSM"	power-switching mode -- if set, each port powered individually
 7-0	"NDP"	number of downstream ports
SeeAlso: #0891,#0905,#0906

Bitfields for OpenHCI "HcRhDescriptorB" register:
Bit(s)	Description	(Table 0905)
 31-16	"PPCM"	PortPowerControlMask -- bitmask of ports NOT affected by global
		  power control (bit 16 [port #0] is reserved)
 15-0	"DR"	DeviceRemovable -- bitmap of removable devices
SeeAlso: #0891,#0904,#0906

Bitfields for OpenHCI "HcRhStatus" register:
Bit(s)	Description	(Table 0906)
 31	"CRWE"	Clear Remote Wakeup Enable
		write 1 to disable remote wakeup (writes of 0 ignored)
 30-18	reserved
 17	"OCIC"	OverCurrent Indicator Change
		write 1 to clear
 16   R	"LPSC"	Local Power Status Change
      W		Set Global Power mode (write 1; writes of 0 ignored)
 15	"DRWE"	Device Remote Wakeup Enable
		write 1 to enable (writes of 0 ignored)
		read to get current status
 14-2	reserved
 1	"OCI"	OverCurrent Indicator
 0    R "LPS"	LocalPowerStatus (always 0 for Root Hub)
      W		write 1 to turn off power to all ports/ports with clear
		  PortPowerControlMask bits
SeeAlso: #0891,#0904,#0905,#0907

Bitfields for OpenHCI "HcRhPortStatusN" register:
Bit(s)	Description	(Table 0907)
 31-21	reserved
 20	"PRSC"	Port Reset Status Change (write '1' to clear)
 19	"OCIC"	Port OverCurrent Indiactor Change (write '1' to clear)
 18	"PSSC"	Port Suspend Status Change (write '1' to clear)
 17	"PESC"	Port Enable Status Change (write '1' to clear)
 16	"CSC"	Connect Status Change (write '1' to clear)
 15-10	reserved
 9    R	"LSDA"	Low Speed Device Attached
      W		clear port power by writing '1'
 8    R	"PPS"	Port Power Status
      W		set port power by writing '1'
 7-5	reserved
 4    R	"PRS"	Port Reset Status
      W		set port reset by writing '1'
 3    R	"POCI"	Port OverCurrent Indicator
      W		clear suspend status by writing '1'
 2    R	"PSS"	Port Suspend Status
      W		set port suspend by writing '1'
 1    R "PES"	Port Enable Status
      W		set port enable by writing '1'
 0    R "CCS"	current connect status
      W		clear port enable by writing '1'
SeeAlso: #0891,#0904,#0905,#0906
--------X-1AB10B-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - WRITE CONFIGURATION BYTE
	AX = B10Bh
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
	CL = byte to write
Return: CF clear if successful
	CF set on error
	AH = status (00h,87h) (see #0646)
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B108h,AX=B10Ch,AX=B10Dh,AX=B18Bh,INT 2F/AX=1684h/BX=304Ch
--------X-1AB10C-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - WRITE CONFIGURATION WORD
	AX = B10Ch
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (multiple of 2 less than 0100h)
	CX = word to write
Return: CF clear if successful
	CF set on error
	AH = status (00h,87h) (see #0646)
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B109h,AX=B10Bh,AX=B10Dh,AX=B18Ch,INT 2F/AX=1684h/BX=304Ch
--------X-1AB10D-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - WRITE CONFIGURATION DWORD
	AX = B10Dh
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (multiple of 4 less than 0100h)
	ECX = dword to write
Return: CF clear if successful
	CF set on error
	AH = status (00h,87h) (see #0646)
	EAX, EBX, ECX, and EDX may be modified
	all other flags (except IF) may be modified
Notes:	this function may require up to 1024 byte of stack; it will not enable
	  interrupts if they were disabled before making the call
	the meanings of BL and BH on entry were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B10Ah,AX=B10Bh,AX=B10Ch,AX=B18Dh,INT 2F/AX=1684h/BX=304Ch
--------X-1AB10EBX0000-----------------------
INT 1A - Intel PCI BIOS v2.1+ - GET IRQ ROUTING INFORMATION
	AX = B10Eh
	BX = 0000h
	DS = segment/selector for PCI BIOS data
	    (real mode: F000h; 16-bit PM: physical 000F0000h; 32-bit PM: as
	    specified by BIOS32 services directory)
	ES:(E)DI -> IRQ routing table header (see #0924 at AX=B406h)
Return: CF clear if successful
	    AH = 00h
	    BX = bit map of IRQ channels permanently dedicated to PCI
	    WORD ES:[DI] = size of returned data
	CF set on error
	    AH = error code (59h) (see #0908)
	    WORD ES:[DI] = required size of buffer
SeeAlso: AX=B10Fh,AX=B406h,INT 2F/AX=1684h/BX=304Ch
--------X-1AB10F-----------------------------
INT 1A - Intel PCI BIOS v2.1+ - SET PCI IRQ
	AX = B10Fh
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	CH = number of IRQ to connect
	CL = number of interrupt pin (0Ah=INTA# to 0Dh=INTD#) to reprogram
	DS = segment/selector for PCI BIOS data
	    (real mode: F000h; 16-bit PM: physical 000F0000h; 32-bit PM: as
	    specified by BIOS32 services directory)
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = error code (59h) (see #0908)
Note:	assumes that the calling application has determined the IRQ routing
	  topology (see AX=B10Eh), has ensured that the selected IRQ will not
	  cause a conflict, and will update the interrupt line configuration
	  register on all devices which currently use the IRQ line
SeeAlso: AX=B10Eh
--------X-1AB181-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - INSTALLATION CHECK (32-bit)
	AX = B181h
Return: as for AX=B101h
SeeAlso: AX=B101h
--------X-1AB182-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - FIND PCI DEVICE (32-bit)
	AX = B182h
	CX = device ID (see #0652,#0658,#0659,#0785,#0787)
	DX = vendor ID (see #0649 at AX=B102h)
	SI = device index (0-n)
Return: as for AX=B102h
SeeAlso: AX=B102h
--------X-1AB183-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - FIND PCI CLASS CODE (32-bit)
	AX = B183h
	ECX = class code (bits 23-0)
	SI = device index (0-n)
Return: as for AX=B103h
SeeAlso: AX=B103h
--------X-1AB186-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - PCI BUS-SPECIFIC OPERATIONS (32-bit)
	AX = B186h
	BH = bus number
	EDX = Special Cycle data
Return: as for AX=B106h
Note:	the meanings of BL and BH on return were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B106h
--------X-1AB188-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - READ CONFIGURATION BYTE (32-bit)
	AX = B188h
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
Return: as for AX=B108h
Note:	the meanings of BL and BH on return were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B108h,AX=B189h,AX=B18Ah
--------X-1AB189-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - READ CONFIGURATION WORD (32-bit)
	AX = B189h
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
Return: as for AX=B109h
Note:	the meanings of BL and BH on return were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B109h,AX=B188h,AX=B18Ah
--------X-1AB18A-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - READ CONFIGURATION DWORD (32-bit)
	AX = B18Ah
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
Return: as for AX=B10Ah
Note:	the meanings of BL and BH on return were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B10Ah,AX=B188h,AX=B189h
--------X-1AB18B-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - WRITE CONFIGURATION BYTE (32-bit)
	AX = B18Bh
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (0000h-00FFh)
	CL = byte to write
Return: as for AX=B10Bh
Note:	the meanings of BL and BH on return were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B10Bh,AX=B18Ch,AX=B18Dh
--------X-1AB18C-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - WRITE CONFIGURATION WORD (32-bit)
	AX = B18Ch
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (multiple of 2 less than 0100h)
	CX = word to write
Return: as for AX=B10Ch
Note:	the meanings of BL and BH on return were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B10Ch,AX=B18Bh,AX=B18Dh
--------X-1AB18D-----------------------------
INT 1A - Intel PCI BIOS v2.0c+ - WRITE CONFIGURATION DWORD (32-bit)
	AX = B18Dh
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	DI = register number (multiple of 4 less than 0100h)
	ECX = dword to write
Return: as for AX=B10Dh
Note:	the meanings of BL and BH on return were exchanged between the initial
	  drafts of the specification and final implementation
SeeAlso: AX=B10Dh,AX=B18Bh,AX=B18Ch
--------X-1AB18EBX0000-----------------------
INT 1A - Intel PCI BIOS v2.1+ - GET IRQ ROUTING INFORMATION (32-bit)
	AX = B18Eh
	BX = 0000h
	DS = segment/selector for PCI BIOS data
	    (real mode: F000h; 16-bit PM: physical 000F0000h; 32-bit PM: as
	    specified by BIOS32 services directory)
	ES:(E)DI -> IRQ routing table header (see #0924 at AX=B406h)
Return: CF clear if successful
	    AH = 00h
	    BX = bit map of IRQ channels permanently dedicated to PCI
	    WORD ES:[DI] = size of returned data
	CF set on error
	    AH = error code (59h) (see #0908)
	    WORD ES:[DI] = required size of buffer
SeeAlso: AX=B10Fh,AX=B406h,INT 2F/AX=1684h/BX=304Ch
--------X-1AB18F-----------------------------
INT 1A - Intel PCI BIOS v2.1+ - SET PCI IRQ (32-bit)
	AX = B18Fh
	BH = bus number
	BL = device/function number (bits 7-3 device, bits 2-0 function)
	CH = number of IRQ to connect
	CL = number of interrupt pin (0Ah=INTA# to 0Dh=INTD#) to reprogram
	DS = segment/selector for PCI BIOS data
	    (real mode: F000h; 16-bit PM: physical 000F0000h; 32-bit PM: as
	    specified by BIOS32 services directory)
Return: CF clear if successful
	    AH = 00h
	CF set on error
	    AH = error code (59h) (see #0908)
Note:	assumes that the calling application has determined the IRQ routing
	  topology (see AX=B10Eh), has ensured that the selected IRQ will not
	  cause a conflict, and will update the interrupt line configuration
	  register on all devices which currently use the IRQ line
SeeAlso: AX=B10Eh
--------!---Section--------------------------
