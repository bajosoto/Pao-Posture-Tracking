class PaoKnnClassifier : PaoClassifier{
	
	var classifier: Classifier
	var scaler: Scaler
	var preprocessor: Preprocessor

	required init(_ traindata: [IPostureEntry]){
		var windowSize = 10
		preprocessor = SimplePreprocessor(windowSize:windowSize)
		var rawData = [RawSample]()
		var labels = [Int]()
		for i in 0 ..< traindata.count{
			if ((i+1)%windowSize==0){
				labels.append(Int(traindata[i].posture))
			}
			rawData.append(RawSample(traindata[i]))
		}
		let featureVectors = try! preprocessor.preprocess(rawData)
		var matrixRep = Matrix(featureVectors)
		scaler = EqualScaler(matrixRep)
		matrixRep = scaler.transform(matrixRep)
		var trainset = try! Dataset(samples:matrixRep,labels:labels)
		classifier = KnnClassifier(trainset:trainset,regularizer:0.0,kNeighbours:1)
	}

	func classifySampleSoft(_ testdata: [IPostureEntry]) -> [IPostureEntry]{
		var rawData = [RawSample]()
		for i in 0 ..< testdata.count{
			rawData.append(RawSample(testdata[i]))
		}

		var featureVector = try! preprocessor.preprocess(rawData)

		var sampleVector = scaler.transform(Matrix(featureVector))

		var probabilities = classifier.classifySoft(samples:sampleVector)[0]

		print(probabilities)
		var badPosture = probabilities[0]! //+probabilities[1]!+probabilities[2]!
		var goodPosture = probabilities[3]! //+probabilities[4]!+probabilities[5]!

		return [Predicition(featureVector[0],goodPosture-badPosture)]
	}
}