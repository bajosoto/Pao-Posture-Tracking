class MyMatrix{
	var data: [[Double]]

	
	init(_ data:[[Double]]){
		self.data = data
	}

	init(_ data:[[Int]]){
		var dataDouble = [[Double]]()
		for row in data{
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

}