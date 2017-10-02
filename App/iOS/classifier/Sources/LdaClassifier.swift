import Nifty
class LdaClassifier: Classifier{
	
	var means = [Matrix<Double>]()
	var covariance : Matrix<Double>

	required init(trainset: Dataset){
		means = LdaClassifier.estimate_means(dataset:trainset)
		covariance = LdaClassifier.estimate_covariance(dataset:trainset)
	}

	func classify(samples: Matrix<Double>)->Vector<Int>{
		return Vector<Int>([1])
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
        
}