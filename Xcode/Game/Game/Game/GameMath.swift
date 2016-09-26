//
//  GameMath.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/20/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameMath {
    
    static func finishDate(timeLeft: Int) -> NSDate {
        return NSDate(timeInterval: NSTimeInterval(timeLeft), sinceDate: NSDate())
    }
    
    static func timeLeftPositional(startDate: NSDate, duration: Int) -> Int {
        let date = NSDate(timeInterval: NSTimeInterval(duration), sinceDate: startDate)
        return Int(date.timeIntervalSinceNow)
    }
    static func timeLeft(startDate: NSDate, duration: Int) -> Int {
        let date = NSDate(timeInterval: NSTimeInterval(duration), sinceDate: startDate)
        return Int(date.timeIntervalSinceNow)
    }
    
    static func timeLeftFormattedPositional(timeLeft: Int) -> String {
        return GameMath.timeLeftDateComponentsFormatterPositional.stringFromDate(NSDate(), toDate: GameMath.finishDate(timeLeft))!
    }
    
    static func timeLeftFormattedAbbreviated(timeLeft: Int) -> String {
        return GameMath.timeLeftDateComponentsFormatterAbbreviated.stringFromDate(NSDate(), toDate: GameMath.finishDate(timeLeft))!
    }
    
    //MARK: Boosts
    static func applyXPBoosts(xp: Int) -> Int {
        
        Boost.reloadBoosts()//TODO: remover daqui
        
        var calculatedXP = xp
        
        for boost in Boost.activeBoosts {
            if boost.isActive() {
                calculatedXP = calculatedXP * boost.type.xpMultiplier
            }
        }
        
        return calculatedXP
    }
    
    static func xpForNextLevel(level level:Int) -> Int {
        return ((100 * level) * level)
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

    static func spaceshipMaxVelocitySquared(speed speed:Int) -> CGFloat {
        let maxVelocity =  CGFloat(speed) * 4
        return CGFloat(maxVelocity * maxVelocity)
    }
    
    static func spaceshipBotSpaceshipLevel() -> Int {
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        var levelSum = 0
        var spaceshipDataCount = 0
        for item in playerData.motherShip.spaceships {
            if let spaceshipData = item as? SpaceshipData {
                levelSum = levelSum + spaceshipData.level.integerValue
                spaceshipDataCount = spaceshipDataCount + 1
            }
        }
        
        let botSpaceshipLevel = (playerData.botLevel.integerValue + (levelSum/spaceshipDataCount))/2
        
        return botSpaceshipLevel
    }
    
    static func spaceshipUpgradeCost(level:Int, type:SpaceshipType) -> Int {
        return MemoryCard.sharedInstance.playerData.botLevel.integerValue
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
        }
    }
    
    //MARK: Weapons
    static let weaponMinFireInterval:Double = 0.1 // seconds
    static let weaponMaxFireInterval:Double = 1.0 // seconds
    static let weaponMaxRangeInPoints:CGFloat = 300
    static let weaponMinRangeInPoints:CGFloat = 100
        
    // Weapons
    static func weaponDamage(level level:Int, type:WeaponType) -> Int {
        return Int(Double(type.damage) * pow(1.1, Double(level - 1)))
    }
    
    //MARK: Mothership
    static let mothershipHealthPointsPerLevel = 8
    
    static func xpForNextLevel(level:Int) -> Int {
        return ((100 * level) * level)
    }
    
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
    //MARK: Battle
    //Battle
    static func battleXP(mothership mothership:Mothership, enemyMothership:Mothership) -> Int {
        
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
    
    //MARK: Researches
    
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
    
    //MARK: Battery
    static let batteryMaxCharge = 4
    static let batteryChargeInterval = 6.0 * 60.0
    static let batteryBoostInterval = 60.0 * 60.0 * 24.0
    
    static func batteryNextChargeTimeLeft(beginChargeDate: NSDate) -> Int {
        let date = NSDate(timeInterval: batteryChargeInterval, sinceDate: beginChargeDate)
        return Int(date.timeIntervalSinceNow)
    }
    
    static func batteryBoostTimeLeft(beginChargeDate: NSDate) -> Int {
        let date = NSDate(timeInterval: batteryBoostInterval, sinceDate: beginChargeDate)
        return Int(date.timeIntervalSinceNow)
    }
    
    
    static let timeLeftDateComponentsFormatterPositional: NSDateComponentsFormatter = {
        
        let dateComponentsFormatter = NSDateComponentsFormatter()
        
        dateComponentsFormatter.unitsStyle = .Positional
        dateComponentsFormatter.allowedUnits = NSCalendarUnit(rawValue: NSCalendarUnit.Second.rawValue | NSCalendarUnit.Minute.rawValue | NSCalendarUnit.Hour.rawValue)
        
        return dateComponentsFormatter
    }()
    
    static let timeLeftDateComponentsFormatterAbbreviated: NSDateComponentsFormatter = {
        
        let dateComponentsFormatter = NSDateComponentsFormatter()
        
        dateComponentsFormatter.unitsStyle = .Abbreviated
        dateComponentsFormatter.allowedUnits = NSCalendarUnit(rawValue: NSCalendarUnit.Second.rawValue | NSCalendarUnit.Minute.rawValue | NSCalendarUnit.Hour.rawValue)
        
        return dateComponentsFormatter
    }()
}
