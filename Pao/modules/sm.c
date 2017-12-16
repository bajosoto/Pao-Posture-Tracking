
/* sm.c
 * Board state machine
 * Author: Sergio Soto
 */

#include "sm.h"

StateEs smCurrState = S1_NOTCALNOTCON;

TransValid noTrans();
TransValid invTrans();

TransValid startCal();
TransValid cancelCal();
TransValid reCal();
TransValid calDoneCon();
TransValid calDoneNotCon();

TransValid bleCon();
TransValid bleConNotCal();
TransValid bleDiscon();
TransValid bleDisconNotCal();

// Machine state transitions from ROW to COL
TransitionEs esSmTable[NUM_STATES_ES][NUM_STATES_ES] = {	
		/*S0_NOTCALIBRATED*/	/*S1_NOTCALNOTCON*/		/*S2_DISCONNECTED*/		/*S3_CONNECTED*/	/*S4_TRAINING*/	
/*S0*/	{{noTrans}, 			{bleDisconNotCal},		{invTrans}, 			{invTrans}, 		{startCal}},
/*S1*/	{{bleConNotCal}, 		{noTrans},				{invTrans}, 			{invTrans}, 		{invTrans}}, 	
/*S2*/	{{invTrans}, 			{invTrans},				{noTrans}, 				{bleCon}, 			{invTrans}}, 
/*S3*/	{{invTrans}, 			{invTrans},				{bleDiscon}, 			{noTrans}, 			{reCal}}, 
/*S4*/	{{cancelCal}, 			{cancelCal},			{calDoneNotCon}, 		{calDoneCon}, 		{noTrans}}, 	
};

/*  */
TransValid noTrans() {
	return TRANS_NONE;
}

/*  */
TransValid invTrans() {
	return TRANS_INVALID;
}

/*  */
TransValid startCal() {
	return TRANS_OK;
}

/*  */
TransValid cancelCal() {
	return TRANS_OK;
}

/*  */
TransValid reCal() {
	return TRANS_OK;
}

/*  */
TransValid calDoneCon() {
	finish_training();
	return TRANS_OK;
}

/*  */
TransValid calDoneNotCon() {
	return TRANS_OK;
}

/*  */
TransValid bleCon() {
	return TRANS_OK;
}

/*  */
TransValid bleConNotCal() {
	return TRANS_OK;
}

/*  */
TransValid bleDiscon() {
	return TRANS_OK;
}

/*  */
TransValid bleDisconNotCal() {
	return TRANS_OK;
}

/* switchState(StateEs smNewState)
 * Author: 		Sergio Soto
 * Function: 	Attempts to switch to a new state
 * IN:			StateEs smNewState - The desired state to change into
 * OUT:			TransValid - The transition outcome, whether it was allowed or not
*/
TransValid switchState(StateEs smNewState) {

	TransValid result = esSmTable[smCurrState][smNewState].action();
	if(result == TRANS_OK) {
		smCurrState = smNewState;
		debugMsgBle("Switched to state %d", smNewState);
		debugMsg("Switched to state %d", smNewState);
	} else {
		debugMsgBle("Invalid trans(%d -> %d)", smCurrState, smNewState);
		debugMsg("Invalid trans(%d -> %d)", smCurrState, smNewState);
	}

	return result;
}

TransValid switchStateDisconnect() {

	if(smCurrState == S0_NOTCAL) {
		return switchState(S1_NOTCALNOTCON);
	} else if(smCurrState == S3_CONNECTED) {
		return switchState(S2_DISCONNECTED);
	} else if(smCurrState == S4_TRAINING) {
		return switchState(S1_NOTCALNOTCON);
	} else {
		return TRANS_INVALID;
	}
}

TransValid switchStateConnect() {

	if(smCurrState == S1_NOTCALNOTCON) {
		return switchState(S0_NOTCAL);
	} else if(smCurrState == S2_DISCONNECTED) {
		return switchState(S3_CONNECTED);
	} else {
		return TRANS_INVALID;
	}
}
