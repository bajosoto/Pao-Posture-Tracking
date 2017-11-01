
#include "app_mpu.h"
#include "app_error.h"
#include "boards.h"
#include "mpu_interface.h"

accel_values_t acc_values;
gyro_values_t gyr_values;

void getMpuSensors() {

	uint32_t err_code;
	// Read accelerometer sensor values
	err_code = mpu_read_accel(&acc_values);
	APP_ERROR_CHECK(err_code);

	// Read gyro sensor values
	err_code = mpu_read_gyro(&gyr_values);
	APP_ERROR_CHECK(err_code);

	// printf("\033[3;1HSample # %d\r\nX: %06d\r\nY: %06d\r\nZ: %06d", ++sample_number, acc_values.x, acc_values.y, acc_values.z);
	//bsp_board_led_invert(1);
}

int16_t getMpuVal(sensValType type) {

	switch(type) {
	case ACC_X:
		return acc_values.x;
		break; 
	case ACC_Y:
		return acc_values.y;
		break;
	case ACC_Z:
		return acc_values.z;
		break;
	case GYR_X:
		return gyr_values.x;
		break;
	case GYR_Y:
		return gyr_values.y;
		break;
	case GYR_Z:
		return gyr_values.z;
		break;
	default:
		return -1;
		break;
	}
}