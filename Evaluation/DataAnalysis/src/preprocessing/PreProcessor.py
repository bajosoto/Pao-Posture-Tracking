import numpy as np
from numpy.ma import count


class PreProcessor:
    @staticmethod
    def majoritiy_vote(labels: np.array, window: np.array):
        votes = {}
        for c in np.unique(labels):
            votes[c] = (window == c).sum()
        return max(votes, key=votes.get)

    @staticmethod
    def average(data: np.array, labels: np.array, window_size=10):
        max_i = int(np.floor(data.shape[0] / window_size))
        average = np.zeros(shape=(max_i, data.shape[1]))
        labels_filtered = np.zeros(shape=(max_i, 1))
        for i in range(0, max_i - 1):
            average[i, :] = np.average(data[i * window_size:(i + 1) * window_size, :], axis=0)
            labels_filtered[i] = PreProcessor.majoritiy_vote(labels, labels[i * window_size:(i + 1) * window_size])
        return average, labels_filtered

    @staticmethod
    def median(data: np.array, labels: np.array, window_size=10):
        max_i = int(np.floor(data.shape[0] / window_size))
        median = np.zeros(shape=(max_i, data.shape[1]))
        labels_filtered = np.zeros(shape=(max_i, 1))
        for i in range(0, max_i - 1):
            median[i, :] = np.median(data[i * window_size:(i + 1) * window_size, :], axis=0)
            labels_filtered[i] = PreProcessor.majoritiy_vote(labels, labels[i * window_size:(i + 1) * window_size])
        return median, labels_filtered

    @staticmethod
    def peak2peak(data: np.array, window_size=10):
        p2p = np.zeros(shape=(int(np.floor(data.shape[0] / window_size)), 1))
        for i in range(0, int(np.floor(data.shape[0] / window_size)) - 1):
            p2p[i] = np.min(np.linalg.norm(data[i * 10:(i + 1) * 10, 0:3])) - np.max(
                np.linalg.norm(data[i * 10:(i + 1) * 10, 0:3]))

        return p2p

    @staticmethod
    def merge_window(data: np.array, window_size=5):
        window = np.zeros(shape=(int(np.floor(data.shape[0] / window_size)), 6 * window_size))
        for i in range(0, int(np.floor(data.shape[0] / window_size)) - 1):
            window[i, :] = data[i * window_size:(i + 1) * window_size, :].reshape(1, -1)

        return window

    @staticmethod
    def split2sequences(data: np.array, window_size=10):
        lengths = []
        for i in range(0, int(np.floor((data.shape[0] / window_size)) - 1)):
            lengths.append(window_size)

        return data, lengths

    @staticmethod
    def magnitude_theta(data: np.array,labels: np.array, window_size=5):
        max_i = int(np.floor(data.shape[0] / window_size))

        magnitude_accel = np.zeros(shape=(max_i, 1))
        magnitude_gyro = np.zeros(shape=(max_i, 1))
        theta = np.zeros(shape=(max_i, 1))
        labels_filtered = np.zeros(shape=(max_i, 1))

        for i in range(0, int(np.floor(data.shape[0] / window_size)) - 1):
            magnitude_accel[i] = np.linalg.norm(data[i * window_size:(i + 1) * window_size, 0:3])
            magnitude_gyro[i] = np.linalg.norm(data[i * window_size:(i + 1) * window_size, 3:7])
            theta[i] = np.linalg.norm(data[i * window_size:(i + 1) * window_size, 8])
            labels_filtered[i] = PreProcessor.majoritiy_vote(labels, labels[i * window_size:(i + 1) * window_size])

        return np.hstack([magnitude_accel, magnitude_gyro, theta]), labels_filtered
