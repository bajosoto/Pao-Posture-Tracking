import numpy as np
from matplotlib.pyplot import figure, plot, show, legend, xlabel, ylabel, title, errorbar, annotate
from sklearn import preprocessing
from sklearn.decomposition import PCA

from evaluation.compare import compare, compare_selected, classifiers_subset
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

# FILE_PATH = "../../../../App/Generated-Data/PostureEntry_11_02_chest_sitting.csv"
FILE_PATH_1 = "../../resource/PostureEntry_11_02_back_sit_move_sergio.csv"
FILE_PATH_2 = "../../resource/PostureEntry.csv"
FILE_PATH_3 = "../../resource/PostureEntry_11_02_chest_sitting_phil.csv"

N_VALIDATIONS = 20
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

scores = []
window_min = 5
window_max = 120
window_step = 5
for window_size in range(window_min, window_max, window_step):
    average = PreProcessor.average(samples_raw, window_size)

    labels_reduced = labels[0::window_size]
    if labels_reduced.shape[0] != average.shape[0]:
        labels_reduced = labels_reduced[:-1]

    samples_features = np.zeros(shape=(int(np.floor(samples_raw.shape[0] / window_size)), 6))
    samples_features[:, 0:6] = average[:, 0:6]
    samples_features = preprocessing.scale(samples_features)

    scores.append(compare_selected(samples_features, labels_reduced, N_VALIDATIONS))

means = np.zeros((len(classifiers_subset.keys()), len(scores)))
std = np.zeros((len(classifiers_subset.keys()), len(scores)))

for i, name in enumerate(classifiers_subset):
    for n, score in enumerate(scores):
        means[i, n] = scores[n][name].mean()
        std[i, n] = scores[n][name].std()

figure()
legends = []
for i, name in enumerate(classifiers_subset):
    plot(np.linspace(window_min, window_max, np.ceil((window_max - window_min) / window_step)), means[i, :], ":o")
    legends.append(name + " | std= " + "{0:.2f}".format(np.mean(std[i, :])))

legend(legends)
xlabel("window size")
ylabel("classification error")
title("Average filter")
show()
