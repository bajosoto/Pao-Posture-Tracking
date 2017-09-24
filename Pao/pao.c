
#include "pao.h"

/**
 * @brief Function for application main entry.
 */
int main(void)
{
    /* Configure board. */
    bsp_board_leds_init();
    bsp_board_buttons_init();
    uart_service_init();

    //printf("Hello!\n");

    /* Toggle LEDs. */
    while (true) {
        // if (rx_queue.count) {
        //     setrxByte(dequeue(&rx_queue));
        // }
        for(int i = 0; i < BUTTONS_NUMBER; i++) {
            if(bsp_board_button_state_get(i)) {
                //printf("uuueeeee\r\n");
                bsp_board_led_invert(i);
            }
        }
        nrf_delay_ms(50);
    }
}

/**
 *@}
 **/
