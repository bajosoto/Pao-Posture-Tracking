from numpy import zeros, mean, std
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis, QuadraticDiscriminantAnalysis
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.model_selection import cross_val_score
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier

from src.filereader.FileReader import FileReader

FILE_PATH = "../../res/log.csv"
N_VALIDATIONS = 4

names = ["Nearest Neighbors", "Linear SVM", "RBF SVM",  "LDA",
             "Decision Tree", "Random Forest", "Neural Net", "AdaBoost",
                   "Naive Bayes", "QDA"]

samples, labels, label_names = FileReader.read(FILE_PATH)

classifiers = [
    KNeighborsClassifier(3),
    SVC(kernel="linear", C=0.025),
    SVC(gamma=2, C=1),
    LinearDiscriminantAnalysis(),
    DecisionTreeClassifier(max_depth=5),
    RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
    MLPClassifier(alpha=1),
    AdaBoostClassifier(),
    GaussianNB(),
    QuadraticDiscriminantAnalysis()]

folds = 4
results = zeros(shape=(len(classifiers), folds))
results_avg = zeros(shape=(2, len(classifiers)))
for i, c in enumerate(classifiers):
    results[i, :] = cross_val_score(c, samples, labels.ravel(), cv=folds)
    results_avg[0, i] = mean(results[i, :])
    results_avg[1, i] = std(results[i, :])
    print("Accuracy for " + names[i] + ": " + str(results_avg[0, i]) + " (+/- " + str(results_avg[1, i]) + ")")

