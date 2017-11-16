import numpy as np
from sklearn import preprocessing
from sklearn.decomposition import PCA

from evaluation.compare import compare, compare_selected
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

# FILE_PATH = "../../../../App/Generated-Data/PostureEntry_11_02_chest_sitting.csv"
FILE_PATH_1 = "../../resource/PostureEntry_DMP_Phil_Monday.csv"
FILE_PATH_2 = "../../resource/PostureEntry_DMP_Sergio_Monday.csv"

N_VALIDATIONS = 20
samples_raw, labels_raw, _ = FileReader.readAll([FILE_PATH_1])

window_size = 20
average, labels_reduced = PreProcessor.median(samples_raw, labels_raw, window_size)
p2p = PreProcessor.peak2peak(samples_raw, window_size)

samples_features = np.zeros(shape=(int(np.floor(samples_raw.shape[0] / window_size)), 9))
samples_features[:, 0:9] = average[:, 0:9]
# samples_features[:, 6] = p2p.ravel()

samples_features = preprocessing.scale(samples_features)

# samples_features = PCA().fit_transform(samples_features)
compare_selected(samples_features, labels_reduced, N_VALIDATIONS)
