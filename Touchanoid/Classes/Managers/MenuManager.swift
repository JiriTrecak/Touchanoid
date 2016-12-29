//
//  MenuManager.swift
//  Touchanoid
//
//  Created by Jiří Třečák on 18.12.16.
//  Copyright © 2016 Jiri Trecak. All rights reserved.
//


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
//MARK: - Imports

import Foundation
import Warp


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Definitions

enum MenuState {
    case main
    case ballSelection
    case levelSelection
    case paddleSelection
}


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Protocols


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Class implementation

public class MenuManager {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    public static let sharedInstance = MenuManager()
    
    // Observers
    let onLevelChangedClosure = ClosureStorage<(Level), ((_ level: Level) -> ())>()
    let onBallChangedClosure = ClosureStorage<(Ball), ((_ ball: Ball) -> ())>()
    let onMenuStateChangedClosure = ClosureStorage<(MenuState), ((_ menuState: MenuState) -> ())>()
    
    // Game state
    var menuState: MenuState = .main {
        didSet {
            onMenuStateChangedClosure.callAll(parameters: menuState)
        }
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup
    
    init() {
        
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Observing
    
    func levelChanged(level: Level) {
        
        // Notify all interested in level change
        self.onLevelChangedClosure.callAll(parameters: level)
    }
    
    
    func ballChanged(ball: Ball) {
        
        // Notify all interested in level change
        self.onBallChangedClosure.callAll(parameters: ball)
    }
}



