import Nifty
protocol Classifier {
	init(trainset:Dataset,regularizer:Double)
	func classify(samples: Matrix<Double>)->[Int]
}