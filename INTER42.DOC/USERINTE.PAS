unit UserInterface;

{the fancy user interface}
{if you want to write your own user interface, you should write a unit,
 having the same name and interface as this one and recompile the 
 INTHELP program }

interface
  procedure GetFileNames (var InFile, OutFile : String);
    {Is called by INTHELP to retrieve the names of the input (InFile) and 
     output (OutFile) file.}
  procedure StartPass1;
    {Is called by INTHELP prior to starting its first pass on the input 
     file. You could use this procedure (and the following) to keep the 
     user informed about the work that is being done by the program}
  procedure StartPass2;
    {Is called by INTHELP prior to starting the second pass on the input
     file}
  procedure PutLineNumber (Number : LongInt);
    {Is called by INTHELP each time a new line is read from the input file.
     Number specifies the line number of that line.}
  procedure Finished (LastTopic : Word);
    {Is called by INTHELP when it has finished its work.  LastTopic specifies
     the highest topic number used by INTHELP.}

implementation
uses DOS, OPDOS, OPPICK, OPSTRING, OPCMD, OPCRT, OPDIR,
     OPENTRY, OPFIELD, OPFRAME, OPROOT, OPSELECT, OPWINDOW;
    {quite a list, isn't it}
const
  LeftX  : Byte = 19;
  RightX : Byte = 60;
  TopY   : Byte = 8;
  BottomY: Byte = 10;
  LinePut: Byte = 3;
var
  InputF, OutputF : String;
    {The names of the input and output file are remembered, so we will be
     able to include them in the information provided by the program
     when giving the user a clue about what the program is doing.}
  Dir             : DirList;
  Display         : RawWindow;
    {The window we'll use to keep the user informed about our whereabouts.}
  LastLine        : LongInt;
    {We keep the last linenumber we've printed, so we can include this 
     information in our INFOwindow}

  {Internal Procedures}

  {$V-}{$F+}
  procedure PreEdit(ESP : EntryScreenPtr);
  var
    Finished : Boolean;
    {----------------------------------------------------------------}
    procedure InitDir;
    begin
    {Initialize the DIRLIST object which might be used to ask for the }
    {name of the input file                                           }
      if not Dir.InitCustom(20, 15, 69, 24,   {Window coordinates}
                            DefaultColorSet,
                            DefWindowOptions or wBordered,
                            MaxAvail,
                            PickSnaking,      {Pick orientation}
                            SingleFile)       {Command handler}
      then Halt; {Sorry Folks, something went wrong}
      {DirList features}
      Dir.SetDirAttr($1E,AutoMapMono); {Color of a directory name     }
      Dir.AddRejectString('PAS');      {Filenames with the following  }
      Dir.AddRejectString('EXE');      {extensions shouldn't be shown }
      Dir.AddRejectString('COM');
      Dir.AddRejectString('BIN');
      Dir.AddRejectString('BAK');
      Dir.AddRejectString('TPU');
      Dir.SetRejectFunc(RejectExtensions);
      Dir.SetPadSize(1, 1);
      Dir.diOptionsOn(diOptimizeSize);
      Dir.wFrame.AddHeader(' Select a File ', heTC);
      Dir.SetSortOrder(SortDirName);   {Sort order : first directories
                                                     then filenames   }
      Dir.SetNameFormat;               {Show filenames only           }
      Dir.SetMask('*.*', ReadOnly+Directory+Archive);
    end{InitDir};
    {----------------------------------------------------------------}
  begin
    case ESP^.GetCurrentID of
      0 : begin {Field 0 = entry field for filename of inputfile}
            if not ExistFile (InputF) then begin
                {specified filename doesn't exist}
              InitDir;
              ESP^.wFastWrite('Specify existing input file', 4, 7, TextAttr);
              Finished := False;
              repeat
                Dir.Process;
                case Dir.GetLastCommand of
                  ccSelect :
                    begin
                      InputF   := Dir.GetSelectedPath;
                      Finished := True;
                    end;
                  ccError  :
                    begin              
                      Finished := True;
                    end;               
                  ccQuit   :
                    Finished := True;
                end;{case}
              until Finished;
              Dir.Done;
            end;{if}
            ESP^.DrawField(0);
          end{block};
      1 : ESP^.wFastWrite('    Specify output file    ', 4, 7, TextAttr);
    end {case};
  end;
  {------------------------------------------------------------------}
  procedure PostEdit (ESP:EntryScreenPtr);
  begin
    case ESP^.GetCurrentId of
      0: ;
      1: if ExistFile (InputF) then
           ESP^.SetLastCommand(ccQuit);
    end;
  end;
  {------------------------------------------------------------------}
  {$F-}
  procedure GetTheNames;
  var
    ES       : EntryScreen;
    Finished : Boolean;
  begin
    {Initialize the 'EntryScreen'}
    if not ES.InitCustom(25, 5, 65, 8,     {Window coordinates}
                         DefaultColorSet,  {ColorSet}
                         DefWindowOptions OR wBordered)
    then begin
      WriteLn('Failed to init EntryScreen. Status = ', InitStatus);
      Halt;
    end;
    {add some window frills}
    ES.wFrame.AddShadow(shBR, shOverWrite);
    ES.wFrame.AddHeader(' Enter File Names ', heTC);
    {add fields}
    ES.esFieldOptionsOn(efClearFirstChar);
    ES.AddStringField('Input :', 2,1, '',2,9, 30, 0,InputF);
    ES.AddStringField('Output:', 3,1, '',3,9, 30, 0,OutputF);
    {set procedure pointers}
    ES.SetPreEditProc(PreEdit);
    ES.SetPostEditProc(PostEdit);
    Finished := False;
    while not Finished do begin
      ES.Process;
      case ES.GetLastCommand of
        ccDone, ccQuit : Finished := (ExistFile(InputF) and (OutputF <> ''));
        else
          Finished := True;
      end{case};
    end{while};
    ES.Erase;
    ES.Done;
  end{GetTheNames};
  {$V+}
  {------------------------------------------------------------------}
  {Implementation of external procedures}
  procedure GetFileNames(var InFile, OutFile : String);
  var
    Parameters : String;
  begin
    InputF  := ParamStr (1);
    OutputF := ParamStr (2);
    if ((not ExistFile (InputF)) or (OutputF = '')) then
      GetTheNames;
    InFile  := InputF;
    OutFile := OutputF;
  end{GetFileNames};
  {------------------------------------------------------------------}
  procedure StartPass1;
  begin
    Display.InitCustom(LeftX, TopY, RightX, BottomY,
                       DefaultColorSet,
                       DefWindowOptions or wBordered);
    with Display.wFrame do begin
      AddShadow(shBR, shOverWrite);
      AddHeader('Pass 1', heTC);
    end;
    Display.Draw;
    Display.wFastText ('Input   : ' + InputF , 1, 1);
    Display.wFastText ('Output  : ' + OutputF, 2, 1);
    Display.wFastText ('Line #  : '          , 3, 1);
  end{StartPass1};
  {------------------------------------------------------------------}
  procedure PutLineNumber (Number: LongInt);
  begin
    LastLine := Number;
    Display.wFastText (Long2Str (Number), LinePut, 11);
  end;
  {------------------------------------------------------------------}
  procedure StartPass2;
  begin
    Inc(BottomY);
    Inc(LinePut);
    Display.Done;
    Display.InitCustom(LeftX, TopY, RightX, BottomY,
                       DefaultColorSet,
                       DefWindowOptions or wBordered);
    with Display.wFrame do begin
      AddShadow(shBR, shOverWrite);
      AddHeader('Pass 2', heTC);
    end;
    Display.Draw;
    Display.wFastText ('Input   : ' + InputF             , 1, 1);
    Display.wFastText ('Output  : ' + OutputF            , 2, 1);
    Display.wFastText ('# Lines : ' + Long2Str (LastLine), 3, 1);
    Display.wFastText ('Line #  : '                      , 4, 1);
  end{StartPass2};
  {------------------------------------------------------------------}
  procedure Finished (LastTopic : Word);
  var
    Key : Word;
  begin
    Display.ChangeHeader(0, 'Any key to continue');
    Display.wFastText ('Last Topic : ' + Long2Str (LastTopic), 4, 1);
    Key := ReadKeyWord;
    Display.Done;
  end{Finished};
  {------------------------------------------------------------------}
begin
  {Initialize the ColorSet}
  DefaultColorSet.SetFrameAttr         ($1F,AutoMapMono);
  DefaultColorSet.SetHeaderAttr        ($1F,AutoMapMono);
  DefaultColorSet.SetTextAttr          ($1F,AutoMapMono);
  DefaultColorSet.SetFieldAttr         ($1F,AutoMapMono);
  DefaultColorSet.SetPromptAttr        ($1F,AutoMapMono);
  DefaultColorSet.SetSelectedPromptAttr($1F,AutoMapMono);
end.
