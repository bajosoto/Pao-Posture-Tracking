#ifndef KNN_H
#define KNN_H

#include "classifier.h"

#define MAX_TRAIN 100
proba_t knn_pdf(feature_t sample[CLF_DIM],posture_t);
void knn_train(uint16_t n_samples, feature_t sample[n_samples][CLF_DIM], posture_t labels[n_samples]);
void knn_init(uint16_t k_neighbors_set);
#endif