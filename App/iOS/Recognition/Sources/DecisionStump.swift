class DecisionStump : Classifier{

	let cmpLess:Bool
	let feature:Int
	let threshold: Double
	required convenience init(trainset:Dataset,regularizer:Double){
		self.init(trainset,eye(trainset.nSamples,1))
	}

	init(_ trainset:Dataset, _ weights:Matrix){
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

					let clf = DecisionStump(cmp, j, thresh)

					let error = evaluate(clf,trainset,weights)

					if (error < bestError){
						bestCmp = cmp
						bestThresh = thresh
						bestFeature = j
						bestError = error
					}
				}
			}
		}

		cmpLess = bestCmp
		feature = bestFeature
		threshold = bestThresh
	}

	init(_ cmpLess: Bool, _ feature: Int, _ threshold: Double){
		self.cmpLess = cmpLess
		self.feature = feature
		self.threshold = threshold
	}

	func classify(samples: Matrix)->[Int]{
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			labelsFound.append(self.classifySample(sample:samples[i,0..<samples.columns]))
			
		}
		return labelsFound
	}

	internal func classifySample(sample: Matrix)->Int {
		return DecisionStump.decision(sample,self.feature,self.cmpLess,self.threshold) 
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

	func classifySoft(samples: Matrix)->[[Int: Double]]{
		return [[:]]
	}
}