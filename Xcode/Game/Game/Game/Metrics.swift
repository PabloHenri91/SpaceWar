//
//  Metrics.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 20/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import GameAnalytics

class Metrics {
    
    static var battlesPlayed = 0
    
    static func killerSpaceship(spaceship: String) {
        GameAnalytics.addDesignEventWithEventId("Killer:" + spaceship)
    }
    
    static func win() {
        let level = MemoryCard.sharedInstance.playerData.motherShip.level
        GameAnalytics.addDesignEventWithEventId("BattleWin:" + level.description)
    }
    
    static func loose() {
        let level = MemoryCard.sharedInstance.playerData.motherShip.level
        GameAnalytics.addDesignEventWithEventId("BattleLoose:" + level.description)
    }

    static func openTheGame() {
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = NSTimeZone.localTimeZone()
        let hour = formatter.stringFromDate(date)
        
        GameAnalytics.addDesignEventWithEventId("OpenTheGameAtHour:" + hour)
    }
    
    static func battlesPlayedPerSession() {
        GameAnalytics.addDesignEventWithEventId("BattlesPlayed" , value: Metrics.battlesPlayed)
    }
    
    static func battleTime(time:NSTimeInterval) {
        let level = MemoryCard.sharedInstance.playerData.motherShip.level
        let totalTime = NSTimeInterval(Int(time))
    
        GameAnalytics.addDesignEventWithEventId("BattleTime:" + level.description , value: totalTime)
    }
    
    static func levelUp() {
        let level = MemoryCard.sharedInstance.playerData.motherShip.level
        let startDate = MemoryCard.sharedInstance.playerData.startDate
        
        let time = NSTimeInterval(Int(startDate!.timeIntervalSinceNow * -1))
        
        GameAnalytics.addDesignEventWithEventId("LevelUp:" + level.description , value: time)
    }
  
}