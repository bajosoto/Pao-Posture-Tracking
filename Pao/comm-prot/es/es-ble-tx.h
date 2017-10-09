#ifndef ES_BLE_TX_H_
#define ES_BLE_TX_H_

typedef enum TxBleMsgEs_t { 
	MSG_BLE_00_PONG,					// 00:	Answer status to App
	MSG_BLE_01_DEBUG,					// 01:	Debug console message in App
	MSG_BLE_02_SENSOR,					// 02:	Accelerometer and Gyro data
	TOTAL_TX_BLE_MESSAGES
} TxMsgBleEs;

void sendBleMessageEs(TxMsgBleEs msgType);


#endif /* ES_BLE_TX_H_ */

