(*
  Interrupt List -> WinHelp converter (c) 1994 by Christian MÅller-Planitz
  ------------------------------------------------------------------------
  e-mail address: see CONST "e_mail"


  The source and the compiled EXE-file can be freely distributed as long as
  no changes are made without my knowledge.

  --------------------------------
  Notes:
   The program was tested with INTLIST38 and INTLIST39 and its output
     was successfully compiled with the MS-Help-compiler "HC31.EXE" V3.10.445.

   The program needs the file "INTWHLP.DAT" in the 'source' directory.

   The program converted all sourcefiles (INTERRUP.* and *.LST) to
     13 RTF files which needed 11MB on my harddrive.

   Compiling the RTF-files without compression took 13 minutes in
     a DOS-Window under Win/NT on a 486-50 (if you run it under DOS
     and if you have a fast hardrive cache, it might be faster).

   The (uncompressed) compiled HLP-File was approximately 7MB large.
   If you want to create a compressed HLP-file, you have to exchange the
     comments in the generated help-project file ("RB.HPJ"). Compressing
     reduces the size of the HLP-file to 3MB but it takes
     *more* (?? 28MB ??)  space on your harddrive while compiling.
     In order to speed up compiling the compressed file, I've included a
     temporary file ("RB.PH") of the helpcompiler in this archive.
     Copy this file into the directory containing all the RTF files
     before starting the compiler. This file is specific for INTERLIST39, so
     if you want to get maximal compression in future versions, remove it.

   After the compilation finishes, you will find the file "RB.HLP".
     Start Windows, create an icon in the program manager and double-click on it.


  --------------------------------

   If you find this program usefull, if it does not work or if you have ideas
   how to expand its functionality, feel fee to write an e-mail to me.

   As usual, I do not take any responsibility for possible damages done by
   this program.


  Two questions and their answers :
  ---------------------------------
   WHY is the HLP-file so large ?
     In contrast to other programs that convert the interrupt list to
     DOS-based hypertext systems, this program generates a large
     index file that allows you to search for keywords.

   WHY did I wrote this program in Pascal and not in C ?
     I think Pascal is a pretty nice language for small projects.
     Another reason is the availability of efficient string handling under Pascal.
*)

{$A+,B-,D-,E-,F-,I+,L-,N-,O-,R-,S-,V-}
{$M 16384,25000,200000}
(* minimum heap estimate (1994): 60*(6+10)+(30+40)*(43+10)+50*256=16770 *)
(* (average entry size times (number of entries + 10) for FLAGS, CATEGORIES,
   and CATEGORYKEYS entries) or times 256 for titles.
   Each string in the [*ALIASES] sections requires (length of string) + 5.
*)

Program INT2WHLP;

uses DOS;

{ Version 1.00 - 1994
  v. 1.01 -
  v. 1.01a - 1994-02-16:
	published with Ralf Brown's Interrupt List release 40.
  v. 1.02 - 1994-04-07:
	Changed program name from RB2HLP/INTWHLP to INT2WHLP.
	Reduced the amount of RTF control codes.
	Introduced program parameter controlled behaviour.
	Improved flexibility by use of constants for parts of the control.
	Changed and added some windows.
	Extended search key facilities.
  v. 1.03 - 1994-04-17:
	Expanded/Compressed index switch.
	Multi columns compressed index.
	Interrupt titles OVERVIEW.LST.
  v. 1.04 - 1994-04-29:
	Configuration file including:
	  Program parameters can be defined in the configuration file. Such
	    definitions are overriden by program parameters.
	  Several WINHELP parameters, like font and size, can be specified.
	  Supplementary information "windows" can be included.
	  An ALIAS list can be compiled and written to the HPJ file.
	  A BUILDTAG list can be copied from the configuration to the HPJ file.
  v. 1.05 - 1994-05-07:
	Reconsidered default directories.
  v. 1.06 - 1994-05-26:
	Cross-references to tables.
  v. 1.07 - 1994-05-29:
	Edited procedure explain.
	Skip "Section" file break sections (from a "--------!-Section--.."
	  divider line up to the next divider line).
	Executable code released with Interrupr List release 41.
	(ProgVers erroneously = '1.06').
  v. 1.08 - 1994-07-10:
	Tables as separate topics.
  v. 1.10 - 1994-07-20:
	Interrupt List release number dependent compilation.
	Published with Interrupt List release 42.

}

const
  progName  = 'INT2WHLP';
  progVers  = '1.10';
  hfName    = 'INTWIN'; { helpfile name }
  copyright = 'Copyright (C) 1994 by Christian MÅller-Planitz';
  e_mail    = '"cmuelle@eos.ncsu.edu" or "cmueller@techfak.uni-bielefeld.de"';
    { e-mail address in Intro/Explain windows }
  e_mailCredits = e_mail;
    { e-mail address in the Credits window }

  { the strings ack01 ... are displayed in the Credits window }

  { thanks to (excuse the format): }
  ack01 = '\par{\b Bent Lynggaard} for ideas, parts of the code, and the "Miscellaneous Information" entry.';
  ack02 = '';
  ack03 = '';
  ack04 = '';
  ack05 = '';
  {if extended, update procedure "Credits"}

{$I INT2WHLP.INC }

  Procedure NewHlpPage(VAR F : Text; S, ID, BrowseID : String; Classification : Char);
    type
      intRec = record (* used for fast test and transfer of string *)
	ln: byte;    (* string length *)
	l: longint;  (* 'INT ' *)
	n: word;     (* 'nn' *)
	c7: char;    (* ' ' *)
	l2: longint; (* 'ahal' or 'List' *)
	c12: char;   (* ' ' *)
	w: word;     (* '- ' *)
      end; (* record intRec *)
      nnRec = record ln: byte; w: word; (* for 'nn' *) end;
      ahalRec = record ln: byte; l: longint; (* for 'ahal' *) end;
    const
      linebreak = #13#10'\par\tab';
      intC = ord('I')+ord('N')*$100+ord('T')*$10000+ord(' ')*$1000000;
      listC = ord('L')+ord('i')*$100+ord('s')*$10000+ord('t')*$1000000;
      sepC = ord('-')+ord(' ')*$100;
      int:  string[3] = 'nn';   (* preset length to 2, never changed *)
    VAR
      intR: nnRec absolute int; (* type cast *)
      p,q : Word;
      func: string[5];
      funcR: ahalRec absolute func; (* type cast *)
      ss: string;
      ssR: intRec absolute ss;

    Procedure FootNote(Note: Char; ID : String);
      begin
	writeln(F, Note,'{\footnote{',Note,'} ', ID, '}');
      end;


    procedure insertInt;
      begin
	insert('INT '+int+equStr+func+';'+int+' '+func+';',ss,11);
	  (* "INT nn Ar = XXxx;nn XXxx;"  (XXxx = ahal, ah, or --al) *)
	if equStr[3]='L' then delete(ss,21+equBlanks,2);
	  (* "--" from AL = --al *)
	insert(copy(ss,18,6+equBlanks+2*ord(equStr[3]='X')),ss,11);
	  (* "Ar = XXxx;" *)
      end;

    begin
      writeln(F, '\page\pard\keepn\li'+indent+'\fi-'+indent);
	(* the '\page' inserted unconditionally here will cause that each .RTF
	   file begin with an empty, unreferenced "topic". This is harmless.
	   It requires, though, that [OPTIONS] CONTENTS= is defined, or we
	   would be left in an empty topic without an exit.
	*)
      FootNote('#', ID);
      if S<>'' then FootNote('$', S);
      if BrowseID<>'' then FootNote('+', BrowseID);
      if (Classification <> nullClassification) then begin
	ss:=s;
	if (ssR.l=intC) AND (ssR.c7=' ') then begin
	  if (length(ss)>14) AND (ssR.c12=' ') AND (ssR.w=sepC) then begin
	    (* insert highlight in s *)
	    insert('}}',s,7);
	    insert('{'+highlightInt+'{',s,1);
	      (* 2nd '{' terminates attribute, a ' ' distorts if attrib. is empty *)
	    (* insert tiny, short, and full form of INT *)
	    intR.w:=ssR.n;   (* length of "int" is preset to 2 *)
	    (* same as "int:=copy(ss,5,2);": nn from INT nn ahal - xxxx ... *)
	    funcR.l:=ssR.l2;
	    funcR.ln:=4;     (* func = 'ahal' *)
	    ss[7]:=';';      (* INT nn;ahal - xxxx ... *)
	    ss[8]:=int[1];
	    ss[9]:=int[2];
	    ss[10]:=';';     (* INT nn;nn;l - xxxx ... *)
	    delete(ss,11,4); (* INT nn;nn;xxxx ... *)
	    if func<>'----' then begin
	      if func[3]='-' then begin equStr[3]:='H'; func[0]:=#2; end
	      else if func[1]='-' then equStr[3]:='L'
	      else equStr[3]:='X';
	      insertInt;
	(* INT nn;nn;AX = ahal;INT nn AX = ahal;nn ahal;xxxx ... or
	   INT nn;nn;AH = ah;INT nn AH = ah;nn ah;xxxx ... or
	   INT nn;nn;AL = al;INT nn AL = al;nn --al;xxxx ...
	*)
	      if equStr[3]='X' then begin (* insert also the AH values *)
		equStr[3]:='H';
		func[0]:=#2;
		insertInt;
(* INT nn;nn;AH = ah;INT nn AH = ah;nn ah;AX = ahal;INT nn AX = ahal;nn ahal;xxxx ... *)
	      end; (* if ar=ax *)
	    end; (* if func<>'----' *)
	  end (* if length(ss)>14 ... *)
	  else if (length(s)=11) and (ssR.l2=listC) then begin
	    insert(copy(ss,1,6)+';',ss,1); (* INT nn;INT nn List *)
	    insert(copy(ss,5,3),ss,8); (* INT nn;nn;INT nn List *)
	  end; (* else if ... *)
	end; (* if (ssR.l=intC) ... *)
	if (Classification <> InvalidClassification)
	AND (Classification > ' ') then begin
	  if categoryKeyStrings[Classification]^<>'' then
	    insert(categoryKeyStrings[Classification]^+';',ss,1);
	  if (Classification<'A') OR (Classification>'Z') then
	    insert(Classification+';',ss,1)
	  else insert(Classification+'!;',ss,1);
	end; (* if (Classification<>InvalidClassification) ... *)
	if Classification=tableClassification then begin
	  delete(ss,1,8); (* 'II SUBF ' *)
	  insert('#'+currentTable+';',ss,1);
	end (* if Classification=tableClassification *)
	else repeat
	  p := POS(' - ', ss);
	  if p <> 0 then
	    begin
	      ss[p] := ';';
	      delete(ss,succ(p),2);
	    end;
	until p=0;
	FootNote('K', SS);
      end; (* if (Classification<>nullClassification) *)

      write(F, '{\f0'+headerAttrib,headerSize,' ');
      if classification=specialClassification then write(F, indexHeader);
      writeln(F, S,'}');
      writeln(F, '\par\pard\keep');

    end;


  Procedure AddTopic(VAR F: Text; ST, S, ID: String);
  { print: ST as a string (normally "\par " for new line), S as a hotspot,
    ID as the corresponding jump address or macro.
  }
    const sp: array[0..7] of string[7] =
      ('       ','      ','     ','    ','   ','  ',' ','');
    var p: integer;
    begin
      repeat
	(* detab S, otherwise the string cannot be selected with the cursor
	   in a tab position.
	*)
	p:=pos(#9,S);
	if p<>0 then begin S[p]:=' '; insert(sp[(p-1) AND 7],S,p); end;
      until p=0;
      writeln(F, ST,'{\uldb ', S, '}{\v ', ID, '}');
    end;


  Procedure CheckKeyWords(VAR s : STring);
    CONST KeyWords = 11;
    CONST Keys : Array[1..KeyWords] of String[10] = ('Desc:', 'Notes:',
      'Note:', 'Warning:', 'Index:', 'SeeAlso:', 'Return:', 'BUG:', 'BUGS:',
      'Program:', 'Range:');
    CONST IStr = '{\b ';
    VAR q,p : Integer;

    begin

      for q:= 1 to KeyWords do
	begin
	  p := POS(Keys[q], S);
	  if p <> 0 then
	    begin
	      insert(IStr, S, p);
	      insert('}', S, p+Length(Keys[q]) + Length(IStr));
	      exit;
	    end;
	end;
    end;


  Function GetSpecialNote(Note : Char)  : String;
    begin
      if flagStrings[Note]^='' then GetSpecialNote:='<unknown note in header>'
      else GetSpecialNote:=flagStrings[Note]^;
    end;


procedure insertQueued;
  var i,j: word;
  begin
    if (indexColumns>1) OR (queuedEntry='') then exit;
    val('$'+lastSection,i,j);
    if singlesInMain AND (INTcounts[i]=1) then
      AddTopic(IntFile, nl, queuedEntry, lastSection+'_1')
    else AddTopic(IntFile, nl, title, lastSection+'_0');
    queuedEntry:='';
  end; (* procedure insertQueued *)


  Function ProcessIntList(FName : PathStr) : Boolean;
    LABEL STOP, error_Exit, endOfLoop, table, fobi, noTable;
    type
      kind = (firstPart,inOverview,inFlags,inCategories,inKeys,
	inFileBreakSection,pastTest);
      tableId = array[1..4] of char;
      sRec = record
	l: byte; (* length *)
	w: word; (* with '(T' *)
	d: longint; (* with 'able' *)
	c1: char; (* ' ' *)
	ti: tableId;
	c2: char; (* ')' *)
      end; (* record sRec *)
      castRec = record
	l: byte;
	case byte of
	  1: (w: word);
	  2: (d: longint);
      end; (* record castRec *)
      dividerRec = record
	s: string[8];	(* '--------' *)
	cat: char;	(* category *)
	c: char;	(* '-' *)
	w: word;	(* Interrupt number, 2 hex digits *)
	d: longint;	(* sub function, 4 hex digits or '-' *)
      end; (* record dividerRec *)
    const
      INTno:     integer = 0;
      bufferString: string = ''; (* transfers part of split string *)
      ta = ord('(')+ord('T')*$100; (* (Table nnnn) *)
      able = ord('a')+ord('b')*$100+ord('l')*$10000+ord('e')*$1000000;
      fo = ord('F')+ord('o')*$100; (* Format of ... *)
      bi = ord('B')+ord('i')*$100; (* Bitfields for ... *)
      Section: String[3] = '--'; (* initialize to length 2 *)
      SubFunc: String[5] = '----'; (* length 4 *)
      allMessages: boolean = false;

    VAR
	tP:          ^tableID;
	hLineP,tLineP : ^string; (* pointers to header and (Table) lines *)
	p,q        : integer;
	lineCount  : word; (* for error report *)
	NewSection : Boolean;
	Classification,c      : Char;
	current    : kind;
	inTable    : boolean;
	table_Id   : String[7];
	tableTitle : String[119];
	s          : String;
	SpecialNote : String;
	sR         : sRec absolute s; (* for type cast *)
	sectionR   : castRec absolute Section;
	subFuncR   : castRec absolute SubFunc;
	dR         : dividerRec absolute s;

	F1, F2        : Text;

    function isNumber(var ti: tableId): boolean;
      var i: integer;
      begin
	isNumber:=false;
	for i:=1 to 4 do case ti[i] of '0'..'9': ; else exit; end;
	isNumber:=true;
      end; (* function isNumber in function ProcessIntList *)
    procedure insertRef;
      begin
	if inTable then AddTopic(F2,nl,'INT '+Section+' '+SubFunc, TopicStr+mainW)
	else if IntTopicStr<>'' then AddTopic(F2,nl,copy(title,1,6),IntTopicStr);
      end; (* procedure insertRef in function ProcessIntList *)
    procedure wrSection;
      begin write(Section,#13); end;

    begin
     {$I-}
      assign(F1, InPath + FName);
      reset(F1);
     {$I+}
      if IOResult <> 0 then
	begin
	  ProcessIntList := FALSE;
	  EXIT;
	end;

      writeln('Processing : ', InPath + FName);
      OpenOutFile(F2);
      write(LastSection,#13);

      readLine(F1, s);    { ignore copyright in 1st two lines }
      readLine(F1, s);
      lineCount:=2;
      current:=firstPart;
      inTable:=false;

      SpecialNote := '';


      while not(EOF(F1)) do
	begin
	  readLine(F1, s);
	  inc(lineCount);
	  NewSection := (s[1]= '-') and (Pos('--------', s) <> 0);

	  if NewSection then
	    begin
	      insertRef;
	      inTable:=false;

	      SectionR.w:=dR.w; (* chars 11..12 of divider line *)
	      SubFuncR.d:=dR.d; (* chars 13..16 of divider line *)
	      Classification := s[9];
	      if Classification = '!' then
		begin
		  delete(s,1,12);

		  q:=0;
		  while (s[q] <> '-') and (q < Length(s)) do
		    Inc(q);
		  s[0] := chr(q-1);  { remove '-' chars at the end }
		  if s='OVERVIEW' then current:=inOverview
		  else if s='FLAGS' then current:=inFlags
		  else if s='CATEGORIES' then current:=inCategories
		  else if s='CATEGORYKEYS' then current:=inKeys
		  else if s='Section' then begin
		    current:=inFileBreakSection;
		    Section:=LastSection;
		    IntTopicStr:='';
		    goto endOfLoop; (* skip file break section *)
		  end (* if s='Section' *)
		  else current:=firstPart;
		  (* Interrupt List release 41 does not include OVERVIEW
		     and CATEGORYKEYS as sections, but as separate files.
		     The program is prepared for this information being
		     parts of the List.
		  *)

		  if s = '' then s:= 'Note';   { shit ! }

		  if EOF(F1)  then   { last line of document ?}
		    goto STOP;
		  inc(TopicNo);
		  str(TopicNo, TopicStr);
		end { if Classification = '!' }
	      else
		begin
		  if section<>lastSection then begin
		    val('$'+section,INTno,q);
		    if q<>0 then begin
		      writeln('Cannot interpret interrupt number in line ',
			lineCount,': "',section,'".');
		      goto error_Exit;
		    end; (* if q<>0 *)
		  end; (* if section<>lastSection *)
		  current:=pastTest;
		  readLine(F1, s);
		  inc(lineCount);
		  inc(INTcounts[INTno]);
		  str(INTcounts[INTno], TopicStr);
		  insert(section+'_',TopicStr,1);
(* We could compare already here: "while aliasString=s do ..." if we want to
   use the orginal interrupt header line to find aliases. However,
     1. it is easier to identify the original position of an alias line,
     2. it is easier to determine the alias sequense in the config. file,
     3. it is easier to track the reason for a "not found" error, and
     4. the chance for an alias line to be unique is higher
   if we compare after the manipulation of the header line. Also, if we copy
   from the INTWIN index rather than from the original list, the lines are
   already manipulated.
*)
		  while (s[8] <> '-') do   { special flags in titel-line ? }
		    begin
		      if s[8] <> ' ' then
			SpecialNote:=SpecialNote+#13#10'\par '+GetSpecialNote(s[8]);
		      delete(s, 8, 1);
		    end;

		  Insert(subFunc+' ', S, 8);
		  while aliasString=S do begin
		    saveAlias(nextAliasPP,aliasId+TopicStr);
		    getNextAlias(aliasP,aliasId,aliasString);
		  end; (* while aliasString=S *)
		end; { else (Classification<>'!') }

	      if LastSection <> Section then
		begin
		  if Classification = '!' then begin
		    if indexColumns=1 then insertQueued;
		    IntTopicStr:='N_'+TopicStr;
		    title:='Notes';
		    if (notesCount MOD indexColumns)=0 then write(IntFile,'\par ')
		    else  write(IntFile,'\tab ');
		    inc(notesCount);
		    writeln(IntFile,'{\uldb Notes}{\v ',IntTopicStr,'}');
		  end (* if Classification = '!' *)
		  else begin (* (Classification <> '!'*)
		    if INTno<lastINTno then begin
		      (* we cannot tolerate inconsistent sorting in a
			 multi-column index.
		      *)
		      writeln('Inconsistent sorting in file ',FName,
			' line ',lineCount);
		      writeln('INT ',section,' appears after INT ',lastSection);
		      if indexColumns>1 then begin
			wl('This can be tolerated only with a single column index.');
	     error_Exit:
			errorExit('Please correct the file and try again.',1);
		      end (* if indexColumns>1 *)
		      else wl('It is recommended to correct the file.');
		    end; (* if INTno<lastINTno *)
		    if INTno<>lastINTno then begin
		      wrSection;
		      IntTopicStr:=Section+'_0';
		      if indexColumns=1 then begin
			insertQueued;
			queuedEntry:=s;
		      end; (* if indexColumns=1 *)
		      title:=INTtitles[INTno]^;
		      if title='' then title:='INT '+Section;
		      lastINTno:=INTno;
		    end; (* if INTno<>lastINTno *)
		  end; (* else (Classification <> '!') *)

		  if backRef then AddTopic(SubIntFile,nl,'Interrupts','idInterrupts');
		    (* don't insert a backward reference the very first time *)
		  backRef:=true; (* but in all the rest *)
		  NewHlpPage(SubIntFile, title, IntTopicStr,'i:0', specialClassification);
		  if twoIndexes AND indexHeaders then
		    OutLn(IndexFile,'\par '+title);
		  LastSection := Section;
		end; { if LastSection <> Section }


	      if TopicNo=1 then c:=specialClassification
		(* The initial Interrupt List section should cary the
		   indexHeader.
		*)
	      else c:=Classification;
	      NewHlpPage(F2, s, TopicStr,'l:0', c);
	      if SpecialNote <> '' then
		begin
		  writeln(F2, '{\cf0 ', SpecialNote, '}'#13#10'\par ');
		  SpecialNote := '';
		end; { if SpecialNote <> '' }

	      OutLN(F2, '{\cf0 Category: '+ Classification +
		' - ' + categoryStrings[Classification]^ + '}\par');
	      if Classification='!' then setTabs(F2, 8, deciPoints, 10)
		(* we will set tabs in the few Notes, but not in all the
		   INT entries.
		*)
	      else if markKeys then OutLN(F2,'{\b Inp.:}');
	      if twoIndexes then AddTopic(IndexFile, indentIndex, s, TopicStr);
	      AddTopic(SubIntFile, nl, s, TopicStr);
	    end { if NewSection }
	  else          { no new section }
	   begin
	     case current of
	       pastTest:     begin
      { this paragraph is un-indented to gain space for code }
      if markKeys then CheckKeyWords(s);
      if tables then case sR.w of
	ta: if (length(s)>=12) AND (sR.d=able) AND (sR.c1=' ') AND (sR.c2=')')
	  AND isNumber(sR.ti) then begin
	    hLineP:=@bufferString;
	    tLineP:=@s;
      table:
	    if eof(F1) then begin
	      writeln('Unextected end of file in table at INT ',Section,
		' Subfunc ',SubFunc);
	      wrSection;
	      goto Stop;
	    end; (* if eof(F1) *)
	    readln(F1, bufferString);
	    inc(lineCount);
	    p:=pos('(Table ',tLineP^);
	    if (p=0) OR  (length(tLineP^)<p+11) OR (tLineP^[p+11]<>')')then begin
      noTable:
	      inc(missingTableCounter);
	      if allMessages OR (missingTableCounter<=missingTableLimit) then begin
		writeln('Missing "(Table nnnn)" in INT ',Section,
		  ' Subfunc ',SubFunc,' (line ',lineCount,'):');
		writeln(pred(lineCount):5,s:succ(length(s)));
		writeln(lineCount:5,bufferString:succ(length(bufferString)));
		if missingTableCounter=missingTableLimit then begin
		  wl(#13#10'Several missing tables encountered. If '
		    +progName+' is used on release 40 or lower');
		  wl('of the List, it should be started with the program '
		    +'parameter -r40, or with key');
		  wl('releaseNo=40 in section [OPTIONS] of the configuration file.');
		  write('s=stop; m=messages; else continue without messages: ');
		  ProcessTime:=ProcessTime-memL[$40:$6C];
		  p:=readKeyWd;
		  ProcessTime:=ProcessTime+memL[$40:$6C];
		    (* sets ProcessTime "pause" ticks later than original *)
		  if word(p)<$100 then writeln (* function key *)
		  else begin
		    writeln(char(p));
		    case upcase(char(p)) of
		      'S': errorExit('Terminated by user',1);
		      'M': allMessages:=true;
		    end; (* if ... case ... of *)
		  end; (* if word(p)>$ff *)
		end; (* if missingTableCounter=missingTableLimit *)
		wrSection;
	      end; (* if allMessages ... *)
	      insert(nl,bufferString,1); (* force newline *)
	    end (* if (p=0) ... *)
	    else begin
	      tP:=@tLineP^[p+7];
	      if NOT isNumber(tP^) then goto noTable;
	      insertRef;
	      inTable:=true;
	      currentTable:=tP^;
	      table_Id:='t'+currentTable;
	      tableTitle:=Section+' '+SubFunc+' '+hLineP^;
	      while tableAliasString=tableTitle do begin
		saveAlias(nextAliasPP,tableAliasId+table_id);
		getNextAlias(tableAliasP,tableAliasId,tableAliasString);
	      end; (* while ... *)
	      NewHlpPage(F2, tableTitle, table_Id,'t:0', tableClassification);
	      if tableWindow then begin
		AddTopic(F2,nl,'Copy to Main',table_Id+mainW);
		OutLn(F2,'');
	      end; (* if tableWindow *)
	      AddTopic(TableFile,nl+currentTable+'  ',tableTitle,table_Id);
	    end; (* else *)
	end; (* case ta *)
	fo: if pos('Format of ',s)=1 then begin
      fobi:
	  hLineP:=@s;
	  tLineP:=@bufferString;
	  goto table;
	end; (* case fo *)
	bi: if pos('Bitfields for ',s)=1 then goto fobi;
	else begin
	  p:=length(s)-4;
	  for q:=p downto 1 do begin
	    if (s[q]='#') AND ((q=p) OR (s[q+5]<'0') OR (s[q+5]>'9')) then begin
	      tP:=@s[q+1];
	      if isNumber(tP^) then begin
		insert('}{\v t'+tP^+tableW+'}', S, q+5);
		insert('{\uldb ', S, q);
		if (length(s)-q>150) AND (q>20) then begin
		  (* we must ensure keeping length(S)<256 *)
		  bufferString:=copy(S, q, 255);
		  S[0]:=char(pred(q)); (* delete the copied part *)
		end; (* if (length(s)-q>150)... *)
	      end; (* if isNumber *)
	    end; (* if (s[q]='#')... *)
	  end; (* for q=p *)
	end; (* else *)
      end; (* case sR.W of *)
      { indent again }
			     end; (* case pastTest *)
	       firstPart:    check1st(s);
	       inOverview:   getINTtitle(s,INTtitles);
	       inFlags:      scan(s,flagStrings);
	       inCategories: scan(s,categoryStrings);
	       inKeys:       scan(s,categoryKeyStrings);
	       inFileBreakSection: goto endOfLoop;
	     end; (* case current of *)
	     OutLN(F2, s);
	     if bufferString<>'' then begin
	       if inTable then OutLn(F2, bufferString) (* with "newline" *)
	       else writeln(F2, bufferString); (* no "newline" (\par ) *)
	       bufferString:='';
	     end; (* if bufferString<>'' *)
	   end; { else (no new section) }

      endOfLoop:
	end; { while not(EOF(F1)) }

      STOP:
      close(F1);
      closeRTF(F2);
      ProcessIntList := TRUE;
    end;


  Procedure NewPage(VAR F: Text; Title : String);
    VAR TopicStr : String;

      begin
	Inc(TopicNo);
	str(TopicNo, TopicStr);
	AddTopic(IndexFile, nl, Title, TopicStr);
	NewHlpPage(F, Title, TopicStr,'p:0', InvalidClassification);
	setTabs(F, 8, deciPoints, 10);
      end;


  Procedure ProcessPorts(FName : String);
    LABEL STOP;
    VAR i          : integer;
	s          : String;
	TopicStr   : String;
	NewSection : Boolean;
	F1, F2     : Text;



    begin
      defaultDir(FName,InPath);
     {$I-}
      assign(F1, FName);
      reset(F1);
     {$I+}
      if IOResult <> 0 then
	begin
	  writeln('Unable to open ', FName);
	  EXIT;
	end;

      writeln('Processing : ', FName);
      OpenOutFile(F2);

      i:=length(FName);
      while FName[i]<>'\' do dec(i);
      NewPage(F2, copy(FName,succ(i),255)+' Note');

      while not(EOF(F1)) do
	begin
	  readLine(F1, s);
	  NewSection := (s[1]= '-') and (Pos('---------', s) <> 0);

	  if NewSection then
	    begin
	      readLine(F1, s);

	      if EOF(F1)  then   { last line of document ?}
		goto STOP;

	      if s <> '' then                { why does this happend }
		NewPage(F2, s);
	    end
	  else
	    begin
	     CheckKeyWords(s);
	     OutLN(F2, s);
	    end;
	end;

      STOP:
      close(F1);
      closeRTF(F2);
    end;


  Procedure ProcessFile(FName : String; Title : String);
    VAR s          : String;
	F1, F2     : Text;

    begin
      defaultDir(FName,InPath);
     {$I-}
      assign(F1, FName);
      reset(F1);
     {$I+}
      if IOResult <> 0 then
	begin
	  writeln('Unable to open ', FName);
	  EXIT;
	end;

      writeln('Processing : ', FName);
      setTabs(IndexFile, 8, deciPoints, 10);

      while not(EOF(F1)) do
	begin
	  readLine(F1, s);
	  OutLN(IndexFile, s);
	end;

      close(F1);
    end;


  Procedure Credits;
    begin
      OutLn(IndexFile,'');
      AddTopic(IndexFile, nl, 'Credits', 'IDCredit');
      OutLn(IndexFile,'');
      OutLn(IndexFile,compilationStr);
      NewHlpPage(IndexFile, 'Credits', 'IdCredit','m:1', InvalidClassification);
      OutLn(IndexFile,'\pard{\f0'+headerSize+
	'\qc\par Interrupt List (c) by {\b Ralf Brown}\par'); { \qc=centered }
      OutLn(IndexFile,'\par This list was converted from the released ASCII file'
		    + '\par to the Windows Help-Format by \par \par'
		    + '\par {\b Christian M\''81ller-Planitz}'+header2ndSize);
      OutLn(IndexFile,e_mailCredits); { e-mail address }
      writeIndex('\par\par Thanks to:');
      writeIndex(ack01);
      writeIndex(ack02);
      writeIndex(ack03);
      writeIndex(ack04);
      writeIndex(ack05);
      writeIndex('\par}');
    end;


procedure processTopics(n: integer);
(* inserts references to n topics in the CONTENTS main index *)
  var i: integer; w: string[13]; title,id: string[39];
  begin
    for i:=1 to n do begin
      str(i,w);
      insert('WINDOW ',w,1);
      title:='';
      profileString(w,'title',title,pred(sizeOf(title)));
      id:='';
      profileString(w,'id',id,pred(sizeOf(id)));
      if (title<>'') AND (id<>'') then AddTopic(IndexFile,nl,title,id);
    end; (* for i:=1 *)
  end; (* procedure processTopics *)

procedure processPages(n: integer);
(* processes n "windows" as defined in the configuration file *)
  var
    i,j,wType,files,fType: integer;
    w: string[13];
    f: string[17];
    id: string[17];
    fId,chain: string[21];
    title,fTitle: string[39];
    fileName: pathStr;
  begin
    for i:=1 to n do begin
      str(i,w);
      insert('WINDOW ',w,1);
      title:='';
      profileString(w,'title',title,pred(sizeOf(title)));
      id:='';
      profileString(w,'id',id,pred(sizeOf(id)));
      if (title<>'') AND (id<>'') then begin
	wType:=1;
	profileInt(w,'type',wType);
	files:=1;
	profileInt(w,'files',files);
	case wType of
	  1: NewHlpPage(IndexFile,title,id,'f:0',InvalidClassification);
	    (* Single entry windows *)
	  2: NewHlpPage(IndexFile,title,id,'m:9',InvalidClassification);
	    (* Multi entries windows *)
	  3: ; (* nop *)   (* Windows with own contents list *)
	end; (* case wType of *)
	for j:=1 to files do begin
	  str(j,f);
	  insert('file ',f,1);
	  fileName:='';
	  profileString(w,f,fileName,pred(sizeOf(fileName)));
	  if fileName<>'' then begin
	    fType:=wType;
	    profileInt(w,f+' type',fType);
	    case fType of
	      1: ProcessFile(fileName,title);
	      2: ProcessPorts(fileName);
	      3: begin
		(* the RTF file is expecte to be in:
		     a. the current directory.
		     b. the program's home directory
		   if no drive or root is specified.
		*)
		if ((length(fileName)<2) OR (fileName[2]<>':'))
		  AND (fileName[1]<>'\') AND (fileName[1]<>'.') then begin
		  if exist(filename) OR NOT exist(homeDir+filename) then
		    insert(currentDir,filename,1)
		  else insert(homeDir,filename,1);
		end; (* if (fileName[2]<':'... *)
		fileName:=fExpand(fileName);
		if NOT exist(fileName) then
		  writeln(#7'File ',fileName,' not found, copy to ',currentDir);
		writeln(HPJ,fileName); (* include the file name *)
	      end;
	      4: begin (* ASCII file in multi file entry *)
		str(j,fTitle);
		str(j,fId);
		insert(title+' - ',fTitle,1);
		insert(id+'_',fId,1);
		chain:=id+':5';
		profileString(w,f+' title',fTitle,pred(sizeOf(fTitle)));
		profileString(w,f+' id',fId,pred(sizeOf(fId)));
		profileString(w,f+' chain',chain,pred(sizeOf(chain)));
		NewHlpPage(IndexFile,fTitle,fId,chain,InvalidClassification);
		defaultDir(fileName,currentDir);
		ProcessFile(fileName,fTitle);
	      end; (* case 4 *)
	    end; (* case fType of *)
	  end (* if fileName<>'' *)
	  else writeln(#7'Missing file name for [',w,'] ',f);
	end; (* for j:=1 *)
      end (* if (title<>'') ... *)
      else writeln(#7'Missing title or identifier in ',w);
    end; (* for i:=1 *)
  end; (* procedure processPages *)

procedure processFilter;
  var d: dirStr;
  begin
    writeIndex('\page\pard');
    writeIndex('#{\footnote{#} idPartComp}');
    writeIndex('{\f0'+header2ndSize+' This compilation of the Interrupt List does '+#13#10
      +'not contain all the information in the List, see the '#13#10
      +'{\uldb INTERRUP.1ST File}{\v id1st} for the availability of the ');
    writeIndex('complete list.\par\par');
    writeIndex('See {\uldb Filter Method}{\v idFlt_meth} and '#13#10
      +'{\uldb Filter File}{\v idFlt_file} for details.\par}');
    d:=currentDir;
    if NOT exist('FLT_METH.RTF') then begin
      if exist(homeDir+'FLT_METH.RTF') then d:=homeDir
      else writeln(#7'File FLT_METH.RTF not found, copy to ',d);
    end; (* if NOT exist() *)
    writeln(HPJ,d,'FLT_METH.RTF');
    NewHlpPage(IndexFile, 'Filter File', 'idFlt_file','flt:1', invalidClassification);
    processFile(filterFileName,'Filter File');
  end; (* procedure processFilter *)

procedure readCategoryKeys;
(* Opens file CATEGORY.KEY if available, and reads definitions to
   categoryKeyStrings. Definitions are of the type
      A - definition A, B - definition B,
   The definitions are inserted as search keys for the appropriate
   categories. Note that more than one keyword per entry is accepted,
   separated by a semicolon, e.g. " c - cachers;spoolers,".

   Reads also title file OVERVIEW.LST.

   CATEGORY.KEY and OVERVIEW.LST are separate files in Interrupt List
   release 41+.
*)
  var t: text; s: string;
  begin
(*$I-*)
    assign(t,InPath+'category.key');
    reset(t);
(*$I+*)
    if IOresult<>0 then writeln('Unable to open ',InPath,'CATEGORY.KEY')
    else begin
      while NOT eof(t) do begin readln(t,s); scan(s,categoryKeyStrings); end;
      close(t);
    end; (* else *)
(*$I-*)
    assign(t,InPath+'overview.lst');
    reset(t);
(*$I+*)
    if IOresult<>0 then writeln('Unable to open ',InPath,'OVERVIEW.LST')
    else begin
      while NOT eof(t) do begin readln(t,s); getINTtitle(s,INTtitles); end;
      close(t);
    end; (* else *)
  end; (* procedure readCategoryKeys *)

procedure INTsToIndex;
  var i,j,k,l: word; s: string[3];
  begin
    for k:=0 to pred(indexPages) do begin
      l:=k*indexRows*indexColumns;
      for i:=0 to pred(indexRows) do begin
	OutLn(IntFile, '');
	for j:=0 to pred(indexColumns) do begin
	  if INTcounts[l+i+j*16]<>0 then begin
	    write(IntFile,'{\uldb INT ',HEX(l+i+j*16));
	    if indexColumns=4 then write(IntFile,' List');
	    write(IntFile,'}{\v ',HEX(l+i+j*16),'_0}');
	  end (* if INTcounts[]<>0 *)
	  else if indexColumns=4 then write(IntFile,'\tab ');
	  if j<pred(indexColumns) then write(IntFile,'\tab ');
	end; (* for j:=0 *)
      end; (* for i:=0 *)
      if k<pred(indexPages) then OutLn(IntFile, '');
    end; (* for k:=0 *)
  end; (* procedure INTsToIndex *)

procedure initializeArrays;
  var i: integer; ch: char;
  begin
    for ch:='!' to #126 do begin (* default to empty string *)
      flagStrings[ch]:=@emptyString;
      categoryStrings[ch]:=@emptyString;
      categoryKeyStrings[ch]:=@emptyString;
    end; (* for ch:='!' *)
    categoryStrings['!']:=@noteString;
    categoryStrings['-']:=@noneString;
    for i:=$00 to $FF do begin INTcounts[i]:=0; INTtitles[i]:=@emptyString; end;
  end; (* procedure initializeArrays *)

procedure findDateAndCopyright;
  var a,b,c,d: word; s,ss: string[99]; t: text;
  begin
    getDate(a,b,c,d);
    (*$ifdef m_dd_yy *)
      str(b*1000000+(c*1000+a MOD 100),dateString);
      dateString[length(dateString)-5]:=dateSep;
      dateString[length(dateString)-2]:=dateSep;
    (*$else*)
      (*$ifdef d_mm_yy *)
	str(c*1000000+(b*1000+a MOD 100),dateString);
	dateString[length(dateString)-5]:=dateSep;
	dateString[length(dateString)-2]:=dateSep;
      (*$else*)
	str(a*1000000+(b*1000+c),dateString);
	dateString[5]:=dateSep;
	dateString[8]:=dateSep;
	(*$ifdef yy_mm_dd *) delete(dateString,1,2); (*$endif*)
      (*$endif*)
    (*$endif*)
    getTime(a,b,c,d);
    str((a*1000+b)+100000,s);
    s[4]:=timeSep;
    s[1]:=' ';
    if a<10 then delete(s,2,1);
    dateString:=dateString+' -'+s;
  (*$I-*)
    assign(t,InPath+'interrup.lst');
    reset(t);
    if IOresult<>0 then begin
      assign(t,InPath+'interrup.a');
      reset(t);
      if IOresult<>0 then
	errorExit('Unable to open INTERRUP file in directory '+InPath,1);
    end; (* if IOresult<>0 *)
  (*$I+*)
    ReadLine(t,s);
    ReadLine(t,ss);
    close(t);
    for a:=1 to 2 do begin
      b:=pos(#9,s); (* remove two wide areas of whitespace *)
      if b<>0 then while s[b]=#9 do delete(s,b,1)
      else begin
	b:=pos('        ',s);
	if b<>0 then while s[b]=' ' do delete(s,b,1)
      end; (* else *)
      if b<>0 then insert('      ',s,b); (* insert 6 spaces instead *)
    end; (* for a:=1 *)
    indexHeader:='{\keep '+s+#13#10'\par{'+header2ndSize+' '+ss+'}'#13#10'\par';
    if scrollIndexTitle then indexHeader:=indexHeader+'\pard';
    indexHeader:=indexHeader+#13#10'\par}';
    compilationStr:=hfName+'.HLP compiled '+dateString+'.';
    if filtered then compilationStr:=compilationStr
      +' {\ul Partial compilation.}{\v idPartComp}';
  end; (* procedure findDateAndCopyright *)

procedure interpretParameters;
(* interprets program parameters and parts of the configuration file *)
  var i,argVal: integer; s: string[79]; blanks: boolean;
  procedure copyParam(var dest: string; len: byte);
    begin dest:=copy(s,3+ord(s[3]=':'),len); end;
  procedure getArgVal;
    (* assigns value of argument, or $8000, to argVal *)
    var i: integer; st: string[9];
    begin
      copyParam(st,9);
      val(st,argVal,i);
      if i<>0 then argVal:=integer($8000);
    end; (* procedure getArgVal in interpretParameters *)
  function getBool: boolean;
    begin getBool:=(length(s)<3) OR (s[3]<>'-'); end;
  procedure setSize(var fs: string; dp: word);
    (* converts decipoints to an RTF halfpoint font size string *)
    begin
      str(dp DIV 5,fs);
      insert('\fs',fs,1);
    end; (* procedure setSize in interpretParameters *)

  begin
    blanks:=true;
    (* first, check configuration file *)
    profileString('OPTIONS','build',buildExpr,pred(sizeOf(buildExpr)));
    profileString('OPTIONS','compression',compression,pred(sizeOf(compression)));
    profileString('OPTIONS','filterFile',filterFileName,pred(sizeOf(filterFileName)));
    profileBoolean('OPTIONS','singlesInMain',singlesInMain);
    profileBoolean('OPTIONS','twoIndexes',twoIndexes);
    profileBoolean('OPTIONS','errorLog',errorLog);
    profileBoolean('OPTIONS','indexHeaders',indexHeaders);
    profileInt('OPTIONS','indexColumns',indexColumns);
    profileBoolean('OPTIONS','markKeys',markKeys);
    profileBoolean('OPTIONS','equalBlanks',blanks);
    profileInt('OPTIONS','releaseNo',releaseNo);
    profileBoolean('OPTIONS','scrollIndexTitle',scrollIndexTitle);
    profileBoolean('OPTIONS','tableWindow',tableWindow);
    profileBoolean('OPTIONS','expandedIndex',expandedIndex);
    (* second, check parameters *)
    for i:=1 to paramCount do begin
      s:=paramStr(i);
      case s[1] of
	'/','-': begin
	  if length(s)=1 then errorExit(
	    'Missing option after "'+s+'"',1);
	  case upcase(s[2]) of
	    'B': copyParam(buildExpr,pred(sizeOf(buildExpr)));
		(* legal: any .HPJ [OPTIONS] build= expression *)
	    'C': begin
	      copyParam(compression,pred(sizeOf(compression)));
		(* legal: 0, 1, no, yes, low, medium, high. Not checked *)
	      if compression='' then compression:='YES';
		(* default if "-c" or "-c:" is specified *)
	    end; (* case 'C' *)
	    'F': begin
	      copyParam(filterFileName,pred(sizeOf(filterFileName)));
	      if filterFileName='' then errorExit(
		'No filter file name specified after "'+s+'"',1);
	      filtered:=true;
	    end; (* case 'F' *)
	    '1': singlesInMain:=getBool;
	    '2': twoIndexes:=getBool;
	    'E': errorLog:=getBool;
	    'H': indexHeaders:=getBool;
	    'I': begin getArgVal; indexColumns:=argVal; end;
	    'M': markKeys:=getBool;
	    'Q': blanks:=getBool;
	    'R': begin getArgVal; releaseNo:=argVal; end;
	    'S': scrollIndexTitle:=getBool;
	    'T': tableWindow:=getBool;
	    'X': expandedIndex:=getBool;
	    else errorExit('Unknown option: '+s,1);
	  end; (* case upcase(s[2] of *)
	end; (* case '/','-' *)
	else begin
	  if InPath='' then InPath:=s
	  else if OutPath='' then OutPath:=s
	  else errorExit('Too many parameters: '+s,1);
	end; (* case else *)
      end; (* case s[1] of *)
    end; (* for i:=1 *)
    (* if file paths were not program parameters, try configuration file *)
    if InPath='' then profileString('FILES','InPath',InPath,pred(sizeOf(InPath)));
    if OutPath='' then profileString('FILES','OutPath',OutPath,pred(sizeOf(OutPath)));
    (* read windows settings from configuration file *)
    profileString('CONFIG','pos and size',windowsPosSize,pred(sizeOf(windowsPosSize)));
    profileString('CONFIG','secondary pos and size',
      secWindowsPosSize,pred(sizeOf(secWindowsPosSize)));
    profileString('CONFIG','background',windowsBackgr,pred(sizeOf(windowsBackgr)));
    profileString('CONFIG','header background',windowsHdrBackgr,pred(sizeOf(windowsHdrBackgr)));
    profileString('CONFIG','header font',headerFont,pred(sizeOf(headerFont)));
    profileString('CONFIG','text font',textFont,pred(sizeOf(textFont)));
    profileInt('CONFIG','deciPoints',integer(deciPoints));
    profileInt('CONFIG','header deciPoints',integer(headerDeciPoints));
    profileInt('CONFIG','header 2nd deciPoints',integer(header2ndDeciPoints));
    (* update other values *)
    indexRows:=16; (* in most cases *)
    indexPages:=1; (* in two cases *)
    case indexColumns of
      1: indexRows:=256;
      4: indexPages:=4;
      8: indexPages:=2;
      16: ; (* already ok *)
      else errorExit('Illegal index columns, only 1, 4, 8, or 16 accepted',1);
    end; (* case indexColumns of *)
    if NOT blanks then begin
      equStr[4]:='=';
      equStr[0]:=#4; (* equStr = ' Ax=' *)
      equBlanks:=0;
    end; (* if NOT blanks *)
    setSize(fontSize,deciPoints);
    setSize(headerSize,headerDeciPoints);
    setSize(header2ndSize,header2ndDeciPoints);
    filtered:=filterFileName<>'';
    if NOT indexHeaders then indentIndex:=nl;
    if releaseNo<41 then begin tables:=false; tableWindow:=false; end;
    if NOT tableWindow then begin mainW:=''; tableW:=''; end;
  end; (* procedure interpretParameters *)

  const
    windows: integer = 0;

  var
    ch: char;

  begin
    Intro;
    if (paramStr(1)='?') OR (paramStr(1)='-?') OR (paramStr(1)='/?')
      then Explain; (* and exit *)

    fSplit(paramStr(0),homeDir,currentDir,currentDir);
      (* works only with DOS 3.30+ - currentDir is used as a dummy *)
    currentDir:=fExpand('.');
    if length(currentDir)>3 then begin
      inc(currentDir[0]);
      currentDir[length(currentDir)]:='\';
    end; (* if length()... *)
    interpretParameters;
    initializeArrays;
    nextAliasPP:=@firstAliasP;

    if InPath='' then begin
      write('Source directory: ');
      readln(InPath);
    end; (* if InPath='' *)
    if InPath<>'' then begin
      ch:=InPath[length(InPath)];
      if (ch<>':') AND (ch<>'\') then
	begin inc(InPath[0]); InPath[length(InPath)]:='\'; end;
    end; (* if InPath<>'' *)

    if OutPath='' then begin
      write('Dest. directory (has to be created in advance) : ');
      readln(OutPath);
    end; (* if OutPath='' *)
    if OutPath<>'' then begin
      ch:=OutPath[length(OutPath)];
      if (ch<>':') AND (ch<>'\') then
	begin inc(OutPath[0]); OutPath[length(OutPath)]:='\'; end;
    end; (* if OutPath<>'' *)

    ProcessTime:=memL[$40:$6C]; { timer ticks since midnight }
    findDateAndCopyright;
    CreateHPJ;

    OpenRTF(IndexFile, 'INDEX.RTF');
    NewHlpPage(IndexFile, 'Contents:', 'CONTENTS','m:2', specialClassification);

    readCategoryKeys; (* reads also titles *)
    OpenRTF(IntFile,   'INT.RTF');
    OpenRTF(SubIntFile,'SUBINT.RTF');
    if tables then OpenRTF(TableFile,'TABLE.RTF');

    if twoIndexes then
      AddTopic(IndexFile, nl, 'Interrupt Index',
	'!IfThenElse(IsMark("Compressed_Index"), '
	+'`JumpId("","idInterrupts")'', `JumpId("","idIndex")'')')
    else AddTopic(IndexFile, nl, 'Interrupts', 'idInterrupts');
    if tables then AddTopic(IndexFile, nl, 'Tables', 'idTables');
    AddTopic(IndexFile, nl, 'FILELIST', '1');
    AddTopic(IndexFile, nl, 'INTERRUP.1ST File', 'id1st');
    if filtered then begin
      AddTopic(IndexFile, nl, 'Filter Method', 'idFlt_meth');
      AddTopic(IndexFile, nl, 'Filter File', 'idFlt_file');
    end; (* if filtered *)

    profileInt('WINDOWS','number',windows);
    processTopics(windows); (* insert Ports, Memory etc. in index *)

    Credits;

    if twoIndexes then begin
      NewHlpPage(IndexFile, 'Interrupt Index', 'idIndex','m:3', specialClassification);
      AddTopic(IndexFile, nl, 'Compress index',
	'!SaveMark("Compressed_Index");JumpId("","idInterrupts")');
      { the program adds all following entries }
    end; (* if twoIndexes *)
    NewHlpPage(IntFile, 'Interrupts', 'idInterrupts','m:4', specialClassification);
    if twoIndexes then begin
      AddTopic(IntFile, nl, 'Expand index','!IfThen(IsMark("Compressed_Index"),'
	+' `DeleteMark("Compressed_Index")'');JumpId("","idIndex")');
      OutLn(IntFile, '');
      if indexColumns>1 then setTabs(IntFile, succ(ord(indexColumns<=4))*8,
	deciPoints, pred(indexColumns));
    end; (* if twoIndexes *)

    if tables then NewHlpPage(TableFile, 'Tables\f1'+fontSize
      +'\par\par Tab# INT Func Title','idTables','m:5', invalidClassification);
      (* "Tab# INT Func Title" in normal text font and size *)

    profileList('ALIAS',aliasP); (* read [ALIAS] section from config. file *)
    getNextAlias(aliasP,aliasId,aliasString); (* get the first one (if any) *)
    profileList('TABLEALIAS',tableAliasP);
    getNextAlias(tableAliasP,tableAliasId,tableAliasString);

    (* process either "interrup.lst" or "interrup.a".."interrup.?" *)
    if NOT ProcessIntList('interrup.lst') then begin
      ch := 'a';
      while ProcessIntList('interrup.'+ch) do inc(ch);
    end; (* if NOT ProcessIntList() *)

    if aliasString<>'' then begin
      writeln(#7'Alias string not found:'#13#10+'  "',aliasString,'"');
      if aliasP<>NIL then
	wl('One or more alias strings not processed.');
    end; (* if aliasP<>NIL *)
    if tableAliasString<>'' then begin
      writeln(#7'Table alias string not found:'#13#10+'  "',
	tableAliasString,'"');
      if tableAliasP<>NIL then
	wl('One or more table alias strings not processed.');
    end; (* if tableAliasP<>NIL *)

    if indexColumns=1 then insertQueued
    else INTsToIndex;

    NewHlpPage(IndexFile, 'INTERRUP.1ST File', 'id1st','f:0', invalidClassification);
      { the program adds all following entries }
    ProcessFile('interrup.1st', 'INTERRUP.1ST File');
    if filtered then processFilter;

    closeRTF(IntFile);
    closeRTF(SubIntFile);
    if tables then closeRTF(TableFile);

    processPages(windows); (* process Ports, Memory etc. *)

    if firstAliasP<>NIL then begin
      writeln(HPJ,#13#10'[ALIAS]');
      processAliasList(firstAliasP);
    end; (* if (firstAliasP<>NIL)... *)
    closeRTF(IndexFile);
    close(HPJ);
    if missingTableCounter>=missingTableLimit then
      writeln(missingTableCounter,' missing tables encountered.');
    ProcessTime:=memL[$40:$6C]-ProcessTime;
    writeln('The processing took ',(ProcessTime*10+91) DIV 182,' seconds.');
      (* 18.2 clock ticks per second, rounded *)
  end.
