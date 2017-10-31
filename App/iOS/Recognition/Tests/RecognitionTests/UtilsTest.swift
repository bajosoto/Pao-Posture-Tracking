import XCTest

@testable import Recognition
class UtilsTest: XCTestCase {

	func testMeanRow(){
		let A = Matrix([[1, 1],[2, 2]])
        let Solution = Matrix([[1.5, 1.5]])
	    let B = mean_row(matrix:A)
	    XCTAssertTrue(B==Solution,"\(B)")    
	}

	func testMeanRow2(){
		let A = Matrix([[1, 2],[3, 4]])
        let Solution = Matrix([[2, 3]])
	    let B = mean_row(matrix:A)
	    XCTAssertTrue(B==Solution,"\(B)")    
	}

	func testMeanCol(){
		let A = Matrix([[1, 1],[2, 2]])
        let Solution = Matrix([[1, 2]])
	    let B = mean_col(matrix:A)
	    XCTAssertTrue(B==Solution,"\(B)")    
	}


	func testTranspose(){

		let A = Matrix([[1, 2],[3, 4]])
        let Solution = Matrix([[1, 3],[2, 4]])
	    let B = A.T
	    XCTAssertTrue(B==Solution,"\(B)")    	
	}
	func testTranspose1(){
		let A = Matrix([[1, 2],[3, 4]])

        let Solution = Matrix([[1], [2]])
	    let B:Matrix = A[0,0...1].T
	    XCTAssertTrue(B==Solution,"\(B)")    	

	}
	func testTranspose2(){
		let A = Matrix([[1, 2],[3, 4]])

        let Solution = Matrix([[3], [4]])
	    let B:Matrix = (A[1,0...1]).T
	    XCTAssertTrue(B==Solution,"\(B)")    	
	}

	func testCov(){
        let A = Matrix([[1, 2],[3, 4]])
        let Solution = Matrix([[2, 2],[2, 2]])
        let B = cov(matrix:A);
        XCTAssertTrue(B==Solution,"\(B)")
    }

    func testUnique(){
    	let labels = [1,1,1,2,2,2,4,4,4,5,5,5,4,4,3,4,4]
    	let result = [1,2,3,4,5]
    	XCTAssertTrue(unique(list:labels).count==5)
    	XCTAssertEqual(unique(list:labels),result)

    }

    func testLn(){
    	  XCTAssertTrue(ln(x:2) <= 0.693148,"Was\(ln(x:2))")
          XCTAssertTrue(ln(x:2) >= 0.693146,"Was\(ln(x:2))")      
    }

    func testDet2(){
    	let m = Matrix([[1,2],
    					[2,3]])

    	XCTAssertEqual(try! det(m),-1)
    }
	func testDet3(){
    	let m = Matrix([[10,2,3],
    					[4,5,6],
    					[7,8,9]])

    	XCTAssertEqual(try! det(m),-27)
    }

    func testDet4(){
    	let m = Matrix([[10,2,3,1],
    					[4,5,6,2],
    					[7,8,9,3],
    					[4,3,2,1]])

    	XCTAssertEqual(try! det(m),-9)
    }

    func testDetUnequal(){
	 	let m = Matrix([[10,2,3,1],
    					[4,5,6,2],
    					[7,8,9,3]])
	 	do{
	 		try det(m)
	 		XCTFail("Should have thrown exception")
	 		}catch{

	 		}
    }

	static var allTests : [(String, (UtilsTest) -> () throws -> Void)] {
        return [
        	("testMeanRow",testMeanRow),
        	("testMeanRow2",testMeanRow2),
        	("testMeanCol",testMeanRow2),
        	("testTranspose",testTranspose), 	
        	("testTranspose1",testTranspose1), 	
        	("testTranspose2",testTranspose2), 	
        	("testCov",testCov),
        	("testUnique",testUnique),
            ("testLn",testLn),
            ("testDet2",testDet2),
            ("testDet3",testDet3),
            ("testDet4",testDet4),
            ("testDetUnequal",testDetUnequal),


    	]
	}
}