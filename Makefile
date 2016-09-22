#place to put the binary
DEST 	= .

#place where tush.doc will be looked for, relative to place where xtush is
#run from
HELPFILEDIR = .

#name the binary will be given
PROGRAM = xtush

#Compiler to use
CC      = gcc

#Compiler flags
CFLAGS  = -O2 

# Select your version of unix
# Available flags - SYSV, system V Revision 4 type unixes
#                   BSD, bsd type unixes
#                   LINUX, For linux, oddly enough (use with BSD)
#                   NO_FILIO, try defining this if you get errors with
#                             not finding sys/filio.h
#SYSTEM = -DSYSV
SYSTEM = -DSYSV -DNO_FILIO
#SYSTEM = -DBSD -DLINUX
#SYSTEM = -DBSD

# Comment this out if you want to try compiling with fancy malloc information
# type things, but it may cause problems compiling, depending on your system
MALL = -DNO_FANCY_MALLOC

# As default, xtush compiles to be just like tush, with some small bug fixes.
# If you uncomment these lines, then the graphical capabilities will be
# included as well. This includes support for the bsx mud graphics, and
# my own system which is starting to be supported by foothills.
#GRAPHICS = -DGRAPHICS
#EXTRALIBS =  -lm -lX11

# Swap the LIBS definitions around if you're trying to compile this on
# Solaris 2.2
# The -L and -R should point to where your ucb libs are.
# Solaris/SysV version
LIBS = -lc -lncurses $(EXTRALIBS)
# bsd version
#LIBS    = -ltermcap $(EXTRALIBS)
# linux version
#LIBS    = -ltermcap -lbsd $(EXTRALIBS)



#######################################################################
# You shouldn't need to alter anything below here.

DEFS = $(SYSTEM) $(MALL) $(GRAPHICS) -DHELPPATH='"$(HELPFILEDIR)/tush.doc"'


HDRS          = clist.h \
		config.h

OBJS          = alias.o \
		command.o \
		main.o \
		socket.o \
		vscreen.o \
                graphics.o \
		bsxgraphics.o

SRCS          = alias.c \
		command.c \
		main.c \
		socket.c \
		vscreen.c \
                graphics.c \
		bsxgraphics.c

all:            $(PROGRAM)

$(PROGRAM):     $(OBJS)
	$(CC) $(CFLAGS) -o $(PROGRAM) $(DEFS) $(OBJS) $(LIBS)

install:
	strip $(PROGRAM)
	cp $(PROGRAM) $(DEST)/$(PROGRAM)
	cp tush.doc $(HELPFILEDIR)/tush.doc


program:        $(PROGRAM)

depend:
	makedepend $(SRCS)

clean:
	$(RM) *~ *.o $(PROGRAM)

tar:
	cd ..;tar -cf xtush-1.4.tar xtush/*.c xtush/*.h xtush/Makefile.std xtush/Imakefile xtush/INSTALL xtush/tush.doc xtush/README xtush/bitmaps xtush/BUGS
	cd ..;gzip xtush-1.4.tar

.c.o:
	$(CC) $(CFLAGS) $(DEFS) -c $<

###
alias.o: config.h
command.o: config.h clist.h
main.o: config.h
socket.o: config.h
vscreen.o: config.h
graphics.o: config.h
bsxgraphics.o: config.h
