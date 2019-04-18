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
        self.addChild(ground)
        
        ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 80, height: 80)
        ball.position = CGPoint(x: -(ball.frame.width * 2), y: 0)
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
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        
        self.addChild(wallPair)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
