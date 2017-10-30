class MatrixMath {
	static func plus(_ this: MyMatrix, _ that: MyMatrix) throws -> MyMatrix {

		try checkDimAdd(this,that)
		return doPlus(this,that)
		
	}

	static func plus(_ this: MyMatrix, _ that: Double) throws -> Double {
		let mat = MyMatrix([[that]])
		let scalarMat = try plus(this,mat)
		return scalarMat[0,0]
	}

	static func minus(_ this: MyMatrix, _ that: MyMatrix) throws -> MyMatrix {

		try checkDimAdd(this,that)
		return doMinus(this,that)
		
	}

	static func minus(_ this: MyMatrix, _ that: Double) throws -> Double {
		let mat = MyMatrix([[that]])
		let scalarMat = try minus(this,mat)
		return scalarMat[0,0]
	}

	static func times(_ this: MyMatrix, _ that: MyMatrix) throws -> MyMatrix {
		try checkDimTimes(this,that)
		return doTimes(this,that)
	
	}

	static func times(_ this: MyMatrix, _ that: Double) throws -> MyMatrix {
		let out = MyMatrix(this.rows,this.columns)
		for i in 0 ..< this.rows {
			for j in 0 ..< this.columns {
				out[i,j] = this[i,j] * that
			}
		}
		return out		
	}

	static func div(_ this: MyMatrix, _ that: Double) throws -> MyMatrix {
		return try times(this,1.0/that)
	}

	internal static func checkDimAdd(_ this: MyMatrix, _ that: MyMatrix) throws{
		if(this.rows != that.rows){
			throw MatrixMathError.dimensionsDoNotMatch(this.rows,that.rows)
		}

		if(this.columns != that.columns){
			throw MatrixMathError.dimensionsDoNotMatch(this.columns,that.columns)
		}
	}

	internal static func checkDimTimes(_ this: MyMatrix, _ that: MyMatrix) throws{
		if(this.columns != that.rows){
			throw MatrixMathError.dimensionsDoNotMatch(this.columns,that.rows)
		}		
	}

	internal static func doPlus(_ this: MyMatrix,_ that: MyMatrix) -> MyMatrix {
		let out = MyMatrix(this.rows,this.columns)

		for i in 0 ..< this.rows {
			for j in 0 ..< this.columns {
				out[i,j] = this[i,j] + that[i,j]
			}
		}
		return out
	}

	internal static func doMinus(_ this: MyMatrix, _ that: MyMatrix) -> MyMatrix{
		let out = MyMatrix(this.rows,this.columns)

		for i in 0 ..< this.rows {
			for j in 0 ..< this.columns {
				out[i,j] = this[i,j] - that[i,j]
			}
		}
		return out
	}

	internal static func doTimes(_ this: MyMatrix, _ that: MyMatrix) -> MyMatrix {
		let out = MyMatrix(this.rows,that.columns)

		for i in 0 ..< this.rows {
			for j in 0 ..< that.columns {
				for k in 0 ..< that.rows {
					out[i,j] += this[i,k] * that[k,j]
				}
			}
		}
		return out
	}
}