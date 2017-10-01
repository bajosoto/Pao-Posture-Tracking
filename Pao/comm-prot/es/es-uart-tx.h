#ifndef ES_UART_TX_H_
#define ES_UART_TX_H_

typedef enum TxMsgEs_t { 
	MSG00_STATUS_ANS,			// 00:	Answer status to terminal
	MSG01_QUIT_ANS, 			// 01:	Answer shutdown request
	MSG02_SENSOR_VALS,			// 02:	Sensor values to display
	MSG03_DBG_MSG,				// 03:	Debugging message

	TOTAL_ES_MESSAGES
} TxMsgEs;

void sendMessageEs(TxMsgEs msgType);


#endif /* ES_UART_TX_H_ */

