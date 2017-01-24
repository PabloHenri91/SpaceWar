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
    
    private var healthBar:HealthBar!
    
    var mothershipData:MothershipData?
    
    var spaceships = [Spaceship]()
    
    var labelHealth:Label!
    
    var explosionSoundEffect:SoundEffect!

    var isAlly = true
    
    var onlineDamage = 0
    var displayName = ""
    
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
    
    init(socketAnyEvent: SocketAnyEvent) {
        super.init()
        
        self.isAlly = false
        
        self.load(level: 1)
        
        if let items = socketAnyEvent.items?.firstObject as? [AnyObject] {
            
            var i = 0
            for item in items {
                
                switch i {
                    
                case 1:
                    self.level = item as! Int
                    break
                    
                case 2, 3, 4, 5:
                    let spaceshipData = item as! [Int]
                    let spaceship = Spaceship(type: spaceshipData[1], level: spaceshipData[0], loadPhysics: true)
                    spaceship.isAlly = self.isAlly
                    self.spaceships.append(spaceship)
                    break
                    
                default:
                    break
                }
                
                i = i + 1
            }
        }
    }
    
    init(level:Int, isAlly: Bool) {
        self.isAlly = isAlly
        super.init()
        self.load(level: level)
    }
    
    init(mothershipData:MothershipData) {
        super.init()
        self.isAlly = true
        self.mothershipData = mothershipData
        self.load(level: mothershipData.level.integerValue)
        
        for item in mothershipData.spaceships {
            if let spaceshipData  = item as? SpaceshipData {
                self.spaceships.append(Spaceship(spaceshipData: spaceshipData, loadPhysics: true))
            }
        }
    }
    
    private func load(level level:Int) {
        self.zPosition = GameWorld.zPositions.mothership.rawValue
        
        self.level = level
        
        self.health = 1
        self.maxHealth = health
        
        
        var spriteNode: SKSpriteNode!
        
        //Gráfico
        if self.isAlly {
            spriteNode = SKSpriteNode(imageNamed: "mothershipBlue")
        } else {
            spriteNode = SKSpriteNode(imageNamed: "mothershipRed")
        }
        spriteNode.texture?.filteringMode = Display.filteringMode
        
        self.size = spriteNode.size
        
        self.addChild(spriteNode)
        
        self.loadPhysics(rectangleOfSize: spriteNode.size)
        
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
    
    func loadHealthBar(gameWorld: GameWorld) {
        
        var fillColor = SKColor.clearColor()
        var backColor = SKColor.clearColor()
        
        if self.isAlly {
            fillColor = SKColor(red: 0/255, green: 126/255, blue: 255/255, alpha: 1)
            backColor = SKColor(red: 0/255, green: 84/255, blue: 143/255, alpha: 1)
        } else {
            fillColor = SKColor(red: 196/255, green: 67/255, blue: 43/255, alpha: 1)
            backColor = SKColor(red: 105/255, green: 31/255, blue: 17/255, alpha: 1)
        }
        
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
        let fontShadowOffset = CGPoint(x: 0, y: -1)
        let fontName = GameFonts.fontName.museo1000
        
        self.labelHealth = Label(color: SKColor.whiteColor(), text: "100/100", fontSize: 11, x: 0, y: 50, fontName: fontName, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset)
        self.labelHealth.position = self.convertPoint(self.labelHealth.position, toNode: gameWorld)
        
        let background = SKSpriteNode(imageNamed: "mothershipHealthBackground")
        background.zRotation = self.zRotation
        
        let cropNode = SKCropNode()
        cropNode.position = self.convertPoint(CGPoint(x: 0, y: -70), toNode: gameWorld)
        cropNode.maskNode = background
        
        
        let border = SKSpriteNode(imageNamed: "mothershipHealthBorder")
        border.color = backColor
        border.colorBlendFactor = 1
        border.zRotation = self.zRotation
        
        self.healthBar = HealthBar(background: background, size: background.size, backColor: backColor, fillColor: fillColor)
        
        gameWorld.addChild(cropNode)
        cropNode.addChild(self.healthBar)
        self.healthBar.addChild(border)
        
        
        gameWorld.addChild(self.labelHealth)
        
        self.updateHealthBarValue()
    }
    
    func loadSpaceship(spaceship:Spaceship, gameWorld:GameWorld, i:Int) {
        
        spaceship.isAlly = self.isAlly
        
        switch i {
        case 0:
            spaceship.position = self.convertPoint(CGPoint(x: -130, y: -5), toNode: gameWorld)
            break
        case 1:
            spaceship.position = self.convertPoint(CGPoint(x: -90, y: 50), toNode: gameWorld)
            break
        case 2:
            spaceship.position = self.convertPoint(CGPoint(x: 90, y: 50), toNode: gameWorld)
            break
        case 3:
            spaceship.position = self.convertPoint(CGPoint(x: 130, y: -5), toNode: gameWorld)
            break
        default:
            break
        }
        
        spaceship.destination = spaceship.position
        
        let spaceshipShadow = SKSpriteNode(imageNamed: spaceship.type.bodyType.skin + "Mask")
        spaceshipShadow.texture?.filteringMode = Display.filteringMode
        spaceshipShadow.setScale(spaceship.type.bodyType.scale)
        spaceshipShadow.color = SKColor(red: 0, green: 0, blue: 0, alpha: 12/100)
        spaceshipShadow.colorBlendFactor = 1
        spaceshipShadow.position = gameWorld.convertPoint(CGPoint(x: spaceship.position.x, y: spaceship.position.y - (5 * cos(self.zRotation))), toNode: self)
        
        spaceshipShadow.position = self.convertPoint(spaceshipShadow.position, toNode: gameWorld)
        gameWorld.addChild(spaceshipShadow)
        
        spaceship.startingPosition = spaceship.position
        
        spaceship.zRotation = self.zRotation
        spaceship.startingZPosition = spaceship.zRotation
        
        gameWorld.addChild(spaceship)
        
        spaceship.loadHealthBar(gameWorld)
        spaceship.loadWeaponRangeSprite(gameWorld)
        spaceship.loadWeaponDetail()
        spaceship.loadRespawnTimeBar(gameWorld)
    }

    func loadSpaceships(gameWorld:GameWorld) {
        
        var i = 0
        for spaceship in self.spaceships {
            self.loadSpaceship(spaceship, gameWorld: gameWorld, i: i)
            i += 1
        }
    }
    
    func updateHealthBarValue() {
        self.healthBar.update(self.health, maxHealth: self.maxHealth)
        self.labelHealth.setText(self.health.description + "/" + self.maxHealth.description)
    }
    
    
    func canBeTargetAndHitBy(spaceship:Spaceship) -> Bool {
        
        if !self.canBeTarget() || !spaceship.canBeTarget() {
            return false
        }
        
        if let spaceshipWeapon = spaceship.weapon {
            let range = spaceshipWeapon.rangeInPoints + spaceship.weaponRangeBonus + self.size.height/2
            if (self.position - spaceship.position).length() > range {
                return false
            }
        } else {
            return false
        }
        
        return true
    }
    
    func canBeTarget() -> Bool {
        
        if self.health <= 0 {
            return false
        }
        
        return true
    }
    
    func getShot(shot:Shot?, contact: SKPhysicsContact?) {
        
        if let shot = shot {
            
            if let spaceship = shot.shooter as? Spaceship {
                if spaceship.isAlly == self.isAlly {
                    return
                }
            }
            
            if BattleScene.state == .battleOnline {
                
                if self.isAlly {
                    // o outro jogador me avisa caso eu receba dano
                } else {
                    
                    self.onlineDamage = self.onlineDamage + shot.damage
                    
                    if self.health > 0 && self.health - shot.damage <= 0 {
                        self.die()
                    } else {
                        self.health = self.health - shot.damage
                    }
                }
                
            } else {
                
                if self.health > 0 && self.health - shot.damage <= 0 {
                    self.die()
                } else {
                    self.health = self.health - shot.damage
                }
            }
            
            self.updateHealthBarValue()
            
            if self.health < 0 { self.health = 0 }
            if shot.damage > 0 {
                self.damageEffect(shot.damage, contactPoint: shot.position, contact: contact)
            }
            shot.damage = 0
            shot.removeFromParent()
        }
    }
    
    func endBattle() {
        for spaceship in self.spaceships {
            spaceship.destination = spaceship.position
            spaceship.canRespawn = false
            spaceship.needToMove = false
            spaceship.maxVelocitySquared = GameMath.spaceshipMaxVelocitySquared(speed: spaceship.speedAtribute)
            spaceship.targetNode = nil
        }
    }
    
    func die() {
        
        Control.gameScene.shake(15)
        
        for spaceship in self.spaceships {
            spaceship.respawnTimeBar.parent?.hidden = true
        }
        
        self.endBattle()
        
        var action = SKAction.runBlock {
            self.explosionSoundEffect.play()
            let particles = SKEmitterNode(fileNamed: "explosion.sks")!
            
            particles.position.x = self.position.x + CGFloat.random(min: -self.size.width/2, max: self.size.width/2)
            particles.position.y = self.position.y + CGFloat.random(min: -self.size.height/2, max: self.size.height/2)
            particles.zPosition = GameWorld.zPositions.explosion.rawValue
            
            particles.numParticlesToEmit = 500
            particles.particleSpeedRange = 1000
            
            particles.particlePositionRange = CGVector(dx: self.size.width/2, dy: self.size.height/2)
            
            if let parent = self.parent {
                
                Control.gameScene.shake(50)
                
                parent.addChild(particles)
                
                let action = SKAction()
                action.duration = 1
                particles.runAction(action, completion: { [weak particles] in
                    particles?.removeFromParent()
                    })
            }
        }
        
        var actions = [SKAction]()
        
        for _ in 0...6 {
            actions.append(SKAction.afterDelay(Double(CGFloat.random(min: 0.1, max: 0.5)), performAction: action))
        }
        
        action = SKAction.runBlock {
            self.explosionSoundEffect.play()
            let particles = SKEmitterNode(fileNamed: "explosion.sks")!
            
            particles.position.x = self.position.x + CGFloat.random(min: -self.size.width/2, max: self.size.width/2)
            particles.position.y = self.position.y + CGFloat.random(min: -self.size.height/2, max: self.size.height/2)
            particles.zPosition = GameWorld.zPositions.explosion.rawValue
            
            particles.numParticlesToEmit = 1000
            particles.particleSpeedRange = 2000
            
            particles.particlePositionRange = CGVector(dx: self.size.width, dy: self.size.height)
            
            if let parent = self.parent {
                
                Control.gameScene.shake(100)
                
                parent.addChild(particles)
                
                let action = SKAction()
                action.duration = 1
                particles.runAction(action, completion: { [weak particles] in
                    particles?.removeFromParent()
                    })
            }
        }
        
        actions.append(action)
        
        actions.append(SKAction.runBlock { self.hidden = true })
        
        self.runAction(SKAction.sequence(actions))
        
        self.physicsBody = nil
        self.health = 0
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
        
        let label = Label(color: SKColor.redColor(), text: "-" + points.description, fontSize: 12)
        SKColor.redColor()
        label.position = contactPoint
        self.parent?.addChild(label)
        
        label.runAction(SKAction.scaleTo(2, duration: 0))
        
        label.runAction(SKAction.scaleTo(1, duration: duration))
        
        
        label.runAction(SKAction.sequence([
            SKAction.waitForDuration(duration/2),
            SKAction.fadeAlphaTo(0, duration: duration/2)
            ]
            ))
        
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
