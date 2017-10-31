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
public func inv(_ m: Matrix) throws ->Matrix{
    return eye(m.rows,m.columns)
}

public func cof(_ m: Matrix) throws ->Matrix{
    let cofM = Matrix(m.rows,m.columns)

    for i in 0 ..< m.rows{
        for j in 0 ..< m.columns{
            let submatrix = Matrix(m)
            submatrix.rmRow(i)
            submatrix.rmColumn(j)
            cofM[i,j] = try ((-1)**(1+i+1+j))*det(submatrix)
        }
    }
    return cofM
}

public func det(_ matrix: Matrix) throws -> Double{
    if( matrix.rows != matrix.columns ){
        throw MatrixMathError.dimensionsDoNotMatch(matrix.rows,matrix.columns)
    }
    return doDet(matrix)
}

internal func doDet(_ matrix: Matrix) -> Double{
    if(matrix.rows == 1){
        return matrix[0,0]
    }else{
        var d = 0.0
        for i in 0 ..< matrix.columns{
            let submatrix = Matrix(matrix)
            submatrix.rmRow(0)
            submatrix.rmColumn(i)
            d += matrix[0,i]*((-1)**(1+i+1))*doDet(submatrix)
        }
        return d
    }
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