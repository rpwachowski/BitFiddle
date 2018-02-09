import Foundation

public extension BinarySingleton where B: BinaryInteger {

    public func value(endianness: Endianness = .system) -> B {
        return raw.enumerated().reduce(0) { (sum, next) -> B in
            let offset = endianness == .big ? abs(next.offset - raw.count + 1) : next.offset
            return sum + (B.init(truncatingIfNeeded: next.element) << (8 * offset))
        }
    }

}

public extension BinarySlice where B: BinaryInteger {
    
    public func values(endianness: Endianness = .system) -> [B] {
        return (0..<(raw.count / B.size)).map {
            let rawValue = Array(raw[($0 * B.size)..<(B.size * ($0 + 1))])
            return BinarySingleton<B>(raw: rawValue).value(endianness: endianness)
        }
    }
    
}
