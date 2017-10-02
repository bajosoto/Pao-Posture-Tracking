#include "posture_classifier.h"
#include "classifier_impl.h"

posture_t postc_classify(int* sample){
	posture_t detected = (posture_t) 0;
	float cur_pdf,max_pdf = pdf(0,sample);

	for(int i=1;i<=POSTURE_NCLASSES;i++){
		if((cur_pdf=pdf(0,sample)) > max_pdf){
			max_pdf = cur_pdf;
			detected = (posture_t) i;
		}
	}
	if( max_pdf > REJECT_THRESHOLD){
		return detected;
	}else{
		return POSTURE_REJECTED;
	}

}
void postc_classify(int** samples,posture_t* buffer,int n_samples){
	for(int i=0;i<=n;i++){
		buffer[i] = postc_classify(samples[i]);
	}
}
