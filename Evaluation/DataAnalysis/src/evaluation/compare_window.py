import numpy as np
from sklearn import preprocessing

from evaluation.compare import compare
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH = "../../resource/PostureEntry.csv"
N_VALIDATIONS = 4

# FILE_PATH = "../../../../App/Generated-Data/PostureEntry_11_02_chest_sitting.csv"
FILE_PATH_1 = "../../resource/PostureEntry_11_02_back_sit_move_sergio.csv"
# FILE_PATH_2 = "../../resource/PostureEntry_11_02_back_phil_walk_outside.csv"
FILE_PATH_3 = "../../resource/PostureEntry_11_02_chest_sitting_phil.csv"


samples_raw_1, labels_1, _ = FileReader.read(FILE_PATH_1)
samples_raw_1 = samples_raw_1[(labels_1.ravel() == 0) | (labels_1.ravel() == 1), :]
labels_1 = labels_1[(labels_1.ravel() == 0) | (labels_1.ravel() == 1)]

#samples_raw_2, labels_2, _ = FileReader.read(FILE_PATH_2)
samples_raw_3, labels_3, _ = FileReader.read(FILE_PATH_3)

samples_raw = np.vstack([samples_raw_1, samples_raw_3])
labels = np.vstack([labels_1, labels_3])
window_size = 20
window = PreProcessor.merge_window(samples_raw, window_size)
# p2p = PreProcessor.peak2peak(samples_raw, window_size)

labels_reduced = labels[0::window_size]
labels_reduced = labels_reduced[:-1]

samples_features = window

samples_features = preprocessing.scale(samples_features)

compare(samples_features, labels_reduced, N_VALIDATIONS)
