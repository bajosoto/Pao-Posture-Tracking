#ifndef MPU_INTERFACE_H_
#define MPU_INTERFACE_H_

// #include "app_mpu.h"

/**@brief Structure to hold acceleromter values. 
 * Sequence of z, y, and x is important to correspond with 
 * the sequence of which z, y, and x data are read from the sensor.
 * All values are unsigned 16 bit integers
*/
typedef struct
{
    int16_t z;
    int16_t y;
    int16_t x;
}accel_values_t;


/**@brief Structure to hold gyroscope values. 
 * Sequence of z, y, and x is important to correspond with 
 * the sequence of which z, y, and x data are read from the sensor.
 * All values are unsigned 16 bit integers
*/
typedef struct
{
    int16_t z;
    int16_t y;
    int16_t x;
}gyro_values_t;


typedef enum sensValType_t {
	ACC_X, 
	ACC_Y,
	ACC_Z,
	GYR_X,
	GYR_Y,
	GYR_Z,
	DMP_X,
	DMP_Y,
	DMP_Z,
} sensValType;

// accel_values_t acc_values;
// gyro_values_t gyr_values;

int16_t phi, theta, psi;
int16_t raw_phi, raw_theta, raw_psi;
int16_t sp, sq, sr;
int16_t sax, say, saz;
uint8_t sensor_fifo_count;
int16_t phi_cal, theta_cal, psi_cal;
long unsigned int pedo;


void getMpuSensors();
void getPedo();
int16_t getMpuVal(sensValType type);

#endif /* MPU_INTERFACE_H_ */

