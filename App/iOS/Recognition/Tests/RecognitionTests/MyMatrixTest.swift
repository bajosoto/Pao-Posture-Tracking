import XCTest
import Nifty
@testable import Recognition

class MyMatrixTest: XCTestCase {
    
    func testInit(){
        _ = MyMatrix([[1,2],[3,4]])
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
        XCTAssertEqual(matrix.columns,2)

        
    }

    func testPlus(){
        let matrix1 = MyMatrix([[1,2],[3,4]])
        let matrix2 = MyMatrix([[1,2],[3,4]])

        do{
            let result = try matrix1.plus(matrix2);
            XCTAssertTrue(result[0,0] == 2)
            XCTAssertTrue(result[0,1] == 4)
            XCTAssertTrue(result[1,0] == 6)
            XCTAssertTrue(result[1,1] == 8)    
        }catch {
            XCTFail("Improper exception")
        }
        
    }


    func testMinus(){
        let matrix1 = MyMatrix([[1,2],[3,4]])
        let matrix2 = MyMatrix([[2,2],[3,4]])

        do{
            let result = try matrix1.minus(matrix2);
            XCTAssertTrue(result[0,0] == -1)
            XCTAssertTrue(result[0,1] == 0)
            XCTAssertTrue(result[1,0] == 0)
            XCTAssertTrue(result[1,1] == 0)    
        }catch {
            XCTFail("Improper exception")
        }
        
    }

    func testMinusException(){
        let matrix1 = MyMatrix([[1,2],[3,4],[5,6]])
        let matrix2 = MyMatrix([[2,2],[3,4]])

        do{
            _ = try matrix1.minus(matrix2);
            XCTFail("No Error thrown")
        }catch {

        }
        
    }

    func testPlusException(){
        let matrix1 = MyMatrix([[1,2],[3,4],[5,6]])
        let matrix2 = MyMatrix([[2,2],[3,4]])

        do{
            _ = try matrix1.plus(matrix2);
            XCTFail("No Error thrown")
        }catch {
            
        }
    }


    func testTimes(){
        let matrix1 = MyMatrix([[1,2],[3,4]])
        let matrix2 = MyMatrix([[1,2],[3,4]])

        do{
            let result = try matrix1.times(matrix2)
            XCTAssertTrue(result[0,0] == 7)
            XCTAssertTrue(result[0,1] == 10)
            XCTAssertTrue(result[1,0] == 15)
            XCTAssertTrue(result[1,1] == 22)    
        }catch {
            XCTFail("Improper exception")
        }
    }

    func testTimes2(){
        let matrix1 = MyMatrix([[1,2]])
        let matrix2 = MyMatrix([[1,2],
                                [3,4]])

        do{
            let result = try matrix1.times(matrix2)
            XCTAssertTrue(result.rows == 1)
            XCTAssertTrue(result.columns == 2)
            XCTAssertTrue(result[0,0] == 7)
            XCTAssertTrue(result[0,1] == 10)
        }catch {
            XCTFail("Improper exception")
        }
    }


    func testTimesException(){
        let matrix1 = MyMatrix([[1,2],
                                [3,4]])
        let matrix2 = MyMatrix([[2,2]])

        do{
            _ = try matrix1.times(matrix2);
            XCTFail("No Error thrown")
        }catch {
            
        }
    }


    func testMinusScalar(){
        let matrix = MyMatrix([[2]])
        let scalar = 2.0
        do{
            let result = try matrix.minus(scalar);
            XCTAssertEqual(result,0)
        }catch {
            XCTFail("Improper exception")
        }   
    }

    func testPlusScalar(){
        let matrix = MyMatrix([[2]])
        let scalar = 2.0
        do{
            let result = try matrix.plus(scalar);
            XCTAssertEqual(result,4)
        }catch {
            XCTFail("Improper exception")
        } 
    }

    func testTimesScalar(){
        let matrix = MyMatrix([[1,2],
                                [3,4]])
        let scalar = 2.0
        do{
            let result = try matrix.times(scalar);
            XCTAssertTrue(result[0,0] == 2)
            XCTAssertTrue(result[0,1] == 4)
            XCTAssertTrue(result[1,0] == 6)
            XCTAssertTrue(result[1,1] == 8)    
        }catch {
            XCTFail("Improper exception")
        }         
    }

    func testMinusScalarException(){
        let matrix = MyMatrix([[2,2]])
        let scalar = 2.0
        do{
            let result = try matrix.minus(scalar);
            XCTFail("Should throw exception")
        }catch {
        }   
    }

    func testPlusScalarException(){
        let matrix = MyMatrix([[2],[2]])
        let scalar = 2.0
        do{
            let result = try matrix.plus(scalar);
            XCTFail("Should throw exception")
        }catch {
        } 
    }


    func testDiv(){
        XCTFail("Not implemented")
    }

    func testDivScalar(){
        XCTFail("Not implemented")
        
    }    

    static var allTests : [(String, (MyMatrixTest) -> () throws -> Void)] {
        return [
        	("testInit",testInit),
        	("testSubscript",testSubscript),
            ("testSubscriptRow",testSubscriptRow),
            ("testRowsCols",testRowsCols),
            ("testPlus",testPlus),
            ("testMinus",testMinus),
            ("testPlusException",testPlusException),
            ("testMinusException",testMinusException),
            ("testTimes",testTimes),
            ("testTimes2",testTimes2),
            ("testTimesException",testTimesException),
            ("testMinusScalar",testMinusScalar),
            ("testPlusScalar",testPlusScalar),
            ("testTimesScalar",testTimesScalar),
            ("testMinusScalarException",testMinusScalarException),
            ("testPlusScalarException",testPlusScalarException),
            


        ]
    }
}
