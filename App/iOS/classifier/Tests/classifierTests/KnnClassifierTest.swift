import XCTest
import Nifty
@testable import classifier

class KnnClassifierTest: XCTestCase {

	func testDist(){
		let sample1 = Matrix<Double>([[1,2,3]])
		let sample2 = Matrix<Double>([[4,5,6]])
		let res = KnnClassifier.dist(this:sample1,that:sample2)
		XCTAssertTrue(res < 5.1962,"Was \(res)")
		XCTAssertTrue(res > 5.1960,"Was \(res)")
	}

	func testDist2(){
		let sample1 = Matrix<Double>([[-1,-2,-3]])
		let sample2 = Matrix<Double>([[-4,-5,-6]])
		let res = KnnClassifier.dist(this:sample1,that:sample2)
		XCTAssertTrue(res < 5.1962,"Was \(res)")
		XCTAssertTrue(res > 5.1960,"Was \(res)")
	}


	func testClassif1(){
		 let samples = Matrix<Double>([[-1,-2],
                                      [-15,-3],
                                      [-1,-27],
                                      [-17,-27],
                                      [-100,-27],
                                      [7,8],
                                      [9,27],
                                      [12,8],
                                      [13,9],
                                      [7,8]])
        let labels = [1,1,1,1,1,2,2,2,2,2]
        let dataset =  Dataset(samples:samples,labels:labels)
        let knnc = KnnClassifier(trainset:dataset)
        let testsamples = Matrix<Double>([[-15,-3]])
        let results = knnc.classify(samples:testsamples)
        XCTAssertTrue(results[0]==1,"Was:\(results[0])")
	}

	func testClassif2(){
		 let samples = Matrix<Double>([[-5,-5],
                                      [-5,-4],
                                      [-5,-6],
                                      [-4,-5],
                                      [5,5],
                                      [5,4],
                                      [5,6],
                                      [4,5]])
        let labels = [1,1,1,1,2,2,2,2]
        let dataset =  Dataset(samples:samples,labels:labels)
        let knnc = KnnClassifier(trainset:dataset)
        let testsamples = Matrix<Double>([  [-5,-4.5],
                                            [-4.5,-6],
                                            [5,4.5],
                                            [4.5,5]])
        let results = knnc.classify(samples:testsamples)
        XCTAssertTrue(results[0]==1,"Was:\(results[0])")
        XCTAssertTrue(results[1]==1,"Was:\(results[1])")
        XCTAssertTrue(results[2]==2,"Was:\(results[2])")
        XCTAssertTrue(results[3]==2,"Was:\(results[3])")
	}

	static var allTests : [(String, (KnnClassifierTest) -> () throws -> Void)] {
        return [
        	("testDist",testDist),
        	("testDist2",testDist2),
        	("testClassif1",testClassif1),
        	("testClassif2",testClassif2)

        ]
    }
}