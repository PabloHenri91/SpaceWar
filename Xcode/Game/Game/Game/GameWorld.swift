//
//  GameWorld.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class GameWorld: SKNode, SKPhysicsContactDelegate {
    
    enum zPositions: CGFloat {
        case battleArea = -20
        case mothership = -10
        case shot = 0
        case spaceship = 10
        case sparks = 20
        case explosion = 30
        case spaceshipHealthBar = 40
        case damageEffect = 50
    }
    
    var physicsWorld:SKPhysicsWorld!
    var defaultGravity = CGVector(dx: 0, dy: 0)
    
    var bodyA: SKPhysicsBody!
    var bodyB: SKPhysicsBody!
    
    var planetNames = [
        "planet0",
        "planet1",
        "planet2"
    ]
    
    init(physicsWorld:SKPhysicsWorld) {
        super.init()
        var spriteNode = SKSpriteNode(imageNamed: "battleBackground")
        spriteNode.zPosition = GameWorld.zPositions.battleArea.rawValue
        self.addChild(spriteNode)
        
        let size = spriteNode.size
        
        spriteNode = SKSpriteNode(imageNamed: self.planetNames[Int.random(self.planetNames.count)])
        spriteNode.setScale(0.5)
        spriteNode.position = CGPoint(x: Int.random(min: -Int(size.width)/2, max: Int(size.width)/2), y: Int.random(min: -Int(size.height)/2, max: Int(size.height)/2))
        spriteNode.zPosition = GameWorld.zPositions.battleArea.rawValue + 1
        self.addChild(spriteNode)
        
        self.physicsWorld = physicsWorld
        physicsWorld.gravity = self.defaultGravity
        
        
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.waitForDuration(5),
            SKAction.runBlock { [weak self] in
                self?.addChild(HealthPack())
            }
            ])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScreenBox(size:CGSize) {
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin: CGPoint(x: -Display.currentSceneSize.width/2, y: -Display.currentSceneSize.height/2), size: size))
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.world.rawValue
        self.physicsBody?.dynamic = false
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        //Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            self.bodyA = contact.bodyA
            self.bodyB = contact.bodyB
        } else {
            self.bodyA = contact.bodyB
            self.bodyB = contact.bodyA
        }
        
        
        //Somente para DEBUG
        var bodyAcategoryBitMask = ""
        var bodyBcategoryBitMask = ""
        
        switch (self.bodyA.categoryBitMask) {
            
        case categoryBitMask.world.rawValue:
            bodyAcategoryBitMask = "world"
            break
        case categoryBitMask.spaceship.rawValue:
            bodyAcategoryBitMask = "spaceship"
            break
        case categoryBitMask.shot.rawValue:
            bodyAcategoryBitMask = "shot"
            break
        case categoryBitMask.spaceshipShot.rawValue:
            bodyAcategoryBitMask = "spaceshipShot"
            break
        case categoryBitMask.mothership.rawValue:
            bodyAcategoryBitMask = "mothership"
            break
        case categoryBitMask.healthPack.rawValue:
            bodyAcategoryBitMask = "healthPack"
            break
        default:
            bodyAcategoryBitMask = "unknown"
            break
        }
        
        switch (self.bodyB.categoryBitMask) {
            
        case categoryBitMask.world.rawValue:
            bodyBcategoryBitMask = "world"
            break
        case categoryBitMask.spaceship.rawValue:
            bodyBcategoryBitMask = "spaceship"
            break
        case categoryBitMask.shot.rawValue:
            bodyBcategoryBitMask = "shot"
            break
        case categoryBitMask.spaceshipShot.rawValue:
            bodyBcategoryBitMask = "spaceshipShot"
            break
        case categoryBitMask.mothership.rawValue:
            bodyBcategoryBitMask = "mothership"
            break
        case categoryBitMask.healthPack.rawValue:
            bodyBcategoryBitMask = "healthPack"
            break
        default:
            bodyBcategoryBitMask = "unknown"
            break
        }
        //
        
        //didBeginContact
        switch (self.bodyA.categoryBitMask + self.bodyB.categoryBitMask) {
            
        case categoryBitMask.spaceship.rawValue + categoryBitMask.spaceshipShot.rawValue:
            //spaceship criou um shot
            if let shot = self.bodyB.node as? Shot {
                if let spaceship = self.bodyA.node as? Spaceship {
                    spaceship.getShot(shot, contact: contact)
                }
            }
            break
            
        case categoryBitMask.spaceship.rawValue + categoryBitMask.shot.rawValue:
            if let shot = self.bodyB.node as? Shot {
                if let spaceship = self.bodyA.node as? Spaceship {
                    spaceship.getShot(shot, contact: contact)
                }
            }
            break
            
        case categoryBitMask.shot.rawValue + categoryBitMask.mothership.rawValue:
            if let shot = self.bodyA.node as? Shot {
                (self.bodyB.node as? Mothership)?.getShot(shot, contact: contact)
            }
            break
            
        case categoryBitMask.spaceship.rawValue + categoryBitMask.healthPack.rawValue:
            if let healthPack = self.bodyB.node as? HealthPack {
                (self.bodyA.node as? Spaceship)?.getHealthPack(healthPack, contact: contact)
            }
            break
            
        default:
            #if DEBUG
                print("didBeginContact: " + bodyAcategoryBitMask + " -> " + bodyBcategoryBitMask)
            #endif
            break
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
        //Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            self.bodyA = contact.bodyA
            self.bodyB = contact.bodyB
        } else {
            self.bodyA = contact.bodyB
            self.bodyB = contact.bodyA
        }
        
        
        #if DEBUG
            var bodyAcategoryBitMask = ""
            var bodyBcategoryBitMask = ""
            
            switch (self.bodyA.categoryBitMask) {
                
            case categoryBitMask.world.rawValue:
                bodyAcategoryBitMask = "world"
                break
            case categoryBitMask.spaceship.rawValue:
                bodyAcategoryBitMask = "spaceship"
                break
            case categoryBitMask.shot.rawValue:
                bodyAcategoryBitMask = "shot"
                break
            case categoryBitMask.spaceshipShot.rawValue:
                bodyAcategoryBitMask = "spaceshipShot"
                break
            case categoryBitMask.mothership.rawValue:
                bodyAcategoryBitMask = "mothership"
                break
            default:
                bodyAcategoryBitMask = "unknown"
                break
            }
            
            switch (self.bodyB.categoryBitMask) {
                
            case categoryBitMask.world.rawValue:
                bodyBcategoryBitMask = "world"
                break
            case categoryBitMask.spaceship.rawValue:
                bodyBcategoryBitMask = "spaceship"
                break
            case categoryBitMask.shot.rawValue:
                bodyBcategoryBitMask = "shot"
                break
            case categoryBitMask.spaceshipShot.rawValue:
                bodyBcategoryBitMask = "spaceshipShot"
                break
            case categoryBitMask.mothership.rawValue:
                bodyBcategoryBitMask = "mothership"
                break
            default:
                bodyBcategoryBitMask = "unknown"
                break
            }
        #endif
        
        //didEndContact
        switch (self.bodyA.categoryBitMask + self.bodyB.categoryBitMask) {
            
        case categoryBitMask.spaceship.rawValue + categoryBitMask.shot.rawValue:
            if let shot = self.bodyB.node as? Shot {
                if let spaceship = self.bodyA.node as? Spaceship {
                    spaceship.getShot(shot, contact: contact)
                }
            }
            break
            
        case categoryBitMask.spaceship.rawValue + categoryBitMask.spaceshipShot.rawValue:
            if let spaceship = self.bodyA.node as? Spaceship {
                spaceship.didEndContact(self.bodyB, contact: contact)
            }
            break
            
        case categoryBitMask.shot.rawValue + categoryBitMask.mothership.rawValue:
            if let shot = self.bodyA.node as? Shot {
                (self.bodyB.node as? Mothership)?.getShot(shot, contact: contact)
            }
            break
            
        case categoryBitMask.spaceship.rawValue + categoryBitMask.healthPack.rawValue:
            if let healthPack = self.bodyB.node as? HealthPack {
                (self.bodyA.node as? Spaceship)?.getHealthPack(healthPack, contact: contact)
            }
            break
            
        default:
            #if DEBUG
                print("didEndContact: " + bodyAcategoryBitMask + " -> " + bodyBcategoryBitMask)
            #endif
            break
        }
    }
    
    struct categoryBitMask : OptionSetType {
        typealias RawValue = UInt32
        private var value: UInt32 = 0
        init(_ value: UInt32) { self.value = value }
        init(rawValue value: UInt32) { self.value = value }
        init(nilLiteral: ()) { self.value = 0 }
        static var allZeros: categoryBitMask { return self.init(0) }
        static func fromMask(raw: UInt32) -> categoryBitMask { return self.init(raw) }
        var rawValue: UInt32 { return self.value }
        
        static var none: categoryBitMask { return self.init(0) }
        
        static var world: categoryBitMask { return categoryBitMask(1 << 0) }
        static var spaceship: categoryBitMask { return categoryBitMask(1 << 1) }
        static var healthPack: categoryBitMask { return categoryBitMask(1 << 2) }
        static var shot: categoryBitMask { return categoryBitMask(1 << 3) }
        static var spaceshipShot: categoryBitMask { return categoryBitMask(1 << 4) }
        static var mothership: categoryBitMask { return categoryBitMask(1 << 5) }
        
    }
    
    struct collisionBitMask {
        
        static var world: UInt32 = 0
        
        static var spaceship: UInt32 =
            categoryBitMask.world.rawValue |
                categoryBitMask.spaceship.rawValue |
                categoryBitMask.mothership.rawValue |
                categoryBitMask.healthPack.rawValue
        
        
        static var mothershipSpaceship:UInt32 =
            categoryBitMask.world.rawValue |
                categoryBitMask.spaceship.rawValue
        
        static var shot: UInt32 = 0
        
        static var spaceshipShot: UInt32 = 0
        
        static var mothership: UInt32 = 0
        
        static var healthPack: UInt32 =
            categoryBitMask.spaceship.rawValue |
                categoryBitMask.healthPack.rawValue
    }
    
    struct contactTestBitMask {
        
        static var world:UInt32 = 0
        
        static var spaceship:UInt32 =
            categoryBitMask.shot.rawValue |
                categoryBitMask.spaceshipShot.rawValue |
                categoryBitMask.healthPack.rawValue
        
        static var mothershipSpaceship =
            categoryBitMask.shot.rawValue |
                categoryBitMask.spaceshipShot.rawValue |
                categoryBitMask.mothership.rawValue
        
        static var shot:UInt32 =
            categoryBitMask.spaceship.rawValue |
                categoryBitMask.mothership.rawValue
        
        static var spaceshipShot:UInt32 =
            categoryBitMask.spaceship.rawValue
        
        static var mothership:UInt32 = categoryBitMask.shot.rawValue
        
        static var healthPack: UInt32 =
            categoryBitMask.spaceship.rawValue
        
    }
}