#ifndef POSTURE_CLASSIFIER_H
#define POSTURE_CLASSIFIER_H

typedef enum{
	POSTURE_STANDING_UPRIGHT=0,
	POSTURE_STANDING_CROUCHED,
	POSTURE_SITTING_UPRIGHT,
	POSTURE_SITTING_CROUCHED,
	POSTURE_SITTING_CONFIDENT,
	POSTURE_STANDING_CONFIDENT,
	POSTURE_SITTING_UNCONFIDENT,
	POSTURE_STANDING_UNCONFIDENT,
	N_POSTURES
}__attribute__((packed)) posture_t;

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