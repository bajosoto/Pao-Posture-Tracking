
// #include "app_mpu.h"
#include "app_error.h"
#include "boards.h"
#include "mpu_interface.h"
#include "mpu_wrapper.h"


void getMpuSensors() {

	get_dmp_data();

	// uint32_t err_code;
	// // Read accelerometer sensor values
	// err_code = mpu_read_accel(&acc_values);
	// APP_ERROR_CHECK(err_code);

	// // Read gyro sensor values
	// err_code = mpu_read_gyro(&gyr_values);
	// APP_ERROR_CHECK(err_code);

	// printf("\033[3;1HSample # %d\r\nX: %06d\r\nY: %06d\r\nZ: %06d", ++sample_number, acc_values.x, acc_values.y, acc_values.z);
	//bsp_board_led_invert(1);
}

int16_t getMpuVal(sensValType type) {

	switch(type) {
	case ACC_X:
		return sax;
		break; 
	case ACC_Y:
		return say;
		break;
	case ACC_Z:
		return saz;
		break;
	case GYR_X:
		return sp;
		break;
	case GYR_Y:
		return sq;
		break;
	case GYR_Z:
		return sr;
		break;
	case DMP_X:
		return phi;
		break;
	case DMP_Y:
		return theta;
		break;
	case DMP_Z:
		return psi;
		break;
	default:
		return -1;
		break;
	}
}