//
//  GameMath.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/20/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameMath {
    
    static let healthPointsPerArmor = 4
    static let healthPointsPerLevel = 2
    
    static let shieldPointsPerPower = 3
    static let shieldPointsPerLevel = 1
    
    static func spaceshipSpeedAtribute(level level:Int, type:SpaceShipType) -> Int {
        return type.speedBonus + ((level - 1) * type.speedBonusPerLevel)
    }
    
    static func spaceshipArmor(level level:Int, type:SpaceShipType) -> Int {
        return type.armorBonus + ((level - 1) * type.armorBonusPerLevel)
    }
    
    static func spaceshipShieldPower(level level:Int, type:SpaceShipType) -> Int {
        return type.shieldPowerBonus + ((level - 1) * type.shieldPowerBonusPerLevel)
    }
    
    static func spaceshipShieldRecharge(level level:Int, type:SpaceShipType) -> Int {
        return type.shieldRechargeBonus + ((level - 1) * type.shieldRechargeBonusPerLevel)
    }
    

    static func spaceshipMaxHealth(level level:Int, armor:Int) -> Int {
        let maxHealth = 10 + (((level - 1) * healthPointsPerLevel) + ((armor - 10) * healthPointsPerArmor))
        return maxHealth
    }
    
    static func spaceshipMaxShield(level level:Int, shieldPower:Int) -> Int {
        let maxShield = 1 + (((level - 1) * shieldPointsPerLevel) + ((shieldPower - 10) * shieldPointsPerPower))
        return maxShield
    }
    
    static func spaceshipShieldRechargeInterval(shieldRechargeInterval shieldRechargeInterval:Int) -> Int {
        return 100 - shieldRechargeInterval
    }
}
