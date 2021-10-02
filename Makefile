VERSION = 1.0.0
CFLAGS = --pedantic -g -Wall
MCP_OBJECTS = $(patsubst %.c,%.o,$(wildcard *.c))
ALL_OBJECTS = $(patsubst %.c,%.o,$(wildcard *.c hashtable/*.c))

all: mcp

utils.o: utils.c utils.h
	cc $(CFLAGS) -c -o utils.o utils.c

input.o: input.c input.h
	cc $(CFLAGS) -c -o input.o input.c

mcp.o: mcp.c input.h utils.h
	cc $(CFLAGS) -c -o mcp.o mcp.c

mcp: $(MCP_OBJECTS) hash_table
	cc $(CFLAGS) -lm -o mcp $(ALL_OBJECTS)

hash_table:
	cd hashtable; $(MAKE)

dist: clean
	tar -cjf mcp-$(VERSION).tar.bz2 *

clean:
	cd hashtable; make clean
	rm *.o mcp
