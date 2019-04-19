//
//  GameScene.swift
//  Jumpy Ball
//
//  Created by Wesley Dashner on 4/18/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var ground = SKSpriteNode()
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor.gray
        
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
        
        ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 80, height: 80)
        ball.position = CGPoint(x: -(ball.frame.width * 2), y: 0)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width / 2)
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.wall
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.wall
        ball.physicsBody?.affectedByGravity = false // Set to true once game starts.
        ball.physicsBody?.isDynamic = true
        self.addChild(ball)
        
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
            
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 135))
        }
        else {
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 135))
        }
        
    }
    
    
    func createWall() {
        
        wallPair = SKNode()
        
        let topWall = SKSpriteNode(imageNamed: "wall")
        let bottomWall = SKSpriteNode(imageNamed: "wall")
        
        // y-value adjusts height of openings
        topWall.position = CGPoint(x: self.frame.width / 2 + topWall.frame.width / 2, y: 655)
        bottomWall.position = CGPoint(x: self.frame.width / 2 + bottomWall.frame.width / 2, y: -655)
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
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        
        wallPair.position.y += CGFloat.random(in: -300...300)
        
        wallPair.run(moveAndRemove)
        
        self.addChild(wallPair)
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
