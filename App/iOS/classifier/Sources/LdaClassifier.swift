import Nifty
class LdaClassifier: Classifier{
	
	var means: [Vector<Double>]()
	var covariance: [Matrix<Double>]()

	func init(trainset: Dataset){
		means = estimate_means(trainset:trainset)
		covariances = estimate_covariances(trainset:covariances)
	}

	func classify(sample: Vector<Double>){

	}
	
	static func estimate_means(trainset: Dataset)->Vector<Double>{
		
	}

	static func estimate_covariance(trainset: Dataset, means: Vector<Double>){
		
	}
        
}