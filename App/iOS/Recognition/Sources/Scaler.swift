protocol Scaler {
	init(_ m: Matrix)

	func transform(_ m:Matrix)->Matrix
}