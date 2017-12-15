#include "fds_interface.h"
//static uint32_t const m_deadbeef = 0xDEADBEEF;

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
            else
            {
                debugMsg("In fds_evt_handler and there was an issue with write:%05d \n\r",p_fds_evt->result);
            }
            break;
        case FDS_EVT_UPDATE:
            if (p_fds_evt->result == FDS_SUCCESS)
            {
                debugMsg("In fds_evt_handler and update successful \n\r");
            }
            else
            {
                debugMsg("In fds_evt_handler and there was an issue with update:%05d \n\r",p_fds_evt->result);
            }
            break;
       default:
            break;
    }
}


void fds_data_write(uint16_t file_id, uint16_t rec_key, uint32_t input, uint16_t input_length_words)
{
    fds_record_t        record;
    fds_record_desc_t   record_desc;
    fds_record_chunk_t  record_chunk;
    // Set up data.
    record_chunk.p_data         = &input;
    record_chunk.length_words   = input_length_words;
    // Set up record.
    record.file_id                  = file_id;
    record.key                      = rec_key;
    record.data.p_chunks       = &record_chunk;
    record.data.num_chunks   = 1;
    fds_find_token_t    ftok = {0}; 
    
    if (fds_record_find(file_id, rec_key, &record_desc, &ftok) == FDS_SUCCESS)
    {
        fds_record_update(&record_desc, &record);
    }
    else
    {
        fds_record_write(&record_desc, &record);
    }
    nrf_delay_ms(5);

}

void fds_data_read(uint16_t file_id, uint16_t rec_key, uint32_t *p_read_data)
{
    fds_flash_record_t  flash_record;
    fds_record_desc_t   record_desc;
    fds_find_token_t    ftok = {0}; 
    //uint32_t read_data = m_deadbeef;

    // Loop until all records with the given key and file ID have been found.
    while (fds_record_find(file_id, rec_key, &record_desc, &ftok) == FDS_SUCCESS)
    {
        if (fds_record_open(&record_desc, &flash_record) != FDS_SUCCESS)
        {
            debugMsg("In fds_data_read and there was an issue with open.");
        }
        // Access the record through the flash_record structure.
        p_read_data = (uint32_t *) flash_record.p_data;
        for (uint16_t i=0;i<flash_record.p_header->tl.length_words;i++)
        {
           debugMsg("Read finished, word number %d is %d", i,p_read_data[i]);
        }
        // Close the record when done.
        if (fds_record_close(&record_desc) != FDS_SUCCESS)
        {
            debugMsg("In fds_data_read and there was an issue with close.");
        }
    }
    else
    {
        debugMsg("In fds_data_read and there was an issue with find.");
    }


}