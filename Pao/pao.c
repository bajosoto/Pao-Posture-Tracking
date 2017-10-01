
#include "pao.h"

int programRunning = 1;

/**
 * @brief Function for application main entry.
 */
int main(void)
{
    uint16_t timer = 0;

    /* Configure board. */
    bsp_board_leds_init();
    bsp_board_buttons_init();
    uart_service_init();
    mpu_setup();

    ret_code_t ret1 = fds_register(fds_evt_handler);
    if (ret1 == FDS_SUCCESS)
    {
        debugMsg("Reg fds evt handler succeed.\r\n");
    }
    if (ret1 != FDS_SUCCESS)
    {
        debugMsg("Reg fds evt handler fail.\r\n");
    }
    ret_code_t ret = fds_init();
    if (ret != FDS_SUCCESS)
    {
        debugMsg("Fds init fail.\r\n");
    }

    /* Toggle LEDs. */
    while (programRunning) {

        uint8_t cr;
        
        if (app_uart_get(&cr) == NRF_SUCCESS){
            setrxByte(cr);
        }

        for(int i = 0; i < BUTTONS_NUMBER; i++) {
            if(bsp_board_button_state_get(i)) {
                printf("Pressed Button %d\r\n", i);
                bsp_board_led_invert(i);
            }
        }
        nrf_delay_ms(5);

        if(timer % 40 == 0) {
            getMpuSensors();
            sendMessageEs(MSG02_SENSOR_VALS);
        }
        if(timer % 100 == 0) {
            bsp_board_led_invert(0);
            timer = 0;
        }
        timer++;
    }
}

/**
 *@}
 **/
