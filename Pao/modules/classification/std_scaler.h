//
// Created by phil on 4-12-17.
//

#ifndef PAO_SCALER_H
#define PAO_SCALER_H

#include "classifier.h"
/**
 * Fits the scaler model on the data.
 * Min and max value for each feature are calculated.
 *
 * @param n_samples: number of samples
 * @param samples: array with nxm elements where n is n_samples and m is the feature dimension
 * @param labels: array with labels for each sample
 * @author phil
 */
void stds_fit(uint16_t n_samples, feature_t samples[n_samples][CLF_DIM], class_t labels[n_samples]);

/**
 * Transforms the data according to the fitted parameters.
 * Data gets centered around mean and scaled between 0 and 1
 *
 * @param n_samples: number of samples
 * @param sample: array with nxm elements where n is n_samples and m is the feature dimension
 * @param labels: array with labels for each sample
 */
void stds_transform(uint16_t n_samples, feature_t samples[n_samples][CLF_DIM], class_t labels[n_samples]);
#endif //PAO_SCALER_H
