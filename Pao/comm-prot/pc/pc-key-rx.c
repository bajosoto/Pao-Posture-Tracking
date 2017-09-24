
/* pc-key-rx.c
 * Dictionary of commands to be received from the keyboard
 * Author: Sergio Soto
 */


#include "pc_terminal.h"
#include "uart-sm.h"
#include <inttypes.h>
#include <ncurses.h>

/* keyInput(int c)
 * Author: 		Sergio Soto
 * Function: 	Executes commands from keyboard input
 * IN:			int c - The int read from the keyboard
*/
void keyInput(int c) {
	switch(c) {
		case 'a':										// 'a': Lift up
			sendMessagePc(MSG04_INC_LIFT);
			break;
		case '.':										// '.'	:	Request status from board			
			dispMsg("Ping...");
			sendMessagePc(MSG00_STATUS);
			break;
		case KEY_END:
		case KEY_EXIT:
		case KEY_CLOSE:
		case 27:										// 'ESC':	Program termination
			dispMsg("Program terminating.");
			sendMessagePc(MSG01_QUIT);
			break;

		default:	
			break;	
	}
}