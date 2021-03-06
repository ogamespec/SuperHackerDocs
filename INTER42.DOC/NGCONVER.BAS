'******************************************************************************
'*                                                                            *
'* Norton Guide Formatting Program                                            *
'*                                                                            *
'* Written By: David Ehrlich                                                  *
'*             DME Systems Specialties                                        *
'*             Copyright 1994                                                 *
'*                                                                            *
'* Designed to work with Ralf Browns Interrupt List version 41                *
'*                                                                            *
'******************************************************************************

filenames$ = "in"
i% = 1
CLS
IF DIR$("INTERRUP.1ST") = "" THEN
   CLS
   PRINT "NORTON GUIDE FORMAT PROGRAM VERSION 1.0"
   PRINT
   PRINT "THE FILE 'INTERRUP.1ST' MUST BE IN THE CURRENT DIRECTORY"
   END
END IF

INFILE$ = "INTERRUP."
filenum% = 0

IF DIR$(INFILE$ + CHR$(65 + filenum%)) = "" THEN
   CLS
   PRINT "NORTON GUIDE FORMAT PROGRAM VERSION 1.0"
   PRINT
   PRINT "YOU MUST HAVE THE FILES INTERRUP.? IN THE CURRENT"
   PRINT "DIRECTORY TO RUN THIE PROGRAM"
   PRINT
   END
END IF

OPEN "i", #1, INFILE$ + CHR$(65 + filenum%)
LN$ = ""
WHILE NOT EOF(1) AND LEFT$(LN$, 12) <> "--------C-00"
      LINE INPUT #1, LN$
WEND
shortcount% = 0
extra% = 0
WHILE 1

   IF LEFT$(LN$, 8) <> "--------" THEN
      LINE INPUT #1, LN$
   END IF

   IF LEFT$(LN$, 8) = "--------" THEN

      IF MID$(LN$, 11, 2) <> OLDINT$ THEN
         IF MID$(LN$, 11, 2) = "--" THEN
            CLOSE #1
            filenum% = filenum% + 1
            IF DIR$(INFILE$ + CHR$(65 + filenum%)) = "" THEN GOTO ENDLOOP
            OPEN "i", #1, INFILE$ + CHR$(65 + filenum%)
            LN$ = ""
            WHILE NOT EOF(1) AND LEFT$(LN$, 8) <> "--------"
               LINE INPUT #1, LN$
            WEND
         END IF
         IF OLDINT$ <> MID$(LN$, 11, 2) THEN
            cntr% = cntr% + 1
            CLOSE #2
            OPEN "o", #2, filenames$ + MID$(LN$, 11, 2)
            extra% = 0
            shortcount% = 0
            PRINT filenames$ + MID$(LN$, 11, 2)
            REDIM PRESERVE menu$(cntr%)
            menu$(cntr%) = filenames$ + MID$(LN$, 11, 2)
         END IF
         OLDINT$ = MID$(LN$, 11, 2)
      END IF

      IF shortcount% >= 200 THEN
         PRINT #2, "!short ^bInterrupt " + OLDINT$ + " continued in next section...^b"
         CLOSE #2
         cntr% = cntr% + 1
         extra% = extra% + 1
         OPEN "o", #2, filenames$ + OLDINT$ + LTRIM$(STR$(extra%))
         PRINT filenames$ + OLDINT$ + LTRIM$(STR$(extra%))
         shortcount% = 0
         REDIM PRESERVE menu$(cntr%)
         menu$(cntr%) = filenames$ + OLDINT$ + LTRIM$(STR$(extra%))
      END IF

      LINE INPUT #1, LN$
      PRINT #2, "!short " + LN$

      shortcount% = shortcount% + 1
      OldTitle$ = LN$
      Size% = 0
      Part% = 1

      IF NOT EOF(1) THEN
         LINE INPUT #1, LN$
         WHILE LEFT$(LN$, 8) <> "--------" AND NOT EOF(1)
            IF Size% + LEN(LN$) >= 12 * 1024 THEN
               Part% = Part% + 1
               PRINT #2, "!short " + OldTitle$ + " (Part" + STR$(Part%) + ")"
               shortcount% = shortcount% + 1
               'PRINT OldTitle$ + " (Part" + STR$(Part%) + ")"
               Size% = 0
            END IF

            TCHK% = 0

            TOKEN$ = "SeeAlso:"
            TLEN% = LEN(TOKEN$)
            IF LEFT$(LN$, TLEN%) = TOKEN$ THEN
               LN$ = "^B" + TOKEN$ + "^B" + MID$(LN$, TLEN% + 1)
               TCHK% = 1
            END IF

            IF TCHK% = 0 THEN
               TOKEN$ = "Return:"
               TLEN% = LEN(TOKEN$)
               IF LEFT$(LN$, TLEN%) = TOKEN$ THEN
                  LN$ = "^B" + TOKEN$ + "^B" + MID$(LN$, TLEN% + 1)
                  TCHK% = 1
               END IF

               IF TCHK% = 0 THEN
                  TOKEN$ = "Desc:"
                  TLEN% = LEN(TOKEN$)
                  IF LEFT$(LN$, TLEN%) = TOKEN$ THEN
                     LN$ = "^B" + TOKEN$ + "^B" + MID$(LN$, TLEN% + 1)
                     TCHK% = 1
                  END IF

                  IF TCHK% = 0 THEN
                     TOKEN$ = "Note:"
                     TLEN% = LEN(TOKEN$)
                     IF LEFT$(LN$, TLEN%) = TOKEN$ THEN
                        LN$ = "^B" + TOKEN$ + "^B" + MID$(LN$, TLEN% + 1)
                        TCHK% = 1
                     END IF

                     IF TCHK% = 0 THEN
                        TOKEN$ = "Notes:"
                        TLEN% = LEN(TOKEN$)
                        IF LEFT$(LN$, TLEN%) = TOKEN$ THEN
                           LN$ = "^B" + TOKEN$ + "^B" + MID$(LN$, TLEN% + 1)
                           TCHK% = 1
                        END IF

                        IF TCHK% = 0 THEN
                           TOKEN$ = "Program:"
                           TLEN% = LEN(TOKEN$)
                           IF LEFT$(LN$, TLEN%) = TOKEN$ THEN
                              LN$ = "^B" + TOKEN$ + "^B" + MID$(LN$, TLEN% + 1)
                              TCHK% = 1
                           END IF

                           IF TCHK% = 0 THEN
                              TOKEN$ = "Range:"
                              TLEN% = LEN(TOKEN$)
                              IF LEFT$(LN$, TLEN%) = TOKEN$ THEN
                                 LN$ = "^B" + TOKEN$ + "^B" + MID$(LN$, TLEN% + 1)
                                 TCHK% = 1
                              END IF

                              IF TCHK% = 0 THEN
                                 TOKEN$ = "Index:"
                                 TLEN% = LEN(TOKEN$)
                                 IF LEFT$(LN$, TLEN%) = TOKEN$ THEN
                                    LN$ = "^B" + TOKEN$ + "^B" + MID$(LN$, TLEN% + 1)
                                    TCHK% = 1
                                 END IF

                                 IF TCHK% = 0 THEN
                                    TOKEN$ = "BUG:"
                                    TLEN% = LEN(TOKEN$)
                                    IF LEFT$(LN$, TLEN%) = TOKEN$ THEN
                                       LN$ = "^B" + TOKEN$ + "^B" + MID$(LN$, TLEN% + 1)
                                       TCHK% = 1
                                    END IF

                                    IF TCHK% = 0 THEN
                                       TOKEN$ = "Warning:"
                                       TLEN% = LEN(TOKEN$)
                                       IF LEFT$(LN$, TLEN%) = TOKEN$ THEN
                                          LN$ = "^B" + TOKEN$ + "^B" + MID$(LN$, TLEN% + 1)
                                          TCHK% = 1
                                       END IF
                                    END IF
                                 END IF
                              END IF
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
            END IF

            PRINT #2, LN$
            Size% = Size% + LEN(LN$)
            LINE INPUT #1, LN$
         WEND
      END IF
   END IF
WEND

ENDLOOP:

CLOSE

mastname$ = "rbcred"

OPEN "i", #1, "INTERRUP.1ST"
LINE INPUT #1, in16data$
filenum% = 1
OPEN "o", #2, mastname$ + LTRIM$(STR$(filenum%))
PRINT mastname$ + CHR$(64 + filenum%)
LN$ = ""
WHILE NOT EOF(1) AND LEFT$(LN$, 21) <> "--------!---COPYRIGHT"
       LINE INPUT #1, LN$
WEND
Size% = 0
LN$ = ""
WHILE NOT EOF(1)
   LINE INPUT #1, LN$
   IF Size% + LEN(LN$) >= 12 * 1024 THEN
      CLOSE #2
      filenum% = filenum% + 1
      OPEN "o", #2, mastname$ + LTRIM$(STR$(filenum%))
      PRINT mastname$ + CHR$(64 + filenum%)
      Size% = 0
   END IF
   PRINT #2, LN$
   Size% = Size% + LEN(LN$)
WEND
CLOSE

OPEN "o", #1, "CREDIT"
Part1$ = LEFT$(in16data$, 15)
Part2$ = MID$(in16data$, INSTR(in16data$, "R"), 10)
Part3$ = MID$(in16data$, INSTR(in16data$, "Last"))
PRINT #1, "                        "; Part1$
PRINT #1, "        "; Part2$; "  "; Part3$
PRINT #1, "                Copyright (c) 1989-94 ^bRalf Brown^b"
PRINT #1, "                Norton Guide Formatting done by"
PRINT #1, "                       ^b^rDavid Ehrlich^r^b"
PRINT #1, "                   ^b^rDME Systems Specialties^r^b"
CLOSE

OPEN "o", #1, "rbcred"
FOR i = 1 TO filenum%
   PRINT #1, "!short Ralphs Credit List - Part"; i
   PRINT #1, "!file:rbcred" + LTRIM$(STR$(i)) + ".ngo"
NEXT
CLOSE

OPEN "o", #1, "interrup.bat"
FOR i = 1 TO cntr%
   PRINT #1, "ngc " + menu$(i)
NEXT
FOR i = 1 TO filenum%
   PRINT #1, "ngc rbcred" + LTRIM$(STR$(i))
NEXT
PRINT #1, "NGC rbcred"
PRINT #1, "NGC inmaster"
PRINT #1, "NGC inASCII"
PRINT #1, "NGC LINES"
PRINT #1, "NGC CREDIT"
PRINT #1, "ngml INTER"
CLOSE

OPEN "o", #1, "inmaster"
m% = 0

FOR i = 1 TO cntr%
   PRINT #1, "!short: INT " + UCASE$(mid$(menu$(i), 3,2));
   IF VAL(MID$(menu$(i), 5, 1)) > 0 THEN
      PRINT #1, " (Part"; VAL(MID$(menu$(i), 5, 1)) + 1; ")"
   ELSE
      PRINT #1, ""
   END IF
   PRINT #1, "!file:" + menu$(i) + ".ngo"
NEXT

CLOSE

OPEN "o", #1, "inter"
PRINT #1, "!name: Interrupt List"
PRINT #1, "!credits:"
PRINT #1, "                        "; Part1$
PRINT #1, "        "; Part2$; "  "; Part3$
PRINT #1, "                   Copyright (c) 1989-94 ^bRalf Brown^b"
PRINT #1, "                Norton Guide Formatting done by"
PRINT #1, "            ^b^rDavid Ehrlich - DME Systems Specialties^r^b"
PRINT #1, ""
PRINT #1, "!menu  Interrupts"
PRINT #1, "       Interrupts                        inmaster.ngo"
PRINT #1, "!menu  Tables"
PRINT #1, "       ASCII Chart                       inascii.ngo"
PRINT #1, "       Box Characters                    lines.ngo"
PRINT #1, "       NG Credits                        credit.ngo"
PRINT #1, "       RB Credits                        rbcred.ngo"
CLOSE

OPEN "o", #1, "inASCII"
PRINT #1, "Dec   Hex  Char         Dec   Hex  Char   Dec   Hex  Char   Dec   Hex  Char"
PRINT #1, "  0   00h   ^b^c00^b   NUL  �   64   40h   ^b@^b  �  128   80h   ^b�^b  �  192   C0h   ^b�^b"
PRINT #1, "  1   01h   ^b^b   SOH  �   65   41h   ^bA^b  �  129   81h   ^b�^b  �  193   C1h   ^b�^b"
PRINT #1, "  2   02h   ^b^b   STX  �   66   42h   ^bB^b  �  130   82h   ^b�^b  �  194   C2h   ^b�^b"
PRINT #1, "  3   03h   ^b^b   ETX  �   67   43h   ^bC^b  �  131   83h   ^b�^b  �  195   C3h   ^b�^b"
PRINT #1, "  4   04h   ^b^b   EOT  �   68   44h   ^bD^b  �  132   84h   ^b�^b  �  196   C4h   ^b�^b"
PRINT #1, "  5   05h   ^b^b   ENQ  �   69   45h   ^bE^b  �  133   85h   ^b�^b  �  197   C5h   ^b�^b"
PRINT #1, "  6   06h   ^b^b   ACK  �   70   46h   ^bF^b  �  134   86h   ^b�^b  �  198   C6h   ^b�^b"
PRINT #1, "  7   07h   ^b^b   BEL  �   71   47h   ^bG^b  �  135   87h   ^b�^b  �  199   C7h   ^b�^b"
PRINT #1, "  8   08h   ^b^b   BS   �   72   48h   ^bH^b  �  136   88h   ^b�^b  �  200   C8h   ^b�^b"
PRINT #1, "  9   09h   ^b^C09^b   HT   �   73   49h   ^bI^b  �  137   89h   ^b�^b  �  201   C9h   ^b�^b"
PRINT #1, " 10   0Ah   ^b^C0A^b   LF   �   74   4Ah   ^bJ^b  �  138   8Ah   ^b�^b  �  202   CAh   ^b�^b"
PRINT #1, " 11   0Bh   ^b^C0B^b   VT   �   75   4Bh   ^bK^b  �  139   8Bh   ^b�^b  �  203   CBh   ^b�^b"
PRINT #1, " 12   0Ch   ^b^C0C^b   FF   �   76   4Ch   ^bL^b  �  140   8Ch   ^b�^b  �  204   CCh   ^b�^b"
PRINT #1, " 13   0Dh   ^b^C0D^b   CR   �   77   4Dh   ^bM^b  �  141   8Dh   ^b�^b  �  205   CDh   ^b�^b"
PRINT #1, " 14   0Eh   ^b^b   SO   �   78   4Eh   ^bN^b  �  142   8Eh   ^b�^b  �  206   CEh   ^b�^b"
PRINT #1, " 15   0Fh   ^b^b   SI   �   79   4Fh   ^bO^b  �  143   8Fh   ^b�^b  �  207   CFh   ^b�^b"
PRINT #1, " 16   10h   ^b^b   DLE  �   80   50h   ^bP^b  �  144   90h   ^b�^b  �  208   D0h   ^b�^b"
PRINT #1, " 17   11h   ^b^b   DC1  �   81   51h   ^bQ^b  �  145   91h   ^b�^b  �  209   D1h   ^b�^b"
PRINT #1, " 18   12h   ^b^b   DC2  �   82   52h   ^bR^b  �  146   92h   ^b�^b  �  210   D2h   ^b�^b"
PRINT #1, " 19   13h   ^b^b   DC3  �   83   53h   ^bS^b  �  147   93h   ^b�^b  �  211   D3h   ^b�^b"
PRINT #1, " 20   14h   ^b^b   DC4  �   84   54h   ^bT^b  �  148   94h   ^b�^b  �  212   D4h   ^b�^b"
PRINT #1, " 21   15h   ^b^b   NAK  �   85   55h   ^bU^b  �  149   95h   ^b�^b  �  213   D5h   ^b�^b"
PRINT #1, " 22   16h   ^b^b   SYN  �   86   56h   ^bV^b  �  150   96h   ^b�^b  �  214   D6h   ^b�^b"
PRINT #1, " 23   17h   ^b^b   ETB  �   87   57h   ^bW^b  �  151   97h   ^b�^b  �  215   D7h   ^b�^b"
PRINT #1, " 24   18h   ^b^b   CAN  �   88   58h   ^bX^b  �  152   98h   ^b�^b  �  216   D8h   ^b�^b"
PRINT #1, " 25   19h   ^b^b        �   89   59h   ^bY^b  �  153   99h   ^b�^b  �  217   D9h   ^b�^b"
PRINT #1, " 26   1Ah   ^b" + CHR$(26) + "^b   SUB  �   90   5Ah   ^bZ^b  �  154   9Ah   ^b�^b  �  218   DAh   ^b�^b"
PRINT #1, " 27   1Bh   ^b" + CHR$(27) + "^b   ESC  �   91   5Bh   ^b[^b  �  155   9Bh   ^b�^b  �  219   DBh   ^b�^b"
PRINT #1, " 28   1Ch   ^b^b   FS   �   92   5Ch   ^b\^b  �  156   9Ch   ^b�^b  �  220   DCh   ^b�^b"
PRINT #1, " 29   1Dh   ^b^b   GS   �   93   5Dh   ^b]^b  �  157   9Dh   ^b�^b  �  221   DDh   ^b�^b"
PRINT #1, " 30   1Eh   ^b^c1e^b   RS   �   94   5Eh   ^b^^^b  �  158   9Eh   ^b�^b  �  222   DEh   ^b�^b"
PRINT #1, " 31   1Fh   ^b^b   US   �   95   5Fh   ^b_^b  �  159   9Fh   ^b�^b  �  223   DFh   ^b�^b"
PRINT #1, " 32   20h   ^b ^b        �   96   60h   ^b`^b  �  160   A0h   ^b�^b  �  224   E0h   ^b�^b"
PRINT #1, " 33   21h   ^b!^b        �   97   61h   ^ba^b  �  161   A1h   ^b�^b  �  225   E1h   ^b�^b"
PRINT #1, " 34   22h   ^b" + CHR$(34) + "^b        �   98   62h   ^bb^b  �  162   A2h   ^b�^b  �  226   E2h   ^b�^b"
PRINT #1, " 35   23h   ^b#^b        �   99   63h   ^bc^b  �  163   A3h   ^b�^b  �  227   E3h   ^b�^b"
PRINT #1, " 36   24h   ^b$^b        �   100  64h   ^bd^b  �  164   A4h   ^b�^b  �  228   E4h   ^b�^b"
PRINT #1, " 37   25h   ^b%^b        �   101  65h   ^be^b  �  165   A5h   ^b�^b  �  229   E5h   ^b�^b"
PRINT #1, " 38   26h   ^b&^b        �   102  66h   ^bf^b  �  166   A6h   ^b�^b  �  230   E6h   ^b�^b"
PRINT #1, " 39   27h   ^b'^b        �   103  67h   ^bg^b  �  167   A7h   ^b�^b  �  231   E7h   ^b�^b"
PRINT #1, " 40   28h   ^b(^b        �   104  68h   ^bh^b  �  168   A8h   ^b�^b  �  232   E8h   ^b�^b"
PRINT #1, " 41   29h   ^b)^b        �   105  69h   ^bi^b  �  169   A9h   ^b�^b  �  233   E9h   ^b�^b"
PRINT #1, " 42   2Ah   ^b*^b        �   106  6Ah   ^bj^b  �  170   AAh   ^b�^b  �  234   EAh   ^b�^b"
PRINT #1, " 43   2Bh   ^b+^b        �   107  6Bh   ^bk^b  �  171   ABh   ^b�^b  �  235   EBh   ^b�^b"
PRINT #1, " 44   2Ch   ^b,^b        �   108  6Ch   ^bl^b  �  172   ACh   ^b�^b  �  236   ECh   ^b�^b"
PRINT #1, " 45   2Dh   ^b-^b        �   109  6Dh   ^bm^b  �  173   ADh   ^b�^b  �  237   EDh   ^b�^b"
PRINT #1, " 46   2Eh   ^b.^b        �   110  6Eh   ^bn^b  �  174   AEh   ^b�^b  �  238   EEh   ^b�^b"
PRINT #1, " 47   2Fh   ^b/^b        �   111  6Fh   ^bo^b  �  175   AFh   ^b�^b  �  239   EFh   ^b�^b"
PRINT #1, " 48   30h   ^b0^b        �   112  70h   ^bp^b  �  176   B0h   ^b�^b  �  240   F0h   ^b�^b"
PRINT #1, " 49   31h   ^b1^b        �   113  71h   ^bq^b  �  177   B1h   ^b�^b  �  241   F1h   ^b�^b"
PRINT #1, " 50   32h   ^b2^b        �   114  72h   ^br^b  �  178   B2h   ^b�^b  �  242   F2h   ^b�^b"
PRINT #1, " 51   33h   ^b3^b        �   115  73h   ^bs^b  �  179   B3h   ^b�^b  �  243   F3h   ^b�^b"
PRINT #1, " 52   34h   ^b4^b        �   116  74h   ^bt^b  �  180   B4h   ^b�^b  �  244   F4h   ^b�^b"
PRINT #1, " 53   35h   ^b5^b        �   117  75h   ^bu^b  �  181   B5h   ^b�^b  �  245   F5h   ^b�^b"
PRINT #1, " 54   36h   ^b6^b        �   118  76h   ^bv^b  �  182   B6h   ^b�^b  �  246   F6h   ^b�^b"
PRINT #1, " 55   37h   ^b7^b        �   119  77h   ^bw^b  �  183   B7h   ^b�^b  �  247   F7h   ^b�^b"
PRINT #1, " 56   38h   ^b8^b        �   120  78h   ^bx^b  �  184   B8h   ^b�^b  �  248   F8h   ^b�^b"
PRINT #1, " 57   39h   ^b9^b        �   121  79h   ^by^b  �  185   B9h   ^b�^b  �  249   F9h   ^b�^b"
PRINT #1, " 58   3Ah   ^b:^b        �   122  7Ah   ^bz^b  �  186   BAh   ^b�^b  �  250   FAh   ^b�^b"
PRINT #1, " 59   3Bh   ^b;^b        �   123  7Bh   ^b{^b  �  187   BBh   ^b�^b  �  251   FBh   ^b�^b"
PRINT #1, " 60   3Ch   ^b<^b        �   124  7Ch   ^b|^b  �  188   BCh   ^b�^b  �  252   FCh   ^b�^b"
PRINT #1, " 61   3Dh   ^b=^b        �   125  7Dh   ^b}^b  �  189   BDh   ^b�^b  �  253   FDh   ^b�^b"
PRINT #1, " 62   3Eh   ^b>^b        �   126  7Eh   ^b~^b  �  190   BEh   ^b�^b  �  254   FEh   ^b�^b"
PRINT #1, " 63   3Fh   ^b?^b        �   127  7Fh   ^b^b  �  191   BFh   ^b�^b  �  255   FFh   ^b ^b"
CLOSE

OPEN "o", #1, "LINES"
PRINT #1, "      218   196   194    191                   201   205   203    187"
PRINT #1, "        ^b�^b����^b�^b�����^b�^b�����^b�^b                       ^b�^b����^b�^b�����^b�^b�����^b�^b"
PRINT #1, "    179 �     197  �     � 179               186 �     206  �     � 186"
PRINT #1, "        �        \ �     �                       �        \ �     �"
PRINT #1, "    195 ^b�^b����������^b�^b�����^b�^b 180               204 ^b�^b����������^b�^b�����^b�^b 185"
PRINT #1, "        �          �     �                       �          �     �"
PRINT #1, "        ^b�^b����^b�^b�����^b�^b�����^b�^b                       ^b�^b����^b�^b�����^b�^b�����^b�^b"
PRINT #1, "      192   196   193    217                   200   205   202    188"
PRINT #1, " "
PRINT #1, " "
PRINT #1, " "
PRINT #1, " "
PRINT #1, "      213   205   209    184                   214   196   210    183"
PRINT #1, "        ^b�^b����^b�^b�����^b�^b�����^b�^b                       ^b�^b����^b�^b�����^b�^b�����^b�^b"
PRINT #1, "    179 �     216  �     � 179               186 �     215  �     � 186"
PRINT #1, "        �        \ �     �                       �        \ �     �"
PRINT #1, "    198 ^b�^b����������^b�^b�����^b�^b 181               199 ^b�^b����������^b�^b�����^b�^b 182"
PRINT #1, "        �          �     �                       �          �     �"
PRINT #1, "        ^b�^b����^b�^b�����^b�^b�����^b�^b                       ^b�^b����^b�^b�����^b�^b�����^b�^b"
PRINT #1, "      212   205   207    190                   211   196   208    189"
CLOSE

SYSTEM

