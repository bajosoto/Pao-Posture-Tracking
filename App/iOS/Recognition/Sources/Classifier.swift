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
}