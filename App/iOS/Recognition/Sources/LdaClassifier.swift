class LdaClassifier: Classifier{
	
	let means 		 : [Matrix]
	let covariance 	 : Matrix
	let priors 	 	 : [Double]
	let classes 	 : [Int]
	var lnPriors 	 = [Double]()
	var covMeans 	 = [Matrix]()
	var meanCovMeans = [Double]()

	required init(trainset: Dataset,regularizer: Double = 0.0001){
		means = LdaClassifier.estimateMeans(dataset:trainset)
		covariance = LdaClassifier.estimateCov(dataset:trainset,regularizer:regularizer)
		priors = LdaClassifier.estimatePriors(dataset:trainset)
		classes = trainset.classes
		for i in 0 ..< self.classes.count {
			meanCovMeans.append(0.5*outerProd(vector:self.means[i],matrix: try! inv(self.covariance)))
			lnPriors.append(ln(x:priors[i]))
			covMeans.append(try! inv(self.covariance)*self.means[i].T)
		}
	}

	func classify(samples: Matrix)->[Int]{
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			labelsFound.append(self.classifySample(sample:samples[i,0..<samples.columns]))
			
		}
		return labelsFound
	}

	private func outerProd(vector: Matrix,matrix: Matrix)->Double{

		let v: Matrix = vector*matrix*vector.T
		return v[0,0] //the result is scalar but still stored in datatype matrix -.-
	}

	private func classifySample(sample: Matrix)->Int{
		var maxArg = 0
		var maxPosterior:Double = -Double.greatestFiniteMagnitude
		for i in 0..<self.classes.count{
			
			//just multiplying a vector with a matrix here and the result is a sampleDepPartScalar
			//this beatiful api doesnt seem to allow it nicer
			let sampleDepPartMat:Matrix = sample*covMeans[i] 
			let sampleDepPartScalar: Double = sampleDepPartMat[0,0] 

			let classPosterior = priors[i]*(sampleDepPartScalar-meanCovMeans[i]+lnPriors[i])
			
			if (classPosterior > maxPosterior){
				maxArg = self.classes[i]
				maxPosterior = classPosterior
			}
		}
		return maxArg

	}
	
	static func estimateMeans(dataset: Dataset)->[Matrix]{
		var means = [Matrix]()
		for i in dataset.classes{
			means.append(meanRow(matrix:(dataset.classSamples(class_id:i)))) 
		}
		return means
	}

	static func estimateCov(dataset: Dataset,regularizer: Double)->Matrix{
		var covariance = Matrix(dataset.dim,dataset.dim)
		let priors = estimatePriors(dataset:dataset)
		for i in dataset.classes{
			covariance = covariance + cov(matrix:dataset.classSamples(class_id:i))*priors[dataset.classes.index(of:i)!]
		}
		
		return covariance+eye(dataset.dim,dataset.dim)*regularizer;
	}

	static func estimatePriors(dataset: Dataset) -> [Double]{
		var priors = [Double]()
		for i in dataset.classes{
			priors.append(Double(dataset.classSamples(class_id:i).rows)/Double(dataset.samples.rows)) 
		}
		return priors	
	}
	func classifySoft(samples: Matrix)->[[Int:Double]]{
		return [[:]]
	}
}