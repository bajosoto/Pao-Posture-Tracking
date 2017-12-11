//
// Created by phil on 4-12-17.
//

#include "preprocessor.h"
#include "mat.h"
#include <stdio.h>
#include <memory.h>

static uint16_t window_size = 10;
static uint16_t training_set_size = 10;
feature_t **samples_buffer;
feature_t **processed_samples_buffer;

feature_t **training_set;
class_t *training_labels;

int16_t counter_train = 0;

void finish_training() {

}

class_t process_new_sample(class_t label){
    static uint16_t count = 0;

    samples_buffer[count][IDX_ACCEL_0] = getMpuVal(ACC_X);
    samples_buffer[count][IDX_ACCEL_1] = getMpuVal(ACC_Y);
    samples_buffer[count][IDX_ACCEL_2] = getMpuVal(ACC_Z);
    samples_buffer[count][IDX_PHI] = getMpuVal(DMP_X);
    samples_buffer[count][IDX_THETA] = getMpuVal(DMP_Y);

    count += 1;

    // Buffer is full
    if(count == window_size) {
        // Preprocess window into single sample
        prep_transform(window_size, samples_buffer, 1, processed_samples_buffer);

        // label = CLASS_NO_CLASS means we're training, otherwise we're classifying
        if(label != CLASS_NO_CLASS) {
            class_t newLabel = clf_predict(processed_samples_buffer);
        } else {
            // Store label
            training_labels[counter_train] = label;
            // Copy processed sample into training set
            for(int i = 0; i < CLF_DIM; i++) {
                training_set[counter_train][i] = processed_samples_buffer[1][i];
            }

            // Calculate new pointer
            int offset = (int16_t)label * (training_set_size / 4)
            counter_train = (((counter_train - offset) + 1) % (training_set_size / 4)) + offset;
        }
        // Return class
        return label;

        // Reset count
        count = 0;
    } else {
        // Buffer is not full
        return CLASS_NO_CLASS;
    }
}


void prep_init(uint16_t window_size_set){
    
    window_size = window_size_set;
    training_set_size = 4 * 300 / window_size; // 300 = 20 samples/second * 15 seconds of training per posture (4)

    samples_buffer = (feature_t**)malloc(sizeof(feature_t *) * window_size_set);
    for (i = 0; i < window_size_set; i++)
         samples_buffer[i] = (feature_t *)malloc(sizeof(feature_t) * RAW_DIM);
    
    processed_samples_buffer = (feature_t**)malloc(sizeof(feature_t *) * 1);        // Only storing one window
    for (i = 0; i < 1; i++)                                                            // same here
         processed_samples_buffer[i] = (feature_t *)malloc(sizeof(feature_t) * CLF_DIM);

    training_set = (feature_t**)malloc(sizeof(feature_t *) * training_set_size);
    for (i = 0; i < training_set_size; i++)
         samples_buffer[i] = (feature_t *)malloc(sizeof(feature_t) * CLF_DIM);
     training_labels = (class_t*)malloc(sizeof(class_t) * training_set_size)

}

static void avg(uint16_t n_samples, feature_t samples[n_samples][RAW_DIM],
                      uint16_t buffer_size,feature_t buffer[buffer_size][RAW_DIM]){

    uint16_t w = 0;
    for(uint16_t i=0; i < n_samples; i++){
        for (uint16_t k = 0; k < RAW_DIM; k++){
            buffer[w][k] = buffer[w][k]+(samples[i][k]/(feature_t )window_size);
        }
        if(i > 0 && i % window_size == 0){
            w++;
        }

    }
}

void prep_transform(uint16_t n_samples, feature_t samples[n_samples][RAW_DIM],uint16_t buffer_size,feature_t buffer[buffer_size][CLF_DIM]){

    uint16_t n_samples_new = (uint16_t)(n_samples/window_size);

    feature_t average[n_samples_new][RAW_DIM];
    memset(average,0,sizeof(feature_t)*n_samples_new*RAW_DIM);

    avg(n_samples,samples,n_samples_new,average);

    for (uint16_t i = 0; i < n_samples_new; i++){
        buffer[i][0] = average[i][IDX_THETA];
        buffer[i][1] = average[i][IDX_PHI];
        feature_t accel[3];
        accel[0] = average[i][IDX_ACCEL_0];
        accel[1] = average[i][IDX_ACCEL_1];
        accel[2] = average[i][IDX_ACCEL_2];
        buffer[i][2] = vec_norm(3,accel);
    }

}
