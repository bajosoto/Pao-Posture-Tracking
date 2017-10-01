import XCTest
import Nifty
@testable import classifier

class DatasetTest: XCTestCase {
    
    func testInit(){

    	let samples = Matrix<Double>([[1,2,3],[4,5,6],[7,8,9]])
    	let labels = Vector([1,1,2])
        let dataset =  Dataset(samples:samples,labels:labels)
        XCTAssertEqual(dataset.dim,3)
        XCTAssertEqual(dataset.nSamples,3)
        XCTAssertEqual(dataset.classes,[1,2])
    }

    static var allTests : [(String, (DatasetTest) -> () throws -> Void)] {
        return [
        	("testInit",testInit)
        ]
    }
}
