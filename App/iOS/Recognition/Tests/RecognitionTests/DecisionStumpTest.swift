import XCTest

@testable import Recognition

class DecisionStumpTest: XCTestCase {

  func testDecision(){
       let sample = Matrix([[1,2,3]])
       XCTAssertEqual(DecisionStump.decision(sample,2,true,2.5),0)
       XCTAssertEqual(DecisionStump.decision(sample,2,false,2.5),1)
       XCTAssertEqual(DecisionStump.decision(sample,1,true,2.5),1)

  }

  func testInit(){
      let sample = Matrix([[1,2,3]])
      let sample2 = Matrix([[1,2,2.4]])

      let clf = DecisionStump(true,2,2.5)
      XCTAssertEqual(clf.classify(samples:sample)[0],0)
      XCTAssertEqual(clf.classify(samples:sample2)[0],1)

  }

  func testTraining(){
      let samples = Matrix([[1,1,0],
                            [1,1,0],
                            [1,1,1]])
      let labels = [1,1,2]
      let clf = DecisionStump(try! Dataset(samples:samples,labels:labels),eye(samples.rows,1))
      let predictions = clf.classify(samples:samples)

      XCTAssertEqual(predictions,labels)
       
  }

  func testClassifSoft(){
       XCTFail("Not implemented")
  }

	static var allTests : [(String, (DecisionStumpTest) -> () throws -> Void)] {
        return [
        	("testDecision", testDecision),
          ("testInit", testInit),
          ("testTraining", testTraining),
          ("testClassifSoft",testClassifSoft)
        ]
    }
}