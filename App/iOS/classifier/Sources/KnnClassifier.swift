import Nifty
class KnnClassifier: Classifier{
	
	let trainset: Dataset
	let kNeighbours: Int

	required init(trainset: Dataset,regularizer: Double = 0.0001){
		self.trainset = trainset
		self.kNeighbours = 2
	}

	required init(trainset: Dataset,regularizer: Double = 0.0001, kNeighbours: Int = 2){
		self.trainset = trainset
		self.kNeighbours = kNeighbours
	}

	func classify(samples: Matrix<Double>)->[Int]{
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			labelsFound.append(self.classifySample(sample:samples[i,0..<samples.columns]))
			
		}
		return labelsFound
	}

	private func classifySample(sample: Matrix<Double>)->Int{
		return classifySample_soft(sample:sample).sorted(by: {$0.1 > $1.1})[0].key


	}

	private func classifySample_soft(sample: Matrix<Double>)->[Int: Double]{
		var distances = [(distance:Double,label:Int)]()
		var proba: [Int: Double] = [:]
		var ranking = [(key: Int, value: Double)]()
		for i in 0 ..< trainset.nSamples{
			distances.append((KnnClassifier.dist(this:trainset.samples[i,0..<trainset.samples.columns],that:sample),trainset.labels[i]))
		}
		distances = distances.sorted(by: {$0.distance < $1.distance})
		print("Distances: \(distances)")

		for k in kNeighbours ..< trainset.nSamples{
			let neighbours = distances[0 ..< k]
			print("Neighbours: \(neighbours)")
			for c in trainset.classes {
				proba.updateValue(Double((neighbours.filter({$0.label == c})).count)/Double(k), forKey:c)
			}

			ranking = proba.sorted(by: {$0.1 > $1.1})

			if (ranking[0].value > ranking[1].value){
				break
			} 	
		}
		return proba

		
	}

	func classify_soft(samples: Matrix<Double>)->[[Int:Double]]{
		var softLabels:[[Int:Double]] = []
		for i in 0..<samples.rows{
			softLabels.append(self.classifySample_soft(sample:samples[i,0..<samples.columns]))
			
		}
		return softLabels
	}

	public static func dist(this: Matrix<Double>,that: Matrix<Double>)->Double{
		//Euclidian
		var sum:Double = 0
		for i in 0 ..< this.columns {
			sum += pow((this[i]-that[i]),2)
		}
		return sqrt(sum)
	}
	
	
        
}