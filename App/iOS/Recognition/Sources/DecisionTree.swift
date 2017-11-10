class DecisionTree : DecisionNode{
	let children:[DecisionNode]
	let decisionRule: DecisionStump

	init(_ trainset: Dataset, maxDepth: Int, minImpurity: Double, weights: [Double]){
		
		decisionRule = DecisionStump(trainset,weights)

		let sets = DecisionTree.split(trainset,decisionRule.predict(samples:trainset.samples))

		var children = [DecisionNode]()
		for set_ in sets {
			if(DecisionTree.impurity(set_) <= minImpurity || maxDepth == 1){
				children.append(DecisionLeaf(trainset))
			}else{
				children.append(DecisionTree(trainset,maxDepth:maxDepth-1,minImpurity:minImpurity,weights:weights))
			}	
		}

		self.children = children


	}

	func predictSoftSample(_ sample: Matrix) -> [Int] {
		return children[decisionRule.predict(samples:sample)[0]].predictSoftSample(sample)
	}


	internal static func split(_ data: Dataset, _ labels: [Int]) -> [Dataset]{

		var idx = [[Int]]()
		for i in 0 ..< labels.count{
			if(labels[i] > idx.count){
				idx.append([Int]())
			}

			idx[labels[i]].append(i)
		}

		var sets = [Dataset]()
		for l in idx{
			let labels = Matrix([data.labels]).T[l].T.array()[0].map{Int($0)}//looks wicked but is just selecting a the subset l of labels
			sets.append(try! Dataset(data.samples[l],labels))
		}
		return sets
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

	
}