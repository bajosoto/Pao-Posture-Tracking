
#include "debug-interface.h"

char dbgMsg[MAX_DBG_MSG_LENGTH];

void debugMsg(const char* format, ... ) {
	
	char msg[MAX_DBG_MSG_LENGTH];

	va_list args;
    va_start( args, format );
    vsprintf (msg,format, args);
    va_end( args );

	strcpy(dbgMsg, msg);

	sendMessageEs(MSG05_DBG_MSG);
}


void debugMsgBle(const char* format, ... ) {
	
	char msg[MAX_DBG_MSG_LENGTH];

	va_list args;
    va_start( args, format );
    vsprintf (msg,format, args);
    va_end( args );

	sendMsgBle(strlen(msg) + 1, "%c%s", 1, msg);
	debugMsg("Ble Msg -> strlen: %d, message: %s", strlen(msg) + 1, msg);
}