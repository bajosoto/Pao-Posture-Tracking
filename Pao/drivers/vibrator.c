
#include "vibrator.h"

#define BUZZ_PORT   19

int buzz_timer = 0;
int buzz_timeout = 0;
int buzz_snooze = 0;      
char buzzing = 0;

void init_vibrator(){
	
	nrf_gpio_cfg(
        BUZZ_PORT,
        NRF_GPIO_PIN_DIR_OUTPUT,
        NRF_GPIO_PIN_INPUT_DISCONNECT,
        NRF_GPIO_PIN_PULLDOWN,
        NRF_GPIO_PIN_S0H1,      // High drive '1', standard '0'
        NRF_GPIO_PIN_NOSENSE);
    
    // nrf_gpio_cfg(       // Using pin 25 as gnd for now
    //     25,
    //     NRF_GPIO_PIN_DIR_OUTPUT,
    //     NRF_GPIO_PIN_INPUT_DISCONNECT,
    //     NRF_GPIO_PIN_NOPULL,
    //     NRF_GPIO_PIN_H0S1,      // High drive '0', standard '1'
    //     NRF_GPIO_PIN_NOSENSE);
    // nrf_gpio_pin_clear(25);
}

void increment_buzz_time(int ms) {
    
    if(buzzing) {
        buzz_timer += ms;        // From main loop
        if(buzz_timer >= buzz_timeout) {
            buzzing = 0;
            nrf_gpio_pin_clear(BUZZ_PORT);
        }
    } else {
        nrf_gpio_pin_clear(BUZZ_PORT);
    }

    // Decrement snooze
    if (buzz_snooze - ms <= 0) {
        buzz_snooze = 0;
    } else {
        buzz_snooze -= ms;
    }
}

void buzz(char msx10) {

    if(buzz_snooze == 0) {              // If not snoozing
        buzz_timer = 0;
        buzz_timeout = msx10 * 10;
        buzzing = 1;
        nrf_gpio_pin_set(BUZZ_PORT);        
    }
}

void start_snooze() {
    buzz(5);
    debugMsg("Snoozing...");
    debugMsgBle("Snoozing...");
    buzz_snooze = 20000;    // 20 seconds
}