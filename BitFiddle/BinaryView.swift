import Foundation

public struct BinaryView {
    
    let ptr: UnsafeBufferPointer<Byte>
    
    public var reader: BinaryReader {
        return BinaryReader(view: self)
    }
    
    public var bytes: [UInt8] {
        return Array(ptr)
    }
    
    init(_ ptr: UnsafeBufferPointer<Byte>) {
        self.ptr = ptr
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
    
}
