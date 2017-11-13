import numpy as np
from sklearn import preprocessing

from evaluation.compare import compare
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH = "../../resource/PostureEntry.csv"
N_VALIDATIONS = 4

FILE_PATH_1 = "../../resource/PostureEntry_11_02_back_sit_stand_phil.csv"


samples_raw, labels, _ = FileReader.read(FILE_PATH_1)

samples_raw = samples_raw[:, 0:6]

window_size = 50
window = PreProcessor.merge_window(samples_raw, window_size)
# p2p = PreProcessor.peak2peak(samples_raw, window_size)

labels_reduced = labels[0::window_size]
labels_reduced = labels_reduced[:-1]

samples_features = window

samples_features = preprocessing.scale(samples_features)

compare(samples_features, labels_reduced, N_VALIDATIONS)
