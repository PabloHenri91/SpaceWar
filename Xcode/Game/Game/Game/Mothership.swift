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
    
    private var healthBar:HealthBar!
    var labelHealth:Label!
    
    var explosionSoundEffect:SoundEffect!
    
    var cropNode:SKCropNode!
    
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
    
    init(level:Int, blueTeam:Bool = false) {
        super.init()
        self.load(level: level, blueTeam: blueTeam)
    }
    
    init(mothershipData:MothershipData) {
        super.init()
        self.mothershipData = mothershipData
        self.load(level: mothershipData.level.integerValue, blueTeam: true)
        
        for item in mothershipData.spaceships {
            if let spaceshipData  = item as? SpaceshipData {
                self.spaceships.append(Spaceship(spaceshipData: spaceshipData, loadPhysics: true))
            }
        }
    }
    
    private func load(level level:Int, blueTeam: Bool) {
        self.zPosition = GameWorld.zPositions.mothership.rawValue
        
        self.level = level
        
        self.health = 1
        self.maxHealth = health
        
        //Gráfico
        if blueTeam {
            self.spriteNode = SKSpriteNode(imageNamed: "mothershipBlue")
        } else {
            self.spriteNode = SKSpriteNode(imageNamed: "mothershipRed")
        }
        self.spriteNode.texture?.filteringMode = Display.filteringMode
        
        
        self.addChild(self.spriteNode)
        
        let mothershipHealthBarMask = SKSpriteNode(imageNamed: "mothershipHealthBarMask")
        mothershipHealthBarMask.texture?.filteringMode = Display.filteringMode
        if blueTeam {
            mothershipHealthBarMask.color = SKColor(red: 0/255, green: 126/255, blue: 255/255, alpha: 1)
        } else {
            mothershipHealthBarMask.color = SKColor(red: 196/255, green: 67/255, blue: 43/255, alpha: 1)
        }
        mothershipHealthBarMask.colorBlendFactor = 1
        
        self.cropNode = SKCropNode()
        self.cropNode.maskNode = mothershipHealthBarMask
        self.addChild(self.cropNode)
        
        
        let mothershipWhiteShape = SKSpriteNode(imageNamed: "mothershipWhiteShape")
        mothershipWhiteShape.position = CGPoint(x: 0, y: -6)
        mothershipWhiteShape.texture?.filteringMode = Display.filteringMode
        self.addChild(mothershipWhiteShape)
        
        self.loadPhysics(rectangleOfSize: self.spriteNode.size)
        
        Mothership.mothershipList.insert(self)
        
        self.loadSoundEffects()
    }
    
    func loadSoundEffects() {
        self.explosionSoundEffect = SoundEffect(soundType: SoundEffect.effectTypes.explosion, node: self)
    }
    
    func loadPhysics(rectangleOfSize size:CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.dynamic = false
        
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.mothership.rawValue
        self.physicsBody?.collisionBitMask = GameWorld.collisionBitMask.mothership
        self.physicsBody?.contactTestBitMask = GameWorld.contactTestBitMask.mothership
    }
    
    func loadHealthBar(blueTeam blueTeam:Bool = true) {
        
        var fillColor = SKColor.greenColor()
        
        if blueTeam {
            fillColor = SKColor(red: 0/255, green: 126/255, blue: 255/255, alpha: 1)
        } else {
            fillColor = SKColor(red: 196/255, green: 67/255, blue: 43/255, alpha: 1)
        }
        
        self.healthBar = HealthBar(size: self.calculateAccumulatedFrame().size, fillColor: fillColor)
        if !blueTeam {
            self.healthBar.zRotation = self.zRotation
        }
        self.cropNode.addChild(self.healthBar)
        
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
        let fontShadowOffset = CGPoint(x: 0, y: -1)
        let fontName = GameFonts.fontName.museo1000
        
        self.labelHealth = Label(color: SKColor.whiteColor(), text: "100/100", fontSize: 11, x: 0, y: -39, fontName: fontName, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset)
        self.labelHealth.zRotation = self.zRotation
        
        self.addChild(self.labelHealth)
        
        self.updateHealthBarValue()
        
    }
    
    func loadSpaceship(spaceship:Spaceship, gameWorld:GameWorld, isAlly:Bool = true, i:Int) {
        
        let mothershipSpaceshipSlot = SKSpriteNode(imageNamed: "mothershipSpaceshipSlot")
        mothershipSpaceshipSlot.texture?.filteringMode = Display.filteringMode
        self.addChild(mothershipSpaceshipSlot)
        
        switch i {
        case 0:
            spaceship.position = self.convertPoint(CGPoint(x: -103, y: -5), toNode: gameWorld)
            break
        case 1:
            spaceship.position = self.convertPoint(CGPoint(x: -34, y: -5), toNode: gameWorld)
            break
        case 2:
            spaceship.position = self.convertPoint(CGPoint(x: 34, y: -5), toNode: gameWorld)
            break
        case 3:
            spaceship.position = self.convertPoint(CGPoint(x: 103, y: -5), toNode: gameWorld)
            break
        default:
            break
        }
        mothershipSpaceshipSlot.position = gameWorld.convertPoint(spaceship.position, toNode: self)
        
        if let weapon = spaceship.weapon {
            mothershipSpaceshipSlot.color = weapon.type.color
            mothershipSpaceshipSlot.colorBlendFactor = 1
        }
        
        let spaceshipShadow = SKSpriteNode(imageNamed: spaceship.type.skin + "Mask")
        spaceshipShadow.texture?.filteringMode = Display.filteringMode
        spaceshipShadow.setScale(spaceship.type.scale)
        spaceshipShadow.color = SKColor(red: 0, green: 0, blue: 0, alpha: 12/100)
        spaceshipShadow.colorBlendFactor = 1
        spaceshipShadow.position = gameWorld.convertPoint(CGPoint(x: spaceship.position.x, y: spaceship.position.y - (5 * cos(self.zRotation))), toNode: self)
        self.addChild(spaceshipShadow)
        
        spaceship.startingPosition = spaceship.position
        spaceship.destination = spaceship.position
        
        spaceship.zRotation = self.zRotation
        spaceship.startingZPosition = spaceship.zRotation
        
        gameWorld.addChild(spaceship)
        
        if isAlly {
            spaceship.loadHealthBar(gameWorld, blueTeam: true)
            
        } else {
            spaceship.loadHealthBar(gameWorld, blueTeam: false)
        }
        spaceship.loadWeaponRangeSprite(gameWorld)
        spaceship.loadWeaponDetail()
        
        
    }

    func loadSpaceships(gameWorld:GameWorld, isAlly:Bool = true) {
        
        var i = 0
        for spaceship in self.spaceships {
            self.loadSpaceship(spaceship, gameWorld: gameWorld, isAlly: isAlly, i: i)
            i += 1
        }
    }
    
    func updateHealthBarValue() {
        self.healthBar.update(self.health, maxHealth: self.maxHealth)
        self.labelHealth.setText(self.health.description + "/" + self.maxHealth.description)
    }
    
    func canBeTarget(spaceship:Spaceship) -> Bool {
        
        if let spaceshipWeapon = spaceship.weapon {
            let range = spaceshipWeapon.rangeInPoints + spaceship.weaponRangeBonus + self.spriteNode.size.height/2
            if CGPoint.distance(CGPoint(x: spaceship.position.x, y:self.position.y), spaceship.position) > range {
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
            
            self.updateHealthBarValue()
        }
    }
    
    func endBattle() {
        for spaceship in self.spaceships {
            spaceship.canRespawn = false
            spaceship.needToMove = false
            spaceship.targetNode = nil
        }
    }
    
    func die() {
        
        self.endBattle()
        
        self.explosionSoundEffect.play()
        let particles = SKEmitterNode(fileNamed: "explosion.sks")!
        
        particles.position.x = self.position.x
        particles.position.y = self.position.y
        particles.zPosition = GameWorld.zPositions.explosion.rawValue
        
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
        
        let particles = SKEmitterNode(fileNamed: "spark.sks")!
        particles.position = contactPoint
        particles.zPosition = GameWorld.zPositions.sparks.rawValue
        particles.emissionAngle = CGFloat(-atan2(vector.dx, vector.dy)) + CGFloat(M_PI/2)
        self.parent?.addChild(particles)
        
        label.runAction({ let a = SKAction(); a.duration = duration; return a }()) { [weak label, weak particles] in
            label?.removeFromParent()
            particles?.removeFromParent()
        }
    }
    
    override func removeFromParent() {
        Mothership.mothershipList.remove(self)
        super.removeFromParent()
    }
}
