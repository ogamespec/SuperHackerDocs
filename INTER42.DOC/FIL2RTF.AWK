

BEGIN{
  printf("{\\rtf\n")
  printf("{\\fonttbl\n")
  printf("\\f0\\froman Times New Roman;\n")
  printf("\\f1\\fdecor Courier New;\n")
  printf("\\f3\\fswiss Arial;\n")
#  printf("\\f4\\fnil Monospaced;}\n")          # better than terminal
  printf("\\f4\\fmodern Terminal;}\n")
  printf("\\deff4 \n")
  str1 = "}\n\\par\n\\pard\\plain\\tx1173\\tx2346\\tx3519\\tx4692\\tx5866\\tx5876\n\\fs20"
  count = 00002
# 2 so that hc reports same topic numbers


}
{
line = $0

if ($1 ~ /.freeze/) { next; };

if ($1 ~ /\\i\\p\\aUp/) { next };

if ($1 ~ /--/) { next };

if ($1 ~ /ÄÄÄ/) { next };

if ($1 ~ /.context/) { sub("@IL", "_IL", $2); printf("\\pard\\plain\\page\n#{\\footnote  _%sZ }\n+{\\footnote %s:%-4.4d}\n", $2, lev, count++); next };

if ($1 ~ /.topic/) { printf( "${\\footnote %-3.3dL}\nK{\\footnote %s%s", count, substr($0,7), str1); next };
# The line below produces produces intelligible titles but file size grows and
# hc must run in OS/2 because of memory requirements
# if ($1 ~ /.topic/) { printf( "${\\footnote %s}\nK{\\footnote %s%s", substr($0,7), substr($0,7), str1); next };

if (($0 ~ /\\b/) && ($0 ~ /\\p/)) { sub("\\\\b", "{\\b ", line); sub("\\\p", " }", line); };

gsub("\\\\a\\\i...", "{\\uldb ", line);
sub("\\\\v",    " }{\\v _"      , line);
sub("\\\\v\\\i...",    "Z}"      , line);
gsub("@IL", "_IL", line);
gsub("\t\t\t\t ", "\\tab\\tab\\tab\\tab ", line);
gsub("\t\t\t ", "\\tab\\tab\\tab ", line);
gsub("\t\t ", "\\tab\\tab ", line);
gsub("\t ", "\\tab ", line);
gsub("\t\t\t\t", "\\tab\\tab\\tab\\tab ", line);
gsub("\t\t\t", "\\tab\\tab\\tab ", line);
gsub("\t\t", "\\tab\\tab ", line);
gsub("\t", "\\tab ", line);
sub("^                            ", "\\tab\\tab\\tab ", line);
sub("^                   ", "\\tab\\tab ", line);
sub("^          ", "\\tab ", line);

# hc 3.1 does not allow all chars... newer than inter33 migth contain more
gsub("\‚", "e", line);
gsub("\¢", "o", line);

print line "\par "
}
END {
  printf("{\\plain \\page}\n}\n")
}
