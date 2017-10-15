import Nifty

func mean_row(matrix: Matrix<Double>)->Matrix<Double>{
	var sum:Matrix<Double> = zeros(1,matrix.columns)
	for i in 0..<matrix.rows{
        sum = sum + matrix[i,0..<matrix.columns]
    }
    return sum/matrix.rows
}

func mean_col(matrix: Matrix<Double>)->Matrix<Double>{
	return transpose(mean_row(matrix:matrix^))
}

func cov(matrix: Matrix<Double>) -> Matrix<Double>{
	var sum:Matrix<Double> = zeros(matrix.columns, matrix.columns)

    for i in 0..<matrix.rows{
        sum = sum + (matrix[i,0..<matrix.columns]-mean_row(matrix:matrix))^ * ((matrix[i,0..<matrix.columns]-mean_row(matrix:matrix)))
    }

    return sum/(matrix.rows-1)
}

func unique<T where T:Comparable, T:Hashable>(list: [T])->[T]{
	return (Array<T>(Set<T>(list))).sorted(by:<)
}

func euler()-> Double{
    return 2.7182818284
}

func pi() -> Double{
    return 3.14159265359
}

func ln(x: Double)->Double{
    return log(x)/log(euler())

}

func norm(_ m: Matrix<Double>) -> Double{
    var sum:Double = 0
    for i in 0 ..< m.columns {
        for j in 0 ..< m.rows {
        sum += pow(m[j,i],2)
        }
    }
    return sqrt(sum)
}