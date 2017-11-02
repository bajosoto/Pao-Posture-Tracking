from sklearn import preprocessing
from sklearn.svm import OneClassSVM

from src.filereader.FileReader import FileReader

FILE_PATH = "../../resource/PostureEntry.csv"
N_VALIDATIONS = 4

samples, labels, label_names = FileReader.read(FILE_PATH)

samples = preprocessing.scale(samples)

labels = labels.ravel()

trainsamples = samples[(labels == 0) | (labels == 2) | (labels == 4), :]
testsamples = samples[(labels == 1) | (labels == 3) | (labels == 5), :]


labels[(labels == 0) | (labels == 2) | (labels == 4)] = 0
labels[(labels != 0)] = 1


clf = OneClassSVM()
clf.fit(trainsamples)

y_train = clf.predict(trainsamples)
y_test = clf.predict(testsamples)

error_train = y_train[y_train == -1].size/y_train.size
error_test = y_test[y_test == -1].size/y_test.size

print("Train error " + str(error_train))
print("Test error " + str(error_test))
