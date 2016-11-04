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
    
    var damage:Int! = 0
    
    var rangeSquared:CGFloat = 0
    
    var startingPosition:CGPoint = CGPoint.zero
    
    var shooter:SKNode!
    
    var emitterNode:SKEmitterNode?
    var emitterNodeParticleBirthRate: CGFloat = 0
    var defaultEmitterNodeParticleBirthRate:CGFloat = 0
    
    init(shooter:SKNode, damage:Int, range:CGFloat, fireRate:Double, texture:SKTexture, position: CGPoint, zRotation: CGFloat, shooterPhysicsBody:SKPhysicsBody, color: SKColor) {
        super.init()
        
        self.zPosition = GameWorld.zPositions.shot.rawValue
        
        self.shooter = shooter
        self.damage = damage
        self.rangeSquared = range * range
        
        self.startingPosition = position
        
        if damage <= 0 {
            #if DEBUG
                //fatalError()
            #endif
        }
        
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.blendMode = .Add
        spriteNode.setScale(1.5)
        
        spriteNode.texture?.filteringMode = Display.filteringMode
        spriteNode.color = color
        spriteNode.colorBlendFactor = 4
        
        self.addChild(spriteNode)
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size)
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.spaceshipShot.rawValue
        self.physicsBody?.collisionBitMask = GameWorld.collisionBitMask.spaceshipShot
        self.physicsBody?.contactTestBitMask = GameWorld.contactTestBitMask.spaceshipShot
        
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        
        self.position = position
        self.zRotation = zRotation + CGFloat.random(min: -0.1, max: 0.1)
        
        let speed: CGFloat = 380
       
        self.physicsBody?.velocity = CGVector(dx: -sin(self.zRotation) * speed + shooterPhysicsBody.velocity.dx, dy: cos(self.zRotation) * speed + shooterPhysicsBody.velocity.dy)
        
        self.defaultEmitterNodeParticleBirthRate = speed/2
        
        
        self.runAction({ let a = SKAction(); a.duration = 3; return a }()) { [weak self] in
            self?.removeFromParent()
        }
        
        self.loadJetEffect(nil, color: color)
        self.emitterNodeParticleBirthRate = self.defaultEmitterNodeParticleBirthRate
        self.updateEmitters()
        
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
        let distanceSquared = (self.startingPosition - self.position).lengthSquared()
        if distanceSquared >= self.rangeSquared {
            self.removeFromParent()
            //print(sqrt(self.rangeSquared).description + " " + sqrt(distanceSquared).description)
        } else {
            self.updateEmitters()
        }
    }
    
    func loadJetEffect(targetNode: SKNode?, color: SKColor) {
        
        self.emitterNode = SKEmitterNode(fileNamed: "Jet.sks")
        if let emitterNode = self.emitterNode {
            emitterNode.particleColorSequence = nil
            emitterNode.particleColorBlendFactor = 1
            emitterNode.particleColor = color
            emitterNode.particleBirthRate = 0
            emitterNode.zPosition = self.zPosition - 1
            emitterNode.particleSize = CGSize(width: 15, height: 15)
            if let targetNode = targetNode {
                emitterNode.targetNode = targetNode
            } else {
                emitterNode.targetNode = self.parent
            }
        }
    }
    
    func updateEmitters() {
        
        if let emitterNode = self.emitterNode {
            emitterNode.particleScaleSpeed = -8
            emitterNode.particleBirthRate = self.emitterNodeParticleBirthRate
            emitterNode.particleSpeed = self.emitterNodeParticleBirthRate/2
            emitterNode.particleSpeedRange = self.emitterNodeParticleBirthRate/4
            emitterNode.position = self.position
            emitterNode.emissionAngle = self.zRotation - CGFloat(M_PI/2)
        }
    }
    
    override func removeFromParent() {
        Shot.shotSet.remove(self)
        
        if self.damage > 0 {
            for spaceship in Spaceship.spaceshipList {
                if self.intersectsNode(spaceship) {
                    spaceship.getShot(self, contact: nil)
                }
            }
            
            for mothership in Mothership.mothershipList {
                if self.intersectsNode(mothership) {
                    mothership.getShot(self, contact: nil)
                }
            }
        }
        
        self.emitterNodeParticleBirthRate = 0
        self.updateEmitters()
        self.emitterNode?.runAction(SKAction.removeFromParentAfterDelay(1))
        
        super.removeFromParent()
    }
}
