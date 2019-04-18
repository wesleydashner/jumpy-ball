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
    var wall = SKSpriteNode()
    
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
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.isDynamic = true
        self.addChild(ball)
        
        createWall()
        
    }
    
    
    func createWall() {
        
        let wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "wall")
        let bottomWall = SKSpriteNode(imageNamed: "wall")
        
        topWall.position = CGPoint(x: 0, y: 500)
        bottomWall.position = CGPoint(x: 0, y: -500)
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
        
        self.addChild(wallPair)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 135))
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
