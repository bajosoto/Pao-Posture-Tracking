
#ifndef MPU_WRAPPER_H__
#define MPU_WRAPPER_H__

#include <stdbool.h>
#include <inttypes.h>
#include <stdint.h>
#include "mpu_interface.h"
#include "pao.h"
#include "inv_mpu_dmp_motion_driver.h"
#include "inv_mpu.h"
#include "ml.h"
#include "twi.h"

void update_euler_from_quaternions(int32_t *quat);

void get_dmp_data(void);

void get_dmp_pedo();

void get_raw_sensor_data(void);

bool check_sensor_int_flag(void);

void calibrate_mpu();

void imu_init(bool dmp, uint16_t freq);

#endif // MPU_WRAPPER_H__