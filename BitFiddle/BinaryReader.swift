import Foundation

public struct BinaryReader {
    
    private let bytes: AnyCollection<Byte>
    
    private var offset = 0
    
    internal init(binary: Binary) {
        bytes = AnyCollection(binary.bytes)
    }
    
    internal init(view: BinaryView) {
        bytes = AnyCollection(view.ptr)
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
        let singleton = BinarySingleton<B>(raw: Array(bytes[AnyIndex(offset)..<AnyIndex(offset + B.size)]))
        offset += B.size
        return singleton
    }
    
    public mutating func next<B>(_ count: Int) -> BinarySlice<B> {
        let slice = BinarySlice<B>(raw: Array(bytes[AnyIndex(offset)..<AnyIndex(offset + B.size * count)]))
        offset += B.size * count
        return slice
    }
    
}
