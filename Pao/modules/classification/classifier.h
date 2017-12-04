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

typedef enum{
    TRANSF_SCALE_STD=0,
    TRANSF_PREP_AVG_MAGN=0,
    TRANSF_N
}__attribute__((packed)) transformer_t;

#define MAX_SCALER_N 10

#define CLF_DIM 2
#define PROBA_T_MAX (float)(2.0*32768)
#define FEATURE_T_MAX (float)(2.0*32768)
typedef float proba_t;
typedef float feature_t;

typedef void (*pdf_f)(feature_t[CLF_DIM],proba_t buffer[CLASS_NCLASSES]);
typedef void (*clf_fit_f)(uint16_t n_samples, feature_t sample[n_samples][CLF_DIM],class_t labels[n_samples]);
typedef void (*transf_fit_f)(uint16_t n_samples, feature_t sample[n_samples][CLF_DIM]);
typedef void (*transform_f)(feature_t sample[CLF_DIM]);

/**
 * Classificatons that are lower than this threshold
 * don't get classified at all (rejected)
 */
#define REJECT_THRESHOLD 0.01

/**
 * [clf_init choses a certain classifier, scaler and preprocessor to initialize the module]
 * @author phil
 * @date   2017-11-27
 * @param  clf        [classifier to be chosen]
 * @param n_scalers   [number of scalers to be chosen. Must not exceed MAX_SCALER_N!]
 * @param  scalers    [scalers to be chosen]
 */
void clf_init(classifier_t clf,uint8_t n_scalers,transformer_t scalers[n_scalers]);


/**
 * [clf_fit trains the chosen classifier]
 * @author phil
 * @date   2017-11-27
 * @param  n_samples  [number samples]
 * @param  sample     [array with training samples]
 */
void clf_fit(uint16_t n_samples, feature_t sample[n_samples][CLF_DIM], class_t labels[n_samples]);

/**
 * [clf_predict returns the classified posture given
 * a certain sample]
 * @author phil
 * @date   2017-09-25
 * @param  sample     [vector containing sample features]
 * @return            [classified posture]
 */
class_t clf_predict(feature_t sample[CLF_DIM]);

/**
 * [clf_predict_n wrapper for postc_predict to classify
 * bunch of samples]
 * @author phil
 * @date   2017-09-25
 * @param  samples    [[n x m] array every line corresponds to one sample]
 * @param  buffer     [output buffer, 1d array with n elements]
 * @param  n_samples  [number of samples]
 * 
 */
void clf_predict_n(uint16_t n_samples, feature_t samples[n_samples][CLF_DIM], class_t buffer[n_samples]);

#endif