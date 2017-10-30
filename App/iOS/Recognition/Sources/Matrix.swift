public class Matrix : CustomStringConvertible, Equatable{
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

	public subscript(_ i: Int, _ j: Int) -> Double {
	  get {
	    return data[i][j]
	  }
	  set {
	    data[i][j] = newValue
	  }
	}

	public subscript(_ i: Int) -> Matrix {
	  get {
	    return Matrix([data[i]])
	  }
	}

	public subscript(_ i: Int, _ r: CountableClosedRange<Int>) -> Matrix {
	  get {
	  	let out:Matrix = Matrix(1,r.count)
	    for j in r{
	    	out[0,j] = self[i,j]
	    }
	    return out
	  }
	  set {
	  	for j in r{
	    	self[0,j] = newValue[0,j]
	    }
	  }
	}

	public subscript(_ i: Int, _ r: CountableRange<Int>) -> Matrix {
	  get {
	  	let out:Matrix = Matrix(1,r.count)
	    for j in r{
	    	out[0,j] = self[i,j]
	    }
	    return out
	  }
	  set {
	    for j in r{
	    	self[0,j] = newValue[0,j]
	    }
	  }
	}

	public var rows:Int{
		return data.count
	}

	public var columns:Int{
		return data[0].count
	}

	public var description : String{
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

	public static func ==(this: Matrix, that: Matrix) -> Bool {
        for i in 0..<this.rows{
			for n in 0..<that.columns{
				if(this[i,n] != that[i,n]){
					return false
				}
			}
		}
		return true
    }

    public var T:Matrix{
    	let transposed = Matrix(self.columns,self.rows)
    	for i in 0 ..< self.rows {
			for j in 0 ..< self.columns {
				transposed[j,i] = self[i,j]
			}
		}
		return transposed
    }
	
}