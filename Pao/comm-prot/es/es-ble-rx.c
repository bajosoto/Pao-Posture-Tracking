
#include "es-ble-rx.h"
#include "debug-interface.h"
#include "es-ble-tx.h"

// =========================================================================== //
//								BLE Messages
// =========================================================================== //

// Payload buffer rx
uint8_t bleRxBuff[BLE_BUFFER_SIZE];

void ble_msg00_ping();
void ble_msg01_dummy_data();
void ble_msg02_dummy_signed_int32();

// Message table
BleMsgType bleMsgTable[TOTAL_BLE_MESSAGES_APP] = {
	/* Action Name */		/* Length */
	{ble_msg00_ping, 				0},				// 00:	Requests board status
	{ble_msg01_dummy_data, 			4}, 			// 01:	Dummy 4 byte data
	{ble_msg02_dummy_signed_int32, 	4},				// 02:	Dummy 32-bit signed int
};



void ble_msg00_ping(){
	bsp_board_led_invert(1);
	sendBleMessageEs(MSG_BLE_00_PONG);
	//debugMsgBle("Hello! %d", -4673);        // Example of how to use debugMsgBle
}

void ble_msg01_dummy_data(){

}

void ble_msg02_dummy_signed_int32(){

}








// =========================================================================== //
//								BLE State Machine
// =========================================================================== //

void ble_start_rx();
void ble_receive_type();
void ble_receive_data();

// Machine state transitions {action}
BleTransition bleTable[STATES_BLE_COUNT] = {	
	/*STATE_BLE_WAIT*/		/*STATE_BLE_RX_TYPE*/		/*STATE_BLE_RX_DATA*/			
	{ble_start_rx},			{ble_receive_type},			{ble_receive_data}	
};

// Initial state: STATE_BLE_WAIT
BleState stateBle = STATE_BLE_WAIT;
// Char received buffer
volatile char bleRxChar = 0;
// Message type
int bleMsgTypeRx = 0;
// Payload length 
uint8_t blePlLength = 0;
// Payload position 
uint8_t blePlPosition = 0;


void bleInput(uint8_t c) {

	bleRxChar = c;
	// debugMsg("received %d", bleRxChar);
	// sendMsgBle("received %c", bleRxChar);
	bleTable[stateBle].action();						// Perform BLE state machine action
}

void ble_start_rx() {

	if(bleRxChar == '~'){										// Start nibble of packet received
		stateBle = STATE_BLE_RX_TYPE;							// Change state expecting payload
	}
}

void ble_receive_type() {

	if(bleRxChar < TOTAL_BLE_MESSAGES_APP) {					// Validate message type

		bleMsgTypeRx = (int)bleRxChar;							// Store message type	
		blePlLength = bleMsgTable[bleMsgTypeRx].length;				// Store the length
		blePlPosition = blePlLength;							// Set the offset of the payload
		
		if(blePlPosition > 0) {									// If the message has payload
			stateBle = STATE_BLE_RX_DATA;						// Switch state to wait for payload
		
		} else {												// If the message has no payload
			bleMsgTable[bleMsgTypeRx].action();					// Execute action directly
			stateBle = STATE_BLE_WAIT;							// Go back to waiting state
		}
	} else {													// Message type was invalid
		stateBle = STATE_BLE_WAIT;								// Discard packet and go back to wait
	}	
}

void ble_receive_data() {

	bleRxBuff[blePlLength - blePlPosition] = bleRxChar;			// Store data into buffer
	blePlPosition -= 1;											// Update position pointer
	
	if(blePlPosition > 0) {										// If more data is expected
		stateBle = STATE_BLE_RX_DATA;							// Stay in current state
	
	} else {													// If last char of payload was received	
		bleMsgTable[bleMsgTypeRx].action();						// Perform action
		stateBle = STATE_BLE_WAIT;								// Move to waiting state
	}
}


