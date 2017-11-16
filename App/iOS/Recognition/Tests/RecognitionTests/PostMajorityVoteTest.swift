import XCTest

@testable import Recognition
class PostMajorityVoteTest: XCTestCase {

    func testHardLabel(){
        var predictions = [1,2,2]
        var pp = PostMajorityVote(3)
        XCTAssertEqual(try! pp.postprocessWindow(predictions),2)

        predictions = [1,1,1,2,2]
        pp = PostMajorityVote(5)
        XCTAssertEqual(try! pp.postprocessWindow(predictions),1)
    }
        
     static var allTests : [(String, (PostMajorityVoteTest) -> () throws -> Void)] {
        return [
          ("testHardLabel",testHardLabel),
        ]
    }
}