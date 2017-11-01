/**
 * Equal Scaler
 *
 * divide all values by its maximum on the training set
 * that way all features should be in the range of ~ -1..1
 */

class EqualScaler : Scaler {
	
	var factors:[Double]

	required init(_ m: Matrix){
		factors = [Double]()
		for i in 0 ..< m.columns{
			let maximum = max(m[ 0 ..< m.rows, i])
			let minimum = max(-1*m[ 0 ..< m.rows, i])
			factors.append(max(Matrix([[maximum,minimum]])))
		}
	}

	func transform(_ m:Matrix)->Matrix{
		var m_transform = Matrix(m.rows,m.columns)

		for i in 0 ..< m.columns{
			m_transform[ 0 ..< m.rows, i] = m[ 0 ..< m.rows, i]/factors[i]
		}	
		return m_transform
	}
}