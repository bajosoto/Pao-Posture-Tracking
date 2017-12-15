#include "fds_interface.h"

#define TRY_FILE_ID     0x1111
#define TRY_REC_KEY     0x2222



void fds_evt_handler(fds_evt_t const * const p_fds_evt)
{
    switch (p_fds_evt->id)
    {
        case FDS_EVT_INIT:
            if (p_fds_evt->result == FDS_SUCCESS)
            {
                debugMsg("In fds_evt_handler and initialization successful \n\r");
            }
            if (p_fds_evt->result != FDS_SUCCESS)
            {
                debugMsg("Initialization had a problem \n\r");
            }
            break;

      case FDS_EVT_WRITE:
            if (p_fds_evt->result == FDS_SUCCESS)
            {
                debugMsg("In fds_evt_handler and write successful \n\r");
            }
            if (p_fds_evt->result != FDS_SUCCESS)
            {
							debugMsg("In fds_evt_handler and there was an issue with write:%05d \n\r",p_fds_evt->result);
            }
            break;

       default:
            break;
    }
}


void fds_try_write(uint32_t input)
{
    fds_record_t        record;
    fds_record_desc_t   record_desc;
    fds_record_chunk_t  record_chunk;
    // Set up data.
    record_chunk.p_data         = &input;
    record_chunk.length_words   = 1;
    // Set up record.
    record.file_id                  = TRY_FILE_ID;
    record.key                      = TRY_REC_KEY;
    record.data.p_chunks       = &record_chunk;
    record.data.num_chunks   = 1;
    ret_code_t ret = fds_record_write(&record_desc, &record);
    // if (ret == FDS_SUCCESS)
    // {
    //     debugMsg("In fds_try_write and write successful \n\r");
    // }
    // if (ret != FDS_SUCCESS)
    // {
    //     debugMsg("In fds_try_write and write unsuccessful %05d \n\r",ret);
    //         }

}

void fds_try_read(uint16_t file_id, uint16_t rec_key)
{
    fds_flash_record_t  flash_record;
    fds_record_desc_t   record_desc;
    fds_find_token_t    ftok ={0};
    // Loop until all records with the given key and file ID have been found.
    ret_code_t ret = fds_record_find(file_id, rec_key, &record_desc, &ftok);
    // if (ret == FDS_SUCCESS)
    // {
    //     debugMsg("In fds_try_read and find successful \n\r");
    // }
    // if (ret != FDS_SUCCESS)
    // {
    //     debugMsg("In fds_try_read and find unsuccessful%05d \n\r",ret);
    // } 
    while (ret == FDS_SUCCESS)
    {
        ret_code_t ret2 = fds_record_open(&record_desc, &flash_record);

        // if (ret2 == FDS_SUCCESS)
        // {
        //     debugMsg("In fds_try_read and open successful \n\r");
        // }
        // if (ret2 != FDS_SUCCESS)
        // {
        //     debugMsg("In fds_try_read and open unsuccessful \n\r");
        // }
        // // Access the record through the flash_record structure.
        // // Close the record when done.
        // if (fds_record_close(&record_desc) != FDS_SUCCESS)
        // {
        //     debugMsg("In fds_try_read and close unsuccessful \n\r");
        // }
    }
}