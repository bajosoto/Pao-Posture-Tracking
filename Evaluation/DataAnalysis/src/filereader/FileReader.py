import numpy as np


class FileReader:
    @staticmethod
    def read(path: str, n_elements=None):
        num_lines = sum(1 for _ in open(path))
        data = np.array
        labels = np.array
        label_names = []
        with open(path) as f:
            for n, line in enumerate(f):
                if n == 0: continue
                elements = line.split(',')
                sample = elements[1:len(elements) - 3]
                label = elements[len(elements) - 1]
                if label not in label_names:
                    label_names.append(label)
                if n == 1:
                    data = np.zeros(shape=(num_lines - 1, len(sample)))
                    labels = np.zeros(shape=(num_lines - 1, 1))
                data[n - 1, :] = np.array(list(map(float, sample)))
                labels[n - 1] = label_names.index(label)
                if n_elements is not None and n > n_elements:
                    break
        return data, labels, label_names

    @staticmethod
    def readAll(paths: [str]):
        data = None
        labels = None
        label_names = []
        for p in paths:
            data_file, label_file, label_names_file = FileReader.read(path=p)
            data = data_file if data is None else np.vstack((data, data_file))
            labels = label_file if labels is None else np.vstack((labels, label_file))
            label_names.append(label_names_file)

        return data, labels.ravel(), label_names