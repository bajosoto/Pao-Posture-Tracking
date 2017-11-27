#include "classifier.h"

static pdf_handler pdf_handlers[CLF_N] = {
	knn_pdf,
};

static train_handler train_handlers[CLF_N] = {
	knn_train,
};

static uint8_t clf = CLF_KNN;

void postc_init(classifier_t clf_set){
	clf = clf_set;
}

posture_t postc_predict(feature_t sample[DIM]){
	pdf_t classifier = pdf_handlers[clf]
	posture_t detected = (posture_t) 0;
	float cur_pdf,max_pdf = classifier(0,sample);

	for(uint8_t i=1;i<=POSTURE_NCLASSES;i++){
		if((cur_pdf = classifier(0,sample)) > max_pdf){
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
void postc_predict_n(uint8_t n_samples, feature_t samples[n_samples][DIM],posture_t buffer[n_samples]){
	for(uint8_t i=0;i<=n;i++){
		buffer[i] = postc_predict(samples[i]);
	}
}
