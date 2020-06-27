# L2WHGLOS.awk glossary.lst
#    create a rtf-file for the glossary
#      to be shown in a secondary Help-window (HPJ: [WINDOWS])
#  pattern is:
#   <empty line>
#   <glossary term>
#   \tab<description>
#   ... empty line of next pattern
#
#  order is lexical order of glossary terms, starting /w 'A'
#
#  1st line of description might start with mmenomic expansion:
#     \tab/(.*) /
#  last line of description might have reference field:
#    /[Ss]ee (also )?\(.*\)\.?$/ 
#      reffield might be commaseperated list
#        refitems /^INT/ do not refer to glossary term, but
#          have pattern: INT 21h Function 5D(06)?h( and INT...)?

function suboem(s) {  # -- escape RTF specials
  sos=s; s=""
  gsub(/\\/,"\\\\",sos);  gsub(/\{/,"\\{",sos); gsub(/\}/,"\\}",sos)
  gsub(/\\'/,"\\.'",sos)  # HC31.EXE V3.10.445 knows no \[rl](dbl)?quote !
  gsub(/\0201/,"{\\'FC}",sos)  # -- german u umlaut ibm-oem 0x81=129d
  gsub(/[\0177-\0377]/,".",sos)  # -- ibm-oem 0x7F-0xFF
  return sos
}

function disbtnout(afile) {
  print ""ftn["!"]"{DisableButton(\"btn_Group\")}}" >> afile
}

function crnewpage(afile) { # -- name should have been: crnewrtf
  system("copy l2whcrtf.npg "afile" >> \\dev\\nul")
}

function wreortf(afile) { # -- appends end-of-page and '}' to rtf-file      
  printf "\n\\par"pardtx"\\page\n}\n" >> afile
}

function escre(s) {     # -- kill regexp specials
  sos=s; s=""
  gsub(/[\$\{\}\*\+\(\)\/\\]/,".",sos)
  gsub(/[\,\&\|\"\?\[\]\^]/,".",sos)
  return sos
}

function newchar(achar) {
  curcharno=0
  print "\\par{\\b\\fs24 "achar"}\\par" >> glosfile
}

function getlookupterm(aterm) {
  g_luterm=toupper(aterm); gsub(/[\-\\\/\, \t]/,"_",g_luterm);
  return g_luterm
}

function newterm(aterm,  termid) {
  ++curcharno
  termid=""curchar""curcharno""
  termsindex[""getlookupterm(aterm)""]=""termid""
  aterm=suboem(aterm)
  print "{\\ul{"aterm"}}{\\v glos_"termid"}\\par" >> glosfile
  print "\n"ftn["#"]"glos_"termid"}" >> popsfile
  print ""ftn["$"]""aterm"}" >> popsfile
  print ""ftn["K"]"{"aterm";Terms;Glossary}}" >> popsfile
  print ""ftn["+"]"Glos}" >> popsfile
  print "{\\fs24\\b\\cf4 "aterm"}\\par" >> popsfile
}

function prexpansion(aexp) {
  print "{\\i ("suboem(aexp)")}\\par" >> popsfile
}

function prtermout(aterm, asep) { # -- flag for 2nd pass
#   print ""aterm"" >> "terms.out"
  print ""linkflag"" >> popsfile
  print ""asep"" >> popsfile
  print ""aterm"" >> popsfile
}

function cvtterm(aterm, asep,   luterm, intid,s,e,t,i,a) {
  if (""aterm"" ~ /^INT/) {
    intid="INT "substr(aterm,5,2)""
    i=match(aterm,/Function [0-9A-F][0-9A-F]/)
    if (i+0 > 3) {
      s=i; e=i+RLENGTH-2; t=substr(aterm,e)
      a="AH"; i=index(t,"h")
      if (i+0 >4) {
        a="AX"; i=4
      } else {
        i=2
      }
      intid=""intid"\/"a"="substr(t,1,i)
      printf asep"{\\strike{"suboem(aterm)"}}" >> popsfile
      printf "{\\v !JumpKeyWord(\"INTERRUP.HLP\"," >> popsfile
      print "\""intid"h\")}" >> popsfile # -- is this to "main" ?
    } else
      printf asep""suboem(aterm)"" >> popsfile
  } else { 
    luterm=getlookupterm(aterm)
    if (""luterm"" in termsindex)
      printf asep"{\\ul{"suboem(aterm)"}}{\\v glos_"termsindex[luterm]"}" >> popsfile
    else
      printf asep""suboem(aterm)"" >> popsfile
  }
}

function prlastlines(  line, term, i,j,pts,pte,terms,luterm,n ) {
  line=""lastlines["befl"]""lastlines["last"]"" # -- concat them
  if (""line"" !~ /^[ \t\r]?$/) {
    i=match(line,/[Ss]ee (also )?/)  # -- sets RSTART and RLENGTH
    if (i+0 > 0) {
      if (i+0 > 1) {
        print ""suboem(substr(line,1,i-1))"" >> popsfile
        line=substr(line,i)
      }
      # -- parse term, set start and end
      pts=RLENGTH+1 # -- startposition of term in line
      term=""substr(line,pts)""
      j=index(term,"\.")
      if (j+0 > 0) { # -- endposition of term in line
        pte=pts+j-1; term=substr(term,1,j-1)
      } else pte=0
      printf ""suboem(substr(line,1,pts-1))"" >> popsfile
      # might be list of terms seperated by ", "s
      n=split(term,terms,"\, "); prtermout(terms[1],"")
      for (i=2; i <= n; i++) prtermout(terms[i],", ")
      if (pte+0 != 0)
        printf ""suboem(substr(line,pte))"" >> popsfile
      printf "\n" >> popsfile
      terms="" # -- destroy array
    } else {
      print ""suboem(line)"" >> popsfile
    }
    lastlines["befl"]=""; lastlines["last"]=""
  }
  print "\\par\\pard\\page" >> popsfile
}

BEGIN {
  console="\\dev\\con"
  hpjfile="interrup.hpj"

  basename=ARGV[ARGC-1]
  if ((i=index(basename,"\.")) > 0) basename=substr(basename,1,i-1)

  glosfile=basename".idx" # -- lexically grouped list of glossary terms
  popsfile=basename".rtf" # -- glossary popups (item descriptions)
  tmpfile=basename".tmp"
  hlpfile=basename".hlp"
  hexdigits="0123456789ABCDEF"; linkflag="!!L2WHCRTF!!"
  glosid="id_Glossary"
  about="About Interrupt List"
  ftnt="{\\footnote "
  ftn["#"]="#"ftnt; ftn["$"]="$"ftnt
  ftn["K"]="K"ftnt; ftn["!"]="!"ftnt; ftn["+"]="+"ftnt
  pardtx="\\pard\\tx960\\tx1920\\tx2880\\tx3840\\tx4800"

  print "Creating glossary in "glosfile" and "popsfile"" >> console

  crnewpage(glosfile)
  print ""ftn["#"]glosid"}" >> glosfile
  s="Glossary"
  print ""ftn["$"]""s"}" >> glosfile
  print ""ftn["K"]"{"s";Terms;"about"}}" >> glosfile
 #  print ""ftn["+"]"Seq}" >> glosfile
 #  disbtnout(glosfile)
  close(glosfile)

  crnewpage(popsfile)

  # termsindex=""
  lastlines["befl"]="" # -- before last
  lastlines["last"]="" # -- to be scanned for /[Ss]ee (also )?/
  curchar="X"; lineprefx=""
  curcharno=0
  doheader="T"
  termscnt=0
}

doheader ~ /T/ { # -- ignore 1st line
  print "{\\fs24\\b\\cf4{"s"}}{" >> glosfile
  if ((getline s)+0 <= 0) exit 3  # -- 2nd line: last change date
  print ", "suboem(s)"}\\par" >> glosfile
  print "{\\pard\\tx240\\li240\\fi-240}" >> glosfile
  doheader="F"
  next
}

/\r$/ { # -- why do I need to strip off CR now ?
  $0=substr($0,1,length($0)-1)
}


/^$/ { # -- empty line
  prlastlines()
  if (getline+0 > 0) { # get next line
    printf ""$0"         \r" >> console
    nterm=$0
    if (""toupper(substr(nterm,1,1))"" !~ "^"curchar"$") {
      curchar=toupper(substr(nterm,1,1))""
      newchar(curchar)
    }
    newterm(nterm); termscnt++
    next    
  } else {
    exit 4
  }
  lineprefx=""
}

/^\t\(/ { # -- 1st line of description /w mnemonic expansion
  # -- strip off expansion: assume expansion is on this line only
  i=index($0,")")
  if (i+0 > 3) prexpansion(substr($0,3,i-3))
  else i=1
  $0=substr($0,i+2)
  lineprefx=""
}

/^\t/ { # -- 1st line of description
  $0=substr($0,2) # -- strip off leading tab
  lineprefx=""
}

  { # -- a line of the description: update last2lines
  $0=""lineprefx""$0"";    lineprefx=" "
  if (""lastlines["befl"]"" !~ /^ ?\r?$/)
    print ""lastlines["befl"]"" >> popsfile
  lastlines["befl"]=lastlines["last"]
  lastlines["last"]=""$0""
  next
}


END {
  prlastlines()

  printf("\n\\par"pardtx"\\page\n}\n") >> glosfile
  close(glosfile)

  print "\n"pardtx"\n}\n" >> popsfile
  close(popsfile)

  # -- start 2nd pass to resolve links
  print "Resolving links...     " >> console
  system("copy "popsfile" "tmpfile"")
  printf "" > popsfile # -- rewrite file
  while (getline < tmpfile > 0) {
    if (""$0"" ~ ""linkflag"$") {
      i=match($0,""linkflag"")
      if (i+0 > 2) printf ""substr($0,1,i-1) >> popsfile
      getline sep < tmpfile
      getline term < tmpfile
      cvtterm(term,sep)
    } else
      print ""$0"" >> popsfile
  }
  close(tmpfile)
  close(popsfile)

 # system("del "tmpfile"")
  print ""glosfile"  ; Glossary index" >> hpjfile
  print ""popsfile"  ; Glossary topics" >> hpjfile
  print "Found "termscnt" terms         " >> console
  print "Done" >> console
}


