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

public struct Binary {
    
    public private(set) var bytes: [UInt8]
    
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
    
    public func offset(by offset: BinaryOffset<Byte>) -> BinaryView {
        return bytes.withUnsafeBufferPointer {
            BinaryView(UnsafeBufferPointer(start: $0.baseAddress?.advanced(by: offset.stride), count: $0.count - offset.stride))
        }
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
    
    public func bytes(from start: BinaryOffset<Byte> = .zero, to end: BinaryOffset<Byte>) -> BinarySlice<Byte> {
        return BinarySlice(raw: Array(bytes[start.stride..<end.stride]))
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
    
    public func deleting(between start: BinaryOffset<Byte>, and end: BinaryOffset<Byte>) -> Binary {
        return Binary(bytes: bytes(to: start).raw + offset(by: end).bytes)
    }
    
//    public func inserting(_ bytes: [UInt8], between start: BinaryOffset<Byte>)
    
    public func overwriting(with replacement: [UInt8], between start: BinaryOffset<Byte>, and end: BinaryOffset<Byte>) -> Binary {
        guard end.stride - start.stride == replacement.count else {
            fatalError("""
                       Overwriting slices of mismatched sizes.
                       start: \(start.stride)    end: \(end.stride)
                       expected size: \(end.stride - start.stride)    actual size: \(replacement.count)
                       """)
        }
        return Binary(bytes: bytes(to: start).raw + replacement + offset(by: end).bytes)
    }
    
}

extension Binary: Equatable {
    
    public static func ==(_ lhs: Binary, _ rhs: Binary) -> Bool {
        return lhs.bytes == rhs.bytes
    }
    
}
