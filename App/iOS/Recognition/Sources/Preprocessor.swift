protocol Preprocessor{

	func preprocess(rawData: [RawDataEntry]) -> [FeatureVector]
	
}