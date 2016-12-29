//
//  MainWC.swift
//  Touchanoid
//
//  Created by Jiří Třečák on 18.12.16.
//  Copyright © 2016 Jiri Trecak. All rights reserved.
//

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Imports

import Cocoa
import SpriteKit
import GameplayKit


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Class

class MainVC: NSViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    @IBOutlet var skView: SKView!
    var scene: GameScene? = nil
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupObservers()
        self.setupGameScene()
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup
    
    func setupGameScene() {
        
        if let view = self.skView {
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                
                self.scene = scene as? GameScene
                self.scene?.scaleMode = .aspectFill
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                // Setup current level
                let level = GameManager.sharedInstance.randomLevel()
                let ball = GameManager.sharedInstance.randomBall()
                self.scene?.configureWithLevel(level: level, ball: ball)
            }
            
            // Configure the SK view debug information
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    
    func setupObservers() {
        
        // Menu selection of the level
        MenuManager.sharedInstance.onLevelChangedClosure.addHandler { level in
            self.scene?.configureWithLevel(level: level, ball: nil)
        }
        
        // Menu selection of the ball
        MenuManager.sharedInstance.onBallChangedClosure.addHandler { ball in
            self.scene?.configureWithBall(ball: ball)
        }
    }
}



