public class PaoKnnClassifier : BasePaoClassifier{
	
	public convenience init(_ traindata: [IPostureEntry],windowSize: Int = 10, kNeighbours: Int = 7){
		self.init(traindata,KnnClassifier(kNeighbours:kNeighbours),MagnitudeThetaPreprocessor(windowSize))
	}

	
	
}
