//
//  GameWorld.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class GameWorld: SKNode, SKPhysicsContactDelegate {
    
    var physicsWorld:SKPhysicsWorld!
    var defaultGravity = CGVector(dx: 0, dy: 0)
    
    var bodyA: SKPhysicsBody!
    var bodyB: SKPhysicsBody!
    
    init(physicsWorld:SKPhysicsWorld) {
        super.init()
        
        let spriteNode = SKSpriteNode(imageNamed: "background")
        spriteNode.texture?.filteringMode = .Nearest
        self.addChild(spriteNode)
        
        self.physicsWorld = physicsWorld
        physicsWorld.gravity = self.defaultGravity
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScreenBox(size:CGSize) {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size))
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
        case categoryBitMask.mySpaceship.rawValue:
            bodyAcategoryBitMask = "mySpaceship"
            break
        case categoryBitMask.shot.rawValue:
            bodyAcategoryBitMask = "shot"
            break
        case categoryBitMask.myShot.rawValue:
            bodyAcategoryBitMask = "myShot"
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
        case categoryBitMask.mySpaceship.rawValue:
            bodyBcategoryBitMask = "mySpaceship"
            break
        case categoryBitMask.shot.rawValue:
            bodyBcategoryBitMask = "shot"
            break
        case categoryBitMask.myShot.rawValue:
            bodyBcategoryBitMask = "myShot"
            break
        case categoryBitMask.mothership.rawValue:
            bodyBcategoryBitMask = "mothership"
            break
        default:
            bodyBcategoryBitMask = "unknown"
            break
        }
        //
        
        //didBeginContact
        switch (self.bodyA.categoryBitMask + self.bodyB.categoryBitMask) {
            
        case categoryBitMask.spaceship.rawValue + categoryBitMask.shot.rawValue:
            if let spaceship = self.bodyA.node as? Spaceship {
                spaceship.didBeginContact(self.bodyB, contact: contact)
            }
            self.bodyB.node?.removeFromParent()//TODO: dano em spaceship
            break
            
        case categoryBitMask.spaceship.rawValue + categoryBitMask.myShot.rawValue:
            //TODO: spaceship atirou ???
            break
            
        case categoryBitMask.mySpaceship.rawValue + categoryBitMask.mothership.rawValue:
            break
            
        case categoryBitMask.shot.rawValue + categoryBitMask.mothership.rawValue:
            self.bodyA.node?.removeFromParent()//TODO: dano em mothership
            break
            
        default:
            print("didBeginContact: " + bodyAcategoryBitMask + " -> " + bodyBcategoryBitMask)
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
        case categoryBitMask.mySpaceship.rawValue:
            bodyAcategoryBitMask = "mySpaceship"
            break
        case categoryBitMask.shot.rawValue:
            bodyAcategoryBitMask = "shot"
            break
        case categoryBitMask.myShot.rawValue:
            bodyAcategoryBitMask = "myShot"
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
        case categoryBitMask.mySpaceship.rawValue:
            bodyBcategoryBitMask = "mySpaceship"
            break
        case categoryBitMask.shot.rawValue:
            bodyBcategoryBitMask = "shot"
            break
        case categoryBitMask.myShot.rawValue:
            bodyBcategoryBitMask = "myShot"
            break
        case categoryBitMask.mothership.rawValue:
            bodyBcategoryBitMask = "mothership"
            break
        default:
            bodyBcategoryBitMask = "unknown"
            break
        }
        //
        
        //lower category is always stored in bodyA
        switch (self.bodyA.categoryBitMask + self.bodyB.categoryBitMask) {
            
        case categoryBitMask.spaceship.rawValue + categoryBitMask.myShot.rawValue:
            if let shot = self.bodyB.node as? Shot {
                shot.resetBitMasks()
            }
            break
            
        case categoryBitMask.mySpaceship.rawValue + categoryBitMask.mothership.rawValue:
            if let spaceship = self.bodyA.node as? Spaceship {
                spaceship.didEndContact(self.bodyB, contact: contact)
            }
            break
            
        default:
            print("didEndContact: " + bodyAcategoryBitMask + " -> " + bodyBcategoryBitMask)
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
        static var mySpaceship: categoryBitMask { return categoryBitMask(1 << 2) }
        static var shot: categoryBitMask { return categoryBitMask(1 << 3) }
        static var myShot: categoryBitMask { return categoryBitMask(1 << 4) }
        static var mothership: categoryBitMask { return categoryBitMask(1 << 5) }
        
    }
    
    struct collisionBitMask {
        
        static var spaceship:UInt32 =
            categoryBitMask.world.rawValue |
                categoryBitMask.spaceship.rawValue |
                categoryBitMask.mySpaceship.rawValue |
                categoryBitMask.shot.rawValue |
                categoryBitMask.mothership.rawValue
        
        
        static var mySpaceship:UInt32 =
            categoryBitMask.world.rawValue |
                categoryBitMask.spaceship.rawValue |
                categoryBitMask.mySpaceship.rawValue |
                categoryBitMask.shot.rawValue
        
        static var shot:UInt32 =
            categoryBitMask.mothership.rawValue |
                categoryBitMask.spaceship.rawValue |
                categoryBitMask.mySpaceship.rawValue
        
        
        static var myShot:UInt32 = 0
        
        static var mothership:UInt32 = 0
    }
    
    struct contactTestBitMask {
        
        static var spaceship:UInt32 = categoryBitMask.shot.rawValue
        
        static var mySpaceship:UInt32 = categoryBitMask.mothership.rawValue
        
        static var shot:UInt32 =
            categoryBitMask.spaceship.rawValue |
                categoryBitMask.mothership.rawValue
        
        static var myShot:UInt32 =
            categoryBitMask.spaceship.rawValue |
                categoryBitMask.mothership.rawValue
        
        static var mothership:UInt32 = categoryBitMask.shot.rawValue
    }
    
}