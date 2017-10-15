import XCTest
import Nifty
@testable import classifier

class SimplePreprocessorTest: XCTestCase {

    func testAverageFilter(){
        let measurement1 = Measurement(Matrix<Double>([[1.0,1.0,1.0, 2.0,2.0,2.0]]))
        let measurement2 = Measurement(Matrix<Double>([[2.0,2.0,2.0, 1.0,1.0,1.0]]))

        let result = SimplePreprocessor.averageFilter([measurement1,measurement2])

        XCTAssertTrue(result.gyroX == 1.5)
        XCTAssertTrue(result.gyroY == 1.5)
        XCTAssertTrue(result.gyroZ == 1.5)
        XCTAssertTrue(result.accelX == 1.5)
        XCTAssertTrue(result.accelY == 1.5)
        XCTAssertTrue(result.accelZ == 1.5)

    }

    func testPeak2Peak(){
        let measurement1 = Measurement(Matrix<Double>([[1.0,1.0,1.0, 0.0,0.0,0.0]]))
        let measurement2 = Measurement(Matrix<Double>([[2.0,2.0,2.0, 1.0,0.0,0.0]]))
        let measurement3 = Measurement(Matrix<Double>([[2.0,2.0,2.0, 0.2,0.2,0.2]]))

        let result = SimplePreprocessor.getPeak2Peak([measurement1,measurement2])

        XCTAssertTrue(result == 1.0, "Was \(result)")
    }

    func testPreprocessor(){
        let measurement1 = Measurement(Matrix<Double>([[1.0,1.0,1.0, 0.0,0.0,0.0]]))
        let measurement2 = Measurement(Matrix<Double>([[2.0,2.0,2.0, 1.0,0.0,0.0]]))
        let measurement3 = Measurement(Matrix<Double>([[2.0,2.0,2.0, 0.2,0.2,0.2]]))


        let preprocessor = SimplePreprocessor(windowSize:2)
        let featureVectors = preprocessor.preprocess(measurements:[measurement1,measurement2,measurement3])

        print(featureVectors)
    }
    
     static var allTests : [(String, (SimplePreprocessorTest) -> () throws -> Void)] {
        return [
          ("testAverageFilter",testAverageFilter),
          ("testPeak2Peak",testPeak2Peak),
          ("testPreprocessor",testPreprocessor),

        ]
    }
}