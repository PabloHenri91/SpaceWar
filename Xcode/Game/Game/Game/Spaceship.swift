//
//  Spaceship.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/19/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Spaceship: Control {
    
    static var spaceshipList = Set<Spaceship>()
    
    static var selectedSpaceship:Spaceship?
    
    enum zPositions: CGFloat {
        case skin
        case teamDetail
        case weaponDetail
        case levelDetail
        case selectedDetail
        case touchAreaEffect
    }
    
    var type:SpaceshipType!
    var level:Int!
    
    //Vida e Escudo de Energia
    var health:Int!
    var maxHealth:Int!
    var energyShield:Int!
    var maxEnergyShield:Int!

    
    var speedAtribute:Int!
    var shieldPower:Int!
    var shieldRecharge:Int!
    
    var weapon:Weapon?
    var weaponRangeBonus:CGFloat = 0
    
    var spaceshipData:SpaceshipData?
    
    var spriteNode:SKSpriteNode!
    var weaponSpriteNode:SKSpriteNode?
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
    
    var healthBar:HealthBar!
    var weaponRangeSprite:SKShapeNode!
    
    //Respawn
    var canRespawn = true
    var deathCount = 0
    var deathTime = 0.0
    var lastSecond = 0.0
    
    var healPerFrame = 1
    
    //statistics
    var isAlly = true

    var explosionSoundEffect:SoundEffect!
    
    var labelLevel:Label!
    
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

    
    override init() {
        fatalError("NÃO IMPLEMENTADO")
    }
    
    init(type:Int, level:Int, loadPhysics:Bool = false) {
        super.init()
        self.load(type: type, level: level, loadPhysics:loadPhysics)
    }
    
    init(extraType:Int, level:Int, loadPhysics:Bool = false) {
        super.init()
        self.load(extraType: extraType, level: level, loadPhysics: loadPhysics)
    }
    
    init(spaceshipData:SpaceshipData, loadPhysics:Bool = false) {
        super.init()
        self.spaceshipData = spaceshipData
        self.load(type: spaceshipData.type.integerValue, level: spaceshipData.level.integerValue, loadPhysics: loadPhysics)
        
        if let weaponData = spaceshipData.weapons.anyObject() as? WeaponData {
            self.weapon = (Weapon(weaponData: weaponData))
        }
        
        if let weapon = self.weapon {
            self.addChild(weapon)
            self.loadWeaponDetail()
        }
    }
    
    func loadHealthBar(gameWorld:GameWorld, borderColor:SKColor) {
        let size = self.calculateAccumulatedFrame().size
        self.healthBar = HealthBar(size: size, borderColor: borderColor)
        gameWorld.addChild(self.healthBar)
    }
    
    func loadWeaponRangeSprite(gameWorld:GameWorld) {
        if let weapon = self.weapon {
            self.weaponRangeSprite = SKShapeNode(circleOfRadius: weapon.rangeInPoints)
            self.weaponRangeSprite.strokeColor = SKColor.whiteColor()
            self.weaponRangeSprite.fillColor = SKColor.clearColor()
            self.weaponRangeSprite.position = self.position
            self.weaponRangeSprite.alpha = 0
            gameWorld.addChild(self.weaponRangeSprite)
        }
    }
    
    func showWeaponRangeSprite() {
        if let _ = self.weapon {
            self.weaponRangeSprite.alpha = 1
        }
    }
    
    func loadWeaponDetail() {
        if let weaponSpriteNode = self.weaponSpriteNode {
            weaponSpriteNode.removeFromParent()
        }
        
        if let weapon = self.weapon {
            self.weaponSpriteNode = SKSpriteNode(imageNamed: GameMath.weaponSkinImageName(level: weapon.level, type: weapon.type))
            self.weaponSpriteNode?.texture?.filteringMode = Display.filteringMode
            self.weaponSpriteNode?.zPosition = zPositions.weaponDetail.rawValue
            self.addChild(self.weaponSpriteNode!)
        }
    }
    
    func loadAllyDetails() {
        self.isAlly = true
        let spriteNode = SKSpriteNode(imageNamed: "spaceshipAlly")
        spriteNode.texture?.filteringMode = Display.filteringMode
        spriteNode.zPosition = zPositions.teamDetail.rawValue
        self.addChild(spriteNode)
    }
    
    func loadEnemyDetails() {
        self.isAlly = false
        let spriteNode = SKSpriteNode(imageNamed: "spaceshipEnemy")
        spriteNode.texture?.filteringMode = Display.filteringMode
        spriteNode.zPosition = zPositions.teamDetail.rawValue
        self.spriteNode.addChild(spriteNode)
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
        self.load(loadPhysics)
    }
    
    private func load(extraType type:Int, level:Int, loadPhysics:Bool) {
        self.type = Spaceship.extraTypes[type]
        self.level = level
        self.load(loadPhysics)
    }
    
    func loadSoundEffects() {
        self.explosionSoundEffect = SoundEffect(soundType: SoundEffect.effectTypes.explosion, node: self)
    }
    
    private func load(loadPhysics:Bool) {
        self.loadSoundEffects()
        self.speedAtribute = GameMath.spaceshipSpeedAtribute(level: self.level, type: self.type)
        self.health = GameMath.spaceshipMaxHealth(level: self.level, type: self.type)
        self.maxHealth = health
        self.shieldPower = GameMath.spaceshipShieldPower(level: self.level, type: self.type)
        self.shieldRecharge = GameMath.spaceshipShieldRecharge(level: self.level, type: self.type)
        
        //TODO: GameMath.calculatedHealPerFrame
        let calculatedHealPerFrame = Int(self.maxHealth/5/60)
        if calculatedHealPerFrame > self.healPerFrame {
            self.healPerFrame = calculatedHealPerFrame
        }
        
        self.energyShield = GameMath.spaceshipShieldPower(level: self.level, type: self.type)
        self.maxEnergyShield = energyShield
        
        //Gráfico
        self.spriteNode = SKSpriteNode(imageNamed: GameMath.spaceshipSkinImageName(level: self.level, type: self.type))
        self.spriteNode.texture?.filteringMode = Display.filteringMode
        self.spriteNode.zPosition = zPositions.skin.rawValue
        self.addChild(self.spriteNode)
        
        self.selectedSpriteNode = SKSpriteNode(color: SKColor(red: 1, green: 1, blue: 1, alpha: 0.5), size: self.spriteNode.size)
        self.selectedSpriteNode.hidden = true
        self.selectedSpriteNode.zPosition = zPositions.selectedDetail.rawValue
        self.addChild(self.selectedSpriteNode)
        
        self.weaponRangeBonus = self.spriteNode.size.height/2
        
        if loadPhysics {
            self.loadPhysics(rectangleOfSize: self.spriteNode.size)
        }
        
        self.increaseTouchArea()
        
        self.labelLevel = Label(color: SKColor(red: 0, green: 0, blue: 0, alpha: 0.5), text: self.level.description, fontSize: 16, x: 0, y: 0)
        self.labelLevel.zPosition = zPositions.levelDetail.rawValue
        self.addChild(self.labelLevel)
        
        Spaceship.spaceshipList.insert(self)
    }
    
    func loadPhysics(rectangleOfSize size:CGSize) {
        
        self.zPosition = GameWorld.zPositions.spaceship.rawValue
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
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
        spriteNode.position = self.destination
        self.parent?.addChild(spriteNode)
        
        spriteNode.runAction(SKAction.resizeToWidth(0, height: 1, duration: 0.5))
        spriteNode.runAction(SKAction.fadeOutWithDuration(0.5), completion: { [weak spriteNode] in
            spriteNode?.removeFromParent()
        })
        self.showWeaponRangeSprite()
    }
    
    func touchEnded() {
        
        if self == Spaceship.selectedSpaceship {
            if !self.isInsideAMothership {
                self.targetNode = nil
                self.needToMove = false
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
        
        self.move(enemyMothership: enemyMothership, enemySpaceships: enemySpaceships, allySpaceships:allySpaceships)
        
        self.healthBar.update(position: self.position)
        
        //TODO: exportar para função
        if let _ = self.weaponRangeSprite {
            self.weaponRangeSprite.position = self.position
            if self.weaponRangeSprite.alpha > 0 {
                self.weaponRangeSprite.alpha -= 0.01666666667
            }
        }
        //
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
    
    func canBeTarget(spaceship:Spaceship) -> Bool {
        
        if self.isInsideAMothership {
            return false
        }
        
        if self.health <= 0 {
            return false
        }
        
        if let spaceshipWeapon = spaceship.weapon {
            let range = spaceshipWeapon.rangeInPoints + spaceship.weaponRangeBonus + self.weaponRangeBonus
            if CGPoint.distance(self.position, spaceship.position) > range {
                return false
            }
        } else {
            return false
        }
        
        return true
    }
    
    func nearestTarget(enemyMothership enemyMothership:Mothership?, enemySpaceships:[Spaceship]) -> SKNode? {
        
        var currentTarget:SKNode? = nil
        
        for targetPriorityType in self.type.targetPriority {
            switch targetPriorityType {
            case TargetType.spaceships:
                for enemySpaceship in enemySpaceships {
                    
                    if enemySpaceship.canBeTarget(self) {
                        
                        if currentTarget != nil {
                            if CGPoint.distanceSquared(self.position, enemySpaceship.position) < CGPoint.distanceSquared(self.position, currentTarget!.position) {
                                currentTarget = enemySpaceship
                            }
                        } else {
                            currentTarget = enemySpaceship
                        }
                        
                    }
                }
                break
                
            case TargetType.mothership:
                if let enemyMothership = enemyMothership {
                    if enemyMothership.canBeTarget(self) {
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
    
    func fire(allySpaceships allySpaceships:[Spaceship]) {
        var canfire = true
        
        for allySpaceship in allySpaceships {
            
            if allySpaceship != self && allySpaceship.canBeTarget(self) {
                if CGPoint.distanceSquared(self.position, allySpaceship.position) < CGPoint.distanceSquared(self.position, self.targetNode!.position) {
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
        
        
        if canfire {
            self.weapon?.fire(self.weaponRangeBonus)
        } else {
            self.targetNode = nil
        }
        
    }
    
    func getShot(shot:Shot?, contact: SKPhysicsContact?) {
        
        if let shot = shot {
            
            if shot.shooter == self {
                return
            }
            
            if self.health > 0 && self.health - shot.damage <= 0 {
                self.die()
                if let spaceship = shot.shooter as? Spaceship {
                    if spaceship.isAlly {
                        if let spaceshipData = spaceship.spaceshipData {
                            spaceshipData.killCount = spaceshipData.killCount.integerValue + 1
                            Metrics.killerSpaceship(spaceship.type.name + " " + spaceship.weapon!.type.name)
                        }
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
            
            self.healthBar.update(self.health, maxHealth: self.maxHealth)
        }
    }
    
    func respawn() {
        self.loadPhysics(rectangleOfSize: self.spriteNode.size)
        
        if Spaceship.selectedSpaceship == self {
            Spaceship.retreatSelectedSpaceship()
        } else {
            self.retreat()
        }
        self.resetToStartingPosition()
        
        self.hidden = false
        
        self.health = self.maxHealth
        self.healthBar.update(1, maxHealth: 1)
        self.healthBar.update(position: self.position)
        self.healthBar.hidden = false
    }
    
    func die() {
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
        
        self.hidden = true
        self.physicsBody = nil
        self.healthBar.hidden = true
    }
    
    func heal() {
        if self.health < self.maxHealth {
            self.health = self.health + self.healPerFrame
            if self.health > self.maxHealth {
                self.health = self.maxHealth
            }
            self.healthBar.update(self.health, maxHealth: self.maxHealth)
        }
    }
    
    func move(enemyMothership enemyMothership:Mothership?, enemySpaceships:[Spaceship], allySpaceships:[Spaceship]) {
       
        if self.health > 0 {
            
            if self.isInsideAMothership {
                
                if CGPoint.distanceSquared(self.position, self.startingPosition) < 256 {
                    self.heal()
                }
                
                if self.destination != self.startingPosition {
                    if let physicsBody = self.physicsBody {
                        let velocitySquared = (physicsBody.velocity.dx * physicsBody.velocity.dx) + (physicsBody.velocity.dy * physicsBody.velocity.dy)
                        
                        self.rotateToPoint(CGPoint(x: self.position.x, y: -self.position.y * 2))
                        
                        if velocitySquared < self.maxVelocitySquared {
                            self.physicsBody?.applyForce(CGVector(dx: -sin(self.zRotation) * self.force, dy: cos(self.zRotation) * self.force))
                        }
                    }
                }
            }
            
            if (self.needToMove) {

                if CGPoint.distanceSquared(self.position, self.destination) < 1024 {
               
                    self.needToMove = false
                    
                    if self.destination == self.startingPosition {
                        self.resetToStartingPosition()
                    } else {
                        if !self.isInsideAMothership {
                            self.targetNode = self.nearestTarget(enemyMothership: enemyMothership, enemySpaceships: enemySpaceships)
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
                        }
                    }
                }
                
            } else {
                
                if let targetNode = self.targetNode {
                    
                    if let mothership = targetNode as? Mothership {
                        if mothership.health <= 0 {
                            self.targetNode = nil
                        } else {
                            self.rotateToPoint(CGPoint(x: self.position.x, y: targetNode.position.y))
                            if abs(self.totalRotationToDestination) <= 0.05 {
                                self.fire(allySpaceships: allySpaceships)
                            }
                        }
                    }
                    
                    if let spaceship = targetNode as? Spaceship {
                        
                        if !spaceship.canBeTarget(self) {
                            self.targetNode = nil
                        } else {
                            self.rotateToPoint(targetNode.position)
                            if abs(self.totalRotationToDestination) <= 0.05 {
                                self.fire(allySpaceships: allySpaceships)
                            }
                        }
                    }
                    
                } else {
                    if !self.isInsideAMothership {
                        self.targetNode = self.nearestTarget(enemyMothership: enemyMothership, enemySpaceships: enemySpaceships)
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
                        if self.destination != self.startingPosition {
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
    
    func addWeapon(weapon:Weapon) {
        self.weapon = weapon
        self.loadWeaponDetail()
        self.addChild(weapon)
        
        if let spaceshipData = self.spaceshipData {
            if let weaponData = weapon.weaponData {
                spaceshipData.addWeaponData(weaponData)
                if let player = spaceshipData.parentPlayer {
                    player.removeWeaponData(weaponData)
                }
            }
        }
    }
    
    func removeWeapon(weapon:Weapon) {
        self.weapon = nil
        
        if let spaceshipData = self.spaceshipData {
            if let weaponData = weapon.weaponData {
                spaceshipData.removeWeaponData(weaponData)
                if let player = spaceshipData.parentPlayer {
                    player.addWeaponData(weaponData)
                }
            }
        }
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
            for item in spaceshipData.weapons {
                if let weaponData = item as? WeaponData {
                    weaponData.level = NSNumber(integer: weaponData.level.integerValue + 1)
                }
            }
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
        label.zPosition = GameWorld.zPositions.damageEffect.rawValue
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
        self.healthBar?.removeFromParent()
        self.weaponSpriteNode?.removeFromParent()
        Spaceship.spaceshipList.remove(self)
        super.removeFromParent()
    }
}

public enum TargetType:Int {
    case mothership
    case spaceships
    case towers
}

class SpaceshipType {
    
    enum rarityTypes {
        case commom
        case rare
        case epic
        case legendary
    }
    
    var rarity:rarityTypes = .commom
    
    var skins = [String]()
    
    var maxLevel:Int
    
    var targetPriority:[TargetType]
    
    var name:String = ""
    var spaceshipDescription:String = ""
    
    var speedBonus:Int
    var healthBonus:Int
    var shieldPowerBonus:Int
    var shieldRechargeBonus:Int
    
    var index:Int!


    
    init(maxLevel:Int, targetPriorityType:Int, speed:Int, health:Int, shieldPower:Int, shieldRecharge:Int) {
        
        self.maxLevel = maxLevel
        
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
            for weaponType in Weapon.types {
                let spaceshipData = memoryCard.newSpaceshipData(type: spaceshipType.index)
                let weaponData = memoryCard.newWeaponData(type: weaponType.index)
                spaceshipData.addWeaponData(weaponData)
                playerData.unlockSpaceshipData(spaceshipData)
            }
        }
    }
    
    static var extraTypes:[SpaceshipType] = [
        {
            let spaceshipType = SpaceshipType(maxLevel: 2, targetPriorityType: 0,
                speed: 0, health: 5, shieldPower: 0, shieldRecharge: 0)
            spaceshipType.skins = [
                "tutorialMeteor"
            ]
            spaceshipType.index = 0
            return spaceshipType
        }()
    ]
    
    static var targetPriorityTypes = [
        [TargetType.spaceships, TargetType.towers, TargetType.mothership],
        
        [TargetType.towers, TargetType.mothership]
    ]
    
    static var types:[SpaceshipType] = [
        {
            let spaceshipType = SpaceshipType(maxLevel: 100, targetPriorityType: 0,
                speed: 7, health: 7, shieldPower: 5, shieldRecharge: 5)
            spaceshipType.skins = [
                "spaceshipCA",
                "spaceshipCB"
            ]
            spaceshipType.name = "Spaceship"
            spaceshipType.spaceshipDescription = "The firs battle spaceship invented"
            spaceshipType.rarity = .commom
            spaceshipType.index = 0
            return spaceshipType
        }(),
        
        {
            let spaceshipType = SpaceshipType(maxLevel: 100, targetPriorityType: 0,
            speed: 5, health: 10, shieldPower: 5, shieldRecharge: 5)
            spaceshipType.skins = [
                "spaceshipAA",
                "spaceshipAB"
            ]
            spaceshipType.name = "Space Tanker"
            spaceshipType.spaceshipDescription = "Can hold a great amount of damage."
            spaceshipType.rarity = .commom
            spaceshipType.index = 1
            return spaceshipType
        }(),
        
        {
            let spaceshipType = SpaceshipType(maxLevel: 100, targetPriorityType: 0,
            speed: 10, health: 5, shieldPower: 10, shieldRecharge: 5)
            spaceshipType.skins = [
                "spaceshipBA",
                "spaceshipBB"
            ]
            
            spaceshipType.name = "Space Speeder"
            spaceshipType.spaceshipDescription = "Flies at the speed of light."
            spaceshipType.rarity = .commom
            spaceshipType.index = 2
            return spaceshipType
        }()
    ]
}
