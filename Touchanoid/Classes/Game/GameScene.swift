//
//  Extensions
//  Touchanoid
//
//  Created by Jiří Třečák on 18.12.16.
//  Copyright © 2016 Jiri Trecak. All rights reserved.
//

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Import

import SpriteKit
import GameplayKit


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Definitions

private let RECT_SIZE: CGSize = CGSize(width: 40, height: 20)
private let BLOCK_SPACING: CGFloat = 10
private let ROW_HEIGHT: CGFloat = 50
private let OFFSET_TOP: CGFloat = 50
private let OFFSET_SIDE: CGFloat = 50


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Extension - Touch Bar

class GameScene: SKScene {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    var wallPrefab: SKShapeNode!
    var ballNode: SKSpriteNode!
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Init
    
    override init(size: CGSize) {
        super.init(size: size)
        self.configureScene()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureScene()
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Level manipulation
    
    func setupLevel() {
        
        self.makePrefabs()
        
        self.generateGrid()
        self.generatePaddle()
        self.generateBall()
    }
    
    
    func configureScene() {
        
        self.view?.showsFPS = true
        self.view?.showsPhysics = true
        self.view?.showsFields = true
        self.view?.showsDrawCount = true
        self.view?.showsQuadCount = true
        self.view?.showsNodeCount = true
    }
    
    
    func makePrefabs() {
        
        // Create wall prefab
        self.wallPrefab = SKShapeNode.init(rectOf: self.wallSizeFor(rows: 6, columns: 8), cornerRadius: 0)
        
        self.wallPrefab.lineWidth = 2.5
        self.wallPrefab.strokeColor = SKColor.green
        self.wallPrefab.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                                      SKAction.fadeAlpha(to: 0.3, duration: 1),
                                                                      SKAction.fadeAlpha(to: 1, duration: 1)
                                                                     ])))
    }
    
    
    func generateBall() {
        
        self.ballNode = SKSpriteNode(imageNamed: "ball")
        self.ballNode.name = "ball"
        self.ballNode.position = CGPoint(x: 0, y: -300)
        self.addChild(self.ballNode)
        
        self.ballNode.physicsBody = SKPhysicsBody(circleOfRadius: self.ballNode.frame.size.width / 2)
        self.ballNode.physicsBody?.friction = 0
        self.ballNode.physicsBody?.restitution = 0
        self.ballNode.physicsBody?.linearDamping = 0
        self.ballNode.physicsBody?.allowsRotation = false
    }
    
    
    func generatePaddle() {
        
        
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Grid Items (brick)
    
    
    func generateGrid() {
        
        // Level array
        let levelArray = [
            [1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 0, 1, 1, 0, 1, 1],
            [1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 0, 1, 1, 0, 1, 1],
            [1, 1, 1, 0, 0, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1, 1]
        ]
        
        for (row, columnStorage) in levelArray.enumerated() {
            for (column, value) in columnStorage.enumerated() {
                self.generateGridItemOf(type: value, row: row, column: column, cX: columnStorage.count, cY: levelArray.count)
            }
        }
    }
    
    
    func generateGridItemOf(type: Int, row: Int, column: Int, cX: Int, cY: Int) {
        
        // Skip empty wall segment
        if type == 0 {
            return
        }
        
        // Generate wall segment and configure its properties based on the type
        let wallItem = self.wallPrefab.copy() as! SKShapeNode
        wallItem.position = self.positionOfWallFor(row: row, column: column, rows: cY, columns: cX)
        self.addChild(wallItem)
    }
    
    
    func wallSizeFor(rows: Int, columns: Int) -> CGSize {
        
        // Calculate the size of the wall block based on the variables in level configuration
        
        let width = (self.screenSize().width - (2.0 * OFFSET_SIDE) - (CGFloat(columns - 1) * BLOCK_SPACING)) / CGFloat(columns)
        let height = ROW_HEIGHT
        
        return CGSize(width: width, height: height)
    }
    
    
    func positionOfWallFor(row: Int, column: Int, rows: Int, columns: Int) -> CGPoint {
        
        // Calculate the position of the wall block based on the variables in level configuration
        let wallSize = self.wallSizeFor(rows: rows, columns: columns)
        
        let verticalSize = ROW_HEIGHT * CGFloat(rows) + BLOCK_SPACING * CGFloat(rows - 1)
        let x = OFFSET_SIDE + (wallSize.width / 2.0) + ((wallSize.width + BLOCK_SPACING) * CGFloat(column)) - self.screenCoordinateOffset().width
        let y = (wallSize.height / 2.0) - ((wallSize.height + BLOCK_SPACING) * CGFloat(row)) + (verticalSize) - OFFSET_TOP
        
        return CGPoint(x: x, y: y)
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Touch events
    
    override func update(_ currentTime: TimeInterval) {
        
        // Called before each frame is rendered
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Convenience
    
    func screenCoordinateOffset() -> CGSize {
        
        // Calculate offset from the center, so it makes the calculations easier
        if let view = self.view {
            return CGSize(width: view.frame.size.width / 2, height: -view.frame.size.height / 2)
        }
        
        return CGSize.zero
    }
    
    
    func screenSize() -> CGSize {
        
        return view?.frame.size ?? CGSize.zero
    }
}
