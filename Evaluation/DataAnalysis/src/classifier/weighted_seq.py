import numpy as np
from numpy.linalg import norm
from sklearn.base import BaseEstimator


class WeightedSeq:
    def __init__(self, clf: BaseEstimator):
        self.clf = clf
        self.classes = 2

    def predict(self, sample: np.array):
        probas = np.zeros((1, self.classes))
        for i in sample.shape[0]:
            probas += i * 1 / sample.shape[0] * self.clf.predict(sample[i, :])

        probas /= norm(probas)

        return probas