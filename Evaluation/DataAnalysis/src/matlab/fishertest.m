
data = [PostureEntry.accX,PostureEntry.accY,PostureEntry.accZ,PostureEntry.gyrX,PostureEntry.gyrY,PostureEntry.gyrZ];
labels = PostureEntry.postureLbl;

dataset = prdataset(data,labels);
% scatterd(dataset)
prcrossval(dataset,naivebc,4)
% plotc(dataset*naivebc)