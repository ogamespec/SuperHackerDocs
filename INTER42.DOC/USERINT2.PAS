unit UserInt2;
{The 'plain' userinterface}

{if you want to use this one, rename the unit and the file to 'UserInterface'
 and recompile the main program}
interface
  procedure GetFileNames (var InFile, OutFile : String);
  procedure StartPass1;
  procedure StartPass2;
  procedure PutLineNumber (Number : LongInt);
  procedure Finished (LastTopic : Word);

implementation
uses DOS, OPDOS, OPSTRING, OPCRT, OPROOT;

var
  InputF, OutputF  : String;
  LastLine         : LongInt;
  CursorX, CursorY : Byte;

  {------------------------------------------------------------------}
  function GetTheName (Echo : String; MustExist : Boolean):String;
  var
    Result : String;
    Found  : Boolean;
  begin
    Found := False;
    while not Found do begin
      Write (Echo);
      Readln (Result);
      if MustExist then
        Found := ExistFile (Result)
      else
        Found := True;
      if not Found then
        writeln ('File doesn''t seem to exist');
    end{while};
    GetTheName := Result;
  end{GetTheName};
  {------------------------------------------------------------------}
  procedure GetFileNames (var InFile, OutFile : String);
  var
    Parameters : String;
  begin
    InFile  := ParamStr (1);
    OutFile := ParamStr (2);
    if InFile = '' then             {No parameters given when invoking}
      InFile := GetTheName ('Input File : ', True);
    if OutFile = '' then
      OutFile := GetTheName ('Output File : ', False);
  end{GetFileNames};
  {------------------------------------------------------------------}
  procedure PutLineNumber (Number: LongInt);
  begin
    LastLine := Number;
    GotoXYAbs (CursorX, CursorY);
    Write (Number:7);
  end;
  {------------------------------------------------------------------}
  procedure StartPass1;
  begin
    writeln('Pass 1 :');
    WhereXYDirect (CursorX, CursorY);
  end{StartPass1};
  {------------------------------------------------------------------}
  procedure StartPass2;
  begin
    writeln;
    writeln('Pass 2 :');
    WhereXYDirect (CursorX, CursorY);
  end{StartPass2};
  {------------------------------------------------------------------}
  procedure Finished (LastTopic : Word);
  var
    Key : Word;
  begin
    writeln;
    writeln ('Highest Topic number :',LastTopic:1);
    Key := ReadKeyWord;
  end{Finished};
  {------------------------------------------------------------------}
end.
