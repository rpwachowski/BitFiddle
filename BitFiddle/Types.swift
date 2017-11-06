import Foundation

public typealias Byte = UInt8
public typealias Word = UInt16
public typealias DWord = UInt32

public struct Bit {
    
    public static let zero = Bit(high: false)
    public static let one = Bit(high: true)
    
    private var representation: UInt8
    
    private init(high: Bool) {
        representation = high ? 1 : 0
    }
    
}

public protocol BinaryStride { }
extension Bit: BinaryStride { }
extension Byte: BinaryStride { }

public struct BinaryOffset<Stride: BinaryStride>: Comparable, Equatable {
    
    public static func <(lhs: BinaryOffset<Stride>, rhs: BinaryOffset<Stride>) -> Bool {
        return lhs.stride < rhs.stride
    }
    
    public static func ==(lhs: BinaryOffset<Stride>, rhs: BinaryOffset<Stride>) -> Bool {
        return lhs.stride == rhs.stride
    }
    
    public let stride: Int
    
}

public extension BinaryOffset {
    public static var zero: BinaryOffset<Stride> {
        return BinaryOffset(stride: 0)
    }
}

public extension BinaryOffset where Stride == Bit {
    public static var byteMSB: BinaryOffset<Bit> {
        return BinaryOffset<Bit>(stride: 7)
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

public struct BinarySingleton<B: BinarySliceRepresentable> {
    internal let raw: [UInt8]
}

public struct BinarySlice<B: BinarySliceRepresentable> {
    internal let raw: [UInt8]
}

internal func sizeof<T>(_ type: T.Type) -> Int {
    return MemoryLayout<T>.stride
}

