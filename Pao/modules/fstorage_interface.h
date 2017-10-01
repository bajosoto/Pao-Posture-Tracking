#ifndef FS_INTERFACE_H__
#define FS_INTERFACE_H__

//add includes for new flash storage. - by odt
#include "fstorage.h"
#include "section_vars.h"
#include "fds.h"
#include "peer_manager.h"
#include "ble_conn_state.h"
#include "debug-interface.h"
#include "app_mpu.h"

#define SEC_PARAM_BOND                   1                                          /**< Perform bonding. */
#define SEC_PARAM_MITM                   0                                          /**< Man In The Middle protection not required. */
#define SEC_PARAM_IO_CAPABILITIES        BLE_GAP_IO_CAPS_NONE                       /**< No I/O capabilities. */
#define SEC_PARAM_OOB                    0                                          /**< Out Of Band data not available. */
#define SEC_PARAM_MIN_KEY_SIZE           7                                          /**< Minimum encryption key size. */
#define SEC_PARAM_MAX_KEY_SIZE           16                                         /**< Maximum encryption key size. */

// Fds variables. - by odt
fds_record_t        record_accel;
fds_record_desc_t   record_desc_accel;
fds_record_chunk_t  record_chunk_accel;
fds_flash_record_t 	flash_record_accel;
/* File write defines. - by odt */
#define FILE_ID_ACCEL     0x1111
#define REC_KEY_ACCEL     0x1111

uint8_t write_flag; // Wait for a write flag. - by odt

// Initialize fds variables, find tokens and write deadbeef. - by odt
void initFdsAccelVariables();

//Simple event handler to handle errors during initialization write and update for fds. - by odt
void fds_evt_handler(fds_evt_t const * const p_fds_evt);

//Replace device manager initialization with peer manager. - by odt
void peer_manager_init(bool erase_bonds);

#endif