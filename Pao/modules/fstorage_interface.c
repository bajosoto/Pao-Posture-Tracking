#include "fstorage_interface.h"
static int32_t const m_deadbeef = 0xDEADBEEF;


//Simple event handler to handle errors during initialization write and update for fds. - by odt
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
                debugMsg("In fds_evt_handler and there was an issue with initialization:%05d \n\r",p_fds_evt->result);
            }
            break;

      case FDS_EVT_WRITE:
            if (p_fds_evt->result == FDS_SUCCESS)
            {
                            debugMsg("In fds_evt_handler and write successful \n\r");
                            write_flag=1;
            }
            if (p_fds_evt->result != FDS_SUCCESS)
            {
                            debugMsg("In fds_evt_handler and there was an issue with write:%05d \n\r",p_fds_evt->result);
                            write_flag=0;
            }
            break;
      case FDS_EVT_UPDATE:
            if (p_fds_evt->result == FDS_SUCCESS)
            {
              debugMsg("In fds_evt_handler and update successful \n\r");
                            write_flag=1;
                            break;
            }
            if (p_fds_evt->result != FDS_SUCCESS)
            {
                            debugMsg("In fds_evt_handler and there was an issue with update:%05d \n\r",p_fds_evt->result);
                            if (p_fds_evt->result == FDS_ERR_NOT_FOUND)
                            {                               
                                write_flag=1;
                                break;
                            }
                            else
                            {
                                write_flag=0;
                                break;
                            }
            }
       default:
            break;
    }
}


// Initialize fds variables, find tokens and write deadbeef. - by odt
void initFdsAccelVariables() 
{
			
	//fds_find_token_t    ftok_x ={0};//Important, make sure you zero init the ftok token.
	//fds_find_token_t    ftok_y ={0};
	//fds_find_token_t    ftok_z ={0};

	//Perform first write to records. - by odt
	record_accel.file_id	= FILE_ID_ACCEL;
	record_accel.key	= REC_KEY_ACCEL;
	record_chunk_accel.p_data         = &m_deadbeef;
	record_chunk_accel.length_words   = 1;
	record_accel.data.p_chunks	= &record_chunk_accel;
	record_accel.data.num_chunks	= 1;
	fds_record_write(&record_desc_accel, &record_accel);
	//wait until write finishes. - by odt
	while (write_flag==0);	
}




