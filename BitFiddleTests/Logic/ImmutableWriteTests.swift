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
    
    func testDeletingEmptyReturnsEquivalentBinary() {
        let result = binary.deleting(between: .zero, and: .zero)
        XCTAssert(binary == result)
    }
    
}

