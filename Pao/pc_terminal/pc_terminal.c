/*------------------------------------------------------------
 * Simple pc terminal in C
 *
 * Arjan J.C. van Gemund (+ mods by Ioannis Protonotarios)
 *
 * read more: http://mirror.datenwolf.net/serial/
 *------------------------------------------------------------
 */

#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <inttypes.h>
#include "../comm-prot/sm/uart-sm.h"			// TODO: Make this tidier in the makefile. It's 4am and I'm getting lazy
#include "../comm-prot/pc/pc-key-rx.h"			// TODO: Make this tidier in the makefile. It's 4am and I'm getting lazy
#include "../comm-prot/pc/pc-js-rx.h"
#include <ncurses.h>

/*------------------------------------------------------------
 * Serial I/O
 * 8 bits, 1 stopbit, no parity,
 * 115,200 baud
 *------------------------------------------------------------
 */
#include <termios.h>
#include <ctype.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <assert.h>
#include <time.h>


int serial_device = 0;
int fd_RS232;

void rs232_open(void) {

  	char 		*name;
  	int 		result;
  	struct termios	tty;
#ifdef __linux__
	fd_RS232 = open("/dev/ttyUSB0", O_RDWR | O_NOCTTY);  // Hardcode your serial port here, or request it as an argument at runtime /dev/bus/usb/002/003 /dev/ttyUSB0
#elif __APPLE__
	fd_RS232 = open("/dev/cu.usbserial-DN00P2TJ", O_RDWR | O_NONBLOCK);  // Hardcode your serial port here, or request it as an argument at runtime
#else
#   error "Unknown compiler"
#endif 	

	assert(fd_RS232>=0);

  	result = isatty(fd_RS232);
  	assert(result == 1);

  	name = ttyname(fd_RS232);
  	assert(name != 0);

  	result = tcgetattr(fd_RS232, &tty);
	assert(result == 0);

	tty.c_iflag = IGNBRK; /* ignore break condition */
	tty.c_oflag = 0;
	tty.c_lflag = 0;

	tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8; /* 8 bits-per-character */
	tty.c_cflag |= CLOCAL | CREAD; /* Ignore model status + read input */

	cfsetospeed(&tty, B115200);
	cfsetispeed(&tty, B115200);

	tty.c_cc[VMIN]  = 0;
	tty.c_cc[VTIME] = 1; // added timeout

	tty.c_iflag &= ~(IXON|IXOFF|IXANY);

	result = tcsetattr (fd_RS232, TCSANOW, &tty); /* non-canonical */

	tcflush(fd_RS232, TCIOFLUSH); /* flush I/O buffer */
}

void rs232_close(void) {

  	int result;

  	result = close(fd_RS232);
  	assert (result==0);
}

int	rs232_getchar_nb() {

	int result;
	unsigned char c;

	result = read(fd_RS232, &c, 1);

	if (result == 0) {

		return -1;
	} else {

		assert(result == 1);
		return (int) c;
	}
}

int rs232_getchar() {

	int c;

	while ((c = rs232_getchar_nb()) == -1);
	return c;
}

int rs232_putchar(char c) {

	int result;

	do {
		result = (int) write(fd_RS232, &c, 1);
	} while (result == 0);

	assert(result == 1);
	return result;
}

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
	int jsDetected= 0;
	
	initInterface();
	dispMsg("Welcome to Tequila Drone!");

	dispMsg("Opening serial interface...");
	rs232_open();
	dispMsg("Serial interface connected.");

	/* Initialize Joystick */	
	dispMsg("Detecting Joystick..."); 
	jsDetected = initJS();
	if(jsDetected) {
		dispMsg("Joystick detected");
	} else {
		dispMsg("Joystick not detected");
	}

	if(has_key(KEY_UP)) {
		dispMsg("This console doesn't support arrow keys");
	} else {
		dispMsg("This console supports arrow keys");
	}
	
	while(waitForUser);

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

		if(sendJsInput) {
			sendJsInput = 0;
			if(jsDetected){
				jsInput();	//Read joystick values and update roll, pitch, yaw, throttle and fire
				sendMessagePc(MSG03_JOYSTICK);
			}
		}
	}

	dispMsg("Closing serial interface...");
	rs232_close();
	dispMsg("Press any key to exit");
	timeout(-1);
	getch();
	closeInterface();

	return 0;
}



