#include "knn.h"
#include <string.h>
#include <stdio.h>
#include "mat.h"
static feature_t train_data[MAX_TRAIN][CLF_DIM];
static uint8_t train_labels[MAX_TRAIN];
static uint16_t n_train_samples = 0;
static uint8_t k_neighbors = 1;

static void find_neighbors(feature_t sample[CLF_DIM],uint16_t neighbors[k_neighbors]){
	uint8_t found_neighbors = 0;
	mat_t previous_neighbor_dist = -1*MAT_MAX;
	while(found_neighbors < k_neighbors){
		mat_t min_dist = MAT_MAX;
		for (uint16_t i = 0; i < n_train_samples; i++){
			mat_t sub[CLF_DIM];
			vec_sub(CLF_DIM,sample,train_data[i],sub);
            printf("Train data:\n");
            vec_print(CLF_DIM,train_data[i]);
            printf("Sample:\n");
            vec_print(CLF_DIM,sample);

            mat_t dist = vec_norm(CLF_DIM,sub);
            printf("Dist[%d]: %f\n",i,dist);

			if(dist < min_dist && dist > previous_neighbor_dist){
				neighbors[found_neighbors] = i;
				min_dist = dist;
			}
		}
        found_neighbors++;
		previous_neighbor_dist = min_dist;
	}
}

proba_t knn_pdf(feature_t sample[CLF_DIM],posture_t posture){
	proba_t pdf = 0.0;
	uint16_t neighbors[k_neighbors];
	find_neighbors(sample,neighbors);

    for (uint16_t i=0; i<k_neighbors;i++){
        printf("Neighbor: %d\n",neighbors[i]);
    }
	//get score
	for (uint8_t i=0;i<k_neighbors;i++){
		if(train_labels[neighbors[i]] == posture){
			pdf += 1.0/k_neighbors;
		}
	}
	return pdf;
}

void knn_train(uint16_t n_samples, feature_t sample[n_samples][CLF_DIM], posture_t labels[n_samples]){
	n_train_samples = n_samples;
	for(uint16_t i = 0; i<n_samples; i++ ){
		memcpy(train_data[i],sample[i],CLF_DIM*sizeof(feature_t));
		memcpy(&train_labels[i],&labels[i],sizeof(posture_t));
        printf("Sample: %i, %d\n",i,train_labels[i]);
        vec_print(CLF_DIM,train_data[i]);
	}
}

void knn_init(uint16_t k_neighbors_set){
    k_neighbors = k_neighbors_set;
}





