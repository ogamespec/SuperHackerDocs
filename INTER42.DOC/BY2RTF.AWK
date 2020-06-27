

BEGIN{
  printf("{\\rtf\n")
  printf("{\\fonttbl\n")
  printf("\\f0\\froman Times New Roman;\n")
  printf("\\f1\\fdecor Courier New;\n")
  printf("\\f3\\fswiss Arial;\n")
# printf("\\f4\\fnil Monospaced;}\n")
  printf("\\f4\\fmodern Terminal;}\n")
  printf("\\deff3\n")
  printf("\\deftab1440")
  count = 00002
# 2 so that hc reports same topic numbers
  col = 2
# first line will be first column
# chance maxcol to desired number of columns
  maxcol = 4
  lineend = ""

}
{
line = $0

if ($1 ~ /.freeze/) { next; };

if ($1 ~ /\\i\\p\\aUp/) { next };

if ($1 ~ /--/) { next };

if ($1 ~ /ÄÄÄ/) { next };

if ($1 ~ /.context/) { sub("@IL", "_IL", $2); printf("\\pard\\page\n#{\\footnote _%sZ }\n+{\\footnote %s:%-5.5d}\n", $2, lev, count++); next };

if ($1 ~ /.topic/) { printf("${\\footnote %-4.4d%s}\nK{\\footnote %s}\n\\par{\\f3\\fs28\\b%s}\n\\par \\tx1440\\tx2880\\tx4320 ", count, prefix, substr($0,7), substr($0,7) ); first = 2; col = 1; next };
# The line below produces produces intelligible titles but file size grows and
# hc must run in OS/2 because of memory requirements
# if ($1 ~ /.topic/) { printf("${\\footnote %s%s}\nK{\\footnote %s}\n\\par{\\f3\\fs28\\b%s}\\n\\par\\tx1440\\tx2880\\tx4320", substr($0,7), prefix, substr($0,7), substr($0,7) ); first= 2; col = 1; next };

gsub("\\\\a", "{\\uldb ", line);
gsub("\\\\v$",    "Z}"      , line);
gsub("\\\\v",    " }{\\v _"      , line);
gsub("@IL", "_IL", line);
if ((first > 0) && (prefix == "V") && (length(line) > 1)) {sub("\t", "", line); }
first--;
if (prefix == "V") sub("\t", "\\tab ", line);
gsub("\t", "", line);
if (prefix == "F")  lineend = "\par"
if ((prefix == "V") && (col > maxcol))  {print line "\par"; col = 2; first = 1 } else {print line lineend; col++}
}
END {
  printf("\\plain \\page\n}\n")
}
