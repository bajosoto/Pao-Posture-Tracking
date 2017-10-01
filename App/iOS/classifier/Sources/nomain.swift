//#!/home/phil/Tools/swift/usr/bin/swift
import Nifty

func helloWorld(){
	print("Hello World")
	var x = Matrix<Double>([[1, 2, 3]])
	var y = Matrix<Double>([[4, 5, 6]])

	print(transpose(x))
	print("\(x+y)")
	print("Dimension: \(x.columns)")
}

