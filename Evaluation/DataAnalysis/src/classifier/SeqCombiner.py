import numpy as np
from numpy.linalg import norm
from sklearn.base import BaseEstimator


class SeqCombiner:
    def __init__(self, clf: BaseEstimator):
        self.clf = clf
        self.classes = 2

    def predict(self, sample: np.array):
        probas = np.zeros((1, self.classes))
        for i in range(sample.shape[0]):
            probas += i * 1 / sample.shape[0] * self.clf.predict_proba(sample[i, :].reshape(1,-1))

        probas /= norm(probas)

        return np.argmax(probas)
