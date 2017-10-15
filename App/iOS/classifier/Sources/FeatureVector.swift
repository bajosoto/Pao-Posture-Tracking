import Nifty

protocol FeatureVector{

	func toVector()->Matrix<Double>
}