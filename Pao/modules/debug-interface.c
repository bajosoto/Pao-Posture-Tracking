
#include "debug-interface.h"

char dbgMsg[MAX_DBG_MSG_LENGTH];

void debugMsg(const char* format, ... ) {
	
	char msg[MAX_DBG_MSG_LENGTH];

	va_list args;
    va_start( args, format );
    vsprintf (msg,format, args);
    va_end( args );

	strcpy(dbgMsg, msg);

	sendMessageEs(MSG03_DBG_MSG);
}

