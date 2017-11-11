class DecisionTree : DecisionNode, Classifier{
	let children:[DecisionNode]
	let decisionRule: DecisionStump
	let trainset: Dataset
	init(_ trainset: Dataset, weights: [Double], maxDepth: Int, minImpurity: Double = 0.0){
		
		self.trainset = trainset
		decisionRule = DecisionStump(trainset,weights)

		let sets = decisionRule.split(trainset)

		var children = [DecisionNode]()
		for set_ in sets {
			if(DecisionTree.impurity(set_) <= minImpurity || maxDepth == 1){
				print("DecisionTree::new leaf")
				children.append(DecisionLeaf(set_))
			}else{
				print("DecisionTree::new child")
				children.append(DecisionTree(set_,weights:weights,maxDepth:maxDepth-1,minImpurity:minImpurity))
			}	
		}
		print("Decision Tree created")
		self.children = children


	}

	func predictSampleSoft(_ sample: Matrix) -> [Int: Double] {
		var probas = [Int:Double]()
		for m in trainset.classes {
			probas.updateValue(0.0,forKey:m)
		}
		var probasRet: [Int: Double]
		if(children.count > 1){
			probasRet = children[decisionRule.label(sample)].predictSampleSoft(sample)
		}else{
			probasRet = children[0].predictSampleSoft(sample)		
		}
		for m in probasRet.keys {
			probas.updateValue(probasRet[m]!,forKey:m)
		}

		return probas
	}

	internal static func impurity(_ data: Dataset) -> Double{
		return DecisionTree.impurity(data,[Double](repeating: 1.0/Double(data.nSamples), count: data.nSamples))
	}

	internal static func impurity(_ data: Dataset, _ weights:[Double]) -> Double{
		//TODO check if weights sum up to one
		var purity = 0.0
		for m in data.classes {
			var d = 0.0
			for i in 0 ..< data.nSamples{
				if (data.labels[i] == m){
					d += weights[i]
				}
			}
			if(d != 0){
				purity += d * _log(d)//Quinlan
			}
			//print("\(purity) = \(d) * \(_log(d))")
		}
		return -1*purity
	}

	required convenience init(trainset:Dataset){
		self.init(trainset,weights:[Double](repeating: 1.0/Double(trainset.nSamples), count: trainset.nSamples),maxDepth:trainset.classes.count+trainset.dim,minImpurity:0.0)
	}

	func predict(samples: Matrix)->[Int]{
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			labelsFound.append(self.predictSample(sample:samples[i,0..<samples.columns]))
			
		}
		return labelsFound
	}

	internal func predictSample(sample: Matrix)->Int{
		return predictSampleSoft(sample).sorted(by: {$0.1 > $1.1})[0].key
	}

	func predictSoft(samples: Matrix)->[[Int: Double]]{
		var softLabels:[[Int:Double]] = []
		for i in 0..<samples.rows{
			softLabels.append(self.predictSampleSoft(samples[i]))
			
		}
		return softLabels
	}
}