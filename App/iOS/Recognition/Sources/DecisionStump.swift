class DecisionStump : Classifier{

	let cmpLess:Bool
	let feature:Int
	let threshold: Double
	let classes: [Int]
	required convenience init(trainset:Dataset,regularizer:Double){
		self.init(trainset,eye(trainset.nSamples,1))
	}

	init(_ trainset:Dataset, _ weights:Matrix){

		classes = trainset.classes
		let ret = DecisionStump.train(trainset,weights)

		cmpLess = ret.0
		threshold = ret.1
		feature = ret.2
	}

	init(_ cmpLess: Bool, _ feature: Int, _ threshold: Double, _ classes: [Int]){
		
		self.classes = classes
		self.cmpLess = cmpLess
		self.feature = feature
		self.threshold = threshold
	}

	internal static func train(_ trainset: Dataset, _ weights: Matrix) -> (Bool,Double,Int){
		var bestCmp = false
		var bestThresh = 0.0
		var bestFeature = 0
		var bestError = 1.0

		for o in 0 ..< 2 {
			let cmp = o == 0
			for j in 0 ..< trainset.dim {
				let sortedSamples = Matrix(trainset.samples.array().sorted{$0[j] < $1[j]})
				var threshPrev = -Double.greatestFiniteMagnitude

				for i in 0 ..< trainset.nSamples {
					let thresh = sortedSamples[i,j]
					if (thresh <= threshPrev){
						continue;
					}

					threshPrev = thresh

					let clf = DecisionStump(cmp, j, thresh,trainset.classes)

					let error = evaluate(clf,trainset,weights)

					if (error < bestError){
						bestCmp = cmp
						bestThresh = thresh
						bestFeature = j
						bestError = error
						if (error == 0.0) {
							return (bestCmp,bestThresh,bestFeature)
						}
					}
				}
			}
		}
		return (bestCmp,bestThresh,bestFeature)
	}
	func predict(samples: Matrix)->[Int]{
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			labelsFound.append(self.predictSample(sample:samples[i,0..<samples.columns]))
			
		}
		return labelsFound
	}

	internal func predictSample(sample: Matrix)->Int {
		return self.classes[DecisionStump.decision(sample,self.feature,self.cmpLess,self.threshold)] 
	}

	internal static func decision(_ sample: Matrix, _ feature: Int, _ cmpLess: Bool, _ threshold: Double) -> Int {
		if (cmpLess) {
			if (sample[0,feature] <= threshold){
				return 1
			}else{
				return 0
			}
		}else{
			if (sample[0,feature] > threshold){
				return 1
			}else{
				return 0
			}
		}
	}

	func predictSoft(samples: Matrix)->[[Int: Double]]{
		return [[:]]
	}
}