import numpy as np


class PreProcessor:
    @staticmethod
    def average(data: np.array, window_size=10):
        average = np.zeros(shape=(int(np.floor(data.shape[0] / window_size)), data.shape[1]))
        for i in range(0, int(np.floor(data.shape[0] / window_size)) - 1):
            average[i, :] = np.mean(data[i * 10:(i + 1) * 10, :], axis=0)

        return average

    @staticmethod
    def peak2peak(data: np.array, window_size=10):
        p2p = np.zeros(shape=(int(np.floor(data.shape[0] / window_size)), 1))
        for i in range(0, int(np.floor(data.shape[0] / window_size)) - 1):
            p2p[i] = np.min(np.linalg.norm(data[i * 10:(i + 1) * 10, 0:3])) - np.max(np.linalg.norm(data[i * 10:(i + 1) * 10, 0:3]))

        return p2p

    @staticmethod
    def gen_features(raw_data: np.array, window_size=10):
        filtered = PreProcessor.average(raw_data, window_size)
        p2p = PreProcessor.peak2peak(raw_data, window_size)
        features = np.zeros(shape=(filtered.shape[0], 7))
        features[:, 0:6] = filtered
        features[:, 6] = p2p.ravel()
        return features
