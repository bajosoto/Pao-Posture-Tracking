#ifndef CLASSIFIER_H
#define CLASSIFIER_H

#include "posture_classifier.h"

/**
 * [pdf yields the class probability density given a sample ]
 * @author phil
 * @date   2017-09-26
 * @param  class      [class]
 * @param  sample     [feature vector of sample]
 * @return            [value of class pdf at sample]
 */
float pdf(posture_t class, int* sample);

#endif