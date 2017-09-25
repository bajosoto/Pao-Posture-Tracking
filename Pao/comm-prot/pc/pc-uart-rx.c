
/* pc-uart-rx.c
 * Functions executed when receiving messages from the board
 * Author: Sergio Soto
 */

#include "pc-uart-rx.h"
#include "pc_terminal.h"
#include <stdio.h> //TODO: Delete. Messages should be logged not displayed
#include "uart-sm.h"
#include <inttypes.h>

void msg00_status_ans();

int16_t unfoldSI16(int index);

// Message table
MsgType msgTable[TOTAL_ES_MESSAGES] = {
	/* Action Name */		/* Length */
	{{msg00_status_ans}, 	0},				// 00: Performs some action
};

void msg00_status_ans() {
	dispMsg("Pong!");
}

int16_t unfoldSI16(int index) {

	int16_t result = 0;
	int16_t offset = 3 * index;

	result |= (rxBuff[1 + offset] & 0xff);
	result |= (rxBuff[2 + offset] & 0xff) << 8;
	result = rxBuff[0 + 3 * index] > 0 ? -result : result;

	return result;
}
