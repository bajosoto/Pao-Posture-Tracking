import XCTest

@testable import Recognition

class DecisionTreeTest: XCTestCase {


  func testImpurity(){
      let samples = Matrix([[0,1,0],
                            [0,1,0],
                            [1,1,1],
                            [0,1,1],
                            [0,1,1]])
   
      XCTAssertEqual(DecisionTree.impurity(try! Dataset(samples,[0,0,0,0,0])),0.0)
      XCTAssertTrue(DecisionTree.impurity(try! Dataset(samples,[0,1,0,0,0])) > 0.0)
  
  }

  func testWeightedImpurity(){
      let samples = Matrix([[0,1,0],
                            [0,1,0],
                            [1,1,1],
                            [0,1,1],
                            [0,1,1]])
   
      let higherWeight = DecisionTree.impurity(try! Dataset(samples,[0,1,0,0,0]),[0.2,0.4,0.2,0.1,0.1]) 
      let unweighed = DecisionTree.impurity(try! Dataset(samples,[0,1,0,0,0]))
      XCTAssertTrue( higherWeight > unweighed,"\(higherWeight) is not larger than \(unweighed)")  
  }

  func testWeightedImpurity2(){
      let samples = Matrix([[0,1,0],
                            [0,1,0],
                            [1,1,1],
                            [0,1,1],
                            [0,1,1]])
   
      XCTAssertEqual(DecisionTree.impurity(try! Dataset(samples,[0,0,0,0,0]),[0.2,0.4,0.2,0.1,0.1]),0.0)  
  }

      func testWeightedImpurity3(){
      let samples = Matrix([[1,1,1]])
   
      XCTAssertEqual(DecisionTree.impurity(try! Dataset(samples,[0]),[1.0]),0.0)  
  }


	static var allTests : [(String, (DecisionTreeTest) -> () throws -> Void)] {
        return [
        	("testImpurity",testImpurity),
          ("testWeightedImpurity",testWeightedImpurity),
          ("testWeightedImpurity2",testWeightedImpurity2),
          ("testWeightedImpurity3",testWeightedImpurity3),

          ]
    }
}