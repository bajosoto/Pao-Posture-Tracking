import XCTest
import Nifty
@testable import classifier

class LdaClassifierTest: XCTestCase {
    
    func testMeans(){

    	let samples = Matrix<Double>([[1,2,3],
    								  [4,5,6],
    								  [7,8,9]])
    	let labels = [1,1,2]
        let dataset =  Dataset(samples:samples,labels:labels)
        let means = LdaClassifier.estimateMeans(dataset:dataset)

        print("\(means[0])")
        print("\(means[1])")

        XCTAssertTrue(means[0] == Matrix<Double>([[2.5,3.5,4.5]]),"\(means[0])")
        XCTAssertTrue(means[1] == Matrix<Double>([[7,8,9]]),"\(means[1])")
        
    }

    func testCov(){

        let samples = Matrix<Double>([[1,2,3],
                                      [4,5,6],
                                      [7,8,9]])
        let labels = [1,1,2]
        let dataset =  Dataset(samples:samples,labels:labels)
        let cov = LdaClassifier.estimateCov(dataset:dataset)

        XCTAssertTrue(cov == Matrix<Double>([[1,1,1],[1,1,1],[1,1,1]]))
        
    }

    func testPrior(){
        let samples = Matrix<Double>([[1,2,3],
                                      [4,5,6],
                                      [7,8,9],
                                      [7,8,9]])
        let labels = [1,1,2,2]
        let dataset =  Dataset(samples:samples,labels:labels)
        let priors = LdaClassifier.estimate_priors(dataset:dataset)

        XCTAssertTrue(priors[0]==0.5,"Priors_0 = \(priors[0])")
        XCTAssertTrue(priors[1]==0.5,"Priors_1 = \(priors[1])")

    }

    func testLDA(){
        let samples = Matrix<Double>([[1,2,3],
                                      [1,2,3],
                                      [7,8,9],
                                      [7,8,9]])
        let labels = [1,1,2,2]
        let dataset =  Dataset(samples:samples,labels:labels)
        let ldc = LdaClassifier(trainset:dataset)

        XCTAssertTrue(ldc.classifySample(sample:Matrix([[1,2,3]]))==1)
        XCTAssertTrue(ldc.classifySample(sample:Matrix([[7,8,9]]))==2)

        
    }

    func testLDA2(){
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
        let ldc = LdaClassifier(trainset:dataset)
        let testsamples = Matrix<Double>([  [-1,-2],
                                            [-1,-2],
                                            [-19,-21],
                                            [7,8],
                                            [15,9]])
        let results = ldc.classify(samples:testsamples)
        XCTAssertTrue(results[0]==1)
        XCTAssertTrue(results[1]==1)
        XCTAssertTrue(results[2]==2)
        XCTAssertTrue(results[2]==2)

        
    }



    static var allTests : [(String, (LdaClassifierTest) -> () throws -> Void)] {
        return [
        	("testMeans",testMeans),
            ("testCov",testCov),
            ("testPrior",testPrior),
            ("testLDA", testLDA),
            ("testLDA2", testLDA2)

        ]
    }
}