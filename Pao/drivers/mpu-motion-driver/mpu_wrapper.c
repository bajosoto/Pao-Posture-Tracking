/*------------------------------------------------------------------
 *  mpu_wrapper.c -- invensense sdk setup
 *
 *  I. Protonotarios
 *  Embedded Software Lab
 *
 *  July 2016
 *------------------------------------------------------------------
 */


#include "mpu_wrapper.h"

#define QUAT_SENS       0x040000000 //1073741824.f //2^30

#define MPU_MPU_INT_PIN     29	// Sergio: TODO - This is most likely wrong. I think it's 29

void update_euler_from_quaternions(int32_t *quat) 
{
	float q[4];

	q[0] = (float)quat[0]/QUAT_SENS;
	q[1] = (float)quat[1]/QUAT_SENS;
	q[2] = (float)quat[2]/QUAT_SENS;
	q[3] = (float)quat[3]/QUAT_SENS;

	phi = (int16_t) (atan2(2.0*(q[2]*q[3] + q[0]*q[1]), q[0]*q[0] - q[1]*q[1] - q[2]*q[2] + q[3]*q[3])*10430.0);
	theta = (int16_t) (-1.0 * asin(-2.0*(q[1]*q[3] - q[0]*q[2]))*10430.0);
	psi = (int16_t) (atan2(2.0*(q[1]*q[2] + q[0]*q[3]), q[0]*q[0] + q[1]*q[1] - q[2]*q[2] - q[3]*q[3])*10430.0);
}

void get_dmp_data(void)
{
	int8_t read_stat;
	int16_t gyro[3], accel[3], dmp_sensors;
	int32_t quat[4];

	if (!(read_stat = dmp_read_fifo(gyro, accel, quat, NULL, &dmp_sensors, &sensor_fifo_count)))
	{
		//debugMsg("sensor fifo count: %d", sensor_fifo_count);
		update_euler_from_quaternions(quat);
		if (dmp_sensors & INV_XYZ_GYRO)
		{
			sp = gyro[0];
			sq = gyro[1];
			sr = gyro[2];
		}
		if (dmp_sensors & INV_XYZ_ACCEL)
		{
			sax = accel[0];
			say = accel[1];
			saz = accel[2];
		}
	}
	//else debugMsg("Error reading sensor fifo: %d\n", read_stat);
}

void get_raw_sensor_data(void)
{
	int8_t read_stat;
	int16_t gyro[3], accel[3];
	uint8_t sensors;

	if (!(read_stat = mpu_read_fifo(gyro, accel, NULL, &sensors, &sensor_fifo_count)))
	{
		if (sensors & INV_XYZ_GYRO) //16.4 LSB/deg/s (+-2000 deg/s)  You might need this for Kalman
		{
			sp = gyro[0];
			sq = gyro[1];
			sr = gyro[2];
		}
		if (sensors & INV_XYZ_ACCEL) //	16384 LSB/g (+-2g)  You might need this for Kalman
		{
			sax = accel[0];
			say = accel[1];
			saz = accel[2];
		}
	}
	/* call the Kalman filter now to filter the raw data */
	// Kalmanfilter_phi_theta();
}



bool check_sensor_int_flag(void)
{
	if (nrf_gpio_pin_read(MPU_MPU_INT_PIN) || sensor_fifo_count) return true;
	return false;
}

void imu_init(bool dmp, uint16_t freq)
{
	static int8_t gyro_orientation[9] = {	1, 0, 0,
											0, 1, 0,
											0, 0, 1	};


	// enable gpio interrupt pin (although we don't use it as interrupt, just GPIO)
	nrf_gpio_cfg_input(MPU_MPU_INT_PIN, 0);

	// tap feature is there to set freq to 100Hz, a bug provided by invensense :)
	uint16_t dmp_features = DMP_FEATURE_6X_LP_QUAT | DMP_FEATURE_SEND_RAW_ACCEL | DMP_FEATURE_SEND_CAL_GYRO | DMP_FEATURE_GYRO_CAL | DMP_FEATURE_TAP;

	// //mpu	
	debugMsg("mpu init result: %d", mpu_init(NULL));
	debugMsg("mpu set sensors: %d", mpu_set_sensors(INV_XYZ_GYRO | INV_XYZ_ACCEL));
	debugMsg("mpu conf fifo  : %d", mpu_configure_fifo(INV_XYZ_GYRO | INV_XYZ_ACCEL));

	//mpu	
	// debugMsg("Initializing mpu...");
	// mpu_init(NULL);
	// debugMsg("Setting sensors...");
	// mpu_set_sensors(INV_XYZ_GYRO | INV_XYZ_ACCEL);
	// debugMsg("Configuring fifo...");
	// mpu_configure_fifo(INV_XYZ_GYRO | INV_XYZ_ACCEL);

	mpu_set_int_level(0);
	mpu_set_int_latched(1);

	if (dmp)
	{
		debugMsg("dmp load firm  : %d", dmp_load_motion_driver_firmware());
		debugMsg("dmp set orient : %d", dmp_set_orientation(inv_orientation_matrix_to_scalar(gyro_orientation)));
		debugMsg("dmp en features: %d", dmp_enable_feature(dmp_features));
		debugMsg("dmp set rate   : %d", dmp_set_fifo_rate(100));
		debugMsg("dmp set state  : %d", mpu_set_dmp_state(1));
		debugMsg("dlpf set freq  : %d", mpu_set_lpf(10));

		// dmp_load_motion_driver_firmware();
		// dmp_set_orientation(inv_orientation_matrix_to_scalar(gyro_orientation));
		// dmp_enable_feature(dmp_features);
		// dmp_set_fifo_rate(100);
		// mpu_set_dmp_state(1);
		// mpu_set_lpf(10);
	} else {
		unsigned char data = 0;
		// printf("\rdisable dlpf   : %d\n", i2c_write(0x68, 0x1A, 1, &data));
		// // if dlpf is disabled (0 or 7) then the sample divider that feeds the fifo is 8kHz (derrived from gyro).
		// data = 8000 / freq - 1;
		// printf("\rset sample rate: %d\n", i2c_write(0x68, 0x19, 1, &data));

		i2c_write(0x68, 0x1A, 1, &data);
		// if dlpf is disabled (0 or 7) then the sample divider that feeds the fifo is 8kHz (derrived from gyro).
		data = 8000 / freq - 1;
		i2c_write(0x68, 0x19, 1, &data);
	}
}
