import numpy as np
import matplotlib.pyplot as plt
import itertools
from sklearn import preprocessing
from sklearn.metrics import confusion_matrix, accuracy_score
from sklearn.model_selection import train_test_split
from evaluation.compare import classifiers_subset
from preprocessing.PreProcessor import PreProcessor
from src.filereader.FileReader import FileReader

FILE_PATH_1 = "../../resource/PostureEntry_DMP_Phil_Monday.csv"
FILE_PATH_2 = "../../resource/PostureEntry_DMP_Sergio_Monday.csv"
FILE_PATH_3 = "../../resource/PostureEntry_DMP_Ozan.csv"

N_VALIDATIONS = 100
samples_raw, labels_raw, label_names = FileReader.readAll([FILE_PATH_1, FILE_PATH_2, FILE_PATH_3])

window_size = 30

scores = []
# samples_filtered, labels_reduced = PreProcessor.average(samples_raw, labels_raw, window_size)
# samples_filtered = np.hstack((samples_filtered, PreProcessor.peak2peak(samples_raw, window_size)))
samples_features = preprocessing.scale(samples_raw)

cm = {}
accuracy = {}

for i in range(N_VALIDATIONS):
    train_data, test_data, train_labels, test_labels = train_test_split(samples_raw, labels_raw,
                                                                        test_size=0.33)
    for _, name in enumerate(classifiers_subset):
        if name not in cm.keys():
            cm[name] = np.zeros((6, 6))
            accuracy[name] = 0.0
        classifiers_subset[name].fit(train_data, train_labels.ravel())
        prediction = classifiers_subset[name].predict(test_data)
        cm[name] += confusion_matrix(test_labels, prediction) / N_VALIDATIONS
        accuracy[name] += accuracy_score(test_labels, prediction) / N_VALIDATIONS

for _, name in enumerate(classifiers_subset):
    print("-------------------" + name + "-------------")

    columns = label_names[0]
    rows = label_names[0]
    cm_norm = cm[name].astype('float') / cm[name].sum(axis=1)[:, np.newaxis]
    cm_norm = np.round(cm_norm,2)

    fig, ax = plt.subplots()

    # Hide axes
    ax.axis('off')
    ax.axis('tight')
    ax.xaxis.set_visible(False)
    ax.yaxis.set_visible(False)
    ax.table(cellText=cm_norm, colLabels=columns,rowLabels=rows, loc='center')
    plt.title(name + "Accuracy: " + str(accuracy[name]))
    plt.show()