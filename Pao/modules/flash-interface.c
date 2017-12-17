
#include "flash-interface.h"
#include <stdio.h>
#include "timestamp.h"
#include "es-ble-tx.h"

#define MAX_ENTRIES		300

entry_t entry_history[MAX_ENTRIES];
int16_t index = -1;


void store_entry(entry_t* newEntry) {

	// Get next address
	index = (index + 1) % MAX_ENTRIES;

	// Copy entry data
	entry_history[index].proba = newEntry->proba;
	entry_history[index].label = newEntry->label;
	entry_history[index].timestamp = newEntry->timestamp;

	// debugMsg("Stored entry at index %d", index);
}

entry_t* get_entry_history() {

	// If history is not empty
	if(index > 0) {
		// debugMsg("Retrieved entry at index %d", index);
		entry_t* entry = &entry_history[index];
		index -= 1;
		return entry;
	} else {
		return NULL;
	}
}


void data_dump() {
	// debugMsg("Data dump requested");
	entry_t* entry;
	while((entry = get_entry_history()) != NULL) {
		entry->timestamp = get_timestamp() - entry->timestamp;
		sendBleEntry(entry);
		// debugMsg("Sent an entry");
	}
}