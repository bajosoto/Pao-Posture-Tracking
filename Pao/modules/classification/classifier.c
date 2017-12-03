#include "classifier.h"
#include "knn.h"

static uint8_t clf;
static pdf_handler pdf_handlers[CLF_N] = {
	knn_pdf,
};

static train_handler train_handlers[CLF_N] = {
	knn_train,
};

static uint8_t clf = CLF_KNN;

static class_t class_max(const proba_t pdfs[CLASS_NCLASSES]){
	class_t detected = (class_t) 0;
	proba_t cur_pdf = 0;
	proba_t max_pdf = PROBA_T_MAX;
	for(uint8_t i=1;i<=CLASS_NCLASSES;i++){
		if(pdfs[i] > max_pdf){
			max_pdf = cur_pdf;
			detected = (class_t) i;
		}
	}

	if( max_pdf > REJECT_THRESHOLD){
		return detected;
	}
	return CLASS_REJECTED;

}

void postc_init(classifier_t clf_set){
	clf = clf_set;
}

class_t postc_predict(feature_t sample[CLF_DIM]){
	pdf_handler classifier = pdf_handlers[clf]

	proba_t pdfs[CLASS_NCLASSES];
	classifier(sample,pdfs);

	return class_max(pdfs);


}
void postc_predict_n(uint8_t n_samples, feature_t samples[n_samples][CLF_DIM],class_t buffer[n_samples]){
	for(uint8_t i=0;i<=n;i++){
		buffer[i] = postc_predict(samples[i]);
	}
}
