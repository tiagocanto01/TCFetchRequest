//
//  PreDefinedFunctionsPredicate.swift
//  TCFetchRequest
//
//  Created by Tiago Canto on 24/08/23.
//

import Foundation

fileprivate class TCGenericPredicate<Root>: TCPredicate<Root> {
    
    private var predicate: NSPredicate
    
    init(predicate: NSPredicate) {
        self.predicate = predicate
    }
    
    override func toNSPredicate() -> NSPredicate {
        predicate
    }
}

extension TCPredicate {
    public static func value<Value>(_ keyPath: KeyPath<Root, Value>, containsInSet set: Set<Value>) -> TCPredicate<Root> {
        TCGenericPredicate<Root>(predicate: NSPredicate(format: "%K IN %@", argumentArray: [NSExpression(forKeyPath: keyPath).keyPath, set]) )
    }
}
