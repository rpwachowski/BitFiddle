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
