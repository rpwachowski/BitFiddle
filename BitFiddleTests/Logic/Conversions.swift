import Foundation
import XCTest
@testable import BitFiddle

class ConversionsTests: XCTestCase {
    
    var binary: Binary!
    
    override func setUp() {
        binary = Binary(bytes: [0, 0, 0, 255])
    }
    
    func testConvertSingleton() {
        let singleton = binary.dword(at: BinaryOffset(stride: 0))
        XCTAssert(singleton.value(endianness: .big) == 255, "Expected big-Endian value to be 255.")
        XCTAssert(singleton.value(endianness: .little) == 4278190080, "Expected little-Endian value to be 4278190080, was \(singleton.value(endianness: .little)).")
    }
    
    func testConvertSlice() {
        let slice = binary.words(2, at: BinaryOffset(stride: 0))
        XCTAssert(slice.values(endianness: .big) == [0, 255], "Expected big-Endian values to be [0, 255], was \(slice.values(endianness: .big)).")
        XCTAssert(slice.values(endianness: .little) == [0, 65280], "Expected little-Endian values to be [0, 65280], was \(slice.values(endianness: .little)).")
    }
}
