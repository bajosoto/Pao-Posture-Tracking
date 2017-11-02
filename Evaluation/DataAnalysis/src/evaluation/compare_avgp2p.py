import numpy as np
from sklearn import preprocessing
from sklearn.decomposition import PCA

from evaluation.compare import compare
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH = "../../../../App/Generated-Data/PostureEntry_11_02_chest_sitting.csv"
N_VALIDATIONS = 4

samples_raw, labels, label_names = FileReader.read(FILE_PATH)
window_size = 10
average = PreProcessor.average(samples_raw, window_size)
p2p = PreProcessor.peak2peak(samples_raw, window_size)

labels_reduced = labels[0::window_size]
labels_reduced = labels_reduced[:-1]
print(samples_raw[0,:])
samples_features = np.zeros(shape=(int(np.floor(samples_raw.shape[0]/window_size)), 7))
samples_features[:, 0:6] = average[:,0:6]
samples_features[:, 6] = p2p.ravel()

samples_features = preprocessing.scale(samples_features)
compare(samples_features, labels_reduced, N_VALIDATIONS)
