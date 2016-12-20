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
private let BALL_SPEED: CGVector = CGVector(dx: 5, dy: 5)
private let PADDLE_ACCELERATION_IMPULSE: CGFloat = 5
private let PADDLE_STARTING_POSITION: CGPoint = CGPoint(x: 0, y: -315)

enum GameState {
    case ready
    case playing
    case paused
    case ended
}

enum PaddleStateKey {
    case none
    case left
    case right
}

struct CollisionCategory {
    static let None:        UInt32 = 0      //  0
    static let Edge:        UInt32 = 0b1    //  1
    static let Paddle:      UInt32 = 0b10   //  2
    static let Ball:        UInt32 = 0b100  //  4
    static let Wall:        UInt32 = 0b1000 //  8
}


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Extension - Touch Bar

class GameScene: SKScene {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    var wallPrefab: SKShapeNode!
    var ballNode: SKSpriteNode!
    var edgeNode: SKShapeNode!
    var paddleNode: SKShapeNode!
    var gameState: GameState = .ready
    var currentPaddleStateKey: PaddleStateKey = .none
    
    
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
    
    func setupLevel() {
        
        self.makePrefabs()
        
        self.generateEdge()
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
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.zero
    }
    
    
    func makePrefabs() {
        
        // Create wall prefab
        self.wallPrefab = SKShapeNode.init(rectOf: self.wallSizeFor(rows: 6, columns: 8), cornerRadius: 0)
        self.wallPrefab.name = "wall"
        
        self.wallPrefab.lineWidth = 2.5
        self.wallPrefab.strokeColor = SKColor.green
        self.wallPrefab.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                                      SKAction.fadeAlpha(to: 0.3, duration: 1),
                                                                      SKAction.fadeAlpha(to: 1, duration: 1)
                                                                     ])))
        
        self.wallPrefab.physicsBody = SKPhysicsBody(rectangleOf: self.wallPrefab.frame.size)
        self.wallPrefab.physicsBody?.friction = 0
        self.wallPrefab.physicsBody?.restitution = 1
        self.wallPrefab.physicsBody?.allowsRotation = false
        self.wallPrefab.physicsBody?.isDynamic = false
        self.wallPrefab.physicsBody?.angularDamping = 0
        self.wallPrefab.physicsBody?.linearDamping = 0
        self.wallPrefab.physicsBody?.usesPreciseCollisionDetection = true
        self.wallPrefab.physicsBody?.categoryBitMask = CollisionCategory.Wall
        self.wallPrefab.physicsBody?.contactTestBitMask = CollisionCategory.Ball
        self.wallPrefab.physicsBody?.collisionBitMask = CollisionCategory.Ball
    }
    
    
    func generateBall() {
        
        self.ballNode = SKSpriteNode(imageNamed: "ball")
        self.ballNode.name = "ball"
        self.ballNode.position = CGPoint(x: 0, y: -300)
        self.addChild(self.ballNode)
        
        self.ballNode.physicsBody = SKPhysicsBody(circleOfRadius: self.ballNode.frame.size.width / 2)
        self.ballNode.physicsBody?.friction = 0
        self.ballNode.physicsBody?.usesPreciseCollisionDetection = true
        self.ballNode.physicsBody?.restitution = 1
        self.ballNode.physicsBody?.angularDamping = 0
        self.ballNode.physicsBody?.linearDamping = 0
        self.ballNode.physicsBody?.allowsRotation = false
        self.ballNode.physicsBody?.categoryBitMask = CollisionCategory.Ball
        self.ballNode.physicsBody?.contactTestBitMask = CollisionCategory.Wall | CollisionCategory.Edge | CollisionCategory.Paddle
        self.ballNode.physicsBody?.collisionBitMask = CollisionCategory.Wall | CollisionCategory.Edge | CollisionCategory.Paddle
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Game state manipulation
    
    func startGame() {
        
        if self.gameState == .ready {
            self.gameState = .playing
            self.ballNode.physicsBody?.applyImpulse(BALL_SPEED)
        }
    }
    
    
    func restartGame() {
        
        // Pause the game
        self.gameState = .paused
        
        // Remove everything in scene
        self.removeAllChildren()
        self.removeAllActions()
        
        // Configure current level
        self.setupLevel()
        
        // Prepare the game
        self.gameState = .ready
    }
    
    
    func generatePaddle() {
        
        // Create paddle prefab
        self.paddleNode = SKShapeNode.init(rectOf: CGSize(width: 100, height: 20), cornerRadius: 0)
        self.paddleNode.name = "paddle"
        self.paddleNode.position = CGPoint(x: 0, y: -315)
        
        self.paddleNode.lineWidth = 2.5
        self.paddleNode.strokeColor = SKColor.white
        self.paddleNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                                      SKAction.fadeAlpha(to: 0.3, duration: 1),
                                                                      SKAction.fadeAlpha(to: 1, duration: 1)
        ])))
        
        self.paddleNode.physicsBody = SKPhysicsBody(rectangleOf: self.wallPrefab.frame.size)
        self.paddleNode.physicsBody?.friction = 0
        self.paddleNode.physicsBody?.restitution = 1
        self.paddleNode.physicsBody?.allowsRotation = false
        self.paddleNode.physicsBody?.isDynamic = true
        self.paddleNode.physicsBody?.angularDamping = 0
        self.paddleNode.physicsBody?.linearDamping = 0
        self.paddleNode.physicsBody?.usesPreciseCollisionDetection = true
        self.paddleNode.physicsBody?.categoryBitMask = CollisionCategory.Paddle
        self.paddleNode.physicsBody?.contactTestBitMask = CollisionCategory.Ball | CollisionCategory.Edge
        self.paddleNode.physicsBody?.collisionBitMask = CollisionCategory.Ball | CollisionCategory.Edge
        self.addChild(self.paddleNode)
    }
    
    
    func generateEdge() {
        
        let frame = self.view!.frame
        let edgeFrame = CGRect(x: -frame.size.width / 2, y: -frame.size.height / 2, width: frame.size.width, height: frame.size.height)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: edgeFrame)
        self.physicsBody?.friction = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.restitution = 1
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = CollisionCategory.Edge
        self.physicsBody?.contactTestBitMask = CollisionCategory.Ball
        self.physicsBody?.collisionBitMask = CollisionCategory.Ball
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
            [0, 1, 1, 0, 0, 1, 1, 0],
            [2, 2, 2, 2, 2, 2, 2, 2]
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
        let wallObject = Wall()
        wallObject.configureWithType(type: type)
        
        let wallItem = self.wallPrefab.copy() as! SKShapeNode
        wallItem.userData = ["storage" : wallObject]
        wallItem.position = self.positionOfWallFor(row: row, column: column, rows: cY, columns: cX)
        self.configureWall(wall: wallItem, withObject: wallObject)
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
        
        // Update paddle position to always stay on Y axis
        if self.gameState == .playing {
//            let body = self.paddleNode.physicsBody!
//            let impulse = CGVector(dx: -body.velocity.dx, dy: -body.velocity.dy)
//            self.paddleNode.physicsBody?.applyImpulse(impulse)
            self.paddleNode.position = CGPoint(x: self.paddleNode.position.x, y: PADDLE_STARTING_POSITION.y)
        }
        
        // Called before each frame is rendered
        if self.currentPaddleStateKey != .none && self.gameState == .playing {
            
            // Apply impulse to a paddle
            let impulse = self.currentPaddleStateKey == .right ? PADDLE_ACCELERATION_IMPULSE : -PADDLE_ACCELERATION_IMPULSE
            self.paddleNode.physicsBody!.applyImpulse(CGVector(dx: impulse, dy: 0))
        }
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
        } else if let characters = event.characters {
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
        NSLog("space")
    }
    
    
    func handleRestart() {
        
        self.restartGame()
        NSLog("restart")
    }
    
    
    func handleRightArrowKey(up: Bool) {
        
        if up {
            NSLog("right up")
            // TODO: handle holding left key
            self.currentPaddleStateKey = .none
            self.nullifyPaddleMovement()
        // User is holding right arrow key
        } else {
            NSLog("right down")
            self.currentPaddleStateKey = .right
        }
    }
    
    
    func handleLeftArrowKey(up: Bool) {
        
        if up {
            NSLog("left up")
            // TODO: handle holding left key
            self.currentPaddleStateKey = .none
            self.nullifyPaddleMovement()
            // User is holding right arrow key
        } else {
            NSLog("left down")
            self.currentPaddleStateKey = .left
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
    
    
    override func didSimulatePhysics() {
        
        super.didSimulatePhysics()
        
        // Update ball vector
        // TODO:
    }
    
    
    func updateBallVelocity() {
        let previousVelocity = self.ballNode.physicsBody!.velocity
        let x = previousVelocity.dx > 0 ? 1 : -1
        let y = previousVelocity.dy > 0 ? 1 : -1
        self.ballNode.physicsBody?.velocity = CGVector(dx: x, dy: y)
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
    }
    
    func contact(wall: SKShapeNode) {
        
        let wallObject = wall.userData!["storage"] as! Wall
        wallObject.health -= 1
        
        if wallObject.health == 0 {
            wall.removeFromParent()
        } else {
            self.configureWall(wall: wall, withObject: wallObject)
        }
    }
    
    func configureWall(wall: SKShapeNode, withObject object: Wall) {
        
        if object.health == 1 {
            wall.strokeColor = NSColor.green
        } else if object.health == 2 {
            wall.strokeColor = NSColor.blue
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        // Force direction
        if contact.bodyA.node?.name == "ball" {
            
        }
    }
}






