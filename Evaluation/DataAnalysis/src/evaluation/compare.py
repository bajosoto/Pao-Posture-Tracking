import numpy as np
from sklearn.tree import DecisionTreeClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis, QuadraticDiscriminantAnalysis
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.model_selection import cross_val_score
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier

names = ["Nearest Neighbors", "LDA", "Naive Bayes", "Decision Tree", "Random Forest", "Neural Net", "AdaBoost",
         "Linear SVM", "RBF SVM",
         "QDA"]

classifiers = [
    KNeighborsClassifier(10),
    LinearDiscriminantAnalysis(),
    GaussianNB(),
    DecisionTreeClassifier(max_depth=5),
    RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
    MLPClassifier(alpha=1),
    AdaBoostClassifier(),
    SVC(kernel="linear", C=0.025),
    SVC(gamma=2, C=1),
    QuadraticDiscriminantAnalysis()]


def compare(samples, labels, folds):
    results = np.zeros(shape=(len(classifiers), folds))
    results_avg = np.zeros(shape=(2, len(classifiers)))
    for i, c in enumerate(classifiers):
        results[i, :] = cross_val_score(c, samples, labels.ravel(), cv=folds)
        results_avg[0, i] = np.mean(results[i, :])
        results_avg[1, i] = np.std(results[i, :])
        print("Accuracy for " + names[i] + ": " + str(results_avg[0, i]) + " (+/- " + str(results_avg[1, i]) + ")")
