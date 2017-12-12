//
// Created by phil on 4-12-17.
//

#ifndef PAO_PREPROCESSOR_H
#define PAO_PREPROCESSOR_H

#include "classifier.h"



void prep_transform(uint16_t n_samples,const feature_t samples[n_samples][RAW_DIM],uint16_t buffer_size,feature_t buffer[buffer_size][CLF_DIM]);



#endif //PAO_PREPROCESSOR_H
