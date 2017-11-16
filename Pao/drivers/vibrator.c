
#include "vibrator.h"

#define BUZZ_PORT   19

int buzz_timer = 0;
int buzz_timeout = 0;
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

void increment_buzz_time() {
    
    if(buzzing) {
        buzz_timer += 5;        // 5ms from main loop
        if(buzz_timer >= buzz_timeout) {
            buzzing = 0;
            nrf_gpio_pin_clear(BUZZ_PORT);
        }
    } else {
        nrf_gpio_pin_clear(BUZZ_PORT);
    }
}

void buzz(char msx10) {

    buzz_timer = 0;
    buzz_timeout = msx10 * 10;
    buzzing = 1;
	nrf_gpio_pin_set(BUZZ_PORT);
	
}