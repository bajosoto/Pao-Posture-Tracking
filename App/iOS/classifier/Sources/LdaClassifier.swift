import Nifty
class LdaClassifier: Classifier{
	
	let means : [Matrix<Double>]
	let covariance : Matrix<Double>
	let priors: [Double]
	let classes: [Int]

	required init(trainset: Dataset,regularizer: Double = 0.0001){
		means = LdaClassifier.estimateMeans(dataset:trainset)
		covariance = LdaClassifier.estimateCov(dataset:trainset,regularizer:regularizer)
		priors = LdaClassifier.estimatePriors(dataset:trainset)
		classes = trainset.classes
	}

	func classify(samples: Matrix<Double>)->[Int]{
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			print("Iclassify = \n \(i)")
			print("sample = \n (\(samples[i,0..<samples.columns])")
			labelsFound.append(self.classifySample(sample:samples[i,0..<samples.columns]))
		}
		return labelsFound
	}

	func classifySample(sample: Matrix<Double>)->Int{
		var maxI = 0
		var max:Double = -Double.greatestFiniteMagnitude
		for i in 0..<self.classes.count{
			print("I = \n \(i)")

			print("Sample = \n \(sample)")
			//print("InvConv = \n\(inv(self.covariance))")
			print("Mean = \n \(self.means[i])")
			
			var a = ((sample)*inv(self.covariance))*self.means[i]^
			var b = log(priors[i])
			var c = self.means[i]*inv(self.covariance)*self.means[i]^
			print("A = \n \(a[0,0])")
			print("B = \n\(b)")
			print("C = \n \(c)")

			var aScalar:Double = a[0,0]
			//var bScalar:Double = b[0,0]
			var cScalar:Double = c[0,0]

			var pdf = (aScalar + b - cScalar)
			print("Pdf = \n \(pdf)")
			
			if (pdf > max){
				print("Imax = \n \(i)")

				maxI = self.classes[i]
				max = pdf
			}
		}
		return maxI

	}
	
	static func estimateMeans(dataset: Dataset)->[Matrix<Double>]{
		var means = [Matrix<Double>]()
		for i in dataset.classes{
			means.append(mean_row(matrix:(dataset.classSamples(class_id:i)))) 
		}
		return means
	}

	static func estimateCov(dataset: Dataset,regularizer: Double)->Matrix<Double>{
		return cov(matrix:dataset.samples)+eye(dataset.dim,dataset.dim)*regularizer;
	}

	static func estimatePriors(dataset: Dataset) -> [Double]{
		var priors = [Double]()
		for i in dataset.classes{
			priors.append(Double(dataset.classSamples(class_id:i).rows)/Double(dataset.samples.rows)) 
		}
		return priors	
	}
        
}