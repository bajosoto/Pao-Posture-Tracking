
#include "pao.h"

int programRunning = 1;

/**
 * @brief Function for application main entry.
 */
int main(void)
{
    uint16_t timer = 0;
    uint32_t err_code;

    /* Configure board. */
    bsp_board_leds_init();
    bsp_board_buttons_init();
    uart_service_init();
    //NRF_LOG_INIT(NULL);  // TODO_SERGIO: Using LOG to find RAM start and end address
    mpu_setup();

    // Bluetooth
    app_timer_init_sergio();
    ble_stack_init();
    gap_params_init();
    services_init();
    advertising_init();
    conn_params_init();

    err_code = ble_advertising_start(BLE_ADV_MODE_FAST);
    APP_ERROR_CHECK(err_code);

    /* Toggle LEDs. */
    while (programRunning) {

        uint8_t cr;
        
        if (app_uart_get(&cr) == NRF_SUCCESS){
            setrxByte(cr);
        }

        if(timer % 50 == 0) {
            if(bsp_board_button_state_get(3)) {
                sendMsgBle(16, "Button 3 Pressed");
            }
            // for(int i = 0; i < BUTTONS_NUMBER; i++) {
            //     if(bsp_board_button_state_get(i)) {
            //         printf("Pressed Button %d\r\n", i);
            //         bsp_board_led_invert(i);
            //     }
            // }
        }
        if(timer % 20 == 0) {
            getMpuSensors();
            sendMessageEs(MSG02_SENSOR_VALS);
            sendBleMessageEs(MSG_BLE_02_SENSOR);
        }
        // if(timer % 50 == 0) {
        //     sendBleMessageEs(MSG_BLE_02_SENSOR);
        // }
        if(timer % 100 == 0) {
            bsp_board_led_invert(0);
            timer = 0;
        }

        nrf_delay_ms(5);
        timer++;
    }
}

/**
 *@}
 **/
