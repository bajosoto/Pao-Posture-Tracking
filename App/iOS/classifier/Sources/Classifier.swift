import Nifty
protocol Classifier {
	init(trainset:Dataset,labels: Vector<Int>)
	func classify(samples: Matrix<Double>)->Vector<Int>
}