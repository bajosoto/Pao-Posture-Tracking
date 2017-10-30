public func mean_row( matrix: Matrix)->Matrix{
	var sum:Matrix = Matrix(1,matrix.columns)
	for i in 0..<matrix.rows{
        sum = sum + matrix[i,0..<matrix.columns]
    }
    return sum/matrix.rows
}

public func mean_col(matrix: Matrix)->Matrix{
	return transpose(mean_row(matrix:matrix^))
}

public func cov(matrix: Matrix) -> Matrix{
	var sum:Matrix = Matrix(matrix.columns, matrix.columns)

    for i in 0..<matrix.rows{
        sum = sum + (matrix[i,0..<matrix.columns]-mean_row(matrix:matrix))^ * ((matrix[i,0..<matrix.columns]-mean_row(matrix:matrix)))
    }

    return sum/(matrix.rows-1)
}

public func unique<T where T:Comparable, T:Hashable>(list: [T])->[T]{
	return (Array<T>(Set<T>(list))).sorted(by:<)
}

public func euler()-> Double{
    return 2.7182818284
}

public func pi() -> Double{
    return 3.14159265359
}

public func ln(x: Double)->Double{
    return log(x)/log(euler())

}

public func norm(_ m: Matrix) -> Double{
    var sum:Double = 0
    for i in 0 ..< m.columns {
        for j in 0 ..< m.rows {
        sum += pow(m[j,i],2)
        }
    }
    return sqrt(sum)
}