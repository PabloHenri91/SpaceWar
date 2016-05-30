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
    
    var weapons = Set<Weapon>()
    
    var spaceshipData:SpaceshipData?
    
    var spriteNode:SKSpriteNode!
    
    //Movement
    var destination = CGPoint.zero
    var needToMove = false
    var auxRotation:CGFloat = 0
    var maxAngularVelocity:CGFloat = 3
    var force:CGFloat = 25
    var startingPosition = CGPoint.zero
    
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
        
        for item in spaceshipData.weapons {
            if let weaponData = item as? WeaponData {
                self.weapons.insert(Weapon(weaponData: weaponData))
            }
        }
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
        self.spriteNode.texture?.filteringMode = .Nearest
        self.addChild(self.spriteNode)
        
        self.loadPhysics(rectangleOfSize: self.spriteNode.size)
    }
    
    func loadPhysics(rectangleOfSize size:CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.dynamic = true
        
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.spaceship.rawValue
        self.physicsBody?.collisionBitMask = GameWorld.collisionBitMask.spaceship
        self.physicsBody?.contactTestBitMask = GameWorld.contactTestBitMask.spaceship
        
        self.physicsBody?.linearDamping = 2
        self.physicsBody?.angularDamping = 2
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
                
                spaceship.destination = touch.locationInNode(parent)
                spaceship.needToMove = true
            }
        }
    }
    
    static func retreat() {
        if let spaceship = Spaceship.selectedSpaceship {
            spaceship.destination = spaceship.startingPosition
            spaceship.needToMove = true
            
            spaceship.spriteNode.color = SKColor.blackColor()
            spaceship.spriteNode.colorBlendFactor = 0
        }
        
        Spaceship.selectedSpaceship = nil
    }
    
    func update() {
        self.move()
    }
    
    func move() {
        if (self.needToMove) {
            
//            if let nodePosition = self.targetNode?.position {
//                self.destination = nodePosition
//            }
            
            if CGPoint.distance(self.position, self.destination) < 64 {
                self.needToMove = false
                
                if self.destination == self.startingPosition {
                    self.position = self.startingPosition
                    self.zRotation = 0
                    self.physicsBody?.velocity = CGVector.zero
                    self.physicsBody?.angularVelocity = 0
                    self.physicsBody?.dynamic = false
                }
                
            } else {
                let dx = Float(self.destination.x - self.position.x)
                let dy = Float(self.destination.y - self.position.y)
                self.auxRotation = CGFloat(-atan2f(dx, dy))
                var totalRotation = self.auxRotation - self.zRotation
                
                
                if(abs(self.physicsBody!.angularVelocity) < self.maxAngularVelocity) {
                    
                    while(totalRotation < -CGFloat(M_PI)) { totalRotation += CGFloat(M_PI * 2) }
                    while(totalRotation >  CGFloat(M_PI)) { totalRotation -= CGFloat(M_PI * 2) }
                    
                    self.physicsBody?.applyAngularImpulse(totalRotation * 0.0005)
                }
                
                if(abs(totalRotation) < 1) {
                    self.physicsBody?.applyForce(CGVector(dx: -sin(self.zRotation) * self.force, dy: cos(self.zRotation) * self.force))
                }
            }
        }
    }
    
    func addWeapon(weapon:Weapon) {
        self.weapons.insert(weapon)
        
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
        self.weapons.remove(weapon)
        
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
            let spaceShipType = SpaceShipType(maxLevel: 2, targetPriorityType: 0,
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
