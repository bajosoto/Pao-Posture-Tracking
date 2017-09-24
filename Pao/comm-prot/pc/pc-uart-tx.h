#ifndef PC_UART_TX_H_
#define PC_UART_TX_H_

typedef enum TxMsgPc_t { 
	MSG00_STATUS,				// 00:	Requests board status
	TOTAL_PC_MESSAGES
} TxMsgPc;

void sendMessagePc(TxMsgPc msgType);

#endif /* PC_UART_TX_H_ */

