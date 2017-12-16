#ifndef FDS_INTERFACE_H_
#define FDS_INTERFACE_H_

#include "fds.h"
#include "fstorage.h"
#include "debug-interface.h"

void fds_evt_handler(fds_evt_t const * const p_fds_evt);
void fds_data_write(uint16_t file_id, uint16_t rec_key, uint32_t *p_write_data, uint16_t input_length_words);
void fds_data_read(uint16_t file_id, uint16_t rec_key, uint32_t *p_read_data);
#endif /* FDS_INTERFACE_H_ */