//
//  Level.swift
//  Touchanoid
//
//  Created by Jiří Třečák on 18.12.16.
//  Copyright © 2016 Jiri Trecak. All rights reserved.
//

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Imports

import Foundation
import Warp


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Object definition

class Level : WRPObject {
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Data object properties
    
    var name : String!
    var structure : String!
    var levelDefinition: [[Int]] = []
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Data object mapping
    
    override func propertyMap() -> [WRPProperty] {
        
        return [
            WRPProperty(remote: "name", bindTo: "name", type: .string),
            WRPProperty(remote: "structure", bindTo: "structure", type: .array)
        ]
    }
    
    
    override func postInit() {
        
        self.buildLevelDefinition()
    }
    
    
    func buildLevelDefinition() {
        
        // Split the string by | to create rows
        let rows = self.structure.components(separatedBy: "|")
        self.levelDefinition = rows.map { (row) -> [Int] in
            row.components(separatedBy: ",").map({ (cell) -> Int in
                Int(cell)!
            })
        }
        
        NSLog("level definitions")
    }
}



