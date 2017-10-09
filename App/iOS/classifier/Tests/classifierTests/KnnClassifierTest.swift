import XCTest
import Nifty
@testable import classifier

class KnnClassifierTest: XCTestCase {

	func testDist(){
		let sample1 = Matrix<Double>([[1,2,3]])
		let sample2 = Matrix<Double>([[4,5,6]])
		let res = KnnClassifier.dist(this:sample1,that:sample2)
		XCTAssertTrue(res < 5.1962,"Was \(res)")
		XCTAssertTrue(res > 5.1960,"Was \(res)")
	}

	static var allTests : [(String, (KnnClassifierTest) -> () throws -> Void)] {
        return [
        	("testDist",testDist)
        ]
    }
}