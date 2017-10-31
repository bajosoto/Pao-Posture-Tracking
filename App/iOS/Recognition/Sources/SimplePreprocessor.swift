class SimplePreprocessor: Preprocessor{
	
	let windowSize: Int
	init(windowSize: Int = 10){
		self.windowSize = windowSize
	}
	func preprocess(rawData: [RawDataEntry]) -> [FeatureVector]{
		var vectors = [FeatureVector]()

		var measurementWindow = [RawDataEntry]()
		for i in 0 ..< rawData.count{	
			measurementWindow.append(rawData[i])
			if(i>0 && i%windowSize==0){
				vectors.append(preprocessWindow(measurementWindow))	
				measurementWindow = [RawDataEntry]()
			}
		}
		return vectors
	}
	func preprocessWindow(_ rawData: [RawDataEntry]) -> FeatureVector{
		let average = SimplePreprocessor.averageFilter(rawData)
		let peak2peak = SimplePreprocessor.getPeak2Peak(rawData)

		var vector = Matrix([[average.gyroX,
							average.gyroY,
							average.gyroZ,
							average.accelX,
							average.accelY,
							average.accelZ,
							peak2peak]])
		
		vector = vector/norm(vector)

		return	FeatureVector(vector)
		
	}

	internal static func averageFilter(_ rawData: [RawDataEntry])->RawDataEntry{
		let matrix: Matrix = Matrix(rawData.count,rawData[0].toVector().columns)

		for i in 0 ..< rawData.count{
			matrix[i,0 ..< matrix.columns] = rawData[i].toVector()
		}

		return RawDataEntry(mean_row(matrix:matrix))
	}

	internal static func getPeak2Peak(_ rawData: [RawDataEntry]) -> Double{
		var maxDist = -Double.greatestFiniteMagnitude
		for i in 0 ..< rawData.count{
			for j in 0 ..< rawData.count{
				let vector1 = Matrix([[rawData[i].accelX,rawData[i].accelY,rawData[i].accelZ]])
				let vector2 = Matrix([[rawData[j].accelX,rawData[j].accelY,rawData[j].accelZ]])

				let dist = norm(vector1-vector2)
				if (dist > maxDist){
					maxDist = dist
				}
			}
		}
		return maxDist
	}
}