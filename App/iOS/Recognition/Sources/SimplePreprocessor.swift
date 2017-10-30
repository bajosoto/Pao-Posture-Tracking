class SimplePreprocessor: Preprocessor{
	
	let windowSize: Int
	init(windowSize: Int = 10){
		self.windowSize = windowSize
	}
	func preprocess(measurements: [Measurement]) -> [FeatureVector]{
		var vectors = [FeatureVector]()

		var measurementWindow = [Measurement]()
		for i in 0 ..< measurements.count{	
			measurementWindow.append(measurements[i])
			if(i>0 && i%windowSize==0){
				vectors.append(preprocessWindow(measurementWindow))	
				measurementWindow = [Measurement]()
			}
		}
		return vectors
	}
	func preprocessWindow(_ measurements: [Measurement]) -> FeatureVector{
		let average = SimplePreprocessor.averageFilter(measurements)
		let peak2peak = SimplePreprocessor.getPeak2Peak(measurements)
		return	SimpleFeatureVector(Matrix([[average.gyroX,
													average.gyroY,
													average.gyroZ,
													average.accelX,
													average.accelY,
													average.accelZ,
													peak2peak]]))
		
	}

	internal static func averageFilter(_ measurements: [Measurement])->Measurement{
		let matrix: Matrix = Matrix(measurements.count,measurements[0].toVector().columns)

		for i in 0 ..< measurements.count{
			matrix[i,0 ..< matrix.columns] = measurements[i].toVector()
		}

		return Measurement(mean_row(matrix:matrix))
	}

	internal static func getPeak2Peak(_ measurements: [Measurement]) -> Double{
		var maxDist = -Double.greatestFiniteMagnitude
		for i in 0 ..< measurements.count{
			for j in 0 ..< measurements.count{
				let vector1 = Matrix([[measurements[i].accelX,measurements[i].accelY,measurements[i].accelZ]])
				let vector2 = Matrix([[measurements[j].accelX,measurements[j].accelY,measurements[j].accelZ]])

				let dist = norm(vector1-vector2)
				if (dist > maxDist){
					maxDist = dist
				}
			}
		}
		return maxDist
	}
}