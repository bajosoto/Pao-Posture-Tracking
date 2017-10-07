
#include "es-ble-rx.h"

/* keyInput(int c)
 * Author: 		Sergio Soto
 * Function: 	Executes commands from keyboard input
 * IN:			int c - The int read from the keyboard
*/
void bleInput(uint8_t c) {
	switch(c) {
		case '1':										// '.'	:	Ping			
			bsp_board_led_invert(1);
			sendMsgBle("Pong!");
			break;
		case '2':										// '.'	:	Request status from board			
			sendMessageEs(MSG04_PICKLE_RICK);
			break;
		default:	
			break;	
	}
}