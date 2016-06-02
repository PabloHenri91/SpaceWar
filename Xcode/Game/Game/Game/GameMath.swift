//
//  GameMath.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/20/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameMath {
    
    //Spaceships
    static let spaceshipHealthPointsPerArmor = 4
    static let spaceshipHealthPointsPerLevel = 2
    
    static let spaceshipShieldPointsPerPower = 3
    static let spaceshipShieldPointsPerLevel = 1
    
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
        let maxHealth = 10 + (((level - 1) * spaceshipHealthPointsPerLevel) + ((armor - 10) * spaceshipHealthPointsPerArmor))
        return maxHealth
    }
    
    static func spaceshipMaxShield(level level:Int, shieldPower:Int) -> Int {
        let maxShield = 1 + (((level - 1) * spaceshipShieldPointsPerLevel) + ((shieldPower - 10) * spaceshipShieldPointsPerPower))
        return maxShield
    }
    
    static func spaceshipShieldRechargeInterval(shieldRechargeInterval shieldRechargeInterval:Int) -> Int {
        return 100 - shieldRechargeInterval
    }
    
    // Weapons
    static func weaponDemage(level level:Int, type:WeaponType) -> Int {
        return type.demage + ((level - 1) * type.demagePerLevel)
    }
    
    static func weaponRange(level level:Int, type:WeaponType) -> Int {
        return type.range + ((level - 1) * type.rangePerLevel)
    }
    
    static func weaponReloadTime(level level:Int, type:WeaponType) -> Double {
        return type.reloadTime + ((Double(level) - 1) * type.reloadTimePerLevel)
    }
    
    static func weaponAmmoPerMag(level level:Int, type:WeaponType) -> Int {
        return type.ammoPerMag + ((level - 1) * type.ammoPerMagPerLevel)
    }
    
    // Mothership
    static let mothershipHealthPointsPerLevel = 8
    
    static func mothershipMaxHealth(level level:Int) -> Int {
        let maxHealth = 10 + ((level - 1) * mothershipHealthPointsPerLevel)
        return maxHealth
    }
    
}
