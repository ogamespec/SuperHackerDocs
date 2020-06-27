/* INT2QH.C
 *
 * Author:   Kai Uwe Rommel
 * Date:     Sun 07-Oct-1990
 * Update:   Sat 20-Oct-1990
 * Update:   Sun 11-Nov-1990  Ralf Brown
 *
 * Compiler: MS C 5.00 and newer / compact model, or TC 2.0 / compact model
 * System:   PC/MS-DOS 3.20 and newer, OS/2 1.0 and newer
 *
 */

#define LABEL    "int2qh.c"
#define VERSION  "1.2"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define divider_line(s) (strncmp(s,"--------",8)==0)


FILE *input, *output, *topics, *subtopics;

char line1[128];
char line2[128];
char category[128];
char parent[128];

int sub;


int _fputs(char *line, FILE *stream)
{
  char buffer[128];
  int cnt = 0;

  while ( *line )
  {
    if ( *line == '\\' )
      buffer[cnt++] = '\\';

    buffer[cnt++] = *line++;
  }

  buffer[cnt] = 0;

  return fputs(buffer, stream);
}


void Initialize(void)
{
  input     = fopen("interrup.lst", "r");
  output    = stdout;
  topics    = fopen("topic.tmp", "w");
  subtopics = fopen("subtopic.tmp", "w");

  fprintf(topics,
    ".context List Categories\n.list\nInterrupt-List\n"
    ".context Interrupt-List\n.context INTLIST\n.topic Interrupt-List\n.list\n"
    );
}


void Cleanup(void)
{
  fclose(topics);
  fclose(subtopics);

  topics = fopen("topic.tmp", "r");
  subtopics = fopen("subtopic.tmp", "r");

  while ( fgets(line1, sizeof(line1), topics) )
    fputs(line1, output);

  while ( fgets(line1, sizeof(line1), subtopics) )
    fputs(line1, output);

  fcloseall();

  unlink("topic.tmp");
  unlink("subtopic.tmp");
}


void CopyMemory(void)
{
  FILE *temp = fopen("memory.lst", "r");

  while ( fgets(line2, sizeof(line2), temp) )
    _fputs(line2, output);

  fclose(temp);
}


void StartTopic(char *name, char *desc)
{
  fprintf(sub ? subtopics : topics, "%s  %s\n", name, desc);
  fprintf(output, ".context %s\n.category %s\n.topic %s\n", name, parent, desc);
}


void StartList(char *name, char *desc)
{
  fprintf(topics, "%s  %s (list)\n", name, desc);
  fprintf(subtopics, ".context %s\n.category %s\n.topic %s\n.list\n", name, parent, desc);

  strcpy(category, desc);
  strcpy(parent, name);
  sub = 1;
}


void EndList(void)
{
  strcpy(category, "Interrupt-List");
  strcpy(parent, "INTLIST");
  sub = 0;
}


char *NextID(void)
{
  static char ID[32];
  static unsigned long CurrentID = 0;

  CurrentID++;
  sprintf(ID, "IL%04ld", CurrentID);

  return ID;
}


int RecognizedTopic(void)
{
  char *ptr, topic[64], desc[128];

  if ( fgets(line2, sizeof(line2), input) == NULL )
    return 0;

  if ( (ptr = strchr(line1, '-')) == NULL )
    return 0;

  *--ptr = 0;
  strcpy(topic, line1);
  *ptr = ' ';

  if ( topic[strlen(topic) - 1] == 'h' )
    topic[strlen(topic) - 1] = 0;

  if ( strcmp(category, topic) && sub )
    EndList();

  strcpy(desc, line1);
  desc[strlen(desc) - 1] = 0;

  for (ptr = line2 ; isspace(*ptr) ; ptr++)
     ;

  if ( (!strncmp(ptr, "AX =", 4) ||
	!strncmp(ptr, "AH =", 4) ||
	!strncmp(ptr, "AL =", 4))
       && !sub )
    StartList(NextID(), topic);

  StartTopic(NextID(), desc);

  _fputs(line1, output);
  if ( !divider_line(line2) )
    _fputs(line2, output);

  return 1;
}


void CopyTopic(void)
{
  if ( divider_line(line2) )
  { /* kludge for one-line interrupts */
    fgets(line1, sizeof(line2), input);
    return;
  }

  for (;;)
  {
    if ( fgets(line1, sizeof(line1), input) == NULL )
      break;

    if ( !divider_line(line1) )
      _fputs(line1, output);
    else
    {
      if ( fgets(line2, sizeof(line2), input) == NULL )
	break;

      if ( strncmp(line2, "INT ", 4) )
      {
	_fputs(line1, output);
	_fputs(line2, output);
      }
      else
      {
	strcpy(line1, line2);
	break;
      }
    }
  }
}


void main(void)
{
  fprintf(stderr, "\nINT2QH %s - (c) Kai Uwe Rommel - %s\n", VERSION, __DATE__);

  Initialize();
  EndList();

  StartTopic("HEADER", "Overview of the Interrupt List");
  CopyTopic();

  StartTopic("MEMLIST", "BIOS Memory List");
  CopyMemory();

  while ( RecognizedTopic() )
    CopyTopic();

  Cleanup();

  exit(0);
}


/* End of INT2QH.C */
