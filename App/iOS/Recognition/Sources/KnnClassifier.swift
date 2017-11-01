class KnnClassifier: Classifier{
	
	internal let trainset: Dataset
	internal let kNeighbours: Int
	internal var priors: [Int: Double] = [:]

	required init(trainset: Dataset,regularizer: Double = 0.0001){
		self.trainset = trainset
		self.kNeighbours = 2
		train()
	}

	required init(trainset: Dataset,regularizer: Double = 0.0001, kNeighbours: Int = 2){
		self.trainset = trainset
		self.kNeighbours = kNeighbours
		train()
	}

	internal func train(){
		for c in trainset.classes{
			print("Class: \(c)")
			priors.updateValue(Double(trainset.classSamples(class_id:c).rows)/Double(trainset.nSamples),forKey:c)
		}
	}

	func classify(samples: Matrix)->[Int]{
		var labelsFound = [Int]()
		for i in 0..<samples.rows{
			labelsFound.append(self.classifySample(sample:samples[i,0..<samples.columns]))
			
		}
		return labelsFound
	}

	internal func classifySample(sample: Matrix)->Int{
		return classifySample_soft(sample:sample).sorted(by: {$0.1 > $1.1})[0].key


	}

	internal func classifySample_soft(sample: Matrix)->[Int: Double]{
		var distances = [(distance:Double,label:Int)]()
		var proba: [Int: Double] = [:]
		var ranking = [(key: Int, value: Double)]()
		for i in 0 ..< trainset.nSamples{
			distances.append((KnnClassifier.dist(this:trainset.samples[i,0..<trainset.samples.columns],that:sample),trainset.labels[i]))
		}
		distances = distances.sorted(by: {$0.distance < $1.distance})

		for k in kNeighbours ..< trainset.nSamples{
			let neighbours = distances[0 ..< k]
			for c in trainset.classes {
				proba.updateValue(priors[c]!*Double((neighbours.filter({$0.label == c})).count)/Double(k), forKey:c)
			}

			ranking = proba.sorted(by: {$0.1 > $1.1})

			if (ranking[0].value > ranking[1].value){
				break
			} 	
		}
		// normalize
		var sum = 0.0
		for c in trainset.classes{
			sum += proba[c]!
		}
		for c in trainset.classes{
			proba.updateValue(proba[c]!/sum,forKey:c)
		}

		return proba

		
	}

	func classifySoft(samples: Matrix)->[[Int:Double]]{
		var softLabels:[[Int:Double]] = []
		for i in 0..<samples.rows{
			softLabels.append(self.classifySample_soft(sample:samples[i,0..<samples.columns]))
			
		}
		return softLabels
	}

	internal static func dist(this: Matrix,that: Matrix)->Double{
		//Euclidian distance
		return norm(this-that)
	}
	
	
        
}