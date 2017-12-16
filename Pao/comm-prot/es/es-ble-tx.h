#ifndef ES_BLE_TX_H_
#define ES_BLE_TX_H_

#include "flash-interface.h"

typedef enum TxBleMsgEs_t { 
	MSG_BLE_00_PONG,					// 00:	Answer status to App
	MSG_BLE_01_DEBUG,					// 01:	Debug console message in App
	MSG_BLE_02_SENSOR,					// 02:	Accelerometer and Gyro data
	MSG_BLE_03_DBL_TAP,					// 03: 	Double tap detected
	MSG_BLE_04_PEDO, 					// 04: 	Pedometer data
	MSG_BLE_05_ENTRY, 					// 05: 	Entry data (label, timestamp, proba)
	TOTAL_TX_BLE_MESSAGES
} TxMsgBleEs;

void sendBleEntry(entry_t* entry);

void sendBleMessageEs(TxMsgBleEs msgType);


#endif /* ES_BLE_TX_H_ */

