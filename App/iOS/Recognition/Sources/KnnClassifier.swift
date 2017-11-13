class KnnClassifier: Classifier{
	
	internal let trainset: Dataset
	internal let kNeighbours: Int
	internal var priors: [Int: Double] = [:]

	required convenience init(trainset: Dataset){
		self.init(trainset:trainset,kNeighbours:2)
	}

	required init(trainset: Dataset, kNeighbours: Int = 2){
		self.trainset = trainset
		self.kNeighbours = kNeighbours
		train()
	}

	internal func train(){
		for c in trainset.classes{
			priors.updateValue(Double(trainset.classSamples(class_id:c).rows)/Double(trainset.nSamples),forKey:c)
		}
	}

	internal func predictSampleSoft(_ sample: Matrix)->[Int: Double]{
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

	internal static func dist(this: Matrix,that: Matrix)->Double{
		//Euclidian distance
		return norm(this-that)
	}
	
	
        
}