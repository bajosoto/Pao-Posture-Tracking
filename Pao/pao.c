
#include "pao.h"

//static uint32_t const writesomething = 1337;
static uint32_t m_deadbeef[2] = {0xDEADBEEF,0xBAADF00D};
#define TRY_FILE_ID     0x1111
#define TRY_REC_KEY     0x2222
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

    /* Configure buzzer */
    init_vibrator();

    //NRF_LOG_INIT(NULL);  // TODO_SERGIO: Using LOG to find RAM start and end address
    
    // Old mpu init:
    //mpu_setup();

    //nrf_delay_ms(2000);

    // New mpu init:
    // twi_init();
    // imu_init(true, 100);

    // Bluetooth
    app_timer_init_sergio();
    ble_stack_init();
    gap_params_init();
    services_init();
    advertising_init();
    conn_params_init();
    ret_code_t ret = fds_register(fds_evt_handler);
    if (ret == FDS_SUCCESS)
    {
        debugMsg("Registering fds_evt_handler successful \n\r");
    }
    if (ret != FDS_SUCCESS)
    {
        debugMsg("Registering fds_evt_handler failed \n\r");
    }
    fds_init();
    nrf_delay_ms(2000);
    fds_data_write(TRY_FILE_ID,TRY_REC_KEY,m_deadbeef,2);
    nrf_delay_ms(2000);
    uint32_t *readthing = (uint32_t *) fds_data_read(TRY_FILE_ID, TRY_REC_KEY);

    for (uint16_t i=0;i<2;i++)
        {
           debugMsg("In main, word number %d is %08x", i,readthing[i]);
        }

    entry_t writeentry;

    writeentry.proba = (proba_t)1.5;
    writeentry.label = 1;
    writeentry.timestamp = 1000;

    entry_t writeentry2;

    writeentry2.proba = (proba_t)2.5;
    writeentry2.label = 2;
    writeentry2.timestamp = 2000;

    entry_t writeentry3;

    writeentry3.proba = (proba_t)3.5;
    writeentry3.label = 3;
    writeentry3.timestamp = 3000;
    
    cqInitialize();
    nrf_delay_ms(3000);

    cqEnqueue(&writeentry);
    nrf_delay_ms(3000);

    cqEnqueue(&writeentry2);
    nrf_delay_ms(3000);

    entry_t *readentry = (entry_t*)malloc(sizeof(entry_t));
    readentry = cqDequeue();
    nrf_delay_ms(3000);

    debugMsg("Reading the entry, proba:%.2f",readentry->proba);
    debugMsg("Reading the entry, label:%d",readentry->label);
    debugMsg("Reading the entry, timestamp:%d",readentry->timestamp);

    entry_t *readentry2 = (entry_t*)malloc(sizeof(entry_t));
    readentry2 = cqDequeue();
    nrf_delay_ms(3000);

    debugMsg("Reading the entry, proba:%.2f",readentry2->proba);
    debugMsg("Reading the entry, label:%d",readentry2->label);
    debugMsg("Reading the entry, timestamp:%d",readentry2->timestamp);

    entry_t *readentry3 = (entry_t*)malloc(sizeof(entry_t));
    readentry3 = cqDequeue();
    nrf_delay_ms(3000);
    debugMsg("Reading the entry, label:%.2f",readentry3->label);

    cqEnqueue(&writeentry);
    nrf_delay_ms(3000);

    cqEnqueue(&writeentry2);
    nrf_delay_ms(3000);

    cqEnqueue(&writeentry3);
    nrf_delay_ms(3000);

    entry_t *readentry4 = (entry_t*)malloc(sizeof(entry_t));
    readentry4 = cqDequeue();
    nrf_delay_ms(3000);

    debugMsg("Reading the entry, proba:%.2f",readentry4->proba);
    debugMsg("Reading the entry, label:%d",readentry4->label);
    debugMsg("Reading the entry, timestamp:%d",readentry4->timestamp);

    entry_t *readentry5 = (entry_t*)malloc(sizeof(entry_t));
    readentry5 = cqDequeue();
    nrf_delay_ms(3000);

    debugMsg("Reading the entry, proba:%.2f",readentry5->proba);
    debugMsg("Reading the entry, label:%d",readentry5->label);
    debugMsg("Reading the entry, timestamp:%d",readentry5->timestamp);

    entry_t *readentry6 = (entry_t*)malloc(sizeof(entry_t));
    readentry6 = cqDequeue();
    nrf_delay_ms(3000);

    debugMsg("Reading the entry, proba:%.2f",readentry6->proba);
    debugMsg("Reading the entry, label:%d",readentry6->label);
    debugMsg("Reading the entry, timestamp:%d",readentry6->timestamp);

    entry_t *readentry7 = (entry_t*)malloc(sizeof(entry_t));
    readentry7 = cqDequeue();
    debugMsg("Reading the entry, label:%.2f",readentry7->label);


    err_code = ble_advertising_start(BLE_ADV_MODE_FAST);
    APP_ERROR_CHECK(err_code);

    /* Toggle LEDs. */
    while (programRunning) {

        uint8_t cr;
        
        if (app_uart_get(&cr) == NRF_SUCCESS){
            setrxByte(cr);
        }
        // TODO: add ble

        if (check_sensor_int_flag()) {
            //getMpuSensors();
        }

        if(timer % 50 == 0) {
            if(bsp_board_button_state_get(3)) {
                // sendMsgBle(16, "Button 3 Pressed");
                debugMsgBle("Button pressed");
                start_snooze();
            }
            // for(int i = 0; i < BUTTONS_NUMBER; i++) {
            //     if(bsp_board_button_state_get(i)) {
            //         printf("Pressed Button %d\r\n", i);
            //         bsp_board_led_invert(i);
            //     }
            // }
        }
        if(timer % 10 == 0) {  // Every 100ms  errr 50
            // getMpuSensors();
            sendMessageEs(MSG02_SENSOR_VALS);
            sendBleMessageEs(MSG_BLE_02_SENSOR);            
        }
        // if(timer % 50 == 0) {
        //     sendBleMessageEs(MSG_BLE_02_SENSOR);
        // }

        if(timer % 100 == 0) {
            // getPedo();                                   // For now I disabled pedo
            // sendBleMessageEs(MSG_BLE_04_PEDO);
            bsp_board_led_invert(0);
            //buzz(10);        // Testing only
            timer = 0;
        }

        increment_buzz_time(5);

        nrf_delay_ms(5);
        timer++;
    }
}

/**
 *@}
 **/