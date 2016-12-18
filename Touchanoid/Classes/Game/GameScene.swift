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

enum GameState {
    case ready
    case playing
    case paused
    case ended
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
    var gameState: GameState = .ready
    
    
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
        self.wallPrefab.physicsBody?.restitution = 0
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
        self.ballNode.physicsBody?.restitution = 0
        self.ballNode.physicsBody?.angularDamping = 0
        self.ballNode.physicsBody?.linearDamping = 0
        self.ballNode.physicsBody?.allowsRotation = false
        self.ballNode.physicsBody?.categoryBitMask = CollisionCategory.Ball
        self.ballNode.physicsBody?.contactTestBitMask = CollisionCategory.Wall | CollisionCategory.Edge
        self.ballNode.physicsBody?.collisionBitMask = CollisionCategory.Wall | CollisionCategory.Edge
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Game state manipulation
    
    func startGame() {
        
        if self.gameState == .ready {
            self.gameState = .playing
            self.ballNode.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 3))
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
        
        
    }
    
    
    func generateEdge() {
        
        let frame = self.view!.frame
        let edgeFrame = CGRect(x: -frame.size.width / 2, y: -frame.size.height / 2, width: frame.size.width, height: frame.size.height)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: edgeFrame)
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
            [0, 0, 1, 1, 1, 1, 0, 0]
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
    // MARK: - Key events
    
    
    override func keyUp(with event: NSEvent) {
        
        self.handleKeyEvent(event: event, keyDown: false)
    }
    
    
    public func handleKeyEvent(event: NSEvent, keyDown: Bool){
        
        if event.modifierFlags.contains(NSEventModifierFlags.numericPad) {
            if let theArrow = event.charactersIgnoringModifiers, let keyChar = theArrow.unicodeScalars.first?.value {
                switch Int(keyChar){
                    case NSRightArrowFunctionKey:
                        self.handleRightArrowKey()
                        break
                    case NSLeftArrowFunctionKey:
                        self.handleLeftArrowKey()
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
    
    
    func handleRightArrowKey() {
        
        NSLog("right")
    }
    
    
    func handleLeftArrowKey() {
        
        NSLog("left")
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
        // self.updateBallVelocity()
    }
    
    
    func updateBallVelocity() {
        let previousVelocity = self.ballNode.physicsBody!.velocity
        NSLog("velocity %f, %f", previousVelocity.dx, previousVelocity.dy)
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
            self.destroy(wall: contact.bodyB.node!)
        } else if contact.bodyA.node?.name == "wall" && contact.bodyB.node?.name == "ball" {
            self.destroy(wall: contact.bodyA.node!)
        } else {
            NSLog("different collision")
        }
    }
    
    func destroy(wall: SKNode) {
        wall.removeFromParent()
    }
}






