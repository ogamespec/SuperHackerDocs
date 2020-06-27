# L2WHINDX.awk interrup.hpj
# -- finish group pages
#    create page for index of groups
#    create page for index of control block formats
# uses DOS's comspec, SORT.EXE

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

function crnewpage(afile) {
  system("copy l2whcrtf.npg "afile" >> \\dev\\nul")
}

function wreortf(afile) { # -- appends end-of-page and '}' to rtf-file      
  printf "\n\\par"pardtx"\\page\n}\n" >> afile
}

function hex2dec(ahexs,   i, m) {
  adecs=0 ;  m=1
  for (i=length(ahexs); i > 0; i--) {
    adecs = adecs + 0 + (m * \
             (index(hexdigits,toupper(substr(ahexs,i,1)))-1)+0)
    m = 16 * m
  }
  ahexs=""; i=""; m=""
  return adecs""
}

function escre(s) {     # -- kill regexp specials
  sos=s; s=""
  gsub(/[\$\{\}\*\+\(\)\/\\]/,".",sos)
  gsub(/[\,\&\|\"\?\[\]\^]/,".",sos)
  return sos
}

function addfmtskey(aintid,formname,intdescr,    fks,n,i)  {
  # -- append pseudotopic to fkeyfile
  #  using topicnames like 'Format of BlockFormatName: [INTsubgroup-]INTFunctionName'
  #  and keynames line 'FORMATS for INTGroupname'
  print ""ftn["#"]"fkj_"aintid"}" >> fkeyfile
  n=split(""intdescr"",fks," - ")+0
  if (n+0 <= 1) fks[1]=""intdescr""
  print ""ftn["$"]"{Format of "suboem(formname)" in "suboem(intdescr)"}}" >> fkeyfile
  print ""ftn["K"]"{FORMATS for "suboem(fks[1])";" >> fkeyfile
  if (n+0 > 2) print ""suboem(fks[2])";" >> fkeyfile
  print "\n"suboem(formname)";"suboem(fks[1])";Formats}}" >> fkeyfile
  keycnt=keycnt+2
  print ""ftn["!"]"{JI(`',`id_"aintid"')}}" >> fkeyfile
  fks=""
  print "\\page" >> fkeyfile
}

function makefmtspage(afile,   s,sa,j,i,intid,idescr,tmpfile) {
  system("copy "afile" "ftmpfile"")
  crnewpage(afile); crnewpage(fkeyfile)
  print ""ftn["#"]formatsid"}" >> afile
  s="Index to Formats"
  print ""ftn["$"]""s"}" >> afile
  print ""ftn["K"]"{"s";Formats;Blocks;" >> afile
  print "Control Blocks;Argument Blocks;Parameter Blocks;" >> afile
  print "Buffers;Request Buffers;Reply Buffers}}" >> afile
#  print ""ftn["+"]"Seq}" >> afile
  disbtnout(afile)
  print "\\keepn{\\fs30\\b\\cf4 "s"" >> afile
  print "   {\\plain\\fs14\\cf0 [Search Key is 'FORMATS for <agroup>']}" >> afile
  print "}\\par\\pard" >> afile
  print "{\\tx240\\li240\\fi-240}\n" >> afile
  j=1
  while (j+0 > 0 && (getline < ftmpfile > 0)) {
    printf ""$1"      \r" >> console
    intid=$1
    i=index($0," "); sa=suboem(substr($0,i+1))
    sa=toupper(substr(sa,1,1))""substr(sa,2)""
    j=(getline idescr < ftmpfile)+0
    i=match(idescr,/ - /); idescr=tolower(substr(idescr,i+3))
    printf ("{\\strike{%s}}{\\v id_"intid"}:\n",sa) >> afile
    printf (" %s.\\par\n",suboem(idescr)) >> afile
    addfmtskey(""intid"",""sa"",""idescr"")
  }
  close(ftmpfile)
  wreortf(afile); print "\n\\par"pardtx"\n}" >> fkeyfile
  close(afile); close(fkeyfile)

  if (j == 0) {
    print "L2WHINDX ERROR: a formatentry in "afile" has no 2 lines" >> console
    exit 1
  }
 # system("del "ftmpfile"")
}

function updallgroups(s1, gd) { # -- uses $0 !
  gd=escre(grpdir)
  if (""s1"" ~ "^"gd"") {
    grpfile=""s1""
    gid=""substr(s1,lsd+1,1)""hex2dec(substr(s1,lsd+2))
    s=$4;  for (i=5; i <= NF; i++) s=s" "$i;  s=suboem(s)
    print "{\\strike{"s"}}{\\v gid_"gid"}\\par" >> tmpfile
  #  printf "Added gid_"gid"               \r" >> console
    if (donttouchgrprtf !~ /T/) {
      printf "Finishing "grpfile"\r" >> console
      wreortf(grpfile); close(grpfile)
    }
  }
}


BEGIN {
  # donttouchgrprtf="T"
  console="\\dev\\con"

  grpdir="g\\"; intdir="i\\"
  basename=ARGV[ARGC-1]
  if ((i=index(basename,"\.")) > 0) basename=substr(basename,1,i-1)
  rtfoutput=basename".rtf"; statefile=basename".sta"
  rtffile=basename".rtf"; hpjfile=basename".hpj"

  fmtsfile=basename".fmt"; fkeyfile=basename".fik"
  ftmpfile=basename".tmf"

  hlpfile=basename".hlp"; grpidxfile=""grpdir""basename".grp"
  basegrpidxfn=""grpdir"IG.~"; allgroupsfile=basename".idx"
  hexdigits="0123456789ABCDEF"; linkflag="!!L2WHCRTF!!"
  lnkrtffile=basename".ltf"
  contentsid="id_Index"; formatsid="id_Formats"
  about="About Interrupt List"
  ftnt="{\\footnote "; decint2164=100
  ftn["#"]="#"ftnt; ftn["$"]="$"ftnt
  ftn["K"]="K"ftnt; ftn["!"]="!"ftnt; ftn["+"]="+"ftnt
  sortfile=basename".srt"
  pardtx="\\pard\\tx960\\tx1920\\tx2880\\tx3840\\tx4800"
  tmpfile=""basename".tmp"
  eopfile=""basename".eop"

  print "Creating index to Formats in "fmtsfile" and "fkeyfile"" >> console
  makefmtspage(fmtsfile)

  print "Creating "allgroupsfile" using [FILES] in "hpjfile >> console
  lsd=length(grpdir)
  atfiles="F"
  #    read group-page files from HPJ file
}


atfiles ~ /F/ && ""$1"" !~ /^\[FI/ { # -- skip to [FILES] section
  next
}

atfiles ~ /F/ { # -- skip over [FILES] line
  atfiles="T"
  next
}

atfiles ~ /T/ && ""$0"" !~ /^[ \t;iI]/ {
  updallgroups($1)
  next
}

END {
  # -- the ARGV[ARGC-1] hpjfile should be closed now
  close(tmpfile)
  # --- sort the groups
  print "\nSorting groups..." >> console
  system("sort < "tmpfile" > "sortfile"") # -- sort does not write Ctrl+Z !
  print "Sorted in "sortfile"" >> console
  system("del "tmpfile"")

  crnewpage(allgroupsfile)
  print ""ftn["#"]contentsid"}" >> allgroupsfile
  s="Index to Groups"
  print ""ftn["$"]""s"}" >> allgroupsfile
  print ""ftn["K"]"{"s";Groups, index to;Index}}" >> allgroupsfile
  print ""ftn["+"]"Seq}" >> allgroupsfile
  disbtnout(allgroupsfile)
  print "\\keepn{\\fs30\\b\\cf4 "s"" >> allgroupsfile
  print "   {\\plain\\fs14\\cf0 [Search Key is 'GROUP: <agroup>']}" >> allgroupsfile
  print "}\\par\\pard" >> allgroupsfile
  print "{\\tx240\\li240\\fi-240}\n" >> allgroupsfile
  close(allgroupsfile)

  printf("\n\\par"pardtx"\\page\n}\n") > eopfile
  close(eopfile)
  system("copy /b "allgroupsfile"+"sortfile"+"eopfile" sorted.ltf >> \\dev\\nul")
  system("del "sortfile" >> \\dev\\nul")
  system("del "eopfile" >> \\dev\\nul")

  print "Finishing "allgroupsfile"" >> console
  system("copy sorted.ltf "allgroupsfile" >> \\dev\\nul")
  system("del sorted.ltf >> \\dev\\nul")
  print ""allgroupsfile" ; Index to Groups" >> hpjfile
  print ""lnkrtffile" ; Topic pages" >> hpjfile
  print ""fmtsfile" ; Index to Formats" >> hpjfile
  print ""fkeyfile" ; Keys to Formats" >> hpjfile
  close(hpjfile)
  print "Done" >> console
}


