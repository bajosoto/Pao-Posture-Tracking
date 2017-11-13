#ifndef TWI_H
#define TWI_H

bool i2c_read(uint8_t slave_addr, uint8_t reg_addr, uint8_t data_length, uint8_t *data);

bool i2c_write(uint8_t slave_addr, uint8_t reg_addr, uint8_t data_length, uint8_t const *data);
	
void SPI0_TWI0_IRQHandler(void);

void twi_init(void);

#endif /* TWI_H */


