import XCTest
@testable import classifierTests

XCTMain([
     testCase(operatorTests.allTests),
     testCase(utilsTests.allTests),
])
