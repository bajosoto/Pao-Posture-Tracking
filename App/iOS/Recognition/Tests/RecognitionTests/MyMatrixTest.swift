import XCTest
import Nifty
@testable import Recognition

class MyMatrixTest: XCTestCase {
    
    func testInit(){
        let matrix = MyMatrix([[1,2],[3,4]])
        XCTAssertTrue(true)
    }

    func testSubscript(){
        let matrix = MyMatrix([[1,2],[3,4]])
    	XCTAssertTrue(matrix[0,0] == 1)
        XCTAssertTrue(matrix[0,1] == 2)
        XCTAssertTrue(matrix[1,0] == 3)
        XCTAssertTrue(matrix[1,1] == 4)

    }

    func testSubscriptRow(){
        let matrix = MyMatrix([[1,2],[3,4]])
        let row1 = matrix[0]
        let row2 = matrix[1]

        XCTAssertEqual(row1[0,0],1)
        XCTAssertEqual(row1[0,1],2)
        XCTAssertEqual(row2[0,0],3)
        XCTAssertEqual(row2[0,1],4)
        
    }


    func testRowsCols(){
        let matrix = MyMatrix([[1,2],[3,4],[5,6]])
        XCTAssertEqual(matrix.rows,3)
        XCTAssertEqual(matrix.columns,3)

        
    }

    static var allTests : [(String, (MyMatrixTest) -> () throws -> Void)] {
        return [
        	("testInit",testInit),
        	("testSubscript",testSubscript),
            ("testSubscriptRow",testSubscriptRow),
            ("testRowsCols",testRowsCols),

        ]
    }
}
