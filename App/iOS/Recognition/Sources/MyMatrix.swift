class MyMatrix{
	var data: [[Double]]

	init(_ nrows:Int, _ ncols:Int){
		data = [[Double]]()
		for _ in 0 ..< nrows {
			var row = [Double]()
			for _ in 0 ..< ncols{
				row.append(0)
			}
			data.append(row)
		}
	}
	
	init(_ data:[[Double]]){
		self.data = data
	}

	init(_ data:[[Int]]){
		var dataDouble = [[Double]]()
		for row in data {
			var rowDouble = [Double]()
			for element in row {
				rowDouble.append(Double(element))
			}
			dataDouble.append(rowDouble)
		}
		
		self.data = dataDouble
	}

	subscript(_ i: Int, _ j: Int) -> Double {
	  get {
	    return data[i][j]
	  }
	  set {
	    data[i][j] = newValue
	  }
	}

	subscript(_ i: Int) -> MyMatrix {
	  get {
	    return MyMatrix([data[i]])
	  }
	}

	var rows:Int{
		return data.count
	}

	var columns:Int{
		return data[0].count
	}

	func plus(_ that: MyMatrix) -> MyMatrix {
		return MyMatrix.plus(self,that)
	}

	func minus(_ that: MyMatrix) -> MyMatrix {
		return MyMatrix.minus(self,that)
	}

	static func plus(_ this: MyMatrix, _ that: MyMatrix) -> MyMatrix {

		try? checkDimAdd(this,that)
		return doPlus(this,that)
		
	}

	static func minus(_ this: MyMatrix, _ that: MyMatrix) -> MyMatrix {

		try? checkDimAdd(this,that)
		return doMinus(this,that)
		
	}

	internal static func checkDimAdd(_ this: MyMatrix, _ that: MyMatrix) throws{
		if(this.rows != that.rows){
			throw MatrixMathError.dimensionsDoNotMatch(this.rows,that.rows)
		}

		if(this.rows != that.rows){
			throw MatrixMathError.dimensionsDoNotMatch(this.columns,that.columns)
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
}