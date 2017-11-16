import numpy as np
import matplotlib.pyplot as plt
import itertools
from sklearn import preprocessing
from sklearn.metrics import confusion_matrix, accuracy_score
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier

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

cm = np.zeros((6, 6))
accuracy = 0.0
clf = KNeighborsClassifier(5, algorithm='kd_tree', metric='manhattan')
for i in range(N_VALIDATIONS):
    train_data, test_data, train_labels, test_labels = train_test_split(samples_features, labels_raw,
                                                                        test_size=0.10)
    clf.fit(train_data, train_labels.ravel())
    prediction = clf.predict(test_data)
    cm += confusion_matrix(test_labels, prediction) / N_VALIDATIONS
    accuracy += accuracy_score(test_labels, prediction) / N_VALIDATIONS

columns = label_names[0]
rows = label_names[0]
cm_norm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
cm_norm = np.round(cm_norm, 2)

fig, ax = plt.subplots()

# Hide axes
ax.axis('off')
ax.axis('tight')
ax.xaxis.set_visible(False)
ax.yaxis.set_visible(False)
ax.table(cellText=cm_norm, colLabels=columns, rowLabels=rows, loc='center')
plt.title("5NN - Accuracy: " + str(accuracy))
plt.show()
