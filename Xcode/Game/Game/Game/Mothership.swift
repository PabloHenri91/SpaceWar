//
//  Mothership.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/24/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Mothership: Control {

    var level:Int!
    
    //Vida
    var health:Int!
    var maxHealth:Int!
    
    var mothershipData:MothershipData?
    
    var spaceships = [Spaceship]()
    
    var spriteNode:SKSpriteNode!
    
    var healthBar:HealthBar!
    
    override var description: String {
        return "\nMothership\n" +
            "level: " + level.description + "\n" +
            "health: " + health.description  + "\n" +
            "maxHealth: " + maxHealth.description  + "\n"
    }
    
    override init() {
        fatalError("NÃO IMPLEMENTADO")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(level:Int) {
        super.init()
        self.load(level: level)
    }
    
    init(mothershipData:MothershipData) {
        super.init()
        self.mothershipData = mothershipData
        self.load(level: mothershipData.level.integerValue)
        
        for item in mothershipData.spaceships {
            if let spaceshipData  = item as? SpaceshipData {
                self.spaceships.append(Spaceship(spaceshipData: spaceshipData))
            }
        }
    }
    
    private func load(level level:Int) {
        self.level = level
        
        self.health = GameMath.mothershipMaxHealth(level: self.level)
        self.maxHealth = health
        
        //Gráfico
        self.spriteNode = SKSpriteNode(imageNamed: "mothership")
        self.spriteNode.texture?.filteringMode = Display.filteringMode
        self.addChild(self.spriteNode)
        
        self.loadPhysics(rectangleOfSize: self.spriteNode.size)
    }
    
    func loadPhysics(rectangleOfSize size:CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.dynamic = false
        
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.mothership.rawValue
        self.physicsBody?.collisionBitMask = GameWorld.collisionBitMask.mothership
        self.physicsBody?.contactTestBitMask = GameWorld.contactTestBitMask.mothership
    }
    
    func loadHealthBar(gameWorld:GameWorld, borderColor:SKColor) {
        self.healthBar = HealthBar(size: self.calculateAccumulatedFrame().size, borderColor: borderColor)
        gameWorld.addChild(self.healthBar)
    }

    func loadSpaceships(gameWorld:GameWorld, isAlly:Bool = true) {
        
        var i = 0
        for spaceship in self.spaceships {
            
            spaceship.zRotation = self.zRotation
            
            gameWorld.addChild(spaceship)
            
            if isAlly {
                spaceship.loadAllyDetails()
                spaceship.loadHealthBar(gameWorld, borderColor: SKColor.blueColor())
                
            } else {
                spaceship.loadEnemyDetails()
                spaceship.loadHealthBar(gameWorld, borderColor: SKColor.redColor())
            }
            spaceship.loadWeaponRangeSprite(gameWorld)
            spaceship.loadWeaponDetail()
            
            switch i {
            case 0:
                spaceship.position = self.convertPoint(CGPoint(x: -103, y: 78), toNode: gameWorld)
                break
            case 1:
                spaceship.position = self.convertPoint(CGPoint(x: -34, y: 78), toNode: gameWorld)
                break
            case 2:
                spaceship.position = self.convertPoint(CGPoint(x: 34, y: 78), toNode: gameWorld)
                break
            case 3:
                spaceship.position = self.convertPoint(CGPoint(x: 103, y: 78), toNode: gameWorld)
                break
            default:
                break
            }
            spaceship.startingPosition = spaceship.position
            i += 1
        }
    }
    
    func canBeTarget(spaceship:Spaceship) -> Bool {
        
        if let spaceshipWeapon = spaceship.weapon {
            let range = spaceshipWeapon.rangeInPoints + spaceship.weaponRangeBonus + self.spriteNode.size.height/2
            if CGPoint.distance(self.position, spaceship.position) > range {
                return false
            }
        } else {
            return false
        }
        
        if self.health <= 0 {
            return false
        }
        
        return true
    }
    
    func getShot(shot:Shot?) {
        if let someShot = shot {
            
            if self.health > 0 && self.health - someShot.damage <= 0 {
                self.die()
            }
            
            self.health = self.health - someShot.damage
            someShot.damage = 0
            someShot.removeFromParent()
            
            self.healthBar.update(self.health, maxHealth: self.maxHealth)
        }
    }
    
    func die() {
        let particles = SKEmitterNode(fileNamed: "explosion.sks")!
        
        particles.position.x = self.position.x
        particles.position.y = self.position.y
        particles.zPosition = self.zPosition
        
        particles.numParticlesToEmit = 333
        particles.particleSpeedRange = 1000
        
        particles.particlePositionRange = CGVector(dx: self.spriteNode.size.width, dy: self.spriteNode.size.height)
        
        if let parent = self.parent {
            parent.addChild(particles)
            
            let action = SKAction()
            action.duration = 1
            particles.runAction(action, completion: { [weak particles] in
                particles?.removeFromParent()
                })
        }
        
        self.hidden = true
        self.physicsBody = nil
        self.healthBar.hidden = true
    }
    
    func update(enemyMothership enemyMothership:Mothership, enemySpaceships:[Spaceship]) {
        for spaceship in self.spaceships {
            spaceship.update(enemyMothership: enemyMothership, enemySpaceships: enemySpaceships, allySpaceships: self.spaceships)
        }
    }
}
