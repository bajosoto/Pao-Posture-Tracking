protocol Preprocessor{

	func preprocess(_ rawData: [RawSample]) -> [FeatureVector]
	
}