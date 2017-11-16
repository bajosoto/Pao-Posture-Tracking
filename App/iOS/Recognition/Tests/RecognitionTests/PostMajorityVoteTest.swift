import XCTest

@testable import Recognition
class PostMajorityVoteTest: XCTestCase {

    func testHardLabelWindow(){
        var predictions = [1,2,2]
        var pp = PostMajorityVote(3)
        XCTAssertEqual(try! pp.postprocessWindow(predictions),2)

        predictions = [1,1,1,2,2]
        pp = PostMajorityVote(5)
        XCTAssertEqual(try! pp.postprocessWindow(predictions),1)
    }

    func testSoftLabelWindow(){
      var predictions = [[1: 0.4,
                         2: 0.6],
                         [1: 0.3,
                         2: 0.7]]
      var pp = PostMajorityVote(2)
      var res = try! pp.postprocessWindow(predictionSoft:predictions)
      XCTAssertEqual(res[1]!,Double(0.35))
//      XCTAssertEqual(res[2]!,0.65)

    }

    func testHardLabel(){
        var predictions = [1,2,2,1,1,2]
        var pp = PostMajorityVote(3)
        XCTAssertEqual(try! pp.postprocess(predictions),[2,1])

        predictions = [1,1,1,2,2,2,2,2,1,1]
        pp = PostMajorityVote(5)
        XCTAssertEqual(try! pp.postprocess(predictions),[1,2])
    }

    func testSoftLabel(){
      var predictions = [[1: 0.4,
                         2: 0.6],
                         [1: 0.3,
                         2: 0.7],
                         [1: 0.6,
                         2: 0.4],
                         [1: 0.7,
                         2: 0.3]]
      var pp = PostMajorityVote(2)
      var res = try! pp.postprocess(predictionSoft:predictions)
      XCTAssertEqual(res[0][1]!,Double(0.35))
//      XCTAssertEqual(res[2]!,0.65)
      XCTAssertEqual(res[1][1]!,Double(0.65))


    }
        
     static var allTests : [(String, (PostMajorityVoteTest) -> () throws -> Void)] {
        return [
          ("testHardLabelWindow",testHardLabelWindow),
          ("testSoftLabelWindow",testSoftLabelWindow),
          ("testHardLabel",testHardLabel),
          ("testSoftLabel",testSoftLabel),
        ]
    }
}