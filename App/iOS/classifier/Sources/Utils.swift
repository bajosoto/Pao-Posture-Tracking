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

    for i in 0..<matrix.columns{
        sum = sum + ((matrix[0..<matrix.rows,i]-mean_col(matrix:matrix)))*(matrix[0..<matrix.rows,i]-mean_col(matrix:matrix))^
    }

    return sum/(matrix.rows-1)
}

func unique<T where T:Comparable, T:Hashable>(list: [T])->[T]{
	return (Array<T>(Set<T>(list))).sorted(by:<)
}
