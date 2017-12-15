//
// Created by phil on 11-12-17.
//

#ifndef PAO_CLASSIFIER_INTERFACE_H_H
#define PAO_CLASSIFIER_INTERFACE_H_H


#include "classifier.h"

class_t process_new_sample(class_t label);
void finish_training();
uint16_t train_label;
void reset_train_buffer();
void finish_training();

class_t process_new_sample(class_t label);
char    training_enabled ;

#endif //PAO_CLASSIFIER_INTERFACE_H_H
