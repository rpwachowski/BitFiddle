import Foundation
import XCTest
@testable import BitFiddle
@testable import WebKit

class ImmutableWriteTests: XCTest {
    
    var binary: Binary!
    
    override func setUp() {
        binary = Binary(bytes: Array(repeating: Byte.max, count: 20))
    }
    
    func testOverwriteEmptyReturnsEquivalentBinary() {
        let result = binary.overwriting(with: [], between: .zero, and: .zero)
        XCTAssert(binary == result)
    }
    
    func testOverwriteFromBeginningOfBinary() {
        let replacement = Array(repeating: Byte.min, count: 10)
        let result = binary.overwriting(with: replacement, between: .zero, and: .init(stride: 10))
        XCTAssert(result == Binary(bytes: replacement + Array(repeating: Byte.max, count: 10)))
    }
    
    func testOverwriteToEndOfBinary() {
        let replacement = Array(repeating: Byte.min, count: 10)
        let result = binary.overwriting(with: replacement, between: .init(stride: 10), and: .init(stride: 21))
        XCTAssert(result == Binary(bytes: Array(repeating: Byte.max, count: 10) + replacement))
    }
    
    func testOverwriteWithinBinary() {
        let replacement = Array(repeating: Byte.min, count: 10)
        let result = binary.overwriting(with: replacement, between: .init(stride: 5), and: .init(stride: 16))
        XCTAssert(result == Binary(bytes: Array(repeating: Byte.max, count: 5) + replacement + Array(repeating: Byte.max, count: 5)))
    }
    
    func testDeletingEmptyReturnsEquivalentBinary() {
        let result = binary.deleting(between: .zero, and: .zero)
        XCTAssert(binary == result)
    }
    
}

