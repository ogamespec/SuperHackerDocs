@echo off
if not .%tmp%.==.. goto skip
echo set tmp environment variable and try again
echo eg. set tmp=c:\temp        note: don't add backslash as last char
quit
:skip
@echo on
mawk -f scanshor.awk intrtf.bot
@rem don't worry if you don't find ppscan.bat, it was created by command above
@rem next line needs about 9MB in %tmp%
call ppscan.bat
del mkpp*.awk
del ppscan.bat
@rem next line needs about 15MB in %tmp%
hc31 inter.hpj
