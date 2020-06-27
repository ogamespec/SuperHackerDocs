

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
# chance maxcol to desired number of columns in by value index
  maxcol = 4
  lineend = ""

}
{
line = $0

if ($1 ~ /.freeze/) { next; };

if ($1 ~ /\\i\\p\\aUp/) { next };

if ($1 ~ /--/) { next };

if ($1 ~ /ÄÄÄ/) { next };

if ($1 ~ /.context/) { sub("@IL", "_IL", $2); printf("\\pard\\page\n#{\\footnote _%sZ }\n+{\\footnote lev1:%-5.5d}\n", $2, count++); next };

if ($1 ~ /.topic/) { printf("${\\footnote %-4.4dI}\nK{\\footnote %s}\n\\par{\\f3\\fs28\\b%s}\n\\par \\tx1440\\tx2880\\tx4320 ", count, substr($0,7), substr($0,7) ); next };

# process jump ,references
sub("\\\\a", "{\\uldb ", line);
sub("\\\\b", "{\\b ", line);
sub("\\\p", " } ", line);
gsub("...\\\\a", "Z}³{\\uldb ", line);
sub("\\\\v.$",    "Z}³"      , line);
sub("\\\\v$",    "Z}"      , line);
gsub("\\\\v",    "}{\\v _"      , line);
gsub("@IL", "_IL", line);
gsub("\t", "", line);

# convert to ansi char set
ur = gsub("^\ÚÄ", "\\brdrth \\box ", line);
if (ur == 1) {sub("-.$", "", line); gsub(".Ä.", "", line);}
sub("-.$", " \\par \\pard", line)
gsub(".Ä.", "", line);          # found in many ATM packages
gsub("Ä.", "", line);
gsub("³", "| ", line);
sub("^.$", "\\pard ",line)
if ((ur == 1) || (line == "") || (line == "\pard ")) print line; else  print line "\par"
}
END {
  printf("\\plain \\page\n}\n")
}
