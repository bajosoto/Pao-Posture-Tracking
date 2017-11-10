class DecisionLeaf : DecisionNode{
	let trainset:Dataset


	init(_ trainset: Dataset){
		self.trainset = trainset
	}
	func predictSampleSoft(_ sample: Matrix) -> [Int: Double]{
		var probas = [Int: Double]()
		for m in trainset.classes{
			probas.updateValue(Double(trainset.labels.filter{$0==m}.count)/Double(trainset.nSamples),forKey:m)
		}
		return probas
	}
}