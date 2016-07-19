//
//  Mothership.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/24/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Mothership: Control {
    
    static var mothershipList = Set<Mothership>()

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
                self.spaceships.append(Spaceship(spaceshipData: spaceshipData, loadPhysics: true))
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
        
        Mothership.mothershipList.insert(self)
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
    
    func loadSpaceship(spaceship:Spaceship, gameWorld:GameWorld, isAlly:Bool = true, i:Int) {
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
        spaceship.destination = spaceship.position
        
        spaceship.zRotation = self.zRotation
        spaceship.startingZPosition = spaceship.zRotation
        
        if isAlly {
            spaceship.loadAllyDetails()
            spaceship.loadHealthBar(gameWorld, borderColor: SKColor.blueColor())
            spaceship.healthBar.update(position: spaceship.position)
            
        } else {
            spaceship.loadEnemyDetails()
            spaceship.loadHealthBar(gameWorld, borderColor: SKColor.redColor())
            spaceship.healthBar.barPosition = .down
            spaceship.healthBar.update(position: spaceship.position)
        }
        spaceship.loadWeaponRangeSprite(gameWorld)
        spaceship.loadWeaponDetail()
        
        gameWorld.addChild(spaceship)
    }

    func loadSpaceships(gameWorld:GameWorld, isAlly:Bool = true) {
        
        var i = 0
        for spaceship in self.spaceships {
            self.loadSpaceship(spaceship, gameWorld: gameWorld, isAlly: isAlly, i: i)
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
    
    func getShot(shot:Shot?, contact: SKPhysicsContact?) {
        if let shot = shot {
            
            if self.health > 0 && self.health - shot.damage <= 0 {
                self.die()
                
                for spaceship in self.spaceships {
                    if spaceship.isInsideAMothership {
                        spaceship.die()
                    }
                }
            }
            
            self.health = self.health - shot.damage
            if self.health < 0 { self.health = 0 }
            if shot.damage > 0 {
                self.damageEffect(shot.damage, contactPoint: shot.position, contact: contact)
            }
            shot.damage = 0
            shot.removeFromParent()
            
            self.healthBar?.update(self.health, maxHealth: self.maxHealth)
        }
    }
    
    func die() {
        let particles = SKEmitterNode(fileNamed: "explosion.sks")!
        
        particles.position.x = self.position.x
        particles.position.y = self.position.y
        particles.zPosition = self.zPosition
        
        particles.numParticlesToEmit = 1000
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
    
    func update(enemyMothership enemyMothership:Mothership? = nil, enemySpaceships:[Spaceship] = [Spaceship]()) {
        for spaceship in self.spaceships {
            spaceship.update(enemyMothership: enemyMothership, enemySpaceships: enemySpaceships, allySpaceships: self.spaceships)
        }
    }
    
    func damageEffect(points:Int, contactPoint: CGPoint, contact: SKPhysicsContact?) {
        
        let duration = 0.5
        var distance:CGFloat = 32
        var vector = CGVector.zero
        
        if let contact = contact {
            if let _ = contact.bodyA.node as? Shot {
                distance *= -1
            }
            vector = CGVector(dx: contact.contactNormal.dx * distance, dy: contact.contactNormal.dy * distance)
        }
        
        let label = SKLabelNode(text: points.description)
        label.position = contactPoint
        label.fontColor = SKColor.whiteColor()
        self.parent?.addChild(label)
        label.runAction(SKAction.moveBy(vector, duration: duration))
        label.runAction({ let a = SKAction(); a.duration = duration; return a }()) { [weak label] in
            label?.removeFromParent()
        }
    }
    
    override func removeFromParent() {
        Mothership.mothershipList.remove(self)
        super.removeFromParent()
    }
}
