                     iAPX 86 Interrupt Primer
                     ------------------------

                          by Ralf Brown
                              12/87
		     Updated 6/88, 4/90, 9/92


What is an interrupt?
   An interrupt is a hardware signal that tells the CPU to 
   temporarily stop what it is doing and go do something else.  
   Without interrupts, the CPU would have to constantly check for 
   external events; with interrupts, the CPU can work on 
   something else and still respond to an event as soon as it 
   occurs. 

   CPUs typically have an instruction to disable interrupts for 
   use when a section of code has to run without being disturbed 
   by external events.  Because of this, most CPUs also have a 
   special interrupt called a Non-Maskable Interrupt (NMI), which 
   is responded to even when all other interrupts are disabled.  
   The NMI is used to signal calamities such as memory failure or 
   imminent power loss.

Why so many different interrupts?
   The 8086 family of processors has the ability to recognize 256 
   different interrupts.  They also have the ability to let a 
   program invoke any of these interrupts with a special 
   instruction, known as a software interrupt (as opposed to a 
   hardware interrupt which is signalled from outside the 
   processor).  Software interrupts are treated just like 
   hardware interrupts, except that they are never disabled and 
   do not result in an acknowledgement to other chips in the 
   computer.  The software interrupt instruction on the 8086 
   family is called INT, and is given the number of the 
   interrupt.  Thus an INT 21h instruction invokes interrupt 
   number 33 decimal.

   Other processors also have software interrupts, though they 
   often use different names, such as the Motorola 68000 family 
   TRAP instruction, the Intel 8080 RST (ReSTart) instruction, or
   many mainframes' SVC (SuperVisor Call). 

   Since a program can invoke an interrupt by number rather than 
   by its address (as it has to in calling subroutines), 
   interrupts are a convenient way of providing services without 
   having to recompile a program whenever the address of the code 
   providing the service changes.  This also allows a user 
   program to enhance the services provided by directing the 
   interrupt to itself.  These enhanced services can then be made 
   available to other programs.

How does an interrupt work?
   The 8086 reserves the lowest 1024 bytes of memory for a table 
   containing the addresses for each of the 256 possible 
   interrupts.  When an interrupt occurs (hardware or software), 
   the processor multiplies its number by 4 and looks at the 
   resulting memory location to find the address of the piece of 
   code which handles the interrupt.  It then places the current 
   address in the program and the processor flags on the stack, 
   and jumps to the beginning of the interrupt handler.

   When the interrupt handler finishes, it invokes a special 
   instruction to return from the interrupt.  This instruction 
   takes the previously saved flags and program address off of 
   the stack and places them back in the appropriate registers in 
   the CPU.

   The interrupt handler has to be careful to preserve any 
   registers that it uses which are not used to communicate 
   results to the program that invoked the interrupt.  If the 
   interrupt can be triggered by a hardware interrupt (only 
   certain ones can on IBM PC's, XT's, and AT's), then the 
   interrupt handler has to preserve ALL registers, since the 
   interrupt could have happened anywhere.


GLOSSARY
--------
API (Application Program[ming] Interface)
   An API is the set of function calls and services that a
   program makes available to other processes (applications).
   Each function or service has a set format which specifies
   the values to be supplied by the caller and the values
   which are returned.	Because of this interface
   specification, the underlying organization of the
   function or service can be changed without affecting the
   applications which use it.  For example, the DOS INT 21h
   file access functions remained unchanged between DOS 2.x
   and DOS 3.x, even though the internal data structures and
   code organization changed significantly.

NMI (Non-Maskable Interrupt)
   Most external (hardware) interrupts can be disabled by the
   CLI (CLear Interrupt enable flag) instruction when the CPU
   is executing critical code that should not be interrupted,
   such as switching from one stack to another.  However, there
   are some situations so dire that the CPU must act on them
   immediately no matter what else it is doing, even if it has
   disabled interrupts.  The Non-Maskable Interrupt serves
   precisely this purpose, as it cannot be disabled (masked) by
   the CPU.
