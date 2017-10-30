struct Dataset{
	public let samples:Matrix
	public let labels:[Int]
	
	init(samples: Matrix, labels: [Int]){
		self.samples = samples
		self.labels = labels
	}

	var dim:Int{
		return samples.columns
	}
	var nSamples:Int{
		return samples.rows
	}
	var classes:[Int]{
		return unique(list:labels)
	}

	public func classSamples(class_id:Int) -> Matrix{
		var count = 0
		for i in 0..<labels.count{
			if(labels[i] == class_id){
				count+=1
			}
		}
		var n = 0
		var classSamples:Matrix = zeros(count,self.dim)
		for i in 0..<labels.count{
			if(labels[i] == class_id){
				classSamples[n,0..<self.dim] = samples[i,0..<self.dim]
				n+=1

			}
		}

		return classSamples
	}

}