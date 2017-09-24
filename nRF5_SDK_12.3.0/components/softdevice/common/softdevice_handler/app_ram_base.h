/**
 * Copyright (c) 2013 - 2017, Nordic Semiconductor ASA
 * 
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form, except as embedded into a Nordic
 *    Semiconductor ASA integrated circuit in a product or a software update for
 *    such product, must reproduce the above copyright notice, this list of
 *    conditions and the following disclaimer in the documentation and/or other
 *    materials provided with the distribution.
 * 
 * 3. Neither the name of Nordic Semiconductor ASA nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 * 
 * 4. This software, with or without modification, must only be used with a
 *    Nordic Semiconductor ASA integrated circuit.
 * 
 * 5. Any software provided in binary form under this license must not be reverse
 *    engineered, decompiled, modified and/or disassembled.
 * 
 * THIS SOFTWARE IS PROVIDED BY NORDIC SEMICONDUCTOR ASA "AS IS" AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY, NONINFRINGEMENT, AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL NORDIC SEMICONDUCTOR ASA OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 */

// ble_enable param app_ram_base

#ifndef APP_RAM_BASE_H__
#define APP_RAM_BASE_H__

#ifdef __cplusplus
extern "C" {
#endif


#ifdef S130
    #define APP_RAM_BASE_CENTRAL_LINKS_0_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20001870
    #define APP_RAM_BASE_CENTRAL_LINKS_0_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20001900
    #define APP_RAM_BASE_CENTRAL_LINKS_0_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20001fe8
    #define APP_RAM_BASE_CENTRAL_LINKS_0_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20002078
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20001ce0
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20001d70
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20001eb0
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20001f40
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002418
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x200024a8
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x200025e0
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002670
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002110
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x200021a0
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x200022d8
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002368
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002840
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x200028d0
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20002a10
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002aa0
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002538
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x200025c8
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20002708
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002798
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002c70
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20002d00
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20002e40
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002ed0
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002968
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x200029f8
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20002b30
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002bc0
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x200030a0
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003130
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003268
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x200032f8
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002d98
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20002e28
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20002f60
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002ff0
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x200034c8
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003558
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003698
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003728
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x200031c0
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003250
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003390
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003420
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x200038f8
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003988
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003ac0
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003b50
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x200035f0
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003680
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x200037b8
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003848
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20003d28
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003db8
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003ef0
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003f80
    #define APP_RAM_BASE_CENTRAL_LINKS_8_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20003a18
    #define APP_RAM_BASE_CENTRAL_LINKS_8_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003aa8
    #define APP_RAM_BASE_CENTRAL_LINKS_8_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003be8
    #define APP_RAM_BASE_CENTRAL_LINKS_8_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003c78
#elif defined(S132) || defined(S332)
    #define APP_RAM_BASE_CENTRAL_LINKS_0_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20001930
    #define APP_RAM_BASE_CENTRAL_LINKS_0_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x200019c0
    #define APP_RAM_BASE_CENTRAL_LINKS_0_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002128
    #define APP_RAM_BASE_CENTRAL_LINKS_0_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x200021b8
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20001e18
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20001ea8
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20001fe8
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002078
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x200025d0
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20002660
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20002798
    #define APP_RAM_BASE_CENTRAL_LINKS_1_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002828
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x200022c0
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20002350
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20002490
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002520
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002a78
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20002b08
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20002c40
    #define APP_RAM_BASE_CENTRAL_LINKS_2_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002cd0
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002768
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x200027f8
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20002938
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x200029c8
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002f20
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20002fb0
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x200030e8
    #define APP_RAM_BASE_CENTRAL_LINKS_3_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003178
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20002c10
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20002ca0
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20002de0
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20002e70
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x200033c8
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003458
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003590
    #define APP_RAM_BASE_CENTRAL_LINKS_4_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003620
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x200030b8
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003148
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003288
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003318
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20003870
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003900
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003a38
    #define APP_RAM_BASE_CENTRAL_LINKS_5_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003ac8
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20003560
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x200035f0
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003730
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x200037c0
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20003d18
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003da8
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003ee0
    #define APP_RAM_BASE_CENTRAL_LINKS_6_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003f70
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20003a08
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003a98
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20003bd8
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20003c68
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x200041c0
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_1_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20004250
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20004388
    #define APP_RAM_BASE_CENTRAL_LINKS_7_PERIPH_LINKS_1_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20004418
    #define APP_RAM_BASE_CENTRAL_LINKS_8_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_1_MID_BW 0x20003eb0
    #define APP_RAM_BASE_CENTRAL_LINKS_8_PERIPH_LINKS_0_SEC_COUNT_0_VS_UUID_COUNT_10_MID_BW 0x20003f40
    #define APP_RAM_BASE_CENTRAL_LINKS_8_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_1_MID_BW 0x20004080
    #define APP_RAM_BASE_CENTRAL_LINKS_8_PERIPH_LINKS_0_SEC_COUNT_1_VS_UUID_COUNT_10_MID_BW 0x20004110
#endif


#ifdef __cplusplus
}
#endif

#endif // APP_RAM_BASE_H__
