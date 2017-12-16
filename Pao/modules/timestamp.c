
#include "timestamp.h"

static uint16_t global_time = 0;

void advance_second() {
	global_time += 1;
}

uint16_t get_timestamp() {
	return global_time;
}