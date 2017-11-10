protocol DecisionNode {
	func predictSampleSoft(_ sample: Matrix)->[Int: Double]
}