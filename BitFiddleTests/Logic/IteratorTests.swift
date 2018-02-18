import Foundation
import XCTest
@testable import BitFiddle

class IteratorTests: XCTestCase {
    
    var binary: Binary!
    
    override func setUp() {
        binary = Binary(bytes: [0, 7, 5, 4, 3, 8, 5])
    }
    
    func testSingletonIterator() {
        var iterator = binary.iterator(of: Byte.self)
        XCTAssertNotNil(iterator.next(), "Expected iterator of bytes to have next.")
        let bytes = Array(binary.iterating(each: Byte.self)).flatMap { $0.raw }
        XCTAssertEqual(binary.bytes, bytes, "Expected sequence of bytes to equal iterator bytes.")
    }
    
    func testSliceIterator() {
        var iterator = binary.groupIterator(of: 3, Byte.self)
        var array = [BinarySlice<Byte>]()
        while let value = iterator.next() {
            array.append(value)
        }
        
        XCTAssert(array.count == 2, "Expected array count to be 2 but was \(array.count).")
        XCTAssert(array[0].raw == [0, 7, 5] && array[1].raw == [4, 3, 8], "Expected slices of [0, 7, 5] and [4, 3, 8] but were \(array[0].raw) and \(array[1].raw).")
    }
    
}
