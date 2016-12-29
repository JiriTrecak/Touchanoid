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


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Extension - Touch Bar

class GameScene: SKScene {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    // World prefabs and objects
    var wallPrefab: SKShapeNode!
    var ballNode: SKSpriteNode!
    var ballEffectNode: SKEmitterNode!
    var edgeNode: SKShapeNode!
    var paddleNode: SKShapeNode!
    
    // Game state
    var gameState: GameState = .ready
    var paddleState: PaddleState = .still
    var currentLevel: Level!
    var currentBall: Ball!
    
    
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
    // MARK: - Game setup
    
    func configureWithLevel(level: Level, ball: Ball?) {
        
        // Pause the game
        self.gameState = .paused
        
        // Remove everything in scene
        self.removeAllChildren()
        self.removeAllActions()
        
        // Assign new level
        self.currentLevel = level
        
        self.makePrefabs()
        self.generateEdge()
        self.generateGrid()
        self.generatePaddle()
        self.generateBall()
        
        if let ball = ball {
            self.configureWithBall(ball: ball)
        } else {
            self.configureWithBall(ball: self.currentBall)
        }
        
        // Prepare the game
        self.gameState = .ready
    }
    
    
    func configureWithBall(ball: Ball) {
        
        self.currentBall = ball
        
        // Remove previous particle emitter, if any
        if self.ballEffectNode != nil {
            self.ballEffectNode.removeFromParent()
        }
        
        // Setup new particle emitter, if applicable
        if let emitterName = ball.emitterName {
            self.ballEffectNode = SKEmitterNode(fileNamed: emitterName)
            self.ballNode.addChild(self.ballEffectNode)
            self.ballEffectNode.particleLifetime = self.gameState == .playing ? 2 : 0
            self.ballEffectNode.targetNode = self
        }
    }
    
    
    func configureScene() {
        
        self.view?.showsFPS = true
        self.view?.showsPhysics = true
        self.view?.showsFields = true
        self.view?.showsDrawCount = true
        self.view?.showsQuadCount = true
        self.view?.showsNodeCount = true
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.zero
    }
    
    
    func makePrefabs() {
        
        // Create wall prefab
        self.wallPrefab = SKShapeNode.init(rectOf: self.wallSizeFor(rows: 6, columns: 8), cornerRadius: 0)
        self.wallPrefab.name = "wall"
        
        self.wallPrefab.lineWidth = 2.5
        self.wallPrefab.strokeColor = SKColor.green
        self.wallPrefab.fillColor = self.wallPrefab.strokeColor.withAlphaComponent(0.3)
        
        self.wallPrefab.physicsBody = SKPhysicsBody(rectangleOf: self.wallPrefab.frame.size)
        self.wallPrefab.physicsBody?.usesPreciseCollisionDetection = true
        self.wallPrefab.physicsBody?.categoryBitMask = CollisionCategory.Wall
        self.wallPrefab.physicsBody?.contactTestBitMask = CollisionCategory.Ball
        self.wallPrefab.physicsBody?.collisionBitMask = CollisionCategory.Ball
        self.configureBodyToNotObeyPhysics(body: self.wallPrefab.physicsBody!, dynamic: false)
    }
    
    
    func generateBall() {
        
        self.ballNode = SKSpriteNode(color: NSColor.clear, size: CGSize(width: 20, height: 20))
        self.ballNode.name = "ball"
        self.ballNode.position = CGPoint(x: 0, y: -300)
        self.addChild(self.ballNode)
        
        self.ballNode.physicsBody = SKPhysicsBody(circleOfRadius: self.ballNode.frame.size.width / 2)
        self.ballNode.physicsBody?.categoryBitMask = CollisionCategory.Ball
        self.ballNode.physicsBody?.contactTestBitMask = CollisionCategory.Wall | CollisionCategory.Edge | CollisionCategory.Paddle
        self.ballNode.physicsBody?.collisionBitMask = CollisionCategory.Wall | CollisionCategory.Edge | CollisionCategory.Paddle
        self.configureBodyToNotObeyPhysics(body: self.ballNode.physicsBody!, dynamic: true)
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Game state manipulation
    
    func startGame() {
        
        if self.gameState == .ready {
            self.gameState = .playing
            self.ballNode.physicsBody?.applyImpulse(GameConfiguration.initialBallSpeed)
            self.ballEffectNode.particleLifetime = 2
        }
    }
    
    
    func restartGame() {
        
        // Configure current level
        self.configureWithLevel(level: self.currentLevel, ball: self.currentBall)
    }
    
    
    func generatePaddle() {
        
        // Create paddle prefab
        self.paddleNode = SKShapeNode.init(rectOf: CGSize(width: 120, height: 20), cornerRadius: 0)
        self.paddleNode.name = "paddle"
        self.paddleNode.position = CGPoint(x: 0, y: -315)
        
        self.paddleNode.lineWidth = 2.5
        self.paddleNode.strokeColor = SKColor.white
        self.paddleNode.fillColor = self.paddleNode.strokeColor.withAlphaComponent(0.3)
        
        self.paddleNode.physicsBody = SKPhysicsBody(rectangleOf: self.paddleNode.frame.size)
        self.paddleNode.physicsBody?.usesPreciseCollisionDetection = true
        self.paddleNode.physicsBody?.categoryBitMask = CollisionCategory.Paddle
        self.paddleNode.physicsBody?.contactTestBitMask = CollisionCategory.Ball | CollisionCategory.Edge
        self.paddleNode.physicsBody?.collisionBitMask = CollisionCategory.Ball | CollisionCategory.Edge
        self.configureBodyToNotObeyPhysics(body: self.paddleNode.physicsBody!, dynamic: true)
        self.addChild(self.paddleNode)
    }
    
    
    func generateEdge() {
        
        let frame = self.view!.frame
        let edgeFrame = CGRect(x: -frame.size.width / 2, y: -frame.size.height / 2, width: frame.size.width, height: frame.size.height)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: edgeFrame)
        self.physicsBody?.usesPreciseCollisionDetection = true

        self.physicsBody?.categoryBitMask = CollisionCategory.Edge
        self.physicsBody?.contactTestBitMask = CollisionCategory.Ball
        self.physicsBody?.collisionBitMask = CollisionCategory.Ball
        self.configureBodyToNotObeyPhysics(body: self.physicsBody!, dynamic: false)
    }
    
    
    func configureBodyToNotObeyPhysics(body: SKPhysicsBody, dynamic: Bool) {
        
        body.friction = 0
        body.restitution = 1
        body.angularDamping = 0
        body.linearDamping = 0
        body.allowsRotation = false
        body.isDynamic = dynamic
    }
    
    
    func updateBallEmitter() {
        
        // Calculate angle from the vector
        let vector = self.ballNode.physicsBody!.velocity
        let angle = atan2(vector.dy, vector.dx)
        
        self.ballEffectNode.emissionAngle = angle
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Grid Items (brick)
    
    
    func generateGrid() {
        
        // Level array
        let levelArray = self.currentLevel.levelDefinition
        
        for (row, columnStorage) in levelArray.enumerated() {
            for (column, rawWallType) in columnStorage.enumerated() {
                if let wallType = WallType(rawValue: rawWallType) {
                    self.generateGridItemOf(type: wallType, row: row, column: column, cX: columnStorage.count, cY: levelArray.count)
                } else {
                    assertionFailure("Definition of the level contains wrong wall type \(rawWallType). See Wall.swift for allowed types.")
                }
            }
        }
    }
    
    
    func generateGridItemOf(type: WallType, row: Int, column: Int, cX: Int, cY: Int) {
        
        // Skip empty wall segment
        if type == .Empty {
            return
        }
        
        // Generate wall segment and configure its properties based on the type
        let wallObject = GOWall()
        wallObject.configureWithType(type: type)
        
        // Generate the physical object in space
        let wallItem = self.wallPrefab.copy() as! SKShapeNode
        wallItem.userData = ["storage" : wallObject]
        wallItem.position = self.positionOfWallFor(row: row, column: column, rows: cY, columns: cX)
        self.configureWall(wall: wallItem, withObject: wallObject)
        self.addChild(wallItem)
    }
    
    
    func wallSizeFor(rows: Int, columns: Int) -> CGSize {
        
        // Calculate the size of the wall block based on the variables in level configuration
        
        let width = (self.screenSize().width - (2.0 * GridConfiguration.spacingSide) - (CGFloat(columns - 1) * GridConfiguration.blockSpacing)) / CGFloat(columns)
        let height = GridConfiguration.rowHeight
        
        return CGSize(width: width, height: height)
    }
    
    
    func positionOfWallFor(row: Int, column: Int, rows: Int, columns: Int) -> CGPoint {
        
        // Calculate the position of the wall block based on the variables in level configuration
        let wallSize = self.wallSizeFor(rows: rows, columns: columns)
        
        let verticalSize = GridConfiguration.rowHeight * CGFloat(rows) + GridConfiguration.blockSpacing * CGFloat(rows - 1)
        let x = GridConfiguration.spacingSide + (wallSize.width / 2.0) + ((wallSize.width + GridConfiguration.blockSpacing) * CGFloat(column)) - self.screenCoordinateOffset().width
        let y = (wallSize.height / 2.0) - ((wallSize.height + GridConfiguration.blockSpacing) * CGFloat(row)) + (verticalSize) - GridConfiguration.spacingTop
        
        return CGPoint(x: x, y: y)
    }
    
    
    func configureWall(wall: SKShapeNode, withObject object: GOWall) {
        
        wall.fillColor = object.fillColor()
        wall.strokeColor = object.strokeColor()
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - SK Physics
    
    override func update(_ currentTime: TimeInterval) {
        
        // Update paddle position to always stay on Y axis
        if self.gameState == .playing {
            self.paddleNode.position = CGPoint(x: self.paddleNode.position.x, y: GameConfiguration.paddleStartingPosition.y)
        }
        
        // Called before each frame is rendered
        if self.paddleState != .still && self.gameState == .playing {
            
            // Apply impulse to a paddle
            let impulse = self.paddleState == .movingRight ? GameConfiguration.paddleAcceleration : -GameConfiguration.paddleAcceleration
            self.paddleNode.physicsBody!.applyImpulse(CGVector(dx: impulse, dy: 0))
        }
    }
    
    
    override func didSimulatePhysics() {
        
        super.didSimulatePhysics()
    }
    
    
    func nullifyPaddleMovement() {
        
        self.paddleNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Key events
    
    override func keyUp(with event: NSEvent) {
        
        self.handleKeyEvent(event: event, keyDown: false)
    }
    
    override func keyDown(with event: NSEvent) {
        
        self.handleKeyEvent(event: event, keyDown: true)
    }
    
    public func handleKeyEvent(event: NSEvent, keyDown: Bool) {
        
        if event.modifierFlags.contains(NSEventModifierFlags.numericPad) {
            if let theArrow = event.charactersIgnoringModifiers, let keyChar = theArrow.unicodeScalars.first?.value {
                switch Int(keyChar){
                    case NSRightArrowFunctionKey:
                        self.handleRightArrowKey(up: !keyDown)
                        break
                    case NSLeftArrowFunctionKey:
                        self.handleLeftArrowKey(up: !keyDown)
                        break
                    default:
                        break
                }
            }
        } else if let characters = event.characters, keyDown {
            for character in characters.characters{
                switch character {
                    case " ":
                        self.handleSpace()
                        break
                    case "r":
                        self.handleRestart()
                        break
                    default:
                        print(character)
                }
            }
        }
    }
    
    
    func handleSpace() {
        
        self.startGame()
    }
    
    
    func handleRestart() {
        
        self.restartGame()
    }
    
    
    func handleRightArrowKey(up: Bool) {
        
        // User released right arrow key
        if up {
            self.paddleState = .still
            self.nullifyPaddleMovement()
            
        // User is holding right arrow key
        } else {
            self.paddleState = .movingRight
        }
    }
    
    
    func handleLeftArrowKey(up: Bool) {
        
        // User released left arrow key
        if up {
            self.paddleState = .still
            self.nullifyPaddleMovement()
            
        // User is holding right arrow key
        } else {
            self.paddleState = .movingLeft
        }
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


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Extension - Physics delegate

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "wall" {
            self.contact(wall: contact.bodyB.node! as! SKShapeNode)
        } else if contact.bodyA.node?.name == "wall" && contact.bodyB.node?.name == "ball" {
            self.contact(wall: contact.bodyA.node! as! SKShapeNode)
        } else {
            NSLog("different collision")
        }
        
        self.updateBallEmitter()
    }
    
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    
    func contact(wall: SKShapeNode) {
        
        let wallObject = wall.userData!["storage"] as! GOWall
        
        // Handle wall collision with ball, remove it from space if it should be removed, otherwise update its state in space
        wallObject.handleBallCollision(shouldRemove: { 
            wall.removeFromParent()
        }, persists: {
            self.configureWall(wall: wall, withObject: wallObject)
        })
    }
}






