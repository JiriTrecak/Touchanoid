//
//  Wall.swift
//  Touchanoid
//
//  Created by Jiří Třečák on 18.12.16.
//  Copyright © 2016 Jiri Trecak. All rights reserved.
//

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Imports

import Cocoa


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Definitions

enum WallType: Int {
    case Empty = 0
    case Singular = 1
    case Double = 2
    case Triple = 3
    case Invisible = 9
    case Indestructible = 10
}


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Class

class Wall {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    var health: Int = 1
    var type: WallType = WallType.Empty
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Lifecycle
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Configuration
    
    func configureWithType(type: WallType) {
        
        self.type = type
        
        // Configure wall types
        switch type {
        case .Empty:
            self.health = 0
        case .Singular:
            self.health = 1
        case .Double:
            self.health = 2
        case .Triple:
            self.health = 3
        case .Invisible:
            self.health = 1
        case .Indestructible:
            self.health = 0
        }
    }
    
    
    func strokeColor() -> NSColor {
        
        // Configure wall types
        switch type {
        case .Empty, .Invisible:
            return NSColor.clear
        case .Singular:
            return NSColor.green
        case .Double:
            return NSColor.blue
        case .Triple:
            return NSColor.red
        case .Indestructible:
            return NSColor.gray
        }
    }
    
    
    func fillColor() -> NSColor {
        
        let strokeColor = self.strokeColor()
        return strokeColor.withAlphaComponent(0.3)
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Collision handling
    
    func handleBallCollision(shouldRemove: () -> (), persists: @escaping () -> ()) {
        
        // Ignore collision with impenetrable walls
        if self.type == .Indestructible {
            return
        }
        
        // Decrease the health and if the wall is ready to die, make it dead.
        self.health -= 1
        if self.health == 0 {
            shouldRemove()
        } else {
            persists()
        }
    }
}



