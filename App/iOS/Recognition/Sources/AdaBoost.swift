class AdaBoost : Classifier {
	
	let weights: Matrix
	let beta: [Double]
	let hypotheses: [Classifier]
	let totalI: Int
	required convenience init(trainset:Dataset,regularizer:Double){
		self.init(trainset,1000)
	}

	init(_ trainset: Dataset, _ maxI: Int){
		let ret = AdaBoost.train(trainset,maxI)
		
		weights = ret.0
		beta = ret.1
		hypotheses = ret.2
		totalI = ret.3
	}

	internal static func train(_ trainset:Dataset,_ maxI: Int) -> (Matrix,[Double],[Classifier],Int){

		var weights = ones(maxI,trainset.nSamples)
		var normedWeights = ones(maxI,trainset.nSamples) 
		var error = [Double]()
		var beta = [Double]()
		var hypotheses = [Classifier]()
		var totalI = 0
		for i in 0 ..< maxI {
			totalI = i
			normedWeights[i,0 ..< weights.columns] = weights[i,0 ..< weights.columns]/norm(weights[i,0 ..< weights.columns])
			let clf = DecisionStump(trainset,normedWeights[i,0 ..< weights.columns])
			hypotheses.append(clf)
			let predictions = clf.predict(samples:trainset.samples)
			error.append(evaluate(clf,trainset,weights[i,0 ..< weights.columns]))
			
			var beta_i = error[i]/(1-error[i])

			if (error[i] == 1.0){
				beta_i = 100
			}
			
			beta.append(beta_i)
			let power = ones(trainset.nSamples,1)-abs(Matrix([predictions]) - Matrix([trainset.labels])).T
			for j in 0 ..< power.rows{
				weights[i,j] = (weights[i,j]*beta[i])**power[j,0] 
			}

			if ( i>1 && abs(error[i]-error[i-1]) <= 0.00001){
				break;
			}
		}

		return (weights,beta,hypotheses,totalI)
	}

	func predict(samples: Matrix)->[Int] {
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			labelsFound.append(self.predictSample(sample:samples[i,0..<samples.columns]))
			
		}
		return labelsFound
	}

	internal func predictSample(sample: Matrix) -> Int{
		var sumVote1 = 0.0
		var sumThresh = 0.0
		for i in 0 ..< self.totalI {
			let clf = hypotheses[i]
			let logBeta = _log(1/beta[i])
			sumVote1 += logBeta*Double(clf.predict(samples:sample)[0])
			sumThresh += logBeta
		}
		if (sumVote1 >= 0.5*sumThresh){
			return 1
		}else{
			return 0
		}
	}

	func predictSoft(samples: Matrix)->[[Int: Double]] {
		return [[:]]
	}
}