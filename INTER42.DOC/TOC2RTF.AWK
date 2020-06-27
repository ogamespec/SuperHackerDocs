

BEGIN{
  printf("{\\rtf\n")
  printf("{\\fonttbl\n")
  printf("\\f0\\froman Times New Roman;\n")
  printf("\\f1\\fdecor Courier New;\n")
  printf("\\f3\\fswiss Arial;\n")
#  printf("\\f4\\fnil Monospaced;}\n")
  printf("\\f4\\fmodern Terminal;}\n")
  printf("\\deff3 \n")
  printf("${\\footnote MAIN INDEX }\n")
  printf("K{\\footnote MAIN INDEX }\n")
  printf("#{\\footnote main_index }\n\\f3")

}
{
line = $0

if ($1 ~ /.freeze/) { next; };

if ($1 ~ /\\i\\p\\aUp/) { next };

if ($1 ~ /--/) { next };

if ($1 ~ /ÄÄÄ/) { next };

if ($1 ~ /.context/) { next };

if ($1 ~ /.topic/) { next };

if (($0 ~ /\\b/) && ($0 ~ /\\p/)) { sub("\\\\b", "{\\b ", line); sub("\\\p", " }", line); };

if ($0 ~ /Spinellis/) { print "\par Based on:  " line "\n\par Winhelp version (c) 1992, 1993 Raimo Koski\n"; next}

gsub("\\\\a\\\i...", "{\\uldb ", line);
sub("\\\\v",    " }{\\v _"      , line);
sub("\\\\v\\\i...",    "Z}"      , line);
gsub("@IL", "_IL", line);
gsub("\t ", "\\tab ", line);
gsub("\t", "\\tab ", line);
print line "\par "
}
END {
  printf("{\\plain \\page}\n}\n")
}
