 public class MagnitudeThetaPreprocessor: SimplePreprocessor{
	
	override func preprocessWindow(_ rawData: [RawSample]) -> FeatureVector{
		let average = SimplePreprocessor.averageFilter(rawData)
		let peak2peak = SimplePreprocessor.getPeak2Peak(rawData)

		var vector = Matrix([[average.theta,
							  average.phi,
							  peak2peak]])
		
		return	MagnitudeThetaVector(vector)
		
	}

}
