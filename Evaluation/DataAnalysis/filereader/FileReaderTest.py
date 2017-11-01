import numpy as np

from filereader.FileReader import FileReader

FILE_PATH = "../../res/log.csv"

samples, labels, label_names = FileReader.read(FILE_PATH)


print("Labels found:")
for name in label_names:
    print(name)

print("Mean")
print(np.mean(samples), 2)
print("Variance:")
print(np.power(np.std(samples), 2))

print("Mean Accelerometer")
print(np.mean(samples[0:3]), 2)
print("Variance Accelerometer:")
print(np.power(np.std(samples[0:3]), 2))

print("Mean Gyroscope")
print(np.mean(samples[3:7]), 2)
print("Variance Gyroscope:")
print(np.power(np.std(samples[3:7]), 2))

for label, name in enumerate(label_names):
    print("Class Mean Accelerometer " + name + ": ")
    print(np.mean(samples[labels.ravel() == label, 0:3]), 2)
    print("Class Variance Accelerometer " + name + ": ")
    print(np.power(np.std(samples[labels.ravel() == label, 0:3]), 2))

    print("Class Mean Gyroscope " + name + ":")
    print(np.mean(samples[labels.ravel() == label, 3:7]), 2)
    print("Class Variance Gyroscope " + name + ":")
    print(np.power(np.std(samples[labels.ravel() == label, 3:7]), 2))



