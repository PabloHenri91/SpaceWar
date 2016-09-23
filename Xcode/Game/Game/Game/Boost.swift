//
//  Boost.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 9/5/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Boost {
    
    static var activeBoosts = [Boost]()
    
    
    var boostData: BoostData!
    var type:BoostType!
    
    static func reloadBoosts() {
        
        Boost.activeBoosts = [Boost]()
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        var inactiveBoostData = [BoostData]()
        
        for item in playerData.boosts {
            if let boostData = item as? BoostData {
                let boost = Boost(boostData: boostData)
                
                if boost.isActive() {
                    Boost.activeBoosts.append(boost)
                } else {
                    inactiveBoostData.append(boostData)
                }
            }
        }
        
        for boostData in inactiveBoostData {
            playerData.removeBoostData(boostData)
        }
        
    }
    
    init(boostData: BoostData) {
        self.boostData = boostData
        
        self.load(boostData.type.intValue)
    }
    
    func load(_ type: Int) {
        self.type = Boost.types[type]
    }
    
    func isActive() -> Bool {
        let timeLeft = GameMath.timeLeft(startDate: self.boostData.lastCharge, duration: self.type.duration)
        
        print("Boost timeLeft: " + GameMath.timeLeftFormattedAbbreviated(timeLeft: timeLeft))
        
        return timeLeft > 0
    }
    
    static var types = [
        BoostType(duration: 60 * 60 * 24 * 1, xpMultiplier: 2),
        BoostType(duration: 60 * 60 * 24 * 3, xpMultiplier: 2),
        BoostType(duration: 60 * 60 * 24 * 7, xpMultiplier: 2)
    ]
}

class BoostType {
    
    var duration:Int = -1
    
    var xpMultiplier = 1
    
    init(duration: Int, xpMultiplier: Int) {
        self.duration = duration
        self.xpMultiplier = xpMultiplier
    }
}

