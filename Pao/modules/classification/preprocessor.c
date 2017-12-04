//
// Created by phil on 4-12-17.
//

#include "preprocessor.h"
#include "mat.h"
#include <stdio.h>
static uint16_t window_size = 10;

void prep_init(uint16_t window_size_set){
    window_size = window_size_set;
}
static void avg(uint16_t n_samples, feature_t samples[n_samples][RAW_DIM],
                      uint16_t buffer_size,feature_t buffer[buffer_size][RAW_DIM]){

    for(int i=0; i < n_samples; i+=window_size){
        for(int j=i;j < window_size; j++){
            for (int k = 0; k < RAW_DIM; k++){
                buffer[(uint16_t )(i/window_size)][k] += samples[j][k];
            }
        }
        for (int k = 0; k < RAW_DIM; k++){
            buffer[(uint16_t )(i/window_size)][k] /= window_size;
        }
    }
}

void prep_transform(uint16_t n_samples, feature_t samples[n_samples][RAW_DIM],uint16_t buffer_size,feature_t buffer[buffer_size][CLF_DIM]){

    uint16_t n_samples_new = (uint16_t)(n_samples/window_size);
    feature_t average[n_samples_new][RAW_DIM];
    avg(n_samples,samples,n_samples_new,average);
    for (int i = 0; i < n_samples_new; i++){
        buffer[i][0] = average[i][IDX_THETA];
        buffer[i][1] = average[i][IDX_PHI];
        feature_t accel[3];
        accel[0] = average[i][IDX_ACCEL_0];
        accel[1] = average[i][IDX_ACCEL_1];
        accel[2] = average[i][IDX_ACCEL_2];
        buffer[i][2] = vec_norm(3,accel);
    }

}
