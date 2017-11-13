import numpy as np
from sklearn import preprocessing

from evaluation.compare import compare
from src.filereader.FileReader import FileReader

# FILE_PATH = "../../../../App/Generated-Data/PostureEntry_11_02_chest_sitting.csv"

FILE_PATH = "../../resource/PostureEntry_11_02_back_phil_walk_outside.csv"
N_VALIDATIONS = 4

samples, labels, label_names = FileReader.read(FILE_PATH)
# print(np.unique(labels))
# print(samples[0,:])*/
# print(np.unique(labels))
samples = preprocessing.scale(samples)

compare(samples, labels, N_VALIDATIONS)
