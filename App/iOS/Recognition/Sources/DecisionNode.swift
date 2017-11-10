protocol DecisionNode {
	func predictSoftSample(_ sample: Matrix)->[Int]
}