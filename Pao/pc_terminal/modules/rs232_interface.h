#ifndef RS232_INTERFACE_H_
#define RS232_INTERFACE_H_

void rs232_open(void);
void rs232_close(void);
int	rs232_getchar_nb();
int rs232_getchar();
int rs232_putchar(char c);
int rs232_is_up();

#endif /* RS232_INTERFACE_H_ */

