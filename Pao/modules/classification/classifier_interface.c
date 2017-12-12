#include "classifier_interface.h"
#include <memory.h>
#include "timestamp.h"
#include <stdlib.h>

#include "mpu_interface.h"
#include "flash-interface.h"
#include "debug-interface.h"
#include "preprocessor.h

#define TRAINING_SET_SIZE   (4 * 300) / WINDOW_SIZE

feature_t samples_buffer[WINDOW_SIZE][RAW_DIM];
feature_t processed_samples_buffer[1][CLF_DIM];

feature_t training_set[TRAINING_SET_SIZE][CLF_DIM];
class_t training_labels[TRAINING_SET_SIZE];

proba_t class_probabilities[CLASS_NCLASSES];

int16_t counter_train = 0;
uint16_t train_label = CLASS_STILL_HEALTHY;

void finish_training() {
    clf_fit(TRAINING_SET_SIZE, training_set, training_labels);
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
    if(count >= WINDOW_SIZE) {
        // Preprocess window into single sample
        prep_transform(WINDOW_SIZE, samples_buffer, 1, processed_samples_buffer);

        // label = CLASS_NO_CLASS means we're training, otherwise we're classifying
        if(label == CLASS_NO_CLASS) {
            class_t newLabel = clf_predict_proba(processed_samples_buffer[0], class_probabilities);
            proba_t highest_proba = class_probabilities[newLabel];
            entry_t* newEntry = (entry_t*)malloc(sizeof(entry_t));
            newEntry->label = newLabel;
            newEntry->proba = highest_proba;
            newEntry->timestamp = get_timestamp();

            // Store newEntry somewhere
            // TODO
            debugMsgBle("Lb: %d\tTime: %d",
                        newEntry->label, newEntry->timestamp);
            // Free memory
            free(newEntry);

        } else {

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


        // Reset count
        count = 0;

        // Return class
        return label;

    } else {
        // Buffer is not full
        return CLASS_NO_CLASS;
    }
}