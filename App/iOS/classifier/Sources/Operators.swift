import Nifty

func equals(this: Matrix<Double>, that: Matrix<Double>, within: Double)-> Bool{
	for i in 0..<this.rows{
		for n in 0..<that.columns{
			if(abs(this[i,n] - that[i,n]) > within){
				return false
			}
		}
	}
	return true
}

func ==(this: Matrix<Double>, that: Matrix<Double>)-> Bool{
	return equals(this:this,that:that,within:Double(0.00000001))
}

func ==(this: Matrix<Int>, that: Matrix<Int>)-> Bool{
	for i in 0..<this.rows{
		for n in 0..<that.columns{
			if(this[i,n] != that[i,n]){
				return false
			}
		}
	}
	return true
}


func *(matrix: Matrix<Double>, mul:Double) -> Matrix<Double>{
	var result:Matrix<Double> = zeros(matrix.rows, matrix.columns)
	for i in 0..<matrix.rows{
		for n in 0..<matrix.columns{
			result = matrix[i,n]*mul
		}
	}
	return result
}

func /(matrix: Matrix<Double>, div:Double) -> Matrix<Double>{
	return matrix*(1/div)
}

func *(matrix: Matrix<Double>, mul: Int) -> Matrix<Double>{
	return matrix * Double(mul)
}

func /(matrix: Matrix<Double>, div: Int) -> Matrix<Double>{
	return matrix / Double(div)
}