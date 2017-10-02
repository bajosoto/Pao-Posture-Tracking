import Nifty
protocol Classifier {
	init(trainset:Dataset)
	func classify(samples: Matrix<Double>)->Vector<Int>
}