#ifndef POSTURE_CLASSIFIER_H
#define POSTURE_CLASSIFIER_H

typedef enum{
	POSTURE_HEALTHY=0,
	POSTURE_UNHEALTHY,
	/*POSTURE_CONFIDENT,
	POSTURE_UNCONFIDENT,*/
	POSTURE_REJECTED,
	POSTURE_NCLASSES
}__attribute__((packed)) posture_t;


/*Classificatons that are lower than this threshold
don't get classified at all (rejected)*/
#define REJECT_THRESHOLD 0.01

/**
 * [postc_classify returns the classified posture given
 * a certain sample]
 * @author phil
 * @date   2017-09-25
 * @param  sample     [vector containing sample features]
 * @return            [classified posture]
 */
posture_t postc_classify(int* sample);

/**
 * [postc_classify wrapper for postc_classify to classify
 * bunch of samples]
 * @author phil
 * @date   2017-09-25
 * @param  samples    [[n x m] array every line corresponds to one sample]
 * @param  buffer     [output buffer, 1d array with n elements]
 * @param  n_samples  [number of samples]
 * 
 */
void postc_classify(int** samples,posture_t* buffer,int n_samples);

#endif