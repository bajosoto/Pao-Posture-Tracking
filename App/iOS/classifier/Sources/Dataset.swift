import Nifty
struct Dataset{
	let samples:Matrix<Double>
	let labels:Vector<Int>
	
	init(samples: Matrix<Double>, labels: Vector<Int>){
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
		return unique(vector:labels)
	}

}