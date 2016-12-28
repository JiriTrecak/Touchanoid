//
//  GameManager.swift
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


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Protocols


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Class implementation

public class GameManager {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    public static let sharedInstance = GameManager()
    var gameData: GameData!
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup
    
    init() {
        
        self.loadGameData()
    }
    
    
    func loadGameData() {
        
        // Get the definition file
        guard let defURL = Bundle.main.url(forResource: "Game", withExtension: "json") else {
            assertionFailure("Could not locate game definition file")
            return
        }
        
        // Create game data object containing all configuration
        do {
            let json = try String(contentsOfFile: defURL.path, encoding: .utf8)
            self.gameData = GameData(fromJSON: json)
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }
}
