class PaoKnnClassifier : BasePaoClassifier{
	
	convenience init(_ traindata: [IPostureEntry],windowSize: Int = 10, kNeighbours: Int = 10){
		self.init(traindata,KnnClassifier(kNeighbours:kNeighbours),SimplePreprocessor(10))
	}

	
	
}