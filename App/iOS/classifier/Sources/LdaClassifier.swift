import Nifty
class LdaClassifier: Classifier{
	
	func train(trainset: Dataset){

	}

	func classify(sample: Vector<Double>){

	}
	

	func estimate_covariance(trainset: Dataset, means: Vector<Double>){
		/*sum_covariance = zeros(trainset.dim, trainset.dim)

        for n in range(0, trainset.nTotal):
            sample = trainset.objects[n]
            label = int(trainset.labels[n])
            diff = array([sample]) - means[label]
            sum_covariance += multiply(diff, diff.T)

        covariance = sum_covariance / trainset.nTotal

        return covariance*/
	}
        
}