import XCTest
@testable import RecognitionTests

XCTMain([ 
	 testCase(MatrixTest.allTests),
     testCase(MatrixMathTest.allTests),
     testCase(OperatorTest.allTests),
     testCase(UtilsTest.allTests),
     testCase(DatasetTest.allTests),
     testCase(LdaClassifierTest.allTests),
     testCase(KnnClassifierTest.allTests),
     testCase(ParzenClassifierTest.allTests),
     testCase(SimplePreprocessorTest.allTests),
    

])
