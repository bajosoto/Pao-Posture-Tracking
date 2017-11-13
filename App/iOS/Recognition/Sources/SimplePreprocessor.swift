class SimplePreprocessor: Preprocessor{
	
	let windowSize: Int
	init(_ windowSize: Int = 10){
		self.windowSize = windowSize
	}
	func preprocess(_ rawData: [RawSample]) throws -> [FeatureVector]{

		if(rawData.count < windowSize){
			throw PreprocessorError.NotEnoughSamples(rawData.count,windowSize)
		}
		var vectors = [FeatureVector]()

		var measurementWindow = [RawSample]()
		for i in 0 ..< rawData.count{	
			measurementWindow.append(rawData[i])
			if(i>0 && (i+1)%windowSize==0){
				vectors.append(preprocessWindow(measurementWindow))	
				measurementWindow = [RawSample]()
			}
		}
		return vectors
	}

	func preprocess(_ rawData: [RawSample], _ labels: [Int]) throws -> ([FeatureVector],[Int]){
		var labels_reduced = [Int]()
		for i in 0 ..< labels.count{
			//TODO replace this with majority vote
			if ((i+1)%windowSize==0){
				labels_reduced.append(labels[i])
			}
		}
		return (try self.preprocess(rawData),labels_reduced)
	}

	func preprocessWindow(_ rawData: [RawSample]) -> FeatureVector{
		let average = SimplePreprocessor.averageFilter(rawData)
		let peak2peak = SimplePreprocessor.getPeak2Peak(rawData)

		var vector = Matrix([[average.gyrX,
							average.gyrY,
							average.gyrZ,
							average.accX,
							average.accY,
							average.accZ,
							peak2peak]])
		
		return	FeatureVector(vector)
		
	}

	internal static func averageFilter(_ rawData: [RawSample])->RawSample{
		let matrix: Matrix = Matrix(rawData.count,rawData[0].toVector.columns)

		for i in 0 ..< rawData.count{
			matrix[i,0 ..< matrix.columns] = rawData[i].toVector
		}

		return RawSample(meanRow(matrix:matrix))
	}

	internal static func getPeak2Peak(_ rawData: [RawSample]) -> Double{
		var maxDist = -Double.greatestFiniteMagnitude
		for i in 0 ..< rawData.count{
			for j in 0 ..< rawData.count{
				let vector1 = Matrix([[rawData[i].accX,rawData[i].accY,rawData[i].accZ]])
				let vector2 = Matrix([[rawData[j].accX,rawData[j].accY,rawData[j].accZ]])

				let dist = norm(vector1-vector2)

				if (dist > maxDist){
					maxDist = dist
				}
			}
		}
		return maxDist
	}
}