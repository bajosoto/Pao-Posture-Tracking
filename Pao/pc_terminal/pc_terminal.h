#ifndef PC_TERMINAL_H_
#define PC_TERMINAL_H_

#include "interface.h"
void term_putchar(char c);
void term_puts(char *s);
int rs232_putchar(char c);

char demo_running;

#endif /* PC_TERMINAL_H_ */