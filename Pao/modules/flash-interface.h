#ifndef FLASH_INTERFACE_H
#define FLASH_INTERFACE_H

#include "classifier.h"
#include <inttypes.h>
// #include "debug-interface.h"

typedef struct entry {
	proba_t proba;
	class_t label;
	uint16_t timestamp;
} entry_t;


void store_entry(entry_t* newEntry);
entry_t* get_entry_history();
int16_t data_dump();

#endif /* FLASH_INTERFACE_H */

