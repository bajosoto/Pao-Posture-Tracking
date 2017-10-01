import Nifty
struct Dataset{
	let samples:Matrix<Double>
	let labels:Vector<Double>
	
	init(samples: Matrix<Double>, labels: Vector<Double>){
		self.samples = samples
		self.labels = labels
	}

	var dim:Int{
		return samples.columns
	}
	var nSamples:Int{
		return samples.rows
	}
}