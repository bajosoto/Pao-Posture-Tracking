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

classifiers_all = {
    "3 Neighbors": KNeighborsClassifier(3),
    "10 Neighbors": KNeighborsClassifier(10),
    "LDA": LinearDiscriminantAnalysis(),
    "Naive Bayes": GaussianNB(),
    "Decision Tree": DecisionTreeClassifier(max_depth=5),
    "Random Forest": RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
    "Neural Net": MLPClassifier(alpha=1, max_iter=2000),
    "AdaBoost": AdaBoostClassifier(),
    "Linear SVM": SVC(kernel="linear", C=0.025),
    "RBF SVM": SVC(gamma=2, C=1),
    "QDA": QuadraticDiscriminantAnalysis()}


def compare(samples, labels, classifiers, folds):
    results = np.zeros(shape=(len(classifiers), folds))
    results_avg = np.zeros(shape=(2, len(classifiers)))
    for i, name in enumerate(classifiers):
        results[i, :] = cross_val_score(classifiers[name], samples, labels.ravel(), cv=folds)
        results_avg[0, i] = np.mean(results[i, :])
        results_avg[1, i] = np.std(results[i, :])
        print("Accuracy for " + name + ": " + str(results_avg[0, i]) + " (+/- " + str(results_avg[1, i]) + ")")


def compare_all(samples, labels, folds):
    return compare(samples, labels, classifiers_all, folds)


def compare_selected(samples, labels, folds):
    classifiers_subset = {
        "3 Neighbors": KNeighborsClassifier(3),
        "10 Neighbors": KNeighborsClassifier(10),
        "Decision Tree": DecisionTreeClassifier(max_depth=5),
        "Random Forest": RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
        "Neural Net": MLPClassifier(alpha=1, max_iter=2000),
        "AdaBoost": AdaBoostClassifier(),
        "QDA": QuadraticDiscriminantAnalysis()}
    return compare(samples, labels, classifiers_subset, folds)
