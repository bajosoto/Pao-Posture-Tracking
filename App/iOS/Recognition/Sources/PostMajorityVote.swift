class PostMajorityVote: Postprocessor{

	let windowSize: Int
	init(_ windowSize : Int = 10){
		self.windowSize = windowSize
	}

	func postprocess(_ prediction: [Int]) throws -> [Int]{
		return [try postprocessWindow(prediction)]
	}
	
	public func postprocessWindow(_ prediction: [Int]) throws -> Int{
		var votes = [Int: Double]()
		for i in unique(list:prediction){
			votes[i] = 0.0
		}
		for i in unique(list:prediction){
			if(prediction[i] == i){
				votes[i]! += 1
			}
		}
		return votes.sorted(by: {$0.1 > $1.1})[0].key
	}

	public func postprocess(predictionSoft: [[Int: Double]]) throws -> [[Int: Double]]{
		return [try postprocessWindow(predictionSoft:predictionSoft)]
	}

	func postprocessWindow(predictionSoft: [[Int: Double]]) throws -> [Int: Double]{
		var matrix = Matrix(windowSize,predictionSoft[0].keys.count)
		for i in 0 ..< windowSize{
			//TODO check dimensions
			var probas = [Double]()
			for k in predictionSoft[i].keys {
				probas.append(predictionSoft[i][k]!)
			}
			matrix[i] = Matrix([probas])
		}
		let mean = meanRow(matrix:matrix)
		var result = [Int: Double]()
		var i = 0
		for k in predictionSoft[0].keys{
			result[k] = mean[0,i]
			i += 1 
		}

		return result
	}

}