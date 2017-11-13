import numpy as np
from sklearn import preprocessing
from sklearn.decomposition import PCA
from sklearn.ensemble import AdaBoostClassifier
from sklearn.model_selection import train_test_split

from classifier.SeqCombiner import SeqCombiner
from evaluation.compare import compare, compare_selected
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

# FILE_PATH = "../../../../App/Generated-Data/PostureEntry_11_02_chest_sitting.csv"
FILE_PATH_1 = "../../resource/PostureEntry_11_02_back_sit_move_sergio.csv"
FILE_PATH_2 = "../../resource/PostureEntry.csv"
FILE_PATH_3 = "../../resource/PostureEntry_11_02_chest_sitting_phil.csv"

N_VALIDATIONS = 100
samples_raw_1, labels_1, _ = FileReader.read(FILE_PATH_1)
samples_raw_1 = samples_raw_1[(labels_1.ravel() == 0) | (labels_1.ravel() == 1), 0:6]
labels_1 = labels_1[(labels_1.ravel() == 0) | (labels_1.ravel() == 1)]

samples_raw_2, labels_2, _ = FileReader.read(FILE_PATH_2)
samples_raw_2 = samples_raw_2[(labels_2.ravel() == 0) | (labels_2.ravel() == 1), :]
labels_2 = labels_2[(labels_2.ravel() == 0) | (labels_2.ravel() == 1)]

samples_raw_3, labels_3, _ = FileReader.read(FILE_PATH_3)
samples_raw_3 = samples_raw_3[:, 0:6]

samples_raw = np.vstack([samples_raw_1, samples_raw_2])
labels = np.vstack([labels_1, labels_2])
window_size = 20
samples_filtered = PreProcessor.median(samples_raw, window_size)
labels_filtered = labels[0::window_size]
labels_filtered = labels_filtered[:-1]

clf = AdaBoostClassifier()
clf.fit(samples_filtered[0:int(np.floor(samples_filtered.shape[0] / 2)), :],
        labels_filtered[0:int(np.floor(samples_filtered.shape[0] / 2))])

combiner = SeqCombiner(clf)

accuracy = 0
for i in range(int(np.floor(samples_filtered.shape[0]/2))+10, samples_filtered.shape[0]):
    if combiner.predict(samples_filtered[i-10:i, :]) == labels_filtered[i]:
        accuracy += 1

print("Accuracy: {0:.2f}".format(accuracy / (samples_filtered.shape[0]/2)))
