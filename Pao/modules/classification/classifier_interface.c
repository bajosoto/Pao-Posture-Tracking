
#include "classifier_interface.h"
#include "pao.h"
#include "vibrator.h"

#define TRAINING_SET_SIZE       (4 * TRAINING_TIME * SAMPLING_FREQ) / WINDOW_SIZE 
#define SECS_IN_BAD_POSTURE     5

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

void notify_posture(class_t label) {
    static int16_t badPostCnt = 0;
    static class_t prevPost = CLASS_NO_CLASS;

    if(label != prevPost) {
        prevPost = label;
        badPostCnt = 0;
    } else {
        if(label == CLASS_STILL_UNHEALTHY || label == CLASS_MOVING_UNHEALTHY) {
            badPostCnt += 1;
        }
        if(badPostCnt >= SECS_IN_BAD_POSTURE) {
            badPostCnt = 1;
            buzz(25);
        }
    }
    // debugMsgBle("Bad Cnt: %d", badPostCnt);
}

class_t process_new_sample(class_t label, entry_t* newEntry){

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
        //debugMsg("b%d,%d,%d,%d", label, (int16_t)(samples_buffer[0][0]), (int16_t)(samples_buffer[0][1]), (int16_t)(samples_buffer[0][2]));


        // label != CLASS_NO_CLASS means we're training, otherwise we're classifying
        if(label == CLASS_NO_CLASS) {
            class_t newLabel = clf_predict_proba(processed_samples_buffer[0], class_probabilities);
            proba_t highest_proba = class_probabilities[newLabel];
            //entry_t* newEntry = (entry_t*)malloc(sizeof(entry_t));    // Now initialized in main
            newEntry->label = newLabel;
            newEntry->proba = highest_proba;
            newEntry->timestamp = get_timestamp();
            // for(int i = 0; i < CLASS_NCLASSES; i++) {
            //     debugMsg("%d, ", (int16_t)(class_probabilities[i] * 100));
            // }
            // Store newEntry somewhere
            // TODO
            
            // Free memory
            // free(newEntry);

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
            //debugMsg("phi: %d\tthe: %d\tmag: %d\t", (int32_t)(processed_samples_buffer[0][0]), (int32_t)(processed_samples_buffer[0][1]), (int32_t)(processed_samples_buffer[0][2]));

            //debugMsgBle("lbl: %d cnt: %d", label, counter_train);

            // Calculate new pointer
            counter_train = (((counter_train - offset) + 1) % (TRAINING_SET_SIZE / 4)) + offset;

            if(counter_train % offset == 0) {
                buzz(25);
            }
        }


        // Reset counter_buffer
        counter_buffer = 0;

        // Return class
        return newEntry->label;

    } else {
        // Buffer is not full
        return CLASS_NO_CLASS;
    }
}