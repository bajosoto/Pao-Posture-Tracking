#ifndef POSTURE_CLASSIFIER_H
#define POSTURE_CLASSIFIER_H

#include <inttypes.h>

typedef enum{
    CLASS_STILL_HEALTHY = 0,
    CLASS_STILL_UNHEALTHY,
    CLASS_MOVING_HEALTHY,
    CLASS_MOVING_UNHEALTHY,
    CLASS_NO_CLASS,
	CLASS_NCLASSES
} class_t;

typedef enum{
	CLF_KNN=0,
	CLF_N
} classifier_t;

typedef enum{
    TRANSF_SCALE_STD=0,
    TRANSF_N
} transformer_t;

#define MAX_SCALER_N 10

#define IDX_ACCEL_0 0
#define IDX_ACCEL_1 1
#define IDX_ACCEL_2 2
#define IDX_PHI 3
#define IDX_THETA 4

#ifdef PC_COMPILE
#define RAW_DIM 9
#define WINDOW_SIZE 2
#define CLF_DIM 3
#else
#define RAW_DIM 5
#define WINDOW_SIZE 30
#define CLF_DIM 3
#endif

#define PROBA_T_MAX (float)(2.0*32768)
#define FEATURE_T_MAX (float)(2.0*32768)
typedef float proba_t;
typedef float feature_t;

typedef void (*pdf_f)(const feature_t[CLF_DIM], proba_t buffer[CLASS_NCLASSES - 1]);
typedef void (*clf_fit_f)(uint16_t n_samples, const feature_t sample[n_samples][CLF_DIM],const class_t labels[n_samples]);
typedef void (*transf_fit_f)(uint16_t n_samples, const feature_t sample[n_samples][CLF_DIM]);

typedef void (*transform_f)(const feature_t sample[CLF_DIM], feature_t sample_transformed[CLF_DIM]);


/**
 * Classificatons that are lower than this threshold
 * don't get classified at all (rejected)
 */
#define REJECT_THRESHOLD 0

/**
 * [clf_init choses a certain classifier, scaler and preprocessor to initialize the module]
 * @author phil
 * @date   2017-11-27
 * @param  clf        [classifier to be chosen]
 * @param  n_transformer   [number of scalers to be chosen. Must not exceed MAX_SCALER_N!]
 * @param  transformer    [scalers to be chosen]
 */
void clf_init(classifier_t clf,uint8_t n_transformer,const transformer_t transformer[n_transformer]);


/**
 * [clf_fit trains the chosen classifier]
 * @author phil
 * @date   2017-11-27
 * @param  n_samples  [number samples]
 * @param  sample     [array with training samples]
 */
void clf_fit(uint16_t n_samples,const feature_t sample[n_samples][CLF_DIM],const class_t labels[n_samples]);

/**
 * [clf_predict returns the classified posture given
 * a certain sample]
 * @author phil
 * @date   2017-09-25
 * @param  sample     [vector containing sample features]
 * @return            [classified posture]
 */
class_t clf_predict(const feature_t sample[CLF_DIM]);

/**
 * [clf_predict_proba predicts class probabilities]
 * @param sample      [sample to classify]
 * @param probas      [return value with probability for each class, enum serves as index]
 * @return            [classified posture]
 */
class_t clf_predict_proba(const feature_t sample[CLF_DIM],proba_t probas[CLASS_NCLASSES]);

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
void clf_predict_n(uint16_t n_samples, const feature_t samples[n_samples][CLF_DIM], class_t buffer[n_samples]);

#endif