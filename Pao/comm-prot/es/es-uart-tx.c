
/* es-uart-tx.c
 * Messages to be sent to the terminal
 * Author: Sergio Soto
 */

#include "es-uart-tx.h"
#include "uart-sm.h"
#include "mpu_interface.h"
#include "debug-interface.h"

void stringCpy(char * inString);
void splitSI16(int16_t c, int index);

/* sendMessage(TxMsg msgType)
 * Author: 		Sergio Soto
 * Function: 	Transmits a message via UART to the board
 * IN:			TxMsg msgType - The message to be transmitted
*/
void sendMessageEs(TxMsgEs msgType){
	//uint16_t uns;
	if(msgType < TOTAL_ES_MESSAGES) {				// Validate message
		lastTxMsg = msgType;						// Store last message attempted to send
		switch (msgType){
	
			case MSG00_STATUS_ANS:
			case MSG01_QUIT_ANS:
				//txBuff[0] = smCurrState;
				sendPacket(msgType, 0);
				break;
			case MSG02_SENSOR_VALS:
				splitSI16(getMpuVal(ACC_X), 0);
				splitSI16(getMpuVal(ACC_Y), 1);
				splitSI16(getMpuVal(ACC_Z), 2);
				splitSI16(getMpuVal(GYR_X), 3);
				splitSI16(getMpuVal(GYR_Y), 4);
				splitSI16(getMpuVal(GYR_Z), 5);
				sendPacket(msgType, 18);
				break;
			case MSG03_DBG_MSG:
				for(int i = 0; i < MAX_DBG_MSG_LENGTH; i++) {
					txBuff[i] = dbgMsg[i];
				}
				sendPacket(msgType, MAX_DBG_MSG_LENGTH);
				break;
			case TOTAL_ES_MESSAGES:					// Only including this to avoid the warning [-Wswitch]
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
void splitSI16(int16_t c, int index) {

	int16_t posNum;
	int16_t offset = 3 * index;;
	
	if(c < 0) {
		posNum = -c;
		txBuff[0 + offset] = 1;
	} else {
		posNum = c;
		txBuff[0 + offset] = 0;
	}

	txBuff[1 + offset] = (uint8_t) (posNum     ) & 0xff;
	txBuff[2 + offset] = (uint8_t) (posNum >> 8) & 0xff;   
}
