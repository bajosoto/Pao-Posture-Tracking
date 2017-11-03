import XCTest

@testable import Recognition

class DecisionStumpTest: XCTestCase {

  func testDecision(){
       let sample = Matrix([[1,2,3]])
       XCTAssertEqual(DecisionStump.decision(sample,2,true,2.5),0)
       XCTAssertEqual(DecisionStump.decision(sample,2,false,2.5),1)
       XCTAssertEqual(DecisionStump.decision(sample,1,true,2.5),1)
  
  }

  func testClassifSoft(){
       XCTFail("Not implemented")
  }

	static var allTests : [(String, (DecisionStumpTest) -> () throws -> Void)] {
        return [
        	("testDecision",testDecision),
          ("testClassifSoft",testClassifSoft)


        ]
    }
}