//
// Created by phil on 4-12-17.
//

#ifndef PAO_PREPROCESSOR_H
#define PAO_PREPROCESSOR_H

#include "classifier.h"


#define IDX_ACCEL_0 0
#define IDX_ACCEL_1 1
#define IDX_ACCEL_2 2
#define IDX_PHI 3
#define IDX_THETA 4
#define RAW_DIM 5

// void prep_init(uint16_t window_size);

void prep_transform(uint16_t n_samples,const feature_t samples[n_samples][RAW_DIM],uint16_t buffer_size,feature_t buffer[buffer_size][CLF_DIM]);



#endif //PAO_PREPROCESSOR_H
