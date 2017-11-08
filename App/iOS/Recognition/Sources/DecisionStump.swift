class DecisionStump : Classifier{

	let cmpLarge:Bool
	let feature:Int
	let threshold: Double
	let classes: [Int]
	required convenience init(trainset:Dataset,regularizer:Double){
		self.init(trainset,eye(trainset.nSamples,1))
	}

	init(_ trainset:Dataset, _ weights:Matrix){

		classes = trainset.classes
		let ret = DecisionStump.train(trainset,weights)

		cmpLarge = ret.0
		threshold = ret.1
		feature = ret.2
	}

	init(_ cmpLarge: Bool, _ feature: Int, _ threshold: Double, _ classes: [Int]){
		
		self.classes = classes
		self.cmpLarge = cmpLarge
		self.feature = feature
		self.threshold = threshold
	}

	internal static func train(_ trainset: Dataset, _ weights: Matrix) -> (Bool,Double,Int){
		
		var bestCmp = false
		var bestThresh = 0.0
		var bestFeature = 0
		var bestImpurity = 1.0

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

						let predictions = clf.predict(samples:trainset.samples)
		
						let (set0,set1) = DecisionStump.split(trainset,predictions)

						let impurity = DecisionStump.impurity(set0) + DecisionStump.impurity(set1)

						if (impurity < bestImpurity){
							bestCmp = cmp
							bestThresh = thresh
							bestFeature = j
							bestImpurity = impurity
							
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
		return classes[DecisionStump.decision(sample,self.feature,self.cmpLarge,self.threshold)] 
	}

	internal static func split(_ data: Dataset, _ predictions: [Int]) -> (Dataset,Dataset){

		var idx0 = [Int]()
		var idx1 = [Int]()
		for i in 0 ..< predictions.count{
			if (predictions[i] == 1){
				idx1.append(i)
			}else{
				idx0.append(i)
			}
		}
		let labels0 = Matrix([data.labels]).T[idx0].T.array()[0].map{Int($0)}
		let labels1 = Matrix([data.labels]).T[idx1].T.array()[0].map{Int($0)}

		return (try! Dataset(samples:data.samples[idx0],labels:labels0),try! Dataset(samples:data.samples[idx1],labels:labels1))
	}

	internal static func impurity(_ data: Dataset) -> Double{
		var purity = 0.0
		for m in data.classes {
			let d = Double(data.labels.filter{$0 == m}.count)/Double(data.labels.count)
			if(d != 0){
				purity += d * _log(d) //Quinlan
			}
			print("\(purity) = \(d) * \(_log(d))")
		}
		return -1*purity
	}

	internal static func decision(_ sample: Matrix, _ feature: Int, _ cmpLarge: Bool, _ threshold: Double) -> Int {
		if (cmpLarge) {
			if (sample[0,feature] >= threshold){
				return 1
			}else{
				return 0
			}
		}else{
			if (sample[0,feature] < threshold){
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