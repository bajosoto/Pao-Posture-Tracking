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
                elements = line.split(',')
                sample = elements[1:len(elements) - 1]
                label = elements[len(elements)-1]
                if label not in label_names:
                    label_names.append(label)
                if n == 0:
                    data = np.zeros(shape=(num_lines, len(sample)))
                    labels = np.zeros(shape=(num_lines, 1))
                data[n, :] = np.array(list(map(float, sample)))
                labels[n] = label_names.index(label)
                if n_elements is not None and n > n_elements:
                    break
        return data, labels, label_names

