import Foundation

public struct BinarySingletonIterator<B: BinarySliceRepresentable>: IteratorProtocol {
    public typealias Element = BinarySingleton<B>
    
    private var reader: BinaryReader
    
    public init(_ binary: Binary) {
        reader = binary.reader
    }
    
    public init(_ view: BinaryView) {
        reader = view.reader
    }
    
    public mutating func next() -> Element? {
        guard reader.hasNext(as: B.self) else { return nil }
        return reader.next()
    }
    
}

public struct BinarySliceIterator<B: BinarySliceRepresentable>: IteratorProtocol {
    public typealias Element = BinarySlice<B>
    
    private let stride: Int
    private var reader: BinaryReader
    
    public init(_ binary: Binary, count: Int) {
        reader = binary.reader
        stride = count
    }
    
    public init(_ view: BinaryView, count: Int) {
        reader = view.reader
        stride = count
    }
    
    public mutating func next() -> Element? {
        guard reader.hasNext(stride, as: B.self) else { return nil }
        return reader.next(stride)
    }
    
}
