#ifndef POSTURE_CLASSIFIER_H
#define POSTURE_CLASSIFIER_H

#include <inttypes.h>

typedef enum{
	POSTURE_HEALTHY=0,
	POSTURE_UNHEALTHY,
	/*POSTURE_CONFIDENT,
	POSTURE_UNCONFIDENT,*/
	POSTURE_REJECTED,
	POSTURE_NCLASSES
}__attribute__((packed)) posture_t;

typedef enum{
	CLF_KNN=0,
	CLF_N
}__attribute__((packed)) classifier_t;

#define CLF_DIM 2
typedef float proba_t; 
typedef float feature_t;

typedef proba_t(*pdf_handler)(feature_t[CLF_DIM],posture_t);
typedef void(*train_handler)(uint8_t n_samples, feature_t sample[n_samples][CLF_DIM]);

/*Classificatons that are lower than this threshold
don't get classified at all (rejected)*/
#define REJECT_THRESHOLD 0.01

/**
 * [postc_init choses a certain classifier and initializes the module]
 * @author phil
 * @date   2017-11-27
 * @param  clf        [classifier to be chosen]
 */
void postc_init(classifier_t clf);


/**
 * [postc_train trains the chosen classifier]
 * @author phil
 * @date   2017-11-27
 * @param  n_samples  [number samples]
 * @param  sample     [array with training samples]
 */
void postc_train(uint8_t n_samples, feature_t sample[n_samples][CLF_DIM]);

/**
 * [postc_predict returns the classified posture given
 * a certain sample]
 * @author phil
 * @date   2017-09-25
 * @param  sample     [vector containing sample features]
 * @return            [classified posture]
 */
posture_t postc_predict(feature_t sample[CLF_DIM]);

/**
 * [postc_predict_n wrapper for postc_predict to classify
 * bunch of samples]
 * @author phil
 * @date   2017-09-25
 * @param  samples    [[n x m] array every line corresponds to one sample]
 * @param  buffer     [output buffer, 1d array with n elements]
 * @param  n_samples  [number of samples]
 * 
 */
void postc_predict_n(uint8_t n_samples, feature_t samples[n_samples][CLF_DIM],posture_t buffer[n_samples]);

#endif