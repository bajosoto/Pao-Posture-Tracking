class MyMatrix{
	private var data: [[Double]]
	init(_ data:[[Double]]){
		self.data = data
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
	    return data[i]
	  }
	  set {
	    data[i][j] = newValue
	  }
	}
}