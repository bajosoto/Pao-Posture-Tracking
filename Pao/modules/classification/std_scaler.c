//
// Created by phil on 4-12-17.
//

#include "std_scaler.h"

static feature_t min[CLF_DIM];
static feature_t max[CLF_DIM];

void stds_fit(uint16_t n_samples, feature_t samples[n_samples][CLF_DIM]){
    for (int j = 0; j < CLF_DIM; j++){
        min[j] = -1*FEATURE_T_MAX;
        max[j] = FEATURE_T_MAX;
    }

    for (int i = 0; i < n_samples; i++){
        for (int j = 0; j < CLF_DIM; j++){
            if(samples[i][j] < min[j]){
                min[j] = samples[i][j];
            }
            if(samples[i][j] > max[j]){
                max[j] = samples[i][j];
            }
        }
    }
}


void stds_transform(feature_t sample[CLF_DIM]){
    for (int j = 0; j < CLF_DIM; j++){
        sample[j] = (sample[j]-min[j])/(max[j]-min[j]);
    }
}

void stds_transform_n(uint16_t n_samples,feature_t samples[n_samples][CLF_DIM]){
    for (int i = 0; i < n_samples; i++){
        stds_transform(samples[i]);
    }
}