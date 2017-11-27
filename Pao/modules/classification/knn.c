#include "knn.h"
#include <string.h>
#include "mat.h"
static feature_t train_data[MAX_TRAIN][CLF_DIM];
static uint8_t train_labels[MAX_TRAIN];
static uint16_t n_train_samples = 0;
static uint8_t k_neighbors = 1;

proba_t knn_pdf(feature_t sample[CLF_DIM],posture_t posture){
	float pdf = 0.0;
	for(uint16_t i=0; i < n_train_samples; i++){

	}
	return pdf;
}

void knn_train(uint8_t n_samples, feature_t sample[n_samples][CLF_DIM], uint8_t labels[n_samples]){
	n_train_samples = n_samples;
	for(uint16_t i = 0; i<n_samples; i++ ){
		memcpy(train_data[i],sample,CLF_DIM*sizeof(feature_t));
		memcpy(&train_labels[i],&labels[i],sizeof(uint8_t));

	}
}

static void find_neighbors(feature_t sample[CLF_DIM],feature_t neighbors[k_neighbors][CLF_DIM]){
	uint8_t found_neighbors = 0;
	while(found_neighbors < k_neighbors){
		
		feature_t res_smallest[CLF_DIM];
		vec_sub(CLF_DIM,sample,neighbors[found_neighbors],res_smallest);
		feature_t norm_smallest = vec_norm(CLF_DIM,res_smallest);

		for (uint8_t i=0; i < n_samples; i++){
			i
		}
	}
}

static void insert_sort(feature_t new[CLF_DIM],feature_t neighbors[k_neighbors][CLF_DIM]){
	feature_t res_this[CLF_DIM];
	vec_sub(CLF_DIM,new,neighbors[0],res_this);
	feature_t norm_this = vec_norm(CLF_DIM,res_this);
	

	for (uint8_t i=0; i<k_neighbors; i++){
		feature_t res_next[CLF_DIM];
		vec_sub(CLF_DIM,new,neighbors[i],res_next);
		feature_t norm_next = vec_norm(CLF_DIM,res_next);
		if ( norm_this > norm_next){
			insert(new,i,neighbors);
			return;
		}
		norm_this = norm_next;
	}
	insert(new,k_neighbors,neighbors);
}

static void insert(feature_t new[CLF_DIM],uint8_t n, feature_t neighbors[k_neighbors][CLF_DIM]){

	for (uint8_t i=k_neighbors-1; i>=n; i--){
		memcpy(neighbors[i+1],neighbors[i],CLF_DIM*sizeof(feature_t));
	}
	memcpy(neighbors[n],new,CLF_DIM*sizeof(feature_t));

}
