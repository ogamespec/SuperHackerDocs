# Usage of List To Windows Help Compiler Rich Text Format:
#   X> AWK -fL2WHCRTF.AWK -vdosavestate="T" interrup.lst
#   X> AWK -fL2WHCRTF.AWK interrup.lst
#   X> AWK -fL2WHindx.AWK interrup.hpj
#   X> AWK -fL2WHlink.AWK interrup.rtf
#   X> HC31 INTERRUP
# Fred de Jong - Heerlen - NL V1.2 20-May-95
# Needs: l2whcrtf.hpj, .npg, .bmp, .grp, .ico, .1st
#        DOS's comspec, sort.exe

function disbtnout(afile) {
  print ""ftn["!"]"{DisableButton(\"btn_Group\")}}" >> afile
}

function enbtnout(l_gid) {
  printf ""ftn["!"]"{ChangeButtonBinding(\"btn_Group\"," >> rtfoutput
  printf "\"JumpId(\\\\\""hlpfile"\\\\\",\\\\\"gid_"l_gid"\\\\\")\");\n" >> rtfoutput
  print "EnableButton(\"btn_Group\")}}" >> rtfoutput
}

function suboem(s) {  # -- escape RTF specials
  sos=s; s=""
  gsub(/\\/,"\\\\",sos);  gsub(/\{/,"\\{",sos); gsub(/\}/,"\\}",sos)
  gsub(/\\'/,"\\.'",sos)  # HC31.EXE V3.10.445 knows no \[rl](dbl)?quote !
  gsub(/\0201/,"{\\'FC}",sos)  # -- german u umlaut ibm-oem 0x81=129d
  gsub(/[\0177-\0377]/,".",sos)  # -- ibm-oem 0x7F-0xFF
  return sos
}

function dopard() {
  printf("\n"pardtx"\\par") >> rtfoutput
}

function crnewpage(afile) {
  system("copy l2whcrtf.npg "afile" > \\dev\\nul")
}

function wreortf(afile) { # -- appends end-of-page and '}' to rtf-file      
  printf "\n\\par"pardtx"\\page\n\}\n" >> afile
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

function copy2rtf(somestr)   {
 # -- this is also for Notes , SeeAlsos and Returns
  if ( substr(somestr,1,1) ~ /[ \t]/ ) {
    somestr=substr(somestr,2)
    print "\\par "somestr"" >> rtfoutput
  }
  else
    print " "somestr"" >> rtfoutput
  somestr=""
}

function asplit(str, arr, n, i) {  # make an assoc array from str
  n = split(str, fields)
  for (i = 1; i <= n; i++) {
    arr[fields[i]]=1 ; delete fields[i]
  }
  fields=""
  return arr
}

function cvtareg(regline,aline,  reg) {
 # -convert AX=1234h , AL=34h or AH=12h to '1234', '__34', or '12__'
  aline=""
  reg=substr(regline,1,2)
  if (reg in aregs) {
    if (reg ~ /AX/) aline=substr(regline,4,4)
    else if (reg ~ /AH/) aline=substr(regline,4,2)"__"
    else if (reg ~ /AL/) aline="__"substr(regline,4,2)
  } else aline="____"
  reg=""; regline=""
  return aline
}

function cvtnareg(regfield,aline,   nareg) {
 # -- convert a RX=1234h or RH=34h or RL=12h line to RR1234,RH34
  aline=""
  nareg=substr(regfield,1,2)
  if (nareg in xregs) aline=nareg""substr(regfield,4,4)
  else aline=nareg""substr(regfield,4,2)
  nareg=""; regfield=""
  return aline
}

function cvtregs(saline,ridline,   regi, nregs, fields, aline)  {
 # -- convert SeeAlso regs into topicid-format (of divide-lines)
  ridline=""
  nregs=split(saline,fields,"\/")
  if (nregs > 0) {
    ridline=cvtareg(fields[1],aline)
    regi=1
    if (substr(fields[1],1,2) in aregs) ++regi
    for (; regi <= nregs; regi++) {
      ridline=ridline""cvtnareg(fields[regi],aline)
      delete fields[regi]
    }
    if (sub(/_+$/,"_",ridline) > 0) # -- strip ending '_'
      ridline=substr(ridline,1,length(ridline)-1)
  }
  saline=""; fields=""; nregs=""; regi=""
  return ridline
}

function mkxrffilenm(anid) {
  l_xrfn=""intdir""substr(anid,1,2)
  return l_xrfn
}

function mkgrpfilenm(idxchr,i) { # - compose temp.filename for groups
  l_gfn=""grpdir""idxchr""sprintf("%3.3x",i+0)
  idxchr=""; i=""
  return l_gfn
}

function mkgrpidxfn(idxchr) {
  sub(/.$/,idxchr"",basegrpidxfn)
  l_gifn=basegrpidxfn
  idxchr=""
  return l_gifn
}

function getgrpidx(grpname) {
  l_indexchr=toupper(substr(grpname,1,1))
  if (""l_indexchr !~ /[A-Z0-9]/) l_indexchr="_"
  return l_indexchr
}

function escre(as) {     # -- kill regexp specials
  sos=as; as=""
  gsub(/[\$\{\}\*\+\(\)\/\\]/,".",sos)
  gsub(/[\,\|\"\?\[\]\^]/,".",sos)
  return sos
}

function neatgrptpc(s) {
  return suboem(toupper(substr(s,1,1))""tolower(substr(s,2))"")
}

function addgroup(grpnm,tid,atopic,  idxchr,l_gid,escgrpnm,astr,i)  {
  # -- lookup / create group using groupnames in group index files
  #     if new group create new groupfile and write RTF-footnotes
  if (""grpnm"" ~ /^IRQ/) {
    if (""grpnm"" ~ /^IRQ *[0-9A-F]+$/) grpnm="IRQ"
    else
    if (""grpnm"" ~ /^IRQ[0-9A-F]+ relocated by/) {
      grpnm=substr(grpnm,index(grpnm,"rel"))    
      grpnm="IRQ "grpnm
    }
  }
  if (""grpnm"" ~ /^IBM (PC ?)?3270/)
    grpnm="IBM 3270 Emulation Program"
  else {
    for (i=1; i<= nfixedgroups; i++)
      if (""grpnm"" ~ "^"fixedgroups[i]"") break
    if (i <= nfixedgroups) grpnm=""fixedgroups[i]""
    else {  # ignore last version word for grouping
      # -- do not strip INT XX groupnames
      if (""grpnm"" !~ /^INT/ && ""grpnm"" ~ / v?[0-9]+(\.[0-9]+)?[\+xf]?$/) {
        n=split(""grpnm"",fields," ")
        if (n > 1) {
          grpnm=fields[1]
          for (i=2; i < n; i++) grpnm=grpnm" "fields[i]
          atopic=atopic" "fields[n]""
        }
        for (i in fields) delete fields[i]
        fields=""
      }
    }
  }
  idxchr=getgrpidx(grpnm)
  sub(/.$/,idxchr"",basegrpidxfn)
  i=1; l_gid="NO"     # -- equals lineno in grpidxfile
  if ((index(grpindices"",idxchr"")+0) > 0) {
    escgrpnm="^"escre(""grpnm"")"$"
    while ( getline astr < basegrpidxfn > 0 ) { # grpidxfile
      if (""astr"" ~ escgrpnm) {
        l_gid=""idxchr""i; break
      }
      ++i
    }
    close(basegrpidxfn); astr=""
  } else 
    grpindices=grpindices""idxchr

  grpfile=mkgrpfilenm(idxchr,i)
  if (l_gid ~ /^NO/) {
    l_gid=""idxchr""i
    ++groupcnt
    # -- create new group RTF-page file and register it in grpidx
  printf "New Group          \r" >> console
    print ""grpnm"" >> basegrpidxfn
    close(basegrpidxfn)
    print ""grpfile"  ; Group "grpnm"" >> hpjfile
    close(hpjfile)
    crnewpage(grpfile)
    print "\n"ftn["#"]"gid_"l_gid"}" >> grpfile
    grpnm=suboem(grpnm)
    print ""ftn["$"]"{GROUP: "grpnm"}}" >> grpfile
    print ""ftn["K"]"{GROUP: "grpnm"}}" >> grpfile
    disbtnout(grpfile); keycnt++
    print "\\keepn{\\fs22\\b\\cf4 GROUP: "grpnm"}\\par"pardtx"" >> grpfile
  } else
    printf "\\par" >> grpfile
  print "{\\strike{"neatgrptpc(atopic)" ("tid")}}{\\v id_"tid"}" >> grpfile
  atopic=""; grpnm=""
  close(grpfile); grpfile=""
  if (l_gid != "") enbtnout(l_gid)
  else  disbtnout(rtfoutput)
  idxchr=""; l_gid=""; escgrpnm=""; i=""
}

function savestate(statefile, statedivline) {
  printf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", \
         statedivline,grpindices,seealsocnt,seerefcnt, \
         topiccnt,groupcnt,previntnuma,deftidcnt) > statefile
  printf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n", \
         eqtidcnt,intnum,intnuma,topicid, \
         intno,previntno,xrffile) >> statefile
  close(statefile)
}

function restorestate(statefile, statedivline) {  # -- get state from statefile
  if ( ( getline statedivline < statefile ) > 0 ) {
    getline grpindices < statefile; getline seealsocnt < statefile
    getline seerefcnt < statefile; getline topiccnt < statefile
    getline groupcnt < statefile; getline previntnuma < statefile
    getline deftidcnt < statefile; getline eqtidcnt < statefile
    getline intnum < statefile; getline intnuma < statefile
    getline topicid < statefile; getline intno < statefile
    getline previntno < statefile; getline xrffile < statefile
    close(statefile); rc=0
  } else rc=99
  return rc
}

function getaddkeys(ina,r) {
  # -- add a key for INT XX/AH=XX like constructs
  gaddkey=""
  if (ah != "") gaddkey="AH="ah"h"
  else if (al != "") gaddkey="AL="al"h"
  else if (ax != "") gaddkey="AX="ax"h"
  if (length(intnuma) > 6)  { # -- format to INT 44/AX=37DFh/BL=78h
    ina=substr(intnuma,7)
    while (length(ina) > 3) {
      r=substr(ina,1,2)
      if (r in xregs) {
        if (length(ina)<6) break
        gaddkey=(gaddkey"/"r"="substr(ina,3,4))"h"; ina=substr(ina,7)
      } else {
        gaddkey=(gaddkey"/"r"="substr(ina,3,2))"h"; ina=substr(ina,5)
      } 
    }
  }
  ina=""; r=""
  return gaddkey
}

function keysandgroup(   keys,groupname,addkey,i) {
  keys=""$0""; gsub(/;/,"|",keys); gsub(/\, /,";",keys)
  i=gsub(/ +- +/,";",keys)+0; keycnt=keycnt+i+1
  if ((i=match(keys,/;[^;]*\?\?\?$/))+0 > 1) {
     keys=substr(keys,1,i-1); keycnt--
  }
  # -- add ref to group page via btn_group
  groupname=keys
  if ((i=index(groupname,";"))+0 > 0)
    groupname=substr(groupname,i+1)
  if ((i=match(groupname,/;.*$/))+0 > 1)
    groupname=substr(groupname,1,i-1)
  addkey=""
  if (""intno"" == $2"") addkey=getaddkeys()
  print ""ftn["K"]"{"suboem(keys)"" >> rtfoutput
  if (addkey != "") {
    print ";INT "intno"/"addkey"" >> rtfoutput
    addkey=""
    keycnt++
  }
  print "}}" >> rtfoutput

  keys=""
  addgroup(groupname,topicid,topic)
  groupname="";  topic=""
  printf "\\keepn{\\b\\cf4 " >> rtfoutput
  print ""suboem($0)"}\\par"pardtx"" >> rtfoutput
  # close(rtfoutput)

}

function printbold(astr) {
  print "\\par\\par{\\b "astr"}\\par" >> rtfoutput
}


BEGIN  {
  # dosavestate="T"
  if (linkcachesize == "") linkcachesize=40
  console="\\dev\\con"

  grpdir="g\\"; intdir="i\\";  lstfile=ARGV[ARGC-1]
  basename=lstfile
  if ((i=index(basename,"\.")) > 0) basename=substr(basename,1,i-1)
  rtfoutput=basename".rtf"; statefile=basename".sta"
  hpjfile=basename".hpj"; fmtsfile=basename".fmt"
  hlpfile=basename".hlp"; grpidxfile=""grpdir""basename".grp"
  basegrpidxfn=""grpdir"IG.~"; allgroupsfile=basename".idx"
  hexdigits="0123456789ABCDEF"; linkflag="!!L2WHCRTF!!"
  lnkrtffile=basename".ltf"; contentsid="id_Index"
  about="About Interrupt List"
  ftnt="{\\footnote "; decint2164=100
  ftn["#"]="#"ftnt; ftn["$"]="$"ftnt
  ftn["K"]="K"ftnt; ftn["!"]="!"ftnt; ftn["+"]="+"ftnt
  pardtx="\\pard\\tx960\\tx1920\\tx2880\\tx3840\\tx4800"

  nfixedgroups=0
  while (getline s < "l2whcrtf.grp" > 0) {
    if (length(s) > 1) fixedgroups[++nfixedgroups]=escre(s)
  }
  close("l2whcrtf.grp")
  print "Using "nfixedgroups" groups from l2whcrtf.grp" >> console
  if (dosavestate ~ /T/) {
    # --- first part
    printf("Creating subdir g ") >> console
    system("mkdir g"); system("del g\\ig.?"); system("del g\\????")
    printf("\nCreating subdir i ") >> console
    system("mkdir i"); system("del i\\???")
    print " " >> console
    grpindices=""
    seealsocnt=0; seerefcnt=0; topiccnt=0; groupcnt=0; keycnt=0
    previntnuma=""; deftidcnt=1; eqtidcnt=""
    intnum=""; intnuma=""
    topicid=""; intno="XX"; previntno="XX"
    xrffile=mkxrffilenm("00")
  } else {
    print "Restoring state" >> console
    if (restorestate(statefile) != 0) {
      print "ERROR: no state" >> console
      exit
    }
  }
  topic=""; sa=""
  asplit("BX CX DX BP SI DI CS DS ES AX",xregs)
  asplit("AL AH BL BH CL CH DL DH SF",hregs) 
  asplit("AL AH AX",aregs)

  chkaxregline="F"

  if (dosavestate ~ /T/) {
    skiptostate=""
    # -- create the Help Compiler project file
   print "Creating HC project "hpjfile >> console
    system("copy l2whcrtf.HPJ "hpjfile)
    # -- append hpj later with summary and group files
    # -- create the 1st pass RTF file (on rtfoutput)
   print "Creating "rtfoutput" from "lstfile >> console
    system("copy /b l2whcrtf.npg+l2whcrtf.1st "rtfoutput" > \\dev\\nul")
  } else {
    # -- skip to last broken state
    skiptostate="T"
  }
  skippar="T"; metainfo="F"
} # -- end BEGIN

# ------------------------- $0 ---------------------------------

skippar ~ /^T/ { # -- skipping to next dividerline
  if (""$0"" ~ /^--------/) {
    skippar="F"
    if (metainfo ~ /^T/) {
      metainfo="F";  print "\\f0" >> rtfoutput
    } 
  }
  else {
    if (metainfo ~ /^T/) { # -- print literally
      print "\\par "suboem($0)"" >> rtfoutput 
    }
    next
  }
}

 {
  $0=suboem($0)
  if (skiptostate ~ /T/) {
    print "Skipping to INT 2F ..." >> console
    i=1; statedivline=suboem(statedivline)
    while (skiptostate ~ /T/ && ""$0"" !~ "^----------2F") {
      if (getline > 0) {
        while (""$0"" !~ /^-/) { # substr($0,1,1)
          if (getline > 0) i++
          else {
            skiptostate="F"; break
          }
        } 
        # $0=suboem($0)
        printf ""i"\r" >> console
      } else {
        skiptostate="F"; break
     }
    }
    print "Skipped to line # "i" in "lstfile"" >> console
    skiptostate="F"
  }
  # -- continue with following patterns/actions for current $0
}

/^Fo/ {
  if (""$0"" ~ /^Format of /) {
    printf(""topicid" %s\n",substr($0,11,length($0)-11)) >> fmtsfile
    printf("%s\n",intline) >> fmtsfile
    close(fmtsfile)
  }
}
   
/^Format/ || /^Bitfields/ || /^Values/ {
  print "\\par{\\b "$0"}\\par" >> rtfoutput

# -- if Format then next line is 'Offset\tab Size\tab Description'
  if (""$0"" ~ /^F/) isformat="T"
  else isformat="F"
# -- if Bitfields then next line is 'Bit(s)\tab Description'
  if (""$0"" !~ /^Values/) {
    if (getline > 0) {
      sa=suboem($0); gsub(/\t/,"\\tab\\ul ",sa)
      print "{\\ul "sa"}"pardtx"\\par" >> rtfoutput
    }
  }

  while ((i = getline) > 0) {
    if (isformat ~ /^T/) { # adjust unaligned '[N0-9]+ BYTEs' Size
      if (NF+0 > 2) {
        if (""substr($0,1,1)"" ~ / /) $0=""substr(""$0"",2)""
        if (""$3"" ~ /(BYTE|WORD)s$/) {
          j=match(""$0"",/ +/)
          if (j+0 > 0) {
            index($0," "); sa=substr(""$0"",j+RLENGTH)
            sa=""$1"\t"sa""; $0=sa
          }
        }
      }
    }
    $0=suboem($0) # -- force recalc of NF and $1,2...
    if ($0 ~ /^[ \t]*$/ || $1 ~ /^-----/ || \
        $1 ~ /^Notes?:/ || $1 ~ /all.*with:$/) break
    else {
      if ($0 ~ /^[ \t]*---[^\-]/) { # --function
        if ((i=match($0,/[^ \t\-]/))+0 > 0) {
          sa=substr($0,i)
          if ((i=match(sa,/---[ \t]*$/))+0 > 1) sa=substr(sa,1,i-1)
          print "\\par\\par{\\f1 "sa"\\f0}\\par"pardtx"" >> rtfoutput
          continue
        } 
      }
      print "\\par "$0"" >> rtfoutput
    }
  }
  if (i <= 0) exit # goto END
  if ($1 !~ /^-----/ && $1 !~ /^Notes?:/ && $1 !~ /all.*with:$/) {
    dopard()
    next
  }
}

/^--------(.+)-+$/  {
  # -- divider line format =  '^--------C-IIAHALRRVV(VVRRVV(VV)?)?-+$'
  if (dosavestate ~ /T/) {
    if (substr(""$0"",11,2) ~ /2F/) {
      savestate(statefile,""$0""); exit # -- goto END
    }
  }
  # class=substr($0,9,1)
  divl=substr($0,11);  $0=""
  previntno=intno; intno=substr(divl,1,2)
  ah=substr(divl,3,2); al=substr(divl,5,2)
  if (ah ~ /--/) ah="" ;  if (al ~ /--/) al=""
  if (ah != "" && al != "") { ax=ah""al""; ah=""; al="" } else ax=""
  intnuma=divl
  if ((i=match(intnuma,/-+$/))+0 > 1) intnuma=""substr(intnuma,1,i-1)
  else intnuma=""
  # -- assign topicid, decrease probability of duplicate topicids
  #    assuming equal divider-line fields exist only sequential 
  #    NB: intnuma is also used later to generate keys  
  if (intnuma == "") {
    topicid="def_"deftidcnt; deftidcnt++
  } else {
    gsub(/-/,"_",intnuma)
    if (""previntnuma == ""intnuma) { # -- matches previous topicid ?
      if (eqtidcnt != "") {
        topicid=""intnuma"_"eqtidcnt; ++eqtidcnt        
      } else {
        topicid=""intnuma"_1"; eqtidcnt=2
      }
    } else {
      topicid=intnuma; eqtidcnt=""
    }
  }
  previntnuma=intnuma

  gsub("-","_",topicid)  # '-' are not allowed in context strings
  if (topicid ~ /^def/) { # -- ignore comments
    skippar="T"; next
  }
  topiccnt++
# printf("%d          \r",0topiccnt) >> console
  print ""pardtx"\\par\\page\n" >> rtfoutput
printf topicid"                \r" >> console
  print ""ftn["#"]"id_"topicid"}" >> rtfoutput
  print ""ftn["+"]"Seq}" >> rtfoutput
  if (topicid ~ /^__[A-Z]/) { # -- no INT line expected
    topic=topicid
    if (""topic"" ~ /^__/) topic=substr(topic,3)
    # -- add to group about ('CONTACTINFO', etc)
    print ""ftn["$"]""topic"}" >> rtfoutput
    print ""ftn["K"]"{"topic";"about"}}" >> rtfoutput
    disbtnout(rtfoutput)
    dopard()
    print "{\\ul\\b\\cf4 "substr(topic,1,1)""tolower(substr(topic,2))"\\par}\\keep" >> rtfoutput
    # ---- read & print literally up to next divline
    skippar="T"; metainfo="T"
  }
  next
}  

/^[ \t]*---[^\-]/ { # --- subdivider
  if ((i=match($0,/[^ \t\-]/))+0 > 0) {
    sa=substr($0,i)
    if ((i=match(sa,/---[ \t]*$/))+0 > 1) sa=substr(sa,1,i-1)
    print "\\par\\par{\\f1 "sa"\\f0}\\par"pardtx"" >> rtfoutput
    next
  }
}


chkaxregline ~ /T/ && $1 ~ /^A[HX]$/ && $2 == "=" {
  sa=substr($0,index($0,"A"))
  printf("\\par{\\b %s}\n",sa) >> rtfoutput
  chkaxregline="F"
  next
}


/^INT [0-9A-F][0-9A-F] [UuPRCO]?/ {  # -- Ralf's Flags
  # -- uses current topicid
  intline=$0
  if ((i=split(""$0"",fields," - "))+0 > 0) {
    topic=fields[i] # last field in INT-line
    if (i+0 > 1) {
      if (fields[2] ~ /^VIRUS$/) {
        topic=substr($0,match($0,/VIRUS/))
      }
    } 
    fields=""
  } else topic=""$0""
  print ""ftn["$"]"{"suboem(topic)"}}" >> rtfoutput
  if (length(topic) == 3) { # prevent '???' topics
    if (""topic"" ~ /\?\?\?/) topic=suboem(""$0"")
  }
  # -- register cross-ref
  if (""previntno"" !~ "^"intno"$") xrffile=mkxrffilenm(topicid)
  printf(""topicid" %s\n",$0) >> xrffile
  close(xrffile)

  keysandgroup()  # uses $0,intno,topic,topicid; topic is reset

  chkaxregline="T"
  next
}

/^$/ {
  dopard()
  next
}

/^Desc:/ {
  printbold("Description:")
  sa=""$0"";  sub(/^Desc:[ \t]*/,"\t",sa)
  copy2rtf(sa); sa=""
  next
}

/all.*with:$/ {
  printbold($0)
  next
}

/^Program:/ {
  printbold("Program:")
  sa=""$0""; sub(/^Program:[ \t]*/,"\t",sa)
  copy2rtf(sa); sa=""
  next
}

/^BUGS?:/ {
  printbold("Bugs:")
  sa=""$0""; sub(/^BUGS?:[ \t]*/,"\t",sa)
  copy2rtf(sa); sa=""
  next
}

/^Index:/ { # -- skip line
 #  printbold("Index:")
 #  sa=""$0""; sub(/^Index:[ \t]*/,"\t",sa)
 #  copy2rtf(sa); sa=""
  next
}

/^Notes?:/  {
  printbold("Notes:")
  sa=""$0"";  sub(/^Notes?:[ \t]*/,"\t",sa)
  copy2rtf(sa); sa=""
  next
}

/^SeeAlso:/ {
  seealsocnt++
  printbold("See also:"); print "\\par" >> rtfoutput
  sa=""$0""; sub(/^SeeAlso:[ \t]*/,"\t",sa)
  # -- flag hyperlinks here for second pass using xrffile
  #     and current topicid for intnum
  #  formats:  AH=B0h, AX=3040h, AH=12h/BH=04h
  #            AH=04h"Amstrad",AH=05h"Amstrad"
  #            AX=1012h,AX=1051h
  #            INT 09"MATH", INT 71
  #            INT 15/AH=4Fh ... (seperator is ',')
  nsa=split(sa,fields,","); sa=""
  if (nsa > 0) {
    lastintref=substr(intnuma,1,2)
    lastaxref=substr(intnuma,3,4) 
    for (i=1; i <= nsa; i++) {
      linkid=""; hint=""
      sa=fields[i]; osa=sa
      if ((j=match(sa,/[^ \t]/)) > 0) sa=substr(sa,j)
      if ((j=match(sa,/[ \t]+$/)) > 0) sa=substr(sa,1,j-1)
      if ((j=index(sa,"\"")) > 0) {
        hint=substr(sa,j+1); sa=substr(sa,1,j-1)
        if ((j=index(hint,"\"")) > 0) {
          hint="\""substr(hint,1,j)
        } else hint=""
      }
      if (sa ~ /^INT/) {
        sa=substr(sa,4)
        if ((j=match(sa,/[^ \t]/)) > 0) sa=substr(sa,j)
        linkid=substr(sa,1,2); lastintref=linkid
        sa=substr(sa,3)
        if (sa ~ /^\//) sa=substr(sa,2)
      } else linkid=lastintref 
      ridline=""
      linkid=linkid""cvtregs(sa,ridline) # --- '/' seperated regs ?
 printf ""linkid" "hint"     \r"  >> console
      printf("{\\v{%s %s HINT=%s LNKTEXT=}}%s \n",
             linkflag,linkid,hint,osa) >> rtfoutput
      seerefcnt++
    }
  for (i in fields) delete fields[i]
  fields=""; sa=""
  } 
  next
}

/^Return:/ {
  printbold("Return:"); sa=""$0""
  sub(/^Return:[ \t]*/,"\t",sa)
  copy2rtf(sa); sa=""
  next
}

 {
  copy2rtf($0)
  #  next
}

END {
  if (xrffile != "") close(xrffile)
  # close(hpjfile)
      # close(basegrpidxfn) # close(grpidxfile)
  if (dosavestate ~ /T/) {
    close(rtfoutput)
    print "\nState saved in "statefile >> console
    exit 0
  }
  wreortf(rtfoutput)
  close(rtfoutput)
  printf "Found: topics="topiccnt", refs="seerefcnt"" >> console
  print ", groups="groupcnt", keys="keycnt"" >> console
  print "Done" >> console
  exit 0
}
