#include "knn.h"
#include <string.h>
#include <stdio.h>
#include <stdbool.h>
#include "mat.h"
static feature_t train_data[MAX_TRAIN][CLF_DIM];
static uint8_t train_labels[MAX_TRAIN];
static uint16_t n_train_samples = 0;
static uint16_t k_neighbors = 1;

static bool contains(uint16_t element, uint16_t len, const uint16_t array[len]){
    for(uint16_t j = 0; j < len; j++){
        if (array[j] == element){
            return true;
        }
    }
    return false;
}

static mat_t euclidian(feature_t *sample_1, feature_t *sample_2){
    mat_t sub[CLF_DIM];
    vec_sub(CLF_DIM,sample_1,sample_2,sub);
    return vec_norm(CLF_DIM,sub);
}

static void find_neighbors(feature_t sample[CLF_DIM],uint16_t neighbors[k_neighbors]){
	uint8_t found_neighbors = 0;
	while(found_neighbors < k_neighbors){
		mat_t min_dist = MAT_MAX;
		for (uint16_t i = 0; i < n_train_samples; i++){

            mat_t dist = euclidian(sample, train_data[i]);
			if( dist < min_dist){

                if (!contains(i,found_neighbors,neighbors)){
                    neighbors[found_neighbors] = i;
                    min_dist = dist;
                }

			}
		}
        found_neighbors++;
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

proba_t knn_class_pdf(feature_t sample[CLF_DIM], class_t posture){
	uint16_t neighbors[k_neighbors];

	find_neighbors(sample,neighbors);

    return get_score(neighbors,posture);
}

void knn_pdf(feature_t sample[CLF_DIM],proba_t class_probas[CLASS_NCLASSES]){
    uint16_t neighbors[k_neighbors];

    find_neighbors(sample,neighbors);

    for (uint8_t i=0; i < CLASS_NCLASSES; i++){
        class_probas[i] = get_score(neighbors,(class_t)i);
    }
}

void knn_fit(uint16_t n_samples, feature_t sample[n_samples][CLF_DIM], class_t labels[CLF_DIM]){
	n_train_samples = n_samples;
	for(uint16_t i = 0; i<n_samples; i++ ){
		memcpy(train_data[i],sample[i],CLF_DIM*sizeof(feature_t));
		memcpy(&train_labels[i],&labels[i],sizeof(class_t));
	}
}

void knn_init(uint16_t k_neighbors_set){
    k_neighbors = k_neighbors_set;
}





