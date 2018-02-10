import Foundation

internal protocol _BinaryIteratorProduceable {
    associatedtype NativeType: BinarySliceRepresentable
}

extension BinarySingleton: _BinaryIteratorProduceable {
    typealias NativeType = B
}

extension BinarySlice: _BinaryIteratorProduceable {
    typealias NativeType = B
}

internal struct _BaseBinaryIterator<P: _BinaryIteratorProduceable>: IteratorProtocol {
    typealias Element = P
    
    private var reader: BinaryReader
    private let generator: (inout BinaryReader) -> () -> Element
    
    internal init(_ binary: Binary, invoking generator: @escaping (inout BinaryReader) -> () -> Element) {
        reader = BinaryReader(binary: binary)
        self.generator = generator
    }
    
    internal init(_ view: BinaryView, invoking generator: @escaping (inout BinaryReader) -> () -> Element) {
        reader = BinaryReader(view: view)
        self.generator = generator
    }
    
    mutating func next() -> Element? {
        guard reader.hasNext(as: P.NativeType.self) else { return nil }
        return generator(&reader)()
    }
    
}

public struct BinarySingletonIterator<B: BinarySliceRepresentable>: IteratorProtocol {
    public typealias Element = BinarySingleton<B>
    
    private var base: _BaseBinaryIterator<Element>
    
    public init(_ binary: Binary) {
        let generator = BinaryReader.next as (inout BinaryReader) -> () -> Element
        base = _BaseBinaryIterator(binary, invoking: generator)
    }
    
    public init(_ view: BinaryView) {
        let generator = BinaryReader.next as (inout BinaryReader) -> () -> Element
        base = _BaseBinaryIterator.init(view, invoking: generator)
    }
    
    public mutating func next() -> Element? {
        return base.next()
    }
    
}

public struct BinarySliceIterator<B: BinarySliceRepresentable>: IteratorProtocol {
    public typealias Element = BinarySlice<B>
    
    private var base: _BaseBinaryIterator<Element>
    
    public init(_ binary: Binary, count: Int) {
        base = _BaseBinaryIterator(binary, invoking: { reader in
            let invocation = BinaryReader.next as (inout BinaryReader) -> (Int) -> Element
            return { [reader] in
                var reader = reader
                return invocation(&reader)(count)
            }
        })
    }
    
    public init(_ view: BinaryView, count: Int) {
        base = _BaseBinaryIterator(view, invoking: { reader in
            let invocation = BinaryReader.next as (inout BinaryReader) -> (Int) -> Element
            return { [reader] in
                var reader = reader
                return invocation(&reader)(count)
            }
        })
    }
    
    public mutating func next() -> Element? {
        return base.next()
    }
    
}
