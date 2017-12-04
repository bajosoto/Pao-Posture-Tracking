#include <lzma.h>
#include "classifier.h"
#include "knn.h"
#include "std_scaler.h"
#include <stdio.h>
static uint8_t clf;
static transformer_t scalers[MAX_SCALER_N];
static uint8_t n_scalers = 0;
static pdf_f pdf_fs[CLF_N] = {
	knn_pdf,
};

static clf_fit_f clf_fit_fs[CLF_N] = {
	knn_fit,
};

static transf_fit_f transf_fit_fs[TRANSF_N] = {
        stds_fit,
};

static transform_f transform_fs[TRANSF_N] = {
        stds_transform
};

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

void clf_init(classifier_t clf_set,uint8_t n_transformer,transformer_t transformer[n_scalers]){
	clf = clf_set;
    n_scalers = n_transformer;
    for (int i = 0; i < n_scalers; i++){
        scalers[i] = transformer[i];
    }
}

class_t clf_predict(feature_t sample[CLF_DIM]){
	// TODO transformations should not work on the input array
    for (uint8_t j = 0; j < n_scalers; j++){
        transform_fs[scalers[j]](sample);
    }

    pdf_f classifier = pdf_fs[clf];

	proba_t pdfs[CLASS_NCLASSES];
	classifier(sample,pdfs);

	return class_max(pdfs);


}

void clf_fit(uint16_t n_samples, feature_t sample[n_samples][CLF_DIM], class_t labels[n_samples]){

    for (int i = 0; i < n_scalers; i++){
        transf_fit_fs[scalers[i]](n_samples,sample);
    }

    for (int i = 0; i < n_scalers; i++){
        for (int j = 0; j < n_samples; j++){
            transform_fs[scalers[i]](sample[j]);
        }
    }

    return clf_fit_fs[clf](n_samples,sample,labels);
}

void clf_predict_n(uint16_t n_samples, feature_t samples[n_samples][CLF_DIM], class_t buffer[n_samples]){
	for(uint8_t i = 0; i <= n_samples; i++){
        buffer[i] = clf_predict(samples[i]);
	}
}
