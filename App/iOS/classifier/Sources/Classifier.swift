import Nifty
protocol Classifier {
	func train(trainset: Dataset)
	func classify(sample: Vector<Double>)
}