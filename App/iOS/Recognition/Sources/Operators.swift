public func equals(this: Matrix, that: Matrix, within: Double)-> Bool{
	for i in 0..<this.rows{
		for n in 0..<that.columns{
			if(abs(this[i,n] - that[i,n]) > within){
				return false
			}
		}
	}
	return true
}

public func *(matrix: Matrix, mul:Double) -> Matrix{
	return try? MatrixMath.times(matrix,mul)
}
public func *(_ mul: Double, _ matrix:Matrix) -> Matrix{
	return matrix*mul
}

public func /(matrix: Matrix, div:Double) -> Matrix{
	return matrix*(1/div)
}

public func /(_ div: Double, _ matrix: Matrix) -> Matrix {
	return matrix*(1/div)	
}

public func *(matrix: Matrix, mul: Int) -> Matrix{
	return matrix * Double(mul)
}

public func *(mul: Int,matrix: Matrix) -> Matrix{
	return matrix * Double(mul)
}

public func /(matrix: Matrix, div: Int) -> Matrix{
	return matrix / Double(div)
}

public func /(div: Int, matrix: Matrix) -> Matrix{
	return matrix / Double(div)
}

public func +(_ this: Matrix, _ that: Matrix) -> Matrix{
	return try? MatrixMath.plus(this,that)
}

public func +(_ this: Matrix, _ that: Double) -> Double{
	return try? MatrixMath.plus(this,that)
}

public func -(_ this: Matrix, _ that: Matrix) -> Matrix{
	return try? MatrixMath.minus(this,that)
}

public func -(_ this: Matrix, _ that: Double) -> Double{
	return try? MatrixMath.minus(this,that)
}

public func -(_ this: Double, _ that: Matrix) -> Double{
	return try? MatrixMath.minus(that,this)
}

public func +(_ this: Double, _ that: Matrix) -> Double{
	return try? MatrixMath.plus(that,this)
}