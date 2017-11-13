class Predicition : IPostureEntry{
    var accX: Int16
    var accY: Int16
    var accZ: Int16
    var gyrX: Int16
    var gyrY: Int16
    var gyrZ: Int16
    var p2p: Double
    var posture: Double
    var postureLbl: String

    init(_ featureVector: FeatureVector, _ posture: Double, _ postureLbl: String = ""){
    	self.accX = Int16(featureVector.accelX)
    	self.accY = Int16(featureVector.accelY)
    	self.accZ = Int16(featureVector.accelZ)
    	self.gyrX = Int16(featureVector.gyroX)
    	self.gyrY = Int16(featureVector.gyroY)
    	self.gyrZ = Int16(featureVector.gyroZ)
    	self.p2p = featureVector.peak2peakAccel
    	self.posture = posture
    	self.postureLbl = postureLbl
    }
}