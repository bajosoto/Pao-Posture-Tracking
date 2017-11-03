# FILE_PATH = "../../../../App/Generated-Data/PostureEntry_11_02_chest_sitting.csv"
from sklearn import preprocessing

from evaluation.compare import compare
from filereader.FileReader import FileReader

FILE_PATH_1 = "../../resource/PostureEntry_11_02_back_sit_move_sergio.csv"
FILE_PATH_2 = "../../resource/PostureEntry_11_02_chest_sitting_phil.csv"

N_VALIDATIONS = 6

samples_raw_1, labels_1, _ = FileReader.read(FILE_PATH_1)
samples_raw_1 = samples_raw_1[(labels_1.ravel() == 0) | (labels_1.ravel() == 1), :]
labels_1 = labels_1[(labels_1.ravel() == 0) | (labels_1.ravel() == 1)]

samples_raw_3, labels_3, _ = FileReader.read(FILE_PATH_2)

samples_raw = np.vstack([samples_raw_1, samples_raw_3])
labels = np.vstack([labels_1, labels_3])
window_size = 100
average = PreProcessor.average(samples_raw, window_size)
p2p = PreProcessor.peak2peak(samples_raw, window_size)

labels_reduced = labels[0::window_size]
labels_reduced = labels_reduced[:-1]
print(samples_raw[0, :])
samples_features = np.zeros(shape=(int(np.floor(samples_raw.shape[0] / window_size)), 6))
samples_features[:, 0:6] = average[:, 0:6]
# samples_features[:, 6] = p2p.ravel()

samples_features = preprocessing.scale(samples_features)
compare(samples_features, labels_reduced, N_VALIDATIONS)