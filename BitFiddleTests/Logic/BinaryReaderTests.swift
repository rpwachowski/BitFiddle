//
//  BinaryReaderTests.swift
//  BitFiddleTests
//
//  Created by Ryan Wachowski on 2/3/18.
//  Copyright © 2018 Ryan Wachowski. All rights reserved.
//

import Foundation
import XCTest
@testable import BitFiddle

class BinaryReaderTests: XCTestCase {
    
    var binary: Binary!
    
    override func setUp() {
        binary = Binary(bytes: [0, 7, 5, 4, 3, 8, 5])
    }
    
    func testHasNextByte() {
        let reader = BinaryReader(binary: binary)
        XCTAssertTrue(reader.hasNext(as: UInt8.self))
    }
    
    func testHasNextSevenBytes() {
        let reader = BinaryReader(binary: binary)
        XCTAssertTrue(reader.hasNext(7, as: UInt8.self))
    }
    
    func testDoesNotHaveNextQWord() {
        let reader = BinaryReader(binary: binary)
        XCTAssertFalse(reader.hasNext(as: QWord.self))
    }
    
}
