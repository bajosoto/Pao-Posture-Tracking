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

      init(_ values: [Int16],_ label: String){
          self.accX = values[0]
          self.accY = values[1]
          self.accZ = values[2]
          self.gyrX = values[3]
          self.gyrY = values[4]
          self.gyrZ = values[5]
          posture = 0
          self.p2p = 0
          self.postureLbl = label
        }
  }

	func testSimple(){
      var classSamples = [[PostureEntry]]()
      var samples = [PostureEntry]()
      for j in 0 ..< 6 {
        var l = [PostureEntry]()
        for i in 0 ..< 10{
          let i16 = Int16(i)
          l.append(PostureEntry([i16,i16,i16,i16,i16,i16],lookupLabel(Double(j+1))))
        } 
        classSamples.append(l)
        samples.append(contentsOf:l) 
      }
      let classifier = PaoKnnClassifier(samples,windowSize:10,kNeighbours:2)
      for j in 0 ..< 6 {
          let prediction = classifier.classifySampleSoft(classSamples[j])
          //print(prediction[0].posture)

      }
  }

  func testNormalDistr(){


      /* Some random values generated with matlab
         each class follows a normal distribution around
         a different mean */
      var class1 = [
        [458,1077,573,-413,652,959],
        [1122,1080,1077,1974,1993,1697],
        [1962,1794,2790,1289,1428,1168],
        [746,2043,1797,2165,-5,-544],
        [2891,1802,557,91,367,-552],
        [-221,531,370,1240,-46,1867],
        [623,953,2533,345,1505,854],
        [1052,1353,3733,2274,1331,613],
        [-954,-257,1167,448,-636,2316],
        [1565,-37,521,912,-907,203],
        ]

      var class2 = [
        [2135,1168,1994,2625,1949,1915],
        [2417,2497,3107,2752,1187,2089],
        [2819,4315,1814,2213,1561,3456],
        [1145,1206,878,1229,2858,2219],
        [2357,2540,2246,1992,2195,1885],
        [4748,1440,3561,2093,2888,2068],
        [487,3976,803,2935,2069,2751],
        [2433,2544,1757,2663,4486,1310],
        [1770,1862,3004,1649,334,2450],
        [1172,2619,79,3619,1584,434],
      ]

      var class3 = [
        [2921,2818,2888,4048,3739,2444],
        [2058,2766,4295,3177,932,1648],
        [2347,1953,4781,3153,1845,3364],
        [3282,4583,2934,1745,2892,2547],
        [1874,2750,2744,1827,1287,3783],
        [2011,4294,3404,1538,2540,4237],
        [1484,3361,3351,1755,4091,4077],
        [771,2736,3807,2844,2836,2965],
        [2848,4082,2744,1385,2932,2496],
        [4162,3982,3715,5246,1998,1775],
      ]

      var class4 = [
        [4118,4892,4521,3931,4762,2862],
        [4959,3635,3008,4782,2817,4643],
        [3659,3173,3746,2579,4583,3987],
        [3826,4276,5009,4669,3419,4914],
        [4616,4459,4051,4683,3438,5107],
        [4863,3782,3559,3117,2444,4820],
        [2583,4796,3151,2495,5100,3182],
        [4199,2481,3759,4433,4175,3873],
        [4195,2925,4602,4808,5003,4264],
        [3848,927,2483,4578,5511,7158]
      ]

      var class5 = [
        [6226,3431,3775,4143,4469,6296],
        [7320,3155,2900,5048,5105,6099],
        [5414,5288,4609,4335,6128,5653],
        [5211,4049,5664,6452,5742,4494],
        [5613,4089,4297,6379,6143,4524],
        [4472,4838,5501,5095,4085,2948],
        [6241,4511,5540,4572,5179,4551],
        [4842,4777,5990,5510,4016,3448],
        [3626,5272,5989,4343,5384,5929],
        [5870,3831,4311,4874,5325,5901],
      ]

      var class6 = [
        [6138,6900,5376,5144,5722,6601],
        [5621,4468,4649,6007,7066,5325],
        [6143,6504,4837,5062,3900,4904],
        [7605,5135,5055,5318,6638,5732],
        [7349,5623,5328,5739,6371,6186],
        [5551,6788,6576,5771,5625,6950],
        [6168,6298,3914,5475,6695,5209],
        [4879,5836,6235,7128,6877,5510],
        [6400,6606,5221,6550,7033,8974],
        [6739,7634,7099,7855,6419,5377],
      ]

      var classes = [
        class1,
        class2,
        class3,
        class4,
        class5,
        class6
      ]
      /* Generate PostureEntries from the values*/
      var classSamples = [[PostureEntry]]()
      var samples = [PostureEntry]()
      for j in 0 ..< 6 {
        var l = [PostureEntry]()

        for i in 0 ..< 10{
          let class_ = classes[j]
          l.append(PostureEntry(class_[i].map{Int16($0)},lookupLabel(Double(j+1))))
        } 
        classSamples.append(l)
        samples.append(contentsOf:l) 
      }

      /* Train */
      let classifier = PaoKnnClassifier(samples,windowSize:2,kNeighbours:1)
      
      /* Predict
      *  just classifying the training data again to see if the code works*/
      for j in 0 ..< 6 {
          let predictions = classifier.classifySampleSoft(classSamples[j])

          for p in predictions{
              XCTAssertEqual(p.postureLbl,lookupLabel(Double(j+1)))

              /* Since we are classifying the training data with 1 nearest neighbour 
              *  healthy/unhealthy should just allways be 100%*/
              if(lookupLabel(p.postureLbl) == 1 ||
                lookupLabel(p.postureLbl) == 3 ||
                lookupLabel(p.postureLbl) == 5){
                XCTAssertEqual(p.posture,1.0)
              }else{
                XCTAssertEqual(p.posture,-1.0)

              }            
          }

      }
  }


  

	static var allTests : [(String, (PaoKnnClassifierTest) -> () throws -> Void)] {
        return [
            ("testSimple",testSimple),
            ("testNormalDistr",testNormalDistr)    	
        ]
    }
}