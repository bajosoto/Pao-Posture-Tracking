#include <lzma.h>
#include "classifier.h"
#include "knn.h"
#include "std_scaler.h"
#include <stdio.h>
static uint8_t clf;
static pdf_f pdf_fs[CLF_N] = {
	knn_pdf,
};

static fit_f clf_fit_fs[CLF_N] = {
	knn_fit,
};

static fit_f scaler_fit_fs[SCALER_N] = {
        stds_fit,
};
static fit_f scalers[MAX_SCALER_N] = {NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};

static uint8_t clf = CLF_KNN;

static class_t class_max(const proba_t pdfs[CLASS_NCLASSES]){
	class_t detected = (class_t) 0;
	proba_t max_pdf = -1*PROBA_T_MAX;
	for(uint8_t i = 0; i <= CLASS_NCLASSES; i++){
		if(pdfs[i] > max_pdf){
			max_pdf = pdfs[i];
			detected = (class_t) i;
		}
	}

	if( max_pdf > REJECT_THRESHOLD){
		return detected;
	}
	return CLASS_REJECTED;

}

void clf_init(classifier_t clf_set,uint8_t n_scalers,scaler_t scalers_set[n_scalers]){
	clf = clf_set;
    for (int i = 0; i < n_scalers; i++){
        scalers[i] = scaler_fit_fs[scalers_set[i]];
    }
}

class_t clf_predict(feature_t sample[CLF_DIM]){
	pdf_f classifier = pdf_fs[clf];

	proba_t pdfs[CLASS_NCLASSES];
	classifier(sample,pdfs);

	return class_max(pdfs);


}

void clf_fit(uint16_t n_samples, feature_t sample[n_samples][CLF_DIM], class_t labels[n_samples]){

    for (int i = 0; i < MAX_SCALER_N; i++){
        if (scalers[i] != NULL){
            scalers[i](n_samples,sample,labels);
        }
    }

    return clf_fit_fs[clf](n_samples,sample,labels);
}

void clf_predict_n(uint16_t n_samples, feature_t samples[n_samples][CLF_DIM], class_t buffer[n_samples]){
	for(uint8_t i=0;i<=n_samples;i++){
		buffer[i] = clf_predict(samples[i]);
	}
}
