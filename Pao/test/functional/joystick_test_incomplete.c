#include <stdio.h>
#include <unistd.h>

#include "joystick.h"
#include "extcontrol.h"
#include "js.h"

int main(void)
{
	int fd;
	struct ExtControl extControl;

	printf("Testing the external control module\n");

	fd = extcontrol_init(EXCI_JOYSTICK);
	if (fd < 0) {
		return -1;
	}

	while (1) {
		int i;

		extcontrol_read(&extControl);

		printf("\n");
//#define RAW
#ifdef RAW
		for (i = 0; i < 6; i++) {
			printf("%6d ", extControl.axis[i]);
		}
#else
			printf("%6d ", extControl.lift);
			printf("%6d ", extControl.roll);
			printf("%6d ", extControl.pitch);
			printf("%6d ", extControl.jaw);
#endif
		printf(" |  ");
		for (i = 0; i < 12; i++) {
			printf("%d ", extControl.button[i]);
		}
		if (extControl.button[0])
			break;
		usleep(100000);
	}
	printf("Exit\n");

}
