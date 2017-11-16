#ifndef VIBRATOR_H__
#define VIBRATOR_H__

#include "nrf_delay.h"
#include "nrf_gpio.h"
#include "debug-interface.h"

void init_vibrator();
void increment_buzz_time();
void buzz(char msx10);
void start_snooze();

#endif /* VIBRATOR_H__ */