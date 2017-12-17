#include "classifierflashqueue_interface.h"

void cqInitialize()
{
  cqSetFront(CQ_INITIAL_REC_KEY-1);
  cqSetRear(CQ_INITIAL_REC_KEY-1);
  debugMsg("Classifier queue initialized.");
  uint16_t front = cqGetFront();
  uint16_t rear = cqGetRear();
  debugMsg("Initial values. (%d, %d)", front, rear);

}

uint16_t cqGetFront()
{
  return *((uint16_t *) fds_data_read(CQ_POINTERS_FILE_ID, CQ_FRONT_REC_KEY));
}

uint16_t cqGetRear()
{
  return *((uint16_t *) fds_data_read(CQ_POINTERS_FILE_ID, CQ_REAR_REC_KEY));
}

void cqSetFront(uint16_t new_front)
{ 
  uint32_t new_front_32 = (uint32_t) new_front;
  uint32_t *p_new_front_32 = &new_front_32;
  fds_data_write(CQ_POINTERS_FILE_ID, CQ_FRONT_REC_KEY, p_new_front_32,1);
}

void cqSetRear(uint16_t new_rear)
{
  uint32_t new_rear_32 = (uint32_t) new_rear;
  uint32_t *p_new_rear_32 = &new_rear_32;
  fds_data_write(CQ_POINTERS_FILE_ID, CQ_REAR_REC_KEY, p_new_rear_32,1);
}

void cqEnqueue(entry_t* write_data)
{   
   flash_entry_t new_entry;
   new_entry.value = (proba_t) write_data->proba;
   new_entry.label = (uint32_t) write_data->label;
   new_entry.timestamp = (uint32_t) write_data->timestamp;

   if(cqGetRear() == CQ_SIZE-1)
   {
    debugMsg("Queue is full, enqueue not possible.");    
   }
   else
   {
    if(cqGetFront() == (CQ_INITIAL_REC_KEY-1))
    {
      cqSetFront(CQ_INITIAL_REC_KEY);
    }
    cqSetRear(cqGetRear()+1);
    uint32_t *p_new_entry_32 = (uint32_t*)&new_entry;
    fds_data_write(CQ_ENTRIES_FILE_ID, cqGetRear(), p_new_entry_32, 3);
    //debugMsg("Enqueued element.");
   }
 }

entry_t* cqDequeue()
{
  entry_t *out = NULL;
  
  uint16_t front = cqGetFront();
  uint16_t rear = cqGetRear();

  if((front == (CQ_INITIAL_REC_KEY-1)) && (rear == (CQ_INITIAL_REC_KEY-1)))
  {
    debugMsg("Queue is empty, dequeue not possible.");
  }
  else
  {
    debugMsg("Queue is not empty. (%d, %d)", front, rear);
    flash_entry_t old_front = *((flash_entry_t *) fds_data_read(CQ_ENTRIES_FILE_ID, cqGetFront()));
    out = (entry_t*)malloc(sizeof(entry_t));
    out->proba = (proba_t) old_front.value;
    out->label = (class_t) old_front.label;
    out->timestamp = (uint16_t) old_front.timestamp;
    cqSetFront(cqGetFront()+1);    
    if (cqGetFront() > cqGetRear())
    {
      cqInitialize();
    }
    //debugMsg("Dequeued element.");
   }
   return out;
}

entry_t* cqDisplay()
{
  entry_t *front = NULL;

  if(cqGetRear() == (CQ_INITIAL_REC_KEY-1))
   {
    debugMsg("Queue is empty.");
   }
   else
   {
    flash_entry_t flash_front = *((flash_entry_t *) fds_data_read(CQ_ENTRIES_FILE_ID, cqGetFront()));
    front = (entry_t*)malloc(sizeof(entry_t));
    front->proba = (proba_t) flash_front.value;
    front->label = (class_t) flash_front.label;
    front->timestamp = (uint16_t) flash_front.timestamp;
  }
  
  return front;
}  