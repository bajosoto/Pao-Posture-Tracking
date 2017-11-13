from filereader.FileReader import FileReader
from plots.plot_pc import plot_pc

FILE_PATH = "../../resource/PostureEntry.csv"

samples, labels, label_names = FileReader.read(FILE_PATH)

plot_pc(samples, labels, "raw")

labels[(labels == 1) | (labels == 3) | (labels == 5)] = 1
labels[labels != 1] = 0

plot_pc(samples, labels, "healthy/unhealthy")
