//
//  GameScene.swift
//  Jumpy Ball
//
//  Created by Wesley Dashner on 4/18/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKSpriteNode()
    var ground = SKSpriteNode()
    var ceiling = SKSpriteNode()
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = false
    
    var score = 0
    let scoreLabel = SKLabelNode()
    var bestScore = 0
    let bestLabel = SKLabelNode()
    
    var isDead = false
    
    var restartButton = SKSpriteNode()
    
    let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    let notificationGenerator = UINotificationFeedbackGenerator()
    
    func restartGame() {
        
        self.removeAllChildren()
        self.removeAllActions()
        isDead = false
        gameStarted = false
        score = 0
        createScene()
        
    }
    
    func createScene() {
        
        backgroundColor = UIColor.gray
        
        scoreLabel.text = "\(score)"
        scoreLabel.position = CGPoint(x: 0, y: 0)
        scoreLabel.fontName = "Nexa-Heavy"
        scoreLabel.fontColor = UIColor.black
        scoreLabel.fontSize = 300
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        
        bestLabel.text = "BEST: \(bestScore)"
        bestLabel.position = CGPoint(x: 0, y: -100)
        bestLabel.fontName = "Nexa-Heavy"
        bestLabel.fontColor = UIColor.black
        bestLabel.fontSize = 50
        bestLabel.zPosition = 1
        self.addChild(bestLabel)
        
        self.physicsWorld.contactDelegate = self
        
        ground = SKSpriteNode(imageNamed: "ground")
        ground.setScale(0.7)
        ground.position = CGPoint(x: 0, y: -(self.frame.height / 2) + ground.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.ball
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        self.addChild(ground)
        
        ceiling = SKSpriteNode(imageNamed: "ground")
        ceiling.setScale(0.7)
        ceiling.position = CGPoint(x: 0, y: (self.frame.height / 2) + (ceiling.frame.height / 2))
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size)
        ceiling.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ceiling.physicsBody?.collisionBitMask = PhysicsCategory.ball
        ceiling.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        ceiling.physicsBody?.affectedByGravity = false
        ceiling.physicsBody?.isDynamic = false
        self.addChild(ceiling)
        
        ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 80, height: 80)
        ball.position = CGPoint(x: -(ball.frame.width * 2), y: 0)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width / 2)
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.wall
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.wall | PhysicsCategory.scoreNode
        ball.physicsBody?.affectedByGravity = false // Set to true once game starts.
        ball.physicsBody?.isDynamic = true
        self.addChild(ball)
        
    }
    
    override func didMove(to view: SKView) {
        
        createScene()
        
    }
    
    
    func createRestartButton() {
        restartButton = SKSpriteNode(imageNamed: "restartButton")
        restartButton.setScale(0.15)
        restartButton.position = CGPoint(x: 0, y: 400)
        restartButton.zPosition = 3
        self.addChild(restartButton)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.scoreNode && secondBody.categoryBitMask == PhysicsCategory.ball || secondBody.categoryBitMask == PhysicsCategory.scoreNode && firstBody.categoryBitMask == PhysicsCategory.ball {
            
            if isDead == false {
                score += 1
                scoreLabel.text = "\(score)"
                ball.zPosition = 2
            }
            
        }
        
        else if firstBody.categoryBitMask == PhysicsCategory.ball && secondBody.categoryBitMask == PhysicsCategory.wall || firstBody.categoryBitMask == PhysicsCategory.wall && secondBody.categoryBitMask == PhysicsCategory.ball || firstBody.categoryBitMask == PhysicsCategory.ball && secondBody.categoryBitMask == PhysicsCategory.ground || firstBody.categoryBitMask == PhysicsCategory.ground && secondBody.categoryBitMask == PhysicsCategory.ball {
            
            if isDead == false {
                notificationGenerator.notificationOccurred(.error)
                
                if score > bestScore {
                    UserDefaults.standard.set(score, forKey: "bestScore")
                    bestLabel.text = "BEST: \(score)"
                }
                
                isDead = true
                createRestartButton()
            }
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted == false {
            gameStarted = true
            
            ball.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.run({
                () in
                self.createWall()
            })
            let delay = SKAction.wait(forDuration: 3)
            let spawnDelayForever = SKAction.repeatForever(SKAction.sequence([spawn, delay]))
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width * 2 + wallPair.frame.width)
            let moveWalls = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.01 * distance))
            let removeWalls = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([moveWalls, removeWalls])
            
            moveBall()
            
        }
        else {
            
            if isDead == false {
                moveBall()
            }
            
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if isDead == true && restartButton.contains(location) {
                impactGenerator.impactOccurred()
                restartGame()
            }
        }
        
    }
    
    
    func moveBall() {
        
        impactGenerator.impactOccurred()
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 135))
        
    }
    
    
    func createWall() {
        
        wallPair = SKNode()
        
        wallPair.zPosition = 2
        
        let topWall = SKSpriteNode(imageNamed: "wall")
        let bottomWall = SKSpriteNode(imageNamed: "wall")
        
        // y-value adjusts height of openings
        let gapSize: CGFloat = 1300
        topWall.position = CGPoint(x: self.frame.width / 2 + topWall.frame.width / 2, y: gapSize / 2)
        bottomWall.position = CGPoint(x: self.frame.width / 2 + bottomWall.frame.width / 2, y: -gapSize / 2)
        topWall.setScale(0.7)
        bottomWall.setScale(0.7)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.ball
        topWall.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.isDynamic = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        bottomWall.physicsBody?.collisionBitMask = PhysicsCategory.ball
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        bottomWall.physicsBody?.affectedByGravity = false
        bottomWall.physicsBody?.isDynamic = false
        
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: gapSize + topWall.frame.height)
        scoreNode.position = CGPoint(x: self.frame.width / 2 + topWall.frame.width, y: 0)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.scoreNode
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        wallPair.addChild(scoreNode)
        
        wallPair.position.y += CGFloat.random(in: -300...300)
        
        wallPair.run(moveAndRemove)
        
        self.addChild(wallPair)
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
