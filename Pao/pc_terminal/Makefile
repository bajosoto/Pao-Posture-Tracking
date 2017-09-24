
CC=gcc
CFLAGS = -g -Wall -lm
CFLAGS += -lncurses

SRC_FILES += \
  ../comm-prot/sm/uart-sm.c \
  ../comm-prot/pc/pc-key-rx.c \
  ../comm-prot/pc/pc-uart-rx.c \
  ../comm-prot/pc/pc-uart-tx.c \
  interface.c \
  pc_terminal.c

INC_DIRS += \
  ./ \
  ../comm-prot/sm \
  ../comm-prot/pc \
  ../comm-prot/es

INC_PARAMS=$(foreach d, $(INC_DIRS), -I$d)

CUSTOMFLAGS = -DBUILD_PC
#CUSTOMFLAGS += -DDEBUG_MSG_NO_CHECKSUM
#CUSTOMFLAGS += -DDEBUG_MSG_NO_ACK
#CUSTOMFLAGS += -DDEBUG_MSG_ACK
#CUSTOMFLAGS += -DDEBUG_MSG_ASCII
#CUSTOMFLAGS += -DDEBUG_RAW_MSG
EXEC = ./pc-terminal

#TODO: Make a proper makefile

all:
	$(CC) $(CFLAGS) $(INC_PARAMS) $(SRC_FILES) $(CUSTOMFLAGS) -o $(EXEC) 

run: all
	$(EXEC)