import Foundation
import XCTest
@testable import BitFiddle

class ImmutableWriteTests: XCTest {
    
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
    
}

