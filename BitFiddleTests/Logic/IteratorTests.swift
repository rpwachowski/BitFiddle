import Foundation
import XCTest
@testable import BitFiddle

class IteratorTests: XCTestCase {
    
    var binary: Binary!
    
    override func setUp() {
        binary = Binary(bytes: [0, 7, 5, 4, 3, 8, 5])
    }
    
    func testIteratingEach() {
        var iterator = binary.iterator(of: Byte.self)
        XCTAssertNotNil(iterator.next(), "Expected iterator of bytes to have next.")
        let bytes = Array(binary.iterating(each: Byte.self)).flatMap { $0.raw }
        XCTAssertEqual(binary.bytes, bytes, "Expected sequence of bytes to equal iterator bytes.")
    }
    
}
