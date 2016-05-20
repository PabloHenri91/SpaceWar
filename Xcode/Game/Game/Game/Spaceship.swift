//
//  Spaceship.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/19/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Spaceship: Control {
    
    var type:SpaceShipType
    var level:Int
    
    //Vida e Escudo de Energia
    var health:Int
    var maxHealth:Int
    var energyShield:Int
    var maxEnergyShield:Int
    var shieldRechargeInterval:Int
    
    var speedAtribute:Int
    var armor:Int
    var shieldPower:Int
    var shieldRecharge:Int
    
    override init() {
        
        self.type = Spaceship.types[0]
        
        self.level = 1
        
        self.speedAtribute = self.type.speedBonus + (self.level * self.type.speedBonusPerLevel)
        self.armor = self.type.armorBonus + (self.level * self.type.armorBonusPerLevel)
        self.shieldPower = self.type.shieldPowerBonus + (self.level * self.type.shieldPowerBonusPerLevel)
        self.shieldRecharge = self.type.shieldRechargeBonus + (self.level * self.type.shieldRechargeBonusPerLevel)
        
        self.health = GameMath.spaceshipMaxHealth(level: self.level, armor: self.armor)
        self.maxHealth = health
        
        self.energyShield = GameMath.spaceshipMaxShield(level: self.level, shieldPower: self.shieldPower)
        self.maxEnergyShield = energyShield
        self.shieldRechargeInterval = GameMath.spaceshipShieldRechargeInterval(shieldRechargeInterval: self.shieldRecharge)
        
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public enum TargetType:Int {
    case mothership
    case spaceships
    case towers
}

class SpaceShipType {
    
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
    
    static var types = [
        SpaceShipType(maxLevel: 5, targetPriorityType: 0,
            speed: 10, armor: 10, shieldPower: 10, shieldRecharge: 10,
            speedPerLevel: 1, armorPerLevel: 3, shieldPowerPerLevel: 3, shieldRechargePerLevel: 1),
        
        SpaceShipType(maxLevel: 10, targetPriorityType: 0,
            speed: 10, armor: 10, shieldPower: 10, shieldRecharge: 10,
            speedPerLevel: 3, armorPerLevel: 1, shieldPowerPerLevel: 1, shieldRechargePerLevel: 3),
        
        SpaceShipType(maxLevel: 10, targetPriorityType: 0,
            speed: 10, armor: 10, shieldPower: 10, shieldRecharge: 10,
            speedPerLevel: 2, armorPerLevel: 2, shieldPowerPerLevel: 2, shieldRechargePerLevel: 2)
    ]
}
