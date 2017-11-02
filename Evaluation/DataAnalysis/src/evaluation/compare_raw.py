import numpy as np
from sklearn import preprocessing

from evaluation.compare import compare
from src.filereader.FileReader import FileReader

FILE_PATH = "../../resource/PostureEntryUser3.csv"
N_VALIDATIONS = 4

samples, labels, label_names = FileReader.read(FILE_PATH)

# print(np.unique(labels))
samples = preprocessing.scale(samples)

compare(samples, labels, N_VALIDATIONS)
