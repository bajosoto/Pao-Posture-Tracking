class EqualScaler : Scaler {
	
	var factors:[Double]

	required init(_ m: Matrix){
		factors = [Double]()
		for i in 0 ..< m.columns{
			factors.append(max(m[ 0 ..< m.rows, i]))
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