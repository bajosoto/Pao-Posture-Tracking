#ifndef MPU_INTERFACE_H_
#define MPU_INTERFACE_H_

#include "app_mpu.h"

typedef enum sensValType_t {
	ACC_X, 
	ACC_Y,
	ACC_Z,
	GYR_X,
	GYR_Y,
	GYR_Z,
} sensValType;

accel_values_t acc_values;
gyro_values_t gyro_values;

void getMpuSensors();
int16_t getMpuVal(sensValType type);

#endif /* MPU_INTERFACE_H_ */

