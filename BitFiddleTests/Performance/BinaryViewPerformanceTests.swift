//
//  BinaryViewPerformanceTests.swift
//  BitFiddleTests
//
//  Created by Ryan Wachowski on 2/10/18.
//  Copyright © 2018 Ryan Wachowski. All rights reserved.
//

import Foundation
import XCTest
@testable import BitFiddle

fileprivate struct NaiveBinaryView {
    
    let bytes: [UInt8]
    
    init(_ bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    public func iterator<B>(of type: B.Type) -> BinarySingletonIterator<B> {
        return BinarySingletonIterator(view: self)
    }
    
}

fileprivate extension BinarySingletonIterator {
    
    init(view: NaiveBinaryView) {
        self.init(Binary(bytes: view.bytes))
    }
    
}

fileprivate extension Binary {
    func naiveOffset(by offset: BinaryOffset<Byte>) -> NaiveBinaryView {
        return NaiveBinaryView(Array(bytes[offset.stride..<bytes.count]))
    }
}

class BinaryViewPerformanceTests: XCTestCase {
    
    var binary: Binary!
    
    override func setUp() {
        let bytes = Array(repeating: UInt8.max, count: 450) + [240] + Array(repeating: 0, count: 2499)
        binary = Binary(bytes: bytes)
    }
    
    func testNaiveInitializationPerformance() {
        measure {
            let array = Array(binary.naiveOffset(by: BinaryOffset(stride: 450)).bytes)
        }
    }
    
    func testImplementationInitializationPerformance() {
        measure {
            let array = Array(binary.offset(by: BinaryOffset(stride: 450)).ptr)
        }
    }
    
    func testNaiveIteratorPerformance() {
        measure {
            var iterator = binary.naiveOffset(by: BinaryOffset(stride: 450)).iterator(of: Byte.self)
            for i in 0..<2500 {
                _ = iterator.next()
            }
        }
    }
    
    func testImplementationIteratorPerformance() {
        measure {
            var iterator = binary.offset(by: BinaryOffset(stride: 450)).iterator(of: Byte.self)
            for i in 0..<2500 {
                _ = iterator.next()
            }
        }
    }
    
}
