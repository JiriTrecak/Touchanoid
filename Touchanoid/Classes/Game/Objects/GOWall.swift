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

class GOWall {
    
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
        case .Singular, .Double, .Triple:
            if self.health == 1 {
                return NSColor.green
            } else if self.health == 2 {
                return NSColor.blue
            } else if self.health == 3 {
                return NSColor.red
            }
            return NSColor.clear
        case .Indestructible:
            return NSColor.gray
        }
    }
    
    
    func fillColor() -> NSColor {
        
        let strokeColor = self.strokeColor()
        return strokeColor.withAlphaComponent(0.3)
    }
    
    
    static func thumbnailFillColor(ofType type: WallType) -> NSColor {
        
        // Configure wall types
        switch type {
        case .Empty:
             return NSColor.clear
        case .Invisible:
            return NSColor.darkGray
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



