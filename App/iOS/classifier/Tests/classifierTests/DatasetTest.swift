import XCTest
import Nifty
@testable import classifier

class DatasetTest: XCTestCase {
    
    func testInit(){

    	let samples = Matrix<Double>([[1,2,3],
    								  [4,5,6],
    								  [7,8,9]])
    	let labels = Vector([1,1,2])
        let dataset =  Dataset(samples:samples,labels:labels)
        XCTAssertEqual(dataset.dim,3)
        XCTAssertEqual(dataset.nSamples,3)
        XCTAssertEqual(dataset.classes,[1,2])
    }

    func testClassSamples(){
    	let samples = Matrix<Double>([[1,2,3],[4,5,6],[7,8,9]])
    	let labels = Vector([1,1,2])
        let dataset =  Dataset(samples:samples,labels:labels)
        let result1 = dataset.class_samples(class_id:2)
        let result2 = dataset.class_samples(class_id:1)

        XCTAssertTrue(result1 == Matrix<Double>([[7,8,9]]),"\(result1)")
        XCTAssertTrue(result2 == Matrix<Double>([[1,2,3],
        										[4,5,6]]),"\(result2)")

    }

    static var allTests : [(String, (DatasetTest) -> () throws -> Void)] {
        return [
        	("testInit",testInit),
        	("testClassSamples",testClassSamples),

        ]
    }
}
