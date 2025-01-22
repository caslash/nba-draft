//
//  Sequest+Sorting.swift
//  Drafter
//
//  Created by Cameron Slash on 1/17/25.
//

import Foundation

extension Sequence {
    public func sorted<Value>(
        by keyPath: KeyPath<Self.Element, Value>,
        using valuesAreInIncreasingOrder: (Value, Value) throws -> Bool)
        rethrows -> [Self.Element]
    {
        return try self.sorted(by: {
            try valuesAreInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        })
    }
    
    public func sorted<Value: Comparable>(
        by keyPath: KeyPath<Self.Element, Value>)
        -> [Self.Element]
    {
        return self.sorted(by: keyPath, using: <)
    }
    
}
