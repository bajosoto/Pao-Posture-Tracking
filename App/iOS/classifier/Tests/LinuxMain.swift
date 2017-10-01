import XCTest
@testable import classifierTests

XCTMain([
     testCase(OperatorTest.allTests),
     testCase(UtilsTest.allTests),
     testCase(DatasetTest.allTests),

])
