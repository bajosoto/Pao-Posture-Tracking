protocol Preprocessor{

	func preprocess(_ rawData: [RawSample]) throws -> [FeatureVector]
	
}