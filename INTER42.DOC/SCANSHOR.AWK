
BEGIN{
# following two constants are meant to be modified if need arises

   ln_limit = 20
# up to this long into pop-up, \footnote lines are also
# counted. Target system's display mode effects this value
# 20 seems quite good with 800x600 resolution

   awklim = 100
# you can try bigger value, it speeds up but all awks seem to be limited to
# about 100. This really makes the whole operation rather silly. Some awks
# might die rather ugly death. 100 seems safe enough. If awk runs with bigger
# value it is ok to use it.

   newnr = 0
   newtopic = "^A$"       # kludge to avoid "" in first sub line in mkpp0.awk
   outline = 0
   outend  = 0
   outstem = "mkpp"
   outfile = outstem outend ".awk"
   tmpflip = 1

   print "BEGIN{\n"                                             >> outfile
   print "disloc = - 1"                                         >> outfile
   print "FS = \"{\""                                           >> outfile
   print "OFS = \"{\""                                          >> outfile
   print "}\n"                                                  >> outfile
   print "{\n"                                                  >> outfile
   print "if (($2 ~ /[Ss]ee[Aa]lso/) || (skip == \"off\")){"    >> outfile
   printf("  for(i=2; i <= NF; i++){\n ")                       >> outfile
   print "mawk -f " outfile " intrtf.bot > %tmp%\intrtf.bo1 " >> "ppscan.bat"
   print "mawk -f " outfile " skip=off intrtf.idx > %tmp%\intrtf.id1 " >> "ppscan.bat"
   print "mawk -f " outfile " skip=off intrtf.byf > %tmp%\intrtf.bf1 " >> "ppscan.bat"
   print "mawk -f " outfile " skip=off intrtf.byv > %tmp%\intrtf.bv1 " >> "ppscan.bat"


}

{ if ($0 ~ /^\#{/){
   oldnr = newnr;
   newnr = NR;
   if (ln_limit < (newnr - oldnr)){
      outline++
      if (outline > awklim ){
         outline = 0;
         outend++
         print "}" >> outfile
         print "}" >> outfile
         print "\n print $0 \n" >> outfile
         print "\n}\n" >> outfile
         close(outfile)
         outfile = outstem outend ".awk"
         if (tmpflip){
            print "mawk -f " outfile " %tmp%\intrtf.bo1 > %tmp%\intrtf.bo2 " >> "ppscan.bat"
            print "mawk -f " outfile " skip=off %tmp%\intrtf.id1 > %tmp%\intrtf.id2 " >> "ppscan.bat"
            print "mawk -f " outfile " skip=off %tmp%\intrtf.bv1 > %tmp%\intrtf.bv2 " >> "ppscan.bat"
            print "mawk -f " outfile " skip=off %tmp%\intrtf.bf1 > %tmp%\intrtf.bf2 " >> "ppscan.bat"
            tmpflip = 0
            }
         else{
            print "mawk -f " outfile " %tmp%\intrtf.bo2 > %tmp%\intrtf.bo1 " >> "ppscan.bat"
            print "mawk -f " outfile " skip=off %tmp%\intrtf.id2 > %tmp%\intrtf.id1 " >> "ppscan.bat"
            print "mawk -f " outfile " skip=off %tmp%\intrtf.bv2 > %tmp%\intrtf.bv1 " >> "ppscan.bat"
            print "mawk -f " outfile " skip=off %tmp%\intrtf.bf2 > %tmp%\intrtf.bf1 " >> "ppscan.bat"
            tmpflip = 1
         }
         print "BEGIN{\n"                                             >> outfile
         print "FS = \"{\""                                           >> outfile
         print "OFS = \"{\""                                           >> outfile
         print "disloc = - 1"                                         >> outfile
         print "}\n"                                                  >> outfile
         print "{\n"                                                  >> outfile
         print "if (($2 ~ /[Ss]ee[Aa]lso/) || (skip == \"off\")){"    >> outfile
#        print "if ($1 ~ /[Ss]ee[Aa]lso/){"                           >> outfile
         printf("  for(i=2; i <= NF; i++){\n ")                             >> outfile
         }
      topicbeg = index($0, " _") + 1
      topicend = index($0 , "Z }") + 1
# debugline      print topicbeg " = topicbeg   " topicend " = topicend   " newnr " = newnr  " (newnr - oldnr) " = diff"
      topic = newtopic
      newtopic = substr($0, topicbeg, topicend - topicbeg)

      printf("      if ($i ~ \"%s\"){ sub(\"db\", \"\", $(i+disloc)); i++; continue}\n", topic)  >> outfile
      }
   }
}
END{
   print "}" >> outfile
   print "}" >> outfile
   print "\n print $0 \n" >> outfile
   print "\n}\n" >> outfile
   close(outfile)
   if (tmpflip){
      print "copy %tmp%\intrtf.bo1  intrtf.bot " >> "ppscan.bat"
      print "copy %tmp%\intrtf.id1  intrtf.idx " >> "ppscan.bat"
      print "copy %tmp%\intrtf.bv1  intrtf.byv " >> "ppscan.bat"
      print "copy %tmp%\intrtf.bf1  intrtf.byf " >> "ppscan.bat"
      }
   else{
      print "copy %tmp%\intrtf.bo2  intrtf.bot " >> "ppscan.bat"
      print "copy %tmp%\intrtf.id2  intrtf.idx " >> "ppscan.bat"
      print "copy %tmp%\intrtf.bv2  intrtf.byv " >> "ppscan.bat"
      print "copy %tmp%\intrtf.bf2  intrtf.byf " >> "ppscan.bat"
   }
   print "del %tmp%\intrtf.bo2"       >> "ppscan.bat"
   print "del %tmp%\intrtf.bo1"       >> "ppscan.bat"
   print "del %tmp%\intrtf.id1"       >> "ppscan.bat"
   print "del %tmp%\intrtf.id2"       >> "ppscan.bat"
   print "del %tmp%\intrtf.bv1"       >> "ppscan.bat"
   print "del %tmp%\intrtf.bv2"       >> "ppscan.bat"
   print "del %tmp%\intrtf.bf1"       >> "ppscan.bat"
   print "del %tmp%\intrtf.bf2"       >> "ppscan.bat"
   close("ppscan.bat")

}

