//
//  HealthPack.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 11/17/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class HealthPack: SKSpriteNode {
    
    var health: Int
    
    init() {
        let texture = SKTexture(imageNamed: "halthPack")
        
        self.health = 1
        
        super.init(texture: texture, color: GameColors.white, size: texture.size())
        
        self.zPosition = GameWorld.zPositions.shot.rawValue
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 14)
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.healthPack.rawValue
        self.physicsBody?.collisionBitMask = GameWorld.collisionBitMask.healthPack
        self.physicsBody?.contactTestBitMask = GameWorld.contactTestBitMask.healthPack
        
        self.physicsBody?.linearDamping = 1
        
        let d = CGFloat.random(min: 0, max: 2 * π)
        self.position = CGPoint(x: cos(d) * 1000, y: sin(d) * 1000)
        
        self.physicsBody?.velocity = CGVector(point: self.position.normalized() * -1000)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
