import numpy as np
from sklearn import preprocessing

from evaluation.compare import compare
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH = "../../resource/PostureEntry.csv"
N_VALIDATIONS = 4

samples_raw, labels, label_names = FileReader.read(FILE_PATH)

labels = labels[(labels == 4) | (labels == 5)]

samples_raw = samples_raw[(labels == 4) | (labels == 5), :]

# determine g when calibrating
# determine upright angle
# put threshold on angles

samples_features = preprocessing.scale(samples_raw)

compare(samples_features, labels, N_VALIDATIONS)