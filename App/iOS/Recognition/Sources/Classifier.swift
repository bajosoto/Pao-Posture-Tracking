protocol Classifier {
	/**
	 * [Constructor create a classifier object by training it from a dataset
	 * Depending on the chosen classifier and the amount of data this can
	 * take a while]
	 * @trainset: 		Dataset [Dataset with labelled samples]
	 * @regularizer:	Double 	[Regularization factor]
	 */
	init(trainset:Dataset,regularizer:Double)


	/**
	 * [classify one or several samples. Hard labelled classification]
	 * @samples 		Matrix 		[Samples to classify each row will be classified as one sample]
	 * @return			[Int]		[List of assigned class labels]
	 */
	func classify(samples: Matrix)->[Int]

	/**
	 * [classify one or several samples. Soft labelled classification]
	 * @samples 		Matrix 		[Samples to classify each row will be classified as one sample]
	 * @return			[Vector]	[Vectors containing the probability for each class]
	 */
	func classifySoft(samples: Matrix)->[[Int: Double]]
}