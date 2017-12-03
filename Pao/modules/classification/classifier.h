#ifndef POSTURE_CLASSIFIER_H
#define POSTURE_CLASSIFIER_H

#include <inttypes.h>

typedef enum{
	CLASS_HEALTHY=0,
	CLASS_UNHEALTHY,
	/*POSTURE_CONFIDENT,
	POSTURE_UNCONFIDENT,*/
	CLASS_REJECTED,
	CLASS_NCLASSES
}__attribute__((packed)) class_t;

typedef enum{
	CLF_KNN=0,
	CLF_N
}__attribute__((packed)) classifier_t;

#define CLF_DIM 2
#define PROBA_T_MAX (float)(2.0*32768)
typedef float proba_t; 
typedef float feature_t;

typedef void (*pdf_handler)(feature_t[CLF_DIM],proba_t buffer[CLASS_NCLASSES]);
typedef void (*train_handler)(uint16_t n_samples, feature_t sample[n_samples][CLF_DIM],class_t labels[n_samples]);

/*Classificatons that are lower than this threshold
don't get classified at all (rejected)*/
#define REJECT_THRESHOLD 0.01

/**
 * [postc_init choses a certain classifier and initializes the module]
 * @author phil
 * @date   2017-11-27
 * @param  clf        [classifier to be chosen]
 */
void clf_init(classifier_t clf);


/**
 * [postc_train trains the chosen classifier]
 * @author phil
 * @date   2017-11-27
 * @param  n_samples  [number samples]
 * @param  sample     [array with training samples]
 */
void clf_train(uint8_t n_samples, feature_t sample[n_samples][CLF_DIM], class_t labels[n_samples]);

/**
 * [postc_predict returns the classified posture given
 * a certain sample]
 * @author phil
 * @date   2017-09-25
 * @param  sample     [vector containing sample features]
 * @return            [classified posture]
 */
class_t clf_predict(feature_t *sample);

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
void clf_predict_n(uint8_t n_samples, feature_t samples[n_samples][CLF_DIM], class_t buffer[n_samples]);

#endif