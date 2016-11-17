//
//  Spaceship.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/19/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Spaceship: Control {
    
    var emitterNode:SKEmitterNode?
    var emitterNodeParticleBirthRate: CGFloat = 0
    var defaultEmitterNodeParticleBirthRate:CGFloat = 0
    
    var emitterNodeLeft:SKEmitterNode?
    var emitterNodeLeftParticleBirthRate:CGFloat = 0
    
    var emitterNodeRight:SKEmitterNode?
    var emitterNodeRightParticleBirthRate:CGFloat = 0
    
    static var spaceshipList = Set<Spaceship>()
    
    static var selectedSpaceship:Spaceship?
    
    enum zPositions: CGFloat {
        case skin
        case glassSkin
        case selectedDetail
        case touchAreaEffect
    }
    
    var level:Int!
    var type: SpaceshipType!
    
    var weapon:Weapon!
    
    var battleMaxLevel:Int!
    
    //Vida e Escudo de Energia
    var health:Int!
    var maxHealth:Int!
    var energyShield:Int!
    var maxEnergyShield:Int!

    
    var speedAtribute:Int!
    var shieldPower:Int!
    var shieldRecharge:Int!
    
    var weaponRangeBonus:CGFloat = 0
    
    var spaceshipData:SpaceshipData?
    
    var selectedSpriteNode:SKSpriteNode!
    
    var targetNode:SKNode?
    
    //Movement
    var destination = CGPoint.zero
    var needToMove = false
    var rotationToDestination:CGFloat = 0
    var totalRotationToDestination:CGFloat = 0
    var startingPosition = CGPoint.zero
    var startingZPosition = CGFloat(0)
    
    var maxAngularVelocity:CGFloat = 3
    var force:CGFloat = 20
    var angularImpulse:CGFloat = 0.0005
    var maxVelocitySquared:CGFloat = 0
    
    var isInsideAMothership = true
    
    private var healthBar:HealthBar!
    var weaponRangeSprite:SKShapeNode?
    var moveWeaponRangeSprite:SKShapeNode?
    
    //Respawn
    var canRespawn = true
    var deathCount = 0
    var deathTime = 0.0
    var lastSecond = 0.0
    
    var healPerFrame = 1
    
    //statistics
    var isAlly = true

    var explosionSoundEffect:SoundEffect!
    
    var onlineDamage = 0
    var onlineHeal = 0
    
    private var spriteNode:SKSpriteNode!
    
    override var description: String {
        return "\nSpaceship\n" +
            "level: " + level.description + "\n" +
            "health: " + health.description  + "\n" +
            "maxHealth: " + maxHealth.description  + "\n" +
            "energyShield: " + energyShield.description  + "\n" +
            "maxEnergyShield: " + maxEnergyShield.description  + "\n" +
            "speedAtribute: " + speedAtribute.description  + "\n" +
            "shieldPower: " + shieldPower.description  + "\n" +
            "shieldRecharge: " + shieldRecharge.description  + "\n"
    }
    
    static func displayName(type:Int, level:Int = 0) -> String {
        return Spaceship.types[type].name
    }
    
    func displayName() -> String {
        return Spaceship.displayName(self.type.index, level: self.level)
    }
    
    override init() {
        fatalError("NÃO IMPLEMENTADO")
    }
    
    init(type: Int, level: Int, loadPhysics: Bool = false) {
        super.init()
        self.load(type: type, level: level, loadPhysics:loadPhysics)
        
        self.weapon = Weapon(weaponType: self.type.weaponType, level: self.level, loadSoundEffects: loadPhysics)
        self.addChild(weapon)
        self.loadWeaponDetail()
    }
    
    init(extraType: Int, level: Int, loadPhysics: Bool = false) {
        super.init()
        self.load(extraType: extraType, level: level, loadPhysics: loadPhysics)
    }
    
    init(spaceshipData:SpaceshipData, loadPhysics:Bool = false) {
        super.init()
        self.spaceshipData = spaceshipData
        self.load(type: spaceshipData.type.integerValue, level: spaceshipData.level.integerValue, loadPhysics: loadPhysics)
        
        self.weapon = Weapon(weaponType: self.type.weaponType, level: self.level, loadSoundEffects: loadPhysics)
        self.addChild(weapon)
        self.loadWeaponDetail()
    }
    
    func loadJetEffect(targetNode: SKNode?, color: SKColor) {
        
        self.defaultEmitterNodeParticleBirthRate  = CGFloat(self.speedAtribute * 20)
        
        var emitterNodes = [SKEmitterNode]()
        
        if self.type.bodyType.centerJet {
            self.emitterNode = SKEmitterNode(fileNamed: "Jet.sks")
            if let emitterNode = self.emitterNode {
                emitterNodes.append(emitterNode)
            }
        }
        if self.type.bodyType.leftJet {
            self.emitterNodeLeft = SKEmitterNode(fileNamed: "Jet.sks")
            if let emitterNode = self.emitterNodeLeft {
                emitterNodes.append(emitterNode)
            }
        }
        if self.type.bodyType.rightJet {
            self.emitterNodeRight = SKEmitterNode(fileNamed: "Jet.sks")
            if let emitterNode = self.emitterNodeRight {
                emitterNodes.append(emitterNode)
            }
        }
        
        for emitterNode in emitterNodes {
            emitterNode.particleColorSequence = nil
            emitterNode.particleColorBlendFactor = 1
            emitterNode.particleColor = color
            emitterNode.particleBirthRate = 0
            emitterNode.zPosition = self.zPosition - 1
            emitterNode.particleSize = CGSize(width: 10, height: 10)
            if let targetNode = targetNode {
                emitterNode.targetNode = targetNode
            } else {
                emitterNode.targetNode = self.parent
            }
            self.parent?.addChild(emitterNode)
        }
    }
    
    func loadHealthBar(gameWorld:GameWorld) {
        
        var fillColor:SKColor!
        var backColor:SKColor!
        let background = SKSpriteNode(imageNamed: "spaceshipHealthBarBackground")
        
        if self.isAlly {
            fillColor = SKColor(red: 0/255, green: 126/255, blue: 255/255, alpha: 1)
            backColor = SKColor(red: 0/255, green: 84/255, blue: 143/255, alpha: 1)
            background.color = backColor
            background.colorBlendFactor = 1
            
            self.healthBar = HealthBar(background: background, backColor: backColor, fillColor: fillColor)
            self.healthBar.positionOffset = CGPoint(x: 0, y: -30)
        } else {
            fillColor = SKColor(red: 196/255, green: 67/255, blue: 43/255, alpha: 1)
            backColor = SKColor(red: 105/255, green: 31/255, blue: 17/255, alpha: 1)
            background.color = backColor
            background.colorBlendFactor = 1
            
            self.healthBar = HealthBar(background: background, backColor: backColor, fillColor: fillColor)
            self.healthBar.positionOffset = CGPoint(x: 0, y: 30)
        }
        
        self.healthBar.zPosition = GameWorld.zPositions.spaceshipHealthBar.rawValue
        gameWorld.addChild(self.healthBar)
        
        let border = SKSpriteNode(imageNamed: "spaceshipHealthBarBorder")
        border.texture?.filteringMode = Display.filteringMode
        border.color = backColor
        border.colorBlendFactor = 1
        self.healthBar.addChild(border)
        
        let spaceshipLevelBackground = SKSpriteNode(imageNamed: "spaceshipLevelBackground")
        spaceshipLevelBackground.texture?.filteringMode = Display.filteringMode
        
        if self.isAlly {
            spaceshipLevelBackground.color = SKColor(red: 214/255, green: 247/255, blue: 255/255, alpha: 1)
        } else {
            spaceshipLevelBackground.color = SKColor(red: 255/255, green: 231/255, blue: 231/255, alpha: 1)
        }
        spaceshipLevelBackground.colorBlendFactor = 1
        spaceshipLevelBackground.position = CGPoint(x: -(spaceshipLevelBackground.size.width + self.healthBar.fillMaxWidth)/2, y: 0)
        self.healthBar.positionOffset = CGPoint(x: spaceshipLevelBackground.size.width/2, y: self.healthBar.positionOffset.y)
        
        self.healthBar.labelLevel = Label(color: backColor, text: self.level.description, fontSize: 11, fontName: GameFonts.fontName.museo1000)
        spaceshipLevelBackground.addChild(self.healthBar.labelLevel)
        
        let spaceshipLevelBorder = SKSpriteNode(imageNamed: "spaceshipLevelBorder")
        spaceshipLevelBorder.texture?.filteringMode = Display.filteringMode
        spaceshipLevelBorder.color = backColor
        spaceshipLevelBorder.colorBlendFactor = 1
        
        self.healthBar.addChild(spaceshipLevelBackground)
        spaceshipLevelBackground.addChild(spaceshipLevelBorder)
        
        self.updateHealthBarPosition()
        self.updateHealthBarValue()
        
        self.loadJetEffect(gameWorld, color: backColor)
    }
    
    func loadWeaponRangeSprite(gameWorld:GameWorld) {
        if let weapon = self.weapon {
            self.weaponRangeSprite = SKShapeNode(circleOfRadius: weapon.rangeInPoints)
            self.weaponRangeSprite?.strokeColor = SKColor.whiteColor()
            self.weaponRangeSprite?.fillColor = SKColor.clearColor()
            self.weaponRangeSprite?.position = self.position
            self.weaponRangeSprite?.alpha = 0
            
            if let weaponRangeSprite = self.weaponRangeSprite {
                gameWorld.addChild(weaponRangeSprite)
            }
            
            
            self.moveWeaponRangeSprite = SKShapeNode(circleOfRadius: weapon.rangeInPoints)
            self.moveWeaponRangeSprite?.strokeColor = SKColor.whiteColor()
            self.moveWeaponRangeSprite?.fillColor = SKColor.clearColor()
            self.moveWeaponRangeSprite?.position = self.position
            self.moveWeaponRangeSprite?.alpha = 0
            
            if let moveWeaponRangeSprite = self.moveWeaponRangeSprite {
                gameWorld.addChild(moveWeaponRangeSprite)
            }
        }
    }
    
    func showMoveWeaponRangeSprite() {
        if let _ = self.weapon {
            self.moveWeaponRangeSprite?.position = self.destination
            self.moveWeaponRangeSprite?.alpha = 1
        }
    }
    
    func showWeaponRangeSprite() {
        if let _ = self.weapon {
            self.weaponRangeSprite?.alpha = 1
        }
    }
    
    func loadWeaponDetail() {
        if let weapon = self.weapon {
            self.spriteNode.color = weapon.type.color
            self.spriteNode.colorBlendFactor = 1
        }
    }
    
    func increaseTouchArea() {
        let spriteNodeTest = SKSpriteNode(color: SKColor.clearColor(), size: CGSize(width: 64, height: 64))
        spriteNodeTest.texture?.filteringMode = Display.filteringMode
        spriteNodeTest.zPosition = zPositions.touchAreaEffect.rawValue
        self.addChild(spriteNodeTest)
    }
    
    private func load(type type:Int, level:Int, loadPhysics:Bool) {
        self.type = Spaceship.types[type]
        self.level = level
        self.battleMaxLevel = level
        self.load(loadPhysics)
    }
    
    private func load(extraType extraType:Int, level:Int, loadPhysics:Bool) {
        self.type = Spaceship.extraTypes[extraType]
        self.level = level
        self.battleMaxLevel = level
        self.load(loadPhysics)
    }
    
    func loadSoundEffects() {
        self.explosionSoundEffect = SoundEffect(soundType: SoundEffect.effectTypes.explosion, node: self)
    }
    
    func setBattleLevel(level:Int) {
        
        self.maxHealth = GameMath.spaceshipMaxHealth(level: level, bodyType: self.type.bodyType)
        
        if level < self.level {
            self.health = self.maxHealth
        }
        
        if let weapon = self.weapon {
            weapon.level = level
            weapon.damage = GameMath.weaponDamage(level: weapon.level, type: weapon.type)
        }
        
        self.level = level
        
        if let healthBar = self.healthBar {
            healthBar.update(self.health, maxHealth: self.maxHealth)
            healthBar.labelLevel.setText(self.level.description)
        }
    }
    
    func upgradeOnBattle() {
        if self.level < self.battleMaxLevel {
            self.setBattleLevel(self.level + 1)
        }
    }
    
    private func load(loadPhysics:Bool) {
        
        self.speedAtribute = GameMath.spaceshipSpeedAtribute(level: self.level, bodyType: self.type.bodyType)
        self.health = GameMath.spaceshipMaxHealth(level: self.level, bodyType: self.type.bodyType)
        self.maxHealth = health
        self.shieldPower = GameMath.spaceshipShieldPower(level: self.level, bodyType: self.type.bodyType)
        self.shieldRecharge = GameMath.spaceshipShieldRecharge(level: self.level, bodyType: self.type.bodyType)
        
        //TODO: GameMath.calculatedHealPerFrame
        let calculatedHealPerFrame = Int(self.maxHealth/5/60)
        if calculatedHealPerFrame > self.healPerFrame {
            self.healPerFrame = calculatedHealPerFrame
        }
        
        self.energyShield = GameMath.spaceshipShieldPower(level: self.level, bodyType: self.type.bodyType)
        self.maxEnergyShield = energyShield
        
        //Gráfico
        self.spriteNode = SKSpriteNode(imageNamed: self.type.bodyType.skin)
        self.spriteNode.texture?.filteringMode = Display.filteringMode
        self.spriteNode.setScale(self.type.bodyType.scale)
        self.spriteNode.texture?.filteringMode = Display.filteringMode
        self.spriteNode.zPosition = zPositions.skin.rawValue
        self.addChild(self.spriteNode)
        
        if self.type.bodyType.glassSkin != "" {
            let spriteNode = SKSpriteNode(imageNamed: self.type.bodyType.glassSkin)
            spriteNode.texture?.filteringMode = Display.filteringMode
            spriteNode.setScale(self.type.bodyType.scale)
            spriteNode.texture?.filteringMode = Display.filteringMode
            spriteNode.zPosition = zPositions.glassSkin.rawValue
            spriteNode.color = self.type.bodyType.glassColor
            spriteNode.colorBlendFactor = 1
            spriteNode.position = self.type.bodyType.glassPosition
            self.addChild(spriteNode)
        }
        
        self.selectedSpriteNode = SKSpriteNode(imageNamed: self.type.bodyType.skin + "Mask")
        self.selectedSpriteNode.texture?.filteringMode = Display.filteringMode
        self.selectedSpriteNode.setScale(self.type.bodyType.scale)
        self.selectedSpriteNode.color = SKColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        self.selectedSpriteNode.colorBlendFactor = 1
        self.selectedSpriteNode.hidden = true
        self.selectedSpriteNode.zPosition = zPositions.selectedDetail.rawValue
        self.addChild(self.selectedSpriteNode)
        
        self.weaponRangeBonus = spriteNode.size.height/2
        
        if loadPhysics {
            self.loadSoundEffects()
            self.loadPhysics(rectangleOfSize: spriteNode.size)
        }
        
        self.increaseTouchArea()
        
        Spaceship.spaceshipList.insert(self)
        
        self.size = spriteNode.size
    }
    
    func loadPhysics(rectangleOfSize size:CGSize) {
        
        self.zPosition = GameWorld.zPositions.spaceship.rawValue
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.mass = 0.0455111116170883
        self.physicsBody?.dynamic = false
        
        self.setBitMasksToMothershipSpaceship()
        
        self.physicsBody?.linearDamping = 2
        self.physicsBody?.angularDamping = 4
//        self.physicsBody?.friction = 0
//        self.physicsBody?.restitution = 0
        
        self.maxVelocitySquared = GameMath.spaceshipMaxVelocitySquared(speed: self.speedAtribute)
        self.force = self.maxVelocitySquared / 60
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMoveArrowToDestination() {
        let spriteNode = SKSpriteNode(imageNamed: "moveArrows")
        spriteNode.texture?.filteringMode = Display.filteringMode
        spriteNode.position = self.destination
        self.parent?.addChild(spriteNode)
        
        spriteNode.runAction(SKAction.resizeToWidth(0, height: 1, duration: 0.5))
        spriteNode.runAction(SKAction.fadeOutWithDuration(0.5), completion: { [weak spriteNode] in
            spriteNode?.removeFromParent()
        })
        self.showWeaponRangeSprite()
        self.showMoveWeaponRangeSprite()
    }
    
    func setAttackArrowToTarget() {
        if self.isAlly {
            if let targetNode = self.targetNode {
                let spriteNode = SKSpriteNode(imageNamed: "attackArrows")
                spriteNode.texture?.filteringMode = Display.filteringMode
                spriteNode.position = targetNode.position
                self.parent?.addChild(spriteNode)
                
                spriteNode.runAction(SKAction.resizeToWidth(0, height: 1, duration: 0.5))
                spriteNode.runAction(SKAction.fadeOutWithDuration(0.5), completion: { [weak spriteNode] in
                    spriteNode?.removeFromParent()
                    })
            }
        }
    }
    
    func touchEnded(touch: UITouch) {
        
        if self == Spaceship.selectedSpaceship {
            if !self.isInsideAMothership {
                self.targetNode = nil
                self.needToMove = false
                if let parent = self.parent {
                    self.destination = touch.locationInNode(parent)
                }
                self.setBitMasksToSpaceship()
            }
            self.showWeaponRangeSprite()
            
        } else {
            if let spaceship = Spaceship.selectedSpaceship {
                spaceship.selectedSpriteNode.hidden = true
            }
            if self.health > 0 {
                Spaceship.selectedSpaceship = self
                self.showWeaponRangeSprite()
                
                self.physicsBody?.dynamic = true
                self.selectedSpriteNode.hidden = false
            }
        }
    }
    
    static func touchEnded(touch: UITouch) {
        if let spaceship = Spaceship.selectedSpaceship {
            if spaceship.health > 0 {
                if let parent = spaceship.parent {
                    
                    //Precisa mover, esqueca o que está fazendo
                    spaceship.targetNode = nil
                    
                    spaceship.destination = touch.locationInNode(parent)
                    spaceship.physicsBody?.dynamic = true
                    spaceship.needToMove = true
                    spaceship.setMoveArrowToDestination()
                    spaceship.showMoveWeaponRangeSprite()
                }
            }
        }
    }
    
    static func retreatSelectedSpaceship() {
        if let spaceship = Spaceship.selectedSpaceship {
            spaceship.retreat()
        }
        
        Spaceship.selectedSpaceship = nil
    }
    
    func retreat() {
        //Precisa mover, esqueca o que está fazendo
        self.targetNode = nil
        
        self.destination = self.startingPosition
        self.needToMove = true
        
        self.selectedSpriteNode.hidden = true
        self.setBitMasksToMothershipSpaceship()
    }
    
    func update(enemyMothership enemyMothership:Mothership?, enemySpaceships:[Spaceship], allySpaceships:[Spaceship]) {
        
        self.emitterNodeParticleBirthRate = 0
        self.emitterNodeLeftParticleBirthRate = 0
        self.emitterNodeRightParticleBirthRate = 0
        
        self.move(enemyMothership: enemyMothership, enemySpaceships: enemySpaceships, allySpaceships:allySpaceships)
        
        self.updateHealthBarPosition()
        
        self.updateWeaponRangeSprite()
        
        self.updateEmitters()
        
    }
    
    func updateEmitters() {
        
        if let emitterNode = self.emitterNode {
            emitterNode.particleBirthRate = self.emitterNodeParticleBirthRate
            emitterNode.particleSpeed = self.emitterNodeParticleBirthRate
            emitterNode.particleSpeedRange = self.emitterNodeParticleBirthRate/2
            emitterNode.position = self.position
            emitterNode.emissionAngle = self.zRotation - CGFloat(M_PI/2)
        } else {
            self.emitterNodeLeftParticleBirthRate = max(self.emitterNodeParticleBirthRate, self.emitterNodeLeftParticleBirthRate)
            self.emitterNodeRightParticleBirthRate = max(self.emitterNodeParticleBirthRate, self.emitterNodeRightParticleBirthRate)
        }
        
        if let emitterNode = self.emitterNodeLeft {
            emitterNode.particleBirthRate = self.emitterNodeLeftParticleBirthRate
            emitterNode.particleSpeed = self.emitterNodeLeftParticleBirthRate
            emitterNode.particleSpeedRange = self.emitterNodeLeftParticleBirthRate/2
            
            let auxX = -sin(self.zRotation + CGFloat(M_PI/2)) * (self.size.width/2 + self.type.bodyType.jetBorderOffset)
            let auxY = cos(self.zRotation + CGFloat(M_PI/2)) * (self.size.width/2 + self.type.bodyType.jetBorderOffset)
            emitterNode.position = CGPoint( x: self.position.x + auxX, y: self.position.y + auxY)
            
            emitterNode.emissionAngle = self.zRotation - CGFloat(M_PI/2)
        }
        
        if let emitterNode = self.emitterNodeRight {
            emitterNode.particleBirthRate = self.emitterNodeRightParticleBirthRate
            emitterNode.particleSpeed = self.emitterNodeRightParticleBirthRate
            emitterNode.particleSpeedRange = self.emitterNodeRightParticleBirthRate/2
            
            let auxX = -sin(self.zRotation - CGFloat(M_PI/2)) * (self.size.width/2 + self.type.bodyType.jetBorderOffset)
            let auxY = cos(self.zRotation - CGFloat(M_PI/2)) * (self.size.width/2 + self.type.bodyType.jetBorderOffset)
            emitterNode.position = CGPoint( x: self.position.x + auxX, y: self.position.y + auxY)
            
            emitterNode.emissionAngle = self.zRotation - CGFloat(M_PI/2)
        }
    }
    
    func updateWeaponRangeSprite() {
        
        if let weaponRangeSprite = self.weaponRangeSprite {
            weaponRangeSprite.position = self.position
            
            if self.health <= 0 {
                weaponRangeSprite.alpha = 0
                moveWeaponRangeSprite?.alpha = 0
            } else {
                
                if moveWeaponRangeSprite?.alpha > 0 {
                    moveWeaponRangeSprite?.alpha -= 0.06666666667
                }
                
                if self != Spaceship.selectedSpaceship {
                    if weaponRangeSprite.alpha > 0 {
                        weaponRangeSprite.alpha -= 0.06666666667
                    }
                }
            }
        }
    }
    
    func setBitMasksToMothershipSpaceship() {
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.mothershipSpaceship.rawValue
        self.physicsBody?.collisionBitMask = GameWorld.collisionBitMask.mothershipSpaceship
        self.physicsBody?.contactTestBitMask = GameWorld.contactTestBitMask.mothershipSpaceship
    }
    
    func setBitMasksToSpaceship() {
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.spaceship.rawValue
        self.physicsBody?.collisionBitMask = GameWorld.collisionBitMask.spaceship
        self.physicsBody?.contactTestBitMask = GameWorld.contactTestBitMask.spaceship
    }
    
    func resetToStartingPosition() {
        self.isInsideAMothership = true
        self.position = self.startingPosition
        self.zRotation = self.startingZPosition
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.angularVelocity = 0
        self.physicsBody?.dynamic = false
    }
    
    func canBeTargetAndHitBy(spaceship:Spaceship) -> Bool {
        
        if !self.canBeTarget() || !spaceship.canBeTarget() {
            return false
        }
        
        if let spaceshipWeapon = spaceship.weapon {
            let range = spaceshipWeapon.rangeInPoints + spaceship.weaponRangeBonus + self.weaponRangeBonus
            if (self.position - spaceship.position).length() > range {
                return false
            }
        } else {
            return false
        }
        
        return true
    }
    
    func canBeTarget() -> Bool {
        
        if self.isInsideAMothership {
            return false
        }
        
        if self.health <= 0 {
            return false
        }
        
        return true
    }
    
    func nearestTarget(enemyMothership enemyMothership:Mothership?, enemySpaceships:[Spaceship], allySpaceships:[Spaceship]) -> SKNode? {
        
        var currentTarget: SKNode? = nil
        
        for targetPriorityType in self.type.bodyType.targetPriority {
            switch targetPriorityType {
            case TargetType.spaceships:
                for enemySpaceship in enemySpaceships {
                    
                    if enemySpaceship.canBeTargetAndHitBy(self) {
                        
                        if currentTarget != nil {
                            if (self.position - enemySpaceship.position).lengthSquared() < (self.position - currentTarget!.position).lengthSquared() {
                                
                                if self.canFire(enemySpaceship.position, allySpaceships: allySpaceships)  {
                                    currentTarget = enemySpaceship
                                }
                            }
                        } else {
                            if self.canFire(enemySpaceship.position, allySpaceships: allySpaceships)  {
                                currentTarget = enemySpaceship
                            }
                        }
                        
                    }
                }
                break
                
            case TargetType.mothership:
                if let enemyMothership = enemyMothership {
                    if enemyMothership.canBeTargetAndHitBy(self) {
                        currentTarget = enemyMothership
                    }
                }
                break
                
            default:
                break
            }
            
            if currentTarget != nil {
                break
            }
        }
        
        return currentTarget
    }
    
    func canFire(targetNodePosition: CGPoint, allySpaceships:[Spaceship]) -> Bool {
        var canfire = true
        
        for allySpaceship in allySpaceships {
            
            if allySpaceship != self && allySpaceship.canBeTargetAndHitBy(self) {
                if (self.position - allySpaceship.position).lengthSquared() < (self.position - targetNodePosition).lengthSquared() {
                    let point = allySpaceship.position
                    let dx = Float(point.x - self.position.x)
                    let dy = Float(point.y - self.position.y)
                    
                    let rotationToDestination = CGFloat(-atan2f(dx, dy))
                    
                    var totalRotationToDestination = rotationToDestination - self.zRotation
                    
                    while(totalRotationToDestination < -CGFloat(M_PI)) { totalRotationToDestination += CGFloat(M_PI * 2) }
                    while(totalRotationToDestination >  CGFloat(M_PI)) { totalRotationToDestination -= CGFloat(M_PI * 2) }
                    
                    if abs(totalRotationToDestination) <= 0.2 {
                        canfire = false
                        break
                    }
                }
            }
        }
        
        return canfire
    }
    
    func getShot(shot:Shot?, contact: SKPhysicsContact?) {
        
        if let shot = shot {
            
            if shot.shooter == self {
                return
            }
            
            if let shooter = shot.shooter as? Spaceship {
                if shooter.isAlly == self.isAlly {
                    return
                }
            }
            
            let dx = Float(shot.position.x - self.position.x)
            let dy = Float(shot.position.y - self.position.y)
            
            let rotationToShot = -atan2f(dx, dy)
            var totalRotationToShot = rotationToShot - Float(self.zRotation)
            while(totalRotationToShot < Float(-M_PI)) { totalRotationToShot += Float(M_PI * 2) }
            while(totalRotationToShot >  Float(M_PI)) { totalRotationToShot -= Float(M_PI * 2) }
            
            let damageMultiplier = max(abs(totalRotationToShot), 1)
            
            shot.damage = Int(Float(shot.damage) * damageMultiplier)
            
            if self.health > 0 && self.health - shot.damage <= 0 {
                if let spaceship = shot.shooter as? Spaceship {
                    if let spaceshipData = spaceship.spaceshipData {
                        spaceshipData.killCount = spaceshipData.killCount.integerValue + 1
                        Metrics.killerSpaceship(spaceship.type.name)
                        if shot.damage > self.maxHealth {
                            Metrics.oneHitKillerSpaceship(spaceship.type.name)
                        }
                    }
                }
            }
            
            if shot.damage > 0 {
                self.damageEffect(shot.damage, contactPoint: shot.position, contact: contact)
            }
            
            if BattleScene.state == .battleOnline {
                
                if self.isAlly {
                    // o outro jogador me avisa caso eu receba dano
                } else {
                    
                    self.onlineDamage = self.onlineDamage + shot.damage
                    
                    if self.health > 0 && self.health - shot.damage <= 0 {
                        self.die()
                        if let spaceship = shot.shooter as? Spaceship {
                            if spaceship.isAlly {
                                spaceship.upgradeOnBattle()
                            }
                        }
                    } else {
                        self.health = self.health - shot.damage
                    }
                }
                
            } else {
                
                
                if self.health > 0 && self.health - shot.damage <= 0 {
                    self.die()
                    if let spaceship = shot.shooter as? Spaceship {
                        spaceship.upgradeOnBattle()
                    }
                } else {
                    self.health = self.health - shot.damage
                }
            }
            
            if self.health < 0 { self.health = 0 }
            self.updateHealthBarValue()
            
            
            shot.damage = 0
            shot.removeFromParent()
        }
    }
    
    func respawn() {
        
        if BattleScene.state == .battleOnline {
            if self.isAlly {
                self.onlineHeal = self.onlineHeal + self.maxHealth
                self.health = self.health + self.maxHealth
            } else {
                return
                // o outro jogador me avisa quando ele estiver recupesando vida
            }
        } else {
            self.health = self.health + self.maxHealth
        }
        
        self.updateHealthBarValue()
        self.updateHealthBarPosition()
    }
    
    func die() {
        
        Control.gameScene.shake(7.5)
        
        self.deathTime = GameScene.currentTime
        self.lastSecond = GameScene.currentTime
        self.deathCount += 1
        
        self.explosionSoundEffect.play()
        let particles = SKEmitterNode(fileNamed: "explosion.sks")!
        
        particles.position.x = self.position.x
        particles.position.y = self.position.y
        
        particles.particlePositionRange = CGVector(dx: self.weaponRangeBonus, dy: self.weaponRangeBonus)
        
        if let parent = self.parent {
            
            particles.zPosition = GameWorld.zPositions.explosion.rawValue
            parent.addChild(particles)
            
            let action = SKAction()
            action.duration = 1
            particles.runAction(action, completion: { [weak particles] in
                particles?.removeFromParent()
            })
        }
        
        
        self.health = 0
        
        self.updateHealthBarValue()
        
        if Spaceship.selectedSpaceship == self {
            Spaceship.retreatSelectedSpaceship()
        } else {
            self.retreat()
        }
        
        self.physicsBody = nil
        self.resetToStartingPosition()
    }
    
    func heal() {
        if self.health < self.maxHealth {
            
            if BattleScene.state == .battleOnline {
                if self.isAlly {
                    //self.onlineHeal = self.onlineHeal + self.healPerFrame
                    //self.health = self.health + self.healPerFrame
                } else {
                    return
                   // o outro jogador me avisa quando ele estiver recupesando vida
                }
            } else {
                //self.health = self.health + self.healPerFrame
            }
            
            if self.health > self.maxHealth {
                self.health = self.maxHealth
            }
            
            self.updateHealthBarValue()
        }
    }
    
    func updateHealthBarPosition() {
        self.healthBar.update(position: self.position)
    }
    
    func updateHealthBarValue() {
        self.healthBar.update(self.health, maxHealth: self.maxHealth)
        
        self.hidden = self.health <= 0
        self.healthBar.hidden = self.hidden
        
        if !self.hidden {
            if self.physicsBody == nil {
                self.loadPhysics(rectangleOfSize: self.spriteNode.size)
            }
        }
    }
    
    func move(enemyMothership enemyMothership:Mothership?, enemySpaceships:[Spaceship], allySpaceships:[Spaceship]) {
       
        if self.health > 0 {
            
            if self.isInsideAMothership {
                
                if (self.position - self.startingPosition).lengthSquared() < 256 {
                    self.heal()
                }
                
                if (CGPoint(x: self.startingPosition.x, y: self.position.y) - self.startingPosition).lengthSquared() > 4545 {
                    self.isInsideAMothership = false
                }
                
                if (self.destination - self.startingPosition).lengthSquared() > 16 {
                    if let physicsBody = self.physicsBody {
                        let velocitySquared = (physicsBody.velocity.dx * physicsBody.velocity.dx) + (physicsBody.velocity.dy * physicsBody.velocity.dy)
                        
                        self.rotateToPoint(CGPoint(x: self.position.x, y: -self.position.y * 2))
                        
                        if velocitySquared < self.maxVelocitySquared {
                            self.physicsBody?.applyForce(CGVector(dx: -sin(self.zRotation) * self.force, dy: cos(self.zRotation) * self.force))
                        }
                        self.emitterNodeParticleBirthRate = self.defaultEmitterNodeParticleBirthRate
                    }
                }
            }
            
            if self.needToMove {

                if (self.position - self.destination).lengthSquared() < 1024 {
               
                    self.needToMove = false
                    
                    if (self.destination - self.startingPosition).lengthSquared() < 16 {
                        self.resetToStartingPosition()
                    } else {
                        if !self.isInsideAMothership {
                            self.targetNode = self.nearestTarget(enemyMothership: enemyMothership, enemySpaceships: enemySpaceships, allySpaceships: allySpaceships)
                            self.setAttackArrowToTarget()
                        }
                    }
                    
                } else {
    
                    self.rotateToPoint(self.destination)
                    
                    if let physicsBody = self.physicsBody {
                        
                        if abs(self.totalRotationToDestination) <= 1 {
                            let velocitySquared = (physicsBody.velocity.dx * physicsBody.velocity.dx) + (physicsBody.velocity.dy * physicsBody.velocity.dy)
                           
                            if velocitySquared < self.maxVelocitySquared {
                                self.physicsBody?.applyForce(CGVector(dx: -sin(self.zRotation) * self.force, dy: cos(self.zRotation) * self.force))
                            }
                            self.emitterNodeParticleBirthRate = self.defaultEmitterNodeParticleBirthRate
                        }
                    }
                }
                
            } else {
                
                if let targetNode = self.targetNode {
                    
                    if let targetNode = targetNode as? Mothership {
                        if targetNode.health <= 0 {
                            self.targetNode = nil
                        } else {
                            self.rotateToPoint(targetNode.position)
                            self.destination = self.position
                            
                            if targetNode.canBeTargetAndHitBy(self) {
                                if abs(self.totalRotationToDestination) <= 0.05 {
                                    if self.canFire(targetNode.position, allySpaceships: allySpaceships) {
                                        self.weapon?.fire(self.weaponRangeBonus)
                                    } else {
                                        self.targetNode = nil
                                    }
                                }
                            } else {
                                
                                if let physicsBody = self.physicsBody {
                                    
                                    if abs(self.totalRotationToDestination) <= 1 {
                                        let velocitySquared = (physicsBody.velocity.dx * physicsBody.velocity.dx) + (physicsBody.velocity.dy * physicsBody.velocity.dy)
                                        
                                        if velocitySquared < self.maxVelocitySquared {
                                            self.physicsBody?.applyForce(CGVector(dx: -sin(self.zRotation) * self.force, dy: cos(self.zRotation) * self.force))
                                        }
                                        self.emitterNodeParticleBirthRate = self.defaultEmitterNodeParticleBirthRate
                                    }
                                }
                            }
                        }
                    }
                    
                    if let targetNode = targetNode as? Spaceship {
                        
                        if !targetNode.canBeTarget() {
                            self.targetNode = nil
                        } else {
                            
                            self.rotateToPoint(targetNode.position)
                            self.destination = self.position
                            
                            if targetNode.canBeTargetAndHitBy(self) {
                                if abs(self.totalRotationToDestination) <= 0.05 {
                                    if self.canFire(targetNode.position, allySpaceships: allySpaceships) {
                                        self.weapon?.fire(self.weaponRangeBonus)
                                    } else {
                                        self.targetNode = nil
                                    }
                                }
                            } else {
                                
                                if let physicsBody = self.physicsBody {
                                    
                                    if abs(self.totalRotationToDestination) <= 1 {
                                        let velocitySquared = (physicsBody.velocity.dx * physicsBody.velocity.dx) + (physicsBody.velocity.dy * physicsBody.velocity.dy)
                                        
                                        if velocitySquared < self.maxVelocitySquared {
                                            self.physicsBody?.applyForce(CGVector(dx: -sin(self.zRotation) * self.force, dy: cos(self.zRotation) * self.force))
                                        }
                                        self.emitterNodeParticleBirthRate = self.defaultEmitterNodeParticleBirthRate
                                    }
                                }
                            }
                        }
                    }
                    
                } else {
                    if self.canBeTarget() {
                        self.targetNode = self.nearestTarget(enemyMothership: enemyMothership, enemySpaceships: enemySpaceships, allySpaceships: allySpaceships)
                        self.setAttackArrowToTarget()
                        
                        if let physicsBody = self.physicsBody {
                            
                            let dx = Float(self.destination.x - self.position.x)
                            let dy = Float(self.destination.y - self.position.y)
                            
                            let rotationToDestination = CGFloat(-atan2f(dx, dy))
                            
                            let velocitySquared = (physicsBody.velocity.dx * physicsBody.velocity.dx) + (physicsBody.velocity.dy * physicsBody.velocity.dy)
                            
                            let force = (self.position - self.destination).length()
                            
                            if velocitySquared < self.maxVelocitySquared {
                                physicsBody.applyForce(CGVector(dx: -sin(rotationToDestination) * force/10, dy: cos(rotationToDestination) * force/10))
                            }
                        }
                    }
                }
            }
        } else {
            if self.canRespawn {
                if GameScene.currentTime - self.lastSecond > 1 {
                    self.lastSecond = GameScene.currentTime
                    if GameScene.currentTime - self.deathTime > Double(self.deathCount * 5) {//TODO self.deathCount * 5
                        self.respawn()
                    } else {
                        let label = Label(text: Int((self.deathCount * 5) - Int(GameScene.currentTime - self.deathTime)).description)
                        label.position = self.startingPosition
                        self.parent?.addChild(label)
                        
                        label.runAction({let a = SKAction(); a.duration = 1; return a}(), completion: { [weak label] in
                            label?.removeFromParent()
                            })
                    }
                }
            }
        }
    }
    
    func rotateToPoint(point:CGPoint) {
        
        if let physicsBody = self.physicsBody {
            
            let dx = Float(point.x - self.position.x)
            let dy = Float(point.y - self.position.y)
            
            self.rotationToDestination = CGFloat(-atan2f(dx, dy))
            
            if(abs(physicsBody.angularVelocity) < self.maxAngularVelocity) {
                
                self.totalRotationToDestination = self.rotationToDestination - self.zRotation
                
                while(self.totalRotationToDestination < -CGFloat(M_PI)) { self.totalRotationToDestination += CGFloat(M_PI * 2) }
                while(self.totalRotationToDestination >  CGFloat(M_PI)) { self.totalRotationToDestination -= CGFloat(M_PI * 2) }
                
                physicsBody.applyAngularImpulse(self.totalRotationToDestination * self.angularImpulse)
            }
            
            let absTotalRotationToDestination = abs(self.totalRotationToDestination)
            
            if abs(self.totalRotationToDestination) >= 0.2 {
                if self.totalRotationToDestination > 0 {
                    self.emitterNodeRightParticleBirthRate = min(absTotalRotationToDestination, 1) * self.defaultEmitterNodeParticleBirthRate
                } else {
                    self.emitterNodeLeftParticleBirthRate = min(absTotalRotationToDestination, 1) * self.defaultEmitterNodeParticleBirthRate
                }
            }
        }
    }
    
    func didBeginContact(otherPhysicsBody:SKPhysicsBody, contact: SKPhysicsContact) {
        if let myPhysicsBody = self.physicsBody {
            
            switch myPhysicsBody.categoryBitMask {
                
            case GameWorld.categoryBitMask.spaceship.rawValue:
                {
                    switch otherPhysicsBody.categoryBitMask {
                        
                    default:
                        #if DEBUG
                            fatalError()
                        #endif
                        break
                    }
                }()
                break
                
            case GameWorld.categoryBitMask.mothershipSpaceship.rawValue:
                {
                    switch otherPhysicsBody.categoryBitMask {
                        
                    case GameWorld.categoryBitMask.mothership.rawValue:
                        self.isInsideAMothership = true
                        break
                        
                    default:
                        #if DEBUG
                            fatalError()
                        #endif
                        break
                    }
                }()
                break
                
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
    
    func didEndContact(otherPhysicsBody:SKPhysicsBody, contact: SKPhysicsContact) {
        
        if let myPhysicsBody = self.physicsBody {
            
            switch myPhysicsBody.categoryBitMask {
                
            case GameWorld.categoryBitMask.spaceship.rawValue:
                {
                    switch otherPhysicsBody.categoryBitMask {
                    case GameWorld.categoryBitMask.spaceshipShot.rawValue:
                        (otherPhysicsBody.node as? Shot)?.resetBitMasks()
                        break
                        
                    default:
                        #if DEBUG
                            fatalError()
                        #endif
                        break
                    }
                }()
                break
                
            case GameWorld.categoryBitMask.mothershipSpaceship.rawValue:
                {
                    switch otherPhysicsBody.categoryBitMask {
                        
                    case GameWorld.categoryBitMask.spaceshipShot.rawValue:
                        (otherPhysicsBody.node as? Shot)?.resetBitMasks()
                        break
                        
                    case GameWorld.categoryBitMask.mothership.rawValue:
                        self.isInsideAMothership = false
                        if (self.destination - self.startingPosition).lengthSquared() > 16 {
                            self.setBitMasksToSpaceship()
                        }
                        break
                        
                    default:
                        #if DEBUG
                            fatalError()
                        #endif
                        break
                    }
                }()
                break
                
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
    
    private func addWeapon(weapon:Weapon) {
        self.weapon = weapon
        self.loadWeaponDetail()
        self.addChild(weapon)
    }
    
    func removeWeapon(weapon:Weapon) {
        self.weapon = nil
    }
    
    func updateSpaceshipData() {
        if let spaceshipData = self.spaceshipData {
            spaceshipData.level = self.level
        }
    }
    
    func upgrade() {
        if let spaceshipData = self.spaceshipData {
            
            spaceshipData.level = NSNumber(integer: spaceshipData.level.integerValue + 1)
            self.level = spaceshipData.level.integerValue
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
        
        //let label = SKLabelNode(text: points.description)
        let label = Label(color: SKColor.redColor(), text: "-" + points.description, fontSize: 12)
        SKColor.redColor()
        label.zPosition = GameWorld.zPositions.damageEffect.rawValue
        label.position = CGPoint(x: Int(self.position.x) + Int.random(min:-20, max:20), y: Int(self.position.y) + Int.random(min:-20, max:20))
        self.parent?.addChild(label)
        
        
        
        label.runAction(SKAction.scaleTo(2, duration: 0))
        
        label.runAction(SKAction.scaleTo(1, duration: duration))
        
  
        label.runAction(SKAction.sequence([
            SKAction.waitForDuration(duration/2),
            SKAction.fadeAlphaTo(0, duration: duration/2)
            ]
            ))
        
        
        let particles = SKEmitterNode(fileNamed: "spark.sks")!
        particles.position = self.position
        particles.zPosition = GameWorld.zPositions.sparks.rawValue
        particles.emissionAngle = CGFloat(-atan2(vector.dx, vector.dy)) + CGFloat(M_PI/2)
        self.parent?.addChild(particles)
        
        label.runAction({ let a = SKAction(); a.duration = duration; return a }()) { [weak label, weak particles] in
            label?.removeFromParent()
            particles?.removeFromParent()
        }
        
        
    }
    
    override func removeFromParent() {
        self.selectedSpriteNode = nil
        self.spriteNode = nil
        Spaceship.spaceshipList.remove(self)
        super.removeFromParent()
    }
    
    override func containsPoint(p: CGPoint) -> Bool {
        if self.hidden {
            return false
        } else {
            return super.containsPoint(p)
        }
    }
}

public enum TargetType:Int {
    case mothership
    case spaceships
    case towers
}

enum rarityType: String {
    case common
    case rare
    case epic
    case legendary
}

enum SpaceshipIndex: Int {
    
    case intrepidBlaster
    case intrepidStriker
    case intrepidDestroyer
    case intrepidSniper
    
    case tankerBlaster
    case tankerStriker
    case tankerDestroyer
    case tankerSniper
    
    case speederBlaster
    case speederStriker
    case speederDestroyer
    case speederSniper
}

class SpaceshipType {
    
    var name:String = ""
    var spaceshipTypeDescription:String = ""
    var index: Int
    var bodyType: BodyType
    var weaponType: WeaponType
    
    var rarity: rarityType = .common
    
    init(index: Int, name: String, bodyType: BodyType, weaponType: WeaponType, spaceshipTypeDescription:String) {
        self.index = index
        self.name = name
        self.bodyType = bodyType
        self.weaponType = weaponType
        self.spaceshipTypeDescription = spaceshipTypeDescription
    }
    
}

class BodyType {
    
    var skin = ""
    var glassSkin = ""
    var glassColor = SKColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    var glassPosition = CGPoint.zero
    var scale:CGFloat = 1.0
    
    var targetPriority:[TargetType]
    
    var speedBonus:Int
    var healthBonus:Int
    var shieldPowerBonus:Int
    var shieldRechargeBonus:Int
    
    var centerJet = false
    var leftJet = false
    var rightJet = false
    var jetBorderOffset:CGFloat = 0
    
    init(targetPriorityType:Int, speed:Int, health:Int, shieldPower:Int, shieldRecharge:Int) {
        
        self.targetPriority = Spaceship.targetPriorityTypes[targetPriorityType]
        
        self.speedBonus = speed
        self.healthBonus = health
        self.shieldPowerBonus = shieldPower
        self.shieldRechargeBonus = shieldRecharge

    }
}

extension Spaceship {
    
    static func cheatUnlockAll() {
        let memoryCard = MemoryCard.sharedInstance
        let playerData = memoryCard.playerData
        playerData.unlockedSpaceships = NSSet()
        
        for spaceshipType in Spaceship.types {
            let spaceshipData = memoryCard.newSpaceshipData(type: spaceshipType.index)
            playerData.unlockSpaceshipData(spaceshipData)
        }
    }
    
    static var targetPriorityTypes = [
        [TargetType.spaceships, TargetType.towers, TargetType.mothership],
        [TargetType.towers, TargetType.mothership]
    ]
    
    static var types: [SpaceshipType] = [
        SpaceshipType(index: SpaceshipIndex.intrepidBlaster.rawValue, name: "Intrepid Blaster",
            bodyType: {
                let spaceshipType = BodyType(targetPriorityType: 0,
                    speed: 15, health: 7, shieldPower: 5, shieldRecharge: 5)
                spaceshipType.skin = "spaceshipAA"
                spaceshipType.glassSkin = "spaceshipAAGlass"
                spaceshipType.scale = 0.5
                spaceshipType.glassPosition = CGPoint(x: 0, y: 12 * spaceshipType.scale)
                
                spaceshipType.centerJet = true
                return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 10, range: 100, fireRate: 1)
                weaponType.color = SKColor(red: 100/255, green: 210/255, blue: 63/255, alpha: 1)
                weaponType.shotSkin = "shotBA"
                
                weaponType.initSoundFileName = "laser5.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: "The first spaceship discovered, its niobium material provides reasonable armor, and its proton pistol can do good damage at medium range"
        ),
        
        SpaceshipType(index: SpaceshipIndex.intrepidStriker.rawValue, name: "Intrepid Striker", bodyType: {
            let spaceshipType = BodyType(targetPriorityType: 0,
                speed: 15, health: 7, shieldPower: 5, shieldRecharge: 5)
            spaceshipType.skin = "spaceshipAA"
            spaceshipType.glassSkin = "spaceshipAAGlass"
            spaceshipType.scale = 0.5
            spaceshipType.glassPosition = CGPoint(x: 0, y: 12 * spaceshipType.scale)
            
            spaceshipType.centerJet = true
            return spaceshipType
            }(), weaponType: {
                let weaponType = WeaponType(damage: 2, range: 150, fireRate: 0.25)
                weaponType.color = SKColor(red: 0/255, green: 226/255, blue: 240/255, alpha: 1)
                weaponType.shotSkin = "shotCA"
                
                weaponType.initSoundFileName = "laser3.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: "A ship with a niobium armor and a space machine gun, this machine gun concentrates small amounts of energy casting them at a high frequency and light years away but their projectiles do low damage."
        ),
        
        
        SpaceshipType(index: SpaceshipIndex.intrepidDestroyer.rawValue, name: "Intrepid Destroyer",
            bodyType: {
                let spaceshipType = BodyType(targetPriorityType: 0,
                    speed: 15, health: 7, shieldPower: 5, shieldRecharge: 5)
                spaceshipType.skin = "spaceshipAA"
                spaceshipType.glassSkin = "spaceshipAAGlass"
                spaceshipType.scale = 0.5
                spaceshipType.glassPosition = CGPoint(x: 0, y: 12 * spaceshipType.scale)
                
                spaceshipType.centerJet = true
                return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 30, range: 50, fireRate: 2)
                weaponType.color = SKColor(red: 105/255, green: 85/255, blue: 172/255, alpha: 1)
                weaponType.shotSkin = "shotAA"
                
                weaponType.initSoundFileName = "laser1.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: "A ship with a niobium shield and a very strong weapon, its cannon takes 2 seconds to accumulate energy and reaches enemies only a short distance, but its shots are fatal."
        ),
        
        SpaceshipType(index: SpaceshipIndex.intrepidSniper.rawValue, name: "Intrepid Sniper", bodyType: {
            let spaceshipType = BodyType(targetPriorityType: 0,
                speed: 15, health: 7, shieldPower: 5, shieldRecharge: 5)
            spaceshipType.skin = "spaceshipAA"
            spaceshipType.glassSkin = "spaceshipAAGlass"
            spaceshipType.scale = 0.5
            spaceshipType.glassPosition = CGPoint(x: 0, y: 12 * spaceshipType.scale)
            
            spaceshipType.centerJet = true
            return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 20, range: 200, fireRate: 4)
                weaponType.color = SKColor(red: 232/255, green: 161/255, blue: 0/255, alpha: 1)
                weaponType.shotSkin = "shotDA"
                
                weaponType.initSoundFileName = "laser9.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: "A ship with a niobium armor, its shots can reach the other side of the universe, no one is able to escape from its aim, so it has a high recharge time."
        ),
        
        SpaceshipType(index: SpaceshipIndex.tankerBlaster.rawValue, name: "Tanker Blaster",
            bodyType: {
                let spaceshipType = BodyType(targetPriorityType: 0,
                    speed: 10, health: 10, shieldPower: 5, shieldRecharge: 5)
                spaceshipType.skin = "spaceshipBA"
                spaceshipType.glassSkin = "spaceshipBAGlass"
                spaceshipType.scale = 0.5
                spaceshipType.glassPosition = CGPoint(x: 0, y: 5 * spaceshipType.scale)
                
                spaceshipType.leftJet = true
                spaceshipType.rightJet = true
                spaceshipType.jetBorderOffset = -5
                return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 7, range: 100, fireRate: 1)
                weaponType.color = SKColor(red: 100/255, green: 210/255, blue: 63/255, alpha: 1)
                weaponType.shotSkin = "shotBA"
                
                weaponType.initSoundFileName = "laser5.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: "This ship was the first to use ultra high tech mega metal technology super tough and waterproof, because it is a heavier metal that ship has a low speed."
        ),
        
        SpaceshipType(index: SpaceshipIndex.tankerStriker.rawValue, name: "Tanker Striker", bodyType: {
            let spaceshipType = BodyType(targetPriorityType: 0,
                speed: 10, health: 10, shieldPower: 5, shieldRecharge: 5)
            spaceshipType.skin = "spaceshipBA"
            spaceshipType.glassSkin = "spaceshipBAGlass"
            spaceshipType.scale = 0.5
            spaceshipType.glassPosition = CGPoint(x: 0, y: 5 * spaceshipType.scale)
            
            spaceshipType.leftJet = true
            spaceshipType.rightJet = true
            spaceshipType.jetBorderOffset = -5
            return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 1, range: 150, fireRate: 0.4)
                weaponType.color = SKColor(red: 0/255, green: 226/255, blue: 240/255, alpha: 1)
                weaponType.shotSkin = "shotCA"
                
                weaponType.initSoundFileName = "laser3.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: "A spacecraft with a tough armor, due to the weight of its armor itself can only be equipped with a light machine gun, does little damage but it is difficult to shoot down this space turtle."
        ),
        
        SpaceshipType(index: SpaceshipIndex.tankerDestroyer.rawValue, name: "Tanker Destroyer", bodyType: {
            let spaceshipType = BodyType(targetPriorityType: 0,
                speed: 10, health: 15, shieldPower: 5, shieldRecharge: 5)
            spaceshipType.skin = "spaceshipBA"
            spaceshipType.glassSkin = "spaceshipBAGlass"
            spaceshipType.scale = 0.5
            spaceshipType.glassPosition = CGPoint(x: 0, y: 5 * spaceshipType.scale)
            
            spaceshipType.leftJet = true
            spaceshipType.rightJet = true
            spaceshipType.jetBorderOffset = -5
            return spaceshipType
            }(), weaponType: {
                let weaponType = WeaponType(damage: 5, range: 50, fireRate: 2)
                weaponType.color = SKColor(red: 105/255, green: 85/255, blue: 172/255, alpha: 1)
                weaponType.shotSkin = "shotAA"
                
                weaponType.initSoundFileName = "laser1.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: ""
        ),
        
        SpaceshipType(index: SpaceshipIndex.tankerSniper.rawValue, name: "Tanker Sniper", bodyType: {
            let spaceshipType = BodyType(targetPriorityType: 0,
                speed: 10, health: 10, shieldPower: 5, shieldRecharge: 5)
            spaceshipType.skin = "spaceshipBA"
            spaceshipType.glassSkin = "spaceshipBAGlass"
            spaceshipType.scale = 0.5
            spaceshipType.glassPosition = CGPoint(x: 0, y: 5 * spaceshipType.scale)
            
            spaceshipType.leftJet = true
            spaceshipType.rightJet = true
            spaceshipType.jetBorderOffset = -5
            return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 15, range: 200, fireRate: 4)
                weaponType.color = SKColor(red: 232/255, green: 161/255, blue: 0/255, alpha: 1)
                weaponType.shotSkin = "shotDA"
                
                weaponType.initSoundFileName = "laser9.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: "Tanker and Sniper? Are you kidding me? This ship is incredible, in addition to his very tough armor his gun shoots at a long distance, is there anything better?"
        ),
        
        SpaceshipType(index: SpaceshipIndex.speederBlaster.rawValue, name: "Speeder Blaster", bodyType: {
            let spaceshipType = BodyType(targetPriorityType: 0,
                speed: 20, health: 5, shieldPower: 10, shieldRecharge: 5)
            spaceshipType.skin = "spaceshipCA"
            spaceshipType.glassSkin = "spaceshipCAGlass"
            spaceshipType.scale = 0.5
            spaceshipType.glassPosition = CGPoint(x: 0, y: 6 * spaceshipType.scale)
            
            spaceshipType.centerJet = true
            return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 15, range: 100, fireRate: 1)
                weaponType.color = SKColor(red: 100/255, green: 210/255, blue: 63/255, alpha: 1)
                weaponType.shotSkin = "shotBA"
                
                weaponType.initSoundFileName = "laser5.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: "The first ship of this type built, this type of ship is super economical, they take everything that could be weighed in her and equip them with the best weapons (the driver drives it on foot)."
        ),
        
        SpaceshipType(index: SpaceshipIndex.speederStriker.rawValue, name: "Speeder Striker", bodyType: {
            let spaceshipType = BodyType(targetPriorityType: 0,
                speed: 20, health: 5, shieldPower: 10, shieldRecharge: 5)
            spaceshipType.skin = "spaceshipCA"
            spaceshipType.glassSkin = "spaceshipCAGlass"
            spaceshipType.scale = 0.5
            spaceshipType.glassPosition = CGPoint(x: 0, y: 6 * spaceshipType.scale)
            
            spaceshipType.centerJet = true
            return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 3, range: 150, fireRate: 0.25)
                weaponType.color = SKColor(red: 0/255, green: 226/255, blue: 240/255, alpha: 1)
                weaponType.shotSkin = "shotCA"
                
                weaponType.initSoundFileName = "laser3.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: "The fastest machine gun in the space wild west, it's amazing the combination of speed of that weapon and the bursts of energy that it can fire."
        ),
        
        SpaceshipType(index: SpaceshipIndex.speederDestroyer.rawValue, name: "Speeder Destroyer", bodyType: {
            let spaceshipType = BodyType(targetPriorityType: 0,
                speed: 20, health: 5, shieldPower: 10, shieldRecharge: 5)
            spaceshipType.skin = "spaceshipCA"
            spaceshipType.glassSkin = "spaceshipCAGlass"
            spaceshipType.scale = 0.5
            spaceshipType.glassPosition = CGPoint(x: 0, y: 6 * spaceshipType.scale)
            
            spaceshipType.centerJet = true
            return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 40, range: 50, fireRate: 2)
                weaponType.color = SKColor(red: 105/255, green: 85/255, blue: 172/255, alpha: 1)
                weaponType.shotSkin = "shotAA"
                
                weaponType.initSoundFileName = "laser1.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: "A cannon with wings, this ship has the most powerful weapon in the whole universe, however its shots have a short range and its armor is weak but if it hits you ..."
        ),
        
        SpaceshipType(index: SpaceshipIndex.speederSniper.rawValue, name: "Speeder Sniper", bodyType: {
            let spaceshipType = BodyType(targetPriorityType: 0,
                speed: 20, health: 5, shieldPower: 10, shieldRecharge: 5)
            spaceshipType.skin = "spaceshipCA"
            spaceshipType.glassSkin = "spaceshipCAGlass"
            spaceshipType.scale = 0.5
            spaceshipType.glassPosition = CGPoint(x: 0, y: 6 * spaceshipType.scale)
            
            spaceshipType.centerJet = true
            return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 10, range: 200, fireRate: 1)
                weaponType.color = SKColor(red: 232/255, green: 161/255, blue: 0/255, alpha: 1)
                weaponType.shotSkin = "shotDA"
                
                weaponType.initSoundFileName = "laser9.mp3"
                return weaponType
            }(),
            spaceshipTypeDescription: "This ship has a sniper that in addition to shooting on the other side of the universe still recharges quickly, the problem is if the enemy approaches, its armor leaves to be desired in the next combat."
        )
    ]
    
    static var extraTypes: [SpaceshipType] = [
        
        SpaceshipType(index: 0, name: "Tutorial Meteor 1",
            bodyType: {
                let spaceshipType = BodyType(targetPriorityType: 0,
                    speed: 0, health: 5, shieldPower: 0, shieldRecharge: 0)
                spaceshipType.skin = "tutorialMeteor"
                spaceshipType.scale = 1
                
                spaceshipType.centerJet = true
                return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 0, range: 100, fireRate: 1)
                return weaponType
            }(),
            spaceshipTypeDescription: ""
            
        ),
        
        SpaceshipType(index: 1, name: "Tutorial Meteor 2",
            bodyType: {
                let spaceshipType = BodyType(targetPriorityType: 0,
                    speed: 0, health: 5, shieldPower: 0, shieldRecharge: 0)
                spaceshipType.skin = "tutorialMeteor2"
                spaceshipType.scale = 1
                
                spaceshipType.centerJet = true
                return spaceshipType
            }(),
            weaponType: {
                let weaponType = WeaponType(damage: 0, range: 100, fireRate: 1)
                return weaponType
            }(),
            spaceshipTypeDescription: ""
            
        )
        
    ]
}
