import Foundation

public typealias Byte = UInt8
public typealias Word = UInt16
public typealias DWord = UInt32
public typealias QWord = UInt64

public struct Bit {
    
    public static func &<I: BinaryInteger>(_ lhs: I, _ rhs: Bit) -> Bit {
        return self.init(lhs & I.init(rhs.representation))
    }
    
    public static func <<<U: UnsignedInteger>(_ lhs: Bit, _ rhs: U) -> Int {
        return Int(lhs.representation) << rhs
    }
    
    public static let zero = Bit(high: false)
    public static let one = Bit(high: true)
    
    private let representation: UInt8
    
    private init<I: BinaryInteger>(_ value: I) {
        representation = UInt8(value)
    }
    
    private init(high: Bool) {
        representation = high ? 1 : 0
    }
    
}

public protocol _BinaryStride { }
extension Bit: _BinaryStride { }
extension Byte: _BinaryStride { }

public struct BinaryOffset<S: _BinaryStride>: Comparable, Equatable {
    
    public static func <(lhs: BinaryOffset<S>, rhs: BinaryOffset<S>) -> Bool {
        return lhs.stride < rhs.stride
    }
    
    public static func ==(lhs: BinaryOffset<S>, rhs: BinaryOffset<S>) -> Bool {
        return lhs.stride == rhs.stride
    }
    
    public let stride: Int
    
    public init(stride: Int) {
        self.stride = stride
    }
    
}

public extension BinaryOffset {
    public static var zero: BinaryOffset<S> {
        return BinaryOffset(stride: 0)
    }
}

extension BinaryOffset: Strideable {
    public typealias Stride = Int
    
    public func distance(to other: BinaryOffset<S>) -> Int {
        return other.stride - self.stride
    }
    
    public func advanced(by n: Int) -> BinaryOffset<S> {
        return BinaryOffset<S>(stride: self.stride + n)
    }
}

public extension BinaryOffset where S == Bit {
    
    public static var byteOffsets: CountableRange<BinaryOffset<Bit>> {
        return BinaryOffset.zero..<BinaryOffset.byteMSB
    }
    
    public static var byteMSB: BinaryOffset<Bit> {
        return BinaryOffset<Bit>(stride: 8)
    }
    
    public static func %(_ lhs: BinaryOffset<Bit>, _ rhs: Int) -> BinaryOffset<Bit> {
        return BinaryOffset(stride: lhs.stride % rhs)
    }
    
    public static func %(_ lhs: BinaryOffset<Bit>, _ rhs: BinaryOffset<Bit>) -> BinaryOffset<Bit> {
        return BinaryOffset(stride: lhs.stride % rhs.stride)
    }
    
}

public protocol BinarySliceRepresentable {
    static var size: Int { get }
}

public extension BinarySliceRepresentable {
    public static var size: Int {
        return sizeof(Self.self)
    }
}

extension Int8: BinarySliceRepresentable { }
extension UInt8: BinarySliceRepresentable { }
extension Int16: BinarySliceRepresentable { }
extension UInt16: BinarySliceRepresentable { }
extension Int32: BinarySliceRepresentable { }
extension UInt32: BinarySliceRepresentable { }
extension UInt64: BinarySliceRepresentable { }

public struct BinarySingleton<B: BinarySliceRepresentable> {
    internal let raw: [UInt8]
}

public struct BinarySlice<B: BinarySliceRepresentable> {
    internal let raw: [UInt8]
}

internal func sizeof<T>(_ type: T.Type) -> Int {
    return MemoryLayout<T>.stride
}

public extension Byte {
    
    func bit(at offset: BinaryOffset<Bit>) -> Bit {
        return Int((self >> (offset % .byteMSB).stride)) & .one
    }
    
}
