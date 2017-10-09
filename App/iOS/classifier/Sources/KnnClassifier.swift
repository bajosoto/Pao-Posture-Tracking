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
		var distances = [(distance:Double,label:Int)]()
		var counts: [Int: Int] = [:]
		var ranking = [(key: Int, value: Int)]()
		for i in 0 ..< trainset.nSamples{
			distances.append((KnnClassifier.dist(this:trainset.samples[i],that:sample),trainset.labels[i]))
		}
		distances = distances.sorted(by: {$0.distance < $1.distance})

		for k in kNeighbours ..< trainset.nSamples{
			let neighbours = distances[0 ..< k]
		
			for i in trainset.classes {
				counts.updateValue((neighbours.filter({$0.label == i})).count, forKey:i)
			}

			ranking = counts.sorted(by: {$0.0 < $1.0})
			if (ranking.prefix(1).count > ranking.prefix(2).count){
				break
			} 	
		}
		return ranking[0].value

		
	}

	public static func dist(this: Matrix<Double>,that: Matrix<Double>)->Double{
		//Euclidian
		var sum:Double = 0
		for i in 0 ..< this.columns {
			sum += (this[i]-that[i])**2
		}
		return sqrt(sum)
	}
	
	
        
}