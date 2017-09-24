#ifndef ES_UART_TX_H_
#define ES_UART_TX_H_

typedef enum TxMsgEs_t { 
	MSG00_STATUS_ANS,			// 00:	Answer status to terminal
	TOTAL_ES_MESSAGES
} TxMsgEs;

void sendMessageEs(TxMsgEs msgType);


#endif /* ES_UART_TX_H_ */

