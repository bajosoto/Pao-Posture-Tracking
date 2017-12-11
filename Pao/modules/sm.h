#ifndef SM_H_
#define SM_H_

#include "pao.h"

// Valid transition outcomes
typedef enum TransValid_t {
	TRANS_INVALID,
	TRANS_NONE,	
	TRANS_OK		
} TransValid;

// Valid States
typedef enum StateEs_t { 
	S0_NOTCAL,						// S0 - Not trained, but connected
	S1_NOTCALNOTCON,				// S1 - Not trained, disconnected
	S2_DISCONNECTED,				// S2 - Disconnected (no BLE connection)
	S3_CONNECTED,					// S3 - Connected (BLE connection to smartphone)
	S4_TRAINING,					// S4 - Training mode
	NUM_STATES_ES,
} StateEs;

// Name holder for actions (to avoid dereferencing everywhere)
typedef TransValid (*ActionEs)();

// A transition occurs when moving from one state to another
typedef struct TransitionEs_t {
	// StateEs nextState;				// Next state in the SM
	ActionEs action;					// Action executed on state transition
} TransitionEs;

StateEs smCurrState;

TransValid switchState(StateEs smNewState);

#endif /* SM_H_ */
