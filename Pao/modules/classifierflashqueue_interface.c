#include "classifierflashqueue_interface.h"

void cqInitialize()
{
  cqSetFront(INITIAL_REC_KEY-1);
  cqSetRear(INITIAL_REC_KEY-1); 
}

uint16_t cqGetFront()
{
  uint32_t *p_read_data = NULL;
  fds_data_read(POINTERS_FILE_ID, FRONT_REC_KEY, p_read_data);
  uint16_t *p_front = (uint16_t *)p_read_data;
  uint16_t front = *p_front;
  return front;
}

uint16_t cqGetRear()
{
  uint32_t *p_read_data = NULL;
  fds_data_read(POINTERS_FILE_ID, REAR_REC_KEY, p_read_data);
  uint16_t *p_rear = (uint16_t *)p_read_data;
  uint16_t rear = *p_rear;
  return rear;
}

void cqSetFront(uint16_t new_front)
{ 
  uint32_t new_front_32 = (uint32_t) new_front;
  uint32_t *p_new_front_32 = &new_front_32;
  fds_data_write(POINTERS_FILE_ID, FRONT_REC_KEY, p_new_front_32,1);
}

void cqSetRear(uint16_t new_rear)
{
  uint32_t new_rear_32 = (uint32_t) new_rear;
  uint32_t *p_new_rear_32 = &new_rear_32;
  fds_data_write(POINTERS_FILE_ID, REAR_REC_KEY, p_new_rear_32,1);
}

void cqEnqueue(entry_t* write_data)
{   
   flash_entry_t new_entry;
   new_entry.value = (uint32_t) write_data->proba;
   new_entry.label = (uint32_t) write_data->label;
   new_entry.timestamp = (uint32_t) write_data->timestamp;

   if(cqGetRear() == SIZE-1)
   {
    debugMsg("Queue is full, enqueue not possible.");    
   }
   else
   {
    if(cqGetFront() == (INITIAL_REC_KEY-1))
    {
      cqSetFront(INITIAL_REC_KEY);

    }
    cqSetRear(cqGetRear()+1);
    uint32_t *p_new_entry_32 = (uint32_t*)&new_entry;
    fds_data_write(ENTRIES_FILE_ID, cqGetRear(), p_new_entry_32, 3);
        debugMsg("Enqueued element.");
   }
 }

entry_t* cqDequeue()
{
  entry_t *out = NULL;
  
  if(cqGetFront() == cqGetRear())
  {
    debugMsg("Queue is empty, dequeue not possible.");
  }
  else
  {
    uint32_t *p_read_data = NULL;
    fds_data_read(POINTERS_FILE_ID, cqGetFront(), p_read_data);
    flash_entry_t *p_old_front = (flash_entry_t *)p_read_data;
    flash_entry_t old_front = *p_old_front;
    out = (entry_t*)malloc(sizeof(entry_t));
    out->proba = (proba_t) old_front.value;
    out->label = (class_t) old_front.label;
    out->timestamp = (uint16_t) old_front.timestamp;
    cqSetFront(cqGetFront()+1);
    
    if (cqGetFront() == cqGetRear())
    {
      cqInitialize();
    }
   }

   debugMsg("Dequeued element.");
   return out;
}

entry_t* cqDisplay()
{
  entry_t *front = NULL;

  if(cqGetRear() == (INITIAL_REC_KEY-1))
   {
    debugMsg("Queue is empty.");
   }
   else
   {
    uint32_t *p_read_data = NULL;
    fds_data_read(POINTERS_FILE_ID, cqGetFront(), p_read_data);
    flash_entry_t *p_flash_front = (flash_entry_t *)p_read_data;
    flash_entry_t flash_front = *p_flash_front;
    front = (entry_t*)malloc(sizeof(entry_t));
    front->proba = (proba_t) flash_front.value;
    front->label = (class_t) flash_front.label;
    front->timestamp = (uint16_t) flash_front.timestamp;
  }
  
  return front;
}    