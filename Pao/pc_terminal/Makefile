
CC=gcc
CFLAGS = -g -Wall -lm

CUSTOMFLAGS = -DBUILD_PC
#CUSTOMFLAGS += -DDEBUG_MSG_NO_CHECKSUM
#CUSTOMFLAGS += -DDEBUG_MSG_NO_ACK
#CUSTOMFLAGS += -DDEBUG_MSG_ACK
#CUSTOMFLAGS += -DDEBUG_MSG_ASCII
#CUSTOMFLAGS += -DDEBUG_RAW_MSG
EXEC = ./pc-terminal

#TODO: Make a proper makefile

all:
	$(CC) $(CFLAGS) $(CUSTOMFLAGS) ../comm-prot/sm/uart-sm.c ../comm-prot/pc/pc-key-rx.c ../comm-prot/pc/pc-js-rx.c ../comm-prot/pc/pc-uart-rx.c ../comm-prot/pc/pc-uart-tx.c interface.c pc_terminal.c -lncurses -o $(EXEC) 

run: all
	$(EXEC)