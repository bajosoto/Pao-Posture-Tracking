import XCTest
import Nifty
@testable import classifier

class operatorTests: XCTestCase {
    
    func testEqInt(){
        let A = Matrix<Int>([[1, 2],[3, 4]])
        XCTAssertTrue(A==A)
    }

    func testEqDouble(){
        let A = Matrix<Double>([[1, 2],[3, 4]])
        XCTAssertTrue(A==A)
    }

    func testEquals(){
        let A = Matrix<Double>([[1, 2],[3, 4]])
        XCTAssertTrue(equals(this:A,that:A,within:0.1))
    }

    func testNotEquals(){
        let A = Matrix<Double>([[1, 2],[3, 4]])
        let B = Matrix<Double>([[1, 2.2],[3, 4]])

        XCTAssertFalse(equals(this:A,that:B,within:0.1))
    }

    func testDiv(){
        let A = Matrix<Double>([[2, 2],[4, 4]])
        let B = Matrix<Double>([[1, 1],[2, 2]])
        XCTAssertTrue((A/2)==B)

    }

    func testMul(){
        let A = Matrix<Double>([[2, 2],[4, 4]])
        let B = Matrix<Double>([[1, 1],[2, 2]])
        XCTAssertTrue(A==(B*2))

    }

    static var allTests : [(String, (operatorTests) -> () throws -> Void)] {
        return [
            ("testEqInt",testEqInt),
            ("testEqDouble",testEqDouble),
            ("testEquals",testEquals),
            ("testNotEquals",testEquals),
            ("testDiv",testDiv),
            ("testMul",testMul),
        ]
    }
}
