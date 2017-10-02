import Nifty
class LdaClassifier: Classifier{
	
	let means : [Matrix<Double>]
	let covariance : Matrix<Double>
	let priors: [Double]

	required init(trainset: Dataset){
		means = LdaClassifier.estimate_means(dataset:trainset)
		covariance = LdaClassifier.estimate_covariance(dataset:trainset)
		priors = LdaClassifier.estimate_priors(dataset:trainset)
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
		for i in 0 ..< means.count{
			var a = (sample^)*inv(covariance)*self.means[i]
			var b = log(priors[i])
			var c = (means[i]^)*inv(covariance)*means[i] 
			print("\(a)")
			print("\(b)")
			print("\(c)")
			//pdfs.append( a+b  - c)
		}
		return pdfs.max()!

	}
	
	static func estimate_means(dataset: Dataset)->[Matrix<Double>]{
		var means = [Matrix<Double>]()
		for i in 0 ..< dataset.classes.count{
			means.append(mean_row(matrix:(dataset.class_samples(class_id:i)))) 
		}
		return means
	}

	static func estimate_covariance(dataset: Dataset)->Matrix<Double>{
		return cov(matrix:dataset.samples)
	}

	static func estimate_priors(dataset: Dataset) -> [Double]{
		var priors = [Double]()
		for i in 0 ..< dataset.classes.count{
			priors.append(Double(dataset.class_samples(class_id:i).rows)/Double(dataset.samples.count)) 
		}
		return priors	
	}
        
}