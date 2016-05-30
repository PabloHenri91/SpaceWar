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
        default:
            bodyAcategoryBitMask = "unknown"
            break
        }
        
        switch (self.bodyB.categoryBitMask) {
        default:
            bodyBcategoryBitMask = "unknown"
            break
        }
        //
        
        switch (self.bodyA.categoryBitMask + self.bodyB.categoryBitMask) {
            
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
        default:
            bodyAcategoryBitMask = "unknown"
            break
        }
        
        switch (self.bodyB.categoryBitMask) {
        default:
            bodyBcategoryBitMask = "unknown"
            break
        }
        //
        
        //lower category is always stored in bodyA
        switch (self.bodyA.categoryBitMask + self.bodyB.categoryBitMask) {
            
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
        
        static var spaceship: categoryBitMask { return categoryBitMask(1 << 0) }
        static var shot: categoryBitMask { return categoryBitMask(1 << 1) }
        static var mothership: categoryBitMask { return categoryBitMask(1 << 2) }
        
    }
    
    struct collisionBitMask {
        
        static var spaceship:UInt32 =
                categoryBitMask.spaceship.rawValue |
                categoryBitMask.shot.rawValue
        
        static var shot:UInt32 =
            categoryBitMask.mothership.rawValue |
                categoryBitMask.spaceship.rawValue
        
        static var mothership:UInt32 = 0
    }
    
    struct contactTestBitMask {
        
        static var spaceship:UInt32 = categoryBitMask.shot.rawValue
        
        static var shot:UInt32 =
            categoryBitMask.spaceship.rawValue |
                categoryBitMask.mothership.rawValue
        
        static var mothership:UInt32 = categoryBitMask.shot.rawValue
    }
    
    
    
    
    
    
    
}