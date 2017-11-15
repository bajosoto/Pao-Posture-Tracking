import numpy as np
from sklearn.tree import DecisionTreeClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis, QuadraticDiscriminantAnalysis
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.model_selection import cross_val_score, LeaveOneOut
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

classifiers_subset = {
#    "Linear SVM": SVC(kernel="linear", C=0.025),
    "6 Neighbors": KNeighborsClassifier(10),
    "Neural Net": MLPClassifier(alpha=1, max_iter=2000),
    "AdaBoost": AdaBoostClassifier(),
    "QDA": QuadraticDiscriminantAnalysis(),
    "Decision Tree": DecisionTreeClassifier(max_depth=5),
}


def compare(samples, labels, classifiers, folds):
    scores = {}
    for i, name in enumerate(classifiers):
        score = cross_val_score(classifiers[name], samples, labels.ravel(), cv=folds)
        scores[name] = score
        # print(results[i, :])
        print("Accuracy for " + name + ": " + str(score.mean()) + " (+/- " + str(score.std()) + ")")
    return scores


def compare_all(samples, labels, folds):
    return compare(samples, labels, classifiers_all, folds)


def compare_selected(samples, labels, folds):
    return compare(samples, labels, classifiers_subset, folds)
