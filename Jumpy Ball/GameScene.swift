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
        ball.size = CGSize(width: 70, height: 70)
        ball.position = CGPoint(x: -(ball.frame.width * 2), y: 0)
        self.addChild(ball)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
