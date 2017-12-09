#ifndef KNN_H
#define KNN_H

#include "classifier.h"

#define MAX_TRAIN 100
proba_t knn_class_pdf(feature_t sample[CLF_DIM], class_t);
void knn_fit(uint16_t n_samples, feature_t sample[n_samples][CLF_DIM], class_t labels[CLF_DIM]);
void knn_init(uint16_t k_neighbors_set);
void knn_pdf(feature_t sample[CLF_DIM], proba_t class_probas[CLASS_NCLASSES]);
#endif