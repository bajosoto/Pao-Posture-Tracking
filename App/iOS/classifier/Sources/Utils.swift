import Nifty

func cov(matrix: Matrix<Double>) -> Matrix<Double>{
	var sum_covariance:Matrix<Double> = zeros(matrix.rows, matrix.rows)

    for i in 0..<matrix.rows{
        //sum_covariance += multiply(-(matrix[i,...],mean(matrix)),transpose(matrix[i,...],mean(matrix))
    }


    return sum_covariance/matrix.rows
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