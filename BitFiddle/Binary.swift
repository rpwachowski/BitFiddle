import Foundation

public enum Endianness {
    
    public static var system: Endianness {
        switch CFByteOrderGetCurrent() {
        case Int(CFByteOrderBigEndian.rawValue): return .big
        case Int(CFByteOrderLittleEndian.rawValue): return .little
        default: return .little
        }
    }
    
    public static var network: Endianness {
        return .big
    }
    
    case big
    case little
}

public struct BinaryReader {
    
    private let bytes: [UInt8]
    
    private var offset = 0
    
    internal init(binary: Binary) {
        bytes = binary.bytes
    }
    
    func hasNext<B: BinarySliceRepresentable>(as type: B.Type) -> Bool {
        return offset + B.size <= bytes.count
    }
    
    func hasNext<B: BinarySliceRepresentable>(_ count: Int, as type: B.Type) -> Bool {
        return offset + B.size * count <= bytes.count
    }
    
    public mutating func seek(to offset: Int = 0) {
        self.offset = offset
    }
    
    public mutating func seek<B>(to offset: BinaryOffset<B>) {
        self.offset = offset.stride * sizeof(B.self)
    }
    
    public mutating func seek<B: BinarySliceRepresentable>(to offset: Int, of type: B.Type) {
        self.offset = offset * B.size
    }
    
    public mutating func next<B>() -> BinarySingleton<B> {
        let singleton = BinarySingleton<B>(raw: Array(bytes[offset..<(offset + B.size)]))
        offset += B.size
        return singleton
    }
    
    public mutating func next<B>(_ count: Int) -> BinarySlice<B> {
        let slice = BinarySlice<B>(raw: Array(bytes[offset..<(offset + B.size * count)]))
        offset += B.size * count
        return slice
    }
    
}

public struct Binary {
    
    public let bytes: [UInt8]
    
    public var reader: BinaryReader {
        return BinaryReader(binary: self)
    }
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    public init(data: Data) {
        var bytes = [UInt8](repeating: 0, count: data.count)
        (data as NSData).getBytes(&bytes, length: data.count)
        self.bytes = bytes
    }
    
    public func iterator<B>(of type: B.Type) -> BinarySingletonIterator<B> {
        return BinarySingletonIterator(self)
    }
    
    public func groupIterator<B>(of count: Int, _ type: B.Type) -> BinarySliceIterator<B> {
        return BinarySliceIterator(self, count: count)
    }
    
    public func iterating<B>(each type: B.Type) -> AnySequence<BinarySingleton<B>> {
        return AnySequence(IteratorSequence(iterator(of: type)))
    }
    
    public func iteratingGroups<B>(of count: Int, _ type: B.Type) -> AnySequence<BinarySlice<B>> {
        return AnySequence(IteratorSequence(groupIterator(of: count, type)))
    }
    
    public func byte(at offset: BinaryOffset<Byte>) -> BinarySingleton<UInt8> {
        return BinarySingleton(raw: [bytes[offset.stride]])
    }
    
    public func bytes(_ count: Int, at offset: BinaryOffset<Byte>) -> BinarySlice<UInt8> {
        return BinarySlice(raw: Array(bytes[offset.stride..<(offset.stride + count)]))
    }
    
    public func word(at offset: BinaryOffset<Byte>) -> BinarySingleton<Word> {
        return BinarySingleton(raw: Array(bytes[offset.stride..<(offset.stride + 2)]))
    }
    
    public func words(_ count: Int, at offset: BinaryOffset<Byte>) -> BinarySlice<Word> {
        return BinarySlice(raw: Array(bytes[offset.stride..<(offset.stride + 2 * count)]))
    }
    
    public func dword(at offset: BinaryOffset<Byte>) -> BinarySingleton<DWord> {
        return BinarySingleton(raw: Array(bytes[offset.stride..<(offset.stride + 4)]))
    }
    
    public func dwords(_ count: Int, at offset: BinaryOffset<Byte>) -> BinarySlice<DWord> {
        return BinarySlice(raw: Array(bytes[offset.stride..<(offset.stride + 4 * count)]))
    }
    
}
