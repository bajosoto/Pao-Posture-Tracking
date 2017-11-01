#ifndef ES_UART_TX_H_
#define ES_UART_TX_H_

typedef enum TxMsgEs_t { 
	MSG00_STATUS_ANS,			// 00:	Answer status to terminal
	MSG01_QUIT_ANS, 			// 01:	Answer shutdown request
	MSG02_SENSOR_VALS,			// 02:	Sensor values to display
	MSG03_BLE_STATUS,			// 03:	BLE connection status change
	MSG04_PICKLE_RICK,			// 04:	Pickle Rick	
	MSG05_DBG_MSG,				// 05:	Debugging message

	TOTAL_ES_MESSAGES
} TxMsgEs;

void sendMessageEs(TxMsgEs msgType);


#endif /* ES_UART_TX_H_ */

