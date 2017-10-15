protocol Preprocessor{

	func preprocess(measurements: [Measurement]) -> [FeatureVector]
	
}