import numpy as np
from sklearn import preprocessing
from sklearn.decomposition import PCA

from evaluation.compare import compare, compare_selected
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

# FILE_PATH = "../../../../App/Generated-Data/PostureEntry_11_02_chest_sitting.csv"
FILE_PATH_1 = "../../resource/PostureEntry_11_02_back_sit_move_sergio.csv"
FILE_PATH_2 = "../../resource/PostureEntry.csv"
FILE_PATH_3 = "../../resource/PostureEntry_11_02_chest_sitting_phil.csv"

N_VALIDATIONS = 20
samples_raw_1, labels_1, _ = FileReader.read(FILE_PATH_1)
#samples_raw_1 = samples_raw_1[(labels_1.ravel() == 0) | (labels_1.ravel() == 1), 0:6]
#labels_1[(labels_1.ravel() == 5)] = 3
#labels_1[(labels_1.ravel() == 6)] = 4

samples_raw_1 = samples_raw_1[:, 0:6]

samples_raw_2, labels_2, _ = FileReader.read(FILE_PATH_2)
# samples_raw_2 = samples_raw_2[(labels_2.ravel() == 0) | (labels_2.ravel() == 1), :]
# labels_2 = labels_2[(labels_2.ravel() == 0) | (labels_2.ravel() == 1)]
# labels_2[(labels_2.ravel() == 5)] = 3
# labels_2[(labels_2.ravel() == 6)] = 4

samples_raw_3, labels_3, _ = FileReader.read(FILE_PATH_3)
samples_raw_3 = samples_raw_3[:, 0:6]

samples_raw = np.vstack([samples_raw_1, samples_raw_2, samples_raw_3])
labels = np.vstack([labels_1, labels_2, labels_3])
window_size = 40
average,labels_reduced = PreProcessor.average(samples_raw,labels, window_size)
p2p = PreProcessor.peak2peak(samples_raw, window_size)

samples_features = np.zeros(shape=(int(np.floor(samples_raw.shape[0] / window_size)), 6))
samples_features[:, 0:6] = average[:, 0:6]
# samples_features[:, 6] = p2p.ravel()

samples_features = preprocessing.scale(samples_features)

# samples_features = PCA().fit_transform(samples_features)
compare_selected(samples_features, labels_reduced, N_VALIDATIONS)
