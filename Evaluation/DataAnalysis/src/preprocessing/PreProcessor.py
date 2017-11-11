import numpy as np


class PreProcessor:
    @staticmethod
    def average(data: np.array, window_size=10):
        average = np.zeros(shape=(int(np.floor(data.shape[0] / window_size)), data.shape[1]))
        for i in range(0, int(np.floor(data.shape[0] / window_size)) - 1):
            average[i, :] = np.mean(data[i * window_size:(i + 1) * window_size, :], axis=0)

        return average

    @staticmethod
    def median(data: np.array, window_size=10):
        median = np.zeros(shape=(int(np.floor(data.shape[0] / window_size)), data.shape[1]))
        for i in range(0, int(np.floor(data.shape[0] / window_size)) - 1):
            median[i, :] = np.median(data[i * window_size:(i + 1) * window_size, :], axis=0)

        return median

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
        for i in range(0, int(np.floor((data.shape[0]/window_size))-1)):
            lengths.append(window_size)

        return data, lengths