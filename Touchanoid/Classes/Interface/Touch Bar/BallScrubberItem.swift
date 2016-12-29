//
//  BallScrubberItem.swift
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
// MARK: - Definitions


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Class

@available(OSX 10.12.2, *)
class BallScrubberItem: NSScrubberItemView {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    var skView: SKView!
    var scene: SKScene!
    var ballNode: SKSpriteNode!
    var ballEffectNode: SKEmitterNode!
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Lifecycle
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Configuration
    
    func configureWith(ball: Ball) {
        
        // Create view and the scene
        self.skView = SKView(frame: NSRect(x: 2, y: 0, width: 116, height: 30))
        
        // Load the SKScene from 'GameScene.sks'
        if let scene = SKScene(fileNamed: "TouchBarScene.sks") {
            
            self.scene = scene
            self.scene?.scaleMode = .aspectFill
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            self.skView.presentScene(scene)
        }
        
        // Configure the SK view debug information
        skView.ignoresSiblingOrder = true
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        // Create ball preview
        self.generateBallPreviewNodeInto(scene: self.scene, ball: ball)
        
        // Assign the scene view into the scrubber item view
        self.addSubview(self.skView)
    }
    
    
    func generateBallPreviewNodeInto(scene: SKScene, ball: Ball) {
        
        self.ballNode = SKSpriteNode(color: NSColor.clear, size: CGSize(width: 20, height: 20))
        self.ballNode.name = "ball"
        self.ballNode.position = CGPoint(x: 30, y: 0)
        scene.addChild(self.ballNode)
        
        // Setup new particle emitter, if applicable
        if let emitterName = ball.emitterName {
            self.ballEffectNode = SKEmitterNode(fileNamed: emitterName)
            self.ballNode.addChild(self.ballEffectNode)
            self.ballEffectNode.particleLifetime = 2
            self.ballEffectNode.targetNode = self.scene
            self.ballEffectNode.emissionAngle = atan2(0, -1)
        }
    }
}



