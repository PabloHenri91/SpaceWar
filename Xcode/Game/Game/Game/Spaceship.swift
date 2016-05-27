//
//  Spaceship.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/19/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Spaceship: Control {
    
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
        let spriteNode = SKSpriteNode(imageNamed: self.type.skins.first!)//TODO: remover gamb
        spriteNode.texture?.filteringMode = .Nearest
        self.addChild(spriteNode)
        
        //self.loadPhysics(rectangleOfSize: spriteNode.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
