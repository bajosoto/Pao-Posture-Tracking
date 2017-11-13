
#include "es-ble-tx.h"
#include "ble_interface.h"
#include "debug-interface.h"
#include "mpu_interface.h"

#define MAX_MSG_LENGTH 30

uint8_t bleTxBuff[MAX_MSG_LENGTH];

void stringCpy(char * inString);
void splitSI16Ble(int16_t c, int index);

/* sendMessage(TxMsg msgType)
 * Author: 		Sergio Soto
 * Function: 	Transmits a message via UART to the board
 * IN:			TxMsg msgType - The message to be transmitted
*/
void sendBleMessageEs(TxMsgBleEs msgType){
	//uint16_t uns;
	if(msgType < TOTAL_TX_BLE_MESSAGES) {				// Validate message
		lastTxMsg = msgType;						// Store last message attempted to send
		switch (msgType){
	
			case MSG_BLE_00_PONG:
				sendMsgBle(1, "%c", 0);
				break;
			case MSG_BLE_01_DEBUG:	// This message is not implemented here. See debug-interface.c
				break;
			case MSG_BLE_02_SENSOR:
				splitSI16Ble(getMpuVal(ACC_X), 1);
				splitSI16Ble(getMpuVal(ACC_Y), 3);
				splitSI16Ble(getMpuVal(ACC_Z), 5);
				splitSI16Ble(getMpuVal(GYR_X), 7);
				splitSI16Ble(getMpuVal(GYR_Y), 9);
				splitSI16Ble(getMpuVal(GYR_Z), 11);
				splitSI16Ble(getMpuVal(DMP_X), 13);
				splitSI16Ble(getMpuVal(DMP_Y), 15);
				splitSI16Ble(getMpuVal(DMP_Z), 17);
				sendMsgBle(19, "%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c", 2, 
					bleTxBuff[1], 
					bleTxBuff[2], 
					bleTxBuff[3], 
					bleTxBuff[4], 
					bleTxBuff[5], 
					bleTxBuff[6], 
					bleTxBuff[7], 
					bleTxBuff[8], 
					bleTxBuff[9], 
					bleTxBuff[10], 
					bleTxBuff[11],
					bleTxBuff[12],
					bleTxBuff[13],
					bleTxBuff[14],
					bleTxBuff[15],
					bleTxBuff[16],
					bleTxBuff[17],
					bleTxBuff[18] );
				break;
			case MSG_BLE_03_DBL_TAP:
				sendMsgBle(1, "%c", 3);
				break;
			// case MSG03_BLE_STATUS:
			// 	txBuff[0] = getBleStatus();
			// 	sendPacket(msgType, 1);
			// 	break;
			// case MSG04_PICKLE_RICK:
			// 	sendPacket(msgType, 0);
			// case MSG05_DBG_MSG:
			// 	for(int i = 0; i < MAX_DBG_MSG_LENGTH; i++) {
			// 		txBuff[i] = dbgMsg[i];
			// 	}
			// 	sendPacket(msgType, MAX_DBG_MSG_LENGTH);
			// 	break;
			case TOTAL_TX_BLE_MESSAGES:					// Only including this to avoid the warning [-Wswitch]
				break;
			default:
				break;
		}
	} else {
		// TODO: Invalid message type is being tried to be sent. A warning somewhere maybe?
	}	

	// TODO: Timeout	
}

/* splitSI16(int16_t c, int index)
 * Author: 		Sergio Soto
 * Function: 	Splits and stores a signed int16 in the tx buffer plus sign
 * IN:			int16_t c - The integer to be split
 *              int index - The starting index in the buffer to store the value
*/
void splitSI16Ble(int16_t c, int index) {

	bleTxBuff[0 + index] = (uint8_t) ((c      ) & 0xff);
	bleTxBuff[1 + index] = (uint8_t) ((c >> 8 ) & 0xff);   
}
