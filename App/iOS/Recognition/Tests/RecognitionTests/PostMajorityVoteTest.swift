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

    func testSoftLabel(){
      var predictions = [[1: 0.4,
                         2: 0.6],
                         [1: 0.3,
                         2: 0.7]]
      var pp = PostMajorityVote(2)
      var res = try! pp.postprocessWindow(predictionSoft:predictions)
      XCTAssertEqual(res[1]!,Double(0.35))
//      XCTAssertEqual(res[2]!,0.65)

    }
        
     static var allTests : [(String, (PostMajorityVoteTest) -> () throws -> Void)] {
        return [
          ("testHardLabel",testHardLabel),
          ("testSoftLabel",testSoftLabel),

        ]
    }
}