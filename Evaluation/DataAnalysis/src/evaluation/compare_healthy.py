import numpy as np
from sklearn import preprocessing

from evaluation.compare import compare
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH = "../../resource/PostureEntry.csv"
N_VALIDATIONS = 4

samples_raw, labels, label_names = FileReader.read(FILE_PATH)

labels[(labels == 0) | (labels == 2) | (labels == 4)] = 1
labels[(labels != 1)] = 0



samples_features = preprocessing.scale(samples_raw)

compare(samples_features, labels, N_VALIDATIONS)
