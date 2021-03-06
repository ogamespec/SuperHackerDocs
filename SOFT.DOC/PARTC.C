#line -a-

/*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커*/
/*� 뜝㎛좂����          : 롡�죖젲���� p젳〃��⑨ ┘飡ぎ． ㄸ稅�           �*/
/*쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑*/
/*� 귣㎜�               : FIXPARTC [��Дp ㄸ稅�] (�� 僧�ョ젺⑧ 0)        �*/
/*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸*/

#include <dos.h>
#include <string.h>
#include <stdlib.h>

#define TRUE   ( 1 == 1 )                       
#define FALSE  ( 1 == 0 )

#define HI(x)  ( *((BYTE *) (&x) + 1) )      /* 궙㎖p좈젰� 飡쟰鼇� 줎⒱   */
#define LO(x)  ( *((BYTE *) &x) )            /* 궙㎖p좈젰� Й젮鼇� 줎⒱   */

typedef unsigned char BYTE;
typedef unsigned int WORD;


typedef struct {                              /* 뙠飡���ギ┘��� 醒も췴�   */
                BYTE Head;                    /* 꺇ギ˚� 譽��⑨/쭬�ⓤ�    */ 
                WORD SecCyl;                  /* 뜮Дp 醒も췴� � 與エ�쨛� */
                } SECPOS;

typedef struct {                              /* 귛�� � �젩エ軟 p젳ㄵギ�  */
		BYTE          Status;         /* 뫌飡�輾�� p젳ㄵ쳽        */
		SECPOS        StartSec;       /* 뜝�젷彛硫 醒も췴         */
		BYTE          PartTyp;        /* 뮜� p젳ㄵ쳽              */
		SECPOS        EndSec;         /* 뒶�η�硫 醒も췴          */
		unsigned long SecOfs;         /* 뫊ι���� 醒も췴� 쭬즤習え*/
		unsigned long SecNum;         /* 뒶エ曄飡¡ 醒も췴��      */
		} PARTENTRY;

typedef struct {                               /* 뫁も췴 p젳〃��⑨        */
		BYTE          BootCode[ 0x1BE ];
		PARTENTRY     PartTable[ 4 ];
		WORD          IdCode;
		} PARTSEC;                      /* OxAA55                 */

typedef PARTSEC far *PARSPTR;   /* 벆젳졻�レ > 醒も췴� p젳ㄵ쳽 � 캙э殊   */

/*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커*/
/*� ReadPartSec : 뿨�젰� 醒も췴 p젳〃��⑨ � ㄸ稅� � ��Д�젰� � ▲芯p     �*/
/*쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑*/
/*� 귛�ㄽ瑜 캙p젹βp� : HrdDrive - BIOS-ぎ� ㄸ稅�(롥80 Œ� 롥81 )        �*/
/*�                   : Head     - 뜮Дp ．ギ˚� 譽��⑨/쭬�ⓤ�           �*/
/*�                   : SecCyl   - 뜮Дp 醒も. � 與エ�쨛� � 兒p쵟收 BIOS �*/
/*�                   : Buf      - 곥芯p, � ぎ獸p硫 ��Д�젰恂� 醒も췴    �*/
/*� 귣若ㄽ瑜 캙p젹βp� : TRUE     - αエ 醒も췴 葉�젰恂� ‥� �鼇―�      �*/
/*�                    : FALSE    - Þ좂�                                �*/
/*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸*/

BYTE ReadPartSec( BYTE HrdDrive, BYTE Head, WORD SecCyl, PARSPTR Buf )
{
	union REGS   Regs;           /* 맓（飡p� 칛�璵遜췴� ㄻ� �留�쥯    */
	struct SREGS SRegs;          /*   칛쩺猶젺⑨                      */

        Regs.x.ax = 0x0201;          /* 뜮Дp 押�ゆĿ "譽����", 1 醒も췴  */
        Regs.h.dl = HrdDrive;        /* 뇿즤習첓 캙p젹βp�� � pⅲⓤ�p�    */ 
        Regs.h.dh = Head;            
        Regs.x.cx = SecCyl;
        Regs.x.bx = FP_OFF( Buf );
	SRegs.es  = FP_SEG( Buf );

	int86x ( 0x13, &Regs, &Regs, &SRegs); /* 귣㎜� 칛쩺猶젺⑨        */
					      /* ┘飡ぎ． ㄸ稅�          */
        return !Regs.x.cflag;
}

/*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커*/
/*� GetSecCyl   : 렞pⅳ�ワβ ��Дp 醒も췴� � 與エ�쨛� � 兒p쵟收 BIOS     �*/
/*쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑*/
/*� 귛�ㄽ瑜 캙p젹βp� : SecCyl  - 뜮Дp 醒も췴� � 與エ�쨛� � 兒p쵟收 BIOS�*/
/*�                   : Sector  - 닾� �쩺�Д���� "醒も췴"                �*/
/*�                   : Cylinder - 닾� �쩺�Д���� "與エ�쨛"              �*/
/*� 귣若ㄽ瑜 캙p젹βp�: �β                                              �*/
/*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸*/

void GetSecCyl( WORD SecCyl, int *Sector, int *Cylinder )
{
        *Sector    = SecCyl & 63;              /* 닱˙η���� 〃獸� 6 � 7  */
        *Cylinder  = HI( SecCyl ) + ( ( (WORD) LO( SecCyl ) & 192 ) << 2 );

}
/*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커*/
/*� ShowPartition  :  롡�죖젲젰� p젳〃���� ┘飡ぎ． ㄸ稅� 췅 咨p젺�      �*/
/*쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑*/
/*� 귛�ㄽ�� 캙p젹βp  : DR    - 뜮Дp ㄸ稅�                              �*/
/*� 귣若ㄽ瑜 캙p젹βp�: �β                                              �*/
/*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸*/

void ShowPartition( BYTE LW )
{

#define AP ParSec.PartTable[ Entry ]

	BYTE       Head,                  /* 꺇ギ˚� ㄻ� 收ゃ耀． p젳ㄵ쳽 */
		   Entry,                 /* 묊β葉� 與か�                */
		   SecCyl;                /* 뫁も췴 � 與エ�쨛             */
	PARTSEC    ParSec;                /* 뮙ゃ蟯� 醒も췴 p젳〃��⑨     */
	int        Sector,                /* 룼ャ曄��� 醒も췴� � 與エ�쨛� */
		   Cylinder;              /* 뜮Дp                        */
	union REGS Regs;                  /* 맓（飡p� 칛�璵遜췴�          */
					  /* ㄻ� �留�쥯 칛쩺猶젺⑨        */
	printf( "\n" );
	LW |= 0x80;                   /* 룼ㄳ�獸˚� ��Дp� ㄸ稅� ㄻ� BIOS */
	if ( ReadPartSec( LW, 0, 1, &ParSec ) ) /* 쀢���� 收ゃ耀． 收め�� */
	  {                                    /* 뫁も췴 信�θ�� 칛�葉�젺 */
	    Regs.h.ah = 8;                     /* 쀢���� 쩆��音 ㄸ稅�     */
	    Regs.h.dl = LW;
	    int86( 0x13, &Regs, &Regs );/* 귣㎜� 칛쩺猶젺⑨ ┘飡ぎ． ㄸ稅�*/
	    GetSecCyl( Regs.x.cx, &Sector, &Cylinder );
	    printf("旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
		   "컴컴컴컴컴컴컴컴컴컴컴컴�");
	    printf("� 꽙稅       %2d:    %2d ．ギ¡�   � %4d "
		   " 與エ�쨛젹� %3d  醒も췴젹�             �",
		     LW-0x80, Regs.h.dh+1, Cylinder, Sector );
	    printf("� 뮔∥ⓩ� p젳ㄵギ� � 醒も췴� p젳〃��⑨     "
		   "                                    �");
	    printf("쳐컫컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴쩡컴"
		   "컴컴컴컴컴쩡컴컴컴컴컴쩡컴컴캑");
	    printf("�  �    �                       � 뜝�젷�      � 뒶�ζ"
		   "       퀜졹飡�輾�� 퀕��-¡�");

	    printf("�#.퀒젫p퀞Ŋ                    � 꺇� 뼥� 뫁� �"
		   " 꺇� 뼥� 뫁� 낟� 醒�.쭬�.녁ⅹ�. �");

	    printf("쳐컵컴컴탠컴컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴탠컴컴"
		   "컴컴컴컴탠컴컴컴컴컴탠컴컴캑");

	    for(Entry = 0; Entry < 4; ++Entry)
	     {
	      printf( "� %d�", Entry );
	      if (AP.Status == 0x80 )
		printf("꽑  ");
	      else
	       printf("뜢� ");
	      printf("�");
	      switch( AP.PartTyp )           /* 롡�죖젲���� 殊캙 p젳ㄵ쳽  */
	       {
		case 0x00 : printf("뜢 쭬�汀�              ");
			    break;
		case 0x01 : printf("DOS, 12-〃獸쥯�  FAT   ");
			    break;
		case 0x02 : printf("XENIX                  ");
			    break;
		case 0x03 : printf("XENIX                  ");
			    break;
		case 0x04 : printf("DOS, 16-〃獸쥯�  FAT   ");
			    break;
		case 0x05 : printf("DOS, 꽡��キⓥ. p젳ㄵ�  ");
			    break;
		case 0xDB : printf("룧p젷ゥレ췅� DOS       ");
			    break;
		default   : printf("뜢�㎖α狩좑  (%3d)     ",
				   ParSec.PartTable[Entry].PartTyp);
	       }

	      GetSecCyl ( AP.StartSec.SecCyl, &Sector, &Cylinder );
	      printf ( "�%2d %5d %3d ",AP.StartSec.Head,Cylinder, Sector );
	      GetSecCyl ( AP.EndSec.SecCyl, &Sector, &Cylinder );
	      printf ( "�%2d %5d %3d ",AP.EndSec.Head,Cylinder, Sector );
	      printf ( "� %6lu    �%6lu�",AP.SecOfs, AP.SecNum );
	     }
	    printf("읕컨컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴좔컴"
		   "컴컴컴컴컴좔컴컴컴컴컴좔컴컴켸");
	  }
	  else
	    printf(" 롨Æ첓 ¡ 줽�э ㄾ飡承� � 醒も췴� 쭬즤習え!\n");
  }

/**************************************************************************/
/*                              깕땸굧�� 룓럠��뙆�                        */
/**************************************************************************/
int main( int argc, char *argv[] )
{
        int HrdDrive;

	HrdDrive = 0;                    /* 룼 僧�ョ젺⑧                  */
	if ( argc == 2 )                 /* 끷エ ㄸ稅 쭬쩆� 캙p젹βp��    */
          {                              /* 꽑                            */
	    HrdDrive = atoi ( argv[ 1 ]);
	    if ( HrdDrive == 0 && *argv[ 1 ] != '0' )
              {
                printf( "\n 뜢´p�� 丞젳젺 ㄸ稅!" );
                return( 1 );             /* 뒶�ζ 칛�즤젹щ               */
                }
	    }
	  ShowPartition( HrdDrive );     /* 롡�죖젲���� 醒も췴� p젳〃��⑨ */
          return( 0 );
}

