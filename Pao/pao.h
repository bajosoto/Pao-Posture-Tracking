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
#include "fds_interface.h"
#include "nrf_log.h"
#include "nrf_log_ctrl.h"
#include "flash-interface.h"
#include "debug-interface.h"
#include "es-ble-tx.h"
#include <math.h>
#include "twi.h"
#include "mpu_wrapper.h"
#include "app_timer.h"
#include "vibrator.h"
#include "sm.h"
#include "timestamp.h"
#include "knn.h"

#include "classifier_interface.h"

// #include "app_mpu.h"

#define SAMPLING_FREQ		10  // Hz
#define KNN_NEIGHBORS		8
#define TRAINING_TIME		10	// Seconds

int programRunning;

#endif /* PAO_H__ */