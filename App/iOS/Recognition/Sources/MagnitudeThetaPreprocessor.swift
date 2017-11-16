 public class MagnitudeThetaPreprocessor: SimplePreprocessor{
	
	override func preprocessWindow(_ rawData: [RawSample]) -> FeatureVector{
		let average = SimplePreprocessor.averageFilter(rawData)
		let magnitude = norm(Matrix([[average.accX,average.accY,average.accZ]]))

		var vector = Matrix([[average.theta,
							  average.phi,
							  magnitude]])
		
		return	MagnitudeThetaVector(vector)
		
	}

}
