import XCTest
import Nifty
@testable import classifier

class LdaClassifierTest: XCTestCase {
    
    func testMeans(){

    	let samples = Matrix<Double>([[1,2,3],
    								  [4,5,6],
    								  [7,8,9]])
    	let labels = Vector([1,1,2])
        let dataset =  Dataset(samples:samples,labels:labels)
        let means = LdaClassifier.estimate_means(dataset:dataset)

        XCTAssertTrue(means[0] == Matrix<Double>([[2.5,3.5,4.5]]))
        XCTAssertTrue(means[1] == Matrix<Double>([[7,8,9]]))
        
    }

    func testCov(){

        let samples = Matrix<Double>([[1,2,3],
                                      [4,5,6],
                                      [7,8,9]])
        let labels = Vector([1,1,2])
        let dataset =  Dataset(samples:samples,labels:labels)
        let cov = LdaClassifier.estimate_covariance(dataset:dataset)

        XCTAssertTrue(cov == Matrix<Double>([[1,1,1],[1,1,1],[1,1,1]]))
        
    }


    static var allTests : [(String, (LdaClassifierTest) -> () throws -> Void)] {
        return [
        	("testMeans",testMeans),

        ]
    }
}