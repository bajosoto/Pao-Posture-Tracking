
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
void msg01_quit_ans();
void msg02_sensor_vals();
void msg03_ble_status();
void msg04_pickle_rick();
void msg05_dbg_msg();

int16_t unfoldSI16(int index);

// Message table
MsgType msgTable[TOTAL_ES_MESSAGES] = {
	/* Action Name */		/* Length */
	{{msg00_status_ans}, 	0},				// 00: Performs some action
	{{msg01_quit_ans}, 		0}, 			// 01: Answer shutdown request
	{{msg02_sensor_vals}, 	12}, 			// 02: Sensor values to display
	{{msg03_ble_status}, 	1}, 			// 03: BLE connection status change 
	{{msg04_pickle_rick}, 	0}, 			// 04: Pickle rick
	{{msg05_dbg_msg}, 		100}, 			// 02: Sensor values to display
};

void msg00_status_ans() {
	dispMsg("Pong!");
}

void msg01_quit_ans() {
	dispMsg("Board has shut down. Terminating program...");
	demo_running = 0;
}

void msg02_sensor_vals() {
	int16_t s0 = unfoldSI16(0);
	int16_t s1 = unfoldSI16(1);
	int16_t s2 = unfoldSI16(2);
	int16_t s3 = unfoldSI16(3);
	int16_t s4 = unfoldSI16(4);
	int16_t s5 = unfoldSI16(5);
	dispVal(DISP_AX, s0);
	dispVal(DISP_AY, s1);
	dispVal(DISP_AZ, s2);
	dispVal(DISP_P, s3);
	dispVal(DISP_Q, s4);
	dispVal(DISP_R, s5);
}

void msg03_ble_status() {

	switch(rxBuff[0]) {
		case 0: 
			dispMsg("BLE device disconnected");
			break;
		case 1:
			dispMsg("BLE device connected");
			break;
		default:
			dispMsg("Unknown BLE status");
			break;
	}
}

void msg04_pickle_rick() {
	dispMsg("Pickle Rick!");
}

void msg05_dbg_msg() {
	dispMsg("%s", rxBuff);
}

int16_t unfoldSI16(int index) {

	int16_t result = 0;
	int16_t offset = 2 * index;

	result |= (rxBuff[0 + offset] & 0xff);
	result |= (rxBuff[1 + offset] & 0xff) << 8;
	// result = rxBuff[0 + 3 * index] > 0 ? -result : result;

	return result;
}
