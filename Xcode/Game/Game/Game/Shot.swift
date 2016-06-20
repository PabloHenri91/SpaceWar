//
//  Laser.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Shot: Control {
    
    static var shotSet = Set<Shot>()
    
    var demage:Int! = 0
    
    var rangeSquared:CGFloat = 0
    
    var startingPosition:CGPoint = CGPoint.zero
    
    init(demage:Int, range:CGFloat, texture:SKTexture, position: CGPoint, zRotation: CGFloat, shooterPhysicsBody:SKPhysicsBody) {
        super.init()
        
        self.demage = demage
        self.rangeSquared = range * range
        
        self.startingPosition = position
        
        if demage <= 0 {
            #if DEBUG
                fatalError()
            #endif
        }
        
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.texture?.filteringMode = Display.filteringMode
        
        self.addChild(spriteNode)
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size)
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.spaceshipShot.rawValue
        self.physicsBody?.collisionBitMask = GameWorld.collisionBitMask.spaceshipShot
        self.physicsBody?.contactTestBitMask = GameWorld.contactTestBitMask.spaceshipShot
        
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        
        self.position = position
        self.zRotation = zRotation
        self.physicsBody?.velocity = CGVector(dx: (-sin(zRotation) * 1000) + shooterPhysicsBody.velocity.dx, dy: (cos(zRotation) * 1000) + shooterPhysicsBody.velocity.dy)
        
        self.runAction({ let a = SKAction(); a.duration = 3; return a }()) { [weak self] in
            guard let shot = self else { return }
            shot.removeFromParent()
        }
        
         Shot.shotSet.insert(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetBitMasks() {
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.shot.rawValue
        self.physicsBody?.collisionBitMask = GameWorld.collisionBitMask.shot
        self.physicsBody?.contactTestBitMask = GameWorld.contactTestBitMask.shot
    }
    
    static func update() {
        for shot in Shot.shotSet {
            shot.update()
        }
    }
    
    func update() {
        let distanceSquared = CGPoint.distanceSquared(self.startingPosition, self.position)
        if distanceSquared >= self.rangeSquared {
            self.removeFromParent()
            //print(sqrt(self.rangeSquared).description + " " + sqrt(distanceSquared).description)
        }
    }
    
    override func removeFromParent() {
        Shot.shotSet.remove(self)
        super.removeFromParent()
    }
}
