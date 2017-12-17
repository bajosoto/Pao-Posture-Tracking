#ifndef DEBUG_INTERFACE_H_
#define DEBUG_INTERFACE_H_

#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <inttypes.h>
// #include "pao.h"
#include "ble_interface.h"


#define MAX_DBG_MSG_LENGTH		100 // If you change this, change message length in pc-uart-rx !!!

char dbgMsg[MAX_DBG_MSG_LENGTH];

void debugMsg(const char* format, ... );
void debugMsgBle(const char* format, ... );

#endif /* DEBUG_INTERFACE_H_ */

