import XCTest

@testable import Recognition

class DatasetTest: XCTestCase {
    
    func testInit(){

    	let samples = Matrix([[1,2,3],
    								  [4,5,6],
    								  [7,8,9]])
    	let labels = [1,1,2]
        let dataset =  try! Dataset(samples:samples,labels:labels)
        XCTAssertEqual(dataset.dim,3)
        XCTAssertEqual(dataset.nSamples,3)
        XCTAssertEqual(dataset.classes,[1,2])
    }

    func testClassSamples(){
    	let samples = Matrix([[1,2,3],[4,5,6],[7,8,9]])
    	let labels = [1,1,2]
        let dataset =  try! Dataset(samples:samples,labels:labels)
        let result1 = dataset.classSamples(class_id:2)
        let result2 = dataset.classSamples(class_id:1)

        XCTAssertTrue(result1 == Matrix([[7,8,9]]),"\(result1)")
        XCTAssertTrue(result2 == Matrix([[1,2,3],
        								 [4,5,6]]),"\(result2)")

        XCTAssertTrue(result1.rows == 1)
        XCTAssertTrue(result2.rows == 2)


    }

    func testDimensionException(){
        let samples = Matrix([[1,2,3],[4,5,6],[7,8,9]])
        let labels = [1,2]
        do{
            try Dataset(samples:samples,labels:labels)
            XCTFail("Should have raised exception")
        }catch{}
    }

    static var allTests : [(String, (DatasetTest) -> () throws -> Void)] {
        return [
        	("testInit",testInit),
        	("testClassSamples",testClassSamples),
            ("testDimensionException",testDimensionException),
        ]
    }
}
