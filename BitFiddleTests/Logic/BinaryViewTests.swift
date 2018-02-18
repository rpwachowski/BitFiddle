//
//  BinaryViewTests.swift
//  BitFiddleTests
//
//  Created by Ryan Wachowski on 2/10/18.
//  Copyright © 2018 Ryan Wachowski. All rights reserved.
//

import Foundation
import XCTest
@testable import BitFiddle

class BinaryViewTests: XCTestCase {
    
    var binary: Binary!
    
    override func setUp() {
        let bytes = Array(repeating: UInt8.max, count: 450) + [240] + Array(repeating: 0, count: 3)
        binary = Binary(bytes: bytes)
    }
    
    func testGeneratesCorrectSubsequence() {
        let subsequence = Array(binary.offset(by: BinaryOffset(stride: 450)).ptr)
        XCTAssert(subsequence == [240, 0, 0, 0], "Expected subsequence to be [240, 0, 0, 0], was \(subsequence).")
    }
    
}
