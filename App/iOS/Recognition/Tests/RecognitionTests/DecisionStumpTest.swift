import XCTest

@testable import Recognition

class DecisionStumpTest: XCTestCase {

  func testDecision(){
       let sample = Matrix([[1,2,3]])
       XCTAssertEqual(DecisionStump.decision(sample,2,true,2.5),1)
       XCTAssertEqual(DecisionStump.decision(sample,2,false,2.5),0)
       XCTAssertEqual(DecisionStump.decision(sample,1,true,2.5),0)

  }

  func testTraining(){
      let samples = Matrix([[1,1,0],
                            [1,1,0],
                            [1,1,1]])
      let labels = [0,0,1]
      let (bestCmp,bestThresh,bestFeature) = DecisionStump.train(try! Dataset(samples,labels),[Double](repeating: 1/3, count: 3))

      XCTAssertEqual(bestFeature,2)
      XCTAssertEqual(bestThresh,1.0)
      XCTAssertEqual(bestCmp,true)
       
  }

  func testTrainingOtherLabels(){
      let samples = Matrix([[1,1,0],
                            [1,1,0],
                            [1,1,1]])
      let labels = [1,1,5]
      let (bestCmp,bestThresh,bestFeature) = DecisionStump.train(try! Dataset(samples,labels),[Double](repeating: 1/3, count: 3))

      XCTAssertEqual(bestFeature,2)
      XCTAssertEqual(bestThresh,1.0)
      XCTAssertEqual(bestCmp,true)
      
  }

  func testTrainingMoreClasses(){
      let samples = Matrix([[1,1,0],
                            [1,1,0],
                            [1,1,0],
                            [1,1,1],
                            [1,1,1],
                            [1,1,1]])
      let labels = [1,2,2,3,4,4]
      let (bestCmp,bestThresh,bestFeature) = DecisionStump.train(try! Dataset(samples,labels),[Double](repeating: 1/3, count: 6))

      XCTAssertEqual(bestFeature,2)
      XCTAssertEqual(bestThresh,1.0)
      XCTAssertEqual(bestCmp,true)
      
  }

  /*
  func testInit(){
      let sample = Matrix([[1,2,3]])
      let sample2 = Matrix([[1,2,2.4]])

      let clf = DecisionStump(true,2,2.5,[0,1])
      XCTAssertEqual(clf.predict(samples:sample)[0],1)
      XCTAssertEqual(clf.predict(samples:sample2)[0],0)

  }

  
  func testWeightedClassification(){
      let samples = Matrix([[0,1,0],
                            [0,1,0],
                            [1,1,1],
                            [0,1,1],
                            [0,1,1]])
      let labels = [0,0,0,1,1]
      let weights = Matrix([[0.1,0.1,0.4,0.2,0.2]])
      let clf = DecisionStump(try! Dataset(samples,labels),weights.T)
      let predictions = clf.predict(samples:samples)

      XCTAssertEqual(predictions,[1,1,0,1,1])
      
  }

  func testImpurity(){
      let samples = Matrix([[0,1,0],
                            [0,1,0],
                            [1,1,1],
                            [0,1,1],
                            [0,1,1]])
      let labels = [0,0,0,1,1]
    
      //XCTAssertEqual(DecisionStump.impurity(try! Dataset(samples,labels)),0.0)
  }

  func testSplit(){
      let samples = Matrix([[0,1,0],
                            [0,1,0],
                            [1,1,1],
                            [0,1,1],
                            [0,1,1]])
      let labels = [0,0,0,1,1]
    
      let splits = DecisionStump.split(try! Dataset(samples,labels),[0,0,1,1,1])

      XCTAssertEqual(splits.0.samples, Matrix([[0,1,0],
                                               [0,1,0]]))
      XCTAssertEqual(splits.0.labels, [0,0])
      
      XCTAssertEqual(splits.1.samples, Matrix([[1,1,1],
                                               [0,1,1],
                                               [0,1,1]]))
      XCTAssertEqual(splits.1.labels, [0,1,1])
  }

  func testClassifSoft(){
       XCTFail("Not implemented")
  }*/

	static var allTests : [(String, (DecisionStumpTest) -> () throws -> Void)] {
        return [
        	("testDecision", testDecision),
          ("testTraining", testTraining),
          ("testTrainingOtherLabels", testTrainingOtherLabels),
          ("testTrainingMoreClasses",testTrainingMoreClasses),

/*          ("testInit", testInit),
          ("testClassifSoft",testClassifSoft),
          ("testWeightedClassification",testWeightedClassification),
*/
        ]
    }
}