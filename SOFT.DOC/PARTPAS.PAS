{旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
{� 뜝㎛좂����     : 롡�죖젲���� p젳〃��⑨ ┘飡ぎ． ㄸ稅�                 �}
{쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
{� 귣㎜�          : PART [��Дp ┘飡ぎ． ㄸ稅�] (�� 僧�ョ젺⑧ - 0)       �}
{읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}

uses Dos;

type SecPos = record                       { 뙠飡���ギ┘��� 醒も췴�       }
                Head   : byte;             { 꺇ギ˚� 譽��⑨/쭬�ⓤ�        }
                SecCyl : word;             { 뜮Дp 醒も췴� � 與エ�쨛�     }
              end;

     PartEntry = record                    { 귛�� � �젩エ軟 p젳ㄵギ�      }
                   Status   : byte;        { 뫌飡�輾�� p젳ㄵ쳽            }
                   StartSec : SecPos;      { 뜝�젷彛硫 醒も췴             }
                   PartTyp  : byte;        { 뮜� p젳ㄵ쳽                  }
                   EndSec   : SecPos;      { 뒶�η�硫 醒も췴              }
                   SecOfs   : longint;     { 뫊ι���� 醒も췴� 쭬즤習え    }
                   SecNum   : longint;     { 뒶エ曄飡¡ 醒も췴��          }
                 end;

     PartSec   = record                    { 뫁も췴 p젳〃��⑨             }
                   BootCode  : array [0..$1BD] of byte;
                   PartTable : array [1..4] of PartEntry;
                   IdCode    : word;
                 end;

{旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
{� ReadPartSec : 뿨�젰� 醒も췴 p젳ㄵ쳽 � ㄸ稅� � ��Д�젰� � ▲芯p        �}
{쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
{� 귛�ㄽ瑜 캙p젹βp� : HrdDrive - BIOS-��Дp ┘飡ぎ． ㄸ稅�($80 Œ� $81) �}
{�                   : Head     - 뜮Дp ．ギ˚� 譽��⑨/쭬�ⓤ�            �}
{�                   : SecCyl   - 뜮Дp 醒も췴� � 與エ�쨛� � 兒p쵟收 BIOS�}
{�                   : Buf      - 곥芯p, � ぎ獸p硫 ��Д�젰恂� 醒も췴     �}
{읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}

function ReadPartSec ( HrdDrive, Head : byte;
                       SecCyl         : word;
                       var Buf        : PartSec ) : boolean;

var Regs : Registers;

begin
  Regs.AX := $0201;                   { 뜮Дp 押�ゆĿ "譽����", 1 醒も췴  }
  Regs.DL := HrdDrive;                { 뇿�α���� ㄾ��キⓥ�レ�音 캙p젹β- }
  Regs.DH := Head;                    { p�� � pⅲⓤ�p�                    }
  Regs.CX := SecCyl;
  Regs.ES := seg( Buf );
  Regs.BX := ofs( Buf );
  Intr( $13, Regs );                  { 귣㎜� 칛쩺猶젺⑨ ┘飡ぎ． ㄸ稅�   }
  ReadPartSec :=
    ( Regs.Flags and 1 ) = 0;         { 뵭젫 �쩺����� 丞젳猶젰� 췅 �鼇―� }
end;

{旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
{� GetSecCyl   : 렞pⅳ�ワβ ��Дp 醒も췴� � 與エ�쨛� � 兒p쵟收 BIOS      �}
{쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
{� 귛�ㄽ瑜 캙p젹βp� : SecCyl   - 뜮Дp 醒も췴� � 與エ�쨛� � 兒p쵟收 BIOS�}
{�                   : Sector   - 닾� �쩺�Д���� "醒も췴"                �}
{�                   : Cylinder - 닾� �쩺�Д���� "與エ�쨛"               �}
{읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}

procedure GetSecCyl ( SecCyl : word; var Sector, Cylinder : integer );

begin
  Sector   := SecCyl and 63;               { 닱˙η���� 〃獸� 6 � 7       }
  Cylinder := hi( SecCyl ) + ( lo( SecCyl ) and 192 ) shl 2;
end;

{旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
{� ShowPartition  :  롡�죖젲젰� p젳〃���� ┘飡ぎ． ㄸ稅� 췅 咨p젺�       �}
{쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
{� 귛�ㄽ�� 캙p젹βp  : DR  - 뜮Дp ギ（曄稅�． ㄸ稅� (0, 1, 2 � �.�.)    �}
{읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}

procedure ShowPartition ( DR : byte );

var Head     : byte;                  { 꺇ギ˚� ㄻ� 收ゃ耀． p젳ㄵ쳽      }
    SecCyl   : byte;                  { 뫁も췴 � 與エ�쨛                  }
    ParSec   : PartSec;               { 뮙ゃ蟯� 醒も췴 p젳〃��⑨          }
    Entry    : byte;                  { 묊β葉� 與か�                     }
    Sector,                           { 룼ャ�좐� ��Дp� 醒も췴� �         }
    Cylinder : integer;               { 與エ�쨛�                          }
    Regs     : Registers;             { 맓（飡p� 칛�璵遜췴� ㄻ� �留�쥯    }
                                      { 칛쩺猶젺⑨                        }
begin
  writeln;
  DR := DR + $80;                     { 룼ㄳ�獸˚� ��Дp� ㄸ稅� ㄻ� BIOS  }
  if ReadPartSec ( DR, 0, 1, ParSec ) then { 쀢���� 醒も췴� p젳〃��⑨     }
    begin                                  { 뫁も췴 信�θ�� 칛�葉�젺      }
      Regs.AH := 8;                        { 쀢���� 쩆��音 ㄸ稅�          }
      Regs.DL := DR;
      Intr( $13, Regs );              { 귣㎜� 칛쩺猶젺⑨ ┘飡ぎ． ㄸ稅�   }
      GetSecCyl ( Regs.CX, Sector, Cylinder );
write('旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
write('컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커');
write('� 꽙稅      ',DR-$80,': ',Regs.DH+1:2,' ．ギ¡� � ',
     Cylinder:5,' 與エ�쨛젹� � ',Sector:3,' 醒も췴젹�                   �');
write('� 뮔∥ⓩ� p젳ㄵギ� � 醒も췴� p젳〃��⑨');
write('                                         �');
write('쳐컫컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컫컴컴');
write('컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴컴컴쩡컴컴캑');
write('�  �    �                        � 뜝�');
write('젷�      � 뒶�ζ      퀜졹飡�輾�� 퀕��-¡�');
write('� #퀒젫p�         뮜�            � 꺇�');
write(' 뼥� 뫁� � 꺇� 뼥� 뫁こ�� 醒�.쭬�.녁ⅹ�. �');
write('쳐컵컴컴탠컴컴컴컴컴컴컴컴컴컴컴컵컴컴');
write('컴컴컴컴컵컴컴컴컴컴컴탠컴컴컴컴컴탠컴컴캑');

      for Entry := 1 to 4 do               { 렊p젩�洙� �젩エ�             }
        with ParSec.PartTable[ Entry ] do
          begin
            write('� ', Entry, '�');
            if Status = $80 then write ('��  ')
                            else write ('뛿� ');
            write('�');
            case PartTyp of                { 롡�죖젲���� 殊캙 p젳ㄵ쳽     }
              $00    : write('뜢 쭬�汀�               ');
              $01    : write('DOS, 12-〃獸쥯� FAT     ');
              $02    : write('XENIX                   ');
              $03    : write('XENIX                   ');
              $04    : write('DOS, 16-〃獸쥯� FAT     ');
              $05    : write('DOS, 꽡��キⓥ. p젳ㄵ�   ');
              $DB    : write('룧p젷ゥレ췅� DOS        ');
              else     write('뜢�㎖α狩좑 (',PartTyp:3,')    ');
            end;
            GetSecCyl ( StartSec.SecCyl, Sector, Cylinder);
            write('�',StartSec.Head:2,' ',Cylinder:5,' ',Sector:3 );
            GetSecCyl ( EndSec.SecCyl, Sector, Cylinder);
            write(' �',EndSec.Head:2,' ',Cylinder:5,Sector:3 );
            write(' �', SecOfs:7,'    �', SecNum:6,'�');

      end;
write('읕컨컴컴좔컴컴컴컴컴컴컴컴컴컴컴컨컴컴');
writeln('컴컴컴컴컨컴컴컴컴컴컴좔컴컴컴컴컴좔컴컴켸');

         end
        else writeln('롨Æ첓 ¡ 줽�э ㄾ飡承� � 醒も췴� 쭬즤習え');
      end;

{旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
{�                    � � � � � � �   � � � � � � � � �                  �}
{읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}

var HrdDrive,                         { 룯p�Д��瑜 ㄻ� 칛��죖젳�쥯�⑨     }
    DError    : integer;              { 쭬쩆��音 쟰ｃД�獸�               }

begin
writeln;
  HrdDrive := 0;                      { 룼 僧�ョ젺⑧                      }
  if ParamCount = 1 then              { 끷エ ㄸ稅 쭬쩆� 캙p젹βp��        }
    begin
      val (ParamStr(1),HrdDrive,DError);   { ASCII � ㄵ碎殊嶺��           }
      if DError <> 0 then                  { 끷エ �鼇―� 칛��죖젳�쥯�⑨   }
        begin
          writeln(#13#10'뜢´p�� 丞젳젺 ㄸ稅!');
          exit;
        end;
    end;
  ShowPartition ( HrdDrive );               { 롡�죖젲젰� 醒も췴 p젳ㄵ쳽   }
end.

