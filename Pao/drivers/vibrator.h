#ifndef VIBRATOR_H__
#define VIBRATOR_H__

#include "nrf_delay.h"
#include "nrf_gpio.h"

void init_vibrator();
void increment_buzz_time();
void buzz(char msx10);

#endif /* VIBRATOR_H__ */