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
    
    //Weapons
    static let weaponMinFireInterval:Double = 0.1 // seconds
    static let weaponMaxFireInterval:Double = 1.0 // seconds
    
    static func xpForNextLevel(level level:Int) -> Int {
        
        var resultado = 0
        var batalhas = 0
        var missoes = 0
        var pesquisa = 0
        
        for i in 1..<(level+2) {
            batalhas = batalhas + (i - 1)
            if (i>2) {
                missoes = missoes + (i - 2)
                
                if (i>3) {
                    pesquisa = pesquisa + (i - 3)
                    
                    
                }
            }
            
            resultado = ((batalhas * 100) * (i - 1)) + (missoes * 50) + (pesquisa * 200)
        }
        
        return resultado
        
    }
    
    
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
    

    // Spaceship
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
    
    static func spaceshipMaxVelocitySquared(speed speed:Int) -> CGFloat {
        let maxVelocity = (Float(speed)/100.0) * 300.0
        return CGFloat(maxVelocity * maxVelocity)
    }
    
    static func spaceshipSkinImageName(level level:Int, type:SpaceShipType) -> String {
        let level = Float(level)
        let maxLevel = Float(type.maxLevel)
        
        let skinIndex = ((level-1)/(maxLevel-1)) * Float(type.skins.count-1)
        
        return type.skins[Int(skinIndex)]
    }
    
    // Weapons
    static func weaponDemage(level level:Int, type:WeaponType) -> Int {
        return type.demage + ((level - 1) * type.demagePerLevel)
    }
    
    static func weaponRange(level level:Int, type:WeaponType) -> Int {
        return type.range + ((level - 1) * type.rangePerLevel)
    }
    
    static func weaponFireInterval(level level:Int, type:WeaponType) -> Double {
        let fireRate = Double(type.fireRate + ((level - 1) * type.fireRatePerLevel))
        return weaponMaxFireInterval - (fireRate/100 * (weaponMaxFireInterval - weaponMinFireInterval))
    }
    
    static func weaponReloadTime(level level:Int, type:WeaponType) -> Double {
        return type.reloadTime + ((Double(level) - 1) * type.reloadTimePerLevel)
    }
    
    static func weaponMagazineSize(level level:Int, type:WeaponType) -> Int {
        return type.magazineSize + ((level - 1) * type.magazineSizePerLevel)
    }
    
    // Mothership
    static let mothershipHealthPointsPerLevel = 8
    
    static func mothershipMaxHealth(level level:Int) -> Int {
        let maxHealth = 10 + ((level - 1) * mothershipHealthPointsPerLevel)
        return maxHealth
    }
    
}
