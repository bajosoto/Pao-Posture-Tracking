protocol Classifier {
	/**
	 * [Constructor create a classifier object by training it from a dataset
	 * Depending on the chosen classifier and the amount of data this can
	 * take a while]
	 * @trainset: 		Dataset [Dataset with labelled samples]
	 */
	init(trainset:Dataset)


	/**
	 * [predict one or several samples. Hard labelled classification]
	 * @samples 		Matrix 		[Samples to predict each row will be classified as one sample]
	 * @return			[Int]		[List of assigned class labels]
	 */
	func predict(samples: Matrix)->[Int]

	/**
	 * [predict one or several samples. Soft labelled classification]
	 * @samples 		Matrix 		[Samples to predict each row will be classified as one sample]
	 * @return			[Vector]	[Vectors containing the probability for each class]
	 */
	func predictSoft(samples: Matrix)->[[Int: Double]]

	/**
	 * [predict one samples. Soft labelled classification]
	 * @samples 		Matrix 		[Samples to predict first row will be classified as one sample]
	 * @return			[Vector]	[Vectors containing the probability for each class]
	 */
	func predictSampleSoft(_ sample: Matrix)->[Int: Double]
}

extension Classifier {
	func predict(samples: Matrix)->[Int] {
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			labelsFound.append(self.predictSample(sample:samples[i]))
			
		}
		return labelsFound
	}

	internal func predictSample(sample: Matrix) -> Int{
		return predictSoft(samples:sample)[0].sorted(by: {$0.1 > $1.1})[0].key
		
	}

	func predictSoft(samples: Matrix)->[[Int: Double]] {
		var softLabels:[[Int:Double]] = []
		for i in 0..<samples.rows{
			softLabels.append(self.predictSampleSoft(samples[i,0..<samples.columns]))
			
		}
		return softLabels
	}
}


	

	
	