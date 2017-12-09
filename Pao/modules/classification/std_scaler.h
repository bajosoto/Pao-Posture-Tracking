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
void stds_fit(uint16_t n_samples, feature_t samples[n_samples][CLF_DIM]);

/**
 * Transforms the data according to the fitted parameters.
 * Data gets centered around mean and scaled between 0 and 1
 *
 * @param sample: sample as array in dimension of features
 */
void stds_transform(const feature_t sample[CLF_DIM], feature_t sample_transformed[CLF_DIM]);

/**
 * Transforms the data according to the fitted parameters.
 * Data gets centered around mean and scaled between 0 and 1
 *
 * @param n_samples: number of samples
 * @param samples: array with nxm elements where n is n_samples and m is the feature dimension
 */
void stds_transform_n(uint16_t n_samples, const feature_t samples[n_samples][CLF_DIM],
                      feature_t samples_transformed[n_samples][CLF_DIM]);

#endif //PAO_SCALER_H
