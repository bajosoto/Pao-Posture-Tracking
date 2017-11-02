import numpy as np
from sklearn import preprocessing

from evaluation.compare import compare
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH = "../../resource/PostureEntryUser3.csv"
N_VALIDATIONS = 4

samples_raw, labels, label_names = FileReader.read(FILE_PATH)

labels[(labels == 0) | (labels == 2) | (labels == 4)] = 0
labels[(labels != 0)] = 1

window_size = 10
average = PreProcessor.average(samples_raw, window_size)

labels_reduced = labels[0::window_size]
labels_reduced = labels_reduced[:-1]

samples_features = np.zeros(shape=(int(np.floor(samples_raw.shape[0]/window_size)), 6))
samples_features[:, 0:6] = average

samples_features = preprocessing.scale(samples_raw)

compare(samples_features, labels, N_VALIDATIONS)
