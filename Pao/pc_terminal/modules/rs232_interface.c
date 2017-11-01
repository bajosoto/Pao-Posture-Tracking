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
#include "interface.h"

int fd_RS232;

void rs232_open(void) {

  	char 		*name;
  	int 		result;
  	struct termios	tty;

	dispMsg("Opening serial interface...");

#ifdef __linux__
	fd_RS232 = open("/dev/ttyACM0", O_RDWR | O_NOCTTY);  
#elif __APPLE__
	fd_RS232 = open("/dev/cu.usbmodem1411", O_RDWR | O_NONBLOCK);  
	if(fd_RS232 < 0) {
		fd_RS232 = open("/dev/cu.usbmodem14211", O_RDWR | O_NONBLOCK);  // Mac sometimes mounts it here
	}
	if(fd_RS232 < 0){
		fd_RS232 = open("/dev/cu.usbmodem1421", O_RDWR | O_NONBLOCK);  // Mac sometimes mounts it here
	}
#else
#   error "Unknown compiler"
#endif 	

	if(fd_RS232 >= 0) {

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

		dispMsg("Serial interface connected.");
	} else {
		dispMsg("Serial interface connection failed");
	}
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

int rs232_is_up() {

	return (fd_RS232 >= 0);
}
