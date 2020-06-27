/* 
 *	An example TrueType font file name parsing program.
 *
 *	Copyright 1992 Microsoft Corporation.
 *
 *	Although this example code is parsing the 'name' table of
 * 	a TrueType font, it could be readily adapted to parse any
 *	other table.  See the "sfnt.h" include file for the 
 *	predefined structures for the other tables in a TrueType 
 *	font.  For example, the 'post' table is referenced by the
 *	"sfnt_PostScriptInfo" structure.
 *
 *	This code could also be useful for applications which
 *	wish to directly parse a TrueType font under Windows.
 *	Since Windows 3.1 allows an application to gain access
 *	to the raw font file via the GetFontData() API, this 
 *	example code may be useful.
 *
 */

#define		PC_OS

#include	<stdio.h>
#include	<fcntl.h>
#include	<io.h>
#include	<errno.h>
#include	<dos.h>
#include	"fscdefs.h"
#include	"sfnt.h"

void DumpNameTable (char *);

main(int argc, char **argv) 
{
	struct find_t	FileInfo;

	if (argc < 2) {
		printf("usage: ttfname *.ttf\n");
		exit(-1);
	}

	_dos_findfirst( argv[1], _A_NORMAL, &FileInfo );
	do
		DumpNameTable( FileInfo.name );
	while ( !_dos_findnext( &FileInfo ) );
}


  // find and seek to the naming table
void DumpNameTable (char * pszFile)
{
  unsigned            i;
  char		      namebuf[255];
  int                 fp;
  unsigned short      numNames;
  long		      curseek;
  unsigned            cTables;
  sfnt_OffsetTable    OffsetTable;
  sfnt_DirectoryEntry Table;
  sfnt_NamingTable    NamingTable;
  sfnt_NameRecord     NameRecord;

  if ((fp = open (pszFile, O_RDONLY | O_BINARY)) == -1)
    return;

  /* First off, read the initial directory header on the TTF.  We're only
   * interested in the "numOffsets" variable to tell us how many tables
   * are present in this file.  
   *
   * Remember to always convert from Motorola format (Big Endian to 
   * Little Endian).
   */
  read (fp, &OffsetTable, sizeof (OffsetTable) - sizeof (sfnt_DirectoryEntry));
  cTables = (int) SWAPW (OffsetTable.numOffsets);

  for ( i = 0; i < cTables && i < 40; i++)
  {
    if ((read (fp, &Table, sizeof (Table))) != sizeof(Table)) {
	printf("Read failed on table #%d\n", i);
	exit(-1);
    }
    if (Table.tag == tag_NamingTable)	/* defined in sfnt_en.h */
    {
	/* Now that we've found the entry for the name table, seek to that
	 * position in the file and read in the initial header for this
	 * particular table.  See "True Type Font Files" for information
	 * on this record layout.
	 */
	lseek (fp, SWAPL (Table.offset), SEEK_SET);
	read (fp, &NamingTable, sizeof (NamingTable));
	numNames = SWAPW(NamingTable.count);
	while (numNames--) {
		read (fp, &NameRecord, sizeof (NameRecord));
		curseek = tell(fp);

/* Undefine this next section if you'd like a little bit more info 
 * during the parsing of this particular name table.
 */
#ifdef SPAM 
printf("(%ld) platform=%u, specific=%u, lang=%x, name=%u (%u, %u)\n", curseek,
		SWAPW(NameRecord.platformID),
		SWAPW(NameRecord.specificID),
		SWAPW(NameRecord.languageID),
		SWAPW(NameRecord.nameID),
		SWAPW(NameRecord.length),
		SWAPW(NameRecord.offset));
#endif
		if (SWAPW(NameRecord.platformID) == 1 &&
				SWAPW(NameRecord.nameID) == 4) {
			lseek (fp, SWAPW (NameRecord.offset) + 
				SWAPW(NamingTable.stringOffset) + 
				SWAPL(Table.offset), SEEK_SET);
			read (fp, &namebuf, SWAPW(NameRecord.length));
			namebuf[SWAPW(NameRecord.length)] = '\0';
			printf("%s: FullFontName = %s\n", pszFile, namebuf);
			lseek (fp, curseek, SEEK_SET);
		}
	}
	goto cleanup;
    }

  }
  printf("%s: ** No name table found **\n", pszFile);

cleanup:
  close (fp);
  return;
}
