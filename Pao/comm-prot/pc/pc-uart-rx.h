#ifndef PC_UART_RX_H_
#define PC_UART_RX_H_

#define TOTAL_ES_MESSAGES 3

// Name holder for actions (to avoid dereferencing everywhere)
typedef void (*Action)();

// A transition occurs when moving from one state to another
typedef struct Transition_t {
	// State nextState;				// Next state in the SM
	Action action;					// Action executed on state transition
} Transition;

// A message has a transition and a length
typedef struct MsgType_t {
	Transition trans;				// Transition associated with the message
	char length;					// Length of the message's payload
} MsgType;

MsgType msgTable[TOTAL_ES_MESSAGES];

#endif /* PC_UART_RX_H_ */