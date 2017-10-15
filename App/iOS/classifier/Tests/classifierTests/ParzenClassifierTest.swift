import XCTest
import Nifty
@testable import classifier

class ParzenClassifierTest: XCTestCase {
    
 
    func testKernel(){
      let testsample = Matrix<Double>([[1,2]])
      let trainsample = Matrix<Double>([[0,0]])
      let result = ParzenClassifier.kernel(x:testsample,width: 1,mean:trainsample)

      print("Result \(result)")
    
    }

    func testSimpleClassif(){
         let samples = Matrix<Double>([[-1,-1],
                                        [1,1]])
        let labels = [1,2]
        let dataset =  Dataset(samples:samples,labels:labels)
        let parzenc = ParzenClassifier(trainset:dataset)
        let testsamples = Matrix<Double>([[-1,-1],
                                          [0,0],
                                          [1,1]])
        let results = parzenc.classify_soft(samples:testsamples)
        print("Results: \(results)")

    }

    func testClassif1(){
        let samples = Matrix<Double>([[-1,-2],
                                      [-15,-3],
                                      [-1,-27],
                                      [-17,-27],
                                      [-100,-27],
                                      [7,8],
                                      [9,27],
                                      [12,8],
                                      [13,9],
                                      [7,8]])
        let labels = [1,1,1,1,1,2,2,2,2,2]
        let dataset =  Dataset(samples:samples,labels:labels)
        let parzenc = ParzenClassifier(trainset:dataset)
        let testsamples = Matrix<Double>([[-15,-3]])
        let results = parzenc.classify(samples:testsamples)
        print("Results: \(results)")

    }



    static var allTests : [(String, (ParzenClassifierTest) -> () throws -> Void)] {
        return [
        	("testKernel",testKernel),
          ("testSimpleClassif",testSimpleClassif),
          ("testClassif1",testClassif1)
        ]
    }
}