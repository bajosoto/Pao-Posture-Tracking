
/* es-uart-rx.c
 * Functions executed when receiving messages from the terminal
 * Author: Sergio Soto
 */

#include "es-uart-rx.h"
#include "es-uart-tx.h"
#include "uart-sm.h"
#include <inttypes.h>

void msg00_status();

int16_t unfoldSI16(int index);

// Message table
MsgType msgTable[TOTAL_PC_MESSAGES] = {
	/* Action Name */		/* Length */
	{{msg00_status}, 		0},				// 00:	Requests board status
};			

void msg00_status() {

	sendMessageEs(MSG00_STATUS_ANS);
}

int16_t unfoldSI16(int index) {

	int16_t result = 0;
	int16_t offset = 3 * index;

	result |= (rxBuff[1 + offset] & 0xff);
	result |= (rxBuff[2 + offset] & 0xff) << 8;
	result = rxBuff[0 + 3 * index] > 0 ? -result : result;

	return result;
}