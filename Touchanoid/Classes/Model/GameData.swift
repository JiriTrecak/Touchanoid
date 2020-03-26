//
//  GameConfiguration.swift
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

class GameData : WRPObject {
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Data object properties
    
    @objc dynamic var levels : [Level] = []
    @objc dynamic var balls : [Ball] = []
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Data object mapping
    
    override func propertyMap() -> [WRPProperty] {
        
        return [
            
        ]
    }

    
    override func relationMap() -> [WRPRelation] {
        
        return [
            WRPRelation(remote: "levels", bindTo: "levels", inverseBindTo: nil, modelClass: Level.self, optional: false, relationType: .toMany, inverseRelationType: nil),
            WRPRelation(remote: "balls", bindTo: "balls", inverseBindTo: nil, modelClass: Ball.self, optional: false, relationType: .toMany, inverseRelationType: nil)
        ]
    }
}




