
/***************************************************************************************************
 *  exp2_test.swift
 *
 *  This file tests the exp2 function.
 *
 *  Author: Nicolas Bertagnolli
 *  Creation Date: 22 Jan 2017
 *
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License. You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software distributed under the 
 *  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either 
 *  express or implied. See the License for the specific language governing permissions and 
 *  limitations under the License.
 *
 *  Copyright 2017 Nicolas Bertagnolli
 **************************************************************************************************/

import XCTest
@testable import Nifty

class exp2_test: XCTestCase 
{
    #if os(Linux)
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", self.testBasic)]),
        ]

        return tests
    }
    #endif

    func testBasic() 
    {        
        let v1 = Vector([1.0, 2.0, 3.0])
        let v1_answer = Vector([2.0, 4.0, 8.0])
        XCTAssert(isequal(exp2(v1), v1_answer, within: 0.0001))
        
        // Test Vector for negative input
        let v2 = Vector([-1.0, -2.0, -3.0])
        let v2_answer = Vector([0.5, 0.25, 0.125])
        XCTAssert(isequal(exp2(v2), v2_answer, within: 0.0001))
        
        // Test matrix as input
        let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
        let m1_answer = Matrix([[2.0, 4.0], [8.0, 16.0]])
        XCTAssert(isequal(exp2(m1), m1_answer, within: 0.0001))
        
        // Test tensor as input mixed positive and negative values
        let m = Matrix(2,3, [1.0, 2.0, 3.0, -1.0, -2.0, -3.0])
        let m_answer = Matrix(2,3, [2.0, 4.0, 8.0, 0.5, 0.25, 0.125])
        let tm = exp2(Tensor(m))
        XCTAssert(isequal(m_answer, Matrix<Double>(2,3, tm.data), within: 0.0001))
    }
}
