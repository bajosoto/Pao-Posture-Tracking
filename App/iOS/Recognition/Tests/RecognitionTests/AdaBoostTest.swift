import XCTest

@testable import Recognition

class AdaBoostTest: XCTestCase {

	func testClassif(){
      let samples = Matrix([[0, 1, 1, 1, 1],
                            [1, 0, 1, 1, 1],
                            [1, 1, 0, 1, 1],
                            [1, 1, 1, 0, 1],
                            [1, 1, 1, 1, 0]])
      let labels = [0,0,0,1,1]

      let clf = AdaBoost(try! Dataset(samples:samples,labels:labels),1000)

      print(clf.predict(samples:samples))
	}

	static var allTests : [(String, (AdaBoostTest) -> () throws -> Void)] {
        return [
        	("testClassif",testClassif),
        ]
    }
}