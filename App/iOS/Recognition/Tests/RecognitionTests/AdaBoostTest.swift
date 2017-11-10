import XCTest

@testable import Recognition

class AdaBoostTest: XCTestCase {

	func testClassif(){
      let samples = Matrix([[0, 1, 0],
                            [0, 0, 0], 
                            [1, 1, 1], 
                            [0, 1, 1], 
                            [0, 0, 1], 
                            [0, 1, 1]])
      let labels = [1,1,1,2,2,2]

      let clf = AdaBoost(try! Dataset(samples,labels),1000)

      XCTAssertEqual(clf.predict(samples:samples),[0,0,0,1,1,1])
	}

	static var allTests : [(String, (AdaBoostTest) -> () throws -> Void)] {
        return [
        	("testClassif",testClassif),
        ]
    }
}