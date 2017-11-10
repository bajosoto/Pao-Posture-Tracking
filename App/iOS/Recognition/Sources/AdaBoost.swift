class AdaBoost : Classifier {
	
	let weights: Matrix
	let beta: [Double]
	let hypotheses: [Classifier]
	let totalI: Int
	let classes: [Int]
	required convenience init(trainset:Dataset){
		self.init(trainset,1000)
	}

	init(_ trainset: Dataset, _ maxI: Int){

		classes = trainset.classes
		let ret = AdaBoost.train(trainset,maxI)
		
		weights = ret.0
		beta = ret.1
		hypotheses = ret.2
		totalI = ret.3
	}

	internal static func train(_ trainset:Dataset,_ maxI: Int) -> (Matrix,[Double],[Classifier],Int){

		var weights = ones(maxI,trainset.nSamples)/trainset.nSamples
		var error = [Double]()
		var beta = [Double]()
		var hypotheses = [Classifier]()
		var totalI = 0
		for i in 0 ..< maxI {
			totalI = i
			//print("Total I: \(i)")
			//print("Weights: \(weights[i])")

			let	normedWeights = weights[i]/sum(weights[i])
			
			//print("Normed weights: \(normedWeights) = \(weights[i])/\(sum(weights[i]))")
			
			let clf = DecisionStump(trainset,normedWeights.array()[0])
			hypotheses.append(clf)
			
			let predictions = clf.predict(samples:trainset.samples)
			error.append(evaluate(clf,trainset,normedWeights))
			//print("Predictions: \(predictions)")
			
			//print("Error: \(error[i])")
			var beta_i = error[i]/(1-error[i])
			if (error[i] == 1.0){
				beta_i = 100
			}
			//print("Beta: \(beta_i)")
			beta.append(beta_i)
			let power = ones(trainset.nSamples,1)-abs(Matrix([predictions]) - Matrix([trainset.labels])).T

			//print("Power: \(power) = \((ones(trainset.nSamples,1)).T) - \((abs(Matrix([predictions]) - Matrix([trainset.labels])).T).T)")
			for j in 0 ..< power.rows{
				weights[i+1,j] = weights[i,j]*(beta[i]**power[j,0]) 
			}


			if ( i>1 && abs(error[i]-error[i-1]) <= 0.00001 ||
				error[i] == 0){
				break;
			}
		}

		return (weights,beta,hypotheses,totalI)
	}

	func predict(samples: Matrix)->[Int] {
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			labelsFound.append(self.predictSample(sample:samples[i]))
			
		}
		return labelsFound
	}

	internal func predictSample(sample: Matrix) -> Int{
		var sumVote1 = 0.0
		var sumThresh = 0.0
		for i in 0 ..< self.totalI {
			let clf = hypotheses[i]
			let logBeta = _log(1/beta[i])
			//print("logBeta: \(logBeta)")
			sumVote1 += logBeta*Double(Int(classes.index(of:clf.predict(samples:sample)[0])!))
			sumThresh += logBeta
			//print("sumVote1: \(sumVote1)")
			//print("sumThresh: \(sumThresh)")
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