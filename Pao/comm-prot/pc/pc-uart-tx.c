
/* pc-uart-tx.c
 * Messages to be sent to the board
 * Author: Sergio Soto
 */

#include "pc-uart-tx.h"
#include "uart-sm.h"
#include <inttypes.h>

void splitSI16(int16_t c, int index);

/* sendMessage(TxMsg msgType)
 * Author: 		Sergio Soto
 * Function: 	Transmits a message via UART to the board
 * IN:			TxMsg msgType - The message to be transmitted
*/
void sendMessagePc(TxMsgPc msgType){

	if(msgType < TOTAL_PC_MESSAGES) {				// Validate message
		lastTxMsg = msgType;						// Store last message attempted to send
		switch (msgType){
	
			case MSG00_STATUS:
			case MSG01_QUIT:
				sendPacket(msgType, 0);
				break;
			case TOTAL_PC_MESSAGES:					// Only including this to avoid the warning [-Wswitch]
				break;
			default:
				break;
		}
	} else {
		// TODO: Invalid message type is being tried to send. A warning somewhere maybe?
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
	int16_t offset = 3 * index;
	
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
