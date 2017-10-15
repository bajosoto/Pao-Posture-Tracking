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
    
     static var allTests : [(String, (SimplePreprocessorTest) -> () throws -> Void)] {
        return [
          ("testSimpleClassif",testSimpleClassif),
          ("testClassif1",testClassif1),
          ("testClassif2",testClassif2)

        ]
    }
}