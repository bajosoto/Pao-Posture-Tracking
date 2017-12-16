#ifndef FLASH_INTERFACE_H
#define FLASH_INTERFACE_H

#include "classifier.h"
#include <inttypes.h>

typedef struct entry {
	proba_t proba;
	class_t label;
	uint16_t timestamp;
} entry_t;

#endif /* FLASH_INTERFACE_H */

