import numpy as np
from sklearn.model_selection import train_test_split
from hmmlearn.hmm import GaussianHMM, GMMHMM
from filereader.FileReader import FileReader
from preprocessing.PreProcessor import PreProcessor

FILE_PATH_1 = "../../resource/PostureEntry_11_02_back_sit_stand_phil.csv"

N_VALIDATIONS = 6

samples_raw_1, labels_1, _ = FileReader.read(FILE_PATH_1)
samples_raw_1 = samples_raw_1[(labels_1.ravel() == 0) | (labels_1.ravel() == 1), 0:6]
labels_1 = labels_1[(labels_1.ravel() == 0) | (labels_1.ravel() == 1)]

window_size = 100

X_train, X_test, y_train, y_test = train_test_split(samples_raw_1, labels_1, train_size=0.6)

samples_healthy = X_train[y_train.ravel() == 0, :]
samples_unhealthy = X_train[y_train.ravel() == 1, :]

model_healthy = GMMHMM()
model_unhealthy = GMMHMM()

seqs, lengths = PreProcessor.split2sequences(samples_healthy, window_size)
model_healthy.fit(seqs, lengths)

seqs, lengths = PreProcessor.split2sequences(samples_unhealthy, window_size)
model_unhealthy.fit(seqs, lengths)

seqs, lengths = PreProcessor.split2sequences(X_test, window_size)
accuracy = 0
for i in range(0, len(lengths)):
    ll_healthy, post_healthy = model_healthy.score_samples(seqs[i*window_size:(i+1)*window_size,:])
    ll_unhealthy, post_unhealthy = model_unhealthy.score_samples(seqs[i*window_size:(i+1)*window_size,:])

    print("[" + str(ll_unhealthy) + "|" + str(ll_unhealthy) + "]")
    prediction_sample = 0 if ll_healthy > ll_unhealthy else 0
    if prediction_sample == y_test[i*window_size]:
       accuracy += 1/len(lengths)

print("Accuracy: " + str(accuracy))
