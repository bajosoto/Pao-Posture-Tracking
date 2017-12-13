//
// Created by phil on 4-12-17.
//

#include "preprocessor.h"
#include "mat.h"
#include <stdio.h>
#include <memory.h>
#include "timestamp.h"
#include <stdlib.h>

#define WINDOW_SIZE         30
#define TRAINING_SET_SIZE   (4 * 300) / WINDOW_SIZE

feature_t samples_buffer[WINDOW_SIZE][RAW_DIM];
feature_t processed_samples_buffer[1][CLF_DIM];

feature_t training_set[TRAINING_SET_SIZE][CLF_DIM];
class_t training_labels[TRAINING_SET_SIZE];

proba_t class_probabilities[CLASS_NCLASSES];

int16_t counter_train = 0;
int16_t counter_buffer = 0;
char    training_enabled = 0;

void reset_train_buffer() {
    counter_buffer = 0;
    counter_train = 0;
}

void finish_training() {
    clf_fit(TRAINING_SET_SIZE, training_set, training_labels);
}

class_t process_new_sample(class_t label){

    samples_buffer[counter_buffer][IDX_ACCEL_0] = getMpuVal(ACC_X);
    samples_buffer[counter_buffer][IDX_ACCEL_1] = getMpuVal(ACC_Y);
    samples_buffer[counter_buffer][IDX_ACCEL_2] = getMpuVal(ACC_Z);
    samples_buffer[counter_buffer][IDX_PHI] = getMpuVal(DMP_X);
    samples_buffer[counter_buffer][IDX_THETA] = getMpuVal(DMP_Y);

    counter_buffer += 1;

    // Buffer is full
    if(counter_buffer >= WINDOW_SIZE) {
        // Preprocess window into single sample
        prep_transform(WINDOW_SIZE, samples_buffer, 1, processed_samples_buffer);

        // label = CLASS_NO_CLASS means we're training, otherwise we're classifying
        if(label == CLASS_NO_CLASS) {
            class_t newLabel = clf_predict_proba(processed_samples_buffer[0], class_probabilities);
            debugMsgBle("newLabel: %d", newLabel);
            for(int i = 0; i < CLASS_NCLASSES; i++) {
                debugMsg("%d, ", (int16_t)(class_probabilities[i] * 100));
            }
            proba_t highest_proba = class_probabilities[newLabel];
            entry_t* newEntry = (entry_t*)malloc(sizeof(entry_t));
            newEntry->label = newLabel;
            newEntry->proba = highest_proba;
            newEntry->timestamp = get_timestamp();

            // Store newEntry somewhere
            // TODO
            debugMsgBle("Lb: %d\tTime: %d", newEntry->label, newEntry->timestamp);
            // Free memory
            free(newEntry);

        } else if(training_enabled) {       // Check if a label button has been pressed on the app

            // Calculate new pointer
            int offset = (int16_t)label * (TRAINING_SET_SIZE / 4);
            counter_train = ((counter_train - offset) % (TRAINING_SET_SIZE / 4)) + offset;

            // Store label
            training_labels[counter_train] = label;
            // Copy processed sample into training set
            for(int i = 0; i < CLF_DIM; i++) {
                training_set[counter_train][i] = processed_samples_buffer[0][i];
            }

            debugMsgBle("lbl: %d cnt: %d", label, counter_train);

            // Calculate new pointer
            counter_train = (((counter_train - offset) + 1) % (TRAINING_SET_SIZE / 4)) + offset;
        }
        

        // Reset counter_buffer
        counter_buffer = 0;

        // Return class
        return label;

    } else {
        // Buffer is not full
        return CLASS_NO_CLASS;
    }
}


// void prep_init(){
    
//     WINDOW_SIZE = window_size_set;
//     TRAINING_SET_SIZE = 4 * 300 / WINDOW_SIZE; // 300 = 20 samples/second * 15 seconds of training per posture (4)

//     samples_buffer = (feature_t**)malloc(sizeof(feature_t *) * window_size_set);
//     for (i = 0; i < window_size_set; i++)
//          samples_buffer[i] = (feature_t *)malloc(sizeof(feature_t) * RAW_DIM);
    
//     processed_samples_buffer = (feature_t**)malloc(sizeof(feature_t *) * 1);        // Only storing one window
//     for (i = 0; i < 1; i++)                                                            // same here
//          processed_samples_buffer[i] = (feature_t *)malloc(sizeof(feature_t) * CLF_DIM);

//     training_set = (feature_t**)malloc(sizeof(feature_t *) * TRAINING_SET_SIZE);
//     for (i = 0; i < TRAINING_SET_SIZE; i++)
//          samples_buffer[i] = (feature_t *)malloc(sizeof(feature_t) * CLF_DIM);
//      training_labels = (class_t*)malloc(sizeof(class_t) * TRAINING_SET_SIZE)

// }

static void avg(uint16_t n_samples,const feature_t samples[n_samples][RAW_DIM],

                      uint16_t buffer_size,feature_t buffer[buffer_size][RAW_DIM]){

    uint16_t w = 0;
    for(uint16_t i=0; i < n_samples; i++){
        for (uint16_t k = 0; k < RAW_DIM; k++){
            buffer[w][k] = buffer[w][k]+(samples[i][k]/(feature_t )WINDOW_SIZE);
        }
        if(i > 0 && i % WINDOW_SIZE == 0){
            w++;
        }

    }
}

void prep_transform(uint16_t n_samples,const feature_t samples[n_samples][RAW_DIM],uint16_t buffer_size,feature_t buffer[buffer_size][CLF_DIM]){

    uint16_t n_samples_new = (uint16_t)(n_samples/WINDOW_SIZE);

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
