//
//  Ball.swift
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

class Ball : WRPObject {
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Data object properties
    
    @objc dynamic var name : String!
    @objc dynamic var emitterName : String?
    @objc dynamic var textureName : String?
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Data object mapping
    
    override func propertyMap() -> [WRPProperty] {
        
        return [
            WRPProperty(remote: "emitterName", bindTo: "emitterName", type: .string, optional: true),
            WRPProperty(remote: "textureName", bindTo: "textureName", type: .string, optional: true),
            WRPProperty(remote: "name", bindTo: "name", type: .string),
        ]
    }
    
    
    override func postInit() {
        
    }
}


