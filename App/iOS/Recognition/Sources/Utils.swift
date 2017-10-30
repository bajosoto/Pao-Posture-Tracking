public func mean_row( matrix: Matrix)->Matrix{
	var sum:Matrix = Matrix(1,matrix.columns)
	for i in 0..<matrix.rows{
        sum = sum + matrix[i]
    }
    return sum/matrix.rows
}

public func mean_col(matrix: Matrix)->Matrix{
	return (mean_row(matrix:matrix.T)).T
}

public func cov(matrix: Matrix) -> Matrix{
	var sum:Matrix = Matrix(matrix.columns, matrix.columns)

    for i in 0..<matrix.rows{
        sum = sum + (matrix[i]-mean_row(matrix:matrix)).T * ((matrix[i]-mean_row(matrix:matrix)))
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
    return _log(x)/_log(euler())

}

public func norm(_ m: Matrix) -> Double{
    var sum:Double = 0
    for i in 0 ..< m.columns {
        for j in 0 ..< m.rows {
        sum += m[j,i]*m[j,i]
        }
    }
    return sum.squareRoot()
}

public func sqrt(_ x: Double) -> Double{
   return x.squareRoot()
}

public func eye(_ rows: Int, _ cols: Int) -> Matrix{
    let mat = Matrix(rows,cols)
    for i in 0 ..< mat.columns {
        for j in 0 ..< mat.rows {
            if( i==j){
                mat[i,j] = 1.0
            }
        }
    }
    return mat
}