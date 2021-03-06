/***********************************************************************
*       ���� TERM.C
*
*	������ �ନ����
*
* �맮�:
*       term [���� [������� [��⭮��� [����� [�⮯]]]]]
*       ����            - ����� ����. �� 㬮�砭�� 1.
*       �������        - ��᫮ �� 50 �� 115200. �� 㬮�砭�� 2400
*       ��⭮���        - ���� �� ᨬ����� N, O, E, M ��� S ���
*                               N - ��� ����஫� (NONE)
*                               O - �㬬� ��⮢ ���⭠� (ODD)
*                               E - �㬬� ��⮢ �⭠� (EVEN)
*                               M - ��� 7 �ᥣ�� 1 (MARK)
*                               S - ��� 7 �ᥣ�� 0 (SPACE)
*			  �� 㬮�砭�� ����஫� �� �⭮�� ���������.
*       �����   - �᫮ ���ଠ樮���� ��� � ����. �� 㬮�砭�� 8.
*       �⮯    - �᫮ �⮯���� ���, 1 ��� 2. �� 㬮�砭�� 1.
*
*       ��������� Microsoft C 5.1
*/

#include <conio.h>      /* ��� ࠡ��� � ���᮫��            */
#include <graph.h>      /* ���⨯� ����᪨� �㭪権    */
#include <stdlib.h>     /* �⠭����� �㭪樨              */
#include <dos.h>        /* ��।������ FP_OFF � FP_SEG      */

#define USAGE   "term [���� [������� [��⭮��� [����� [�⮯]]]]]"

/*  ���饭�� ॣ���஢ �⭮�⥫쭮 ����		    */
#define LCR	3	/* ������� �ࠢ����� ������	    */
#define MCR	4	/* ������� �ࠢ����� �������	    */
#define IER	1	/* ������� �����䨪�樨 ���뢠��� */
#define LSR	5	/* ������� ����� �����	    */

/*  ��᪨ ��� ��⠭���� ��⮢ � ॣ�����                           */
#define GPO2    8       /* ������ ࠧ�襭�� �������� ���뢠���  */
#define R_INT   1       /* ���뢠��� �� ��室� ����              */

/* ����⠭�� �⭮��騥�� � ����஫��� ���뢠��� 8259       */
#define IMR     0x21    /* ���� ॣ���� ��᮪ ���뢠���  */
#define ICR     0x20    /* ���� ॣ���� ������            */
#define IRQ3	0xF7	/* ��᪠ ��� ࠧ�襭�� ���뢠��� �� COM2  */
#define IRQ4	0xEF	/* ��᪠ ��� ࠧ�襭�� ���뢠��� �� COM1  */
#define EOI3    0x63    /* ������ �� ����砭�� ��ࠡ�⪨ ���뢠��� �� COM2 */
#define EOI4    0x64    /* ������ �� ����砭�� ��ࠡ�⪨ ���뢠��� �� COM1 */

int eoi;     /* ������ �� ����砭�� ��ࠡ�⪨ ���뢠��� */

/*  ��᪨ ��� ��⠭���� ��⮢ � ॣ���� �ࠢ����� �������     */
#define DTR     1       /* ������ ��⮢���� �ନ����          */
#define RTS     2       /* ������ ����� �� ��।���           */

#define TRRDY	0x20	/* ��᪠ ��� ��।������ ��⮢���� ���� � ��।��
			   ����    */

/* �������� ��६����    */
int p_base;     /*  ������ ���� ��᫥����⥫쭮�� ����   */
void (interrupt far *oldvect)(); /* ���� ����� ���뢠��� 0xB/0xC */

#define BSIZE	4096		    /* ������ ����楢��� ����      */
unsigned char buf[BSIZE];    /* ����楢�� ���� 		     */
unsigned char *inptr = buf;  /* �����⥫� �� ��ࢮ� ᢮������ ����  */
unsigned char *outptr = buf; /* �����⥫� �� ���� ���뢠��� ���� */

#define ESC	0x1B	    /* ASCII ��� ᨬ���� Esc	*/

/* ���⨯� �㭪権    */
void interrupt far i_handler(void);
int portbase(short);
void setparm(long, char, int, int);
void porton(short);
void portoff(short);
int portin(unsigned char *);
int portout(unsigned char);

void main(int argc, char *argv[])
{
short port = 1;     /* ����� �ᯮ��㥬��� ����	    */
long speed = 2400;  /* ������� ��।��		    */
char parity = 'N';  /* ����஫� �� �⭮��		    */
short word = 8;     /* ��᫮ ���ଠ樮���� ��⮢	    */
short stop = 1;     /* ��᫮ �⮯���� ��⮢		    */
unsigned char ch;   /* ������ ��६�����. ������� ᨬ��� */

/* ������ ��㬥�⮢ ��������� ��ப�   */
if (argc > 6) {
	cprintf("\a%s\r\n",USAGE);
	exit(1);
	}

switch (argc) {
	case 6:     /* ��᫮ �⮯���� ��⮢         */
		stop = atoi(argv[5]);
	case 5:     /* ��᫮ ���ଠ樮���� ��⮢   */
		word = atoi(argv[4]);
	case 4:     /* ����஫� �� �⭮��         */
		parity = (char)toupper(*argv[3]);
	case 3:     /* ������� ��।��            */
		speed = atol(argv[2]);
	case 2:     /* ����� �ᯮ��㥬��� ����    */
		port = atoi(argv[1]);
	}

/* ������ ��ࠬ��஢ ࠡ���     */
if ((port < 1) || (port > 4)) {
	cprintf("\a���ࠢ���� ����� ����! '%d'\r\n%s",port,USAGE);
	exit(1);
	}

if ((speed < 50) || (speed > 115200)) {
	cprintf("\a���ࠢ��쭮 ������ ᪮����! '%ld'\r\n%s",speed,USAGE);
	exit(1);
	}

if ((word > 8) || (word < 5)) {
	cprintf("\a���ࠢ��쭮 ����� ࠧ��� ᫮��! '%d'\r\n%s",word,USAGE);
	exit(1);
	}

if ((parity != 'N') && (parity != 'O') && (parity != 'M') &&
		(parity != 'S') && (parity != 'E')) {
	cprintf("\a���ࠢ��쭮 ������ �⭮���! '%c'\r\n%s",parity,USAGE);
	exit(1);
	}

if ((stop > 2) || (stop < 1)) {
	cprintf("\a���ࠢ��쭮 ������ �᫮ �⮯���� ��⮢! '%d'\r\n%s",stop,USAGE);
	exit(1);
	}

/*  ��।������ �������� ���� ��᫥����⥫쭮�� ���� */
if (portbase(port) == -1) {
	cprintf("\a���� COM%d �������� �� ��襩 ��設�!",port);
	exit(1);
	}

/* ��⠭���� ��ࠬ��஢ ������  */
setparm(speed, parity, word, stop);

/* �����⮢�� ���� � ࠡ��    */
porton(port);

cprintf("\r\n���� %d  ������� %ld\r\n��� ��室� ������ Esc\r\n\n\n");

/*** �᭮���� 横�  ***/
while (1) {
    if (portin(&ch) > -1)   /* ���� ����� � ����? */
	putch(ch);	    /*	�⮡ࠧ�� �� ��࠭�  */

    if (kbhit())		    /* �뫮 ����⨥ ������?	*/
	if ((ch = (unsigned char)getch()) != ESC)   /* ��. ����� ࠡ���? */
	    portout(ch);	     /* ���. ���뫠�� � �����	 */
	else break;		    /* ��. �����		*/
    }

/* ��୥� ���� � ���筮� ���ﭨ�   */
portoff(port);
exit(0);
}

/*************************************************************************
*       �㭪�� portbase �롨ࠥ� ������ ���� ��������� ���� ��
*   ⠡���� ��������� ��६����� BIOS � ��⠭�������� ���������
*   ��६����� p_base.
*
*   �����頥� ���祭�� p_base ��� -1 �� ������⢨� ���� � ��設�
*/
int portbase(short pnum)
{
int far *biosdata;      /* �����⥫� � BIOS Data Area   */

FP_SEG(biosdata) = 0x40;    /* ������� 40H  */
FP_OFF(biosdata) = 0;       /* ���饭�� 0   */

p_base = *(biosdata + pnum - 1);    /* ��६ ����  */

if (!p_base)            /* 0 ����砥� ������⢨� ����  */
	return -1;      /* ᨣ��� �� �訡��             */

return p_base;
}

/*************************************************************************
*       �㭪�� setparm ��⠭�������� ��ࠬ���� ������: ᪮����,
*   ��� ����஫� �� �⭮��, �᫮ ��⮢ ������ � �᫮ �⮯���� ��⮢.
*/
void setparm(long baud, char parity, int word, int stop)
{
register unsigned divisor;   /* ����⥫� ����� ��� ��⠭���� ᪮���        */
register unsigned char parm; /* ���� ��ࠬ��஢ ��� ॣ���� �ࠢ����� ������ */

if (!p_base)    /* 0 ����砥� �, �� ������ ���� */
	return;     /* ���� �� ��⠭�����              */

parm = (unsigned char)inp(p_base + LCR);    /* �⥭�� ⥪��� ��ࠬ��஢ �����  */

/* ��⠭���� ᪮��� ������            */
/* ����⥫� = 1.8432 ��� / (baud * 16)  */
divisor = (unsigned)(115200L / baud);

outp(p_base + LCR, parm | 0x80);    /* �����⮢�� ���� � ��⠭����
										᪮���. ��� 7 � 1         */
outp(p_base + 1, divisor >> 8); /* ���訩 ���� ����⥫�    */
outp(p_base, divisor & 0xFF);   /* ����訩 ���� ����⥫�    */

/* �����⮢�� ���� ��ࠬ��஢ ��� ॣ���� �ࠢ����� ������   */
/* ��⭮��� */
parm &= 7;          /* �� 㬮�砭�� NONE    */
switch (parity) {
	case 'S':               /* SPACE    */
	case 's':
		parm |= (7 << 3);
		break;
	case 'M':               /* MARK     */
	case 'm':
		parm |= (5 << 3);
		break;
	case 'E':               /* EVEN     */
	case 'e':
		parm |= (3 << 3);
		break;
	case 'O':               /* ODD      */
	case 'o':
		parm |= (1 << 3);
		break;
	}

/* ��⠭���� �᫠ ��⮢ ������ � �᫠ �⮯���� ��⮢  */
parm |= (((stop - 1) << 2) | (word - 5));

/* ��⠭���� ��ࠬ��஢ ����� � ��४��祭�� ���� � ࠡ�稩 ०��  */
outp(p_base + LCR, parm);
}

/*************************************************************************
*       �㭪�� porton ��ॢ���� ���� � ࠡ�稩 ०��.
*   �������� ����� ���뢠���, ࠧ�蠥� ���뢠��� �� ���� �
*   ���⠢��� ᨣ���� ��⮢���� �ନ���� � ����� �� ��।���.
*/
void porton(short pnum)
{
register unsigned i_num;    /* ����� ���뢠���     */
register int c;             /* ������ ��६�����   */

if ((pnum == 2) || (pnum == 4)) /* ��।������ ����� ���뢠���    */
	i_num = 0xB;
else i_num = 0xC;

oldvect = _dos_getvect(i_num);  /* ���࠭�� ⥪�騩 ����� ���뢠���    */
_dos_setvect(i_num, i_handler); /* ������� ��ࠡ��稪 ���뢠��� �� ᢮� */

/* ����訬 ���뢠��� �� ���� */
c = inp(p_base + MCR) | GPO2 | DTR | RTS;   /* ����襭�� ���뢠��� ��
					       �奬 RS-232 � ��⠭����
					       ᨣ����� DTR � RTS	*/
outp(p_base + MCR, c);

outp(p_base + IER, R_INT);      /* ���뢠��� ⮫쪮 �� ��室� ����   */

/* �ணࠬ�஢���� ����஫��� 8259 */
c = inp(IMR);
if ((pnum == 2) || (pnum == 4))
	{
	c &= IRQ3;      /* ����襭�� ���뢠��� �� COM2                    */
	eoi = EOI3;     /* ������ �� ����砭�� ��ࠡ�⪨ ���뢠��� �� COM2 */
	}
else {
	c &= IRQ4;      /* ����襭�� ���뢠��� �� COM1                    */
	eoi = EOI4;     /* ������ �� ����砭�� ��ࠡ�⪨ ���뢠��� �� COM1 */
	}
outp(IMR, c);
}

/*************************************************************************
*       �㭪�� portoff ��ॢ���� ���� � �� ࠡ�祣� ०��� � ���筮�
*   ���ﭨ� ��� MS-DOS (���⭠� � porton).
*   ����頥� ���뢠��� �� ����, ���⠭�������� ��ࠡ��稪 ���뢠���
*   � ��᪨��� ᨣ���� MCR.
*/
void portoff(short pnum)
{
register unsigned i_num;    /* ����� ���뢠���     */
register int c;     /* ������ ��६�����   */

/* ����頥� ���뢠��� �� ����    */
/* �ணࠬ�஢���� ����஫��� 8259 */
c = inp(IMR);
if ((pnum == 2) || (pnum == 4))
	c |= ~IRQ3;     /* ����饭�� ���뢠��� �� COM2 */
else c |= ~IRQ4;	/* ����饭�� ���뢠��� �� COM1 */
outp(IMR, c);

outp(p_base + IER, 0);      /* ����饭�� ��� ⨯�� ���뢠��� */

outp(p_base + MCR, 0);      /* ��᪨�㥬 �� ᨣ����            */

if ((pnum == 2) || (pnum == 4)) /* ��।������ ����� ���뢠���    */
	i_num = 0xB;
else i_num = 0xC;

_dos_setvect(i_num, oldvect);   /* ����⠭���� ��ࠡ��稪 ���뢠��� */
}

/*************************************************************************
*       �㭪�� i_handler ���� ��ࠡ��稪�� ���뢠��� �� ����.
*   �㭪�� ����砥� �ࠢ����� �� ������������� ���뢠���. ���
*   ����ࠥ� ���� �� ���� � ������ ��� � ����. ���� ����楢�� - �.�.
*   �� ���������� �� ��稭��� ����������� ᭠砫�.
*/
void interrupt far i_handler(void)
{
*inptr = (unsigned char)inp(p_base);   /* ��⠥� ���� */

if (++inptr >= &buf[BSIZE])     /* �஢�ઠ ��室� �� �࠭��� ����    */
	inptr = buf;		/* �᫨ ��, � ��筥� ᭠砫�		*/

outp(ICR, eoi);
}

/*************************************************************************
* �㭪�� portin �롨ࠥ� ���� ���� �� ����楢��� ����. �᫨ ���� ����,
* � �����頥��� -1
*/
int portin(unsigned char *ch)
{
int rc = 0;   /* ��� �����襭�� */

if (inptr != outptr) {		/* ���� � ���� �����?    */
    *ch = *outptr & 0x7F;	/* ��. ��६ ASCII ᨬ���   */
    if (++outptr >= &buf[BSIZE])    /* �஢�ઠ ��室� �� �࠭��� ���� */
	outptr = buf;		    /* �᫨ ��, � ��筥� ᭠砫�	 */
    }
else rc = -1;

return rc;
}

/*************************************************************************
* �㭪�� portout ���뫠�� ���� ch � �����. �����頥� 0 �� ��ଠ�쭮�
* �����襭��. �� �訡�� �����頥��� -1
*/
int portout(unsigned char ch)
{
register int tm = -32000;      /* ���稪 ��� �࣠����樨 ⠩���� */

while ((inp(p_base + LSR) & TRRDY) == 0)  /* ���� ���� �� ��⮢ � ��।�� */
    if (tm++ > 0)
	return -1;	/* �訡��. ��室 �� ⠩�����	*/

outp(p_base, ch);	/* �뢮� ᨬ���� */
return 0;
}
