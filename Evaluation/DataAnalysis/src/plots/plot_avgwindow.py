import numpy as np
from matplotlib.pyplot import figure, plot, show, legend, xlabel, ylabel, title, errorbar, annotate
from sklearn import preprocessing
from sklearn.decomposition import PCA

from evaluation.compare import compare, compare_selected, classifiers_subset, classifiers_all
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH_1 = "../../resource/PostureEntry_DMP_Phil_Monday.csv"
FILE_PATH_2 = "../../resource/PostureEntry_DMP_Sergio_Monday.csv"
FILE_PATH_3 = "../../resource/PostureEntry_DMP_Ozan.csv"
N_VALIDATIONS = 20
samples_raw, labels_raw, _ = FileReader.readAll([FILE_PATH_1, FILE_PATH_2, FILE_PATH_3])

window_size = 25

scores = []
window_min = 5
window_max = 100
window_step = 5
for window_size in range(window_min, window_max, window_step):
    samples_filtered, labels_reduced = PreProcessor.median(samples_raw, labels_raw, window_size)
    np.hstack((samples_filtered, PreProcessor.peak2peak(samples_raw, window_size)))
    samples_features = preprocessing.scale(samples_filtered)
    scores.append(compare(samples_features, labels_reduced, classifiers_all, N_VALIDATIONS))

means = np.zeros((len(classifiers_subset.keys()), len(scores)))
std = np.zeros((len(classifiers_subset.keys()), len(scores)))

for i, name in enumerate(classifiers_subset):
    for n, score in enumerate(scores):
        means[i, n] = scores[n][name].mean()
        std[i, n] = scores[n][name].std()

figure()
legends = []
for i, name in enumerate(classifiers_all):
    plot(np.linspace(window_min, window_max, np.ceil((window_max - window_min) / window_step)), means[i, :], ":o")
    legends.append(name + " | std= " + "{0:.2f}".format(np.mean(std[i, :])))

legend(legends)
xlabel("window size")
ylabel("classification error")
title("Average & Peak2Peak, back, 2users")
show()
