mawk -f BY2RTF.AWK  lev=lev3 prefix=F int.byf > intrtf.byf
mawk -f BY2RTF.AWK  lev=lev4 prefix=V int.byv > intrtf.byv
mawk -f fil2RTF.AWK lev=lev2          int.fil > intrtf.fil
mawk -f BOT2RTF.AWK                   int.bot > intrtf.bot
mawk -f toc2RTF.AWK                   int.toc > intrtf.toc
mawk -f idx2RTF.AWK                   int.idx > intrtf.idx

