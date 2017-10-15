import XCTest
import Nifty
@testable import classifier

class ParzenClassifierTest: XCTestCase {
    
 
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
       
        XCTAssertTrue(0.9999999 <= results[0][1]!)
        XCTAssertTrue(results[0][1]! <= 1.0)

        XCTAssertTrue(0.00001 >= results[0][2]!)
        XCTAssertTrue(results[0][2]! >= 0.0)

        XCTAssertTrue(0.49 <= results[1][1]!)
        XCTAssertTrue(results[1][1]! <= 0.51)

        XCTAssertTrue(0.49 <= results[1][2]!)
        XCTAssertTrue(results[1][2]! <= 0.51)

        XCTAssertTrue(0.9999999 <= results[2][2]!)
        XCTAssertTrue(results[2][2]! <= 1.0)

        XCTAssertTrue(0.00001 >= results[2][1]!)
        XCTAssertTrue(results[2][1]! >= 0.0)


    }

    func testClassif1(){
        let samples = Matrix<Double>([[-5,-5],
                                      [-5,-4],
                                      [-5,-6],
                                      [-4,-5],
                                      [5,5],
                                      [5,4],
                                      [5,6],
                                      [4,5]])
        let labels = [1,1,1,1,2,2,2,2]
        let dataset =  Dataset(samples:samples,labels:labels)
        let parzenc = ParzenClassifier(trainset:dataset)
        let testsamples = Matrix<Double>([  [-5,-4.5],
                                            [-4.5,-6],
                                            [5,4.5],
                                            [4.5,5]])
        let results = parzenc.classify(samples:testsamples)
        XCTAssertTrue(results[0]==1,"Was:\(results[0])")
        XCTAssertTrue(results[1]==1,"Was:\(results[1])")
        XCTAssertTrue(results[2]==2,"Was:\(results[2])")
        XCTAssertTrue(results[3]==2,"Was:\(results[3])")

    }



    static var allTests : [(String, (ParzenClassifierTest) -> () throws -> Void)] {
        return [
          ("testSimpleClassif",testSimpleClassif),
          ("testClassif1",testClassif1)
        ]
    }
}