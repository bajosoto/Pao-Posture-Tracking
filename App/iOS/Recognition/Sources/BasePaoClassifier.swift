class  BasePaoClassifier: PaoClassifier {

	let classifier: Classifier
	let scaler: Scaler
	let preprocessor: Preprocessor

	init(_ traindata: [IPostureEntry], _ classifier: Classifier,_ preprocessor: Preprocessor = SimplePreprocessor(), _ scaler: Scaler = EqualScaler()){
		self.classifier = classifier
		self.scaler = scaler
		self.preprocessor = preprocessor
		self.train(traindata)
	}

	func train(_ traindata: [IPostureEntry]){

		/* convert the posture entries to local type raw data and put labels in seperate list*/
		var rawData = [RawSample]()
		var labels = [Int]()
		for i in 0 ..< traindata.count{
			labels.append(Int(lookupLabel(traindata[i].postureLbl)))
			rawData.append(RawSample(traindata[i]))
		}

		/* apply preprocessing*/
		let filtered = try! preprocessor.preprocess(rawData,labels)

		/* convert to matrix */
		var matrixRep = Matrix(filtered.0)
		
		/* apply scaling*/
		self.scaler.train(matrixRep)
		matrixRep = scaler.transform(matrixRep)

		/*generate trainingset and train*/
		let trainset = try! Dataset(matrixRep,filtered.1)
		self.classifier.train(trainset)
	}

	func predictSampleSoft(_ testdata: [IPostureEntry]) -> [IPostureEntry]{

		/* convert data to local type*/
		var rawData = [RawSample]()
		for i in 0 ..< testdata.count{
			rawData.append(RawSample(testdata[i]))
		}

		/* apply preprocessing -> average filter and peak2peak*/
		let featureVector = try! preprocessor.preprocess(rawData)

		/* apply same scaling as on the training set*/
		let sampleMatrix = scaler.transform(Matrix(featureVector))

		/* get the hard labels*/
		let hardLabels = classifier.predict(samples:sampleMatrix)
		
		/* get the soft labels*/
		let softLabels = classifier.predictSoft(samples:sampleMatrix)

		/* create output data type for each classified sample*/
		var predictions = [Predicition]()
		for i in 0 ..< softLabels.count{

			/* calculate percentage of healthy/unhealthy*/
			var probabilities = softLabels[i]
			var badPosture = probabilities[Int(lookupLabel("SitNok"))]! 
			badPosture += probabilities[Int(lookupLabel("StandNok"))]!
			badPosture += probabilities[Int(lookupLabel("MovNok"))]!
			var goodPosture = probabilities[Int(lookupLabel("SitOk"))]!
			goodPosture += probabilities[Int(lookupLabel("StandOk"))]!
			goodPosture += probabilities[Int(lookupLabel("MovOk"))]!

			/* put it all together */
			predictions.append(Predicition(featureVector[0],goodPosture-badPosture,lookupLabel(Double(hardLabels[i]))))
		}
		
		return predictions
	}
}