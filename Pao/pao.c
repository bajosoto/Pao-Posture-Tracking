
#include "pao.h"
#include "flash-interface.h"
#include "sm.h"

#define TIMER_PERIOD_MS         5
#define TIMER5_TIMER_PERIOD     APP_TIMER_TICKS(TIMER_PERIOD_MS, 0)  // timer period is in ms

int programRunning = 1;
uint16_t timer = 0;
volatile uint8_t sync_timer = 1;

void timer_5ms_handler() {
    sync_timer = 0;
}

/**
 * @brief Function for application main entry.
 */
int main(void)
{
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

    // nrf_delay_ms(2000);

    // New mpu init:
    twi_init();
    imu_init(true, 100);

    // Bluetooth
    app_timer_init_sergio();
    ble_stack_init();
    gap_params_init();
    services_init();
    advertising_init();
    conn_params_init();

    err_code = ble_advertising_start(BLE_ADV_MODE_FAST);
    APP_ERROR_CHECK(err_code);

    /* Enable Timer */
    APP_TIMER_DEF(timer_5ms);
    app_timer_create(&timer_5ms, APP_TIMER_MODE_REPEATED, timer_5ms_handler);
    app_timer_start(timer_5ms, TIMER5_TIMER_PERIOD, NULL);

    // /* Init Classifier stuff */
    knn_init(KNN_NEIGHBORS);
    transformer_t scalers[1] = {TRANSF_SCALE_STD};
    clf_init(CLF_KNN, 1, scalers);

    /* Main loop */
    while (programRunning) {

        while (sync_timer);
        sync_timer = 1;

        uint8_t cr;
        if (app_uart_get(&cr) == NRF_SUCCESS){
            setrxByte(cr);
        }

        if (check_sensor_int_flag()) {
            getMpuSensors();
        }

        // @ 100ms = 10Hz
        if(timer % (1000 / (5 * SAMPLING_FREQ)) == 0) {  
            sendMessageEs(MSG02_SENSOR_VALS);
            // sendBleMessageEs(MSG_BLE_02_SENSOR);
            
            class_t label;
            entry_t* newEntry = (entry_t*)malloc(sizeof(entry_t));

            switch(smCurrState) {

                case S2_DISCONNECTED:
                    label = process_new_sample(CLASS_NO_CLASS, newEntry);
                    if(label != CLASS_NO_CLASS) {
                        // Store in Flash
                        store_entry(newEntry);
                        // Vibrate if bad posture is detected
                        notify_posture(label);
                    }
                    break;

                case S3_CONNECTED:
                    label = process_new_sample(CLASS_NO_CLASS, newEntry);
                    if(label != CLASS_NO_CLASS) {
                        // Set timestamp to zero, since in connected mode results are real-time
                        newEntry->timestamp = 0;
                        // Send to App
                        sendBleEntry(newEntry);
                        // Vibrate if bad posture is detected
                        notify_posture(label);

                        //debugMsgBle("Lb: %d\tT: %d\tPr: %d", newEntry->label, newEntry->timestamp, (int32_t)(newEntry->proba * 100));
                    }
                    break;

                case S4_TRAINING:
                    process_new_sample(train_label, NULL);
                    break;

                case S5_DUMPING:
                    if(data_dump()) {
                        debugMsg("sent entry");
                    } else {
                        switchState(S3_CONNECTED);
                    }
                    break;
                default:
                    // Do nothing
                    break;
            }

            free(newEntry);

            // if(smCurrState == S4_TRAINING) {
            //     // Add sample to training data TODO
            //     process_new_sample(train_label);        // TODO Get this from BLE!
            // } else if(smCurrState == S2_DISCONNECTED || smCurrState == S3_CONNECTED) {
            //     class_t label = process_new_sample(CLASS_NO_CLASS);
            //     // If there was a classification
            //     if(label != CLASS_NO_CLASS) {
            //         // Store in flash (TODO)
            //         // 
            //         if(smCurrState == S3_CONNECTED) {
            //             // Send to phone (TODO)
            //             // sendBleMessageEs(SOME_NEW_MESSAGE);
            //         }
            //     }
            // }
        }

        // @ 250ms
        if(timer % 50 == 0) {
            if(bsp_board_button_state_get(3)) {
                debugMsgBle("Button 3 pressed");
                start_snooze();
            }
        }

        // @ 500ms
        if(timer % 100 == 0) {
            // For now I disabled pedo
            // getPedo();                       
            // sendBleMessageEs(MSG_BLE_04_PEDO);
            bsp_board_led_invert(0);
        }

        if(timer % 200 == 0) {
            advance_second();
            timer = 0;
        }

        increment_buzz_time(TIMER_PERIOD_MS);

        timer++;
    }
}

/**
 *@}
 **/
