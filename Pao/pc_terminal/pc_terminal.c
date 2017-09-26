
#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <inttypes.h>
#include "uart-sm.h"
#include "pc-key-rx.h"	
#include <ncurses.h>
#include "rs232_interface.h"

/*----------------------------------------------------------------
 * main -- execute terminal
 *----------------------------------------------------------------
 */

char demo_running = 1;
volatile char sendJsInput = 0;

void  periodicMessage(int sig) {

	signal(SIGALRM, SIG_IGN);
	sendJsInput = 1;
	signal(SIGALRM, periodicMessage);
	ualarm(200000, 0);
}

int main(int argc, char **argv)
{
	char c;
	int i;

	initInterface();
	
	while(waitForUser);

	dispMsg("Welcome to Pao Terminal!");

	rs232_open();

	if(rs232_is_up()) {
		// Initialize timer
		signal(SIGALRM, periodicMessage);
		ualarm(200000, 0);
	
		/* send & receive */
		while(demo_running) {
			if ((i = readCommand()) != -1) {
				keyInput(i);
			}
	
			if ((c = rs232_getchar_nb()) != -1) {
				setrxByte(c);
			}
		}

		dispMsg("Closing serial interface...");
		rs232_close();
	}

	dispMsg("Press any key to exit");
	timeout(-1);
	getch();
	closeInterface();

	return 0;
}



