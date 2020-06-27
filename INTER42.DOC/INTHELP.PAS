Program IntHelp;

uses GLOBAL, OPSTRING, OPROOT, UserInterFace;
var
    {First of all some general (mostly dummy) variables}
  DummyStr, InputF,
  OutputF         : String;
  DummyLst        : SingleListPtr;
  DummyInt        : Integer;
  DummyNode,
  DummyNode2      : IntDataPtr;
  DummyBool, InINT: Boolean;
  Counter, CurInt : Byte;
  LineCount       : LongInt;
  LastTopic       : Word;
  OutFile, InFile : Text;

    {We use the following datastructure to keep the information about the
     INT's (in order to be able to X-reference) : 
     1. an array (IntArray) containing (per INT number) a list of items 
        (different values of registers, ... for the same INT) ;
     2. a list (IntList) containing all the items in the same order as
        they were encountered in the inputfile.

     Remark : In fact there is one long list (IntList) and the array 
              (IntArray) contains pointers, pointing into this one list.}

  IntArray        : Array[0..255] of SingleListPtr;
  IntList         : SingleListPtr;

  {--------------------------------------------------------------------}
  function SeeAlso(InThe : String):SingleListPtr;
   {InThe is supposed to be a string with X-references to other INT items.
    This X-references should obey the syntax rules of the Ralph Brown
    INT list of 1/5/91. The code should be changed according to changes
    of these rules

    The result of this function is a list containing the X-refs in a
    'formal' way (a record).

    X-references are supposed to be separated by a comma.  Each X-ref is
    called 'Item' in this function                                       }


  const
    Laatste : Byte = Byte(InThe[0]);
                              {Index of the last character in 'InThe'}
  var
    Result      : SingleListPtr;
    TempNode,                 {Dummy, used when copying last node}
    DummyNode   : IntDataPtr; {'Running' node to find Result}
    ItemNr,                   {Sequence number of Item}
    NextOne     : Byte;       {Sequence number of next part in item}
    LastName,                 {Name of last part that has been dealt with}
    Name        : String[2];  {Name of part that is being dealt with}
    Item, Value,              {Item which is to be (or being) dealt with and 
                              value of current subpart}
    Main, Sub1,
    Sub2        : String;     {Subparts of the item that is being dealt with}
    {------------------------------------------------------------------}
    procedure FillDummy (Name, Value : String);
      {This procedure is rather self-explanatory}
    begin
      if Name = 'AX' then
        DummyNode^.AX := Value
      else
        if Name = 'AH' then
          DummyNode^.AX := Value + '00'
        else
          if Name = 'AL' then
            DummyNode^.AX := '00' + Value
          else begin
            DummyNode^.Other.Name  := Name;
            if Length (Value) = 2 then
              DummyNode^.Other.Value := Value + '  '
            else
              DummyNode^.Other.Value := Value;
          end{if};
    end{FillDummy};
    {------------------------------------------------------------------}
  begin
  {Initialization part}
    New(Result, Init);
    ItemNr   := 1 ;          {start with the first item}
    LastName := '';          {we haven't dealt with items yet, so we 
                              haven't got a name to remember either.

                              Get the first item                       }
    Item := Trim (ExtractWord (ItemNr, InThe, [',']));
    while Item <> '' do begin   {While there are still items in 'InThe'}
      New (DummyNode, Init);    {Initialize a dummy node}
      DummyNode^.Text := ExtractWord (2, Item, ['"']);
                                {Each item can consist of 3 parts, so 
                                get these parts                       }
      Main := Trim (ExtractWord (1, Item, ['/']));
      Sub1 := Trim (ExtractWord (2, Item, ['/']));
      Sub2 := Trim (ExtractWord (3, Item, ['/']));

      {Deal with the main part (which certainly exists)}

      if Main[1] = 'I' then begin
                                {Main == 'INT ##' and it is followed by
                                a space or a quote                    }
        DummyNode^.INT := ExtractWord (2, Main, [' ','"']);
        LastName       := '';   {No name to recall                     } 
      end else begin            {if it's not 'INT ......'              }
            if WordCount (Main, ['=']) = 1 then begin
                                {No name given for the main part, so 
                                the name is 'inherited' from the previous
                                Item                                  }
              Name     := LastName;
              NextOne  := 1;
              TempNode := IntDataPtr (Result^.Tail);
                                {Almost all the values must be copied
                                from the last X-ref                   }
              DummyNode^.INT        := TempNode^.INT;
              DummyNode^.AX         := TempNode^.AX;
              DummyNode^.Other.Name := TempNode^.Other.Name;
            end else begin      {Jot down the new name for main element}
              Name     := Trim (ExtractWord (1, Main, ['=']));
              LastName := Name;
              NextOne  := 2;
            end{if};
            {Find the value of the main element (when it's not INT)    }
            Value := Trim (ExtractWord (NextOne, Main, ['h','"','=']));
            {And finally note the name and value of the main part      }
            FillDummy (Name, Value);
      end{if};

      {Deal with the second part, if present}

      if Sub1 <> '' then begin
        Name     := Trim (ExtractWord (1, Sub1, ['=']));
        Value    := Trim (ExtractWord (2, Sub1, ['=','h','"']));
        LastName := Name;
        FillDummy (Name, Value);
      end{if};

      {And finally the third part, if present}

      if Sub2 <> '' then begin
        DummyNode^.Other.Name  := Trim (ExtractWord (1, Sub2, ['=']));
        DummyNode^.Other.Value := Trim (ExtractWord (2, Sub2, ['=','"','h']));
      end{if};

      Result^.Append (SingleNodePtr (DummyNode));
      Inc(ItemNr);              {Get the following X-ref}
      Item := Trim (ExtractWord (ItemNr, InThe, [',']));
    end{while};
    SeeAlso := Result;
  end{SeeAlso};
  {--------------------------------------------------------------------}
  function Parse  (INT : String):IntDataPtr;
    {Interprets the 'useful' part of the line containing information
     about the following INT item (the line starting with '----------'
     and returns that information in a record (pointer to a ...)}
  var
    Result       : IntDataPtr;
    AH, AL, Name : String[2];
    Value        : String;
  begin
    New (Result, Init);

      {Determine the value of AX, supposing that no value will be given
      to AL without supplying a value for AH (Ralph ?)                }

    if INT[13] = '-' then begin {if AH isn't supplied then             }
      AH := '  ';               {  it's value is empty                 }
      AL := '  ';               {  and so is AL's                      }
    end else begin              {Otherwise                             }
      AH := INT[13] + INT[14];  {  take note of its value and          }
      if INT[15] <> '-' then    {  see if AL has been specified        }
        AL := INT[15] + INT[16] {    if so : take note of its value    }
      else
        AL := '00';             {    else give it a '00' value         }
    end{if};

      {If applicable : take note of the name and type of other register}

    if INT[17] <> '-' then begin{if another register has been specified}
      Name := INT[17] + INT[18];{  Note name and value                 }
      if INT[21] = '-' then begin
                                {If the value has only two figures then}
        Value := INT[19] + INT[20];         {- jot down the value      }
        if (Name = 'AL') then begin         {- and if it's al then :   }
          AL    := INT[19] + INT[20];       {  * note the value in AL  }
          Name  := '  ';                    {  * and strike out the    }
          Value := '   ';                   {    noted name and value  }
          if AH = '  ' then                 {  * change AH if necessary}
            AH := '00';
        end{if};
      end else                              {it's a 4 character value  }
        Value := INT[19] + INT[20] + INT[21] + INT[22];
    end else begin
      Name  := '  ';                        {no supplemental register  }
      Value := '    ';
    end{if};

      {Finally construct the 'Result' from what we've found}

    Result^.INT := INT[11] + INT[12];
    Result^.AX  := AH + AL;
    Result^.Other.Name  := Name;
    Result^.Other.Value := Value;

    Parse := Result;
  end{Parse};

  {--------------------------------------------------------------------}

  function Topic (TheItem : IntDataPtr;
                  InThe   : SingleListPtr):Word;
    {Result : the topic number of 'TheItem' if 'TheItem' can be found
              in 'InThe'. Else returns 0}
  var
    TheNode  : IntDataPtr;
    NotFound : Boolean;
    {------------------------------------------------------------------}
    function IsPartOf (TheOne, TheOther : IntDataPtr):Boolean;
      {Returns TRUE if the register information of TheOne is equal to 
      that of TheOther and if the Text information of TheOne is part of
      the Text information of TheOther}
    var
      Result : Boolean;
    begin
      Result := ((TheOne^.AX = TheOther^.AX) and
                (TheOne^.Other.Name = TheOther^.Other.Name) and
                (TheOne^.Other.Value = TheOther^.Other.Value));
      if Length (TheOne^.Text) <> 0 then
        Result := (Result and
                  (Search (TheOther^.Text[1], Length (TheOther^.Text),
                          TheOne^.Text[1], Length (TheOne^.Text)) <> $FFFF));
      IsPartOf := Result;
    end;{IsPartOf}
    {------------------------------------------------------------------}
  begin
    NotFound := True;
    TheNode  := IntDataPtr (InThe^.Head);
    while ((TheNode <> nil) and NotFound) do begin
      NotFound := (not IsPartOf (TheItem, TheNode));
      if NotFound then
        TheNode := IntDataPtr (InThe^.Next (TheNode));
    end{while};
    if NotFound then
      Topic := 0
    else
      Topic := TheNode^.Topic;
  end{Topic};
  {--------------------------------------------------------------------}
  procedure GetLine (var TheLine : String);
    {Reads one line from the inputfile into 'TheLine'}
  begin
    ReadLn (InFile, TheLine);
      {The two following commands are included merely to allow you to
       signal the user what we're doing}
    Inc(LineCount);
    PutLineNumber (LineCount);
  end{GetLine};
  {------------------------------------------------------------------}
  function IsINT (TheLine : String): Boolean;
    {Returns TRUE if 'TheLine' as a string indicating the start of 
     information about a new interrupt item (i.e. '----------XX........')
     where XX stands for the hexadecimal INT number}
  begin
    IsINT := ((Length(TheLine) <> 0) and
              (ExtractWord (1, DummyStr, ['0','1','2','3','4','5','6','7',
                                          '8','9','A','B','C','D','E','F'])
                            = '----------'));
  end{IsINT};
  {------------------------------------------------------------------}
  procedure Initialize;
                  {Initialize everything}
  begin
    GetFileNames (InputF, OutputF);
    Assign (InFile, InputF);
    Assign (OutFile, OutputF);
    Reset(InFile);
    Rewrite(OutFile);
    LastTopic := 0;
    LineCount := 0;
    CurInt    := 255;
      {OK, I lied. I'm not really treating INT FF, so what ?}
    for Counter := 0 to 255 do
      New (IntArray[Counter], Init);
    New (IntList, Init);
      {Signal to 'UserInterface' that we're about to start}
    StartPass1;
      {Write the first (formatting) information to the output file}
    writeln(OutFile, '!WIDTH 76');
    writeln(OutFile, '!NOWRAP');
  end{Initialize};
  {------------------------------------------------------------------}
  function MakeHeader (ForNode : IntDataPtr):String;
    {Returns a string which can be used as a header for the help window
     for the item to wich ForNode points : 
        INT = xx / yy = zz
     where xx stands for the INT number, yy optionally stands for an 
     additional register name and zz for the value of that register}
  var
    Result : String;
  begin
    Result := 'INT = ' + ForNode^.INT;
    if ForNode^.AX <> '    ' then
      Result := Result + ' / AX = ' + ForNode^.AX;
    if ForNode^.Other.Name <> '  ' then
      Result := Result + ' / ' + ForNode^.Other.Name + ' = '
                       + ForNode^.Other.Value;
    MakeHeader := Result;
  end{MakeHeader};
  {------------------------------------------------------------------}
  procedure BuildIntList;
    {During a first pass through the input file, IntList and IntArray
     are filled with the necessary data about the interrupts to be able
     to X-reference the help file (i.e. implement the 'See Also : ...')}

    {After this routine, the input file has been 'rewound' and is ready
     to be read again}
  begin
    while not EOF (InFile) do begin
      GetLine (DummyStr);
      if IsINT(DummyStr) then begin     {if it's an 'INT' line}
        Inc (LastTopic);                { then get a new topic number       }
        DummyNode := Parse (DummyStr);  {      get the data from that line  }
        DummyNode^.Topic := LastTopic;  {      note down the topic number   }
        GetLine (DummyStr);             {      read the line with additional
                                               data and take note of this 
                                               data                         }
        for Counter := 10 to Length (DummyStr) do
          DummyNode^.Text[Counter - 9] := DummyStr[Counter];
        DummyNode^.Text[0] := Chr (Counter - 9);
                                        {      Finally append the node to 
                                               the appropriate list(s)      }
        if Str2Int ('$'+DummyNode^.INT, DummyInt) then begin
          IntArray[DummyInt]^.Append (SingleNodePtr (DummyNode));
          IntList^.Append (SingleNodePtr (IntArray[DummyInt]^.Tail));
        end else                        {if Ralph changes his 'syntax' !!   }
          writeln ('Error on line ',LineCount:1);
      end{if};
    end{while};
                                        {'Rewind' the input file            }
    Reset (InFile);
    LineCount := 0;
  end{BuildIntList};
  {------------------------------------------------------------------}
  procedure TreatSeeAlso (TheItem : String);
    {TheItem is supposed to be the string that follows a 'See Also :'

     This procedure will take 'TheItem' (in fact a X-reference list) and
     write into the outputfile the code necessary to implement this
     'SEE ALSO' X-referencing in the help system                     }
  var
    SeeList : SingleListPtr;
    TheNode : IntDataPtr;
    INTNr   : Integer;
    DBool   : Boolean;
    Text    : String;
  begin
    writeln (OutFile, 'SeeAlso : ');
    SeeList := SeeAlso (TheItem);   {Construct a X-ref list}
    TheNode := IntDataPtr (SeeList^.Head);
    while TheNode <> nil do begin
      {Write the necessary code into the outputfile per X-ref}
      if TheNode^.INT = '  ' then begin
        INTNr := Integer (CurInt);  {No INT number given, meaning the}
        Text  := '';                {number hasn't changed           }
      end else begin
        DBool := Str2Int ('$'+TheNode^.INT, INTNr);
        Text  := 'INT ' + TheNode^.INT;
      end{if};
      if TheNode^.AX <> '    ' then
        Text := Text + ' AX=' + TheNode^.AX;
      if TheNode^.Other.Name <> '  ' then
        Text := Text + ' ' + TheNode^.Other.Name + '=' + TheNode^.Other.Value;
      Text := Trim (Text + ' ' + TheNode^.Text);
      writeln (OutFile, '  ',Chr(4), Topic (TheNode, INTArray[INTNr]):1,
                             Chr(5), Detab (Text,8), Chr(5));
      TheNode := IntDataPtr (SeeList^.Next (SingleNodePtr (TheNode)));
    end{while};
  end{TreatSeeAlso};
  {------------------------------------------------------------------}
  procedure TakeNote (StartingWith : String);
    {Writes the necessary code to 'highlight' the part of 'StartingWith'
     that comes before a colon in that string                         }
  var
    Temp  : String;
    Count : Byte;
  begin
    Temp := ExtractWord (1, StartingWith, [':']);
    write   (OutFile, Chr(1));
    Insert  (Chr(1), StartingWith, Length (Temp) + 1);
    writeln (OutFile, Detab (StartingWith, 8));
  end{TakeNote};
  {------------------------------------------------------------------}

begin
  Initialize;
  BuildIntList;
  StartPass2;
  DummyNode := IntDataPtr (IntList^.Head);
    {From here on, DummyNode is the following node to be dealt with}
  DummyStr := '';
    {Skip introductory text in the input file}
  while ((not IsINT (DummyStr)) and (not EOF (InFile))) do
    GetLine (DummyStr);

  InINT := True;  {We are working with INT data in the input file}
  while not EOF (InFile) do begin
    if IsINT (DummyStr) then begin
      {If this line starts a new INT item}
      DummyBool := Str2Int ('$' + DummyNode^.INT, DummyINT);
      if (DummyINT <> CurINT) then begin
        {If it's a new INT number, we have to create a new main TOPIC in the
         output file                                                        }
        CurINT := DummyINT;
        Inc (LastTopic);
        writeln (OutFile, '!TOPIC ',LastTopic:1,' INT ',DummyNode^.INT);
        writeln (OutFile, '!INDEX ',CurINT:1);
        DummyNode2 := IntDataPtr (IntArray[CurInt]^.Head);
        for DummyInt := 1 to IntArray[CurInt]^.Size do begin
          write (OutFile, Chr(4), DummyNode2^.Topic:1, Chr(5));
          if DummyNode2^.AX <> '    ' then
            write (OutFile, 'AX=', DummyNode2^.AX, ' ');
          if DummyNode2^.Other.Name <> '  ' then
            write (OutFile, DummyNode2^.Other.Name,'=',DummyNode2^.Other.Value,' ');
          if DummyNode2^.Text <> '' then
            write (OutFile, Detab (DummyNode2^.Text,8), ' ');
          writeln (OutFile, Chr(5));
          DummyNode2 := IntDataPtr (IntArray[CurInt]^.Next
                                         (SingleNodePtr (DummyNode2)));
        end{for};
      end{if};
        {We always have to make a TOPIC for this INT itself}
      writeln (OutFile, '!TOPIC ',DummyNode^.Topic:1,' ', MakeHeader (DummyNode));
      writeln (OutFile, '!NOINDEX');
        {Write an appropriate header}
      writeln (OutFile, Detab (Dummynode^.Text, 8));
        {Read the supplementary data (which is useless during this pass}
      GetLine (DummyStr);
      DummyNode := IntDataPtr (IntList^.Next (SingleNodePtr (DummyNode)));
    end else
      {if it's a X-Ref string}
      if Pos ('SeeAlso:', DummyStr) <> 0 then
        TreatSeeAlso (TrimSpaces (ExtractWord (2, DummyStr, [':'])))
      else
        {if it's a 'note'}
        if Pos ('Note', DummyStr) = 1 then
          TakeNote (DummyStr)
        else {no INT, no SeeAlso, no Notes, just plain text}
          writeln (OutFile, Detab (DummyStr, 8));
    GetLine (DummyStr);
    InINT := (DummyStr <> '---------------------------------------------');
      {I have noticed that plain text, containing no information whatsoever
       about INTs is separated from the 'useful' information by a line
       filled with '-'.

       If such a line is encountered, skip everything until the EOF is
       or a new INTline is encountered}
    while (not InINT) and (not EOF (InFile)) do begin
      GetLine (DummyStr);
      InINT := IsINT (DummyStr);
    end{while};
    {end if}
  end{while};
  Dec(LastTopic);
  UserInterface.Finished(LastTopic);
end{IntHelp}.
