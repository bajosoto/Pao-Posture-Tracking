class ParzenClassifier {

	internal let trainset: Dataset
	internal var width: Double
	internal var priors: [Int: Double] = [:]

	init(trainset:Dataset,regularizer:Double){
		self.trainset = trainset
		self.width = sqrt(Double(trainset.nSamples))/2
		self.width = train(trainset)
	}

	init(trainset:Dataset){
		self.trainset = trainset
		self.width = sqrt(Double(trainset.nSamples))/2
		self.width = train(trainset)
	}
	init(trainset:Dataset,regularizer:Double,maxApparentErr: Double, maxI: Int, learningRate: Double){
		self.trainset = trainset
		self.width = sqrt(Double(trainset.nSamples))/2
		self.width = train(trainset,maxApparentErr,maxI,learningRate)
	}

	internal func train(_ trainset: Dataset,_ maxApparentErr: Double = 0.000001, _ maxI: Int = 1000, _ learningRate: Double = 10.0)->Double{

		var errorLast = 1.0
		var width = self.width
		for c in trainset.classes{
			priors.updateValue(Double(trainset.classSamples(class_id:c).rows)/Double(trainset.nSamples),forKey:c)
		}
		for i in 0 ..< maxI{
			let error = getApparentError()
			if(abs(error - errorLast) <= maxApparentErr){
				break;
			}else{
				width = sqrt(Double(trainset.nSamples))/(Double((i+1))*learningRate)
				errorLast = error
			}
		}
		return width
	}

	func classify(samples: Matrix)->[Int]{
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			labelsFound.append(self.classifySample(sample:samples[i,0..<samples.columns]))
			
		}
		return labelsFound
	}

	internal func getApparentError()->Double{
		var error = 0.0
		for i in 0 ..< self.trainset.nSamples{
			if(classifySample(sample:self.trainset.samples[i,0..<trainset.dim]) != self.trainset.labels[i]){
				error += 1
			}
		}
		error /= Double(self.trainset.nSamples)
		return error;
	}

	internal func classifySample(sample: Matrix)->Int{
		return classifySampleSoft(sample:sample).sorted(by: {$0.1 > $1.1})[0].key
	}
	static internal func kernel(x: Matrix,width: Double, mean: Matrix)->Double{
		//Gaussian with unity covariance
		let normConst = 1.0/(2.0*pi())**(Double(x.rows)/2.0)
		let xMu = x-mean;
		let outerProd = (xMu*(xMu.T))*(-0.5)
		let scalar = outerProd[0,0]
		return normConst * (euler()**scalar)
	}

	func classifySoft(samples: Matrix)->[[Int:Double]]{
		var softLabels:[[Int:Double]] = []
		for i in 0..<samples.rows{
			softLabels.append(self.classifySampleSoft(sample:samples[i,0..<samples.columns]))
			
		}
		return softLabels
	}

	internal func classifySampleSoft(sample: Matrix)->[Int: Double]{
		var classLikelihoods: [Int: Double]=[:]
		for c in trainset.classes{
			classLikelihoods.updateValue(priors[c]!*getClassLikelihood(sample,c),forKey:c)
		}
		//normalize
		var sum = 0.0
		for c in trainset.classes{
			sum += classLikelihoods[c]!
		}
		for c in trainset.classes{
			classLikelihoods.updateValue(classLikelihoods[c]!/sum,forKey:c)
		}

		return classLikelihoods
	}

	internal func getClassLikelihood(_ sample: Matrix,_ class_: Int)->Double{
		var windowSum = 0.0
		for i in 0 ..< trainset.nSamples{
			if(trainset.labels[i] == class_){
				let x = (sample - trainset.samples[i,0..<trainset.samples.columns])/width
				windowSum += ParzenClassifier.kernel(x:x,width:self.width,mean:trainset.samples[i,0..<trainset.samples.columns])/Double(trainset.classSamples(class_id:class_).rows)
			}
		}
		return windowSum/(Double(trainset.classSamples(class_id:class_).rows) * width**sample.rows)

	}
}