class SimplePreprocessor: Preprocessor{
	
	let windowSize
	init(windowSize: Int = 10){
		self.windowSize = windowSize
	}

	func preprocess(measurements: [Measurement]) -> Sample{
		let average = averageFilter(measurements,windowSize)
		let peak2peak = getPeak2Peak(measurement)
		return	SimpleFeatureVector(Matrix<Double>[[average.gyroX,
													average.gyroY,
													average.gyroZ,
													average.accelX,
													average.accelY,
													average.accelZ,
													peak2peak]])
		
	}

	internal static func averageFilter(_ measurements: [Measurement],_ windowSize: Int)->Measurement{
		matrix: Matrix<Double> = zeros(measurements.count,measurements[0].toVector().columns)

		for i in 0 ..< measurements.count{
			matrix[i,0 ..< matrix.columns] = measurements[i].toVector()
		}

		return Measurement(mean_row(matrix))
	}

	internal static func getPeak2Peak(_ measurements: [Measurement]) -> Double{
		var maxDist = Double.greatestFiniteMagnitude
		for i in 0 ..< measurements.count{
			for j in 0 ..< measurements.count{
				vector1 = Matrix<Double>[[measurements[i].accelX,measurements[i].accelY],measurements[i].accelZ]]
				vector2 = Matrix<Double>[[measurements[j].accelX,measurements[j].accelY],measurements[j].accelZ]]

				dist = norm(vector1-vector2)
				if dist > maxDist{
					maxDist = dist
				}
			}
		}
		return maxDist
	}
}