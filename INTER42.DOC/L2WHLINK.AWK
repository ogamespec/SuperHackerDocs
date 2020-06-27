# L2WHLINK.AWK interrup.rtf
# v1.0  8-May-94

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

function mkxrffilenm(anid) {
  l_xrfn=""intdir""substr(anid,1,2)
  return l_xrfn
}

function escre(as) {     # -- kill regexp specials
  sos=as; as=""
  gsub(/[\$\{\}\*\+\(\)\/\\]/,".",sos)
  gsub(/[\,\&\|\"\?\[\]\^]/,".",sos)
  return sos
}

function idexists(anid, ahint, idtouse, firstmatchid, xrffile, idhint, usemem, i, s1) {
  # -- lookup anid /w ahint in index-files, return idtouse too
  #    use simple FIFO cache (hope ahint does not contain spaces)
  if (linkcachecnt+0 > 0) {
    idhint=""ahint; gsub(/ /,"-",idhint); idhint=""anid""idhint
    if ((i=index(linkcache,""idhint""))+0 > 0) {
      s1=substr(linkcache,i,30)
      if ((i=index(s1," "))+0 > 0) {
        if (""substr(s1,1,i-1)"" ~ "^"escre(idhint)"$") {
          printf "Cachehit "idhint"       \r" >> console
          idtouse=""anid""; return ""idtouse
        }
      }
    }
  }
  idtouse=""; firstmatchid="" #; ahint=suboem(ahint)
  usemem="F"
  xrffile=mkxrffilenm(anid)
  if (substr(anid,1,2) ~ /21/) {  # -- i\21 split in two parts
    if (hex2dec(substr(anid,3,2))+0 >= dec21split) {
      xrffile=xrffile""split21""
      if (""idxintno"" ~ split21re) { usemem="T" }
    } else {
      if (substr(anid,1,2) ~ "^"idxintno"$") { usemem="T" }
    }
  } else {
    if (substr(anid,1,2) ~ /2F/) {  # -- i\2F split in two parts
      if (hex2dec(substr(anid,3,2))+0 >= dec2Fsplit) {
        xrffile=xrffile""split2F""
        if (""idxintno"" ~ split2Fre) { usemem="T" }
      } else {
        if (substr(anid,1,2) ~ "^"idxintno"$") { usemem="T" }
      }
    } else {
      if (substr(anid,1,2) ~ "^"idxintno"$") usemem="T"
    }
  }

  if (usemem ~ /T/) {
    printf "Using mem "idxintno"    \r" >> console
    if (""anid"" in intindex) {
      if (""ahint"" == "") idtouse=""anid""
      else {
        if (""intindex[""anid""]"" ~ toupper(""ahint))
          idtouse=""anid""
      }
    }
  }
  if (idtouse == "") {
    # idexsave0=$0
    printf "Using file "xrffile"    \r" >> console
    while ( getline < xrffile > 0 ) {
      if ( ""$1"" ~ "^"anid )  {
        if (""ahint"" == "") { idtouse=""$1; break }
        else {
          if (firstmatchid == "") firstmatchid=""$1
          if (toupper(""$0"") ~ toupper(""ahint)) { idtouse=""$1""; break }
        }
      } else
        if (firstmatchid != "") break
    }
    close(xrffile) # ; xrffile=""
    # $0=idexsave0; idexsave0=""; 
  }

  if (idtouse == "") if (firstmatchid != "") idtouse=firstmatchid
  firstmatchid=""
  if (""idtouse"" != "") {
    idhint=""ahint; gsub(/ /,"-",idhint); idhint=""idtouse""idhint
    if ((index(""idhint"",""linkcache"")+0) > 0) return ""idtouse
    if (linkcachecnt+0 == linkcachesize) {
      i=index(linkcache," ")
      linkcache=""substr(linkcache,i+1)" "idhint""
    } else {
      linkcache=""linkcache" "idhint""
      linkcachecnt++
    }
  }
  return ""idtouse
}


function mklinkedrtf(lnkid, lnktext, hint, idtouse, i) {
  # --- this is the 2nd pass procedure RTF -> LTF 
  #       updates global resolvedcnt, uses global $0 and textsep
  rc=0
    lnktext=substr(""$0"",(index(""$0"","LNKTEXT=")+10))
    if ((i=match(lnktext,/[^ \t]/)) > 0) lnktext=substr(lnktext,i)
    gsub(/\\\//,"\/",lnktext)
    if (sub(/[ \t]*$/," ",lnktext) > 0)
      lnktext=substr(lnktext,1,length(lnktext)-1)
 # print "Lnktext="lnktext"         " >> console
    hint=substr(""$0"",(index(""$0"","HINT=")+5))
    if (substr(hint,1,1) ~ /\"/) {
      hint=substr(hint,2,index(hint,"\" LNKTEXT")-2)
 #  print "Hint="hint"                       \r" >> console
    } else hint=""
    idtouse=" "
 # printf "LinkId="lnkid"  \r" >> console
    if (""(idtouse=idexists(lnkid,hint,idtouse)) != "") {
      print ""textsep"{\\strike{"lnktext"}}{\\v id_"idtouse"}" >> lnkrtffile 
#  printf "From "lnktext"             \r" >> console
      rc=1
    } else
      print ""textsep""lnktext"" >> lnkrtffile
    if (textsep == "") textsep=", " 
  lnktext=""; hint=""; lnkid="";
  return rc
}

function loadindex(anid,  xrffile, as) {
  intindex="" # -- free array
  nintindex=0
  xrffile=mkxrffilenm(anid); idxintno=substr(anid,1,2)
  if (""idxintno"" ~ /21/) {  # -- i\21 split in two parts
    if (hex2dec(substr(anid,3,2))+0 >= dec21split) {
      xrffile=xrffile""split21""; idxintno="21"split21""
    }
  } else {
  if (""idxintno"" ~ /2F/) {  # -- i\2F split in two parts
    if (hex2dec(substr(anid,3,2))+0 >= dec2Fsplit) {
      xrffile=xrffile""split2F""; idxintno="2F"split2F""
    }
  }
  }
  printf "Loading "xrffile"    \r" >> console
  while ( getline < xrffile > 0 ) {
    if (length($0) > 1) {
      intindex[""$1""]=escre(toupper(substr($0,index($0," ")+1)))
      ++nintindex
    }
  }
  close(xrffile)
  if (nintindex+0 <= 0) idxintno="--"
}

BEGIN {

  # -- resolve the hyperlinks using idx-files
  #       -> (re)create 2nd pass output file .ltf
  if (linkcachesize == "") linkcachesize=100
  console="\\dev\\con"

  grpdir="g\\"; intdir="i\\";  lstfile=ARGV[ARGC-1]
  basename=lstfile
  if ((i=index(basename,"\.")) > 0) basename=substr(basename,1,i-1)
  rtfoutput=basename".rtf"; statefile=basename".sta"
  rtffile=basename".rtf"; hpjfile=basename".hpj"
  hlpfile=basename".hlp"; grpidxfile=""grpdir""basename".grp"
  basegrpidxfn=""grpdir"IG.~"; allgroupsfile=basename".idx"
  hexdigits="0123456789ABCDEF"; linkflag="!!L2WHCRTF!!"
  lnkrtffile=basename".ltf"; contentsid="id_Index"
  about="About Interrupt List"
  ftnt="{\\footnote "
  ftn["#"]="#"ftnt; ftn["$"]="$"ftnt
  ftn["K"]="K"ftnt; ftn["!"]="!"ftnt; ftn["+"]="+"ftnt

  print "Verifying hyperlinks and creating new RTF "lnkrtffile >> console
  print "" > lnkrtffile

  # -- first split xrf INT 21 in two parts to speedup lookup
  split21="65"; split21re="^21"split21"$"
  xrffile=intdir"21.org"; nxrffile=intdir"21"
  dec21split=hex2dec(split21)+0; next21loaded="F"
  print "Splitting "nxrffile" at 21"split21"" >> console
  if (system("ren "nxrffile" 21.org >> \\dev\\nul")+0 != 0) {
    system("copy "xrffile" "nxrffile" >> \\dev\\nul")
  }
  system("del "nxrffile""split21" >> \\dev\\nul")
  system("del "nxrffile" >> \\dev\\nul")
  while ( getline < xrffile > 0 ) {
    if ( ""$1"" ~ split21re)  {
      close(nxrffile); nxrffile=intdir"21"split21"" 
    }
    print ""$0"" >> nxrffile
  }
  close(xrffile); xrffile=""
  close(nxrffile); nxrffile=""

  # -- split xrf INT 2F in two parts too
  split2F="86"; split2Fre="^2F"split2F"$"
  dec2Fsplit=hex2dec(split2F)+0; next2Floaded="F"
  xrffile=intdir"2F.org"; nxrffile=intdir"2F"
  print "Splitting "nxrffile" at 2F"split2F"" >> console
  if (system("ren "nxrffile" 2F.org >> \\dev\\nul")+0 != 0) {
    system("copy "xrffile" "nxrffile" >> \\dev\\nul")
  }
  system("del "nxrffile""split2F" >> \\dev\\nul")
  system("del "nxrffile" >> \\dev\\nul")
  while ( getline < xrffile > 0 ) {
    if ( ""$1"" ~ split2Fre)  {
      close(nxrffile); nxrffile=intdir"2F"split2F"" 
    }
    print ""$0"" >> nxrffile
  }
  close(xrffile); xrffile=""
  close(nxrffile); nxrffile=""


  # -- now rewrite the flagged seealsos
  textsep=""; resolvedcnt=0
  linkcache="00"; linkcachecnt=0
  intno=""; previntno="--"
  intindex=""; nintindex=0; idxintno="--"
}

/^\#/ {
  print ""$0"" >> lnkrtffile
  if (""$1"" ~ /^\#\{\\footnote/)  {
    intno=substr($0,match($0,/id_/)+3,2)
    if (""intno"" !~ /^(de)|(__)|(Be)/) {
      if (""intno"" !~ "^"previntno"$") {
        loadindex(intno)
        previntno=intno
      } else {
        if (""intno"" ~ /^21/ && next21loaded ~ /F/) {
          ia=substr($0,match($0,/id_/)+5,2)
          if (""ia"" !~ /^__/) {  # -- i\21 split in two parts
            if (hex2dec(ia)+0 >= dec21split) {
              loadindex("21"split21""); next21loaded="T"
            }  
          }
        }
        if (""intno"" ~ /^2F/ && next2Floaded ~ /F/) {
          ia=substr($0,match($0,/id_/)+5,2)
          if (""ia"" !~ /^__/) {  # -- i\2F split in two parts
            if (hex2dec(ia)+0 >= dec2Fsplit) {
              loadindex("2F"split2F""); next2Floaded="T"
            }  
          }
        }
      }
    }
  } 
  next
}

/^\{\\v/ {
  if (""$1"" ~ /L2WHCRTF/) { # -- linkflag
    id=""$2""
    gsub(/\//,"\\\/"); gsub(/\,/,"\\\,")
    if (mklinkedrtf(id) != 0) ++resolvedcnt
    next
  }
}

  {
  textsep=""; print ""$0"" >> lnkrtffile
  next
}

END {
  for (s in linkcache) delete linkcache[s]
  linkcache=""
  print "# of resolved links = "resolvedcnt"   " >> console
  print "Run Help Compiler now with:",
        " X> HC31 "basename"" >> console
}
