class DecisionLeaf : DecisionNode{
	let trainset:Dataset


	init(_ trainset: Dataset){
		self.trainset = trainset
	}
	func predictSoftSample(_ sample: Matrix) -> [Int]{
		var probas = [Int]()
		for m in trainset.classes{
			probas.append(trainset.labels.filter{$0==m}.count/trainset.nSamples)
		}
		return probas
	}
}