class DecisionStump : Classifier{

	let cmpLarge:Bool
	let feature:Int
	let threshold: Double
	let classes: [Int]
	required convenience init(trainset:Dataset){
		self.init(trainset,[Double](repeating: 1.0/Double(trainset.nSamples), count: trainset.nSamples))
	}

	init(_ trainset:Dataset, _ weights:[Double]){

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

	internal static func train(_ trainset: Dataset, _ weights: [Double]) -> (Bool,Double,Int){
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
					
					/* split TODO move to own fcn */
					var set0 = Dataset()
					var weights0 = [Double]()
					var set1 = Dataset()
					var weights1 = [Double]()
					for n in 0 ..< trainset.nSamples {
						if(decision(trainset.samples[n],j,cmp,thresh)==1){
							set1 = try! set1.append(try! Dataset(trainset.samples[n],[trainset.labels[n]]))
							weights1.append(weights[n])
						}else{
							set0 = try! set1.append(try! Dataset(trainset.samples[n],[trainset.labels[n]]))
							weights0.append(weights[n])

						}
					}

					let impurity = DecisionTree.impurity(set0,weights0) + DecisionTree.impurity(set1,weights1)

					if (impurity < bestImpurity){
						bestCmp = cmp
						bestThresh = thresh
						bestFeature = j
						bestImpurity = impurity
						if (impurity == 0.0) {
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
			labelsFound.append(self.predictSample(samples[i,0..<samples.columns]))
			
		}
		return labelsFound
	}

	internal func predictSample(_ sample: Matrix)->Int {
		return classes[DecisionStump.decision(sample,self.feature,self.cmpLarge,self.threshold)] 
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