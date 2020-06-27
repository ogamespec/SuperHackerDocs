unit Global;
{A unit containing a 'global' object type.  Objects of this type will be
 used to remember the necessary information about the different INTerrupt
 items (necessary to be able to X-reference)}
interface
  uses OPROOT;

  type IntDataPtr = ^IntData;
       IntData = object (SingleListNode)
         INT   : String[2];             {INT number}
         AX    : String[4];             {AX contents}
         Other : record                 {other register}
                   Name  : String[2];   {'  ' if none specified}
                   Value : String[4];
                 end{record};
         Topic : Word;                  {Topic number given to this item}
         Text  : String[80];            
            {Supplementary information (some INT items have textual 
             information, necessary to identify them when they share the
             same INT, AX and other register values with one or more other
             items}

         {functions and procedures}

         constructor Init;
       end{IntData};

implementation

Constructor IntData.Init;
begin
  if not SingleListNode.Init then
    fail;
  INT         := '  '  ;
  AX          := '    ';
  Other.Name  := '  '  ;
  Other.Value := '    ';
  Topic       := 0     ;
  Text        := ''    ;
end{IntData.Init};

end {Global}.

