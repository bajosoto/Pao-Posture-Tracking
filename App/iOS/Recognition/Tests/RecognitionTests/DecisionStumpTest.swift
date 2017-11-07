import XCTest

@testable import Recognition

class DecisionStumpTest: XCTestCase {

  func testDecision(){
       let sample = Matrix([[1,2,3]])
       XCTAssertEqual(DecisionStump.decision(sample,2,true,2.5),1)
       XCTAssertEqual(DecisionStump.decision(sample,2,false,2.5),0)
       XCTAssertEqual(DecisionStump.decision(sample,1,true,2.5),0)

  }

  func testInit(){
      let sample = Matrix([[1,2,3]])
      let sample2 = Matrix([[1,2,2.4]])

      let clf = DecisionStump(true,2,2.5,[0,1])
      XCTAssertEqual(clf.predict(samples:sample)[0],1)
      XCTAssertEqual(clf.predict(samples:sample2)[0],0)

  }

  func testTraining(){
      let samples = Matrix([[1,1,0],
                            [1,1,0],
                            [1,1,1]])
      let labels = [0,0,1]
      let clf = DecisionStump(try! Dataset(samples:samples,labels:labels),ones(samples.rows,1)/samples.rows)
      let predictions = clf.predict(samples:samples)

      XCTAssertEqual(predictions,labels)
       
  }

  func testTrainingOtherLabels(){
      let samples = Matrix([[1,1,0],
                            [1,1,0],
                            [1,1,1]])
      let labels = [1,1,2]
      let clf = DecisionStump(try! Dataset(samples:samples,labels:labels),ones(samples.rows,1)/samples.rows)
      let predictions = clf.predict(samples:samples)

      XCTAssertEqual(predictions,labels)
      
  }

  func testWeightedClassification(){
      let samples = Matrix([[0,1,0],
                            [0,1,0],
                            [1,1,1],
                            [0,1,1],
                            [0,1,1]])
      let labels = [0,0,0,1,1]
      let weights = Matrix([[0.1,0.1,0.4,0.2,0.2]])
      let clf = DecisionStump(try! Dataset(samples:samples,labels:labels),weights.T)
      let predictions = clf.predict(samples:samples)

      XCTAssertEqual(predictions,[1,1,0,1,1])
      
  }


  func testClassifSoft(){
       XCTFail("Not implemented")
  }

	static var allTests : [(String, (DecisionStumpTest) -> () throws -> Void)] {
        return [
        	("testDecision", testDecision),
          ("testInit", testInit),
          ("testTraining", testTraining),
          ("testTrainingOtherLabels", testTrainingOtherLabels),
          ("testClassifSoft",testClassifSoft),
          ("testWeightedClassification",testWeightedClassification)
        ]
    }
}