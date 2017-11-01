import XCTest

@testable import Recognition

class PaoKnnClassifierTest: XCTestCase {

  class PostureEntry : IPostureEntry{
      var accX: Int16
      var accY: Int16
      var accZ: Int16
      var gyrX: Int16
      var gyrY: Int16
      var gyrZ: Int16
      var p2p: Double
      var posture: Double
      var postureLbl: String

      init(_ values: [Int16],_ label: Double){
          self.accX = values[0]
          self.accY = values[1]
          self.accZ = values[2]
          self.gyrX = values[3]
          self.gyrY = values[4]
          self.gyrZ = values[5]
          posture = label
          self.p2p = 0
          self.postureLbl = ""
        }
  }

	func testSimple(){
      var classSamples = [[PostureEntry]]()
      var samples = [PostureEntry]()
      for j in 0 ..< 6 {
        var l = [PostureEntry]()
        for i in 0 ..< 10{
          let i16 = Int16(i)
          l.append(PostureEntry([i16,i16,i16,i16,i16,i16],Double(j)))
        } 
        classSamples.append(l)
        samples.append(contentsOf:l) 
      }
      let classifier = PaoKnnClassifier(samples)
      for j in 0 ..< 6 {
          let prediction = classifier.classifySampleSoft(classSamples[j])
          print(prediction[0].posture)

      }
  }

  

	static var allTests : [(String, (PaoKnnClassifierTest) -> () throws -> Void)] {
        return [
            ("testSimple",testSimple)    	
        ]
    }
}