/****************************************************************/
/*	EEL code file for editing the Interrupt List		*/
/*								*/
/*	Written by Ralf Brown					*/
/*	LastEdit: 7 May 94					*/
/*								*/
/*  This EEL file adds the following keybindings:		*/
/*    Shf-Alt-B add another BUG: to the current entry           */
/*    Shf-Alt-D add a Desc: section to the current entry	*/
/*    Shf-Alt-R add a Range: section to the current entry       */
/*	Alt-I	add an Index: section to the current entry	*/
/*		add another Index: line if already on Index:	*/
/*      Alt-N   add a new note to current entry or data struct  */
/*      Alt-P   add a Program: section to the current entry     */
/*      Alt-R   insert Return: at start of line                 */
/*	Alt-S	insert SeeAlso: at start of line		*/
/*	F11	insert a blank separator line			*/
/*	^F11	create Format of: header			*/
/*	Shf-F11	create Values for: header			*/
/*	Alt-F11 create Call with: header			*/
/*	Alt-F12 create Bitfield for: header			*/
/*	F12	add the interrupt number to the separator line	*/
/*		preceding the current entry			*/
/*	^F12	jump to a specified entry			*/
/*								*/
/*  It adds the following unbound commands:		        */
/*      renumber-tables					        */
/*								*/
/*  Other:							*/
/*	adds intlist-mode for .LST and .1ST files		*/
/*	switches current buffer into intlist-mode on loading	*/
/*      maintains a table counter which is inserted each time   */
/*        a table is created in the text		        */
/****************************************************************/

#include "eel.h"

keytable intlist_tab ;			/* key table for IntList mode */

/* on repeated F12, how often to display number of entries processed */
/* for fast 386, every 100; for a Pentium, at least 300 or the message */
/* line will lag way behind the actual progress */
#define NUMBER_INT_PROGRESS_INTERVAL 500

/*=============================================================*/
/*    Global Variables					       */
/*=============================================================*/

char return_section[] = "Return: " ;
char program_section[] = "Program: " ;
char desc_section[] = "Desc:\t" ;
char range_section[] = "Range:\t" ;
char notes_section[] = "Notes*:\t" ;
char bugs_section[] = "BUGS*:\t" ;
char seealso_section[] = "SeeAlso: " ;
char index_section[] = "Index:\t" ;

char *(section_order[9]) ;

when_loading()
{
   /* list the sections of an entry in the order they should appear (if */
   /* present at all) */
   section_order[0] = return_section ;
   section_order[1] = program_section ;
   section_order[2] = desc_section ;
   section_order[3] = range_section ;
   section_order[4] = notes_section ;
   section_order[5] = bugs_section ;
   section_order[6] = seealso_section ;
   section_order[7] = index_section ;
   section_order[8] = NULL ;
}

/*=============================================================*/
/*    Buffer-specific variables				       */
/*=============================================================*/

buffer spot table_counter ;

/*=============================================================*/
/*=============================================================*/

int empty_line()
{
   return (character(point-1) == '\n' && character(point) == '\n') ;
}

/*=============================================================*/
/*=============================================================*/

int is_separator_line()
{
   return (empty_line() || parse_string(1,"--------",NULL)) ;
}

/*=============================================================*/
/* search in the specified direction (1 = forward, -1 = back)  */
/* for the next entry separator line			       */
/*=============================================================*/

int to_separator_line(dir)
int dir ;
{
   nl_reverse() ;
   return search(dir,"\n--------") ;
}

/*=============================================================*/
/* move to the location where the specified section of an      */
/* entry begins (if present) or should begin (if not)	       */
/*=============================================================*/

int to_section_start(section)
char *section ;
{
   int i, j, len ;

   for (i = 0 ; section_order[i] ; i++)
      if (strcmp(section,section_order[i]) == 0)
	 break ;
   if (section_order[i])
      {
      while (!is_separator_line())
	 {
	 for (j = i ; section_order[j] ; j++)
	    if (parse_string(1,section_order[j],NULL))
	       {
	       if ((len = parse_string(1,section,NULL)) != 0)
		  {
		  point += len ;
		  return 1 ;	/* section already exists */
		  }
	       return 0 ;	/* section nonexistent, but found position */
	       }
	 if (!nl_forward())
	    break ;
	 }
      return 0 ;	/* section does not yet exist */
      }
   else
      return 0 ;	/* section not found */
}

/*=============================================================*/
/*=============================================================*/

int make_section(section,start_entry,name)
char *section, *name ;
int start_entry ;
{
   int start = point ;

   if (start_entry)
      {
      if (!to_separator_line(-1))  /* find previous separator line */
	 {
	 point = start ;
	 say("Not in an interrupt entry") ;
	 return 0 ;
	 }
      }
   else
      {
      to_begin_line() ;
      while (!empty_line() && !parse_string(1,"\n--------",NULL))
	 if (!nl_reverse())
	    break ;
      }
   point++ ;			     /* skip the newline */
   nl_forward() ;		     /* advance to first line of entry */
   if (!to_section_start(section))
      {
      if (name)
	 stuff(name) ;
      else
	 stuff(section) ;
      stuff("\n") ;
      point-- ; 		     /* back up over inserted newline */
      return 1 ;
      }
   else
      return 0 ;
   return 2 ;  /* just in case */
}

/*=============================================================*/
/*=============================================================*/

int pluralize_section(plural)
char plural ;
{
   point -= 3 ;
   if (curchar() != plural)		/* already plural ? */
      {
      point++ ;
      insert(plural) ;
      }
   nl_forward() ;
   while (!is_separator_line() && parse_string(1,"[ \t]",NULL))
      nl_forward() ;
   stuff("\t\n") ;
   point-- ;
}

/*=============================================================*/
/* Add "SeeAlso: " to the beginning of the current line unless */
/* it is already present				       */
/*=============================================================*/

command see_also() on intlist_tab[ALT('s')]
{
   to_begin_line() ;
   if (parse_string(1,"SeeAlso: ",NULL) == 0)
      stuff("SeeAlso: ") ;
   else
      {
      nl_forward() ;
      stuff("SeeAlso: \n") ;
      point-- ;
      }
}

/*=============================================================*/
/* Add a Desc: section if the current entry does not already   */
/* have one; if there is already a Desc: section, move to the  */
/* start of it						       */
/*=============================================================*/

command desc() on intlist_tab[ALT('D')]
{
   make_section(desc_section,1,NULL) ;
}

/*=============================================================*/
/* Add a Range: section if the current entry does not already  */
/* have one; if there is already a Range: section, move to the */
/* start of it						       */
/*=============================================================*/

command range() on intlist_tab[ALT('R')]
{
   make_section(range_section,1,NULL) ;
}

/*=============================================================*/
/* Add a "Program: " section to the current entry if it does   */
/* not have one; otherwise, move to the beginning of the       */
/* Program: section					       */
/*=============================================================*/

command program() on intlist_tab[ALT('p')]
{
   make_section(program_section,1,NULL) ;
}

/*=============================================================*/
/* Add an "Index: " section to the current entry if it does    */
/* not have one; otherwise, move to the beginning of the       */
/* Index: section					       */
/*=============================================================*/

command add_index() on intlist_tab[ALT('i')]
{
   to_begin_line() ;
   if (parse_string(1,"Index:",NULL))
      {
      while (parse_string(1,"Index:",NULL))
	 nl_forward() ;
      stuff("Index:\t\n") ;
      point-- ;
      }
   else
      make_section(index_section,1,NULL) ;
}

/*=============================================================*/
/*=============================================================*/

command bug() on intlist_tab[ALT('B')]
{
   if (!make_section(bugs_section,1,"BUG:\t"))
      pluralize_section('S') ;
}

/*=============================================================*/
/* Add "Note: " section to the current entry; change an        */
/* existing Note: to Notes: and position at end of Note:       */
/* section.						       */
/*=============================================================*/

command add_note() on intlist_tab[ALT('n')]
{
   if (!make_section(notes_section,0,"Note:\t"))
      pluralize_section('s') ;
}

/*=============================================================*/
/* Insert "Return: " at the beginning of the current line, if  */
/* not already present					       */
/*=============================================================*/

command returns() on intlist_tab[ALT('r')]
{
   int start = point ;
   
   to_begin_line() ;
   if (parse_string(1,return_section,NULL) == 0)
      stuff(return_section) ;
   else
      point = start ;
}

/*=============================================================*/
/* insert a line of dashes prior to the current cursor line    */
/*=============================================================*/

command separator_line() on intlist_tab[FKEY(11)]
{
   int i ;

   to_begin_line() ;
   for (i = 0 ; i < 45 ; i++)
      insert('-') ;
   insert('\n') ;
}

/*=============================================================*/
/*=============================================================*/

void insert_table_counter()
{
   char counter[6] ;
   save_var point = *table_counter + 3 ;

   /* increment that table counter */
   while (curchar() >= '0')
      {
      if (curchar() < '9')
	 {
	 replace(point,curchar()+1) ;
	 break ;
	 }
      else
	 {
	 replace(point,'0') ;
	 point-- ;
	 }
      }
   restore_vars() ;
   /* and now insert the incremented value at point */
   stuff("(Table ") ;
   grab(*table_counter,*table_counter+4,counter) ;
   stuff(counter) ;
   stuff(")") ;
}

/*=============================================================*/
/* type the name of a structure, then invoke this function     */
/* to create the "Format of X:" and "Offset Size Descr" lines  */
/*=============================================================*/

command structure_header() on intlist_tab[FCTRL(11)]
{
   int start = point ;

   to_begin_line() ;
   if (parse_string(1,"Format of ",NULL) == 0)
      {
      stuff("Format of ") ;
      to_end_line() ;
      stuff(":\nOffset\tSize\tDescription\t") ;
      insert_table_counter() ;
      stuff("\n 00h\t") ;
      }
   else
      point = start ;
}

/*=============================================================*/
/* Turn the current line into the header for a "Values of"     */
/* section						       */
/*=============================================================*/

command value_header() on intlist_tab[FSHIFT(11)]
{
   int start = point ;
   
   to_begin_line() ;
   if (parse_string(1,"Values for ",NULL) == 0)
      {
      insert_table_counter() ;
      stuff("\nValues for ") ;
      to_end_line() ;
      stuff(":\n ") ;
      }
   else
      point = start ;
}

/*=============================================================*/
/* Turn the current line into the header of a "Call with"      */
/* section						       */
/*=============================================================*/

command call_with_header() on intlist_tab[FALT(11)]
{
   int start = point ;
   
   to_begin_line() ;
   if (parse_string(1,"Call ",NULL) == 0)
      {
      insert_table_counter() ;
      stuff("\nCall ") ;
      to_end_line() ;
      if (character(point-1) != ' ')
	 stuff(" ") ;
      stuff("with:\n") ;
      }
   else
      point = start ;
}

/*=============================================================*/
/* Turn the current line into the header of a "Bitfield for"   */
/* section						       */
/*=============================================================*/

command bitfields_for_header() on intlist_tab[FALT(12)]
{
   int start = point ;
   
   to_begin_line() ;
   if (parse_string(1,"Bitfields for ",NULL) == 0)
      {
      stuff("Bitfields for ") ;
      to_end_line() ;
      stuff(":\nBit(s)\tDescription\t") ;
      insert_table_counter() ;
      stuff("\n ") ;
      }
   else
      point = start ;
}

/*=============================================================*/
/*=============================================================*/

char grab_entry_number(func_num)
char *func_num ;
{
   char c ;
   int i ;

   strcpy(func_num,"------------") ;	/* 12 dashes */
   point++ ;				/* go to first char of separator line */
   nl_forward() ;			/* go to first line of entry */
   if (parse_string(1,"INT ",NULL) == 0)
      return 0 ;			/* not an interrupt entry, so return */
   point += 4 ;				/* skip the "INT " */
   func_num[0] = curchar() ;		/* grab the interrupt number */
   point++ ;
   func_num[1] = curchar() ;
   nl_forward() ;			/* skip to second line of entry */
   if (parse_string(1,"[ \t]*A[LHX][ \t]=[ \t][0-9A-F][0-9A-F]+h",NULL))
      {
      re_search(1,"[ \t]*A") ;
      c = curchar() ;
      point += 4 ;			/* skip ch and " = " */
      if (c != 'L')
	 {
	 grab(point,point+((c=='X')?4:2),func_num+2) ;
	 point += ((c=='X')?4:2) ;
	 func_num[(c=='H')?4:6] = '-' ;	/* grab() stuck a NUL into the string */
	 }
      else /* c == 'L' */
	 {
	 func_num[4] = curchar() ;
	 point++ ;
	 func_num[5] = curchar() ;
	 point ++ ;
	 }
      point++ ;
      if (parse_string(1,"[ \t]*subfn [0-9A-F][0-9A-F]+h",NULL))
	 {
	 re_search(1,"[ \t]*subfn ") ;
	 func_num[6] = 'S' ;
	 func_num[7] = 'F' ;
	 for (i = 0 ; i < 4 ; i++)
	    {
	    c = curchar() ;
	    if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'F'))
	       {
	       func_num[8+i] = c ;
	       point++ ;
	       }
	    else
	       break ;
	    }
	 }
      nl_forward() ;			/* skip to third line of entry */
      }
   if (parse_string(1,"[ \t]*[BCDES][HILPSX] = [0-9A-F][0-9A-F]+h",NULL))
      {
      re_search(1,"[ \t]*") ;
      func_num[6] = curchar() ;
      point++ ;
      func_num[7] = c = curchar() ;
      point += 4 ;			/* skip curchar and " = " */
      if (c == 'H' || c == 'L')
	 {
	 grab(point,point+2,func_num+8) ;
	 func_num[10] = '-' ;		/* grab() stuck a NUL into the string */
	 }
      else /* c == 'X' || c == 'I' || c == 'P' || c == 'S' */
	 grab(point,point+4,func_num+8) ;
      }
   return 1 ;				/* successful and have func number */
}

/*=============================================================*/
/* Put the interrupt and function number into the separator    */
/* line just above the intlist entry preceding the cursor pos  */
/*=============================================================*/

int number_one_int()
{
   char func_num[13] ;			/* 2->int, 4->AX, 6->extra reg, NUL */
   int oldpoint ;
   
   while (to_separator_line(-1))	/* find previous separator line */
      {
      oldpoint = point ;
      if (grab_entry_number(func_num))	/* does it belong to an intlist entry? */
	 {				/*   if yes, success, else try again */
	 point = oldpoint + 11 ;	/* skip NL and first ten dashes */
	 delete(point,point+12) ;	/* replace 12 dashes by the function */
	 stuff(func_num) ;		/*   number and extra register */
	 point = oldpoint + 9 ;		/* back to category letter position */
	 return 1 ;
	 }
      point = oldpoint ;
      }
   return 0 ;				/* if we get here, we failed */
}

/*=============================================================*/
/* Put the interrupt and function number into the separator    */
/* line just above one or more intlist entries preceding the   */
/* current cursor position, letting user know of progress      */
/*=============================================================*/

command number_int() on intlist_tab[FKEY(12)]
{
   int i, hit_top = 0 ;
   
   for (i = 0 ; i < iter ; i++)
      {
      if (!number_one_int())
	 {
	 hit_top = 1 ;
	 say("No prior entry.") ;
	 break ;
	 }
      if (((i+1) % NUMBER_INT_PROGRESS_INTERVAL) == 0)
	 say("%4d...",i+1) ;
      }
   if (iter > 1 && !hit_top)
      say("Done.") ;
   iter = 1 ;
}

/*=============================================================*/
/*=============================================================*/

int line_has_see_also()
{
   int len ;
   
   to_begin_line() ;
   if ((len = parse_string(1,".*%([sS]ee ",NULL)) != 0)
      {
      point += len ;		/* go to start of cross-reference */
      point += parse_string(1,"also ",NULL) ;
      if (parse_string(1,"INT [0-9A-F]",NULL) ||
	  parse_string(1,"A[XHL] =",NULL)
	 )
	 {
	 point++ ;		/* move into reference */
	 return 1 ;
	 }
      }
   return 0 ;
}

/*=============================================================*/
/*=============================================================*/

int grab_int_reference(ref)
char *ref ;
{
   int begin, start = point ;
   
   re_search(-1,"[, \t\n]") ;	/* backup to start of reference */
   if (curchar() == '\n')	/* start of line? */
      re_search(1,":[ \t]") ;	/* skip the SeeAlso: */
   else if (character(point-1) == 'T' && character(point-2) == 'N')
      point -= 3 ;
   else
      point++ ;			/* back to start of reference */
   begin = point ;
   re_search(1,"[,\n\"]") ;	/* find end of INT-spec */
   point-- ;
   if (curchar() == '\"')	/* extra string at end of INT-spec? */
      {
      point++ ;
      re_search(1,"[\"\n]") ;	/* if yes, run to end of line or string */
      }
   grab(begin,point,ref) ;
   point = start ;
   return 0 ;
}

/*=============================================================*/
/*=============================================================*/

int parse_int_name(entry_name,id,extra_string)
char *entry_name, *id, *extra_string ;
{
   int start = point ;
   int i ;
   char c, *last ;

   for (i = strlen(entry_name)-1 ; i >= 0 ; i--)
      entry_name[i] = toupper(entry_name[i]) ;
   strcpy(id,"------------") ;
   if (strncmp(entry_name,"INT ",4) == 0)
      {
      id[0] = entry_name[4] ;
      id[1] = entry_name[5] ;
      entry_name += 6 ;
      if (entry_name[0] == '/')
	 entry_name++ ;
      }
   else if (to_separator_line(-1))
      {
      id[0] = character(point+11) ;
      id[1] = character(point+12) ;
      }
   point = start ;
   c = entry_name[1] ;
   if (entry_name[0] == 'A' && (c == 'X' || c == 'H' || c == 'L'))
      {
      entry_name += 2 ;
      while (entry_name[0] == ' ' || entry_name[0] == '\t')
	 entry_name++ ;
      if (entry_name[0] == '=')
	 entry_name++ ;
      while (entry_name[0] == ' ' || entry_name[0] == '\t')
	 entry_name++ ;
      if (c != 'L')
	 {
         id[2] = entry_name[0] ;
         id[3] = entry_name[1] ;
	 }
      if (c == 'X')
	 {
	 id[4] = entry_name[2] ;
	 id[5] = entry_name[3] ;
	 entry_name += 4 ;
	 }
      else
	 {
	 if (c == 'L')
	    {
	    id[2] = entry_name[0] ;
	    id[3] = entry_name[1] ;
	    }
	 entry_name += 2 ;
	 }
      if (entry_name[0] == 'H')
	 entry_name++ ;
      if (entry_name[0] == '/')
	 entry_name++ ;
      }
   if (index("ABCDES",entry_name[0]) && index("HILPSXF",entry_name[1]))
      {
      id[6] = entry_name[0] ;
      c = id[7] = entry_name[1] ;
      entry_name += 2 ;
      while (entry_name[0] == ' ' || entry_name[0] == '\t')
	 entry_name++ ;
      if (entry_name[0] == '=')
	 entry_name++ ;
      while (entry_name[0] == ' ' || entry_name[0] == '\t')
	 entry_name++ ;
      id[8] = entry_name[0] ;
      id[9] = entry_name[1] ;
      if (c != 'H' && c != 'L' && (c != 'F' || entry_name[2] != 'h'))
	 {
	 id[10] = entry_name[2] ;
	 id[11] = entry_name[3] ;
	 entry_name += 4 ;
	 }
      else
	 entry_name += 2 ;
      if (entry_name[0] == 'H')
	 entry_name++ ;
      if (entry_name[0] == '/')
	 entry_name++ ;
      }
   if (entry_name[0] == '\"')
      {
      entry_name++ ;
      strcpy(extra_string,entry_name) ;
      last = index(extra_string,'\"') ;
      if (last)
	 *last = '\0' ;
      }
   else
      extra_string[0] = '\0' ;
   return 0 ;
}

/*=============================================================*/
/*=============================================================*/

int hex2_to_int(c1,c2)
char c1, c2 ;
{
   if (c1 >= '0' && c1 <= '9')
      c1 -= '0' ;
   else if (c1 >= 'A' && c1 <= 'F')
      c1 = c1 - 'A' + 10 ;
   else if (c1 >= 'a' && c1 <= 'f')
      c1 = c1 - 'a' + 10 ;
   else
      return -1 ;
   if (c2 >= '0' && c2 <= '9')
      c2 -= '0' ;
   else if (c2 >= 'A' && c2 <= 'F')
      c2 = c2 - 'A' + 10 ;
   else if (c2 >= 'a' && c2 <= 'f')
      c2 = c2 - 'a' + 10 ;
   else
      return -1 ;
   return 16*c1 + c2 ;
}

/*=============================================================*/
/*=============================================================*/

char hex_digit(val)
int val ;
{
   if (val < 0)
      return '-' ;
   else
      return (val > 9) ? ('A' + val - 10) : ('0' + val) ;
}

/*=============================================================*/
/*=============================================================*/

int scan_for_entry(entry,extra_str,first_entry)
char *entry, *extra_str ;
int *first_entry ;
{
   int ah, al, t1, t2, match, found ;
   char buf[7] ;

   if (extra_str) extra_str = 0 ;  /* for now, to avoid compiler warning */
   *first_entry = 0 ;
   ah = hex2_to_int(entry[2],entry[3]) ;
   while (1)
      {
      if (!to_separator_line(1))
	 return 0 ;	/* failed if hit end of file */
      if (character(point+1) != entry[0] || character(point+2) != entry[1])
	 return 0 ;	/* failed if no longer on same interrupt */
      t1 = hex2_to_int(character(point+3),character(point+4)) ;
      if (t1 == ah)
	 break ;
      else if (t1 > ah)
	 {
	 to_begin_line() ;
	 *first_entry = point ;
	 return 0 ;	/* no such entry */
	 }
      }
   nl_reverse() ;
   *first_entry = point ;
   found = 0 ;
   al = hex2_to_int(entry[4],entry[5]) ;
   while (1)
      {
      if (!to_separator_line(1))
	 return 0 ;	/* failed if hit end of file */
      if (character(point+1) != entry[0] || character(point+2) != entry[1])
	 return 0 ;	/* failed if no longer on same interrupt */
      t1 = hex2_to_int(character(point+3),character(point+4)) ;
      if (t1 != ah)
	 return 0 ;	/* failed if no longer on same INT/AH combo */
      t2 = hex2_to_int(character(point+5),character(point+6)) ;
      if (t2 == al)
	 {
	 if (!found)
	    {
	    found = 1 ;
	    *first_entry = point ;
	    }
	 if (entry[6] != '-')
	    {
	    grab(point+7,point+12,buf) ;
	    match = strncmp(buf,entry+6,6) ;
	    if (match == 0)
	       {
	       *first_entry = point ;
	       break ;
	       }
	    else if (match > 0)
	       return 0 ;	/* no exact match, but return a partial match */
	    }
	 else
	    break ;
	 }
      else if (t2 > al)
	 {
	 if (found)
	    break ;
	 else
	    {
	    to_begin_line() ;
	    *first_entry = point ;
	    return 0 ;	/* no such entry */
	    }
	 }
      }
   point = *first_entry ;	/* back to first matching entry */
   
   
   return 1 ;			/* we were successful */
}

/*=============================================================*/
/*=============================================================*/

int goto_entry(entry_name)
char *entry_name ;
{
   char int_id[13], extra_string[60] ;
   int start = point, first_entry ;
   int int_num, curr_int ;
   char search_str[22] ;
   
   parse_int_name(entry_name,int_id,extra_string) ;
   int_num = hex2_to_int(int_id[0],int_id[1]) ;
   if (to_separator_line(-1))
      {
      if (character(point+11) == '-')
	 curr_int = -1 ;
      else
	 curr_int = hex2_to_int(character(point+11),character(point+12)) ;
      if (int_num <= 0)
	 point = 0 ;		/* go to top of file */
      else
	 {
	 if (curr_int < 0)
	    point = 0 ;		/* go to top of file */
	 strcpy(search_str,"----------") ;
	 search_str[10] = hex_digit((int_num-1) / 16) ;
	 search_str[11] = hex_digit((int_num-1) % 16) ;
	 search_str[12] = '\0' ;
	 search( (int_num<=curr_int)?-1:1, search_str) ;
	 to_begin_line() ;
	 }
      }
   else
      point = 0 ;
   if (!scan_for_entry(int_id,extra_string,&first_entry))
      {
      say("%s not found.",entry_name) ;
      if (first_entry)
	 {
	 mark = start ;
	 point = first_entry ;
	 }
      else
	 point = start ;
      }
   if (has_arg)
     iter = 1 ;				/* don't search repeatedly */
   return 0 ;
}

/*=============================================================*/
/*=============================================================*/

command goto_int() on intlist_tab[FCTRL(12)]
{
   char entry_name[60], def_entry[60] ;
   int start = point ;

   to_begin_line() ;
   if (parse_string(1,"SeeAlso: ",NULL) != 0)
      {
      point += 9 ;		/* skip the SeeAlso: */
      if (point < start)	/* if we were originally to the right of     */
	 point = start ;	/* current position, go back to original pos */
      grab_int_reference(def_entry) ;
      get_strdef(entry_name,"Goto Interrupt",def_entry) ;
      }
   else if (line_has_see_also())
      {
      grab_int_reference(def_entry) ;
      get_strdef(entry_name,"Goto Interrupt",def_entry) ;
      }
   else
      get_string(entry_name,"Goto Interrupt: ") ;
   point = start ;
   goto_entry(entry_name) ;
   if (has_arg)
      iter = 1 ;
}

/*=============================================================*/
/*=============================================================*/

void fix_unnumbered_tables()
{
   int matchsize ;
   
   point = 0 ;
   while (search(1,"\n\n"))
      {
      switch(curchar())
	 {
	 case 'C':
	    if (parse_string(1,"Call ") != 0)
	       {
	       /* we got Call..., we know it doesn't have a table number */
	       insert_table_counter() ;
	       stuff("\n") ;
	       }
	    break ;
	 case 'V':
	    if (parse_string(1,"Values ") != 0)
	       {
	       /* we know this Values... doesn't have a table number */
	       insert_table_counter() ;
	       stuff("\n") ;
	       }
	    break ;
	 case 'B':
	    if (parse_string(1,"Bitfields ",0) == 0)
	       break ;
	    nl_forward() ;    /* skip to start of next line */
	    if (parse_string(1,".*\t%(Table ",0) == 0)
	       {
	       /* if the pattern didn't match, there is no table number, */
	       /* so add it */
	       to_end_line() ;
	       matchsize = parse_string(-1,"[ \t]+",0) ;
	       if (matchsize)
		  delete(point-matchsize,point) ;
	       stuff("\t") ;
	       insert_table_counter() ;
	       }
	    break ;
	 case 'F':
	    if (parse_string(1,"Format ",0) == 0)
	       break ;
	    nl_forward() ;    /* skip to start of next line */
	    if (parse_string(1,".*\t%(Table ",0) == 0)
	       {
	       /* if the pattern didn't match, there is no table number, */
	       /* so add it */
	       to_end_line() ;
	       matchsize = parse_string(-1,"[ \t]+",0) ;
	       if (matchsize)
		  delete(point-matchsize,point) ;
	       stuff("\t") ;
	       insert_table_counter() ;
	       }
	    break ;
	 default:
	    /* not a table header, so ignore it */
	    break ;
	 }
      }
}

/*=============================================================*/
/*=============================================================*/

int *gather_table_numbers(number_of_tables)
int *number_of_tables ;
{
   int i, num_tables ;
   int tcount = 0 ;
   char counter[5] ;
   int *new_numbers ;
   int old_number ;
   save_var case_fold = 0 ;
   
   grab(*table_counter,*table_counter+4,counter) ;
   num_tables = strtoi(counter,10) ;
   new_numbers = (int *)malloc((num_tables+2)*sizeof(int)) ;
   for (i = 0 ; i <= num_tables ; i++)
      new_numbers[i] = 0 ;
   point = 0 ;
   while (search(1,"(Table "))
      {
      grab(point,point+4,counter) ;
      old_number = strtoi(counter,10) ;
      if (old_number > 0 && old_number <= num_tables)
	 new_numbers[old_number] = ++tcount ;
      }
   if (number_of_tables)
      *number_of_tables = num_tables ;
   return new_numbers ;
}

/*=============================================================*/
/*=============================================================*/

int adjust_table_numbers(num_tables,new_numbers)
int num_tables ;
int *new_numbers ;
{
   char counter[5] ;
   int old_number ;
   int dangling = 0 ;
   
   point = 0 ;
   while (search(1,"(Table "))
      {
      grab(point,point+4,counter) ;
      old_number = strtoi(counter,10) ;
      if (old_number > 0 && old_number <= num_tables)
	 {
	 delete(point,point+4) ;
	 bprintf("%04d",new_numbers[old_number]) ;
	 }
      }
   point = 0 ;
   while (re_search(1,"[, \t]%#[0-9][0-9][0-9][0-9]"))
      {
      grab(point-4,point,counter) ;
      old_number = strtoi(counter,10) ;
      if (old_number > 0 && old_number <= num_tables)
	 {
	 if (new_numbers[old_number])
	    {
	    delete(point-4,point) ;
	    bprintf("%04d",new_numbers[old_number]) ;
	    }
	 else /* dangling xref */
	    {
	    dangling++ ;
	    point -= 4 ;
	    stuff("?") ;
	    point += 4 ;
	    }
	 }
      }
   return dangling ;
}

/*=============================================================*/
/*=============================================================*/

command renumber_tables()
{
   int number_of_tables ;
   int *new_numbers ;
   spot start = alloc_spot(1) ;
   int dangling ;
   
   *start = point ;
   say("Pass 1: numbering unnumbered tables") ;
   fix_unnumbered_tables() ;
   say("Pass 2: gathering table numbers") ;
   new_numbers = gather_table_numbers(&number_of_tables) ;
   say("Pass 3: adjusting table numbers") ;
   dangling = adjust_table_numbers(number_of_tables,new_numbers) ;
   free(new_numbers) ;
   if (dangling)
      say("%d dangling cross-references, search for '#?'",dangling) ;
   else
      say("Done") ;
   point = *start ;
   free_spot(start) ;
}

/*=============================================================*/
/*=============================================================*/

void find_table_counter()
{
   save_var point = (size() > 10000) ? size() - 10000 : 0 ;

   search(1,"Highest Table Number = ") ;
   table_counter = alloc_spot(1) ;
}

/*=============================================================*/
/* Put the current buffer into IntList major mode	       */
/*=============================================================*/

command intlist_mode()
{
   mode_keys = intlist_tab ;
   intlist_tab[')'] = intlist_tab[']'] = (short) show_matching_delimiter;
   delete_hacking_tabs = 0 ;
   major_mode = strsave("IntList") ;
   make_mode() ;
   auto_indent = 0 ;
   margin_right = 79 ;
   want_backups = 1 ;
   undo_size = 100000 ;     /* less than default 500,000 since list is so big */
   find_table_counter() ;
}

when_loading()
{
   char *curbuf ;

   want_backups = want_backups.default = 1 ;
   strcpy(backup_name,"%pbak/%b%e") ;		/* put backups in BAK subdir */
   one_window() ;
   intlist_mode() ;
   if (exist("interrup.1st"))
      {
      curbuf = bufname ;
      bufname = "interrup.1st" ;
      intlist_mode() ;
      bufname = curbuf ;
      }
/* Epsilon v6.0+ */
   strcpy(mode_end," %d%p %S") ;
}

/*=============================================================*/
/* automagically switch into interrupt list mode on .LST and .1ST files */

suffix_lst()   { intlist_mode(); }
suffix_1st()   { intlist_mode(); }


