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
    static let weaponMaxRangeInPoints:CGFloat = 300
    static let weaponMinRangeInPoints:CGFloat = 100
    
    
    
    
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
    
    
    // de 5 a 30, fixo pela nave
    static func spaceshipSpeedAtribute(level level:Int, type:SpaceShipType) -> Int {
        return type.speedBonus
    }
    
    // Pontos de HP, aumenta 10 por cento por level
    static func spaceshipArmor(level level:Int, type:SpaceShipType) -> Int {
        return Int(Double(type.armorBonus) * pow(1.1, Double(level - 1)))
    }
    
    // Pontos de escudo, aumenta 10 por cento por level
    static func spaceshipShieldPower(level level:Int, type:SpaceShipType) -> Int {
        return Int(Double(type.shieldPowerBonus) * pow(1.1, Double(level - 1)))
    }
    
    // Quantidade de pontos de escudo recarregado por segundo
    static func spaceshipShieldRecharge(level level:Int, type:SpaceShipType) -> Int {
        return Int(Double(type.shieldRechargeBonus) * pow(1.1, Double(level - 1)))
    }
    

    // SPACESHIP
    
    // calculo desnecessario, ja ha uma variacao de hp por level baseado no armor, se necessario apenas normalizar o numero aqui
    static func spaceshipMaxHealth(level level:Int, armor:Int) -> Int {
        //let maxHealth = 10 + (((level - 1) * spaceshipHealthPointsPerLevel) + ((armor - 10) * spaceshipHealthPointsPerArmor))
        return armor
    }
    
    // calculo desnecessario, ja ha uma variacao de escudo por level baseado no shield, se necessario apenas normalizar o numero aqui
    static func spaceshipMaxShield(level level:Int, shieldPower:Int) -> Int {
        //let maxShield = 1 + (((level - 1) * spaceshipShieldPointsPerLevel) + ((shieldPower - 10) * spaceshipShieldPointsPerPower))
        return shieldPower
    }
    
    // calculo desnecessario, ja ha uma variacao de pontos recarregados por segundo baseado no shield recharge , se necessario apenas normalizar o numero aqui
    static func spaceshipShieldRechargeInterval(shieldRechargeInterval shieldRechargeInterval:Int) -> Int {
        return shieldRechargeInterval
    }
    
    
    
    static func spaceshipMaxVelocitySquared(speed speed:Int) -> CGFloat {
        let maxVelocity =  CGFloat(speed) * 4
        return CGFloat(maxVelocity * maxVelocity)
    }
    
    static func spaceshipSkinImageName(level level:Int, type:SpaceShipType) -> String {
        let level = Float(level)
        let maxLevel = Float(type.maxLevel)
        
        let skinIndex = ((level-1)/(maxLevel-1)) * Float(type.skins.count-1)
        
        return type.skins[Int(skinIndex)]
    }
    
    // Spaceship upgrade
    static func spaceshipUpgradeCost(level level:Int, type:SpaceShipType) -> Int {
        switch type.rarity! {
        case .commom:
            return Int(100 * pow(1.1, Double(level)))
        case .rare:
            return Int(200 * pow(1.1, Double(level)))
        case .epic:
            return Int(500 * pow(1.1, Double(level)))
        case .legendary:
            return Int(1000 * pow(1.1, Double(level)))
        default:
            break
        }
    }
    
    static func spaceshipUpgradeXP(level level:Int, type:SpaceShipType) -> Int {
        switch type.rarity! {
        case .commom:
            return Int(50 * pow(1.1, Double(level)))
        case .rare:
            return Int(100 * pow(1.1, Double(level)))
        case .epic:
            return Int(200 * pow(1.1, Double(level)))
        case .legendary:
            return Int(400 * pow(1.1, Double(level)))
        default:
            break
        }
    }
    
    // Weapons
    static func weaponDemage(level level:Int, type:WeaponType) -> Int {
        return type.demage + ((level - 1) * type.demagePerLevel)
    }
    
    static func weaponRange(level level:Int, type:WeaponType) -> Int {
        return type.range + ((level - 1) * type.rangePerLevel)
    }
    
    static func weaponRangeInPoints(range range:Int) -> CGFloat {
        return weaponMinRangeInPoints + ((CGFloat(range)/100) * (weaponMaxRangeInPoints - weaponMinRangeInPoints))
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
    
    //Battle
    static func battleXP(mothership mothership:Mothership, enemyMothership:Mothership) -> Int {
        if mothership.health > 0 {
            let xp = mothership.level * 100 + ((enemyMothership.level - mothership.level) * (mothership.level * 10))
            return xp
        }
        let xp = mothership.level * 10 + ((enemyMothership.level - mothership.level) * (mothership.level * 10))
        return xp
    }
    
    static func battlePoints(mothership mothership:Mothership, enemyMothership:Mothership) -> Int {
        if mothership.health > 0 {
            let points = mothership.level * 200 + ((enemyMothership.level - mothership.level) * (mothership.level * 10))
            return points
        }
        return 0
    }
    
}
