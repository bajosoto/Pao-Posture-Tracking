import Nifty

func mean(matrix: Matrix<Double>)->Matrix<Double>{
	var sum:Matrix<Double> = zeros(1,matrix.columns)
	for i in 0..<matrix.rows{
		print("\(matrix[i,0..<matrix.columns])")
        sum = sum + matrix[i]
    }
    return sum/matrix.rows
}

func cov(matrix: Matrix<Double>) -> Matrix<Double>{
	var sum:Matrix<Double> = zeros(matrix.rows, matrix.rows)

    for i in 0..<matrix.rows{
        sum = sum + (matrix[i]-mean(matrix:matrix))*(transpose(matrix[i]-mean(matrix:matrix)))
    }


    return sum/matrix.rows
}


func unique(vector: Vector<Double>)->Int{
	var elements = [Double]()
	var unique = 0

	for i in 0..<vector.count{
		if(!elements.contains(vector[i])){
			elements.append(vector[i])
			unique+=1
		}
	}
	return unique
}