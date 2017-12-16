#ifndef ES_BLE_RX_H_
#define ES_BLE_RX_H_

#include "pao.h"

// =========================================================================== //
//								BLE Messages
// =========================================================================== //

// Number of messages sent from the app to pao
#define TOTAL_BLE_MESSAGES_APP		7

// Name holder for actions (to avoid dereferencing everywhere)
typedef void (*BleMsgAction)();

// A message has a transition and a length
typedef struct BleMsgType_t {
	BleMsgAction action;				// Transition associated with the message
	char length;					// Length of the message's payload
} BleMsgType;


// =========================================================================== //
//								BLE State Machine
// =========================================================================== //

// Maximim data length of the message payload
#define BLE_BUFFER_SIZE			25

// Name holder for actions (to avoid dereferencing everywhere)
typedef void (*BleAction)();

// A transition occurs when moving from one state to another
typedef struct BleTransition_t {
	// State nextState;				// Next state in the SM
	BleAction action;					// Action executed on state transition
} BleTransition;

// Valid States
typedef enum BleState_t { 
	STATE_BLE_WAIT, 				// Waiting for $ character
	STATE_BLE_RX_TYPE,				// Data Type received
	STATE_BLE_RX_DATA,				// Expecting Data
	STATES_BLE_COUNT
} BleState;


void bleInput(uint8_t c);

#endif /* ES_BLE_RX_H_ */

