//
//  ClosureStorage.swift
//  Touchanoid
//
//  Created by Jiří Třečák on 18.12.16.
//  Copyright © 2016 Jiri Trecak. All rights reserved.
//


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Imports

import AppKit


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Class

class ClosureStorage<Parameters, Closure> {
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    private var lastIndex: Int = 0
    private var items: [Int: Closure] = [:]
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Observing state
    
    private var onAdd: ((_ closureStorage: ClosureStorage, _ count: Int, _ handler: Closure) -> ())? = nil
    func setOnAddHandler(handler: ((_ closureStorage: ClosureStorage, _ count: Int, _ handler: Closure) -> ())?) {
        self.onAdd = handler
    }
    
    private var onRemove: ((_ closureStorage: ClosureStorage, _ count: Int) -> ())? = nil
    func setOnRemoveHandler(handler: ((_ closureStorage: ClosureStorage, _ count: Int) -> ())?) {
        self.onRemove = handler
    }
    
    private var onEmpty: ((_ closureStorage: ClosureStorage) -> ())? = nil
    func setOnEmptyHandler(handler: @escaping ((_ closureStorage: ClosureStorage) -> ())) {
        self.onEmpty = handler
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Operations
    
    @discardableResult
    func addHandler(handler: Closure) -> Int {
        self.lastIndex += 1
        self.items[self.lastIndex] = handler
        
        if let onAdd = self.onAdd {
            onAdd(self, self.items.count, handler)
        }
        
        return self.lastIndex
    }
    
    func removeHandlerWithID(handlerID: Int) {
        self.items.removeValue(forKey: handlerID)
        
        if let onRemove = self.onRemove {
            onRemove(self, self.items.count)
        }
        if let onEmpty = self.onEmpty, self.items.count == 0 {
            onEmpty(self)
        }
    }
    
    func removeAllHandlers() {
        self.items.removeAll()
        
        if let onEmpty = self.onEmpty {
            onEmpty(self)
        }
    }
    
    func callAll(parameters: Parameters) {
        for handler: Closure in self.items.values {
            if let handler: ((Parameters) -> ()) = handler as? ((Parameters) -> ()) {
                handler(parameters)
            }
        }
    }
}
