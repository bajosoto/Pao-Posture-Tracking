class MyMatrix : CustomStringConvertible{
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

	var description : String{
		var s = String()
		for i in 0 ..< self.rows {
			s += "\n"
			for j in 0 ..< self.columns {
				s += "|\(self[i,j])"
			}
			s += "|"
		}
		return s
	}

	func plus(_ that: MyMatrix) throws -> MyMatrix {
		return try MatrixMath.plus(self,that)
	}

	func plus(_ that: Double) throws -> Double {
		return try MatrixMath.plus(self,that)
	}

	func minus(_ that: MyMatrix) throws -> MyMatrix {
		return try MatrixMath.minus(self,that)
	}

	func minus(_ that: Double) throws -> Double {
		return try MatrixMath.minus(self,that)
	}

	func times(_ that: MyMatrix) throws -> MyMatrix {
		return try MatrixMath.times(self,that)

	}

	func times(_ that: Double) throws -> MyMatrix {
		return try MatrixMath.times(self,that)

	}
	func div(_ that: Double) throws -> MyMatrix {
		return try MatrixMath.div(self,that)

	}
	
}