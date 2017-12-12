#include "knn.h"
#include <string.h>
#include <stdio.h>
#include <stdbool.h>
#include "mat.h"
static feature_t train_data[MAX_TRAIN][CLF_DIM];
static uint8_t train_labels[MAX_TRAIN];
static uint16_t n_train_samples = 0;
static uint16_t k_neighbors = 1;

static void shift(uint16_t idx, uint16_t len, uint16_t neighbors[len], mat_t distances[len]) {
    for (uint16_t i = len - 1; i > idx; i--) {
        neighbors[i] = neighbors[i - 1];
        distances[i] = distances[i - 1];
    }
}

static void insert_sort(uint16_t idx, mat_t distance, uint16_t len, uint16_t neighbors[len], mat_t distances[len]) {
    mat_t distance_prev = 0;
    for (uint16_t i = 0; i < len; i++) {
        if (distance_prev < distance && distance < distances[i]) {
            shift(i, len, neighbors, distances);
            distances[i] = distance;
            neighbors[i] = idx;
            distance_prev = distances[i];
        }
    }
}

static mat_t euclidian(const feature_t *sample_1,const feature_t *sample_2){
    mat_t sub[CLF_DIM];
    vec_sub(CLF_DIM,sample_1,sample_2,sub);
    return vec_norm(CLF_DIM,sub);
}

static void find_neighbors(const feature_t sample[CLF_DIM],uint16_t neighbors[k_neighbors]){
    mat_t distances[k_neighbors];
    for (uint16_t i = 0; i < k_neighbors; i++) {
        distances[i] = MAT_MAX;
    }
    for (uint16_t i = 0; i < n_train_samples; i++) {

        mat_t dist = euclidian(sample, train_data[i]);
        if (dist < distances[k_neighbors - 1]) {
            insert_sort(i, dist, k_neighbors, neighbors, distances);

        }
    }

}

static proba_t get_score(const uint16_t neighbors[k_neighbors],class_t posture){
    proba_t pdf = 0.0;
    for (uint8_t i=0;i<k_neighbors;i++){
        if(train_labels[neighbors[i]] == posture){
            pdf += 1.0/k_neighbors;
        }
    }
    return pdf;
}

proba_t knn_class_pdf(const feature_t sample[CLF_DIM], class_t posture){
	uint16_t neighbors[k_neighbors];

	find_neighbors(sample,neighbors);

    return get_score(neighbors,posture);
}

void knn_pdf(const feature_t sample[CLF_DIM],proba_t class_probas[CLASS_NCLASSES-1]){
    uint16_t neighbors[k_neighbors];
    memset(neighbors,0,sizeof(uint16_t)*k_neighbors);
    find_neighbors(sample,neighbors);

    // last class is NO_CLASS so we get scores until n-1
    for (uint8_t i=0; i < CLASS_NCLASSES-1; i++){
        class_probas[i] = get_score(neighbors,(class_t)i);
    }
}

void knn_fit(uint16_t n_samples,const feature_t sample[n_samples][CLF_DIM],const class_t labels[CLF_DIM]){
	n_train_samples = n_samples;
	for(uint16_t i = 0; i<n_samples; i++ ){
		memcpy(train_data[i],sample[i],CLF_DIM*sizeof(feature_t));
		memcpy(&train_labels[i],&labels[i],sizeof(class_t));
	}
}

void knn_init(uint16_t k_neighbors_set){
    k_neighbors = k_neighbors_set;
}





