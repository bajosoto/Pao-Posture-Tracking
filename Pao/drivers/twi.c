/*------------------------------------------------------------------
 *  twic.c-- i2c driver. It had to be blocking so that the invensense
 *			sdk could be used. ~650us to read the fifo
 *			-=sucks=- how much faster can you make it??
 *
 *  I. Protonotarios
 *  Embedded Software Lab
 *
 *  July 2016
 *------------------------------------------------------------------
 */

#include <stdbool.h>
#include "debug-interface.h"
#include "twi.h"
#include "nrf_drv_mpu.h"
#include "mpu9150_register_map.h"

// Sergio: These are in the board. Are they the same in Pao?
// #define MPU_TWI_SCL_PIN 1
// #define MPU_TWI_SDA_PIN 2

#define MPU_TWI_SCL_PIN 7
#define MPU_TWI_SDA_PIN 30

static volatile bool sent = false;
static volatile bool read = false;

bool i2c_read(uint8_t slave_addr, uint8_t reg_addr, uint8_t data_length, uint8_t *data)
{
	if (!data_length) return -1;

	sent = false;
	read = false;
	NRF_TWI0->ADDRESS = slave_addr;
	NRF_TWI0->TXD = reg_addr;
	NRF_TWI0->SHORTS = 0;
	NRF_TWI0->TASKS_STARTTX = 1;

	while (!sent);
	sent = false;
	
	if (data_length-1 == 0) NRF_TWI0->SHORTS = TWI_SHORTS_BB_STOP_Msk;
	else NRF_TWI0->SHORTS = TWI_SHORTS_BB_SUSPEND_Msk;

	NRF_TWI0->TASKS_STARTRX = 1;

	while (true)
	{
		while (!read);
		read = false;
	
		*data++ = NRF_TWI0->RXD;
		if (--data_length == 1) NRF_TWI0->SHORTS = TWI_SHORTS_BB_STOP_Msk;
		NRF_TWI0->TASKS_RESUME = 1;
		if (data_length == 0) break;	
	}


	// // Sergio: Implementation using nrf SDK:
	// nrf_drv_mpu_read_registers(reg_addr, data, data_length);


	return 0;			
}

bool i2c_write(uint8_t slave_addr, uint8_t reg_addr, uint8_t data_length, uint8_t const *data)
{
	if (!data_length) return -1;

	sent = false;
	NRF_TWI0->ADDRESS = slave_addr;
	NRF_TWI0->SHORTS = 0;
	NRF_TWI0->TXD = reg_addr;
	NRF_TWI0->TASKS_STARTTX = 1;

	while(!sent);
	sent = false;  // address sent

	while (data_length-- != 0)
	{
		NRF_TWI0->TXD = *data++;

		while(!sent);
		sent = false;  
	}
	
	NRF_TWI0->TASKS_STOP = 1;



	// // Sergio: Implementation using nrf SDK:
	// uint8_t *newData = (uint8_t*)data;
	// nrf_drv_mpu_write_registers(reg_addr, newData, data_length);

	return 0;
}

// Sergio: TWI0 handler is already implemented in SDK 
	
void SPI0_TWI0_IRQHandler(void) 
{
	if(NRF_TWI0->EVENTS_RXDREADY != 0)
	{
		NRF_TWI0->EVENTS_RXDREADY = 0;
//		printf("\revent rxready\n");
		read = true;
	}

        if(NRF_TWI0->EVENTS_TXDSENT != 0)
	{
		NRF_TWI0->EVENTS_TXDSENT = 0;
//		printf("\revent txdsent\n");
		sent = true;
  	}
        
	if(NRF_TWI0->EVENTS_ERROR != 0)
    	{
		debugMsg("TWI error, code: %lx | from device: %ld", NRF_TWI0->ERRORSRC, NRF_TWI0->ADDRESS);
		NRF_TWI0->ERRORSRC = 3;
        NRF_TWI0->EVENTS_ERROR = 0;

        // Sergio: I'm hoping this will stop the program from freezing whenever there's a TWI error
        sent = true;
        read = true;
	}

}



void twi_init(void)
{
	nrf_gpio_cfg(MPU_TWI_SCL_PIN, NRF_GPIO_PIN_DIR_INPUT, NRF_GPIO_PIN_INPUT_CONNECT, NRF_GPIO_PIN_PULLUP, NRF_GPIO_PIN_S0D1, NRF_GPIO_PIN_NOSENSE); 
	nrf_gpio_cfg(MPU_TWI_SDA_PIN, NRF_GPIO_PIN_DIR_INPUT, NRF_GPIO_PIN_INPUT_CONNECT, NRF_GPIO_PIN_PULLUP, NRF_GPIO_PIN_S0D1, NRF_GPIO_PIN_NOSENSE); 

  	NRF_TWI0->PSELSCL	  = MPU_TWI_SCL_PIN;
	NRF_TWI0->PSELSDA 	  = MPU_TWI_SDA_PIN;
 	NRF_TWI0->EVENTS_RXDREADY = 0;
	NRF_TWI0->EVENTS_TXDSENT  = 0;
    	NRF_TWI0->FREQUENCY       = TWI_FREQUENCY_FREQUENCY_K400;
	NRF_TWI0->INTENSET	  = TWI_INTENSET_TXDSENT_Msk | TWI_INTENSET_RXDREADY_Msk | TWI_INTENSET_ERROR_Msk;// | TWI_INTENSET_SUSPENDED_Msk | TWI_INTENSET_BB_Msk | TWI_INTENSET_STOPPED_Msk;

	NRF_TWI0->SHORTS	  = 0;
	NRF_TWI0->ENABLE          = TWI_ENABLE_ENABLE_Enabled;

	NVIC_ClearPendingIRQ(SPI0_TWI0_IRQn);
	NVIC_SetPriority(SPI0_TWI0_IRQn, 3);
	NVIC_EnableIRQ(SPI0_TWI0_IRQn);

	

	// // Sergio: Implementation using SDK:
	
	// // Initate TWI or SPI driver dependent on what is defined from the project
	// nrf_drv_mpu_init();

 //    uint8_t reset_value = 7; // Resets gyro, accelerometer and temperature sensor signal paths.
 //    nrf_drv_mpu_write_single_register(MPU_REG_SIGNAL_PATH_RESET, reset_value);

 //    // Chose  PLL with X axis gyroscope reference as clock source
 //    nrf_drv_mpu_write_single_register(MPU_REG_PWR_MGMT_1, 1);

}
