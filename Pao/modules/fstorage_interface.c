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
//Replace device manager evt handler with peer manager (empty for now). - by odt
static void pm_evt_handler(pm_evt_t const * p_evt)
{
    switch(p_evt->evt_id)
    {
        case PM_EVT_BONDED_PEER_CONNECTED:
        case PM_EVT_CONN_SEC_START:
        case PM_EVT_CONN_SEC_SUCCEEDED:
        case PM_EVT_CONN_SEC_FAILED:
        case PM_EVT_CONN_SEC_CONFIG_REQ:
        case PM_EVT_STORAGE_FULL:
        case PM_EVT_ERROR_UNEXPECTED:
        case PM_EVT_PEER_DATA_UPDATE_SUCCEEDED:
        case PM_EVT_PEER_DATA_UPDATE_FAILED:
        case PM_EVT_PEER_DELETE_SUCCEEDED:
        case PM_EVT_PEER_DELETE_FAILED:
        case PM_EVT_PEERS_DELETE_SUCCEEDED:
        case PM_EVT_PEERS_DELETE_FAILED:
        case PM_EVT_LOCAL_DB_CACHE_APPLIED:
        case PM_EVT_LOCAL_DB_CACHE_APPLY_FAILED:
        case PM_EVT_SERVICE_CHANGED_IND_SENT:
        case PM_EVT_SERVICE_CHANGED_IND_CONFIRMED:
        default:
            break;
    }
}

//Replace device manager initialization with peer manager. - by odt
void peer_manager_init(bool erase_bonds)
{
    ble_gap_sec_params_t sec_param;
    ret_code_t err_code;

    err_code = pm_init();
    APP_ERROR_CHECK(err_code);

    if (erase_bonds)
    {
        err_code = pm_peers_delete();
        APP_ERROR_CHECK(err_code);
    }

    memset(&sec_param, 0, sizeof(ble_gap_sec_params_t));

    // Security parameters to be used for all security procedures.
    sec_param.bond              = SEC_PARAM_BOND;
    sec_param.mitm              = SEC_PARAM_MITM;
    //sec_param.lesc              = SEC_PARAM_LESC;
    //sec_param.keypress          = SEC_PARAM_KEYPRESS;
    sec_param.io_caps           = SEC_PARAM_IO_CAPABILITIES;
    sec_param.oob               = SEC_PARAM_OOB;
    sec_param.min_key_size      = SEC_PARAM_MIN_KEY_SIZE;
    sec_param.max_key_size      = SEC_PARAM_MAX_KEY_SIZE;
    sec_param.kdist_own.enc     = 1;
    sec_param.kdist_own.id      = 1;
    sec_param.kdist_peer.enc    = 1;
    sec_param.kdist_peer.id     = 1;

    err_code = pm_sec_params_set(&sec_param);
    APP_ERROR_CHECK(err_code);

    err_code = pm_register(pm_evt_handler);
    APP_ERROR_CHECK(err_code);
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




