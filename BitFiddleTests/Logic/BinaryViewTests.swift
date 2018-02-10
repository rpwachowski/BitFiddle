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
    
    func testConvertSlice() {
        let slice = binary.words(2, at: BinaryOffset(stride: 0))
        XCTAssert(slice.values(endianness: .big) == [0, 255], "Expected big-Endian values to be [0, 255], was \(slice.values(endianness: .big)).")
        XCTAssert(slice.values(endianness: .little) == [0, 65280], "Expected little-Endian values to be [0, 65280], was \(slice.values(endianness: .little)).")
    }
}
