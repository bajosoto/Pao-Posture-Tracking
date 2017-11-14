import numpy as np
from matplotlib.pyplot import figure, plot, show, legend, xlabel, ylabel, title, errorbar, annotate
from sklearn import preprocessing
from sklearn.decomposition import PCA
from sklearn.model_selection import KFold

from evaluation.compare import compare, compare_selected, classifiers_subset
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH_1 = "../../resource/PostureEntry_DMP_Phil_Monday.csv"
FILE_PATH_2 = "../../resource/PostureEntry_DMP_Sergio_Monday.csv"

N_VALIDATIONS = 20
samples_raw, labels_raw, _ = FileReader.readAll([FILE_PATH_1, FILE_PATH_2])

window_size = 20

scores = []
samples_filtered, labels_reduced = PreProcessor.average(samples_raw, labels_raw, window_size)
np.hstack((samples_filtered, PreProcessor.peak2peak(samples_raw, window_size)))
samples_features = preprocessing.scale(samples_filtered)

for train_idx, test_idx in KFold(samples_filtered.shape[0], N_VALIDATIONS).split(samples_raw, labels_raw):
    for i, name in enumerate(classifiers_subset):
        classifiers_subset[name].fit(samples_filtered[train_idx])
        prediction = classifiers_subset[name].f

