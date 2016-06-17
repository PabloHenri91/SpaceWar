//
//  Spaceship.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/19/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Spaceship: Control {
    
    static var selectedSpaceship:Spaceship?
    
    var type:SpaceShipType!
    var level:Int!
    
    //Vida e Escudo de Energia
    var health:Int!
    var maxHealth:Int!
    var energyShield:Int!
    var maxEnergyShield:Int!
    var shieldRechargeInterval:Int!
    
    var speedAtribute:Int!
    var armor:Int!
    var shieldPower:Int!
    var shieldRecharge:Int!
    
    var weapon:Weapon?
    
    var spaceshipData:SpaceshipData?
    
    var spriteNode:SKSpriteNode!
    
    var targetNode:SKNode?
    
    //Movement
    var destination = CGPoint.zero
    var needToMove = false
    var rotationToDestination:CGFloat = 0
    var totalRotationToDestination:CGFloat = 0
    var startingPosition = CGPoint.zero
    
    var maxAngularVelocity:CGFloat = 3
    var force:CGFloat = 25
    var angularImpulse:CGFloat = 0.0005
    var maxVelocitySquared:CGFloat = 0
    
    var isInsideAMothership = true
    
    var healthBar:HealthBar!
    
    override var description: String {
        return "\nSpaceship\n" +
            "level: " + level.description + "\n" +
            "health: " + health.description  + "\n" +
            "maxHealth: " + maxHealth.description  + "\n" +
            "energyShield: " + energyShield.description  + "\n" +
            "maxEnergyShield: " + maxEnergyShield.description  + "\n" +
            "shieldRechargeInterval: " + shieldRechargeInterval.description  + "\n" +
            "speedAtribute: " + speedAtribute.description  + "\n" +
            "armor: " + armor.description  + "\n" +
            "shieldPower: " + shieldPower.description  + "\n" +
            "shieldRecharge: " + shieldRecharge.description  + "\n"
    }

    
    override init() {
        fatalError("NÃO IMPLEMENTADO")
    }
    
    init(type:Int, level:Int) {
        super.init()
        self.load(type: type, level: level)
    }
    
    init(spaceshipData:SpaceshipData) {
        super.init()
        self.spaceshipData = spaceshipData
        self.load(type: spaceshipData.type.integerValue, level: spaceshipData.level.integerValue)
        
        if let weaponData = spaceshipData.weapons.anyObject() as? WeaponData {
            self.weapon = (Weapon(weaponData: weaponData))
        }
        
        if let weapon = self.weapon {
            self.addChild(weapon)
        }
    }
    
    func loadHealthBar(gameWorld:GameWorld, borderColor:SKColor) {
        self.healthBar = HealthBar(size: self.calculateAccumulatedFrame().size, borderColor: borderColor)
        gameWorld.addChild(self.healthBar)
    }
    
    func loadAllyDetails() {
        let spriteNode = SKSpriteNode(imageNamed: "spaceshipAlly")
        spriteNode.texture?.filteringMode = Display.filteringMode
        self.spriteNode.addChild(spriteNode)
    }
    
    func loadEnemyDetails() {
        let spriteNode = SKSpriteNode(imageNamed: "spaceshipEnemy")
        spriteNode.texture?.filteringMode = Display.filteringMode
        self.spriteNode.addChild(spriteNode)
    }
    
    func increaseTouchArea() {
        let spriteNodeTest = SKSpriteNode(color: SKColor.clearColor(), size: CGSize(width: 64, height: 64))
        spriteNodeTest.texture?.filteringMode = Display.filteringMode
        self.spriteNode.addChild(spriteNodeTest)
    }
    
    private func load(type type:Int, level:Int) {
        
        self.type = Spaceship.types[type]
        
        self.level = level
        
        self.speedAtribute = GameMath.spaceshipSpeedAtribute(level: self.level, type: self.type)
        self.armor = GameMath.spaceshipArmor(level: self.level, type: self.type)
        self.shieldPower = GameMath.spaceshipShieldPower(level: self.level, type: self.type)
        self.shieldRecharge = GameMath.spaceshipShieldRecharge(level: self.level, type: self.type)
        
        self.health = GameMath.spaceshipMaxHealth(level: self.level, armor: self.armor)
        self.maxHealth = health
        
        self.energyShield = GameMath.spaceshipMaxShield(level: self.level, shieldPower: self.shieldPower)
        self.maxEnergyShield = energyShield
        self.shieldRechargeInterval = GameMath.spaceshipShieldRechargeInterval(shieldRechargeInterval: self.shieldRecharge)
        
        //Gráfico
        self.spriteNode = SKSpriteNode(imageNamed: self.type.skins.first!)//TODO: remover gamb
        self.spriteNode.texture?.filteringMode = Display.filteringMode
        self.addChild(self.spriteNode)
        
        self.loadPhysics(rectangleOfSize: self.spriteNode.size)
        
        self.increaseTouchArea()
    }
    
    func loadPhysics(rectangleOfSize size:CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.dynamic = false
        
        self.setBitMasksToMothershipSpaceship()
        
        self.physicsBody?.linearDamping = 2
        self.physicsBody?.angularDamping = 2
        self.physicsBody?.friction = 0
        
        self.maxVelocitySquared = GameMath.spaceshipMaxVelocitySquared(speed: self.speedAtribute)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchEnded() {
        if let spaceship = Spaceship.selectedSpaceship {
            spaceship.spriteNode.color = SKColor.blackColor()
            spaceship.spriteNode.colorBlendFactor = 0
        }
        
        Spaceship.selectedSpaceship = self
        
        self.physicsBody?.dynamic = true
        self.spriteNode.color = SKColor.blackColor()
        self.spriteNode.colorBlendFactor = 0.5
    }
    
    static func touchEnded(touch: UITouch) {
        if let spaceship = Spaceship.selectedSpaceship {
            if let parent = spaceship.parent {
                
                //Precisa mover, esqueca o que está fazendo
                spaceship.targetNode = nil
                
                spaceship.destination = touch.locationInNode(parent)
                spaceship.needToMove = true
            }
        }
    }
    
    static func retreat() {
        if let spaceship = Spaceship.selectedSpaceship {
            //Precisa mover, esqueca o que está fazendo
            spaceship.targetNode = nil
            
            spaceship.destination = spaceship.startingPosition
            spaceship.needToMove = true
            
            spaceship.spriteNode.color = SKColor.blackColor()
            spaceship.spriteNode.colorBlendFactor = 0
            
            spaceship.setBitMasksToMothershipSpaceship()
        }
        
        Spaceship.selectedSpaceship = nil
    }
    
    func update(enemyMothership enemyMothership:Mothership, enemySpaceships:[Spaceship]) {
        
        self.move(enemyMothership: enemyMothership, enemySpaceships: enemySpaceships)
        
        self.healthBar.updateUp(position: self.position)
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
        self.position = self.startingPosition
        self.zRotation = 0
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.angularVelocity = 0
        self.physicsBody?.dynamic = false
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
    
    func nearestTarget(enemyMothership enemyMothership:Mothership, enemySpaceships:[Spaceship]) -> SKNode? {
        
        var currentTarget:SKNode? = nil
        
        for targetPriorityType in self.type.targetPriority {
            switch targetPriorityType {
            case TargetType.spaceships:
                for enemySpaceship in enemySpaceships {
                    
                    if enemySpaceship.canBeTarget() {
                        
                        if currentTarget != nil {
                            if CGPoint.distance(self.destination, enemySpaceship.position) < CGPoint.distance(self.position, currentTarget!.position) {
                                currentTarget = enemySpaceship
                            }
                        } else {
                            currentTarget = enemySpaceship
                        }
                        
                    }
                }
                break
                
            case TargetType.mothership:
                if enemyMothership.health > 0 {
                    currentTarget = enemyMothership
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
    
    func fire() {
        self.weapon?.fire()
    }
    
    func getShot(shot:Shot?) {
        if let someShot = shot {
            self.health = self.health - someShot.demage
            someShot.demage = 0
            someShot.removeFromParent()
            
            self.healthBar.update(self.health, maxHealth: self.maxHealth)
        }
    }
    
    func move(enemyMothership enemyMothership:Mothership, enemySpaceships:[Spaceship]) {
        
        if self.health > 0 {
            if (self.needToMove) {
                
                if CGPoint.distance(self.position, self.destination) < 32 {
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
                            self.rotateToPoint(targetNode.position)
                            if abs(self.totalRotationToDestination) <= 0.1 {
                                self.fire()
                            }
                        }
                    }
                    
                    if let spaceship = targetNode as? Spaceship {
                        
                        if !spaceship.canBeTarget() {
                            self.targetNode = nil
                        } else {
                            self.rotateToPoint(targetNode.position)
                            if abs(self.totalRotationToDestination) <= 0.1 {
                                self.fire()
                            }
                        }
                    }
                    
                } else {
                    if !self.isInsideAMothership {
                        self.targetNode = self.nearestTarget(enemyMothership: enemyMothership, enemySpaceships: enemySpaceships)
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
                        fatalError()
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
                        fatalError()
                        break
                    }
                }()
                break
                
            default:
                fatalError()
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
                        fatalError()
                        break
                    }
                }()
                break
                
            case GameWorld.categoryBitMask.mothershipSpaceship.rawValue:
                {
                    switch otherPhysicsBody.categoryBitMask {
                        
                    case GameWorld.categoryBitMask.mothership.rawValue:
                        self.isInsideAMothership = false
                        if self.destination != self.startingPosition {
                            self.setBitMasksToSpaceship()
                        }
                        break
                        
                    default:
                        fatalError()
                        break
                    }
                }()
                break
                
            default:
                fatalError()
                break
            }
        }
    }
    
    func addWeapon(weapon:Weapon) {
        self.weapon = weapon
        
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
}

public enum TargetType:Int {
    case mothership
    case spaceships
    case towers
}

class SpaceShipType {
    
    var skins = [String]()
    
    var maxLevel:Int
    
    var targetPriority:[TargetType]
    
    var speedBonus:Int
    var armorBonus:Int
    var shieldPowerBonus:Int
    var shieldRechargeBonus:Int
    
    var speedBonusPerLevel:Int
    var armorBonusPerLevel:Int
    var shieldPowerBonusPerLevel:Int
    var shieldRechargeBonusPerLevel:Int
    
    init(maxLevel:Int, targetPriorityType:Int, speed:Int, armor:Int, shieldPower:Int, shieldRecharge:Int,
         speedPerLevel:Int, armorPerLevel:Int, shieldPowerPerLevel:Int, shieldRechargePerLevel:Int) {
        
        self.maxLevel = maxLevel
        
        self.targetPriority = Spaceship.targetPriorityTypes[targetPriorityType]
        
        self.speedBonus = speed
        self.armorBonus = armor
        self.shieldPowerBonus = shieldPower
        self.shieldRechargeBonus = shieldRecharge
        
        self.speedBonusPerLevel = speedPerLevel
        self.armorBonusPerLevel = armorPerLevel
        self.shieldPowerBonusPerLevel = shieldPowerPerLevel
        self.shieldRechargeBonusPerLevel = shieldRechargePerLevel
    }
}

extension Spaceship {
    
    static var targetPriorityTypes = [
        [TargetType.spaceships, TargetType.towers, TargetType.mothership],
        
        [TargetType.towers, TargetType.mothership]
    ]
    
    static var types:[SpaceShipType] = [
        {
            let spaceShipType = SpaceShipType(maxLevel: 2, targetPriorityType: 1,
                speed: 10, armor: 10, shieldPower: 10, shieldRecharge: 10,
                speedPerLevel: 1, armorPerLevel: 1, shieldPowerPerLevel: 1, shieldRechargePerLevel: 1)
            spaceShipType.skins = [
                "spaceshipAA",
                "spaceshipAB"
            ]
            return spaceShipType
        }(),
        
        {
            let spaceShipType = SpaceShipType(maxLevel: 2, targetPriorityType: 0,
            speed: 10, armor: 10, shieldPower: 10, shieldRecharge: 10,
            speedPerLevel: 1, armorPerLevel: 1, shieldPowerPerLevel: 1, shieldRechargePerLevel: 1)
            spaceShipType.skins = [
                "spaceshipBA",
                "spaceshipBB"
            ]
            return spaceShipType
        }(),
        
        {
            let spaceShipType = SpaceShipType(maxLevel: 2, targetPriorityType: 0,
            speed: 10, armor: 10, shieldPower: 10, shieldRecharge: 10,
            speedPerLevel: 1, armorPerLevel: 1, shieldPowerPerLevel: 1, shieldRechargePerLevel: 1)
            spaceShipType.skins = [
                "spaceshipCA",
                "spaceshipCB"
            ]
            return spaceShipType
        }()
    ]
}
