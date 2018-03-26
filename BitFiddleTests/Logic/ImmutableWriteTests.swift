import Foundation
import XCTest
@testable import BitFiddle

class ImmutableWriteTests: XCTestCase {
    
    var binary: Binary!
    
    override func setUp() {
        binary = Binary(bytes: Array(repeating: Byte.max, count: 20))
    }
    
    func testOverwriteEmptyReturnsEquivalentBinary() {
        let result = binary.overwriting(with: [], between: .zero, and: .zero)
        XCTAssert(binary == result)
    }
    
    func testOverwritingFromBeginningOfBinary() {
        let replacement = Array(repeating: Byte.min, count: 10)
        let result = binary.overwriting(with: replacement, between: .zero, and: .init(stride: 10))
        XCTAssert(result == Binary(bytes: replacement + Array(repeating: Byte.max, count: 10)))
    }
    
    func testOverwritingToEndOfBinary() {
        let replacement = Array(repeating: Byte.min, count: 10)
        let result = binary.overwriting(with: replacement, between: .init(stride: 10), and: .init(stride: 20))
        XCTAssert(result == Binary(bytes: Array(repeating: Byte.max, count: 10) + replacement))
    }
    
    func testOverwritingWithinBinary() {
        let replacement = Array(repeating: Byte.min, count: 10)
        let result = binary.overwriting(with: replacement, between: .init(stride: 5), and: .init(stride: 15))
        XCTAssert(result == Binary(bytes: Array(repeating: Byte.max, count: 5) + replacement + Array(repeating: Byte.max, count: 5)))
    }
    
    func testOverwritingAllBinary() {
        let replacement = Array(repeating: Byte.min, count: 20)
        let result = binary.overwriting(with: replacement, between: .zero, and: .init(stride: 20))
        XCTAssert(result == Binary(bytes: replacement))
    }
    
    func testDeletingEmptyReturnsEquivalentBinary() {
        let result = binary.deleting(between: .zero, and: .zero)
        XCTAssert(binary == result)
    }
    
    func testDeletingFromBeginningOfBinary() {
        let result = binary.deleting(between: .zero, and: .init(stride: 10))
        XCTAssert(result == Binary(bytes: Array(repeating: Byte.max, count: 10)))
    }
    
    func testDeletingToEndOfBinary() {
        let result = binary.deleting(between: .zero, and: .init(stride: 10))
        XCTAssert(result == Binary(bytes: Array(repeating: Byte.max, count: 10)))
    }
    
    func testDeletingWithinBinary() {
        let result = binary.deleting(between: .init(stride: 5), and: .init(stride: 15))
        XCTAssert(result == Binary(bytes: Array(repeating: Byte.max, count: 10)))
    }
    
    func testDeletingAllBinary() {
        let result = binary.deleting(between: .zero, and: .init(stride: 20))
        XCTAssert(result == Binary(bytes: []))
    }
    
    func testAppendingEmptyReturnsEquivalentBinary() {
        let result = binary.appending([])
        XCTAssert(result == binary)
    }

    func testAppendingNonEmpty() {
        let bytes = Array(repeating: Byte.min, count: 5)
        let result = binary.appending(bytes)
        XCTAssert(result == Binary(bytes: Array(repeating: Byte.max, count: 20) + bytes))
    }
    
    func testPrependingEmptyReturnsEquivalentBinary() {
        let result = binary.prepending([])
        XCTAssert(result == binary)
    }
    
    func testPrependingNonEmpty() {
        let bytes = Array(repeating: Byte.min, count: 5)
        let result = binary.prepending(bytes)
        XCTAssert(result == Binary(bytes: bytes + Array(repeating: Byte.max, count: 20)))
    }
    
    func testInsertingEmptyReturnsEquivalentBinary() {
        let result = binary.inserting([], at: .zero)
        XCTAssert(result == binary)
    }
    
    func testInsertingAtBeginningEqualsPrepending() {
        let bytes = Array(repeating: Byte.min, count: 5)
        let insertingResult = binary.inserting(bytes, at: .zero)
        let prependingResult = binary.prepending(bytes)
        XCTAssert(insertingResult == prependingResult)
    }
    
    func testInsertingAtEndEqualsAppending() {
        let bytes = Array(repeating: Byte.min, count: 5)
        let insertingResult = binary.inserting(bytes, at: .init(stride: 20))
        let appendingResult = binary.appending(bytes)
        XCTAssert(insertingResult == appendingResult)
    }
    
    func testInsertingWithinBinary() {
        let bytes = Array(repeating: Byte.min, count: 5)
        let result = binary.inserting(bytes, at: .init(stride: 5))
        XCTAssert(result == Binary(bytes: Array(repeating: Byte.max, count: 5) + bytes + Array(repeating: Byte.max, count: 15)))
    }
    
}

