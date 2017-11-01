class PaoKnnClassifier : PaoClassifier{
	
	let classifier: Classifier
	let scaler: Scaler
	let preprocessor: Preprocessor

	init(_ traindata: [IPostureEntry],windowSize: Int = 10, kNeighbours: Int = 10){
		preprocessor = SimplePreprocessor(windowSize:windowSize)
		var rawData = [RawSample]()
		var labels = [Int]()
		for i in 0 ..< traindata.count{
			if ((i+1)%windowSize==0){
				labels.append(Int(lookupLabel(traindata[i].postureLbl)))
			}
			rawData.append(RawSample(traindata[i]))
		}
		let featureVectors = try! preprocessor.preprocess(rawData)
		var matrixRep = Matrix(featureVectors)
		scaler = EqualScaler(matrixRep)
		matrixRep = scaler.transform(matrixRep)
		let trainset = try! Dataset(samples:matrixRep,labels:labels)
		classifier = KnnClassifier(trainset:trainset,regularizer:0.0,kNeighbours:kNeighbours)
	}

	required convenience init (_ traindata: [IPostureEntry]){
		self.init(traindata,windowSize:10,kNeighbours:10)
	}

	func classifySampleSoft(_ testdata: [IPostureEntry]) -> [IPostureEntry]{
		var rawData = [RawSample]()
		for i in 0 ..< testdata.count{
			rawData.append(RawSample(testdata[i]))
		}
		let featureVector = try! preprocessor.preprocess(rawData)

		let sampleMatrix = scaler.transform(Matrix(featureVector))

		let hardLabels = classifier.classify(samples:sampleMatrix)
		
		let softLabels = classifier.classifySoft(samples:sampleMatrix)

		var predictions = [Predicition]()
		for i in 0 ..< softLabels.count{
			var probabilities = softLabels[i]
			var badPosture = probabilities[Int(lookupLabel("SitNok"))]! 
			badPosture += probabilities[Int(lookupLabel("StandNok"))]!
			badPosture += probabilities[Int(lookupLabel("MovNok"))]!
			var goodPosture = probabilities[Int(lookupLabel("SitOk"))]!
			goodPosture += probabilities[Int(lookupLabel("StandOk"))]!
			goodPosture += probabilities[Int(lookupLabel("MovOk"))]!

			predictions.append(Predicition(featureVector[0],goodPosture-badPosture,lookupLabel(Double(hardLabels[i]))))
		}
		
		return predictions
	}
}