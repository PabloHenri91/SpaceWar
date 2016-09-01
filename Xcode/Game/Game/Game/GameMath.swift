//
//  GameMath.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/20/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameMath {
    
    
    //Weapons
    static let weaponMinFireInterval:Double = 0.1 // seconds
    static let weaponMaxFireInterval:Double = 1.0 // seconds
    static let weaponMaxRangeInPoints:CGFloat = 300
    static let weaponMinRangeInPoints:CGFloat = 100
    
    static func xpForNextLevel(level level:Int) -> Int {
        
        var resultado = 0
        var batalhas = 0
        var missoes = 0
        
        for i in 1..<(level+2) {
            batalhas = batalhas + (i - 1)
            if i > 2 {
                missoes = missoes + (i - 2)

            }
            
            resultado = ((batalhas * 100) * (i - 1)) + (missoes * 50)
        }
        
        return resultado
        
    }
    
    
    // de 5 a 30, fixo pela nave
    static func spaceshipSpeedAtribute(level level:Int, type:SpaceshipType) -> Int {
        return type.speedBonus
    }
    
    // Pontos de HP, aumenta 10 por cento por level
    static func spaceshipMaxHealth(level level:Int, type:SpaceshipType) -> Int {
        return Int(Double(type.healthBonus * 10) * pow(1.1, Double(level - 1)))
    }
    
    // Pontos de escudo, aumenta 10 por cento por level
    static func spaceshipShieldPower(level level:Int, type:SpaceshipType) -> Int {
        return Int(Double(type.shieldPowerBonus) * pow(1.1, Double(level - 1)))
    }
    
    // Quantidade de pontos de escudo recarregado por segundo
    static func spaceshipShieldRecharge(level level:Int, type:SpaceshipType) -> Int {
        return Int(Double(type.shieldRechargeBonus) * pow(1.1, Double(level - 1)))
    }
    

    // SPACESHIP

    static func spaceshipMaxVelocitySquared(speed speed:Int) -> CGFloat {
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
        
        let playerData = MemoryCard.sharedInstance.playerData
        
        var resultado = 0
        var batalhas = 0
        var missoes = 0
        
        for i in 1..<(playerData.motherShip.level.integerValue) {
            batalhas = batalhas + (i - 1)
            if i > 2 {
                missoes = missoes + (i - 2)
            }
            resultado = resultado + ((batalhas * 100) * (i - 1)) + (missoes * 50)
        }
        
        var custo = 0
        var nivel = 1
        
        while custo < resultado {
            custo = custo + 4 * Int(100 * pow(1.3, Double(nivel)))
            nivel += 1
        }
        
        if playerData.botUpdateInterval.integerValue < 0 {
            nivel += abs(playerData.botUpdateInterval.integerValue)
        }
        
        return nivel
    }
    
    // Spaceship upgrade
    static func spaceshipUpgradeCost(level level:Int, type:SpaceshipType) -> Int {
        switch type.rarity {
        case .common:
            return Int(100 * pow(1.3, Double(level)))
        case .rare:
            return Int(200 * pow(1.3, Double(level)))
        case .epic:
            return Int(500 * pow(1.3, Double(level)))
        case .legendary:
            return Int(1000 * pow(1.3, Double(level)))
        default:
            #if DEBUG
                fatalError()
            #endif
            break
        }
    }
    
    
    static func spaceshipPrice(type:SpaceshipType) -> Int {
        switch type.rarity {
        case .common:
            return 1000
        case .rare:
            return 2000
        case .epic:
            return 5000
        case .legendary:
            return 10000 
        default:
            #if DEBUG
                fatalError()
            #endif
            break
        }
    }
    
    static func spaceshipFixTime(fromDate: NSDate) -> Int {
        
        let date = NSDate(timeInterval: NSTimeInterval(1800), sinceDate: fromDate)
        return Int(date.timeIntervalSinceNow)
        
    }
    
    static func timeFormated(time: Int) -> String {
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
    
    static func spaceshipUpgradeXPBonus(level level:Int, type:SpaceshipType) -> Int {
        switch type.rarity {
        case .common:
            return Int(10 * pow(1.1, Double(level)))
        case .rare:
            return Int(20 * pow(1.1, Double(level)))
        case .epic:
            return Int(50 * pow(1.1, Double(level)))
        case .legendary:
            return Int(100 * pow(1.1, Double(level)))
        default:
            #if DEBUG
                fatalError()
            #endif
            break
        }
    }
    
    // Weapons
    static func weaponDamage(level level:Int, type:WeaponType) -> Int {
        return Int(Double(type.damage) * pow(1.1, Double(level - 1)))
    }
    
//    static func weaponSkinImageName(level level:Int, type:WeaponType) -> String {
//        let level = Float(level)
//        let maxLevel = Float(type.maxLevel)
//        
//        let skinIndex = ((level-1)/(maxLevel-1)) * Float(type.skins.count-1)
//        
//        return type.skins[Int(skinIndex)]
//    }
    
    // Mothership
    static let mothershipHealthPointsPerLevel = 8
    
    static func mothershipMaxHealth(mothership:Mothership , enemyMothership: Mothership) -> Int {
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
    static func battleXP(mothership mothership:Mothership, enemyMothership:Mothership) -> Int {
        // win
        if mothership.health > 0 {
            if enemyMothership.level - mothership.level > 0 {
                let xp = mothership.level * 100 + ((enemyMothership.level - mothership.level) * (mothership.level * 10))
                return xp
            } else {
                let xp = mothership.level * 100
                return xp
            }
            
        } else {
            //loose
            if enemyMothership.level - mothership.level > 0 {
                let xp = mothership.level * 10 + ((enemyMothership.level - mothership.level) * (mothership.level * 10))
                return xp
            } else {
                let xp = mothership.level * 10
                return xp
            }
        }
    }
    
    static func battlePoints(mothership mothership:Mothership, enemyMothership:Mothership) -> Int {

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
    static func finishDate(timeLeft timeLeft: Int) -> NSDate {
       return NSDate(timeInterval: NSTimeInterval(timeLeft), sinceDate: NSDate())
    }
    
    static func timeLeft(startDate startDate: NSDate, duration: Int) -> Int {
        let date = NSDate(timeInterval: NSTimeInterval(duration), sinceDate: startDate)
        return Int(date.timeIntervalSinceNow)
    }
    
    //Battery
    static let batteryMaxCharge = 4
    #if DEBUG
    static let batteryChargeInterval = 2.0
    #else
    static let batteryChargeInterval = 6.0 * 60.0
    #endif
    
    static func batteryNextChargeTimeLeft(beginChargeDate: NSDate) -> Int {
        let date = NSDate(timeInterval: batteryChargeInterval, sinceDate: beginChargeDate)
        return Int(date.timeIntervalSinceNow)
    }
    
}
