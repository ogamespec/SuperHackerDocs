					       �.�.��ᨫ쭨���

		       ��� ��� � TSR ��� PSP
	       -------------------------------------
	       (����⪨ �� ����� ���� �.�.�������)

     ����୮,	�����	 �ணࠬ����,	�����   ����  १������
�ணࠬ��, ࠭� ��� ������  ��稭��� ��������� �� ��������  �����.
���� 蠣 ��  �⮬ ��� -  ��। �뤠祩 ���뢠���  TSR �᢮������
ᥣ����   �����   Environment	 (ࠧ㬥����,	�᫨   ���ଠ��  �
��६����� �।�  �� �㦭�  १����⭮� ���  �ணࠬ��). �� �����
���⨣����� ᫥���騬� ��������� ��ᥬ����:

     mov  es,cs:[2Ch] ; ����㧨�� � ES ���� ᥣ���� Environment
		      ; �� PSP (CS ������ 㪠�뢠�� �� PSP)
     mov  ah,49h      ; �㭪�� �᢮�������� �����
     int  21h

     ������ ᥣ���� Environment �᢮������ � ����� ����  �ᯮ�짮���
��㣨�� �ணࠬ����, ����᪠��묨 ��᫥ �⮩ १����⭮�  �ணࠬ��.
�����  ����㯮�,  �ࠢ��,  �����  ����	�����  -  ������ �ணࠬ�� -
���������� ����⨢��� �����	(���ਬ��, SYSINFO ��  ����� Norton
Utilities  5.0	(�㭪��  Memory),   UNLOAD  �	�.�.)  ��   ᯮᮡ��
��।�����  ���  �ணࠬ��,  ��ࠧ����襩  �����  ᥣ����,  � �����
��-�	�த�	"Unknown  owner",   �.�.  ��   �ணࠬ��   �������
���ଠ��  ��	 �����	�ணࠬ��-��������   ������  ��    ᥣ����
Environment. ���祬, ��㤮��⢮ �� �� �⮫� � ������.

     ������  �⨬  ��  ����뢠����  १���  ��������  �����. ���
�����⭮,  DOS	��  ����᪥  �ணࠬ��  ��ந� ��䨪� �ணࠬ�����
ᥣ����, ����騩 ����� �  256 ���� � ��室�騩��  ��। �ணࠬ���
�����. � ��� �� ᠬ� 256 ���� �� ���� ����� ������  �ணࠬ���⠬:
楫��	16   ��ࠣ�䮢   �����   �ய�����   ���!   �����  ��  ��
�ᯮ�짮����?

				8

     ����� �.�.�������, ����祭��� � "���⯠��ࠬ�" N 5 �� 1991 �.,
ᮤ�ন�  ���ᠭ��  ����  �����쭮  ���㬭�� ��⮤�� �ᯮ�짮�����
PSP. ����  �� ���  �ਭ������� "��㯯�  �ணࠬ���⮢ 2�"  ��୥�
�.�. � ��ॣ��� �.�.,  ��ன ࠧࠡ�⠭ ᠬ�� �.�.�������.  ����
��⮤ �� ������  ��⮨� � ��७�ᥭ��  ��� �ணࠬ����� ����  �
��㣮�	����	�����,  ���४�஢��	 ࠧ��஢  ᥣ����   �����
�ணࠬ��,  ��७�ᥭ��   �  ����祭��   ᥣ����  �㦭���   ࠧ���
१����⭮� ���  �ணࠬ�� �	�� ����ன��  �� �����	� �����襭��
�ணࠬ��  �����  ��ࠧ��  ���  �᢮��������	�⮣� ᥣ����. ����
��ண� ��⮤� - �  �����襭�� �ணࠬ�� "������� ��ࠧ��",  �����
DOS ���⠢���� �믮����� �ࠣ����  �ணࠬ�� ����� �� �����襭��  ��
TSR-���뢠���.   ���	 �ࠣ����   �	�����⢫��   ��१�����  �
१������  ᥣ����  �����  १����⭮�   ���  �ணࠬ��  �   ��
����ன��.

     ���� �.�.������� ���  �������஢������ �ணࠬ���� (���  ��
��� �ࠩ��ࠬ  PU*), �	������ᮢ���� �।��������  �� ��⮤���� �
���஡���� �� ॠ��������. �ਢ��� ���� �� ��� ����:

"2.1. ������ ���樠����樨 TSR �ணࠬ� � �ᯮ�짮������ PSP.

     1. ��।�����  ����� १����⭮� ��� �ணࠬ�� (EndRes),
	��஢����� �� �࠭�� ��ࠣ��.
     2. ��������� 16 ���� १����⭮� ��� �ணࠬ�� �� ᬥ�-
	��� EndRes-Delta � ᯥ樠�쭮 �⢥������ ����, ���:
	Delta - ����稭� ��६�饭�� �ணࠬ�� (��⭠ 16)
		��� TSR ��� PSP Delta=100h
	� ��� ������� DOS �ᯮ����� ��᫥���� MCB  ����  ��᫥
	१����⭮�� �����襭�� �ணࠬ�� (���.2).
     3. �᢮������ ���� �।�, �᫨ �� ����室���.
     4. ��८�।�����	㪠��⥫�  ��室� PSP_tm (ᬥ饭�� 0ah)
	㪠��⥫�� �� �ணࠬ��-��������� ��室� � DOS (�.2.2).
     5. ���᫨��  ����� १����⭮� ��� �ணࠬ�� � ��ࠣ�-
	�� � ��⮬ ��६�饭�� � PSP:
		   LTSR=(EndRes-Delta)/16
	���������, ��� ������, ॣ����� SS � SP .
     6. �������� �ணࠬ�� �� �㭪樨 DOS 31h ��� INT 27h.

      2.2. ������ �ணࠬ��-��������� ��室� � DOS.

     1. ����⠭�����, ��� ������, ॣ����� SS � SP.
     2. ��६����� १������� ���� �ணࠬ�� � PSP.
     3. ����⠭�����   16   ����    �ணࠬ��	 ��    ᬥ饭��
	EndRes-2*Delta �� ������ ��砫� �ணࠬ�� �� ����.
     4. ��⠭����� �ॡ㥬� ����� ���뢠���, �᫨ �� ����-
	室���. ��  ��⠭����	 ����஢   ����室���	 �����
	����� ���祭�� ᥣ���� TSR = CS-Delta/16.
     5. �����⢨�� ������ ���室 �� ������ 22h."

     (����� ����).

				9

     �� ॠ����樨 ��⮤��� ���᭨���� ᫥���饥:

     1) �����⢨�� �����⥫�� ��室  � DOS ���室�� ��  ������
22h �� 㤠����. �� ���� ����⫥���, DOS �� �����襭��  �ணࠬ��,
� ���ன  ᪮�४�஢�� ����  ��室� �  DOS �  PSP, ��� ���ᠭ� �
�㭪�	2.1.4,	���४����  �  ����	�� ������ 22h (��ᯥਬ����
�஢�������  �	PC  DOS  3.30).  ��ࠢ����� � �⮩ �஡����� 㤠����
⮫쪮 ������������ ���� ��室�  � DOS �� �뤠�  TSR-���뢠��� �
ࠡ�祩 ��६����� � ���室�� �� ������������ �����.

     2)  �  ��⠫쭮�  ��⮤���   ࠡ�⠥�  ���४⭮  �   ��������
����⢨⥫쭮  �ᯮ�짮����  ����  PSP,  ᮪�⨢  ⥬	ᠬ� ࠧ���
१����⭮�  ���  �ணࠬ��  ��  256	����.  ������ � ����⨫, ��
�����	��⮤	�����襭��  १�������   �ணࠬ�  ��ᮢ���⨬    �
�ணࠬ��� RELEASE. ��᫥ ����᪠ १����⭮� �ணࠬ��,  ����ᠭ���
�� �ਢ�������	��� ��⮤���,	RELEASE ����  �����뢠�� ����������
����� �ணࠬ��, � �� ����⪥	���� �� �ணࠬ�� ��� �  �ய�����
�� ⠡��窨, �뤠������ RELEASE, ��  ⥬ �� ����� ��⠥��� �  �����
� ࠡ�⠥�,  ���� ��  (� ��襬  ��砥) ��  ����⨨ ������  "Alt="
�뤠���� ᮮ�饭��  "Divide error"  � �ࠢ�����  ����뢠���� �  DOS
(Norton Commander �� �⮬ "᫥⠥�").

     3)  ��᫥	�����襭��  �ணࠬ��  ��  TSR-���뢠���  ������, �
���ன ��室���� �ࠣ���� �ணࠬ��, �����⢫��騩  ������⥫��
����樨  ��  ��⠭����  �ணࠬ��,  㦥  �᢮�������.	������᪨
��������  ��砩,  �����  �����-�����	�����  (���ਬ��,   ��㣠�
१����⭠�  �ணࠬ��,  ����饭���  ࠭��)  ������  �	���  ������
������ �ࠢ����� ��  ���뢠���, ������ �  DOS ᥣ���� �����  �
�ᯮ���� ��� �� ᢮��� �ᬮ�७�� - � �祢���묨 ��᫥��⢨ﬨ.

     � �����祭��  ��� �ਢ���  ᢮� ᮮ�ࠦ����  �� �⮬� ������.
��ᬮ�ਬ  �����⥫쭮	��  ��������  PSP  (��㭮�  ⠪��  ���� ��
���� �.�.�������):

PSP?	    Struc
PSP_int_20  db	  0cdh,020h  ;00h - INT 20 ��� �����襭��
;				    �ணࠬ��
PSP_top     dw	  ?	     ;02h - N 1 ᢮������� ��ࠣ��.
PSP_rsv1    db	  6  dup(?)  ;04h - � � � � � �
; ���� �����襭�� �ணࠬ�� - ����� ����� 22h:
PSP_tm_ip   dw	  ?	     ;0ah
PSP_tm_cs   dw	  ?	     ;0ch
; ���� ��室� �� Ctrl-Break - ����� ����� 23h:
PSP_cb_ip   dw	  ?	     ;0eh
PSP_cb_cs   dw	  ?	     ;10h
; ���� ��室� �� �⠫쭮� �訡�� - ����� ����� 24h:
PSP_er_ip   dw	  ?	     ;12h
PSP_er_cs   dw	  ?	     ;14h
; �������� ���� த�⥫�᪮�� PSP
PSP_ow_cs   dw	  ?	     ;16h
; File Handle Table - 20 �����ᮢ ��� ��⥬��� ⠡�. 䠩���
PSP_fht     db	  20 dup(?)  ;18h - File Handle Table

				10

; �������� ���� �।� ����� (ENVIROMENT)
PSP_env     dw	  ?	     ;2�h
PSP_rsv2    db	  34 dup(?)  ;2eh - � � � � � �
PSP_dos     db	  0cdh,021h  ;50h - INT 21 - ���. � �. DOS
PSP_rsv3    db	  3 dup(?)   ;52h -  � � � � � �
PSP_efcb1   db	  7  dup(?)  ;55h - ���७�� FCB1
PSP_fcb1    db	  16 dup(?)  ;5ch - �� ������ FCB1
PSP_fcb2    db	  16 dup(?)  ;6ch - �� ������ FCB2
PSP_rsv4    db	  4  dup(?)  ;7ch - � � � � � �
; ������� DTA �� 㬮�砭�� �:
PSP_lparm   db	  ?	     ;80h - ����� ���� ��ࠬ��஢
PSP_parm    db	  127 dup(?) ;81h - ���� ��ࠬ��஢
PSP?	    Ends

     ����訢����� ᫥���騥 �뢮��:

     -	��᫥  �������	���������  ��ப�  DOS	�������   ��ࠬ��஢
(����  80h  -  0FFh)	㦥  ��  �㦭�	� ����� ���� �ᯮ�짮���� ��
�ᬮ�७��  �ணࠬ��.	(������  ⠪  ����㯠�� �����ୠ� �ணࠬ��
800).

     - �᫨ �ணࠬ�� ��  �ᯮ���� FCB ��� ����  䠩���, 㪠������
�  ���������  ��ப�,  �  �����  �ᯮ�짮����	� ���� PSP, �������
�⨬� FCB (���� 5Ch - 7Bh).

     �᫨ ⠪�� ������⢮����  ����塠��� १�� ��  ����� 7Ch,
� � ��襬 �ᯮ�殮��� ����뢠����  ������ � PSP, ��稭�� �  ����
5Ch,  �㤠  �����  ��९����  १�������  ����  �ணࠬ��.  �����
��ࠧ��, ��  㤠���� �ᯮ�짮����  ���� 5Ch  (�.�. 92)	����. � ���
�⮣� �� �ॡ���� �����-���� ᫮���� �奬 �����襭�� �ணࠬ��.  ��
�  ����  ��  ��  92  ����  �ᨫ��,  ���ࠢ������  ��  �,   �⮡�
�ᯮ�짮���� � ��?

     �����  ����  �뫠	����ᠭ�  �ணࠬ��  EC1840A  -  १������
�ࠩ���  ����������  ���  ��-1840/41.  ��९�ᠢ  १�������  ����
�ணࠬ�� �  PSP ��稭��  � ����  5Ch, ���  㤠���� �������� ⮣�,
�� १����⭠� ����  �ணࠬ�� �������� �ᥣ�  176 ���� -  �����,
祬 ࠧ��� PSP. �� ⠪ � � ���� - � ��� �ᮡ�� ���७��.  ���⮬�
�����  ��  ࠧ  ������  �����  -  ����  ��	���  �  ⮬, �⮡�
��६����� �ᯮ�짮����  ���६���� ����  PSP, �����  ����� ᬥ��  �
���� �ᯮ�짮���� ���� 2/3 ���?

