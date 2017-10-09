import Nifty
class KnnClassifier: Classifier{
	
	let trainset: Matrix<Double>

	required init(trainset: Dataset,regularizer: Double = 0.0001, kNeighbours: Int){
		self.trainset = trainset	
	}

	func classify(samples: Matrix<Double>)->[Int]{
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			labelsFound.append(self.classifySample(sample:samples[i,0..<samples.columns]))
			
		}
		return labelsFound
	}

	private func classifySample(sample: Matrix<Double>)->Int{
		var neighbours = [(distance:Double,label:Int)] = [:]
		var counts: [label:Int: count:Int] = [:]

		for i in 0 ..< trainset.nSamples{
			neighbours.append((dist(trainset.samples[i],sample),trainset.labels[i]))
		}
		neighbours = neighbours.sorted(by: {$0.distance < $1.distance})

		for k in kNeighbours ..< trainset.nSamples{
			kNeighbours = neighbours.prefix(k)
		
			for i in 0 ..< trainset.classes {
				counts[i] = kNeighbours.filter{$0.label == element}.count
			}

			counts = counts.sorted(by: {$0.count < $1.count})
			if (counts.prefix(1).count > counts.prefix(2).count){
				break
			} 	
		}
		return counts.prefix(1).label

		
	}

	private static func dist(this: Matrix<Double>,that: Matrix<Double>){
		var sum = 0
		for m in 0 ..< this.columns {
			sum += (this[i]-that[i])**2
		}
		return sqrt(sum)
	}
	
	
        
}