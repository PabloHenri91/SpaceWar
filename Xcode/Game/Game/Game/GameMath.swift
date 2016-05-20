//
//  GameMath.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/20/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameMath {
    
    static let healthPointsPerArmor = 40
    static let healthPointsPerLevel = 20
    
    static let shieldPointsPerPower = 30
    static let shieldPointsPerLevel = 10

    static func spaceshipMaxHealth(level level:Int, armor:Int) -> Int {
        let maxHealth = (level * healthPointsPerLevel) + (armor * healthPointsPerArmor)
        return maxHealth
    }
    
    static func spaceshipMaxShield(level level:Int, shieldPower:Int) -> Int {
        let maxShield = (level * shieldPointsPerLevel) + (shieldPower * shieldPointsPerPower)
        return maxShield
    }
    
    static func spaceshipShieldRechargeInterval(shieldRechargeInterval shieldRechargeInterval:Int) -> Int {
        return 100 - shieldRechargeInterval
    }
}
