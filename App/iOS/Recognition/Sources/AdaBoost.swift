class AdaBoost : Classifier {
	
	init(trainset:Dataset,regularizer:Double)

	internal func train(_ trainset:Dataset,_ maxI: Int) -> (Matrix,[Double],[Classifier],Int){

		var weights = ones(maxI,trainset.dim)
		var normedWeights = ones(maxI,trainset.dim) 
		var error = [Double]
		var beta = [Double]
		var hypotheses = [Classifier]
		var totalI = 0
		for i in 0 ..< maxI {
			totalI = i
			normedWeights[i,:] = weights[i,:]/norm(weights[i,:])

			let clf = DecisionStump(trainset,normedWeights[i,:])
			hypotheses.append(clf)
			
			predictions = clf.predict(trainset.samples)
			error.append(evaluate(clf,trainset,weights[i,:]))
			beta.append(error[i]/(1-error[i]))

			let power = ones(trainset.nSamples,1)-abs(Matrix([predictions]) - Matrix([trainset.labels]))
			
			for j in 0 ..< power.rows{
				weights[i,j] = (weights[i,j]*beta[i])**power[0,j] 
			}

			if ( i>1 && abs(error[i]-error[i-1]) <= 0.00001){
				break;
			}
		}

		return (weights,beta,hypotheses,totalI)
	}

	func predict(samples: Matrix)->[Int] {

	}

	internal func predictSample(sample: Matrix) -> Int{
		var sumVote1 = 0
		var sumThresh = 0
		for i in 0 ..< self.totalI {
			clf = hypotheses[i]
			let logBeta = log(1/beta[i])
			sumVote1 += logBeta*clf(sample)
			sumThresh += logBeta
		}
		if (sumVote1 >= 0.5*sumThresh){
			return 1
		}else{
			return 0
		}
	}

	func predictSoft(samples: Matrix)->[[Int: Double]]
}