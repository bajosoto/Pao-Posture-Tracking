#include<stdio.h>
#include
#define ENTRIES_FILE_ID     0x1111
#define INITIAL_REC_KEY     0x0002
#define POINTERS_FILE_ID    0x0001
#define FRONT_REC_KEY       0xAAFF
#define REAR_REC_KEY        0xBBFF
#define SIZE                1000

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
void cqEnqueue(entry_t write_data);
entry_t cqDequeue();
flash_entry_t cqDisplay();
