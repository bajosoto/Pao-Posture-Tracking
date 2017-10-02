import Nifty
class LdaClassifier: Classifier{
	
	let means : [Matrix<Double>]
	let covariance : Matrix<Double>
	let priors: [Double]
	let classes: [Int]

	required init(trainset: Dataset){
		means = LdaClassifier.estimateMeans(dataset:trainset)
		covariance = LdaClassifier.estimateCov(dataset:trainset)
		priors = LdaClassifier.estimatePriors(dataset:trainset)
		classes = trainset.classes
	}

	func classify(samples: Matrix<Double>)->[Int]{
		var labelsFound = [Int]()
		for i in 0..<samples.count{
			labelsFound.append(self.classifySample(sample:samples[i,0..<samples.columns]))
		}
		return labelsFound
	}

	func classifySample(sample: Matrix<Double>)->Int{
		var pdfs = [Int]()
		for i in self.classes{
			print("Sample = \n \(sample)")
			print("InvConv = \n\(inv(self.covariance))")
			print("Mean = \n \(self.means[i])")
			
			var a = (sample^)*inv(self.covariance)*self.means[i]
			var b = log(priors[i])
			var c = (self.means[i]^)*inv(self.covariance)*self.means[i] 
			print("A = \n \(a)")
			print("B = \n\(b)")
			print("C = \n \(c)")
			//pdfs.append( a+b  - c)
		}
		return self.classes[pdfs.max()!]

	}
	
	static func estimateMeans(dataset: Dataset)->[Matrix<Double>]{
		var means = [Matrix<Double>]()
		for i in dataset.classes{
			means.append(mean_row(matrix:(dataset.classSamples(class_id:i)))) 
		}
		return means
	}

	static func estimateCov(dataset: Dataset)->Matrix<Double>{
		return cov(matrix:dataset.samples)
	}

	static func estimatePriors(dataset: Dataset) -> [Double]{
		var priors = [Double]()
		for i in dataset.classes{
			priors.append(Double(dataset.classSamples(class_id:i).rows)/Double(dataset.samples.rows)) 
		}
		return priors	
	}
        
}