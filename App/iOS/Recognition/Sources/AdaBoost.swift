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

		var weights = ones(maxI+1,trainset.nSamples)/trainset.nSamples
		var error = [Double]()
		var beta = [Double]()
		var hypotheses = [Classifier]()
		var totalI = 0
		for i in 0 ..< maxI {
			totalI = i
			print("Total I: \(i)")
			//print("Weights: \(weights[i])")

			let	normedWeights = weights[i]/sum(weights[i])
			
			//print("Normed weights: \(normedWeights) = \(weights[i])/\(sum(weights[i]))")
			
			let clf = DecisionTree(trainset,weights:normedWeights.array()[0],maxDepth:trainset.classes.count-1)
			hypotheses.append(clf)
			
			let predictions = clf.predict(samples:trainset.samples)
			//print("Predictions: \(predictions)")

			error.append(evaluate(predictions,trainset,normedWeights))
			
			print("Error: \(error[i])")
			var beta_i = error[i]/(1-error[i])
			//print("Beta: \(beta_i)")
			beta.append(beta_i)
			let power = ones(trainset.nSamples,1)-lossFcn(predictions,trainset.labels)

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

	internal static func lossFcn( _ predictions: [Int], _ labels: [Int]) -> Matrix{
		var loss = Matrix(predictions.count,1)
		for i in 0 ..< predictions.count {
			if(predictions[i] != labels[i]){
				loss[i] = Matrix([[1.0]])
			}
		}
		return loss
	}

	internal func predictSample(sample: Matrix) -> Int{
		var probas = [Int: Double]()
		for m in classes{
			probas.updateValue(0.0,forKey:m)
		}
		for i in 0 ..< self.totalI {
			let clf = hypotheses[i]
			let logBeta = _log(1/beta[i])
			let predictedClass = clf.predict(samples:sample)[0]
			probas[predictedClass]! += logBeta
		}
		print(probas)
		return probas.sorted(by: {$0.1 > $1.1})[0].key
	}


	func predictSoft(samples: Matrix)->[[Int: Double]] {
		return [[:]]
	}
}