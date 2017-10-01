import XCTest
import Nifty
@testable import classifier

class utilsTests: XCTestCase {

	func testCov(){
	        let A = Matrix<Double>([[1, 2],[3, 4]])
	        let Result = Matrix<Double>([[0.5, 0.6],[0.5, 0.5]])
	        XCTAssertTrue(cov(matrix:A)==Result)
	    }

	static var allTests : [(String, (utilsTests) -> () throws -> Void)] {
        return [
        	("testCov",testCov),
    	]
	}
}