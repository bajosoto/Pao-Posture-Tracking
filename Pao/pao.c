
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

    printf("Hello!\n\r");

    /* Toggle LEDs. */
    while (true) {

        uint8_t cr;
        
        if (app_uart_get(&cr) == NRF_SUCCESS){
            app_uart_put(cr);
        }

        for(int i = 0; i < BUTTONS_NUMBER; i++) {
            if(bsp_board_button_state_get(i)) {
                printf("Pressed Button %d\r\n", i);
                bsp_board_led_invert(i);
            }
        }
        nrf_delay_ms(50);
    }
}

/**
 *@}
 **/
