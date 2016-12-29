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
    private var gameData: GameData!
    
    
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
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Level manipulation
    
    func randomLevel() -> Level {
        
        let index = Int(arc4random_uniform(UInt32(self.gameData.levels.count)))
        return self.gameData.levels[index]
    }
    
    
    func numberOfLevels() -> Int {
        
        return self.gameData.levels.count
    }
    
    
    func level(index: Int) -> Level {
        
        return self.gameData.levels[index]
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Ball manipulation
    
    func randomBall() -> Ball {
        
        let index = Int(arc4random_uniform(UInt32(self.gameData.balls.count)))
        return self.gameData.balls[index]
    }
    
    
    func numberOfBalls() -> Int {
        
        return self.gameData.balls.count
    }
    
    
    func ball(index: Int) -> Ball {
        
        return self.gameData.balls[index]
    }
}



