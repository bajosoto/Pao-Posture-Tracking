import XCTest
import Nifty
@testable import classifier

class utilsTests: XCTestCase {

	func testMeanRow(){
		let A = Matrix<Double>([[1, 1],[2, 2]])
        let Solution = Matrix<Double>([[1.5, 1.5]])
	    let B = mean_row(matrix:A)
	    XCTAssertTrue(B==Solution,"\(B)")    
	}

	func testMeanRow2(){
		let A = Matrix<Double>([[1, 2],[3, 4]])
        let Solution = Matrix<Double>([[2, 3]])
	    let B = mean_row(matrix:A)
	    XCTAssertTrue(B==Solution,"\(B)")    
	}

	func testMeanCol(){
		let A = Matrix<Double>([[1, 1],[2, 2]])
        let Solution = Matrix<Double>([[1, 2]])
	    let B = mean_col(matrix:A)
	    XCTAssertTrue(B==Solution,"\(B)")    
	}


	func testTranspose(){

		let A = Matrix<Double>([[1, 2],[3, 4]])
        var Solution = Matrix<Double>([[1, 3],[2, 4]])
	    var B = A^
	    XCTAssertTrue(B==Solution,"\(B)")    	
	}
	func testTranspose1(){
		let A = Matrix<Double>([[1, 2],[3, 4]])

        var Solution = Matrix<Double>([[1], [2]])
	    var B:Matrix = A[0,0...1]^
	    XCTAssertTrue(B==Solution,"\(B)")    	

	}
	func testTranspose2(){
		let A = Matrix<Double>([[1, 2],[3, 4]])

        var Solution = Matrix<Double>([[3], [4]])
	    var B:Matrix = transpose(A[1,0...1])
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
        	("testMeanRow",testMeanRow),
        	("testMeanRow2",testMeanRow2),
        	("testMeanCol",testMeanRow2),
        	("testTranspose",testTranspose), 	
        	("testTranspose1",testTranspose1), 	
        	("testTranspose2",testTranspose2), 	

        	("testCov",testCov),
    	]
	}
}