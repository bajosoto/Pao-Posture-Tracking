//
// Created by phil on 11-12-17.
//

#ifndef PAO_CLASSIFIER_INTERFACE_H_H
#define PAO_CLASSIFIER_INTERFACE_H_H


#include "classifier.h"

class_t process_new_sample(class_t label);
void finish_training();
uint16_t train_label;


#endif //PAO_CLASSIFIER_INTERFACE_H_H
