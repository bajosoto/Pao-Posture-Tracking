//
// Created by phil on 4-12-17.
//

#include "preprocessor.h"
#include "mat.h"
#include <stdio.h>
#include <memory.h>
#include <stdlib.h>
#include "debug-interface.h"

static void avg(uint16_t n_samples,const feature_t samples[n_samples][CLF_DIM],

                      uint16_t buffer_size,feature_t buffer[buffer_size][CLF_DIM]){

    uint16_t w = 0;
    for(uint16_t i=0; i < n_samples; i++){
        for (uint16_t k = 0; k < CLF_DIM; k++){
            buffer[w][k] = buffer[w][k]+(samples[i][k]/(feature_t )WINDOW_SIZE);
        }
        if(i > 0 && i % WINDOW_SIZE == 0){
            w++;
        }

    }
}

void prep_transform(uint16_t n_samples,const feature_t samples[n_samples][RAW_DIM],uint16_t buffer_size,feature_t buffer[buffer_size][CLF_DIM]){

    uint16_t n_samples_new = (uint16_t)(n_samples/WINDOW_SIZE);

    feature_t output_buffer[n_samples][CLF_DIM];

    feature_t average[n_samples_new][CLF_DIM];

    memset(average,0,sizeof(feature_t) * n_samples_new * CLF_DIM);
    memset(output_buffer,0,sizeof(feature_t) * n_samples * CLF_DIM);
    memset(buffer,0,sizeof(feature_t) * buffer_size * CLF_DIM);

    for (int i = 0; i < n_samples; i++) {
        feature_t accel[3];
        accel[0] = samples[i][IDX_ACCEL_0];
        accel[1] = samples[i][IDX_ACCEL_1];
        accel[2] = samples[i][IDX_ACCEL_2];
        output_buffer[i][2] = vec_norm(3,accel);
    }

    for(int i = 0; i < n_samples; i++) {
        output_buffer[i][0] = samples[i][IDX_THETA];
        output_buffer[i][1] = samples[i][IDX_PHI];
    }

    avg(n_samples,output_buffer,n_samples_new,buffer);

    feature_t min = 30000;
    feature_t max = 0;
    for(int i = 0; i < n_samples; i++) {
        if(output_buffer[i][2] > max) {
            max = output_buffer[i][2];
        } else if(output_buffer[i][2] < min) {
            min = output_buffer[i][2];
        }
    }
    buffer[0][2] = max - min;

    
    
    // for (uint16_t i = 0; i < n_samples_new; i++){
        // buffer[i][0] = average[i][IDX_THETA];
        // buffer[i][1] = average[i][IDX_PHI];
    //     feature_t accel[3];
        // accel[0] = average[i][IDX_ACCEL_0];
        // accel[1] = average[i][IDX_ACCEL_1];
        // accel[2] = average[i][IDX_ACCEL_2];
        // buffer[i][2] = average
    // debugMsg("accel> %d, %d, %d", (int16_t)buffer[0][0], (int16_t)buffer[0][1], (int16_t)buffer[0][2]);
    // }

}
