import numpy as np
from sklearn import preprocessing
from sklearn.decomposition import PCA

from evaluation.compare import compare, compare_selected, classifiers_all
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH_1 = "../../resource/PostureEntry_DMP_Phil_Monday.csv"
FILE_PATH_2 = "../../resource/PostureEntry_DMP_Sergio_Monday.csv"
FILE_PATH_3 = "../../resource/PostureEntry_DMP_Ozan.csv"

N_VALIDATIONS = 30
samples_raw, labels_raw, label_names = FileReader.readAll([FILE_PATH_1, FILE_PATH_2, FILE_PATH_3])
scores = []
samples_filtered, labels_reduced = PreProcessor.magnitude_theta(samples_raw, labels_raw,5)
samples_features = preprocessing.scale(samples_filtered)

# samples_features = PCA().fit_transform(samples_features)
compare(samples_features, labels_reduced,classifiers_all, N_VALIDATIONS)
