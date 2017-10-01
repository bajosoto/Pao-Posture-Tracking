import XCTest
import Nifty
@testable import classifier

class utilsTests: XCTestCase {

	func testMean(){
		let A = Matrix<Double>([[1, 1],[3, 3]])
        let Solution = Matrix<Double>([[1.5, 1.5]])
	    let B = mean(matrix:A)
	    XCTAssertTrue(B==Solution,"\(B)")    
	}

	func testCov(){
	        let A = Matrix<Double>([[1, 2],[3, 4]])
	        let Solution = Matrix<Double>([[0.5, 0.5],[0.5, 0.5]])
	        let B = cov(matrix:A);
	        XCTAssertTrue(B==Solution,"\(B)")
	    }

	static var allTests : [(String, (utilsTests) -> () throws -> Void)] {
        return [
        	("testMean",testMean),
        	("testCov",testCov),
    	]
	}
}