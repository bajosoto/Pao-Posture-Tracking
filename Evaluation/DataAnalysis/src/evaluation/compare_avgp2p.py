import numpy as np
from sklearn import preprocessing

from evaluation.compare import compare
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH = "../../resource/PostureEntry.csv"
N_VALIDATIONS = 4

samples_raw, labels, label_names = FileReader.read(FILE_PATH)
window_size = 10
average = PreProcessor.average(samples_raw, window_size)
p2p = PreProcessor.peak2peak(samples_raw, window_size)

labels_reduced = labels[0::window_size]
# labels_reduced = labels_reduced[:-(labels.shape[0] % window_size)]

samples_features = np.zeros(shape=(int(np.floor(samples_raw.shape[0]/10)), 7))
samples_features[:, 0:6] = average
samples_features[:, 6] = p2p.ravel()

samples_features = preprocessing.scale(samples_features)

compare(samples_features, labels_reduced, N_VALIDATIONS)
