//
//  GameMath.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/20/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameMath {
    
    
    //Boosts
    static func applyXPBoosts(_ xp: Int) -> Int {
        
        Boost.reloadBoosts()//TODO: remover daqui
        
        var calculatedXP = xp
        
        for boost in Boost.activeBoosts {
            if boost.isActive() {
                calculatedXP = calculatedXP * boost.type.xpMultiplier
            }
        }
        
        return calculatedXP
    }
    
    //Weapons
    static let weaponMinFireInterval:Double = 0.1 // seconds
    static let weaponMaxFireInterval:Double = 1.0 // seconds
    static let weaponMaxRangeInPoints:CGFloat = 300
    static let weaponMinRangeInPoints:CGFloat = 100
    
    static func xpForNextLevel(level:Int) -> Int {
        
        return ((100 * level) * level)
        
    }
    
    
    // de 5 a 30, fixo pela nave
    static func spaceshipSpeedAtribute(level:Int, type:SpaceshipType) -> Int {
        return type.speedBonus
    }
    
    // Pontos de HP, aumenta 10 por cento por level
    static func spaceshipMaxHealth(level:Int, type:SpaceshipType) -> Int {
        return Int(Double(type.healthBonus * 10) * pow(1.1, Double(level - 1)))
    }
    
    // Pontos de escudo, aumenta 10 por cento por level
    static func spaceshipShieldPower(level:Int, type:SpaceshipType) -> Int {
        return Int(Double(type.shieldPowerBonus) * pow(1.1, Double(level - 1)))
    }
    
    // Quantidade de pontos de escudo recarregado por segundo
    static func spaceshipShieldRecharge(level:Int, type:SpaceshipType) -> Int {
        return Int(Double(type.shieldRechargeBonus) * pow(1.1, Double(level - 1)))
    }
    

    // SPACESHIP

    static func spaceshipMaxVelocitySquared(speed:Int) -> CGFloat {
        let maxVelocity =  CGFloat(speed) * 4
        return CGFloat(maxVelocity * maxVelocity)
    }
    
//    static func spaceshipSkinImageName(level level:Int, type:SpaceshipType) -> String {
//        let level = Float(level)
//        let maxLevel = Float(type.maxLevel)
//        
//        let skinIndex = ((level-1)/(maxLevel-1)) * Float(type.skins.count-1)
//        
//        return type.skins[Int(skinIndex)]
//    }
    
    static func spaceshipBotSpaceshipLevel() -> Int {
        return MemoryCard.sharedInstance.playerData!.botLevel.intValue
    }
    
    // Spaceship upgrade
    static func spaceshipUpgradeCost(level:Int, type:SpaceshipType) -> Int {
        switch type.rarity {
        case .common:
            return Int(100 * pow(1.3, Double(level)))
        case .rare:
            return Int(200 * pow(1.3, Double(level)))
        case .epic:
            return Int(500 * pow(1.3, Double(level)))
        case .legendary:
            return Int(1000 * pow(1.3, Double(level)))
        }
    }
    
    
    static func spaceshipPrice(_ type:SpaceshipType) -> Int {
        switch type.rarity {
        case .common:
            return 1000
        case .rare:
            return 2000
        case .epic:
            return 5000
        case .legendary:
            return 10000
        }
    }
    
    static func spaceshipFixTime(_ fromDate: Date) -> Int {
        
        let date = Date(timeInterval: TimeInterval(1800), since: fromDate)
        return Int(date.timeIntervalSinceNow)
        
    }
    
    static func timeFormated(_ time: Int) -> String {
        if time > 0 {
            if time < 60 {
                return (time.description + "s")
            } else if time < 3600 {
                let minutes = Int(time / 60)
                let seconds = time % 60
                if seconds > 0 {
                    return (minutes.description + "m " + seconds.description + "s" )
                } else {
                    return (minutes.description + "m ")
                }
                
            } else {
                let hours = Int(time/3600)
                let minutes = Int((time % 3600) / 60)
                if minutes > 0 {
                    return (hours.description + "h " + minutes.description + "m" )
                } else {
                    return (hours.description + "h ")
                }
            }
        } else {
            return "0seconds"
        }
    }
    
    // Weapons
    static func weaponDamage(level:Int, type:WeaponType) -> Int {
        return Int(Double(type.damage) * pow(1.1, Double(level - 1)))
    }
    
    // Mothership
    static let mothershipHealthPointsPerLevel = 8
    
    static func mothershipMaxHealth(_ mothership:Mothership , enemyMothership: Mothership) -> Int {
        var dps = 0
        for spaceship in mothership.spaceships {
            dps = dps + Int(Double((spaceship.weapon?.damage)!) / (spaceship.weapon?.fireInterval)!)
        }
        
        for spaceship in enemyMothership.spaceships {
            dps = dps + Int(Double((spaceship.weapon?.damage)!) / (spaceship.weapon?.fireInterval)!)
        }
        
        let maxHealth = Int((dps / 2) * 5)
        return maxHealth
    }
    
    //Battle
    static func battleXP(mothership:Mothership, enemyMothership:Mothership) -> Int {
        
        var xp = 0
        
        // win
        if mothership.health > 0 {
            if enemyMothership.level - mothership.level > 0 {
                xp = mothership.level * 100 + ((enemyMothership.level - mothership.level) * (mothership.level * 10))
            } else {
                xp = mothership.level * 100
            }
            
        } else {
            //loose
            if enemyMothership.level - mothership.level > 0 {
                xp = mothership.level * 10 + ((enemyMothership.level - mothership.level) * (mothership.level * 10))
            } else {
                xp = mothership.level * 10
            }
        }
        
        xp = GameMath.applyXPBoosts(xp)
        
        return xp
    }
    
    static func battlePoints(mothership:Mothership, enemyMothership:Mothership) -> Int {

        // win
        if mothership.health > 0 {
            if enemyMothership.level - mothership.level > 0 {
                let points = mothership.level * 200 + ((enemyMothership.level - mothership.level) * (mothership.level * 20))
                return points
            } else {
                let points = mothership.level * 200
                return points
            }
            
        } else {
            //loose
            if enemyMothership.level - mothership.level > 0 {
                let points = mothership.level * 20 + ((enemyMothership.level - mothership.level) * (mothership.level * 2))
                return points
            } else {
                let points = mothership.level * 20
                return points
            }
        }
    }
    
    static func getRandomResearch() {
        let winSpaceship = Int(arc4random_uniform(101) + 1)
        
        if (winSpaceship > 90) {
            
            let diceRoll = Int(arc4random_uniform(101) + 1)
            if (diceRoll <= 85) {
                //print("common")
            } else if (diceRoll <= 95) {
                //print("rare")
            } else if (diceRoll <= 99) {
                //print("epic")
            } else {
                //print("legendary")
            }
        }
    }
    
    //Mission Spaceship        
    static func finishDate(timeLeft: Int) -> Date {
       return Date(timeInterval: TimeInterval(timeLeft), since: Date())
    }
    
    static func timeLeft(startDate: Date, duration: Int) -> Int {
        let date = Date(timeInterval: TimeInterval(duration), since: startDate)
        return Int(date.timeIntervalSinceNow)
    }
    
    //Battery
    static let batteryMaxCharge = 4
    #if DEBUG
    static let batteryChargeInterval = 6.0 * 6.0
    #else
    static let batteryChargeInterval = 6.0 * 60.0
    #endif
    
    static let batteryBoostInterval = 60.0 * 60.0 * 24.0
    
    static func batteryNextChargeTimeLeft(_ beginChargeDate: Date) -> Int {
        let date = Date(timeInterval: batteryChargeInterval, since: beginChargeDate)
        return Int(date.timeIntervalSinceNow)
    }
    
    static func batteryBoostTimeLeft(_ beginChargeDate: Date) -> Int {
        let date = Date(timeInterval: batteryBoostInterval, since: beginChargeDate)
        return Int(date.timeIntervalSinceNow)
    }
    
}
