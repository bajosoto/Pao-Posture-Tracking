#ifndef BLE_INTERFACE_H__
#define BLE_INTERFACE_H__

#include <stdint.h>
#include <string.h>
#include "nordic_common.h"
#include "nrf.h"
#include "ble_hci.h"
#include "ble_advdata.h"
#include "ble_advertising.h"
#include "ble_conn_params.h"
#include "softdevice_handler.h"
#include "app_timer.h"
#include "app_button.h"
#include "ble_nus.h"
#include "app_uart.h"
#include "app_util_platform.h"
#include "bsp.h"
#include "bsp_btn_ble.h"
#include "es-uart-tx.h"
#include "es-ble-rx.h"

/**@brief Function for the GAP initialization.
 *
 * @details This function will set up all the necessary GAP (Generic Access Profile) parameters of
 *          the device. It also sets the permissions and appearance.
 */
void gap_params_init(void);
/**@brief Function for initializing services that will be used by the application.
 */
void services_init(void);

/**@brief Function for initializing the Connection Parameters module.
 */
void conn_params_init(void);

/**@brief Function for the SoftDevice initialization.
 *
 * @details This function initializes the SoftDevice and the BLE event interrupt.
 */
void ble_stack_init(void);

/**@brief Function for initializing the Advertising functionality.
 */
void advertising_init(void);

void app_timer_init_sergio();

uint8_t getBleStatus();

void sendMsgBle(char *string);


#endif /* BLE_INTERFACE_H__ */