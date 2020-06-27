
BEGIN{
  printf("{\\rtf\n")
  printf("{\\fonttbl\n")
  printf("\\f0\\froman Times New Roman;\n")
  printf("\\f1\\fdecor Courier New;\n")
  printf("\\f3\\fswiss Arial;\n")
# printf("\\f4\\fnil Monospaced;}\n")  # truetype, but not in standard configuration
  printf("\\f4\\fmodern Terminal;}\n") # only one size available
# printf("\\deff1 \n")}
# printf("\\deff0 \n")}
# printf("\\deff3 \n")}
  printf("\\deff4 \n")
  str1 = " }\\par\n\\pard\\plain\n\\f4\\fs20\\tx1173\\tx2346\\tx3519\\tx4692\\tx5866 "
  printf("\\deftab1173 \n")
  count = 00002
# 2 so that hc reports same topic numbers

}
{
line = $0
# first skip some lines
if ($1 ~ /.freeze/) { next; };
if ($1 ~ /\\i\\p\\aUp/) { next };
if ($1 ~ /--/) { next };
if ($1 ~ /ƒƒƒ/) { next };

# process topic headers
if ($1 ~ /.context/) { sub("@IL","_IL", $2); printf("\\pard\\plain\\page\n#{\\footnote _%sZ }\n+{\\footnote lev9:%-5.5d}\n", $2, count++); next };
if ($1 ~ /.topic/) { printf("${\\footnote %-4.4dB }\nK{\\footnote %s}\n", count, substr($0,7)); next };
# The line below produces produces intelligible titles but file size grows and
# hc must run in OS/2 because of memory requirements.
# if ($1 ~ /.topic/) { printf("${\\footnote %s }\nK{\\footnote %s}\n", substr($0,7), substr($0,7)); next };

# mark as bold 'notes:', 'seealso:' etc
if (($1 ~ /\\b/) && ($1 ~ /\\p/)) { sub("\\\\b", "{\\b ", $1); sub("\\\p", " }", $1); line = $0 };

# Make headline
if ($0 ~ /\\bINT [0-9A-F]/) { sub("\\\p", str1, line); sub("\\\\b", "\\pard \\qc {\\f3\\b\\fs28 ", line); };

# process jump ,references
gsub("\\\i...\\\\a", "{\\uldb ", line)
gsub("\\\i.....",     "}{\\v _",  line);
gsub("\\\\v, ",       "Z}, ",      line);
gsub("\\\\v$",        "Z}",       line);
gsub("\\\\v,$",        "Z}",       line);
# above line is for exceptions, some 10 found in inter32
gsub("@IL", "_IL", line);

# process tabs and spaces in line beginning
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

# hc 3.1 does not allow all chars...
gsub("\Å", "\¸", line)

print line "\par "
}
END {
  printf("{\\plain \\page}\n}\n")
}
