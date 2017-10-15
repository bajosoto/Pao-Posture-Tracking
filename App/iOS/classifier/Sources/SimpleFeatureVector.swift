import Nifty 

struct SimpleFeatureVector : FeatureVector{

	let gyroX: Double
	let gyroY: Double
	let gyroZ: Double
	let accelX: Double
	let accelY: Double
	let accelZ: Double
	let peak2peakAccel: Double

	init(_ vector: Matrix<Double>){
		gyroX = vector[0,0]
		gyroY = vector[0,1]
		gyroZ = vector[0,2]
		accelX = vector[0,3]
		accelY = vector[0,4]
		accelZ = vector[0,5]
		peak2peakAccel = vector[0,6]
	}

	func toVector()->Matrix<Double>{
		return Matrix<Double>([[gyroX,gyroY,gyroZ,accelX,accelY,accelZ,peak2peakAccel]])
	}
}
	