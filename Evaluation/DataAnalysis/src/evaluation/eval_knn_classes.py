import numpy as np
from matplotlib.pyplot import figure, plot, show, title, xlabel, ylabel
from sklearn import preprocessing
from sklearn.decomposition import PCA
from sklearn.feature_selection import SelectKBest
from sklearn.model_selection import cross_val_score
from sklearn.neighbors import KNeighborsClassifier
from sklearn.pipeline import Pipeline

from evaluation.compare import compare, compare_selected, classifiers_all
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH_1 = "../../resource/PostureEntry_DMP_Phil_Monday.csv"
FILE_PATH_2 = "../../resource/PostureEntry_DMP_Sergio_Monday.csv"
FILE_PATH_3 = "../../resource/PostureEntry_DMP_Ozan.csv"

N_VALIDATIONS = 30
samples_raw, labels_raw, label_names = FileReader.readAll([FILE_PATH_1, FILE_PATH_2, FILE_PATH_3])

labels_raw[labels_raw == 2] = 0
labels_raw[labels_raw == 3] = 1

# samples_filtered, labels_reduced = PreProcessor.average(samples_raw, labels_raw, window_size)
samples_features = preprocessing.scale(samples_raw)

print(str(cross_val_score(KNeighborsClassifier(5, metric='manhattan', algorithm='kd_tree'), samples_features,
                          labels_raw.ravel(), cv=N_VALIDATIONS).mean()))
