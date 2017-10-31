import XCTest

@testable import Recognition
class SimplePreprocessorTest: XCTestCase {

    func testAverageFilter(){
        let measurement1 = RawSample(Matrix([[1.0,1.0,1.0, 2.0,2.0,2.0]]))
        let measurement2 = RawSample(Matrix([[2.0,2.0,2.0, 1.0,1.0,1.0]]))

        let result = SimplePreprocessor.averageFilter([measurement1,measurement2])

        XCTAssertTrue(result.gyrX == 1.5)
        XCTAssertTrue(result.gyrY == 1.5)
        XCTAssertTrue(result.gyrZ == 1.5)
        XCTAssertTrue(result.accX == 1.5)
        XCTAssertTrue(result.accY == 1.5)
        XCTAssertTrue(result.accZ == 1.5)

    }

    func testPeak2Peak(){
        let measurement1 = RawSample(Matrix([[1.0,1.0,1.0, 0.0,0.0,0.0]]))
        let measurement2 = RawSample(Matrix([[2.0,2.0,2.0, 1.0,0.0,0.0]]))
        let measurement3 = RawSample(Matrix([[2.0,2.0,2.0, 0.2,0.2,0.2]]))

        let result = SimplePreprocessor.getPeak2Peak([measurement1,measurement2])

        XCTAssertTrue(result == 1.0, "Was \(result)")
    }

    func testPreprocessor(){
        let measurement1 = RawSample(Matrix([[1.0,1.0,1.0, 0.0,0.0,0.0]]))
        let measurement2 = RawSample(Matrix([[2.0,2.0,2.0, 1.0,0.0,0.0]]))
        let measurement3 = RawSample(Matrix([[2.0,2.0,2.0, 0.2,0.2,0.2]]))


        let preprocessor = SimplePreprocessor(windowSize:2)
        let featureVectors = preprocessor.preprocess([measurement1,measurement2,measurement3])
        //TODO inser assertion
    }
    
     static var allTests : [(String, (SimplePreprocessorTest) -> () throws -> Void)] {
        return [
          ("testAverageFilter",testAverageFilter),
          ("testPeak2Peak",testPeak2Peak),
          ("testPreprocessor",testPreprocessor),

        ]
    }
}