#ifndef PAO_H__
#define PAO_H__

#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include "nrf_delay.h"
#include "nrf_gpio.h"
#include "boards.h"
#include "uart.h"
#include "uart-sm.h"
#include "mpu_interface.h"
#include "ble_interface.h"
#include "nrf_log.h"
#include "nrf_log_ctrl.h"
#include "debug-interface.h"
#include "es-ble-tx.h"
#include <math.h>
#include "twi.h"
#include "mpu_wrapper.h"
#include "app_timer.h"
#include "vibrator.h"
// #include "app_mpu.h"

int programRunning;

#endif /* PAO_H__ */