#ifndef CLASSIFIERFLASHQUEUE_INTERFACE_H_
#define CLASSIFIERFLASHQUEUE_INTERFACE_H_

#include<stdio.h>
#include "flash-interface.h"
#include "fds_interface.h"

#define CQ_ENTRIES_FILE_ID     0x1111
#define CQ_INITIAL_REC_KEY     0x0002
#define CQ_POINTERS_FILE_ID    0x0001
#define CQ_FRONT_REC_KEY       0xAAFF
#define CQ_REAR_REC_KEY        0xBBFF
#define CQ_SIZE                0x1068 //Size is 4200.

typedef struct flash_entry
{ 
  uint32_t value;
  uint32_t label;
  uint32_t timestamp;
}__attribute__((packed)) flash_entry_t;

void cqInitialize();
uint16_t cqGetFront();
uint16_t cqGetRear();
void cqSetFront(uint16_t new_front);
void cqSetRear(uint16_t new_rear);
void cqEnqueue(entry_t* write_data);
entry_t* cqDequeue();
entry_t* cqDisplay();

#endif /* CLASSIFIERFLASHQUEUE_INTERFACE_H_ */